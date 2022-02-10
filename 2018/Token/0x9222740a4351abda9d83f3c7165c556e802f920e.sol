['pragma solidity ^0.4.13;\n', '\n', 'contract Receiver {\n', '  function tokenFallback(address from, uint value, bytes data);\n', '}\n', '\n', 'contract ERC20 {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint);\n', '  function allowance(address owner, address spender) public constant returns (uint);\n', '\n', '  function transfer(address to, uint value) public returns (bool ok);\n', '  function transferFrom(address from, address to, uint value) public returns (bool ok);\n', '  function approve(address spender, uint value) public returns (bool ok);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'contract SafeMath {\n', '  function safeMul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint a, uint b) internal returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      revert();\n', '    }\n', '  }\n', '}\n', '\n', 'contract StandardToken is ERC20, SafeMath {\n', '  event Transfer(address indexed from, address indexed to, uint indexed value, bytes data);\n', '\n', '  event Minted(address receiver, uint amount);\n', '\n', '  mapping(address => uint) balances;\n', '\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '  modifier onlyPayloadSize(uint size) {\n', '     if(msg.data.length != size + 4) {\n', '       revert();\n', '     }\n', '     _;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) public returns (bool success) {\n', '      bytes memory _empty;\n', '\n', '      return transfer(_to, _value, _empty);\n', '  }\n', '\n', '  function transfer(address _to, uint _value, bytes _data) public returns (bool success) {\n', '    balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    Transfer(msg.sender, _to, _value, _data);\n', '    Transfer(msg.sender, _to, _value);\n', '\n', '    if (isContract(_to)) {\n', '      Receiver(_to).tokenFallback(msg.sender, _value, _data);\n', '    }\n', '\n', '    return true;\n', '  }\n', '\n', '  function isContract( address _addr ) private returns (bool) {\n', '    uint length;\n', '    _addr = _addr;\n', '    assembly { length := extcodesize(_addr) }\n', '    return (length > 0);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value) public returns (bool success) {\n', '    uint _allowance = allowed[_from][msg.sender];\n', '\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    balances[_from] = safeSub(balances[_from], _value);\n', '    allowed[_from][msg.sender] = safeSub(_allowance, _value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) public constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint _value) public returns (bool success) {\n', '\n', '    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '}\n', '\n', '\n', '\n', 'contract BurnableToken is StandardToken {\n', '\n', '  address public constant BURN_ADDRESS = 0;\n', '\n', '  event Burned(address burner, uint burnedAmount);\n', '\n', '  function burn(uint burnAmount) public {\n', '    address burner = msg.sender;\n', '    balances[burner] = safeSub(balances[burner], burnAmount);\n', '    totalSupply = safeSub(totalSupply, burnAmount);\n', '    Burned(burner, burnAmount);\n', '  }\n', '}\n', '\n', '\n', 'contract ReferralWeToken is BurnableToken {\n', '\n', '  string public name;\n', '  string public symbol;\n', '  uint public decimals;\n', '  address public owner;\n', '\n', '  modifier onlyOwner() {\n', '    if(msg.sender != owner) revert();\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '  function ReferralWeToken(address _owner, uint _totalSupply) public {\n', '    name = "refwttoken";\n', '    symbol = "RefWT";\n', '    decimals = 0;\n', '    totalSupply = _totalSupply;\n', '\n', '    balances[_owner] = totalSupply;\n', '\n', '    owner = _owner;\n', '  }\n', '}']
['pragma solidity ^0.4.13;\n', '\n', 'contract Receiver {\n', '  function tokenFallback(address from, uint value, bytes data);\n', '}\n', '\n', 'contract ERC20 {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint);\n', '  function allowance(address owner, address spender) public constant returns (uint);\n', '\n', '  function transfer(address to, uint value) public returns (bool ok);\n', '  function transferFrom(address from, address to, uint value) public returns (bool ok);\n', '  function approve(address spender, uint value) public returns (bool ok);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'contract SafeMath {\n', '  function safeMul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint a, uint b) internal returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      revert();\n', '    }\n', '  }\n', '}\n', '\n', 'contract StandardToken is ERC20, SafeMath {\n', '  event Transfer(address indexed from, address indexed to, uint indexed value, bytes data);\n', '\n', '  event Minted(address receiver, uint amount);\n', '\n', '  mapping(address => uint) balances;\n', '\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '  modifier onlyPayloadSize(uint size) {\n', '     if(msg.data.length != size + 4) {\n', '       revert();\n', '     }\n', '     _;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) public returns (bool success) {\n', '      bytes memory _empty;\n', '\n', '      return transfer(_to, _value, _empty);\n', '  }\n', '\n', '  function transfer(address _to, uint _value, bytes _data) public returns (bool success) {\n', '    balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    Transfer(msg.sender, _to, _value, _data);\n', '    Transfer(msg.sender, _to, _value);\n', '\n', '    if (isContract(_to)) {\n', '      Receiver(_to).tokenFallback(msg.sender, _value, _data);\n', '    }\n', '\n', '    return true;\n', '  }\n', '\n', '  function isContract( address _addr ) private returns (bool) {\n', '    uint length;\n', '    _addr = _addr;\n', '    assembly { length := extcodesize(_addr) }\n', '    return (length > 0);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value) public returns (bool success) {\n', '    uint _allowance = allowed[_from][msg.sender];\n', '\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    balances[_from] = safeSub(balances[_from], _value);\n', '    allowed[_from][msg.sender] = safeSub(_allowance, _value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) public constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint _value) public returns (bool success) {\n', '\n', '    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '}\n', '\n', '\n', '\n', 'contract BurnableToken is StandardToken {\n', '\n', '  address public constant BURN_ADDRESS = 0;\n', '\n', '  event Burned(address burner, uint burnedAmount);\n', '\n', '  function burn(uint burnAmount) public {\n', '    address burner = msg.sender;\n', '    balances[burner] = safeSub(balances[burner], burnAmount);\n', '    totalSupply = safeSub(totalSupply, burnAmount);\n', '    Burned(burner, burnAmount);\n', '  }\n', '}\n', '\n', '\n', 'contract ReferralWeToken is BurnableToken {\n', '\n', '  string public name;\n', '  string public symbol;\n', '  uint public decimals;\n', '  address public owner;\n', '\n', '  modifier onlyOwner() {\n', '    if(msg.sender != owner) revert();\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '  function ReferralWeToken(address _owner, uint _totalSupply) public {\n', '    name = "refwttoken";\n', '    symbol = "RefWT";\n', '    decimals = 0;\n', '    totalSupply = _totalSupply;\n', '\n', '    balances[_owner] = totalSupply;\n', '\n', '    owner = _owner;\n', '  }\n', '}']
