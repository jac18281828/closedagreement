// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Script } from "forge-std/Script.sol";

import { ClosedAgreement } from "../contracts/ClosedAgreement.sol";

contract CounterScript is Script {

    event ClosedAgreementCreated(address agreement);

    function deploy() public {
        vm.broadcast();
        ClosedAgreement agreement = new ClosedAgreement();
        emit ClosedAgreementCreated(address(agreement));
    }
}
