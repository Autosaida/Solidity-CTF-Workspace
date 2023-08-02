// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { VotingHTBBusiness23 } from "./Voting.sol";

contract SetupVotingHTBBusiness23 {
    VotingHTBBusiness23 public immutable TARGET;

    constructor() payable {
        require(msg.value == 1 ether);
        TARGET = new VotingHTBBusiness23();
    }

    function isSolved() public view returns (bool) {
        // return (TARGET.WinningParty() == bytes3("UNZ"));
        // 0x1ee7b2d7
    }
}
