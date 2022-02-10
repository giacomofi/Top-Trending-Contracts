['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-26\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.6.6;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'interface IPairXCore {\n', '\n', '    // 向池子中存入资产\n', '    function deposit( address token , address to , uint amount ) external  ;\n', '\n', '    // 取回指定的Token资产及奖励\n', '    function claim( address token ) external returns (uint amount) ;\n', '\n', '    // 提取PairX的挖矿奖励,可以提取当前已解锁的份额\n', '    function redeem(address token ) external returns (uint amount ) ;\n', '\n', '    /**\n', '     *  结束流动性挖矿\n', '     */\n', '    function finish() external ;\n', '}\n', '\n', 'interface IWETH {\n', '    function deposit() external payable;\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function withdraw(uint) external;\n', '}\n', '\n', 'interface IStakingRewards {\n', '    // Views\n', '    function lastTimeRewardApplicable() external view returns (uint256);\n', '\n', '    function rewardPerToken() external view returns (uint256);\n', '\n', '    function earned(address account) external view returns (uint256);\n', '\n', '    function getRewardForDuration() external view returns (uint256);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    // Mutative\n', '    function stake(uint256 amount) external;\n', '\n', '    function withdraw(uint256 amount) external;\n', '\n', '    function getReward() external;\n', '\n', '    function exit() external;\n', '\n', '    event Staked(address indexed user, uint256 amount);\n', '    event Withdrawn(address indexed user, uint256 amount);\n', '    event RewardPaid(address indexed user, uint256 reward);\n', '    event RewardAdded(uint256 reward);\n', '}\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false\n', 'library TransferHelper {\n', '    function safeApprove(address token, address to, uint value) internal {\n', "        // bytes4(keccak256(bytes('approve(address,uint256)')));\n", '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));\n', "        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');\n", '    }\n', '\n', '    function safeTransfer(address token, address to, uint value) internal {\n', "        // bytes4(keccak256(bytes('transfer(address,uint256)')));\n", '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));\n', "        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');\n", '    }\n', '\n', '    function safeTransferFrom(address token, address from, address to, uint value) internal {\n', "        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));\n", '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));\n', "        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');\n", '    }\n', '\n', '    function safeTransferETH(address to, uint value) internal {\n', '        (bool success,) = to.call{value:value}(new bytes(0));\n', "        require(success, 'TransferHelper: ETH_TRANSFER_FAILED');\n", '    }\n', '}\n', '\n', '\n', 'interface IUniswapV2Pair {\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    function name() external pure returns (string memory);\n', '    function symbol() external pure returns (string memory);\n', '    function decimals() external pure returns (uint8);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function transferFrom(address from, address to, uint value) external returns (bool);\n', '\n', '    function DOMAIN_SEPARATOR() external view returns (bytes32);\n', '    function PERMIT_TYPEHASH() external pure returns (bytes32);\n', '    function nonces(address owner) external view returns (uint);\n', '\n', '    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;\n', '\n', '    event Mint(address indexed sender, uint amount0, uint amount1);\n', '    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);\n', '    event Swap(\n', '        address indexed sender,\n', '        uint amount0In,\n', '        uint amount1In,\n', '        uint amount0Out,\n', '        uint amount1Out,\n', '        address indexed to\n', '    );\n', '    event Sync(uint112 reserve0, uint112 reserve1);\n', '\n', '    function MINIMUM_LIQUIDITY() external pure returns (uint);\n', '    function factory() external view returns (address);\n', '    function token0() external view returns (address);\n', '    function token1() external view returns (address);\n', '    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '    function price0CumulativeLast() external view returns (uint);\n', '    function price1CumulativeLast() external view returns (uint);\n', '    function kLast() external view returns (uint);\n', '\n', '    function mint(address to) external returns (uint liquidity);\n', '    function burn(address to) external returns (uint amount0, uint amount1);\n', '    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\n', '    function skim(address to) external;\n', '    function sync() external;\n', '\n', '    function initialize(address, address) external;\n', '}\n', '\n', '\n', 'contract PairPairX is IPairXCore {\n', '    using SafeMath for uint256;\n', '\n', '    address public Owner;\n', '    uint8 public Fee = 10;\n', '    address public FeeTo;\n', '\n', '    uint256 private MinToken0Deposit;\n', '    uint256 private MinToken1Deposit;\n', '\n', '    // for pairx\n', '    address public RewardToken; // Reward Token\n', '    uint256 public RewardAmount;\n', '\n', '    uint8 public Status = 0; // 0 = not init , 1 = open , 2 = locked , 9 = finished\n', '    // uint public MaxLockDays = 365 ;\n', '    uint256 public RewardBeginTime = 0; // 开始PairX计算日期,在addLiquidityAndStake时设置\n', '    uint256 public DepositEndTime = 0; // 存入结束时间\n', '    uint256 public StakeEndTime = 0;\n', '\n', '    address public UniPairAddress; // 配对奖励Token address\n', '    address public MainToken; // stake and reward token\n', '    address public Token0; // Already sorted .\n', '    address public Token1;\n', '    TokenRecord Token0Record;\n', '    TokenRecord Token1Record;\n', '\n', '    address public StakeAddress; //\n', '    // uint StakeAmount ;\n', '\n', '    uint RewardGottedTotal ;    //已提现总数\n', '    mapping(address => mapping(address => uint256)) UserBalance; // 用户充值余额 UserBalance[sender][token]\n', '    mapping(address => mapping(address => uint256)) RewardGotted; // RewardGotted[sender][token]\n', '\n', '    event Deposit(address from, address to, address token, uint256 amount);\n', '    event Claim(\n', '        address from,\n', '        address to,\n', '        address token,\n', '        uint256 principal,\n', '        uint256 interest,\n', '        uint256 reward\n', '    );\n', '\n', '    struct TokenRecord {\n', '        uint256 total; // 存入总代币计数\n', '        uint256 reward; // 分配的总奖励pairx,默认先分配40%,最后20%根据规则分配\n', '        uint256 compensation; // PairX补贴额度,默认为0\n', '        uint256 stake; // lon staking token\n', '        uint256 withdraw; // 可提现总量，可提现代币需要包含挖矿奖励部分\n', '        uint256 mint; // 挖矿奖励\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == Owner, "no role.");\n', '        _;\n', '    }\n', '\n', '    modifier isActive() {\n', '        require(block.timestamp < StakeEndTime, "Mining was expired.");\n', '        require(Status == 1, "Not open.");\n', '        _;\n', '    }\n', '\n', '    constructor(address owner) public {\n', '        Owner = owner;\n', '    }\n', '\n', '    function active(\n', '        address feeTo,\n', '        address pair,\n', '        address main,\n', '        address stake,\n', '        uint256 stakeEndTime\n', '    ) external onlyOwner {\n', '        FeeTo = feeTo;\n', '        UniPairAddress = pair;\n', '        MainToken = main;\n', '        // 通过接口读取token0和token1的值\n', '        IUniswapV2Pair uni = IUniswapV2Pair(UniPairAddress);\n', '        Token0 = uni.token0();\n', '        Token1 = uni.token1();\n', '\n', '        StakeEndTime = stakeEndTime; //按秒计算，不再按天计算了\n', '        StakeAddress = stake;\n', '    }\n', '\n', '    /**\n', '     *  deposit reward-tokens (PairX token).\n', '     */\n', '    function setReward(\n', '        address reward,\n', '        uint256 amount,\n', '        uint256 token0min,\n', '        uint256 token1min,\n', '        uint256 depositEndTime\n', '    ) external onlyOwner {\n', '        RewardToken = reward;\n', '        TransferHelper.safeTransferFrom(\n', '            reward,\n', '            msg.sender,\n', '            address(this),\n', '            amount\n', '        );\n', '        RewardAmount = RewardAmount.add(amount);\n', '        MinToken0Deposit = token0min;\n', '        MinToken1Deposit = token1min;\n', '        Status = 1;\n', '\n', '        //update TokenRecord\n', '        uint256 defaultReward = RewardAmount.mul(4).div(10);\n', '        Token0Record.reward = defaultReward;\n', '        Token1Record.reward = defaultReward;\n', '        DepositEndTime = depositEndTime;\n', '    }\n', '\n', '    function tokenRecordInfo(address token)\n', '        external\n', '        view\n', '        returns (\n', '            uint256 free,\n', '            uint256 total,\n', '            uint256 reward,\n', '            uint256 stake,\n', '            uint256 withdraw\n', '        )\n', '    {\n', '        if (token == Token0) {\n', '            // free = _tokenBalance(Token0);\n', '            free = Token0Record.withdraw ;\n', '            total = Token0Record.total;\n', '            reward = Token0Record.reward;\n', '            stake = Token0Record.stake;\n', '            withdraw = Token0Record.withdraw;\n', '        } else {\n', '            // free = _tokenBalance(Token1);\n', '            free = Token1Record.withdraw ;\n', '            total = Token1Record.total;\n', '            reward = Token1Record.reward;\n', '            stake = Token1Record.stake;\n', '            withdraw = Token1Record.withdraw;\n', '        }\n', '\n', '    }\n', '\n', '    function info() external view returns (\n', '        // address owner , uint8 fee , address feeTo ,\n', '        uint minToken0Deposit , uint minToken1Deposit ,\n', '        address rewardToken  , uint rewardAmount , \n', '        uint8 status , uint stakeEndTime , \n', '        address token0 , address token1 , address pair ,\n', '        address mainToken , uint rewardBeginTime , uint depositEndTime\n', '    ) {\n', '        minToken0Deposit = MinToken0Deposit ;\n', '        minToken1Deposit = MinToken1Deposit ;\n', '        rewardToken = RewardToken ;\n', '        rewardAmount = RewardAmount ;\n', '        status = Status ;\n', '        stakeEndTime = StakeEndTime ;\n', '        token0 = Token0 ;\n', '        token1 = Token1 ;\n', '        mainToken = MainToken ;\n', '        pair = UniPairAddress ;\n', '        rewardBeginTime = RewardBeginTime ;\n', '        depositEndTime = DepositEndTime ;\n', '    } \n', '\n', '    function depositInfo( address sender , address token ) external view returns \n', '     ( uint depositBalance ,uint depositTotal , uint leftDays ,\n', '       uint lockedReward , uint freeReward , uint gottedReward ) {\n', '        depositBalance = UserBalance[sender][token] ;\n', '        if( token == Token0 ) {\n', '            depositTotal = Token0Record.total ;\n', '        } else {\n', '            depositTotal = Token1Record.total ;\n', '        }\n', '        // rewardTotal = RewardTotal[sender] ;\n', '        if( sender != address(0) ){\n', '            ( leftDays , lockedReward , freeReward , gottedReward )\n', '                = getRewardRecord( token , sender ) ;\n', '        } else {\n', '            leftDays = 0 ;\n', '            lockedReward = 0 ;\n', '            freeReward = 0 ;\n', '            gottedReward = 0 ;\n', '        }\n', '    }\n', '\n', '    function getRewardRecord(address token , address sender ) public view returns  \n', '     ( uint leftDays , uint locked , uint free , uint gotted ) {\n', '\n', '        uint nowDate = getDateTime( block.timestamp ) ;\n', '        //计算一共可提取的奖励\n', '        uint depositAmount = UserBalance[sender][token] ;\n', '        TokenRecord memory record = token == Token0 ? Token0Record : Token1Record ;\n', '\n', '        leftDays = _leftDays( StakeEndTime , nowDate ) ;\n', '        locked = 0 ;\n', '        free = 0 ;\n', '        gotted = 0 ;\n', '        if( depositAmount == 0 ) {\n', '            return ( leftDays , 0 , 0 , 0 );\n', '        }\n', '\n', '        if( record.reward == 0 ) {\n', '            return ( leftDays , 0 , 0 , 0 );\n', '        }\n', '\n', '        gotted = RewardGotted[sender][token] ;\n', '\n', '        //换个计算方法,计算每秒可获得的收益\n', '        uint lockedTimes = _leftDays( StakeEndTime , RewardBeginTime ) ;\n', '        uint oneTimeReward = record.reward.div( lockedTimes ) ;\n', '        uint freeTime ;\n', '\n', '        if( nowDate > StakeEndTime ) {\n', '            leftDays = 0 ;\n', '            locked = 0 ;\n', '            freeTime = lockedTimes ; \n', '        } else {\n', '            leftDays = _leftDays( StakeEndTime , nowDate ) ;\n', '            freeTime = lockedTimes.sub( leftDays ) ;\n', '        }\n', '\n', '        // 防止溢出,保留3位精度\n', '        uint maxReward = depositAmount.mul( oneTimeReward ).div(1e15)\n', '            .mul( lockedTimes ).div( record.total.div(1e15) );\n', '            \n', '        if( Status == 2 ) {\n', '            free = depositAmount.mul( oneTimeReward ).div(1e15)\n', '                .mul( freeTime ).div( record.total.div(1e15) ); \n', '            if( free.add(gotted) > maxReward ){\n', '                locked = 0 ;\n', '            } else {\n', '                locked = maxReward.sub( free ).sub( gotted ) ;\n', '            }\n', '        } else if ( Status == 9 ) {\n', '            free = maxReward.sub( gotted ) ;\n', '            locked = 0 ;\n', '        } else if ( Status == 1 ) {\n', '            free = 0 ;\n', '            locked = maxReward ;\n', '        } else {\n', '            free = 0 ;\n', '            locked = 0 ;\n', '        }\n', '\n', '    }    \n', '    \n', '    function getDateTime( uint timestamp ) public pure returns ( uint ) {\n', '        // timeValue = timestamp ;\n', '        return timestamp ;\n', '    }\n', '\n', '    function _sendReward( address to , uint amount ) internal {\n', '        //Give reward tokens .\n', '        uint balance = RewardAmount.sub( RewardGottedTotal ); \n', '        if( amount > 0 && balance > 0 ) {\n', '            if( amount > balance ){\n', '                amount = balance ;  //余额不足时，只能获得余额部分\n', '            }\n', '            TransferHelper.safeTransfer( RewardToken , to , amount ) ;\n', '            // RewardAmount = RewardAmount.sub( amount ) ;  使用balanceOf 确定余额\n', '        }\n', '    }\n', '\n', '    function _deposit(address sender ,  address token , uint amount ) internal {\n', '        if( token == Token0 ) {\n', '            require( amount > MinToken0Deposit , "Deposit tokens is too less." ) ;\n', '        }\n', '\n', '        if( token == Token1 ) {\n', '            require( amount > MinToken1Deposit , "Deposit tokens is too less." ) ;\n', '        }\n', '\n', '        if( token == Token0 ) {\n', '            Token0Record.total = Token0Record.total.add( amount ) ;\n', '            Token0Record.withdraw = Token0Record.total ;\n', '        }\n', '\n', '        if( token == Token1 ) {\n', '            Token1Record.total = Token1Record.total.add( amount ) ;\n', '            Token1Record.withdraw = Token1Record.total ;\n', '        }\n', '\n', '        UserBalance[sender][token] = UserBalance[sender][token].add(amount );\n', '    }\n', '\n', '    function _fee( uint amount ) internal returns ( uint fee ) {\n', '        fee = amount.mul( Fee ).div( 100 ) ;\n', '        if( fee > 0 ) {\n', '            _safeTransfer( MainToken , FeeTo , fee ) ;\n', '        }\n', '    }\n', '\n', '    function _leftDays(uint afterDate , uint beforeDate ) internal pure returns( uint ) {\n', '        if( afterDate <= beforeDate ) {\n', '            return 0 ;\n', '        } else {\n', '            return afterDate.sub(beforeDate ) ;\n', '            // 将由天计算改为由秒计算\n', '            //return afterDate.sub(beforeDate).div( OneDay )  ;\n', '        }\n', '    }\n', '\n', '    /*\n', '    *   向池子中存入资产, 目前该接口只支持erc20代币.\n', '    *   如果需要使用eth，会在前置合约进行处理,将eth兑换成WETH\n', '    */\n', '    function deposit( address token , address to , uint amount  ) public override isActive {\n', '        \n', '        require( Status == 1 , "Not allow deposit ." ) ;\n', '        require( (token == Token0) || ( token == Token1) , "Match token faild." ) ;\n', '\n', '        // More gas , But logic will more easy.\n', '        if( token == MainToken ){\n', '            TransferHelper.safeTransferFrom( token , msg.sender , address(this) , amount ) ;\n', '        } else {\n', '            // 兑换 weth\n', '            IWETH( token ).deposit{\n', '                value : amount \n', '            }() ;\n', '        }\n', '        _deposit( to , token , amount ) ;\n', '\n', '        emit Deposit( to, address(this) , token , amount ) ;\n', '    } \n', '\n', '    /**\n', '     *  提取可提现的奖励Token\n', '     */\n', '    function redeem(address token ) public override returns ( uint amount ) {\n', '        require( Status == 2 || Status == 9 , "Not finished." ) ;\n', '        address sender = msg.sender ;\n', '        ( , , uint free , ) = getRewardRecord( token , sender ) ;\n', '        amount = free ;\n', '        _sendReward( sender , amount ) ;\n', '        RewardGotted[sender][token] = RewardGotted[sender][token].add( amount ) ;  \n', '        RewardGottedTotal = RewardGottedTotal.add( amount ) ;\n', '    }\n', '\n', '    // redeem all , claim from tokenlon , and removeLiquidity from uniswap\n', '    // 流程结束\n', '    function finish() external override onlyOwner {\n', '        // require(block.timestamp >= StakeEndTime , "It\'s not time for redemption." ) ;\n', '        // redeem liquidity from staking contracts \n', '        IStakingRewards staking = IStakingRewards(StakeAddress) ;\n', '        // uint stakeBalance = staking.balanceOf( address(this) ) ;\n', '\n', '        //计算MainToken余额变化,即挖矿Token的余额变化，获取收益\n', '        uint beforeExit = _tokenBalance( MainToken ); \n', '        staking.exit() ;\n', '        uint afterExit = _tokenBalance( MainToken ); \n', '\n', '        uint interest = afterExit.sub( beforeExit ) ;\n', '\n', '        // remove liquidity\n', '        IUniswapV2Pair pair = IUniswapV2Pair( UniPairAddress ) ;\n', '        uint liquidityBalance = pair.balanceOf( address(this) ) ;\n', '        TransferHelper.safeTransfer( UniPairAddress , UniPairAddress , liquidityBalance ) ;\n', '        pair.burn( address(this) ) ;\n', '\n', '        //计算剩余本金\n', '        uint mainTokenBalance = _tokenBalance( MainToken ) ;\n', '        uint principal = mainTokenBalance.sub( interest ).sub( RewardAmount ).add( RewardGottedTotal ) ;  \n', '\n', '        // 收取 interest 的 10% 作为管理费\n', '        uint fee = _fee( interest ) ;\n', '        uint interestWithoutFee = interest - fee ;\n', '        //判断无偿损失\n', '        // 判断Token0是否受到了无偿损失影响\n', '        TokenRecord memory mainRecord = MainToken == Token0 ? Token0Record : Token1Record ;\n', '        \n', '        uint mainTokenRate = 5 ;\n', '        uint pairTokenRate = 5 ;  //各50%的收益,不需要补偿无偿损失的一方\n', '        if( mainRecord.total > principal ) {\n', '            // 有无偿损失\n', '            uint diff = mainRecord.total - principal ;\n', '            uint minDiff = mainRecord.total.div( 10 ) ; // 10%的损失\n', '            if( diff > minDiff ) {\n', '                //满足补贴条件\n', '                mainTokenRate = 6 ;\n', '                pairTokenRate = 4 ;\n', '            }\n', '        } else {\n', '            // 计算另一个token的是否满足补偿条件\n', '            TokenRecord memory pairRecord = MainToken == Token0 ? Token1Record : Token0Record ;\n', '            //获取配对Token的余额\n', '            address pairToken = Token0 == MainToken ? Token1 : Token0 ;\n', '            //TODO 二池因为奖励token和挖矿token属于同一token，所以这里通过余额计算会存在问题，需要调整\n', '            uint pairTokenBalance = _tokenBalance( pairToken ) ;\n', '            uint diff = pairRecord.total - pairTokenBalance ;\n', '            uint minDiff = pairRecord.total.div(10) ;\n', '            if( diff > minDiff ) {\n', '                pairTokenRate = 6 ;\n', '                mainTokenRate = 4 ;\n', '            }\n', '        }\n', '\n', '        ( uint token0Rate , uint token1Rate ) = Token0 == MainToken ? \n', '            ( mainTokenRate , pairTokenRate) : ( pairTokenRate , mainTokenRate ) ;\n', '\n', '        Token0Record.reward = RewardAmount.mul( token0Rate ).div( 10 ) ;\n', '        Token1Record.reward = RewardAmount.mul( token1Rate ).div( 10 ) ;\n', '\n', '        Token0Record.mint = interestWithoutFee.mul( token0Rate ).div( 10 ) ;\n', '        Token1Record.mint = interestWithoutFee.mul( token1Rate ).div( 10 ) ;\n', '\n', '        // 设置为挖矿结束\n', '        Status = 9 ;\n', '    }\n', '\n', '    /**\n', '     *  添加流动性并开始挖矿时\n', '     *      1、不接收继续存入资产。\n', '     *      2、开始计算PairX的挖矿奖励，并线性释放。\n', '     */\n', '    function addLiquidityAndStake( ) external onlyOwner returns ( uint token0Amount , uint token1Amount , uint liquidity , uint stake ) {\n', '        //TODO 在二池的情况下有问题\n', '        // uint token0Balance = _tokenBalance( Token0 ) ;\n', '        // uint token1Balance = _tokenBalance( Token1 ) ;\n', '        uint token0Balance = Token0Record.total ; \n', '        uint token1Balance = Token1Record.total ;\n', '\n', '        require( token0Balance > MinToken0Deposit && token1Balance > MinToken1Deposit , "No enought balance ." ) ;\n', '        IUniswapV2Pair pair = IUniswapV2Pair( UniPairAddress ) ;\n', '        ( uint reserve0 , uint reserve1 , ) = pair.getReserves() ;  // sorted\n', '\n', '        //先计算将A全部存入需要B的配对量\n', '        token0Amount = token0Balance ;\n', '        token1Amount = token0Amount.mul( reserve1 ) /reserve0 ;\n', '        if( token1Amount > token1Balance ) {\n', '            //计算将B全部存入需要的B的总量\n', '            token1Amount = token1Balance ;\n', '            token0Amount = token1Amount.mul( reserve0 ) / reserve1 ;\n', '        } \n', '\n', '        require( token0Amount > 0 && token1Amount > 0 , "No enought tokens for pair." ) ;\n', '        TransferHelper.safeTransfer( Token0 , UniPairAddress , token0Amount ) ;\n', '        TransferHelper.safeTransfer( Token1 , UniPairAddress , token1Amount ) ;\n', '\n', '        //add liquidity\n', '        liquidity = pair.mint( address(this) ) ;\n', '\n', '        require( liquidity > 0 , "Stake faild. No liquidity." ) ;\n', '        //stake \n', '        stake = _stake( ) ;\n', '        // 开始计算PairX挖矿\n', '        RewardBeginTime = getDateTime( block.timestamp ) ;\n', '        Status = 2 ;    //Locked \n', '    }\n', '\n', '    //提取存入代币及挖矿收益,一次性全部提取\n', '    function claim( address token ) public override returns (uint amount ) {\n', '        // require( StakeEndTime <= block.timestamp , "Unexpired for locked.") ;\n', '        // 余额做了处理,不用担心重入\n', '        amount = UserBalance[msg.sender][token] ;\n', '\n', '        require( amount > 0 , "Invaild request, balance is not enough." ) ;\n', '        require( Status != 2 , "Not finish. " ) ;   //locked\n', '        require( token == Token0 || token == Token1 , "No matched token.") ; \n', '        uint reward = 0 ;\n', '        uint principal = amount ;\n', '        uint interest = 0 ;\n', '        if( Status == 1 ) {\n', '            // 直接提取本金,但没有任何收益\n', '            _safeTransfer( token , msg.sender , amount ) ;\n', '            if( token == Token0 ) {\n', '                Token0Record.total = Token0Record.total.sub( amount ) ;\n', '                Token0Record.withdraw = Token0Record.total ;\n', '            }\n', '            if( token == Token1 ) {\n', '                Token1Record.total = Token1Record.total.sub( amount ) ;\n', '                Token1Record.withdraw = Token1Record.total ;\n', '            }\n', '            // UserBalance[msg.sender][token] = UserBalance[msg.sender][token].sub( amount ) ; \n', '        } \n', '\n', '        if( Status == 9 ) {\n', '            TokenRecord storage tokenRecord = token == Token0 ? Token0Record : Token1Record ;\n', '            // 计算可提取的本金 amount / total * withdraw\n', '            principal = amount.div(1e15).mul( tokenRecord.withdraw ).div( tokenRecord.total.div(1e15) );\n', '            if( tokenRecord.mint > 0 ) {\n', '                interest = amount.div(1e15).mul( tokenRecord.mint ).div( tokenRecord.total.div(1e15) ) ;\n', '            }\n', '            \n', '            // if( token == Token0 ) {\n', '            //     tokenBalance = Token0Record.total ;\n', '            // }\n', '            if( token == MainToken ) {\n', '                // 一次性转入\n', '                uint tranAmount = principal + interest ;\n', '                _safeTransfer( token , msg.sender , tranAmount ) ;\n', '            } else {\n', '                _safeTransfer( token , msg.sender , principal ) ;\n', '                if( interest > 0 ) {\n', '                    // 分别转出\n', '                    _safeTransfer( MainToken , msg.sender , interest ) ;\n', '                }\n', '            }\n', '\n', '            // 提取解锁的解锁的全部奖励\n', '            reward = redeem( token ) ;\n', '        }\n', '        \n', '        // clear \n', '        UserBalance[msg.sender][token] = uint(0);\n', '\n', '        emit Claim( address(this) , msg.sender , token , principal , interest , reward ) ;\n', '    }\n', '\n', '    function _stake() internal returns (uint stake ) {\n', '        IStakingRewards staking = IStakingRewards( StakeAddress ) ;\n', '        uint liquidity = IUniswapV2Pair( UniPairAddress ).balanceOf( address(this) ) ;\n', '        stake = liquidity ;\n', '        TransferHelper.safeApprove( UniPairAddress , StakeAddress , liquidity) ;\n', '        staking.stake( liquidity ) ;\n', '        // emit Staking( address(this) , StakeAddress , liquidity , stake ) ;\n', '    }\n', '\n', '    function depositETH() external payable {\n', '        uint ethValue = msg.value ;\n', '        require( ethValue > 0 , "Payment is zero." ) ;\n', '        address weth = Token0 == MainToken ? Token1 : Token0 ;\n', '        deposit( weth , msg.sender , ethValue ) ;\n', '    }\n', '\n', '    function _safeTransfer( address token , address to , uint amount ) internal {\n', '        uint balance = _tokenBalance( token ) ;\n', '        if( amount > balance ){\n', '            amount = balance ;\n', '        }\n', '        if( token == MainToken ) {\n', '            TransferHelper.safeTransfer( token , to , amount ) ;\n', '        } else {\n', '            // weth\n', '            IWETH( token ).withdraw( amount ) ;\n', '            TransferHelper.safeTransferETH( to , amount );\n', '        }\n', '    }\n', '\n', '    function _tokenBalance( address token ) internal view returns (uint) {\n', '        return IERC20( token ).balanceOf( address(this) ) ;\n', '    }\n', '\n', '    receive() external payable {\n', '        assert(msg.sender == Token0 || msg.sender == Token1 ); // only accept ETH via fallback from the WETH contract\n', '    }\n', '\n', '}']