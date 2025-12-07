// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PaymentContract {
    address public owner;
    bool public paused = false;
    mapping(address => uint256) public balances;
    uint256 public constant MIN_DEPOSIT = 0.01 ether;

    constructor(){
        owner = msg.sender;
    } 

    modifier isOwner(){
        require(msg.sender == owner, "not owner");
        _;
    }

    modifier whenNotPaused(){
        require(!paused, "contract is paused");
        _;
    }

        modifier whenPaused(){
        require(paused, "contract is not paused");
        _;
    }

    function deposit() public payable isOwner whenNotPaused{
        require(msg.value > MIN_DEPOSIT, "deposit too low");
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint _amount) public isOwner whenNotPaused{
        require(_amount > MIN_DEPOSIT, "deposit too low");
        require(balances[msg.sender] >= _amount,"balance too low");
        balances[msg.sender] -= _amount;
        (bool transferSuccess, ) = owner.call{value: _amount}("");
        require(transferSuccess, "ETH transfer failed");
    }

    function pause()  public isOwner whenNotPaused{
        paused = true;
    }

    function start()  public isOwner whenPaused{
        paused = false;
    }

    function getBalance() public view isOwner whenNotPaused returns (uint256){
        return balances[msg.sender];
    }
}