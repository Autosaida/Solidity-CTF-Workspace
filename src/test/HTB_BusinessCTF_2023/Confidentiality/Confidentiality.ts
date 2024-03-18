import { ethers } from "ethers";

async function main() {
    let signature = ethers.Signature.from("0x1deef9c543f0ab3440a43cfb531724c4f937d5c1d394bf1f3e32e8837ce564f40d5047f16b69c0f43f18da7921f26da0496c87fd3bee5b03d403ddbfee6820041b");
    let new_s = "0x" + (ethers.N - ethers.toBigInt(signature.s)).toString(16);
    let new_v = (signature.v === 27) ? 28 : 27;
    console.log(new_s, new_v);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});