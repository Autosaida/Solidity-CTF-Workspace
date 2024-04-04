# Solidity-CTF-Workspace

This repository contains my personal workspace and solutions to Solidity-based CTF blockchain challenges. Please note that the solutions provided are intended solely for reference purposes.

The **src** directory contains blockchain challenges, while the **src/test** directory includes scripts for solving these challenges. The `template.t.sol` can serve as a reference for creating your own scripts, simply replacing the contract name and target address accordingly.

To test locally, use the following command:

```bash
forge test --contracts .\src\test\TemplateCTF\template.t.sol -vvv
```

To solve the challenge and interact with it remotely, use the following command:

```bash
forge script --contracts .\src\test\TemplateCTF\templateScript.t.sol --slow .\src\test\TemplateCTF\templateScript.t.sol --broadcast
```

Note: Before interacting with the challenge remotely, make sure to correctly fill in the RPC endpoint.

## 2024

### [EthernautCTF](src/EthernautCTF_2024/)

| Challenge  | Keyword   |
|--------------------|-------------------|
| [SpaceBank](src/EthernautCTF_2024/SpaceBank/) | Precision Loss; Create2; Selfdestruct  |
| [WomboCombo](src/EthernautCTF_2024/WomboCombo/) | ERC-2771: Trusted Forwarder  |
| [AlienSpaceship](src/EthernautCTF_2024/AlienSpaceship/) | Bytecode Reverse Engineering; Logic Puzzle  |
| [XYZ](src/EthernautCTF_2024/XYZ/) | Precision Loss; Logic Puzzle  |

## 2023

### [MetaTrustCTF](src/MetaTrustCTF_2023/)

| Challenge  | Keyword   |
|--------------------|-------------------|
| [GreeterVault](src/MetaTrustCTF_2023/GreeterVault/) | Delegatecall  |
| [GreeterGate](src/MetaTrustCTF_2023/GreeterGate/) | Storage Layout  |
| [GuessGame](src/MetaTrustCTF_2023/GuessGame/) | Immutable Variables; Precompiled Contracts  |
| [Registry](src/MetaTrustCTF_2023/Registry/) | Reentrancy  |
| [Who](src/MetaTrustCTF_2023/Who) |  Special Address; Gas Puzzle; Storage Layout  |
| [ByteVault](src/MetaTrustCTF_2023/ByteVault/) | EVM Bytecode Constraints  |
| [ByteDance](src/MetaTrustCTF_2023/ByteDance/) | EVM Bytecode Constraints; Delegatecall   |
| [DeFiMaze](src/MetaTrustCTF_2023/DeFiMaze/) | Logic Puzzle   |
| [Achilles](src/MetaTrustCTF_2023/DeFiMaze/) | Logic Puzzle; UniswapV2   |
| [StakingPool](src/MetaTrustCTF_2023/StakingPool/) | Logic Puzzle   |
| [EthStaking](src/MetaTrustCTF_2023//EthStaking/) | Logic Puzzle   |


### [SekaiCTF](src/SekaiCTF_2023/)

| Challenge  | Keyword   |
|--------------------|-------------------|
| [Re-Remix](src/SekaiCTF_2023/ReRemix/) | Signature Malleability; Storage Layout; Read-Only Reentrancy  |

### [HTB Business CTF](src/HTB_BusinessCTF_2023/)

| Challenge  | Keyword   |
|--------------------|-------------------|
| [Confidentiality](src/HTB_BusinessCTF_2023/Confidentiality/) | Signature Malleability  |
| [Funds Secured](src/HTB_BusinessCTF_2023/FundsSecured/) | Missing Length Check  |

### [CrewCTF](src/CrewCTF_2023/)

| Challenge  | Keyword   |
|--------------------|-------------------|
| [positive](src/CrewCTF_2023/Positive/) | Integer Overflow |
| [infinite](src/CrewCTF_2023/Infinite/) | Logic Puzzle |
| [deception](src/CrewCTF_2023/Deception/) | Bytecode Reverse Engineering |

### [SCTF](src/SCTF_2023/)

| Challenge  | Keyword   |
|--------------------|-------------------|
| [damn brackets](src/SCTF_2023/DamnBrackets/) | EVM Bytecode Golf  |

### [SEETF](src/SEETF_2023/)

| Challenge  | Keyword   |
|--------------------|-------------------|
| [Murky Seepass](src/SEETF_2023/MurkySeepass/) | Missing Length Check  |
| [Operation Feathered](src/SEETF_2023/OperationFeathered/) | abi.encodePacked Collisions |
| [Pigeon Bank](src/SEETF_2023/PigeonBank/) | Reentrancy  |
| [Pigeon Vault](src/SEETF_2023/PigeonVault/) | Governance; ERC-2535: Diamonds Proxy; Missing Signature Verification |


### [D^3CTF](src/D3CTF_2023/)

| Challenge  | Keyword   |
|--------------------|-------------------|
| [d3casino](src/D3CTF_2023/d3casino/) |  EVM Bytecode Golf; Special Address  |

### [NumenCTF](src/NumenCTF_2023/)

| Challenge  | Keyword   |
|--------------------|-------------------|
| [Counter](src/NumenCTF_2023/Counter/) |  EVM Bytecode Golf; Delegatecall  |
| [SimpleCall](src/NumenCTF_2023/SimpleCall/) |  Integer Overflow; Reentrancy  |
| [LittleMoney](src/NumenCTF_2023/LittleMoney/) |  EVM Bytecode Golf; Delegatecall; Bytecode Reverse Engineering  |
| [Exist](src/NumenCTF_2023/Exist/) | Special Address |
| [HEXP](src/NumenCTF_2023/HEXP/) | Bytecode Reverse Engineering |
| [Asslot](src/NumenCTF_2023/Asslot/) | EVM Bytecode Golf; Gas Puzzle |
| [LenderPool](src/NumenCTF_2023/LenderPool/) | Reentrancy |
| [GOATFinance](src/NumenCTF_2023/GOATFinance/) | Logic Puzzle |
| [Wallet](src/NumenCTF_2023/Wallet/) | Head Overflow Bug |
| [ApplePool](src/NumenCTF_2023/ApplePool/) | Price Manipulation; UniswapV2 |

