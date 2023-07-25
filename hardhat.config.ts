import { HardhatUserConfig, task } from "hardhat/config";
import { HardhatNetworkUserConfig, NetworkUserConfig, HardhatNetworkAccountUserConfig } from "hardhat/types";
import "@nomicfoundation/hardhat-toolbox";

import { config as dotenvConfig } from "dotenv";
import { readdirSync } from "fs";
import { resolve, join } from "path";
import { execSync } from "child_process";
import chalk from "chalk";

dotenvConfig({ path: resolve(__dirname, "./.env") });  // Loads .env file contents into process.env.


const PRIVATE_KEY1 = process.env.PRIVATE_KEY1 || "";
const PRIVATE_KEY2 = process.env.PRIVATE_KEY2 || "";
const RPC_URL = process.env.RPC_URL || "";

function createNetConfig(): NetworkUserConfig {
  const url: string = RPC_URL;
  return {
    accounts: [PRIVATE_KEY1, PRIVATE_KEY2],
    url: url,
  };
}

function createLocalnetConfig(): HardhatNetworkUserConfig {
  const accounts: HardhatNetworkAccountUserConfig[] = [
    {
      privateKey: PRIVATE_KEY1,
      balance: "10000000000000000000000",    // 10000 eth
    },
    {
      privateKey: PRIVATE_KEY2,
      balance: "10000000000000000000",      // 10 eth
    },
    ];
  return {
    allowUnlimitedContractSize: true,
    // blockGasLimit: 80000000,
    accounts: accounts,
    forking: {
      enabled: true,
      url: "https://rpc.sepolia.org/",
      // url: RPC_URL,
    }
  }
}

const config: HardhatUserConfig = {
  defaultNetwork: "hardhat",
  networks: {
    hardhat: createLocalnetConfig(),
    remote: createNetConfig(),
  },
  solidity: {
    compilers: [
      { version: "0.5.17" },
      { version: "0.6.12" },
      { version: "0.7.6" },
      { version: "0.8.0" },
      { version: "0.8.12" },
      { version: "0.8.15" },
      { version: "0.8.16" },
      { version: "0.8.17" },
      { version: "0.8.18" },
    ],
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000,
      },
    },
  },
  
  etherscan: {
    //apiKey: ETHERSCAN_API_KEY,
  },
  gasReporter: {
    currency: "USD",
    gasPrice: 100,
    // enabled: process.env.REPORT_GAS ? true : false,
  },
  typechain: {
    outDir: "typechain",
    target: "ethers-v6",
  },
};


task('run-all', 'Run all scripts to test')
  .setAction(async (_, hre) => {
    const scriptsDir = join(__dirname, 'scripts');
    const contestDirs = readdirSync(scriptsDir, { withFileTypes: true })
      .filter((dirent: { isDirectory: () => any; }) => dirent.isDirectory())
      .map((dirent: { name: any; }) => dirent.name);

    const errorLogs = [];

    for (const contestDir of contestDirs) {
      console.log(`${chalk.green("[-] Start ")}`+ contestDir);
      const contestDirPath = join(scriptsDir, contestDir);
      const scriptFiles = readdirSync(contestDirPath).filter(file => file.endsWith('.ts'));
      for (const file of scriptFiles) {
        try {
          execSync(`npx hardhat run ${join(contestDirPath, file)}`, {stdio: "ignore"});
          console.log(`${chalk.green("[-] ")}`+file+` ${chalk.green("pass")}`);
        } catch (error) {
          errorLogs.push({ contestDir, file, error });
        }
      }
    }

    if (errorLogs.length > 0) {
      console.log(`${chalk.red("[x] ")}Errors occurred while executing the following scripts:`);
      for (const { contestDir, file, error } of errorLogs) {
        console.log(`${chalk.red("[x] ")}Contest: ${contestDir}, Script: ${chalk.red(file)}`);
      }
    } else {
      console.log(`${chalk.green("[-] ")}All scripts executed successfully!`);
    }
  });


export default config;