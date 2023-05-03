// SPDX-License-Identifier: UNLICENSED

import Web3 from "web3";

import { Config } from "./config";
import { LoggerFactory } from "./logging";
import {
    loadContract, getKeyAsEthereumKey
} from './contract';

const logger = LoggerFactory.getLogger(module.filename);

/**
 * runnable script to reveal a sample agreement between two parties
 */
const run = async () => {
    const config = new Config();
    const web3 = new Web3(config.rpcUrl);
    const contract = loadContract(config, "ClosedAgreement.json", web3);

    const agentPrivateKey = getKeyAsEthereumKey(config.agentPrivateKey);
    const agentAccount = web3.eth.accounts.wallet.add(agentPrivateKey);
    const revealTx = await contract.methods
        .reveal(
            config.agreementHash,
            config.secret
        )
        .send({
            from: agentAccount.address,
            gas: config.getGasLimit(),
        });
    logger.info(revealTx);
};

run()
    .then(() => process.exit(0))
    .catch((error) => logger.error(error));
