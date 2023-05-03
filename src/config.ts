// SPDX-License-Identifier: UNLICENSED

import * as dotenv from "dotenv";

dotenv.config();

export class Config {
    public readonly secret = process.env.SECRET_AGREEMENT || "";
    public readonly agentAddress = process.env.PUBLIC_ADDRESS || "";
    public readonly agentPrivateKey = process.env.PRIVATE_KEY || "";
    public readonly counterAddress = process.env.COUNTER_PARTY_ADDRESS || "";
    public readonly counterPrivateKey = process.env.COUNTER_PARTY_PRIVATE_KEY || "";
    public readonly rpcUrl = process.env.RPC_URL || "";
    public readonly abiPath = process.env.ABI_PATH || "";
    public readonly contractAddress = process.env.CONTRACT_ADDRESS || "";
    public readonly agreementHash = process.env.AGREEMENT_HASH || "";

    // default gas limit - may override in .env
    public readonly gasLimit = process.env.GAS_LIMIT || "400000";

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

        if (!this.abiPath) {
            throw new Error("ABI_PATH is required");
        }

        if (!this.contractAddress) {
            throw new Error("CONTRACT_ADDRESS is required");
        }
    }


    getGasLimit(): number {
        return parseInt(this.gasLimit);
    }
}
