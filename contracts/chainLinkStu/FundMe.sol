// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe{
    mapping (address => uint256) public funderToAmount;
    uint256 constant MINIMUM_VALUE = 100 * 10 ** 18;  //USB
    uint256 constant TARGET = 1000 * 10 ** 18;
    address owner;

    AggregatorV3Interface internal dataFeed;


    constructor() {
        owner = msg.sender;
        dataFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }

    function fund() external payable {
        require(converETHToUSD(msg.value) >= MINIMUM_VALUE, "Send more USD");
        funderToAmount[msg.sender] = msg.value;
    }

    function getChainlinkDataFeedLatestAnswer() public view returns (int256) {
        // prettier-ignore
        (
        /* uint80 roundId */
        ,
        int256 answer,
        /*uint256 startedAt*/
        ,
        /*uint256 updatedAt*/
        ,
        /*uint80 answeredInRound*/
        ) = dataFeed.latestRoundData();
        return answer;
    }

    function converETHToUSD(uint256 ethAmount) internal view  returns (uint256){
        uint256 ethPrice = uint256(getChainlinkDataFeedLatestAnswer());
        // Chainlink 为了统一价格精度，绝大多数价格类 Data Feed（如 ETH/USD、BTC/USD、USDC/USD 等）的 answer 都会将实际价格放大 10^8 倍
        // 即：answer 的数值 = 实际价格 × 10^8
        return ethAmount * ethPrice / (10**8);
    }

    function getFund() external  {
        require(owner == msg.sender, "must be admin");
        require(converETHToUSD(address(this).balance) >= TARGET, "Target is not reached");
        funderToAmount[msg.sender] = 0;
        (bool success,) = payable(msg.sender).call{value: address(this).balance}("");
        require(success, "Call failed");
    }

    function refund() external {
        require(converETHToUSD(address(this).balance) < TARGET, "Target is reached.");
        require(funderToAmount[msg.sender] != 0, "There is no fund for you");
        funderToAmount[msg.sender] = 0;
        (bool success,) = payable(msg.sender).call{value: address(this).balance}("");
        require(success, "Call failed");
    }
}