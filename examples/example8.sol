pragma solidity ^0.4.10;

//the very 8th example
contract SimpleMegasena {

    address owner;
    mapping (address => uint) accounts;


    event Loga(
        address indexed _from
    );

    function SimpleMegasena() {
        owner = msg.sender; //owner do contrato, ver isso se isso funciona depois
    }

    function amIowner() public constant returns (string) {
        Loga(msg.sender);
        if (msg.sender == owner) {
            return "Yes, master";
        }
        return "No";
    }
    function getBalance() public constant returns (uint) {
        return msg.sender.balance;
    }


    function mint(address recipient, uint value) {
        if (msg.sender == owner) {
            accounts[recipient] += value;
        }
    }

    function transfer(address to, uint value) {
        if (accounts[msg.sender] >= value) {
            accounts[msg.sender] -= value;
            accounts[to] += value;
        }
    }

    function balance(address addr) constant returns (uint) {
        return accounts[addr];
        
    }
}