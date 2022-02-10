['// SPDX-License-Identifier: UNLICENSED\n', 'pragma solidity 0.6.12;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'import "./SafeMath.sol";\n', 'import "./IERC20.sol";\n', 'import "./HoldefiOwnable.sol";\n', '\n', '/// @notice File: contracts/Holdefi.sol\n', 'interface HoldefiInterface {\n', '\tstruct Market {\n', '\t\tuint256 totalSupply;\n', '\t\tuint256 supplyIndex;\n', '\t\tuint256 supplyIndexUpdateTime;\n', '\n', '\t\tuint256 totalBorrow;\n', '\t\tuint256 borrowIndex;\n', '\t\tuint256 borrowIndexUpdateTime;\n', '\n', '\t\tuint256 promotionReserveScaled;\n', '\t\tuint256 promotionReserveLastUpdateTime;\n', '\t\tuint256 promotionDebtScaled;\n', '\t\tuint256 promotionDebtLastUpdateTime;\n', '\t}\n', '\n', '\tfunction marketAssets(address market) external view returns (Market memory);\n', '\tfunction holdefiSettings() external view returns (address contractAddress);\n', '\tfunction beforeChangeSupplyRate (address market) external;\n', '\tfunction beforeChangeBorrowRate (address market) external;\n', '\tfunction reserveSettlement (address market) external;\n', '}\n', '\n', '/// @title HoldefiSettings contract\n', '/// @author Holdefi Team\n', '/// @notice This contract is for Holdefi settings implementation\n', 'contract HoldefiSettings is HoldefiOwnable {\n', '\n', '\tusing SafeMath for uint256;\n', '\n', '\t/// @notice Markets Features\n', '\tstruct MarketSettings {\n', '\t\tbool isExist;\t\t// Market is exist or not\n', '\t\tbool isActive;\t\t// Market is open for deposit or not\n', '\n', '\t\tuint256 borrowRate;\n', '\t\tuint256 borrowRateUpdateTime;\n', '\n', '\t\tuint256 suppliersShareRate;\n', '\t\tuint256 suppliersShareRateUpdateTime;\n', '\n', '\t\tuint256 promotionRate;\n', '\t}\n', '\n', '\t/// @notice Collateral Features\n', '\tstruct CollateralSettings {\n', '\t\tbool isExist;\t\t// Collateral is exist or not\n', '\t\tbool isActive;\t\t// Collateral is open for deposit or not\n', '\n', '\t\tuint256 valueToLoanRate;\n', '\t\tuint256 VTLUpdateTime;\n', '\n', '\t\tuint256 penaltyRate;\n', '\t\tuint256 penaltyUpdateTime;\n', '\n', '\t\tuint256 bonusRate;\n', '\t}\n', '\n', '\tuint256 constant public rateDecimals = 10 ** 4;\n', '\n', '\taddress constant public ethAddress = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;\n', '\n', '\tuint256 constant public periodBetweenUpdates = 864000;      \t// seconds per ten days\n', '\n', '\tuint256 constant public maxBorrowRate = 4000;      \t\t\t\t// 40%\n', '\n', '\tuint256 constant public borrowRateMaxIncrease = 500;      \t\t// 5%\n', '\n', '\tuint256 constant public minSuppliersShareRate = 5000;      \t\t// 50%\n', '\n', '\tuint256 constant public suppliersShareRateMaxDecrease = 500;\t// 5%\n', '\n', '\tuint256 constant public maxValueToLoanRate = 20000;      \t\t// 200%\n', '\n', '\tuint256 constant public valueToLoanRateMaxIncrease = 500;      \t// 5%\n', '\n', '\tuint256 constant public maxPenaltyRate = 13000;      \t\t\t// 130%\n', '\n', '\tuint256 constant public penaltyRateMaxIncrease = 500;      \t\t// 5%\n', '\n', '\tuint256 constant public maxPromotionRate = 3000;\t\t\t\t// 30%\n', '\n', '\tuint256 constant public maxListsLength = 25;\n', '\n', '\t/// @dev Used for calculating liquidation threshold \n', '\t/// There is 5% gap between value to loan rate and liquidation rate\n', '\tuint256 constant private fivePercentLiquidationGap = 500;\n', '\n', '\tmapping (address => MarketSettings) public marketAssets;\n', '\taddress[] public marketsList;\n', '\n', '\tmapping (address => CollateralSettings) public collateralAssets;\n', '\n', '\tHoldefiInterface public holdefiContract;\n', '\n', '\t/// @notice Event emitted when market activation status is changed\n', '\tevent MarketActivationChanged(address indexed market, bool status);\n', '\n', '\t/// @notice Event emitted when collateral activation status is changed\n', '\tevent CollateralActivationChanged(address indexed collateral, bool status);\n', '\n', '\t/// @notice Event emitted when market existence status is changed\n', '\tevent MarketExistenceChanged(address indexed market, bool status);\n', '\n', '\t/// @notice Event emitted when collateral existence status is changed\n', '\tevent CollateralExistenceChanged(address indexed collateral, bool status);\n', '\n', '\t/// @notice Event emitted when market borrow rate is changed\n', '\tevent BorrowRateChanged(address indexed market, uint256 newRate, uint256 oldRate);\n', '\n', '\t/// @notice Event emitted when market suppliers share rate is changed\n', '\tevent SuppliersShareRateChanged(address indexed market, uint256 newRate, uint256 oldRate);\n', '\n', '\t/// @notice Event emitted when market promotion rate is changed\n', '\tevent PromotionRateChanged(address indexed market, uint256 newRate, uint256 oldRate);\n', '\n', '\t/// @notice Event emitted when collateral value to loan rate is changed\n', '\tevent ValueToLoanRateChanged(address indexed collateral, uint256 newRate, uint256 oldRate);\n', '\n', '\t/// @notice Event emitted when collateral penalty rate is changed\n', '\tevent PenaltyRateChanged(address indexed collateral, uint256 newRate, uint256 oldRate);\n', '\n', '\t/// @notice Event emitted when collateral bonus rate is changed\n', '\tevent BonusRateChanged(address indexed collateral, uint256 newRate, uint256 oldRate);\n', '\n', '\n', '\n', '\t/// @dev Modifier to make a function callable only when the market is exist\n', '\t/// @param market Address of the given market\n', '    modifier marketIsExist(address market) {\n', '        require (marketAssets[market].isExist, "The market is not exist");\n', '        _;\n', '    }\n', '\n', '\t/// @dev Modifier to make a function callable only when the collateral is exist\n', '\t/// @param collateral Address of the given collateral\n', '    modifier collateralIsExist(address collateral) {\n', '        require (collateralAssets[collateral].isExist, "The collateral is not exist");\n', '        _;\n', '    }\n', '\n', '\n', '\t/// @notice you cannot send ETH to this contract\n', '    receive() external payable {\n', '        revert();\n', '    }\n', '\n', ' \t/// @notice Activate a market asset\n', '\t/// @dev Can only be called by the owner\n', '\t/// @param market Address of the given market\n', '\tfunction activateMarket (address market) public onlyOwner marketIsExist(market) {\n', '\t\tactivateMarketInternal(market);\n', '\t}\n', '\n', '\t/// @notice Deactivate a market asset\n', '\t/// @dev Can only be called by the owner\n', '\t/// @param market Address of the given market\n', '\tfunction deactivateMarket (address market) public onlyOwner marketIsExist(market) {\n', '\t\tmarketAssets[market].isActive = false;\n', '\t\temit MarketActivationChanged(market, false);\n', '\t}\n', '\n', '\t/// @notice Activate a collateral asset\n', '\t/// @dev Can only be called by the owner\n', '\t/// @param collateral Address the given collateral\n', '\tfunction activateCollateral (address collateral) public onlyOwner collateralIsExist(collateral) {\n', '\t\tactivateCollateralInternal(collateral);\n', '\t}\n', '\n', '\t/// @notice Deactivate a collateral asset\n', '\t/// @dev Can only be called by the owner\n', '\t/// @param collateral Address of the given collateral\n', '\tfunction deactivateCollateral (address collateral) public onlyOwner collateralIsExist(collateral) {\n', '\t\tcollateralAssets[collateral].isActive = false;\n', '\t\temit CollateralActivationChanged(collateral, false);\n', '\t}\n', '\n', '\t/// @notice Returns the list of markets\n', '\t/// @return res List of markets\n', '\tfunction getMarketsList() external view returns (address[] memory res){\n', '\t\tres = marketsList;\n', '\t}\n', '\n', '\t/// @notice Disposable function to interact with Holdefi contract\n', '\t/// @dev Can only be called by the owner\n', '\t/// @param holdefiContractAddress Address of the Holdefi contract\n', '\tfunction setHoldefiContract(HoldefiInterface holdefiContractAddress) external onlyOwner {\n', '\t\trequire (holdefiContractAddress.holdefiSettings() == address(this),\n', '\t\t\t"Conflict with Holdefi contract address"\n', '\t\t);\n', '\t\trequire (address(holdefiContract) == address(0), "Should be set once");\n', '\t\tholdefiContract = holdefiContractAddress;\n', '\t}\n', '\n', '\t/// @notice Returns supply, borrow and promotion rate of the given market\n', '\t/// @dev supplyRate = (totalBorrow * borrowRate) * suppliersShareRate / totalSupply\n', '\t/// @param market Address of the given market\n', '\t/// @return borrowRate Borrow rate of the given market\n', '\t/// @return supplyRateBase Supply rate base of the given market\n', '\t/// @return promotionRate Promotion rate of the given market\n', '\tfunction getInterests (address market)\n', '\t\texternal\n', '\t\tview\n', '\t\treturns (uint256 borrowRate, uint256 supplyRateBase, uint256 promotionRate)\n', '\t{\n', '\t\tuint256 totalBorrow = holdefiContract.marketAssets(market).totalBorrow;\n', '\t\tuint256 totalSupply = holdefiContract.marketAssets(market).totalSupply;\n', '\t\tborrowRate = marketAssets[market].borrowRate;\n', '\n', '\t\tif (totalSupply == 0) {\n', '\t\t\tsupplyRateBase = 0;\n', '\t\t}\n', '\t\telse {\n', '\t\t\tuint256 totalInterestFromBorrow = totalBorrow.mul(borrowRate);\n', '\t\t\tuint256 suppliersShare = totalInterestFromBorrow.mul(marketAssets[market].suppliersShareRate);\n', '\t\t\tsuppliersShare = suppliersShare.div(rateDecimals);\n', '\t\t\tsupplyRateBase = suppliersShare.div(totalSupply);\n', '\t\t}\n', '\t\tpromotionRate = marketAssets[market].promotionRate;\n', '\t}\n', '\n', '\n', '\t/// @notice Set promotion rate for a market\n', '\t/// @dev Can only be called by the owner\n', '\t/// @param market Address of the given market\n', '\t/// @param newPromotionRate New promotion rate\n', '\tfunction setPromotionRate (address market, uint256 newPromotionRate) external onlyOwner {\n', '\t\trequire (newPromotionRate <= maxPromotionRate, "Rate should be in allowed range");\n', '\n', '\t\tholdefiContract.beforeChangeSupplyRate(market);\n', '\t\tholdefiContract.reserveSettlement(market);\n', '\n', '\t\temit PromotionRateChanged(market, newPromotionRate, marketAssets[market].promotionRate);\n', '\t\tmarketAssets[market].promotionRate = newPromotionRate;\n', '\t}\n', '\n', '\t/// @notice Reset promotion rate of the market to zero\n', '\t/// @dev Can only be called by holdefi contract\n', '\t/// @param market Address of the given market\n', '\tfunction resetPromotionRate (address market) external {\n', '\t\trequire (msg.sender == address(holdefiContract), "Sender is not Holdefi contract");\n', '\n', '\t\temit PromotionRateChanged(market, 0, marketAssets[market].promotionRate);\n', '\t\tmarketAssets[market].promotionRate = 0;\n', '\t}\n', '\n', '\t/// @notice Set borrow rate for a market\n', '\t/// @dev Can only be called by the owner\n', '\t/// @param market Address of the given market\n', '\t/// @param newBorrowRate New borrow rate\n', '\tfunction setBorrowRate (address market, uint256 newBorrowRate)\n', '\t\texternal \n', '\t\tonlyOwner\n', '\t\tmarketIsExist(market)\n', '\t{\n', '\t\tsetBorrowRateInternal(market, newBorrowRate);\n', '\t}\n', '\n', '\t/// @notice Set suppliers share rate for a market\n', '\t/// @dev Can only be called by the owner\n', '\t/// @param market Address of the given market\n', '\t/// @param newSuppliersShareRate New suppliers share rate\n', '\tfunction setSuppliersShareRate (address market, uint256 newSuppliersShareRate)\n', '\t\texternal\n', '\t\tonlyOwner\n', '\t\tmarketIsExist(market)\n', '\t{\n', '\t\tsetSuppliersShareRateInternal(market, newSuppliersShareRate);\n', '\t}\n', '\n', '\t/// @notice Set value to loan rate for a collateral\n', '\t/// @dev Can only be called by the owner\n', '\t/// @param collateral Address of the given collateral\n', '\t/// @param newValueToLoanRate New value to loan rate\n', '\tfunction setValueToLoanRate (address collateral, uint256 newValueToLoanRate)\n', '\t\texternal\n', '\t\tonlyOwner\n', '\t\tcollateralIsExist(collateral)\n', '\t{\n', '\t\tsetValueToLoanRateInternal(collateral, newValueToLoanRate);\n', '\t}\n', '\n', '\t/// @notice Set penalty rate for a collateral\n', '\t/// @dev Can only be called by the owner\n', '\t/// @param collateral Address of the given collateral\n', '\t/// @param newPenaltyRate New penalty rate\n', '\tfunction setPenaltyRate (address collateral, uint256 newPenaltyRate)\n', '\t\texternal\n', '\t\tonlyOwner\n', '\t\tcollateralIsExist(collateral)\n', '\t{\n', '\t\tsetPenaltyRateInternal(collateral, newPenaltyRate);\n', '\t}\n', '\n', '\t/// @notice Set bonus rate for a collateral\n', '\t/// @dev Can only be called by the owner\n', '\t/// @param collateral Address of the given collateral\n', '\t/// @param newBonusRate New bonus rate\n', '\tfunction setBonusRate (address collateral, uint256 newBonusRate)\n', '\t\texternal\n', '\t\tonlyOwner\n', '\t\tcollateralIsExist(collateral)\n', '\t{\n', '\t\tsetBonusRateInternal(collateral, newBonusRate); \n', '\t}\n', '\n', '\t/// @notice Add a new asset as a market\n', '\t/// @dev Can only be called by the owner\n', '\t/// @param market Address of the new market\n', '\t/// @param borrowRate BorrowRate of the new market\n', '\t/// @param suppliersShareRate SuppliersShareRate of the new market\n', '\tfunction addMarket (address market, uint256 borrowRate, uint256 suppliersShareRate)\n', '\t\texternal\n', '\t\tonlyOwner\n', '\t{\n', '\t\trequire (!marketAssets[market].isExist, "The market is exist");\n', '\t\trequire (marketsList.length < maxListsLength, "Market list is full");\n', '\n', '\t\tif (market != ethAddress) {\n', '\t\t\tIERC20(market);\n', '\t\t}\n', '\n', '\t\tmarketsList.push(market);\n', '\t\tmarketAssets[market].isExist = true;\n', '\t\temit MarketExistenceChanged(market, true);\n', '\n', '\t\tsetBorrowRateInternal(market, borrowRate);\n', '\t\tsetSuppliersShareRateInternal(market, suppliersShareRate);\n', '\t\t\n', '\t\tactivateMarketInternal(market);\t\t\n', '\t}\n', '\n', '\t/// @notice Remove a market asset\n', '\t/// @dev Can only be called by the owner\n', '\t/// @param market Address of the given market\n', '\tfunction removeMarket (address market) external onlyOwner marketIsExist(market) {\n', '\t\tuint256 totalBorrow = holdefiContract.marketAssets(market).totalBorrow;\n', '\t\trequire (totalBorrow == 0, "Total borrow is not zero");\n', '\t\t\n', '\t\tholdefiContract.beforeChangeBorrowRate(market);\n', '\n', '\t\tuint256 i;\n', '\t\tuint256 index;\n', '\t\tuint256 marketListLength = marketsList.length;\n', '\t\tfor (i = 0 ; i < marketListLength ; i++) {\n', '\t\t\tif (marketsList[i] == market) {\n', '\t\t\t\tindex = i;\n', '\t\t\t}\n', '\t\t}\n', '\n', '\t\tif (index != marketListLength-1) {\n', '\t\t\tfor (i = index ; i < marketListLength-1 ; i++) {\n', '\t\t\t\tmarketsList[i] = marketsList[i+1];\n', '\t\t\t}\n', '\t\t}\n', '\n', '\t\tmarketsList.pop();\n', '\t\tdelete marketAssets[market];\n', '\t\temit MarketExistenceChanged(market, false);\n', '\t}\n', '\n', '\t/// @notice Add a new asset as a collateral\n', '\t/// @dev Can only be called by the owner\n', '\t/// @param collateral Address of the new collateral\n', '\t/// @param valueToLoanRate ValueToLoanRate of the new collateral\n', '\t/// @param penaltyRate PenaltyRate of the new collateral\n', '\t/// @param bonusRate BonusRate of the new collateral\n', '\tfunction addCollateral (\n', '\t\taddress collateral,\n', '\t\tuint256 valueToLoanRate,\n', '\t\tuint256 penaltyRate,\n', '\t\tuint256 bonusRate\n', '\t)\n', '\t\texternal\n', '\t\tonlyOwner\n', '\t{\n', '\t\trequire (!collateralAssets[collateral].isExist, "The collateral is exist");\n', '\n', '\t\tif (collateral != ethAddress) {\n', '\t\t\tIERC20(collateral);\n', '\t\t}\n', '\n', '\t\tcollateralAssets[collateral].isExist = true;\n', '\t\temit CollateralExistenceChanged(collateral, true);\n', '\n', '\t\tsetValueToLoanRateInternal(collateral, valueToLoanRate);\n', '\t\tsetPenaltyRateInternal(collateral, penaltyRate);\n', '\t\tsetBonusRateInternal(collateral, bonusRate);\n', '\n', '\t\tactivateCollateralInternal(collateral);\n', '\t}\n', '\n', '\t/// @notice Activate the market\n', '\tfunction activateMarketInternal (address market) internal {\n', '\t\tmarketAssets[market].isActive = true;\n', '\t\temit MarketActivationChanged(market, true);\n', '\t}\n', '\n', '\t/// @notice Activate the collateral\n', '\tfunction activateCollateralInternal (address collateral) internal {\n', '\t\tcollateralAssets[collateral].isActive = true;\n', '\t\temit CollateralActivationChanged(collateral, true);\n', '\t}\n', '\n', '\t/// @notice Set borrow rate operation\n', '\tfunction setBorrowRateInternal (address market, uint256 newBorrowRate) internal {\n', '\t\trequire (newBorrowRate <= maxBorrowRate, "Rate should be less than max");\n', '\t\tuint256 currentTime = block.timestamp;\n', '\n', '\t\tif (marketAssets[market].borrowRateUpdateTime != 0) {\n', '\t\t\tif (newBorrowRate > marketAssets[market].borrowRate) {\n', '\t\t\t\tuint256 deltaTime = currentTime.sub(marketAssets[market].borrowRateUpdateTime);\n', '\t\t\t\trequire (deltaTime >= periodBetweenUpdates, "Increasing rate is not allowed at this time");\n', '\n', '\t\t\t\tuint256 maxIncrease = marketAssets[market].borrowRate.add(borrowRateMaxIncrease);\n', '\t\t\t\trequire (newBorrowRate <= maxIncrease, "Rate should be increased less than max allowed");\n', '\t\t\t}\n', '\n', '\t\t\tholdefiContract.beforeChangeBorrowRate(market);\n', '\t\t}\n', '\n', '\t\temit BorrowRateChanged(market, newBorrowRate, marketAssets[market].borrowRate);\n', '\n', '\t\tmarketAssets[market].borrowRate = newBorrowRate;\n', '\t\tmarketAssets[market].borrowRateUpdateTime = currentTime;\n', '\t}\n', '\n', '\t/// @notice Set suppliers share rate operation\n', '\tfunction setSuppliersShareRateInternal (address market, uint256 newSuppliersShareRate) internal {\n', '\t\trequire (\n', '\t\t\tnewSuppliersShareRate >= minSuppliersShareRate && newSuppliersShareRate <= rateDecimals,\n', '\t\t\t"Rate should be in allowed range"\n', '\t\t);\n', '\t\tuint256 currentTime = block.timestamp;\n', '\n', '\t\tif (marketAssets[market].suppliersShareRateUpdateTime != 0) {\n', '\t\t\tif (newSuppliersShareRate < marketAssets[market].suppliersShareRate) {\n', '\t\t\t\tuint256 deltaTime = currentTime.sub(marketAssets[market].suppliersShareRateUpdateTime);\n', '\t\t\t\trequire (deltaTime >= periodBetweenUpdates, "Decreasing rate is not allowed at this time");\n', '\n', '\t\t\t\tuint256 decreasedAllowed = newSuppliersShareRate.add(suppliersShareRateMaxDecrease);\n', '\t\t\t\trequire (\n', '\t\t\t\t\tmarketAssets[market].suppliersShareRate <= decreasedAllowed,\n', '\t\t\t\t\t"Rate should be decreased less than max allowed"\n', '\t\t\t\t);\n', '\t\t\t}\n', '\n', '\t\t\tholdefiContract.beforeChangeSupplyRate(market);\n', '\t\t}\n', '\n', '\t\temit SuppliersShareRateChanged(\n', '\t\t\tmarket,\n', '\t\t\tnewSuppliersShareRate,\n', '\t\t\tmarketAssets[market].suppliersShareRate\n', '\t\t);\n', '\n', '\t\tmarketAssets[market].suppliersShareRate = newSuppliersShareRate;\n', '\t\tmarketAssets[market].suppliersShareRateUpdateTime = currentTime;\n', '\t}\n', '\n', '\t/// @notice Set value to loan rate operation\n', '\tfunction setValueToLoanRateInternal (address collateral, uint256 newValueToLoanRate) internal {\n', '\t\trequire (\n', '\t\t\tnewValueToLoanRate <= maxValueToLoanRate &&\n', '\t\t\tcollateralAssets[collateral].penaltyRate.add(fivePercentLiquidationGap) <= newValueToLoanRate,\n', '\t\t\t"Rate should be in allowed range"\n', '\t\t);\n', '\t\t\n', '\t\tuint256 currentTime = block.timestamp;\n', '\t\tif (\n', '\t\t\tcollateralAssets[collateral].VTLUpdateTime != 0 &&\n', '\t\t\tnewValueToLoanRate > collateralAssets[collateral].valueToLoanRate\n', '\t\t) {\n', '\t\t\tuint256 deltaTime = currentTime.sub(collateralAssets[collateral].VTLUpdateTime);\n', '\t\t\trequire (deltaTime >= periodBetweenUpdates,"Increasing rate is not allowed at this time");\n', '\t\t\tuint256 maxIncrease = collateralAssets[collateral].valueToLoanRate.add(\n', '\t\t\t\tvalueToLoanRateMaxIncrease\n', '\t\t\t);\n', '\t\t\trequire (newValueToLoanRate <= maxIncrease,"Rate should be increased less than max allowed");\n', '\t\t}\n', '\t\temit ValueToLoanRateChanged(\n', '\t\t\tcollateral,\n', '\t\t\tnewValueToLoanRate,\n', '\t\t\tcollateralAssets[collateral].valueToLoanRate\n', '\t\t);\n', '\n', '\t    collateralAssets[collateral].valueToLoanRate = newValueToLoanRate;\n', '\t    collateralAssets[collateral].VTLUpdateTime = currentTime;\n', '\t}\n', '\n', '\t/// @notice Set penalty rate operation\n', '\tfunction setPenaltyRateInternal (address collateral, uint256 newPenaltyRate) internal {\n', '\t\trequire (\n', '\t\t\tnewPenaltyRate <= maxPenaltyRate &&\n', '\t\t\tnewPenaltyRate <= collateralAssets[collateral].valueToLoanRate.sub(fivePercentLiquidationGap) &&\n', '\t\t\tcollateralAssets[collateral].bonusRate <= newPenaltyRate,\n', '\t\t\t"Rate should be in allowed range"\n', '\t\t);\n', '\n', '\t\tuint256 currentTime = block.timestamp;\n', '\t\tif (\n', '\t\t\tcollateralAssets[collateral].penaltyUpdateTime != 0 &&\n', '\t\t\tnewPenaltyRate > collateralAssets[collateral].penaltyRate\n', '\t\t) {\n', '\t\t\tuint256 deltaTime = currentTime.sub(collateralAssets[collateral].penaltyUpdateTime);\n', '\t\t\trequire (deltaTime >= periodBetweenUpdates, "Increasing rate is not allowed at this time");\n', '\t\t\tuint256 maxIncrease = collateralAssets[collateral].penaltyRate.add(penaltyRateMaxIncrease);\n', '\t\t\trequire (newPenaltyRate <= maxIncrease, "Rate should be increased less than max allowed");\n', '\t\t}\n', '\n', '\t\temit PenaltyRateChanged(collateral, newPenaltyRate, collateralAssets[collateral].penaltyRate);\n', '\n', '\t    collateralAssets[collateral].penaltyRate  = newPenaltyRate;\n', '\t    collateralAssets[collateral].penaltyUpdateTime = currentTime;\n', '\t}\n', '\n', '\t/// @notice Set Bonus rate operation\n', '\tfunction setBonusRateInternal (address collateral, uint256 newBonusRate) internal {\n', '\t\trequire (\n', '\t\t\tnewBonusRate <= collateralAssets[collateral].penaltyRate && newBonusRate >= rateDecimals,\n', '\t\t\t"Rate should be in allowed range"\n', '\t\t);\n', '\t\t\n', '\t\temit BonusRateChanged(collateral, newBonusRate, collateralAssets[collateral].bonusRate);\n', '\t    collateralAssets[collateral].bonusRate = newBonusRate;    \n', '\t}\n', '}']