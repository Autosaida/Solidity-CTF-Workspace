// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "./NaryaRegistryAttack.sol";

contract Attacker is Test, Script {
    address deployer = makeAddr("deployer");
    uint256 attacker_key = vm.envUint("ATTACKER_KEY");
    address attacker = vm.addr(attacker_key);

    NaryaRegistry registry;

    function setUp() public {
        vm.createSelectFork("mainnet");
        vm.startPrank(deployer, deployer);
        deal(attacker, 1 ether);

        registry = new NaryaRegistry();

        vm.stopPrank();
        console2.log("setUp done!");
    }

    function testExploit() public {
        vm.startPrank(attacker, attacker);

        solve();
        // console.log("isSolved:", registry.isSolved());
        vm.stopPrank();
    }

    function solve() public {
        NaryaRegistryAttack attack = new NaryaRegistryAttack();
        attack.attack(address(registry));

    }
}


