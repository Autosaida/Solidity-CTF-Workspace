// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;
import "./Vault.sol";
import "hardhat/console.sol";

contract DeFiPlatform {
    address private owner;
    address public vaultAddress;
    uint256 private constant RATIO = 10**18;
    mapping(address => uint256) public deposits;
    mapping(address => bool) private yieldCalculated;

    constructor() {
        owner = msg.sender;
    }

    function setVaultAddress(address vault) external {
        require(msg.sender == owner, "No permissions!");
        vaultAddress = vault;
    }

    function depositFunds(uint256 amount) external payable {
        require(msg.value == amount, "Incorrect Ether sent");
        deposits[msg.sender] += amount;
    }

    function calculateYield(uint256 principal, uint256 rate, uint256 time) external returns (uint256) {
        uint256 yieldAmount;
        assembly {
            // r = rate/100+1e18
            let r := add(div(rate, 100), RATIO)  
            // t = 0x100000000000000000000000000000000**(time*0x10000000000000000)  time=0 -> 1 else 0
            let t := exp(0x100000000000000000000000000000000, mul(time, 0x10000000000000000))
            //    principal*(rate/100+1e18) * (type(uint256).max - 1e18) / 1e36
            yieldAmount := div(mul(mul(principal, r), sub(t, RATIO)), mul(RATIO, RATIO))
        }
        
        // yieldAmount == 0 
        deposits[msg.sender] += yieldAmount;
        yieldCalculated[msg.sender] = true;
        return yieldAmount;
    }

    function requestWithdrawal(uint256 amount) external {
        require(deposits[msg.sender] >= amount, "Insufficient funds");
        require(yieldCalculated[msg.sender], "You should calculateYield first"); 
        Vault vault = Vault(vaultAddress);
        vault.processWithdrawal(msg.sender, amount); // amount == 7 ether
    }
}