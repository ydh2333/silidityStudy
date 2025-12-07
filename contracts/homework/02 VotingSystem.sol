//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {
    enum Vote {Yes, No, Abstain}

    mapping (address => Vote) public votes;
    mapping (address => bool) public hasVoted;
    uint public yesCount;
    uint public noCount;
    uint public abstainCount;

    // 3. 投票函数
    function vote(Vote _vote) public {
        // - 检查是否已投票
        require(!hasVoted[msg.sender], "You are voted yet");
        // - 记录投票
        votes[msg.sender] = _vote;
        hasVoted[msg.sender] = true;
        // - 更新计数
        if(_vote == Vote.Yes){
            yesCount += 1;
        }
        if (_vote == Vote.No){
            noCount += 1;
        }
        if (_vote == Vote.Abstain){
            abstainCount += 1;
        }
    }

    // 4. 查询函数
    function getResults() public view returns (uint, uint, uint) {
        return (yesCount, noCount, abstainCount);
    }
    
    function getMyVote() public view returns (Vote) {
        require(hasVoted[msg.sender], "You haven't voted");
        return votes[msg.sender];
    }
}