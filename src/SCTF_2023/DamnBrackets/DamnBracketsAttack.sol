// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;
import "./DamnBrackets.sol";
import "forge-std/console2.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";

// solution a: 207 bytes
contract DamnBracketsAttack1 {
    mapping(uint=>uint) private checker;
    uint public num;
    constructor(){
        checker[0x287b7d7b7d290000000000000000000000000000000000000000000000000000]=0x100000000000000000000000000000000000000000000000000000000000000;
        checker[0x5b5d7b287d5d285d292929000000000000000000000000000000000000000000]=0x0;
        checker[0x7b7d7b5b5d7d0000000000000000000000000000000000000000000000000000]=0x100000000000000000000000000000000000000000000000000000000000000;
        checker[0x28287b29295d28285b7b00000000000000000000000000000000000000000000]=0x0;
        checker[0x28297b2828292829282800000000000000000000000000000000000000000000]=0x0;
        checker[0x7b7b2829285b5d00000000000000000000000000000000000000000000000000]=0x0;
        checker[0x287b7d7d7b282800000000000000000000000000000000000000000000000000]=0x0;
        checker[0x7d287b5b5d285d7b7d285b7d287b000000000000000000000000000000000000]=0x0;
        checker[0x282829297b7d0000000000000000000000000000000000000000000000000000]=0x100000000000000000000000000000000000000000000000000000000000000;
        checker[0x5b28295d28290000000000000000000000000000000000000000000000000000]=0x100000000000000000000000000000000000000000000000000000000000000;
        checker[0x28285b5d29290000000000000000000000000000000000000000000000000000]=0x100000000000000000000000000000000000000000000000000000000000000;
        checker[0x295b7b7b7d285d28000000000000000000000000000000000000000000000000]=0x0;
        checker[0x29295d5b7b5d5d7d000000000000000000000000000000000000000000000000]=0x0;
        checker[0x28297b7d28290000000000000000000000000000000000000000000000000000]=0x100000000000000000000000000000000000000000000000000000000000000;
        checker[0x7b7d5b7b7d5d0000000000000000000000000000000000000000000000000000]=0x100000000000000000000000000000000000000000000000000000000000000;
        checker[0x5d285d295d7d7b5d29287d7d7d29000000000000000000000000000000000000]=0x0;
        checker[0x7b7d7b7d5b5d0000000000000000000000000000000000000000000000000000]=0x100000000000000000000000000000000000000000000000000000000000000;
        checker[0x7d7d28295d287d5d5d5b7b282800000000000000000000000000000000000000]=0x0;
        checker[0x2828282929290000000000000000000000000000000000000000000000000000]=0x100000000000000000000000000000000000000000000000000000000000000;
        checker[0x5b297d5b285d5d29285b29000000000000000000000000000000000000000000]=0x0;
        checker[0x7d5d5d287d7b2900000000000000000000000000000000000000000000000000]=0x0;
        checker[0x5b5d7b28297d0000000000000000000000000000000000000000000000000000]=0x100000000000000000000000000000000000000000000000000000000000000;
        checker[0x2829282928290000000000000000000000000000000000000000000000000000]=0x100000000000000000000000000000000000000000000000000000000000000;
        checker[0x285b5b7b7d5d5d7b7d2900000000000000000000000000000000000000000000]=0x100000000000000000000000000000000000000000000000000000000000000;
        checker[0x297b5d285b5d2900000000000000000000000000000000000000000000000000]=0x0;
        checker[0x5b295b5d287b0000000000000000000000000000000000000000000000000000]=0x0;
        checker[0x28297b5b5d7d0000000000000000000000000000000000000000000000000000]=0x100000000000000000000000000000000000000000000000000000000000000;
        checker[0x5b285d5d7d7b5d7d7b5d00000000000000000000000000000000000000000000]=0x0;
        checker[0x7b5b5d7b28297d7d000000000000000000000000000000000000000000000000]=0x100000000000000000000000000000000000000000000000000000000000000;
        checker[0x7b7d5d7d5d7d7b7b7b7b7b000000000000000000000000000000000000000000]=0x0;
        checker[0x7b287b7b7b5d7b5d5b5d5b5b0000000000000000000000000000000000000000]=0x0;
        checker[0x7b7d5b5d7b7d0000000000000000000000000000000000000000000000000000]=0x100000000000000000000000000000000000000000000000000000000000000;
    }

    fallback() external {
        assembly {
            // isValid("({}{})")
            // f1dfaefb
            // 0000000000000000000000000000000000000000000000000000000000000020
            // 0000000000000000000000000000000000000000000000000000000000000006
            // 287b7d7b7d290000000000000000000000000000000000000000000000000000
            let d := calldataload(0x44)
            mstore(0, d)
            mstore(0x20, checker.slot)
            let pos := keccak256(0, 0x40)
            let v := sload(pos)
            mstore(0, v)
            return(0, 0x20)
        }
    }
}

// solution b
contract DamnBracketsAttack2 {

    address public proxyAddress;

    function clone(address implementation) public {
        proxyAddress = Clones.clone(implementation);
    }

    function isValid(string memory brackets) external pure returns(uint value) {
        bytes memory bracketsBytes = bytes(brackets);
        uint256 length = bracketsBytes.length;

        if (length % 2 != 0) {
            return 0;
        }

        bytes32[] memory stack = new bytes32[](length / 2);
        uint256 stackSize = 0;

        for (uint256 i = 0; i < length; i++) {
            bytes1 bracket = bracketsBytes[i];

            if (bracket == '(' || bracket == '[' || bracket == '{') {
                stack[stackSize] = bytes32(bracket);
                stackSize++;
            } else if (bracket == ')' || bracket == ']' || bracket == '}') {
                if (stackSize == 0) {
                    return 0;
                }

                bytes32 topBracket = stack[stackSize - 1];
                if (
                    (bracket == ')' && topBracket == '(') ||
                    (bracket == ']' && topBracket == '[') ||
                    (bracket == '}' && topBracket == '{')
                ) {
                    stackSize--;
                } else {
                    return 0;
                }
            }
        }
        return stackSize == 0 ? 1<<0xf8:0;
    }
}