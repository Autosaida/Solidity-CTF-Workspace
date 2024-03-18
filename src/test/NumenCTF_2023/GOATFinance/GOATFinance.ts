import { ethers } from "ethers";

function help(): [string, number] {
    let msgsender = "0x71fA690CcCDC285E3Cb6d5291EA935cfdfE4E0";
    for (let i = 0; i < 256; i++) {
        let _msgsender = msgsender + i.toString(16).padStart(2, "0");
        let checksumAddress = ethers.getAddress(_msgsender.toLowerCase());
        if (checksumAddress.substring(0, 40) == msgsender){
            msgsender = checksumAddress;
            console.log(`True msgsender: ${checksumAddress}`);
            break;
        }
    }
    let block = 1677729608;
    for (let j = 0; j < 2; j++) {
        let digest = ethers.solidityPackedKeccak256(["address", "uint", "uint"], [msgsender, "65000000000000000000000", block+j]);
        let address = ethers.recoverAddress(digest,{r:"0xf296e6b417ce70a933383191bea6018cb24fa79d22f7fb3364ee4f54010a472c", s: "0x62bdb7aed9e2f82b2822ab41eb03e86a9536fcccff5ef6c1fbf1f6415bd872f9", v:28})        
        if (address == "0x2922F8CE662ffbD46e8AE872C1F285cd4a23765b") {
            block = block + j;
            console.log(`True blocktimestamp: ${block}`);
            break;
        }
    }
    return [msgsender, block];

}

async function main() {
    let [msgsender, blocktimestamp] = help();
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});