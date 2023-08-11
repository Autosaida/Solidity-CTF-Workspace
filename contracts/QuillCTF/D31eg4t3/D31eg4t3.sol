// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract D31eg4t3Quill {
    uint a = 12345;   // 0
    uint8 b = 32;     // 0
    string private d; // 1
    uint32 private c; // 2
    string private mot;   // 3
    address public owner;  // 4
    mapping (address => bool) public canYouHackMe; // 5

    modifier onlyOwner{
        require(false, "Not a Owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function hackMe(bytes calldata bites) public returns(bool, bytes memory) {
        (bool r, bytes memory msge) = address(msg.sender).delegatecall(bites);
        return (r, msge);
    }


    function hacked() public onlyOwner{
        canYouHackMe[msg.sender] = true;
    }
}