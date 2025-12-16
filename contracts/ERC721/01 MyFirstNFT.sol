// SPDX-License-Identifier: MIT
// 指定 Solidity 版本，0.8.20 是稳定且常用的版本
pragma solidity ^0.8.20;

// 引入 OpenZeppelin 的 ERC721 核心库和所有权管理库（可选）
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// 合约继承 ERC721（核心 NFT 功能）和 Ownable（权限管理，仅所有者可铸造）
contract MyFirstNFT is ERC721, Ownable {
    // 代币 ID 计数器，保证每个 NFT 唯一
    uint256 private _tokenIdCounter;

    // 构造函数：初始化 NFT 名称和符号，Ownable 初始化所有者为部署者
    constructor() ERC721("MyFirstNFT", "MFN") Ownable(msg.sender) {}

    // 铸造 NFT 函数：仅所有者可调用，_to 是接收者地址
    function safeMint(address to) public onlyOwner {
        // 获取当前代币 ID（从 1 开始，避免 0 ID 可能的问题）
        uint256 tokenId = _tokenIdCounter + 1;
        // 自增计数器，为下一次铸造准备
        _tokenIdCounter = tokenId;
        // OpenZeppelin 封装的安全铸造函数（会检查接收者是否支持 ERC721）
        _safeMint(to, tokenId);
    }

    // 可选：获取当前已铸造的 NFT 总数
    function getTotalSupply() public view returns (uint256) {
        return _tokenIdCounter;
    }
}