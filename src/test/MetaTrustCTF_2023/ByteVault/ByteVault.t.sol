// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "./BytecodeVaultAttack.sol";

contract Attacker is Test, Script {
    address deployer = makeAddr("deployer");
    uint256 attacker_key = vm.envUint("ATTACKER_KEY");
    address attacker = vm.addr(attacker_key);

    BytecodeVault vault;

    function setUp() public {
        vm.createSelectFork("mainnet");
        vm.startPrank(deployer, deployer);
        deal(deployer, 1 ether);

        vault = new BytecodeVault{value: 0.1 ether}();

        vm.stopPrank();
        console2.log("setUp done!");
    }

    function testExploit() public {
        vm.startPrank(attacker, attacker);

        solve();
        console.log("isSolved:", vault.isSolved());
        vm.stopPrank();
    }

    function solve() public {
        BytecodeVaultAttack attack = new BytecodeVaultAttack();
        attack.attack(address(vault));
        
    }
}


