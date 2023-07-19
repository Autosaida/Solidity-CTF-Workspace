import chalk from "chalk";
import { ethers } from "hardhat";
import { HardhatEthersSigner } from "@nomicfoundation/hardhat-ethers/signers";
import { Wallet } from "ethers";

export function log(s:string){
    console.log(`${chalk.green("[-] ")+s}`)
}

export async function initialize<T>(Challenge__factory: any, attackerPrivateKey?: any, constructorArgs?: any[], challengeAddress?: any): Promise<[T, HardhatEthersSigner| Wallet]>{
    const signers = await ethers.getSigners();
    const provider = ethers.provider;
    const network = await provider.getNetwork();
    const deployer = signers[0];
    
    let attacker: HardhatEthersSigner| Wallet = signers[1];
    if (attackerPrivateKey) {
        let address = ethers.computeAddress(attackerPrivateKey);
        let tx = await attacker.sendTransaction({
            to: address,
            value: ethers.parseEther("0.9")
        });
        await tx.wait();
        const attackerWallet = new ethers.Wallet(attackerPrivateKey);
        attacker = attackerWallet.connect(provider);
    }

    log(`Running on the ${chalk.yellow(network.name)} network`);
    log(`Attacker address: ${chalk.yellow(attacker.address)}`);
    log(`Attacker balance: ${chalk.yellow(ethers.formatEther(await provider.getBalance(attacker)))} ETH`);

    let challengeContract;
    if(network.name == "hardhat") {
        if (constructorArgs) {
            challengeContract = await new Challenge__factory(deployer).deploy(...constructorArgs);
        } else {
            challengeContract = await new Challenge__factory(deployer).deploy();
        }
        await challengeContract.waitForDeployment();
        challengeContract = challengeContract.connect(attacker);
        log(`Successfully deployed the target contract to address ${chalk.yellow(await challengeContract.getAddress())}!`)
    } else if (network.name == "remote") {
        if (challengeAddress) {
            challengeContract = Challenge__factory.connect(challengeAddress, attacker);
            log(`Successfully connected to the target contract with address ${chalk.yellow(await challengeContract.getAddress())}!`)
        } else {
            log(`Remote connection failed! Missing contract address.`);
            process.exit(0);
        }
    }
    return [challengeContract, attacker];
}
