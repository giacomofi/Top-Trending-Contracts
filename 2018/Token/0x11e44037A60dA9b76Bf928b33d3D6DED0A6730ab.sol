['pragma solidity ^0.4.18;\n', '\n', 'pragma solidity ^0.4.18;\n', '\n', '// ----------------------------------------------------------------------------\n', '// &#39;FIXED&#39; &#39;Example Fixed Supply Token&#39; token contract\n', '//\n', '// Symbol      : FIXED\n', '// Name        : Example Fixed Supply Token\n', '// Total supply: 1,000,000.000000000000000000\n', '// Decimals    : 18\n', '//\n', '// Enjoy.\n', '//\n', '// (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Safe maths\n', '// ----------------------------------------------------------------------------\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Contract function to receive approval and execute function in one call\n', '//\n', '// Borrowed from MiniMeToken\n', '// ----------------------------------------------------------------------------\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20 Token, with the addition of symbol, name and decimals and an\n', '// initial fixed supply\n', '// ----------------------------------------------------------------------------\n', 'contract FixedSupplyToken is ERC20Interface, Owned {\n', '    using SafeMath for uint;\n', '\n', '    string public symbol;\n', '    string public  name;\n', '    uint8 public decimals;\n', '    uint public _totalSupply;\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    function FixedSupplyToken() public {\n', '        symbol = "FIXED";\n', '        name = "Example Fixed Supply Token";\n', '        decimals = 18;\n', '        _totalSupply = 1000000 * 10**uint(decimals);\n', '        balances[owner] = _totalSupply;\n', '        Transfer(address(0), owner, _totalSupply);\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public constant returns (uint) {\n', '        return _totalSupply  - balances[address(0)];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer the balance from token owner&#39;s account to `to` account\n', '    // - Owner&#39;s account must have sufficient balance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', '    // from the token owner&#39;s account\n', '    //\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces \n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    // \n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        balances[from] = balances[from].sub(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', '    // transferred to the spender&#39;s account\n', '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', '    // from the token owner&#39;s account. The `spender` contract function\n', '    // `receiveApproval(...)` is then executed\n', '    // ------------------------------------------------------------------------\n', '    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        Approval(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Don&#39;t accept ETH\n', '    // ------------------------------------------------------------------------\n', '    function () public payable {\n', '        revert();\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Owner can transfer out any accidentally sent ERC20 tokens\n', '    // ------------------------------------------------------------------------\n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '        return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '    }\n', '}\n', '\n', '/*\n', ' * ERC20 interface\n', ' */\n', 'contract ERC20 {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function transfer(address to, uint value);\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '\n', '  function transferFrom(address from, address to, uint value);\n', '  function approve(address spender, uint value);\n', '\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'contract ExxStandart is ERC20 {\n', '    using SafeMath for uint;\n', '    \n', '\tstring  public name        = "Exxcoin";\n', '    string  public symbol      = "EXX";\n', '    uint8   public decimals    = 0;\n', '\n', '\tmapping (address => mapping (address => uint)) allowed;\n', '\tmapping (address => uint) balances;\n', '\n', '\tfunction transferFrom(address _from, address _to, uint _value) {\n', '\t\tbalances[_from] = balances[_from].sub(_value);\n', '\t\tallowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '\t\tbalances[_to] = balances[_to].add(_value);\n', '\t\tTransfer(_from, _to, _value);\n', '\t}\n', '\n', '\tfunction approve(address _spender, uint _value) {\n', '\t\tallowed[msg.sender][_spender] = _value;\n', '\t\tApproval(msg.sender, _spender, _value);\n', '\t}\n', '\n', '\tfunction allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '\t\treturn allowed[_owner][_spender];\n', '\t}\n', '\n', '\tfunction transfer(address _to, uint _value) {\n', '\t\tbalances[msg.sender] = balances[msg.sender].sub(_value);\n', '\t\tbalances[_to] = balances[_to].add(_value);\n', '\t\tTransfer(msg.sender, _to, _value);\n', '\t}\n', '\n', '\tfunction balanceOf(address _owner) constant returns (uint balance) {\n', '\t\treturn balances[_owner];\n', '\t}\n', '}\n', '\n', 'contract owned {\n', '    \n', '    address public owner;\n', '    address public newOwner;\n', '\t\n', '    function owned() public payable {\n', '        owner = msg.sender;\n', '    }\n', '\t\n', '    modifier onlyOwner {\n', '        require(owner == msg.sender);\n', '        _; /* return */\n', '    }\n', '\t\n', '    function changeOwner(address _owner) onlyOwner public {\n', '        require(_owner != 0);\n', '        newOwner = _owner;\n', '    }\n', '    \n', '    function confirmOwner() public {\n', '        require(newOwner == msg.sender);\n', '        owner = newOwner;\n', '        delete newOwner;\n', '    }\n', '}\n', '\n', 'contract Exxcoin is owned, ExxStandart {\n', '\taddress public manager = 0x0;\n', '\n', '\tmodifier onlyManager {\n', '\t\trequire(manager == msg.sender);\n', '\t\t_;\n', '\t}\n', '    \n', '    function changeTotalSupply(uint _totalSupply) onlyOwner public {\n', '        totalSupply = _totalSupply;\n', '    }\n', '    \n', '\tfunction setManager(address _manager) onlyOwner public {\n', '\t\tmanager = _manager;\n', '\t}\n', '\n', '\tfunction delManager() onlyOwner public {\n', '\t\tmanager = 0x123;\n', '\t}\n', '\n', '    function () payable {\n', '\t\t\n', '\t}\n', '\n', '    function sendTokensManager(address _to, uint _tokens) onlyManager public{\n', '\t\trequire(manager != 0x0);\n', '\t\t_to.send(_tokens);\n', '\t\tbalances[_to] = _tokens;\n', '        Transfer(msg.sender, _to, _tokens);\n', '\t}\n', '\n', '    function sendTokens(address _to, uint _tokens) onlyOwner public{\n', '\t\t_to.send(_tokens);\n', '\t\tbalances[_to] = _tokens;\n', '        Transfer(msg.sender, _to, _tokens);\n', '    }\n', '}']