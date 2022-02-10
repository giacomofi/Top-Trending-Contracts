['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity 0.6.12;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'interface Auction {\n', '    function getBid(address addr) external view returns (address a, uint256 b, uint256 c, uint256 d, uint e, uint f, uint g, bool distributed);\n', '}\n', '\n', 'contract LPStaker {\n', '    \n', '    struct StakeState {\n', '        uint128 balance;\n', '        uint64 lockedUntil;\n', '        uint64 reward;\n', '        uint128 bonusBalance;\n', '    }\n', '    \n', '    uint128 constant initialDepositedTokens = 20000 * 1000000; // an offset\n', '    uint128 constant initialAllocatedReward = 1930 * 1000000; // an offset\n', '    uint128 constant maxAllocatedReward = 10000 * 1000000; \n', '    \n', '    uint128 totalDepositedTokens = initialDepositedTokens; \n', '    uint128 totalAllocatedReward = initialAllocatedReward;\n', '    uint128 public totalBonusDeposits = 0;\n', '    \n', '    function sumDepositedTokens() external view returns (uint128) { return totalDepositedTokens - initialDepositedTokens; }\n', '    function sumAllocatedReward() external view returns (uint128) { return totalAllocatedReward - initialAllocatedReward; }\n', '    \n', '    event Deposit(address indexed from, uint128 balance, uint64 until, uint64 reward);\n', '    \n', '    mapping(address => StakeState) private _states;\n', '    \n', '    IERC20 private depositToken = IERC20(0x510C9b3FE162f463DAC2F8c6dDd3d8ED5F49e360); // HGET/CHR\n', '    IERC20 private rewardToken1 = IERC20(0x7968bc6a03017eA2de509AAA816F163Db0f35148); // HGET\n', '    IERC20 private rewardToken2 = IERC20(0x8A2279d4A90B6fe1C4B30fa660cC9f926797bAA2); // CHR\n', '    \n', '    Auction constant usdt_auction = Auction(0xf8E30096dD15Ce4F47310A20EdD505B42a633808);\n', '    Auction constant chr_auction = Auction(0x12F41B4bb7D5e5a2148304caAfeb26d9edb7Ef4A);\n', '    \n', '    // note that depositedTokens must be in the same tokens as initialDepositedTokens\n', '    // (i.e. 6 decimals, 1000M tokens represent 1000 HGET worth of liquidity)\n', '    function calculateReward (uint128 depositedTokens) internal view returns (uint256) {\n', '        // calculate amount of bought reward tokens (i.e. reward for deposit) using Bancor formula\n', '        // Exact formula: boughtTokens = tokenSupply * ( (1 + x) ^ F - 1)\n', '        //    where F is reserve ratio\n', '        //      and x = depositedTokens/totalDepositedTokens\n', '        // We have an approximation which is precise for 0 <= x <= 1.\n', '        // So to handle values above totalDepositedTokens, we simulate\n', '        // multi-step buy process. totalDepositedTokens doubles on each iteration.\n', '        \n', '        uint256 tDepositedTokens = totalDepositedTokens;\n', '        uint256 tAllocatedReward = totalAllocatedReward;\n', '        uint256 remainingDeposit = depositedTokens;\n', '        uint256 totalBoughtTokens = 0;\n', '\n', '        while (remainingDeposit >= tDepositedTokens) {\n', '            // buy tDepositedTokens worth of tokens. in this case x = 1, thus we\n', '            // have formula boughtTokens = tokenSupply * ( 2^F - 1)\n', '            // 2^F - 1 = 0.741101126592248\n', '\n', '            uint256 boughtTokens = (741101126592248 * tAllocatedReward) / (1000000000000000);\n', '\n', '            totalBoughtTokens += boughtTokens;\n', '            tAllocatedReward += boughtTokens;\n', '            remainingDeposit -= tDepositedTokens;\n', '            tDepositedTokens += tDepositedTokens;\n', '        }\n', '        if (remainingDeposit > 0) {\n', '            // third degree polynomial which approximates the exact value\n', '            // obtained using Lagrange interpolation\n', '            // boughtTokens = TS*(0.017042*(x/ER)^3 - 0.075513*(x/ER)^2 + 0.799572*(x/ER))\n', '            // (TS = tAllocatedReward, ER=tDepositedTokens)\n', '            // coefficients are truncated to millionths\n', '\n', '            // we assume that tAllocatedReward, remainingDeposit and tDepositedTokens do not exceed 80 bits, thus\n', '            // we can multiply three of them within int256 without getting overflow\n', '            int256 rd = int256(remainingDeposit);\n', '            int256 tDepositedTokensSquared = int256(tDepositedTokens*tDepositedTokens);\n', '            int256 temp1 = int256(tAllocatedReward) * rd;\n', '            int256 x1 = (799572 * temp1)/int256(tDepositedTokens);\n', '            int256 x2 = (75513 * temp1 * rd)/tDepositedTokensSquared;\n', '            int256 x3 = (((17042 * temp1 * rd)/tDepositedTokensSquared) * rd)/int256(tDepositedTokens);\n', '            int256 res = (x1 - x2 + x3)/1000000;\n', '            if (res > 0)  totalBoughtTokens += uint256(res);\n', '        }\n', '        return totalBoughtTokens;\n', '    }\n', '    \n', '    constructor () public {}\n', '\n', '    function getStakeState(address account) external view returns (uint256, uint64, uint64) {\n', '        StakeState storage ss = _states[account];\n', '        return (ss.balance, ss.lockedUntil, ss.reward);\n', '    }\n', '\n', '    function depositWithBonus(uint128 amount, bool is_chr) external {\n', '        deposit(amount);\n', '        Auction a = (is_chr) ? chr_auction : usdt_auction;\n', '        (,,,,,,,bool distributed) = a.getBid(msg.sender); \n', '        require(distributed, "need to win auction to get bonus");\n', '        StakeState storage ss = _states[msg.sender];\n', '        ss.bonusBalance += amount;\n', '        totalBonusDeposits += amount;\n', '    }\n', '\n', '    function deposit(uint128 amount) public {\n', '        require(block.timestamp < 1604707200, "deposits no longer accepted"); // 2020 November 07 00:00 UTC\n', '        uint64 until = uint64(block.timestamp + 2 weeks); // TODO\n', '        \n', '        uint128 adjustedAmount = (1156 * amount) / (10000); // 0.1156 HGET atoms per 1 LP token atom, corresponds to ~75 CHR per HGET\n', '        uint64 reward = uint64(calculateReward(adjustedAmount)); \n', '        totalAllocatedReward += reward;\n', '        \n', '        require(totalAllocatedReward <= initialAllocatedReward + maxAllocatedReward, "reward pool exhausted");\n', '        \n', '        totalDepositedTokens += adjustedAmount;\n', '        \n', '        StakeState storage ss = _states[msg.sender];\n', '        ss.balance += amount;\n', '        ss.reward += reward;\n', '        ss.lockedUntil = until;\n', '        \n', '        emit Deposit(msg.sender, amount, until, reward);\n', '        require(depositToken.transferFrom(msg.sender, address(this), amount), "transfer unsuccessful");\n', '    }\n', '\n', '    function withdraw(address to) external {\n', '        StakeState storage ss = _states[msg.sender];\n', '        require(ss.lockedUntil < block.timestamp, "still locked");\n', '        require(ss.balance > 0, "must have tokens to withdraw");\n', '        uint128 balance = ss.balance;\n', '        uint64 reward = ss.reward;\n', '        uint128 bonusBalance = ss.bonusBalance;\n', '        ss.balance = 0;\n', '        ss.lockedUntil = 0;\n', '        ss.reward = 0;\n', '        \n', '        if (bonusBalance > 0) {\n', '            ss.bonusBalance = 0;\n', '            reward += uint64((2500 * 1000000 * bonusBalance) / totalBonusDeposits); // TODO\n', '        }\n', '        \n', '        require(depositToken.transfer(to, balance), "transfer unsuccessful");\n', '        require(rewardToken1.transfer(to, reward), "transfer unsuccessful");\n', '        require(rewardToken2.transfer(to, reward * 75), "transfer unsuccessful");\n', '    }\n', '}']