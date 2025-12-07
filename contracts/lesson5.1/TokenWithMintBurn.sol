// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TokenWithMintBurn{
    string public name="Young Token";
    string public symbol="YTK";
    uint public decimal = 18;
    uint256 public totalSupply;
    address public owner;
    bool public pauseState = false;

    // 余额
    mapping (address=>uint256) public balanceOf;
    // 授权额度
    mapping (address=>mapping (address=>uint256)) public allowance;

    // 转账事件
    event Transfer(address indexed form, address indexed to, uint256 value);
    // 授权事件
    event Approval(address indexed owener, address indexed spender, uint256 value);

    constructor(uint256 _inialSupply){
        owner = msg.sender;
        totalSupply = _inialSupply * 10 ** decimal;
        balanceOf[owner] = totalSupply;
        emit Transfer(address(0), owner, totalSupply);
    }


    modifier onlyOwener(){
        require(msg.sender == owner, "Only Owner");
        _;
    }

    modifier isPaused(){
        require(!pauseState,"Transfer paused");
        _;
    }

    // 转账
    function transfer(address _to, uint256 _amount) public isPaused returns (bool){
        // 零地址判定
        require(_to != address(0), "Zero address");
        // 判断转账者金额是否充足
        require(balanceOf[msg.sender] >= _amount,"Insufficients balance");
        
        balanceOf[msg.sender] -= _amount;
        balanceOf[_to] += _amount;

        emit Transfer(msg.sender, _to, _amount);
        return true;
    }

    // 授权
    function approval(address _spender, uint256 _amount) public isPaused returns (bool){
        require(_spender != address(0), "Zero address");

        allowance[msg.sender][_spender] = _amount;

        emit Approval(msg.sender, _spender, _amount);
        return true;
    }

    // 授权转账
    function transferForm(address _from, address _to, uint256 _amount) public isPaused returns (bool){
        require(_from != address(0), "From is zero address");
        require(_to != address(0), "To is zero address");
        require(balanceOf[_from] >= _amount, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _amount, "Insufficient amount");

        allowance[_from][msg.sender] -= _amount;
        balanceOf[_from] -= _amount;
        balanceOf[_to] += _amount;

        emit Approval(_from, _to, _amount);
        return true;
    }

    // 铸造货币
    function mint(address _to, uint256 _amount) public isPaused onlyOwener{
        require(_to != address(0), "Zero address");

        totalSupply += _amount;
        balanceOf[_to] += _amount;

        emit Transfer(address(0), _to, _amount);
    }

    // 销毁货币
    function burn(uint256 _amount) public isPaused {
        require(balanceOf[msg.sender] >= _amount, "Insufficient balance");

        totalSupply -= _amount;
        balanceOf[msg.sender] -= _amount;

        emit Transfer(msg.sender, address(0), _amount);
    }

    // 批量转账
    function batchTransfer(address[] memory _recipients, uint256[] memory _amounts) public isPaused returns (bool){
        require(_recipients.length==_amounts.length, "Unequal lengths");
        // 检查数组长度
        require(_recipients.length <= 3, "Length is limited");
        uint256 sum=0;
        for (uint i=0; i<_amounts.length;i++){
            sum += _amounts[i];
        }
        require(balanceOf[msg.sender] >= sum, "Insufficient aoumt");

        for (uint i = 0; i < _recipients.length;i++){
            require(_recipients[i] != address(0),"Zero address");
            require(_amounts[i] > 0,"Invalid amount");

            balanceOf[msg.sender] -= _amounts[i];
            balanceOf[_recipients[i]] += _amounts[i];

            emit Transfer(msg.sender, _recipients[i], _amounts[i]);
        }
        return true;
    }

    function pause() public onlyOwener returns (bool){
        require(!pauseState, "The state is paused");
        pauseState = true;
        return pauseState;
    }

        function unpause() public onlyOwener returns (bool){
        require(pauseState, "The state is not paused");
        pauseState = false;
        return pauseState;
    }

}