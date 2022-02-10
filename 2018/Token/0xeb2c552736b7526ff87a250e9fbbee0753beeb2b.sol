['//Compatible Solidity Compiler Version\n', '\n', 'pragma solidity ^0.4.15;\n', '\n', '\n', '\n', '/*\n', 'This Ace Equity Token contract is based on the ERC20 token contract standard. Additional\n', 'functionality has been integrated:\n', '\n', '*/\n', '\n', '\n', 'contract AceEquityToken  {\n', '    //AceEquityToken\n', '    string public name;\n', '    \n', '    //AceEquityToken Official Symbol\n', '\tstring public symbol;\n', '\t\n', '\t//AceEquityToken Decimals\n', '\tuint8 public decimals; \n', '  \n', '  //database to match user Accounts and their respective balances\n', '  mapping(address => uint) _balances;\n', '  mapping(address => mapping( address => uint )) _approvals;\n', '  \n', '  \n', '\n', '  address public dev;\n', '  \n', '  //Number of AceEquityToken in existence\n', '  uint public _supply;\n', '  \n', '\n', '  event TokenSwapOver();\n', '  \n', '  event Transfer(address indexed from, address indexed to, uint value );\n', '  event Approval(address indexed owner, address indexed spender, uint value );\n', ' \n', ' \n', '\n', '  //initialize AceEquityToken\n', '  //pass Ace Configurations to the Constructor\n', ' function AceEquityToken(uint initial_balance, string tokenName, string tokenSymbol, uint8 decimalUnits) {\n', '    \n', '   \n', '    _supply += initial_balance;\n', '    _balances[msg.sender] = initial_balance;\n', '    \n', '    decimals = decimalUnits;\n', '\tsymbol = tokenSymbol;\n', '\tname = tokenName;\n', '\t\n', '\tdev = msg.sender;\n', ' \n', '    \n', '  }\n', '\n', '//retrieve number of all AceEquityToken in existence\n', 'function totalSupply() constant returns (uint supply) {\n', '    return _supply;\n', '  }\n', '\n', '//check Ace Token balance of an Ethereum account\n', 'function balanceOf(address who) constant returns (uint value) {\n', '    return _balances[who];\n', '  }\n', '\n', '//check how many Ace Tokens a spender is allowed to spend from an owner\n', 'function allowance(address _owner, address spender) constant returns (uint _allowance) {\n', '    return _approvals[_owner][spender];\n', '  }\n', '\n', '  // A helper to notify if overflow occurs\n', 'function safeToAdd(uint a, uint b) internal returns (bool) {\n', '    return (a + b >= a && a + b >= b);\n', '  }\n', '\n', '//transfer an amount of Ace Tokens to an Ethereum address\n', 'function transfer(address to, uint value) returns (bool ok) {\n', '\n', '    if(_balances[msg.sender] < value) revert();\n', '    \n', '    if(!safeToAdd(_balances[to], value)) revert();\n', '    \n', '\n', '    _balances[msg.sender] -= value;\n', '    _balances[to] += value;\n', '    Transfer(msg.sender, to, value);\n', '    return true;\n', '  }\n', '\n', '//spend Ace Tokens from another Ethereum account that approves you as spender\n', 'function transferFrom(address from, address to, uint value) returns (bool ok) {\n', '    // if you don&#39;t have enough balance, throw\n', '    if(_balances[from] < value) revert();\n', '\n', '    // if you don&#39;t have approval, throw\n', '    if(_approvals[from][msg.sender] < value) revert();\n', '    \n', '    if(!safeToAdd(_balances[to], value)) revert();\n', '    \n', '    // transfer and return true\n', '    _approvals[from][msg.sender] -= value;\n', '    _balances[from] -= value;\n', '    _balances[to] += value;\n', '    Transfer(from, to, value);\n', '    return true;\n', '  }\n', '  \n', '  \n', '//allow another Ethereum account to spend Ace Tokens from your Account\n', 'function approve(address spender, uint value)\n', '    \n', '    returns (bool ok) {\n', '    _approvals[msg.sender][spender] = value;\n', '    Approval(msg.sender, spender, value);\n', '    return true;\n', '  }\n', '}']