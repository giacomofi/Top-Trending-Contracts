['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity 0.6.12;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'interface ITokenInterface {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function burn(uint amount) external;\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /** VALUE, YFV, vUSD, vETH has minters **/\n', '    function minters(address account) external view returns (bool);\n', '    function mint(address _to, uint _amount) external;\n', '\n', '    /** YFV <-> VALUE **/\n', '    function deposit(uint _amount) external;\n', '    function withdraw(uint _amount) external;\n', '    function cap() external returns (uint);\n', '    function yfvLockedBalance() external returns (uint);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract ValueVaultProfitSharerV2 {\n', '    using SafeMath for uint256;\n', '\n', '    address public governance;\n', '\n', '    ITokenInterface public valueToken;\n', '    ITokenInterface public yfvToken;\n', '\n', '    address public govVault = 0xceC03a960Ea678A2B6EA350fe0DbD1807B22D875; // VALUE -> VALUE and 6.7% profit from Value Vaults\n', '    address public insuranceFund = 0xb7b2Ea8A1198368f950834875047aA7294A2bDAa; // set to Governance Multisig at start\n', '    address public performanceReward = 0x7Be4D5A99c903C437EC77A20CB6d0688cBB73c7f; // set to deploy wallet at start\n', '\n', '    uint256 public constant FEE_DENOMINATOR = 10000;\n', '    uint256 public insuranceFee = 0; // 0% at start and can be set by governance decision\n', '    uint256 public performanceFee = 0; // 0% at start and can be set by governance decision\n', '    uint256 public burnFee = 0; // 0% at start and can be set by governance decision\n', '\n', '    uint256 public distributeCap = 100 ether; // Maximum of Value to distribute each time\n', '    uint256 public distributeCooldownPeriod = 0; // Cool-down period for each time distribution\n', '    uint256 public distributeLasttime = 0;\n', '\n', '    constructor(ITokenInterface _valueToken, ITokenInterface _yfvToken) public {\n', '        valueToken = _valueToken;\n', '        yfvToken = _yfvToken;\n', '        yfvToken.approve(address(valueToken), type(uint256).max);\n', '        governance = tx.origin;\n', '    }\n', '\n', '    function setGovernance(address _governance) external {\n', '        require(msg.sender == governance, "!governance");\n', '        governance = _governance;\n', '    }\n', '\n', '    function setGovVault(address _govVault) public {\n', '        require(msg.sender == governance, "!governance");\n', '        govVault = _govVault;\n', '    }\n', '\n', '    function setInsuranceFund(address _insuranceFund) public {\n', '        require(msg.sender == governance, "!governance");\n', '        insuranceFund = _insuranceFund;\n', '    }\n', '\n', '    function setPerformanceReward(address _performanceReward) public {\n', '        require(msg.sender == governance, "!governance");\n', '        performanceReward = _performanceReward;\n', '    }\n', '\n', '    function setInsuranceFee(uint256 _insuranceFee) public {\n', '        require(msg.sender == governance, "!governance");\n', '        insuranceFee = _insuranceFee;\n', '    }\n', '\n', '    function setPerformanceFee(uint256 _performanceFee) public {\n', '        require(msg.sender == governance, "!governance");\n', '        performanceFee = _performanceFee;\n', '    }\n', '\n', '    function setBurnFee(uint256 _burnFee) public {\n', '        require(msg.sender == governance, "!governance");\n', '        burnFee = _burnFee;\n', '    }\n', '\n', '    function setDistributeCap(uint256 _distributeCap) public {\n', '        require(msg.sender == governance, "!governance");\n', '        distributeCap = _distributeCap;\n', '    }\n', '\n', '    function setDistributeCooldownPeriod(uint256 _distributeCooldownPeriod) public {\n', '        require(msg.sender == governance, "!governance");\n', '        distributeCooldownPeriod = _distributeCooldownPeriod;\n', '    }\n', '\n', '    function shareProfit() public returns (uint256 profit) {\n', '        if (distributeCap > 0 && govVault != address(0) && distributeLasttime.add(distributeCooldownPeriod) <= block.timestamp) {\n', '            profit = yfvToken.balanceOf(address(this));\n', '            if (profit > 0) {\n', '                valueToken.deposit(profit);\n', '            }\n', '            profit = valueToken.balanceOf(address(this));\n', '            if (profit > 0) {\n', '                if (performanceFee > 0 && performanceReward != address(0)) {\n', '                    valueToken.transfer(performanceReward, profit.mul(performanceFee).div(FEE_DENOMINATOR));\n', '                }\n', '                if (insuranceFee > 0 && insuranceFund != address(0)) {\n', '                    valueToken.transfer(insuranceFund, profit.mul(insuranceFee).div(FEE_DENOMINATOR));\n', '                }\n', '                if (burnFee > 0) {\n', '                    valueToken.burn(profit.mul(burnFee).div(FEE_DENOMINATOR));\n', '                }\n', '                uint256 _valueBal = valueToken.balanceOf(address(this));\n', '                valueToken.transfer(govVault, (_valueBal <= distributeCap) ? _valueBal : distributeCap);\n', '                distributeLasttime = block.timestamp;\n', '            }\n', '        }\n', '    }\n', '\n', '    /**\n', '     * This function allows governance to take unsupported tokens out of the contract.\n', '     * This is in an effort to make someone whole, should they seriously mess up.\n', '     * There is no guarantee governance will vote to return these.\n', '     * It also allows for removal of airdropped tokens.\n', '     */\n', '    function governanceRecoverUnsupported(ITokenInterface _token, uint256 amount, address to) external {\n', '        require(msg.sender == governance, "!governance");\n', '        _token.transfer(to, amount);\n', '    }\n', '}']