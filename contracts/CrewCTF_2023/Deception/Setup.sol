// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./Deception.sol";

contract SetupDeceptionCrew23 {
    DeceptionCrew23 public immutable TARGET;

    constructor() payable {
        TARGET = new DeceptionCrew23(); 
    }

    function isSolved() public view returns (bool) {
        return TARGET.solved();
    }
}
