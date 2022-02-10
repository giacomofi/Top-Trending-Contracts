['pragma solidity ^0.4.21;\n', '\n', '/*\n', ' * Abstract Token Smart Contract.  Copyright &#169; 2017 by Grab A Meal.\n', ' * Author: <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="a8cbc7c6dcc9cbdce8cfdac9cac9c5cdc9c486dfc7dac4cc">[email&#160;protected]</a>\n', ' */\n', '\n', ' \n', ' /*\n', ' * Safe Math Smart Contract.  Copyright &#169; 2017 by Grab A Meal.\n', ' * Author: <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="fe9d91908a9f9d8abe998c9f9c9f939b9f92d089918c929a">[email&#160;protected]</a>\n', ' * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol\n', ' */\n', '\n', 'contract SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * ERC-20 standard token interface, as defined\n', ' * <a href="http://github.com/ethereum/EIPs/issues/20">here</a>.\n', ' */\n', 'contract Token {\n', '  \n', '  function totalSupply() constant returns (uint256 supply);\n', '  function balanceOf(address _owner) constant returns (uint256 balance);\n', '  function transfer(address _to, uint256 _value) returns (bool success);\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '  function approve(address _spender, uint256 _value) returns (bool success);\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * Abstract Token Smart Contract that could be used as a base contract for\n', ' * ERC-20 token contracts.\n', ' */\n', 'contract AbstractToken is Token, SafeMath {\n', '  /**\n', '   * Create new Abstract Token contract.\n', '   */\n', '  function AbstractToken () {\n', '    // Do nothing\n', '  }\n', '  \n', '  /**\n', '   * Get number of tokens currently belonging to given owner.\n', '   *\n', '   * @param _owner address to get number of tokens currently belonging to the\n', '   *        owner of\n', '   * @return number of tokens currently belonging to the owner of given address\n', '   */\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return accounts [_owner];\n', '  }\n', '\n', '  /**\n', '   * Transfer given number of tokens from message sender to given recipient.\n', '   *\n', '   * @param _to address to transfer tokens to the owner of\n', '   * @param _value number of tokens to transfer to the owner of given address\n', '   * @return true if tokens were transferred successfully, false otherwise\n', '   * accounts [_to] + _value > accounts [_to] for overflow check\n', '   * which is already in safeMath\n', '   */\n', '  function transfer(address _to, uint256 _value) returns (bool success) {\n', '    require(_to != address(0));\n', '    if (accounts [msg.sender] < _value) return false;\n', '    if (_value > 0 && msg.sender != _to) {\n', '      accounts [msg.sender] = safeSub (accounts [msg.sender], _value);\n', '      accounts [_to] = safeAdd (accounts [_to], _value);\n', '    }\n', '    Transfer (msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * Transfer given number of tokens from given owner to given recipient.\n', '   *\n', '   * @param _from address to transfer tokens from the owner of\n', '   * @param _to address to transfer tokens to the owner of\n', '   * @param _value number of tokens to transfer from given owner to given\n', '   *        recipient\n', '   * @return true if tokens were transferred successfully, false otherwise\n', '   * accounts [_to] + _value > accounts [_to] for overflow check\n', '   * which is already in safeMath\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value)\n', '  returns (bool success) {\n', '    require(_to != address(0));\n', '    if (allowances [_from][msg.sender] < _value) return false;\n', '    if (accounts [_from] < _value) return false; \n', '\n', '    if (_value > 0 && _from != _to) {\n', '\t  allowances [_from][msg.sender] = safeSub (allowances [_from][msg.sender], _value);\n', '      accounts [_from] = safeSub (accounts [_from], _value);\n', '      accounts [_to] = safeAdd (accounts [_to], _value);\n', '    }\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * Allow given spender to transfer given number of tokens from message sender.\n', '   * @param _spender address to allow the owner of to transfer tokens from message sender\n', '   * @param _value number of tokens to allow to transfer\n', '   * @return true if token transfer was successfully approved, false otherwise\n', '   */\n', '   function approve (address _spender, uint256 _value) returns (bool success) {\n', '    allowances [msg.sender][_spender] = _value;\n', '    Approval (msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * Tell how many tokens given spender is currently allowed to transfer from\n', '   * given owner.\n', '   *\n', '   * @param _owner address to get number of tokens allowed to be transferred\n', '   *        from the owner of\n', '   * @param _spender address to get number of tokens allowed to be transferred\n', '   *        by the owner of\n', '   * @return number of tokens given spender is currently allowed to transfer\n', '   *         from given owner\n', '   */\n', '  function allowance(address _owner, address _spender) constant\n', '  returns (uint256 remaining) {\n', '    return allowances [_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * Mapping from addresses of token holders to the numbers of tokens belonging\n', '   * to these token holders.\n', '   */\n', '  mapping (address => uint256) accounts;\n', '\n', '  /**\n', '   * Mapping from addresses of token holders to the mapping of addresses of\n', '   * spenders to the allowances set by these token holders to these spenders.\n', '   */\n', '  mapping (address => mapping (address => uint256)) private allowances;\n', '}\n', '\n', '\n', '/**\n', ' * GAM token smart contract.\n', ' */\n', 'contract GAMToken is AbstractToken {\n', '  /**\n', '   * Maximum allowed number of tokens in circulation.\n', '   * Total Supply 2000000000 GAM Tokens\n', '   * 10^^10 is done for decimal places, this is standard practice as all ethers are actually wei in EVM\n', '   */\n', '   \n', '   \n', '  uint256 constant MAX_TOKEN_COUNT = 2000000000 * (10**10);\n', '   \n', '  /**\n', '   * Address of the owner of this smart contract.\n', '   */\n', '  address private owner;\n', '\n', '  /**\n', '   * Current number of tokens in circulation.\n', '   */\n', '  uint256 tokenCount = 0;\n', '  \n', ' \n', '  /**\n', '   * True if tokens transfers are currently frozen, false otherwise.\n', '   */\n', '  bool frozen = false;\n', '  \n', '  \n', '  /**\n', '   * Create new GAM token smart contract and make msg.sender the\n', '   * owner of this smart contract.\n', '   */\n', '  function GAMToken () {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * Get total number of tokens in circulation.\n', '   *\n', '   * @return total number of tokens in circulation\n', '   */\n', '  function totalSupply() constant returns (uint256 supply) {\n', '    return tokenCount;\n', '  }\n', '\n', '  string constant public name = "Grab A Meal Token";\n', '  string constant public symbol = "GAM";\n', '  uint8 constant public decimals = 10;\n', '  \n', '  /**\n', '   * Transfer given number of tokens from message sender to given recipient.\n', '   *\n', '   * @param _to address to transfer tokens to the owner of\n', '   * @param _value number of tokens to transfer to the owner of given address\n', '   * @return true if tokens were transferred successfully, false otherwise\n', '   */\n', '  function transfer(address _to, uint256 _value) returns (bool success) {\n', '    if (frozen) return false;\n', '    else return AbstractToken.transfer (_to, _value);\n', '  }\n', '\n', '  /**\n', '   * Transfer given number of tokens from given owner to given recipient.\n', '   *\n', '   * @param _from address to transfer tokens from the owner of\n', '   * @param _to address to transfer tokens to the owner of\n', '   * @param _value number of tokens to transfer from given owner to given\n', '   *        recipient\n', '   * @return true if tokens were transferred successfully, false otherwise\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value)\n', '    returns (bool success) {\n', '    if (frozen) return false;\n', '    else return AbstractToken.transferFrom (_from, _to, _value);\n', '  }\n', '\n', '   /**\n', '   * Change how many tokens given spender is allowed to transfer from message\n', '   * spender.  In order to prevent double spending of allowance,\n', '   * To change the approve amount you first have to reduce the addresses`\n', '   * allowance to zero by calling `approve(_spender, 0)` if it is not\n', '   * already 0 to mitigate the race condition described here:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender address to allow the owner of to transfer tokens from\n', '   *        message sender\n', '   * @param _value number of tokens to allow to transfer\n', '   * @return true if token transfer was successfully approved, false otherwise\n', '   */\n', '  function approve (address _spender, uint256 _value)\n', '    returns (bool success) {\n', '\trequire(allowance (msg.sender, _spender) == 0 || _value == 0);\n', '    return AbstractToken.approve (_spender, _value);\n', '  }\n', '\n', '  /**\n', '   * Create _value new tokens and give new created tokens to msg.sender.\n', '   * May only be called by smart contract owner.\n', '   *\n', '   * @param _value number of tokens to create\n', '   * @return true if tokens were created successfully, false otherwise\n', '   */\n', '  function createTokens(uint256 _value)\n', '    returns (bool success) {\n', '    require (msg.sender == owner);\n', '\n', '    if (_value > 0) {\n', '      if (_value > safeSub (MAX_TOKEN_COUNT, tokenCount)) return false;\n', '\t  \n', '      accounts [msg.sender] = safeAdd (accounts [msg.sender], _value);\n', '      tokenCount = safeAdd (tokenCount, _value);\n', '      \n', '\t  \n', '\t  // adding transfer event and _from address as null address\n', '\t  Transfer(0x0, msg.sender, _value);\n', '\t  \n', '\t  return true;\n', '    }\n', '\t\n', '\t  return false;\n', '    \n', '  }\n', '  \n', '  \n', '  /**\n', '   * For future use only whne we will need more tokens for our main application\n', '   * Create mintedAmount new tokens and give new created tokens to target.\n', '   * May only be called by smart contract owner.\n', '   * @param mintedAmount number of tokens to create\n', '   * @return true if tokens were created successfully, false otherwise\n', '   */\n', '  \n', '  function mintToken(address target, uint256 mintedAmount) \n', '  returns (bool success) {\n', '    require (msg.sender == owner);\n', '      if (mintedAmount > 0) {\n', '\t  \n', '      accounts [target] = safeAdd (accounts [target], mintedAmount);\n', '      tokenCount = safeAdd (tokenCount, mintedAmount);\n', '\t  \n', '\t  // adding transfer event and _from address as null address\n', '\t  Transfer(0x0, target, mintedAmount);\n', '\t  \n', '\t   return true;\n', '    }\n', '\t  return false;\n', '   \n', '    }\n', '\n', '  /**\n', '   * Set new owner for the smart contract.\n', '   * May only be called by smart contract owner.\n', '   *\n', '   * @param _newOwner address of new owner of the smart contract\n', '   */\n', '  function setOwner(address _newOwner) {\n', '    require (msg.sender == owner);\n', '\n', '    owner = _newOwner;\n', '  }\n', '\n', '  /**\n', '   * Freeze token transfers.\n', '   * May only be called by smart contract owner.\n', '   */\n', '  function freezeTransfers () {\n', '    require (msg.sender == owner);\n', '\n', '    if (!frozen) {\n', '      frozen = true;\n', '      Freeze ();\n', '    }\n', '  }\n', '\n', '  /**\n', '   * Unfreeze token transfers.\n', '   * May only be called by smart contract owner.\n', '   */\n', '  function unfreezeTransfers () {\n', '    require (msg.sender == owner);\n', '\n', '    if (frozen) {\n', '      frozen = false;\n', '      Unfreeze ();\n', '    }\n', '  }\n', '  \n', '  /*A user is able to unintentionally send tokens to a contract \n', '  * and if the contract is not prepared to refund them they will get stuck in the contract. \n', '  * The same issue used to happen for Ether too but new Solidity versions added the payable modifier to\n', '  * prevent unintended Ether transfers. However, there’s no such mechanism for token transfers.\n', '  * so the below function is created\n', '  */\n', '  \n', '  function refundTokens(address _token, address _refund, uint256 _value) {\n', '    require (msg.sender == owner);\n', '    require(_token != address(this));\n', '    AbstractToken token = AbstractToken(_token);\n', '    token.transfer(_refund, _value);\n', '    RefundTokens(_token, _refund, _value);\n', '  }\n', '\n', '  /**\n', '   * Logged when token transfers were frozen.\n', '   */\n', '  event Freeze ();\n', '\n', '  /**\n', '   * Logged when token transfers were unfrozen.\n', '   */\n', '  event Unfreeze ();\n', '  \n', '  /**\n', '   * when accidentally send other tokens are refunded\n', '   */\n', '  \n', '  event RefundTokens(address _token, address _refund, uint256 _value);\n', '}']
['pragma solidity ^0.4.21;\n', '\n', '/*\n', ' * Abstract Token Smart Contract.  Copyright © 2017 by Grab A Meal.\n', ' * Author: contact@grabameal.world\n', ' */\n', '\n', ' \n', ' /*\n', ' * Safe Math Smart Contract.  Copyright © 2017 by Grab A Meal.\n', ' * Author: contact@grabameal.world\n', ' * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol\n', ' */\n', '\n', 'contract SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * ERC-20 standard token interface, as defined\n', ' * <a href="http://github.com/ethereum/EIPs/issues/20">here</a>.\n', ' */\n', 'contract Token {\n', '  \n', '  function totalSupply() constant returns (uint256 supply);\n', '  function balanceOf(address _owner) constant returns (uint256 balance);\n', '  function transfer(address _to, uint256 _value) returns (bool success);\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '  function approve(address _spender, uint256 _value) returns (bool success);\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * Abstract Token Smart Contract that could be used as a base contract for\n', ' * ERC-20 token contracts.\n', ' */\n', 'contract AbstractToken is Token, SafeMath {\n', '  /**\n', '   * Create new Abstract Token contract.\n', '   */\n', '  function AbstractToken () {\n', '    // Do nothing\n', '  }\n', '  \n', '  /**\n', '   * Get number of tokens currently belonging to given owner.\n', '   *\n', '   * @param _owner address to get number of tokens currently belonging to the\n', '   *        owner of\n', '   * @return number of tokens currently belonging to the owner of given address\n', '   */\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return accounts [_owner];\n', '  }\n', '\n', '  /**\n', '   * Transfer given number of tokens from message sender to given recipient.\n', '   *\n', '   * @param _to address to transfer tokens to the owner of\n', '   * @param _value number of tokens to transfer to the owner of given address\n', '   * @return true if tokens were transferred successfully, false otherwise\n', '   * accounts [_to] + _value > accounts [_to] for overflow check\n', '   * which is already in safeMath\n', '   */\n', '  function transfer(address _to, uint256 _value) returns (bool success) {\n', '    require(_to != address(0));\n', '    if (accounts [msg.sender] < _value) return false;\n', '    if (_value > 0 && msg.sender != _to) {\n', '      accounts [msg.sender] = safeSub (accounts [msg.sender], _value);\n', '      accounts [_to] = safeAdd (accounts [_to], _value);\n', '    }\n', '    Transfer (msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * Transfer given number of tokens from given owner to given recipient.\n', '   *\n', '   * @param _from address to transfer tokens from the owner of\n', '   * @param _to address to transfer tokens to the owner of\n', '   * @param _value number of tokens to transfer from given owner to given\n', '   *        recipient\n', '   * @return true if tokens were transferred successfully, false otherwise\n', '   * accounts [_to] + _value > accounts [_to] for overflow check\n', '   * which is already in safeMath\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value)\n', '  returns (bool success) {\n', '    require(_to != address(0));\n', '    if (allowances [_from][msg.sender] < _value) return false;\n', '    if (accounts [_from] < _value) return false; \n', '\n', '    if (_value > 0 && _from != _to) {\n', '\t  allowances [_from][msg.sender] = safeSub (allowances [_from][msg.sender], _value);\n', '      accounts [_from] = safeSub (accounts [_from], _value);\n', '      accounts [_to] = safeAdd (accounts [_to], _value);\n', '    }\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * Allow given spender to transfer given number of tokens from message sender.\n', '   * @param _spender address to allow the owner of to transfer tokens from message sender\n', '   * @param _value number of tokens to allow to transfer\n', '   * @return true if token transfer was successfully approved, false otherwise\n', '   */\n', '   function approve (address _spender, uint256 _value) returns (bool success) {\n', '    allowances [msg.sender][_spender] = _value;\n', '    Approval (msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * Tell how many tokens given spender is currently allowed to transfer from\n', '   * given owner.\n', '   *\n', '   * @param _owner address to get number of tokens allowed to be transferred\n', '   *        from the owner of\n', '   * @param _spender address to get number of tokens allowed to be transferred\n', '   *        by the owner of\n', '   * @return number of tokens given spender is currently allowed to transfer\n', '   *         from given owner\n', '   */\n', '  function allowance(address _owner, address _spender) constant\n', '  returns (uint256 remaining) {\n', '    return allowances [_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * Mapping from addresses of token holders to the numbers of tokens belonging\n', '   * to these token holders.\n', '   */\n', '  mapping (address => uint256) accounts;\n', '\n', '  /**\n', '   * Mapping from addresses of token holders to the mapping of addresses of\n', '   * spenders to the allowances set by these token holders to these spenders.\n', '   */\n', '  mapping (address => mapping (address => uint256)) private allowances;\n', '}\n', '\n', '\n', '/**\n', ' * GAM token smart contract.\n', ' */\n', 'contract GAMToken is AbstractToken {\n', '  /**\n', '   * Maximum allowed number of tokens in circulation.\n', '   * Total Supply 2000000000 GAM Tokens\n', '   * 10^^10 is done for decimal places, this is standard practice as all ethers are actually wei in EVM\n', '   */\n', '   \n', '   \n', '  uint256 constant MAX_TOKEN_COUNT = 2000000000 * (10**10);\n', '   \n', '  /**\n', '   * Address of the owner of this smart contract.\n', '   */\n', '  address private owner;\n', '\n', '  /**\n', '   * Current number of tokens in circulation.\n', '   */\n', '  uint256 tokenCount = 0;\n', '  \n', ' \n', '  /**\n', '   * True if tokens transfers are currently frozen, false otherwise.\n', '   */\n', '  bool frozen = false;\n', '  \n', '  \n', '  /**\n', '   * Create new GAM token smart contract and make msg.sender the\n', '   * owner of this smart contract.\n', '   */\n', '  function GAMToken () {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * Get total number of tokens in circulation.\n', '   *\n', '   * @return total number of tokens in circulation\n', '   */\n', '  function totalSupply() constant returns (uint256 supply) {\n', '    return tokenCount;\n', '  }\n', '\n', '  string constant public name = "Grab A Meal Token";\n', '  string constant public symbol = "GAM";\n', '  uint8 constant public decimals = 10;\n', '  \n', '  /**\n', '   * Transfer given number of tokens from message sender to given recipient.\n', '   *\n', '   * @param _to address to transfer tokens to the owner of\n', '   * @param _value number of tokens to transfer to the owner of given address\n', '   * @return true if tokens were transferred successfully, false otherwise\n', '   */\n', '  function transfer(address _to, uint256 _value) returns (bool success) {\n', '    if (frozen) return false;\n', '    else return AbstractToken.transfer (_to, _value);\n', '  }\n', '\n', '  /**\n', '   * Transfer given number of tokens from given owner to given recipient.\n', '   *\n', '   * @param _from address to transfer tokens from the owner of\n', '   * @param _to address to transfer tokens to the owner of\n', '   * @param _value number of tokens to transfer from given owner to given\n', '   *        recipient\n', '   * @return true if tokens were transferred successfully, false otherwise\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value)\n', '    returns (bool success) {\n', '    if (frozen) return false;\n', '    else return AbstractToken.transferFrom (_from, _to, _value);\n', '  }\n', '\n', '   /**\n', '   * Change how many tokens given spender is allowed to transfer from message\n', '   * spender.  In order to prevent double spending of allowance,\n', '   * To change the approve amount you first have to reduce the addresses`\n', '   * allowance to zero by calling `approve(_spender, 0)` if it is not\n', '   * already 0 to mitigate the race condition described here:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender address to allow the owner of to transfer tokens from\n', '   *        message sender\n', '   * @param _value number of tokens to allow to transfer\n', '   * @return true if token transfer was successfully approved, false otherwise\n', '   */\n', '  function approve (address _spender, uint256 _value)\n', '    returns (bool success) {\n', '\trequire(allowance (msg.sender, _spender) == 0 || _value == 0);\n', '    return AbstractToken.approve (_spender, _value);\n', '  }\n', '\n', '  /**\n', '   * Create _value new tokens and give new created tokens to msg.sender.\n', '   * May only be called by smart contract owner.\n', '   *\n', '   * @param _value number of tokens to create\n', '   * @return true if tokens were created successfully, false otherwise\n', '   */\n', '  function createTokens(uint256 _value)\n', '    returns (bool success) {\n', '    require (msg.sender == owner);\n', '\n', '    if (_value > 0) {\n', '      if (_value > safeSub (MAX_TOKEN_COUNT, tokenCount)) return false;\n', '\t  \n', '      accounts [msg.sender] = safeAdd (accounts [msg.sender], _value);\n', '      tokenCount = safeAdd (tokenCount, _value);\n', '      \n', '\t  \n', '\t  // adding transfer event and _from address as null address\n', '\t  Transfer(0x0, msg.sender, _value);\n', '\t  \n', '\t  return true;\n', '    }\n', '\t\n', '\t  return false;\n', '    \n', '  }\n', '  \n', '  \n', '  /**\n', '   * For future use only whne we will need more tokens for our main application\n', '   * Create mintedAmount new tokens and give new created tokens to target.\n', '   * May only be called by smart contract owner.\n', '   * @param mintedAmount number of tokens to create\n', '   * @return true if tokens were created successfully, false otherwise\n', '   */\n', '  \n', '  function mintToken(address target, uint256 mintedAmount) \n', '  returns (bool success) {\n', '    require (msg.sender == owner);\n', '      if (mintedAmount > 0) {\n', '\t  \n', '      accounts [target] = safeAdd (accounts [target], mintedAmount);\n', '      tokenCount = safeAdd (tokenCount, mintedAmount);\n', '\t  \n', '\t  // adding transfer event and _from address as null address\n', '\t  Transfer(0x0, target, mintedAmount);\n', '\t  \n', '\t   return true;\n', '    }\n', '\t  return false;\n', '   \n', '    }\n', '\n', '  /**\n', '   * Set new owner for the smart contract.\n', '   * May only be called by smart contract owner.\n', '   *\n', '   * @param _newOwner address of new owner of the smart contract\n', '   */\n', '  function setOwner(address _newOwner) {\n', '    require (msg.sender == owner);\n', '\n', '    owner = _newOwner;\n', '  }\n', '\n', '  /**\n', '   * Freeze token transfers.\n', '   * May only be called by smart contract owner.\n', '   */\n', '  function freezeTransfers () {\n', '    require (msg.sender == owner);\n', '\n', '    if (!frozen) {\n', '      frozen = true;\n', '      Freeze ();\n', '    }\n', '  }\n', '\n', '  /**\n', '   * Unfreeze token transfers.\n', '   * May only be called by smart contract owner.\n', '   */\n', '  function unfreezeTransfers () {\n', '    require (msg.sender == owner);\n', '\n', '    if (frozen) {\n', '      frozen = false;\n', '      Unfreeze ();\n', '    }\n', '  }\n', '  \n', '  /*A user is able to unintentionally send tokens to a contract \n', '  * and if the contract is not prepared to refund them they will get stuck in the contract. \n', '  * The same issue used to happen for Ether too but new Solidity versions added the payable modifier to\n', '  * prevent unintended Ether transfers. However, there’s no such mechanism for token transfers.\n', '  * so the below function is created\n', '  */\n', '  \n', '  function refundTokens(address _token, address _refund, uint256 _value) {\n', '    require (msg.sender == owner);\n', '    require(_token != address(this));\n', '    AbstractToken token = AbstractToken(_token);\n', '    token.transfer(_refund, _value);\n', '    RefundTokens(_token, _refund, _value);\n', '  }\n', '\n', '  /**\n', '   * Logged when token transfers were frozen.\n', '   */\n', '  event Freeze ();\n', '\n', '  /**\n', '   * Logged when token transfers were unfrozen.\n', '   */\n', '  event Unfreeze ();\n', '  \n', '  /**\n', '   * when accidentally send other tokens are refunded\n', '   */\n', '  \n', '  event RefundTokens(address _token, address _refund, uint256 _value);\n', '}']
