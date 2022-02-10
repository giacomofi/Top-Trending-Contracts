['pragma solidity ^0.4.21;\n', '\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    \n', '    /// &#39;owner&#39; is the only address that can call a function with \n', '    /// this modifier\n', '    address public owner;\n', '    address internal newOwner;\n', '    \n', '    ///@notice The constructor assigns the message sender to be &#39;owner&#39;\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    event updateOwner(address _oldOwner, address _newOwner);\n', '    \n', '    ///change the owner\n', '    function changeOwner(address _newOwner) public onlyOwner returns(bool) {\n', '        require(owner != _newOwner);\n', '        newOwner = _newOwner;\n', '        return true;\n', '    }\n', '    \n', '    /// accept the ownership\n', '    function acceptNewOwner() public returns(bool) {\n', '        require(msg.sender == newOwner);\n', '        emit updateOwner(owner, newOwner);\n', '        owner = newOwner;\n', '        return true;\n', '    }\n', '}\n', '\n', '// Safe maths, borrowed from OpenZeppelin\n', '// ----------------------------------------------------------------------------\n', 'library SafeMath {\n', '\n', '  function mul(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal pure returns (uint) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal pure returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', 'contract tokenRecipient {\n', '  function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;\n', '}\n', '\n', 'contract ERC20Token {\n', '    /* This is a slight change to the ERC20 base standard.\n', '    function totalSupply() constant returns (uint256 supply);\n', '    is replaced with:\n', '    uint256 public totalSupply;\n', '    This automatically creates a getter function for the totalSupply.\n', '    This is moved to the base contract since public getter functions are not\n', '    currently recognised as an implementation of the matching abstract\n', '    function by the compiler.\n', '    */\n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) constant public returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract standardToken is ERC20Token {\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowances;\n', '\n', '    function balanceOf(address _owner) constant public returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /* Transfers tokens from your address to other */\n', '    function transfer(address _to, uint256 _value) \n', '        public \n', '        returns (bool success) \n', '    {\n', '        require (balances[msg.sender] >= _value);           // Throw if sender has insufficient balance\n', '        require (balances[_to] + _value >= balances[_to]);  // Throw if owerflow detected\n', '        balances[msg.sender] -= _value;                     // Deduct senders balance\n', '        balances[_to] += _value;                            // Add recivers blaance\n', '        emit Transfer(msg.sender, _to, _value);             // Raise Transfer event\n', '        return true;\n', '    }\n', '\n', '    /* Approve other address to spend tokens on your account */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        require(balances[msg.sender] >= _value);\n', '        allowances[msg.sender][_spender] = _value;          // Set allowance\n', '        emit Approval(msg.sender, _spender, _value);        // Raise Approval event\n', '        return true;\n', '    }\n', '\n', '    /* Approve and then communicate the approved contract in a single tx */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);              // Cast spender to tokenRecipient contract\n', '        approve(_spender, _value);                                      // Set approval to contract for _value\n', '        spender.receiveApproval(msg.sender, _value, this, _extraData);  // Raise method on _spender contract\n', '        return true;\n', '    }\n', '\n', '    /* A contract attempts to get the coins */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require (balances[_from] >= _value);                // Throw if sender does not have enough balance\n', '        require (balances[_to] + _value >= balances[_to]);  // Throw if overflow detected\n', '        require (_value <= allowances[_from][msg.sender]);  // Throw if you do not have allowance\n', '        balances[_from] -= _value;                          // Deduct senders balance\n', '        balances[_to] += _value;                            // Add recipient blaance\n', '        allowances[_from][msg.sender] -= _value;            // Deduct allowance for this address\n', '        emit Transfer(_from, _to, _value);                  // Raise Transfer event\n', '        return true;\n', '    }\n', '\n', '    /* Get the amount of allowed tokens to spend */\n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {\n', '        return allowances[_owner][_spender];\n', '    }\n', '\n', '}\n', '\n', 'contract KODB is standardToken, Owned {\n', '    using SafeMath for uint;\n', '    \n', '    string public name="kingdom of develop blockchain";\n', '    string public symbol="KODB";\n', '    uint256 public decimals=18;\n', '    uint256 public totalSupply = 0;\n', '    uint256 public topTotalSupply = 1*10**8*10**decimals;\n', '    /// @dev Fallback to calling deposit when ether is sent directly to contract.\n', '    function() public payable {\n', '        revert();\n', '    }\n', '    \n', '    /// @dev initial function\n', '    function KODB(address _tokenAlloc) public {\n', '        owner=msg.sender;\n', '        balances[_tokenAlloc] = topTotalSupply;\n', '        totalSupply = topTotalSupply;\n', '        emit Transfer(0x0, _tokenAlloc, topTotalSupply); \n', '    }\n', '}']
['pragma solidity ^0.4.21;\n', '\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    \n', "    /// 'owner' is the only address that can call a function with \n", '    /// this modifier\n', '    address public owner;\n', '    address internal newOwner;\n', '    \n', "    ///@notice The constructor assigns the message sender to be 'owner'\n", '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    event updateOwner(address _oldOwner, address _newOwner);\n', '    \n', '    ///change the owner\n', '    function changeOwner(address _newOwner) public onlyOwner returns(bool) {\n', '        require(owner != _newOwner);\n', '        newOwner = _newOwner;\n', '        return true;\n', '    }\n', '    \n', '    /// accept the ownership\n', '    function acceptNewOwner() public returns(bool) {\n', '        require(msg.sender == newOwner);\n', '        emit updateOwner(owner, newOwner);\n', '        owner = newOwner;\n', '        return true;\n', '    }\n', '}\n', '\n', '// Safe maths, borrowed from OpenZeppelin\n', '// ----------------------------------------------------------------------------\n', 'library SafeMath {\n', '\n', '  function mul(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal pure returns (uint) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal pure returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', 'contract tokenRecipient {\n', '  function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;\n', '}\n', '\n', 'contract ERC20Token {\n', '    /* This is a slight change to the ERC20 base standard.\n', '    function totalSupply() constant returns (uint256 supply);\n', '    is replaced with:\n', '    uint256 public totalSupply;\n', '    This automatically creates a getter function for the totalSupply.\n', '    This is moved to the base contract since public getter functions are not\n', '    currently recognised as an implementation of the matching abstract\n', '    function by the compiler.\n', '    */\n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) constant public returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract standardToken is ERC20Token {\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowances;\n', '\n', '    function balanceOf(address _owner) constant public returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /* Transfers tokens from your address to other */\n', '    function transfer(address _to, uint256 _value) \n', '        public \n', '        returns (bool success) \n', '    {\n', '        require (balances[msg.sender] >= _value);           // Throw if sender has insufficient balance\n', '        require (balances[_to] + _value >= balances[_to]);  // Throw if owerflow detected\n', '        balances[msg.sender] -= _value;                     // Deduct senders balance\n', '        balances[_to] += _value;                            // Add recivers blaance\n', '        emit Transfer(msg.sender, _to, _value);             // Raise Transfer event\n', '        return true;\n', '    }\n', '\n', '    /* Approve other address to spend tokens on your account */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        require(balances[msg.sender] >= _value);\n', '        allowances[msg.sender][_spender] = _value;          // Set allowance\n', '        emit Approval(msg.sender, _spender, _value);        // Raise Approval event\n', '        return true;\n', '    }\n', '\n', '    /* Approve and then communicate the approved contract in a single tx */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);              // Cast spender to tokenRecipient contract\n', '        approve(_spender, _value);                                      // Set approval to contract for _value\n', '        spender.receiveApproval(msg.sender, _value, this, _extraData);  // Raise method on _spender contract\n', '        return true;\n', '    }\n', '\n', '    /* A contract attempts to get the coins */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require (balances[_from] >= _value);                // Throw if sender does not have enough balance\n', '        require (balances[_to] + _value >= balances[_to]);  // Throw if overflow detected\n', '        require (_value <= allowances[_from][msg.sender]);  // Throw if you do not have allowance\n', '        balances[_from] -= _value;                          // Deduct senders balance\n', '        balances[_to] += _value;                            // Add recipient blaance\n', '        allowances[_from][msg.sender] -= _value;            // Deduct allowance for this address\n', '        emit Transfer(_from, _to, _value);                  // Raise Transfer event\n', '        return true;\n', '    }\n', '\n', '    /* Get the amount of allowed tokens to spend */\n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {\n', '        return allowances[_owner][_spender];\n', '    }\n', '\n', '}\n', '\n', 'contract KODB is standardToken, Owned {\n', '    using SafeMath for uint;\n', '    \n', '    string public name="kingdom of develop blockchain";\n', '    string public symbol="KODB";\n', '    uint256 public decimals=18;\n', '    uint256 public totalSupply = 0;\n', '    uint256 public topTotalSupply = 1*10**8*10**decimals;\n', '    /// @dev Fallback to calling deposit when ether is sent directly to contract.\n', '    function() public payable {\n', '        revert();\n', '    }\n', '    \n', '    /// @dev initial function\n', '    function KODB(address _tokenAlloc) public {\n', '        owner=msg.sender;\n', '        balances[_tokenAlloc] = topTotalSupply;\n', '        totalSupply = topTotalSupply;\n', '        emit Transfer(0x0, _tokenAlloc, topTotalSupply); \n', '    }\n', '}']
