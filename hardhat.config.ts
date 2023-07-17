import { HardhatUserConfig } from "hardhat/config";
import { HardhatNetworkUserConfig, NetworkUserConfig, HardhatNetworkAccountUserConfig } from "hardhat/types";
import "@nomicfoundation/hardhat-toolbox";

import { config as dotenvConfig } from "dotenv";
import { resolve } from "path"
dotenvConfig({ path: resolve(__dirname, "./.env") });  // Loads .env file contents into process.env.


const PRIVATE_KEY1 = process.env.PRIVATE_KEY1 || "";
const PRIVATE_KEY2 = process.env.PRIVATE_KEY2 || "";
const PRIVATE_KEY3 = process.env.PRIVATE_KEY3 || "";
const RPC_URL = process.env.RPC_URL || "";

function createNetConfig(): NetworkUserConfig {
  const url: string = RPC_URL;
  return {
    accounts: [PRIVATE_KEY1, PRIVATE_KEY2, PRIVATE_KEY3],
    url: url,
  };
}

function createLocalnetConfig(): HardhatNetworkUserConfig {
  const accounts: HardhatNetworkAccountUserConfig[] = [
    // 10 eth
    {
      privateKey: PRIVATE_KEY1,
      balance: "10000000000000000000",
    },
    {
      privateKey: PRIVATE_KEY2,
      balance: "10000000000000000000",
    },
    {
      privateKey: PRIVATE_KEY3,
      balance: "10000000000000000000",
    },
    ];
  return {
    allowUnlimitedContractSize: true,
    // blockGasLimit: 80000000,
    accounts: accounts,
    forking: {
      url: "https://rpc.sepolia.org/",
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

export default config;