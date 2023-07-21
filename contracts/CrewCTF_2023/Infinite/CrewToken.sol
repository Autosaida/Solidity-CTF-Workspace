// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @notice A token to represent you are a part of the local crew
contract CrewTokenCrew23 is ERC20 {
  bool public claimed;
  address public receiver;
  constructor() ERC20('crew', 'crew') {
    claimed = false;
  }

  function mint() external {  // get 1 CrewToken
    require(!claimed , "already claimed");
    receiver = msg.sender;
    claimed = true;
    _mint(receiver, 1);
  }
}