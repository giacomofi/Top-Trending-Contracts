['pragma solidity ^0.4.24;\n', '\n', '\n', 'contract ERC223 {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '\n', '  function name() constant returns (string _name);\n', '  function symbol() constant returns (string _symbol);\n', '  function decimals() constant returns (uint8 _decimals);\n', '  function totalSupply() constant returns (uint256 _supply);\n', '\n', '  function transfer(address to, uint value) returns (bool ok);\n', '  function transfer(address to, uint value, bytes data) returns (bool ok);\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event ERC223Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);\n', '}\n', '\n', 'contract ContractReceiver {\n', '  function tokenFallback(address _from, uint _value, bytes _data);\n', '}\n', '\n', 'contract ERC223Token is ERC223 {\n', '  using SafeMath for uint;\n', '\n', '  mapping(address => uint) balances;\n', '\n', '  string public name;\n', '  string public symbol;\n', '  uint8 public decimals;\n', '  uint256 public totalSupply;\n', '\n', '\n', '  // Function to access name of token .\n', '  function name() constant returns (string _name) {\n', '      return name;\n', '  }\n', '  // Function to access symbol of token .\n', '  function symbol() constant returns (string _symbol) {\n', '      return symbol;\n', '  }\n', '  // Function to access decimals of token .\n', '  function decimals() constant returns (uint8 _decimals) {\n', '      return decimals;\n', '  }\n', '  // Function to access total supply of tokens .\n', '  function totalSupply() constant returns (uint256 _totalSupply) {\n', '      return totalSupply;\n', '  }\n', '\n', '  // Function that is called when a user or another contract wants to transfer funds .\n', '  function transfer(address _to, uint _value, bytes _data) returns (bool success) {\n', '    if(isContract(_to)) {\n', '        return transferToContract(_to, _value, _data);\n', '    }\n', '    else {\n', '        return transferToAddress(_to, _value, _data);\n', '    }\n', '}\n', '\n', '  // Standard function transfer similar to ERC20 transfer with no _data .\n', '  // Added due to backwards compatibility reasons .\n', '  function transfer(address _to, uint _value) returns (bool success) {\n', '\n', '    //standard function transfer similar to ERC20 transfer with no _data\n', '    //added due to backwards compatibility reasons\n', '    bytes memory empty;\n', '    if(isContract(_to)) {\n', '        return transferToContract(_to, _value, empty);\n', '    }\n', '    else {\n', '        return transferToAddress(_to, _value, empty);\n', '    }\n', '}\n', '\n', '//assemble the given address bytecode. If bytecode exists then the _addr is a contract.\n', '  function isContract(address _addr) private returns (bool is_contract) {\n', '      uint length;\n', '      assembly {\n', '            //retrieve the size of the code on target address, this needs assembly\n', '            length := extcodesize(_addr)\n', '        }\n', '        if(length>0) {\n', '            return true;\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '  //function that is called when transaction target is an address\n', '  function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {\n', '    if (balanceOf(msg.sender) < _value) revert();\n', '    balances[msg.sender] = balanceOf(msg.sender).sub(_value);\n', '    balances[_to] = balanceOf(_to).add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    ERC223Transfer(msg.sender, _to, _value, _data);\n', '    return true;\n', '  }\n', '\n', '  //function that is called when transaction target is a contract\n', '  function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {\n', '    if (balanceOf(msg.sender) < _value) revert();\n', '    balances[msg.sender] = balanceOf(msg.sender).sub(_value);\n', '    balances[_to] = balanceOf(_to).add(_value);\n', '    ContractReceiver reciever = ContractReceiver(_to);\n', '    reciever.tokenFallback(msg.sender, _value, _data);\n', '    Transfer(msg.sender, _to, _value);\n', '    ERC223Transfer(msg.sender, _to, _value, _data);\n', '    return true;\n', '  }\n', '\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '\n', '\n', "// your contract's name\n", '\n', 'contract BIBToken is ERC223Token {\n', '  using SafeMath for uint256;\n', '\n', '  // name\n', '  string public name = "Blockchain Investor Bearer";\n', '  // ticker\n', '  string public symbol = "BIB";\n', "  // set token's precision\n", '  //\n', '  // for example, 4 decimal points means that\n', '  // smallest token using will be 0.0001 BIB\n', '  uint public decimals = 4;\n', '  // total supply of the token\n', '  // 1 billion\n', '  uint public totalSupply = 1000000000 * (10**decimals);\n', '  //\n', '  address private treasury = 0x3805D6c12b3d53351Ad128EE78f4ca53Fb52dA77;\n', '  //\n', '  // given 4 decimals, this setting means "1 ETC = 4000 BIB"\n', '  uint256 private priceDiv = 25000000000;\n', '\n', '  event Purchase(address indexed purchaser, uint256 amount);\n', '\n', '  constructor() public {\n', '    // Tokens allocation. 150 million tokens distributed to current shareholders\n', '    // and 850 millions for future issuing (capital increase) against digital\n', '    // assets / currencies.\n', '    balances[msg.sender] = 1000000000 * (10**decimals);\n', '    // This is how many tokens you want to allocate for ICO\n', '    balances[0x0] = 0 * (10**decimals);\n', '  }\n', '\n', '  function () public payable {\n', '    bytes memory empty;\n', '    if (msg.value == 0) { revert(); }\n', '    uint256 purchasedAmount = msg.value.div(priceDiv);\n', '    if (purchasedAmount == 0) { revert(); } // not enough ETC sent\n', '    if (purchasedAmount > balances[0x0]) { revert(); } // too much ETC sent\n', '\n', '    treasury.transfer(msg.value);\n', '    balances[0x0] = balances[0x0].sub(purchasedAmount);\n', '    balances[msg.sender] = balances[msg.sender].add(purchasedAmount);\n', '\n', '    emit Transfer(0x0, msg.sender, purchasedAmount);\n', '    emit ERC223Transfer(0x0, msg.sender, purchasedAmount, empty);\n', '    emit Purchase(msg.sender, purchasedAmount);\n', '  }\n', '}']