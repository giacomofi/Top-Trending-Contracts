['pragma solidity ^0.4.16;\n', '\n', 'interface tokenRecipient { \n', '    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;\n', '}\n', '\n', 'contract TokenERC20 {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;\n', '    uint256 public totalSupply;\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    // Triggered when tokens are transferred.\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    // Triggered when spending allowance is set.\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    /**\n', '     * Constructor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    function TokenERC20(uint256 _initialSupply, string _tokenName, string _tokenSymbol) internal {\n', '        totalSupply = _initialSupply * 10 ** uint256(decimals);\n', '        balanceOf[msg.sender] = totalSupply;\n', '        name = _tokenName;\n', '        symbol = _tokenSymbol;\n', '    }\n', '\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require(_to != 0x0);\n', '\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '\n', '        // Perform the transfer\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` in behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);\n', '\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        require(_spender != 0x0);\n', '\n', '        allowance[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (!approve(_spender, _value)) {\n', '            return false;\n', '        }\n', '\n', '        spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '\n', '    function Owned() internal {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) onlyOwner public {\n', '        owner = _newOwner;\n', '    }\n', '}\n', '\n', 'contract WMCToken is Owned, TokenERC20 {\n', '    address public clearing;\n', '\n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    // Triggered when account freeze status changes.\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    // Triggered when tokens are burnt.\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    function WMCToken() TokenERC20(20000000, "Weekend Millionaires Club Token", "WMC") public {\n', '        clearing = 0x0;\n', '    }\n', '\n', '    function freezeAccount(address _target, bool _freeze) onlyOwner public {\n', '        require(_target != 0x0);\n', '\n', '        frozenAccount[_target] = _freeze;\n', '        FrozenFunds(_target, _freeze);\n', '    }\n', '\n', '    function transferClearingFunction(address _clearing) onlyOwner public {\n', '        clearing = _clearing;\n', '    }\n', '\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (clearing == 0x0 || clearing == _from || clearing == _to);\n', '\n', '        require(!frozenAccount[_from]);\n', '        require(!frozenAccount[_to]);\n', '\n', '        super._transfer(_from, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) onlyOwner public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '\n', '        balanceOf[msg.sender] -= _value;\n', '        totalSupply -= _value;\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);\n', '        require(_value <= allowance[_from][msg.sender]);\n', '\n', '        balanceOf[_from] -= _value;\n', '        allowance[_from][msg.sender] -= _value;\n', '        totalSupply -= _value;\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '}']