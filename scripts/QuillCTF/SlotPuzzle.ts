import chalk from "chalk";
import { ethers } from "hardhat";
import { SlotPuzzleFactoryQuill__factory, SlotPuzzleFactoryQuill, SlotPuzzleQuillAttack__factory } from "../../typechain";
import { log, initialize } from "../utils";


async function main() {
    let [slotPuzzleFactoryQuillContract, attacker] = await initialize<SlotPuzzleFactoryQuill>(SlotPuzzleFactoryQuill__factory, undefined, undefined, "3");
    let attackContract = await new SlotPuzzleQuillAttack__factory(attacker).deploy();
    await attackContract.waitForDeployment();

    let tx = await attackContract.attack(await slotPuzzleFactoryQuillContract.getAddress());
    await tx.wait();

    log(`Is solved: ${chalk.yellow(await slotPuzzleFactoryQuillContract.isSolved())}`);
    
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});