['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-28\n', '*/\n', '\n', 'pragma solidity 0.6.12;\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'abstract contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', 'interface StandardToken {\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    function balanceOf(address account) external view returns (uint256);\n', '}\n', '\n', 'interface IController {\n', '    function withdrawETH(uint256 amount) external;\n', '    function depositForStrategy(uint256 amount, address addr) external;\n', '    function buyForStrategy(\n', '        uint256 amount,\n', '        address rewardToken,\n', '        address recipient\n', '    ) external;\n', '\n', '    function sendExitToken(\n', '        address user,\n', '        uint256 amount\n', '    ) external;\n', '\n', '    function getStrategy(address vault) external view returns (address);\n', '}\n', '\n', 'interface IStrategy {\n', '    function getLastEpochTime() external view returns(uint256);\n', '}\n', '\n', 'contract StakeAndYield is Ownable {\n', '    uint256 constant STAKE = 1;\n', '    uint256 constant YIELD = 2;\n', '    uint256 constant BOTH = 3;\n', '\n', '    uint256 public PERIOD = 24 hours;\n', '    uint256 public EXIT_PERIOD = 90 days;\n', '\n', '    uint256 public lastUpdateTime;\n', '    uint256 public rewardRate;\n', '    uint256 public rewardRateYield;\n', '\n', '    uint256 public rewardTillNowPerToken = 0;\n', '    uint256 public yieldRewardTillNowPerToken = 0;\n', '\n', '    uint256 public _totalSupply = 0;\n', '    uint256 public _totalSupplyYield = 0;\n', '\n', '    uint256 public _totalYieldWithdrawed = 0;\n', '    uint256 public _totalExit = 0;\n', '    uint256 public _totalBurned = 0;\n', '\n', '    // false: withdraw from YEARN and then pay the user\n', '    // true: pay the user before withdrawing from YEARN\n', '    bool public allowEmergencyWithdraw = false;\n', '\n', '    IController public controller;\n', '\n', '    address public operator;\n', '\n', '    struct User {\n', '        uint256 balance;\n', '        uint256 stakeType;\n', '\n', '        uint256 paidReward;\n', '        uint256 yieldPaidReward;\n', '\n', '        uint256 paidRewardPerToken;\n', '        uint256 yieldPaidRewardPerToken;\n', '\n', '        uint256 withdrawable;\n', '        uint256 withdrawableExit;\n', '        uint256 withdrawTime;\n', '\n', '        bool exit;\n', '\n', '        uint256 exitStartTime;\n', '        uint256 exitAmountTillNow;\n', '    }\n', '\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => User) public users;\n', '\n', '    uint256 public lastUpdatedBlock;\n', '\n', '    uint256 public periodFinish = 0;\n', '\n', '    uint256 public scale = 1e18;\n', '\n', '    uint256 public daoShare;\n', '    address public daoWallet;\n', '\n', '    bool public exitable;\n', '\n', '    StandardToken public stakedToken;\n', '    StandardToken public rewardToken;\n', '    StandardToken public yieldRewardToken;\n', '\n', '    event Deposit(address user, uint256 amount, uint256 stakeType);\n', '    event Withdraw(address user, uint256 amount, uint256 stakeType);\n', '    event Exit(address user, uint256 amount, uint256 stakeType);\n', '    event Unfreeze(address user, uint256 amount, uint256 stakeType);\n', '    event EmergencyWithdraw(address user, uint256 amount);\n', '    event RewardClaimed(address user, uint256 amount, uint256 stakeType);\n', '\n', '    constructor (\n', '        address _stakedToken,\n', '        address _rewardToken,\n', '        address _yieldRewardToken,\n', '        uint256 _daoShare,\n', '        address _daoWallet,\n', '        address _controller,\n', '        bool _exitable\n', '    ) public {\n', '        stakedToken = StandardToken(_stakedToken);\n', '        rewardToken = StandardToken(_rewardToken);\n', '        yieldRewardToken = StandardToken(_yieldRewardToken);\n', '        controller = IController(_controller);\n', '        daoShare = _daoShare;\n', '        daoWallet = _daoWallet;\n', '        exitable = _exitable;\n', '\n', '        operator = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwnerOrController(){\n', '        require(msg.sender == owner() ||\n', '            msg.sender == address(controller) ||\n', '            msg.sender == operator\n', '            ,\n', '            "!ownerOrController"\n', '        );\n', '        _;\n', '    }\n', '\n', '    modifier updateReward(address account, uint256 stakeType) {\n', '        if(users[account].balance > 0){\n', '            stakeType = users[account].stakeType;\n', '        }\n', '        \n', '        if (account != address(0)) {\n', '            sendReward(\n', '                account,\n', '                earned(account, STAKE),\n', '                earned(account, YIELD)\n', '            );\n', '        }\n', '        if(stakeType == STAKE || stakeType == BOTH){\n', '            rewardTillNowPerToken = rewardPerToken(STAKE);\n', '            lastUpdateTime = lastTimeRewardApplicable();\n', '            if (account != address(0)) {\n', '                users[account].paidRewardPerToken = rewardTillNowPerToken;\n', '            }\n', '        }\n', '\n', '        if(stakeType == YIELD || stakeType == BOTH){\n', '            yieldRewardTillNowPerToken = rewardPerToken(YIELD);\n', '            lastUpdateTime = lastTimeRewardApplicable();\n', '            if (account != address(0)) {\n', '                users[account].yieldPaidRewardPerToken = yieldRewardTillNowPerToken;\n', '            }\n', '        }\n', '        _;\n', '    }\n', '\n', '    function setDaoWallet(address _daoWallet) public onlyOwner {\n', '        daoWallet = _daoWallet;\n', '    }\n', '\n', '    function setDaoShare(uint256 _daoShare) public onlyOwner {\n', '        daoShare = _daoShare;\n', '    }\n', '\n', '    function setExitPeriod(uint256 period) public onlyOwner {\n', '        EXIT_PERIOD = period;\n', '    }\n', '\n', '    function setOperator(address _addr) public onlyOwner{\n', '        operator = _addr;\n', '    }\n', '\n', '    function setPeriod(uint256 period) public onlyOwner{\n', '        PERIOD = period;\n', '    }\n', '\n', '    function withdrawToBurn() public onlyOwner{\n', '        stakedToken.transfer(\n', '            msg.sender,\n', '            _totalExit.sub(_totalBurned)\n', '        );\n', '        _totalBurned = _totalExit;\n', '    }\n', '\n', '    function earned(address account, uint256 stakeType) public view returns(uint256) {\n', '        User storage user = users[account];\n', '\n', '        uint256 paidPerToken = stakeType == STAKE ? \n', '            user.paidRewardPerToken : user.yieldPaidRewardPerToken;\n', '\n', '        return balanceOf(account, stakeType).mul(\n', '            rewardPerToken(stakeType).\n', '            sub(paidPerToken)\n', '        ).div(1e18);\n', '    }\n', '\n', '\n', '    function earned(address account) public view returns(uint256){\n', '        return earned(account, STAKE) + earned(account, YIELD);\n', '    }\n', '\n', '    function deposit(uint256 amount, uint256 stakeType, bool _exit) public {\n', '        depositFor(msg.sender, amount, stakeType, _exit);\n', '    }\n', '\n', '    function depositFor(address _user, uint256 amount, uint256 stakeType, bool _exit)\n', '        updateReward(_user, stakeType)\n', '        public {\n', '        \n', '        require(stakeType==STAKE || stakeType ==YIELD || stakeType==BOTH, "Invalid stakeType");\n', '        User storage user = users[_user];\n', '        require(user.balance == 0 || user.stakeType==stakeType, "Invalid Stake Type");\n', '\n', '        if(user.exit || (user.balance == 0 && _exit)){\n', '            updateExit(_user);\n', '        }else if(user.balance == 0 && !_exit){\n', '            user.exit = false;\n', '        }\n', '\n', '        stakedToken.transferFrom(address(msg.sender), address(this), amount);\n', '\n', '        user.stakeType = stakeType;\n', '        user.balance = user.balance.add(amount);\n', '\n', '        if(stakeType == STAKE){\n', '            _totalSupply = _totalSupply.add(amount);\n', '        }else if(stakeType == YIELD){\n', '            _totalSupplyYield = _totalSupplyYield.add(amount);\n', '        }else{\n', '            _totalSupplyYield = _totalSupplyYield.add(amount);\n', '            _totalSupply = _totalSupply.add(amount);\n', '        }\n', '        \n', '        emit Deposit(_user, amount, stakeType);\n', '    }\n', '\n', '    function updateExit(address _user) private{\n', '        require(exitable, "Not exitable");\n', '        User storage user = users[_user];\n', '        user.exit = true;\n', '        user.exitAmountTillNow = exitBalance(_user);\n', '        user.exitStartTime = block.timestamp;\n', '    }\n', '\n', '    function sendReward(address userAddress, uint256 amount, uint256 yieldAmount) private {\n', '        User storage user = users[userAddress];\n', '        uint256 _daoShare = amount.mul(daoShare).div(scale);\n', '        uint256 _yieldDaoShare = yieldAmount.mul(daoShare).div(scale);\n', '\n', '        if(amount > 0){\n', '            rewardToken.transfer(userAddress, amount.sub(_daoShare));\n', '            if(_daoShare > 0)\n', '                rewardToken.transfer(daoWallet, _daoShare);\n', '            user.paidReward = user.paidReward.add(\n', '                amount\n', '            );\n', '        }\n', '\n', '        if(yieldAmount > 0){\n', '            yieldRewardToken.transfer(userAddress, yieldAmount.sub(_yieldDaoShare));\n', '            \n', '            if(_yieldDaoShare > 0)\n', '                yieldRewardToken.transfer(daoWallet, _yieldDaoShare);   \n', '            \n', '            user.yieldPaidReward = user.yieldPaidReward.add(\n', '                yieldAmount\n', '            );\n', '        }\n', '        \n', '        if(amount > 0 || yieldAmount > 0){\n', '            emit RewardClaimed(userAddress, amount, yieldAmount);\n', '        }\n', '    }\n', '\n', '    function sendExitToken(address _user, uint256 amount) private {\n', '        controller.sendExitToken(\n', '            _user,\n', '            amount\n', '        );\n', '    }\n', '\n', '    function claim() updateReward(msg.sender, 0) public {\n', '        // updateReward handles everything\n', '    }\n', '\n', '    function setExit(bool _val) public{\n', '        User storage user = users[msg.sender];\n', '        require(user.exit != _val, "same exit status");\n', '        require(user.balance > 0, "0 balance");\n', '\n', '        user.exit = _val;\n', '        user.exitStartTime = now;\n', '        user.exitAmountTillNow = 0;\n', '    }\n', '\n', '    function unfreezeAllAndClaim() public{\n', '        unfreeze(users[msg.sender].balance);\n', '    }\n', '\n', '    function unfreeze(uint256 amount) updateReward(msg.sender, 0) public {\n', '        User storage user = users[msg.sender];\n', '        uint256 stakeType = user.stakeType;\n', '\n', '        require(\n', '            user.balance >= amount,\n', '            "withdraw > deposit");\n', '\n', '        if (amount > 0) {\n', '            uint256 exitAmount = exitBalance(msg.sender);\n', '            uint256 remainingExit = 0;\n', '            if(exitAmount > amount){\n', '                remainingExit = exitAmount.sub(amount);\n', '                exitAmount = amount;\n', '            }\n', '\n', '            if(user.exit){\n', '                user.exitAmountTillNow = remainingExit;\n', '                user.exitStartTime = now;\n', '            }\n', '\n', '            uint256 tokenAmount = amount.sub(exitAmount);\n', '            user.balance = user.balance.sub(amount);\n', '            if(stakeType == STAKE){\n', '                _totalSupply = _totalSupply.sub(amount);\n', '            }else if (stakeType == YIELD){\n', '                _totalSupplyYield = _totalSupplyYield.sub(amount);\n', '            }else{\n', '                _totalSupply = _totalSupply.sub(amount);\n', '                _totalSupplyYield = _totalSupplyYield.sub(amount);\n', '            }\n', '\n', '            if(allowEmergencyWithdraw || stakeType==STAKE){\n', '                if(tokenAmount > 0){\n', '                    stakedToken.transfer(address(msg.sender), tokenAmount);\n', '                    emit Withdraw(msg.sender, tokenAmount, stakeType);\n', '                }\n', '                if(exitAmount > 0){\n', '                    sendExitToken(msg.sender, exitAmount);\n', '                    emit Exit(msg.sender, exitAmount, stakeType);\n', '                }\n', '            }else{\n', '                user.withdrawable += tokenAmount;\n', '                user.withdrawableExit += exitAmount;\n', '\n', '                user.withdrawTime = now;\n', '\n', '                _totalYieldWithdrawed += amount;\n', '                emit Unfreeze(msg.sender, amount, stakeType);\n', '            }\n', '            _totalExit += exitAmount;\n', '        }\n', '    }\n', '\n', '    function withdrawUnfreezed() public{\n', '        User storage user = users[msg.sender];\n', '        require(user.withdrawable > 0 || user.withdrawableExit > 0, \n', '            "amount is 0");\n', '        \n', '        uint256 lastEpochTime = IStrategy(\n', '            controller.getStrategy(address(this))\n', '        ).getLastEpochTime();\n', '        require(user.withdrawTime < lastEpochTime,\n', '            "Can\'t withdraw yet");\n', '\n', '        if(user.withdrawable > 0){\n', '            stakedToken.transfer(address(msg.sender), user.withdrawable);\n', '            emit Withdraw(msg.sender, user.withdrawable, YIELD);\n', '            user.withdrawable = 0;    \n', '        }\n', '\n', '        if(user.withdrawableExit > 0){\n', '            sendExitToken(msg.sender, user.withdrawableExit);\n', '            emit Exit(msg.sender, user.withdrawableExit, YIELD);\n', '            user.withdrawableExit = 0;    \n', '        }\n', '    }\n', '\n', '    // just Controller and admin should be able to call this\n', '    function notifyRewardAmount(uint256 reward, uint256 stakeType) public onlyOwnerOrController  updateReward(address(0), stakeType){\n', '        if (block.timestamp >= periodFinish) {\n', '            if(stakeType == STAKE){\n', '                rewardRate = reward.div(PERIOD);    \n', '            }else{\n', '                rewardRateYield = reward.div(PERIOD);\n', '            }\n', '        } else {\n', '            uint256 remaining = periodFinish.sub(block.timestamp);\n', '            if(stakeType == STAKE){\n', '                uint256 leftover = remaining.mul(rewardRate);\n', '                rewardRate = reward.add(leftover).div(PERIOD);    \n', '            }else{\n', '                uint256 leftover = remaining.mul(rewardRateYield);\n', '                rewardRateYield = reward.add(leftover).div(PERIOD);\n', '            }\n', '            \n', '        }\n', '        lastUpdateTime = block.timestamp;\n', '        periodFinish = block.timestamp.add(PERIOD);\n', '    }\n', '\n', '    function balanceOf(address account, uint256 stakeType) public view returns(uint256) {\n', '        User storage user = users[account];\n', '        if(user.stakeType == BOTH || user.stakeType==stakeType)\n', '            return user.balance;\n', '        return 0;\n', '    }\n', '\n', '    function exitBalance(address account) public view returns(uint256){\n', '        User storage user = users[account];\n', '        if(!user.exit || user.balance==0){\n', '            return 0;\n', '        }\n', '        uint256 portion = (block.timestamp - user.exitStartTime).div(EXIT_PERIOD);\n', '        portion = portion >= 1 ? 1 : portion;\n', '        \n', '        uint256 balance = user.exitAmountTillNow.add(\n', '                user.balance.mul(portion)\n', '        );\n', '        return balance > user.balance ? user.balance : balance;\n', '    }\n', '\n', '    function totalYieldWithdrawed() public view returns(uint256) {\n', '        return _totalYieldWithdrawed;\n', '    }\n', '\n', '    function totalExit() public view returns(uint256) {\n', '        return _totalExit;\n', '    }\n', '\n', '    function totalSupply(uint256 stakeType) public view returns(uint256) {\n', '        return stakeType == STAKE ? _totalSupply : _totalSupplyYield;\n', '    }\n', '\n', '    function lastTimeRewardApplicable() public view returns(uint256) {\n', '        return block.timestamp < periodFinish ? block.timestamp : periodFinish;\n', '    }\n', '\n', '    function rewardPerToken(uint256 stakeType) public view returns(uint256) {\n', '        uint256 supply = stakeType == STAKE ? _totalSupply : _totalSupplyYield;        \n', '        if (supply == 0) {\n', '            return stakeType == STAKE ? rewardTillNowPerToken : yieldRewardTillNowPerToken;\n', '        }\n', '        if(stakeType == STAKE){\n', '            return rewardTillNowPerToken.add(\n', '                lastTimeRewardApplicable().sub(lastUpdateTime)\n', '                .mul(rewardRate).mul(1e18).div(_totalSupply)\n', '            );\n', '        }else{\n', '            return yieldRewardTillNowPerToken.add(\n', '                lastTimeRewardApplicable().sub(lastUpdateTime).\n', '                mul(rewardRateYield).mul(1e18).div(_totalSupplyYield)\n', '            );\n', '        }\n', '    }\n', '\n', '    function getRewardToken() public view returns(address){\n', '        return address(rewardToken);\n', '    }\n', '\n', '    function userInfo(address account) public view returns(\n', '        uint256[14] memory numbers,\n', '\n', '        address rewardTokenAddress,\n', '        address stakedTokenAddress,\n', '        address controllerAddress,\n', '        address strategyAddress,\n', '        bool exit\n', '    ){\n', '        User storage user = users[account];\n', '        numbers[0] = user.balance;\n', '        numbers[1] = user.stakeType;\n', '        numbers[2] = user.withdrawTime;\n', '        numbers[3] = user.withdrawable;\n', '        numbers[4] = _totalSupply;\n', '        numbers[5] = _totalSupplyYield;\n', '        numbers[6] = stakedToken.balanceOf(address(this));\n', '        \n', '        numbers[7] = rewardPerToken(STAKE);\n', '        numbers[8] = rewardPerToken(YIELD);\n', '        \n', '        numbers[9] = earned(account);\n', '\n', '        numbers[10] = user.exitStartTime;\n', '        numbers[11] = exitBalance(account);\n', '\n', '        numbers[12] = user.withdrawable;\n', '        numbers[13] = user.withdrawableExit;\n', '\n', '        rewardTokenAddress = address(rewardToken);\n', '        stakedTokenAddress = address(stakedToken);\n', '        controllerAddress = address(controller);\n', '\n', '        exit = user.exit;\n', '\n', '\n', '        strategyAddress = controller.getStrategy(address(this));\n', '\n', '        numbers[10] = IStrategy(\n', '            controller.getStrategy(address(this))\n', '        ).getLastEpochTime();\n', '    }\n', '\n', '    function setController(address _controller) public onlyOwner{\n', '        if(_controller != address(0)){\n', '            controller = IController(_controller);\n', '        }\n', '    }\n', '\n', '    function emergencyWithdrawFor(address _user) public onlyOwner{\n', '        User storage user = users[_user];\n', '\n', '        uint256 amount = user.balance;\n', '\n', '        stakedToken.transfer(_user, amount);\n', '\n', '        emit EmergencyWithdraw(_user, amount);\n', '\n', '        //add other fields\n', '        user.balance = 0;\n', '        user.paidReward = 0;\n', '        user.yieldPaidReward = 0;\n', '    }\n', '\n', '    function setAllowEmergencyWithdraw(bool _val) public onlyOwner{\n', '        allowEmergencyWithdraw = _val;\n', '    }\n', '\n', '    function setExitable(bool _val) public onlyOwner{\n', '        exitable = _val;\n', '    }\n', '\n', '    function emergencyWithdrawETH(uint256 amount, address addr) public onlyOwner{\n', '        require(addr != address(0));\n', '        payable(addr).transfer(amount);\n', '    }\n', '\n', '    function emergencyWithdrawERC20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner {\n', '        StandardToken(_tokenAddr).transfer(_to, _amount);\n', '    }\n', '}\n', '\n', '\n', '\n', '//Dar panah khoda']