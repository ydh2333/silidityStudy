// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract Animal  {
    function makeSound() public virtual returns (string memory);

    function eat() public virtual returns (string memory){
        return "eat something...";
    }

}

contract Dog is Animal{
    function makeSound() public pure override returns (string memory){
        return "miao miao miao....";
    }
    function eat() public pure override returns (string memory){
        return "eat fish...";
    }

}

contract Cat is Animal{
    function makeSound() public pure override returns (string memory){
        return "wamg wang wang....";
    }
    function eat() public pure override returns (string memory){
        return "eat meat...";
    }
}