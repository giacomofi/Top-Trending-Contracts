['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-07\n', '*/\n', '\n', '// File: localhost/contracts/helpers/SafeMath.sol\n', '\n', '// SPDX-License-Identifier: bsl-1.1\n', '\n', '/*\n', '  Copyright 2020 Unit Protocol: Artem Zakharov ([email\xa0protected]).\n', '*/\n', 'pragma solidity 0.7.6;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0, "SafeMath: division by zero");\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '// File: localhost/contracts/helpers/ReentrancyGuard.sol\n', '\n', 'pragma solidity 0.7.6;\n', '\n', '/**\n', ' * @dev Contract module that helps prevent reentrant calls to a function.\n', ' *\n', ' * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier\n', ' * available, which can be applied to functions to make sure there are no nested\n', ' * (reentrant) calls to them.\n', ' *\n', ' * Note that because there is a single `nonReentrant` guard, functions marked as\n', ' * `nonReentrant` may not call one another. This can be worked around by making\n', ' * those functions `private`, and then adding `external` `nonReentrant` entry\n', ' * points to them.\n', ' *\n', ' * TIP: If you would like to learn more about reentrancy and alternative ways\n', ' * to protect against it, check out our blog post\n', ' * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].\n', ' */\n', 'contract ReentrancyGuard {\n', '    // Booleans are more expensive than uint256 or any type that takes up a full\n', '    // word because each write operation emits an extra SLOAD to first read the\n', "    // slot's contents, replace the bits taken up by the boolean, and then write\n", "    // back. This is the compiler's defense against contract upgrades and\n", '    // pointer aliasing, and it cannot be disabled.\n', '\n', '    // The values being non-zero value makes deployment a bit more expensive,\n', '    // but in exchange the refund on every call to nonReentrant will be lower in\n', '    // amount. Since refunds are capped to a percentage of the total\n', "    // transaction's gas, it is best to keep them low in cases like this one, to\n", '    // increase the likelihood of the full refund coming into effect.\n', '    uint256 private constant _NOT_ENTERED = 1;\n', '    uint256 private constant _ENTERED = 2;\n', '\n', '    uint256 private _status;\n', '\n', '    constructor () {\n', '        _status = _NOT_ENTERED;\n', '    }\n', '\n', '    /**\n', '     * @dev Prevents a contract from calling itself, directly or indirectly.\n', '     * Calling a `nonReentrant` function from another `nonReentrant`\n', '     * function is not supported. It is possible to prevent this from happening\n', '     * by making the `nonReentrant` function external, and make it call a\n', '     * `private` function that does the actual work.\n', '     */\n', '    modifier nonReentrant() {\n', '        // On the first call to nonReentrant, _notEntered will be true\n', '        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");\n', '\n', '        // Any calls to nonReentrant after this point will fail\n', '        _status = _ENTERED;\n', '\n', '        _;\n', '\n', '        // By storing the original value once again, a refund is triggered (see\n', '        // https://eips.ethereum.org/EIPS/eip-2200)\n', '        _status = _NOT_ENTERED;\n', '    }\n', '}\n', '\n', '// File: localhost/contracts/interfaces/IToken.sol\n', '\n', 'interface IToken {\n', '    function decimals() external view returns (uint8);\n', '}\n', '// File: localhost/contracts/interfaces/IVaultParameters.sol\n', '\n', 'interface IVaultParameters {\n', '    function canModifyVault ( address ) external view returns ( bool );\n', '    function foundation (  ) external view returns ( address );\n', '    function isManager ( address ) external view returns ( bool );\n', '    function isOracleTypeEnabled ( uint256, address ) external view returns ( bool );\n', '    function liquidationFee ( address ) external view returns ( uint256 );\n', '    function setCollateral ( address asset, uint256 stabilityFeeValue, uint256 liquidationFeeValue, uint256 usdpLimit, uint256[] calldata oracles ) external;\n', '    function setFoundation ( address newFoundation ) external;\n', '    function setLiquidationFee ( address asset, uint256 newValue ) external;\n', '    function setManager ( address who, bool permit ) external;\n', '    function setOracleType ( uint256 _type, address asset, bool enabled ) external;\n', '    function setStabilityFee ( address asset, uint256 newValue ) external;\n', '    function setTokenDebtLimit ( address asset, uint256 limit ) external;\n', '    function setVaultAccess ( address who, bool permit ) external;\n', '    function stabilityFee ( address ) external view returns ( uint256 );\n', '    function tokenDebtLimit ( address ) external view returns ( uint256 );\n', '    function vault (  ) external view returns ( address );\n', '    function vaultParameters (  ) external view returns ( address );\n', '}\n', '\n', '// File: localhost/contracts/interfaces/IVaultManagerParameters.sol\n', '\n', 'interface IVaultManagerParameters {\n', '    function devaluationPeriod ( address ) external view returns ( uint256 );\n', '    function initialCollateralRatio ( address ) external view returns ( uint256 );\n', '    function liquidationDiscount ( address ) external view returns ( uint256 );\n', '    function liquidationRatio ( address ) external view returns ( uint256 );\n', '    function maxColPercent ( address ) external view returns ( uint256 );\n', '    function minColPercent ( address ) external view returns ( uint256 );\n', '    function setColPartRange ( address asset, uint256 min, uint256 max ) external;\n', '    function setCollateral (\n', '        address asset,\n', '        uint256 stabilityFeeValue,\n', '        uint256 liquidationFeeValue,\n', '        uint256 initialCollateralRatioValue,\n', '        uint256 liquidationRatioValue,\n', '        uint256 liquidationDiscountValue,\n', '        uint256 devaluationPeriodValue,\n', '        uint256 usdpLimit,\n', '        uint256[] calldata oracles,\n', '        uint256 minColP,\n', '        uint256 maxColP\n', '    ) external;\n', '    function setDevaluationPeriod ( address asset, uint256 newValue ) external;\n', '    function setInitialCollateralRatio ( address asset, uint256 newValue ) external;\n', '    function setLiquidationDiscount ( address asset, uint256 newValue ) external;\n', '    function setLiquidationRatio ( address asset, uint256 newValue ) external;\n', '    function vaultParameters (  ) external view returns ( address );\n', '}\n', '\n', '// File: localhost/contracts/interfaces/ICDPRegistry.sol\n', '\n', 'pragma experimental ABIEncoderV2;\n', '\n', '\n', 'interface ICDPRegistry {\n', '    \n', '    struct CDP {\n', '        address asset;\n', '        address owner;\n', '    }\n', '    \n', '    function batchCheckpoint ( address[] calldata assets, address[] calldata owners ) external;\n', '    function batchCheckpointForAsset ( address asset, address[] calldata owners ) external;\n', '    function checkpoint ( address asset, address owner ) external;\n', '    function cr (  ) external view returns ( address );\n', '    function getAllCdps (  ) external view returns ( CDP[] memory r );\n', '    function getCdpsByCollateral ( address asset ) external view returns ( CDP[] memory cdps );\n', '    function getCdpsByOwner ( address owner ) external view returns ( CDP[] memory r );\n', '    function getCdpsCount (  ) external view returns ( uint256 totalCdpCount );\n', '    function getCdpsCountForCollateral ( address asset ) external view returns ( uint256 );\n', '    function isAlive ( address asset, address owner ) external view returns ( bool );\n', '    function isListed ( address asset, address owner ) external view returns ( bool );\n', '    function vault (  ) external view returns ( address );\n', '}\n', '\n', '// File: localhost/contracts/interfaces/IVault.sol\n', '\n', 'interface IVault {\n', '    function DENOMINATOR_1E2 (  ) external view returns ( uint256 );\n', '    function DENOMINATOR_1E5 (  ) external view returns ( uint256 );\n', '    function borrow ( address asset, address user, uint256 amount ) external returns ( uint256 );\n', '    function calculateFee ( address asset, address user, uint256 amount ) external view returns ( uint256 );\n', '    function changeOracleType ( address asset, address user, uint256 newOracleType ) external;\n', '    function chargeFee ( address asset, address user, uint256 amount ) external;\n', '    function col (  ) external view returns ( address );\n', '    function colToken ( address, address ) external view returns ( uint256 );\n', '    function collaterals ( address, address ) external view returns ( uint256 );\n', '    function debts ( address, address ) external view returns ( uint256 );\n', '    function depositCol ( address asset, address user, uint256 amount ) external;\n', '    function depositEth ( address user ) external payable;\n', '    function depositMain ( address asset, address user, uint256 amount ) external;\n', '    function destroy ( address asset, address user ) external;\n', '    function getTotalDebt ( address asset, address user ) external view returns ( uint256 );\n', '    function lastUpdate ( address, address ) external view returns ( uint256 );\n', '    function liquidate ( address asset, address positionOwner, uint256 mainAssetToLiquidator, uint256 colToLiquidator, uint256 mainAssetToPositionOwner, uint256 colToPositionOwner, uint256 repayment, uint256 penalty, address liquidator ) external;\n', '    function liquidationBlock ( address, address ) external view returns ( uint256 );\n', '    function liquidationFee ( address, address ) external view returns ( uint256 );\n', '    function liquidationPrice ( address, address ) external view returns ( uint256 );\n', '    function oracleType ( address, address ) external view returns ( uint256 );\n', '    function repay ( address asset, address user, uint256 amount ) external returns ( uint256 );\n', '    function spawn ( address asset, address user, uint256 _oracleType ) external;\n', '    function stabilityFee ( address, address ) external view returns ( uint256 );\n', '    function tokenDebts ( address ) external view returns ( uint256 );\n', '    function triggerLiquidation ( address asset, address positionOwner, uint256 initialPrice ) external;\n', '    function update ( address asset, address user ) external;\n', '    function usdp (  ) external view returns ( address );\n', '    function vaultParameters (  ) external view returns ( address );\n', '    function weth (  ) external view returns ( address payable );\n', '    function withdrawCol ( address asset, address user, uint256 amount ) external;\n', '    function withdrawEth ( address user, uint256 amount ) external;\n', '    function withdrawMain ( address asset, address user, uint256 amount ) external;\n', '}\n', '\n', '// File: localhost/contracts/interfaces/IWETH.sol\n', '\n', 'interface IWETH {\n', '    function deposit() external payable;\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function transferFrom(address from, address to, uint value) external returns (bool);\n', '    function withdraw(uint) external;\n', '}\n', '// File: localhost/contracts/interfaces/IOracleUsd.sol\n', '\n', 'interface IOracleUsd {\n', '\n', '    // returns Q112-encoded value\n', '    // returned value 10**18 * 2**112 is $1\n', '    function assetToUsd(address asset, uint amount) external view returns (uint);\n', '}\n', '\n', '// File: localhost/contracts/interfaces/IOracleRegistry.sol\n', '\n', '\n', 'interface IOracleRegistry {\n', '\n', '    struct Oracle {\n', '        uint oracleType;\n', '        address oracleAddress;\n', '    }\n', '\n', '    function WETH (  ) external view returns ( address );\n', '    function getKeydonixOracleTypes (  ) external view returns ( uint256[] memory );\n', '    function getOracles (  ) external view returns ( Oracle[] memory foundOracles );\n', '    function keydonixOracleTypes ( uint256 ) external view returns ( uint256 );\n', '    function maxOracleType (  ) external view returns ( uint256 );\n', '    function oracleByAsset ( address asset ) external view returns ( address );\n', '    function oracleByType ( uint256 ) external view returns ( address );\n', '    function oracleTypeByAsset ( address ) external view returns ( uint256 );\n', '    function oracleTypeByOracle ( address ) external view returns ( uint256 );\n', '    function setKeydonixOracleTypes ( uint256[] memory _keydonixOracleTypes ) external;\n', '    function setOracle ( uint256 oracleType, address oracle ) external;\n', '    function setOracleTypeForAsset ( address asset, uint256 oracleType ) external;\n', '    function setOracleTypeForAssets ( address[] memory assets, uint256 oracleType ) external;\n', '    function unsetOracle ( uint256 oracleType ) external;\n', '    function unsetOracleForAsset ( address asset ) external;\n', '    function unsetOracleForAssets ( address[] memory assets ) external;\n', '    function vaultParameters (  ) external view returns ( address );\n', '}\n', '\n', '// File: localhost/contracts/vault-managers/CDPManager01.sol\n', '\n', '/*\n', '  Copyright 2020 Unit Protocol: Artem Zakharov ([email\xa0protected]).\n', '*/\n', 'pragma solidity 0.7.6;\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title CDPManager01\n', ' **/\n', 'contract CDPManager01 is ReentrancyGuard {\n', '    using SafeMath for uint;\n', '\n', '    IVault public immutable vault;\n', '    IVaultManagerParameters public immutable vaultManagerParameters;\n', '    IOracleRegistry public immutable oracleRegistry;\n', '    ICDPRegistry public immutable cdpRegistry;\n', '    address payable public immutable WETH;\n', '\n', '    uint public constant Q112 = 2 ** 112;\n', '    uint public constant DENOMINATOR_1E5 = 1e5;\n', '\n', '    /**\n', '     * @dev Trigger when joins are happened\n', '    **/\n', '    event Join(address indexed asset, address indexed owner, uint main, uint usdp);\n', '\n', '    /**\n', '     * @dev Trigger when exits are happened\n', '    **/\n', '    event Exit(address indexed asset, address indexed owner, uint main, uint usdp);\n', '\n', '    /**\n', '     * @dev Trigger when liquidations are initiated\n', '    **/\n', '    event LiquidationTriggered(address indexed asset, address indexed owner);\n', '\n', '    modifier checkpoint(address asset, address owner) {\n', '        _;\n', '        cdpRegistry.checkpoint(asset, owner);\n', '    }\n', '\n', '    /**\n', '     * @param _vaultManagerParameters The address of the contract with Vault manager parameters\n', '     * @param _oracleRegistry The address of the oracle registry\n', '     * @param _cdpRegistry The address of the CDP registry\n', '     **/\n', '    constructor(address _vaultManagerParameters, address _oracleRegistry, address _cdpRegistry) {\n', '        require(\n', '            _vaultManagerParameters != address(0) && \n', '            _oracleRegistry != address(0) && \n', '            _cdpRegistry != address(0),\n', '                "Unit Protocol: INVALID_ARGS"\n', '        );\n', '        vaultManagerParameters = IVaultManagerParameters(_vaultManagerParameters);\n', '        vault = IVault(IVaultParameters(IVaultManagerParameters(_vaultManagerParameters).vaultParameters()).vault());\n', '        oracleRegistry = IOracleRegistry(_oracleRegistry);\n', '        WETH = IVault(IVaultParameters(IVaultManagerParameters(_vaultManagerParameters).vaultParameters()).vault()).weth();\n', '        cdpRegistry = ICDPRegistry(_cdpRegistry);\n', '    }\n', '\n', '    // only accept ETH via fallback from the WETH contract\n', '    receive() external payable {\n', '        require(msg.sender == WETH, "Unit Protocol: RESTRICTED");\n', '    }\n', '\n', '    /**\n', '      * @notice Depositing tokens must be pre-approved to Vault address\n', '      * @notice position actually considered as spawned only when debt > 0\n', '      * @dev Deposits collateral and/or borrows USDP\n', '      * @param asset The address of the collateral\n', '      * @param assetAmount The amount of the collateral to deposit\n', '      * @param usdpAmount The amount of USDP token to borrow\n', '      **/\n', '    function join(address asset, uint assetAmount, uint usdpAmount) public nonReentrant checkpoint(asset, msg.sender) {\n', '        require(usdpAmount != 0 || assetAmount != 0, "Unit Protocol: USELESS_TX");\n', '\n', '        require(IToken(asset).decimals() <= 18, "Unit Protocol: NOT_SUPPORTED_DECIMALS");\n', '\n', '        if (usdpAmount == 0) {\n', '\n', '            vault.depositMain(asset, msg.sender, assetAmount);\n', '\n', '        } else {\n', '\n', '            _ensureOracle(asset);\n', '\n', '            bool spawned = vault.debts(asset, msg.sender) != 0;\n', '\n', '            if (!spawned) {\n', '                // spawn a position\n', '                vault.spawn(asset, msg.sender, oracleRegistry.oracleTypeByAsset(asset));\n', '            }\n', '\n', '            if (assetAmount != 0) {\n', '                vault.depositMain(asset, msg.sender, assetAmount);\n', '            }\n', '\n', '            // mint USDP to owner\n', '            vault.borrow(asset, msg.sender, usdpAmount);\n', '\n', '            // check collateralization\n', '            _ensurePositionCollateralization(asset, msg.sender);\n', '\n', '        }\n', '\n', '        // fire an event\n', '        emit Join(asset, msg.sender, assetAmount, usdpAmount);\n', '    }\n', '\n', '    /**\n', '      * @dev Deposits ETH and/or borrows USDP\n', '      * @param usdpAmount The amount of USDP token to borrow\n', '      **/\n', '    function join_Eth(uint usdpAmount) external payable {\n', '\n', '        if (msg.value != 0) {\n', '            IWETH(WETH).deposit{value: msg.value}();\n', '            require(IWETH(WETH).transfer(msg.sender, msg.value), "Unit Protocol: WETH_TRANSFER_FAILED");\n', '        }\n', '\n', '        join(WETH, msg.value, usdpAmount);\n', '    }\n', '\n', '    /**\n', '      * @notice Tx sender must have a sufficient USDP balance to pay the debt\n', '      * @dev Withdraws collateral and repays specified amount of debt\n', '      * @param asset The address of the collateral\n', '      * @param assetAmount The amount of the collateral to withdraw\n', '      * @param usdpAmount The amount of USDP to repay\n', '      **/\n', '    function exit(address asset, uint assetAmount, uint usdpAmount) public nonReentrant checkpoint(asset, msg.sender) returns (uint) {\n', '\n', '        // check usefulness of tx\n', '        require(assetAmount != 0 || usdpAmount != 0, "Unit Protocol: USELESS_TX");\n', '\n', '        uint debt = vault.debts(asset, msg.sender);\n', '\n', '        // catch full repayment\n', '        if (usdpAmount > debt) { usdpAmount = debt; }\n', '\n', '        if (assetAmount == 0) {\n', '            _repay(asset, msg.sender, usdpAmount);\n', '        } else {\n', '            if (debt == usdpAmount) {\n', '                vault.withdrawMain(asset, msg.sender, assetAmount);\n', '                if (usdpAmount != 0) {\n', '                    _repay(asset, msg.sender, usdpAmount);\n', '                }\n', '            } else {\n', '                _ensureOracle(asset);\n', '\n', '                // withdraw collateral to the owner address\n', '                vault.withdrawMain(asset, msg.sender, assetAmount);\n', '\n', '                if (usdpAmount != 0) {\n', '                    _repay(asset, msg.sender, usdpAmount);\n', '                }\n', '\n', '                vault.update(asset, msg.sender);\n', '\n', '                _ensurePositionCollateralization(asset, msg.sender);\n', '            }\n', '        }\n', '\n', '        // fire an event\n', '        emit Exit(asset, msg.sender, assetAmount, usdpAmount);\n', '\n', '        return usdpAmount;\n', '    }\n', '\n', '    /**\n', '      * @notice Repayment is the sum of the principal and interest\n', '      * @dev Withdraws collateral and repays specified amount of debt\n', '      * @param asset The address of the collateral\n', '      * @param assetAmount The amount of the collateral to withdraw\n', '      * @param repayment The target repayment amount\n', '      **/\n', '    function exit_targetRepayment(address asset, uint assetAmount, uint repayment) external returns (uint) {\n', '\n', '        uint usdpAmount = _calcPrincipal(asset, msg.sender, repayment);\n', '\n', '        return exit(asset, assetAmount, usdpAmount);\n', '    }\n', '\n', '    /**\n', '      * @notice Withdraws WETH and converts to ETH\n', '      * @param ethAmount ETH amount to withdraw\n', '      * @param usdpAmount The amount of USDP token to repay\n', '      **/\n', '    function exit_Eth(uint ethAmount, uint usdpAmount) public returns (uint) {\n', '        usdpAmount = exit(WETH, ethAmount, usdpAmount);\n', '        require(IWETH(WETH).transferFrom(msg.sender, address(this), ethAmount), "Unit Protocol: WETH_TRANSFER_FROM_FAILED");\n', '        IWETH(WETH).withdraw(ethAmount);\n', '        (bool success, ) = msg.sender.call{value:ethAmount}("");\n', '        require(success, "Unit Protocol: ETH_TRANSFER_FAILED");\n', '        return usdpAmount;\n', '    }\n', '\n', '    /**\n', '      * @notice Repayment is the sum of the principal and interest\n', '      * @notice Withdraws WETH and converts to ETH\n', '      * @param ethAmount ETH amount to withdraw\n', '      * @param repayment The target repayment amount\n', '      **/\n', '    function exit_Eth_targetRepayment(uint ethAmount, uint repayment) external returns (uint) {\n', '        uint usdpAmount = _calcPrincipal(WETH, msg.sender, repayment);\n', '        return exit_Eth(ethAmount, usdpAmount);\n', '    }\n', '\n', '    // decreases debt\n', '    function _repay(address asset, address owner, uint usdpAmount) internal {\n', '        uint fee = vault.calculateFee(asset, owner, usdpAmount);\n', '        vault.chargeFee(vault.usdp(), owner, fee);\n', '\n', "        // burn USDP from the owner's balance\n", '        uint debtAfter = vault.repay(asset, owner, usdpAmount);\n', '        if (debtAfter == 0) {\n', '            // clear unused storage\n', '            vault.destroy(asset, owner);\n', '        }\n', '    }\n', '\n', '    function _ensurePositionCollateralization(address asset, address owner) internal view {\n', '        // collateral value of the position in USD\n', '        uint usdValue_q112 = getCollateralUsdValue_q112(asset, owner);\n', '\n', '        // USD limit of the position\n', '        uint usdLimit = usdValue_q112 * vaultManagerParameters.initialCollateralRatio(asset) / Q112 / 100;\n', '\n', '        // revert if collateralization is not enough\n', '        require(vault.getTotalDebt(asset, owner) <= usdLimit, "Unit Protocol: UNDERCOLLATERALIZED");\n', '    }\n', '    \n', '    // Liquidation Trigger\n', '\n', '    /**\n', '     * @dev Triggers liquidation of a position\n', '     * @param asset The address of the collateral token of a position\n', '     * @param owner The owner of the position\n', '     **/\n', '    function triggerLiquidation(address asset, address owner) external nonReentrant {\n', '\n', '        _ensureOracle(asset);\n', '\n', '        // USD value of the collateral\n', '        uint usdValue_q112 = getCollateralUsdValue_q112(asset, owner);\n', '        \n', '        // reverts if a position is not liquidatable\n', '        require(_isLiquidatablePosition(asset, owner, usdValue_q112), "Unit Protocol: SAFE_POSITION");\n', '\n', '        uint liquidationDiscount_q112 = usdValue_q112.mul(\n', '            vaultManagerParameters.liquidationDiscount(asset)\n', '        ).div(DENOMINATOR_1E5);\n', '\n', '        uint initialLiquidationPrice = usdValue_q112.sub(liquidationDiscount_q112).div(Q112);\n', '\n', '        // sends liquidation command to the Vault\n', '        vault.triggerLiquidation(asset, owner, initialLiquidationPrice);\n', '\n', '        // fire an liquidation event\n', '        emit LiquidationTriggered(asset, owner);\n', '    }\n', '\n', '    function getCollateralUsdValue_q112(address asset, address owner) public view returns (uint) {\n', '        return IOracleUsd(oracleRegistry.oracleByAsset(asset)).assetToUsd(asset, vault.collaterals(asset, owner));\n', '    }\n', '\n', '    /**\n', '     * @dev Determines whether a position is liquidatable\n', '     * @param asset The address of the collateral\n', '     * @param owner The owner of the position\n', '     * @param usdValue_q112 Q112-encoded USD value of the collateral\n', '     * @return boolean value, whether a position is liquidatable\n', '     **/\n', '    function _isLiquidatablePosition(\n', '        address asset,\n', '        address owner,\n', '        uint usdValue_q112\n', '    ) internal view returns (bool) {\n', '        uint debt = vault.getTotalDebt(asset, owner);\n', '\n', '        // position is collateralized if there is no debt\n', '        if (debt == 0) return false;\n', '\n', '        return debt.mul(100).mul(Q112).div(usdValue_q112) >= vaultManagerParameters.liquidationRatio(asset);\n', '    }\n', '\n', '    function _ensureOracle(address asset) internal view {\n', '        uint oracleType = oracleRegistry.oracleTypeByAsset(asset);\n', '        require(oracleType != 0, "Unit Protocol: INVALID_ORACLE_TYPE");\n', '        address oracle = oracleRegistry.oracleByType(oracleType);\n', '        require(oracle != address(0), "Unit Protocol: DISABLED_ORACLE");\n', '    }\n', '\n', '    /**\n', '     * @dev Determines whether a position is liquidatable\n', '     * @param asset The address of the collateral\n', '     * @param owner The owner of the position\n', '     * @return boolean value, whether a position is liquidatable\n', '     **/\n', '    function isLiquidatablePosition(\n', '        address asset,\n', '        address owner\n', '    ) public view returns (bool) {\n', '        uint usdValue_q112 = getCollateralUsdValue_q112(asset, owner);\n', '\n', '        return _isLiquidatablePosition(asset, owner, usdValue_q112);\n', '    }\n', '\n', '    /**\n', '     * @dev Calculates current utilization ratio\n', '     * @param asset The address of the collateral\n', '     * @param owner The owner of the position\n', '     * @return utilization ratio\n', '     **/\n', '    function utilizationRatio(\n', '        address asset,\n', '        address owner\n', '    ) public view returns (uint) {\n', '        uint debt = vault.getTotalDebt(asset, owner);\n', '        if (debt == 0) return 0;\n', '        \n', '        uint usdValue_q112 = getCollateralUsdValue_q112(asset, owner);\n', '\n', '        return debt.mul(100).mul(Q112).div(usdValue_q112);\n', '    }\n', '    \n', '\n', '    /**\n', '     * @dev Calculates liquidation price\n', '     * @param asset The address of the collateral\n', '     * @param owner The owner of the position\n', '     * @return Q112-encoded liquidation price\n', '     **/\n', '    function liquidationPrice_q112(\n', '        address asset,\n', '        address owner\n', '    ) external view returns (uint) {\n', '\n', '        uint debt = vault.getTotalDebt(asset, owner);\n', '        if (debt == 0) return uint(-1);\n', '        \n', '        uint collateralLiqPrice = debt.mul(100).mul(Q112).div(vaultManagerParameters.liquidationRatio(asset));\n', '\n', '        require(IToken(asset).decimals() <= 18, "Unit Protocol: NOT_SUPPORTED_DECIMALS");\n', '\n', '        return collateralLiqPrice / vault.collaterals(asset, owner) / 10 ** (18 - IToken(asset).decimals());\n', '    }\n', '\n', '    function _calcPrincipal(address asset, address owner, uint repayment) internal view returns (uint) {\n', '        uint fee = vault.stabilityFee(asset, owner) * (block.timestamp - vault.lastUpdate(asset, owner)) / 365 days;\n', '        return repayment * DENOMINATOR_1E5 / (DENOMINATOR_1E5 + fee);\n', '    }\n', '}']