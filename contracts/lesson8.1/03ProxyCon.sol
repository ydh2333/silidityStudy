// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// 逻辑合约 V1：初始版本
contract ImplementationV1 {
    // 注意：存储布局必须与代理合约匹配
    uint256 public value;
    address public owner;
    
    /**
     * @notice 设置值
     * @param _value 要设置的值
     */
    function setValue(uint256 _value) external {
        // 这个函数会修改调用者合约（代理合约）的storage
        value = _value;
        // msg.sender是原始调用者，不是代理合约
        owner = msg.sender;
    }
    
    /**
     * @notice 获取值
     */
    function getValue() external view returns (uint256) {
        return value;
    }
}

// 逻辑合约 V2：升级版本（值翻倍）
contract ImplementationV2 {
    // 存储布局必须与V1和代理合约完全一致
    uint256 public value;
    address public owner;
    
    /**
     * @notice 设置值（新逻辑：值翻倍）
     * @param _value 要设置的值
     */
    function setValue(uint256 _value) external {
        // 新逻辑：值翻倍
        value = _value * 2;
        owner = msg.sender;
    }
    
    /**
     * @notice 获取值
     */
    function getValue() external view returns (uint256) {
        return value;
    }
    
    /**
     * @notice 新增功能：重置值
     * @dev V1没有这个函数，升级后可以使用
     */
    function reset() external {
        value = 0;
    }
}

// 代理合约：存储数据，通过delegatecall调用逻辑合约
contract Proxy {
    // 存储布局必须与逻辑合约完全一致
    address public implementation; // 逻辑合约地址
    uint256 public value;          // 与逻辑合约的value对应
    address public owner;           // 与逻辑合约的owner对应
    
    event Upgraded(address indexed newImplementation);
    
    // 构造函数：初始化逻辑合约地址
    constructor(address _implementation) {
        implementation = _implementation;
        owner = msg.sender;
    }
    
    /**
     * @notice 升级函数：更换逻辑合约
     * @param newImplementation 新的逻辑合约地址
     */
    function upgrade(address newImplementation) external {
        require(msg.sender == owner, "Not owner");
        implementation = newImplementation;
        emit Upgraded(newImplementation);
    }
    
    /**
     * @notice fallback函数：将所有调用转发到逻辑合约
     * @dev 使用delegatecall调用逻辑合约，逻辑合约的代码在代理合约的上下文中执行
     */
    fallback() external payable {
        address impl = implementation;
        require(impl != address(0), "Implementation not set");
        
        // 使用delegatecall调用逻辑合约
        // 逻辑合约的代码会在本合约（代理合约）的上下文中执行
        // 这意味着修改的是代理合约的storage，而不是逻辑合约的
        (bool success, bytes memory returnData) = impl.delegatecall(msg.data);
        
        if (!success) {
            // 如果调用失败，回滚
            assembly {
                returndatacopy(0, 0, returndatasize())
                revert(0, returndatasize())
            }
        }
        
        // 返回数据
        assembly {
            return(add(returnData, 0x20), mload(returnData))
        }
    }
    
    // 接收以太币
    receive() external payable {}
}