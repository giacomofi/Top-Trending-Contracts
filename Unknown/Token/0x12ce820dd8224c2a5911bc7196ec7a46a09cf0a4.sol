['pragma solidity ^0.4.16;\n', '\n', '\n', '/**\n', ' * @title Contract owner definition\n', ' */\n', 'contract Owned {\n', '\n', '    /* Owner&#39;s address */\n', '    address owner;\n', '\n', '    /**\n', '     * @dev Constructor, records msg.sender as contract owner\n', '     */\n', '    function Owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Validates if msg.sender is an owner\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '}\n', '\n', '/** \n', ' * @title Standard token interface (ERC 20)\n', ' * \n', ' * https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'interface ERC20 {\n', '    \n', '// Functions:\n', '    \n', '    /**\n', '     * @return total amount of tokens\n', '     */\n', '    function totalSupply() constant returns (uint256);\n', '\n', '    /** \n', '     * @param _owner The address from which the balance will be retrieved\n', '     * @return The balance\n', '     */\n', '    function balanceOf(address _owner) constant returns (uint256);\n', '\n', '    /** \n', '     * @notice send `_value` token to `_to` from `msg.sender`\n', '     * \n', '     * @param _to The address of the recipient\n', '     * @param _value The amount of token to be transferred\n', '     * @return Whether the transfer was successful or not\n', '     */\n', '    function transfer(address _to, uint256 _value) returns (bool);\n', '\n', '    /** \n', '     * @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '     * \n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value The amount of token to be transferred\n', '     * @return Whether the transfer was successful or not\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool);\n', '\n', '    /** \n', '     * @notice `msg.sender` approves `_addr` to spend `_value` tokens\n', '     * \n', '     * @param _spender The address of the account able to transfer the tokens\n', '     * @param _value The amount of wei to be approved for transfer\n', '     * @return Whether the approval was successful or not\n', '     */\n', '    function approve(address _spender, uint256 _value) returns (bool);\n', '\n', '    /** \n', '     * @param _owner The address of the account owning tokens\n', '     * @param _spender The address of the account able to transfer the tokens\n', '     * @return Amount of remaining tokens allowed to spent\n', '     */\n', '    function allowance(address _owner, address _spender) constant returns (uint256);\n', '\n', '// Events:\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Implementation of ERC 20 interface with holders list\n', ' */\n', 'contract Token is ERC20 {\n', '\n', '    /// Name of the token\n', '    string public name;\n', '    /// Token symbol\n', '    string public symbol;\n', '\n', '    /// Fixed point description\n', '    uint8 public decimals;\n', '\n', '    /// Qty of supplied tokens\n', '    uint256 public totalSupply;\n', '\n', '    /// Token holders list\n', '    address[] public holders;\n', '    /* address => index in array of hodlers, index starts from 1 */\n', '    mapping(address => uint256) index;\n', '\n', '    /* Token holders map */\n', '    mapping(address => uint256) balances;\n', '    /* Token transfer approvals */\n', '    mapping(address => mapping(address => uint256)) allowances;\n', '\n', '    /**\n', '     * @dev Constructs Token with given `_name`, `_symbol` and `_decimals`\n', '     */\n', '    function Token(string _name, string _symbol, uint8 _decimals) {\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '    }\n', '\n', '    /**\n', '     * @dev Get balance of given address\n', '     *\n', '     * @param _owner The address to request balance from\n', '     * @return The balance\n', '     */\n', '    function balanceOf(address _owner) constant returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer own tokens to given address\n', '     * @notice send `_value` token to `_to` from `msg.sender`\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value The amount of token to be transferred\n', '     * @return Whether the transfer was successful or not\n', '     */\n', '    function transfer(address _to, uint256 _value) returns (bool) {\n', '\n', '        // balance check\n', '        if (balances[msg.sender] >= _value) {\n', '\n', '            // transfer\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '\n', '            // push new holder if _value > 0\n', '            if (_value > 0 && index[_to] == 0) {\n', '                index[_to] = holders.push(_to);\n', '            }\n', '\n', '            Transfer(msg.sender, _to, _value);\n', '\n', '            return true;\n', '        }\n', '\n', '        return false;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens between addresses using approvals\n', '     * @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value The amount of token to be transferred\n', '     * @return Whether the transfer was successful or not\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '\n', '        // approved balance check\n', '        if (allowances[_from][msg.sender] >= _value &&\n', '            balances[_from] >= _value ) {\n', '\n', '            // hit approved amount\n', '            allowances[_from][msg.sender] -= _value;\n', '\n', '            // transfer\n', '            balances[_from] -= _value;\n', '            balances[_to] += _value;\n', '\n', '            // push new holder if _value > 0\n', '            if (_value > 0 && index[_to] == 0) {\n', '                index[_to] = holders.push(_to);\n', '            }\n', '\n', '            Transfer(_from, _to, _value);\n', '\n', '            return true;\n', '        }\n', '\n', '        return false;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve token transfer with specific amount\n', '     * @notice `msg.sender` approves `_addr` to spend `_value` tokens\n', '     *\n', '     * @param _spender The address of the account able to transfer the tokens\n', '     * @param _value The amount of wei to be approved for transfer\n', '     * @return Whether the approval was successful or not\n', '     */\n', '    function approve(address _spender, uint256 _value) returns (bool) {\n', '        allowances[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Get amount of tokens approved for transfer\n', '     *\n', '     * @param _owner The address of the account owning tokens\n', '     * @param _spender The address of the account able to transfer the tokens\n', '     * @return Amount of remaining tokens allowed to spent\n', '     */\n', '    function allowance(address _owner, address _spender) constant returns (uint256) {\n', '        return allowances[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * @dev Convenient way to reset approval for given address, not a part of ERC20\n', '     *\n', '     * @param _spender the address\n', '     */\n', '    function unapprove(address _spender) {\n', '        allowances[msg.sender][_spender] = 0;\n', '    }\n', '\n', '    /**\n', '     * @return total amount of tokens\n', '     */\n', '    function totalSupply() constant returns (uint256) {\n', '        return totalSupply;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns count of token holders\n', '     */\n', '    function holderCount() constant returns (uint256) {\n', '        return holders.length;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Cat&#39;s Token, miaow!!!\n', ' *\n', ' * @dev Defines token with name "Cat&#39;s Token", symbol "CTS"\n', ' * and 3 digits after the point\n', ' */\n', 'contract Cat is Token("Cat&#39;s Token", "CTS", 3), Owned {\n', '\n', '    /**\n', '     * @dev Emits specified number of tokens. Only owner can emit.\n', '     * Emitted tokens are credited to owner&#39;s account\n', '     *\n', '     * @param _value number of emitting tokens\n', '     * @return true if emission succeeded, false otherwise\n', '     */\n', '    function emit(uint256 _value) onlyOwner returns (bool) {\n', '\n', '        // overflow check\n', '        assert(totalSupply + _value >= totalSupply);\n', '\n', '        // emission\n', '        totalSupply += _value;\n', '        balances[owner] += _value;\n', '\n', '        return true;\n', '    }\n', '}']