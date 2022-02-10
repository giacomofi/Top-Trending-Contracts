['pragma solidity ^0.4.16;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract owned {\n', '  address public owner;\n', '\n', '  function owned() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', 'interface tokenRecipient {\n', '  function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;\n', '}\n', '\n', 'contract Pausable is owned {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS paused\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS NOT paused\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused {\n', '    paused = true;\n', '    Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused {\n', '    paused = false;\n', '    Unpause();\n', '  }\n', '}\n', '\n', '\n', 'contract TokenERC20 is Pausable {\n', '  using SafeMath for uint256;\n', '  // Public variables of the token\n', '  string public name;\n', '  string public symbol;\n', '  uint8 public decimals = 18;\n', '  // 18 decimals is the strongly suggested default, avoid changing it\n', '  uint256 public totalSupply;\n', '  // total no of tokens for sale\n', '  uint256 public TokenForSale;\n', '\n', '  // This creates an array with all balances\n', '  mapping (address => uint256) public balanceOf;\n', '  mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '  // This generates a public event on the blockchain that will notify clients\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '\n', '  /**\n', '   * Constrctor function\n', '   *\n', '   * Initializes contract with initial supply tokens to the creator of the contract\n', '   */\n', '  function TokenERC20(\n', '    uint256 initialSupply,\n', '    string tokenName,\n', '    string tokenSymbol,\n', '    uint256 TokenSale\n', '  ) public {\n', '    totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount\n', '    balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens\n', '    name = tokenName;                                   // Set the name for display purposes\n', '    symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '    TokenForSale =  TokenSale * 10 ** uint256(decimals);\n', '\n', '  }\n', '\n', '  /**\n', '   * Internal transfer, only can be called by this contract\n', '   */\n', '  function _transfer(address _from, address _to, uint _value) internal {\n', '    // Prevent transfer to 0x0 address. Use burn() instead\n', '    require(_to != 0x0);\n', '    // Check if the sender has enough\n', '    require(balanceOf[_from] >= _value);\n', '    // Check for overflows\n', '    require(balanceOf[_to] + _value > balanceOf[_to]);\n', '    // Save this for an assertion in the future\n', '    uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '    // Subtract from the sender\n', '    balanceOf[_from] = balanceOf[_from].sub(_value);\n', '    // Add the same to the recipient\n', '    balanceOf[_to] = balanceOf[_to].add(_value);\n', '    Transfer(_from, _to, _value);\n', '    // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '    assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '  }\n', '\n', '  /**\n', '   * Transfer tokens\n', '   *\n', '   * Send `_value` tokens to `_to` from your account\n', '   *\n', '   * @param _to The address of the recipient\n', '   * @param _value the amount to send\n', '   */\n', '  function transfer(address _to, uint256 _value) public {\n', '    _transfer(msg.sender, _to, _value);\n', '  }\n', '\n', '  /**\n', '   * Transfer tokens from other address\n', '   *\n', '   * Send `_value` tokens to `_to` in behalf of `_from`\n', '   *\n', '   * @param _from The address of the sender\n', '   * @param _to The address of the recipient\n', '   * @param _value the amount to send\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '    require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '    allowance[_from][msg.sender] =  allowance[_from][msg.sender].sub(_value);\n', '    _transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * Set allowance for other address\n', '   *\n', '   * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '   *\n', '   * @param _spender The address authorized to spend\n', '   * @param _value the max amount they can spend\n', '   */\n', '  function approve(address _spender, uint256 _value) public\n', '  returns (bool success) {\n', '    allowance[msg.sender][_spender] = _value;\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * Set allowance for other address and notify\n', '   *\n', '   * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '   *\n', '   * @param _spender The address authorized to spend\n', '   * @param _value the max amount they can spend\n', '   * @param _extraData some extra information to send to the approved contract\n', '   */\n', '  function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '  public\n', '  returns (bool success) {\n', '    tokenRecipient spender = tokenRecipient(_spender);\n', '    if (approve(_spender, _value)) {\n', '      spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '      return true;\n', '    }\n', '  }\n', '}\n', '\n', 'contract Sale is owned, TokenERC20 {\n', '\n', '  // total token which is sold\n', '  uint256 public soldTokens;\n', '\n', '  modifier CheckSaleStatus() {\n', '    require (TokenForSale >= soldTokens);\n', '    _;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract Zigit is TokenERC20, Sale {\n', '  using SafeMath for uint256;\n', '  uint256 public  unitsOneEthCanBuy;\n', '  uint256 public  minPurchaseQty;\n', '\n', '  mapping (address => bool) public airdrops;\n', '\n', '\n', '  /* Initializes contract with initial supply tokens to the creator of the contract */\n', '  function Zigit()\n', '  TokenERC20(1000000000, &#39;Zigit&#39;, &#39;ZGT&#39;, 1000000000) public {\n', '    unitsOneEthCanBuy = 80000;\n', '    soldTokens = 0;\n', '    minPurchaseQty = 16000 * 10 ** uint256(decimals);\n', '  }\n', '\n', '  function changeOwnerWithTokens(address newOwner) onlyOwner public {\n', '    uint previousBalances = balanceOf[owner] + balanceOf[newOwner];\n', '    balanceOf[newOwner] += balanceOf[owner];\n', '    balanceOf[owner] = 0;\n', '    assert(balanceOf[owner] + balanceOf[newOwner] == previousBalances);\n', '    owner = newOwner;\n', '  }\n', '\n', '  function changePrice(uint256 _newAmount) onlyOwner public {\n', '    unitsOneEthCanBuy = _newAmount;\n', '  }\n', '\n', '  function startSale() onlyOwner public {\n', '    soldTokens = 0;\n', '  }\n', '\n', '  function increaseSaleLimit(uint256 TokenSale)  onlyOwner public {\n', '    TokenForSale = TokenSale * 10 ** uint256(decimals);\n', '  }\n', '\n', '  function increaseMinPurchaseQty(uint256 newQty) onlyOwner public {\n', '    minPurchaseQty = newQty * 10 ** uint256(decimals);\n', '  }\n', '\n', '  function airDrop(address[] _recipient, uint _totalTokensToDistribute) onlyOwner public {\n', '    uint256 total_token_to_transfer = (_totalTokensToDistribute * 10 ** uint256(decimals)).mul(_recipient.length);\n', '    require(balanceOf[owner] >=  total_token_to_transfer);\n', '    for(uint256 i = 0; i< _recipient.length; i++)\n', '    {\n', '      if (!airdrops[_recipient[i]]) {\n', '        airdrops[_recipient[i]] = true;\n', '        _transfer(owner, _recipient[i], _totalTokensToDistribute * 10 ** uint256(decimals));\n', '      }\n', '    }\n', '  }\n', '  function() public payable whenNotPaused CheckSaleStatus {\n', '    uint256 eth_amount = msg.value;\n', '    uint256 amount = eth_amount.mul(unitsOneEthCanBuy);\n', '    soldTokens = soldTokens.add(amount);\n', '    require(amount >= minPurchaseQty );\n', '    require(balanceOf[owner] >= amount );\n', '    _transfer(owner, msg.sender, amount);\n', '    //Transfer ether to fundsWallet\n', '    owner.transfer(msg.value);\n', '  }\n', '}']
['pragma solidity ^0.4.16;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract owned {\n', '  address public owner;\n', '\n', '  function owned() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', 'interface tokenRecipient {\n', '  function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;\n', '}\n', '\n', 'contract Pausable is owned {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS paused\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS NOT paused\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused {\n', '    paused = true;\n', '    Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused {\n', '    paused = false;\n', '    Unpause();\n', '  }\n', '}\n', '\n', '\n', 'contract TokenERC20 is Pausable {\n', '  using SafeMath for uint256;\n', '  // Public variables of the token\n', '  string public name;\n', '  string public symbol;\n', '  uint8 public decimals = 18;\n', '  // 18 decimals is the strongly suggested default, avoid changing it\n', '  uint256 public totalSupply;\n', '  // total no of tokens for sale\n', '  uint256 public TokenForSale;\n', '\n', '  // This creates an array with all balances\n', '  mapping (address => uint256) public balanceOf;\n', '  mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '  // This generates a public event on the blockchain that will notify clients\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '\n', '  /**\n', '   * Constrctor function\n', '   *\n', '   * Initializes contract with initial supply tokens to the creator of the contract\n', '   */\n', '  function TokenERC20(\n', '    uint256 initialSupply,\n', '    string tokenName,\n', '    string tokenSymbol,\n', '    uint256 TokenSale\n', '  ) public {\n', '    totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount\n', '    balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens\n', '    name = tokenName;                                   // Set the name for display purposes\n', '    symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '    TokenForSale =  TokenSale * 10 ** uint256(decimals);\n', '\n', '  }\n', '\n', '  /**\n', '   * Internal transfer, only can be called by this contract\n', '   */\n', '  function _transfer(address _from, address _to, uint _value) internal {\n', '    // Prevent transfer to 0x0 address. Use burn() instead\n', '    require(_to != 0x0);\n', '    // Check if the sender has enough\n', '    require(balanceOf[_from] >= _value);\n', '    // Check for overflows\n', '    require(balanceOf[_to] + _value > balanceOf[_to]);\n', '    // Save this for an assertion in the future\n', '    uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '    // Subtract from the sender\n', '    balanceOf[_from] = balanceOf[_from].sub(_value);\n', '    // Add the same to the recipient\n', '    balanceOf[_to] = balanceOf[_to].add(_value);\n', '    Transfer(_from, _to, _value);\n', '    // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '    assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '  }\n', '\n', '  /**\n', '   * Transfer tokens\n', '   *\n', '   * Send `_value` tokens to `_to` from your account\n', '   *\n', '   * @param _to The address of the recipient\n', '   * @param _value the amount to send\n', '   */\n', '  function transfer(address _to, uint256 _value) public {\n', '    _transfer(msg.sender, _to, _value);\n', '  }\n', '\n', '  /**\n', '   * Transfer tokens from other address\n', '   *\n', '   * Send `_value` tokens to `_to` in behalf of `_from`\n', '   *\n', '   * @param _from The address of the sender\n', '   * @param _to The address of the recipient\n', '   * @param _value the amount to send\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '    require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '    allowance[_from][msg.sender] =  allowance[_from][msg.sender].sub(_value);\n', '    _transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * Set allowance for other address\n', '   *\n', '   * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '   *\n', '   * @param _spender The address authorized to spend\n', '   * @param _value the max amount they can spend\n', '   */\n', '  function approve(address _spender, uint256 _value) public\n', '  returns (bool success) {\n', '    allowance[msg.sender][_spender] = _value;\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * Set allowance for other address and notify\n', '   *\n', '   * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '   *\n', '   * @param _spender The address authorized to spend\n', '   * @param _value the max amount they can spend\n', '   * @param _extraData some extra information to send to the approved contract\n', '   */\n', '  function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '  public\n', '  returns (bool success) {\n', '    tokenRecipient spender = tokenRecipient(_spender);\n', '    if (approve(_spender, _value)) {\n', '      spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '      return true;\n', '    }\n', '  }\n', '}\n', '\n', 'contract Sale is owned, TokenERC20 {\n', '\n', '  // total token which is sold\n', '  uint256 public soldTokens;\n', '\n', '  modifier CheckSaleStatus() {\n', '    require (TokenForSale >= soldTokens);\n', '    _;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract Zigit is TokenERC20, Sale {\n', '  using SafeMath for uint256;\n', '  uint256 public  unitsOneEthCanBuy;\n', '  uint256 public  minPurchaseQty;\n', '\n', '  mapping (address => bool) public airdrops;\n', '\n', '\n', '  /* Initializes contract with initial supply tokens to the creator of the contract */\n', '  function Zigit()\n', "  TokenERC20(1000000000, 'Zigit', 'ZGT', 1000000000) public {\n", '    unitsOneEthCanBuy = 80000;\n', '    soldTokens = 0;\n', '    minPurchaseQty = 16000 * 10 ** uint256(decimals);\n', '  }\n', '\n', '  function changeOwnerWithTokens(address newOwner) onlyOwner public {\n', '    uint previousBalances = balanceOf[owner] + balanceOf[newOwner];\n', '    balanceOf[newOwner] += balanceOf[owner];\n', '    balanceOf[owner] = 0;\n', '    assert(balanceOf[owner] + balanceOf[newOwner] == previousBalances);\n', '    owner = newOwner;\n', '  }\n', '\n', '  function changePrice(uint256 _newAmount) onlyOwner public {\n', '    unitsOneEthCanBuy = _newAmount;\n', '  }\n', '\n', '  function startSale() onlyOwner public {\n', '    soldTokens = 0;\n', '  }\n', '\n', '  function increaseSaleLimit(uint256 TokenSale)  onlyOwner public {\n', '    TokenForSale = TokenSale * 10 ** uint256(decimals);\n', '  }\n', '\n', '  function increaseMinPurchaseQty(uint256 newQty) onlyOwner public {\n', '    minPurchaseQty = newQty * 10 ** uint256(decimals);\n', '  }\n', '\n', '  function airDrop(address[] _recipient, uint _totalTokensToDistribute) onlyOwner public {\n', '    uint256 total_token_to_transfer = (_totalTokensToDistribute * 10 ** uint256(decimals)).mul(_recipient.length);\n', '    require(balanceOf[owner] >=  total_token_to_transfer);\n', '    for(uint256 i = 0; i< _recipient.length; i++)\n', '    {\n', '      if (!airdrops[_recipient[i]]) {\n', '        airdrops[_recipient[i]] = true;\n', '        _transfer(owner, _recipient[i], _totalTokensToDistribute * 10 ** uint256(decimals));\n', '      }\n', '    }\n', '  }\n', '  function() public payable whenNotPaused CheckSaleStatus {\n', '    uint256 eth_amount = msg.value;\n', '    uint256 amount = eth_amount.mul(unitsOneEthCanBuy);\n', '    soldTokens = soldTokens.add(amount);\n', '    require(amount >= minPurchaseQty );\n', '    require(balanceOf[owner] >= amount );\n', '    _transfer(owner, msg.sender, amount);\n', '    //Transfer ether to fundsWallet\n', '    owner.transfer(msg.value);\n', '  }\n', '}']
