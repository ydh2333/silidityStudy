//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UserManagementSystem {
    struct User {
        string name;
        string email;
        uint balance;
        uint registeredAt;
        bool exists;
    }
    
    // TODO: 定义数据存储
    mapping(address => User) public users;
    address[] public userAddresses;
    uint256 public userCount;
    uint256 public constant MAX_USERS = 1000;
    
    // TODO: 实现注册功能
    function register(string memory name, string memory email) public {
        // 检查是否已注册
        require(!users[msg.sender].exists, "already rigested");
        // 检查是否达到上限
        require(userCount < MAX_USERS,"users is full");
        // 创建用户
        users[msg.sender] = User({
            name: name,
            email:email,
            balance:0,
            registeredAt:block.timestamp,
            exists: true
        });
        // 添加到列表
        userAddresses.push(msg.sender);
        // 更新计数
        userCount++;
    }
    
    // 更新个人资料
    function updateProfile(string memory name, string memory email) public {
        require(users[msg.sender].exists, "Not registered");
        users[msg.sender].name = name;
        users[msg.sender].email = email;
    }

    // 获取某个用户资料
    function getUserInfo(address user) public view returns (User memory) {
        require(users[user].exists, "Not registered");
        return users[user];
    }

    // 获取所有用户地址
    function getAllUsers() public view returns (address[] memory) {
        return userAddresses;
    }

    // 查看某个用户是否存在
    function isRegistered(address user) public view returns (bool) {
        return users[user].exists;
    }
}
