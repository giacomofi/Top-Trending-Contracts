['pragma solidity 0.5.16;\n', '\n', '\n', 'library Math {\n', '    function max(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '    function min(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '    function average(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // (a + b) / 2 can overflow, so we distribute\n', '        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    \n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'contract Context {\n', '    // Empty internal constructor, to prevent people from mistakenly deploying\n', '    // an instance of this contract, which should be used via inheritance.\n', '    constructor () internal { }\n', '    // solhint-disable-previous-line no-empty-blocks\n', '\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor () internal {\n', '        _owner = _msgSender();\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    function isOwner() public view returns (bool) {\n', '        return _msgSender() == _owner;\n', '    }\n', '\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function mint(address account, uint amount) external;\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library Address {\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies in extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', "        // for accounts without code, i.e. `keccak256('')`\n", '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != 0x0 && codehash != accountHash);\n', '    }\n', '\n', '    function toPayable(address account) internal pure returns (address payable) {\n', '        return address(uint160(account));\n', '    }\n', '\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-call-value\n', '        (bool success, ) = recipient.call.value(amount)("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '}\n', '\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves.\n", '\n', '        // A Solidity high level call has three parts:\n', '        //  1. The target address is checked to verify it contains contract code\n', '        //  2. The call itself is made, and success asserted\n', '        //  3. The return value is decoded, which in turn checks the size of the returned data.\n', '        // solhint-disable-next-line max-line-length\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', '/**\n', ' * Reward Amount Interface\n', ' */\n', 'contract IRewardDistributionRecipient is Ownable {\n', '    address rewardDistribution;\n', '\n', '    function notifyRewardAmount(uint256 reward) external;\n', '\n', '    modifier onlyRewardDistribution() {\n', '        require(_msgSender() == rewardDistribution, "Caller is not reward distribution");\n', '        _;\n', '    }\n', '\n', '    function setRewardDistribution(address _rewardDistribution)\n', '        external\n', '        onlyOwner\n', '    {\n', '        rewardDistribution = _rewardDistribution;\n', '    }\n', '}\n', '\n', '/**\n', ' * Staking Token Wrapper\n', ' */\n', 'pragma solidity 0.5.16;\n', '\n', 'contract GOFTokenWrapper {\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for IERC20;\n', '\n', '    //GOF TOKEN \n', '    IERC20 public gof = IERC20(0x488E0369f9BC5C40C002eA7c1fe4fd01A198801c);\n', '\n', '    uint256 private _totalSupply;\n', '    mapping(address => uint256) private _balances;\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address account) public view returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    function stake(uint256 amount) public {\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[msg.sender] = _balances[msg.sender].add(amount);\n', '        gof.safeTransferFrom(msg.sender, address(this), amount);\n', '    }\n', '\n', '    function withdraw(uint256 amount) public {\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        _balances[msg.sender] = _balances[msg.sender].sub(amount);\n', '        gof.safeTransfer(msg.sender, amount);\n', '    }\n', '}\n', '\n', '/**\n', ' * GOF Pool\n', ' */\n', 'contract GOFPool is GOFTokenWrapper, IRewardDistributionRecipient {\n', '\n', '    uint256 public constant DURATION = 7 days;\n', '    uint256 public constant FROZEN_STAKING_TIME = 24 hours;\n', '\n', '    uint256 public constant startTime = 1601467200; //utc+8 2020-09-30 20:00:00\n', '    uint256 public periodFinish = 0;\n', '    uint256 public rewardRate = 0;\n', '    uint256 public lastUpdateTime;\n', '    uint256 public rewardPerTokenStored = 0;\n', '    bool private open = true;\n', '    uint256 private constant _gunit = 1e18;\n', '    mapping(address => uint256) public userRewardPerTokenPaid; \n', '    mapping(address => uint256) public rewards; // Unclaimed rewards\n', '\n', '    mapping(address => uint256) public lastStakeTimes;\n', '\n', '    event RewardAdded(uint256 reward);\n', '    event Staked(address indexed user, uint256 amount);\n', '    event Withdrawn(address indexed user, uint256 amount);\n', '    event RewardPaid(address indexed user, uint256 reward);\n', '    event SetOpen(bool _open);\n', '\n', '    modifier updateReward(address account) {\n', '        rewardPerTokenStored = rewardPerToken();\n', '        lastUpdateTime = lastTimeRewardApplicable();\n', '        if (account != address(0)) {\n', '            rewards[account] = earned(account);\n', '            userRewardPerTokenPaid[account] = rewardPerTokenStored;\n', '        }\n', '        _;\n', '    }\n', '\n', '    function lastTimeRewardApplicable() public view returns (uint256) {\n', '        return Math.min(block.timestamp, periodFinish);\n', '    }\n', '\n', '    /**\n', '     * Calculate the rewards for each token\n', '     */\n', '    function rewardPerToken() public view returns (uint256) {\n', '        if (totalSupply() == 0) {\n', '            return rewardPerTokenStored;\n', '        }\n', '        return\n', '            rewardPerTokenStored.add(\n', '                lastTimeRewardApplicable()\n', '                    .sub(lastUpdateTime)\n', '                    .mul(rewardRate)\n', '                    .mul(_gunit)\n', '                    .div(totalSupply())\n', '            );\n', '    }\n', '\n', '    function earned(address account) public view returns (uint256) {\n', '        uint256 calculatedEarned = \n', '            balanceOf(account)\n', '                .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))\n', '                .div(_gunit)\n', '                .add(rewards[account]);\n', '        uint256 poolBalance = gof.balanceOf(address(this));\n', '        if (poolBalance < totalSupply()) return 0;\n', '        if (calculatedEarned.add(totalSupply()) > poolBalance) return poolBalance.sub(totalSupply());\n', '        return calculatedEarned;\n', '    }\n', '\n', '    function stake(uint256 amount) public checkOpen checkStart updateReward(msg.sender){ \n', '        require(amount > 0, "Golff-GOF-POOL: Cannot stake 0");\n', '        super.stake(amount);\n', '        lastStakeTimes[msg.sender] = block.timestamp;\n', '        emit Staked(msg.sender, amount);\n', '    }\n', '\n', '    function unfrozenStakeTime(address account) public view returns (uint256) {\n', '        return lastStakeTimes[account] + FROZEN_STAKING_TIME;\n', '    }\n', '\n', '    function withdraw(uint256 amount) public checkStart updateReward(msg.sender){\n', '        require(amount > 0, "Golff-GOF-POOL: Cannot withdraw 0");\n', '        super.withdraw(amount);\n', '        emit Withdrawn(msg.sender, amount);\n', '    }\n', '\n', '    function exit() external {\n', '        withdraw(balanceOf(msg.sender));\n', '        getReward();\n', '    }\n', '\n', '    function getReward() public checkStart updateReward(msg.sender){\n', '        uint256 reward = earned(msg.sender);\n', '        if (reward > 0) {\n', '            rewards[msg.sender] = 0;\n', '            gof.safeTransfer(msg.sender, reward);\n', '            emit RewardPaid(msg.sender, reward);\n', '        }\n', '    }\n', '\n', '    modifier checkStart(){\n', '        require(block.timestamp > startTime,"Golff-GOF-POOL: not start");\n', '        _;\n', '    }\n', '\n', '    modifier checkOpen() {\n', '        require(open, "Golff-GOF-POOL: Pool is closed");\n', '        _;\n', '    }\n', '\n', '    function getPeriodFinish() external view returns (uint256) {\n', '        return periodFinish;\n', '    }\n', '\n', '    function isOpen() external view returns (bool) {\n', '        return open;\n', '    }\n', '\n', '    function setOpen(bool _open) external onlyOwner {\n', '        open = _open;\n', '        emit SetOpen(_open);\n', '    }\n', '\n', '    function notifyRewardAmount(uint256 reward)\n', '        external\n', '        onlyRewardDistribution\n', '        checkOpen\n', '        updateReward(address(0)) {\n', '        if (block.timestamp > startTime){\n', '            if (block.timestamp >= periodFinish) {\n', '                uint256 period = block.timestamp.sub(startTime).div(DURATION).add(1);\n', '                periodFinish = startTime.add(period.mul(DURATION));\n', '                rewardRate = reward.div(periodFinish.sub(block.timestamp));\n', '            } else {\n', '                uint256 remaining = periodFinish.sub(block.timestamp);\n', '                uint256 leftover = remaining.mul(rewardRate);\n', '                rewardRate = reward.add(leftover).div(remaining);\n', '            }\n', '            lastUpdateTime = block.timestamp;\n', '        }else {\n', '          uint256 b = gof.balanceOf(address(this));\n', '          rewardRate = reward.add(b).div(DURATION);\n', '          periodFinish = startTime.add(DURATION);\n', '          lastUpdateTime = startTime;\n', '        }\n', '\n', '        gof.mint(address(this),reward);\n', '        emit RewardAdded(reward);\n', '\n', '        // avoid overflow to lock assets\n', '        _checkRewardRate();\n', '    }\n', '    \n', '    function _checkRewardRate() internal view returns (uint256) {\n', '        return DURATION.mul(rewardRate).mul(_gunit);\n', '    }\n', '}']