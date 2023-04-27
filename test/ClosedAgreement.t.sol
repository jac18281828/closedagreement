// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

import "../contracts/ClosedAgreement.sol";

contract ClosedAgreementTest is Test {
    ClosedAgreement public agreement;

    function setUp() public {
        agreement = new ClosedAgreement();
    }
}
