['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-31\n', '*/\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'contract ERC20Interface {\n', '    function totalSupply() public view returns (uint);\n', '    function balanceOf(address tokenOwner) public view returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', 'contract LUB is ERC20Interface {\n', '    using SafeMath for uint;\n', '    \n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '   \n', '    uint256 public _totalSupply;\n', '   \n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '   \n', '    constructor() public {\n', '        name = "Long Until Binance";\n', '        symbol = "LUB";\n', '        decimals = 18;\n', '        _totalSupply = 10550000000000000000000000;\n', '       \n', '        balances[msg.sender] = _totalSupply;\n', '        emit Transfer(address(0), msg.sender, _totalSupply);\n', '    }\n', '   \n', '    function totalSupply() public view returns (uint) {\n', '        return _totalSupply  - balances[address(0)];\n', '    }\n', '   \n', '    function balanceOf(address tokenOwner) public view returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '   \n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '   \n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '   \n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '   \n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        balances[from] = balances[from].sub(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '}']