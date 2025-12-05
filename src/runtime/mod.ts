// SPDX-License-Identifier: MIT AND LicenseRef-Palimpsest-0.8
// SPDX-FileCopyrightText: 2024 Jonathan

/**
 * ObliFS Runtime
 *
 * Deno-based coordination runtime for ObliFS entities.
 */

export const VERSION = "0.1.0";

/**
 * Entity reference - content-addressable
 */
export interface EntityRef {
  id: string;
  entityType: EntityType;
}

/**
 * Entity types in ObliFS
 */
export type EntityType =
  | "Manifest"
  | "Actor"
  | "Channel"
  | "Router"
  | "Workflow"
  | "Archive";

/**
 * Capability token
 */
export interface Capability {
  holder: EntityRef;
  target: EntityRef;
  operation: OperationType;
  expiry?: number;
  delegable: boolean;
}

/**
 * Operation types that can be authorized
 */
export type OperationType =
  | "Query"
  | "Command"
  | "Replicate"
  | "CreateChannel"
  | "Delegate";

/**
 * Consent proof for channel creation
 */
export interface ConsentProof {
  initiatorCap: Capability;
  responderCap: Capability;
  channelId: string;
  timestamp: number;
}

/**
 * Message between entities
 */
export interface Message<T = unknown> {
  id: string;
  from: EntityRef;
  to: EntityRef;
  messageType: string;
  payload: T;
  timestamp: number;
  consent: ConsentProof;
}

/**
 * Runtime configuration
 */
export interface RuntimeConfig {
  /** Storage adapter to use */
  storageAdapter: string;
  /** Enable audit logging */
  auditEnabled: boolean;
  /** Maximum mailbox size per actor */
  maxMailboxSize: number;
}

/**
 * Default runtime configuration
 */
export const defaultConfig: RuntimeConfig = {
  storageAdapter: "memory",
  auditEnabled: true,
  maxMailboxSize: 1000,
};

/**
 * ObliFS Runtime instance
 */
export class Runtime {
  private config: RuntimeConfig;
  private entities: Map<string, EntityRef>;

  constructor(config: Partial<RuntimeConfig> = {}) {
    this.config = { ...defaultConfig, ...config };
    this.entities = new Map();
  }

  /**
   * Register an entity with the runtime
   */
  register(entity: EntityRef): void {
    this.entities.set(entity.id, entity);
    if (this.config.auditEnabled) {
      console.log(`[AUDIT] Registered entity: ${entity.id} (${entity.entityType})`);
    }
  }

  /**
   * Get entity by ID
   */
  get(id: string): EntityRef | undefined {
    return this.entities.get(id);
  }

  /**
   * Send message between entities (placeholder)
   */
  async send<T>(message: Message<T>): Promise<void> {
    if (this.config.auditEnabled) {
      console.log(
        `[AUDIT] Message ${message.id}: ${message.from.id} -> ${message.to.id}`
      );
    }
    // Actual message routing would happen here
    await Promise.resolve();
  }
}

// Export singleton instance
export const runtime = new Runtime();
