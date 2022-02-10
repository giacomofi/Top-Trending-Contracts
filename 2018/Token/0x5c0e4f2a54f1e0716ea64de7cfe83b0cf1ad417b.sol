['pragma solidity ^0.4.18;\n', '\n', '// (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.\n', ' \n', 'library SafeMath {\n', '\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '\n', '        c = a + b;\n', '\n', '        require(c >= a);\n', '\n', '    }\n', '\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '\n', '        require(b <= a);\n', '\n', '        c = a - b;\n', '\n', '    }\n', '\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '\n', '        c = a * b;\n', '\n', '        require(a == 0 || c / a == b);\n', '\n', '    }\n', '\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '\n', '        require(b > 0);\n', '\n', '        c = a / b;\n', '\n', '    }\n', '\n', '}\n', ' \n', 'contract ERC20Interface {\n', '\n', '    function totalSupply() public constant returns (uint);\n', '\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '\n', '}\n', '\n', '\n', ' \n', 'contract ApproveAndCallFallBack {\n', '\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '\n', '}\n', '\n', ' \n', 'contract Owned {\n', '\n', '    address public owner;\n', '\n', '    address public newOwner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '\n', '    function Owned() public {\n', '\n', '        owner = msg.sender;\n', '\n', '    }\n', '\n', '\n', '    modifier onlyOwner {\n', '\n', '        require(msg.sender == owner);\n', '\n', '        _;\n', '\n', '    }\n', '\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '\n', '        newOwner = _newOwner;\n', '\n', '    }\n', '\n', '    function acceptOwnership() public {\n', '\n', '        require(msg.sender == newOwner);\n', '\n', '        OwnershipTransferred(owner, newOwner);\n', '\n', '        owner = newOwner;\n', '\n', '        newOwner = address(0);\n', '\n', '    }\n', '\n', '}\n', '\n', ' \n', 'contract PowrLedgerToken is ERC20Interface, Owned {\n', '\n', '    using SafeMath for uint;\n', '\n', '\n', '    string public symbol;\n', '\n', '    string public  name;\n', '\n', '    uint8 public decimals;\n', '\n', '    uint public _totalSupply;\n', '\n', '\n', '    mapping(address => uint) balances;\n', '\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '\n', ' \n', '    function PowrLedgerToken() public {\n', '\n', '        symbol = "POWR";\n', '\n', '        name = "PowrLedger (POWR)";\n', '\n', '        decimals = 18;\n', '\n', '        _totalSupply = 21 * 10**uint(decimals);\n', '\n', '        balances[owner] = _totalSupply;\n', '\n', '        Transfer(address(0), owner, _totalSupply);\n', '\n', '    }\n', '\n', ' \n', '    function totalSupply() public constant returns (uint) {\n', '\n', '        return _totalSupply  - balances[address(0)];\n', '\n', '    }\n', ' \n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '\n', '        return balances[tokenOwner];\n', '\n', '    }\n', '\n', '\n', ' \n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '\n', '        balances[to] = balances[to].add(tokens);\n', '\n', '        Transfer(msg.sender, to, tokens);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', ' \n', '\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '\n', '        allowed[msg.sender][spender] = tokens;\n', '\n', '        Approval(msg.sender, spender, tokens);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', ' \n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '\n', '        balances[from] = balances[from].sub(tokens);\n', '\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '\n', '        balances[to] = balances[to].add(tokens);\n', '\n', '        Transfer(from, to, tokens);\n', '\n', '        return true;\n', '\n', '    }\n', '  \n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '\n', '        return allowed[tokenOwner][spender];\n', '\n', '    }\n', '\n', ' \n', '    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {\n', '\n', '        allowed[msg.sender][spender] = tokens;\n', '\n', '        Approval(msg.sender, spender, tokens);\n', '\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '\n', '        return true;\n', '\n', '    }\n', ' \n', '    function () public payable {\n', '\n', '        revert();\n', '\n', '    }\n', ' \n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '\n', '        return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '\n', '    }\n', '\n', '}']