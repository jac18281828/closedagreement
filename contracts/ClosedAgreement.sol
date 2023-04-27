// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

/**
 * @notice Implement a closed agreement between two parties.
 * The agent and the counter party show there concent to the agreement by
 * signing in advance and this contract validates the signatures prior to
 * creating the agreemnt.
 */
contract ClosedAgreement {
    event AgreementCreated(bytes32 messageHash, address agent, address counterparty);
    event AgreementRevealed(bytes32 messageHash, string indexed agreement, address revealingParty);

    struct Agreement {
        address agent;
        address counter;
        uint256 blockNumber;
        string cipherText;
    }

    mapping(bytes32 => Agreement) private agreementLookup;

    function createAgreement(
        bytes32 _agreementMessageHash,
        string memory _cipherText,
        string memory _agentSignature,
        string memory _counterpartySignature
    ) external {}

    function getCipher(bytes32 _agreementHash) external view returns (string memory) {
        Agreement memory agreement = agreementLookup[_agreementHash];
        return agreement.cipherText;
    }

    function reveal(string memory plainText) external {}
}
