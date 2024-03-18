// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "./XYZAttack.sol";

contract Attacker is Test, Script {
    address deployer = makeAddr("deployer");
    uint256 attacker_key = vm.envUint("ATTACKER_KEY");
    address attacker = vm.addr(attacker_key);

    Challenge challenge;

    function setUp() public {
        vm.createSelectFork("mainnet");
        vm.startPrank(deployer, deployer);
        deal(attacker, 1 ether);

        Token sETH = new Token(deployer, "sETH");
        Manager manager = new Manager();
        Token XYZ = manager.xyz();
        challenge = new Challenge(XYZ, sETH, manager);
        manager.addCollateralToken(IERC20(address(sETH)), new PriceFeed(), 20_000_000_000_000_000 ether, 1 ether);

        sETH.mint(deployer, 2 ether);
        sETH.approve(address(manager), type(uint256).max);
        manager.manage(sETH, 2 ether, true, 3395 ether, true);

        (, ERC20Signal debtToken,,,) = manager.collateralData(IERC20(address(sETH)));
        manager.updateSignal(debtToken, 3520 ether);

        sETH.mint(attacker, 6000 ether);

        vm.stopPrank();
        console2.log("setUp done!");
    }

    // forge test --contracts .\src\test\TemplateCTF\template.t.sol -vvv
    function testExploit() public {
        // Call the solver's function with the attacker identity to test
        vm.startPrank(attacker, attacker);

        solve();
        console.log("isSolved:", challenge.isSolved());

        vm.stopPrank();
    }

    function solve() public {
        XYZAttack attacker = new XYZAttack(challenge, deployer);
        Token sETH = challenge.seth();
        // Token(challenge.sETH()).sender(address(attacker));
        attacker.solve();
    
    }

    // forge script .\src\test\TemplateCTF\template.t.sol:Attacker --slow --skip-simulation --broadcast
    function run() public {
        // Broadcast transactions, similar to tests, just need set the actual address of the instance.
        vm.startBroadcast(attacker_key);
        console2.log(address(0x2d4C0a9bE173BF972314942bb953e5210B5e45f0).balance);
        challenge = Challenge(0x773dB58920450822F28A6061178413E4B7c153E7);
        solve();
        console.log("isSolved:", challenge.isSolved());
        
        vm.stopBroadcast();
    }
}


