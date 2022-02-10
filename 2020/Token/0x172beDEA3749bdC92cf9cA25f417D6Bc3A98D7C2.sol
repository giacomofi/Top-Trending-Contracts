['// File: @openzeppelin/contracts/token/ERC20/IERC20.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP. Does not include\n', ' * the optional functions; to access them see {ERC20Detailed}.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '/**\n', ' * @dev Optional functions from the ERC20 standard.\n', ' */\n', 'contract ERC20Detailed is IERC20 {\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '\n', '    /**\n', '     * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of\n', '     * these values are immutable: they can only be set once during\n', '     * construction.\n', '     */\n', '    constructor (string memory name, string memory symbol, uint8 decimals) public {\n', '        _name = name;\n', '        _symbol = symbol;\n', '        _decimals = decimals;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the name of the token.\n', '     */\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the symbol of the token, usually a shorter version of the\n', '     * name.\n', '     */\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the number of decimals used to get its user representation.\n', '     * For example, if `decimals` equals `2`, a balance of `505` tokens should\n', '     * be displayed to a user as `5,05` (`505 / 10 ** 2`).\n', '     *\n', '     * Tokens usually opt for a value of 18, imitating the relationship between\n', '     * Ether and Wei.\n', '     *\n', '     * NOTE: This information is only used for _display_ purposes: it in\n', '     * no way affects any of the arithmetic of the contract, including\n', '     * {IERC20-balanceOf} and {IERC20-transfer}.\n', '     */\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '}\n', '\n', '// File: contracts/ApyOracle.sol\n', '\n', 'pragma solidity 0.5.16;\n', '\n', '\n', '\n', '\n', 'contract IUniswapRouterV2 {\n', '  function getAmountsOut(uint256 amountIn, address[] memory path) public view returns (uint256[] memory amounts);\n', '}\n', '\n', 'interface IUniswapV2Pair {\n', '  function token0() external view returns (address);\n', '  function token1() external view returns (address);\n', '  function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '  function totalSupply() external view returns (uint256);\n', '}\n', '\n', 'contract ApyOracle {\n', '\n', '  address public constant oracle = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;\n', '  address public constant usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;\n', '  address public constant weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;\n', '\n', '  constructor () public {\n', '  }\n', '\n', '  function getApy(\n', '    address stakeToken,\n', '    bool isUni,\n', '    address ausc,\n', '    uint256 incentive,\n', '    uint256 howManyWeeks,\n', '    address pool) public view returns (uint256) {\n', '    address[] memory p = new address[](3);\n', '    p[1] = weth;\n', '    p[2] = usdc;\n', '    p[0] = ausc;\n', '    uint256[] memory auscPriceAmounts = IUniswapRouterV2(oracle).getAmountsOut(1e18, p);\n', '    uint256 poolBalance = IERC20(stakeToken).balanceOf(pool);\n', '    uint256 stakeTokenPrice = 1000000;\n', '    p[0] = stakeToken;\n', '    if (stakeToken != usdc) {\n', '      if (isUni) {\n', '        stakeTokenPrice = getUniPrice(IUniswapV2Pair(stakeToken));\n', '      } else {\n', '        uint256 unit = 10 ** uint256(ERC20Detailed(stakeToken).decimals());\n', '        uint256[] memory stakePriceAmounts = IUniswapRouterV2(oracle).getAmountsOut(unit, p);\n', '        stakeTokenPrice = stakePriceAmounts[2];\n', '      }\n', '    }\n', '    uint256 temp = (\n', '      1e8 * auscPriceAmounts[2] * incentive * (52 / howManyWeeks)\n', '    ) / (poolBalance * stakeTokenPrice);\n', '    if (ERC20Detailed(stakeToken).decimals() == uint8(18)) {\n', '      return temp;\n', '    } else {\n', '      uint256 divideBy = 10 ** uint256(18 - ERC20Detailed(stakeToken).decimals());\n', '      return temp / divideBy;\n', '    }\n', '  }\n', '\n', '  function getUniPrice(IUniswapV2Pair unipair) public view returns (uint256) {\n', '    // find the token that is not weth\n', '    (uint112 r0, uint112 r1, ) = unipair.getReserves();\n', '    uint256 total = 0;\n', '    if (unipair.token0() == weth) {\n', '      total = uint256(r0) * 2;\n', '    } else {\n', '      total = uint256(r1) * 2;\n', '    }\n', '    uint256 singlePriceInWeth = 1e18 * total / unipair.totalSupply();\n', '    address[] memory p = new address[](2);\n', '    p[0] = weth;\n', '    p[1] = usdc;\n', '    uint256[] memory prices = IUniswapRouterV2(oracle).getAmountsOut(1e18, p);\n', '    return prices[1] * singlePriceInWeth / 1e18; // price of single token in USDC\n', '  }\n', '\n', '  function getTvl(address pool, address token, bool isUniswap) public view returns (uint256) {\n', '    uint256 balance = IERC20(token).balanceOf(pool);\n', '    uint256 decimals = ERC20Detailed(token).decimals();\n', '    if (balance == 0) {\n', '      return 0;\n', '    }\n', '    if (!isUniswap) {\n', '      address[] memory p = new address[](3);\n', '      p[1] = weth;\n', '      p[2] = usdc;\n', '      p[0] = token;\n', '      uint256 one = 10 ** decimals;\n', '      uint256[] memory amounts = IUniswapRouterV2(oracle).getAmountsOut(one, p);\n', '      return amounts[2] * balance / decimals;\n', '    } else {\n', '      uint256 price = getUniPrice(IUniswapV2Pair(token));\n', '      return price * balance / decimals;\n', '    }\n', '  }\n', '}']