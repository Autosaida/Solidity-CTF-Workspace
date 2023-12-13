// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import "./Challenge.sol";

contract ChallengeAttack {
    function set(address target) public {
        Challenge(target).set("template");
    }
}
