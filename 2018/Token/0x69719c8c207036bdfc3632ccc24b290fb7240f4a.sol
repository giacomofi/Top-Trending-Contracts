['pragma solidity ^0.4.2;\n', '\n', 'contract ERC20Interface {\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    \n', '}\n', '\n', 'contract BitPayToken is ERC20Interface {\n', '\n', '    string  public name;\n', '    string  public symbol;\n', '    uint8   public decimals;\n', '    uint256 public totalSupply;\n', '    \n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping (address => uint256)) allowed;\n', '    \n', '    function BitPayToken(uint256 initial_supply, string _name, string _symbol, uint8 _decimal) {\n', '\n', '        balances[msg.sender]  = initial_supply;\n', '        name                  = _name;\n', '        symbol                = _symbol;\n', '        decimals              = _decimal;\n', '        totalSupply           = initial_supply;\n', '\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transfer(address to, uint value) returns (bool success) {\n', '        if(balances[msg.sender] < value) return false;\n', '        if(balances[to] + value < balances[to]) return false;\n', '        \n', '        balances[msg.sender] -= value;\n', '        balances[to] += value;\n', '        \n', '        Transfer(msg.sender, to, value);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '    function transferFrom(address from, address to, uint value) returns (bool success) {\n', '\n', '        if(balances[from] < value) return false;\n', '        if( allowed[from][msg.sender] < value ) return false;\n', '        if(balances[to] + value < balances[to]) return false;\n', '        \n', '        balances[from] -= value;\n', '        allowed[from][msg.sender] -= value;\n', '        balances[to] += value;\n', '        \n', '        Transfer(from, to, value);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '\n', '        return allowed[_owner][_spender];\n', '\n', '    }\n', '\n', '    function approve(address _spender, uint256 _amount) returns (bool success) {\n', '\n', '        allowed[msg.sender][_spender] = _amount;\n', '        Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '\n', '    }\n', '\n', '}']