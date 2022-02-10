['pragma solidity ^0.4.21;\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'contract SafeMath {\n', '\n', '  function safeSub(uint256 x, uint256 y) internal pure returns (uint256) {\n', '    uint256 z = x - y;\n', '    assert(z <= x);\n', '    return z;\n', '  }\n', '\n', '  function safeAdd(uint256 x, uint256 y) internal pure returns (uint256) {\n', '    uint256 z = x + y;\n', '    assert(z >= x);\n', '    return z;\n', '  }\n', '\t\n', '  function safeDiv(uint256 x, uint256 y) internal pure returns (uint256) {\n', '    uint256 z = x / y;\n', '    return z;\n', '  }\n', '\t\n', '  function safeMul(uint256 x, uint256 y) internal pure returns (uint256) {\n', '    uint256 z = x * y;\n', '    assert(x == 0 || z / x == y);\n', '    return z;\n', '  }\n', '\n', '  function min(uint256 x, uint256 y) internal pure returns (uint256) {\n', '    uint256 z = x <= y ? x : y;\n', '    return z;\n', '  }\n', '\n', '  function max(uint256 x, uint256 y) internal pure returns (uint256) {\n', '    uint256 z = x >= y ? x : y;\n', '    return z;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable contract - base contract with an owner\n', ' */\n', 'contract Ownable {\n', '  \n', '  address public owner;\n', '  address public newOwner;\n', '\n', '  event OwnershipTransferred(address indexed _from, address indexed _to);\n', '  \n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.\n', '   */\n', '  function Ownable () public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    assert(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    assert(_newOwner != address(0));      \n', '    newOwner = _newOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Accept transferOwnership.\n', '   */\n', '  function acceptOwnership() public {\n', '    if (msg.sender == newOwner) {\n', '      emit OwnershipTransferred(owner, newOwner);\n', '      owner = newOwner;\n', '    }\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC223 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/223\n', ' */\n', 'contract ERC223 {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) public view returns (uint);\n', '  \n', '  function name() public view returns (string _name);\n', '  function symbol() public view returns (string _symbol);\n', '  function decimals() public view returns (uint _decimals);\n', '  function totalSupply() public view returns (uint256 _supply);\n', '\n', '  function transfer(address to, uint value) public returns (bool ok);\n', '  function transfer(address to, uint value, bytes data) public returns (bool ok);\n', '  function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);\n', '  \n', '  event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);\n', '}\n', '\n', 'contract ContractReceiver {\n', '    function tokenFallback(address _from, uint _value, bytes _data) public returns (bool success);\n', '}\n', '\n', '/**\n', ' * @title Standard ERC223 token\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/223\n', ' * @dev https://github.com/Dexaran/ERC223-token-standard\n', ' */\n', 'contract StandardToken is ERC223, SafeMath{\n', '\t\n', '  mapping(address => uint) balances;\n', '  \n', '  string public name;\n', '  string public symbol;\n', '  uint public decimals;\n', '  uint256 public totalSupply;\n', '  \n', '  bool public stopped = false;\n', '  \n', '  modifier isRunning {\n', '    assert(!stopped);\n', '    _;\n', '  }\n', '\n', '  // Function to access name of token .\n', '  function name() public view returns (string _name) {\n', '      return name;\n', '  }\n', '  // Function to access symbol of token .\n', '  function symbol() public view returns (string _symbol) {\n', '      return symbol;\n', '  }\n', '  // Function to access decimals of token .\n', '  function decimals() public view returns (uint _decimals) {\n', '      return decimals;\n', '  }\n', '  // Function to access total supply of tokens .\n', '  function totalSupply() public view returns (uint256 _totalSupply) {\n', '      return totalSupply;\n', '  }\n', '  \n', '  \n', '  // Function that is called when a user or another contract wants to transfer funds .\n', '  function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {\n', '      \n', '    if(isContract(_to)) {\n', '        if (balanceOf(msg.sender) < _value) revert();\n', '        balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);\n', '        balances[_to] = safeAdd(balanceOf(_to), _value);\n', '        assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));\n', '        emit Transfer(msg.sender, _to, _value, _data);\n', '        return true;\n', '    }\n', '    else {\n', '        return transferToAddress(_to, _value, _data);\n', '    }\n', '}\n', '  \n', '\n', '  // Function that is called when a user or another contract wants to transfer funds .\n', '  function transfer(address _to, uint _value, bytes _data) public returns (bool success) {\n', '      \n', '    if(isContract(_to)) {\n', '        return transferToContract(_to, _value, _data);\n', '    }\n', '    else {\n', '        return transferToAddress(_to, _value, _data);\n', '    }\n', '}\n', '  \n', '  // Standard function transfer similar to ERC20 transfer with no _data .\n', '  // Added due to backwards compatibility reasons .\n', '  function transfer(address _to, uint _value) public returns (bool success) {\n', '      \n', '    //standard function transfer similar to ERC20 transfer with no _data\n', '    //added due to backwards compatibility reasons\n', '    bytes memory empty;\n', '    if(isContract(_to)) {\n', '        return transferToContract(_to, _value, empty);\n', '    }\n', '    else {\n', '        return transferToAddress(_to, _value, empty);\n', '    }\n', '}\n', '\n', '  //assemble the given address bytecode. If bytecode exists then the _addr is a contract.\n', '  function isContract(address _addr) private view returns (bool is_contract) {\n', '      uint length;\n', '      assembly {\n', '            //retrieve the size of the code on target address, this needs assembly\n', '            length := extcodesize(_addr)\n', '      }\n', '      return (length>0);\n', '    }\n', '\n', '  //function that is called when transaction target is an address\n', '  function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {\n', '    if (balanceOf(msg.sender) < _value) revert();\n', '    balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);\n', '    balances[_to] = safeAdd(balanceOf(_to), _value);\n', '    emit Transfer(msg.sender, _to, _value, _data);\n', '    return true;\n', '  }\n', '  \n', '  //function that is called when transaction target is a contract\n', '  function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {\n', '    if (balanceOf(msg.sender) < _value) revert();\n', '    balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);\n', '    balances[_to] = safeAdd(balanceOf(_to), _value);\n', '    ContractReceiver receiver = ContractReceiver(_to);\n', '    receiver.tokenFallback(msg.sender, _value, _data);\n', '    emit Transfer(msg.sender, _to, _value, _data);\n', '    return true;\n', '  }\n', '\n', '\n', '  function balanceOf(address _owner) public view returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '}\n', '\n', '/**\n', ' * @title YouGive contract token\n', ' * @dev \n', ' */\n', 'contract YouGive is StandardToken, Ownable {\n', '\n', '  string public name;\n', '  string public symbol;\n', '  uint public decimals;\n', '  \n', '  /* Name and symbol were updated */\n', '  event UpdatedTokenInformation(string newName, string newSymbol);\n', '  \n', '  /**\n', '   * @dev Construct the token.\n', '   * @param _initialSupply How many tokens we start with\n', '   * @param _decimals Number of decimal places\n', '   * @param _name Token name \n', '   * @param _symbol Token symbol - should be all caps\n', '   * @param _addressFounder token distribution address\n', '   */\n', '  function YouGive(uint256 _initialSupply, uint _decimals, string _name, string _symbol, address _addressFounder) public {\n', '    \n', '    totalSupply = _initialSupply;\n', '    decimals = _decimals;\n', '    name = _name;\n', '    symbol = _symbol;\n', '    \n', '    balances[_addressFounder] = totalSupply;\n', '    bytes memory empty;\n', '    emit Transfer(0x0, _addressFounder, balances[_addressFounder], empty);\n', '  }\n', '  \n', '  function stop() public onlyOwner {\n', '    stopped = true;\n', '  }\n', '\n', '  function start() public onlyOwner {\n', '    stopped = false;\n', '  }\n', '\n', '  /**\n', '   * @dev Owner can update token information here.\n', '   *\n', '   * It is often useful to conceal the actual token association, until\n', '   * the token operations, like central issuance or reissuance have been completed.\n', '   *\n', '   * This function allows the token owner to rename the token after the operations\n', '   * have been completed and then point the audience to use the token contract.\n', '   */\n', '  function setTokenInformation(string _name, string _symbol, uint256 totalSupply_) public onlyOwner {\n', '    name = _name;\n', '    symbol = _symbol;\n', '    totalSupply = totalSupply_;\n', '    emit UpdatedTokenInformation(name, symbol);\n', '  }\n', '}']