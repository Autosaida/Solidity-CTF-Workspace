// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @notice You can imagine this contract as candy
contract CandyTokenCrew23 is ERC20, Ownable{
  constructor() ERC20('candy', 'candy') {
    
  }
  function mint(address reciever, uint amount) external onlyOwner{
    _mint(reciever, amount);
  }
  function burn(address sender, uint amount) external onlyOwner{
    _burn(sender, amount);
  }
}