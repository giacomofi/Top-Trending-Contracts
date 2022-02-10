['pragma solidity ^0.4.25;\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '        return c;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'contract BaseToken {\n', '    using SafeMath for uint256;\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '    uint256 public _totalLimit;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    function _transfer(address from, address to, uint value) internal {\n', '        require(to != address(0));\n', '        balanceOf[from] = balanceOf[from].sub(value);\n', '        balanceOf[to] = balanceOf[to].add(value);\n', '        emit Transfer(from, to, value);\n', '    }\n', '\n', '    function _mint(address account, uint256 value) internal {\n', '        require(account != address(0));\n', '        totalSupply = totalSupply.add(value);\n', '        require(_totalLimit >= totalSupply);\n', '        balanceOf[account] = balanceOf[account].add(value);\n', '        emit Transfer(address(0), account, value);\n', '    }\n', '\n', '    function transfer(address to, uint256 value) public returns (bool) {\n', '        _transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '        allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);\n', '        _transfer(from, to, value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address spender, uint256 value) public returns (bool) {\n', '        require(spender != address(0));\n', '        allowance[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '        require(spender != address(0));\n', '        allowance[msg.sender][spender] = allowance[msg.sender][spender].add(addedValue);\n', '        emit Approval(msg.sender, spender, allowance[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '        require(spender != address(0));\n', '        allowance[msg.sender][spender] = allowance[msg.sender][spender].sub(subtractedValue);\n', '        emit Approval(msg.sender, spender, allowance[msg.sender][spender]);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract CustomToken is BaseToken {\n', '    constructor() public {\n', '        name = &#39;International data coin&#39;;\n', '        symbol = &#39;IDC&#39;;\n', '        decimals = 18;\n', '        totalSupply = 5000000000000000000000000;\n', '        _totalLimit = 100000000000000000000000000000000;\n', '        balanceOf[0x305897E62C08D92DBFD38e8Dd5d7eea4495b8c08] = totalSupply;\n', '        emit Transfer(address(0), 0x305897E62C08D92DBFD38e8Dd5d7eea4495b8c08, totalSupply);\n', '    }\n', '}']