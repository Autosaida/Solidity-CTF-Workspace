// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./SEEPass.sol";

contract SetupMSSEETF23 {
    SEEPassMSSEETF23 public immutable pass;

    constructor(bytes32 _merkleRoot) {
        pass = new SEEPassMSSEETF23(_merkleRoot);
    }

    function isSolved() external view returns (bool) {
        return pass.balanceOf(msg.sender) > 0;
    }
}
