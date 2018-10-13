#!/bin/bash

#Set a secure password
PASSWORD="123456"
ARG=""
if [ -n "$2" ]; then ARG="\"$2\","; fi

echo "var output=`solc --optimize --combined-json abi,bin,interface $1`;" > /tmp/test.js

var="$(cat <<EOF
var array = Object.keys(output.contracts);
for (var i in array) {
  var contract = eth.contract(JSON.parse(output.contracts[array[i]].abi));
  var bytecode = '0x' + output.contracts[array[i]].bin;
  var txDeploy = {from:eth.accounts[0], data: bytecode, gas: 4700000}; 
  personal.unlockAccount(eth.accounts[0], "$PASSWORD", 999999);
  personal.unlockAccount(eth.accounts[1], "$PASSWORD", 999999);
  var test = contract.new($ARG txDeploy,
    function (e, contract) {
      if (typeof contract.address !== 'undefined') {
        console.log('Contract mined! address: ' + contract.address + ' transactionHash: ' + contract.transactionHash);
    }
  });
}
EOF
)";

echo $var >> /tmp/test.js
