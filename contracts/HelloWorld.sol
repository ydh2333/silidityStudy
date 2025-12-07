// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HelloWorld {
    string public message;
    address public owner;

    constructor() {
        message = "Hello, Solidity, YDH2333333333!";
    }

    function updateMessage(string memory newMessage) public {
        message = newMessage;
        owner = msg.sender;
    }

    function getMessage() public view returns (string memory) {
        return message;
    }

    function getOwner() public view  returns (address){
        return owner;
    }
}