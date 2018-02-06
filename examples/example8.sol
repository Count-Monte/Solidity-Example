pragma solidity ^0.4.10;


//the very 8th example
//this contract implements proof of ownership :) or at least it tries
contract Example8 {

    address owner;
    
    event Stored(
    );

    struct Document {
        address ownerAddress;
        string name;
        uint256 timestamp;
        uint256 modified;
    }
    mapping (bytes32 => Document) public documents; //every file hashed will belong to a address using the data type 32 bytes, size of a sha256 hash. 
    mapping (uint => bytes32) public hashList; //every file hashed will belong to a address using the data type 32 bytes, size of a sha256 hash. 
    uint public documentCount = 0;

    function Example8() {
        owner = msg.sender;
    }

    function amIMaster() public view returns (string) {
        if (msg.sender == owner) {
            return "Yes, master";
        }
        return "No";
    }
    function getBalance() public view returns (uint) {
        return msg.sender.balance;
    }

    function amIOwner(string file) public view returns (bool) {
        var fileHash = sha256(file);

        if (msg.sender == documents[fileHash].ownerAddress) {
            return true;
        }
        return false;
    }
    function getHash(string file) public pure returns (bytes32) {
        return sha256(file);
    }

    function changeOwner(string file,address newOwner) public returns (bool) {
        if (amIOwner(file)) {
             var fileHash = sha256(file);
             documents[fileHash].ownerAddress = newOwner;
             documents[fileHash].modified = now;
             Stored();
             return true;
        }
        return false;
    }

    function store(string file,string name) public returns (bytes32) {
        var fileHash = sha256(file);
        if (documents[fileHash].ownerAddress == 0x0000000000000000000000000000000000000000) {
            documents[fileHash].ownerAddress = msg.sender;  //can save
            documents[fileHash].name = name;
            documents[fileHash].timestamp = now;
            hashList[documentCount] = fileHash;
            documentCount += 1;
            Stored();
            return fileHash;
        }
    }

    function getDocumentCount() public view returns (uint) {
        return documentCount;
    }

    function getDocument(uint index) public view returns (bytes32 fileHash, address ownerAddress, string name, uint256 timestamp) {
        if (index > documentCount)
            return;

        fileHash = hashList[index];
        ownerAddress = documents[fileHash].ownerAddress;
        name = documents[fileHash].name;
        timestamp = documents[fileHash].timestamp;

    }

    function hasOwner(string file) public view returns (address) {
        return documents[sha256(file)].ownerAddress;
    }
}