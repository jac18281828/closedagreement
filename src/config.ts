// SPDX-License-Identifier: UNLICENSED

import * as dotenv from "dotenv";

dotenv.config();

export class Config {
    public readonly secret = process.env.SECRET_AGREEMENT || "";
    public readonly agentAddress = process.env.AGENT_ADDRESS || "";
    public readonly agentPrivateKey = process.env.AGENT_PRIVATE_KEY || "";
    public readonly counterAddress = process.env.COUNTER_PARTY_ADDRESS || "";
    public readonly counterPrivateKey = process.env.COUNTER_PARTY_PRIVATE_KEY || "";
    public readonly rpcUrl = process.env.RPC_URL || "";

    constructor() {
        if (!this.secret) {
            throw new Error("SECRET_AGREEMENT is required");
        }

        if (!this.agentAddress) {
            throw new Error("AGENT_ADDRESS is required");
        }

        if (!this.agentPrivateKey) {
            throw new Error("AGENT_PRIVATE_KEY is required");
        }

        if (!this.counterAddress) {
            throw new Error("COUNTER_PARTY_ADDRESS is required");
        }

        if (!this.counterPrivateKey) {
            throw new Error("COUNTER_PARTY_PRIVATE_KEY is required");
        }

        if (!this.rpcUrl) {
            throw new Error("RPC_URL is required");
        }
    }
}
