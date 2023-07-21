// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CandyToken.sol";
import "./RespectToken.sol";
import "./CrewToken.sol";


/// @notice fancy store sells candies only to respectable members in the gang

contract FancyStoreCrew23 {

    CandyTokenCrew23 public immutable candy;
    RespectTokenCrew23 public immutable respect;
    CrewTokenCrew23 public immutable crew;

    mapping (address=>uint) public respectCount;
    mapping (address=>uint) public timestamp;

    constructor(address candyAddress, address respectAddress, address crewAddress){
        candy = CandyTokenCrew23(candyAddress);
        respect = RespectTokenCrew23(respectAddress);
        crew = CrewTokenCrew23(crewAddress);
    }

    function verification() public payable{  // 1 CrewToken -> 10 CandyToken
        require(crew.balanceOf(msg.sender)==1, "You don't have crew tokens to verify");
        require(crew.allowance(msg.sender, address(this))==1, "You need to approve the contract to transfer crew tokens");
        
        crew.transferFrom(msg.sender, address(this), 1);

        candy.mint(msg.sender, 10);
    }

    function buyCandies(uint _respectCount) public payable{ // RespectToken -> CandyToken, respectCount up
        require(_respectCount!=0, "You need to donate respect to buy candies");
        require(respect.balanceOf(msg.sender)>=_respectCount, "You don't have enough respect");
        require(respect.allowance(msg.sender, address(this))>=_respectCount, "You need to approve the contract to transfer respect");

        respectCount[msg.sender] += _respectCount;
        respect.transferFrom(msg.sender, address(this), _respectCount);
        timestamp[msg.sender] = block.timestamp;

        candy.mint(msg.sender, _respectCount);
    }

    function respectIncreasesWithTime() public { // 1 day to increase RespectToken by respectCount
        require(timestamp[msg.sender]!=0, "You need to buy candies first");
        require(block.timestamp-timestamp[msg.sender]>=1 days, "You need to wait 1 day to gain respect again");

        timestamp[msg.sender] = block.timestamp;
        uint reward = respectCount[msg.sender]/10;
        respectCount[msg.sender] += reward;
        respect.mint(msg.sender, reward); // not owner, will revert
    }

    function sellCandies(uint _candyCount) public payable{ // CandyToken -> RespectToken
        require(_candyCount!=0, "You need to sell at least 1 candy");
        require(candy.balanceOf(msg.sender)>=_candyCount, "You don't have enough candies");
        require(candy.allowance(msg.sender, address(this))>=_candyCount, "You need to approve the contract to transfer candies");

        candy.burn(address(msg.sender), _candyCount);

        respectCount[msg.sender] -= _candyCount;
        respect.transfer(msg.sender, _candyCount);
    }
}