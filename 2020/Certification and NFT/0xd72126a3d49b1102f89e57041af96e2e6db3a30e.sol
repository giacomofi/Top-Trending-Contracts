['pragma solidity 0.6.4;\n', '\n', '\n', 'interface IERC20 {\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', ' \n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', '\n', 'contract SWAPCONTRACT{\n', '    \n', '   using SafeMath for uint256;\n', '    \n', '   address public V1;\n', '   address public V2;\n', '   bool swapEnabled;\n', '   address administrator;\n', '   \n', '   constructor() public {\n', '       \n', '\t    administrator = msg.sender;\n', '\t\tswapEnabled = false;\n', '\t\t\n', '\t}\n', '\t\n', '//======================================ADMINSTRATION=========================================//\n', '\n', '\tmodifier onlyCreator() {\n', '        require(msg.sender == administrator, "Ownable: caller is not the administrator");\n', '        _;\n', '    }\n', '   \n', '   function tokenConfig(address _v1Address, address _v2Address) public onlyCreator returns(bool){\n', '       require(_v1Address != address(0) && _v2Address != address(0), "Invalid address has been set");\n', '       V1 = _v1Address;\n', '       V2 = _v2Address;\n', '       return true;\n', '       \n', '   }\n', '   \n', '   \n', '   function swapStatus(bool _status) public onlyCreator returns(bool){\n', '       require(V1 != address(0) && V2 != address(0), "V1 and V2 addresses are not set up yet");\n', '       swapEnabled = _status;\n', '   }\n', '   \n', '   \n', '   \n', '   \n', '   function swap(uint256 _amount) external returns(bool){\n', '       \n', '       require(swapEnabled, "Swap not yet initialized");\n', '       require(_amount > 0, "Invalid amount to swap");\n', '       require(IERC20(V1).balanceOf(msg.sender) >= _amount, "You cannot swap more than what you hold");\n', '       require(IERC20(V2).balanceOf(address(this)) >= _amount, "Insufficient amount of tokens to be swapped for");\n', '       require(IERC20(V1).allowance(msg.sender, address(this)) >= _amount, "Insufficient allowance given to contract");\n', '       \n', '       require(IERC20(V1).transferFrom(msg.sender, address(this), _amount), "Transaction failed on root");\n', '       require(IERC20(V2).transfer(msg.sender, _amount), "Transaction failed from base");\n', '       \n', '       return true;\n', '       \n', '   }\n', '   \n', '   function swapAll() external returns(bool){\n', '       \n', '       require(swapEnabled, "Swap not yet initialized");\n', '       uint v1userbalance = IERC20(V1).balanceOf(msg.sender);\n', '       uint v2contractbalance = IERC20(V2).balanceOf(address(this));\n', '       \n', '       require(v1userbalance > 0, "You cannot swap on zero balance");\n', '       require(v2contractbalance >= v1userbalance, "Insufficient amount of tokens to be swapped for");\n', '       require(IERC20(V1).allowance(msg.sender, address(this)) >= v1userbalance, "Insufficient allowance given to contract");\n', '       \n', '       require(IERC20(V1).transferFrom(msg.sender, address(this), v1userbalance), "Transaction failed on root");\n', '       require(IERC20(V2).transfer(msg.sender, v1userbalance), "Transaction failed from base");\n', '       \n', '       return true;\n', '       \n', '   }\n', '   \n', '   \n', '   function GetLeftOverV1() public onlyCreator returns(bool){\n', '      \n', '      require(administrator != address(0));\n', '      require(administrator != address(this));\n', '      require(V1 != address(0) && V2 != address(0), "V1 address not set up yet");\n', '      uint bal = IERC20(V1).balanceOf(address(this));\n', '      require(IERC20(V1).transfer(administrator, bal), "Transaction failed");\n', '      \n', '  }\n', '  \n', '  function GetLeftOverV2() public onlyCreator returns(bool){\n', '      \n', '      require(administrator != address(0));\n', '      require(administrator != address(this));\n', '      require(V1 != address(0) && V2 != address(0), "V1 address not set up yet");\n', '      uint bal = IERC20(V2).balanceOf(address(this));\n', '      require(IERC20(V2).transfer(administrator, bal), "Transaction failed");\n', '      \n', '  }\n', '   \n', '    \n', '}']