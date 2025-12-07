// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {
    struct Proposal {
        string description;
        uint voteCount;
        uint deadline;
        bool exists;
    }
    
    address public owner;
    uint public proposalCount;
    
    mapping(uint => Proposal) public proposals;
    mapping(uint => mapping(address => bool)) public hasVoted;
    
    constructor() {
        owner = msg.sender;
    }
    
    // TODO: 实现创建提案
    function createProposal(string memory description, uint durationDays) 
        public 
    {
        // 检查权限
        // 验证参数
        // 创建提案
    }
    
    // TODO: 实现投票
    function vote(uint proposalId) public {
        // 检查提案存在
        // 检查是否已投票
        // 检查是否已截止
        // 执行投票
    }
    
    // TODO: 获取获胜提案
    function getWinner() public view returns (uint) {
        // 遍历所有提案
        // 找出票数最多的
    }
}