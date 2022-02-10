['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-20\n', '*/\n', '\n', 'pragma solidity ^0.4.26;\n', '\n', '\n', '\n', '\n', 'contract SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function safeAdd(uint256 a, uint256 b) public pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function safeSub(uint256 a, uint256 b) public pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '\n', '}\n', '\n', '\n', 'contract TGBT is SafeMath {\n', '      \n', '    \n', '    \n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;\n', '  \n', '    uint256 public totalSupply;\n', '\n', '  \n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint256 value);\n', '\n', '\n', '    constructor (uint256 initialSupply, string tokenName, string tokenSymbol) public {\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount\n', '        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens\n', '        name = tokenName;                                   // Set the name for display purposes\n', '        symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '    }\n', '    \n', '    \n', '    /**\n', '     * _transfer Moves tokens `_value` from `_from` to `_to`.\n', '     *     \n', '     * \n', '     * Emits a {Transfer} event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `_from` cannot be the zero address.\n', '     * - `_to` cannot be the zero address.\n', '     * - `_from` must have a balance of at least `_value`.\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require(_from != 0x0);\n', '        require(_to != 0x0);\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '       // no need  uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        balanceOf[_from] = safeSub(balanceOf[_from],_value); // subtract from sender\n', '        balanceOf[_to] = safeAdd(balanceOf[_to],_value); // add the same to the reciptient\n', '        emit Transfer(_from, _to, _value);\n', '      // no need   assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '    \n', '    \n', '    \n', '   /**\n', '     * _approve Sets `amount` as the allowance of `spender` over the `owner` s tokens.\n', '     *\n', '     *\n', '     * Emits an {Approval} event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `owner` cannot be the zero address.\n', '     * - `spender` cannot be the zero address.\n', '     */\n', '    function _approve(address owner, address spender, uint256 amount) internal  {\n', '        require(owner != 0x0);\n', '        require(spender != 0x0);\n', '\n', '        allowance[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '    /**\n', '     *transfer\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `_to` cannot be the zero address.\n', '     * - the caller must have a balance of at least `_value`.\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * transferFrom\n', '     *\n', '     * Emits an {Approval} event indicating the updated allowance.\n', '     * \n', '     * Requirements:\n', '     *\n', '     * - `_from` and `_to` cannot be the zero address.\n', '     * - `_from` must have a balance of at least `_value`.\n', "     * - the caller must have allowance for ``_from``'s tokens of at least\n", '     * `_value`.\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        _approve(_from, msg.sender, safeSub(allowance[_from][msg.sender],_value));\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '   /**\n', '     * approve\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `_spender` cannot be the zero address.\n', '     */\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        _approve(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '   /**\n', '     * increaseAllowance\n', '     *\n', '     *\n', '     * Emits an {Approval} event indicating the updated allowance.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `_spender` cannot be the zero address.\n', '     */\n', '     \n', '    function increaseAllowance(address _spender, uint256 addedValue) public  returns (bool) {\n', '        _approve(msg.sender, _spender, safeAdd(allowance[msg.sender][_spender],addedValue));\n', '        return true;\n', '    }\n', '\n', '   /**\n', '     * decreaseAllowance\n', '     *\n', '     *\n', '     * Emits an {Approval} event indicating the updated allowance.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `_spender` cannot be the zero address.\n', '     * - `spender` must have allowance for the caller of at least\n', '     * `subtractedValue`.\n', '     */\n', '    function decreaseAllowance(address _spender, uint256 subtractedValue) public  returns (bool) {\n', '        _approve(msg.sender, _spender, safeSub(allowance[msg.sender][_spender],subtractedValue));\n', '        return true;\n', '    }\n', '\n', '   /**\n', '     * burn  \n', '     * Destroys `_value` tokens from the caller.\n', '     *\n', '     */\n', '    function burn(uint256 _value) public returns (bool) {\n', '        require(balanceOf[msg.sender] >= _value);                              // Check if the sender has enough\n', '        balanceOf[msg.sender] = safeSub(balanceOf[msg.sender],_value);            // Subtract from the sender\n', '        totalSupply = safeSub(totalSupply,_value);                               // Updates totalSupply\n', '        emit  Transfer(msg.sender, address(0), _value);\n', '        return true;\n', '    }\n', '\n', '   /**\n', '     * burnFrom\n', "     * Destroys `_value` tokens from `_from`, deducting from the caller's\n", '     * allowance.\n', '     *\n', '     *\n', '     * Requirements:\n', '     *\n', "     * - the caller must have allowance for ``_from``'s tokens of at least\n", '     * `_value`.\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool) {\n', '        require(_value <= allowance[_from][msg.sender]);                         // Check allowance\n', '        require(balanceOf[_from] >= _value); // Check if the targeted balance is enough\n', '        \n', '        uint256 decreasedAllowance = safeSub(allowance[_from][msg.sender],_value);\n', '        _approve(_from, msg.sender,decreasedAllowance);\n', '        balanceOf[_from] = safeSub(balanceOf[_from],_value);                         // Subtract from the targeted balance\n', '        totalSupply = safeSub(totalSupply,_value) ;                                  // Update totalSupply\n', '        emit Transfer(_from, address(0), _value);\n', '        return true;\n', '    }\n', '}']