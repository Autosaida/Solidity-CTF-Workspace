import chalk from "chalk";
import { ethers } from "hardhat";
import { Hexp__factory } from "../../typechain";

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

    let hexpContract;
    let tx;
    if(network.name == "hardhat") {
        hexpContract = await new Hexp__factory(deployer).deploy();
        await hexpContract.waitForDeployment();
        hexpContract = hexpContract.connect(attacker);
        log(`Successfully deployed the target contract to address ${chalk.yellow(await hexpContract.getAddress())}!`)
    } else if (network.name == "remote") {
        const contractAddress = "0x0000000000000000000000000000000000000000";
        hexpContract = Hexp__factory.connect(contractAddress, attacker);
        log(`Successfully connected to the target contract with address ${chalk.yellow(await hexpContract.getAddress())}!`)
    }

    if(hexpContract) {
        let code = "0x62ffffff80600a43034016903a1681146016576033fe5b5060006000f3";
        // block.blockHash(block.number - 0x0a) & 0xffffff == gasprice & 0xffffff
        let block = await provider.getBlock((await provider.getBlockNumber())-9);  // 10 maybe late
        let hash = block?.hash;
        tx = await hexpContract.f00000000_bvvvdlt({gasPrice:"0x"+hash?.slice(60, 66)});
        await tx.wait();
        
        log(`Is solved: ${await hexpContract.isSolved()}`);
    }

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});