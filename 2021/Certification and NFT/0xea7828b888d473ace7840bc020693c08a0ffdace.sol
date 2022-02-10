['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-23\n', '*/\n', '\n', 'pragma solidity ^0.6.6;\n', '\n', '/**\n', ' * licence MIT university 2020.\n', ' */\n', '\n', 'interface IERC20 {\n', '\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'contract THCfreeFarm is IERC20 {\n', '\n', '    string public constant name = "THCfreeFarm";\n', '    string public constant symbol = "THCF";\n', '    uint8 public constant decimals = 18;\n', '\n', '\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    mapping(address => mapping (address => uint256)) allowed;\n', '\n', '    uint256 totalSupply_;\n', '\n', '    using SafeMath for uint256;\n', '\n', '\n', '   constructor(uint256 total) public {\n', '    totalSupply_ = total;\n', '    balances[msg.sender] = totalSupply_;\n', '    }\n', '\n', '    function totalSupply() public override view returns (uint256) {\n', '    return totalSupply_;\n', '    }\n', '\n', '    function balanceOf(address tokenOwner) public override view returns (uint256) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    function transfer(address receiver, uint256 numTokens) public override returns (bool) {\n', '        require(numTokens <= balances[msg.sender]);\n', '        balances[msg.sender] = balances[msg.sender].sub(numTokens);\n', '        balances[receiver] = balances[receiver].add(numTokens);\n', '        emit Transfer(msg.sender, receiver, numTokens);\n', '        return true;\n', '    }\n', '\n', '    function approve(address delegate, uint256 numTokens) public override returns (bool) {\n', '        allowed[msg.sender][delegate] = numTokens;\n', '        emit Approval(msg.sender, delegate, numTokens);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address owner, address delegate) public override view returns (uint) {\n', '        return allowed[owner][delegate];\n', '    }\n', '\n', '    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool) {\n', '        require(numTokens <= balances[owner]);\n', '        require(numTokens <= allowed[owner][msg.sender]);\n', '\n', '        balances[owner] = balances[owner].sub(numTokens);\n', '        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);\n', '        balances[buyer] = balances[buyer].add(numTokens);\n', '        emit Transfer(owner, buyer, numTokens);\n', '        return true;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '      assert(b <= a);\n', '      return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '      uint256 c = a + b;\n', '      assert(c >= a);\n', '      return c;\n', '    }\n', '     /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '   \n', '}']