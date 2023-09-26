//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ByteDanceAttackMetaTrust23 {
    constructor() {
        assembly {
            // PUSH2 0x0101
            // PUSH2 0x0101
            // DUP2  // 81
            // SUB
            // ISZERO
            // PUSH2 0x0101
            // PUSH2 0x0101
            // SUB
            // SSTORE  
            mstore(0x00, shl(mul(8,15), 0x6101016101018103156101016101010355))
            return(0, 17)
        }
    }
}