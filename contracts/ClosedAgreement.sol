// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { ECDSA } from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

/**
 * @notice Implement a closed agreement between two parties.
 * The agent and the counter party show there concent to the agreement by
 * signing in advance and this contract validates the signatures prior to
 * creating the agreemnt.
 */
contract ClosedAgreement {
    event AgreementCreated(bytes32 messageHash, address agent, address counterparty);
    event AgreementRevealed(bytes32 messageHash, string indexed agreement, address revealingParty);

    error AgreementExists(bytes32 messageHash);
    error NoSuchAgreement(bytes32 messageHash);
    error AgreementNotMatched(bytes32 messageHash);
    error SignatureVerificationFailed(address expected, address found);
    error NotParty(address sender);

    struct Agreement {
        address agent;
        address counterParty;
        uint256 blockNumber;
        bytes cipherText;
    }

    mapping(bytes32 => Agreement) private agreementMap;

    function createAgreement(
        bytes32 _agreementHash,
        address _counterParty,
        bytes memory _cipherText,
        bytes memory _agentSignature,
        bytes memory _counterpartySignature
    ) external {
        Agreement storage agreement = agreementMap[_agreementHash];
        if (agreement.agent != address(0x0)) revert AgreementExists(_agreementHash);
        address agentAddress = ECDSA.recover(_agreementHash, _agentSignature);
        if (agentAddress != msg.sender) revert SignatureVerificationFailed(msg.sender, agentAddress);
        address counterSignAddress = ECDSA.recover(_agreementHash, _counterpartySignature);
        if (counterSignAddress != _counterParty) revert SignatureVerificationFailed(_counterParty, counterSignAddress);
        agreement.agent = msg.sender;
        agreement.counterParty = _counterParty;
        agreement.blockNumber = block.number;
        agreement.cipherText = _cipherText;
        emit AgreementCreated(_agreementHash, agentAddress, _counterParty);
    }

    function getCipher(bytes32 _agreementHash) external view returns (bytes memory) {
        Agreement memory agreement = agreementMap[_agreementHash];
        return agreement.cipherText;
    }

    function reveal(bytes32 _agreementHash, string memory plainText) external {
        Agreement memory agreement = agreementMap[_agreementHash];
        if (agreement.agent == address(0x0)) revert NoSuchAgreement(_agreementHash);
        if (msg.sender != agreement.agent && msg.sender != agreement.counterParty) revert NotParty(msg.sender);

        // check agreement alignment
        bytes32 multipartyHash = keccak256(abi.encode(agreement.agent, agreement.counterParty, bytes(plainText).length, plainText));
        bytes32 ethMsgHash = ECDSA.toEthSignedMessageHash(multipartyHash);
        if (ethMsgHash != _agreementHash) revert AgreementNotMatched(multipartyHash);

        // overwrite and erase agreement
        agreementMap[_agreementHash] = Agreement(address(0x0), address(0x0), 0, "");
        delete agreementMap[_agreementHash];

        // reveal agreement
        emit AgreementRevealed(_agreementHash, plainText, msg.sender);
    }
}
