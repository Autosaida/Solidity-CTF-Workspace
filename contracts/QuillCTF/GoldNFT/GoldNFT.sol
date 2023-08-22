// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

interface IPassManager {
    function read(bytes32) external returns (bool);
}

contract GoldNFTQuill is ERC721("GoldNFT", "GoldNFT") {
    uint lastTokenId;
    bool minted;

    function takeONEnft(bytes32 password) external {
        require(  //https://goerli.etherscan.io/tx/0x88fc0f1dd855405d092fc408c3311e7131477ec201f39344c4f002371c23f81c#statechange
            IPassManager(0xe43029d90B47Dd47611BAd91f24F87Bc9a03AEC2).read(  // goerli, just read the slot(password) 
                password
            ),
            "wrong pass"
        );

        if (!minted) {
            lastTokenId++;
            _safeMint(msg.sender, lastTokenId);
            minted = true;   // reentrancy
        } else 
        revert("already minted");
    }

    function isSolved() public view returns(bool) {
        return balanceOf(msg.sender) >= 10;
    }
}