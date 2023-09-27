// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "./StakingPool.sol";
import "./Insurance.sol";


contract EthStakingMetaTrust23 {
  EthStakingPool public pool;
  InsuranceMetaTrust23 public insurance;

  constructor() payable {
    require(msg.value == 10 ether);

    insurance = new InsuranceMetaTrust23();
    pool = new EthStakingPool(msg.sender, address(insurance));
    (bool success,) = payable(insurance).call{value: msg.value}("");
    require(success);
  }

  function isSolved() external view returns (bool) {
    if (address(insurance).balance == 0) {
      return true;
    } else {
      return false;
    }
  }
}
