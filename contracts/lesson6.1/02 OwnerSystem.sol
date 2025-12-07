// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ownable  {
    address public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor (){
        owner = msg.sender;
        emit OwnershipTransferred(address(0), owner);
    }

    modifier onlyOwner(){
        require(owner == msg.sender, "Only owner");
        _;
    }

    function ownershipTransferred(address _newOwner) public virtual onlyOwner returns (bool){
        require(_newOwner != address(0), "Zero address");

        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;

        return true;
    }

}

contract Pausable {
    bool public pauseStat = false;

    event Paused(address account);
    event Unpaused(address account);

    modifier isPaused(){
        require(pauseStat == true, "Not paused");
        _;
    }

    modifier unpaused(){
        require(pauseStat == false, "In paused");
        _;
    }

    function _pause() internal unpaused {
        pauseStat = true;
        emit Paused(msg.sender);
    }

    function _unpause() internal isPaused {
        pauseStat = false;
        emit Unpaused(msg.sender);
    }
}


contract MyContract is Ownable, Pausable {

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }


     function ownershipTransferred(address _newOwner) public override onlyOwner returns (bool){
        require(!pauseStat, "Unpause");
        return super.ownershipTransferred(_newOwner);
     }
}