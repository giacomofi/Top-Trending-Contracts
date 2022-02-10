['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a && c >= b);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', 'contract owned { //Contract used to only allow the owner to call some functions\n', '  address public owner;\n', '\n', '  function owned() public {\n', '  owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner {\n', '  require(msg.sender == owner);\n', '  _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '  owner = newOwner;\n', '  }\n', '}\n', '\n', '\n', 'contract TokenERC20 {\n', '\n', 'using SafeMath for uint256;\n', '// Public variables of the token\n', 'string public name;\n', 'string public symbol;\n', 'uint8 public decimals = 18;\n', '//\n', 'uint256 public totalSupply;\n', '\n', '\n', '// This creates an array with all balances\n', 'mapping (address => uint256) public balanceOf;\n', 'mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '// This generates a public event on the blockchain that will notify clients\n', 'event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '// This notifies clients about the amount burnt\n', 'event Burn(address indexed from, uint256 value);\n', '\n', '/**\n', '* Constrctor function\n', '*\n', '* Initializes contract with initial supply tokens to the creator of the contract\n', '*/\n', 'function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {\n', '  totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount\n', '  balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens\n', '  name = tokenName;                                   // Set the name for display purposes\n', '  symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '}\n', '\n', '/**\n', '* Internal transfer, only can be called by this contract\n', '*/\n', 'function _transfer(address _from, address _to, uint _value) internal {\n', '  // Prevent transfer to 0x0 address. Use burn() instead\n', '  require(_to != 0x0);\n', '  // Check for overflows\n', '  // Subtract from the sender\n', '  balanceOf[_from] = balanceOf[_from].sub(_value);\n', '  // Add the same to the recipient\n', '  balanceOf[_to] = balanceOf[_to].add(_value);\n', '  emit Transfer(_from, _to, _value);\n', '}\n', '\n', '/**\n', '* Function to Transfer tokens\n', '*\n', '* Send `_value` tokens to `_to` from your account\n', '*\n', '* @param _to The address of the recipient\n', '* @param _value the amount to send\n', '*/\n', 'function transfer(address _to, uint256 _value) public {\n', '  _transfer(msg.sender, _to, _value);\n', '}\n', '\n', '/**\n', '* function to Transfer tokens from other address\n', '*\n', '* Send `_value` tokens to `_to` in behalf of `_from`\n', '*\n', '* @param _from The address of the sender\n', '* @param _to The address of the recipient\n', '* @param _value the amount to send\n', '*/\n', 'function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '  allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);\n', '  _transfer(_from, _to, _value);\n', '  return true;\n', '}\n', '\n', '/**\n', '* function Set allowance for other address\n', '*\n', '* Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '*\n', '* @param _spender The address authorized to spend\n', '* @param _value the max amount they can spend\n', '*/\n', 'function approve(address _spender, uint256 _value) public returns (bool success) {\n', '  allowance[msg.sender][_spender] = _value;\n', '  return true;\n', '}\n', '\n', '\n', '/**\n', '*Function to Destroy tokens\n', '*\n', '* Remove `_value` tokens from the system irreversibly\n', '*\n', '* @param _value the amount of money to burn\n', '*/\n', 'function burn(uint256 _value) public returns (bool success) {\n', '  balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender\n', '  totalSupply = totalSupply.sub(_value);                      // Updates totalSupply\n', '  emit Burn(msg.sender, _value);\n', '  return true;\n', '}\n', '\n', '\n', '\n', '/**\n', '* Destroy tokens from other ccount\n', '*\n', '* Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '*\n', '* @param _from the address of the sender\n', '* @param _value the amount of money to burn\n', '*/\n', 'function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '  balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance\n', '  allowance[_from][msg.sender] =allowance[_from][msg.sender].sub(_value);             // Subtract from the sender&#39;s allowance\n', '  totalSupply = totalSupply.sub(_value);                              // Update totalSupply\n', '  emit Burn(_from, _value);\n', '  return true;\n', '}\n', '\n', '\n', '}\n', '\n', '/******************************************/\n', '/*       Accommodation Coin STARTS HERE       */\n', '/******************************************/\n', '\n', 'contract AccommodationCoin is owned, TokenERC20  {\n', '\n', '  //Modify these variables\n', '  uint256 _initialSupply=100000000; \n', '  string _tokenName="Accommodation Coin";  \n', '  string _tokenSymbol="ACC";\n', '\n', '  mapping (address => bool) public frozenAccount;\n', '\n', '  /* This generates a public event on the blockchain that will notify clients */\n', '  event FrozenFunds(address target, bool frozen);\n', '\n', '  /* Initializes contract with initial supply tokens to the creator of the contract */\n', '  function AccommodationCoin( ) TokenERC20(_initialSupply, _tokenName, _tokenSymbol) public {}\n', '\n', '  /* Internal transfer, only can be called by this contract. */\n', '  function _transfer(address _from, address _to, uint _value) internal {\n', '    require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\n', '    require(!frozenAccount[_from]);                     // Check if sender is frozen\n', '    require(!frozenAccount[_to]);                       // Check if recipient is frozen\n', '    balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender\n', '    balanceOf[_to] = balanceOf[_to].add(_value);                           // Add the same to the recipient\n', '    emit Transfer(_from, _to, _value);\n', '  }\n', '\n', '  /// function to create more coins and send it to `target`\n', '  /// @param target Address to receive the tokens\n', '  /// @param mintedAmount the amount of tokens it will receive\n', '  function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '    balanceOf[target] = balanceOf[target].add(mintedAmount);\n', '    totalSupply = totalSupply.add(mintedAmount);\n', '    emit Transfer(0, this, mintedAmount);\n', '    emit Transfer(this, target, mintedAmount);\n', '  }\n', '\n', '  function freezeAccount(address target, bool freeze) onlyOwner public {\n', '    frozenAccount[target] = freeze;\n', '    emit FrozenFunds(target, freeze);\n', '  }\n', '\n', '\n', '\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a && c >= b);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', 'contract owned { //Contract used to only allow the owner to call some functions\n', '  address public owner;\n', '\n', '  function owned() public {\n', '  owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner {\n', '  require(msg.sender == owner);\n', '  _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '  owner = newOwner;\n', '  }\n', '}\n', '\n', '\n', 'contract TokenERC20 {\n', '\n', 'using SafeMath for uint256;\n', '// Public variables of the token\n', 'string public name;\n', 'string public symbol;\n', 'uint8 public decimals = 18;\n', '//\n', 'uint256 public totalSupply;\n', '\n', '\n', '// This creates an array with all balances\n', 'mapping (address => uint256) public balanceOf;\n', 'mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '// This generates a public event on the blockchain that will notify clients\n', 'event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '// This notifies clients about the amount burnt\n', 'event Burn(address indexed from, uint256 value);\n', '\n', '/**\n', '* Constrctor function\n', '*\n', '* Initializes contract with initial supply tokens to the creator of the contract\n', '*/\n', 'function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {\n', '  totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount\n', '  balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens\n', '  name = tokenName;                                   // Set the name for display purposes\n', '  symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '}\n', '\n', '/**\n', '* Internal transfer, only can be called by this contract\n', '*/\n', 'function _transfer(address _from, address _to, uint _value) internal {\n', '  // Prevent transfer to 0x0 address. Use burn() instead\n', '  require(_to != 0x0);\n', '  // Check for overflows\n', '  // Subtract from the sender\n', '  balanceOf[_from] = balanceOf[_from].sub(_value);\n', '  // Add the same to the recipient\n', '  balanceOf[_to] = balanceOf[_to].add(_value);\n', '  emit Transfer(_from, _to, _value);\n', '}\n', '\n', '/**\n', '* Function to Transfer tokens\n', '*\n', '* Send `_value` tokens to `_to` from your account\n', '*\n', '* @param _to The address of the recipient\n', '* @param _value the amount to send\n', '*/\n', 'function transfer(address _to, uint256 _value) public {\n', '  _transfer(msg.sender, _to, _value);\n', '}\n', '\n', '/**\n', '* function to Transfer tokens from other address\n', '*\n', '* Send `_value` tokens to `_to` in behalf of `_from`\n', '*\n', '* @param _from The address of the sender\n', '* @param _to The address of the recipient\n', '* @param _value the amount to send\n', '*/\n', 'function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '  allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);\n', '  _transfer(_from, _to, _value);\n', '  return true;\n', '}\n', '\n', '/**\n', '* function Set allowance for other address\n', '*\n', '* Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '*\n', '* @param _spender The address authorized to spend\n', '* @param _value the max amount they can spend\n', '*/\n', 'function approve(address _spender, uint256 _value) public returns (bool success) {\n', '  allowance[msg.sender][_spender] = _value;\n', '  return true;\n', '}\n', '\n', '\n', '/**\n', '*Function to Destroy tokens\n', '*\n', '* Remove `_value` tokens from the system irreversibly\n', '*\n', '* @param _value the amount of money to burn\n', '*/\n', 'function burn(uint256 _value) public returns (bool success) {\n', '  balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender\n', '  totalSupply = totalSupply.sub(_value);                      // Updates totalSupply\n', '  emit Burn(msg.sender, _value);\n', '  return true;\n', '}\n', '\n', '\n', '\n', '/**\n', '* Destroy tokens from other ccount\n', '*\n', '* Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '*\n', '* @param _from the address of the sender\n', '* @param _value the amount of money to burn\n', '*/\n', 'function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '  balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance\n', "  allowance[_from][msg.sender] =allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance\n", '  totalSupply = totalSupply.sub(_value);                              // Update totalSupply\n', '  emit Burn(_from, _value);\n', '  return true;\n', '}\n', '\n', '\n', '}\n', '\n', '/******************************************/\n', '/*       Accommodation Coin STARTS HERE       */\n', '/******************************************/\n', '\n', 'contract AccommodationCoin is owned, TokenERC20  {\n', '\n', '  //Modify these variables\n', '  uint256 _initialSupply=100000000; \n', '  string _tokenName="Accommodation Coin";  \n', '  string _tokenSymbol="ACC";\n', '\n', '  mapping (address => bool) public frozenAccount;\n', '\n', '  /* This generates a public event on the blockchain that will notify clients */\n', '  event FrozenFunds(address target, bool frozen);\n', '\n', '  /* Initializes contract with initial supply tokens to the creator of the contract */\n', '  function AccommodationCoin( ) TokenERC20(_initialSupply, _tokenName, _tokenSymbol) public {}\n', '\n', '  /* Internal transfer, only can be called by this contract. */\n', '  function _transfer(address _from, address _to, uint _value) internal {\n', '    require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\n', '    require(!frozenAccount[_from]);                     // Check if sender is frozen\n', '    require(!frozenAccount[_to]);                       // Check if recipient is frozen\n', '    balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender\n', '    balanceOf[_to] = balanceOf[_to].add(_value);                           // Add the same to the recipient\n', '    emit Transfer(_from, _to, _value);\n', '  }\n', '\n', '  /// function to create more coins and send it to `target`\n', '  /// @param target Address to receive the tokens\n', '  /// @param mintedAmount the amount of tokens it will receive\n', '  function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '    balanceOf[target] = balanceOf[target].add(mintedAmount);\n', '    totalSupply = totalSupply.add(mintedAmount);\n', '    emit Transfer(0, this, mintedAmount);\n', '    emit Transfer(this, target, mintedAmount);\n', '  }\n', '\n', '  function freezeAccount(address target, bool freeze) onlyOwner public {\n', '    frozenAccount[target] = freeze;\n', '    emit FrozenFunds(target, freeze);\n', '  }\n', '\n', '\n', '\n', '}']
