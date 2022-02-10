['// SPDX-License-Identifier: MIT\n', '\n', '// P1 - P3: OK\n', 'pragma solidity ^0.7.3;\n', '\n', 'import "./IERC20.sol";\n', 'import "./SafeERC20.sol";\n', 'import "./SafeMath.sol";\n', 'import "./AccessControl.sol";\n', '\n', 'import "./IUniswapV2.sol";\n', '\n', 'import "./FeeDistributorHelpers.sol";\n', '\n', '\n', 'contract FeeDistributor is FeeDistributorHelpers, AccessControl {\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for IERC20;\n', '\n', '    // Fees, their respective recipients, and the target asset\n', '    // Should be xBASK - 30%, BDPI - 70%\n', '    uint256[] public fees; // Should add up to 1e18\n', '    address[] public feeRecipients;\n', '    address[] public feeRecipientAssets;\n', '\n', '    // Mappings\n', '    mapping(address => address) internal _bridges;\n', '    mapping(bytes32 => address) internal _factories;\n', '\n', '    // Events\n', '    event LogFactorySet(address indexed fromToken, address indexed toToken, address indexed factory);\n', '    event LogBridgeSet(address indexed token, address indexed bridge);\n', '    event LogConverted(\n', '        address indexed server,\n', '        address indexed token0,\n', '        address indexed token1,\n', '        address recipient,\n', '        uint256 amount0,\n', '        uint256 amount1\n', '    );\n', '\n', '    // Constants\n', '    IUniswapV2Factory constant sushiswapFactory = IUniswapV2Factory(0xC0AEe478e3658e2610c5F7A4A2E1777cE9e4f2Ac);\n', '    IUniswapV2Factory constant uniswapFactory = IUniswapV2Factory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);\n', '\n', '    // Roles\n', '    bytes32 public constant MARKET_MAKER = keccak256("baskmaker.access.marketMaker");\n', '    bytes32 public constant MARKET_MAKER_ADMIN = keccak256("baskmaker.access.marketMaker.admin");\n', '\n', '    bytes32 public constant TIMELOCK = keccak256("baskmaker.access.marketMaker");\n', '    bytes32 public constant TIMELOCK_ADMIN = keccak256("baskmaker.access.marketMaker.admin");\n', '\n', '    constructor(\n', '        address _timelock,\n', '        address _admin,\n', '        uint256[] memory _fees,\n', '        address[] memory _feeRecipients,\n', '        address[] memory _feeRecipientAssets\n', '    ) {\n', '        _setRoleAdmin(TIMELOCK, TIMELOCK_ADMIN);\n', '        _setupRole(TIMELOCK_ADMIN, _timelock);\n', '        _setupRole(TIMELOCK, _timelock);\n', '\n', '        _setRoleAdmin(MARKET_MAKER, MARKET_MAKER_ADMIN);\n', '        _setupRole(MARKET_MAKER_ADMIN, _admin);\n', '        _setupRole(MARKET_MAKER, _admin);\n', '        _setupRole(MARKET_MAKER, msg.sender);\n', '\n', '        fees = _fees;\n', '        feeRecipients = _feeRecipients;\n', '        feeRecipientAssets = _feeRecipientAssets;\n', '        _assertFees();\n', '\n', '        setFactory(KNC, WETH, address(uniswapFactory));\n', '        setFactory(LRC, WETH, address(uniswapFactory));\n', '        setFactory(BAL, WETH, address(uniswapFactory));\n', '        setFactory(MTA, WETH, address(uniswapFactory));\n', '    }\n', '\n', '    // **** Modifiers ****\n', '\n', '    modifier authorized(bytes32 role) {\n', '        require(hasRole(role, msg.sender), "!authorized");\n', '        _;\n', '    }\n', '\n', '    // **** Stateless functions ****\n', '\n', '    function bridgeFor(address token) public view returns (address bridge) {\n', '        bridge = _bridges[token];\n', '        if (bridge == address(0)) {\n', '            bridge = WETH;\n', '        }\n', '    }\n', '\n', '    function factoryFor(address fromToken, address toToken) public view returns (address factory) {\n', '        bytes32 h = keccak256(abi.encode(fromToken, toToken));\n', '        factory = _factories[h];\n', '        if (factory == address(0)) {\n', '            factory = address(sushiswapFactory);\n', '        }\n', '    }\n', '\n', '    // **** Restricted functions ***\n', '\n', '    function setFees(\n', '        uint256[] memory _fees,\n', '        address[] memory _feeRecipients,\n', '        address[] memory _feeRecipientAssets\n', '    ) external authorized(TIMELOCK) {\n', '        fees = _fees;\n', '        feeRecipients = _feeRecipients;\n', '        feeRecipientAssets = _feeRecipientAssets;\n', '        _assertFees();\n', '    }\n', '\n', '    function setBridge(address token, address bridge) external authorized(MARKET_MAKER) {\n', '        require(token != BASK && token != WETH && token != bridge, "BaskMaker: Invalid bridge");\n', '        // Effects\n', '        _bridges[token] = bridge;\n', '        emit LogBridgeSet(token, bridge);\n', '    }\n', '\n', '    function setFactory(\n', '        address fromToken,\n', '        address toToken,\n', '        address factory\n', '    ) public authorized(MARKET_MAKER) {\n', '        require(\n', '            factory == address(sushiswapFactory) || factory == address(uniswapFactory),\n', '            "BaskMaker: Invalid factory"\n', '        );\n', '\n', '        // Effects\n', '        _factories[keccak256(abi.encode(fromToken, toToken))] = factory;\n', '        LogFactorySet(fromToken, toToken, factory);\n', '    }\n', '\n', '    function rescueERC20(address _token) public authorized(MARKET_MAKER) {\n', '        uint256 _amount = IERC20(_token).balanceOf(address(this));\n', '        IERC20(_token).safeTransfer(msg.sender, _amount);\n', '    }\n', '\n', '    function rescueERC20s(address[] memory _tokens) external authorized(MARKET_MAKER) {\n', '        for (uint256 i = 0; i < _tokens.length; i++) {\n', '            rescueERC20(_tokens[i]);\n', '        }\n', '    }\n', '\n', '    function convert(address token) external authorized(MARKET_MAKER) {\n', '        _convert(token);\n', '    }\n', '\n', '    function convertMultiple(address[] calldata tokens) external authorized(MARKET_MAKER) {\n', '        uint256 len = tokens.length;\n', '        for (uint256 i = 0; i < len; i++) {\n', '            _convert(tokens[i]);\n', '        }\n', '    }\n', '\n', '    // **** Internal functions ****\n', '\n', '    function _convert(address token) internal {\n', '        address token0 = _toUnderlying(token);\n', '        uint256 amount0 = IERC20(token0).balanceOf(address(this));\n', '\n', '        _convertStep(token0, amount0);\n', '    }\n', '\n', '    function _convertStep(address token, uint256 amount) internal {\n', '        // Final case\n', '        if (token == WETH) {\n', '            uint256 wethAllocAmount;\n', '            address wantedAsset;\n', '            for (uint256 i = 0; i < fees.length; i++) {\n', '                wethAllocAmount = amount.mul(fees[i]).div(1e18);\n', '                wantedAsset = feeRecipientAssets[i];\n', '                if (wantedAsset == token) {\n', '                    IERC20(token).safeTransfer(feeRecipients[i], wethAllocAmount);\n', '                } else {\n', '                    _swap(token, feeRecipientAssets[i], wethAllocAmount, feeRecipients[i]);\n', '                }\n', '            }\n', '            return;\n', '        }\n', '\n', '        // Otherwise keep converting\n', '        address bridge = bridgeFor(token);\n', '        uint256 amountOut = _swap(token, bridge, amount, address(this));\n', '        _convertStep(bridge, amountOut);\n', '    }\n', '\n', '    function _swap(\n', '        address fromToken,\n', '        address toToken,\n', '        uint256 amountIn,\n', '        address to\n', '    ) internal returns (uint256 amountOut) {\n', '        // Checks\n', '        // X1 - X5: OK\n', '        IUniswapV2Pair pair =\n', '            IUniswapV2Pair(IUniswapV2Factory(factoryFor(fromToken, toToken)).getPair(fromToken, toToken));\n', '        require(address(pair) != address(0), "BaskMaker: Cannot convert");\n', '\n', '        // Interactions\n', '        // X1 - X5: OK\n', '        (uint256 reserve0, uint256 reserve1, ) = pair.getReserves();\n', '        uint256 amountInWithFee = amountIn.mul(997);\n', '        if (fromToken == pair.token0()) {\n', '            amountOut = amountIn.mul(997).mul(reserve1) / reserve0.mul(1000).add(amountInWithFee);\n', '            IERC20(fromToken).safeTransfer(address(pair), amountIn);\n', '            pair.swap(0, amountOut, to, new bytes(0));\n', '            // TODO: Add maximum slippage?\n', '        } else {\n', '            amountOut = amountIn.mul(997).mul(reserve0) / reserve1.mul(1000).add(amountInWithFee);\n', '            IERC20(fromToken).safeTransfer(address(pair), amountIn);\n', '            pair.swap(amountOut, 0, to, new bytes(0));\n', '            // TODO: Add maximum slippage?\n', '        }\n', '        emit LogConverted(msg.sender, fromToken, toToken, to, amountIn, amountOut);\n', '    }\n', '\n', '    function _assertFees() internal view {\n', '        require(fees.length == feeRecipients.length, "!invalid-recipient-length");\n', '        require(fees.length == feeRecipientAssets.length, "!invalid-asset-length");\n', '\n', '        uint256 total = 0;\n', '        for (uint256 i = 0; i < fees.length; i++) {\n', '            total = total.add(fees[i]);\n', '        }\n', '\n', '        require(total == 1e18, "!valid-fees");\n', '    }\n', '}']