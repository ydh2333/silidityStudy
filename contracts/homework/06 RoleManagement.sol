//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RoleManagement  {
    // TODO: 定义角色枚举
    enum Role { None, User, Admin, Owner }
    
    // TODO: 存储用户角色
    mapping(address => Role) public roles;
    
    address public owner;
    
    constructor() {
        owner = msg.sender;
        roles[msg.sender] = Role.Owner;
    }
    
    // TODO: 定义modifier
    modifier onlyOwner() {
        // 检查是否为Owner
        require(roles[owner] == Role.Owner, "user is not a owner");
        _;
    }
    
    modifier onlyAdmin() {
        // 检查是否为Admin或Owner
        require(roles[owner] == Role.Owner || roles[owner] == Role.Admin, "user is not a owner or admin");
        _;
    }
    
    // TODO: 实现功能函数
    function addAdmin(address user) public onlyOwner {
        // Owner添加Admin
        roles[user] = Role.Admin;
    }
    
    function addUser(address user) public onlyAdmin {
        // Admin添加User
        roles[user] = Role.User;
    }
    
    function getRole(address user) public view returns (Role) {
        // 查询角色
        return roles[user];
    }
}