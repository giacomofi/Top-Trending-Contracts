['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-12\n', '*/\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'interface IERC20 {\n', '\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'contract ERC20Basic is IERC20 {\n', '\n', '    string public constant name = "The Most Non Discriminatory Vegetable Everrr";\n', '    string public constant symbol = "LETTUCE";\n', '    uint8 public constant decimals = 18;\n', '\n', '\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    mapping(address => mapping (address => uint256)) allowed;\n', '\n', '    uint256 totalSupply_;\n', '\n', '    using SafeMath for uint256;\n', '\n', '\n', '   constructor(uint256 total) public {\n', '    totalSupply_ = total;\n', '    balances[msg.sender] = totalSupply_;\n', '    }\n', '\n', '    function totalSupply() public override view returns (uint256) {\n', '    return totalSupply_;\n', '    }\n', '\n', '    function balanceOf(address tokenOwner) public override view returns (uint256) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    function transfer(address receiver, uint256 numTokens) public override returns (bool) {\n', '        require(numTokens <= balances[msg.sender]);\n', '        balances[msg.sender] = balances[msg.sender].sub(numTokens);\n', '        balances[receiver] = balances[receiver].add(numTokens);\n', '        emit Transfer(msg.sender, receiver, numTokens);\n', '        return true;\n', '    }\n', '\n', '    function approve(address delegate, uint256 numTokens) public override returns (bool) {\n', '        allowed[msg.sender][delegate] = numTokens;\n', '        emit Approval(msg.sender, delegate, numTokens);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address owner, address delegate) public override view returns (uint) {\n', '        return allowed[owner][delegate];\n', '    }\n', '\n', '    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool) {\n', '        require(numTokens <= balances[owner]);\n', '        require(numTokens <= allowed[owner][msg.sender]);\n', '\n', '        balances[owner] = balances[owner].sub(numTokens);\n', '        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);\n', '        balances[buyer] = balances[buyer].add(numTokens);\n', '        emit Transfer(owner, buyer, numTokens);\n', '        return true;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '      assert(b <= a);\n', '      return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '      uint256 c = a + b;\n', '      assert(c >= a);\n', '      return c;\n', '    }\n', '}']