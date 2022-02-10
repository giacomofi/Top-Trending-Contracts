['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-15\n', '*/\n', '\n', 'pragma solidity 0.8.4;\n', '\n', '// ----------------------------------------------------------------------------\n', '// MARAN token main contract (2021) \n', '//\n', '// Symbol       : MARAN\n', '// Name         : MARAN\n', '// Total supply : 100.000.000.000\n', '// Decimals     : 18\n', '// ----------------------------------------------------------------------------\n', '// SPDX-License-Identifier: MIT\n', '// ----------------------------------------------------------------------------\n', '\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) { c = a + b; require(c >= a); }\n', '    function sub(uint a, uint b) internal pure returns (uint c) { require(b <= a); c = a - b; }\n', '    function mul(uint a, uint b) internal pure returns (uint c) { c = a * b; require(a == 0 || c / a == b); }\n', '    function div(uint a, uint b) internal pure returns (uint c) { require(b > 0); c = a / b; }\n', '}\n', '\n', 'abstract contract ERC20Interface {\n', '    function totalSupply() public virtual view returns (uint);\n', '    function balanceOf(address tokenOwner) public virtual view returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public virtual view returns (uint remaining);\n', '    function transfer(address to, uint tokens) public virtual returns (bool success) ;\n', '    function approve(address spender, uint tokens) public virtual returns (bool success) ;\n', '    function transferFrom(address from, address to, uint tokens) public virtual returns (bool success) ;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', 'abstract contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint tokens, address token, bytes memory data) public virtual;\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed from, address indexed to);\n', '\n', '    constructor() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address transferOwner) public onlyOwner {\n', '        require(transferOwner != newOwner);\n', '        newOwner = transferOwner;\n', '    }\n', '\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// MARAN ERC20 Token \n', '// ----------------------------------------------------------------------------\n', 'contract MARAN is ERC20Interface, Owned {\n', '    using SafeMath for uint;\n', '\n', '    bool public running = true;\n', '    bool public blacklisting = true;\n', '    string public symbol;\n', '    string public name;\n', '    uint8 public decimals;\n', '    uint _totalSupply;\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => uint) blacklist;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '    constructor() {\n', '        symbol = "MARAN";\n', '        name = "MARAN";\n', '        decimals = 18;\n', '        _totalSupply = 100000000000 * 10**uint(decimals);\n', '        balances[owner] = _totalSupply;\n', '        emit Transfer(address(0), owner, _totalSupply);\n', '    }\n', '\n', '    modifier isRunning {\n', '        require(running);\n', '        _;\n', '    }\n', '\n', '    function startStopContract () public onlyOwner returns (bool success) {\n', '        if (running) { running = false; } else { running = true; }\n', '        return true;\n', '    }\n', '    \n', '    function startStopBlacklist () public onlyOwner returns (bool success) {\n', '        if (blacklisting) { blacklisting = false; } else { blacklisting = true; }\n', '        return true;\n', '    }\n', '\n', '    function totalSupply() public override  view returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address tokenOwner) public override view returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '    \n', '    function blacklistOf(address tokenOwner) public view returns (uint blacklistTime) {\n', '        return blacklist[tokenOwner];\n', '    }\n', '\n', '    function transfer(address to, uint tokens) public override isRunning returns (bool success) {\n', '        require(tokens <= balances[msg.sender]);\n', '        require(to != address(0));\n', '        _transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    function _transfer(address from, address to, uint256 tokens) internal {\n', '        blackcheck(from);\n', '        balances[from] = balances[from].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(from, to, tokens);\n', '    }\n', '\n', '    function approve(address spender, uint tokens) public override isRunning returns (bool success) {\n', '        _approve(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '    function increaseAllowance(address spender, uint addedTokens) public isRunning returns (bool success) {\n', '        _approve(msg.sender, spender, allowed[msg.sender][spender].add(addedTokens));\n', '        return true;\n', '    }\n', '\n', '    function decreaseAllowance(address spender, uint subtractedTokens) public isRunning returns (bool success) {\n', '        _approve(msg.sender, spender, allowed[msg.sender][spender].sub(subtractedTokens));\n', '        return true;\n', '    }\n', '\n', '    function approveAndCall(address spender, uint tokens, bytes memory data) public isRunning returns (bool success) {\n', '        _approve(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);\n', '        return true;\n', '    }\n', '\n', '    function _approve(address owner, address spender, uint256 value) internal {\n', '        require(owner != address(0));\n', '        require(spender != address(0));\n', '        allowed[owner][spender] = value;\n', '        emit Approval(owner, spender, value);\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint tokens) public override isRunning returns (bool success) {\n', '        require(to != address(0));\n', '        _approve(from, msg.sender, allowed[from][msg.sender].sub(tokens));\n', '        _transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address tokenOwner, address spender) public override view returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '        return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '    }\n', '    \n', '    function burnTokens(uint tokens) public returns (bool success) {\n', '        require(tokens <= balances[msg.sender]);\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        _totalSupply = _totalSupply.sub(tokens);\n', '        emit Transfer(msg.sender, address(0), tokens);\n', '        return true;\n', '    }\n', '\n', '    function mintTokens(uint256 tokens) public onlyOwner returns (bool success) {\n', '        balances[msg.sender] = balances[msg.sender].add(tokens);\n', '        _totalSupply = _totalSupply.add(tokens);\n', '        emit Transfer(address(0), msg.sender, tokens);\n', '        return true;\n', '    } \n', '    \n', '    function blackcheck(address from) internal  {\n', '        if (blacklisting == true) { require(blacklist[from] <= block.timestamp, "YOU ARE BLACKLISTED"); }\n', '    }\n', '    \n', '    function addToBlacklist(address tokenOwner, uint256 time) public onlyOwner returns (bool success) {\n', '        require(time != 0);\n', '        blacklist[tokenOwner] = time;\n', '        return true;\n', '    } \n', '    \n', '    function removeFromBlacklist(address tokenOwner) public onlyOwner returns (bool success) {\n', '        blacklist[tokenOwner] = 0;\n', '        return true;\n', '    } \n', '\n', '    function multisend(address[] memory to, uint[] memory values) public returns (uint) {\n', '        blackcheck(msg.sender);\n', '        require(to.length == values.length);\n', '        require(to.length < 100);\n', '        uint sum;\n', '        for (uint j; j < values.length; j++) {\n', '            sum += values[j];\n', '        }\n', '        require(sum <= balances[msg.sender]);\n', '        balances[msg.sender] = balances[owner].sub(sum);\n', '        for (uint i; i < to.length; i++) {\n', '            balances[to[i]] = balances[to[i]].add(values[i]);\n', '            emit Transfer(owner, to[i], values[i]);\n', '        }\n', '        return(to.length);\n', '    }\n', '}']