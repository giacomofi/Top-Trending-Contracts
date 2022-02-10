['pragma solidity ^0.4.11;\n', '\n', ' /* Receiver must implement this function to receive tokens\n', ' *  otherwise token transaction will fail\n', ' */\n', ' \n', ' contract ContractReceiver {\n', '    function tokenFallback(address _from, uint256 _value, bytes _data){\n', '      _from = _from;\n', '      _value = _value;\n', '      _data = _data;\n', '      // Incoming transaction code here\n', '    }\n', '}\n', ' \n', ' /* New ERC23 contract interface */\n', '\n', 'contract ERC23 {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '\n', '  function name() constant returns (string _name);\n', '  function symbol() constant returns (string _symbol);\n', '  function decimals() constant returns (uint8 _decimals);\n', '  function totalSupply() constant returns (uint256 _supply);\n', '\n', '  function transfer(address to, uint256 value) returns (bool ok);\n', '  function transfer(address to, uint256 value, bytes data) returns (bool ok);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool ok);\n', '  function approve(address spender, uint256 value) returns (bool ok);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Transfer(address indexed from, address indexed to, uint256 value, bytes data);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', ' /**\n', ' * ERC23 token by Dexaran\n', ' *\n', ' * https://github.com/Dexaran/ERC23-tokens\n', ' */\n', ' \n', 'contract ERC23Token is ERC23 {\n', '\n', '  mapping(address => uint256) balances;\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '  string public name;\n', '  string public symbol;\n', '  uint8 public decimals;\n', '  uint256 public totalSupply;\n', '\n', '  // Function to access name of token .\n', '  function name() constant returns (string _name) {\n', '      return name;\n', '  }\n', '  // Function to access symbol of token .\n', '  function symbol() constant returns (string _symbol) {\n', '      return symbol;\n', '  }\n', '  // Function to access decimals of token .\n', '  function decimals() constant returns (uint8 _decimals) {\n', '      return decimals;\n', '  }\n', '  // Function to access total supply of tokens .\n', '  function totalSupply() constant returns (uint256 _totalSupply) {\n', '      return totalSupply;\n', '  }\n', '\n', '  //function that is called when a user or another contract wants to transfer funds\n', '  function transfer(address _to, uint256 _value, bytes _data) returns (bool success) {\n', '  \n', '    //filtering if the target is a contract with bytecode inside it\n', '    if(isContract(_to)) {\n', '        transferToContract(_to, _value, _data);\n', '    }\n', '    else {\n', '        transferToAddress(_to, _value, _data);\n', '    }\n', '    return true;\n', '  }\n', '  \n', '  function transfer(address _to, uint256 _value) returns (bool success) {\n', '      \n', '    //standard function transfer similar to ERC20 transfer with no _data\n', '    //added due to backwards compatibility reasons\n', '    bytes memory empty;\n', '    if(isContract(_to)) {\n', '        transferToContract(_to, _value, empty);\n', '    }\n', '    else {\n', '        transferToAddress(_to, _value, empty);\n', '    }\n', '    return true;\n', '  }\n', '\n', '  //function that is called when transaction target is an address\n', '  function transferToAddress(address _to, uint256 _value, bytes _data) private returns (bool success) {\n', '    balances[msg.sender] -= _value;\n', '    balances[_to] += _value;\n', '    Transfer(msg.sender, _to, _value);\n', '    Transfer(msg.sender, _to, _value, _data);\n', '    return true;\n', '  }\n', '  \n', '  //function that is called when transaction target is a contract\n', '  function transferToContract(address _to, uint256 _value, bytes _data) private returns (bool success) {\n', '    balances[msg.sender] -= _value;\n', '    balances[_to] += _value;\n', '    ContractReceiver reciever = ContractReceiver(_to);\n', '    reciever.tokenFallback(msg.sender, _value, _data);\n', '    Transfer(msg.sender, _to, _value);\n', '    Transfer(msg.sender, _to, _value, _data);\n', '    return true;\n', '  }\n', '  \n', '  //assemble the given address bytecode. If bytecode exists then the _addr is a contract.\n', '  function isContract(address _addr) private returns (bool is_contract) {\n', '      _addr = _addr;\n', '      uint256 length;\n', '      assembly {\n', '            //retrieve the size of the code on target address, this needs assembly\n', '            length := extcodesize(_addr)\n', '        }\n', '        if(length>0) {\n', '            return true;\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '    \n', '    if(_value > _allowance) {\n', '        throw;\n', '    }\n', '\n', '    balances[_to] += _value;\n', '    balances[_from] -= _value;\n', '    allowed[_from][msg.sender] -= _value;\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) returns (bool success) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '}\n', '\n', '\n', '// ERC223 token with the ability for the owner to block any account\n', 'contract DASToken is ERC23Token {\n', '    mapping (address => bool) blockedAccounts;\n', '    address public secretaryGeneral;\n', '\n', '\n', '    // Constructor\n', '    function DASToken(\n', '            string _name,\n', '            string _symbol,\n', '            uint8 _decimals,\n', '            uint256 _totalSupply,\n', '            address _initialTokensHolder) {\n', '        secretaryGeneral = msg.sender;\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '        totalSupply = _totalSupply;\n', '        balances[_initialTokensHolder] = _totalSupply;\n', '    }\n', '\n', '\n', '    modifier onlySecretaryGeneral {\n', '        if (msg.sender != secretaryGeneral) throw;\n', '        _;\n', '    }\n', '\n', '\n', '    // block account\n', '    function blockAccount(address _account) onlySecretaryGeneral {\n', '        blockedAccounts[_account] = true;\n', '    }\n', '\n', '    // unblock account\n', '    function unblockAccount(address _account) onlySecretaryGeneral {\n', '        blockedAccounts[_account] = false;\n', '    }\n', '\n', '    // check is account blocked\n', '    function isAccountBlocked(address _account) returns (bool){\n', '        return blockedAccounts[_account];\n', '    }\n', '\n', '    // override transfer methods to throw on blocked accounts\n', '    function transfer(address _to, uint256 _value, bytes _data) returns (bool success) {\n', '        if (blockedAccounts[msg.sender]) {\n', '            throw;\n', '        }\n', '        return ERC23Token.transfer(_to, _value, _data);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if (blockedAccounts[msg.sender]) {\n', '            throw;\n', '        }\n', '        bytes memory empty;\n', '        return ERC23Token.transfer(_to, _value, empty);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (blockedAccounts[_from]) {\n', '            throw;\n', '        }\n', '        return ERC23Token.transferFrom(_from, _to, _value);\n', '    }\n', '}']