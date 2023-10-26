// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// cast code 0xFD3CbdbD9D1bBe0452eFB1d1BFFa94C8468A66fC --rpc-url https://rpc.ankr.com/eth_goerli
contract PredictableNFTQuill {
    uint256 public id;
    mapping (uint256 =>uint256) public tokens;
    bool public isSolved;
    bool once = true;

    function mint() public payable returns(uint256) {
        require(once);
        require(msg.value == 1 ether);
        once = false;
        id += 1;
        uint256 value = uint256(keccak256(abi.encode(id, msg.sender, block.number))) % 100;
        if(value <= 90) {
            if (value <= 80) {
                tokens[id] = 1;
            } else {
                tokens[id] = 2;
            }
        } else {
            tokens[id] = 3;
            isSolved = true;
        }
        return id;
    }
}


