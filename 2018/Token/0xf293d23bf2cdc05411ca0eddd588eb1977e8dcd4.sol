['pragma solidity ^0.4.15;\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        if (msg.sender != owner) {\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '\n', '}\n', '\n', 'contract SafeMath {\n', '    function safeSub(uint a, uint b) pure internal returns (uint) {\n', '        sAssert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function safeAdd(uint a, uint b) pure internal returns (uint) {\n', '        uint c = a + b;\n', '        sAssert(c>=a && c>=b);\n', '        return c;\n', '    }\n', '\n', '    function sAssert(bool assertion) pure internal {\n', '        if (!assertion) {\n', '            revert();\n', '        }\n', '    }\n', '}\n', '\n', 'contract ERC20 {\n', '    uint public totalSupply;\n', '    function balanceOf(address who) public constant returns (uint);\n', '    function allowance(address owner, address spender) public constant returns (uint);\n', '\n', '    function transfer(address to, uint value) public returns (bool ok);\n', '    function transferFrom(address from, address to, uint value) public returns (bool ok);\n', '    function approve(address spender, uint value) public returns (bool ok);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'contract StandardToken is ERC20, SafeMath {\n', '    mapping(address => uint) balances;\n', '    mapping (address => mapping (address => uint)) allowed;\n', '\n', '    function transfer(address _to, uint _value) public returns (bool success) {\n', '        balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {\n', '        var _allowance = allowed[_from][msg.sender];\n', '\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        balances[_from] = safeSub(balances[_from], _value);\n', '        allowed[_from][msg.sender] = safeSub(_allowance, _value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', 'contract SyloToken is Ownable, StandardToken {\n', '    string public name = "Sylo";\n', '    string public symbol = "SYLO";\n', '    uint public decimals = 18;\n', '\n', '    uint public totalSupply = 10000000000 ether;\n', '\n', '    function SyloToken() {\n', '        balances[msg.sender] = totalSupply;\n', '    }\n', '\n', '    function () public {\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        balances[_newOwner] = safeAdd(balances[owner], balances[_newOwner]);\n', '        balances[owner] = 0;\n', '        Ownable.transferOwnership(_newOwner);\n', '    }\n', '\n', '    function transferAnyERC20Token(address tokenAddress, uint amount) public onlyOwner returns (bool success) {\n', '        return ERC20(tokenAddress).transfer(owner, amount);\n', '    }\n', '}']
['pragma solidity ^0.4.15;\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        if (msg.sender != owner) {\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '\n', '}\n', '\n', 'contract SafeMath {\n', '    function safeSub(uint a, uint b) pure internal returns (uint) {\n', '        sAssert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function safeAdd(uint a, uint b) pure internal returns (uint) {\n', '        uint c = a + b;\n', '        sAssert(c>=a && c>=b);\n', '        return c;\n', '    }\n', '\n', '    function sAssert(bool assertion) pure internal {\n', '        if (!assertion) {\n', '            revert();\n', '        }\n', '    }\n', '}\n', '\n', 'contract ERC20 {\n', '    uint public totalSupply;\n', '    function balanceOf(address who) public constant returns (uint);\n', '    function allowance(address owner, address spender) public constant returns (uint);\n', '\n', '    function transfer(address to, uint value) public returns (bool ok);\n', '    function transferFrom(address from, address to, uint value) public returns (bool ok);\n', '    function approve(address spender, uint value) public returns (bool ok);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'contract StandardToken is ERC20, SafeMath {\n', '    mapping(address => uint) balances;\n', '    mapping (address => mapping (address => uint)) allowed;\n', '\n', '    function transfer(address _to, uint _value) public returns (bool success) {\n', '        balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {\n', '        var _allowance = allowed[_from][msg.sender];\n', '\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        balances[_from] = safeSub(balances[_from], _value);\n', '        allowed[_from][msg.sender] = safeSub(_allowance, _value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', 'contract SyloToken is Ownable, StandardToken {\n', '    string public name = "Sylo";\n', '    string public symbol = "SYLO";\n', '    uint public decimals = 18;\n', '\n', '    uint public totalSupply = 10000000000 ether;\n', '\n', '    function SyloToken() {\n', '        balances[msg.sender] = totalSupply;\n', '    }\n', '\n', '    function () public {\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        balances[_newOwner] = safeAdd(balances[owner], balances[_newOwner]);\n', '        balances[owner] = 0;\n', '        Ownable.transferOwnership(_newOwner);\n', '    }\n', '\n', '    function transferAnyERC20Token(address tokenAddress, uint amount) public onlyOwner returns (bool success) {\n', '        return ERC20(tokenAddress).transfer(owner, amount);\n', '    }\n', '}']
