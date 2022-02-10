['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-29\n', '*/\n', '\n', '/***\n', '* MIT License\n', '* ===========\n', '*\n', '* Copyright (c) 2021 HADA\n', '*\n', '* Permission is hereby granted, free of charge, to any person obtaining a copy\n', '* of this software and associated documentation files (the "Software"), to deal\n', '* in the Software without restriction, including without limitation the rights\n', '* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\n', '* copies of the Software, and to permit persons to whom the Software is\n', '* furnished to do so, subject to the following conditions:\n', '*\n', '* The above copyright notice and this permission notice shall be included in all\n', '* copies or substantial portions of the Software.\n', '*\n', '* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n', '* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n', '* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n', '* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n', '* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n', '* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\n', '*/\n', '// File: @openzeppelin/contracts/math/SafeMath.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/token/ERC20/IERC20.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP. Does not include\n', ' * the optional functions; to access them see {ERC20Detailed}.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '/**\n', ' * @dev Optional functions from the ERC20 standard.\n', ' */\n', 'contract ERC20Detailed is IERC20 {\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '\n', '    /**\n', '     * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of\n', '     * these values are immutable: they can only be set once during\n', '     * construction.\n', '     */\n', '    constructor (string memory name, string memory symbol, uint8 decimals) public {\n', '        _name = name;\n', '        _symbol = symbol;\n', '        _decimals = decimals;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the name of the token.\n', '     */\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the symbol of the token, usually a shorter version of the\n', '     * name.\n', '     */\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the number of decimals used to get its user representation.\n', '     * For example, if `decimals` equals `2`, a balance of `505` tokens should\n', '     * be displayed to a user as `5,05` (`505 / 10 ** 2`).\n', '     *\n', '     * Tokens usually opt for a value of 8, imitating the relationship between\n', '     * Ether and Wei.\n', '     *\n', '     * NOTE: This information is only used for _display_ purposes: it in\n', '     * no way affects any of the arithmetic of the contract, including\n', '     * {IERC20-balanceOf} and {IERC20-transfer}.\n', '     */\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '}\n', '\n', '// File: contracts/library/Governance.sol\n', '\n', 'pragma solidity ^0.5.5;\n', '\n', 'contract Governance {\n', '\n', '    address public governance;\n', '\n', '    constructor() public {\n', '        governance = tx.origin;\n', '    }\n', '\n', '    event GovernanceTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    modifier onlyGovernance {\n', '        require(msg.sender == governance, "not governance");\n', '        _;\n', '    }\n', '\n', '    function setGovernance(address _governance)  public  onlyGovernance\n', '    {\n', '        require(_governance != address(0), "new governance the zero address");\n', '        emit GovernanceTransferred(governance, _governance);\n', '        governance = _governance;\n', '    }\n', '\n', '\n', '\n', '}\n', '\n', '// File: contracts/token/HADAToken.sol\n', '\n', 'pragma solidity ^0.5.5;\n', '\n', '/// @title HADAToken Contract\n', '\n', 'contract HADAToken is Governance, ERC20Detailed{\n', '\n', '    using SafeMath for uint256;\n', '\n', '    //events\n', '    event eveSetRate(uint256 burn_rate);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    //token base data\n', '    uint256 internal _totalSupply;\n', '    mapping(address => uint256) public _balances;\n', '    mapping (address => mapping (address => uint256)) public _allowances;\n', '\n', '    /// Constant token specific fields\n', '    uint256 public  _maxSupply = 0;\n', '\n', '    ///\n', '    bool public _openTransfer = false;\n', '\n', '    // hardcode limit rate\n', '    uint256 public constant _maxGovernValueRate = 2000;//2000/10000\n', '    uint256 public constant _minGovernValueRate = 10;  //10/10000\n', '    uint256 public constant _rateBase = 10000; \n', '\n', '    // additional variables for use if transaction fees ever became necessary\n', '    uint256 public  _burnRate = 50;       \n', '\n', '    uint256 public _totalBurnToken = 0;\n', '\n', '    //todo burn pool!\n', '    address public _burnPool = 0x6666666666666666666666666666666666666666;\n', '\n', '    /**\n', '    * @dev set the token transfer switch\n', '    */\n', '    function enableOpenTransfer() public onlyGovernance  \n', '    {\n', '        _openTransfer = true;\n', '    }\n', '\n', '\n', '    /**\n', '     * CONSTRUCTOR\n', '     *\n', '     * @dev Initialize the Token\n', '     */\n', '\n', '    constructor () public ERC20Detailed("HADA Coin", "HADA", 8) {\n', '         _maxSupply = 100000000000 * (10**8);\n', '        _totalSupply = _maxSupply;\n', '        _balances[0xa419546E9ECb2F3D22f4501d18ea651E4DFAa1CC] = _totalSupply;\n', '\n', '\t\temit Transfer(address(0), 0xa419546E9ECb2F3D22f4501d18ea651E4DFAa1CC, _maxSupply);\n', '    }\n', '\n', '\n', '    \n', '    /**\n', '    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '    * @param spender The address which will spend the funds.\n', '    * @param amount The amount of tokens to be spent.\n', '    */\n', '    function approve(address spender, uint256 amount) public \n', '    returns (bool) \n', '    {\n', '        require(msg.sender != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[msg.sender][spender] = amount;\n', '        emit Approval(msg.sender, spender, amount);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Function to check the amount of tokens than an owner _allowed to a spender.\n', '    * @param owner address The address which owns the funds.\n', '    * @param spender address The address which will spend the funds.\n', '    * @return A uint256 specifying the amount of tokens still available for the spender.\n', '    */\n', '    function allowance(address owner, address spender) public view \n', '    returns (uint256) \n', '    {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address owner) public  view \n', '    returns (uint256) \n', '    {\n', '        return _balances[owner];\n', '    }\n', '\n', '    /**\n', '    * @dev return the token total supply\n', '    */\n', '    function totalSupply() public view \n', '    returns (uint256) \n', '    {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function() external payable {\n', '        revert();\n', '    }\n', '\n', '    /**\n', '    * @dev for govern value\n', '    */\n', '    function setRate(uint256 burn_rate) public \n', '        onlyGovernance \n', '    {\n', '        require(_maxGovernValueRate >= burn_rate && burn_rate >= _minGovernValueRate,"invalid burn rate");\n', '\n', '        _burnRate = burn_rate;\n', '\n', '        emit eveSetRate(burn_rate);\n', '    }\n', '\n', '   function transfer(address to, uint256 value) public \n', '   returns (bool)  \n', '   {\n', '        return _transfer(msg.sender,to,value);\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer tokens from one address to another\n', '    * @param from address The address which you want to send tokens from\n', '    * @param to address The address which you want to transfer to\n', '    * @param value uint256 the amount of tokens to be transferred\n', '    */\n', '    function transferFrom(address from, address to, uint256 value) public \n', '    returns (bool) \n', '    {\n', '        uint256 allow = _allowances[from][msg.sender];\n', '        _allowances[from][msg.sender] = allow.sub(value);\n', '        \n', '        return _transfer(from,to,value);\n', '    }\n', '\n', ' \n', '\n', '    /**\n', '    * @dev Transfer tokens with fee\n', '    * @param from address The address which you want to send tokens from\n', '    * @param to address The address which you want to transfer to\n', '    * @param value uint256s the amount of tokens to be transferred\n', '    */\n', '    function _transfer(address from, address to, uint256 value) internal \n', '    returns (bool) \n', '    {\n', '        // :)\n', '        require(_openTransfer || from == governance, "transfer closed");\n', '\n', '        require(from != address(0), "ERC20: transfer from the zero address");\n', '        require(to != address(0), "ERC20: transfer to the zero address");\n', '\n', '        uint256 sendAmount = value;\n', '        uint256 burnFee = (value.mul(_burnRate)).div(_rateBase);\n', '        if (burnFee > 0) {\n', '            //to burn\n', '            _balances[_burnPool] = _balances[_burnPool].add(burnFee);\n', '            _totalSupply = _totalSupply.sub(burnFee);\n', '            sendAmount = sendAmount.sub(burnFee);\n', '\n', '            _totalBurnToken = _totalBurnToken.add(burnFee);\n', '\n', '            emit Transfer(from, _burnPool, burnFee);\n', '        }\n', '\n', '        _balances[from] = _balances[from].sub(value);\n', '        _balances[to] = _balances[to].add(sendAmount);\n', '\n', '        emit Transfer(from, to, sendAmount);\n', '\n', '        return true;\n', '    }\n', '}']