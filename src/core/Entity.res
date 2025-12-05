// SPDX-License-Identifier: MIT AND LicenseRef-Palimpsest-0.8
// SPDX-FileCopyrightText: 2024 Jonathan

/**
 * Entity Base Module
 *
 * Provides the base interface for all ObliFS entities.
 */

open Types

/** Entity state that can be held */
type entityState<'state> = {
  manifest: entityRef,
  state: 'state,
  created: timestamp,
  modified: timestamp,
}

/** Message handler signature */
type messageHandler<'state, 'msg, 'response> = (
  entityState<'state>,
  message<'msg>,
) => result<('state, option<'response>), string>

/** Entity definition */
type entityDef<'state, 'msg, 'response> = {
  entityType: entityType,
  initialState: 'state,
  handlers: array<messageHandler<'state, 'msg, 'response>>,
  canReceive: array<string>,
  canEmit: array<string>,
}

/** Create a new entity reference from content hash */
let makeRef = (hash: contentHash, eType: entityType): entityRef => {
  {id: hash, entityType: eType}
}

/** Get current timestamp */
let now = (): timestamp => {
  Js.Date.now()
}

/** Create initial entity state */
let createState = (manifest: entityRef, initial: 'state): entityState<'state> => {
  let ts = now()
  {
    manifest,
    state: initial,
    created: ts,
    modified: ts,
  }
}
