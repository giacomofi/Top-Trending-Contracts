['/*\n', '\n', '* @dev This is the Axia Protocol Staking pool 2 contract (Defi Fund Pool), \n', '* a part of the protocol where stakers are rewarded in AXIA tokens \n', '* when they make stakes of liquidity tokens from the oracle pool.\n', '\n', '* stakers reward come from the daily emission from the total supply into circulation,\n', '* this happens daily and upon the reach of a new epoch each made of 180 days, \n', '* halvings are experienced on the emitting amount of tokens.\n', '\n', '* on the 11th epoch all the tokens would have been completed emitted into circulation,\n', '* from here on, the stakers will still be earning from daily emissions\n', '* which would now be coming from the accumulated basis points over the epochs.\n', '\n', '* stakers are not charged any fee for unstaking.\n', '\n', '\n', '*/\n', 'pragma solidity 0.6.4;\n', '\n', 'interface IERC20 {\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', ' \n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', '\n', 'contract DSP{\n', '    \n', '    using SafeMath for uint256;\n', '    \n', '//======================================EVENTS=========================================//\n', '    event StakeEvent(address indexed staker, address indexed pool, uint amount);\n', '    event UnstakeEvent(address indexed unstaker, address indexed pool, uint amount);\n', '    event RewardEvent(address indexed staker, address indexed pool, uint amount);\n', '    event RewardStake(address indexed staker, address indexed pool, uint amount);\n', '    \n', '    \n', '//======================================STAKING POOLS=========================================//\n', '    address public Axiatoken;\n', '    address public DefiIndexFunds;\n', '    \n', '    address public administrator;\n', '    \n', '    bool public stakingEnabled;\n', '    \n', '    uint256 constant private FLOAT_SCALAR = 2**64;\n', '    uint256 public MINIMUM_STAKE = 1000000000000000000; // 1 minimum\n', '\tuint256 public MIN_DIVIDENDS_DUR = 18 hours;\n', '\t\n', '\tuint public infocheck;\n', '    \n', '    struct User {\n', '\t\tuint256 balance;\n', '\t\tuint256 frozen;\n', '\t\tint256 scaledPayout;  \n', '\t\tuint256 staketime;\n', '\t}\n', '\n', '\tstruct Info {\n', '\t\tuint256 totalSupply;\n', '\t\tuint256 totalFrozen;\n', '\t\tmapping(address => User) users;\n', '\t\tuint256 scaledPayoutPerToken; //pool balance \n', '\t\taddress admin;\n', '\t}\n', '\t\n', '\tInfo private info;\n', '\t\n', '\t\n', '\tconstructor() public {\n', '\t    \n', '        info.admin = msg.sender;\n', '        stakingEnabled = false;\n', '\t}\n', '\n', '//======================================ADMINSTRATION=========================================//\n', '\n', '\tmodifier onlyCreator() {\n', '        require(msg.sender == info.admin, "Ownable: caller is not the administrator");\n', '        _;\n', '    }\n', '    \n', '    modifier onlyAxiaToken() {\n', '        require(msg.sender == Axiatoken, "Authorization: only token contract can call");\n', '        _;\n', '    }\n', '    \n', '\t function tokenconfigs(address _axiatoken, address _defiindex) public onlyCreator returns (bool success) {\n', '        require(_axiatoken != _defiindex, "Insertion of same address is not supported");\n', '        require(_axiatoken != address(0) && _defiindex != address(0), "Insertion of address(0) is not supported");\n', '        Axiatoken = _axiatoken;\n', '        DefiIndexFunds = _defiindex;\n', '        return true;\n', '    }\n', '\t\n', '\tfunction _minStakeAmount(uint256 _number) onlyCreator public {\n', '\t\t\n', '\t\tMINIMUM_STAKE = _number*1000000000000000000;\n', '\t\t\n', '\t}\n', '\t\n', '\tfunction stakingStatus(bool _status) public onlyCreator {\n', '\t    require(Axiatoken != address(0) && DefiIndexFunds != address(0), "Pool addresses are not yet setup");\n', '\tstakingEnabled = _status;\n', '    }\n', '    \n', '    \n', '    function MIN_DIVIDENDS_DUR_TIME(uint256 _minDuration) public onlyCreator {\n', '        \n', '\tMIN_DIVIDENDS_DUR = _minDuration;\n', '\t\n', '    }\n', '    \n', '//======================================USER WRITE=========================================//\n', '\n', '\tfunction StakeTokens(uint256 _tokens) external {\n', '\t\t_stake(_tokens);\n', '\t}\n', '\t\n', '\tfunction UnstakeTokens(uint256 _tokens) external {\n', '\t\t_unstake(_tokens);\n', '\t}\n', '    \n', '\n', '//======================================USER READ=========================================//\n', '\n', '\tfunction totalFrozen() public view returns (uint256) {\n', '\t\treturn info.totalFrozen;\n', '\t}\n', '\t\n', '    function frozenOf(address _user) public view returns (uint256) {\n', '\t\treturn info.users[_user].frozen;\n', '\t}\n', '\n', '\tfunction dividendsOf(address _user) public view returns (uint256) {\n', '\t    \n', '\t    if(info.users[_user].staketime < MIN_DIVIDENDS_DUR){\n', '\t        return 0;\n', '\t    }else{\n', '\t     return uint256(int256(info.scaledPayoutPerToken * info.users[_user].frozen) - info.users[_user].scaledPayout) / FLOAT_SCALAR;   \n', '\t    }\n', '\t    \n', '\t}\n', '\t\n', '\n', '\tfunction userData(address _user) public view \n', '\treturns (uint256 totalTokensFrozen, uint256 userFrozen, \n', '\tuint256 userDividends, uint256 userStaketime, int256 scaledPayout) {\n', '\t    \n', '\t\treturn (totalFrozen(), frozenOf(_user), dividendsOf(_user), info.users[_user].staketime, info.users[_user].scaledPayout);\n', '\t\n', '\t    \n', '\t}\n', '\t\n', '\n', '//======================================ACTION CALLS=========================================//\t\n', '\t\n', '\tfunction _stake(uint256 _amount) internal {\n', '\t    \n', '\t    require(stakingEnabled, "Staking not yet initialized");\n', '\t    \n', '\t\trequire(IERC20(DefiIndexFunds).balanceOf(msg.sender) >= _amount, "Insufficient DeFi AFT balance");\n', '\t\trequire(frozenOf(msg.sender) + _amount >= MINIMUM_STAKE, "Your amount is lower than the minimum amount allowed to stake");\n', '\t\trequire(IERC20(DefiIndexFunds).allowance(msg.sender, address(this)) >= _amount, "Not enough allowance given to contract yet to spend by user");\n', '\t\t\n', '\t\tinfo.users[msg.sender].staketime = now;\n', '\t\tinfo.totalFrozen += _amount;\n', '\t\tinfo.users[msg.sender].frozen += _amount;\n', '\t\t\n', '\t\tinfo.users[msg.sender].scaledPayout += int256(_amount * info.scaledPayoutPerToken); \n', '\t\tIERC20(DefiIndexFunds).transferFrom(msg.sender, address(this), _amount);      // Transfer liquidity tokens from the sender to this contract\n', '\t\t\n', '        emit StakeEvent(msg.sender, address(this), _amount);\n', '\t}\n', '\t\n', '    \n', '    \n', ' \n', '\tfunction _unstake(uint256 _amount) internal {\n', '\t    \n', '\t\trequire(frozenOf(msg.sender) >= _amount, "You currently do not have up to that amount staked");\n', '\t\t\n', '\t\tinfo.totalFrozen -= _amount;\n', '\t\tinfo.users[msg.sender].frozen -= _amount;\n', '\t\tinfo.users[msg.sender].scaledPayout -= int256(_amount * info.scaledPayoutPerToken);\n', '\t\t\n', '\t\trequire(IERC20(DefiIndexFunds).transfer(msg.sender, _amount), "Transaction failed");\n', '        emit UnstakeEvent(address(this), msg.sender, _amount);\n', '\t\t\n', '\t}\n', '\t\n', '\t\t\n', '\tfunction TakeDividends() external returns (uint256) {\n', '\t\t    \n', '\t\tuint256 _dividends = dividendsOf(msg.sender);\n', '\t\trequire(_dividends >= 0, "you do not have any dividend yet");\n', '\t\tinfo.users[msg.sender].scaledPayout += int256(_dividends * FLOAT_SCALAR);\n', '\t\t\n', '\t\trequire(IERC20(Axiatoken).transfer(msg.sender, _dividends), "Transaction Failed");    // Transfer dividends to msg.sender\n', '\t\temit RewardEvent(msg.sender, address(this), _dividends);\n', '\t\t\n', '\t\treturn _dividends;\n', '\t    \n', '\t\t    \n', '\t}\n', ' \n', '    function scaledToken(uint _amount) external onlyAxiaToken returns(bool){\n', '            \n', '    \t\tinfo.scaledPayoutPerToken += _amount * FLOAT_SCALAR / info.totalFrozen;\n', '    \t\tinfocheck = info.scaledPayoutPerToken;\n', '    \t\treturn true;\n', '            \n', '    }\n', ' \n', '        \n', '    function mulDiv (uint x, uint y, uint z) public pure returns (uint) {\n', '          (uint l, uint h) = fullMul (x, y);\n', '          assert (h < z);\n', '          uint mm = mulmod (x, y, z);\n', '          if (mm > l) h -= 1;\n', '          l -= mm;\n', '          uint pow2 = z & -z;\n', '          z /= pow2;\n', '          l /= pow2;\n', '          l += h * ((-pow2) / pow2 + 1);\n', '          uint r = 1;\n', '          r *= 2 - z * r;\n', '          r *= 2 - z * r;\n', '          r *= 2 - z * r;\n', '          r *= 2 - z * r;\n', '          r *= 2 - z * r;\n', '          r *= 2 - z * r;\n', '          r *= 2 - z * r;\n', '          r *= 2 - z * r;\n', '          return l * r;\n', '    }\n', '    \n', '     function fullMul (uint x, uint y) private pure returns (uint l, uint h) {\n', '          uint mm = mulmod (x, y, uint (-1));\n', '          l = x * y;\n', '          h = mm - l;\n', '          if (mm < l) h -= 1;\n', '    }\n', ' \n', '    \n', '}']