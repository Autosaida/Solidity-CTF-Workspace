// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "./StakingPool.sol";
import "./Insurance.sol";


contract EthStaking {
  EthStakingPool public pool;
  Insurance public insurance;

  constructor() payable {
    require(msg.value == 10 ether);

    insurance = new Insurance();
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
