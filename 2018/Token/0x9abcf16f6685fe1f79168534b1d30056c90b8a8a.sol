['pragma solidity ^0.4.21;\n', '\n', 'contract NetkillerToken {\n', '  string public name;\n', '  string public symbol;\n', '  uint public decimals;\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '  /* This creates an array with all balances */\n', '  mapping (address => uint256) public balanceOf;\n', '\n', '  function NetkillerToken(uint256 initialSupply, string tokenName, string tokenSymbol, uint decimalUnits) public {\n', '    balanceOf[msg.sender] = initialSupply;\n', '    name = tokenName;\n', '    symbol = tokenSymbol;\n', '    decimals = decimalUnits;\n', '  }\n', '\n', '  /* Send coins */\n', '  function transfer(address _to, uint256 _value) public {\n', '    /* Check if the sender has balance and for overflows */\n', '    require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);\n', '\n', '    /* Add and subtract new balances */\n', '    balanceOf[msg.sender] -= _value;\n', '    balanceOf[_to] += _value;\n', '\n', '    /* Notify anyone listening that this transfer took place */\n', '    emit Transfer(msg.sender, _to, _value);\n', '  }\n', '}']
['pragma solidity ^0.4.21;\n', '\n', 'contract NetkillerToken {\n', '  string public name;\n', '  string public symbol;\n', '  uint public decimals;\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '  /* This creates an array with all balances */\n', '  mapping (address => uint256) public balanceOf;\n', '\n', '  function NetkillerToken(uint256 initialSupply, string tokenName, string tokenSymbol, uint decimalUnits) public {\n', '    balanceOf[msg.sender] = initialSupply;\n', '    name = tokenName;\n', '    symbol = tokenSymbol;\n', '    decimals = decimalUnits;\n', '  }\n', '\n', '  /* Send coins */\n', '  function transfer(address _to, uint256 _value) public {\n', '    /* Check if the sender has balance and for overflows */\n', '    require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);\n', '\n', '    /* Add and subtract new balances */\n', '    balanceOf[msg.sender] -= _value;\n', '    balanceOf[_to] += _value;\n', '\n', '    /* Notify anyone listening that this transfer took place */\n', '    emit Transfer(msg.sender, _to, _value);\n', '  }\n', '}']
