['pragma solidity ^0.4.19;\n', '\n', '/**\n', ' * ERC 20 token\n', ' * https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'interface Token {\n', '\n', '    /// @return total amount of tokens\n', '    /// function totalSupply() public constant returns (uint256 supply);\n', '    /// do not declare totalSupply() here, see https://github.com/OpenZeppelin/zeppelin-solidity/issues/434\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_addr` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of wei to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '}\n', '\n', '\n', '/** @title PROVISIONAL SMART CONTRACT for Fluzcoin (FFC) **/\n', '\n', 'contract Fluzcoin is Token {\n', '\n', '    string public constant name = "Fluzcoin";\n', '    string public constant symbol = "FFC";\n', '    uint8 public constant decimals = 18;\n', '    uint256 public constant totalSupply = 3223000000 * 10**18;\n', '\n', '    uint public launched = 0; // Time of locking distribution and retiring founder; 0 means not launched\n', '    address public founder = 0xCB7ECAB8EEDd4b53d0F48E421D56fBA262AF57FC; // Founder&#39;s address\n', '    mapping (address => uint256) public balances;\n', '    mapping (address => mapping (address => uint256)) public allowed;\n', '    \n', '    bool public transfersAreLocked = true;\n', '\n', '    function Fluzcoin() public {\n', '        balances[founder] = totalSupply;\n', '        Transfer(0x0, founder, totalSupply);\n', '    }\n', '    \n', '    /**\n', '     * Modifier to check whether transfers are unlocked or the owner is sending\n', '     */\n', '    modifier canTransfer() {\n', '        require(msg.sender == founder || !transfersAreLocked);\n', '        _;\n', '    }\n', '    \n', '    /**\n', '     * Modifier to allow only founder to transfer\n', '     */\n', '    modifier onlyFounder() {\n', '        require(msg.sender == founder);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Transfer with checking if it&#39;s allowed\n', '     */\n', '    function transfer(address _to, uint256 _value) public canTransfer returns (bool success) {\n', '        if (balances[msg.sender] < _value) {\n', '            return false;\n', '        }\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Transfer with checking if it&#39;s allowed\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public canTransfer returns (bool success) {\n', '        if (balances[_from] < _value || allowed[_from][msg.sender] < _value) {\n', '            return false;\n', '        }\n', '        allowed[_from][msg.sender] -= _value;\n', '        balances[_from] -= _value;\n', '        balances[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Default balanceOf function\n', '     */\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /**\n', '     * Default approval function\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Get user allowance\n', '     */\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * Launch and retire the founder \n', '     */\n', '    function launch() public onlyFounder {\n', '        launched = block.timestamp;\n', '        founder = 0x0;\n', '    }\n', '    \n', '    /**\n', '     * Change transfer locking state\n', '     */\n', '    function changeTransferLock(bool locked) public onlyFounder {\n', '        transfersAreLocked = locked;\n', '    }\n', '\n', '    function() public { // no direct purchases\n', '        revert();\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.19;\n', '\n', '/**\n', ' * ERC 20 token\n', ' * https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'interface Token {\n', '\n', '    /// @return total amount of tokens\n', '    /// function totalSupply() public constant returns (uint256 supply);\n', '    /// do not declare totalSupply() here, see https://github.com/OpenZeppelin/zeppelin-solidity/issues/434\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_addr` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of wei to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '}\n', '\n', '\n', '/** @title PROVISIONAL SMART CONTRACT for Fluzcoin (FFC) **/\n', '\n', 'contract Fluzcoin is Token {\n', '\n', '    string public constant name = "Fluzcoin";\n', '    string public constant symbol = "FFC";\n', '    uint8 public constant decimals = 18;\n', '    uint256 public constant totalSupply = 3223000000 * 10**18;\n', '\n', '    uint public launched = 0; // Time of locking distribution and retiring founder; 0 means not launched\n', "    address public founder = 0xCB7ECAB8EEDd4b53d0F48E421D56fBA262AF57FC; // Founder's address\n", '    mapping (address => uint256) public balances;\n', '    mapping (address => mapping (address => uint256)) public allowed;\n', '    \n', '    bool public transfersAreLocked = true;\n', '\n', '    function Fluzcoin() public {\n', '        balances[founder] = totalSupply;\n', '        Transfer(0x0, founder, totalSupply);\n', '    }\n', '    \n', '    /**\n', '     * Modifier to check whether transfers are unlocked or the owner is sending\n', '     */\n', '    modifier canTransfer() {\n', '        require(msg.sender == founder || !transfersAreLocked);\n', '        _;\n', '    }\n', '    \n', '    /**\n', '     * Modifier to allow only founder to transfer\n', '     */\n', '    modifier onlyFounder() {\n', '        require(msg.sender == founder);\n', '        _;\n', '    }\n', '\n', '    /**\n', "     * Transfer with checking if it's allowed\n", '     */\n', '    function transfer(address _to, uint256 _value) public canTransfer returns (bool success) {\n', '        if (balances[msg.sender] < _value) {\n', '            return false;\n', '        }\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', "     * Transfer with checking if it's allowed\n", '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public canTransfer returns (bool success) {\n', '        if (balances[_from] < _value || allowed[_from][msg.sender] < _value) {\n', '            return false;\n', '        }\n', '        allowed[_from][msg.sender] -= _value;\n', '        balances[_from] -= _value;\n', '        balances[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Default balanceOf function\n', '     */\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /**\n', '     * Default approval function\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Get user allowance\n', '     */\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * Launch and retire the founder \n', '     */\n', '    function launch() public onlyFounder {\n', '        launched = block.timestamp;\n', '        founder = 0x0;\n', '    }\n', '    \n', '    /**\n', '     * Change transfer locking state\n', '     */\n', '    function changeTransferLock(bool locked) public onlyFounder {\n', '        transfersAreLocked = locked;\n', '    }\n', '\n', '    function() public { // no direct purchases\n', '        revert();\n', '    }\n', '\n', '}']
