# Solidity-CTF-Workspace

This repository contains my personal workspace and solutions to Solidity-based CTF blockchain challenges, which are typically deployed using the [SolidCTF](https://github.com/chainflag/solidctf) framework or other ways. Please note that the solutions provided are intended solely for reference purposes.

## Usage

If you wish to make use of this workspace and explore the solutions, follow these steps:

1. Clone the repository:

   ```bash
   git clone https://github.com/Autosaida/Solidity-CTF-Workspace.git
   ```

2. Install the dependencies:

   ```bash
   cd Solidity-CTF-Workspace
   npm install
   ```

The **contracts** directory contains blockchain challenges and the corresponding solution contracts. The **scripts** directory includes interactive scripts, where `template.ts` can serve as a reference for creating your own scripts, simply replacing the contract name and target address accordingly.

If you want to simulate challenges more realistically, you can refer to [SolidCTF](https://github.com/chainflag/solidctf) and [solidity-ctf-template](https://github.com/chainflag/solidity-ctf-template) to deploy the challenges on a server.

To test locally, use the following command:

```bash
hh run ./scripts/Challenge.ts
```

By default, this command will fork the remote network. You could deploy the target challenge contract in the script. 

To solve the challenge and interact with it remotely, use the following command:

```bash
hh run ./scripts/Challenge.ts --network remote
```

Note: Before interacting with the challenge remotely, make sure to correctly fill in the RPC endpoint in the `.env` file.

Feel free to customize the settings by modifying the `hardhat.config.ts` file.

forge test --contracts .\src\test\TemplateCTF\template.t.sol -vvv
forge script .\src\test\TemplateCTF\template.t.sol:Exploiter --slow --skip-simulation --broadcast