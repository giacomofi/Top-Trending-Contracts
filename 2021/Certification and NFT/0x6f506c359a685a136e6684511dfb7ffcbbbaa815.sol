['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-15\n', '*/\n', '\n', '// File: contracts/interfaces/IVaultParameters.sol\n', '\n', 'interface IVaultParameters {\n', '    function canModifyVault ( address ) external view returns ( bool );\n', '    function foundation (  ) external view returns ( address );\n', '    function isManager ( address ) external view returns ( bool );\n', '    function isOracleTypeEnabled ( uint256, address ) external view returns ( bool );\n', '    function liquidationFee ( address ) external view returns ( uint256 );\n', '    function setCollateral ( address asset, uint256 stabilityFeeValue, uint256 liquidationFeeValue, uint256 usdpLimit, uint256[] calldata oracles ) external;\n', '    function setFoundation ( address newFoundation ) external;\n', '    function setLiquidationFee ( address asset, uint256 newValue ) external;\n', '    function setManager ( address who, bool permit ) external;\n', '    function setOracleType ( uint256 _type, address asset, bool enabled ) external;\n', '    function setStabilityFee ( address asset, uint256 newValue ) external;\n', '    function setTokenDebtLimit ( address asset, uint256 limit ) external;\n', '    function setVaultAccess ( address who, bool permit ) external;\n', '    function stabilityFee ( address ) external view returns ( uint256 );\n', '    function tokenDebtLimit ( address ) external view returns ( uint256 );\n', '    function vault (  ) external view returns ( address );\n', '    function vaultParameters (  ) external view returns ( address );\n', '}\n', '\n', '// File: contracts/interfaces/IVaultManagerParameters.sol\n', '\n', 'interface IVaultManagerParameters {\n', '    function devaluationPeriod ( address ) external view returns ( uint256 );\n', '    function initialCollateralRatio ( address ) external view returns ( uint256 );\n', '    function liquidationDiscount ( address ) external view returns ( uint256 );\n', '    function liquidationRatio ( address ) external view returns ( uint256 );\n', '    function maxColPercent ( address ) external view returns ( uint256 );\n', '    function minColPercent ( address ) external view returns ( uint256 );\n', '    function setColPartRange ( address asset, uint256 min, uint256 max ) external;\n', '    function setCollateral (\n', '        address asset,\n', '        uint256 stabilityFeeValue,\n', '        uint256 liquidationFeeValue,\n', '        uint256 initialCollateralRatioValue,\n', '        uint256 liquidationRatioValue,\n', '        uint256 liquidationDiscountValue,\n', '        uint256 devaluationPeriodValue,\n', '        uint256 usdpLimit,\n', '        uint256[] calldata oracles,\n', '        uint256 minColP,\n', '        uint256 maxColP\n', '    ) external;\n', '    function setDevaluationPeriod ( address asset, uint256 newValue ) external;\n', '    function setInitialCollateralRatio ( address asset, uint256 newValue ) external;\n', '    function setLiquidationDiscount ( address asset, uint256 newValue ) external;\n', '    function setLiquidationRatio ( address asset, uint256 newValue ) external;\n', '    function vaultParameters (  ) external view returns ( address );\n', '}\n', '\n', '// File: contracts/interfaces/IVault.sol\n', '\n', 'interface IVault {\n', '    function DENOMINATOR_1E2 (  ) external view returns ( uint256 );\n', '    function DENOMINATOR_1E5 (  ) external view returns ( uint256 );\n', '    function borrow ( address asset, address user, uint256 amount ) external returns ( uint256 );\n', '    function calculateFee ( address asset, address user, uint256 amount ) external view returns ( uint256 );\n', '    function changeOracleType ( address asset, address user, uint256 newOracleType ) external;\n', '    function chargeFee ( address asset, address user, uint256 amount ) external;\n', '    function col (  ) external view returns ( address );\n', '    function colToken ( address, address ) external view returns ( uint256 );\n', '    function collaterals ( address, address ) external view returns ( uint256 );\n', '    function debts ( address, address ) external view returns ( uint256 );\n', '    function depositCol ( address asset, address user, uint256 amount ) external;\n', '    function depositEth ( address user ) external payable;\n', '    function depositMain ( address asset, address user, uint256 amount ) external;\n', '    function destroy ( address asset, address user ) external;\n', '    function getTotalDebt ( address asset, address user ) external view returns ( uint256 );\n', '    function lastUpdate ( address, address ) external view returns ( uint256 );\n', '    function liquidate ( address asset, address positionOwner, uint256 mainAssetToLiquidator, uint256 colToLiquidator, uint256 mainAssetToPositionOwner, uint256 colToPositionOwner, uint256 repayment, uint256 penalty, address liquidator ) external;\n', '    function liquidationBlock ( address, address ) external view returns ( uint256 );\n', '    function liquidationFee ( address, address ) external view returns ( uint256 );\n', '    function liquidationPrice ( address, address ) external view returns ( uint256 );\n', '    function oracleType ( address, address ) external view returns ( uint256 );\n', '    function repay ( address asset, address user, uint256 amount ) external returns ( uint256 );\n', '    function spawn ( address asset, address user, uint256 _oracleType ) external;\n', '    function stabilityFee ( address, address ) external view returns ( uint256 );\n', '    function tokenDebts ( address ) external view returns ( uint256 );\n', '    function triggerLiquidation ( address asset, address positionOwner, uint256 initialPrice ) external;\n', '    function update ( address asset, address user ) external;\n', '    function usdp (  ) external view returns ( address );\n', '    function vaultParameters (  ) external view returns ( address );\n', '    function weth (  ) external view returns ( address payable );\n', '    function withdrawCol ( address asset, address user, uint256 amount ) external;\n', '    function withdrawEth ( address user, uint256 amount ) external;\n', '    function withdrawMain ( address asset, address user, uint256 amount ) external;\n', '}\n', '\n', '// File: contracts/interfaces/IToken.sol\n', '\n', 'interface IToken {\n', '    function decimals() external view returns (uint8);\n', '    function symbol() external view returns (string memory);\n', '    function balanceOf(address) external view returns (uint);\n', '}\n', '\n', '// File: contracts/interfaces/IOracleRegistry.sol\n', '\n', 'pragma abicoder v2;\n', '\n', '\n', 'interface IOracleRegistry {\n', '\n', '    struct Oracle {\n', '        uint oracleType;\n', '        address oracleAddress;\n', '    }\n', '\n', '    function WETH (  ) external view returns ( address );\n', '    function getKeydonixOracleTypes (  ) external view returns ( uint256[] memory );\n', '    function getOracles (  ) external view returns ( Oracle[] memory foundOracles );\n', '    function keydonixOracleTypes ( uint256 ) external view returns ( uint256 );\n', '    function maxOracleType (  ) external view returns ( uint256 );\n', '    function oracleByAsset ( address asset ) external view returns ( address );\n', '    function oracleByType ( uint256 ) external view returns ( address );\n', '    function oracleTypeByAsset ( address ) external view returns ( uint256 );\n', '    function oracleTypeByOracle ( address ) external view returns ( uint256 );\n', '    function setKeydonixOracleTypes ( uint256[] memory _keydonixOracleTypes ) external;\n', '    function setOracle ( uint256 oracleType, address oracle ) external;\n', '    function setOracleTypeForAsset ( address asset, uint256 oracleType ) external;\n', '    function setOracleTypeForAssets ( address[] memory assets, uint256 oracleType ) external;\n', '    function unsetOracle ( uint256 oracleType ) external;\n', '    function unsetOracleForAsset ( address asset ) external;\n', '    function unsetOracleForAssets ( address[] memory assets ) external;\n', '    function vaultParameters (  ) external view returns ( address );\n', '}\n', '\n', '// File: contracts/helpers/IUniswapV2PairFull.sol\n', '\n', '// SPDX-License-Identifier: bsl-1.1\n', '\n', '/*\n', '  Copyright 2020 Unit Protocol: Artem Zakharov ([email\xa0protected]).\n', '*/\n', 'pragma solidity 0.7.6;\n', '\n', 'interface IUniswapV2PairFull {\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    function name() external pure returns (string memory);\n', '    function symbol() external pure returns (string memory);\n', '    function decimals() external pure returns (uint8);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function transferFrom(address from, address to, uint value) external returns (bool);\n', '\n', '    function DOMAIN_SEPARATOR() external view returns (bytes32);\n', '    function PERMIT_TYPEHASH() external pure returns (bytes32);\n', '    function nonces(address owner) external view returns (uint);\n', '\n', '    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;\n', '\n', '    event Mint(address indexed sender, uint amount0, uint amount1);\n', '    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);\n', '    event Swap(\n', '        address indexed sender,\n', '        uint amount0In,\n', '        uint amount1In,\n', '        uint amount0Out,\n', '        uint amount1Out,\n', '        address indexed to\n', '    );\n', '    event Sync(uint112 reserve0, uint112 reserve1);\n', '\n', '    function MINIMUM_LIQUIDITY() external pure returns (uint);\n', '    function factory() external view returns (address);\n', '    function token0() external view returns (address);\n', '    function token1() external view returns (address);\n', '    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '    function price0CumulativeLast() external view returns (uint);\n', '    function price1CumulativeLast() external view returns (uint);\n', '    function kLast() external view returns (uint);\n', '\n', '    function mint(address to) external returns (uint liquidity);\n', '    function burn(address to) external returns (uint amount0, uint amount1);\n', '    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\n', '    function skim(address to) external;\n', '    function sync() external;\n', '\n', '    function initialize(address, address) external;\n', '}\n', '\n', '// File: contracts/helpers/CDPViewer.sol\n', '\n', '/*\n', '  Copyright 2021 Unit Protocol: Artem Zakharov ([email\xa0protected]).\n', '*/\n', 'pragma solidity 0.7.6;\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', 'interface IMaker {\n', '    function symbol() external view returns(bytes32);\n', '}\n', '\n', '\n', '/**\n', ' * @notice Views collaterals in one request to save node requests and speed up dapps.\n', ' */\n', 'contract CDPViewer {\n', '\n', '    IVault public vault;\n', '    IVaultParameters public  vaultParameters;\n', '    IVaultManagerParameters public  vaultManagerParameters;\n', '    IOracleRegistry public  oracleRegistry;\n', '\n', '    struct CDP {\n', '        address owner;\n', '\n', '        // Collateral amount\n', '        uint128 collateral;\n', '\n', '        // Debt amount\n', '        uint128 debt;\n', '\n', '        // Percentage with 3 decimals\n', '        uint32 stabilityFee;\n', '\n', '        // Percentage with 0 decimals\n', '        uint16 liquidationFee;\n', '    }\n', '\n', '    struct CollateralParameters {\n', '\n', '        address asset;\n', '\n', '        // Percentage with 3 decimals\n', '        uint32 stabilityFee;\n', '\n', '        // Percentage with 0 decimals\n', '        uint16 liquidationFee;\n', '\n', '        // Percentage with 0 decimals\n', '        uint16 initialCollateralRatio;\n', '\n', '        // Percentage with 0 decimals\n', '        uint16 liquidationRatio;\n', '\n', '        // Percentage with 3 decimals\n', '        uint32 liquidationDiscount;\n', '\n', '        // Devaluation period in blocks\n', '        uint32 devaluationPeriod;\n', '\n', '        // USDP mint limit\n', '        uint128 tokenDebtLimit;\n', '\n', '        // USDP mint limit\n', '        uint128 tokenDebt;\n', '\n', '        // Oracle types enabled for this asset\n', '        uint16 oracleType;\n', '\n', '        CDP cdp;\n', '    }\n', '\n', '    struct TokenDetails {\n', '        uint balance;\n', '        address[2] lpUnderlyings;\n', '    }\n', '\n', '\n', '    constructor() {\n', '         IVaultManagerParameters vmp = IVaultManagerParameters(0x203153522B9EAef4aE17c6e99851EE7b2F7D312E);\n', '         vaultManagerParameters = vmp;\n', '         IVaultParameters vp = IVaultParameters(vmp.vaultParameters());\n', '         vaultParameters = vp;\n', '         vault = IVault(vp.vault());\n', '         IOracleRegistry or = IOracleRegistry(0x75fBFe26B21fd3EA008af0C764949f8214150C8f);\n', '         oracleRegistry = or;\n', '    }\n', '\n', '    /**\n', '     * @notice Get parameters of one asset\n', '     * @param asset asset address\n', '     * @param owner owner address\n', '     */\n', '    function getCollateralParameters(address asset, address owner)\n', '        public\n', '        view\n', '        returns (CollateralParameters memory r)\n', '    {\n', '        r.asset = asset;\n', '        r.stabilityFee = uint32(vaultParameters.stabilityFee(asset));\n', '        r.liquidationFee = uint16(vaultParameters.liquidationFee(asset));\n', '        r.initialCollateralRatio = uint16(vaultManagerParameters.initialCollateralRatio(asset));\n', '        r.liquidationRatio = uint16(vaultManagerParameters.liquidationRatio(asset));\n', '        r.liquidationDiscount = uint32(vaultManagerParameters.liquidationDiscount(asset));\n', '        r.devaluationPeriod = uint32(vaultManagerParameters.devaluationPeriod(asset));\n', '\n', '        r.tokenDebtLimit = uint128(vaultParameters.tokenDebtLimit(asset));\n', '        r.tokenDebt = uint128(vault.tokenDebts(asset));\n', '        r.oracleType = uint16(oracleRegistry.oracleTypeByAsset(asset));\n', '\n', '        if (owner == address(0)) return r;\n', '\n', '        r.cdp.owner = owner;\n', '        r.cdp.stabilityFee = uint32(vault.stabilityFee(asset, owner));\n', '        r.cdp.liquidationFee = uint16(vault.liquidationFee(asset, owner));\n', '        r.cdp.debt = uint128(vault.debts(asset, owner));\n', '        r.cdp.collateral = uint128(vault.collaterals(asset, owner));\n', '    }\n', '\n', '    /**\n', '     * @notice Get details of one token\n', '     * @param asset token address\n', '     * @param owner owner address\n', '     */\n', '    function getTokenDetails(address asset, address owner)\n', '        public\n', '        view\n', '        returns (TokenDetails memory r)\n', '    {\n', '        try IUniswapV2PairFull(asset).token0() returns(address token0) {\n', '            r.lpUnderlyings[0] = token0;\n', '            r.lpUnderlyings[1] = IUniswapV2PairFull(asset).token1();\n', '        } catch (bytes memory) { }\n', '\n', '        if (owner == address(0)) return r;\n', '        r.balance = IToken(asset).balanceOf(owner);\n', '    }\n', '\n', '    /**\n', '     * @notice Get parameters of many collaterals\n', '     * @param assets asset addresses\n', '     * @param owner owner address\n', '     */\n', '    function getMultiCollateralParameters(address[] calldata assets, address owner)\n', '        external\n', '        view\n', '        returns (CollateralParameters[] memory r)\n', '    {\n', '        uint length = assets.length;\n', '        r = new CollateralParameters[](length);\n', '        for (uint i = 0; i < length; ++i) {\n', '            r[i] = getCollateralParameters(assets[i], owner);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @notice Get details of many token\n', '     * @param assets token addresses\n', '     * @param owner owner address\n', '     */\n', '    function getMultiTokenDetails(address[] calldata assets, address owner)\n', '        external\n', '        view\n', '        returns (TokenDetails[] memory r)\n', '    {\n', '        uint length = assets.length;\n', '        r = new TokenDetails[](length);\n', '        for (uint i = 0; i < length; ++i) {\n', '            r[i] = getTokenDetails(assets[i], owner);\n', '        }\n', '    }\n', '}']