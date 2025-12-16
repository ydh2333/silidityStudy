// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// 简单的代币合约
contract SimpleToken {
    string public name;
    string public symbol;
    address public creator;
    uint256 public totalSupply;
    
    mapping(address => uint256) public balances;
    
    /**
     * @notice 构造函数：初始化代币
     * @param _name 代币名称
     * @param _symbol 代币符号
     * @param _supply 初始供应量
     */
    constructor(string memory _name, string memory _symbol, uint256 _supply) {
        name = _name;
        symbol = _symbol;
        creator = msg.sender;
        totalSupply = _supply;
        balances[msg.sender] = _supply;
    }
    
    /**
     * @notice 转账函数
     */
    function transfer(address to, uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[to] += amount;
    }
}

// 代币工厂合约
contract TokenFactory {
    // 记录所有创建的代币地址
    SimpleToken[] public tokens;
    
    // 记录每个用户创建的代币
    mapping(address => address[]) public userTokens;
    
    // 事件：记录代币创建
    event TokenCreated(
        address indexed tokenAddress,
        string name,
        string symbol,
        address indexed creator
    );
    
    /**
     * @notice 创建新代币
     * @param name 代币名称
     * @param symbol 代币符号
     * @param initialSupply 初始供应量
     * @return 新代币的地址
     * @dev 使用new关键字创建新合约实例
     */
    function createToken(
        string memory name,
        string memory symbol,
        uint256 initialSupply
    ) public returns (address) {
        // 使用new关键字创建新的代币合约
        SimpleToken newToken = new SimpleToken(name, symbol, initialSupply);
        
        // 记录新代币地址
        tokens.push(newToken);
        userTokens[msg.sender].push(address(newToken));
        
        // 发出事件
        emit TokenCreated(address(newToken), name, symbol, msg.sender);
        
        return address(newToken);
    }
    
    /**
     * @notice 查询创建的代币数量
     */
    function getTokenCount() public view returns (uint256) {
        return tokens.length;
    }
    
    /**
     * @notice 查询用户创建的所有代币
     * @param user 用户地址
     * @return 代币地址数组
     */
    function getUserTokens(address user) public view returns (address[] memory) {
        return userTokens[user];
    }
}