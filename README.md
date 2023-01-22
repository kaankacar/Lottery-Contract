# Lottery Smart Contract

This is a smart contract for a lottery on the Ethereum blockchain, written in Solidity. It allows users to start a new lottery, participate in a lottery, and end a lottery and select a winner. 

The contract is designed to be simple and easy to use, while still maintaining security and reliability. It uses the Solidity programming language and is compatible with version 0.8.7 of the Solidity compiler. 

## Contract Structure

The contract defines a struct called "lottery" which stores all the relevant information about a lottery, including:
- `players`: an array of player addresses who have participated in the lottery
- `prizePool`: the total prize pool in wei
- `winningNumber`: the winning number
- `deadLine`: the deadline for the lottery to end
- `ended`: a flag to determine if the lottery has ended

The contract also includes a `mapping(address => lottery)` public variable called `lotteryStorage` to store lottery data by address and another `mapping(address => mapping(address => bool))` public variable called `participants` to store participant addresses.

## Contract Functions

The contract includes several functions that allow users to interact with the lottery:
- `start()`: This function is used to start a new lottery. It takes in two arguments, the prize pool in wei and the deadline in the form of a timestamp. The function requires that the msg.value is greater than the prize pool and that the deadline has not passed. It also checks that the prize pool is a multiple of 1 ether, and greater than 10 ether.
- `participate()`: This function is used for a user to participate in a lottery. It takes in one argument, the address of the lottery starter. It checks that the deadline has not passed and that the pool is not full and also that the sent amount is 1 ether. It also checks that the user has not already participated.
- `end()`: This function is used to end a lottery and select a winner. It takes in one argument, the address of the lottery starter. It checks that only the lottery starter can end the lottery and that the deadline has passed and that there is more than one player in the lottery.

The contract also includes a modifier called `isEnded()` which is used to check if a lottery has ended or not.

## Deployment and Usage

You will need to have a local development environment set up with Truffle and a local blockchain network (such as Ganache) running to deploy and test this contract.

1. Clone this repository to your local machine.
2. In the project root directory, run `truffle compile` to compile the contract.
3. Run `truffle migrate` to deploy the contract to your local blockchain network.
4. Use Truffle's console to interact with the contract and test its functions.

## License
This code is distributed under the MIT license.

## Disclaimer
Please note that this contract is for demonstration purposes only and should not be used in a production environment without proper testing and security review. As with any smart contract, it is possible that bugs or vulnerabilities may exist in the code. Use at your own risk.
