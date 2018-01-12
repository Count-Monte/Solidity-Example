# Solidity Smart Contract Examples

##First steps
Make sure you have [geth](https://www.ethereum.org/cli) and the [Solidity Compiler](http://solidity.readthedocs.io/en/develop/installing-solidity.html#binary-packages) installed in your computer. We are going to be using the geth console, so get familiar with it :)

PS: all the commands in the repository were executed and tested in a Ubuntu 16.04 "xenial".

Before geth 1.6, a Solidity file could be compiled from within geth. The file had to be prepared and newlines had to be removed

```
#old, does not work anymore since geth 1.6
grep -o '^[^//]*' example1.sol | tr --delete '\n\t' > /tmp/test.js
```

Since geth 1.6 it can be done with the following command 
 
```
echo "var testOutput=`solc --optimize --combined-json abi,bin,interface Test.sol`" > test.js
```

As reported [here](https://ethereum.stackexchange.com/questions/15435/how-to-compile-solidity-contracts-with-geth-v1-6). The issue is reported [here](https://github.com/ethereum/go-ethereum/issues/3793). 
 
## First Example

The first example (example1.sol) is a very simple contract

```
pragma solidity ^0.4.10;

//the very first example
contract Example1 {
        uint stateVar;
}
```
Make sure you have started geth before

```
geth --testnet --fast --rpc --rpcapi eth,web3,personal,net,miner,admin
geth --testnet attach http://127.0.0.1:8545
```
run the deploy script deploy.sh

```
./deploy.sh example1.sol
```

Now switch to the attached geth console and load the resulting script

```
loadScript("/tmp/test.js")
```
Eventually, you'll see something like this

```
Contract mined! address: 0xfb821bf9e66a5decb43a92fc615bbbdb296df462 transactionHash: 0xda816929b1764fa9736f02505e94bfdeace098a4348057ddacb0baf466dfda5e
```

You have mined you first contract!

## Example 2

Now we'll store a state and access the state 