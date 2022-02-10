['pragma solidity ^0.4.11;\n', '\n', 'contract ContractReceiver {\n', '     \n', '    struct TKN {\n', '        address sender;\n', '        uint value;\n', '        bytes data;\n', '        bytes4 sig;\n', '    }\n', '    \n', '    \n', '    function tokenFallback(address _from, uint _value, bytes _data){\n', '      TKN memory tkn;\n', '      tkn.sender = _from;\n', '      tkn.value = _value;\n', '      tkn.data = _data;\n', '      uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);\n', '      tkn.sig = bytes4(u);\n', ' \n', '    }\n', '}\n', '\n', 'contract SafeMath {\n', '    uint256 constant public MAX_UINT256 =\n', '    0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;\n', '\n', '    function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '        if (x > MAX_UINT256 - y) throw;\n', '        return x + y;\n', '    }\n', '\n', '    function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '        if (x < y) throw;\n', '        return x - y;\n', '    }\n', '\n', '    function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '        if (y == 0) return 0;\n', '        if (x > MAX_UINT256 / y) throw;\n', '        return x * y;\n', '    }\n', '}\n', '\n', 'contract Token is SafeMath{\n', '\n', '  mapping(address => uint) balances;\n', '  \n', '  string public symbol = "";\n', '  string public name = "";\n', '  uint8 public decimals = 18;\n', '  uint256 public totalSupply = 0;\n', '  address owner = 0;\n', '  bool setupDone = false;\n', '  \n', '  event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);\n', '  \n', '  function Token(address adr) {\n', '\t\towner = adr;        \n', '    }\n', '\t\n', '\tfunction SetupToken(string _tokenName, string _tokenSymbol, uint256 _tokenSupply)\n', '\t{\n', '\t\tif (msg.sender == owner && setupDone == false)\n', '\t\t{\n', '\t\t\tsymbol = _tokenSymbol;\n', '\t\t\tname = _tokenName;\n', '\t\t\ttotalSupply = _tokenSupply * 1000000000000000000;\n', '\t\t\tbalances[owner] = totalSupply;\n', '\t\t\tsetupDone = true;\n', '\t\t}\n', '\t}\n', '  \n', '  function name() constant returns (string _name) {\n', '      return name;\n', '  }\n', '\n', '  function symbol() constant returns (string _symbol) {\n', '      return symbol;\n', '  }\n', '\n', '  function decimals() constant returns (uint8 _decimals) {\n', '      return decimals;\n', '  }\n', '\n', '  function totalSupply() constant returns (uint256 _totalSupply) {\n', '      return totalSupply;\n', '  }\n', '  \n', '  function transfer(address _to, uint _value, bytes _data) returns (bool success) {\n', '      \n', '    if(isContract(_to)) {\n', '        return transferToContract(_to, _value, _data);\n', '    }\n', '    else {\n', '        return transferToAddress(_to, _value, _data);\n', '    }\n', '}\n', '  \n', '  function transfer(address _to, uint _value) returns (bool success) {\n', '      \n', '    bytes memory empty;\n', '    if(isContract(_to)) {\n', '        return transferToContract(_to, _value, empty);\n', '    }\n', '    else {\n', '        return transferToAddress(_to, _value, empty);\n', '    }\n', '}\n', '\n', '  function isContract(address _addr) private returns (bool is_contract) {\n', '      uint length;\n', '\t  \n', '\t  if (balanceOf(_addr) >=0 )\n', '\t  \n', '      assembly {\n', '            length := extcodesize(_addr)\n', '        }\n', '        if(length>0) {\n', '            return true;\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '  function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {\n', '    if (balanceOf(msg.sender) < _value) throw;\n', '    balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);\n', '    balances[_to] = safeAdd(balanceOf(_to), _value);\n', '    Transfer(msg.sender, _to, _value, _data);\n', '    return true;\n', '  }\n', '  \n', '  function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {\n', '    if (balanceOf(msg.sender) < _value) throw;\n', '    balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);\n', '    balances[_to] = safeAdd(balanceOf(_to), _value);\n', '    ContractReceiver reciever = ContractReceiver(_to);\n', '    reciever.tokenFallback(msg.sender, _value, _data);\n', '    Transfer(msg.sender, _to, _value, _data);\n', '    return true;\n', '}\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '}']