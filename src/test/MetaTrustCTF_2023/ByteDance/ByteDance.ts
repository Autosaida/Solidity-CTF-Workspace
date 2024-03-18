function isPalindrome(str: string): boolean {
    return str === str.split('').reverse().join('');
}

function getAllPalindromicBytes(): string[] {
    let result: string[] = [];

    for (let i = 0; i <= 255; i++) { 
        let binaryString = i.toString(2).padStart(8, '0');
        if (isPalindrome(binaryString)) {
            let hexString = i.toString(16).toUpperCase().padStart(2, '0');
            if (i%2==1) {
                result.push(hexString);
            }
        }
    }
    return result;
}

async function main() {
    console.log(getAllPalindromicBytes());   
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});