# Solidity Smart Contract Examples

Solidity smart contracts examples and Ethereum setup information for the Blockchains and Overlay Networks class at the University of Zurich. Repository forked from the [CSG official Repostory](https://github.com/Communication-Systems-Group/solidity-examples), thanks @tbocek :thumbsup:

[Click here](https://solidity.readthedocs.io/en/develop/) for the full Solidity Documentation.

[Click here](https://www.youtube.com/watch?v=F_l4HycnHAIa) for a video explaining the Application Binary Interface (ABI) of Ethereum Smart Contracts (Useful for interacting with the Smart Contract)

## First steps
Make sure you have [geth](https://www.ethereum.org/cli) and the [Solidity Compiler](http://solidity.readthedocs.io/en/develop/installing-solidity.html#binary-packages) installed in your computer. We are going to be using the geth console, so get familiar with it :smiley:

PS: All the commands in the repository were executed and tested in a Ubuntu 16.04 "xenial". 

PS2: You can create a Virtual Machine (VM) using [Virtual Box](https://www.virtualbox.org/wiki/Downloads) and install [Ubuntu 16.04](https://www.ubuntu.com/download/desktop) if you don't want to change any boot configuration in your PC. For a tutorial on how to perfom the install refer [here](https://www.lifewire.com/run-ubuntu-within-windows-virtualbox-2202098).

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

To allow the rapid development of smart contracts and not have to download the entire public Ethereum testnet, we are going go to create a private testnet. The instructions were retrieved from [here](https://github.com/ethereum/go-ethereum/wiki/Private-network), so refer there for more information.

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

Great! Now we have two accounts in the blockchain! unfortunately, they don't have ether yet, so let's mine a couple of ether.

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

### :warning: Important information :warning:

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

## [Example 2](examples/example2.sol)

Now we'll store a state and access the state.

Deploy the contract by running (you have to do this to every new contract):

```
$ ./deploy.sh examples/example2.sol
```

Now switch to the attached geth console and load the resulting script

```
> loadScript("/tmp/test.js")
```

Once the contract has been mined you can interact with it
```
> test.push("someString")
```

If you see something like this
```
Error: invalid address
```
Set the default account of the wallet and try the push command again
```
> eth.defaultAccount=eth.accounts[0]
"0x41e26b3c7b...420000ae9643dd30cfb11"
> test.push("someString")
"0x58fbadf2567f43aa443623d5c237dbcaa387b01757c84586251f035e12f323ee"
```

Now we can retrieve the value:
```
> test.get(0)
"someString"
```

## [Example 3](examples/example3.sol)

In the third example we are going to work with structs.
This contract has a struct named "Account" that stores an address and an amount. Calling the function creates(address) creates an entry in the accounts list and sets the owner of the contract to be the address that called the function.

```
> test.create(eth.accounts[0],{gas:2100000})
```
:warning: Every transaction that modifies a state in the Smart Contract consumes what Ethereum calls "gas", so that is the reason why we pass as argument an amount of "gas". This amount, in wei, is deducted from your account, and if the function does not consume all the gas, the difference will be returned. If you specify too little gas, the function will not run. Thus, if your function does not run, maybe you need to specify more gas when calling the function.
Refer [here](http://ethdocs.org/en/latest/contracts-and-transactions/account-types-gas-and-transactions.html) for more information about gas and gas price.

If we call the ``get`` function passing as argument 1 we should get the address that was stored in the function Example3:
```
> test.get(1)
"0x41e26b3c7b...420000ae9643dd30cfb11"
```

We can also create entries to new addresses and specify the amount that the address will have. This function contains a condition that specify that only the owner of the contract (i.e., the address that called the Example3 function) can create new entries and amounts.
```
> test.set(66, eth.accounts[1],{gas:2100000})
true
```

Now if we call the ``getAmount`` function we can see the amount of the second address in the accounts list.
```
> test.getAmount(2) #second account
66
> test.getAmount(1) #first account
42
```

## [Example 4](examples/example4.sol)

This example introduces the concept of Events in Solidity. Events are signals that the smart contract can issue and applications can listen to these events.
To implement an application that listens/watches to a specific Event of a contract, please refer to [this brief course](https://coursetro.com/posts/code/100/Solidity-Events-Tutorial---Using-Web3.js-to-Listen-for-Smart-Contract-Events). 
Events are important when implementing Distributed Applications based on Solidity.

Regarding the Example 4, everytime the function ``set`` is called, if the sender of the message is the owner of the contract, then an event of the type Message is called.
```
	event Message(
        string msg
    );
    .
    .
    .
    function set(uint nr, string addr) returns (bool) {
	if(owner == msg.sender) {
            accounts[counter++] = Account(addr, nr);
            Message("all set!");
            return true;
        } else {
            return false;
        }
    }
```

## [Example 5](examples/example5.sol)

In this example we are going to store some amount of Ethers in the smart contrat and we will be able to withdraw an arbitrary amount from our account.
We can deposit an amount of ether by calling the deposit function, note that the value is in Wei not Ether (see [EtherConverter.online](https://etherconverter.online/)):
```
> test.deposit({from: eth.accounts[0], value: web3.toWei(1,"ether")})
> test.balance()
1000000000000000000
```

Now that we have some amount deposit in the smart contract, we can withdraw a specific amount:
```
> test.withdraw(web3.toWei(0.5,"ether"))
true
> test.balance()
500000000000000000
> test.withdraw(web3.toWei(0.5,"ether"))
true
> test.balance()
0
```

## [Example 6](examples/example6.sol)

You tell me, what do you think that this contract is implementing?

## [Example 7](examples/example7.sol)

How about this one?

## [Example 8](examples/example8.sol)

This contract implements a contract where you can send the content of a file, which will be hashed and stored in the Smart Contract with your address as the owner of the file. Thus, if someone wants to store the same file, it will not be able to store it because the hash of the file's content is already registered to a address.






