// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { ECDSA } from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

import "forge-std/Test.sol";

import "../contracts/ClosedAgreement.sol";

contract ClosedAgreementTest is Test {
    bytes32 public constant MSG_HASH = hex"523511d280b10d6ae6685a0239cdb93bd8f5f113b9215d189bbe095edadd3d20";
    address public constant AGENT_ADDRESS = address(0x6CEb0bF1f28ca4165d5C0A04f61DC733987eD6ad);
    bytes public constant AGENT_SIGNATURE =
        hex"54eebd76b88797c7450b77f9aa4b73290ca8f183fcadbcaf5ba9cb1544fed4d423b1d0d2d7fe505392ca0c9b7fe09817d28c2a8bdf59ff80554ebfaed357e1cf1b";
    address public constant COUNTER_ADDRESS = address(0x22A653801bB0bb85BE38765cC072144736635eE8);
    bytes public constant COUNTER_SIGNATURE =
        hex"417edacdc79fcddc51ffbed2c8e70a40fbc86b361107000aa57de7152d5ce20458bbe26465682236b6edbb9d17a0c67e233895effaca4fc348333ac0065f9ee51b";

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
        agreement.createAgreement(MSG_HASH, COUNTER_ADDRESS, "hello world", AGENT_SIGNATURE, COUNTER_SIGNATURE);
    }

    function testDuplicateAgreementForbidden() public {
        vm.prank(AGENT_ADDRESS);
        agreement.createAgreement(MSG_HASH, COUNTER_ADDRESS, "hello world", AGENT_SIGNATURE, COUNTER_SIGNATURE);
        vm.expectRevert(abi.encodeWithSelector(ClosedAgreement.AgreementExists.selector, MSG_HASH));
        vm.prank(AGENT_ADDRESS);
        agreement.createAgreement(MSG_HASH, COUNTER_ADDRESS, "hello world", AGENT_SIGNATURE, COUNTER_SIGNATURE);
    }

    function testAgentSignatureFails() public {
        vm.expectRevert(abi.encodeWithSelector(ClosedAgreement.SignatureVerificationFailed.selector, address(0x1234), AGENT_ADDRESS));
        vm.prank(address(0x1234));
        agreement.createAgreement(MSG_HASH, COUNTER_ADDRESS, "hello world", AGENT_SIGNATURE, COUNTER_SIGNATURE);
    }

    function testCounterSignatureFails() public {
        vm.expectRevert(abi.encodeWithSelector(ClosedAgreement.SignatureVerificationFailed.selector, address(0x1234), COUNTER_ADDRESS));
        vm.prank(AGENT_ADDRESS);
        agreement.createAgreement(MSG_HASH, address(0x1234), "hello world", AGENT_SIGNATURE, COUNTER_SIGNATURE);
    }

    function testCipher() public {
        vm.prank(AGENT_ADDRESS);
        agreement.createAgreement(MSG_HASH, COUNTER_ADDRESS, "hello world", AGENT_SIGNATURE, COUNTER_SIGNATURE);
        bytes memory cipherText = agreement.getCipher(MSG_HASH);
        assertEq("hello world", cipherText);
    }


}
