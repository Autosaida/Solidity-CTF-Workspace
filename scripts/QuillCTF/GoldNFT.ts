import chalk from "chalk";
import { ethers } from "hardhat";
import { GoldNFTQuill__factory, GoldNFTQuill } from "../../typechain";
import { log, initialize } from "../utils";


async function main() {
    let [goldNFTQuillContract, attacker] = await initialize<GoldNFTQuill>(GoldNFTQuill__factory, undefined, [(await ethers.getSigners())[0]]);
    let address = await goldNFTQuillContract.getAddress();


    log(`Is solved: ${chalk.yellow(await goldNFTQuillContract.isSolved())}`);
    
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});