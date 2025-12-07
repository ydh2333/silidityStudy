//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TestOveeFlow {
    function getB() pure external returns (uint8){
        uint8 a = 255;
        unchecked{
            return a + 1;
        }
    }
    function concat() pure public returns (string memory){
        string memory str1 = "hello ";
        string memory str2 = "world";
        return string.concat(str1, str2);
    }
    function compare(string memory a, string memory b) pure public returns (bool){
        return sha256(bytes(a)) == sha256(bytes(b));
    }
    function getStringLen(string memory str) pure public returns ( uint256){
        return bytes(str).length;
    }
}