['pragma solidity ^0.4.16;\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '\n', '\n', '\n', 'contract ITUTokenERC20 is owned {\n', '    // Public variables of the token\n', '    string public name = "iTrue";\n', '    string public symbol = "ITU";\n', '    uint8 public decimals = 18;\n', '    // 18 decimals is the strongly suggested default, avoid changing it\n', '    uint256 public totalSupply;\n', '\n', '    string public version = "0.1";\n', '\n', '    bool public canTransfer = false;\n', '\n', '    struct HoldBalance{\n', '        uint256 amount;\n', '        uint256 timeEnd;\n', '    }\n', '\n', '    // This creates an array with all balances\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    mapping (address => HoldBalance) public holdBalances;\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    // This notifies clients about the amount burnt\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    /**\n', '  * @dev Fix for the ERC20 short address attack.\n', '   */\n', '    modifier onlyPayloadSize(uint size) {\n', '        require(msg.data.length >= 32 * size + 4) ;\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    constructor() public {\n', '        uint128 initialSupply = 8000000000;\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount\n', '        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens\n', '        name = "iTrue";                                   // Set the name for display purposes\n', '        symbol = "ITU";                               // Set the symbol for display purposes\n', '    }\n', '\n', '    function tstart() onlyOwner public {\n', '        canTransfer = true;\n', '    }\n', '\n', '    function tstop() onlyOwner public {\n', '        canTransfer = false;\n', '    }\n', '\n', '    function availableBalance(address _owner) internal constant returns(uint256) {\n', '        if (holdBalances[_owner].timeEnd <= now) {\n', '            return balanceOf[_owner];\n', '        } else {\n', '            assert(balanceOf[_owner] >= holdBalances[_owner].amount);\n', '            return balanceOf[_owner] - holdBalances[_owner].amount;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require(canTransfer);\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '\n', '        require(availableBalance(_from) >= _value);\n', '\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    function transferF(address _from, address _to, uint256 _value) onlyOwner onlyPayloadSize(3) public returns (bool success) {\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferHold(address _from, address _to, uint256 _value, uint256 _hold, uint256 _expire) onlyOwner onlyPayloadSize(5) public returns (bool success) {\n', '        require(_hold <= _value);\n', '        // transfer first\n', '        _transfer(_from, _to, _value);\n', '        // now hold\n', '        holdBalances[_to] = HoldBalance(_hold, _expire);\n', '        return true;\n', '    }\n', '\n', '    function setHold(address _owner, uint256 _hold, uint256 _expire) onlyOwner onlyPayloadSize(3) public returns (bool success) {\n', '        holdBalances[_owner] = HoldBalance(_hold, _expire);\n', '        return true;\n', '    }\n', '\n', '    // --------------\n', '    function getB(address _owner) onlyOwner onlyPayloadSize(1) public constant returns (uint256 balance) {\n', '        return availableBalance(_owner);\n', '    }\n', '\n', '    function getHold(address _owner) onlyOwner onlyPayloadSize(1) public constant returns (uint256 hold, uint256 holdt, uint256 n) {\n', '        return (holdBalances[_owner].amount, holdBalances[_owner].timeEnd, now);\n', '    }\n', '    // --------------\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) onlyPayloadSize(2) public returns (bool success) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` in behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) onlyPayloadSize(2) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) onlyPayloadSize(2) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', "        allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance\n", '        totalSupply -= _value;                              // Update totalSupply\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '}']