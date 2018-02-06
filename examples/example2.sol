pragma solidity ^0.4.10;

//the very second example
contract Example2 {
	struct Account {
		string addr;
		uint amount; //default is 256bits
	}

	uint counter=0;
	mapping (uint => Account) accounts;

    function push(string addr) public {
        accounts[counter] = Account(addr, 42);
		counter++;
    }

    function get(uint nr) public constant returns (string) {
        return accounts[nr].addr;
    }
    function getCounter() public constant returns (uint) {
        return counter;
    }
}
