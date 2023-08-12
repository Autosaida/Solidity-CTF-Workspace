import chalk from "chalk";
import { ethers } from "hardhat";
import { TrueXorQuill__factory, TrueXorQuill, TrueXorQuillAttack__factory } from "../../typechain";
import { log, initialize } from "../utils";


async function main() {
    let [trueXorQuillContract, attacker] = await initialize<TrueXorQuill>(TrueXorQuill__factory);
    let xorAttack = await new TrueXorQuillAttack__factory(attacker).deploy();
    await xorAttack.waitForDeployment();

    log(`Is solved: ${chalk.yellow(await trueXorQuillContract.callMe(await xorAttack.getAddress(), {gasLimit:100000}))}`); 

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});