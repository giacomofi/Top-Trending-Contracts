['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-09\n', '*/\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '\n', '    function min(uint x, uint y) internal pure returns (uint z) {\n', '        return x <= y ? x : y;\n', '    }\n', '}\n', '\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP. Does not include\n', ' * the optional functions; to access them see {ERC20Detailed}.\n', ' */\n', 'interface IERC20 {\n', '    function decimals() external view returns (uint8);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    function mint(address account, uint256 amount) external;\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '\n', 'interface AggregatorV3Interface {\n', '    function decimals() external view returns (uint8);\n', '\n', '    function description() external view returns (string memory);\n', '\n', '    function version() external view returns (uint256);\n', '\n', '    function latestRoundData()\n', '        external\n', '        view\n', '        returns (\n', '            uint80 roundId,\n', '            int256 answer,\n', '            uint256 startedAt,\n', '            uint256 updatedAt,\n', '            uint80 answeredInRound\n', '        );\n', '}\n', '\n', '\n', '\n', 'interface CurvePoolLike {\n', '    function balances(uint256 idx) external view returns (uint256);\n', '    function coins(uint256 idx) external view returns (address);\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title oracle for Uniswap LP tokens which contains stable coins\n', ' * this contract assume USDT token may be part of pool\n', ' * all stables except USDT assumed eq 1 USD\n', ' *\n', '*/\n', 'contract CurveAdapterPriceOracle_Buck_Buck {\n', '    using SafeMath for uint256;\n', '\n', '    IERC20 public gem;\n', '    CurvePoolLike public pool;\n', '    uint256 public numCoins;\n', '    address public deployer;\n', '\n', '    AggregatorV3Interface public priceETHUSDT;\n', '    AggregatorV3Interface public priceUSDETH;\n', '    address public usdtAddress;\n', '\n', '    constructor() public {\n', '        deployer = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev initialize oracle\n', '     * _gem - address of CRV pool token contract\n', '     * _pool - address of CRV pool token contract\n', '     * num - num of tokens in pools\n', '     */\n', '    function setup(address _gem, address _pool, uint256 num) public {\n', '        require(deployer == msg.sender);\n', '        gem = IERC20(_gem);\n', '        pool = CurvePoolLike(_pool);\n', '        numCoins = num;\n', '    }\n', '\n', '    function resetDeployer() public {\n', '        require(deployer == msg.sender);\n', '        deployer = address(0);\n', '    }\n', '\n', '    function setupUsdt(\n', '        address _priceETHUSDT,\n', '        address _priceUSDETH,\n', '        address _usdtAddress,\n', '        bool usdtAsString) public {\n', '\n', '        require(address(pool) != address(0));\n', '\n', '        require(deployer == msg.sender);\n', '        require(_usdtAddress != address(0));\n', '        require(_priceETHUSDT != address(0));\n', '        require(_priceUSDETH != address(0));\n', '\n', '\n', '        (bool success, bytes memory returndata) =\n', '            address(_usdtAddress).call(abi.encodeWithSignature("symbol()"));\n', '        require(success, "USDT: low-level call failed");\n', '\n', '        require(returndata.length > 0);\n', '        if (usdtAsString) {\n', '            bytes memory usdtSymbol = bytes(abi.decode(returndata, (string)));\n', '            require(keccak256(bytes(usdtSymbol)) == keccak256("USDT"));\n', '        } else {\n', '            bytes32 usdtSymbol = abi.decode(returndata, (bytes32));\n', '            require(usdtSymbol == "USDT");\n', '        }\n', '\n', '        priceETHUSDT = AggregatorV3Interface(_priceETHUSDT);\n', '        priceUSDETH  = AggregatorV3Interface(_priceUSDETH);\n', '        usdtAddress = _usdtAddress;\n', '\n', '        deployer = address(0);\n', '    }\n', '\n', '    function usdtCalcValue(uint256 value) internal view returns (uint256) {\n', '        uint256 price1Div =\n', '            10 **\n', '                (\n', '                    uint256(priceETHUSDT.decimals()).add(uint256(priceUSDETH.decimals())).add(\n', '                        uint256(IERC20(usdtAddress).decimals())\n', '                    )\n', '                );\n', '\n', '        (, int256 answerUSDETH, , , ) = priceUSDETH.latestRoundData();\n', '        (, int256 answerETHUSDT, , , ) = priceETHUSDT.latestRoundData();\n', '\n', '        uint256 usdtPrice = uint256(answerUSDETH).mul(uint256(answerETHUSDT));\n', '        return value.mul(usdtPrice).div(price1Div);\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev calculate price\n', '     */\n', '    function calc() internal view returns (bytes32, bool) {\n', '\n', '        uint256 totalSupply = gem.totalSupply();\n', '        uint256 decimals = gem.decimals();\n', '\n', '        uint256 totalValue = 0;\n', '        for (uint256 i = 0; i<numCoins; i++) {\n', '            uint256 value = pool.balances(i).mul(1e18).mul(uint256(10)**decimals).div(totalSupply);\n', '\n', '            if (pool.coins(i) == usdtAddress) {\n', '\n', '                totalValue = totalValue.add(usdtCalcValue(value));\n', '            }\n', '            else {\n', '                uint256 tokenDecimalsF = uint256(10)**uint256(IERC20(pool.coins(i)).decimals());\n', '\n', '                totalValue = totalValue.add(value.div(tokenDecimalsF));\n', '            }\n', '        }\n', '\n', '        return (\n', '            bytes32(\n', '                totalValue\n', '            ),\n', '            true\n', '        );\n', '\n', '    }\n', '\n', '    /**\n', '     * @dev base oracle interface see OSM docs\n', '     */\n', '    function peek() public view returns (bytes32, bool) {\n', '        return calc();\n', '    }\n', '\n', '    /**\n', '     * @dev base oracle interface see OSM docs\n', '     */\n', '    function read() public view returns (bytes32) {\n', '        bytes32 wut;\n', '        bool haz;\n', '        (wut, haz) = calc();\n', '        require(haz, "haz-not");\n', '        return wut;\n', '    }\n', '}']