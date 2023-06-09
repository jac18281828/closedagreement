import { Config } from "../config";

describe("Config", () => {
    const env = process.env;
    let config: Config;

    beforeEach(() => {
        jest.resetModules();
        process.env = {
            ...env,
            SECRET_AGREEMENT: "agree",
            PUBLIC_ADDRESS: "0x0000",
            PRIVATE_KEY: "12345",
            COUNTER_PARTY_ADDRESS: "0x0001",
            COUNTER_PARTY_PRIVATE_KEY: "12346",
            RPC_URL: "https://eth.net.com/rpc",
            ABI_PATH: "./abi",
            CONTRACT_ADDRESS: "0xabcdef",
        };
        config = new Config();
    });

    afterEach(() => {
        process.env = env;
    });

    it("must load secret", () => {
        expect(config.secret).toBe("agree");
    });

    it("must require secret", () => {
        process.env.SECRET_AGREEMENT = "";
        expect(() => new Config()).toThrow();
    });

    it("must load agent address", () => {
        expect(config.agentAddress).toBe("0x0000");
    });

    it("must require agent address", () => {
        process.env.PUBLIC_ADDRESS = "";
        expect(() => new Config()).toThrow();
    });

    it("must load agent key", () => {
        expect(config.agentPrivateKey).toBe("12345");
    });

    it("must require agent private key", () => {
        process.env.PRIVATE_KEY = "";
        expect(() => new Config()).toThrow();
    });

    it("must load counter address", () => {
        expect(config.counterAddress).toBe("0x0001");
    });

    it("must require counter address", () => {
        process.env.COUNTER_PARTY_ADDRESS = "";
        expect(() => new Config()).toThrow();
    });

    it("must load counter key", () => {
        expect(config.counterPrivateKey).toBe("12346");
    });

    it("must require counter private key", () => {
        process.env.COUNTER_PARTY_PRIVATE_KEY = "";
        expect(() => new Config()).toThrow();
    });

    it("must load rpcUrl", () => {
        expect(config.rpcUrl).toBe("https://eth.net.com/rpc");
    });

    it("must require rpc url", () => {
        process.env.RPC_URL = "";
        expect(() => new Config()).toThrow();
    });

    it("must load abiPath", () => {
        expect(config.abiPath).toBe("./abi");
    });

    it("must require abiPath", () => {
        process.env.ABI_PATH = "";
        expect(() => new Config()).toThrow();
    });

    it("must load contractAddress", () => {
        expect(config.contractAddress).toBe("0xabcdef");
    });

    it("must require contractAddress", () => {
        process.env.CONTRACT_ADDRESS = "";
        expect(() => new Config()).toThrow();
    });
});
