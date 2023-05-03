// SPDX-License-Identifier: UNLICENSED

import * as fs from "fs";
import Web3 from "web3";
import { Contract } from "web3-eth-contract";

import { Config } from "./config";
import { LoggerFactory } from "./logging";

const logger = LoggerFactory.getLogger(module.filename);

/// format key for use by Ethereum
export function getKeyAsEthereumKey(privateKey: string): string {
    if (privateKey.startsWith("0x")) {
        return privateKey;
    }
    return "0x" + privateKey;
}

/// load a contract with an abi
export function loadContract(config: Config, abiName: string, web3: Web3): Contract {
    const abiFile = pathWithSlash(config.abiPath) + abiName;
    logger.info(`loading ABI ${abiFile}`);
    const contractAbi = loadAbi(abiFile);
    return new web3.eth.Contract(contractAbi, config.contractAddress);
}

function loadAbi(abiFile: string): [] {
    const abiData = fs.readFileSync(abiFile).toString();
    const abi = JSON.parse(abiData);
    return abi;
}

function pathWithSlash(path: string): string {
    if (path.endsWith("/")) {
        return path;
    }
    return path + "/";
}
