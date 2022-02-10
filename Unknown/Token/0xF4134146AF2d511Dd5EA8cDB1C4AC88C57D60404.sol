['//\n', '/* SunContract Token Smart Contract v1.0 */   \n', '//\n', '\n', 'contract owned {\n', '\n', '  address public owner;\n', '\n', '  function owned() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner {\n', '    if (msg.sender != owner) throw;\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', 'contract tokenRecipient { \n', '  function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);\n', '} \n', '\n', 'contract IERC20Token {\n', '\n', '  /// @return total amount of tokens\n', '  function totalSupply() constant returns (uint256 totalSupply);\n', '\n', '  /// @param _owner The address from which the balance will be retrieved\n', '  /// @return The balance\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {}\n', '\n', '  /// @notice send `_value` token to `_to` from `msg.sender`\n', '  /// @param _to The address of the recipient\n', '  /// @param _value The amount of tokens to be transferred\n', '  /// @return Whether the transfer was successful or not\n', '  function transfer(address _to, uint256 _value) returns (bool success) {}\n', '\n', '  /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '  /// @param _from The address of the sender\n', '  /// @param _to The address of the recipient\n', '  /// @param _value The amount of token to be transferred\n', '  /// @return Whether the transfer was successful or not\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}\n', '\n', '  /// @notice `msg.sender` approves `_addr` to spend `_value` tokens\n', '  /// @param _spender The address of the account able to transfer the tokens\n', '  /// @param _value The amount of wei to be approved for transfer\n', '  /// @return Whether the approval was successful or not\n', '  function approve(address _spender, uint256 _value) returns (bool success) {}\n', '\n', '  /// @param _owner The address of the account owning tokens\n', '  /// @param _spender The address of the account able to transfer the tokens\n', '  /// @return Amount of remaining tokens allowed to spent\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}\n', '\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '} \n', '\n', 'contract SunContractToken is IERC20Token, owned{\n', '\n', '  /* Public variables of the token */\n', '  string public standard = "SunContract token v1.0";\n', '  string public name = "SunContract";\n', '  string public symbol = "SNC";\n', '  uint8 public decimals = 18;\n', '  address public icoContractAddress;\n', '  uint256 public tokenFrozenUntilBlock;\n', '\n', '  /* Private variables of the token */\n', '  uint256 supply = 0;\n', '  mapping (address => uint256) balances;\n', '  mapping (address => mapping (address => uint256)) allowances;\n', '  mapping (address => bool) restrictedAddresses;\n', '\n', '  /* Events */\n', '  event Mint(address indexed _to, uint256 _value);\n', '  event Burn(address indexed _from, uint256 _value);\n', '  event TokenFrozen(uint256 _frozenUntilBlock, string _reason);\n', '\n', '  /* Initializes contract and  sets restricted addresses */\n', '  function SunContractToken(address _icoAddress) {\n', '    restrictedAddresses[0x0] = true;\n', '    restrictedAddresses[_icoAddress] = true;\n', '    restrictedAddresses[address(this)] = true;\n', '    icoContractAddress = _icoAddress;\n', '  }\n', '\n', '  /* Returns total supply of issued tokens */\n', '  function totalSupply() constant returns (uint256 totalSupply) {\n', '    return supply;\n', '  }\n', '\n', '  /* Returns balance of address */\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  /* Transfers tokens from your address to other */\n', '  function transfer(address _to, uint256 _value) returns (bool success) {\n', '    if (block.number < tokenFrozenUntilBlock) throw;    // Throw if token is frozen\n', '    if (restrictedAddresses[_to]) throw;                // Throw if recipient is restricted address\n', '    if (balances[msg.sender] < _value) throw;           // Throw if sender has insufficient balance\n', '    if (balances[_to] + _value < balances[_to]) throw;  // Throw if owerflow detected\n', '    balances[msg.sender] -= _value;                     // Deduct senders balance\n', '    balances[_to] += _value;                            // Add recivers blaance \n', '    Transfer(msg.sender, _to, _value);                  // Raise Transfer event\n', '    return true;\n', '  }\n', '\n', '  /* Approve other address to spend tokens on your account */\n', '  function approve(address _spender, uint256 _value) returns (bool success) {\n', '    if (block.number < tokenFrozenUntilBlock) throw;    // Throw if token is frozen        \n', '    allowances[msg.sender][_spender] = _value;          // Set allowance         \n', '    Approval(msg.sender, _spender, _value);             // Raise Approval event         \n', '    return true;\n', '  }\n', '\n', '  /* Approve and then communicate the approved contract in a single tx */ \n', '  function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {            \n', '    tokenRecipient spender = tokenRecipient(_spender);              // Cast spender to tokenRecipient contract         \n', '    approve(_spender, _value);                                      // Set approval to contract for _value         \n', '    spender.receiveApproval(msg.sender, _value, this, _extraData);  // Raise method on _spender contract         \n', '    return true;     \n', '  }     \n', '\n', '  /* A contract attempts to get the coins */\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {      \n', '    if (block.number < tokenFrozenUntilBlock) throw;    // Throw if token is frozen\n', '    if (restrictedAddresses[_to]) throw;                // Throw if recipient is restricted address  \n', '    if (balances[_from] < _value) throw;                // Throw if sender does not have enough balance     \n', '    if (balances[_to] + _value < balances[_to]) throw;  // Throw if overflow detected    \n', '    if (_value > allowances[_from][msg.sender]) throw;  // Throw if you do not have allowance       \n', '    balances[_from] -= _value;                          // Deduct senders balance    \n', '    balances[_to] += _value;                            // Add recipient blaance         \n', '    allowances[_from][msg.sender] -= _value;            // Deduct allowance for this address         \n', '    Transfer(_from, _to, _value);                       // Raise Transfer event\n', '    return true;     \n', '  }         \n', '\n', '  /* Get the amount of allowed tokens to spend */     \n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {         \n', '    return allowances[_owner][_spender];\n', '  }         \n', '\n', '  /* Issue new tokens */     \n', '  function mintTokens(address _to, uint256 _amount) {         \n', '    if (msg.sender != icoContractAddress) throw;            // Only ICO address can mint tokens        \n', '    if (restrictedAddresses[_to]) throw;                    // Throw if user wants to send to restricted address       \n', '    if (balances[_to] + _amount < balances[_to]) throw;     // Check for overflows\n', '    supply += _amount;                                      // Update total supply\n', '    balances[_to] += _amount;                               // Set minted coins to target\n', '    Mint(_to, _amount);                                     // Create Mint event       \n', '    Transfer(0x0, _to, _amount);                            // Create Transfer event from 0x\n', '  }     \n', '  \n', '  /* Destroy tokens from owners account */\n', '  function burnTokens(uint256 _amount) onlyOwner {\n', '    if(balances[msg.sender] < _amount) throw;               // Throw if you do not have enough balance\n', '    if(supply < _amount) throw;                             // Throw if overflow detected\n', '\n', '    supply -= _amount;                                      // Deduct totalSupply\n', '    balances[msg.sender] -= _amount;                        // Destroy coins on senders wallet\n', '    Burn(msg.sender, _amount);                              // Raise Burn event\n', '    Transfer(msg.sender, 0x0, _amount);                     // Raise transfer to 0x0\n', '  }\n', '\n', '  /* Stops all token transfers in case of emergency */\n', '  function freezeTransfersUntil(uint256 _frozenUntilBlock, string _reason) onlyOwner {      \n', '    tokenFrozenUntilBlock = _frozenUntilBlock;\n', '    TokenFrozen(_frozenUntilBlock, _reason);\n', '  }\n', '\n', '  function isRestrictedAddress(address _querryAddress) constant returns (bool answer){\n', '    return restrictedAddresses[_querryAddress];\n', '  }\n', '\n', '  //\n', '  /* This part is here only for testing and will not be included into final version */\n', '  //\n', '\n', '  //function changeICOAddress(address _newAddress) onlyOwner{\n', '  //  icoContractAddress = _newAddress;\n', '  //  restrictedAddresses[_newAddress] = true;   \n', '  //}\n', '\n', '  //function killContract() onlyOwner{\n', '  //  selfdestruct(msg.sender);\n', '  //}\n', '}']