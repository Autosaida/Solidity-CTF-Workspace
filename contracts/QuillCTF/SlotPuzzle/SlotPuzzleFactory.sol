// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {SafeTransferLib} from "solmate/src/utils/SafeTransferLib.sol";
import {SlotPuzzleQuill} from "./SlotPuzzle.sol";
import {EnumerableSet} from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "./ISlotPuzzleFactory.sol";

contract SlotPuzzleFactoryQuill is ReentrancyGuard{
    using EnumerableSet for EnumerableSet.AddressSet;
    using SafeTransferLib for address;

    EnumerableSet.AddressSet deployedAddress;

    constructor() payable {
        require(msg.value == 3 ether);
    }

    function deploy(Parameters calldata params) external nonReentrant {
        SlotPuzzleQuill newContract = new SlotPuzzleQuill();

        deployedAddress.add(address(newContract));   
        newContract.ascertainSlot(params); 
    }

    function payout(address wallet,uint256 amount) external {   // slotPuzzle call it to get eth
        require(deployedAddress.contains(msg.sender));
        require(amount == 1 ether);
        wallet.safeTransferETH(amount);
    }   

    function isSolved() public view returns(bool) {
        return address(this).balance == 0;
    }
}