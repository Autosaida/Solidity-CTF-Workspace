import chalk from "chalk";
import { ethers } from "hardhat";
import { DeFiMazeSetUpMetaTrust23__factory, DeFiMazeSetUpMetaTrust23, DeFiMazeAttackMetaTrust23__factory} from "../../typechain";
import { log, initialize } from "../utils";

async function main() {
    let [DeFiMazeContract, attacker] = await initialize<DeFiMazeSetUpMetaTrust23>(DeFiMazeSetUpMetaTrust23__factory);
    let attackContract = await new DeFiMazeAttackMetaTrust23__factory(attacker).deploy();
    await attackContract.waitForDeployment();

    let tx = await attackContract.setUp(await DeFiMazeContract.getAddress());
    await tx.wait();
    tx = await attackContract.attack({value: ethers.parseEther("7")});
    await tx.wait();

    log(`Is solved: ${chalk.yellow(await DeFiMazeContract.isSolved())}`);

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});