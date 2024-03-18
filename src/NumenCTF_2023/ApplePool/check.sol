// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./UniswapV2Factory.sol";
import "./AppleToken.sol";
import "./AppleRewardPool.sol";

contract ApplePoolCheck {
    AppleToken public token0 = new AppleToken(10000 * 10 ** 18);
    AppleToken public token1 = new AppleToken(20000 * 10 ** 18);
    AppleToken public token2 = new AppleToken(20000 * 10 ** 18);
    AppleToken public token3 = new AppleToken(10000 * 10 ** 18);
    UniswapV2Factory public factory = new UniswapV2Factory(address(this));
    AppleRewardPool public appleRewardPool;
    address public pair1;
    address public pair2;
    uint256 public starttime = block.timestamp;
    uint256 public endtime = block.timestamp + 90 days;
    constructor() {
        pair1 = factory.createPair(address(token0),address(token1));
        token0.transfer(pair1,10000 * 10 ** 18);
        token1.transfer(pair1,10000 * 10 ** 18);        
        UniswapV2Pair(pair1).mint(address(this));   // pair: token0 - token1 10000:10000
        pair2 = factory.createPair(address(token1),address(token2));
        token1.transfer(pair2,10000 * 10 ** 18);
        token2.transfer(pair2,10000 * 10 ** 18);
        UniswapV2Pair(pair2).mint(address(this));   // pair: token1 - token2 10000:10000
        appleRewardPool = new AppleRewardPool(IERC20(address(token2)),IERC20(address(token3)),address(pair1),address(pair2));
        token2.transfer(address(appleRewardPool),10000 * 10 ** 18);  
        token3.transfer(address(appleRewardPool),10000 * 10 ** 18);  
        appleRewardPool.addPool(IERC20(address(token1)),starttime, endtime,0,false);
        appleRewardPool.addPool(IERC20(address(token2)),starttime, endtime,0,false);  // pool: token2: 10000 token3:10000
    }
        
    function isSolved()  public view returns(bool){

        if(token3.balanceOf(address(appleRewardPool)) == 0){  // steal token3
           return  true;
        }
        return false;
    }
}


// core: deposit function (withdraw function is independent of token3, reclaimAppleStakingReward does not need to be considered as it involving rewards)

// player has no token, so we should use uniswap's flashswap

// start
// pair1: token0 - token1 10000:10000
// pair2: token1 - token2 10000:10000
// applePool: token2:10000 token3:10000
// target: get token3 from appleRewardPool

// loan token0/token1/token2
// deposit: token1(token0/token1) -> token2    token2(token2/token1/2) -> token3

// plan 1 do not work
// loan:9999 token1 reserve: 1 token1
// 1 token1 -> 10000 token2 (from ApplePool)
// 9999 token2 transfer to pair (19999 token2, 10000 token1 (could be lower))
// 1: 19999/1/2 = 9999, not all token3, 2：rate1 use reserves, can not exploit flashswap to decrease token1

// plan 2
// loan:9999 token1 reserve: 1 token1
// 1 token1 -> 10000 token2 (from ApplePool)
// withdraw and repay, now we have 10000 token2
// swap token2 for token1 (increase token2 and decrease token1)
// swap 5000 token2 for 3333 token1 (10000*10000/15000=6666.66, 10000-6667=3333)
// now price: token2/token1/2 = 15000/6667/2 = 1
// deposit 5000 token2 to get 5000 token3 twice