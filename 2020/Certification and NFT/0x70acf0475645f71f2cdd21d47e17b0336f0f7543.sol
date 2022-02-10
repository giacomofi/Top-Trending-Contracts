['/* Experimental Keeper staking contract – for the distribution of unsold presale tokens to \n', 'buyer */\n', 'pragma solidity 0.6.6;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address account) external view returns (uint);\n', '    function transfer(address recipient, uint amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '    function approve(address spender, uint amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        require(c >= a, "add: +");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting with custom message on overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint a, uint b, string memory errorMessage) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        require(c >= a, errorMessage);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on underflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot underflow.\n', '     */\n', '    function sub(uint a, uint b) internal pure returns (uint) {\n', '        return sub(a, b, "sub: -");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on underflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot underflow.\n', '     */\n', '    function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {\n', '        require(b <= a, errorMessage);\n', '        uint c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint a, uint b) internal pure returns (uint) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint c = a * b;\n', '        require(c / a == b, "mul: *");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint a, uint b, string memory errorMessage) internal pure returns (uint) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint c = a * b;\n', '        require(c / a == b, errorMessage);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers.\n', '     * Reverts on division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint a, uint b) internal pure returns (uint) {\n', '        return div(a, b, "div: /");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers.\n', '     * Reverts with custom message on division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint a, uint b) internal pure returns (uint) {\n', '        return mod(a, b, "mod: %");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint a, uint b, string memory errorMessage) internal pure returns (uint) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// y = f(x)\n', '\n', '// 5 = f(10)\n', '// 185 = f(365)\n', '//y = A^x - X\n', '//y = 1.87255 + 0.2985466*x + 0.001419838*x^2\n', '\n', 'interface StakingInterface {\n', '    function votingPowerOf(address acc, uint256 until) external view returns(uint256);\n', '}\n', '\n', 'contract StakeContract is Ownable, StakingInterface {\n', '    using SafeMath for uint256;\n', '    IERC20 public kp4r;\n', '\n', '    bool isClosed = false;\n', '\n', '    // quadratic reward curve constants\n', '    // a + b*x + c*x^2\n', '    uint256 public A = 187255; // 1.87255 \n', '    uint256 public B = 29854;  // 0.2985466*x\n', '    uint256 public C = 141;    // 0.001419838*x^2\n', '    uint256 constant BP = 10000;\n', '\n', '    uint256 public maxDays = 365;\n', '    uint256 public minDays = 10;\n', '\n', '    uint256 public totalStaked = 0;\n', '    uint256 public totalRewards = 0;\n', '\n', '    uint256 public earlyExit = 0;\n', '\n', '    struct StakeInfo {\n', '        uint256 reward; \n', '        uint256 initial;\n', '        uint256 payday;\n', '        uint256 startday;\n', '    }\n', '\n', '    mapping (address=>StakeInfo) public stakes;\n', '\n', '    constructor(address _kp4r) public {\n', '        kp4r = IERC20(_kp4r);\n', '    }\n', '\n', '    function stake(uint256 _amount, uint256 _days) public {\n', '        require(_days > minDays, "less than minimum staking period");\n', '        require(_days < maxDays, "more than maximum staking period");\n', '        require(stakes[msg.sender].payday == 0, "already staked");\n', '        require(_amount > 100, "amount to small");\n', '        require(!isClosed, "staking is closed");\n', '\n', '        // calculate reward\n', '        uint256 _reward = calculateReward(_amount, _days);\n', '\n', '        // contract must have funds to keep this commitment\n', '        require(kp4r.balanceOf(address(this)) > totalOwedValue().add(_reward).add(_amount), "insufficient contract bal");\n', '        \n', '        require(kp4r.transferFrom(msg.sender, address(this), _amount), "transfer failed");\n', '\n', '        stakes[msg.sender].payday = block.timestamp.add(_days * (1 days));\n', '        stakes[msg.sender].reward = _reward;\n', '        stakes[msg.sender].startday = block.timestamp;\n', '        stakes[msg.sender].initial = _amount;\n', '\n', '        // update stats\n', '        totalStaked = totalStaked.add(_amount);\n', '        totalRewards = totalRewards.add(_reward);\n', '    }\n', '\n', '    function claim() public {\n', '        require(owedBalance(msg.sender) > 0, "nothing to claim");\n', '        require(block.timestamp > stakes[msg.sender].payday.sub(earlyExit), "too early");\n', '\n', '        uint256 owed = stakes[msg.sender].reward.add(stakes[msg.sender].initial);\n', '\n', '        // update stats\n', '        totalStaked = totalStaked.sub(stakes[msg.sender].initial);\n', '        totalRewards = totalRewards.sub(stakes[msg.sender].reward);\n', '\n', '        stakes[msg.sender].initial = 0;\n', '        stakes[msg.sender].reward = 0;\n', '        stakes[msg.sender].payday = 0;\n', '        stakes[msg.sender].startday = 0;\n', '\n', '        require(kp4r.transfer(msg.sender, owed), "transfer failed");\n', '    }\n', '\n', '    function calculateReward(uint256 _amount, uint256 _days) public view returns (uint256) {\n', '        uint256 _multiplier = _quadraticRewardCurveY(_days);\n', '        uint256 _AY = _amount.mul(_multiplier);\n', '        return _AY.div(10000000);\n', '\n', '    }\n', '\n', '    // a + b*x + c*x^2\n', '    function _quadraticRewardCurveY(uint256 _x) public view returns (uint256) {\n', '        uint256 _bx = _x.mul(B);\n', '        uint256 _x2 = _x.mul(_x);\n', '        uint256 _cx2 = C.mul(_x2);\n', '        return A.add(_bx).add(_cx2);\n', '    }\n', '\n', '    // helpers:\n', '    function totalOwedValue() public view returns (uint256) {\n', '        return totalStaked.add(totalRewards);\n', '    }\n', '\n', '    function owedBalance(address acc) public view returns(uint256) { \n', '        return stakes[acc].initial.add(stakes[acc].reward);\n', '    }\n', '\n', '    function votingPowerOf(address acc, uint256 until) external override view returns(uint256) {\n', '        if (stakes[acc].payday > until) {\n', '            return 0;\n', '        }\n', '\n', '        return owedBalance(acc);\n', '    }\n', '\n', '    // owner functions:\n', '    function setLimits(uint256 _minDays, uint256 _maxDays) public onlyOwner {\n', '        minDays = _minDays;\n', '        maxDays = _maxDays;\n', '    }\n', '\n', '    function setCurve(uint256 _A, uint256 _B, uint256 _C) public onlyOwner {\n', '        A = _A;\n', '        B = _B;\n', '        C = _C;\n', '    }\n', '\n', '    function setEarlyExit(uint256 _earlyExit) public onlyOwner {\n', '        require(_earlyExit < 1604334278, "too big");\n', '        close(true);\n', '        earlyExit = _earlyExit;\n', '    }\n', '\n', '    function close(bool closed) public onlyOwner {\n', '        isClosed = closed;\n', '    }\n', '\n', '    function ownerReclaim(uint256 _amount) public onlyOwner {\n', '        require(_amount < kp4r.balanceOf(address(this)).sub(totalOwedValue()), "cannot withdraw owed funds");\n', '        kp4r.transfer(msg.sender, _amount);\n', '    }\n', '\n', '    function flushETH() public onlyOwner {\n', '        uint256 bal = address(this).balance.sub(1);\n', '        msg.sender.transfer(bal);\n', '    }\n', '\n', '}']