['pragma solidity ^0.4.8;\n', '\n', 'contract ERC20 {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '\n', '  function transfer(address to, uint value) returns (bool ok);\n', '  function transferFrom(address from, address to, uint value) returns (bool ok);\n', '  function approve(address spender, uint value) returns (bool ok);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    if (msg.sender == owner)\n', '      _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract TokenSpender {\n', '    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);\n', '}\n', '\n', 'contract SafeMath {\n', '  function safeMul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint a, uint b) internal returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      throw;\n', '    }\n', '  }\n', '}\n', '\n', '\n', 'contract YEARS is ERC20, SafeMath, Ownable {\n', '\n', '    /* Public variables of the token */\n', '  string public name;       //fancy name\n', '  string public symbol;\n', '  uint8 public decimals;    //How many decimals to show.\n', "  string public version = 'v0.1'; \n", '  uint public initialSupply;\n', '  uint public totalSupply;\n', '  bool public locked;\n', '  //uint public unlockBlock;\n', '\n', '  mapping(address => uint) balances;\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '  // lock transfer during the ICO\n', '  modifier onlyUnlocked() {\n', '    if (msg.sender != owner && locked) throw;\n', '    _;\n', '  }\n', '\n', '  /*\n', '   *  The YERS Token created with the time at which the crowdsale end\n', '   */\n', '\n', '  function YEARS() {\n', '    // lock the transfer function during the crowdsale\n', '    locked = true;\n', '    //unlockBlock=  now + 15 days; // (testnet) - for mainnet put the block number\n', '\n', '    initialSupply = 10000000000000000;\n', '    totalSupply = initialSupply;\n', '    balances[msg.sender] = initialSupply;// Give the creator all initial tokens                    \n', "    name = 'LIGHTYEARS';        // Set the name for display purposes     \n", "    symbol = 'LYS';                       // Set the symbol for display purposes  \n", '    decimals = 8;                        // Amount of decimals for display purposes\n', '  }\n', '\n', '  function unlock() onlyOwner {\n', '    locked = false;\n', '  }\n', '\n', '  function burn(uint256 _value) returns (bool){\n', '    balances[msg.sender] = safeSub(balances[msg.sender], _value) ;\n', '    totalSupply = safeSub(totalSupply, _value);\n', '    Transfer(msg.sender, 0x0, _value);\n', '    return true;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) onlyUnlocked returns (bool) {\n', '    balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value) onlyUnlocked returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '    \n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    balances[_from] = safeSub(balances[_from], _value);\n', '    allowed[_from][msg.sender] = safeSub(_allowance, _value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint _value) returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '    /* Approve and then comunicate the approved contract in a single tx */\n', '  function approveAndCall(address _spender, uint256 _value, bytes _extraData){    \n', '      TokenSpender spender = TokenSpender(_spender);\n', '      if (approve(_spender, _value)) {\n', '          spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '      }\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '  \n', '}']