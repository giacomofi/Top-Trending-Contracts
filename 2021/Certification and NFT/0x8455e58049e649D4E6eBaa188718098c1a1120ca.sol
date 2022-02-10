['/**\n', ' *Submitted for verification at Etherscan.io on 2021-07-14\n', '*/\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'interface Token {\n', '  /**\n', '   * Get total number of tokens in circulation.\n', '   *\n', '   * @return supply total number of tokens in circulation\n', '   */\n', '  function totalSupply () external view returns (uint256 supply);\n', '\n', '  /**\n', '   * Get number of tokens currently belonging to given owner.\n', '   *\n', '   * @param _owner address to get number of tokens currently belonging to the\n', '   *        owner of\n', '   * @return balance number of tokens currently belonging to the owner of given address\n', '   */\n', '  function balanceOf (address _owner) external view returns (uint256 balance);\n', '\n', '  /**\n', '   * Transfer given number of tokens from message sender to given recipient.\n', '   *\n', '   * @param _to address to transfer tokens to the owner of\n', '   * @param _value number of tokens to transfer to the owner of given address\n', '   * @return success true if tokens were transferred successfully, false otherwise\n', '   */\n', '  function transfer (address _to, uint256 _value)\n', '  external returns (bool success);\n', '\n', '  /**\n', '   * Transfer given number of tokens from given owner to given recipient.\n', '   *\n', '   * @param _from address to transfer tokens from the owner of\n', '   * @param _to address to transfer tokens to the owner of\n', '   * @param _value number of tokens to transfer from given owner to given\n', '   *        recipient\n', '   * @return success true if tokens were transferred successfully, false otherwise\n', '   */\n', '  function transferFrom (address _from, address _to, uint256 _value)\n', '  external returns (bool success);\n', '\n', '  /**\n', '   * Allow given spender to transfer given number of tokens from message sender.\n', '   *\n', '   * @param _spender address to allow the owner of to transfer tokens from\n', '   *        message sender\n', '   * @param _value number of tokens to allow to transfer\n', '   * @return success true if token transfer was successfully approved, false otherwise\n', '   */\n', '  function approve (address _spender, uint256 _value)\n', '  external returns (bool success);\n', '\n', '  /**\n', '   * Tell how many tokens given spender is currently allowed to transfer from\n', '   * given owner.\n', '   *\n', '   * @param _owner address to get number of tokens allowed to be transferred\n', '   *        from the owner of\n', '   * @param _spender address to get number of tokens allowed to be transferred\n', '   *        by the owner of\n', '   * @return remaining number of tokens given spender is currently allowed to transfer\n', '   *         from given owner\n', '   */\n', '  function allowance (address _owner, address _spender)\n', '  external view returns (uint256 remaining);\n', '\n', '  /**\n', '   * Logged when tokens were transferred from one owner to another.\n', '   *\n', '   * @param _from address of the owner, tokens were transferred from\n', '   * @param _to address of the owner, tokens were transferred to\n', '   * @param _value number of tokens transferred\n', '   */\n', '  event Transfer (address indexed _from, address indexed _to, uint256 _value);\n', '\n', '  /**\n', '   * Logged when owner approved his tokens to be transferred by some spender.\n', '   *\n', '   * @param _owner owner who approved his tokens to be transferred\n', '   * @param _spender spender who were allowed to transfer the tokens belonging\n', '   *        to the owner\n', '   * @param _value number of tokens belonging to the owner, approved to be\n', '   *        transferred by the spender\n', '   */\n', '  event Approval (\n', '    address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', '/**\n', ' * Abstract Token Smart Contract that could be used as a base contract for\n', ' * ERC-20 token contracts.\n', ' */\n', 'abstract contract AbstractToken is Token {\n', '  /**\n', '   * Create new Abstract Token contract.\n', '   */\n', '  constructor () {\n', '    // Do nothing\n', '  }\n', '\n', '  /**\n', '   * Get number of tokens currently belonging to given owner.\n', '   *\n', '   * @param _owner address to get number of tokens currently belonging to the\n', '   *        owner of\n', '   * @return balance number of tokens currently belonging to the owner of given address\n', '   */\n', '  function balanceOf (address _owner) public override virtual view returns (uint256 balance) {\n', '    return accounts [_owner];\n', '  }\n', '\n', '  /**\n', '   * Transfer given number of tokens from message sender to given recipient.\n', '   *\n', '   * @param _to address to transfer tokens to the owner of\n', '   * @param _value number of tokens to transfer to the owner of given address\n', '   * @return success true if tokens were transferred successfully, false otherwise\n', '   */\n', '  function transfer (address _to, uint256 _value)\n', '  public override virtual returns (bool success) {\n', '    uint256 fromBalance = accounts [msg.sender];\n', '    if (fromBalance < _value) return false;\n', '    if (_value > 0 && msg.sender != _to) {\n', '      accounts [msg.sender] = fromBalance - _value;\n', '      accounts [_to] = accounts [_to] + _value;\n', '    }\n', '    emit Transfer (msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * Transfer given number of tokens from given owner to given recipient.\n', '   *\n', '   * @param _from address to transfer tokens from the owner of\n', '   * @param _to address to transfer tokens to the owner of\n', '   * @param _value number of tokens to transfer from given owner to given\n', '   *        recipient\n', '   * @return success true if tokens were transferred successfully, false otherwise\n', '   */\n', '  function transferFrom (address _from, address _to, uint256 _value)\n', '  public override virtual returns (bool success) {\n', '    uint256 spenderAllowance = allowances [_from][msg.sender];\n', '    if (spenderAllowance < _value) return false;\n', '    uint256 fromBalance = accounts [_from];\n', '    if (fromBalance < _value) return false;\n', '\n', '    allowances [_from][msg.sender] =\n', '      spenderAllowance - _value;\n', '\n', '    if (_value > 0 && _from != _to) {\n', '      accounts [_from] = fromBalance - _value;\n', '      accounts [_to] = accounts [_to] + _value;\n', '    }\n', '    emit Transfer (_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * Allow given spender to transfer given number of tokens from message sender.\n', '   *\n', '   * @param _spender address to allow the owner of to transfer tokens from\n', '   *        message sender\n', '   * @param _value number of tokens to allow to transfer\n', '   * @return success true if token transfer was successfully approved, false otherwise\n', '   */\n', '  function approve (address _spender, uint256 _value)\n', '  public override virtual returns (bool success) {\n', '    allowances [msg.sender][_spender] = _value;\n', '    emit Approval (msg.sender, _spender, _value);\n', '\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * Tell how many tokens given spender is currently allowed to transfer from\n', '   * given owner.\n', '   *\n', '   * @param _owner address to get number of tokens allowed to be transferred\n', '   *        from the owner of\n', '   * @param _spender address to get number of tokens allowed to be transferred\n', '   *        by the owner of\n', '   * @return remaining number of tokens given spender is currently allowed to transfer\n', '   *         from given owner\n', '   */\n', '  function allowance (address _owner, address _spender)\n', '  public override virtual view returns (uint256 remaining) {\n', '    return allowances [_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Mapping from addresses of token holders to the numbers of tokens belonging\n', '   * to these token holders.\n', '   */\n', '  mapping (address => uint256) internal accounts;\n', '\n', '  /**\n', '   * @dev Mapping from addresses of token holders to the mapping of addresses of\n', '   * spenders to the allowances set by these token holders to these spenders.\n', '   */\n', '  mapping (address => mapping (address => uint256)) internal allowances;\n', '}\n', '\n', '\n', '/**\n', ' * GMBLR Token Smart Contract: EIP-20 compatible token smart contract that\n', ' * manages GMBLR tokens.\n', ' */\n', 'contract Gambler is AbstractToken {\n', '  // /**\n', '  //  * @dev Fee denominator (0.001%).\n', '  //  */\n', '  // uint256 constant internal FEE_DENOMINATOR = 100000;\n', '\n', '  // /**\n', '  //  * @dev Maximum fee numerator (100%).\n', '  //  */\n', '  // uint256 constant internal MAX_FEE_NUMERATOR = FEE_DENOMINATOR;\n', '\n', '  // /**\n', '  //  * @dev Maximum allowed number of tokens in circulation.\n', '  //  */\n', '   uint256 constant internal MAX_TOKENS_COUNT = 10**13;\n', '  // uint256 constant internal MAX_TOKENS_COUNT = \n', '  //   0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff /\n', '  //   MAX_FEE_NUMERATOR;\n', '\n', '  /**\n', '   * @dev Address flag that marks black listed addresses.\n', '   */\n', '  uint256 constant internal BLACK_LIST_FLAG = 0x01;\n', '\n', '  /**\n', '   * Create GMBLR Token smart contract with message sender as an owner.\n', '   */\n', '  constructor () {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * Get name of the token.\n', '   *\n', '   * @return name of the token\n', '   */\n', '  function name () public pure returns (string memory) {\n', '    return "Gambler Coin";\n', '  }\n', '\n', '  /**\n', '   * Get symbol of the token.\n', '   *\n', '   * @return symbol of the token\n', '   */\n', '  function symbol () public pure returns (string memory) {\n', '    return "GMBLR";\n', '  }\n', '\n', '  /**\n', '   * Get number of decimals for the token.\n', '   *\n', '   * @return number of decimals for the token\n', '   */\n', '  function decimals () public pure returns (uint8) {\n', '    return 3;\n', '  }\n', '\n', '  /**\n', '   * Get total number of tokens in circulation.\n', '   *\n', '   * @return total number of tokens in circulation\n', '   */\n', '  function totalSupply () public override view returns (uint256) {\n', '    return tokensCount;\n', '  }\n', '\n', '  /**\n', '   * Get number of tokens currently belonging to given owner.\n', '   *\n', '   * @param _owner address to get number of tokens currently belonging to the\n', '   *        owner of\n', '   * @return balance number of tokens currently belonging to the owner of given address\n', '   */\n', '  function balanceOf (address _owner)\n', '    public override view returns (uint256 balance) {\n', '    return AbstractToken.balanceOf (_owner);\n', '  }\n', '\n', '  /**\n', '   * Transfer given number of tokens from message sender to given recipient.\n', '   *\n', '   * @param _to address to transfer tokens to the owner of\n', '   * @param _value number of tokens to transfer to the owner of given address\n', '   * @return true if tokens were transferred successfully, false otherwise\n', '   */\n', '  function transfer (address _to, uint256 _value)\n', '  public override virtual returns (bool) {\n', '    if (frozen) return false;\n', '    else if (\n', '      (addressFlags [msg.sender] | addressFlags [_to]) & BLACK_LIST_FLAG ==\n', '      BLACK_LIST_FLAG)\n', '      return false;\n', '    else {\n', '      if (_value <= accounts [msg.sender]) {\n', '        require (AbstractToken.transfer (_to, _value));\n', '        return true;\n', '      } else return false;\n', '    }\n', '  }\n', '\n', '  /**\n', '   * Transfer given number of tokens from given owner to given recipient.\n', '   *\n', '   * @param _from address to transfer tokens from the owner of\n', '   * @param _to address to transfer tokens to the owner of\n', '   * @param _value number of tokens to transfer from given owner to given\n', '   *        recipient\n', '   * @return true if tokens were transferred successfully, false otherwise\n', '   */\n', '  function transferFrom (address _from, address _to, uint256 _value)\n', '  public override virtual returns (bool) {\n', '    if (frozen) return false;\n', '    else if (\n', '      (addressFlags [_from] | addressFlags [_to]) & BLACK_LIST_FLAG ==\n', '      BLACK_LIST_FLAG)\n', '      return false;\n', '    else {\n', '      if (_value <= allowances [_from][msg.sender] &&\n', '          _value <= accounts [_from]) {\n', '        require (AbstractToken.transferFrom (_from, _to, _value));\n', '        return true;\n', '      } else return false;\n', '    }\n', '  }\n', '\n', '  /**\n', '   * Allow given spender to transfer given number of tokens from message sender.\n', '   *\n', '   * @param _spender address to allow the owner of to transfer tokens from\n', '   *        message sender\n', '   * @param _value number of tokens to allow to transfer\n', '   * @return success true if token transfer was successfully approved, false otherwise\n', '   */\n', '  function approve (address _spender, uint256 _value)\n', '  public override returns (bool success) {\n', '    return AbstractToken.approve (_spender, _value);\n', '  }\n', '\n', '  /**\n', '   * Tell how many tokens given spender is currently allowed to transfer from\n', '   * given owner.\n', '   *\n', '   * @param _owner address to get number of tokens allowed to be transferred\n', '   *        from the owner of\n', '   * @param _spender address to get number of tokens allowed to be transferred\n', '   *        by the owner of\n', '   * @return remaining number of tokens given spender is currently allowed to transfer\n', '   *         from given owner\n', '   */\n', '  function allowance (address _owner, address _spender)\n', '  public override view returns (uint256 remaining) {\n', '    return AbstractToken.allowance (_owner, _spender);\n', '  }\n', '\n', '  /**\n', '   * Transfer given number of token from the signed defined by digital signature\n', '   * to given recipient.\n', '   *\n', '   * @param _to address to transfer token to the owner of\n', '   * @param _value number of tokens to transfer\n', '   * @param _fee number of tokens to give to message sender\n', '   * @param _nonce nonce of the transfer\n', '   * @param _v parameter V of digital signature\n', '   * @param _r parameter R of digital signature\n', '   * @param _s parameter S of digital signature\n', '   */\n', '  function delegatedTransfer (\n', '    address _to, uint256 _value, uint256 _fee,\n', '    uint256 _nonce, uint8 _v, bytes32 _r, bytes32 _s)\n', '  public virtual returns (bool) {\n', '    if (frozen) return false;\n', '    else {\n', '      address _from = ecrecover (\n', '        keccak256 (\n', '          abi.encodePacked (\n', '            thisAddress (), messageSenderAddress (), _to, _value, _fee, _nonce)),\n', '        _v, _r, _s);\n', '\n', '      if (_from == address (0)) return false;\n', '\n', '      if (_nonce != nonces [_from]) return false;\n', '\n', '      if (\n', '        (addressFlags [_from] | addressFlags [_to]) & BLACK_LIST_FLAG ==\n', '        BLACK_LIST_FLAG)\n', '        return false;\n', '\n', '      uint256 balance = accounts [_from];\n', '      if (_value > balance) return false;\n', '      balance = balance - _value;\n', '      if (_fee > balance) return false;\n', '      balance = balance - _fee;\n', '\n', '      nonces [_from] = _nonce + 1;\n', '\n', '      accounts [_from] = balance;\n', '      accounts [_to] = accounts [_to] + _value;\n', '      accounts [msg.sender] = accounts [msg.sender] + _fee;\n', '\n', '      Transfer (_from, _to, _value);\n', '      Transfer (_from, msg.sender, _fee);\n', '\n', '      return true;\n', '    }\n', '  }\n', '\n', '  /**\n', '   * Create tokens.\n', '   *\n', '   * @param _value number of tokens to be created.\n', '   */\n', '  function createTokens (uint256 _value)\n', '  public virtual returns (bool) {\n', '    require (msg.sender == owner);\n', '\n', '    if (_value > 0) {\n', '      if (_value <= MAX_TOKENS_COUNT - tokensCount) {\n', '        accounts [msg.sender] = accounts [msg.sender] + _value;\n', '        tokensCount = tokensCount + _value;\n', '\n', '        Transfer (address (0), msg.sender, _value);\n', '\n', '        return true;\n', '      } else return false;\n', '    } else return true;\n', '  }\n', '\n', '  /**\n', '   * Burn tokens.\n', '   *\n', '   * @param _value number of tokens to burn\n', '   */\n', '  function burnTokens (uint256 _value)\n', '  public virtual returns (bool) {\n', '    require (msg.sender == owner);\n', '\n', '    if (_value > 0) {\n', '      if (_value <= accounts [msg.sender]) {\n', '        accounts [msg.sender] = accounts [msg.sender] - _value;\n', '        tokensCount = tokensCount - _value;\n', '\n', '        Transfer (msg.sender, address (0), _value);\n', '\n', '        return true;\n', '      } else return false;\n', '    } else return true;\n', '  }\n', '\n', '  /**\n', '   * Freeze token transfers.\n', '   */\n', '  function freezeTransfers () public {\n', '    require (msg.sender == owner);\n', '\n', '    if (!frozen) {\n', '      frozen = true;\n', '\n', '      Freeze ();\n', '    }\n', '  }\n', '\n', '  /**\n', '   * Unfreeze token transfers.\n', '   */\n', '  function unfreezeTransfers () public {\n', '    require (msg.sender == owner);\n', '\n', '    if (frozen) {\n', '      frozen = false;\n', '\n', '      Unfreeze ();\n', '    }\n', '  }\n', '\n', '  /**\n', '   * Set smart contract owner.\n', '   *\n', '   * @param _newOwner address of the new owner\n', '   */\n', '  function setOwner (address _newOwner) public {\n', '    require (msg.sender == owner);\n', '\n', '    owner = _newOwner;\n', '  }\n', '\n', '  /**\n', '   * Get current nonce for token holder with given address, i.e. nonce this\n', '   * token holder should use for next delegated transfer.\n', '   *\n', '   * @param _owner address of the token holder to get nonce for\n', '   * @return current nonce for token holder with give address\n', '   */\n', '  function nonce (address _owner) public view returns (uint256) {\n', '    return nonces [_owner];\n', '  }\n', '\n', '  /**\n', '   * Get fee parameters.\n', '   *\n', '   * @return _fixedFee fixed fee\n', '   * @return _minVariableFee minimum variable fee\n', '   * @return _maxVariableFee maximum variable fee\n', '   * @return _variableFeeNumnerator variable fee numerator\n', '   */\n', '  function getFeeParameters () public pure returns (\n', '    uint256 _fixedFee,\n', '    uint256 _minVariableFee,\n', '    uint256 _maxVariableFee,\n', '    uint256 _variableFeeNumnerator) {\n', '    _fixedFee = 0;\n', '    _minVariableFee = 0;\n', '    _maxVariableFee = 0;\n', '    _variableFeeNumnerator = 0;\n', '  }\n', '\n', '  /**\n', '   * Calculate fee for transfer of given number of tokens.\n', '   *\n', '   * @param _amount transfer amount to calculate fee for\n', '   * @return _fee fee for transfer of given amount\n', '   */\n', '  function calculateFee (uint256 _amount)\n', '    public pure returns (uint256 _fee) {\n', '    require (_amount <= MAX_TOKENS_COUNT);\n', '\n', '    _fee = 0;\n', '  }\n', '\n', '  /**\n', '   * Set flags for given address.\n', '   *\n', '   * @param _address address to set flags for\n', '   * @param _flags flags to set\n', '   */\n', '  function setFlags (address _address, uint256 _flags)\n', '  public {\n', '    require (msg.sender == owner);\n', '\n', '    addressFlags [_address] = _flags;\n', '  }\n', '\n', '  /**\n', '   * Get flags for given address.\n', '   *\n', '   * @param _address address to get flags for\n', '   * @return flags for given address\n', '   */\n', '  function flags (address _address) public view returns (uint256) {\n', '    return addressFlags [_address];\n', '  }\n', '\n', '  /**\n', '   * Get address of this smart contract.\n', '   *\n', '   * @return address of this smart contract\n', '   */\n', '  function thisAddress () internal virtual view returns (address) {\n', '    return address(this);\n', '  }\n', '\n', '  /**\n', '   * Get address of message sender.\n', '   *\n', '   * @return address of this smart contract\n', '   */\n', '  function messageSenderAddress () internal virtual view returns (address) {\n', '    return msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Owner of the smart contract.\n', '   */\n', '  address internal owner;\n', '\n', '  /**\n', '   * @dev Address where fees are sent to.  Not used anymore.\n', '   */\n', '  address internal feeCollector;\n', '\n', '  /**\n', '   * @dev Number of tokens in circulation.\n', '   */\n', '  uint256 internal tokensCount;\n', '\n', '  /**\n', '   * @dev Whether token transfers are currently frozen.\n', '   */\n', '  bool internal frozen;\n', '\n', '  /**\n', "   * @dev Mapping from sender's address to the next delegated transfer nonce.\n", '   */\n', '  mapping (address => uint256) internal nonces;\n', '\n', '  /**\n', '   * @dev Fixed fee amount in token units.  Not used anymore.\n', '   */\n', '  uint256 internal fixedFee;\n', '\n', '  /**\n', '   * @dev Minimum variable fee in token units.  Not used anymore.\n', '   */\n', '  uint256 internal minVariableFee;\n', '\n', '  /**\n', '   * @dev Maximum variable fee in token units.  Not used anymore.\n', '   */\n', '  uint256 internal maxVariableFee;\n', '\n', '  /**\n', '   * @dev Variable fee numerator.  Not used anymore.\n', '   */\n', '  uint256 internal variableFeeNumerator;\n', '\n', '  /**\n', '   * @dev Maps address to its flags.\n', '   */\n', '  mapping (address => uint256) internal addressFlags;\n', '\n', '  /**\n', '   * @dev Address of smart contract to delegate execution of delegatable methods to,\n', '   * or zero to not delegate delegatable methods execution.  Not used in upgrade.\n', '   */\n', '  address internal delegate;\n', '\n', '  /**\n', '   * Logged when token transfers were frozen.\n', '   */\n', '  event Freeze ();\n', '\n', '  /**\n', '   * Logged when token transfers were unfrozen.\n', '   */\n', '  event Unfreeze ();\n', '}']