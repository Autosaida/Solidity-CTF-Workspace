// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VaultLogicMetaTrust23 {

  address payable public owner;
  bytes32 private password; // useless

  constructor(bytes32 _password) {
    owner = payable(msg.sender);
    password = _password;
  }

  function changeOwner(bytes32 _password, address payable newOwner) public {
      if (password == _password) {
        owner = newOwner;
    } 
  }

 function withdraw() external {
    if (owner == msg.sender) {
          owner.transfer(address(this).balance);
    }
  }

}

contract Vault {

  address public owner;
  VaultLogicMetaTrust23 logic; // real password

  constructor(address _logicAddress) payable {
    logic = VaultLogicMetaTrust23(_logicAddress);
    owner = msg.sender;
  }

  fallback() external {
    (bool result,) = address(logic).delegatecall(msg.data);
    if (result) {
      this;
    }
  }

   receive() external payable {}
}

contract GreeterVaultSetUpMetaTrust23 {
    address public logic;
    
    address payable public vault;


    constructor(bytes32 _password) payable {
        VaultLogicMetaTrust23 logicCon = new VaultLogicMetaTrust23(_password);
        logic = address(logicCon);
        Vault vaultCon = new Vault(logic);
        vault = payable(address(vaultCon));
        (bool success, ) = vault.call{value: 1 ether}("");
        require(success);
    }

    function isSolved() public view returns(bool) {
        return vault.balance == 0;
    }
}

