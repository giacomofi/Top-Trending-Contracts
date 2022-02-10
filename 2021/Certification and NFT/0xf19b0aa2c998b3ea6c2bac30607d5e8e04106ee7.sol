['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-06\n', '*/\n', '\n', '// SPDX-License-Identifier: UNLICENSED\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' *\n', '*/\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function ceil(uint a, uint m) internal pure returns (uint r) {\n', '    return (a + m - 1) / m * m; \n', '  }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address payable public owner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner, "Only allowed by owner");\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address payable _newOwner) external onlyOwner {\n', '        require(_newOwner != address(0),"Invalid address passed");\n', '        owner = _newOwner;\n', '        emit OwnershipTransferred(msg.sender, _newOwner);\n', '    }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'abstract contract ERC20Interface {\n', '    function totalSupply() public virtual view returns (uint);\n', '    function balanceOf(address tokenOwner) public virtual view returns (uint256 balance);\n', '    function allowance(address tokenOwner, address spender) public virtual view returns (uint256 remaining);\n', '    function transfer(address to, uint256 tokens) public virtual returns (bool success);\n', '    function approve(address spender, uint256 tokens) public virtual returns (bool success);\n', '    function transferFrom(address from, address to, uint256 tokens) public virtual returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', "// 'Infinity Yield Token' token contract\n", '\n', '// Symbol      : IFY\n', '// Name        : Infinity Yield Token\n', '// Total supply: 250,000 (250 Thousand)\n', '// Decimals    : 18\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20 Token, with the addition of symbol, name and decimals and assisted\n', '// token transfers\n', '// ----------------------------------------------------------------------------\n', 'contract Token is ERC20Interface, Owned {\n', '    using SafeMath for uint256;\n', '\n', '    string public constant symbol = "IFY";\n', '    string public  constant name = "Infinity Yield";\n', '    uint256 public constant decimals = 18;\n', '    uint256 private _totalSupply = 250000 * 10 ** (decimals);\n', '    uint256 public tax = 5;\n', '    \n', '    address public STAKING_ADDRESS;\n', '    address public PRESALE_ADDRESS;\n', '    address public taxReceiver; // 10%\n', '    \n', '    mapping(address => uint256) private balances;\n', '    mapping(address => mapping(address => uint256)) private allowed;\n', '    \n', '    event TaxChanged(uint256 newTax, address changedBy);\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    constructor(address _stakingAddress, address preSaleAddress) public {\n', '        taxReceiver = 0x8D74DaBe71b1b95b4e4c90E5A97850FEB9C20855;\n', '        owner = 0xa97F07bc8155f729bfF5B5312cf42b6bA7c4fCB9;\n', '        STAKING_ADDRESS = _stakingAddress;\n', '        PRESALE_ADDRESS = preSaleAddress;\n', '        balances[owner] = totalSupply();\n', '        emit Transfer(address(0), owner, totalSupply());\n', '\n', '    }\n', '    \n', '    function ChangeTax(uint256 _newTax) external onlyOwner{\n', '        tax = _newTax;\n', '        emit TaxChanged(_newTax, msg.sender);\n', '    }\n', '\n', "    /** ERC20Interface function's implementation **/\n", '\n', '    function totalSupply() public override view returns (uint256){\n', '       return _totalSupply;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public override view returns (uint256 balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Transfer the balance from token owner's account to `to` account\n", "    // - Owner's account must have sufficient balance to transfer\n", '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint256 tokens) public override returns (bool success) {\n', '        require(address(to) != address(0) , "Invalid address");\n', '        require(balances[msg.sender] >= tokens, "insufficient sender\'s balance");\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        uint256 deduction = 0;\n', '        // if the sender and receiver address is not staking address, apply tax \n', '        if (to != STAKING_ADDRESS && msg.sender != STAKING_ADDRESS && to!= PRESALE_ADDRESS && msg.sender != PRESALE_ADDRESS){\n', '            deduction = onePercent(tokens).mul(tax); // Calculates the tax to be applied on the amount transferred\n', '            uint256 _OS = onePercent(deduction).mul(10); // 10% will go to owner\n', '            balances[taxReceiver] = balances[taxReceiver].add(_OS);\n', '            emit Transfer(address(this), taxReceiver, _OS);\n', '            balances[STAKING_ADDRESS] = balances[STAKING_ADDRESS].add(deduction.sub(_OS)); // add the tax deducted to the staking pool for rewards\n', '            emit Transfer(address(this), STAKING_ADDRESS, deduction.sub(_OS));\n', '        }\n', '        balances[to] = balances[to].add(tokens.sub(deduction));\n', '        emit Transfer(msg.sender, to, tokens.sub(deduction));\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account\n", '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint256 tokens) public override returns (bool success){\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender,spender,tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    //\n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint256 tokens) public override returns (bool success){\n', '        require(tokens <= allowed[from][msg.sender], "insufficient allowance"); //check allowance\n', '        require(balances[from] >= tokens, "Insufficient senders balance");\n', '        balances[from] = balances[from].sub(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '\n', '        uint256 deduction = 0;\n', '        // if the sender and receiver address is not staking address, apply tax \n', '        if (to != STAKING_ADDRESS && from != STAKING_ADDRESS && to!= PRESALE_ADDRESS && from != PRESALE_ADDRESS){\n', '            deduction = onePercent(tokens).mul(tax); // Calculates the tax to be applied on the amount transferred\n', '            uint256 _OS = onePercent(deduction).mul(10); // 10% will go to owner\n', '            balances[taxReceiver] = balances[taxReceiver].add(_OS); \n', '            emit Transfer(address(this), taxReceiver, _OS);\n', '            balances[STAKING_ADDRESS] = balances[STAKING_ADDRESS].add(deduction.sub(_OS)); // add the tax deducted to the staking pool for rewards\n', '            emit Transfer(address(this), STAKING_ADDRESS, deduction.sub(_OS));\n', '        }\n', '        \n', '        balances[to] = balances[to].add(tokens.sub(deduction)); // send rest of the amount to the receiver after deduction\n', '        emit Transfer(from, to, tokens.sub(tokens));\n', '        return true;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', "    // transferred to the spender's account\n", '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public override view returns (uint256 remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '    \n', '    /**UTILITY***/\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Calculates onePercent of the uint256 amount sent\n', '    // ------------------------------------------------------------------------\n', '    function onePercent(uint256 _tokens) internal pure returns (uint256){\n', '        uint256 roundValue = _tokens.ceil(100);\n', '        uint onePercentofTokens = roundValue.mul(100).div(100 * 10**uint(2));\n', '        return onePercentofTokens;\n', '    }\n', '}']