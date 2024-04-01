// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Token} from "./Token.sol";
import {Manager} from "./Manager.sol";
import "./PriceFeed.sol";
import "./ERC20Signal.sol";
import "./helpers/ProtocolMath.sol";

contract Challenge {
    Token public immutable xyz;
    Token public immutable seth;
    Manager public immutable manager;

    constructor(Token _xyz, Token _seth, Manager _manager) {
        xyz = _xyz;
        seth = _seth;
        manager = _manager;
    }

    function isSolved() external view returns (bool) {
        return xyz.balanceOf(address(0xCAFEBABE)) == 250_000_000 ether;
    }
}

// the only way to get/mint XYZ is the _updateDebt in manage
// need pass in enough debtDelta while maintaining health
// need get more protocolCollateralToken.balanceOf(attacker), less protocolDebtToken.balanceOf(attacker)
// precision loss in ERC20Signal mint -> divUp
// if the signal of protocolCollateralToken is very large, then minting 1 CollateralToken will still receive 1 ERC20, namely 1*Signal/e ERC20Signal.
// so 1 sETH -> 1*Signal/e CollateralToken -> 1697.7*Signal/e DebtToken -> 1697.7*Signal/e XYZ
