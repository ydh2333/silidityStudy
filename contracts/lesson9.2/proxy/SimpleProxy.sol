// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Proxy {
    // ========== 核心存储（需与逻辑合约兼容） ==========
    address public implementation; // 逻辑合约地址
    uint256 public count;          // 业务数据（示例）
    address public owner;          // 权限控制

    // ========== 事件 ==========
    event Upgraded(address indexed newImplementation);

    // ========== 构造函数 ==========
    constructor(address _implementation) {
        owner = msg.sender;
        implementation = _implementation;
    }

    // ========== 权限修饰器 ==========
    modifier onlyOwner() {
        require(msg.sender == owner, "Proxy: not owner");
        _;
    }

    // ========== 核心：转发调用到逻辑合约 ==========
    fallback() external payable {
        _delegate(implementation);
    }

    receive() external payable {
        _delegate(implementation);
    }

    // 内部委托调用逻辑
    function _delegate(address _impl) internal {
        // solhint-disable-next-line no-inline-assembly
        assembly {
            // 复制调用数据到内存
            calldatacopy(0, 0, calldatasize())

            // 执行delegatecall
            let result := delegatecall(gas(), _impl, 0, calldatasize(), 0, 0)

            // 复制返回数据到内存
            returndatacopy(0, 0, returndatasize())

            // 处理调用结果：成功则返回数据，失败则回滚
            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }

    // ========== 升级逻辑合约 ==========
    function upgradeTo(address _newImplementation) external onlyOwner {
        require(_newImplementation != address(0), "Proxy: invalid implementation");
        implementation = _newImplementation;
        emit Upgraded(_newImplementation);
    }
}