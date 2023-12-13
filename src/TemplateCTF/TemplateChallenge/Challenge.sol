// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

contract Challenge {
    string private secret;
    string private greeting;

    constructor(string memory s) {
        secret = s;
    }

    function set(string memory s) public {
        greeting = s;
    }

    function isSolved() public view returns(bool){
        return keccak256(abi.encode(greeting)) == keccak256(abi.encode(secret));
    }
}



