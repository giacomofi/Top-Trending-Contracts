['pragma solidity 0.4.15;\n', '\n', 'contract DPIcoWhitelist {\n', '  address admin;\n', '  bool isOn;\n', '  mapping ( address => bool ) whitelist;\n', '  address[] users;\n', '\n', '  modifier signUpOpen() {\n', '    if ( ! isOn ) revert();\n', '    _;\n', '  }\n', '\n', '  modifier isAdmin() {\n', '    if ( msg.sender != admin ) revert();\n', '    _;\n', '  }\n', '\n', '  modifier newAddr() {\n', '    if ( whitelist[msg.sender] ) revert();\n', '    _;\n', '  }\n', '\n', '  function DPIcoWhitelist() {\n', '    admin = msg.sender;\n', '    isOn = false;\n', '  }\n', '\n', '  function getAdmin() constant returns (address) {\n', '    return admin;\n', '  }\n', '\n', '  function signUpOn() constant returns (bool) {\n', '    return isOn;\n', '  }\n', '\n', '  function setSignUpOnOff(bool state) public isAdmin {\n', '    isOn = state;\n', '  }\n', '\n', '  function signUp() public signUpOpen newAddr {\n', '    whitelist[msg.sender] = true;\n', '    users.push(msg.sender);\n', '  }\n', '\n', '  function () {\n', '    signUp();\n', '  }\n', '\n', '  function isSignedUp(address addr) constant returns (bool) {\n', '    return whitelist[addr];\n', '  }\n', '\n', '  function getUsers() constant returns (address[]) {\n', '    return users;\n', '  }\n', '\n', '  function numUsers() constant returns (uint) {\n', '    return users.length;\n', '  }\n', '\n', '  function userAtIndex(uint idx) constant returns (address) {\n', '    return users[idx];\n', '  }\n', '}']
['pragma solidity 0.4.15;\n', '\n', 'contract DPIcoWhitelist {\n', '  address admin;\n', '  bool isOn;\n', '  mapping ( address => bool ) whitelist;\n', '  address[] users;\n', '\n', '  modifier signUpOpen() {\n', '    if ( ! isOn ) revert();\n', '    _;\n', '  }\n', '\n', '  modifier isAdmin() {\n', '    if ( msg.sender != admin ) revert();\n', '    _;\n', '  }\n', '\n', '  modifier newAddr() {\n', '    if ( whitelist[msg.sender] ) revert();\n', '    _;\n', '  }\n', '\n', '  function DPIcoWhitelist() {\n', '    admin = msg.sender;\n', '    isOn = false;\n', '  }\n', '\n', '  function getAdmin() constant returns (address) {\n', '    return admin;\n', '  }\n', '\n', '  function signUpOn() constant returns (bool) {\n', '    return isOn;\n', '  }\n', '\n', '  function setSignUpOnOff(bool state) public isAdmin {\n', '    isOn = state;\n', '  }\n', '\n', '  function signUp() public signUpOpen newAddr {\n', '    whitelist[msg.sender] = true;\n', '    users.push(msg.sender);\n', '  }\n', '\n', '  function () {\n', '    signUp();\n', '  }\n', '\n', '  function isSignedUp(address addr) constant returns (bool) {\n', '    return whitelist[addr];\n', '  }\n', '\n', '  function getUsers() constant returns (address[]) {\n', '    return users;\n', '  }\n', '\n', '  function numUsers() constant returns (uint) {\n', '    return users.length;\n', '  }\n', '\n', '  function userAtIndex(uint idx) constant returns (address) {\n', '    return users[idx];\n', '  }\n', '}']
