['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.7.0;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'import "./interface/IPremiaOption.sol";\n', '\n', '/// @author Premia\n', '/// @title Batch functions to interact with PremiaOption\n', 'contract PremiaOptionBatch {\n', '    /// @notice Write multiple options at once\n', '    /// @param _premiaOption A PremiaOption contract\n', '    /// @param _options Options to write\n', '    /// @param _referrer Referrer\n', '    function batchWriteOption(IPremiaOption _premiaOption, IPremiaOption.OptionWriteArgs[] memory _options, address _referrer) external {\n', '        for (uint256 i = 0; i < _options.length; ++i) {\n', '            _premiaOption.writeOptionFrom(msg.sender, _options[i], _referrer);\n', '        }\n', '    }\n', '\n', '    /// @notice Cancel multiple options at once\n', '    /// @param _premiaOption A PremiaOption contract\n', '    /// @param _optionId List of ids of options to cancel\n', '    /// @param _amounts Amount to cancel for each option\n', '    function batchCancelOption(IPremiaOption _premiaOption, uint256[] memory _optionId, uint256[] memory _amounts) external {\n', '        require(_optionId.length == _amounts.length, "Arrays diff len");\n', '\n', '        for (uint256 i = 0; i < _optionId.length; ++i) {\n', '            _premiaOption.cancelOptionFrom(msg.sender, _optionId[i], _amounts[i]);\n', '        }\n', '    }\n', '\n', '    /// @notice Withdraw funds from multiple options at once\n', '    /// @param _premiaOption A PremiaOption contract\n', '    /// @param _optionId List of ids of options to withdraw funds from\n', '    function batchWithdraw(IPremiaOption _premiaOption, uint256[] memory _optionId) external {\n', '        for (uint256 i = 0; i < _optionId.length; ++i) {\n', '            _premiaOption.withdrawFrom(msg.sender, _optionId[i]);\n', '        }\n', '    }\n', '\n', '    /// @notice Exercise multiple options at once\n', '    /// @param _premiaOption A PremiaOption contract\n', '    /// @param _optionId List of ids of options to exercise\n', '    /// @param _amounts Amount to exercise for each option\n', '    /// @param _referrer Referrer\n', '    function batchExerciseOption(IPremiaOption _premiaOption, uint256[] memory _optionId, uint256[] memory _amounts, address _referrer) external {\n', '        require(_optionId.length == _amounts.length, "Arrays diff len");\n', '\n', '        for (uint256 i = 0; i < _optionId.length; ++i) {\n', '            _premiaOption.exerciseOptionFrom(msg.sender, _optionId[i], _amounts[i], _referrer);\n', '        }\n', '    }\n', '\n', '    /// @notice Withdraw funds pre expiration from multiple options at once\n', '    /// @param _premiaOption A PremiaOption contract\n', '    /// @param _optionId List of ids of options to withdraw funds from\n', '    /// @param _amounts Amount to withdraw pre expiration for each option\n', '    function batchWithdrawPreExpiration(IPremiaOption _premiaOption, uint256[] memory _optionId, uint256[] memory _amounts) external {\n', '        require(_optionId.length == _amounts.length, "Arrays diff len");\n', '\n', '        for (uint256 i = 0; i < _optionId.length; ++i) {\n', '            _premiaOption.withdrawPreExpirationFrom(msg.sender, _optionId[i], _amounts[i]);\n', '        }\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.7.0;\n', 'pragma experimental ABIEncoderV2;\n', '\n', "import '@openzeppelin/contracts/token/ERC1155/IERC1155.sol';\n", 'import "../interface/IFlashLoanReceiver.sol";\n', 'import "../uniswapV2/interfaces/IUniswapV2Router02.sol";\n', '\n', 'interface IPremiaOption is IERC1155 {\n', '    struct OptionWriteArgs {\n', '        address token;                  // Token address\n', '        uint256 amount;                 // Amount of tokens to write option for\n', '        uint256 strikePrice;            // Strike price (Must follow strikePriceIncrement of token)\n', '        uint256 expiration;             // Expiration timestamp of the option (Must follow expirationIncrement)\n', '        bool isCall;                    // If true : Call option | If false : Put option\n', '    }\n', '\n', '    struct OptionData {\n', '        address token;                  // Token address\n', '        uint256 strikePrice;            // Strike price (Must follow strikePriceIncrement of token)\n', '        uint256 expiration;             // Expiration timestamp of the option (Must follow expirationIncrement)\n', '        bool isCall;                    // If true : Call option | If false : Put option\n', '        uint256 claimsPreExp;           // Amount of options from which the funds have been withdrawn pre expiration\n', '        uint256 claimsPostExp;          // Amount of options from which the funds have been withdrawn post expiration\n', '        uint256 exercised;              // Amount of options which have been exercised\n', '        uint256 supply;                 // Total circulating supply\n', '        uint8 decimals;                 // Token decimals\n', '    }\n', '\n', '    // Total write cost = collateral + fee + feeReferrer\n', '    struct QuoteWrite {\n', '        address collateralToken;        // The token to deposit as collateral\n', '        uint256 collateral;             // The amount of collateral to deposit\n', '        uint8 collateralDecimals;       // Decimals of collateral token\n', '        uint256 fee;                    // The amount of collateralToken needed to be paid as protocol fee\n', '        uint256 feeReferrer;            // The amount of collateralToken which will be paid the referrer\n', '    }\n', '\n', '    // Total exercise cost = input + fee + feeReferrer\n', '    struct QuoteExercise {\n', '        address inputToken;             // Input token for exercise\n', '        uint256 input;                  // Amount of input token to pay to exercise\n', '        uint8 inputDecimals;            // Decimals of input token\n', '        address outputToken;            // Output token from the exercise\n', '        uint256 output;                 // Amount of output tokens which will be received on exercise\n', '        uint8 outputDecimals;           // Decimals of output token\n', '        uint256 fee;                    // The amount of inputToken needed to be paid as protocol fee\n', '        uint256 feeReferrer;            // The amount of inputToken which will be paid to the referrer\n', '    }\n', '\n', '    struct Pool {\n', '        uint256 tokenAmount;\n', '        uint256 denominatorAmount;\n', '    }\n', '\n', '    function denominatorDecimals() external view returns(uint8);\n', '\n', '    function maxExpiration() external view returns(uint256);\n', '    function optionData(uint256 _optionId) external view returns (OptionData memory);\n', '    function tokenStrikeIncrement(address _token) external view returns (uint256);\n', '    function nbWritten(address _writer, uint256 _optionId) external view returns (uint256);\n', '\n', '    function getOptionId(address _token, uint256 _expiration, uint256 _strikePrice, bool _isCall) external view returns(uint256);\n', '    function getOptionIdOrCreate(address _token, uint256 _expiration, uint256 _strikePrice, bool _isCall) external returns(uint256);\n', '\n', '    //////////////////////////////////////////////////\n', '    //////////////////////////////////////////////////\n', '    //////////////////////////////////////////////////\n', '\n', '    function getWriteQuote(address _from, OptionWriteArgs memory _option, address _referrer, uint8 _decimals) external view returns(QuoteWrite memory);\n', '    function getExerciseQuote(address _from, OptionData memory _option, uint256 _amount, address _referrer, uint8 _decimals) external view returns(QuoteExercise memory);\n', '\n', '    function writeOptionWithIdFrom(address _from, uint256 _optionId, uint256 _amount, address _referrer) external returns(uint256);\n', '    function writeOption(address _token, OptionWriteArgs memory _option, address _referrer) external returns(uint256);\n', '    function writeOptionFrom(address _from, OptionWriteArgs memory _option, address _referrer) external returns(uint256);\n', '    function cancelOption(uint256 _optionId, uint256 _amount) external;\n', '    function cancelOptionFrom(address _from, uint256 _optionId, uint256 _amount) external;\n', '    function exerciseOption(uint256 _optionId, uint256 _amount) external;\n', '    function exerciseOptionFrom(address _from, uint256 _optionId, uint256 _amount, address _referrer) external;\n', '    function withdraw(uint256 _optionId) external;\n', '    function withdrawFrom(address _from, uint256 _optionId) external;\n', '    function withdrawPreExpiration(uint256 _optionId, uint256 _amount) external;\n', '    function withdrawPreExpirationFrom(address _from, uint256 _optionId, uint256 _amount) external;\n', '    function flashExerciseOption(uint256 _optionId, uint256 _amount, address _referrer, IUniswapV2Router02 _router, uint256 _amountInMax) external;\n', '    function flashExerciseOptionFrom(address _from, uint256 _optionId, uint256 _amount, address _referrer, IUniswapV2Router02 _router, uint256 _amountInMax) external;\n', '    function flashLoan(address _tokenAddress, uint256 _amount, IFlashLoanReceiver _receiver) external;\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.2 <0.8.0;\n', '\n', 'import "../../introspection/IERC165.sol";\n', '\n', '/**\n', ' * @dev Required interface of an ERC1155 compliant contract, as defined in the\n', ' * https://eips.ethereum.org/EIPS/eip-1155[EIP].\n', ' *\n', ' * _Available since v3.1._\n', ' */\n', 'interface IERC1155 is IERC165 {\n', '    /**\n', '     * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.\n', '     */\n', '    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);\n', '\n', '    /**\n', '     * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all\n', '     * transfers.\n', '     */\n', '    event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);\n', '\n', '    /**\n', '     * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to\n', '     * `approved`.\n', '     */\n', '    event ApprovalForAll(address indexed account, address indexed operator, bool approved);\n', '\n', '    /**\n', '     * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.\n', '     *\n', '     * If an {URI} event was emitted for `id`, the standard\n', '     * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value\n', '     * returned by {IERC1155MetadataURI-uri}.\n', '     */\n', '    event URI(string value, uint256 indexed id);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens of token type `id` owned by `account`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `account` cannot be the zero address.\n', '     */\n', '    function balanceOf(address account, uint256 id) external view returns (uint256);\n', '\n', '    /**\n', '     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `accounts` and `ids` must have the same length.\n', '     */\n', '    function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);\n', '\n', '    /**\n', "     * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,\n", '     *\n', '     * Emits an {ApprovalForAll} event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `operator` cannot be the caller.\n', '     */\n', '    function setApprovalForAll(address operator, bool approved) external;\n', '\n', '    /**\n', "     * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.\n", '     *\n', '     * See {setApprovalForAll}.\n', '     */\n', '    function isApprovedForAll(address account, address operator) external view returns (bool);\n', '\n', '    /**\n', '     * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.\n', '     *\n', '     * Emits a {TransferSingle} event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `to` cannot be the zero address.\n', "     * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.\n", '     * - `from` must have a balance of tokens of type `id` of at least `amount`.\n', '     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the\n', '     * acceptance magic value.\n', '     */\n', '    function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;\n', '\n', '    /**\n', '     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.\n', '     *\n', '     * Emits a {TransferBatch} event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `ids` and `amounts` must have the same length.\n', '     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the\n', '     * acceptance magic value.\n', '     */\n', '    function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.7.0;\n', '\n', 'interface IFlashLoanReceiver {\n', '    function execute(address _tokenAddress, uint256 _amount, uint256 _amountWithFee) external;\n', '}\n', '\n', 'pragma solidity >=0.6.2;\n', '\n', "import './IUniswapV2Router01.sol';\n", '\n', 'interface IUniswapV2Router02 is IUniswapV2Router01 {\n', '    function removeLiquidityETHSupportingFeeOnTransferTokens(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountETH);\n', '    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline,\n', '        bool approveMax, uint8 v, bytes32 r, bytes32 s\n', '    ) external returns (uint amountETH);\n', '\n', '    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external;\n', '    function swapExactETHForTokensSupportingFeeOnTransferTokens(\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external payable;\n', '    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external;\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC165 standard, as defined in the\n', ' * https://eips.ethereum.org/EIPS/eip-165[EIP].\n', ' *\n', ' * Implementers can declare support of contract interfaces, which can then be\n', ' * queried by others ({ERC165Checker}).\n', ' *\n', ' * For an implementation, see {ERC165}.\n', ' */\n', 'interface IERC165 {\n', '    /**\n', '     * @dev Returns true if this contract implements the interface defined by\n', '     * `interfaceId`. See the corresponding\n', '     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]\n', '     * to learn more about how these ids are created.\n', '     *\n', '     * This function call must use less than 30 000 gas.\n', '     */\n', '    function supportsInterface(bytes4 interfaceId) external view returns (bool);\n', '}\n', '\n', 'pragma solidity >=0.6.2;\n', '\n', 'interface IUniswapV2Router01 {\n', '    function factory() external pure returns (address);\n', '    function WETH() external pure returns (address);\n', '\n', '    function addLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint amountADesired,\n', '        uint amountBDesired,\n', '        uint amountAMin,\n', '        uint amountBMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountA, uint amountB, uint liquidity);\n', '    function addLiquidityETH(\n', '        address token,\n', '        uint amountTokenDesired,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline\n', '    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\n', '    function removeLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint liquidity,\n', '        uint amountAMin,\n', '        uint amountBMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountA, uint amountB);\n', '    function removeLiquidityETH(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountToken, uint amountETH);\n', '    function removeLiquidityWithPermit(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint liquidity,\n', '        uint amountAMin,\n', '        uint amountBMin,\n', '        address to,\n', '        uint deadline,\n', '        bool approveMax, uint8 v, bytes32 r, bytes32 s\n', '    ) external returns (uint amountA, uint amountB);\n', '    function removeLiquidityETHWithPermit(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline,\n', '        bool approveMax, uint8 v, bytes32 r, bytes32 s\n', '    ) external returns (uint amountToken, uint amountETH);\n', '    function swapExactTokensForTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint[] memory amounts);\n', '    function swapTokensForExactTokens(\n', '        uint amountOut,\n', '        uint amountInMax,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint[] memory amounts);\n', '    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)\n', '        external\n', '        payable\n', '        returns (uint[] memory amounts);\n', '    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)\n', '        external\n', '        returns (uint[] memory amounts);\n', '    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)\n', '        external\n', '        returns (uint[] memory amounts);\n', '    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)\n', '        external\n', '        payable\n', '        returns (uint[] memory amounts);\n', '\n', '    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);\n', '    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);\n', '    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);\n', '    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);\n', '    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);\n', '}']