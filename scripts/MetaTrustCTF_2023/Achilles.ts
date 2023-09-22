import chalk from "chalk";
import { ethers } from "hardhat";
import { AchillesSetUpMetaTrust23__factory, AchillesSetUpMetaTrust23, AchillesAttackMetaTrust23__factory} from "../../typechain";
import { log, initialize } from "../utils";

async function main() {
    let [AchillesContract, attacker] = await initialize<AchillesSetUpMetaTrust23>(AchillesSetUpMetaTrust23__factory);
    let attackContract = await new AchillesAttackMetaTrust23__factory(attacker).deploy();
    await attackContract.waitForDeployment();
    let tx = await attackContract.attack(await AchillesContract.getAddress());
    await tx.wait();
    log(`Is solved: ${chalk.yellow(await AchillesContract.isSolved())}`);

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});