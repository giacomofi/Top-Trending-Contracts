['pragma solidity ^0.4.16;\n', '\n', 'library Math {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Token {\n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '\n', '    uint256 public decimals;                \n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', 'contract Cloud is Token {\n', '\n', '    using Math for uint256;\n', '\tbool trading=false;\n', '\n', '    mapping (address => bool) public frozenAccount;\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    function transfer(address _to, uint256 _value) canTrade returns (bool success) {\n', '        require(_value > 0);\n', '        require(!frozenAccount[msg.sender]);\n', '        require(balances[msg.sender] >= _value);\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) canTrade returns (bool success) {\n', '        require(_value > 0);\n', '        require(!frozenAccount[_from]);\n', '        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);\n', '        //require(balances[_from] >= _value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '\tmodifier canTrade {\n', '    \trequire(trading==true ||(canRelease==true && msg.sender==owner));\n', '    \t_;\n', '    }\n', '    \n', '    function setTrade(bool allow) onlyOwner {\n', '    \ttrading=allow;\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    \n', '    /* Public variables of the token */\n', '    event Invested(address investor, uint256 tokens);\n', '\n', '    uint256 public employeeShare=8;\n', '    // Wallets - 4 employee\n', '    address[4] employeeWallets = [0x9caeD53A6C6E91546946dD866dFD66c0aaB9f347,0xf1Df495BE71d1E5EdEbCb39D85D5F6b620aaAF47,0xa3C38bc8dD6e26eCc0D64d5B25f5ce855bb57Cd5,0x4d67a23b62399eDec07ad9c0f748D89655F0a0CB];\n', '\n', '    string public name;                 \n', '    string public symbol;               \n', '    address public owner;\t\t\t\t\n', '    uint256 public tokensReleased=0;\n', '    bool canRelease=false;\n', '\n', '    /* Initializes contract with initial supply tokens to the owner of the contract */\n', '    function Cloud(\n', '        uint256 _initialAmount,\n', '        uint256 _decimalUnits,\n', '        string _tokenName,\n', '        string _tokenSymbol,\n', '        address ownerWallet\n', '        ) {\n', '        owner=ownerWallet;\n', '        decimals = _decimalUnits;                            // Amount of decimals for display purposes\n', '        totalSupply = _initialAmount*(10**decimals);         // Update total supply\n', '        balances[owner] = totalSupply;                       // Give the creator all initial tokens\n', '        name = _tokenName;                                   // Set the name for display purposes\n', '        symbol = _tokenSymbol;                               // Set the symbol for display purposes\n', '    }\n', '\n', '    /* Freezing tokens */\n', '    function freezeAccount(address target, bool freeze) onlyOwner{\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '\n', '    /* Authenticating owner */\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    /* Allow and restrict of release of tokens */\n', '    function releaseTokens(bool allow) onlyOwner {\n', '        canRelease=allow;\n', '    }\n', '    /// @param receiver The address of the account which will receive the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the token transfer was successful or not was successful or not\n', '    function invest(address receiver, uint256 _value) onlyOwner returns (bool success) {\n', '        require(canRelease);\n', '        require(_value > 0);\n', '        uint256 numTokens = _value*(10**decimals);\n', '        uint256 employeeTokens = 0;\n', '        uint256 employeeTokenShare=0;\n', '        // divide employee tokens by 4 shares\n', '        employeeTokens = numTokens.mul(employeeShare).div(100);\n', '        employeeTokenShare = employeeTokens.div(employeeWallets.length);\n', '        //split tokens for different wallets of employees and company\n', '        approve(owner,employeeTokens.add(numTokens));\n', '        for(uint i = 0; i < employeeWallets.length; i++)\n', '        {\n', '            require(transferFrom(owner, employeeWallets[i], employeeTokenShare));\n', '        }\n', '        require(transferFrom(owner, receiver, numTokens));\n', '        tokensReleased = tokensReleased.add(numTokens).add(employeeTokens.mul(4));\n', '        Invested(receiver,numTokens);\n', '        return true;\n', '    }\n', '}']
['pragma solidity ^0.4.16;\n', '\n', 'library Math {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Token {\n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '\n', '    uint256 public decimals;                \n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', 'contract Cloud is Token {\n', '\n', '    using Math for uint256;\n', '\tbool trading=false;\n', '\n', '    mapping (address => bool) public frozenAccount;\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    function transfer(address _to, uint256 _value) canTrade returns (bool success) {\n', '        require(_value > 0);\n', '        require(!frozenAccount[msg.sender]);\n', '        require(balances[msg.sender] >= _value);\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) canTrade returns (bool success) {\n', '        require(_value > 0);\n', '        require(!frozenAccount[_from]);\n', '        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);\n', '        //require(balances[_from] >= _value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '\tmodifier canTrade {\n', '    \trequire(trading==true ||(canRelease==true && msg.sender==owner));\n', '    \t_;\n', '    }\n', '    \n', '    function setTrade(bool allow) onlyOwner {\n', '    \ttrading=allow;\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    \n', '    /* Public variables of the token */\n', '    event Invested(address investor, uint256 tokens);\n', '\n', '    uint256 public employeeShare=8;\n', '    // Wallets - 4 employee\n', '    address[4] employeeWallets = [0x9caeD53A6C6E91546946dD866dFD66c0aaB9f347,0xf1Df495BE71d1E5EdEbCb39D85D5F6b620aaAF47,0xa3C38bc8dD6e26eCc0D64d5B25f5ce855bb57Cd5,0x4d67a23b62399eDec07ad9c0f748D89655F0a0CB];\n', '\n', '    string public name;                 \n', '    string public symbol;               \n', '    address public owner;\t\t\t\t\n', '    uint256 public tokensReleased=0;\n', '    bool canRelease=false;\n', '\n', '    /* Initializes contract with initial supply tokens to the owner of the contract */\n', '    function Cloud(\n', '        uint256 _initialAmount,\n', '        uint256 _decimalUnits,\n', '        string _tokenName,\n', '        string _tokenSymbol,\n', '        address ownerWallet\n', '        ) {\n', '        owner=ownerWallet;\n', '        decimals = _decimalUnits;                            // Amount of decimals for display purposes\n', '        totalSupply = _initialAmount*(10**decimals);         // Update total supply\n', '        balances[owner] = totalSupply;                       // Give the creator all initial tokens\n', '        name = _tokenName;                                   // Set the name for display purposes\n', '        symbol = _tokenSymbol;                               // Set the symbol for display purposes\n', '    }\n', '\n', '    /* Freezing tokens */\n', '    function freezeAccount(address target, bool freeze) onlyOwner{\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '\n', '    /* Authenticating owner */\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    /* Allow and restrict of release of tokens */\n', '    function releaseTokens(bool allow) onlyOwner {\n', '        canRelease=allow;\n', '    }\n', '    /// @param receiver The address of the account which will receive the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the token transfer was successful or not was successful or not\n', '    function invest(address receiver, uint256 _value) onlyOwner returns (bool success) {\n', '        require(canRelease);\n', '        require(_value > 0);\n', '        uint256 numTokens = _value*(10**decimals);\n', '        uint256 employeeTokens = 0;\n', '        uint256 employeeTokenShare=0;\n', '        // divide employee tokens by 4 shares\n', '        employeeTokens = numTokens.mul(employeeShare).div(100);\n', '        employeeTokenShare = employeeTokens.div(employeeWallets.length);\n', '        //split tokens for different wallets of employees and company\n', '        approve(owner,employeeTokens.add(numTokens));\n', '        for(uint i = 0; i < employeeWallets.length; i++)\n', '        {\n', '            require(transferFrom(owner, employeeWallets[i], employeeTokenShare));\n', '        }\n', '        require(transferFrom(owner, receiver, numTokens));\n', '        tokensReleased = tokensReleased.add(numTokens).add(employeeTokens.mul(4));\n', '        Invested(receiver,numTokens);\n', '        return true;\n', '    }\n', '}']
