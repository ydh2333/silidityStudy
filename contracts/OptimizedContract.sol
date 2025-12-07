// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OptimizedContract{
    function processMemory(uint256[] memory data) external pure returns (uint256){
        return data.length;
    }

        function processCalldata(uint256[] calldata data) external pure returns (uint256){
        return data.length;
    }
}