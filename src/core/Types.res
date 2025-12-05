// SPDX-License-Identifier: MIT AND LicenseRef-Palimpsest-0.8
// SPDX-FileCopyrightText: 2024 Jonathan

/**
 * ObliFS Core Types
 *
 * Fundamental types for the ObliFS coordination layer.
 * These types are derived from the Oblíbený type system.
 */

/** Content-addressable hash for entity references */
type contentHash = string

/** Unique identifier for messages */
type messageId = string

/** Timestamp in milliseconds since epoch */
type timestamp = float

/** Channel identifier */
type channelId = string

/** Reference to an entity */
type entityRef = {
  id: contentHash,
  entityType: entityType,
}

/** Types of entities in ObliFS */
and entityType =
  | Manifest
  | Actor
  | Channel
  | Router
  | Workflow
  | Archive

/** Capability token authorizing an interaction */
type capability = {
  holder: entityRef,
  target: entityRef,
  operation: operationType,
  expiry: option<timestamp>,
  delegable: bool,
}

/** Types of operations that can be authorized */
and operationType =
  | Query
  | Command
  | Replicate
  | CreateChannel
  | Delegate

/** Proof that both parties consented to a channel */
type consentProof = {
  initiatorCap: capability,
  responderCap: capability,
  channelId: channelId,
  timestamp: timestamp,
}

/** Message exchanged between entities */
type message<'payload> = {
  id: messageId,
  from: entityRef,
  to: entityRef,
  messageType: string,
  payload: 'payload,
  timestamp: timestamp,
  consent: consentProof,
}

/** Result type for operations */
type result<'ok, 'err> =
  | Ok('ok)
  | Error('err)
