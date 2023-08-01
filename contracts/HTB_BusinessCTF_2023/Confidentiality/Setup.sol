// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import {AccessTokenHTBBusiness23} from "./AccessToken.sol";

contract SetupATHTBBusiness23 {
    AccessTokenHTBBusiness23 public immutable TARGET;

    constructor(address _owner, bytes memory signature) {
        TARGET = new AccessTokenHTBBusiness23(_owner);

        // Secure 1 AccessToken for myself
        TARGET.safeMintWithSignature(signature, address(this));
    }

    function isSolved(address _player) public view returns (bool) {
        return TARGET.balanceOf(_player) > 0;
    }
}
