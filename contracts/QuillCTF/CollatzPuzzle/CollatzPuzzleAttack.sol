// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract CollatzPuzzleQuillAttack {
    constructor() {
        // if (n % 2 == 0) {
        //     return n / 2;
        //     } else {
        //     return 3 * n + 1;
        // }

        // assembly {
        //     let n := calldataload(0x4)  // jump over the function signature
        //     let flag := mod(n, 2)
        //     switch flag 
        //     case 0 {
        //         let result := div(n, 2)
        //         mstore(0x0, result)
        //         return(0x0, 0x20)
        //     }
        //     case 1 {
        //         let result := add(mul(n, 3), 1)
        //         mstore(0x0, result)
        //         return(0x0, 0x20)
        //     }
        // }
        // 

        // push1 4  // 2
        // calldataload  // 1
        // push1 2  // 2
        // dup2  // 1
        // mod     // 1
        // push1 0x11   // 2
        // jumpi    // 1
        // push1 2   // 2
        // dup2 //2 
        // div  // 1 
        // push1 25   // 2
        // jump     // 1
        // jumpdest   // 1
        // push1 0x3   // 2
        // dup2 // 1
        // mul  // 1
        // push1 1  // 2
        // add  // 1
        // jumpdest // 1
        // callvalue // 2
        // mstore
        // push1 0x20
        // callvalue
        // return

        assembly {
            mstore(0x0, 0x60043560028106601157600281046019565b600381026001015b3452602034f3)
            return(0x0, 0x20)
        }
    }
}