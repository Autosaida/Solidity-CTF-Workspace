// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "./DeFiPlatform.sol";
import "./Vault.sol";

contract DeFiMazeSetUpMetaTrust23 {

    DeFiPlatform public platfrom;
    Vault public vault;

    constructor() {
        platfrom = new DeFiPlatform();
        vault = new Vault();
        platfrom.setVaultAddress(address(vault));
        vault.setPlatformAddress(address(platfrom));
    }

    function isSolved() public view returns(bool) {
        return vault.solved();
    }
}
