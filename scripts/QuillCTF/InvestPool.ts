import chalk from "chalk";
import { ethers } from "hardhat";
import { InvestPoolQuill__factory, InvestPoolQuill } from "../../typechain";
import { log, initialize } from "../utils";


async function main() {
    // password: cast storage 0xA45aC53E355161f33fB00d3c9485C77be3c808ae --rpc-url https://rpc.ankr.com/eth_goerli
    let [investPoolQuillContract, attacker] = await initialize<InvestPoolQuill>(InvestPoolQuill__factory);
    

    log(`Is solved: ${chalk.yellow()}`);
    
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});