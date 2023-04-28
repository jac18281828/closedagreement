import Web3 from 'web3';

import { Config } from "./config";
import { LoggerFactory } from "./logging";

const logger = LoggerFactory.getLogger(module.filename);

const run = async () => {
    const config = new Config();
    const web3 = new Web3(config.rpcUrl);
    const agentPrivateKey = getKeyAsEthereumKey(config.agentPrivateKey);
    const agentAccount = web3.eth.accounts.wallet.add(agentPrivateKey);

    const counterPrivateKey = getKeyAsEthereumKey(config.counterPrivateKey);
    const counterAccount = web3.eth.accounts.wallet.add(counterPrivateKey);

    const message = config.secret;
    const ethMsgHash = toEthSignedMessage(web3, config.agentAddress, config.counterAddress, message);
    const agentSignature = agentAccount.sign(ethMsgHash);
    logger.info(`eth msg hash = ${ethMsgHash}`);
    logger.info(`agent hash: ${agentSignature.messageHash}`);
    logger.info(`agent signature: ${agentSignature.signature}`);
    const counterSignature = counterAccount.sign(ethMsgHash);
    logger.info(`counter party hash: ${counterSignature.messageHash}`);
    logger.info(`counter party signature: ${counterSignature.signature}`);
};

function toEthSignedMessage(web3: Web3, agent: string, counter: string, message: string) {
    const multiPartyMsg = web3.eth.abi.encodeParameters(["address", "address", "uint256", "string"], [agent, counter, message.length, message]);
    const partyHash = web3.utils.keccak256(multiPartyMsg);
    logger.info(`multi party hash = ${partyHash}`);
    return partyHash;
}

function getKeyAsEthereumKey(privateKey: string): string {
    if (privateKey.startsWith('0x')) {
        return privateKey;
    }
    return '0x' + privateKey;
}


run()
    .then(() => process.exit(0))
    .catch((error) => logger.error(error));
