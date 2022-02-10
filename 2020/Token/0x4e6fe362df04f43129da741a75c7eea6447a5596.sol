['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, "SafeMath: division by zero");\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', '/******************************************/\n', '/*      TOKEN INSTANCE STARTS HERE       */\n', '/******************************************/\n', '\n', 'contract Token {\n', '    \n', '    using SafeMath for uint256;\n', '    \n', '    //variables of the token, EIP20 standard\n', '    string public name = "Exodus Computing Networks";\n', '    string public symbol = "DUS";\n', '    uint256 public decimals = 10; // 18 decimals is the strongly suggested default, avoid changing it\n', '    uint256 public totalSupply = uint256(330000000).mul(uint256(10) ** decimals);\n', '    \n', '    address ZERO_ADDR = address(0x0000000000000000000000000000000000000000);\n', '    address payable public creator; // for destruct contract\n', '\n', '    // mapping structure\n', '    mapping (address => uint256) public balanceOf;  //eip20\n', '    mapping (address => mapping (address => uint256)) public allowance; //eip20\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event Transfer(address indexed from, address indexed to, uint256 token);  //eip20\n', '    event Approval(address indexed owner, address indexed spender, uint256 token);   //eip20\n', '    \n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    // constructor (string memory _name, string memory _symbol, uint256 _total, uint256 _decimals) public {\n', '    constructor () public {\n', '        // name = _name;\n', '        // symbol = _symbol;\n', '        // totalSupply = _total.mul(uint256(10) ** _decimals);\n', '        // decimals = _decimals;\n', '        creator = msg.sender;\n', '        balanceOf[creator] = totalSupply;\n', '        emit Transfer(ZERO_ADDR, msg.sender, totalSupply);\n', '    }\n', '    \n', '    /* Internal transfer, only can be called by this contract */\n', '    function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {\n', '        // prevent 0 and attack!\n', "        require(_value > 0 && _value <= totalSupply, 'Invalid token amount to transfer!');\n", '\n', "        require(_to != ZERO_ADDR, 'Cannot send to ZERO address!'); \n", '        require(_from != _to, "Cannot send token to yourself!");\n', '        require (balanceOf[_from] >= _value, "No enough token to transfer!");   \n', '\n', '        // update balance before transfer\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', "    // Transfer the balance from token owner's account to to account\n", "    // - Owner's account must have sufficient balance to transfer\n", '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint256 token) public returns (bool success) {\n', '        return _transfer(msg.sender, to, token);\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for spender to transferFrom(...) tokens\n', "    // from the token owner's account\n", '    //\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces \n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint256 token) public returns (bool success) {\n', '        require(spender != ZERO_ADDR);\n', '        require(balanceOf[msg.sender] >= token, "No enough balance to approve!");\n', '        // prevent state race attack\n', '        require(allowance[msg.sender][spender] == 0 || token == 0, "Invalid allowance state!");\n', '        allowance[msg.sender][spender] = token;\n', '        emit Approval(msg.sender, spender, token);\n', '        return true;\n', '    }\n', '\t\n', '    // ------------------------------------------------------------------------\n', '    // Transfer tokens from the from account to the to account\n', '    // \n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the from account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint256 token) public returns (bool success) {\n', '        require(allowance[from][msg.sender] >= token, "No enough allowance to transfer!");\n', '        allowance[from][msg.sender] = allowance[from][msg.sender].sub(token);\n', '        _transfer(from, to, token);\n', '        return true;\n', '    }\n', '    \n', '    //destroy this contract\n', '    function destroy() public {\n', '        require(msg.sender == creator, "You\'re not creator!");\n', '        selfdestruct(creator);\n', '    }\n', '\n', '    //Fallback: reverts if Ether is sent to this smart contract by mistake\n', '    fallback() external {\n', '  \t    revert();\n', '    }\n', '}']