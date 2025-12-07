//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ArryOptimizedCode {
    uint[] public data;
    
    function process1(uint[] memory values) public {
        for(uint i = 0; i < values.length; i++) {
            if(values[i] > 10) {
                data.push(values[i]);
            }
        }
    }


    function process2(uint[] calldata values) public {
        uint len = values.length;
        for(uint i = 0; i < len; ) {
            if(values[i] > 10) {
                data.push(values[i]);
            }
            unchecked{i++;}
        }
    }

}