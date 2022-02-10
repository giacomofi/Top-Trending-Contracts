['"""\n', '@title Greenwood AaveV2Calculator\n', '@notice AaveV2 calculations for the Greenwood Protocol\n', '@author Greenwood Labs\n', '"""\n', '\n', '# define the interfaces used by the contract\n', 'from vyper.interfaces import ERC20\n', '\n', 'interface AAVE_V2_PRICE_FEED:\n', '    def getAssetPrice(_asset: address) -> uint256: view\n', '\n', 'interface REGISTRY:\n', '    def getAddress(_contract: String[20], _version: String[11]) -> address: nonpayable\n', '    def governance() -> address: nonpayable\n', '\n', '# define the constants used by the contract\n', 'TEN_EXP_18: constant(uint256) = 1000000000000000000\n', '\n', '# define the events emitted by the contract\n', 'event SetFee:\n', '    previousFee: uint256\n', '    newFee: uint256\n', '    governance: address\n', '    blockNumber: uint256\n', '\n', 'event SetRegistry:\n', '    previousRegistry: address\n', '    newRegistry: address\n', '    governance: address\n', '    blockNumber: uint256\n', '\n', '# define the structs used by the contract\n', 'struct AaveV2BorrowCalculation:\n', '    requiredCollateral: uint256\n', '    borrowIndex: uint256\n', '    borrowAmount: uint256\n', '    originationFee: uint256\n', '\n', 'struct AaveV2RepayCalculation:\n', '    repayAmount: uint256\n', '    redemptionAmount: int128\n', '    requiredCollateral: uint256\n', '    outstanding: int128\n', '    borrowIndex: uint256\n', '\n', 'struct AaveV2WithdrawCalculation:\n', '    requiredCollateral: uint256\n', '    outstanding: uint256\n', '\n', 'struct AssetContext:\n', '    aToken: address\n', '    aaveV2PriceFeed: address\n', '    aaveV2LendingPool: address\n', '    cToken: address\n', '    compoundPriceFeed: address\n', '    comptroller: address\n', '    decimals: uint256\n', '    underlying: address\n', '\n', 'struct Loan:\n', '    collateralAsset: address\n', '    borrowAsset: address\n', '    outstanding: uint256\n', '    collateralizationRatio: uint256\n', '    collateralLocked: uint256\n', '    borrower: address\n', '    lastBorrowIndex: uint256\n', '    repaymentTime: uint256\n', '\n', '# define the storage variables used by the contract\n', 'protocolFee: public(uint256)\n', 'registry: public(address)\n', '\n', '@external\n', 'def __init__(_protocol_fee: uint256, _registry: address):\n', '    """\n', '    @notice Contract constructor\n', '    @param _protocol_fee The origination fee for the Greenwood Protocol scaled by 1e18\n', '    @param _registry The address of the Greenwood Registry\n', '    """\n', '\n', '    # set the protocol fee\n', '    self.protocolFee = _protocol_fee\n', '\n', '    # set the address of the Greenwood Registry\n', '    self.registry = _registry\n', '\n', '@internal\n', 'def isAuthorized(_caller: address, _role: String[20], _version: String[11]) -> bool:\n', '    """\n', '    @notice Method for role-based security\n', '    @param _caller The address that called the permissioned method\n', '    @param _role The requested authorization level\n', '    @param _version The version of Greenwood to use\n', '    @return True if the caller is authorized, False otherwise\n', '    """\n', '\n', '    # check if the requested role is "escrow"\n', '    if keccak256(_role) == keccak256("escrow"):\n', '\n', '        # get the address of the Escrow from the Registry\n', '        controller: address = REGISTRY(self.registry).getAddress("aaveV2Escrow", _version)\n', '\n', '        # return the equality comparison\n', '        return controller == _caller\n', '    \n', '    # check if the requested role is "governance"\n', '    elif keccak256(_role) == keccak256("governance"):\n', '\n', '        # get the address of the Governance from the Registry\n', '        governance: address = REGISTRY(self.registry).governance()\n', '\n', '        # return the equality comparison\n', '        return governance == _caller\n', '\n', '    # catch extraneous role arguments\n', '    else:\n', '\n', '        # revert\n', '        raise "Unhandled role argument"\n', '\n', '@external\n', 'def calculateBorrow(_borrow_context: AssetContext, _collateral_context: AssetContext, _amount: uint256, _collateralization_ratio: uint256, _version: String[11]) -> AaveV2BorrowCalculation:\n', '    """\n', '    @notice Calculate and return values needed to open a loan on Aave V2\n', '    @param _borrow_context The AssetContext struct of the asset being borrowed\n', '    @param _collateral_context The AssetContext struct of the asset being used as collateral\n', "    @param _amount The amount of asset being borrowed scaled by the asset's decimals\n", '    @param _collateralization_ratio The collateralization ratio for the loan\n', '    @param _version The version of the Greenwood Protocol to use\n', '    @return AaveV2BorrowCalculation struct\n', '    @dev Only the AaveV2Escrow or the Governance can call this method\n', '    """\n', '\n', '    # require that the method caller is the Escrow or the Governance\n', '    assert self.isAuthorized(msg.sender, "escrow", _version) == True or self.isAuthorized(msg.sender, "governance", _version) == True, "Only Escrow or Governance can call this method"\n', '\n', '    # get the LTV ratio of the collateral asset\n', '    collateralReserveData: Bytes[768] = raw_call(\n', '        _collateral_context.aaveV2LendingPool,\n', '        concat(\n', '            method_id("getReserveData(address)"),\n', '            convert(_collateral_context.underlying, bytes32)\n', '        ),\n', '        max_outsize=768\n', '    )\n', '\n', '    # parse the LTV from collateralReserveData and convert it to a percentage\n', '    collateralAssetLTV: decimal = convert(convert(slice(collateralReserveData, 30, 2), uint256), decimal) / 10000.0\n', '\n', '    # get the current borrowIndex of the borrow asset\n', '    borrowReserveData: Bytes[768] = raw_call(\n', '        _borrow_context.aaveV2LendingPool,\n', '        concat(\n', '            method_id("getReserveData(address)"),\n', '            convert(_borrow_context.underlying, bytes32)\n', '        ),\n', '        max_outsize=768\n', '    )\n', '\n', '    # parse the variableBorrowIndex from borrowReserveData\n', '    borrowIndex: uint256 = convert(slice(borrowReserveData, 64, 32), uint256)\n', '\n', '    # get the price of the borrow asset and the collateral asset denominated in ETH\n', '    borrowAssetPriceScaled: uint256 = AAVE_V2_PRICE_FEED(_borrow_context.aaveV2PriceFeed).getAssetPrice(_borrow_context.underlying)\n', '    collateralAssetPriceScaled: uint256 = AAVE_V2_PRICE_FEED(_collateral_context.aaveV2PriceFeed).getAssetPrice(_collateral_context.underlying)\n', '\n', '    # scale down the asset prices and convert them to decimals\n', '    borrowAssetPrice: decimal = convert(borrowAssetPriceScaled, decimal) / convert(TEN_EXP_18, decimal)\n', '    collateralAssetPrice: decimal = convert(collateralAssetPriceScaled, decimal) / convert(TEN_EXP_18, decimal)\n', '\n', '    # convert the borrow amount to a decimal and scale it down\n', '    borrowAmount: decimal = convert(_amount, decimal) / convert(10 ** _borrow_context.decimals, decimal)\n', '\n', '    # calculate the protocol fee\n', '    originationFee: decimal = (borrowAmount * (convert(self.protocolFee, decimal) / convert(TEN_EXP_18, decimal))) / (collateralAssetPrice / borrowAssetPrice)\n', '\n', '    # calculate the value of the borrow request denominated in ETH\n', '    borrowAmountInETH: decimal = borrowAmount * borrowAssetPrice\n', '\n', '    # calculate the required collateral denominated in ETH\n', '    requiredCollateralInETH: decimal = borrowAmountInETH / collateralAssetLTV\n', '    \n', '    # calculate the required collateral denominated in the collateral asset \n', '    requiredCollateral: decimal = requiredCollateralInETH / collateralAssetPrice\n', '\n', '    # calculate the required collateral for Greenwood plus fees denominated in the collateral asset \n', '    requiredCollateralGreenwood: decimal = requiredCollateral * (convert(_collateralization_ratio, decimal) / 100.0)\n', '\n', '    # scale the required collateral for Greenwood by the decimals of the collateral asset\n', '    requiredCollateralScaled: uint256 = convert(requiredCollateralGreenwood * convert(10 ** _collateral_context.decimals, decimal), uint256)\n', '\n', '    # return the calculations\n', '    return AaveV2BorrowCalculation({\n', '        requiredCollateral: requiredCollateralScaled,\n', '        borrowIndex: borrowIndex,\n', '        borrowAmount: convert(borrowAmount * convert(10 ** _borrow_context.decimals, decimal), uint256),    # scale the borrow amount back up and convert it to a uint256\n', '        originationFee: convert(originationFee * convert(10 ** _collateral_context.decimals, decimal), uint256) # scale the protocol fee back up and convert it to a uint256\n', '    })\n', '\n', '@external\n', 'def calculateWithdraw(_borrow_context: AssetContext, _collateral_context: AssetContext, _escrow: address, _loan: Loan, _version: String[11]) -> AaveV2WithdrawCalculation:\n', '    """\n', '    @notice Calculate and return values needed to withdraw collateral from Aave V2\n', '    @param _borrow_context The AssetContext struct of the asset being borrowed\n', '    @param _collateral_context The AssetContext struct of the asset being used as collateral\n', '    @param _escrow The address of the Greenwood Escrow use\n', '    @param _loan A Loan struct containing loan data\n', '    @param _version The version of the Greenwood Protocol to use\n', '    @return AaveV2WithdrawCalculation struct\n', '    @dev Only the AaveV2Escrow or the Governance can call this method\n', '    """\n', '\n', '    # require that the method caller is the Escrow or the Governance\n', '    assert self.isAuthorized(msg.sender, "escrow", _version) == True or self.isAuthorized(msg.sender, "governance", _version) == True, "Only Escrow or Governance can call this method"\n', '\n', '    # get the LTV ratio of the collateral asset\n', '    collateralReserveData: Bytes[768] = raw_call(\n', '        _collateral_context.aaveV2LendingPool,\n', '        concat(\n', '            method_id("getReserveData(address)"),\n', '            convert(_collateral_context.underlying, bytes32)\n', '        ),\n', '        max_outsize=768\n', '    )\n', '\n', '    # parse the LTV from collateralReserveData and convert it to a percentage\n', '    collateralAssetLTV: decimal = convert(convert(slice(collateralReserveData, 30, 2), uint256), decimal) / 10000.0\n', '\n', '    # get the current borrowIndex of the borrow asset\n', '    borrowReserveData: Bytes[768] = raw_call(\n', '        _borrow_context.aaveV2LendingPool,\n', '        concat(\n', '            method_id("getReserveData(address)"),\n', '            convert(_borrow_context.underlying, bytes32)\n', '        ),\n', '        max_outsize=768\n', '    )\n', '\n', '    # parse the variableBorrowIndex from borrowReserveData\n', '    borrowIndex: uint256 = convert(slice(borrowReserveData, 64, 32), uint256)\n', '\n', '    # parse the variableDebtTokenAddress from borrowReserveData\n', '    variableDebtTokenAddress: address = convert(convert(slice(borrowReserveData, 288, 32), bytes32), address)\n', '\n', '    # get variableDebtToken balance of the Escrow\n', '    escrowBorrowBalance: uint256 = ERC20(variableDebtTokenAddress).balanceOf(_escrow)\n', '\n', '    # get the variableDebtToken scaledBalanceOf of the Escrow\n', '    scaledBalanceOfResponse: Bytes[32] = raw_call(\n', '        variableDebtTokenAddress,\n', '        concat(\n', '            method_id("scaledBalanceOf(address)"),\n', '            convert(_escrow, bytes32)\n', '        ),\n', '        max_outsize=32\n', '    )\n', '\n', '    # convert the scaledBalanceOfResponse to a uint256\n', '    scaledBalanceOf: uint256 = convert(scaledBalanceOfResponse, uint256)\n', '\n', '    # calculate the borrow balance increase of the Escrow\n', '    balanceIncrease: decimal = ((convert(escrowBorrowBalance, decimal) - convert(scaledBalanceOf, decimal)) * (convert(_loan.lastBorrowIndex, decimal) / convert(10 ** 27, decimal))) / convert(10 ** 18, decimal)\n', '\n', '    # declare a memory variable to store the amount of interest accrued\n', '    interestAccrued: decimal = 0.0\n', '\n', '    # check that the escrow borrow balance is not equal to the balance increase to prevent division by 0\n', '    if convert(escrowBorrowBalance, decimal) != balanceIncrease:\n', '\n', '        # calculate the interest accrued since the last action on the loan\n', '        interestAccrued = balanceIncrease / (convert(escrowBorrowBalance, decimal) - balanceIncrease)\n', '\n', '    # apply interest accrued to the outstanding balance of the loan\n', '    borrowBalanceScaled: uint256 = convert(convert(_loan.outstanding, decimal) * (1.0 + interestAccrued), uint256)\n', '\n', '    # get the price of the borrow asset and the collateral asset denominated in ETH\n', '    borrowAssetPriceExp: uint256 = AAVE_V2_PRICE_FEED(_borrow_context.aaveV2PriceFeed).getAssetPrice(_borrow_context.underlying)\n', '    collateralAssetPriceExp: uint256 = AAVE_V2_PRICE_FEED(_collateral_context.aaveV2PriceFeed).getAssetPrice(_collateral_context.underlying)\n', '\n', '    # scale down the prices and convert them to decimals\n', '    borrowAssetPrice: decimal = convert(borrowAssetPriceExp, decimal) / convert(TEN_EXP_18, decimal)\n', '    collateralAssetPrice: decimal = convert(collateralAssetPriceExp, decimal) / convert(TEN_EXP_18, decimal)\n', '\n', '    # convert the borrow balance to a decimal and scale it down\n', '    borrowBalance: decimal = convert(borrowBalanceScaled, decimal) / convert(10 ** _borrow_context.decimals, decimal)\n', '\n', '    # calculate the value of the borrow balance denominated in ETH\n', '    borrowAmountInETH: decimal = borrowBalance * borrowAssetPrice\n', '\n', '    # calculate the required collateral denominated in ETH\n', '    requiredCollateralInETH: decimal = borrowAmountInETH / collateralAssetLTV\n', '\n', '    # calculate the required collateral denominated in the collateral asset \n', '    requiredCollateral: decimal = requiredCollateralInETH / collateralAssetPrice\n', '\n', '    # calculate the required collateral for Greenwood denominated in the collateral asset \n', '    requiredCollateralGreenwood: decimal = requiredCollateral * (convert(_loan.collateralizationRatio, decimal) / 100.0)\n', '\n', '    # scale the required collateral for Greenwood by the decimals of the collateral asset\n', '    requiredCollateralScaled: uint256 = convert(requiredCollateralGreenwood * convert(10 ** _collateral_context.decimals, decimal), uint256)\n', '\n', '    # return the calculation\n', '    return AaveV2WithdrawCalculation({\n', '        requiredCollateral: requiredCollateralScaled,\n', '        outstanding: borrowBalanceScaled\n', '    })\n', '\n', '@external\n', 'def calculateRepay(_borrow_context: AssetContext, _collateral_context: AssetContext, _amount: uint256, _escrow: address, _loan: Loan, _version: String[11]) -> AaveV2RepayCalculation:\n', '    """\n', '    @notice Calculate and return values needed to repay a loan on Aave V2\n', '    @param _borrow_context The AssetContext struct of the asset being borrowed\n', '    @param _collateral_context The AssetContext struct of the asset being used as collateral\n', "    @param _amount The amount of asset being repaid scaled by the asset's decimals\n", '    @param _escrow The address of the Greenwood Escrow use\n', '    @param _loan A Loan struct containing loan data\n', '    @param _version The version of the Greenwood Protocol to use\n', '    @return AaveV2RepayCalculation struct\n', '    @dev Passing 2 ** 256 - 1 as _amount triggers a full repayment\n', '    @dev Only the AaveV2Escrow or the Governance can call this method\n', '    """\n', '\n', '    # require that the method caller is the Escrow or the Governance\n', '    assert self.isAuthorized(msg.sender, "escrow", _version) == True or self.isAuthorized(msg.sender, "governance", _version) == True, "Only Escrow or Governance can call this method"\n', '    \n', '    # get the current borrowIndex of the borrow asset\n', '    borrowReserveData: Bytes[768] = raw_call(\n', '        _borrow_context.aaveV2LendingPool,\n', '        concat(\n', '            method_id("getReserveData(address)"),\n', '            convert(_borrow_context.underlying, bytes32)\n', '        ),\n', '        max_outsize=768\n', '    )\n', '\n', '    # parse the variableBorrowIndex from borrowReserveData\n', '    borrowIndex: uint256 = convert(slice(borrowReserveData, 64, 32), uint256)\n', '\n', '    # parse the variableDebtTokenAddress from borrowReserveData\n', '    variableDebtTokenAddress: address = convert(convert(slice(borrowReserveData, 288, 32), bytes32), address)\n', '\n', '    # get variableDebtToken balance of the Escrow\n', '    escrowBorrowBalance: uint256 = ERC20(variableDebtTokenAddress).balanceOf(_escrow)\n', '\n', '    # get the variableDebtToken scaledBalanceOf of the Escrow\n', '    scaledBalanceOfResponse: Bytes[32] = raw_call(\n', '        variableDebtTokenAddress,\n', '        concat(\n', '            method_id("scaledBalanceOf(address)"),\n', '            convert(_escrow, bytes32)\n', '        ),\n', '        max_outsize=32\n', '    )\n', '\n', '    # convert the scaledBalanceOfResponse to a uint256\n', '    scaledBalanceOf: uint256 = convert(scaledBalanceOfResponse, uint256)\n', '\n', '    # calculate the borrow balance increase of the Escrow\n', '    balanceIncrease: decimal = ((convert(escrowBorrowBalance, decimal) - convert(scaledBalanceOf, decimal)) * (convert(_loan.lastBorrowIndex, decimal) / convert(10 ** 27, decimal))) / convert(10 ** 18, decimal)\n', '\n', '    # declare a memory variable to store the amount of interest accrued\n', '    interestAccrued: decimal = 0.0\n', '\n', '    # check that the escrow borrow balance is not equal to the balance increase to prevent division by 0\n', '    if convert(escrowBorrowBalance, decimal) != balanceIncrease:\n', '\n', '        # calculate the interest accrued since the last action on the loan\n', '        interestAccrued = balanceIncrease / (convert(escrowBorrowBalance, decimal) - balanceIncrease)\n', '\n', '    # apply interest accrued to the outstanding balance of the loan\n', '    borrowBalance: uint256 = convert(convert(_loan.outstanding, decimal) * (1.0 + interestAccrued), uint256)\n', '\n', '    # declare a memory variable to store the repayment amount \n', '    repayAmount: uint256 = 0\n', '\n', '    # check if this is a full repayment or an over-repayment\n', '    if _amount == MAX_UINT256 or _amount > borrowBalance:\n', '\n', '        # set repaymentAmount to be the borrowBalance\n', '        repayAmount = borrowBalance\n', '\n', '    # handle partial repayment\n', '    else:\n', '\n', '        # set repaymentAmount to be the requested amount\n', '        repayAmount = _amount\n', '\n', '    # subtract the repayment amount from the borrow balance to get the outstanding balance\n', '    outstandingBalanceScaled: int128 = convert(borrowBalance, int128) - convert(repayAmount, int128)\n', '\n', '    # get the LTV ratio of the collateral asset\n', '    collateralReserveData: Bytes[768] = raw_call(\n', '        _collateral_context.aaveV2LendingPool,\n', '        concat(\n', '            method_id("getReserveData(address)"),\n', '            convert(_collateral_context.underlying, bytes32)\n', '        ),\n', '        max_outsize=768\n', '    )\n', '\n', '    # parse the LTV from collateralReserveData and convert it to a percentage\n', '    collateralAssetLTV: decimal = convert(convert(slice(collateralReserveData, 30, 2), uint256), decimal) / 10000.0\n', '\n', '    # get the price of the borrow asset and the collateral asset denominated in ETH\n', '    borrowAssetPriceExp: uint256 = AAVE_V2_PRICE_FEED(_borrow_context.aaveV2PriceFeed).getAssetPrice(_borrow_context.underlying)\n', '    collateralAssetPriceExp: uint256 = AAVE_V2_PRICE_FEED(_collateral_context.aaveV2PriceFeed).getAssetPrice(_collateral_context.underlying)\n', '\n', '    # scale down the prices and convert them to decimals\n', '    borrowAssetPrice: decimal = convert(borrowAssetPriceExp, decimal) / convert(TEN_EXP_18, decimal)\n', '    collateralAssetPrice: decimal = convert(collateralAssetPriceExp, decimal) / convert(TEN_EXP_18, decimal)\n', '\n', '    # convert the outstanding balance to a decimal and scale it down\n', '    outstandingBalance: decimal = convert(outstandingBalanceScaled, decimal) / convert(10 ** _borrow_context.decimals, decimal)\n', '\n', '    # calculate the value of the outstanding borrow amount denominated in ETH\n', '    borrowAmountInETH: decimal = outstandingBalance * borrowAssetPrice\n', '\n', '    # calculate the required collateral denominated in ETH\n', '    requiredCollateralInETH: decimal = borrowAmountInETH / collateralAssetLTV\n', '\n', '    # calculate the amount of collateral asset to lock\n', '    requiredCollateral: decimal = requiredCollateralInETH / collateralAssetPrice\n', '\n', '    # calculate the required collateral denominated in the collateral asset\n', '    requiredCollateralGreenwood: decimal = requiredCollateral * (convert(_loan.collateralizationRatio, decimal) / 100.0)\n', '\n', '    # calculate the required collateral for Greenwood denominated in the collateral asset \n', '    requiredCollateralScaled: uint256 = convert(requiredCollateralGreenwood * convert(10 ** _collateral_context.decimals, decimal), uint256)\n', '\n', '    # calculate the redemption amount\n', '    redemptionAmount: int128 = convert(_loan.collateralLocked, int128) - convert(requiredCollateralScaled, int128)\n', '\n', '    # return the calculations\n', '    return AaveV2RepayCalculation({\n', '        repayAmount: repayAmount,\n', '        redemptionAmount: redemptionAmount,\n', '        requiredCollateral: requiredCollateralScaled,\n', '        outstanding: convert(outstandingBalance * convert(10 ** _borrow_context.decimals, decimal), int128), # scale the outstanding balance back up and convert it to an int128\n', '        borrowIndex: borrowIndex\n', '    })\n', '\n', '@external\n', 'def setProtocolFee(_new_fee: uint256):\n', '    """\n', '    @notice Updates the protocol fee\n', '    @param _new_fee The new protocol fee\n', '    @dev Only the Governance can call this method\n', '    """\n', '\n', '    # require that the method caller is the Governance\n', '    assert self.isAuthorized(msg.sender, "governance", "") == True, "Only Governance can call this method"\n', '\n', '    # get the previous protocol fee\n', '    previousFee: uint256 = self.protocolFee\n', '\n', '    # update the protocol fee\n', '    self.protocolFee = _new_fee\n', '\n', '    # emit a SetFee event\n', '    log SetFee(previousFee, _new_fee, msg.sender, block.number)\n', '\n', '@external\n', 'def setRegistry(_new_registry: address):\n', '    """\n', '    @notice Updates the address of the Registry\n', '    @param _new_registry The address of the new Greenwood Registry\n', '    @dev Only the Governance can call this method\n', '    @dev Only call this method with a valid Greenwood Registry or subsequent calls will fail!\n', '    """\n', '\n', '    # require that the method caller is the Governance\n', '    assert self.isAuthorized(msg.sender, "governance", "") == True, "Only Governance can call this method"\n', '\n', '    # get the previous Registry\n', '    previousRegistry: address = self.registry\n', '\n', '    # update the address of the Registry\n', '    self.registry = _new_registry\n', '\n', '    # emit a SetRegistry event\n', '    log SetRegistry(previousRegistry, _new_registry, msg.sender, block.number)']