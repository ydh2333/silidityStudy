// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LogicV2 {
    address public implementation; // 占位（与Proxy兼容）
    uint256 public count;        // 业务数据（兼容V1）
    address public owner;          // 占位（与Proxy兼容）

    // 兼容V1的功能
    function increment() external {
        count += 2; // 升级逻辑：每次加2而非1
    }

    // 新增功能：减少count
    function decrement() external {
        require(count > 0, "LogicV2: count is 0");
        count -= 1;
    }

    // 兼容V1的查询功能
    function getCount() external view returns (uint256) {
        return count;
    }
}