import chalk from "chalk";
import { ethers, network } from "hardhat";
import { HardhatNetworkConfig } from "hardhat/types";
import { HardhatEthersSigner } from "@nomicfoundation/hardhat-ethers/signers";
import { Wallet } from "ethers";

export function log(s:string){
    console.log(`${chalk.green("[-] ")+s}`)
}

export async function initialize<T>(Challenge__factory: any, attackerPrivateKey?: any, constructorArgs?: any[], balance?: string, challengeAddress?: any): Promise<[T, HardhatEthersSigner| Wallet]>{
    const signers = await ethers.getSigners();
    const provider = ethers.provider;
    const deployer = signers[0];
    const forkingConfig = (network.config as HardhatNetworkConfig).forking;
    if (!balance) {
        balance = "0";
    }

    let attacker: HardhatEthersSigner| Wallet = signers[1];
    if (attackerPrivateKey) {
        let address = ethers.computeAddress(attackerPrivateKey);
        if (network.name == "hardhat" && forkingConfig?.url == "https://rpc.sepolia.org/") {
            let tx = await attacker.sendTransaction({
                to: address,
                value: ethers.parseEther("0.9")
            });
            await tx.wait();
        }
        const attackerWallet = new ethers.Wallet(attackerPrivateKey);
        attacker = attackerWallet.connect(provider);
    }

    log(`Running on the ${chalk.yellow(network.name)} network`);
    log(`Attacker address: ${chalk.yellow(attacker.address)}`);
    log(`Attacker balance: ${chalk.yellow(ethers.formatEther(await provider.getBalance(attacker)))} ETH`);

    let challengeContract;
    if(network.name == "hardhat" && forkingConfig?.url == "https://rpc.sepolia.org/") {
        if (constructorArgs) {
            challengeContract = await new Challenge__factory(deployer).deploy(...constructorArgs, {value: ethers.parseEther(balance)});
        } else {
            challengeContract = await new Challenge__factory(deployer).deploy({value: ethers.parseEther(balance)});
        }
        await challengeContract.waitForDeployment();
        challengeContract = challengeContract.connect(attacker);
        log(`Successfully deployed the target contract to address ${chalk.yellow(await challengeContract.getAddress())}!`)
    } else { // remote or remoteFork
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
