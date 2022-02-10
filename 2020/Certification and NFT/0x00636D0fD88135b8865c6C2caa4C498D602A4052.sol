['/*\n', '   ____            __   __        __   _\n', '  / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __\n', ' _\\ \\ / // // _ \\/ __// _ \\/ -_)/ __// / \\ \\ /\n', '/___/ \\_, //_//_/\\__//_//_/\\__/ \\__//_/ /_\\_\\\n', '     /___/\n', '\n', '* Synthetix: Pyramid.sol\n', '*\n', '* Docs: https://docs.synthetix.io/\n', '*\n', '*\n', '* MIT License\n', '* ===========\n', '*\n', '* Copyright (c) 2020 Synthetix\n', '*\n', '* Permission is hereby granted, free of charge, to any person obtaining a copy\n', '* of this software and associated documentation files (the "Software"), to deal\n', '* in the Software without restriction, including without limitation the rights\n', '* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\n', '* copies of the Software, and to permit persons to whom the Software is\n', '* furnished to do so, subject to the following conditions:\n', '*\n', '* The above copyright notice and this permission notice shall be included in all\n', '* copies or substantial portions of the Software.\n', '*\n', '* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n', '* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n', '* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n', '* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n', '* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n', '* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\n', '*/\n', '\n', '// File: @openzeppelin/contracts/math/Math.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @dev Standard math utilities missing in the Solidity language.\n', ' */\n', 'library Math {\n', '\n', '    function max(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function average(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // (a + b) / 2 can overflow, so we distribute\n', '        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/math/SafeMath.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'library SafeMath {\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', '// File: @openzeppelin/contracts/ownership/Ownable.sol\n', '\n', 'contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor () internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '// File: eth-token-recover/contracts/TokenRecover.sol\n', '\n', 'contract TokenRecover is Ownable {\n', '\n', '    function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {\n', '        IERC20(tokenAddress).transfer(owner(), tokenAmount);\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/token/ERC20/IERC20.sol\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP. Does not include\n', ' * the optional functions; to access them see {ERC20Detailed}.\n', ' */\n', 'interface IERC20 {\n', '\n', '    function totalStaked() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    function burn(uint256 amount, uint256 bRate) external returns(uint256);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: @openzeppelin/contracts/utils/Address.sol\n', '\n', 'pragma solidity ^0.5.5;\n', '\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * This test is non-exhaustive, and there may be false-negatives: during the\n', "     * execution of a contract's constructor, its address will be reported as\n", '     * not containing a contract.\n', '     *\n', '     * IMPORTANT: It is unsafe to assume that an address for which this\n', '     * function returns false is an externally-owned account (EOA) and not a\n', '     * contract.\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies in extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', "        // for accounts without code, i.e. `keccak256('')`\n", '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != 0x0 && codehash != accountHash);\n', '    }\n', '\n', '    /**\n', '     * @dev Converts an `address` into `address payable`. Note that this is\n', '     * simply a type cast: the actual underlying value is not changed.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function toPayable(address account) internal pure returns (address payable) {\n', '        return address(uint160(account));\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-call-value\n', '        (bool success, ) = recipient.call.value(amount)("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure (when the token\n', ' * contract returns false). Tokens that return no value (and instead revert or\n', ' * throw on failure) are also supported, non-reverting calls are assumed to be\n', ' * successful.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves.\n", '\n', '        // A Solidity high level call has three parts:\n', '        //  1. The target address is checked to verify it contains contract code\n', '        //  2. The call itself is made, and success asserted\n', '        //  3. The return value is decoded, which in turn checks the size of the returned data.\n', '        // solhint-disable-next-line max-line-length\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/IRewardDistributionRecipient.sol\n', '\n', 'contract IRewardDistributionRecipient is Ownable {\n', '    address public rewardDistribution;\n', '\n', '    function notifyRewardAmount(uint256 reward) external;\n', '\n', '    modifier onlyRewardDistribution() {\n', '        require(msg.sender == rewardDistribution, "Caller is not reward distribution");\n', '        _;\n', '    }\n', '\n', '    function setRewardDistribution(address _rewardDistribution)\n', '        external\n', '        onlyOwner\n', '    {\n', '        rewardDistribution = _rewardDistribution;\n', '    }\n', '}\n', '\n', '// File: contracts/CurveRewards.sol\n', '\n', 'contract LPTokenWrapper {\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for IERC20;\n', '    \n', '    event Stake(address staker, uint256 amount, uint256 operateAmount);\n', '\n', '    IERC20 public rugStake;\n', '    uint256 burnRate = 3;\n', '    uint256 redistributeRate = 7;\n', '\n', '    uint256 internal _totalDividends;\n', '    uint256 internal _totalStaked;\n', '    uint256 internal _dividendsPerRug;\n', '\n', '    mapping(address => uint256) internal _stakeAmount;\n', '    mapping(address => uint256) internal _dividendsSnapshot; // Get "position" relative to _totalDividends\n', '    mapping(address => uint256) internal _userDividends;\n', '   \n', '    function totalStaked() public view returns (uint256) {\n', '        return _totalStaked;\n', '    }\n', '\n', '    function totalDividends() public view returns (uint256) {\n', '        return _totalDividends;\n', '    }\n', '\n', '    function balanceOf(address account) public view returns (uint256) {\n', '        return _stakeAmount[account];\n', '    }\n', '\n', '    function checkUserPayout(address staker) public view returns (uint256) {\n', '        return _dividendsSnapshot[staker];\n', '    }\n', ' \n', '    function dividendsPerRug() public view returns (uint256) {\n', '        return _dividendsPerRug;\n', '    }\n', '\n', '    function userDividends(address account) public view returns (uint256) { // Returns the amount of dividends that has been synced by _updateDividends()\n', '        return _userDividends[account];\n', '    }\n', '\n', '    function dividendsOf(address staker) public view returns (uint256) {\n', '        require(_dividendsPerRug >= _dividendsSnapshot[staker], "dividend calc overflow");\n', '        uint256 sum = balanceOf(staker).mul((_dividendsPerRug.sub(_dividendsSnapshot[staker]))).div(1e18);\n', '        return sum;\n', '    }\n', '\n', '    // adds dividends to staked balance\n', '    function _updateDividends() internal returns(uint256) {\n', '\t\tuint256 _dividends = dividendsOf(msg.sender);\n', '\t\trequire(_dividends >= 0);\n', '\n', '        _userDividends[msg.sender] = _userDividends[msg.sender].add(_dividends);\n', '        _dividendsSnapshot[msg.sender] = _dividendsPerRug;\n', '\t\treturn _dividends; // amount of dividends added to _userDividends[]\n', '    }\n', '\n', '    function displayDividends(address staker) public view returns(uint256) { //created solely to display total amount of dividends on rug.money\n', '        return (dividendsOf(staker) + userDividends(staker)); \n', '    }\n', '\n', '    // withdraw only dividends \n', '    function withdrawDividends() public {\n', '        _updateDividends();\n', '        uint256 amount = _userDividends[msg.sender];\n', '        _userDividends[msg.sender] = 0;\n', '        _totalDividends = _totalDividends.sub(amount);\n', '        rugStake.safeTransfer(msg.sender, amount);\n', '    }\n', '\n', '    // 10% fee: 7% redistribution, 3% burn\n', '    function stake(uint256 amount) public { \n', '        rugStake.safeTransferFrom(msg.sender, address(this), amount);\n', '\n', '        bool firstTime = false;\n', '        if (_stakeAmount[msg.sender] == 0) firstTime = true;\n', '\n', '        uint256 amountToStake = (amount.mul(uint256(100).sub((redistributeRate.add(burnRate)))).div(100));\n', '        uint256 operateAmount = amount.sub(amountToStake);\n', '        \n', '        uint256 burnAmount = operateAmount.mul(burnRate).div(10);\n', '        rugStake.burn(burnAmount, 100); // burns 100% of burnAmount\n', '       \n', '        uint256 dividendAmount = operateAmount.sub(burnAmount);\n', '\n', '        _totalDividends = _totalDividends.add(dividendAmount); \n', '\n', '        if (_totalStaked > 0) _dividendsPerRug = _dividendsPerRug.add(dividendAmount.mul(1e18).div(_totalStaked)); // prevents division by 0\n', '     \n', '        if (firstTime) _dividendsSnapshot[msg.sender] = _dividendsPerRug; // For first time stakers\n', '\n', "        _updateDividends(); // If you're restaking, reset snapshot back to _dividendsPerRug, reward previous staking.\n", '\n', '        _totalStaked = _totalStaked.add(amountToStake);\n', '        _stakeAmount[msg.sender] = _stakeAmount[msg.sender].add(amountToStake);\n', '     \n', '        emit Stake(msg.sender, amountToStake, operateAmount);\n', '    }\n', '\n', '    function withdraw(uint256 amount) public { \n', '        _totalStaked = _totalStaked.sub(amount);\n', '        _stakeAmount[msg.sender] = _stakeAmount[msg.sender].sub(amount);\n', '        rugStake.safeTransfer(msg.sender, amount);\n', '    }\n', '}\n', '\n', 'contract PyramidPool is LPTokenWrapper, IRewardDistributionRecipient, TokenRecover {\n', '\n', '    constructor() public {\n', '        rewardDistribution = msg.sender;\n', '    }\n', '\n', '    IERC20 public rugReward;\n', '    uint256 public DURATION = 1641600; // 19 days\n', '\n', '    uint256 public starttime = 0; \n', '    uint256 public periodFinish = 0;\n', '    uint256 public rewardRate = 0;\n', '    uint256 public lastUpdateTime;\n', '    uint256 public rewardPerTokenStored;\n', '    mapping(address => uint256) public userRewardPerTokenPaid;\n', '    mapping(address => uint256) public rewards;\n', '\n', '    event RewardAdded(uint256 reward);\n', '    event Staked(address indexed user, uint256 amount);\n', '    event Withdrawn(address indexed user, uint256 amount);\n', '    event RewardPaid(address indexed user, uint256 reward);\n', '    event SetRewardToken(address rewardAddress);\n', '    event SetStakeToken(address stakeAddress);\n', '    event SetStartTime(uint256 unixtime);\n', '    event SetDuration(uint256 duration);\n', '\n', '    modifier checkStart() {\n', '        require(block.timestamp >= starttime,"Rewards haven\'t started yet!");\n', '        _;\n', '    }\n', '\n', '    modifier updateReward(address account) {\n', '        rewardPerTokenStored = rewardPerToken();\n', '        lastUpdateTime = lastTimeRewardApplicable();\n', '        if (account != address(0)) {\n', '            rewards[account] = earned(account);\n', '            userRewardPerTokenPaid[account] = rewardPerTokenStored;\n', '        }\n', '        _;\n', '    }\n', '\n', '    function lastTimeRewardApplicable() public view returns (uint256) {\n', '        return Math.min(block.timestamp, periodFinish);\n', '    }\n', '\n', '    function rewardPerToken() public view returns (uint256) {\n', '        if (totalStaked() == 0) {\n', '            return rewardPerTokenStored;\n', '        }\n', '        return\n', '            rewardPerTokenStored.add(\n', '                lastTimeRewardApplicable()\n', '                    .sub(lastUpdateTime)\n', '                    .mul(rewardRate)\n', '                    .mul(1e18)\n', '                    .div(totalStaked())\n', '            );\n', '    }\n', '\n', '    function earned(address account) public view returns (uint256) {\n', '        return\n', '            balanceOf(account)\n', '                .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))\n', '                .div(1e18)\n', '                .add(rewards[account]);\n', '    }\n', '\n', "    // stake visibility is public as overriding LPTokenWrapper's stake() function\n", '    function stake(uint256 amount) public updateReward(msg.sender) checkStart {\n', '        require(amount > 0, "Cannot stake 0");\n', '        super.stake(amount);\n', '    }\n', '\n', '    function withdraw(uint256 amount) public updateReward(msg.sender) checkStart {\n', '        require(amount > 0, "Cannot withdraw 0");\n', '        super.withdraw(amount);\n', '        emit Withdrawn(msg.sender, amount);\n', '    }\n', '\n', '    function exit() external {  \n', '        withdrawDividends();\n', '        getReward();\n', '        withdraw(balanceOf(msg.sender));\n', '    }\n', '\n', '    function collectRewardsOnly() public {\n', '        withdrawDividends();\n', '        getReward();        \n', '    }\n', '\n', '    function getReward() public updateReward(msg.sender) checkStart {\n', '        uint256 reward = earned(msg.sender);\n', '        if (reward > 0) {\n', '            rewards[msg.sender] = 0;\n', '            rugReward.safeTransfer(msg.sender, reward);\n', '            emit RewardPaid(msg.sender, reward);\n', '        }\n', '    }\n', '\n', '    function notifyRewardAmount(uint256 reward)\n', '        external\n', '        onlyRewardDistribution\n', '        updateReward(address(0))\n', '    {\n', '        if (block.timestamp > starttime) {\n', '          if (block.timestamp >= periodFinish) {\n', '              rewardRate = reward.div(DURATION);\n', '          } else {\n', '              uint256 remaining = periodFinish.sub(block.timestamp);\n', '              uint256 leftover = remaining.mul(rewardRate);\n', '              rewardRate = reward.add(leftover).div(DURATION);\n', '          }\n', '          lastUpdateTime = block.timestamp;\n', '          periodFinish = block.timestamp.add(DURATION);\n', '          emit RewardAdded(reward);\n', '        } else {\n', '          rewardRate = reward.div(DURATION);\n', '          lastUpdateTime = starttime;\n', '          periodFinish = starttime.add(DURATION);\n', '          emit RewardAdded(reward);\n', '        }\n', '    }\n', '\n', '    function setRewardAddress(address rewardAddress) public onlyOwner {\n', '        rugReward = IERC20(rewardAddress);\n', '        emit SetRewardToken(rewardAddress);\n', '    } \n', '\n', '    function setStakeAddress(address stakeAddress) public onlyOwner {\n', '        rugStake = IERC20(stakeAddress);\n', '        emit SetStakeToken(stakeAddress);\n', '    }\n', '\n', '    function setStartTime(uint256 unixtime) public onlyOwner {\n', '        starttime = unixtime;\n', '        emit SetStartTime(unixtime);\n', '    }\n', '\n', '    function setDuration(uint256 duration) public onlyOwner {\n', '        DURATION = duration;\n', '        emit SetDuration(duration);\n', '    }\n', '\n', '}']