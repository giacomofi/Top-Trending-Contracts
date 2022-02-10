['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-23\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity 0.7.5;\n', '\n', 'interface IOwnable {\n', '\n', '  function owner() external view returns (address);\n', '\n', '  function renounceOwnership() external;\n', '  \n', '  function transferOwnership( address newOwner_ ) external;\n', '}\n', '\n', 'contract Ownable is IOwnable {\n', '    \n', '  address internal _owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev Initializes the contract setting the deployer as the initial owner.\n', '   */\n', '  constructor () {\n', '    _owner = msg.sender;\n', '    emit OwnershipTransferred( address(0), _owner );\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the address of the current owner.\n', '   */\n', '  function owner() public view override returns (address) {\n', '    return _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require( _owner == msg.sender, "Ownable: caller is not the owner" );\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Leaves the contract without owner. It will not be possible to call\n', '   * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '   *\n', '   * NOTE: Renouncing ownership will leave the contract without an owner,\n', '   * thereby removing any functionality that is only available to the owner.\n', '   */\n', '  function renounceOwnership() public virtual override onlyOwner() {\n', '    emit OwnershipTransferred( _owner, address(0) );\n', '    _owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '   * Can only be called by the current owner.\n', '   */\n', '  function transferOwnership( address newOwner_ ) public virtual override onlyOwner() {\n', '    require( newOwner_ != address(0), "Ownable: new owner is the zero address");\n', '    emit OwnershipTransferred( _owner, newOwner_ );\n', '    _owner = newOwner_;\n', '  }\n', '}\n', '\n', 'interface IERC20 {\n', '\n', '  function decimals() external view returns (uint8);\n', '  /**\n', '   * @dev Returns the amount of tokens in existence.\n', '   */\n', '  function totalSupply() external view returns (uint256);\n', '\n', '  /**\n', '   * @dev Returns the amount of tokens owned by `account`.\n', '   */\n', '  function balanceOf(address account) external view returns (uint256);\n', '\n', '  /**\n', "   * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '   *\n', '   * Returns a boolean value indicating whether the operation succeeded.\n', '   *\n', '   * Emits a {Transfer} event.\n', '   */\n', '  function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '  /**\n', '   * @dev Returns the remaining number of tokens that `spender` will be\n', '   * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '   * zero by default.\n', '   *\n', '   * This value changes when {approve} or {transferFrom} are called.\n', '   */\n', '  function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '  /**\n', "   * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '   *\n', '   * Returns a boolean value indicating whether the operation succeeded.\n', '   *\n', '   * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '   * that someone may use both the old and the new allowance by unfortunate\n', '   * transaction ordering. One possible solution to mitigate this race\n', "   * condition is to first reduce the spender's allowance to 0 and set the\n", '   * desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   *\n', '   * Emits an {Approval} event.\n', '   */\n', '  function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '  /**\n', '   * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "   * allowance mechanism. `amount` is then deducted from the caller's\n", '   * allowance.\n', '   *\n', '   * Returns a boolean value indicating whether the operation succeeded.\n', '   *\n', '   * Emits a {Transfer} event.\n', '   */\n', '  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '  /**\n', '   * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '   * another (`to`).\n', '   *\n', '   * Note that `value` may be zero.\n', '   */\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '  /**\n', '   * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '   * a call to {approve}. `value` is the new allowance.\n', '   */\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '\n', '    // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)\n', '    function sqrrt(uint256 a) internal pure returns (uint c) {\n', '        if (a > 3) {\n', '            c = a;\n', '            uint b = add( div( a, 2), 1 );\n', '            while (b < c) {\n', '                c = b;\n', '                b = div( add( div( a, b ), b), 2 );\n', '            }\n', '        } else if (a != 0) {\n', '            c = 1;\n', '        }\n', '    }\n', '\n', '    /*\n', '     * Expects percentage to be trailed by 00,\n', '    */\n', '    function percentageAmount( uint256 total_, uint8 percentage_ ) internal pure returns ( uint256 percentAmount_ ) {\n', '        return div( mul( total_, percentage_ ), 1000 );\n', '    }\n', '\n', '    /*\n', '     * Expects percentage to be trailed by 00,\n', '    */\n', '    function substractPercentage( uint256 total_, uint8 percentageToSub_ ) internal pure returns ( uint256 result_ ) {\n', '        return sub( total_, div( mul( total_, percentageToSub_ ), 1000 ) );\n', '    }\n', '\n', '    function percentageOfTotal( uint256 part_, uint256 total_ ) internal pure returns ( uint256 percent_ ) {\n', '        return div( mul(part_, 100) , total_ );\n', '    }\n', '\n', '    /**\n', '     * Taken from Hypersonic https://github.com/M2629/HyperSonic/blob/main/Math.sol\n', '     * @dev Returns the average of two numbers. The result is rounded towards\n', '     * zero.\n', '     */\n', '    function average(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // (a + b) / 2 can overflow, so we distribute\n', '        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);\n', '    }\n', '\n', '    function quadraticPricing( uint256 payment_, uint256 multiplier_ ) internal pure returns (uint256) {\n', '        return sqrrt( mul( multiplier_, payment_ ) );\n', '    }\n', '\n', '  function bondingCurve( uint256 supply_, uint256 multiplier_ ) internal pure returns (uint256) {\n', '      return mul( multiplier_, supply_ );\n', '  }\n', '}\n', '\n', 'contract aOHMMigration is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    uint256 swapEndBlock;\n', '\n', '    IERC20 public OHM;\n', '    IERC20 public aOHM;\n', '    \n', '    bool public isInitialized;\n', '\n', '    mapping(address => uint256) public senderInfo;\n', '    \n', '    modifier onlyInitialized() {\n', '        require(isInitialized, "not initialized");\n', '        _;\n', '    }\n', '\n', '    function initialize (\n', '        address _OHM,\n', '        address _aOHM,\n', '        uint256 _swapDuration\n', '    ) public onlyInitialized() {\n', '        OHM = IERC20(_OHM);\n', '        aOHM = IERC20(_aOHM);\n', '        swapEndBlock = block.number.add(_swapDuration);\n', '        isInitialized = true;\n', '    }\n', '\n', '    function migrate(uint256 amount) external onlyInitialized() {\n', '        require(\n', '            aOHM.balanceOf(msg.sender) >= amount,\n', '            "amount above user balance"\n', '        );\n', '        require(block.number < swapEndBlock, "swapping of aOHM has ended");\n', '\n', '        aOHM.transferFrom(msg.sender, address(this), amount);\n', '        senderInfo[msg.sender] = senderInfo[msg.sender].add(amount);\n', '        OHM.transfer(msg.sender, amount);\n', '    }\n', '\n', '    function reclaim() external {\n', '        require(senderInfo[msg.sender] > 0, "user has no aOHM to withdraw");\n', '        require(\n', '            block.number > swapEndBlock,\n', '            "aOHM swap is still ongoing"\n', '        );\n', '\n', '        uint256 amount = senderInfo[msg.sender];\n', '        senderInfo[msg.sender] = 0;\n', '        aOHM.transfer(msg.sender, amount);\n', '    }\n', '\n', '    function withdraw() external onlyOwner() {\n', '        require(block.number > swapEndBlock, "swapping of aOHM has not ended");\n', '        uint256 amount = OHM.balanceOf(address(this));\n', '\n', '        OHM.transfer(msg.sender, amount);\n', '    }\n', '}']