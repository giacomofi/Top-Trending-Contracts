['pragma solidity ^0.4.9;\n', '\n', 'contract ERC223 {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  \n', '  function name() constant returns (string _name);\n', '  function symbol() constant returns (string _symbol);\n', '  function decimals() constant returns (uint8 _decimals);\n', '  function totalSupply() constant returns (uint256 _supply);\n', '\n', '  function transfer(address to, uint value) returns (bool ok);\n', '  function transfer(address to, uint value, bytes data) returns (bool ok);\n', '  event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', '\n', 'contract ContractReceiver {\n', '     \n', '    struct TKN {\n', '        address sender;\n', '        uint value;\n', '        bytes data;\n', '        bytes4 sig;\n', '    }\n', '    \n', '    \n', '    function tokenFallback(address _from, uint _value, bytes _data){\n', '      TKN memory tkn;\n', '      tkn.sender = _from;\n', '      tkn.value = _value;\n', '      tkn.data = _data;\n', '      uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);\n', '      tkn.sig = bytes4(u);\n', '      \n', '      /* tkn variable is analogue of msg variable of Ether transaction\n', '      *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)\n', '      *  tkn.value the number of tokens that were sent   (analogue of msg.value)\n', '      *  tkn.data is data of token transaction   (analogue of msg.data)\n', '      *  tkn.sig is 4 bytes signature of function\n', '      *  if data of token transaction is a function execution\n', '      */\n', '    }\n', '}\n', ' /**\n', ' * ERC23 token by Dexaran\n', ' *\n', ' * https://github.com/Dexaran/ERC23-tokens\n', ' */\n', ' \n', ' \n', ' /* https://github.com/LykkeCity/EthereumApiDotNetCore/blob/master/src/ContractBuilder/contracts/token/SafeMath.sol */\n', 'contract SafeMath {\n', '    uint256 constant public MAX_UINT256 =\n', '    0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;\n', '\n', '    function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '        assert(x <= MAX_UINT256 - y);\n', '        return x + y;\n', '    }\n', '\n', '    function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '        assert(x >= y);\n', '        return x - y;\n', '    }\n', '\n', '    function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '        if (y == 0) return 0;\n', '        assert(x <= MAX_UINT256 / y);\n', '        return x * y;\n', '    }\n', '}\n', ' \n', '/*\n', ' * Ownable\n', ' *\n', ' * Base contract with an owner.\n', ' * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    assert(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', 'contract Haltable is Ownable {\n', '  bool public halted;\n', '\n', '  modifier stopInEmergency {\n', '    assert(!halted);\n', '    _;\n', '  }\n', '\n', '  modifier onlyInEmergency {\n', '    assert(halted);\n', '    _;\n', '  }\n', '\n', '  // called by the owner on emergency, triggers stopped state\n', '  function halt() external onlyOwner {\n', '    halted = true;\n', '  }\n', '\n', '  // called by the owner on end of emergency, returns to normal state\n', '  function unhalt() external onlyOwner onlyInEmergency {\n', '    halted = false;\n', '  }\n', '\n', '}\n', '\n', 'contract ERC223Token is ERC223, SafeMath, Haltable {\n', '\n', '  mapping(address => uint) balances;\n', '  \n', '  string public name;\n', '  string public symbol;\n', '  uint8 public decimals;\n', '  uint256 public totalSupply;\n', '  \n', '  \n', '  // Function to access name of token .\n', '  function name() constant returns (string _name) {\n', '      return name;\n', '  }\n', '  // Function to access symbol of token .\n', '  function symbol() constant returns (string _symbol) {\n', '      return symbol;\n', '  }\n', '  // Function to access decimals of token .\n', '  function decimals() constant returns (uint8 _decimals) {\n', '      return decimals;\n', '  }\n', '  // Function to access total supply of tokens .\n', '  function totalSupply() constant returns (uint256 _totalSupply) {\n', '      return totalSupply;\n', '  }\n', '  \n', '  \n', '\n', '  // Function that is called when a user or another contract wants to transfer funds .\n', '  function transfer(address _to, uint _value, bytes _data) returns (bool success) {\n', '      \n', '    if(isContract(_to)) {\n', '        return transferToContract(_to, _value, _data);\n', '    }\n', '    else {\n', '        return transferToAddress(_to, _value, _data);\n', '    }\n', '}\n', '  \n', '  // Standard function transfer similar to ERC20 transfer with no _data .\n', '  // Added due to backwards compatibility reasons .\n', '  function transfer(address _to, uint _value) returns (bool success) {\n', '      \n', '    //standard function transfer similar to ERC20 transfer with no _data\n', '    //added due to backwards compatibility reasons\n', '    bytes memory empty;\n', '    if(isContract(_to)) {\n', '        return transferToContract(_to, _value, empty);\n', '    }\n', '    else {\n', '        return transferToAddress(_to, _value, empty);\n', '    }\n', '}\n', '\n', '//assemble the given address bytecode. If bytecode exists then the _addr is a contract.\n', '  function isContract(address _addr) private returns (bool is_contract) {\n', '      uint length;\n', '      assembly {\n', '            //retrieve the size of the code on target address, this needs assembly\n', '            length := extcodesize(_addr)\n', '        }\n', '        if(length>0) {\n', '            return true;\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '  //function that is called when transaction target is an address\n', '  function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {\n', '    assert(balanceOf(msg.sender) >= _value);\n', '    balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);\n', '    balances[_to] = safeAdd(balanceOf(_to), _value);\n', '    Transfer(msg.sender, _to, _value, _data);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '  \n', '  //function that is called when transaction target is a contract\n', '  function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {\n', '    assert(balanceOf(msg.sender) >= _value);\n', '    balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);\n', '    balances[_to] = safeAdd(balanceOf(_to), _value);\n', '    ContractReceiver reciever = ContractReceiver(_to);\n', '    reciever.tokenFallback(msg.sender, _value, _data);\n', '    Transfer(msg.sender, _to, _value, _data);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '}\n', '\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '  \n', '  \n', '}\n', '\n', 'contract ZontoToken is ERC223Token {\n', '\n', '    address public beneficiary;\n', '    event Buy(address indexed participant, uint tokens, uint eth);\n', '    event GoalReached(uint amountRaised);\n', '\n', '    uint public cap = 20000000000000;\n', '    uint public price;\n', '    uint public collectedTokens;\n', '    uint public collectedEthers;\n', '\n', '    uint public tokensSold = 0;\n', '    uint public weiRaised = 0;\n', '    uint public investorCount = 0;\n', '\n', '    uint public startTime;\n', '    uint public endTime;\n', '\n', '    bool public presaleFinished = false;\n', '\n', '  /**\n', '   * @dev Contructor that gives msg.sender all of existing tokens. \n', '   */\n', '    function ZontoToken() {\n', '            \n', '        name = "ZONTO Token";\n', '        symbol = "ZONTO";\n', '        decimals = 8;\n', '        totalSupply = 500000000000000;\n', '    \n', '        balances[msg.sender] = totalSupply;\n', '        \n', '        beneficiary = 0x0980eaD74d176025F2962f8b5535346c77ffd2f5;\n', '        price = 150;\n', '        startTime = 1502706677;\n', '        endTime = startTime + 14 * 1 days;\n', '        \n', '    }\n', '    \n', '    modifier onlyAfter(uint time) {\n', '        assert(now >= time);\n', '        _;\n', '    }\n', '\n', '    modifier onlyBefore(uint time) {\n', '        assert(now <= time);\n', '        _;\n', '    }\n', '    \n', '    function () payable stopInEmergency {\n', '        assert(msg.value >= 0.01 * 1 ether);\n', '        doPurchase();\n', '    }\n', '    \n', '    function doPurchase() private onlyAfter(startTime) onlyBefore(endTime) {\n', '\n', '        assert(!presaleFinished);\n', '        \n', '        uint tokens = msg.value * price / 10000000000;\n', '\n', '        if (balanceOf(msg.sender) == 0) investorCount++;\n', '        \n', '        balances[owner] -= tokens;\n', '        balances[msg.sender] += tokens;\n', '        \n', '        collectedTokens = safeAdd(collectedTokens, tokens);\n', '        collectedEthers = safeAdd(collectedEthers, msg.value);\n', '        \n', '        weiRaised = safeAdd(weiRaised, msg.value);\n', '        tokensSold = safeAdd(tokensSold, tokens);\n', '        \n', '        bytes memory empty;\n', '        Transfer(owner, msg.sender, tokens, empty);\n', '        Transfer(owner, msg.sender, tokens);\n', '        \n', '        Buy(msg.sender, tokens, msg.value);\n', '        \n', '        if (collectedTokens >= cap) {\n', '            GoalReached(collectedTokens);\n', '        }\n', '\n', '    }\n', '    \n', '    function withdraw() onlyOwner onlyAfter(endTime) returns (bool) {\n', '        if (!beneficiary.send(collectedEthers)) {\n', '            return false;\n', '        }\n', '        presaleFinished = true;\n', '        return true;\n', '    }\n', '    \n', '    \n', '}']
['pragma solidity ^0.4.9;\n', '\n', 'contract ERC223 {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  \n', '  function name() constant returns (string _name);\n', '  function symbol() constant returns (string _symbol);\n', '  function decimals() constant returns (uint8 _decimals);\n', '  function totalSupply() constant returns (uint256 _supply);\n', '\n', '  function transfer(address to, uint value) returns (bool ok);\n', '  function transfer(address to, uint value, bytes data) returns (bool ok);\n', '  event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', '\n', 'contract ContractReceiver {\n', '     \n', '    struct TKN {\n', '        address sender;\n', '        uint value;\n', '        bytes data;\n', '        bytes4 sig;\n', '    }\n', '    \n', '    \n', '    function tokenFallback(address _from, uint _value, bytes _data){\n', '      TKN memory tkn;\n', '      tkn.sender = _from;\n', '      tkn.value = _value;\n', '      tkn.data = _data;\n', '      uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);\n', '      tkn.sig = bytes4(u);\n', '      \n', '      /* tkn variable is analogue of msg variable of Ether transaction\n', '      *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)\n', '      *  tkn.value the number of tokens that were sent   (analogue of msg.value)\n', '      *  tkn.data is data of token transaction   (analogue of msg.data)\n', '      *  tkn.sig is 4 bytes signature of function\n', '      *  if data of token transaction is a function execution\n', '      */\n', '    }\n', '}\n', ' /**\n', ' * ERC23 token by Dexaran\n', ' *\n', ' * https://github.com/Dexaran/ERC23-tokens\n', ' */\n', ' \n', ' \n', ' /* https://github.com/LykkeCity/EthereumApiDotNetCore/blob/master/src/ContractBuilder/contracts/token/SafeMath.sol */\n', 'contract SafeMath {\n', '    uint256 constant public MAX_UINT256 =\n', '    0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;\n', '\n', '    function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '        assert(x <= MAX_UINT256 - y);\n', '        return x + y;\n', '    }\n', '\n', '    function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '        assert(x >= y);\n', '        return x - y;\n', '    }\n', '\n', '    function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '        if (y == 0) return 0;\n', '        assert(x <= MAX_UINT256 / y);\n', '        return x * y;\n', '    }\n', '}\n', ' \n', '/*\n', ' * Ownable\n', ' *\n', ' * Base contract with an owner.\n', ' * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    assert(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', 'contract Haltable is Ownable {\n', '  bool public halted;\n', '\n', '  modifier stopInEmergency {\n', '    assert(!halted);\n', '    _;\n', '  }\n', '\n', '  modifier onlyInEmergency {\n', '    assert(halted);\n', '    _;\n', '  }\n', '\n', '  // called by the owner on emergency, triggers stopped state\n', '  function halt() external onlyOwner {\n', '    halted = true;\n', '  }\n', '\n', '  // called by the owner on end of emergency, returns to normal state\n', '  function unhalt() external onlyOwner onlyInEmergency {\n', '    halted = false;\n', '  }\n', '\n', '}\n', '\n', 'contract ERC223Token is ERC223, SafeMath, Haltable {\n', '\n', '  mapping(address => uint) balances;\n', '  \n', '  string public name;\n', '  string public symbol;\n', '  uint8 public decimals;\n', '  uint256 public totalSupply;\n', '  \n', '  \n', '  // Function to access name of token .\n', '  function name() constant returns (string _name) {\n', '      return name;\n', '  }\n', '  // Function to access symbol of token .\n', '  function symbol() constant returns (string _symbol) {\n', '      return symbol;\n', '  }\n', '  // Function to access decimals of token .\n', '  function decimals() constant returns (uint8 _decimals) {\n', '      return decimals;\n', '  }\n', '  // Function to access total supply of tokens .\n', '  function totalSupply() constant returns (uint256 _totalSupply) {\n', '      return totalSupply;\n', '  }\n', '  \n', '  \n', '\n', '  // Function that is called when a user or another contract wants to transfer funds .\n', '  function transfer(address _to, uint _value, bytes _data) returns (bool success) {\n', '      \n', '    if(isContract(_to)) {\n', '        return transferToContract(_to, _value, _data);\n', '    }\n', '    else {\n', '        return transferToAddress(_to, _value, _data);\n', '    }\n', '}\n', '  \n', '  // Standard function transfer similar to ERC20 transfer with no _data .\n', '  // Added due to backwards compatibility reasons .\n', '  function transfer(address _to, uint _value) returns (bool success) {\n', '      \n', '    //standard function transfer similar to ERC20 transfer with no _data\n', '    //added due to backwards compatibility reasons\n', '    bytes memory empty;\n', '    if(isContract(_to)) {\n', '        return transferToContract(_to, _value, empty);\n', '    }\n', '    else {\n', '        return transferToAddress(_to, _value, empty);\n', '    }\n', '}\n', '\n', '//assemble the given address bytecode. If bytecode exists then the _addr is a contract.\n', '  function isContract(address _addr) private returns (bool is_contract) {\n', '      uint length;\n', '      assembly {\n', '            //retrieve the size of the code on target address, this needs assembly\n', '            length := extcodesize(_addr)\n', '        }\n', '        if(length>0) {\n', '            return true;\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '  //function that is called when transaction target is an address\n', '  function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {\n', '    assert(balanceOf(msg.sender) >= _value);\n', '    balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);\n', '    balances[_to] = safeAdd(balanceOf(_to), _value);\n', '    Transfer(msg.sender, _to, _value, _data);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '  \n', '  //function that is called when transaction target is a contract\n', '  function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {\n', '    assert(balanceOf(msg.sender) >= _value);\n', '    balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);\n', '    balances[_to] = safeAdd(balanceOf(_to), _value);\n', '    ContractReceiver reciever = ContractReceiver(_to);\n', '    reciever.tokenFallback(msg.sender, _value, _data);\n', '    Transfer(msg.sender, _to, _value, _data);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '}\n', '\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '  \n', '  \n', '}\n', '\n', 'contract ZontoToken is ERC223Token {\n', '\n', '    address public beneficiary;\n', '    event Buy(address indexed participant, uint tokens, uint eth);\n', '    event GoalReached(uint amountRaised);\n', '\n', '    uint public cap = 20000000000000;\n', '    uint public price;\n', '    uint public collectedTokens;\n', '    uint public collectedEthers;\n', '\n', '    uint public tokensSold = 0;\n', '    uint public weiRaised = 0;\n', '    uint public investorCount = 0;\n', '\n', '    uint public startTime;\n', '    uint public endTime;\n', '\n', '    bool public presaleFinished = false;\n', '\n', '  /**\n', '   * @dev Contructor that gives msg.sender all of existing tokens. \n', '   */\n', '    function ZontoToken() {\n', '            \n', '        name = "ZONTO Token";\n', '        symbol = "ZONTO";\n', '        decimals = 8;\n', '        totalSupply = 500000000000000;\n', '    \n', '        balances[msg.sender] = totalSupply;\n', '        \n', '        beneficiary = 0x0980eaD74d176025F2962f8b5535346c77ffd2f5;\n', '        price = 150;\n', '        startTime = 1502706677;\n', '        endTime = startTime + 14 * 1 days;\n', '        \n', '    }\n', '    \n', '    modifier onlyAfter(uint time) {\n', '        assert(now >= time);\n', '        _;\n', '    }\n', '\n', '    modifier onlyBefore(uint time) {\n', '        assert(now <= time);\n', '        _;\n', '    }\n', '    \n', '    function () payable stopInEmergency {\n', '        assert(msg.value >= 0.01 * 1 ether);\n', '        doPurchase();\n', '    }\n', '    \n', '    function doPurchase() private onlyAfter(startTime) onlyBefore(endTime) {\n', '\n', '        assert(!presaleFinished);\n', '        \n', '        uint tokens = msg.value * price / 10000000000;\n', '\n', '        if (balanceOf(msg.sender) == 0) investorCount++;\n', '        \n', '        balances[owner] -= tokens;\n', '        balances[msg.sender] += tokens;\n', '        \n', '        collectedTokens = safeAdd(collectedTokens, tokens);\n', '        collectedEthers = safeAdd(collectedEthers, msg.value);\n', '        \n', '        weiRaised = safeAdd(weiRaised, msg.value);\n', '        tokensSold = safeAdd(tokensSold, tokens);\n', '        \n', '        bytes memory empty;\n', '        Transfer(owner, msg.sender, tokens, empty);\n', '        Transfer(owner, msg.sender, tokens);\n', '        \n', '        Buy(msg.sender, tokens, msg.value);\n', '        \n', '        if (collectedTokens >= cap) {\n', '            GoalReached(collectedTokens);\n', '        }\n', '\n', '    }\n', '    \n', '    function withdraw() onlyOwner onlyAfter(endTime) returns (bool) {\n', '        if (!beneficiary.send(collectedEthers)) {\n', '            return false;\n', '        }\n', '        presaleFinished = true;\n', '        return true;\n', '    }\n', '    \n', '    \n', '}']
