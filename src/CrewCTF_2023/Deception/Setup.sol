// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./Deception.sol";

contract Setup {
    Deception public immutable TARGET;

    constructor() payable {
        TARGET = new Deception(); 
    }

    function isSolved() public view returns (bool) {
        return TARGET.solved();
    }
}
