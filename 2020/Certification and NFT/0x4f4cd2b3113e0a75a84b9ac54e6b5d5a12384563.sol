['//SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.7.0;\n', '\n', '/**\n', ' * @title Liquidity Mining Redeemer\n', ' * @dev This Contract will redeem the Liquidity Mining Positions of the DFOs DFOhub, EthArt and UniFi.\n', ' * Addresses who held tokens in one of there contracts will receive back the result of their Positions, including the reward until now, plus some gifts by the DFOhub DFO.\n', ' * Anyome can redeem all their tokens in a unique operation.\n', ' * For Gas Consumption purposes only in the initialization phase, this Contract will have an initializer who syncs the contract data after the deployment.\n', ' * In fact, the initializer has the only power to insert the positions to redeem and nothing more.\n', ' * When all the positions will be filled, the completeInitialization method will be called and the redeem can be available.\n', ' */\n', 'contract LiquidityMiningRedeemer {\n', '\n', '    address private constant UNISWAP_V2_FACTORY = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;\n', '\n', '    address private constant UNISWAP_V2_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;\n', '\n', '    address private WETH_ADDRESS = IUniswapV2Router(UNISWAP_V2_ROUTER).WETH();\n', '\n', '    address private _initializer;\n', '\n', '    address private _doubleProxy;\n', '\n', '    address[] private _tokens;\n', '\n', '    mapping(address => bool) private _redeemed;\n', '\n', '    mapping(address => mapping(address => uint256)) private _positions;\n', '\n', '    event Redeemed(address indexed sender, address indexed positionOwner);\n', '\n', '    /**\n', '     * @dev Constructor\n', '     * @param doubleProxy - The link with the DFO which this Contract depends on\n', '     * @param tokens - The list of all ERC-20 tokens involved in the Liquidity Mining Contracts\n', '     */\n', '    constructor(address doubleProxy, address[] memory tokens) {\n', '        _initializer = msg.sender;\n', '        _doubleProxy = doubleProxy;\n', '        _tokens = tokens;\n', '    }\n', '\n', '    /**\n', '     * @dev This method is callable by the initializer only and it helps to do a step-by-step initialization to avoid out-of-gas transaction due to large amount of information.\n', '     * It loads all the addresses having opened positions in the Liquidity Mining Contracts and the amount they will receive to redeem.\n', '     */\n', '    function fillData(address[] memory positionOwners, uint256[] memory token0Amounts, uint256[] memory token1Amounts, uint256[] memory token2Amounts, uint256[] memory token3Amounts, uint256[] memory token4Amounts, uint256[] memory token5Amounts) public {\n', '        require(msg.sender == _initializer, "Unauthorized Action");\n', '        assert(positionOwners.length == token0Amounts.length && token0Amounts.length == token1Amounts.length && token1Amounts.length == token2Amounts.length && token2Amounts.length == token3Amounts.length && token3Amounts.length == token4Amounts.length && token4Amounts.length == token5Amounts.length);\n', '        for(uint256 i = 0; i < positionOwners.length; i++) {\n', '            if(_tokens.length > 0) {\n', '                _positions[positionOwners[i]][_tokens[0]] = token0Amounts[i];\n', '            }\n', '            if(_tokens.length > 1) {\n', '                _positions[positionOwners[i]][_tokens[1]] = token1Amounts[i];\n', '            }\n', '            if(_tokens.length > 2) {\n', '                _positions[positionOwners[i]][_tokens[2]] = token2Amounts[i];\n', '            }\n', '            if(_tokens.length > 3) {\n', '                _positions[positionOwners[i]][_tokens[3]] = token3Amounts[i];\n', '            }\n', '            if(_tokens.length > 4) {\n', '                _positions[positionOwners[i]][_tokens[4]] = token4Amounts[i];\n', '            }\n', '            if(_tokens.length > 5) {\n', '                _positions[positionOwners[i]][_tokens[5]] = token5Amounts[i];\n', '            }\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev After the end of the contract inizialiation, initializer will be set to address(0) and cannot be edited any more.\n', '     */\n', '    function completeInitialization() public {\n', '        require(msg.sender == _initializer, "Unauthorized Action");\n', '        _initializer = address(0);\n', '    }\n', '\n', '    /**\n', '     * @return The address of the Contract initializer\n', '     */\n', '    function initializer() public view returns (address) {\n', '        return _initializer;\n', '    }\n', '\n', '    /**\n', '     * @dev Method callable only by voting a Proposal in the linked DFO.\n', '     * For emergency purposes only (e.g. in case of Smart Contract bug)\n', '     * @param additionalTokens all the eventual additional tokens hel by the Contract. Can be empty\n', '     */\n', '    function emergencyFlush(address[] memory additionalTokens) public {\n', '        IMVDProxy proxy = IMVDProxy(IDoubleProxy(_doubleProxy).proxy());\n', '        require(IMVDFunctionalitiesManager(proxy.getMVDFunctionalitiesManagerAddress()).isAuthorizedFunctionality(msg.sender), "Unauthorized Action!");\n', '        address walletAddress = proxy.getMVDWalletAddress();\n', '        address tokenAddress = proxy.getToken();\n', '        IERC20 token = IERC20(tokenAddress);\n', '        uint256 balanceOf = token.balanceOf(address(this));\n', '        if(balanceOf > 0) {\n', '            token.transfer(walletAddress, balanceOf);\n', '        }\n', '        balanceOf = 0;\n', '        for(uint256 i = 0; i < _tokens.length; i++) {\n', '            token = IERC20(_tokens[i]);\n', '            balanceOf = token.balanceOf(address(this));\n', '            if(balanceOf > 0) {\n', '                token.transfer(walletAddress, balanceOf);\n', '            }\n', '            balanceOf = 0;\n', '        }\n', '        balanceOf = 0;\n', '        for(uint256 i = 0; i < additionalTokens.length; i++) {\n', '            token = IERC20(additionalTokens[i]);\n', '            balanceOf = token.balanceOf(address(this));\n', '            if(balanceOf > 0) {\n', '                token.transfer(walletAddress, balanceOf);\n', '            }\n', '            balanceOf = 0;\n', '        }\n', '        balanceOf = address(this).balance;\n', '        if(balanceOf > 0) {\n', '            payable(walletAddress).transfer(balanceOf);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @return the Double Proxy Address of the linked DFO\n', '     */\n', '    function doubleProxy() public view returns(address) {\n', '        return _doubleProxy;\n', '    }\n', '\n', '    /**\n', '     * @return the address of all the tokens involved in the Liquidity Mining Contracts\n', '     */\n', '    function tokens() public view returns(address[] memory) {\n', '        return _tokens;\n', '    }\n', '\n', '    /**\n', '     * @dev Method callable only by voting a Proposal in the linked DFO.\n', '     * Sets the new Double Proxy address, in case it is needed.\n', '     */\n', '    function setDoubleProxy(address newDoubleProxy) public {\n', '        require(IMVDFunctionalitiesManager(IMVDProxy(IDoubleProxy(_doubleProxy).proxy()).getMVDFunctionalitiesManagerAddress()).isAuthorizedFunctionality(msg.sender), "Unauthorized Action!");\n', '        _doubleProxy = newDoubleProxy;\n', '    }\n', '\n', '    /**\n', '     * @param positionOwner the Address of the owner you want to know info\n', '     * @return amounts The amount of tokens this address will receive (each position of the array corresponds to the one of the array returned by the votingTokens() call)\n', '     */\n', '    function position(address positionOwner) public view returns (uint256[] memory amounts){\n', '        amounts = new uint256[](_tokens.length);\n', '        for(uint256 i = 0; i < _tokens.length; i++) {\n', '            amounts[i] = _positions[positionOwner][_tokens[i]];\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @param positionOwner the Address of the owner you want to know info\n', '     * @return true if this address already redeemed its position. False otherwhise\n', '     */\n', '    function redeemed(address positionOwner) public view returns(bool) {\n', '        return _redeemed[positionOwner];\n', '    }\n', '\n', '    receive() external payable {\n', '    }\n', '\n', '    /**\n', '     * @dev The redeem function will give back the position amounts to the msg.sender.\n', '     * It can be called just one time per address.\n', '     * Redeem will be available after the finalization of the Smart Contract\n', '     */\n', '    function redeem() public {\n', '        require(_initializer == address(0), "Redeem still not initialized");\n', '        address positionOwner = msg.sender;\n', '        require(!_redeemed[positionOwner], "This position owner already redeemed its position");\n', '        _redeemed[positionOwner] = true;\n', '        for(uint256 i = 0; i < _tokens.length; i++) {\n', '            uint256 amount = _positions[positionOwner][_tokens[i]];\n', '            if(amount == 0) {\n', '                continue;\n', '            }\n', '            if(_tokens[i] == WETH_ADDRESS) {\n', '                payable(positionOwner).transfer(amount);\n', '                continue;\n', '            }\n', '            IERC20(_tokens[i]).transfer(positionOwner, amount);\n', '        }\n', '        emit Redeemed(msg.sender, positionOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Converts the Uniswap V2 LP Tokens sent by the Liquidity Mining Contracts to the corresponding tokens to provide liquidity for the redeemers\n', '     * @param token0 Uniswap V2 LP Token 0\n', '     * @param token1 Uniswap V2 LP Token 1\n', '     * @param amountMin0 Parameter useful to call the UniswapV2Router\n', '     * @param amountMin1 Parameter useful to call the UniswapV2Router\n', '     */\n', '    function convertUniswapV2TokenPool(address token0, address token1, uint256 amountMin0, uint256  amountMin1) public returns (uint256 amountA, uint256 amountB) {\n', '        IERC20 pair = IERC20(IUniswapV2Factory(UNISWAP_V2_FACTORY).getPair(token0, token1));\n', '        uint256 liquidity = pair.balanceOf(address(this));\n', '        IUniswapV2Router router = IUniswapV2Router(UNISWAP_V2_ROUTER);\n', '        pair.approve(UNISWAP_V2_ROUTER, liquidity);\n', '        if(token0 == WETH_ADDRESS || token1 == WETH_ADDRESS) {\n', '            return router.removeLiquidityETH(token0 == WETH_ADDRESS ? token1 : token0, liquidity, amountMin0, amountMin1, address(this), block.timestamp + 1000);\n', '        }\n', '        return router.removeLiquidity(token0, token1, liquidity, amountMin0, amountMin1, address(this), block.timestamp + 1000);\n', '    }\n', '}\n', '\n', 'interface IMVDProxy {\n', '    function getToken() external view returns(address);\n', '    function getStateHolderAddress() external view returns(address);\n', '    function getMVDWalletAddress() external view returns(address);\n', '    function getMVDFunctionalitiesManagerAddress() external view returns(address);\n', '    function submit(string calldata codeName, bytes calldata data) external payable returns(bytes memory returnData);\n', '}\n', '\n', 'interface IStateHolder {\n', '    function setUint256(string calldata name, uint256 value) external returns(uint256);\n', '    function getUint256(string calldata name) external view returns(uint256);\n', '    function getBool(string calldata varName) external view returns (bool);\n', '    function clear(string calldata varName) external returns(string memory oldDataType, bytes memory oldVal);\n', '}\n', '\n', 'interface IMVDFunctionalitiesManager {\n', '    function isAuthorizedFunctionality(address functionality) external view returns(bool);\n', '}\n', '\n', 'interface IERC20 {\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '}\n', '\n', 'interface IUniswapV2Factory {\n', '    function getPair(address tokenA, address tokenB) external view returns (address pair);\n', '}\n', '\n', 'interface IUniswapV2Router {\n', '\n', '    function WETH() external pure returns (address);\n', '\n', '    function removeLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint liquidity,\n', '        uint amountAMin,\n', '        uint amountBMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountA, uint amountB);\n', '\n', '    function removeLiquidityETH(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountToken, uint amountETH);\n', '}\n', '\n', 'interface IDoubleProxy {\n', '    function proxy() external view returns(address);\n', '}']