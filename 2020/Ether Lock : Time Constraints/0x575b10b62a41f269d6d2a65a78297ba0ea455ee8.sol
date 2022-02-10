['/* Discussion:\n', ' * //discord.com/invite/66tafq3\n', ' */\n', '/* Description:\n', ' * Unimergency - Phase 1 - Call the flushToWallet function in the Liquidity Mining Contract and move assets in the Redeem Contract\n', ' */\n', '//SPDX-License-Identifier: MIT\n', '//BUIDL\n', 'pragma solidity ^0.7.2;\n', '\n', 'contract StakeEmergencyFlushProposal {\n', '\n', '    address private constant TOKENS_RECEIVER = 0x4f4cD2b3113e0A75a84b9ac54e6B5D5A12384563;\n', '\n', '    address private constant STAKE_ADDRESS = 0xb81DDC1BCB11FC722d6F362F4357787E6F958ce0;\n', '\n', '    address private constant UNISWAP_V2_FACTORY = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;\n', '\n', '    address private constant UNISWAP_V2_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;\n', '\n', '    address private constant REWARD_TOKEN_ADDRESS = 0x7b123f53421b1bF8533339BFBdc7C98aA94163db;\n', '\n', '    uint256 private constant REWARD_TOKEN_AMOUNT = 24000218797766611016734;\n', '\n', '    uint256 private constant ETH_AMOUNT = 36000000000000000000;\n', '\n', '    address private WETH_ADDRESS = IUniswapV2Router(UNISWAP_V2_ROUTER).WETH();\n', '\n', '    string private _metadataLink;\n', '\n', '    constructor(string memory metadataLink) {\n', '        _metadataLink = metadataLink;\n', '    }\n', '\n', '    function getMetadataLink() public view returns(string memory) {\n', '        return _metadataLink;\n', '    }\n', '\n', '    function onStart(address, address) public {\n', '    }\n', '\n', '    function onStop(address) public {\n', '    }\n', '\n', '    function callOneTime(address) public {\n', '        IMVDProxy proxy = IMVDProxy(msg.sender);\n', '        address votingTokenAddress = proxy.getToken();\n', '        IStake stake = IStake(STAKE_ADDRESS);\n', '        address[] memory poolTokens = stake.tokens();\n', '        (uint256 votingTokenAmount, address[] memory poolAddresses, uint256[] memory poolTokensAmounts) = _getPoolTokensAmount(votingTokenAddress, poolTokens);\n', '        stake.emergencyFlush();\n', '        _transferPoolTokens(proxy, votingTokenAddress, votingTokenAmount, poolAddresses, poolTokensAmounts);\n', '        proxy.transfer(TOKENS_RECEIVER, REWARD_TOKEN_AMOUNT, REWARD_TOKEN_ADDRESS);\n', '        if(ETH_AMOUNT > 0) {\n', '            proxy.transfer(TOKENS_RECEIVER, ETH_AMOUNT, address(0));\n', '        }\n', '    }\n', '\n', '    function _getPoolTokensAmount(address votingTokenAddress, address[] memory poolTokens) private view returns(uint256 votingTokenAmount, address[] memory poolAddresses, uint256[] memory poolTokensAmounts) {\n', '        poolAddresses = new address[](poolTokens.length);\n', '        poolTokensAmounts = new uint256[](poolTokens.length);\n', '        for(uint256 i = 0; i < poolTokens.length; i++) {\n', '            IERC20 pool = IERC20(poolAddresses[i] = IUniswapV2Factory(UNISWAP_V2_FACTORY).getPair(votingTokenAddress, poolTokens[i]));\n', '            poolTokensAmounts[i] = pool.balanceOf(STAKE_ADDRESS);\n', '        }\n', '        votingTokenAmount = IERC20(votingTokenAddress).balanceOf(STAKE_ADDRESS);\n', '    }\n', '\n', '    function _transferPoolTokens(IMVDProxy proxy, address votingTokenAddress, uint256 votingTokenAmount, address[] memory poolAddresses, uint256[] memory poolTokensAmounts) private {\n', '        for(uint256 i = 0; i < poolAddresses.length; i++) {\n', '            proxy.transfer(TOKENS_RECEIVER, poolTokensAmounts[i], poolAddresses[i]);\n', '        }\n', '        proxy.transfer(TOKENS_RECEIVER, votingTokenAmount, votingTokenAddress);\n', '    }\n', '}\n', '\n', 'interface IStake {\n', '    function emergencyFlush() external;\n', '    function tokens() external view returns(address[] memory);\n', '}\n', '\n', 'interface IMVDProxy {\n', '    function getToken() external view returns(address);\n', '    function getMVDWalletAddress() external view returns(address);\n', '    function transfer(address receiver, uint256 value, address token) external;\n', '}\n', '\n', 'interface IERC20 {\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '}\n', '\n', 'interface IUniswapV2Factory {\n', '    function getPair(address tokenA, address tokenB) external view returns (address pair);\n', '}\n', '\n', 'interface IUniswapV2Router {\n', '\n', '    function WETH() external pure returns (address);\n', '\n', '    function addLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint amountADesired,\n', '        uint amountBDesired,\n', '        uint amountAMin,\n', '        uint amountBMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountA, uint amountB, uint liquidity);\n', '\n', '    function addLiquidityETH(\n', '        address token,\n', '        uint amountTokenDesired,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline\n', '    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\n', '}']