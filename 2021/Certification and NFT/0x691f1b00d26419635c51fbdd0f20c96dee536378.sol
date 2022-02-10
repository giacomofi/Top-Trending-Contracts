['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-10\n', '*/\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender)\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    function transfer(address recipient, uint256 amount)\n', '        external\n', '        returns (bool);\n', '\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    function transferFrom(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) external returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    );\n', '}\n', '\n', 'contract BZZ is IERC20 {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public constant decimals = 18;\n', '\n', '    event Approval(\n', '        address indexed tokenOwner,\n', '        address indexed spender,\n', '        uint256 tokens\n', '    );\n', '    event Transfer(address indexed from, address indexed to, uint256 tokens);\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '\n', '    uint256 totalSupply_;\n', '\n', '    using SafeMath for uint256;\n', '\n', '    constructor(\n', '        string memory tokenName,\n', '        string memory tokenSymbol,\n', '        uint256 total\n', '    ) public {\n', '        totalSupply_ = total * 10**uint256(decimals);\n', '        balances[msg.sender] = totalSupply_;\n', '        name = tokenName;\n', '        symbol = tokenSymbol;\n', '    }\n', '\n', '    function totalSupply() public override view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    function balanceOf(address tokenOwner)\n', '        public\n', '        override\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    function transfer(address receiver, uint256 numTokens)\n', '        public\n', '        override\n', '        returns (bool)\n', '    {\n', '        require(numTokens <= balances[msg.sender]);\n', '        balances[msg.sender] = balances[msg.sender].sub(numTokens);\n', '        balances[receiver] = balances[receiver].add(numTokens);\n', '        emit Transfer(msg.sender, receiver, numTokens);\n', '        return true;\n', '    }\n', '\n', '    function approve(address delegate, uint256 numTokens)\n', '        public\n', '        override\n', '        returns (bool)\n', '    {\n', '        allowed[msg.sender][delegate] = numTokens;\n', '        emit Approval(msg.sender, delegate, numTokens);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address owner, address delegate)\n', '        public\n', '        override\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return allowed[owner][delegate];\n', '    }\n', '\n', '    function transferFrom(\n', '        address owner,\n', '        address buyer,\n', '        uint256 numTokens\n', '    ) public override returns (bool) {\n', '        require(numTokens <= balances[owner]);\n', '        require(numTokens <= allowed[owner][msg.sender]);\n', '\n', '        balances[owner] = balances[owner].sub(numTokens);\n', '        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);\n', '        balances[buyer] = balances[buyer].add(numTokens);\n', '        emit Transfer(owner, buyer, numTokens);\n', '        return true;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}']