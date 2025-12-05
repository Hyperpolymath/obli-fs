# ObliFS: Elevator Pitches

Different framings for different audiences. Use the one that resonates.

---

## The 30-Second Version

**For anyone:**

> "What if files weren't just data sitting on disk waiting to be acted upon—what if they were active participants that knew their role in the system? ObliFS makes stored data smart: each file knows what it can do, what it can't do, and how to cooperate with other files to handle backup, security, and data integrity automatically. It's like giving your filesystem an immune system."

---

## Technical Pitches by Audience

### For Distributed Systems Engineers

> "ObliFS is an actor model over persistent storage. Every stored entity is a typed actor with a bounded capability set and a mailbox. System behaviours like replication and consistency emerge from message-passing protocols between actors, not from central services. Think Erlang/OTP, but for your data layer."

**Hook**: "Emergent system behaviours from local actor interactions"

---

### For Security/Capability Researchers

> "ObliFS implements capability-based access control at the storage layer. No entity can be accessed without presenting a valid capability. Channels between entities require mutual consent. All operations are typed and auditable. It's like Capsicum or seL4's capability model, applied to persistent storage."

**Hook**: "Capability security by construction, not configuration"

---

### For Type Theory/PL Researchers

> "ObliFS uses substructural types to guarantee storage entity behaviour. Each entity type is a Turing-incomplete restriction of a full language, enforced at compile time. An Actor can receive messages and transform state; a Channel can only forward. The safety properties aren't runtime checks—they're type-level guarantees."

**Hook**: "Turing-incomplete types for bounded storage behaviour"

---

### For Compliance/Audit Professionals

> "ObliFS provides built-in audit trails and consent tracking. Every operation is typed, logged, and reversible. Consent is required before any entity can access another. Data provenance is tracked from creation to archival. You get GDPR-style consent and SOX-style audit trails by construction, not by bolting on logging."

**Hook**: "Compliance by architecture, not afterthought"

---

### For Enterprise Architects

> "ObliFS is a governance layer over your existing storage. It sits between applications and filesystems, adding type safety, access control, and audit trails without replacing your infrastructure. Think of it as a policy enforcement point for all data operations, with the policies encoded in types rather than configuration files."

**Hook**: "Data governance as a typed abstraction layer"

---

### For Developers (Metaphor-Friendly)

> "Imagine your files are like workers in a village. Each one has a specific job—some store data, some handle backups, some verify integrity. They can only talk to each other through approved channels, and every conversation is logged. No worker can do anything outside their job description. That's ObliFS: a cooperative system where data knows its role and plays it safely."

**Hook**: "Files as cooperative specialists, not passive blobs"

---

## The Problem Statement

Use this to set up any of the pitches above:

> "Current filesystems treat files as passive data. All the intelligence—backup, security, versioning, integrity checking—lives in external services that operate on inert bytes. This creates fragile systems where security is bolted on, audit trails are afterthoughts, and coordination requires central orchestrators.
>
> We're asking: what if the storage layer itself were intelligent? What if files knew their roles and cooperated to maintain system properties automatically?"

---

## What NOT to Lead With

Avoid these unless the audience is already engaged:

- The metaphors (sigil, vessel, cloak, ritual, compost) — they sound like fantasy worldbuilding
- "Paradigm shift" or "revolutionary" — sounds like hype
- The full type specification — too much detail too soon
- Oblíbený dependency — explain the benefits first, the implementation second

---

## Conversation Starters

Questions that lead naturally into the pitch:

- "Have you ever had to bolt audit logging onto a system after the fact?"
- "How do you handle capability-based access in your storage layer?"
- "What's your strategy for data provenance across services?"
- "How confident are you that a bug in one service can't corrupt another service's data?"

These create openings where ObliFS's properties become relevant solutions.
