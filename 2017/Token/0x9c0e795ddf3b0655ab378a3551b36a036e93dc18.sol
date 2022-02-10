['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * IMultiOwned\n', ' *\n', ' * Interface that allows multiple owners\n', ' *\n', ' * #created 09/10/2017\n', ' * #author Frank Bonnet\n', ' */\n', 'interface IMultiOwned {\n', '\n', '    /**\n', '     * Returns true if `_account` is an owner\n', '     *\n', '     * @param _account The address to test against\n', '     */\n', '    function isOwner(address _account) public view returns (bool);\n', '\n', '\n', '    /**\n', '     * Returns the amount of owners\n', '     *\n', '     * @return The amount of owners\n', '     */\n', '    function getOwnerCount() public view returns (uint);\n', '\n', '\n', '    /**\n', '     * Gets the owner at `_index`\n', '     *\n', '     * @param _index The index of the owner\n', '     * @return The address of the owner found at `_index`\n', '     */\n', '    function getOwnerAt(uint _index) public view returns (address);\n', '\n', '\n', '     /**\n', '     * Adds `_account` as a new owner\n', '     *\n', '     * @param _account The account to add as an owner\n', '     */\n', '    function addOwner(address _account) public;\n', '\n', '\n', '    /**\n', '     * Removes `_account` as an owner\n', '     *\n', '     * @param _account The account to remove as an owner\n', '     */\n', '    function removeOwner(address _account) public;\n', '}\n', '\n', '\n', '/**\n', ' * MultiOwned\n', ' *\n', ' * Allows multiple owners\n', ' *\n', ' * #created 09/10/2017\n', ' * #author Frank Bonnet\n', ' */\n', 'contract MultiOwned is IMultiOwned {\n', '\n', '    // Owners\n', '    mapping (address => uint) private owners;\n', '    address[] private ownersIndex;\n', '\n', '\n', '     /**\n', '     * Access is restricted to owners only\n', '     */\n', '    modifier only_owner() {\n', '        require(isOwner(msg.sender));\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * The publisher is the initial owner\n', '     */\n', '    function MultiOwned() public {\n', '        ownersIndex.push(msg.sender);\n', '        owners[msg.sender] = 0;\n', '    }\n', '\n', '\n', '    /**\n', '     * Returns true if `_account` is the current owner\n', '     *\n', '     * @param _account The address to test against\n', '     */\n', '    function isOwner(address _account) public view returns (bool) {\n', '        return owners[_account] < ownersIndex.length && _account == ownersIndex[owners[_account]];\n', '    }\n', '\n', '\n', '    /**\n', '     * Returns the amount of owners\n', '     *\n', '     * @return The amount of owners\n', '     */\n', '    function getOwnerCount() public view returns (uint) {\n', '        return ownersIndex.length;\n', '    }\n', '\n', '\n', '    /**\n', '     * Gets the owner at `_index`\n', '     *\n', '     * @param _index The index of the owner\n', '     * @return The address of the owner found at `_index`\n', '     */\n', '    function getOwnerAt(uint _index) public view returns (address) {\n', '        return ownersIndex[_index];\n', '    }\n', '\n', '\n', '    /**\n', '     * Adds `_account` as a new owner\n', '     *\n', '     * @param _account The account to add as an owner\n', '     */\n', '    function addOwner(address _account) public only_owner {\n', '        if (!isOwner(_account)) {\n', '            owners[_account] = ownersIndex.push(_account) - 1;\n', '        }\n', '    }\n', '\n', '\n', '    /**\n', '     * Removes `_account` as an owner\n', '     *\n', '     * @param _account The account to remove as an owner\n', '     */\n', '    function removeOwner(address _account) public only_owner {\n', '        if (isOwner(_account)) {\n', '            uint indexToDelete = owners[_account];\n', '            address keyToMove = ownersIndex[ownersIndex.length - 1];\n', '            ownersIndex[indexToDelete] = keyToMove;\n', '            owners[keyToMove] = indexToDelete; \n', '            ownersIndex.length--;\n', '        }\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * IObservable\n', ' *\n', ' * Allows observers to register and unregister with the \n', ' * implementing smart-contract that is observable\n', ' *\n', ' * #created 09/10/2017\n', ' * #author Frank Bonnet\n', ' */\n', 'interface IObservable {\n', '\n', '\n', '    /**\n', '     * Returns true if `_account` is a registered observer\n', '     * \n', '     * @param _account The account to test against\n', '     * @return Whether the account is a registered observer\n', '     */\n', '    function isObserver(address _account) public view returns (bool);\n', '\n', '\n', '    /**\n', '     * Gets the amount of registered observers\n', '     * \n', '     * @return The amount of registered observers\n', '     */\n', '    function getObserverCount() public view returns (uint);\n', '\n', '\n', '    /**\n', '     * Gets the observer at `_index`\n', '     * \n', '     * @param _index The index of the observer\n', '     * @return The observers address\n', '     */\n', '    function getObserverAtIndex(uint _index) public view returns (address);\n', '\n', '\n', '    /**\n', '     * Register `_observer` as an observer\n', '     * \n', '     * @param _observer The account to add as an observer\n', '     */\n', '    function registerObserver(address _observer) public;\n', '\n', '\n', '    /**\n', '     * Unregister `_observer` as an observer\n', '     * \n', '     * @param _observer The account to remove as an observer\n', '     */\n', '    function unregisterObserver(address _observer) public;\n', '}\n', '\n', '\n', '/**\n', ' * Abstract Observable\n', ' *\n', ' * Allows observers to register and unregister with the the \n', ' * implementing smart-contract that is observable\n', ' *\n', ' * #created 09/10/2017\n', ' * #author Frank Bonnet\n', ' */\n', 'contract Observable is IObservable {\n', '\n', '\n', '    // Observers\n', '    mapping (address => uint) private observers;\n', '    address[] private observerIndex;\n', '\n', '\n', '    /**\n', '     * Returns true if `_account` is a registered observer\n', '     * \n', '     * @param _account The account to test against\n', '     * @return Whether the account is a registered observer\n', '     */\n', '    function isObserver(address _account) public view returns (bool) {\n', '        return observers[_account] < observerIndex.length && _account == observerIndex[observers[_account]];\n', '    }\n', '\n', '\n', '    /**\n', '     * Gets the amount of registered observers\n', '     * \n', '     * @return The amount of registered observers\n', '     */\n', '    function getObserverCount() public view returns (uint) {\n', '        return observerIndex.length;\n', '    }\n', '\n', '\n', '    /**\n', '     * Gets the observer at `_index`\n', '     * \n', '     * @param _index The index of the observer\n', '     * @return The observers address\n', '     */\n', '    function getObserverAtIndex(uint _index) public view returns (address) {\n', '        return observerIndex[_index];\n', '    }\n', '\n', '\n', '    /**\n', '     * Register `_observer` as an observer\n', '     * \n', '     * @param _observer The account to add as an observer\n', '     */\n', '    function registerObserver(address _observer) public {\n', '        require(canRegisterObserver(_observer));\n', '        if (!isObserver(_observer)) {\n', '            observers[_observer] = observerIndex.push(_observer) - 1;\n', '        }\n', '    }\n', '\n', '\n', '    /**\n', '     * Unregister `_observer` as an observer\n', '     * \n', '     * @param _observer The account to remove as an observer\n', '     */\n', '    function unregisterObserver(address _observer) public {\n', '        require(canUnregisterObserver(_observer));\n', '        if (isObserver(_observer)) {\n', '            uint indexToDelete = observers[_observer];\n', '            address keyToMove = observerIndex[observerIndex.length - 1];\n', '            observerIndex[indexToDelete] = keyToMove;\n', '            observers[keyToMove] = indexToDelete;\n', '            observerIndex.length--;\n', '        }\n', '    }\n', '\n', '\n', '    /**\n', '     * Returns whether it is allowed to register `_observer` by calling \n', '     * canRegisterObserver() in the implementing smart-contract\n', '     *\n', '     * @param _observer The address to register as an observer\n', '     * @return Whether the sender is allowed or not\n', '     */\n', '    function canRegisterObserver(address _observer) internal view returns (bool);\n', '\n', '\n', '    /**\n', '     * Returns whether it is allowed to unregister `_observer` by calling \n', '     * canRegisterObserver() in the implementing smart-contract\n', '     *\n', '     * @param _observer The address to unregister as an observer\n', '     * @return Whether the sender is allowed or not\n', '     */\n', '    function canUnregisterObserver(address _observer) internal view returns (bool);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * ITokenObserver\n', ' *\n', ' * Allows a token smart-contract to notify observers \n', ' * when tokens are received\n', ' *\n', ' * #created 09/10/2017\n', ' * #author Frank Bonnet\n', ' */\n', 'interface ITokenObserver {\n', '\n', '\n', '    /**\n', '     * Called by the observed token smart-contract in order \n', '     * to notify the token observer when tokens are received\n', '     *\n', '     * @param _from The address that the tokens where send from\n', '     * @param _value The amount of tokens that was received\n', '     */\n', '    function notifyTokensReceived(address _from, uint _value) public;\n', '}\n', '\n', '\n', '/**\n', ' * TokenObserver\n', ' *\n', ' * Allows observers to be notified by an observed token smart-contract\n', ' * when tokens are received\n', ' *\n', ' * #created 09/10/2017\n', ' * #author Frank Bonnet\n', ' */\n', 'contract TokenObserver is ITokenObserver {\n', '\n', '\n', '    /**\n', '     * Called by the observed token smart-contract in order \n', '     * to notify the token observer when tokens are received\n', '     *\n', '     * @param _from The address that the tokens where send from\n', '     * @param _value The amount of tokens that was received\n', '     */\n', '    function notifyTokensReceived(address _from, uint _value) public {\n', '        onTokensReceived(msg.sender, _from, _value);\n', '    }\n', '\n', '\n', '    /**\n', '     * Event handler\n', '     * \n', '     * Called by `_token` when a token amount is received\n', '     *\n', '     * @param _token The token contract that received the transaction\n', '     * @param _from The account or contract that send the transaction\n', '     * @param _value The value of tokens that where received\n', '     */\n', '    function onTokensReceived(address _token, address _from, uint _value) internal;\n', '}\n', '\n', '\n', '\n', '/**\n', ' * ITokenRetriever\n', ' *\n', ' * Allows tokens to be retrieved from a contract\n', ' *\n', ' * #created 29/09/2017\n', ' * #author Frank Bonnet\n', ' */\n', 'interface ITokenRetriever {\n', '\n', '    /**\n', '     * Extracts tokens from the contract\n', '     *\n', '     * @param _tokenContract The address of ERC20 compatible token\n', '     */\n', '    function retrieveTokens(address _tokenContract) public;\n', '}\n', '\n', '\n', '/**\n', ' * TokenRetriever\n', ' *\n', ' * Allows tokens to be retrieved from a contract\n', ' *\n', ' * #created 18/10/2017\n', ' * #author Frank Bonnet\n', ' */\n', 'contract TokenRetriever is ITokenRetriever {\n', '\n', '    /**\n', '     * Extracts tokens from the contract\n', '     *\n', '     * @param _tokenContract The address of ERC20 compatible token\n', '     */\n', '    function retrieveTokens(address _tokenContract) public {\n', '        IToken tokenInstance = IToken(_tokenContract);\n', '        uint tokenBalance = tokenInstance.balanceOf(this);\n', '        if (tokenBalance > 0) {\n', '            tokenInstance.transfer(msg.sender, tokenBalance);\n', '        }\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * Input validation\n', ' *\n', ' * Validates argument length\n', ' *\n', ' * #created 01/10/2017\n', ' * #author Frank Bonnet\n', ' */\n', 'contract InputValidator {\n', '\n', '\n', '    /**\n', '     * ERC20 Short Address Attack fix\n', '     */\n', '    modifier safe_arguments(uint _numArgs) {\n', '        assert(msg.data.length == _numArgs * 32 + 4);\n', '        _;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * ERC20 compatible token interface\n', ' *\n', ' * - Implements ERC 20 Token standard\n', ' * - Implements short address attack fix\n', ' *\n', ' * #created 29/09/2017\n', ' * #author Frank Bonnet\n', ' */\n', 'interface IToken { \n', '\n', '    /** \n', '     * Get the total supply of tokens\n', '     * \n', '     * @return The total supply\n', '     */\n', '    function totalSupply() public view returns (uint);\n', '\n', '\n', '    /** \n', '     * Get balance of `_owner` \n', '     * \n', '     * @param _owner The address from which the balance will be retrieved\n', '     * @return The balance\n', '     */\n', '    function balanceOf(address _owner) public view returns (uint);\n', '\n', '\n', '    /** \n', '     * Send `_value` token to `_to` from `msg.sender`\n', '     * \n', '     * @param _to The address of the recipient\n', '     * @param _value The amount of token to be transferred\n', '     * @return Whether the transfer was successful or not\n', '     */\n', '    function transfer(address _to, uint _value) public returns (bool);\n', '\n', '\n', '    /** \n', '     * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '     * \n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value The amount of token to be transferred\n', '     * @return Whether the transfer was successful or not\n', '     */\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool);\n', '\n', '\n', '    /** \n', '     * `msg.sender` approves `_spender` to spend `_value` tokens\n', '     * \n', '     * @param _spender The address of the account able to transfer the tokens\n', '     * @param _value The amount of tokens to be approved for transfer\n', '     * @return Whether the approval was successful or not\n', '     */\n', '    function approve(address _spender, uint _value) public returns (bool);\n', '\n', '\n', '    /** \n', '     * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`\n', '     * \n', '     * @param _owner The address of the account owning tokens\n', '     * @param _spender The address of the account able to transfer the tokens\n', '     * @return Amount of remaining tokens allowed to spent\n', '     */\n', '    function allowance(address _owner, address _spender) public view returns (uint);\n', '}\n', '\n', '\n', '/**\n', ' * ERC20 compatible token\n', ' *\n', ' * - Implements ERC 20 Token standard\n', ' * - Implements short address attack fix\n', ' *\n', ' * #created 29/09/2017\n', ' * #author Frank Bonnet\n', ' */\n', 'contract Token is IToken, InputValidator {\n', '\n', '    // Ethereum token standard\n', '    string public standard = "Token 0.3.1";\n', '    string public name;        \n', '    string public symbol;\n', '    uint8 public decimals;\n', '\n', '    // Token state\n', '    uint internal totalTokenSupply;\n', '\n', '    // Token balances\n', '    mapping (address => uint) internal balances;\n', '\n', '    // Token allowances\n', '    mapping (address => mapping (address => uint)) internal allowed;\n', '\n', '\n', '    // Events\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '\n', '    /** \n', '     * Construct ERC20 token\n', '     * \n', '     * @param _name The full token name\n', '     * @param _symbol The token symbol (aberration)\n', '     * @param _decimals The token precision\n', '     */\n', '    function Token(string _name, string _symbol, uint8 _decimals) public {\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '        balances[msg.sender] = 0;\n', '        totalTokenSupply = 0;\n', '    }\n', '\n', '\n', '    /** \n', '     * Get the total token supply\n', '     * \n', '     * @return The total supply\n', '     */\n', '    function totalSupply() public view returns (uint) {\n', '        return totalTokenSupply;\n', '    }\n', '\n', '\n', '    /** \n', '     * Get balance of `_owner` \n', '     * \n', '     * @param _owner The address from which the balance will be retrieved\n', '     * @return The balance\n', '     */\n', '    function balanceOf(address _owner) public view returns (uint) {\n', '        return balances[_owner];\n', '    }\n', '\n', '\n', '    /** \n', '     * Send `_value` token to `_to` from `msg.sender`\n', '     * \n', '     * @param _to The address of the recipient\n', '     * @param _value The amount of token to be transferred\n', '     * @return Whether the transfer was successful or not\n', '     */\n', '    function transfer(address _to, uint _value) public safe_arguments(2) returns (bool) {\n', '\n', '        // Check if the sender has enough tokens\n', '        require(balances[msg.sender] >= _value);   \n', '\n', '        // Check for overflows\n', '        require(balances[_to] + _value >= balances[_to]);\n', '\n', '        // Transfer tokens\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '\n', '        // Notify listeners\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    /** \n', '     * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '     * \n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value The amount of token to be transferred\n', '     * @return Whether the transfer was successful or not \n', '     */\n', '    function transferFrom(address _from, address _to, uint _value) public safe_arguments(3) returns (bool) {\n', '\n', '        // Check if the sender has enough\n', '        require(balances[_from] >= _value);\n', '\n', '        // Check for overflows\n', '        require(balances[_to] + _value >= balances[_to]);\n', '\n', '        // Check allowance\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        // Transfer tokens\n', '        balances[_to] += _value;\n', '        balances[_from] -= _value;\n', '\n', '        // Update allowance\n', '        allowed[_from][msg.sender] -= _value;\n', '\n', '        // Notify listeners\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    /** \n', '     * `msg.sender` approves `_spender` to spend `_value` tokens\n', '     * \n', '     * @param _spender The address of the account able to transfer the tokens\n', '     * @param _value The amount of tokens to be approved for transfer\n', '     * @return Whether the approval was successful or not\n', '     */\n', '    function approve(address _spender, uint _value) public safe_arguments(2) returns (bool) {\n', '\n', '        // Update allowance\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        // Notify listeners\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    /** \n', '     * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`\n', '     * \n', '     * @param _owner The address of the account owning tokens\n', '     * @param _spender The address of the account able to transfer the tokens\n', '     * @return Amount of remaining tokens allowed to spent\n', '     */\n', '    function allowance(address _owner, address _spender) public view returns (uint) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * IManagedToken\n', ' *\n', ' * Adds the following functionality to the basic ERC20 token\n', ' * - Locking\n', ' * - Issuing\n', ' * - Burning \n', ' *\n', ' * #created 29/09/2017\n', ' * #author Frank Bonnet\n', ' */\n', 'interface IManagedToken { \n', '\n', '    /** \n', '     * Returns true if the token is locked\n', '     * \n', '     * @return Whether the token is locked\n', '     */\n', '    function isLocked() public view returns (bool);\n', '\n', '\n', '    /**\n', '     * Locks the token so that the transfering of value is disabled \n', '     *\n', '     * @return Whether the unlocking was successful or not\n', '     */\n', '    function lock() public returns (bool);\n', '\n', '\n', '    /**\n', '     * Unlocks the token so that the transfering of value is enabled \n', '     *\n', '     * @return Whether the unlocking was successful or not\n', '     */\n', '    function unlock() public returns (bool);\n', '\n', '\n', '    /**\n', '     * Issues `_value` new tokens to `_to`\n', '     *\n', '     * @param _to The address to which the tokens will be issued\n', '     * @param _value The amount of new tokens to issue\n', '     * @return Whether the tokens where sucessfully issued or not\n', '     */\n', '    function issue(address _to, uint _value) public returns (bool);\n', '\n', '\n', '    /**\n', '     * Burns `_value` tokens of `_from`\n', '     *\n', '     * @param _from The address that owns the tokens to be burned\n', '     * @param _value The amount of tokens to be burned\n', '     * @return Whether the tokens where sucessfully burned or not \n', '     */\n', '    function burn(address _from, uint _value) public returns (bool);\n', '}\n', '\n', '\n', '/**\n', ' * ManagedToken\n', ' *\n', ' * Adds the following functionality to the basic ERC20 token\n', ' * - Locking\n', ' * - Issuing\n', ' * - Burning \n', ' *\n', ' * #created 29/09/2017\n', ' * #author Frank Bonnet\n', ' */\n', 'contract ManagedToken is IManagedToken, Token, MultiOwned {\n', '\n', '    // Token state\n', '    bool internal locked;\n', '\n', '\n', '    /**\n', '     * Allow access only when not locked\n', '     */\n', '    modifier only_when_unlocked() {\n', '        require(!locked);\n', '        _;\n', '    }\n', '\n', '\n', '    /** \n', '     * Construct managed ERC20 token\n', '     * \n', '     * @param _name The full token name\n', '     * @param _symbol The token symbol (aberration)\n', '     * @param _decimals The token precision\n', '     * @param _locked Whether the token should be locked initially\n', '     */\n', '    function ManagedToken(string _name, string _symbol, uint8 _decimals, bool _locked) public \n', '        Token(_name, _symbol, _decimals) {\n', '        locked = _locked;\n', '    }\n', '\n', '\n', '    /** \n', '     * Send `_value` token to `_to` from `msg.sender`\n', '     * \n', '     * @param _to The address of the recipient\n', '     * @param _value The amount of token to be transferred\n', '     * @return Whether the transfer was successful or not\n', '     */\n', '    function transfer(address _to, uint _value) public only_when_unlocked returns (bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '\n', '    /** \n', '     * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '     * \n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value The amount of token to be transferred\n', '     * @return Whether the transfer was successful or not\n', '     */\n', '    function transferFrom(address _from, address _to, uint _value) public only_when_unlocked returns (bool) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '\n', '    /** \n', '     * `msg.sender` approves `_spender` to spend `_value` tokens\n', '     * \n', '     * @param _spender The address of the account able to transfer the tokens\n', '     * @param _value The amount of tokens to be approved for transfer\n', '     * @return Whether the approval was successful or not\n', '     */\n', '    function approve(address _spender, uint _value) public returns (bool) {\n', '        return super.approve(_spender, _value);\n', '    }\n', '\n', '\n', '    /** \n', '     * Returns true if the token is locked\n', '     * \n', '     * @return Whether the token is locked\n', '     */\n', '    function isLocked() public view returns (bool) {\n', '        return locked;\n', '    }\n', '\n', '\n', '    /**\n', '     * Locks the token so that the transfering of value is enabled \n', '     *\n', '     * @return Whether the locking was successful or not\n', '     */\n', '    function lock() public only_owner returns (bool)  {\n', '        locked = true;\n', '        return locked;\n', '    }\n', '\n', '\n', '    /**\n', '     * Unlocks the token so that the transfering of value is enabled \n', '     *\n', '     * @return Whether the unlocking was successful or not\n', '     */\n', '    function unlock() public only_owner returns (bool)  {\n', '        locked = false;\n', '        return !locked;\n', '    }\n', '\n', '\n', '    /**\n', '     * Issues `_value` new tokens to `_to`\n', '     *\n', '     * @param _to The address to which the tokens will be issued\n', '     * @param _value The amount of new tokens to issue\n', '     * @return Whether the approval was successful or not\n', '     */\n', '    function issue(address _to, uint _value) public only_owner safe_arguments(2) returns (bool) {\n', '        \n', '        // Check for overflows\n', '        require(balances[_to] + _value >= balances[_to]);\n', '\n', '        // Create tokens\n', '        balances[_to] += _value;\n', '        totalTokenSupply += _value;\n', '\n', '        // Notify listeners \n', '        Transfer(0, this, _value);\n', '        Transfer(this, _to, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    /**\n', '     * Burns `_value` tokens of `_recipient`\n', '     *\n', '     * @param _from The address that owns the tokens to be burned\n', '     * @param _value The amount of tokens to be burned\n', '     * @return Whether the tokens where sucessfully burned or not\n', '     */\n', '    function burn(address _from, uint _value) public only_owner safe_arguments(2) returns (bool) {\n', '\n', '        // Check if the token owner has enough tokens\n', '        require(balances[_from] >= _value);\n', '\n', '        // Check for overflows\n', '        require(balances[_from] - _value <= balances[_from]);\n', '\n', '        // Burn tokens\n', '        balances[_from] -= _value;\n', '        totalTokenSupply -= _value;\n', '\n', '        // Notify listeners \n', '        Transfer(_from, 0, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * ATM Security token (KATM)\n', ' *\n', ' * KATM maintaining the primary security functions of the ATM token as \n', ' * outlined within the whitepaper.\n', ' *\n', ' * Those who bear ATMS will be entitled to profit sharing in the form of dividends, \n', ' * and is considered the "Security" token.\n', ' *\n', ' * #created 30/10/2017\n', ' * #author Frank Bonnet\n', ' */\n', 'contract KATMToken is ManagedToken, Observable, TokenRetriever {\n', '\n', '    \n', '    /**\n', '     * Construct the managed security token\n', '     */\n', '    function KATMToken() public ManagedToken("KATM Security", "KATM", 8, false) {}\n', '\n', '\n', '    /**\n', '     * Returns whether sender is allowed to register `_observer`\n', '     *\n', '     * @param _observer The address to register as an observer\n', '     * @return Whether the sender is allowed or not\n', '     */\n', '    function canRegisterObserver(address _observer) internal view returns (bool) {\n', '        return _observer != address(this) && isOwner(msg.sender);\n', '    }\n', '\n', '\n', '    /**\n', '     * Returns whether sender is allowed to unregister `_observer`\n', '     *\n', '     * @param _observer The address to unregister as an observer\n', '     * @return Whether the sender is allowed or not\n', '     */\n', '    function canUnregisterObserver(address _observer) internal view returns (bool) {\n', '        return msg.sender == _observer || isOwner(msg.sender);\n', '    }\n', '\n', '\n', '    /** \n', '     * Send `_value` token to `_to` from `msg.sender`\n', '     * - Notifies registered observers when the observer receives tokens\n', '     * \n', '     * @param _to The address of the recipient\n', '     * @param _value The amount of token to be transferred\n', '     * @return Whether the transfer was successful or not\n', '     */\n', '    function transfer(address _to, uint _value) public returns (bool) {\n', '        bool result = super.transfer(_to, _value);\n', '        if (isObserver(_to)) {\n', '            ITokenObserver(_to).notifyTokensReceived(msg.sender, _value);\n', '        }\n', '\n', '        return result;\n', '    }\n', '\n', '\n', '    /** \n', '     * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '     * - Notifies registered observers when the observer receives tokens\n', '     * \n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value The amount of token to be transferred\n', '     * @return Whether the transfer was successful or not\n', '     */\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool) {\n', '        bool result = super.transferFrom(_from, _to, _value);\n', '        if (isObserver(_to)) {\n', '            ITokenObserver(_to).notifyTokensReceived(_from, _value);\n', '        }\n', '\n', '        return result;\n', '    }\n', '\n', '\n', '    /**\n', '     * Failsafe mechanism\n', '     * \n', '     * Allows the owner to retrieve tokens from the contract that \n', '     * might have been send there by accident\n', '     *\n', '     * @param _tokenContract The address of ERC20 compatible token\n', '     */\n', '    function retrieveTokens(address _tokenContract) public only_owner {\n', '        super.retrieveTokens(_tokenContract);\n', '    }\n', '\n', '\n', '    /**\n', '     * Prevents the accidental sending of ether\n', '     */\n', '    function () public payable {\n', '        revert();\n', '    }\n', '}']