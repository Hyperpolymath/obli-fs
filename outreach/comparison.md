# ObliFS: Comparison with Existing Systems

How ObliFS relates to existing storage and coordination systems.

---

## Feature Comparison Matrix

| Feature | Traditional FS | Object Store | Actor System | ObliFS |
|---------|---------------|--------------|--------------|--------|
| **Storage** | Yes | Yes | No (memory) | Yes (via adapters) |
| **Typed entities** | No | Metadata only | Yes | Yes (enforced) |
| **Message-passing** | No | No | Yes | Yes |
| **Capability security** | Bolt-on (ACLs) | IAM policies | Varies | Built-in |
| **Audit by construction** | No | Varies | No | Yes |
| **Reversible operations** | No | Versioning | No | Yes |
| **Termination guarantees** | N/A | N/A | No | Yes |
| **Consent model** | No | No | No | Yes |

---

## Detailed Comparisons

### vs. Traditional Filesystems (ext4, ZFS, NTFS, APFS)

**What they do well:**
- Efficient block management
- Journaling/consistency guarantees
- Mature, battle-tested
- Universal compatibility

**What they lack:**
- Files are passive blobs — no typed behaviour
- Access control is identity-based, not capability-based
- No built-in audit trail
- No coordination primitives
- No semantic awareness of content

**ObliFS relationship:**
- ObliFS sits **above** traditional filesystems
- Uses them as storage backends via adapters
- Adds typed actor semantics without replacing proven storage

---

### vs. Object Stores (S3, GCS, Azure Blob)

**What they do well:**
- Scalable storage
- Rich metadata
- Versioning and lifecycle policies
- IAM-based access control

**What they lack:**
- Objects are still passive data
- No inter-object coordination
- Access control is policy-based, not capability-based
- No typed operations beyond CRUD
- Audit trails are separate (CloudTrail, etc.)

**ObliFS relationship:**
- Object stores can be ObliFS storage backends
- ObliFS adds typed actor semantics on top
- Capabilities provide finer-grained access than IAM

---

### vs. Actor Systems (Erlang/OTP, Akka, Orleans)

**What they do well:**
- Typed message-passing
- Fault tolerance (supervisors, restarts)
- Location transparency
- Concurrency model

**What they lack:**
- State is in-memory, not persistent
- No capability-based security (usually)
- No built-in audit by construction
- No termination guarantees (Turing-complete)

**ObliFS relationship:**
- Closest conceptual match
- ObliFS adapts actor model to persistent storage
- Adds capability security and termination guarantees
- Actors are backed by durable storage, not just RAM

---

### vs. Capability Systems (seL4, Capsicum, CloudABI)

**What they do well:**
- Principled capability-based security
- Least privilege by construction
- Unforgeable tokens

**What they lack:**
- Operating at OS/process level, not storage level
- No typed storage entities
- No audit-by-construction
- No coordination protocols built-in

**ObliFS relationship:**
- ObliFS applies capability principles to storage
- Every channel requires capability presentation
- Consent model extends beyond simple capabilities to mutual agreement

---

### vs. Distributed Databases (CockroachDB, Spanner, FoundationDB)

**What they do well:**
- ACID transactions across nodes
- SQL or structured queries
- Strong consistency options
- Horizontal scaling

**What they lack:**
- Records are passive data
- No inter-record coordination
- No capability-based access (row-level security is policy-based)
- No reversibility beyond transaction rollback

**ObliFS relationship:**
- Different layer — databases query structured data, ObliFS coordinates entities
- A database could be one kind of Actor in ObliFS
- ObliFS provides coordination that databases don't

---

### vs. Content-Addressable Storage (Git, IPFS, Merkle DAGs)

**What they do well:**
- Immutable, verifiable content
- Deduplication
- Provenance tracking
- Tamper detection

**What they lack:**
- Content is passive
- No typed operations
- No coordination between objects
- No capability model

**ObliFS relationship:**
- ObliFS uses content-addressing for entity references
- Archive entity provides provenance like Git's commit history
- Adds typed actor semantics on top of content-addressable foundations

---

### vs. Message Queues/Brokers (Kafka, RabbitMQ, NATS)

**What they do well:**
- Reliable message delivery
- Pub/sub patterns
- Streaming
- Decoupling producers/consumers

**What they lack:**
- Messages are untyped (just bytes)
- No entity coordination (just message passing)
- No capability-based channel creation
- No consent model

**ObliFS relationship:**
- Message brokers could be transport layer under Router
- ObliFS adds typed messages and capability security
- Channels are consent-based, not just authenticated

---

### vs. Workflow Engines (Temporal, Argo, Airflow)

**What they do well:**
- Orchestrating multi-step processes
- Error handling and retry
- Visibility into execution state
- Scheduling

**What they lack:**
- Orchestrate external systems, not typed entities
- No capability-based access to steps
- No built-in audit by construction
- No reversibility guarantees

**ObliFS relationship:**
- ObliFS Workflow is a typed, consent-aware orchestrator
- Workflow operations must go through typed channels
- Reversibility is built into operation definitions

---

## What ObliFS Provides That None of These Do

1. **Typed storage entities with bounded behaviour**
   - Not just schema (what data looks like)
   - But type (what operations are permitted, what's prohibited)
   - With termination guarantees (from Oblíbený's phase separation)

2. **Consent-based channel creation**
   - Not just authentication (who are you?)
   - Not just authorisation (what can you access?)
   - But mutual consent (both parties agree to communicate)

3. **Audit by construction**
   - Not logging as afterthought
   - Operations are typed and logged by definition
   - Archive preserves provenance chains

4. **Reversible operations**
   - Every state-modifying operation defines its inverse
   - Combined with Archive, enables point-in-time recovery

5. **Emergent system behaviours**
   - Backup, replication, integrity checking from local protocols
   - Not centralised services operating on passive data

---

## The Gap ObliFS Fills

```
                    Expressiveness
                          ↑
                          │
     Actor Systems ●      │      ● Databases
          (Erlang)        │        (Spanner)
                          │
                          │         ● ObliFS
                          │
   Capability Systems ●   │      ● Object Stores
        (seL4)            │          (S3)
                          │
                          │
      Filesystems ●───────┼───────────────────→ Persistence
          (ext4)          │
                          │
```

ObliFS occupies the space where:
- **Persistence** (like filesystems and object stores)
- **Typed coordination** (like actor systems)
- **Capability security** (like seL4/Capsicum)

...all intersect. No existing system covers this intersection.

---

## When to Use What

| Use Case | Best Choice | Why |
|----------|-------------|-----|
| Simple file storage | Traditional FS | Mature, fast, universal |
| Scalable blob storage | Object store | S3-compatible, cheap |
| In-memory coordination | Actor system | Erlang/OTP is battle-tested |
| OS-level security | Capability system | seL4 for high-assurance |
| Structured queries | Database | SQL is well-understood |
| Typed storage coordination with audit | **ObliFS** | That's what it's for |
