['pragma solidity ^0.4.11;\n', '\n', 'contract owned { address public owner;\n', '\n', '  function owned() {\n', '      owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner {\n', '      require(msg.sender == owner);\n', '      _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '      owner = newOwner;\n', '  }\n', '}\n', '\n', 'contract tokenRecipient { function receiveApproval(address from, uint256 value, address token, bytes extraData); }\n', '\n', 'contract token { \n', '    string public name; string public symbol; uint8 public decimals; uint256 public totalSupply;\n', '\n', '  /* This creates an array with all balances */\n', '  mapping (address => uint256) public balanceOf;\n', '  mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '  /* This generates a public event on the blockchain that will notify clients */\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '  /* This notifies clients about the amount burnt */\n', '  event Burn(address indexed from, uint256 value);\n', '\n', '  /* Initializes contract with initial supply tokens to the creator of the contract */\n', '  function token(\n', '      uint256 initialSupply,\n', '      string tokenName,\n', '      uint8 decimalUnits,\n', '      string tokenSymbol\n', '      ) {\n', '      balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens\n', '      totalSupply = initialSupply;                        // Update total supply\n', '      name = tokenName;                                   // Set the name for display purposes\n', '      symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '      decimals = decimalUnits;                            // Amount of decimals for display purposes\n', '  }\n', '\n', '  /* Internal transfer, only can be called by this contract */\n', '  function _transfer(address _from, address _to, uint _value) internal {\n', '      require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\n', '      require (balanceOf[_from] > _value);                // Check if the sender has enough\n', '      require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows\n', '      balanceOf[_from] -= _value;                         // Subtract from the sender\n', '      balanceOf[_to] += _value;                            // Add the same to the recipient\n', '      Transfer(_from, _to, _value);\n', '  }\n', '\n', '  /// @notice Send `_value` tokens to `_to` from your account\n', '  /// @param _to The address of the recipient\n', '  /// @param _value the amount to send\n', '  function transfer(address _to, uint256 _value) {\n', '      _transfer(msg.sender, _to, _value);\n', '  }\n', '\n', '  /// @notice Send `_value` tokens to `_to` in behalf of `_from`\n', '  /// @param _from The address of the sender\n', '  /// @param _to The address of the recipient\n', '  /// @param _value the amount to send\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '      require (_value < allowance[_from][msg.sender]);     // Check allowance\n', '      allowance[_from][msg.sender] -= _value;\n', '      _transfer(_from, _to, _value);\n', '      return true;\n', '  }\n', '\n', '  /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '  /// @param _spender The address authorized to spend\n', '  /// @param _value the max amount they can spend\n', '  function approve(address _spender, uint256 _value)\n', '      returns (bool success) {\n', '      allowance[msg.sender][_spender] = _value;\n', '      return true;\n', '  }\n', '\n', '  /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '  /// @param _spender The address authorized to spend\n', '  /// @param _value the max amount they can spend\n', '  /// @param _extraData some extra information to send to the approved contract\n', '  function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '      returns (bool success) {\n', '      tokenRecipient spender = tokenRecipient(_spender);\n', '      if (approve(_spender, _value)) {\n', '          spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '          return true;\n', '      }\n', '  }        \n', '\n', '  /// @notice Remove `_value` tokens from the system irreversibly\n', '  /// @param _value the amount of money to burn\n', '  function burn(uint256 _value) returns (bool success) {\n', '      require (balanceOf[msg.sender] > _value);            // Check if the sender has enough\n', '      balanceOf[msg.sender] -= _value;                      // Subtract from the sender\n', '      totalSupply -= _value;                                // Updates totalSupply\n', '      Burn(msg.sender, _value);\n', '      return true;\n', '  }\n', '\n', '  function burnFrom(address _from, uint256 _value) returns (bool success) {\n', '      require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '      require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '      balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', '      allowance[_from][msg.sender] -= _value;             // Subtract from the sender&#39;s allowance\n', '      totalSupply -= _value;                              // Update totalSupply\n', '      Burn(_from, _value);\n', '      return true;\n', '  }\n', '}\n', '\n', 'contract MyAdvancedToken is owned, token {\n', '\n', '  uint256 public sellPrice;\n', '  uint256 public buyPrice;\n', '\n', '  mapping (address => bool) public frozenAccount;\n', '\n', '  /* This generates a public event on the blockchain that will notify clients */\n', '  event FrozenFunds(address target, bool frozen);\n', '\n', '  /* Initializes contract with initial supply tokens to the creator of the contract */\n', '  function MyAdvancedToken(\n', '      uint256 initialSupply,\n', '      string tokenName,\n', '      uint8 decimalUnits,\n', '      string tokenSymbol\n', '  ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}\n', '\n', '  /* Internal transfer, only can be called by this contract */\n', '  function _transfer(address _from, address _to, uint _value) internal {\n', '      require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\n', '      require (balanceOf[_from] > _value);                // Check if the sender has enough\n', '      require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows\n', '      require(!frozenAccount[_from]);                     // Check if sender is frozen\n', '      require(!frozenAccount[_to]);                       // Check if recipient is frozen\n', '      balanceOf[_from] -= _value;                         // Subtract from the sender\n', '      balanceOf[_to] += _value;                           // Add the same to the recipient\n', '      Transfer(_from, _to, _value);\n', '  }\n', '\n', '  /// @notice Create `mintedAmount` tokens and send it to `target`\n', '  /// @param target Address to receive the tokens\n', '  /// @param mintedAmount the amount of tokens it will receive\n', '  function mintToken(address target, uint256 mintedAmount) onlyOwner {\n', '      balanceOf[target] += mintedAmount;\n', '      totalSupply += mintedAmount;\n', '      Transfer(0, this, mintedAmount);\n', '      Transfer(this, target, mintedAmount);\n', '  }\n', '\n', '  /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens\n', '  /// @param target Address to be frozen\n', '  /// @param freeze either to freeze it or not\n', '  function freezeAccount(address target, bool freeze) onlyOwner {\n', '      frozenAccount[target] = freeze;\n', '      FrozenFunds(target, freeze);\n', '  }\n', '\n', '  /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth\n', '  /// @param newSellPrice Price the users can sell to the contract\n', '  /// @param newBuyPrice Price users can buy from the contract\n', '  function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {\n', '      sellPrice = newSellPrice;\n', '      buyPrice = newBuyPrice;\n', '  }\n', '\n', '  /// @notice Buy tokens from contract by sending ether\n', '  function buy() payable {\n', '      uint amount = msg.value / buyPrice;               // calculates the amount\n', '      _transfer(this, msg.sender, amount);              // makes the transfers\n', '  }\n', '\n', '  /// @notice Sell `amount` tokens to contract\n', '  /// @param amount amount of tokens to be sold\n', '  function sell(uint256 amount) {\n', '      require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy\n', '      _transfer(msg.sender, this, amount);              // makes the transfers\n', '      msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It&#39;s important to do this last to avoid recursion attacks\n', '  }\n', '}']
['pragma solidity ^0.4.11;\n', '\n', 'contract owned { address public owner;\n', '\n', '  function owned() {\n', '      owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner {\n', '      require(msg.sender == owner);\n', '      _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '      owner = newOwner;\n', '  }\n', '}\n', '\n', 'contract tokenRecipient { function receiveApproval(address from, uint256 value, address token, bytes extraData); }\n', '\n', 'contract token { \n', '    string public name; string public symbol; uint8 public decimals; uint256 public totalSupply;\n', '\n', '  /* This creates an array with all balances */\n', '  mapping (address => uint256) public balanceOf;\n', '  mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '  /* This generates a public event on the blockchain that will notify clients */\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '  /* This notifies clients about the amount burnt */\n', '  event Burn(address indexed from, uint256 value);\n', '\n', '  /* Initializes contract with initial supply tokens to the creator of the contract */\n', '  function token(\n', '      uint256 initialSupply,\n', '      string tokenName,\n', '      uint8 decimalUnits,\n', '      string tokenSymbol\n', '      ) {\n', '      balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens\n', '      totalSupply = initialSupply;                        // Update total supply\n', '      name = tokenName;                                   // Set the name for display purposes\n', '      symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '      decimals = decimalUnits;                            // Amount of decimals for display purposes\n', '  }\n', '\n', '  /* Internal transfer, only can be called by this contract */\n', '  function _transfer(address _from, address _to, uint _value) internal {\n', '      require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\n', '      require (balanceOf[_from] > _value);                // Check if the sender has enough\n', '      require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows\n', '      balanceOf[_from] -= _value;                         // Subtract from the sender\n', '      balanceOf[_to] += _value;                            // Add the same to the recipient\n', '      Transfer(_from, _to, _value);\n', '  }\n', '\n', '  /// @notice Send `_value` tokens to `_to` from your account\n', '  /// @param _to The address of the recipient\n', '  /// @param _value the amount to send\n', '  function transfer(address _to, uint256 _value) {\n', '      _transfer(msg.sender, _to, _value);\n', '  }\n', '\n', '  /// @notice Send `_value` tokens to `_to` in behalf of `_from`\n', '  /// @param _from The address of the sender\n', '  /// @param _to The address of the recipient\n', '  /// @param _value the amount to send\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '      require (_value < allowance[_from][msg.sender]);     // Check allowance\n', '      allowance[_from][msg.sender] -= _value;\n', '      _transfer(_from, _to, _value);\n', '      return true;\n', '  }\n', '\n', '  /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '  /// @param _spender The address authorized to spend\n', '  /// @param _value the max amount they can spend\n', '  function approve(address _spender, uint256 _value)\n', '      returns (bool success) {\n', '      allowance[msg.sender][_spender] = _value;\n', '      return true;\n', '  }\n', '\n', '  /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '  /// @param _spender The address authorized to spend\n', '  /// @param _value the max amount they can spend\n', '  /// @param _extraData some extra information to send to the approved contract\n', '  function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '      returns (bool success) {\n', '      tokenRecipient spender = tokenRecipient(_spender);\n', '      if (approve(_spender, _value)) {\n', '          spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '          return true;\n', '      }\n', '  }        \n', '\n', '  /// @notice Remove `_value` tokens from the system irreversibly\n', '  /// @param _value the amount of money to burn\n', '  function burn(uint256 _value) returns (bool success) {\n', '      require (balanceOf[msg.sender] > _value);            // Check if the sender has enough\n', '      balanceOf[msg.sender] -= _value;                      // Subtract from the sender\n', '      totalSupply -= _value;                                // Updates totalSupply\n', '      Burn(msg.sender, _value);\n', '      return true;\n', '  }\n', '\n', '  function burnFrom(address _from, uint256 _value) returns (bool success) {\n', '      require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '      require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '      balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', "      allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance\n", '      totalSupply -= _value;                              // Update totalSupply\n', '      Burn(_from, _value);\n', '      return true;\n', '  }\n', '}\n', '\n', 'contract MyAdvancedToken is owned, token {\n', '\n', '  uint256 public sellPrice;\n', '  uint256 public buyPrice;\n', '\n', '  mapping (address => bool) public frozenAccount;\n', '\n', '  /* This generates a public event on the blockchain that will notify clients */\n', '  event FrozenFunds(address target, bool frozen);\n', '\n', '  /* Initializes contract with initial supply tokens to the creator of the contract */\n', '  function MyAdvancedToken(\n', '      uint256 initialSupply,\n', '      string tokenName,\n', '      uint8 decimalUnits,\n', '      string tokenSymbol\n', '  ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}\n', '\n', '  /* Internal transfer, only can be called by this contract */\n', '  function _transfer(address _from, address _to, uint _value) internal {\n', '      require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\n', '      require (balanceOf[_from] > _value);                // Check if the sender has enough\n', '      require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows\n', '      require(!frozenAccount[_from]);                     // Check if sender is frozen\n', '      require(!frozenAccount[_to]);                       // Check if recipient is frozen\n', '      balanceOf[_from] -= _value;                         // Subtract from the sender\n', '      balanceOf[_to] += _value;                           // Add the same to the recipient\n', '      Transfer(_from, _to, _value);\n', '  }\n', '\n', '  /// @notice Create `mintedAmount` tokens and send it to `target`\n', '  /// @param target Address to receive the tokens\n', '  /// @param mintedAmount the amount of tokens it will receive\n', '  function mintToken(address target, uint256 mintedAmount) onlyOwner {\n', '      balanceOf[target] += mintedAmount;\n', '      totalSupply += mintedAmount;\n', '      Transfer(0, this, mintedAmount);\n', '      Transfer(this, target, mintedAmount);\n', '  }\n', '\n', '  /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens\n', '  /// @param target Address to be frozen\n', '  /// @param freeze either to freeze it or not\n', '  function freezeAccount(address target, bool freeze) onlyOwner {\n', '      frozenAccount[target] = freeze;\n', '      FrozenFunds(target, freeze);\n', '  }\n', '\n', '  /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth\n', '  /// @param newSellPrice Price the users can sell to the contract\n', '  /// @param newBuyPrice Price users can buy from the contract\n', '  function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {\n', '      sellPrice = newSellPrice;\n', '      buyPrice = newBuyPrice;\n', '  }\n', '\n', '  /// @notice Buy tokens from contract by sending ether\n', '  function buy() payable {\n', '      uint amount = msg.value / buyPrice;               // calculates the amount\n', '      _transfer(this, msg.sender, amount);              // makes the transfers\n', '  }\n', '\n', '  /// @notice Sell `amount` tokens to contract\n', '  /// @param amount amount of tokens to be sold\n', '  function sell(uint256 amount) {\n', '      require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy\n', '      _transfer(msg.sender, this, amount);              // makes the transfers\n', "      msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks\n", '  }\n', '}']
