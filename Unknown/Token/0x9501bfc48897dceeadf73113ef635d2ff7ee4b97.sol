['pragma solidity ^0.4.13;\n', '\n', 'contract Token {\n', '  /* This is a slight change to the ERC20 base standard.\n', '     function totalSupply() constant returns (uint256 supply);\n', '     is replaced with:\n', '     uint256 public totalSupply;\n', '     This automatically creates a getter function for the totalSupply.\n', '     This is moved to the base contract since public getter functions are not\n', '     currently recognised as an implementation of the matching abstract\n', '     function by the compiler.\n', '  */\n', '  /// total amount of tokens\n', '  uint256 public totalSupply;\n', '\n', '  /// @param _owner The address from which the balance will be retrieved\n', '  /// @return The balance\n', '  function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '  /// @notice send `_value` token to `_to` from `msg.sender`\n', '  /// @param _to The address of the recipient\n', '  /// @param _value The amount of token to be transferred\n', '  /// @return Whether the transfer was successful or not\n', '  function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '  /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '  /// @param _from The address of the sender\n', '  /// @param _to The address of the recipient\n', '  /// @param _value The amount of token to be transferred\n', '  /// @return Whether the transfer was successful or not\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '  /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '  /// @param _spender The address of the account able to transfer the tokens\n', '  /// @param _value The amount of tokens to be approved for transfer\n', '  /// @return Whether the approval was successful or not\n', '  function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '  /// @param _owner The address of the account owning tokens\n', '  /// @param _spender The address of the account able to transfer the tokens\n', '  /// @return Amount of remaining tokens allowed to spent\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract StandardToken is Token {\n', '\n', '  function transfer(address _to, uint256 _value) returns (bool success) {\n', '    //Default assumes totalSupply can&#39;t be over max (2^256 - 1).\n', '    //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn&#39;t wrap.\n', '    //Replace the if with this one instead.\n', '    //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '    if (balances[msg.sender] >= _value && _value > 0) {\n', '      balances[msg.sender] -= _value;\n', '      balances[_to] += _value;\n', '      Transfer(msg.sender, _to, _value);\n', '      return true;\n', '    } else { return false; }\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '    //same as above. Replace this line with the following if you want to protect against wrapping uints.\n', '    //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '    if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '      balances[_to] += _value;\n', '      balances[_from] -= _value;\n', '      allowed[_from][msg.sender] -= _value;\n', '      Transfer(_from, _to, _value);\n', '      return true;\n', '    } else { return false; }\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) returns (bool success) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  mapping (address => uint256) balances;\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', 'contract EasyMineToken is StandardToken {\n', '\n', '  string public constant name = "easyMINE Token";\n', '  string public constant symbol = "EMT";\n', '  uint8 public constant decimals = 18;\n', '\n', '  function EasyMineToken(address _icoAddress,\n', '                         address _preIcoAddress,\n', '                         address _easyMineWalletAddress,\n', '                         address _bountyWalletAddress) {\n', '    require(_icoAddress != 0x0);\n', '    require(_preIcoAddress != 0x0);\n', '    require(_easyMineWalletAddress != 0x0);\n', '    require(_bountyWalletAddress != 0x0);\n', '\n', '    totalSupply = 33000000 * 10**18;                     // 33.000.000 EMT\n', '\n', '    uint256 icoTokens = 27000000 * 10**18;               // 27.000.000 EMT\n', '\n', '    uint256 preIcoTokens = 2000000 * 10**18;             // 2.000.000 EMT\n', '\n', '    uint256 easyMineTokens = 3000000 * 10**18;           // 1.500.000 EMT dev team +\n', '                                                         // 500.000 EMT advisors +\n', '                                                         // 1.000.000 EMT easyMINE corporation +\n', '                                                         // = 3.000.000 EMT\n', '\n', '    uint256 bountyTokens = 1000000 * 10**18;             // 1.000.000 EMT\n', '\n', '    assert(icoTokens + preIcoTokens + easyMineTokens + bountyTokens == totalSupply);\n', '\n', '    balances[_icoAddress] = icoTokens;\n', '    Transfer(0, _icoAddress, icoTokens);\n', '\n', '    balances[_preIcoAddress] = preIcoTokens;\n', '    Transfer(0, _preIcoAddress, preIcoTokens);\n', '\n', '    balances[_easyMineWalletAddress] = easyMineTokens;\n', '    Transfer(0, _easyMineWalletAddress, easyMineTokens);\n', '\n', '    balances[_bountyWalletAddress] = bountyTokens;\n', '    Transfer(0, _bountyWalletAddress, bountyTokens);\n', '  }\n', '\n', '  function burn(uint256 _value) returns (bool success) {\n', '    if (balances[msg.sender] >= _value && _value > 0) {\n', '      balances[msg.sender] -= _value;\n', '      totalSupply -= _value;\n', '      Transfer(msg.sender, 0x0, _value);\n', '      return true;\n', '    } else {\n', '      return false;\n', '    }\n', '  }\n', '}']
['pragma solidity ^0.4.13;\n', '\n', 'contract Token {\n', '  /* This is a slight change to the ERC20 base standard.\n', '     function totalSupply() constant returns (uint256 supply);\n', '     is replaced with:\n', '     uint256 public totalSupply;\n', '     This automatically creates a getter function for the totalSupply.\n', '     This is moved to the base contract since public getter functions are not\n', '     currently recognised as an implementation of the matching abstract\n', '     function by the compiler.\n', '  */\n', '  /// total amount of tokens\n', '  uint256 public totalSupply;\n', '\n', '  /// @param _owner The address from which the balance will be retrieved\n', '  /// @return The balance\n', '  function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '  /// @notice send `_value` token to `_to` from `msg.sender`\n', '  /// @param _to The address of the recipient\n', '  /// @param _value The amount of token to be transferred\n', '  /// @return Whether the transfer was successful or not\n', '  function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '  /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '  /// @param _from The address of the sender\n', '  /// @param _to The address of the recipient\n', '  /// @param _value The amount of token to be transferred\n', '  /// @return Whether the transfer was successful or not\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '  /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '  /// @param _spender The address of the account able to transfer the tokens\n', '  /// @param _value The amount of tokens to be approved for transfer\n', '  /// @return Whether the approval was successful or not\n', '  function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '  /// @param _owner The address of the account owning tokens\n', '  /// @param _spender The address of the account able to transfer the tokens\n', '  /// @return Amount of remaining tokens allowed to spent\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract StandardToken is Token {\n', '\n', '  function transfer(address _to, uint256 _value) returns (bool success) {\n', "    //Default assumes totalSupply can't be over max (2^256 - 1).\n", "    //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.\n", '    //Replace the if with this one instead.\n', '    //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '    if (balances[msg.sender] >= _value && _value > 0) {\n', '      balances[msg.sender] -= _value;\n', '      balances[_to] += _value;\n', '      Transfer(msg.sender, _to, _value);\n', '      return true;\n', '    } else { return false; }\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '    //same as above. Replace this line with the following if you want to protect against wrapping uints.\n', '    //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '    if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '      balances[_to] += _value;\n', '      balances[_from] -= _value;\n', '      allowed[_from][msg.sender] -= _value;\n', '      Transfer(_from, _to, _value);\n', '      return true;\n', '    } else { return false; }\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) returns (bool success) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  mapping (address => uint256) balances;\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', 'contract EasyMineToken is StandardToken {\n', '\n', '  string public constant name = "easyMINE Token";\n', '  string public constant symbol = "EMT";\n', '  uint8 public constant decimals = 18;\n', '\n', '  function EasyMineToken(address _icoAddress,\n', '                         address _preIcoAddress,\n', '                         address _easyMineWalletAddress,\n', '                         address _bountyWalletAddress) {\n', '    require(_icoAddress != 0x0);\n', '    require(_preIcoAddress != 0x0);\n', '    require(_easyMineWalletAddress != 0x0);\n', '    require(_bountyWalletAddress != 0x0);\n', '\n', '    totalSupply = 33000000 * 10**18;                     // 33.000.000 EMT\n', '\n', '    uint256 icoTokens = 27000000 * 10**18;               // 27.000.000 EMT\n', '\n', '    uint256 preIcoTokens = 2000000 * 10**18;             // 2.000.000 EMT\n', '\n', '    uint256 easyMineTokens = 3000000 * 10**18;           // 1.500.000 EMT dev team +\n', '                                                         // 500.000 EMT advisors +\n', '                                                         // 1.000.000 EMT easyMINE corporation +\n', '                                                         // = 3.000.000 EMT\n', '\n', '    uint256 bountyTokens = 1000000 * 10**18;             // 1.000.000 EMT\n', '\n', '    assert(icoTokens + preIcoTokens + easyMineTokens + bountyTokens == totalSupply);\n', '\n', '    balances[_icoAddress] = icoTokens;\n', '    Transfer(0, _icoAddress, icoTokens);\n', '\n', '    balances[_preIcoAddress] = preIcoTokens;\n', '    Transfer(0, _preIcoAddress, preIcoTokens);\n', '\n', '    balances[_easyMineWalletAddress] = easyMineTokens;\n', '    Transfer(0, _easyMineWalletAddress, easyMineTokens);\n', '\n', '    balances[_bountyWalletAddress] = bountyTokens;\n', '    Transfer(0, _bountyWalletAddress, bountyTokens);\n', '  }\n', '\n', '  function burn(uint256 _value) returns (bool success) {\n', '    if (balances[msg.sender] >= _value && _value > 0) {\n', '      balances[msg.sender] -= _value;\n', '      totalSupply -= _value;\n', '      Transfer(msg.sender, 0x0, _value);\n', '      return true;\n', '    } else {\n', '      return false;\n', '    }\n', '  }\n', '}']
