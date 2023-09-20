import chalk from "chalk";
import { ethers } from "hardhat";
import { BytecodeVaultMetaTrust23__factory, BytecodeVaultMetaTrust23, BytecodeVaultAttackMetaTrust23__factory} from "../../typechain";
import { log, initialize } from "../utils";

async function main() {
    let [BytecodeVaultContract, attacker] = await initialize<BytecodeVaultMetaTrust23>(BytecodeVaultMetaTrust23__factory, undefined, undefined, "1");
    let attackContract = await new BytecodeVaultAttackMetaTrust23__factory(attacker).deploy();
    let tx = await attackContract.attack(await BytecodeVaultContract.getAddress());
    await tx.wait();
    log(`Is solved: ${chalk.yellow(await BytecodeVaultContract.isSolved())}`);

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});