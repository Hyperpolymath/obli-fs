# ObliFS: Typed Actor Coordination Over Storage

## Technical Summary (v0.1)

### Problem Statement

Current storage systems treat files as passive data. Programs act upon files; files have no agency. System behaviours (backup, replication, integrity checking, access control) are implemented as external services operating on inert data. This architecture creates:

- **Security fragility**: Access control is bolted on, not intrinsic
- **Audit complexity**: Operations must be logged externally
- **Coordination overhead**: System behaviours require centralised orchestration
- **Reversibility gaps**: Undo requires external versioning systems

### Core Architecture

ObliFS is a **typed actor coordination layer** over storage. It does not replace existing filesystems; it provides a semantic layer above them.

```
┌─────────────────────────────────────────┐
│  Application (uses ObliFS API)          │
├─────────────────────────────────────────┤
│  ObliFS (typed actors, message-passing) │
├─────────────────────────────────────────┤
│  Adapter Layer                          │
├─────────────────────────────────────────┤
│  ext4 / ZFS / S3 / any storage backend  │
└─────────────────────────────────────────┘
```

### Key Properties

**1. Entities are Typed Actors**

Every stored entity has a type that defines:
- What state it can hold
- What messages it can receive
- What messages it can emit
- What operations are prohibited

Types are **Turing-incomplete by construction**—each entity can only do its designated job.

**2. Communication via Typed Messages**

Entities do not directly access each other. They exchange typed messages through channels. This provides:
- Type-safe interactions
- Auditable operation history
- Decoupled components

**3. Consent-Based Channels**

Channels between entities require explicit consent from both parties. No entity can be accessed without presenting a valid capability. This provides:
- Capability-based security by default
- No covert channels
- Explicit trust relationships

**4. Emergent System Behaviours**

Backup, replication, integrity checking, and access control emerge from protocols between typed entities—not from monolithic services. Local rules produce global properties.

**5. Reversible Operations**

All state-modifying operations define their inverse. Combined with append-only archival, this provides:
- Full operation history
- Point-in-time recovery
- Provenance tracking

### Entity Types

| Type | Purpose | Can Do | Cannot Do |
|------|---------|--------|-----------|
| **Manifest** | Immutable specification | Validate against schema | Execute, mutate, communicate |
| **Actor** | Active entity with state | Receive messages, transform state, emit messages | Arbitrary I/O, spawn processes, escape type bounds |
| **Channel** | Message conduit | Forward typed messages | Store state, transform content |
| **Router** | Message routing | Route based on headers | Read message content, create channels |
| **Workflow** | Operation composition | Sequence operations, handle errors | Bypass consent, violate type bounds |
| **Archive** | Historical preservation | Store, retrieve, prove provenance | Delete, modify, reorder |

### Type Derivation

Entity types are derived from the Oblíbený language core through systematic restriction. The full language is Turing-complete; derived entity types are Turing-incomplete sublanguages that can perform their role but nothing else. Safety comes from the restriction, not from runtime enforcement.

### Substrate Independence

ObliFS operates over any storage backend through adapters:
- Local filesystems (ext4, ZFS, APFS, NTFS)
- Object stores (S3, GCS, Azure Blob)
- Distributed filesystems (Ceph, GlusterFS)
- Content-addressable stores (IPFS, custom)

The same typed actor semantics apply regardless of underlying storage.

### Target Domains

ObliFS provides strongest value where:
- **Formal verification** of operations is required
- **Audit trails** are regulatory mandates
- **Consent-based access** aligns with data governance
- **Distributed coordination** lacks central authority
- **Long-term preservation** requires provenance

Examples: safety-critical systems, compliance-heavy environments, federated data systems, digital archives.

### Implementation Status

- Specification: Draft (this document)
- Reference implementation: Not started
- Target languages: Rust (core), bindings for other languages

---

*ObliFS is part of the Oblíbený project. Contact: [maintainer]*
