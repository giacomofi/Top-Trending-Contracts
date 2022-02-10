['pragma solidity ^0.6.6;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'import "./SafeMath.sol";\n', 'import "./IACOPoolStrategy.sol";\n', 'import "./IACOFactory.sol";\n', 'import "./IACOToken.sol";\n', 'import "./ILendingPool.sol";\n', '\n', 'library ACOPoolLib {\n', '\tusing SafeMath for uint256;\n', '\t\n', '\tstruct OpenPositionData {\n', '        uint256 underlyingPrice;\n', '        uint256 baseVolatility;\n', '        uint256 underlyingPriceAdjustPercentage;\n', '        uint256 fee;\n', '        uint256 underlyingPrecision;\n', '        address strategy;\n', '        address acoFactory;\n', '\t    address acoToken;\n', '\t}\n', '\t\n', '\tstruct QuoteData {\n', '\t\tbool isCall;\n', '        uint256 tokenAmount; \n', '\t\taddress underlying;\n', '\t\taddress strikeAsset;\n', '\t\tuint256 strikePrice; \n', '\t\tuint256 expiryTime;\n', '\t\taddress lendingToken;\n', '\t\taddress strategy;\n', '\t\tuint256 baseVolatility;\n', '\t\tuint256 fee;\n', '\t\tuint256 minExpiration;\n', '\t\tuint256 maxExpiration;\n', '\t\tuint256 tolerancePriceBelow;\n', '\t\tuint256 tolerancePriceAbove;\n', '\t\tuint256 underlyingPrice;\n', '\t\tuint256 underlyingPrecision;\n', '\t}\n', '\t\n', '\tstruct OpenPositionExtraData {\n', '        bool isCall;\n', '        uint256 strikePrice; \n', '        uint256 expiryTime;\n', '        uint256 tokenAmount;\n', '\t    address underlying;\n', '        address strikeAsset; \n', '\t}\n', '\t\n', '\tuint256 public constant PERCENTAGE_PRECISION = 100000;\n', '\t\n', '\tfunction name(address underlying, address strikeAsset, bool isCall) public view returns(string memory) {\n', '        return string(abi.encodePacked(\n', '            "ACO POOL WRITE ",\n', '            _getAssetSymbol(underlying),\n', '            "-",\n', '            _getAssetSymbol(strikeAsset),\n', '            "-",\n', '            (isCall ? "CALL" : "PUT")\n', '        ));\n', '    }\n', '    \n', '\tfunction acoStrikePriceIsValid(\n', '\t\tuint256 tolerancePriceBelow,\n', '\t\tuint256 tolerancePriceAbove,\n', '\t\tuint256 strikePrice, \n', '\t\tuint256 price\n', '\t) public pure returns(bool) {\n', '\t\treturn (tolerancePriceBelow == 0 && tolerancePriceAbove == 0) ||\n', '\t\t\t(tolerancePriceBelow == 0 && strikePrice > price.mul(PERCENTAGE_PRECISION.add(tolerancePriceAbove)).div(PERCENTAGE_PRECISION)) ||\n', '\t\t\t(tolerancePriceAbove == 0 && strikePrice < price.mul(PERCENTAGE_PRECISION.sub(tolerancePriceBelow)).div(PERCENTAGE_PRECISION)) ||\n', '\t\t\t(strikePrice >= price.mul(PERCENTAGE_PRECISION.sub(tolerancePriceBelow)).div(PERCENTAGE_PRECISION) && \n', '\t\t\t strikePrice <= price.mul(PERCENTAGE_PRECISION.add(tolerancePriceAbove)).div(PERCENTAGE_PRECISION));\n', '\t}\n', '\n', '\tfunction acoExpirationIsValid(uint256 acoExpiryTime, uint256 minExpiration, uint256 maxExpiration) public view returns(bool) {\n', '\t\treturn acoExpiryTime >= block.timestamp.add(minExpiration) && acoExpiryTime <= block.timestamp.add(maxExpiration);\n', '\t}\n', '\n', '    function getBaseAssetsWithdrawWithLocked(\n', '        uint256 shares,\n', '        address underlying,\n', '        address strikeAsset,\n', '        bool isCall,\n', '        uint256 totalSupply,\n', '        address lendingToken\n', '    ) public view returns(\n', '        uint256 underlyingWithdrawn,\n', '\t\tuint256 strikeAssetWithdrawn\n', '    ) {\n', '\t\tuint256 underlyingBalance = _getPoolBalanceOf(underlying);\n', '\t\tuint256 strikeAssetBalance;\n', '\t\tif (isCall) {\n', '\t\t    strikeAssetBalance = _getPoolBalanceOf(strikeAsset);\n', '\t\t} else {\n', '\t\t    strikeAssetBalance = _getPoolBalanceOf(lendingToken);\n', '\t\t}\n', '\t\t\n', '\t\tunderlyingWithdrawn = underlyingBalance.mul(shares).div(totalSupply);\n', '\t\tstrikeAssetWithdrawn = strikeAssetBalance.mul(shares).div(totalSupply);\n', '    }\n', '    \n', '    function getBaseWithdrawNoLockedData(\n', '        uint256 shares,\n', '        uint256 totalSupply,\n', '        bool isCall,\n', '        uint256 underlyingBalance, \n', '        uint256 strikeAssetBalance, \n', '        uint256 collateralBalance, \n', '        uint256 collateralLockedRedeemable\n', '    ) public pure returns(\n', '        uint256 underlyingWithdrawn,\n', '\t\tuint256 strikeAssetWithdrawn,\n', '\t\tbool isPossible\n', '    ) {\n', '\t\tuint256 collateralAmount = shares.mul(collateralBalance).div(totalSupply);\n', '\t\t\n', '\t\tif (isCall) {\n', '\t\t\tunderlyingWithdrawn = collateralAmount;\n', '\t\t\tstrikeAssetWithdrawn = strikeAssetBalance.mul(shares).div(totalSupply);\n', '\t\t\tisPossible = (collateralAmount <= underlyingBalance.add(collateralLockedRedeemable));\n', '\t\t} else {\n', '\t\t\tstrikeAssetWithdrawn = collateralAmount;\n', '\t\t\tunderlyingWithdrawn = underlyingBalance.mul(shares).div(totalSupply);\n', '\t\t\tisPossible = (collateralAmount <= strikeAssetBalance.add(collateralLockedRedeemable));\n', '\t\t}\n', '    }\n', '    \n', '    function getAmountToLockedWithdraw(\n', '        uint256 shares, \n', '        uint256 totalSupply, \n', '        address lendingToken,\n', '        address underlying, \n', '        address strikeAsset, \n', '        bool isCall\n', '    ) public view returns(\n', '        uint256 underlyingWithdrawn, \n', '        uint256 strikeAssetWithdrawn\n', '    ) {\n', '\t\tuint256 underlyingBalance = _getPoolBalanceOf(underlying);\n', '\t\tuint256 strikeAssetBalance;\n', '\t\tif (isCall) {\n', '\t\t    strikeAssetBalance = _getPoolBalanceOf(strikeAsset);\n', '\t\t} else {\n', '\t\t    strikeAssetBalance = _getPoolBalanceOf(lendingToken);\n', '\t\t}\n', '\t\t\n', '\t\tunderlyingWithdrawn = underlyingBalance.mul(shares).div(totalSupply);\n', '\t\tstrikeAssetWithdrawn = strikeAssetBalance.mul(shares).div(totalSupply);\n', '    }\n', '    \n', '    function getAmountToNoLockedWithdraw(\n', '        uint256 shares, \n', '        uint256 totalSupply,\n', '        uint256 underlyingBalance, \n', '        uint256 strikeAssetBalance,\n', '        uint256 collateralBalance,\n', '        uint256 minCollateral,\n', '        bool isCall\n', '    ) public pure returns(\n', '        uint256 underlyingWithdrawn, \n', '        uint256 strikeAssetWithdrawn\n', '    ) {\n', '\t\tuint256 collateralAmount = shares.mul(collateralBalance).div(totalSupply);\n', '\t\trequire(collateralAmount >= minCollateral, "ACOPoolLib: The minimum collateral was not satisfied");\n', '\n', '        if (isCall) {\n', '\t\t\trequire(collateralAmount <= underlyingBalance, "ACOPoolLib: Collateral balance is not sufficient");\n', '\t\t\tunderlyingWithdrawn = collateralAmount;\n', '\t\t\tstrikeAssetWithdrawn = strikeAssetBalance.mul(shares).div(totalSupply);\n', '        } else {\n', '\t\t\trequire(collateralAmount <= strikeAssetBalance, "ACOPoolLib: Collateral balance is not sufficient");\n', '\t\t\tstrikeAssetWithdrawn = collateralAmount;\n', '\t\t\tunderlyingWithdrawn = underlyingBalance.mul(shares).div(totalSupply);\n', '\t\t}\n', '    }\n', '    \n', '\tfunction getBaseCollateralData(\n', '\t    address lendingToken,\n', '\t    address underlying,\n', '\t    address strikeAsset,\n', '\t    bool isCall,\n', '\t    uint256 underlyingPrice,\n', '\t    uint256 underlyingPriceAdjustPercentage,\n', '\t    uint256 underlyingPrecision,\n', '\t    bool isDeposit\n', '    ) public view returns(\n', '        uint256 underlyingBalance, \n', '        uint256 strikeAssetBalance, \n', '        uint256 collateralBalance\n', '    ) {\n', '\t\tunderlyingBalance = _getPoolBalanceOf(underlying);\n', '\t\t\n', '\t\tif (isCall) {\n', '\t\t    strikeAssetBalance = _getPoolBalanceOf(strikeAsset);\n', '\t\t\tcollateralBalance = underlyingBalance;\n', '\t\t\tif (isDeposit && strikeAssetBalance > 0) {\n', '\t\t\t\tuint256 priceAdjusted = _getUnderlyingPriceAdjusted(underlyingPrice, underlyingPriceAdjustPercentage, false); \n', '\t\t\t\tcollateralBalance = collateralBalance.add(strikeAssetBalance.mul(underlyingPrecision).div(priceAdjusted));\n', '\t\t\t}\n', '\t\t} else {\n', '\t\t    strikeAssetBalance = _getPoolBalanceOf(lendingToken);\n', '\t\t\tcollateralBalance = strikeAssetBalance;\n', '\t\t\tif (isDeposit && underlyingBalance > 0) {\n', '\t\t\t\tuint256 priceAdjusted = _getUnderlyingPriceAdjusted(underlyingPrice, underlyingPriceAdjustPercentage, true); \n', '\t\t\t\tcollateralBalance = collateralBalance.add(underlyingBalance.mul(priceAdjusted).div(underlyingPrecision));\n', '\t\t\t}\n', '\t\t}\n', '\t}\n', '\t\n', '\tfunction getOpenPositionCollateralBalance(OpenPositionData memory data) public view returns(\n', '        uint256 collateralLocked, \n', '        uint256 collateralOnOpenPosition,\n', '        uint256 collateralLockedRedeemable\n', '    ) {\n', '        OpenPositionExtraData memory extraData = _getOpenPositionCollateralExtraData(data.acoToken, data.acoFactory);\n', '        (collateralLocked, collateralOnOpenPosition, collateralLockedRedeemable) = _getOpenPositionCollateralBalance(data, extraData);\n', '    }\n', '    \n', '    function quote(QuoteData memory data) public view returns(\n', '        uint256 swapPrice, \n', '        uint256 protocolFee, \n', '        uint256 volatility, \n', '        uint256 collateralAmount\n', '    ) {\n', '        require(data.expiryTime > block.timestamp, "ACOPoolLib: ACO token expired");\n', '        require(acoExpirationIsValid(data.expiryTime, data.minExpiration, data.maxExpiration), "ACOPoolLib: Invalid ACO token expiration");\n', '\t\trequire(acoStrikePriceIsValid(data.tolerancePriceBelow, data.tolerancePriceAbove, data.strikePrice, data.underlyingPrice), "ACOPoolLib: Invalid ACO token strike price");\n', '\n', '        uint256 collateralAvailable;\n', '        (collateralAmount, collateralAvailable) = _getOrderSizeData(data.tokenAmount, data.underlying, data.isCall, data.strikePrice, data.lendingToken, data.underlyingPrecision);\n', '        uint256 calcPrice;\n', '        (calcPrice, volatility) = _strategyQuote(data.strategy, data.underlying, data.strikeAsset, data.isCall, data.strikePrice, data.expiryTime, data.underlyingPrice, data.baseVolatility, collateralAmount, collateralAvailable);\n', '        (swapPrice, protocolFee) = _setSwapPriceAndFee(calcPrice, data.tokenAmount, data.fee, data.underlyingPrecision);\n', '    }\n', '    \n', '    \n', '    function _getCollateralAmount(\n', '\t\tuint256 tokenAmount,\n', '\t\tuint256 strikePrice,\n', '\t\tbool isCall,\n', '\t\tuint256 underlyingPrecision\n', '\t) private pure returns(uint256) {\n', '        if (isCall) {\n', '            return tokenAmount;\n', '        } else if (tokenAmount > 0) {\n', '            return tokenAmount.mul(strikePrice).div(underlyingPrecision);\n', '        } else {\n', '            return 0;\n', '        }\n', '    }\n', '    \n', '    function _getOrderSizeData(\n', '        uint256 tokenAmount,\n', '        address underlying,\n', '        bool isCall,\n', '        uint256 strikePrice,\n', '        address lendingToken,\n', '        uint256 underlyingPrecision\n', '    ) private view returns(\n', '        uint256 collateralAmount, \n', '        uint256 collateralAvailable\n', '    ) {\n', '        if (isCall) {\n', '            collateralAvailable = _getPoolBalanceOf(underlying);\n', '            collateralAmount = tokenAmount; \n', '        } else {\n', '            collateralAvailable = _getPoolBalanceOf(lendingToken);\n', '            collateralAmount = _getCollateralAmount(tokenAmount, strikePrice, isCall, underlyingPrecision);\n', '            require(collateralAmount > 0, "ACOPoolLib: The token amount is too small");\n', '        }\n', '        require(collateralAmount <= collateralAvailable, "ACOPoolLib: Insufficient liquidity");\n', '    }\n', '    \n', '\tfunction _strategyQuote(\n', '        address strategy,\n', '\t\taddress underlying,\n', '\t\taddress strikeAsset,\n', '\t\tbool isCall,\n', '\t\tuint256 strikePrice,\n', '        uint256 expiryTime,\n', '        uint256 underlyingPrice,\n', '\t\tuint256 baseVolatility,\n', '        uint256 collateralAmount,\n', '        uint256 collateralAvailable\n', '    ) private view returns(uint256 swapPrice, uint256 volatility) {\n', '        (swapPrice, volatility) = IACOPoolStrategy(strategy).quote(IACOPoolStrategy.OptionQuote(\n', '\t\t\tunderlyingPrice,\n', '            underlying, \n', '            strikeAsset, \n', '            isCall, \n', '            strikePrice, \n', '            expiryTime, \n', '            baseVolatility, \n', '            collateralAmount, \n', '            collateralAvailable\n', '        ));\n', '    }\n', '    \n', '    function _setSwapPriceAndFee(\n', '        uint256 calcPrice, \n', '        uint256 tokenAmount, \n', '        uint256 fee,\n', '        uint256 underlyingPrecision\n', '    ) private pure returns(uint256 swapPrice, uint256 protocolFee) {\n', '        \n', '        swapPrice = calcPrice.mul(tokenAmount).div(underlyingPrecision);\n', '        \n', '        if (fee > 0) {\n', '            protocolFee = swapPrice.mul(fee).div(PERCENTAGE_PRECISION);\n', '\t\t\tswapPrice = swapPrice.add(protocolFee);\n', '        }\n', '        require(swapPrice > 0, "ACOPoolLib: Invalid quoted price");\n', '    }\n', '    \n', '    function _getOpenPositionCollateralExtraData(address acoToken, address acoFactory) private view returns(OpenPositionExtraData memory extraData) {\n', '        (address underlying, address strikeAsset, bool isCall, uint256 strikePrice, uint256 expiryTime) = IACOFactory(acoFactory).acoTokenData(acoToken);\n', '        uint256 tokenAmount = IACOToken(acoToken).currentCollateralizedTokens(address(this));\n', '        extraData = OpenPositionExtraData(isCall, strikePrice, expiryTime, tokenAmount, underlying, strikeAsset);\n', '    }\n', '    \n', '\tfunction _getOpenPositionCollateralBalance(\n', '\t\tOpenPositionData memory data,\n', '\t\tOpenPositionExtraData memory extraData\n', '\t) private view returns(\n', '\t    uint256 collateralLocked, \n', '        uint256 collateralOnOpenPosition,\n', '        uint256 collateralLockedRedeemable\n', '    ) {\n', '        collateralLocked = _getCollateralAmount(extraData.tokenAmount, extraData.strikePrice, extraData.isCall, data.underlyingPrecision);\n', '        \n', '        if (extraData.expiryTime > block.timestamp) {\n', '    \t\t(uint256 price,) = _strategyQuote(data.strategy, extraData.underlying, extraData.strikeAsset, extraData.isCall, extraData.strikePrice, extraData.expiryTime, data.underlyingPrice, data.baseVolatility, 0, 1);\n', '    \t\tif (data.fee > 0) {\n', '    \t\t    price = price.mul(PERCENTAGE_PRECISION.add(data.fee)).div(PERCENTAGE_PRECISION);\n', '    \t\t}\n', '    \t\tif (extraData.isCall) {\n', '    \t\t\tuint256 priceAdjusted = _getUnderlyingPriceAdjusted(data.underlyingPrice, data.underlyingPriceAdjustPercentage, false); \n', '    \t\t\tcollateralOnOpenPosition = price.mul(extraData.tokenAmount).div(priceAdjusted);\n', '    \t\t} else {\n', '    \t\t\tcollateralOnOpenPosition = price.mul(extraData.tokenAmount).div(data.underlyingPrecision);\n', '    \t\t}\n', '        } else {\n', '            collateralLockedRedeemable = collateralLocked;\n', '        }\n', '\t}\n', '\t\n', '\tfunction _getUnderlyingPriceAdjusted(uint256 underlyingPrice, uint256 underlyingPriceAdjustPercentage, bool isMaximum) private pure returns(uint256) {\n', '\t\tif (isMaximum) {\n', '\t\t\treturn underlyingPrice.mul(PERCENTAGE_PRECISION.add(underlyingPriceAdjustPercentage)).div(PERCENTAGE_PRECISION);\n', '\t\t} else {\n', '\t\t\treturn underlyingPrice.mul(PERCENTAGE_PRECISION.sub(underlyingPriceAdjustPercentage)).div(PERCENTAGE_PRECISION);\n', '\t\t}\n', '    }\n', '    \n', '    function _getPoolBalanceOf(address asset) private view returns(uint256) {\n', '        if (asset == address(0)) {\n', '            return address(this).balance;\n', '        } else {\n', '            (bool success, bytes memory returndata) = asset.staticcall(abi.encodeWithSelector(0x70a08231, address(this)));\n', '            require(success, "ACOPoolLib::_getAssetBalanceOf");\n', '            return abi.decode(returndata, (uint256));\n', '        }\n', '    }\n', '    \n', '    function _getAssetSymbol(address asset) private view returns(string memory) {\n', '        if (asset == address(0)) {\n', '            return "ETH";\n', '        } else {\n', '            (bool success, bytes memory returndata) = asset.staticcall(abi.encodeWithSelector(0x95d89b41));\n', '            require(success, "ACOPoolLib::_getAssetSymbol");\n', '            return abi.decode(returndata, (string));\n', '        }\n', '    }\n', '}']