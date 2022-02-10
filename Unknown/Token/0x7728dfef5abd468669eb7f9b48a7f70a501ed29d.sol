['pragma solidity ^0.4.11;\n', '\n', '  /**\n', '   * Provides methods to safely add, subtract and multiply uint256 numbers.\n', '   */\n', '  contract SafeMath {\n', '    uint256 constant private MAX_UINT256 =\n', '      0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;\n', '\n', '    /**\n', '     * Add two uint256 values, revert in case of overflow.\n', '     *\n', '     * @param x first value to add\n', '     * @param y second value to add\n', '     * @return x + y\n', '     */\n', '    function safeAdd (uint256 x, uint256 y)\n', '    constant internal\n', '    returns (uint256 z) {\n', '      require (x <= MAX_UINT256 - y);\n', '      return x + y;\n', '    }\n', '\n', '    /**\n', '     * Subtract one uint256 value from another, throw in case of underflow.\n', '     *\n', '     * @param x value to subtract from\n', '     * @param y value to subtract\n', '     * @return x - y\n', '     */\n', '    function safeSub (uint256 x, uint256 y)\n', '    constant internal\n', '    returns (uint256 z) {\n', '      require(x >= y);\n', '      return x - y;\n', '    }\n', '\n', '    /**\n', '     * Multiply two uint256 values, throw in case of overflow.\n', '     *\n', '     * @param x first value to multiply\n', '     * @param y second value to multiply\n', '     * @return x * y\n', '     */\n', '    function safeMul (uint256 x, uint256 y)\n', '    constant internal\n', '    returns (uint256 z) {\n', '      if (y == 0) return 0; // Prevent division by zero at the next line\n', '      require (x <= MAX_UINT256 / y);\n', '      return x * y;\n', '    }\n', '  }\n', '\n', '  /**\n', '   * ERC-20 standard token interface, as defined\n', '   * <a href="http://github.com/ethereum/EIPs/issues/20">here</a>.\n', '   */\n', '  contract Token {\n', '    /**\n', '     * Get total number of tokens in circulation.\n', '     *\n', '     * @return total number of tokens in circulation\n', '     */\n', '    function totalSupply () constant returns (uint256 supply);\n', '\n', '    /**\n', '     * Get number of tokens currently belonging to given owner.\n', '     *\n', '     * @param _owner address to get number of tokens currently belonging to the\n', '     *        owner of\n', '     * @return number of tokens currently belonging to the owner of given address\n', '     */\n', '    function balanceOf (address _owner) constant returns (uint256 balance);\n', '\n', '    /**\n', '     * Transfer given number of tokens from message sender to given recipient.\n', '     *\n', '     * @param _to address to transfer tokens to the owner of\n', '     * @param _value number of tokens to transfer to the owner of given address\n', '     * @return true if tokens were transferred successfully, false otherwise\n', '     */\n', '    function transfer (address _to, uint256 _value) returns (bool success);\n', '\n', '    /**\n', '     * Transfer given number of tokens from given owner to given recipient.\n', '     *\n', '     * @param _from address to transfer tokens from the owner of\n', '     * @param _to address to transfer tokens to the owner of\n', '     * @param _value number of tokens to transfer from given owner to given\n', '     *        recipient\n', '     * @return true if tokens were transferred successfully, false otherwise\n', '     */\n', '    function transferFrom (address _from, address _to, uint256 _value)\n', '    returns (bool success);\n', '\n', '    /**\n', '     * Allow given spender to transfer given number of tokens from message sender.\n', '     *\n', '     * @param _spender address to allow the owner of to transfer tokens from\n', '     *        message sender\n', '     * @param _value number of tokens to allow to transfer\n', '     * @return true if token transfer was successfully approved, false otherwise\n', '     */\n', '    function approve (address _spender, uint256 _value) returns (bool success);\n', '\n', '    /**\n', '     * Tell how many tokens given spender is currently allowed to transfer from\n', '     * given owner.\n', '     *\n', '     * @param _owner address to get number of tokens allowed to be transferred\n', '     *        from the owner of\n', '     * @param _spender address to get number of tokens allowed to be transferred\n', '     *        by the owner of\n', '     * @return number of tokens given spender is currently allowed to transfer\n', '     *         from given owner\n', '     */\n', '    function allowance (address _owner, address _spender) constant\n', '    returns (uint256 remaining);\n', '\n', '    /**\n', '     * Logged when tokens were transferred from one owner to another.\n', '     *\n', '     * @param _from address of the owner, tokens were transferred from\n', '     * @param _to address of the owner, tokens were transferred to\n', '     * @param _value number of tokens transferred\n', '     */\n', '    event Transfer (address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    /**\n', '     * Logged when owner approved his tokens to be transferred by some spender.\n', '     *\n', '     * @param _owner owner who approved his tokens to be transferred\n', '     * @param _spender spender who were allowed to transfer the tokens belonging\n', '     *        to the owner\n', '     * @param _value number of tokens belonging to the owner, approved to be\n', '     *        transferred by the spender\n', '     */\n', '    event Approval (\n', '      address indexed _owner, address indexed _spender, uint256 _value);\n', '  }\n', '\n', '  /**\n', '   * Abstract Token Smart Contract that could be used as a base contract for\n', '   * ERC-20 token contracts.\n', '   */\n', '  contract AbstractToken is Token, SafeMath {\n', '\n', '    /**\n', '     * Address of the fund of this smart contract.\n', '     */\n', '    address fund;\n', '\n', '    /**\n', '     * Create new Abstract Token contract.\n', '     */\n', '    function AbstractToken () {\n', '      // Do nothing\n', '    }\n', '\n', '\n', '    /**\n', '     * Get number of tokens currently belonging to given owner.\n', '     *\n', '     * @param _owner address to get number of tokens currently belonging to the\n', '     *        owner of\n', '     * @return number of tokens currently belonging to the owner of given address\n', '     */\n', '     function balanceOf (address _owner) constant returns (uint256 balance) {\n', '      return accounts [_owner];\n', '    }\n', '\n', '    /**\n', '     * Transfer given number of tokens from message sender to given recipient.\n', '     *\n', '     * @param _to address to transfer tokens to the owner of\n', '     * @param _value number of tokens to transfer to the owner of given address\n', '     * @return true if tokens were transferred successfully, false otherwise\n', '     */\n', '    function transfer (address _to, uint256 _value) returns (bool success) {\n', '      uint256 feeTotal = fee();\n', '\n', '      if (accounts [msg.sender] < _value) return false;\n', '      if (_value > feeTotal && msg.sender != _to) {\n', '        accounts [msg.sender] = safeSub (accounts [msg.sender], _value);\n', '        \n', '        accounts [_to] = safeAdd (accounts [_to], safeSub(_value, feeTotal));\n', '\n', '        processFee(feeTotal);\n', '\n', '        Transfer (msg.sender, _to, safeSub(_value, feeTotal));\n', '        \n', '      }\n', '      return true;\n', '    }\n', '\n', '    /**\n', '     * Transfer given number of tokens from given owner to given recipient.\n', '     *\n', '     * @param _from address to transfer tokens from the owner of\n', '     * @param _to address to transfer tokens to the owner of\n', '     * @param _value number of tokens to transfer from given owner to given\n', '     *        recipient\n', '     * @return true if tokens were transferred successfully, false otherwise\n', '     */\n', '    function transferFrom (address _from, address _to, uint256 _value)\n', '    returns (bool success) {\n', '      uint256 feeTotal = fee();\n', '\n', '      if (allowances [_from][msg.sender] < _value) return false;\n', '      if (accounts [_from] < _value) return false;\n', '\n', '      allowances [_from][msg.sender] =\n', '        safeSub (allowances [_from][msg.sender], _value);\n', '\n', '      if (_value > feeTotal && _from != _to) {\n', '        accounts [_from] = safeSub (accounts [_from], _value);\n', '\n', '        \n', '        accounts [_to] = safeAdd (accounts [_to], safeSub(_value, feeTotal));\n', '\n', '        processFee(feeTotal);\n', '\n', '        Transfer (_from, _to, safeSub(_value, feeTotal));\n', '      }\n', '\n', '      return true;\n', '    }\n', '\n', '    function fee () constant returns (uint256);\n', '\n', '    function processFee(uint256 feeTotal) internal returns (bool);\n', '\n', '    /**\n', '     * Allow given spender to transfer given number of tokens from message sender.\n', '     *\n', '     * @param _spender address to allow the owner of to transfer tokens from\n', '     *        message sender\n', '     * @param _value number of tokens to allow to transfer\n', '     * @return true if token transfer was successfully approved, false otherwise\n', '     */\n', '    function approve (address _spender, uint256 _value) returns (bool success) {\n', '      allowances [msg.sender][_spender] = _value;\n', '      Approval (msg.sender, _spender, _value);\n', '\n', '      return true;\n', '    }\n', '\n', '    /**\n', '     * Tell how many tokens given spender is currently allowed to transfer from\n', '     * given owner.\n', '     *\n', '     * @param _owner address to get number of tokens allowed to be transferred\n', '     *        from the owner of\n', '     * @param _spender address to get number of tokens allowed to be transferred\n', '     *        by the owner of\n', '     * @return number of tokens given spender is currently allowed to transfer\n', '     *         from given owner\n', '     */\n', '    function allowance (address _owner, address _spender) constant\n', '    returns (uint256 remaining) {\n', '      return allowances [_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * Mapping from addresses of token holders to the numbers of tokens belonging\n', '     * to these token holders.\n', '     */\n', '    mapping (address => uint256) accounts;\n', '\n', '    /**\n', '     * Mapping from addresses of token holders to the mapping of addresses of\n', '     * spenders to the allowances set by these token holders to these spenders.\n', '     */\n', '    mapping (address => mapping (address => uint256)) allowances;\n', '  }\n', '\n', '  contract ParagonCoinToken is AbstractToken {\n', '    /**\n', '     * Initial number of tokens.\n', '     */\n', '    uint256 constant INITIAL_TOKENS_COUNT = 200000000e6;\n', '\n', '    /**\n', '     * Address of the owner of this smart contract.\n', '     */\n', '    address owner;\n', '\n', '   \n', '\n', '    /**\n', '     * Total number of tokens ins circulation.\n', '     */\n', '    uint256 tokensCount;\n', '\n', '    /**\n', '     * Create new ParagonCoin Token Smart Contract, make message sender to be the\n', '     * owner of smart contract, issue given number of tokens and give them to\n', '     * message sender.\n', '     */\n', '    function ParagonCoinToken (address fundAddress) {\n', '      tokensCount = INITIAL_TOKENS_COUNT;\n', '      accounts [msg.sender] = INITIAL_TOKENS_COUNT;\n', '      owner = msg.sender;\n', '      fund = fundAddress;\n', '    }\n', '\n', '    /**\n', '     * Get name of this token.\n', '     *\n', '     * @return name of this token\n', '     */\n', '    function name () constant returns (string name) {\n', '      return "PRG";\n', '    }\n', '\n', '    /**\n', '     * Get symbol of this token.\n', '     *\n', '     * @return symbol of this token\n', '     */\n', '    function symbol () constant returns (string symbol) {\n', '      return "PRG";\n', '    }\n', '\n', '\n', '    /**\n', '     * Get number of decimals for this token.\n', '     *\n', '     * @return number of decimals for this token\n', '     */\n', '    function decimals () constant returns (uint8 decimals) {\n', '      return 6;\n', '    }\n', '\n', '    /**\n', '     * Get total number of tokens in circulation.\n', '     *\n', '     * @return total number of tokens in circulation\n', '     */\n', '    function totalSupply () constant returns (uint256 supply) {\n', '      return tokensCount;\n', '    }\n', '\n', '    \n', '\n', '    /**\n', '     * Transfer given number of tokens from message sender to given recipient.\n', '     *\n', '     * @param _to address to transfer tokens to the owner of\n', '     * @param _value number of tokens to transfer to the owner of given address\n', '     * @return true if tokens were transferred successfully, false otherwise\n', '     */\n', '    function transfer (address _to, uint256 _value) returns (bool success) {\n', '      return AbstractToken.transfer (_to, _value);\n', '    }\n', '\n', '    /**\n', '     * Transfer given number of tokens from given owner to given recipient.\n', '     *\n', '     * @param _from address to transfer tokens from the owner of\n', '     * @param _to address to transfer tokens to the owner of\n', '     * @param _value number of tokens to transfer from given owner to given\n', '     *        recipient\n', '     * @return true if tokens were transferred successfully, false otherwise\n', '     */\n', '    function transferFrom (address _from, address _to, uint256 _value)\n', '    returns (bool success) {\n', '      return AbstractToken.transferFrom (_from, _to, _value);\n', '    }\n', '\n', '    function fee () constant returns (uint256) {\n', '      return safeAdd(safeMul(tokensCount, 5)/1e11, 25000);\n', '    }\n', '\n', '    function processFee(uint256 feeTotal) internal returns (bool) {\n', '        uint256 burnFee = feeTotal/2;\n', '        uint256 fundFee = safeSub(feeTotal, burnFee);\n', '\n', '        accounts [fund] = safeAdd (accounts [fund], fundFee);\n', '        tokensCount = safeSub (tokensCount, burnFee); // ledger burned toke\n', '\n', '        Transfer (msg.sender, fund, fundFee);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Change how many tokens given spender is allowed to transfer from message\n', '     * spender.  In order to prevent double spending of allowance, this method\n', '     * receives assumed current allowance value as an argument.  If actual\n', '     * allowance differs from an assumed one, this method just returns false.\n', '     *\n', '     * @param _spender address to allow the owner of to transfer tokens from\n', '     *        message sender\n', '     * @param _currentValue assumed number of tokens currently allowed to be\n', '     *        transferred\n', '     * @param _newValue number of tokens to allow to transfer\n', '     * @return true if token transfer was successfully approved, false otherwise\n', '     */\n', '    function approve (address _spender, uint256 _currentValue, uint256 _newValue)\n', '    returns (bool success) {\n', '      if (allowance (msg.sender, _spender) == _currentValue)\n', '        return approve (_spender, _newValue);\n', '      else return false;\n', '    }\n', '\n', '    /**\n', '     * Burn given number of tokens belonging to message sender.\n', '     *\n', '     * @param _value number of tokens to burn\n', '     * @return true on success, false on error\n', '     */\n', '    function burnTokens (uint256 _value) returns (bool success) {\n', '      if (_value > accounts [msg.sender]) return false;\n', '      else if (_value > 0) {\n', '        accounts [msg.sender] = safeSub (accounts [msg.sender], _value);\n', '        tokensCount = safeSub (tokensCount, _value);\n', '        return true;\n', '      } else return true;\n', '    }\n', '\n', '    /**\n', '     * Set new owner for the smart contract.\n', '     * May only be called by smart contract owner.\n', '     *\n', '     * @param _newOwner address of new owner of the smart contract\n', '     */\n', '    function setOwner (address _newOwner) {\n', '      require (msg.sender == owner);\n', '\n', '      owner = _newOwner;\n', '    }\n', '\n', '    \n', '    /**\n', '     * Set new fund address for the smart contract.\n', '     * May only be called by smart contract owner.\n', '     *\n', '     * @param _newFund new fund address of the smart contract\n', '     */\n', '    function setFundAddress (address _newFund) {\n', '      require (msg.sender == owner);\n', '\n', '      fund = _newFund;\n', '    }\n', '\n', '  }']
['pragma solidity ^0.4.11;\n', '\n', '  /**\n', '   * Provides methods to safely add, subtract and multiply uint256 numbers.\n', '   */\n', '  contract SafeMath {\n', '    uint256 constant private MAX_UINT256 =\n', '      0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;\n', '\n', '    /**\n', '     * Add two uint256 values, revert in case of overflow.\n', '     *\n', '     * @param x first value to add\n', '     * @param y second value to add\n', '     * @return x + y\n', '     */\n', '    function safeAdd (uint256 x, uint256 y)\n', '    constant internal\n', '    returns (uint256 z) {\n', '      require (x <= MAX_UINT256 - y);\n', '      return x + y;\n', '    }\n', '\n', '    /**\n', '     * Subtract one uint256 value from another, throw in case of underflow.\n', '     *\n', '     * @param x value to subtract from\n', '     * @param y value to subtract\n', '     * @return x - y\n', '     */\n', '    function safeSub (uint256 x, uint256 y)\n', '    constant internal\n', '    returns (uint256 z) {\n', '      require(x >= y);\n', '      return x - y;\n', '    }\n', '\n', '    /**\n', '     * Multiply two uint256 values, throw in case of overflow.\n', '     *\n', '     * @param x first value to multiply\n', '     * @param y second value to multiply\n', '     * @return x * y\n', '     */\n', '    function safeMul (uint256 x, uint256 y)\n', '    constant internal\n', '    returns (uint256 z) {\n', '      if (y == 0) return 0; // Prevent division by zero at the next line\n', '      require (x <= MAX_UINT256 / y);\n', '      return x * y;\n', '    }\n', '  }\n', '\n', '  /**\n', '   * ERC-20 standard token interface, as defined\n', '   * <a href="http://github.com/ethereum/EIPs/issues/20">here</a>.\n', '   */\n', '  contract Token {\n', '    /**\n', '     * Get total number of tokens in circulation.\n', '     *\n', '     * @return total number of tokens in circulation\n', '     */\n', '    function totalSupply () constant returns (uint256 supply);\n', '\n', '    /**\n', '     * Get number of tokens currently belonging to given owner.\n', '     *\n', '     * @param _owner address to get number of tokens currently belonging to the\n', '     *        owner of\n', '     * @return number of tokens currently belonging to the owner of given address\n', '     */\n', '    function balanceOf (address _owner) constant returns (uint256 balance);\n', '\n', '    /**\n', '     * Transfer given number of tokens from message sender to given recipient.\n', '     *\n', '     * @param _to address to transfer tokens to the owner of\n', '     * @param _value number of tokens to transfer to the owner of given address\n', '     * @return true if tokens were transferred successfully, false otherwise\n', '     */\n', '    function transfer (address _to, uint256 _value) returns (bool success);\n', '\n', '    /**\n', '     * Transfer given number of tokens from given owner to given recipient.\n', '     *\n', '     * @param _from address to transfer tokens from the owner of\n', '     * @param _to address to transfer tokens to the owner of\n', '     * @param _value number of tokens to transfer from given owner to given\n', '     *        recipient\n', '     * @return true if tokens were transferred successfully, false otherwise\n', '     */\n', '    function transferFrom (address _from, address _to, uint256 _value)\n', '    returns (bool success);\n', '\n', '    /**\n', '     * Allow given spender to transfer given number of tokens from message sender.\n', '     *\n', '     * @param _spender address to allow the owner of to transfer tokens from\n', '     *        message sender\n', '     * @param _value number of tokens to allow to transfer\n', '     * @return true if token transfer was successfully approved, false otherwise\n', '     */\n', '    function approve (address _spender, uint256 _value) returns (bool success);\n', '\n', '    /**\n', '     * Tell how many tokens given spender is currently allowed to transfer from\n', '     * given owner.\n', '     *\n', '     * @param _owner address to get number of tokens allowed to be transferred\n', '     *        from the owner of\n', '     * @param _spender address to get number of tokens allowed to be transferred\n', '     *        by the owner of\n', '     * @return number of tokens given spender is currently allowed to transfer\n', '     *         from given owner\n', '     */\n', '    function allowance (address _owner, address _spender) constant\n', '    returns (uint256 remaining);\n', '\n', '    /**\n', '     * Logged when tokens were transferred from one owner to another.\n', '     *\n', '     * @param _from address of the owner, tokens were transferred from\n', '     * @param _to address of the owner, tokens were transferred to\n', '     * @param _value number of tokens transferred\n', '     */\n', '    event Transfer (address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    /**\n', '     * Logged when owner approved his tokens to be transferred by some spender.\n', '     *\n', '     * @param _owner owner who approved his tokens to be transferred\n', '     * @param _spender spender who were allowed to transfer the tokens belonging\n', '     *        to the owner\n', '     * @param _value number of tokens belonging to the owner, approved to be\n', '     *        transferred by the spender\n', '     */\n', '    event Approval (\n', '      address indexed _owner, address indexed _spender, uint256 _value);\n', '  }\n', '\n', '  /**\n', '   * Abstract Token Smart Contract that could be used as a base contract for\n', '   * ERC-20 token contracts.\n', '   */\n', '  contract AbstractToken is Token, SafeMath {\n', '\n', '    /**\n', '     * Address of the fund of this smart contract.\n', '     */\n', '    address fund;\n', '\n', '    /**\n', '     * Create new Abstract Token contract.\n', '     */\n', '    function AbstractToken () {\n', '      // Do nothing\n', '    }\n', '\n', '\n', '    /**\n', '     * Get number of tokens currently belonging to given owner.\n', '     *\n', '     * @param _owner address to get number of tokens currently belonging to the\n', '     *        owner of\n', '     * @return number of tokens currently belonging to the owner of given address\n', '     */\n', '     function balanceOf (address _owner) constant returns (uint256 balance) {\n', '      return accounts [_owner];\n', '    }\n', '\n', '    /**\n', '     * Transfer given number of tokens from message sender to given recipient.\n', '     *\n', '     * @param _to address to transfer tokens to the owner of\n', '     * @param _value number of tokens to transfer to the owner of given address\n', '     * @return true if tokens were transferred successfully, false otherwise\n', '     */\n', '    function transfer (address _to, uint256 _value) returns (bool success) {\n', '      uint256 feeTotal = fee();\n', '\n', '      if (accounts [msg.sender] < _value) return false;\n', '      if (_value > feeTotal && msg.sender != _to) {\n', '        accounts [msg.sender] = safeSub (accounts [msg.sender], _value);\n', '        \n', '        accounts [_to] = safeAdd (accounts [_to], safeSub(_value, feeTotal));\n', '\n', '        processFee(feeTotal);\n', '\n', '        Transfer (msg.sender, _to, safeSub(_value, feeTotal));\n', '        \n', '      }\n', '      return true;\n', '    }\n', '\n', '    /**\n', '     * Transfer given number of tokens from given owner to given recipient.\n', '     *\n', '     * @param _from address to transfer tokens from the owner of\n', '     * @param _to address to transfer tokens to the owner of\n', '     * @param _value number of tokens to transfer from given owner to given\n', '     *        recipient\n', '     * @return true if tokens were transferred successfully, false otherwise\n', '     */\n', '    function transferFrom (address _from, address _to, uint256 _value)\n', '    returns (bool success) {\n', '      uint256 feeTotal = fee();\n', '\n', '      if (allowances [_from][msg.sender] < _value) return false;\n', '      if (accounts [_from] < _value) return false;\n', '\n', '      allowances [_from][msg.sender] =\n', '        safeSub (allowances [_from][msg.sender], _value);\n', '\n', '      if (_value > feeTotal && _from != _to) {\n', '        accounts [_from] = safeSub (accounts [_from], _value);\n', '\n', '        \n', '        accounts [_to] = safeAdd (accounts [_to], safeSub(_value, feeTotal));\n', '\n', '        processFee(feeTotal);\n', '\n', '        Transfer (_from, _to, safeSub(_value, feeTotal));\n', '      }\n', '\n', '      return true;\n', '    }\n', '\n', '    function fee () constant returns (uint256);\n', '\n', '    function processFee(uint256 feeTotal) internal returns (bool);\n', '\n', '    /**\n', '     * Allow given spender to transfer given number of tokens from message sender.\n', '     *\n', '     * @param _spender address to allow the owner of to transfer tokens from\n', '     *        message sender\n', '     * @param _value number of tokens to allow to transfer\n', '     * @return true if token transfer was successfully approved, false otherwise\n', '     */\n', '    function approve (address _spender, uint256 _value) returns (bool success) {\n', '      allowances [msg.sender][_spender] = _value;\n', '      Approval (msg.sender, _spender, _value);\n', '\n', '      return true;\n', '    }\n', '\n', '    /**\n', '     * Tell how many tokens given spender is currently allowed to transfer from\n', '     * given owner.\n', '     *\n', '     * @param _owner address to get number of tokens allowed to be transferred\n', '     *        from the owner of\n', '     * @param _spender address to get number of tokens allowed to be transferred\n', '     *        by the owner of\n', '     * @return number of tokens given spender is currently allowed to transfer\n', '     *         from given owner\n', '     */\n', '    function allowance (address _owner, address _spender) constant\n', '    returns (uint256 remaining) {\n', '      return allowances [_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * Mapping from addresses of token holders to the numbers of tokens belonging\n', '     * to these token holders.\n', '     */\n', '    mapping (address => uint256) accounts;\n', '\n', '    /**\n', '     * Mapping from addresses of token holders to the mapping of addresses of\n', '     * spenders to the allowances set by these token holders to these spenders.\n', '     */\n', '    mapping (address => mapping (address => uint256)) allowances;\n', '  }\n', '\n', '  contract ParagonCoinToken is AbstractToken {\n', '    /**\n', '     * Initial number of tokens.\n', '     */\n', '    uint256 constant INITIAL_TOKENS_COUNT = 200000000e6;\n', '\n', '    /**\n', '     * Address of the owner of this smart contract.\n', '     */\n', '    address owner;\n', '\n', '   \n', '\n', '    /**\n', '     * Total number of tokens ins circulation.\n', '     */\n', '    uint256 tokensCount;\n', '\n', '    /**\n', '     * Create new ParagonCoin Token Smart Contract, make message sender to be the\n', '     * owner of smart contract, issue given number of tokens and give them to\n', '     * message sender.\n', '     */\n', '    function ParagonCoinToken (address fundAddress) {\n', '      tokensCount = INITIAL_TOKENS_COUNT;\n', '      accounts [msg.sender] = INITIAL_TOKENS_COUNT;\n', '      owner = msg.sender;\n', '      fund = fundAddress;\n', '    }\n', '\n', '    /**\n', '     * Get name of this token.\n', '     *\n', '     * @return name of this token\n', '     */\n', '    function name () constant returns (string name) {\n', '      return "PRG";\n', '    }\n', '\n', '    /**\n', '     * Get symbol of this token.\n', '     *\n', '     * @return symbol of this token\n', '     */\n', '    function symbol () constant returns (string symbol) {\n', '      return "PRG";\n', '    }\n', '\n', '\n', '    /**\n', '     * Get number of decimals for this token.\n', '     *\n', '     * @return number of decimals for this token\n', '     */\n', '    function decimals () constant returns (uint8 decimals) {\n', '      return 6;\n', '    }\n', '\n', '    /**\n', '     * Get total number of tokens in circulation.\n', '     *\n', '     * @return total number of tokens in circulation\n', '     */\n', '    function totalSupply () constant returns (uint256 supply) {\n', '      return tokensCount;\n', '    }\n', '\n', '    \n', '\n', '    /**\n', '     * Transfer given number of tokens from message sender to given recipient.\n', '     *\n', '     * @param _to address to transfer tokens to the owner of\n', '     * @param _value number of tokens to transfer to the owner of given address\n', '     * @return true if tokens were transferred successfully, false otherwise\n', '     */\n', '    function transfer (address _to, uint256 _value) returns (bool success) {\n', '      return AbstractToken.transfer (_to, _value);\n', '    }\n', '\n', '    /**\n', '     * Transfer given number of tokens from given owner to given recipient.\n', '     *\n', '     * @param _from address to transfer tokens from the owner of\n', '     * @param _to address to transfer tokens to the owner of\n', '     * @param _value number of tokens to transfer from given owner to given\n', '     *        recipient\n', '     * @return true if tokens were transferred successfully, false otherwise\n', '     */\n', '    function transferFrom (address _from, address _to, uint256 _value)\n', '    returns (bool success) {\n', '      return AbstractToken.transferFrom (_from, _to, _value);\n', '    }\n', '\n', '    function fee () constant returns (uint256) {\n', '      return safeAdd(safeMul(tokensCount, 5)/1e11, 25000);\n', '    }\n', '\n', '    function processFee(uint256 feeTotal) internal returns (bool) {\n', '        uint256 burnFee = feeTotal/2;\n', '        uint256 fundFee = safeSub(feeTotal, burnFee);\n', '\n', '        accounts [fund] = safeAdd (accounts [fund], fundFee);\n', '        tokensCount = safeSub (tokensCount, burnFee); // ledger burned toke\n', '\n', '        Transfer (msg.sender, fund, fundFee);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Change how many tokens given spender is allowed to transfer from message\n', '     * spender.  In order to prevent double spending of allowance, this method\n', '     * receives assumed current allowance value as an argument.  If actual\n', '     * allowance differs from an assumed one, this method just returns false.\n', '     *\n', '     * @param _spender address to allow the owner of to transfer tokens from\n', '     *        message sender\n', '     * @param _currentValue assumed number of tokens currently allowed to be\n', '     *        transferred\n', '     * @param _newValue number of tokens to allow to transfer\n', '     * @return true if token transfer was successfully approved, false otherwise\n', '     */\n', '    function approve (address _spender, uint256 _currentValue, uint256 _newValue)\n', '    returns (bool success) {\n', '      if (allowance (msg.sender, _spender) == _currentValue)\n', '        return approve (_spender, _newValue);\n', '      else return false;\n', '    }\n', '\n', '    /**\n', '     * Burn given number of tokens belonging to message sender.\n', '     *\n', '     * @param _value number of tokens to burn\n', '     * @return true on success, false on error\n', '     */\n', '    function burnTokens (uint256 _value) returns (bool success) {\n', '      if (_value > accounts [msg.sender]) return false;\n', '      else if (_value > 0) {\n', '        accounts [msg.sender] = safeSub (accounts [msg.sender], _value);\n', '        tokensCount = safeSub (tokensCount, _value);\n', '        return true;\n', '      } else return true;\n', '    }\n', '\n', '    /**\n', '     * Set new owner for the smart contract.\n', '     * May only be called by smart contract owner.\n', '     *\n', '     * @param _newOwner address of new owner of the smart contract\n', '     */\n', '    function setOwner (address _newOwner) {\n', '      require (msg.sender == owner);\n', '\n', '      owner = _newOwner;\n', '    }\n', '\n', '    \n', '    /**\n', '     * Set new fund address for the smart contract.\n', '     * May only be called by smart contract owner.\n', '     *\n', '     * @param _newFund new fund address of the smart contract\n', '     */\n', '    function setFundAddress (address _newFund) {\n', '      require (msg.sender == owner);\n', '\n', '      fund = _newFund;\n', '    }\n', '\n', '  }']
