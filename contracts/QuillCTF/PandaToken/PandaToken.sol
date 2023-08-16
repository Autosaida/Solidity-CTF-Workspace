// SPDX-License-Identifier: MIT

pragma solidity ^0.8;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

contract PandaTokenQuill is ERC20, Ownable {
    uint public c1;         // slot 6
    mapping(bytes => bool) public usedSignatures;   // slot 7
    mapping(address => uint) public burnPending;    // slot 8 
    event show_uint(uint u);

    function sMint(uint amount) external onlyOwner {
        _mint(msg.sender, amount);
    }

    constructor(
        uint _c1,
        string memory tokenName,
        string memory tokenSymbol
    ) ERC20(tokenName, tokenSymbol) {
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, sload(mul(1, 110)))
            mstore(add(ptr, 0x20), 0)
            let slot := keccak256(ptr, 0x40)
            sstore(slot, exp(10, add(4, mul(3, 5))))  // slot <- 10 eth
            mstore(ptr, sload(5))      // owner
            sstore(6, _c1)           
            mstore(add(ptr, 0x20), 0)   // slot0 balance
            let slot1 := keccak256(ptr, 0x40)  // balance[owner]
            mstore(ptr, sload(7))
            mstore(add(ptr, 0x20), 0)
            sstore(slot1, mul(sload(slot), 2))  // balance[owner] = 20 eth
        }
    }

    function calculateAmount(
        uint I1ILLI1L1ILLIL1LLI1IL1IL1IL1L
    ) public view returns (uint) {
        uint I1I1LI111IL1IL1LLI1IL1IL11L1L;
        assembly {
            let I1ILLI1L1IL1IL1LLI1IL1IL11L1L := 2
            let I1ILLILL1IL1IL1LLI1IL1IL11L1L := 1000
            let I1ILLI1L1IL1IL1LLI1IL1IL11L11 := 14382
            let I1ILLI1L1IL1ILLLLI1IL1IL11L1L := 14382
            let I1LLLI1L1IL1IL1LLI1IL1IL11L1L := 599
            let I1ILLI111IL1IL1LLI1IL1IL11L1L := 1
            I1I1LI111IL1IL1LLI1IL1IL11L1L := div(
                mul(
                    I1ILLI1L1ILLIL1LLI1IL1IL1IL1L,
                    I1ILLILL1IL1IL1LLI1IL1IL11L1L
                ),
                add(
                    I1LLLI1L1IL1IL1LLI1IL1IL11L1L,
                    add(I1ILLI111IL1IL1LLI1IL1IL11L1L, sload(6))
                )
            )
        }

        return I1I1LI111IL1IL1LLI1IL1IL11L1L;
    }

    function getTokens(uint amount, bytes memory signature) external {  
        uint giftAmount = calculateAmount(amount);
        bytes32 msgHash = keccak256(abi.encode(msg.sender, giftAmount));
        bytes32 r;
        bytes32 s;
        uint8 v;

        // 1. do not check sig' length
        // 2. signature malleability
        assembly {
            r := mload(add(signature, 0x20))
            s := mload(add(signature, 0x40))
            v := byte(0, mload(add(signature, 0x60)))
        }
        address giftFrom = ecrecover(msgHash, v, r, s);
        burnPending[giftFrom] += amount;
        require(amount == 1 ether, "amount error");
        require(
            (balanceOf(giftFrom) - burnPending[giftFrom]) >= amount,
            "balance"
        );
        require(!usedSignatures[signature], "used signature");
        usedSignatures[signature] = true;
        _mint(msg.sender, amount);
    }

    function burnPendings(address burnFrom) external onlyOwner {
        burnPending[burnFrom] = 0;
        _burn(burnFrom, burnPending[burnFrom]);
    }

    function isSolved() public view returns(bool) {
        return balanceOf(msg.sender) == 3 ether;
    }
}