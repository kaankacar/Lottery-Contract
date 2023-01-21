// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract Lottery {
    // struct to store lottery data
    struct lottery {
        address[] players; // array of player addresses
        uint256 prizePool; // total prize pool in wei
        uint256 winningNumber; // winning number
        uint256 deadLine; // deadline for lottery to end
        bool ended; // flag to determine if lottery has ended
    }
    // variable to store the contract owner address
    address public owner;
    // constructor function to set the owner address
    constructor() {
        owner = msg.sender;
    }
    // mapping to store lottery data by address
    mapping(address => lottery) public lotteryStorage;
    // mapping to store participant addresses
    mapping(address => mapping(address => bool)) public participants;
    // function to start a new lottery
    function start(uint256 _prizePool, uint256 _deadLine) public payable {
        // check that msg.value is greater than the prize pool
        require(
            msg.value > _prizePool,
            "You don't have enough funds to initiate a lottery."
        );
        // check that the deadline has not passed
        require(
            _deadLine > block.timestamp,
            "The deadline has already passed."
        );
        // check that the prize pool is a multiple of 1 ether
        require(
            _prizePool % 1e18 == 0,
            "The prize pool must be a multiple of 1 ether."
        );
        require(
            _prizePool >= 10 ether,
            "The prize pool must be more than 10 ether."
        );
        // initialize the lottery data
        lotteryStorage[msg.sender].players = new address[](0);
        lotteryStorage[msg.sender].prizePool = _prizePool;
        lotteryStorage[msg.sender].deadLine = _deadLine;
        lotteryStorage[msg.sender].ended = false;
        lotteryStorage[msg.sender].players.push(msg.sender);
    }
    // function for a user to participate in a lottery
    function participate(address lotteryStarter)
        public
        payable
        isEnded(lotteryStarter)
    {
        // check that the deadline has not passed
        require(
            block.timestamp < lotteryStorage[lotteryStarter].deadLine,
            "The deadline for the lottery has passed."
        );
        // check that the pool is not full
        require(
            lotteryStorage[lotteryStarter].players.length <= 5,
            "The pool is full."
        );
        // check that the sent amount is 1 ether
        require(
            msg.value % 1e18 == 0,
            "You must send 1 ether to participate."
        );
        // check that the user has not already participated
        require(
            !participants[lotteryStarter][msg.sender],
            "You have already participated in this lottery."
        );
        // add the user to the players array
        lotteryStorage[lotteryStarter].players.push(msg.sender);
        // adding the participation price to the prize pool
        lotteryStorage[lotteryStarter].prizePool += msg.value;
        // adding the user to the participants mapping to prevent re-entries
        participants[lotteryStarter][msg.sender] = true;
    }
    // function to end a lottery and select a winner
    function end(address lotteryStarter) public isEnded(lotteryStarter) {
        // check that only the lottery starter can end the lottery
        require(
            lotteryStarter == msg.sender,
            "Only the lottery starter can end the lottery."
        );
        // check that the deadline has passed
        require(
            block.timestamp > lotteryStorage[lotteryStarter].deadLine,
            "The deadline has not passed yet."
        );
        // check that there is more than one player in the lottery
        require(
            lotteryStorage[lotteryStarter].players.length > 1,
            "Only one player has joined so far."
        );
        // set the lottery as ended
        lotteryStorage[lotteryStarter].ended = true;
        // generate a random number using keccak256 hash function
        uint256 winnerIndex = uint256(
            keccak256(abi.encodePacked(block.timestamp, block.difficulty))
        ) % 6;
        // select the winner using the generated number
        address winner = lotteryStorage[lotteryStarter].players[winnerIndex];
        // transfer the prize pool to the winner
        payable(winner).transfer(lotteryStorage[lotteryStarter].prizePool);
        // ending the lottery
        lotteryStorage[lotteryStarter].ended = true;
        // set the winning number
        lotteryStorage[lotteryStarter].winningNumber = winnerIndex;
    }
     // function to check the winner of a lottery
    function checkWinner(address lotteryStarter)
        public
        view
        isNotEnded(lotteryStarter)
        returns (bool)
    {
        if (
            msg.sender ==
            lotteryStorage[lotteryStarter].players[
                lotteryStorage[lotteryStarter].winningNumber
            ]
        ) {
            return true;
        } else return false;
    }
    // function to allow the lottery starter to withdraw their funds
    function withdraw() public {
        require(msg.sender == owner, "Only the owner can withdraw funds.");
        require(address(this).balance > 0, "There are no funds to withdraw.");
        payable(msg.sender).transfer(address(this).balance);
    }

    // Modifiers are here to check if the lottery has ended before executing a function

    modifier isNotEnded(address lotteryStarter) {
        require(
            lotteryStorage[lotteryStarter].ended == true,
            "The lottery has not ended yet."
        );
        _;
    }

    modifier isEnded(address lotteryStarter) {
        require(
            !lotteryStorage[lotteryStarter].ended,
            "The lottery has already ended."
        );
        _;
    }
}
