function findFibonacciN(x:bigint) {
    console.log(x);
    let sum = BigInt(0);
    let prev = BigInt(1);
    let current = BigInt(2);
    let n = 0;
  
    while (sum < x) {
      let temp = current;
      current = prev + current;
      prev = temp;
      sum += prev;
      n++;
    }
    console.log(prev); // the last added number: 22698374052006863956975682
  
    if (sum === x) {
      return n; 
    } else {
      return null; 
    }
  }

async function main() {
   
    let n = findFibonacciN(BigInt(59425114757512643212875122n));
    console.log(n);  // 121, so we should reenter 120 times

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});