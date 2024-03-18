import { ethers } from "ethers";
import { randomBytes } from "crypto";

async function main() {
    let key = "0xf2b6c9639f151c02b3dac23920d699ef3792e75756db1e34cf141cc9ffe9b726";
    let nonce = BigInt(0);
    while (true) {
        let bytes = "0x" + randomBytes(32).toString('hex');
        let from = ethers.computeAddress(bytes);
        let contractAddress = ethers.getCreateAddress({from, nonce});
        if(ethers.getBigInt(contractAddress) % BigInt(1000) == BigInt(137)) {
            key = bytes;
            break;
        }
    }
    console.log(`Private Key: ${key}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});