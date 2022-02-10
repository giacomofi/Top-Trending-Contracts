['/*\n', ' * Abstract Token Smart Contract.  Copyright © 2017 by ABDK Consulting.\n', ' * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>\n', ' */\n', '\n', 'pragma solidity ^0.4.26;\n', '/**\n', ' * Provides methods to safely add, subtract and multiply uint256 numbers.\n', ' */\n', 'contract SafeMath {\n', '  uint256 constant private MAX_UINT256 =\n', '    0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;\n', '\n', '  /**\n', '   * Add two uint256 values, throw in case of overflow.\n', '   *\n', '   * @param x first value to add\n', '   * @param y second value to add\n', '   * @return x + y\n', '   */\n', '  function safeAdd (uint256 x, uint256 y)\n', '  pure internal\n', '  returns (uint256 z) {\n', '    assert (x <= MAX_UINT256 - y);\n', '    return x + y;\n', '  }\n', '\n', '  /**\n', '   * Subtract one uint256 value from another, throw in case of underflow.\n', '   *\n', '   * @param x value to subtract from\n', '   * @param y value to subtract\n', '   * @return x - y\n', '   */\n', '  function safeSub (uint256 x, uint256 y)\n', '  pure internal\n', '  returns (uint256 z) {\n', '    assert (x >= y);\n', '    return x - y;\n', '  }\n', '\n', '  /**\n', '   * Multiply two uint256 values, throw in case of overflow.\n', '   *\n', '   * @param x first value to multiply\n', '   * @param y second value to multiply\n', '   * @return x * y\n', '   */\n', '  function safeMul (uint256 x, uint256 y)\n', '  pure internal\n', '  returns (uint256 z) {\n', '    if (y == 0) return 0; // Prevent division by zero at the next line\n', '    assert (x <= MAX_UINT256 / y);\n', '    return x * y;\n', '  }\n', '}\n', '/*\n', ' * EIP-20 Standard Token Smart Contract Interface.\n', ' * Copyright © 2016–2018 by ABDK Consulting.\n', ' * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>\n', ' */\n', '\n', '/**\n', ' * ERC-20 standard token interface, as defined\n', ' * <a href="https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md">here</a>.\n', ' */\n', 'contract Token {\n', '  /**\n', '   * Get total number of tokens in circulation.\n', '   *\n', '   * @return total number of tokens in circulation\n', '   */\n', '  function totalSupply () public view returns (uint256 supply);\n', '\n', '  /**\n', '   * Get number of tokens currently belonging to given owner.\n', '   *\n', '   * @param _owner address to get number of tokens currently belonging to the\n', '   *        owner of\n', '   * @return number of tokens currently belonging to the owner of given address\n', '   */\n', '  function balanceOf (address _owner) public view returns (uint256 balance);\n', '\n', '  /**\n', '   * Transfer given number of tokens from message sender to given recipient.\n', '   *\n', '   * @param _to address to transfer tokens to the owner of\n', '   * @param _value number of tokens to transfer to the owner of given address\n', '   * @return true if tokens were transferred successfully, false otherwise\n', '   */\n', '  function transfer (address _to, uint256 _value)\n', '  public returns (bool success);\n', '\n', '  /**\n', '   * Transfer given number of tokens from given owner to given recipient.\n', '   *\n', '   * @param _from address to transfer tokens from the owner of\n', '   * @param _to address to transfer tokens to the owner of\n', '   * @param _value number of tokens to transfer from given owner to given\n', '   *        recipient\n', '   * @return true if tokens were transferred successfully, false otherwise\n', '   */\n', '  function transferFrom (address _from, address _to, uint256 _value)\n', '  public returns (bool success);\n', '\n', '  /**\n', '   * Allow given spender to transfer given number of tokens from message sender.\n', '   *\n', '   * @param _spender address to allow the owner of to transfer tokens from\n', '   *        message sender\n', '   * @param _value number of tokens to allow to transfer\n', '   * @return true if token transfer was successfully approved, false otherwise\n', '   */\n', '  function approve (address _spender, uint256 _value)\n', '  public returns (bool success);\n', '\n', '  /**\n', '   * Tell how many tokens given spender is currently allowed to transfer from\n', '   * given owner.\n', '   *\n', '   * @param _owner address to get number of tokens allowed to be transferred\n', '   *        from the owner of\n', '   * @param _spender address to get number of tokens allowed to be transferred\n', '   *        by the owner of\n', '   * @return number of tokens given spender is currently allowed to transfer\n', '   *         from given owner\n', '   */\n', '  function allowance (address _owner, address _spender)\n', '  public view returns (uint256 remaining);\n', '\n', '  /**\n', '   * Logged when tokens were transferred from one owner to another.\n', '   *\n', '   * @param _from address of the owner, tokens were transferred from\n', '   * @param _to address of the owner, tokens were transferred to\n', '   * @param _value number of tokens transferred\n', '   */\n', '  event Transfer (address indexed _from, address indexed _to, uint256 _value);\n', '\n', '  /**\n', '   * Logged when owner approved his tokens to be transferred by some spender.\n', '   *\n', '   * @param _owner owner who approved his tokens to be transferred\n', '   * @param _spender spender who were allowed to transfer the tokens belonging\n', '   *        to the owner\n', '   * @param _value number of tokens belonging to the owner, approved to be\n', '   *        transferred by the spender\n', '   */\n', '  event Approval (\n', '    address indexed _owner, address indexed _spender, uint256 _value);\n', '}/*\n', ' * SCT Token Smart Contract.  Copyright © 2018 by ABDK Consulting.\n', ' * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>\n', ' */\n', '/**\n', ' * Abstract Token Smart Contract that could be used as a base contract for\n', ' * ERC-20 token contracts.\n', ' */\n', 'contract AbstractToken is Token, SafeMath {\n', '  /**\n', '   * Create new Abstract Token contract.\n', '   */\n', '  constructor () public {\n', '    // Do nothing\n', '  }\n', '\n', '  /**\n', '   * Get number of tokens currently belonging to given owner.\n', '   *\n', '   * @param _owner address to get number of tokens currently belonging to the\n', '   *        owner of\n', '   * @return number of tokens currently belonging to the owner of given address\n', '   */\n', '  function balanceOf (address _owner) public view returns (uint256 balance) {\n', '    return accounts [_owner];\n', '  }\n', '\n', '  /**\n', '   * Transfer given number of tokens from message sender to given recipient.\n', '   *\n', '   * @param _to address to transfer tokens to the owner of\n', '   * @param _value number of tokens to transfer to the owner of given address\n', '   * @return true if tokens were transferred successfully, false otherwise\n', '   */\n', '  function transfer (address _to, uint256 _value)\n', '  public returns (bool success) {\n', '    uint256 fromBalance = accounts [msg.sender];\n', '    if (fromBalance < _value) return false;\n', '    if (_value > 0 && msg.sender != _to) {\n', '      accounts [msg.sender] = safeSub (fromBalance, _value);\n', '      accounts [_to] = safeAdd (accounts [_to], _value);\n', '    }\n', '    emit Transfer (msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * Transfer given number of tokens from given owner to given recipient.\n', '   *\n', '   * @param _from address to transfer tokens from the owner of\n', '   * @param _to address to transfer tokens to the owner of\n', '   * @param _value number of tokens to transfer from given owner to given\n', '   *        recipient\n', '   * @return true if tokens were transferred successfully, false otherwise\n', '   */\n', '  function transferFrom (address _from, address _to, uint256 _value)\n', '  public returns (bool success) {\n', '    uint256 spenderAllowance = allowances [_from][msg.sender];\n', '    if (spenderAllowance < _value) return false;\n', '    uint256 fromBalance = accounts [_from];\n', '    if (fromBalance < _value) return false;\n', '\n', '    allowances [_from][msg.sender] =\n', '      safeSub (spenderAllowance, _value);\n', '\n', '    if (_value > 0 && _from != _to) {\n', '      accounts [_from] = safeSub (fromBalance, _value);\n', '      accounts [_to] = safeAdd (accounts [_to], _value);\n', '    }\n', '    emit Transfer (_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * Allow given spender to transfer given number of tokens from message sender.\n', '   *\n', '   * @param _spender address to allow the owner of to transfer tokens from\n', '   *        message sender\n', '   * @param _value number of tokens to allow to transfer\n', '   * @return true if token transfer was successfully approved, false otherwise\n', '   */\n', '  function approve (address _spender, uint256 _value)\n', '  public returns (bool success) {\n', '    allowances [msg.sender][_spender] = _value;\n', '    emit Approval (msg.sender, _spender, _value);\n', '\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * Tell how many tokens given spender is currently allowed to transfer from\n', '   * given owner.\n', '   *\n', '   * @param _owner address to get number of tokens allowed to be transferred\n', '   *        from the owner of\n', '   * @param _spender address to get number of tokens allowed to be transferred\n', '   *        by the owner of\n', '   * @return number of tokens given spender is currently allowed to transfer\n', '   *         from given owner\n', '   */\n', '  function allowance (address _owner, address _spender)\n', '  public view returns (uint256 remaining) {\n', '    return allowances [_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * Mapping from addresses of token holders to the numbers of tokens belonging\n', '   * to these token holders.\n', '   */\n', '  mapping (address => uint256) internal accounts;\n', '\n', '  /**\n', '   * Mapping from addresses of token holders to the mapping of addresses of\n', '   * spenders to the allowances set by these token holders to these spenders.\n', '   */\n', '  mapping (address => mapping (address => uint256)) internal allowances;\n', '}\n', '/*\n', ' * Safe Math Smart Contract.  Copyright © 2016–2017 by ABDK Consulting.\n', ' * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>\n', ' */\n', '\n', '\n', '/**\n', ' * SCT Token Smart Contract: EIP-20 compatible token smart contract that manages\n', ' * SCT tokens.\n', ' */\n', 'contract SCTToken is AbstractToken {\n', '\n', '  uint256 constant internal MAX_TOKENS_COUNT = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF - 1;\n', '\n', '\n', '  /**\n', '   * Create SCT Token smart contract with message sender as an owner.\n', '   *\n', '   */\n', '  constructor () public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * Delegate unrecognized functions.\n', '   */\n', '  function () public payable {\n', '    revert (); // Revert if not delegated\n', '  }\n', '\n', '  /**\n', '   * Get name of the token.\n', '   *\n', '   * @return name of the token\n', '   */\n', '  function name () public pure returns (string) {\n', '    return "STASIS token";\n', '  }\n', '\n', '  /**\n', '   * Get symbol of the token.\n', '   *\n', '   * @return symbol of the token\n', '   */\n', '  function symbol () public pure returns (string) {\n', '    return "STSS";\n', '  }\n', '\n', '  /**\n', '   * Get number of decimals for the token.\n', '   *\n', '   * @return number of decimals for the token\n', '   */\n', '  function decimals () public pure returns (uint8) {\n', '    return 18;\n', '  }\n', '\n', '  /**\n', '   * Get total number of tokens in circulation.\n', '   *\n', '   * @return total number of tokens in circulation\n', '   */\n', '  function totalSupply () public view returns (uint256) {\n', '    return tokensCount;\n', '  }\n', '\n', '  /**\n', '   * Get number of tokens currently belonging to given owner.\n', '   *\n', '   * @param _owner address to get number of tokens currently belonging to the\n', '   *        owner of\n', '   * @return number of tokens currently belonging to the owner of given address\n', '   */\n', '  function balanceOf (address _owner)\n', '    public view returns (uint256 balance) {\n', '    return AbstractToken.balanceOf (_owner);\n', '  }\n', '\n', '  /**\n', '   * Transfer given number of tokens from message sender to given recipient.\n', '   *\n', '   * @param _to address to transfer tokens to the owner of\n', '   * @param _value number of tokens to transfer to the owner of given address\n', '   * @return true if tokens were transferred successfully, false otherwise\n', '   */\n', '  function transfer (address _to, uint256 _value)\n', '  public returns (bool) {\n', '    if (frozen) return false;\n', '    else {\n', '      if (_value <= accounts [msg.sender]) {\n', '        require (AbstractToken.transfer (_to, _value));        \n', '        return true;\n', '      } else return false;\n', '    }\n', '  }\n', '\n', '  /**\n', '   * Transfer given number of tokens from given owner to given recipient.\n', '   *\n', '   * @param _from address to transfer tokens from the owner of\n', '   * @param _to address to transfer tokens to the owner of\n', '   * @param _value number of tokens to transfer from given owner to given\n', '   *        recipient\n', '   * @return true if tokens were transferred successfully, false otherwise\n', '   */\n', '  function transferFrom (address _from, address _to, uint256 _value)\n', '  public returns (bool) {\n', '    if (frozen) return false;\n', '    else {\n', '      if (_value <= allowances [_from][msg.sender] &&\n', '          _value <= accounts [_from]) {\n', '        require (AbstractToken.transferFrom (_from, _to, _value));\n', '        return true;\n', '      } else return false;\n', '    }\n', '  }\n', '\n', '  /**\n', '   * Allow given spender to transfer given number of tokens from message sender.\n', '   *\n', '   * @param _spender address to allow the owner of to transfer tokens from\n', '   *        message sender\n', '   * @param _value number of tokens to allow to transfer\n', '   * @return true if token transfer was successfully approved, false otherwise\n', '   */\n', '  function approve (address _spender, uint256 _value)\n', '  public returns (bool success) {\n', '    return AbstractToken.approve (_spender, _value);\n', '  }\n', '\n', '  /**\n', '   * Tell how many tokens given spender is currently allowed to transfer from\n', '   * given owner.\n', '   *\n', '   * @param _owner address to get number of tokens allowed to be transferred\n', '   *        from the owner of\n', '   * @param _spender address to get number of tokens allowed to be transferred\n', '   *        by the owner of\n', '   * @return number of tokens given spender is currently allowed to transfer\n', '   *         from given owner\n', '   */\n', '  function allowance (address _owner, address _spender)\n', '  public view returns (uint256 remaining) {\n', '    return AbstractToken.allowance (_owner, _spender);\n', '  }\n', '\n', '  /**\n', '   * Transfer given number of token from the signed defined by digital signature\n', '   * to given recipient.\n', '   *\n', '   * @param _to address to transfer token to the owner of\n', '   * @param _value number of tokens to transfer\n', '   * @param _fee number of tokens to give to message sender\n', '   * @param _nonce nonce of the transfer\n', '   * @param _v parameter V of digital signature\n', '   * @param _r parameter R of digital signature\n', '   * @param _s parameter S of digital signature\n', '   */\n', '  function delegatedTransfer (\n', '    address _to, uint256 _value, uint256 _fee,\n', '    uint256 _nonce, uint8 _v, bytes32 _r, bytes32 _s)\n', '  public returns (bool) {\n', '    if (frozen) return false;\n', '    else {\n', '      address _from = ecrecover (\n', '        keccak256 (\n', '          thisAddress (), messageSenderAddress (), _to, _value, _fee, _nonce),\n', '        _v, _r, _s);\n', '\n', '      if (_nonce != nonces [_from]) return false;\n', '\n', '      uint256 balance = accounts [_from];\n', '      if (_value > balance) return false;\n', '      balance = safeSub (balance, _value);\n', '      if (_fee > balance) return false;\n', '      balance = safeSub (balance, _fee);\n', '\n', '      nonces [_from] = _nonce + 1;\n', '\n', '      accounts [_from] = balance;\n', '      accounts [_to] = safeAdd (accounts [_to], _value);      \n', '      accounts [msg.sender] = safeAdd (accounts [msg.sender], _fee);\n', '\n', '      emit Transfer (_from, _to, _value);\n', '      emit Transfer (_from, msg.sender, _fee);\n', '\n', '      return true;\n', '    }\n', '  }\n', '\n', '  /**\n', '   * Create tokens.\n', '   *\n', '   * @param _value number of tokens to be created.\n', '   */\n', '  function createTokens (uint256 _value)\n', '  public returns (bool) {\n', '    require (msg.sender == owner);\n', '\n', '    if (_value > 0) {\n', '      if (_value <= safeSub (MAX_TOKENS_COUNT, tokensCount)) {\n', '        accounts [msg.sender] = safeAdd (accounts [msg.sender], _value);\n', '        tokensCount = safeAdd (tokensCount, _value);\n', '\n', '        emit Transfer (address (0), msg.sender, _value);\n', '\n', '        return true;\n', '      } else return false;\n', '    } else return true;\n', '  }\n', '\n', '  /**\n', '   * Burn tokens.\n', '   *\n', '   * @param _value number of tokens to burn\n', '   */\n', '  function burnTokens (uint256 _value)\n', '  public returns (bool) {\n', '    require (msg.sender == owner);\n', '\n', '    if (_value > 0) {\n', '      if (_value <= accounts [msg.sender]) {\n', '        accounts [msg.sender] = safeSub (accounts [msg.sender], _value);\n', '        tokensCount = safeSub (tokensCount, _value);\n', '\n', '        emit Transfer (msg.sender, address (0), _value);\n', '\n', '        return true;\n', '      } else return false;\n', '    } else return true;\n', '  }\n', '\n', '  /**\n', '   * Freeze token transfers.\n', '   */\n', '  function freezeTransfers () public {\n', '    require (msg.sender == owner);\n', '\n', '    if (!frozen) {\n', '      frozen = true;\n', '\n', '      emit Freeze ();\n', '    }\n', '  }\n', '\n', '  /**\n', '   * Unfreeze token transfers.\n', '   */\n', '  function unfreezeTransfers () public {\n', '    require (msg.sender == owner);\n', '\n', '    if (frozen) {\n', '      frozen = false;\n', '\n', '      emit Unfreeze ();\n', '    }\n', '  }\n', '\n', '  /**\n', '   * Set smart contract owner.\n', '   *\n', '   * @param _newOwner address of the new owner\n', '   */\n', '  function setOwner (address _newOwner) public {\n', '    require (msg.sender == owner);\n', '\n', '    owner = _newOwner;\n', '  }\n', '\n', '  /**\n', '   * Get current nonce for token holder with given address, i.e. nonce this\n', '   * token holder should use for next delegated transfer.\n', '   *\n', '   * @param _owner address of the token holder to get nonce for\n', '   * @return current nonce for token holder with give address\n', '   */\n', '  function nonce (address _owner) public view  returns (uint256) {\n', '    return nonces [_owner];\n', '  }\n', '\n', '  /**\n', '   * Get address of this smart contract.\n', '   *\n', '   * @return address of this smart contract\n', '   */\n', '  function thisAddress () internal view returns (address) {\n', '    return this;\n', '  }\n', '\n', '  /**\n', '   * Get address of message sender.\n', '   *\n', '   * @return address of this smart contract\n', '   */\n', '  function messageSenderAddress () internal view returns (address) {\n', '    return msg.sender;\n', '  }\n', '\n', '  /**\n', '   * Owner of the smart contract.\n', '   */\n', '  address internal owner;\n', '\n', '  /**\n', '   * Number of tokens in circulation.\n', '   */\n', '  uint256 internal tokensCount;\n', '\n', '  /**\n', '   * Whether token transfers are currently frozen.\n', '   */\n', '  bool internal frozen;\n', '\n', '  /**\n', "   * Mapping from sender's address to the next delegated transfer nonce.\n", '   */\n', '  mapping (address => uint256) internal nonces;\n', '\n', '  /**\n', '   * Logged when token transfers were frozen.\n', '   */\n', '  event Freeze ();\n', '\n', '  /**\n', '   * Logged when token transfers were unfrozen.\n', '   */\n', '  event Unfreeze ();\n', '}']