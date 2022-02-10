['pragma solidity ^0.4.12;\n', '\n', '/*\n', ' * ERC20 interface\n', ' * see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '\n', '  function transfer(address to, uint value) returns (bool ok);\n', '  function transferFrom(address from, address to, uint value) returns (bool ok);\n', '  function approve(address spender, uint value) returns (bool ok);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'contract SafeMath {\n', '  function safeMul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint a, uint b) internal returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', ' \n', '}\n', '\n', '\n', '\n', '/**\n', ' * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.\n', ' *\n', ' * Based on code by FirstBlood:\n', ' * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, SafeMath {\n', '\n', '  /* Token supply got increased and a new owner received these tokens */\n', '  event Minted(address receiver, uint amount);\n', '\n', '  /* Actual balances of token holders */\n', '  mapping(address => uint) balances;\n', '\n', '  /* approve() allowances */\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '  /**\n', '   *\n', '   * Fix for the ERC20 short address attack\n', '   *\n', '   * http://vessenes.com/the-erc20-short-address-attack-explained/\n', '   */\n', '  modifier onlyPayloadSize(uint size) {\n', '     require(msg.data.length == size + 4);\n', '     _;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {\n', '    balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value) returns (bool success) {\n', '    uint _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met\n', '    // if (_value > _allowance) throw;\n', '\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    balances[_from] = safeSub(balances[_from], _value);\n', '    allowed[_from][msg.sender] = safeSub(_allowance, _value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint _value) returns (bool success) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * Atomic increment of approved spending\n', '   *\n', '   * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   *\n', '   */\n', '  function addApproval(address _spender, uint _addedValue)\n', '  onlyPayloadSize(2 * 32)\n', '  returns (bool success) {\n', '      uint oldValue = allowed[msg.sender][_spender];\n', '      allowed[msg.sender][_spender] = safeAdd(oldValue, _addedValue);\n', '      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '      return true;\n', '  }\n', '\n', '  /**\n', '   * Atomic decrement of approved spending.\n', '   *\n', '   * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   */\n', '  function subApproval(address _spender, uint _subtractedValue)\n', '  onlyPayloadSize(2 * 32)\n', '  returns (bool success) {\n', '\n', '      uint oldVal = allowed[msg.sender][_spender];\n', '\n', '      if (_subtractedValue > oldVal) {\n', '          allowed[msg.sender][_spender] = 0;\n', '      } else {\n', '          allowed[msg.sender][_spender] = safeSub(oldVal, _subtractedValue);\n', '      }\n', '      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '      return true;\n', '  }\n', '\n', '}\n', '\n', 'contract GIFTToken is StandardToken {\n', '\n', '  string public name;\n', '  string public symbol;\n', '  uint public decimals;\n', '  address public owner;\n', '\n', '  mapping(address => uint) previligedBalances;\n', '\n', '  function GIFTToken(address _owner, string _name, string _symbol, uint _totalSupply, uint _decimals) {\n', '    name = _name;\n', '    symbol = _symbol;\n', '    totalSupply = _totalSupply;\n', '    decimals = _decimals;\n', '\n', '    // Allocate initial balance to the owner\n', '    balances[_owner] = _totalSupply;\n', '\n', '    // save the owner\n', '    owner = _owner;\n', '  }\n', '\n', '\n', '  // privileged transfer\n', '  function transferPrivileged(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {\n', '    require(msg.sender == owner);\n', '    balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    previligedBalances[_to] = safeAdd(previligedBalances[_to], _value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  // get priveleged balance\n', '  function getPrivilegedBalance(address _owner) constant returns (uint balance) {\n', '    return previligedBalances[_owner];\n', '  }\n', '\n', '  // admin only can transfer from the privileged accounts\n', '  function transferFromPrivileged(address _from, address _to, uint _value) returns (bool success) {\n', '    require(msg.sender == owner);\n', '\n', '    uint availablePrevilegedBalance = previligedBalances[_from];\n', '\n', '    balances[_from] = safeSub(balances[_from], _value);\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    previligedBalances[_from] = safeSub(availablePrevilegedBalance, _value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '}']