// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { ECDSA } from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

import { Test } from "forge-std/Test.sol";

import { ClosedAgreement } from "../contracts/ClosedAgreement.sol";

contract ClosedAgreementTest is Test {
    string public constant AGREEMENT = "daccord";
    bytes public constant CIPHER = bytes(AGREEMENT);
    bytes32 public constant MSG_HASH = hex"6ccef4a336990d1c3c52b7a0624d811b7eddecb4825e3ec9ce7ae57f4fa2d9c7";
    address public constant AGENT_ADDRESS = address(0x6CEb0bF1f28ca4165d5C0A04f61DC733987eD6ad);
    bytes public constant AGENT_SIGNATURE =
        hex"aa4179ee0406f6c06032682185b74d422925968824778d25239817dc6d23dd7a4e84a2fc4c410461791ce1cc719f942712b0eea9e6549e43155be40c9311af1e1b";
    address public constant COUNTER_ADDRESS = address(0x22A653801bB0bb85BE38765cC072144736635eE8);
    bytes public constant COUNTER_SIGNATURE =
        hex"b0c1499b588f65243c1a86d31020228b849bd464943753ada9030eb63f814ae72b894776ab2dcca598c47b42c7e71f3dd7148d70bf710fda2406e4268b5ff3c31b";

    ClosedAgreement public agreement;

    function setUp() public {
        agreement = new ClosedAgreement();
    }

    function testSignatureAgent() public {
        address signer = ECDSA.recover(MSG_HASH, AGENT_SIGNATURE);
        assertEq(signer, AGENT_ADDRESS);
    }

    function testSignatureCounter() public {
        address signer = ECDSA.recover(MSG_HASH, COUNTER_SIGNATURE);
        assertEq(signer, COUNTER_ADDRESS);
    }

    function testAgreementCreation() public {
        vm.prank(AGENT_ADDRESS);
        agreement.createAgreement(MSG_HASH, COUNTER_ADDRESS, CIPHER, AGENT_SIGNATURE, COUNTER_SIGNATURE);
    }

    function testDuplicateAgreementForbidden() public {
        vm.prank(AGENT_ADDRESS);
        agreement.createAgreement(MSG_HASH, COUNTER_ADDRESS, CIPHER, AGENT_SIGNATURE, COUNTER_SIGNATURE);
        vm.expectRevert(abi.encodeWithSelector(ClosedAgreement.AgreementExists.selector, MSG_HASH));
        vm.prank(AGENT_ADDRESS);
        agreement.createAgreement(MSG_HASH, COUNTER_ADDRESS, CIPHER, AGENT_SIGNATURE, COUNTER_SIGNATURE);
    }

    function testAgentSignatureFails() public {
        vm.expectRevert(
            abi.encodeWithSelector(ClosedAgreement.SignatureVerificationFailed.selector, address(0x1234), AGENT_ADDRESS)
        );
        vm.prank(address(0x1234));
        agreement.createAgreement(MSG_HASH, COUNTER_ADDRESS, CIPHER, AGENT_SIGNATURE, COUNTER_SIGNATURE);
    }

    function testCounterSignatureFails() public {
        vm.expectRevert(
            abi.encodeWithSelector(ClosedAgreement.SignatureVerificationFailed.selector, address(0x1234), COUNTER_ADDRESS)
        );
        vm.prank(AGENT_ADDRESS);
        agreement.createAgreement(MSG_HASH, address(0x1234), CIPHER, AGENT_SIGNATURE, COUNTER_SIGNATURE);
    }

    function testCipher() public {
        vm.prank(AGENT_ADDRESS);
        agreement.createAgreement(MSG_HASH, COUNTER_ADDRESS, CIPHER, AGENT_SIGNATURE, COUNTER_SIGNATURE);
        bytes memory cipherText = agreement.getCipher(MSG_HASH);
        assertEq(CIPHER, cipherText);
    }

    function testAgreementReveal() public {
        vm.prank(AGENT_ADDRESS);
        agreement.createAgreement(MSG_HASH, COUNTER_ADDRESS, CIPHER, AGENT_SIGNATURE, COUNTER_SIGNATURE);
        vm.prank(AGENT_ADDRESS);
        agreement.reveal(MSG_HASH, AGREEMENT);
    }

    function testHashAgreement() public {
        bytes32 exptHash = hex"b2cc7f42911d454a23e955705c1e8c73563284b935e563c828c065989906cf97";
        bytes32 partyHash = keccak256(abi.encode(AGENT_ADDRESS, COUNTER_ADDRESS, bytes(AGREEMENT).length, AGREEMENT));
        assertEq(partyHash, exptHash);
        bytes32 yanHash = ECDSA.toEthSignedMessageHash(partyHash);
        assertEq(yanHash, MSG_HASH);
    }
}
