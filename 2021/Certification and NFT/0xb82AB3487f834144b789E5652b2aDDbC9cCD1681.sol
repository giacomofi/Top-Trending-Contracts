['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.7.3;\n', '\n', 'import "./Helpers.sol";\n', '\n', 'import "./IATokenV1.sol";\n', 'import "./ICToken.sol";\n', 'import "./IComptroller.sol";\n', 'import "./ISushiBar.sol";\n', 'import "./ILendingPoolV1.sol";\n', 'import "./ICompoundLens.sol";\n', 'import "./IUniswapV2.sol";\n', 'import "./IBasicIssuanceModule.sol";\n', 'import "./IOneInch.sol";\n', '\n', 'import "./SafeMath.sol";\n', 'import "./ERC20.sol";\n', 'import "./IERC20.sol";\n', 'import "./SafeERC20.sol";\n', 'import "./ReentrancyGuard.sol";\n', '\n', '// Basket Weaver is a way to socialize gas costs related to minting baskets tokens\n', 'contract SocialWeaverV1 is ReentrancyGuard, Helpers {\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for IERC20;\n', '\n', '    IOneInch public constant OneInch = IOneInch(0xC586BeF4a0992C495Cf22e1aeEE4E446CECDee0E);\n', '    IBDPI public constant BDPI = IBDPI(0x0309c98B1bffA350bcb3F9fB9780970CA32a5060);\n', '\n', '    IBasicIssuanceModule public constant DPI_ISSUER = IBasicIssuanceModule(0xd8EF3cACe8b4907117a45B0b125c68560532F94D);\n', '\n', '    address public governance;\n', '\n', '    // **** ETH **** //\n', '\n', '    // Current weaveId\n', '    uint256 public weaveIdETH = 0;\n', '\n', '    // User Address => WeaveId => Amount deposited\n', '    mapping(address => mapping(uint256 => uint256)) public depositsETH;\n', '\n', '    // User Address => WeaveId => Claimed\n', '    mapping(address => mapping(uint256 => bool)) public basketsClaimedETH;\n', '\n', '    // WeaveId => Amount deposited\n', '    mapping(uint256 => uint256) public totalDepositedETH;\n', '\n', '    // Basket minted per weaveId\n', '    mapping(uint256 => uint256) public basketsMintedETH;\n', '\n', '    // **** DPI **** //\n', '    uint256 public weaveIdDPI = 0;\n', '\n', '    // User Address => WeaveId => Amount deposited\n', '    mapping(address => mapping(uint256 => uint256)) public depositsDPI;\n', '\n', '    // User Address => WeaveId => Claimed\n', '    mapping(address => mapping(uint256 => bool)) public basketsClaimedDPI;\n', '\n', '    // WeaveId => Amount deposited\n', '    mapping(uint256 => uint256) public totalDepositedDPI;\n', '\n', '    // Basket minted per weaveId\n', '    mapping(uint256 => uint256) public basketsMintedDPI;\n', '\n', '    // Approved users to call weave\n', '    // This is v important as invalid inputs will\n', '    // be basically a "fat finger"\n', '    mapping(address => bool) public approvedWeavers;\n', '\n', '    // **** Constructor and modifiers ****\n', '\n', '    constructor(address _governance) {\n', '        governance = _governance;\n', '\n', '        // Enter compound markets\n', '        address[] memory markets = new address[](2);\n', '        markets[0] = CUNI;\n', '        markets[0] = CCOMP;\n', '        enterMarkets(markets);\n', '    }\n', '\n', '    modifier onlyGov() {\n', '        require(msg.sender == governance, "!governance");\n', '        _;\n', '    }\n', '\n', '    modifier onlyWeavers {\n', '        require(msg.sender == governance || approvedWeavers[msg.sender], "!weaver");\n', '        _;\n', '    }\n', '\n', '    receive() external payable {}\n', '\n', '    // **** Protected functions ****\n', '\n', '    function approveWeaver(address _weaver) public onlyGov {\n', '        approvedWeavers[_weaver] = true;\n', '    }\n', '\n', '    function revokeWeaver(address _weaver) public onlyGov {\n', '        approvedWeavers[_weaver] = false;\n', '    }\n', '\n', '    function setGov(address _governance) public onlyGov {\n', '        governance = _governance;\n', '    }\n', '\n', '    // Emergency\n', '    function recoverERC20(address _token) public onlyGov {\n', '        require(address(_token) != address(BDPI), "!dpi");\n', '        require(address(_token) != address(DPI), "!dpi");\n', '        IERC20(_token).safeTransfer(governance, IERC20(_token).balanceOf(address(this)));\n', '    }\n', '\n', '    /// @notice Converts DPI into a Basket, socializing gas cost\n', '    /// @param  derivatives  Address of the derivatives (e.g. cUNI, aYFI)\n', '    /// @param  underlyings  Address of the underlyings (e.g. UNI,   YFI)\n', '    /// @param  minMintAmount Minimum amount of basket token to mint\n', '    /// @param  deadline      Deadline to mint by\n', '    function weaveWithDPI(\n', '        address[] memory derivatives,\n', '        address[] memory underlyings,\n', '        uint256 minMintAmount,\n', '        uint256 deadline\n', '    ) public onlyWeavers {\n', '        require(block.timestamp <= deadline, "expired");\n', '        uint256 bdpiToMint = _burnDPIAndGetMintableBDPI(derivatives, underlyings);\n', '        require(bdpiToMint >= minMintAmount, "!mint-min-amount");\n', '\n', '        // Save the amount minted to mintId\n', '        // Leftover dust will be rolledover to next batch\n', '        basketsMintedDPI[weaveIdDPI] = bdpiToMint;\n', '\n', '        // Mint tokens\n', '        BDPI.mint(bdpiToMint);\n', '\n', '        weaveIdDPI++;\n', '    }\n', '\n', '    /// @notice Converts ETH into a Basket, socializing gas cost\n', '    /// @param  derivatives  Address of the derivatives (e.g. cUNI, aYFI)\n', '    /// @param  underlyings  Address of the underlyings (e.g. UNI,   YFI)\n', '    /// @param  minMintAmount Minimum amount of basket token to mint\n', '    /// @param  deadline      Deadline to mint by\n', '    function weaveWithETH(\n', '        address[] memory derivatives,\n', '        address[] memory underlyings,\n', '        uint256 minMintAmount,\n', '        uint256 deadline\n', '    ) public onlyWeavers {\n', '        require(block.timestamp <= deadline, "expired");\n', '\n', '        // ETH -> DPI\n', '        // address(0) is ETH\n', '        (uint256 retAmount, uint256[] memory distribution) =\n', '            OneInch.getExpectedReturn(address(0), DPI, address(this).balance, 2, 0);\n', '        OneInch.swap{ value: address(this).balance }(\n', '            address(0),\n', '            DPI,\n', '            address(this).balance,\n', '            retAmount,\n', '            distribution,\n', '            0\n', '        );\n', '        // DPI -> BDPI\n', '        uint256 bdpiToMint = _burnDPIAndGetMintableBDPI(derivatives, underlyings);\n', '        require(bdpiToMint >= minMintAmount, "!mint-min-amount");\n', '\n', '        // Save the amount minted to mintId\n', '        // Leftover dust will be rolledover to next batch\n', '        basketsMintedETH[weaveIdETH] = bdpiToMint;\n', '\n', '        // Mint tokens\n', '        BDPI.mint(bdpiToMint);\n', '\n', '        weaveIdETH++;\n', '    }\n', '\n', '    // **** Public functions ****\n', '\n', '    //// DPI\n', '\n', '    /// @notice Deposits DPI to be later converted into the Basket by some kind soul\n', '    function depositDPI(uint256 _amount) public nonReentrant {\n', '        require(_amount > 1e8, "!dust-dpi");\n', '        IERC20(DPI).safeTransferFrom(msg.sender, address(this), _amount);\n', '\n', '        depositsDPI[msg.sender][weaveIdDPI] = depositsDPI[msg.sender][weaveIdDPI].add(_amount);\n', '        totalDepositedDPI[weaveIdDPI] = totalDepositedDPI[weaveIdDPI].add(_amount);\n', '    }\n', '\n', "    /// @notice User doesn't want to wait anymore and just wants their DPI back\n", '    function withdrawDPI(uint256 _amount) public nonReentrant {\n', '        // Reverts if withdrawing too many\n', '        depositsDPI[msg.sender][weaveIdDPI] = depositsDPI[msg.sender][weaveIdDPI].sub(_amount);\n', '        totalDepositedDPI[weaveIdDPI] = totalDepositedDPI[weaveIdDPI].sub(_amount);\n', '\n', '        IERC20(DPI).safeTransfer(msg.sender, _amount);\n', '    }\n', '\n', '    /// @notice User withdraws converted Basket token\n', '    function withdrawBasketDPI(uint256 _weaveId) public payable nonReentrant {\n', '        require(_weaveId < weaveIdDPI, "!weaved");\n', '        require(!basketsClaimedDPI[msg.sender][_weaveId], "already-claimed");\n', '        uint256 userDeposited = depositsDPI[msg.sender][_weaveId];\n', '        require(userDeposited > 0, "!deposit");\n', '\n', '        uint256 ratio = userDeposited.mul(1e18).div(totalDepositedDPI[_weaveId]);\n', '        uint256 userBasketAmount = basketsMintedDPI[_weaveId].mul(ratio).div(1e18);\n', '        basketsClaimedDPI[msg.sender][_weaveId] = true;\n', '\n', '        IERC20(address(BDPI)).safeTransfer(msg.sender, userBasketAmount);\n', '    }\n', '\n', '    //// ETH\n', '\n', '    /// @notice Deposits ETH to be later converted into the Basket by some kind soul\n', '    function depositETH() public payable nonReentrant {\n', '        require(msg.value > 1e8, "!dust-eth");\n', '\n', '        depositsETH[msg.sender][weaveIdETH] = depositsETH[msg.sender][weaveIdETH].add(msg.value);\n', '        totalDepositedETH[weaveIdETH] = totalDepositedETH[weaveIdETH].add(msg.value);\n', '    }\n', '\n', "    /// @notice User doesn't want to wait anymore and just wants their ETH back\n", '    function withdrawETH(uint256 _amount) public nonReentrant {\n', '        // Reverts if withdrawing too many\n', '        depositsETH[msg.sender][weaveIdETH] = depositsETH[msg.sender][weaveIdETH].sub(_amount);\n', '        totalDepositedETH[weaveIdETH] = totalDepositedETH[weaveIdETH].sub(_amount);\n', '\n', '        (bool s, ) = msg.sender.call{ value: _amount }("");\n', '        require(s, "!transfer-eth");\n', '    }\n', '\n', '    /// @notice User withdraws converted Basket token\n', '    function withdrawBasketETH(uint256 _weaveId) public payable nonReentrant {\n', '        require(_weaveId < weaveIdETH, "!weaved");\n', '        require(!basketsClaimedETH[msg.sender][_weaveId], "already-claimed");\n', '        uint256 userDeposited = depositsETH[msg.sender][_weaveId];\n', '        require(userDeposited > 0, "!deposit");\n', '\n', '        uint256 ratio = userDeposited.mul(1e18).div(totalDepositedETH[_weaveId]);\n', '        uint256 userBasketAmount = basketsMintedETH[_weaveId].mul(ratio).div(1e18);\n', '        basketsClaimedETH[msg.sender][_weaveId] = true;\n', '\n', '        IERC20(address(BDPI)).safeTransfer(msg.sender, userBasketAmount);\n', '    }\n', '\n', '    // **** Internals ****\n', '\n', '    /// @notice Chooses which router address to use\n', '    function _getRouterAddressForToken(address _token) internal pure returns (address) {\n', '        // Chooses which router (uniswap or sushiswap) to use to swap tokens\n', '        // By default: SUSHI\n', "        // But some tokens don't have liquidity on SUSHI, so we use UNI\n", "        // Don't want to use 1inch as its too costly gas-wise\n", '\n', '        if (_token == KNC || _token == LRC || _token == BAL || _token == MTA) {\n', '            return UNIV2_ROUTER;\n', '        }\n', '\n', '        return SUSHISWAP_ROUTER;\n', '    }\n', '\n', '    /// @notice\n', '    function _burnDPIAndGetMintableBDPI(address[] memory derivatives, address[] memory underlyings)\n', '        internal\n', '        returns (uint256)\n', '    {\n', '        // Burn DPI\n', '        uint256 dpiBal = IERC20(DPI).balanceOf(address(this));\n', '        IERC20(DPI).approve(address(DPI_ISSUER), dpiBal);\n', '        DPI_ISSUER.redeem(address(DPI), dpiBal, address(this));\n', '\n', '        // Convert components to derivative\n', '        (, uint256[] memory tokenAmountsInBasket) = BDPI.getAssetsAndBalances();\n', '        uint256 basketTotalSupply = BDPI.totalSupply();\n', '        uint256 bdpiToMint;\n', '        for (uint256 i = 0; i < derivatives.length; i++) {\n', '            // Convert to from respective token to derivative\n', '            _toDerivative(underlyings[i], derivatives[i]);\n', '\n', '            // Approve derivative and calculate mint amount\n', '            bdpiToMint = _approveDerivativeAndGetMintAmount(\n', '                derivatives[i],\n', '                basketTotalSupply,\n', '                tokenAmountsInBasket[i],\n', '                bdpiToMint\n', '            );\n', '        }\n', '\n', '        return bdpiToMint;\n', '    }\n', '\n', '    /// @notice Approves derivative to the basket address and gets the mint amount.\n', '    ///         Mainly here to avoid stack too deep errors\n', '    /// @param  derivative  Address of the derivative (e.g. cUNI, aYFI)\n', '    /// @param  basketTotalSupply  Total supply of the basket token\n', '    /// @param  tokenAmountInBasket  Amount of derivative currently in the basket\n', '    /// @param  curMintAmount  Accumulator - whats the minimum mint amount right now\n', '    function _approveDerivativeAndGetMintAmount(\n', '        address derivative,\n', '        uint256 basketTotalSupply,\n', '        uint256 tokenAmountInBasket,\n', '        uint256 curMintAmount\n', '    ) internal returns (uint256) {\n', '        uint256 derivativeBal = IERC20(derivative).balanceOf(address(this));\n', '\n', '        IERC20(derivative).safeApprove(address(BDPI), derivativeBal);\n', '\n', '        // Calculate how much BDPI we can mint at max\n', '        // Formula: min(e for e in bdpiSupply * tokenWeHave[e] / tokenInBDPI[e])\n', '        if (curMintAmount == 0) {\n', '            return basketTotalSupply.mul(derivativeBal).div(tokenAmountInBasket);\n', '        }\n', '\n', '        uint256 temp = basketTotalSupply.mul(derivativeBal).div(tokenAmountInBasket);\n', '        if (temp < curMintAmount) {\n', '            return temp;\n', '        }\n', '\n', '        return curMintAmount;\n', '    }\n', '}']