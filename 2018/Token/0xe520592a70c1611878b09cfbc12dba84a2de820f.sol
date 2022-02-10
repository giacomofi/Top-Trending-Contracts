['pragma solidity ^0.4.8;\n', '\n', 'contract ERC20 {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '    \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal returns (uint) {\n', '    uint c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      throw;\n', '    }\n', '  }\n', '}\n', '\n', 'contract Token is ERC20 {\n', '\n', '    using SafeMath for uint;\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    \n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] = balances[msg.sender].sub(_value);\n', '            balances[_to] = balances[_to].add(_value);\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            var _allowance = allowed[_from][msg.sender];\n', '            balances[_to] = balances[_to].add(_value);\n', '            balances[_from] = balances[_from].sub(_value);\n', '            allowed[_from][msg.sender] = _allowance.sub(_value);\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        if(_value >= 0) {\n', '          allowed[msg.sender][_spender] = _value;\n', '          Approval(msg.sender, _spender, _value);\n', '          return true;\n', '        } else { return false; }\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', 'contract OtcgateToken is Token {\n', '    \n', '    string public version = &#39;v1.0&#39;;\n', '    string public name;\n', '    uint8 public decimals;\n', '    string public symbol;\n', '    address public master;\n', '    \n', '    function OtcgateToken(uint256 _initialAmount, uint8 _decimalUnits, string _tokenName, string _tokenSymbol, address _master) {\n', '        decimals = _decimalUnits;\n', '        master = _master;\n', '        totalSupply = _initialAmount * 10**uint(decimals);\n', '        balances[master] = totalSupply;\n', '        name = _tokenName;\n', '        symbol = _tokenSymbol;\n', '    }\n', '    \n', '}']