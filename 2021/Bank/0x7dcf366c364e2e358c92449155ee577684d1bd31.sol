['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-12\n', '*/\n', '\n', '// SPDX-License-Identifier: UNLICENSED\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', 'interface IUniswapV2Router01 {\n', '    function factory() external pure returns (address);\n', '    function WETH() external pure returns (address);\n', '\n', '    function addLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint amountADesired,\n', '        uint amountBDesired,\n', '        uint amountAMin,\n', '        uint amountBMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountA, uint amountB, uint liquidity);\n', '    function addLiquidityETH(\n', '        address token,\n', '        uint amountTokenDesired,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline\n', '    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\n', '    function removeLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint liquidity,\n', '        uint amountAMin,\n', '        uint amountBMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountA, uint amountB);\n', '    function removeLiquidityETH(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountToken, uint amountETH);\n', '    function removeLiquidityWithPermit(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint liquidity,\n', '        uint amountAMin,\n', '        uint amountBMin,\n', '        address to,\n', '        uint deadline,\n', '        bool approveMax, uint8 v, bytes32 r, bytes32 s\n', '    ) external returns (uint amountA, uint amountB);\n', '    function removeLiquidityETHWithPermit(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline,\n', '        bool approveMax, uint8 v, bytes32 r, bytes32 s\n', '    ) external returns (uint amountToken, uint amountETH);\n', '    function swapExactTokensForTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint[] memory amounts);\n', '    function swapTokensForExactTokens(\n', '        uint amountOut,\n', '        uint amountInMax,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint[] memory amounts);\n', '    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)\n', '        external\n', '        payable\n', '        returns (uint[] memory amounts);\n', '    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)\n', '        external\n', '        returns (uint[] memory amounts);\n', '    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)\n', '        external\n', '        returns (uint[] memory amounts);\n', '    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)\n', '        external\n', '        payable\n', '        returns (uint[] memory amounts);\n', '\n', '    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);\n', '    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);\n', '    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);\n', '    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);\n', '    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);\n', '}\n', 'interface IUniswapV2Router02 is IUniswapV2Router01 {\n', '    function removeLiquidityETHSupportingFeeOnTransferTokens(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountETH);\n', '    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline,\n', '        bool approveMax, uint8 v, bytes32 r, bytes32 s\n', '    ) external returns (uint amountETH);\n', '\n', '    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external;\n', '    function swapExactETHForTokensSupportingFeeOnTransferTokens(\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external payable;\n', '    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external;\n', '}\n', '\n', 'pragma solidity ^0.8.2;\n', '\n', 'interface ChiToken is IERC20 {\n', '    function mint(uint256 value) external;\n', '}\n', '\n', 'contract ChiMinter {\n', '    ChiToken constant CHI =\n', '        ChiToken(0x0000000000004946c0e9F43F4Dee607b0eF1fA1c);\n', '    IERC20 constant WETH = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);\n', '    IUniswapV2Router02 constant UNISWAP =\n', '        IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\n', '\n', '    function mintAndSell(uint256 amount) external {\n', '        CHI.mint(amount);\n', '        try CHI.approve(address(UNISWAP), amount) {\n', '            address[] memory path = new address[](2);\n', '            path[0] = address(CHI);\n', '            path[1] = address(WETH);\n', '            try\n', '                UNISWAP.swapExactTokensForETH(\n', '                    amount,\n', '                    0,\n', '                    path,\n', '                    msg.sender,\n', '                    block.timestamp\n', '                )\n', '            {} catch {\n', "                // swap failed. Let's not revert so we keep the CHI.\n", '            }\n', '        } catch {\n', "            // approve failed. Let's not revert so we keep the CHI\n", '        }\n', '    }\n', '}']