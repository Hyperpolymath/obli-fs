# ObliFS: FAQ and Objections

Anticipated questions and pushback, with honest responses.

---

## Skeptical Questions

### "This sounds like you're anthropomorphising files. Files are just bytes."

Yes, files are bytes at the storage level. ObliFS doesn't change that. What it adds is a *coordination layer* where stored entities have typed interfaces. The "agency" isn't consciousness—it's the same kind of agency an Erlang process has: it receives messages, processes them according to its type, and emits responses. The bytes are still bytes; the type system constrains what operations make sense.

**Short answer**: "Not anthropomorphising—typing. Like how a database record isn't 'alive' but still has a schema that constrains operations."

---

### "What's the performance overhead of message-passing vs. direct file access?"

Real, but manageable. Every abstraction has costs. The question is whether the benefits (type safety, auditability, capability security) outweigh the costs for your use case.

For bulk data transfer where security and audit don't matter, use raw file I/O. For operations where you need guarantees, the message-passing overhead is the price of those guarantees.

Mitigation strategies:
- Batching (multiple operations in one message)
- Zero-copy forwarding through channels where possible
- Locality-aware routing (prefer local entities)
- Bypassing the typed layer for trusted, high-throughput paths (with explicit opt-out)

**Short answer**: "Overhead exists. It's the cost of the guarantees. Not appropriate for all workloads—appropriate for workloads where the guarantees matter."

---

### "This is just microservices for filesystems. We've seen how that goes."

Microservices fail when:
1. Service boundaries are wrong (too fine-grained)
2. Communication protocols are untyped (HTTP/JSON with no contracts)
3. Failure handling is ad-hoc
4. There's no coordination model

ObliFS addresses these:
1. Entity types are semantically meaningful (data, index, backup, audit), not arbitrary decomposition
2. All communication is typed and protocol-verified
3. Workflows define explicit error handling and rollback
4. The consent model provides coordination

**Short answer**: "Microservices with typed contracts, explicit coordination, and capability security. The problems you've seen come from untyped, ad-hoc decomposition."

---

### "Why not just use a database?"

Databases solve a different problem: structured query over tabular data with ACID guarantees. ObliFS solves coordination over heterogeneous stored entities with capability security and emergent behaviours.

If your use case is "store and query structured data," use a database. If your use case is "coordinate data, backups, indices, and audit logs with type-safe operations and consent-based access," ObliFS is relevant.

They can coexist: a database could be one kind of Actor in an ObliFS system.

**Short answer**: "Different layer, different problem. Databases handle query; ObliFS handles coordination and governance."

---

### "How does this interact with existing POSIX applications?"

Through adapters. ObliFS can present:
- A FUSE filesystem for POSIX compatibility (files appear as regular files, operations go through the typed layer)
- A native API for applications that want full typed access
- Object store interfaces (S3-compatible) for cloud-native applications

Legacy applications see files. New applications see typed actors. Both work.

**Short answer**: "Adapters. POSIX apps see files; native apps see typed actors."

---

### "This requires rewriting everything to work."

No. The adoption path is:
1. **Layer**: ObliFS sits above existing storage, not replacing it
2. **Opt-in**: Applications choose whether to use the typed API
3. **Gradual**: Start with one use case (e.g., audit-critical data), expand from there
4. **Compatible**: POSIX adapters mean legacy apps keep working

**Short answer**: "It's a layer, not a replacement. Adopt incrementally."

---

### "What about existing data? Do I have to migrate everything?"

Migration is optional and gradual:
- Existing files can be "wrapped" as untyped Actors with minimal capabilities
- Over time, you can add type information to files that benefit from it
- The Archive entity type handles provenance for both native and migrated data

**Short answer**: "Wrap existing data, add types incrementally as beneficial."

---

## Technical Questions

### "How is garbage collection handled?"

Entities are referenced by content-addressable hashes. An entity is collectible when:
1. No other entity holds a reference to it
2. No active channel terminates at it
3. The Archive has recorded its deprecation

Collection requires proving non-reference, which the Archive can provide. This is similar to how Git's garbage collection works: objects are retained while reachable, collected when provably unreachable.

---

### "What happens when the network partitions in a distributed deployment?"

Entities on each side of the partition continue operating locally. Messages to unreachable entities queue or timeout (configurable per protocol). When the partition heals:
- Workflow entities handle reconciliation
- Archive entities merge histories
- Conflict resolution is type-specific (some types have merge semantics, others require manual resolution)

This is CAP-aware: you choose consistency vs. availability per entity type, not system-wide.

---

### "How do type definitions evolve over time?"

Through explicit migration:
1. New type versions are defined as Manifests
2. Migration Workflows transform entities from old types to new types
3. Archive preserves history across migrations
4. Protocol versioning allows old and new types to coexist during transition

Breaking changes require migration workflows. Non-breaking changes (adding optional capabilities) can be handled through protocol negotiation.

---

### "Can I trust the type guarantees if the underlying storage is compromised?"

Type guarantees are enforced by the ObliFS runtime, not the storage layer. If the storage layer is compromised (bits flipped, data corrupted), ObliFS detects this through:
- Content-addressable hashes (corruption is detectable)
- Archive checksums (provenance chain is verifiable)
- Actor state validation against manifest schemas

ObliFS can't prevent storage corruption, but it can detect it and trigger recovery (via Workflow) from Archive or replicas.

---

## Philosophical Questions

### "Isn't this over-engineering for most use cases?"

Yes. Most file I/O doesn't need typed actors and capability security. For a simple application reading config files, this is overkill.

ObliFS is for use cases where:
- Security must be built-in, not bolted-on
- Audit trails are mandatory
- Coordination across services is complex
- Data provenance matters over long time scales

If those don't apply, use regular files.

---

### "Why build a new thing instead of improving existing systems?"

Existing filesystems are built on the assumption that files are passive. Adding typed actors, capability security, and emergent coordination would require fundamental changes that would break backward compatibility.

ObliFS works *with* existing filesystems as a layer above, providing new properties without requiring changes to mature, trusted storage infrastructure.

---

### "Is this actually new, or just a combination of existing ideas?"

It's a combination. The individual concepts exist:
- Actor model (Hewitt, 1973)
- Capability security (Dennis & Van Horn, 1966)
- Content-addressable storage (various)
- Type-directed compilation (many PL systems)

What's (potentially) new is applying all of these *systematically to the storage layer*, with types derived from a formal language (Oblíbený) that guarantees bounded behaviour.

---

## Red Flags / When NOT to Use ObliFS

- **High-throughput bulk data**: Raw I/O will always be faster
- **Simple applications**: If you don't need the guarantees, don't pay the complexity cost
- **Hostile runtime environments**: If you can't trust the ObliFS runtime itself, the type guarantees don't help
- **Write-heavy workloads with no audit need**: The Archive overhead isn't justified
- **Legacy systems that can't adopt gradually**: If you need 100% compatibility with zero changes, adapters add overhead

Be honest about when this is the wrong tool.
