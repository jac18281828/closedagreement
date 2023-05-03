// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { ECDSA } from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

/**
 * @notice Implement a closed agreement between two parties.
 * The agent and the counter party demonstrate consent by
 * signing in advance.  This contract validates the signatures and
 * creates the agreement.
 */
contract ClosedAgreement {
    /// @notice a new agreement has been created
    event AgreementCreated(bytes32 messageHash, address agent, address counterparty);
    /// @notice the existing agreement has been publically revaled
    event AgreementRevealed(bytes32 messageHash, string agreement, address revealingParty);

    /// @notice error on attempting to create an existing agreement
    error AgreementExists(bytes32 messageHash);
    /// @notice no such agreement exists
    error NoSuchAgreement(bytes32 messageHash);
    /// @notice an attempt to reveal the agreement failed to verify the agreement
    error AgreementNotRevealed(bytes32 messageHash);
    /// @notice signing party did not provide a valid signature
    error SignatureVerificationFailed(address expected, address found);
    /// @notice sender is not a party to the agreement
    error NotParty(address sender);

    /// @notice struct representing the agreement, agent is the agreement sender,
    /// counterParty is the person the agreement is with and
    // blockNumber is the block at which the agreement was created
    struct Agreement {
        address agent;
        address counterParty;
        uint256 blockNumber;
    }

    mapping(bytes32 => Agreement) private agreementMap;

    /**
     * @notice create an agreement between parties
     * @param _agreementHash the hash of the agreement message text
     * @param _counterParty the address the agreement is with
     * @param _agentSignature the signature of the message sender
     * @param _counterpartySignature the counter signature for the agreeable party
     */
    function createAgreement(
        bytes32 _agreementHash,
        address _counterParty,
        bytes memory _agentSignature,
        bytes memory _counterpartySignature
    ) external {
        Agreement storage agreement = agreementMap[_agreementHash];
        if (agreement.agent != address(0x0)) revert AgreementExists(_agreementHash);
        verifySignature(_agreementHash, _agentSignature, msg.sender);
        verifySignature(_agreementHash, _counterpartySignature, _counterParty);
        address counterSignAddress = ECDSA.recover(_agreementHash, _counterpartySignature);
        if (counterSignAddress != _counterParty) revert SignatureVerificationFailed(_counterParty, counterSignAddress);
        agreement.agent = msg.sender;
        agreement.counterParty = _counterParty;
        agreement.blockNumber = block.number;
        emit AgreementCreated(_agreementHash, msg.sender, _counterParty);
    }

    /**
     * @notice reveal an agreement by publishing the text of the agreement
     * @dev the agreement text must match the stored agreement hash to be revealed
     * @param _agreementHash the hash of an existing agreement
     * @param _plainText the original agreement to reveal
     */
    function reveal(bytes32 _agreementHash, string memory _plainText) external {
        Agreement memory agreement = agreementMap[_agreementHash];
        if (agreement.agent == address(0x0)) revert NoSuchAgreement(_agreementHash);
        if (msg.sender != agreement.agent && msg.sender != agreement.counterParty) revert NotParty(msg.sender);

        agreementAlignsWithReveal(_agreementHash, agreement, _plainText);

        // overwrite and erase agreement
        agreementMap[_agreementHash] = Agreement(address(0x0), address(0x0), 0);
        delete agreementMap[_agreementHash];

        // reveal agreement
        emit AgreementRevealed(_agreementHash, _plainText, msg.sender);
    }

    function verifySignature(bytes32 _agreementHash, bytes memory _signature, address _expectedSigner) private pure {
        address signatureAddress = ECDSA.recover(_agreementHash, _signature);
        if (signatureAddress != _expectedSigner) revert SignatureVerificationFailed(_expectedSigner, signatureAddress);
    }

    function agreementAlignsWithReveal(
        bytes32 _agreementHash,
        Agreement memory _agreement,
        string memory plainText
    ) private pure {
        // check agreement alignment
        bytes32 multipartyHash = keccak256(
            abi.encode(_agreement.agent, _agreement.counterParty, bytes(plainText).length, plainText)
        );
        bytes32 ethMsgHash = ECDSA.toEthSignedMessageHash(multipartyHash);
        if (ethMsgHash != _agreementHash) revert AgreementNotRevealed(ethMsgHash);
    }
}
