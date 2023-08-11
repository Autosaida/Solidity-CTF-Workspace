import chalk from "chalk";
import { ethers } from "hardhat";
import { ConfidentialQuill__factory, ConfidentialQuill } from "../../typechain";
import { log, initialize } from "../utils";
import {randomBytes} from "crypto";

async function main() {
    let [confidentialQuillContract, attacker] = await initialize<ConfidentialQuill>(ConfidentialQuill__factory);
    let address = await confidentialQuillContract.getAddress();
    let aliceHash = await ethers.provider.getStorage(address, 4);
    let bobHash = await ethers.provider.getStorage(address, 9);

    log(`Is solved: ${chalk.yellow(await confidentialQuillContract.checkthehash(await confidentialQuillContract.hash(aliceHash, bobHash)))}`);
    
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});