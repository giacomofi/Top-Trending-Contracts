['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-27\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', '\n', 'pragma solidity ^0.6.6;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'interface OrFeedInterface {\n', '    function getExchangeRate ( string calldata fromSymbol, string calldata  toSymbol, string calldata venue, uint256 amount ) external view returns ( uint256 );\n', '    function getTokenDecimalCount ( address tokenAddress ) external view returns ( uint256 );\n', '    function getTokenAddress ( string calldata  symbol ) external view returns ( address );\n', '    function getSynthBytes32 ( string calldata  symbol ) external view returns ( bytes32 );\n', '    function getForexAddress ( string calldata symbol ) external view returns ( address );\n', '    function arb(address  fundsReturnToAddress,  address liquidityProviderContractAddress, string[] calldata   tokens,  uint256 amount, string[] calldata  exchanges) external payable returns (bool);\n', '}\n', '\n', 'interface IERC20 {\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    function approve(address _spender, uint256 _value) external returns (bool success);\n', '\n', '    function transfer(address _to, uint256 _value) external returns (bool success);\n', '\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _value\n', '    ) external returns (bool success);\n', '\n', '    function allowance(address _owner, address _spender) external view returns (uint256 remaining);\n', '\n', '    function balanceOf(address _owner) external view returns (uint256 balance);\n', '\n', '    function decimals() external view returns (uint8 digits);\n', '\n', '    function totalSupply() external view returns (uint256 supply);\n', '}\n', '\n', '\n', '// to support backward compatible contract name -- so function signature remains same\n', 'abstract contract ERC20 is IERC20 {\n', '\n', '}\n', '\n', 'interface IKyberNetworkProxy {\n', '\n', '    event ExecuteTrade(\n', '        address indexed trader,\n', '        IERC20 src,\n', '        IERC20 dest,\n', '        address destAddress,\n', '        uint256 actualSrcAmount,\n', '        uint256 actualDestAmount,\n', '        address platformWallet,\n', '        uint256 platformFeeBps\n', '    );\n', '\n', '    /// @notice backward compatible\n', '    function tradeWithHint(\n', '        ERC20 src,\n', '        uint256 srcAmount,\n', '        ERC20 dest,\n', '        address payable destAddress,\n', '        uint256 maxDestAmount,\n', '        uint256 minConversionRate,\n', '        address payable walletId,\n', '        bytes calldata hint\n', '    ) external payable returns (uint256);\n', '\n', '    function tradeWithHintAndFee(\n', '        IERC20 src,\n', '        uint256 srcAmount,\n', '        IERC20 dest,\n', '        address payable destAddress,\n', '        uint256 maxDestAmount,\n', '        uint256 minConversionRate,\n', '        address payable platformWallet,\n', '        uint256 platformFeeBps,\n', '        bytes calldata hint\n', '    ) external payable returns (uint256 destAmount);\n', '\n', '    function trade(\n', '        IERC20 src,\n', '        uint256 srcAmount,\n', '        IERC20 dest,\n', '        address payable destAddress,\n', '        uint256 maxDestAmount,\n', '        uint256 minConversionRate,\n', '        address payable platformWallet\n', '    ) external payable returns (uint256);\n', '\n', '    /// @notice backward compatible\n', '    /// @notice Rate units (10 ** 18) => destQty (twei) / srcQty (twei) * 10 ** 18\n', '    function getExpectedRate(\n', '        ERC20 src,\n', '        ERC20 dest,\n', '        uint256 srcQty\n', '    ) external view returns (uint256 expectedRate, uint256 worstRate);\n', '\n', '    function getExpectedRateAfterFee(\n', '        IERC20 src,\n', '        IERC20 dest,\n', '        uint256 srcQty,\n', '        uint256 platformFeeBps,\n', '        bytes calldata hint\n', '    ) external view returns (uint256 expectedRate);\n', '\n', '}\n', '\n', '\n', '// ERC20 Token Smart Contract\n', 'contract oracleInfo {\n', '\n', '    address owner;\n', '    OrFeedInterface orfeed = OrFeedInterface(0x8316B082621CFedAB95bf4a44a1d4B64a6ffc336);\n', '    address kyberProxyAddress = 0x818E6FECD516Ecc3849DAf6845e3EC868087B755;\n', '    IKyberNetworkProxy kyberProxy = IKyberNetworkProxy(kyberProxyAddress);\n', '\n', '    constructor() public payable {\n', '        owner = msg.sender;\n', '\n', '    }\n', '    \n', '    function getTokenPrice(string memory fromParam, string memory toParam, string memory venue, uint256 amount) public view returns (uint256) {\n', '         return orfeed.getExchangeRate(fromParam, toParam, venue, amount);\n', '\n', '    }\n', '\n', '    function getPriceFromOracle(string memory fromParam, string memory toParam, uint256 amount) public view returns (uint256){\n', '\n', '        address sellToken = orfeed.getTokenAddress(fromParam);\n', '        address buyToken = orfeed.getTokenAddress(toParam);\n', '\n', '        ERC20 sellToken1 = ERC20(sellToken);\n', '        ERC20 buyToken1 = ERC20(buyToken);\n', '\n', '        uint sellDecim = sellToken1.decimals();\n', '        uint buyDecim = buyToken1.decimals();\n', '\n', '        // uint base = 1^sellDecim;\n', '        // uint adding;\n', '        (uint256 price,) = kyberProxy.getExpectedRate(sellToken1, buyToken1, amount);\n', '\n', '\n', '        uint initResp = (((price * 1000000) / (10 ** 18)) * (amount)) / 1000000;\n', '        uint256 diff;\n', '        if (sellDecim > buyDecim) {\n', '            diff = sellDecim - buyDecim;\n', '            initResp = initResp / (10 ** diff);\n', '            return initResp;\n', '        }\n', '\n', '        else if (sellDecim < buyDecim) {\n', '            diff = buyDecim - sellDecim;\n', '            initResp = initResp * (10 ** diff);\n', '            return initResp;\n', '        }\n', '        else {\n', '            return initResp;\n', '        }\n', '\n', '\n', '    }\n', '\n', '\n', '}']