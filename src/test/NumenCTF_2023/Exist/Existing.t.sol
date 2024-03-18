// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;
pragma experimental ABIEncoderV2;

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "src/NumenCTF_2023/Exist/Existing.sol";

contract Attacker is Test, Script {
    address deployer = makeAddr("deployer");
    uint256 attacker_key = vm.envUint("ATTACKER_KEY");
    address attacker = vm.addr(0xfbe28e86d49d3155523d059df9a44ef8390a8779757e41149b44aa7eb75cf33e);
    // address 0xd41BC63873Be128dabaf5207847B7f3368455a54  suffix:0x5a54

    Existing e;

    function setUp() public {
        vm.createSelectFork("mainnet");
        vm.startPrank(deployer, deployer);

        e = new Existing();

        vm.stopPrank();
        console2.log("setUp done!");
    }

    function testExploit() public {
        vm.startPrank(attacker, attacker);

        solve();
        console.log("isSolved:", e.isSolved());
        vm.stopPrank();
    }

    function solve() public {
        e.share_my_vault();
        e.setflag();
    }
}




