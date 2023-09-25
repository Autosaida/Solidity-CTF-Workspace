import chalk from "chalk";
import { ethers } from "hardhat";
import { GuessGameSetUpMetaTrust23__factory, GuessGameSetUpMetaTrust23, GuessGameAttackMetaTrust23__factory} from "../../typechain";
import { log, initialize } from "../utils";

async function main() {
    let [GuessGameSetUpContract, attacker] = await initialize<GuessGameSetUpMetaTrust23>(GuessGameSetUpMetaTrust23__factory);
    
    let attackContract = await new GuessGameAttackMetaTrust23__factory(attacker).deploy();
    await attackContract.waitForDeployment();
    let tx = await attackContract.attack(await GuessGameSetUpContract.getAddress(), {value: ethers.parseEther("1")});
    await tx.wait();
    
    log(`Is solved: ${chalk.yellow(await GuessGameSetUpContract.isSolved())}`);

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});