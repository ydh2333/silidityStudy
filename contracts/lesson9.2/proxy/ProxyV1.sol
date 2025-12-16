// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// 注意：存储变量需与Proxy完全一致（类型、顺序）
contract LogicV1 {
    address public implementation; // 占位（与Proxy兼容）
    uint256 public count;          // 业务数据
    address public owner;          // 占位（与Proxy兼容）

    // 业务功能：增加count
    function increment() external {
        count += 1;
    }

    // 业务功能：获取count
    function getCount() external view returns (uint256) {
        return count;
    }
}