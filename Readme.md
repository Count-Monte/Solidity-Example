# Solidity Smart Contract Examples

Solidity smart contracts examples and Ethereum setup information for the Blockchains and Overlay Networks class at the University of Zurich. Repository forked from the [CSG official Repostory](https://github.com/Communication-Systems-Group/solidity-examples), thanks @tbocek :thumbsup:

## First steps
Make sure you have [geth](https://www.ethereum.org/cli) and the [Solidity Compiler](http://solidity.readthedocs.io/en/develop/installing-solidity.html#binary-packages) installed in your computer. We are going to be using the geth console, so get familiar with it :smiley:

PS: all the commands in the repository were executed and tested in a Ubuntu 16.04 "xenial".

## Version information
Before geth 1.6, a Solidity file could be compiled from within geth. The file had to be prepared and newlines had to be removed

```
#old, does not work anymore since geth 1.6
$ grep -o '^[^//]*' example1.sol | tr --delete '\n\t' > /tmp/test.js
```

Since geth 1.6 it can be done with the following command 
 
```
$ echo "var testOutput=`solc --optimize --combined-json abi,bin,interface Test.sol`" > test.js
```

As reported [here](https://ethereum.stackexchange.com/questions/15435/how-to-compile-solidity-contracts-with-geth-v1-6). The issue is reported [here](https://github.com/ethereum/go-ethereum/issues/3793). 
 
## Setting up your private Ethereum testnet

To allow the rapid development of smart contracts and not have to download the entire publci Ethereum testnet, we are going go to create a private testnet. The instructiosn were retrieved from [here](https://github.com/ethereum/go-ethereum/wiki/Private-network), so refer there for more information.

### Creating the custom Data Directory

The data directory is where all the information regarding the blockchain (including the blockchain) is going to be stored.
```
$ cd ~ 
$ mkdir privateEthTestnet
$ cd privateEthTestNet
```
### Creating the genesis block

Copy the [genesisBlock.json](genesisBlock.json) file to the privateEthTestnet directory.
```
$ cp genesisBlock.json ~/privateEthTestnet/
```

### Creating the blockchain
Now we create a database using the genesis block.

```
$ cd ~/privateEthTestNet/
$ geth --datadir ~/privateEthTestnet/ init genesisBlock.json
```

If everything went fine you should see something like this
```
INFO Writing custom genesis block
INFO Successfully wrote genesis state         database=lightchaindata                                   hash=ab944c…55600c
```


### Creating Accounts

We are going to have two accounts. Both with password "123456", as we are in a private testnet we don't need strong passwords, but mind to use strong passwords in the real world :wink:

Start geth in one terminal
```
$ geth --datadir ~/privateEthTestnet --networkid 3107 --fast --rpc --rpcapi eth,web3,personal,net,miner,admin
```

Attach another instance of the geth console in another terminal
```
$ geth attach http://127.0.0.1:8545

> eth.accounts
[]
> personal.newAccount()
Passphrase: 123456
Repeat passphrase: 123456 
"0x41e26b3c7...43dd30cfb11"
> personal.newAccount()
Passphrase: 123456
Repeat passphrase: 123456
"0x844268de3...c988eecc4f2"
> eth.accounts
["0x41e26b3c7...43dd30cfb11", "0x844268de3...c988eecc4f2"]
```

Great! Now we have two accounts in the blockchain! Unfornatelly, they don't have ether yet, so let's mine a couple of ether.

### Mining some ether ⛏️

On the geth console, set the account that will receive the ether from the mining
```
> miner.setEtherbase(eth.accounts[0])
true
```

Start the miner with 4 threads
```
> miner.start(4)
null
```

You should see some CPU activity and in the other geth console something like this:
```
INFO Commit new mining work                   number=1 txs=0 uncles=0 elapsed=225.785µs
INFO Generating DAG in progress               epoch=0 percentage=80 elapsed=2m4.249s
...
INFO 🔗 block reached canonical chain          number=40 hash=32e77d…f9aac3
INFO 🔨 mined potential block                  number=45 hash=29be2c…e74788
INFO Commit new mining work

```

You can check the balance of your account
```
> web3.fromWei(eth.getBalance(eth.accounts[0]), "ether")
```

Once you have a couple of ethers you can stop the mining
```
> miner.stop()
true
```

### Important information

* You must mine every transaction in your private test network.

## First Example

The [first example](examples/example1.sol) is a very simple contract

```
pragma solidity ^0.4.10;

//the very first example
contract Example1 {
        uint stateVar;
}
```
Make sure you have started geth before

```
$ geth --datadir ~/privateEthTestnet --fast --rpc --rpcapi eth,web3,personal,net,miner,admin
$ geth attach http://127.0.0.1:8545
```
run the deploy script deploy.sh

```
$ ./deploy.sh examples/example1.sol
```

Now switch to the attached geth console and load the resulting script

```
> loadScript("/tmp/test.js")
```
Eventually, you'll see something like this

```
Contract mined! address: 0xfb821bf9e66a5decb43a92fc615bbbdb296df462 transactionHash: 0xda816929b1764fa9736f02505e94bfdeace098a4348057ddacb0baf466dfda5e
```

You have mined you first contract!

## Example 2

Now we'll store a state and access the state 