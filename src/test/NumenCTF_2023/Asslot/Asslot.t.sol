// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "src/NumenCTF_2023/Asslot/Asslot.sol";
import "./AsslotAttack.sol";

contract Attacker is Test, Script {
    address deployer = makeAddr("deployer");
    uint256 attacker_key = vm.envUint("ATTACKER_KEY");
    address attacker = vm.addr(attacker_key);

    Asslot asslot;

    function setUp() public {
        vm.createSelectFork("mainnet");
        vm.startPrank(deployer, deployer);

        asslot = new Asslot();

        vm.stopPrank();
        console2.log("setUp done!");
    }

    function testExploit() public {
        vm.startPrank(attacker, attacker);

        solve();
        // console.log("isSolved:", asslot.isSolved());
        vm.stopPrank();
    }

    function solve() public {
        AsslotAttack attack = new AsslotAttack();
        attack.clone();
        AsslotAttack(attack.proxyAddress()).solve{gas: 300000}(address(asslot));
    }
}


