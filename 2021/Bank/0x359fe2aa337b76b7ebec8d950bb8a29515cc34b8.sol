['pragma solidity 0.5.16;\n', '\n', 'import "./Ownable.sol";\n', 'import "./MorpherTradeEngine.sol";\n', 'import "./MorpherState.sol";\n', 'import "./SafeMath.sol";\n', '\n', '// ----------------------------------------------------------------------------------\n', '// Morpher Oracle contract v 2.0\n', '// The oracle initates a new trade by calling trade engine and requesting a new orderId.\n', '// An event is fired by the contract notifying the oracle operator to query a price/liquidation unchecked\n', '// for a market/user and return the information via the callback function. Since calling\n', '// the callback function requires gas, the user must send a fixed amount of Ether when\n', '// creating their order.\n', '// ----------------------------------------------------------------------------------\n', '\n', 'contract MorpherOracle is Ownable {\n', '\n', '    MorpherTradeEngine tradeEngine;\n', "    MorpherState state; // read only, Oracle doesn't need writing access to state\n", '\n', '    using SafeMath for uint256;\n', '\n', '    bool public paused;\n', '    bool public useWhiteList; //always false at the moment\n', '\n', '    uint256 public gasForCallback;\n', '\n', '    address payable public callBackCollectionAddress;\n', '\n', '    mapping(address => bool) public callBackAddress;\n', '    mapping(address => bool) public whiteList;\n', '    \n', '    mapping(bytes32 => uint256) public priceBelow;\n', '    mapping(bytes32 => uint256) public priceAbove;\n', '    mapping(bytes32 => uint256) public goodFrom;\n', '    mapping(bytes32 => uint256) public goodUntil;\n', '\n', '    mapping(bytes32 => bool) public orderCancellationRequested;\n', '\n', '    mapping(bytes32 => address) public orderIdTradeEngineAddress;\n', '    address public previousTradeEngineAddress;\n', '    address public previousOracleAddress;\n', '\n', '// ----------------------------------------------------------------------------------\n', '// Events\n', '// ----------------------------------------------------------------------------------\n', '    event OrderCreated(\n', '        bytes32 indexed _orderId,\n', '        address indexed _address,\n', '        bytes32 indexed _marketId,\n', '        uint256 _closeSharesAmount,\n', '        uint256 _openMPHTokenAmount,\n', '        bool _tradeDirection,\n', '        uint256 _orderLeverage,\n', '        uint256 _onlyIfPriceBelow,\n', '        uint256 _onlyIfPriceAbove,\n', '        uint256 _goodFrom,\n', '        uint256 _goodUntil\n', '        );\n', '\n', '    event LiquidationOrderCreated(\n', '        bytes32 indexed _orderId,\n', '        address _sender,\n', '        address indexed _address,\n', '        bytes32 indexed _marketId\n', '\n', '        );\n', '\n', '    event OrderProcessed(\n', '        bytes32 indexed _orderId,\n', '        uint256 _price,\n', '        uint256 _unadjustedMarketPrice,\n', '        uint256 _spread,\n', '        uint256 _positionLiquidationTimestamp,\n', '        uint256 _timeStamp,\n', '        uint256 _newLongShares,\n', '        uint256 _newShortShares,\n', '        uint256 _newMeanEntry,\n', '        uint256 _newMeanSprad,\n', '        uint256 _newMeanLeverage,\n', '        uint256 _liquidationPrice\n', '        );\n', '\n', '    event OrderFailed(\n', '        bytes32 indexed _orderId,\n', '        address indexed _address,\n', '        bytes32 indexed _marketId,\n', '        uint256 _closeSharesAmount,\n', '        uint256 _openMPHTokenAmount,\n', '        bool _tradeDirection,\n', '        uint256 _orderLeverage,\n', '        uint256 _onlyIfPriceBelow,\n', '        uint256 _onlyIfPriceAbove,\n', '        uint256 _goodFrom,\n', '        uint256 _goodUntil\n', '        );\n', '\n', '    event OrderCancelled(\n', '        bytes32 indexed _orderId,\n', '        address indexed _sender,\n', '        address indexed _oracleAddress\n', '        );\n', '    \n', '    event AdminOrderCancelled(\n', '        bytes32 indexed _orderId,\n', '        address indexed _sender,\n', '        address indexed _oracleAddress\n', '        );\n', '\n', '    event OrderCancellationRequestedEvent(\n', '        bytes32 indexed _orderId,\n', '        address indexed _sender\n', '        );\n', '\n', '    event CallbackAddressEnabled(\n', '        address indexed _address\n', '        );\n', '\n', '    event CallbackAddressDisabled(\n', '        address indexed _address\n', '        );\n', '\n', '    event OraclePaused(\n', '        bool _paused\n', '        );\n', '        \n', '    event CallBackCollectionAddressChange(\n', '        address _address\n', '        );\n', '\n', '    event SetGasForCallback(\n', '        uint256 _gasForCallback\n', '        );\n', '\n', '    event LinkTradeEngine(\n', '        address _address\n', '        );\n', '\n', '    event LinkMorpherState(\n', '        address _address\n', '        );\n', '\n', '    event SetUseWhiteList(\n', '        bool _useWhiteList\n', '        );\n', '\n', '    event AddressWhiteListed(\n', '        address _address\n', '        );\n', '\n', '    event AddressBlackListed(\n', '        address _address\n', '        );\n', '\n', '    event AdminLiquidationOrderCreated(\n', '        bytes32 indexed _orderId,\n', '        address indexed _address,\n', '        bytes32 indexed _marketId,\n', '        uint256 _closeSharesAmount,\n', '        uint256 _openMPHTokenAmount,\n', '        bool _tradeDirection,\n', '        uint256 _orderLeverage\n', '        );\n', '\n', '    /**\n', '     * Delisting markets is a function that stops when gas is running low\n', '     * if it reached all positions it will emit "DelistMarketComplete"\n', '     * otherwise it needs to be re-run.\n', '     */\n', '    event DelistMarketIncomplete(bytes32 _marketId, uint256 _processedUntilIndex);\n', '    event DelistMarketComplete(bytes32 _marketId);\n', '    event LockedPriceForClosingPositions(bytes32 _marketId, uint256 _price);\n', '\n', '\n', '    modifier onlyOracleOperator {\n', '        require(isCallbackAddress(msg.sender), "MorpherOracle: Only the oracle operator can call this function.");\n', '        _;\n', '    }\n', '\n', '    modifier onlyAdministrator {\n', '        require(msg.sender == state.getAdministrator(), "Function can only be called by the Administrator.");\n', '        _;\n', '    }\n', '\n', '    modifier notPaused {\n', '        require(paused == false, "MorpherOracle: Oracle paused, aborting");\n', '        _;\n', '    }\n', '\n', '   constructor(address _tradeEngineAddress, address _morpherState, address _callBackAddress, address payable _gasCollectionAddress, uint256 _gasForCallback, address _coldStorageOwnerAddress, address _previousTradeEngineAddress, address _previousOracleAddress) public {\n', '        setTradeEngineAddress(_tradeEngineAddress);\n', '        setStateAddress(_morpherState);\n', '        enableCallbackAddress(_callBackAddress);\n', '        setCallbackCollectionAddress(_gasCollectionAddress);\n', '        setGasForCallback(_gasForCallback);\n', '        transferOwnership(_coldStorageOwnerAddress);\n', '        previousTradeEngineAddress = _previousTradeEngineAddress; //that is the address before updating the trade engine. Can set to 0x0000 if a completely new deployment happens. It is only valid when mid-term updating the tradeengine\n', '        previousOracleAddress = _previousOracleAddress; //if we are updating the oracle, then this is the previous oracle address. Can be set to 0x00 if a completely new deployment happens.\n', '    }\n', '\n', '// ----------------------------------------------------------------------------------\n', '// Setter/getter functions for trade engine address, oracle operator (callback) address,\n', '// and prepaid gas limit for callback function\n', '// ----------------------------------------------------------------------------------\n', '    function setTradeEngineAddress(address _address) public onlyOwner {\n', '        tradeEngine = MorpherTradeEngine(_address);\n', '        emit LinkTradeEngine(_address);\n', '    }\n', '\n', '    function setStateAddress(address _address) public onlyOwner {\n', '        state = MorpherState(_address);\n', '        emit LinkMorpherState(_address);\n', '    }\n', '\n', '    function overrideGasForCallback(uint256 _gasForCallback) public onlyOwner {\n', '        gasForCallback = _gasForCallback;\n', '        emit SetGasForCallback(_gasForCallback);\n', '    }\n', '    \n', '    function setGasForCallback(uint256 _gasForCallback) private {\n', '        gasForCallback = _gasForCallback;\n', '        emit SetGasForCallback(_gasForCallback);\n', '    }\n', '\n', '    function enableCallbackAddress(address _address) public onlyOwner {\n', '        callBackAddress[_address] = true;\n', '        emit CallbackAddressEnabled(_address);\n', '    }\n', '\n', '    function disableCallbackAddress(address _address) public onlyOwner {\n', '        callBackAddress[_address] = false;\n', '        emit CallbackAddressDisabled(_address);\n', '    }\n', '\n', '    function isCallbackAddress(address _address) public view returns (bool _isCallBackAddress) {\n', '        return callBackAddress[_address];\n', '    }\n', '\n', '    function setCallbackCollectionAddress(address payable _address) public onlyOwner {\n', '        callBackCollectionAddress = _address;\n', '        emit CallBackCollectionAddressChange(_address);\n', '    }\n', '\n', '    function getAdministrator() public view returns(address _administrator) {\n', '        return state.getAdministrator();\n', '    }\n', '\n', '// ----------------------------------------------------------------------------------\n', '// Oracle Owner can use a whitelist and authorize individual addresses\n', '// ----------------------------------------------------------------------------------\n', '    function setUseWhiteList(bool _useWhiteList) public onlyOracleOperator {\n', '        require(false, "MorpherOracle: Cannot use this functionality in the oracle at the moment");\n', '        useWhiteList = _useWhiteList;\n', '        emit SetUseWhiteList(_useWhiteList);\n', '    }\n', '\n', '    function setWhiteList(address _whiteList) public onlyOracleOperator {\n', '        whiteList[_whiteList] = true;\n', '        emit AddressWhiteListed(_whiteList);\n', '    }\n', '\n', '    function setBlackList(address _blackList) public onlyOracleOperator {\n', '        whiteList[_blackList] = false;\n', '        emit AddressBlackListed(_blackList);\n', '    }\n', '\n', '    function isWhiteListed(address _address) public view returns (bool _whiteListed) {\n', '        if (useWhiteList == false ||  whiteList[_address] == true) {\n', '            _whiteListed = true;\n', '        }\n', '        return(_whiteListed);\n', '    }\n', '\n', '// ----------------------------------------------------------------------------------\n', '// emitOrderFailed\n', '// Can be called by Oracle Operator to notifiy user of failed order\n', '// ----------------------------------------------------------------------------------\n', '    function emitOrderFailed(\n', '        bytes32 _orderId,\n', '        address _address,\n', '        bytes32 _marketId,\n', '        uint256 _closeSharesAmount,\n', '        uint256 _openMPHTokenAmount,\n', '        bool _tradeDirection,\n', '        uint256 _orderLeverage,\n', '        uint256 _onlyIfPriceBelow,\n', '        uint256 _onlyIfPriceAbove,\n', '        uint256 _goodFrom,\n', '        uint256 _goodUntil\n', '    ) public onlyOracleOperator {\n', '        emit OrderFailed(\n', '            _orderId,\n', '            _address,\n', '            _marketId,\n', '            _closeSharesAmount,\n', '            _openMPHTokenAmount,\n', '            _tradeDirection,\n', '            _orderLeverage,\n', '            _onlyIfPriceBelow,\n', '            _onlyIfPriceAbove,\n', '            _goodFrom,\n', '            _goodUntil);\n', '    }\n', '\n', '// ----------------------------------------------------------------------------------\n', '// createOrder(bytes32  _marketId, bool _tradeAmountGivenInShares, uint256 _tradeAmount, bool _tradeDirection, uint256 _orderLeverage)\n', '// Request a new orderId from trade engine and fires event for price/liquidation check request.\n', '// ----------------------------------------------------------------------------------\n', '    function createOrder(\n', '        bytes32 _marketId,\n', '        uint256 _closeSharesAmount,\n', '        uint256 _openMPHTokenAmount,\n', '        bool _tradeDirection,\n', '        uint256 _orderLeverage,\n', '        uint256 _onlyIfPriceAbove,\n', '        uint256 _onlyIfPriceBelow,\n', '        uint256 _goodUntil,\n', '        uint256 _goodFrom\n', '        ) public payable notPaused returns (bytes32 _orderId) {\n', '        require(isWhiteListed(msg.sender),"MorpherOracle: Address not eligible to create an order.");\n', '        if (gasForCallback > 0) {\n', '            require(msg.value >= gasForCallback, "MorpherOracle: Must transfer gas costs for Oracle Callback function.");\n', '            callBackCollectionAddress.transfer(msg.value);\n', '        }\n', '        _orderId = tradeEngine.requestOrderId(msg.sender, _marketId, _closeSharesAmount, _openMPHTokenAmount, _tradeDirection, _orderLeverage);\n', '        orderIdTradeEngineAddress[_orderId] = address(tradeEngine);\n', '\n', "        //if the market was deactivated, and the trader didn't fail yet, then we got an orderId to close the position with a locked in price\n", '        if(state.getMarketActive(_marketId) == false) {\n', '\n', '            //price will come from the position where price is stored forever\n', '            tradeEngine.processOrder(_orderId, tradeEngine.getDeactivatedMarketPrice(_marketId), 0, 0, now.mul(1000));\n', '            \n', '            emit OrderProcessed(\n', '                _orderId,\n', '                tradeEngine.getDeactivatedMarketPrice(_marketId),\n', '                0,\n', '                0,\n', '                0,\n', '                now.mul(1000),\n', '                0,\n', '                0,\n', '                0,\n', '                0,\n', '                0,\n', '                0\n', '                );\n', '        } else {\n', '            priceAbove[_orderId] = _onlyIfPriceAbove;\n', '            priceBelow[_orderId] = _onlyIfPriceBelow;\n', '            goodFrom[_orderId]   = _goodFrom;\n', '            goodUntil[_orderId]  = _goodUntil;\n', '            emit OrderCreated(\n', '                _orderId,\n', '                msg.sender,\n', '                _marketId,\n', '                _closeSharesAmount,\n', '                _openMPHTokenAmount,\n', '                _tradeDirection,\n', '                _orderLeverage,\n', '                _onlyIfPriceBelow,\n', '                _onlyIfPriceAbove,\n', '                _goodFrom,\n', '                _goodUntil\n', '                );\n', '        }\n', '\n', '        return _orderId;\n', '    }\n', '\n', '    function getTradeEngineFromOrderId(bytes32 _orderId) public view returns (address) {\n', '        //get the current trade engine\n', '        if(orderIdTradeEngineAddress[_orderId] != address(0)){\n', '            return orderIdTradeEngineAddress[_orderId];\n', '        }\n', '\n', '        //todo for later\n', "        //we can't do recursively call the oracle.getTradeEngineFromOrderId here, because the previously deployed oracle\n", "        //doesn't have this function yet. We can uncomment this in later updates of the oracle\n", '        // if(previousOracleAddress !== address(0)) {\n', '        //     MorpherOracle _oracle = MorpherOracle(previousOracleAddress)\n', '        //     return _oracle.getTradeEngineFromOrderId(_orderId);\n', '        // }\n', '\n', '        //nothing in there, take the previous tradeEngine then.\n', '        return previousTradeEngineAddress;\n', '    }\n', '\n', '    function initiateCancelOrder(bytes32 _orderId) public {\n', '        MorpherTradeEngine _tradeEngine = MorpherTradeEngine(getTradeEngineFromOrderId(_orderId));\n', '        require(orderCancellationRequested[_orderId] == false, "MorpherOracle: Order was already canceled.");\n', '        (address userId, , , , , , ) = _tradeEngine.getOrder(_orderId);\n', '        require(userId == msg.sender, "MorpherOracle: Only the user can request an order cancellation.");\n', '        orderCancellationRequested[_orderId] = true;\n', '        emit OrderCancellationRequestedEvent(_orderId, msg.sender);\n', '\n', '    }\n', '    // ----------------------------------------------------------------------------------\n', '    // cancelOrder(bytes32  _orderId)\n', '    // User or Administrator can cancel their own orders before the _callback has been executed\n', '    // ----------------------------------------------------------------------------------\n', '    function cancelOrder(bytes32 _orderId) public onlyOracleOperator {\n', '        require(orderCancellationRequested[_orderId] == true, "MorpherOracle: Order-Cancellation was not requested.");\n', '        MorpherTradeEngine _tradeEngine = MorpherTradeEngine(getTradeEngineFromOrderId(_orderId));\n', '        (address userId, , , , , , ) = _tradeEngine.getOrder(_orderId);\n', '        _tradeEngine.cancelOrder(_orderId, userId);\n', '        clearOrderConditions(_orderId);\n', '        emit OrderCancelled(\n', '            _orderId,\n', '            userId,\n', '            msg.sender\n', '            );\n', '    }\n', '    \n', '    // ----------------------------------------------------------------------------------\n', '    // adminCancelOrder(bytes32  _orderId)\n', '    // Administrator can cancel before the _callback has been executed to provide an updateOrder functionality\n', '    // ----------------------------------------------------------------------------------\n', '    function adminCancelOrder(bytes32 _orderId) public onlyOracleOperator {\n', '        MorpherTradeEngine _tradeEngine = MorpherTradeEngine(getTradeEngineFromOrderId(_orderId));\n', '        (address userId, , , , , , ) = _tradeEngine.getOrder(_orderId);\n', '        _tradeEngine.cancelOrder(_orderId, userId);\n', '        clearOrderConditions(_orderId);\n', '        emit AdminOrderCancelled(\n', '            _orderId,\n', '            userId,\n', '            msg.sender\n', '            );\n', '    }\n', '\n', '    function getGoodUntil(bytes32 _orderId) public view returns(uint) {\n', '        if(goodUntil[_orderId] > 0) {\n', '            return goodUntil[_orderId];\n', '        }\n', '\n', '        //just return the old one\n', '        if(previousOracleAddress != address(0)) {\n', '            MorpherOracle _oldOracle = MorpherOracle(previousOracleAddress);\n', '            return _oldOracle.goodUntil(_orderId);\n', '        }\n', '\n', '        return 0;\n', '    }\n', '    function getGoodFrom(bytes32 _orderId) public view returns(uint) {\n', '        if(goodFrom[_orderId] > 0) {\n', '            return goodFrom[_orderId];\n', '        }\n', '\n', '        //just return the old one\n', '        if(previousOracleAddress != address(0)) {\n', '            MorpherOracle _oldOracle = MorpherOracle(previousOracleAddress);\n', '            return _oldOracle.goodFrom(_orderId);\n', '        }\n', '        return 0;\n', '    }\n', '    function getPriceAbove(bytes32 _orderId) public view returns(uint) {\n', '        if(priceAbove[_orderId] > 0) {\n', '            return priceAbove[_orderId];\n', '        }\n', '\n', '        //just return the old one\n', '        if(previousOracleAddress != address(0)) {\n', '            MorpherOracle _oldOracle = MorpherOracle(previousOracleAddress);\n', '            return _oldOracle.priceAbove(_orderId);\n', '        }\n', '        return 0;\n', '    }\n', '    function getPriceBelow(bytes32 _orderId) public view returns(uint) {\n', '        if(priceBelow[_orderId] > 0) {\n', '            return priceBelow[_orderId];\n', '        }\n', '\n', '        //just return the old one\n', '        if(previousOracleAddress != address(0)) {\n', '            MorpherOracle _oldOracle = MorpherOracle(previousOracleAddress);\n', '            return _oldOracle.priceBelow(_orderId);\n', '        }\n', '        return 0;\n', '    }\n', '\n', '// ------------------------------------------------------------------------\n', '// checkOrderConditions(bytes32 _orderId, uint256 _price)\n', '// Checks if callback satisfies the order conditions\n', '// ------------------------------------------------------------------------\n', '    function checkOrderConditions(bytes32 _orderId, uint256 _price) public view returns (bool _conditionsMet) {\n', '        _conditionsMet = true;\n', '        if (now > getGoodUntil(_orderId) && getGoodUntil(_orderId) > 0) {\n', '            _conditionsMet = false;\n', '        }\n', '        if (now < getGoodFrom(_orderId) && getGoodFrom(_orderId) > 0) {\n', '            _conditionsMet = false;\n', '        }\n', '\n', '        if(getPriceAbove(_orderId) > 0 && getPriceBelow(_orderId) > 0) {\n', '            if(_price < getPriceAbove(_orderId) && _price > getPriceBelow(_orderId)) {\n', '                _conditionsMet = false;\n', '            }\n', '        } else {\n', '            if (_price < getPriceAbove(_orderId) && getPriceAbove(_orderId) > 0) {\n', '                _conditionsMet = false;\n', '            }\n', '            if (_price > getPriceBelow(_orderId) && getPriceBelow(_orderId) > 0) {\n', '                _conditionsMet = false;\n', '            }\n', '        }\n', '        \n', '        return _conditionsMet;\n', '    }\n', '\n', '// ----------------------------------------------------------------------------------\n', '// Deletes parameters of cancelled or processed orders\n', '// ----------------------------------------------------------------------------------\n', '    function clearOrderConditions(bytes32 _orderId) internal {\n', '        priceAbove[_orderId] = 0;\n', '        priceBelow[_orderId] = 0;\n', '        goodFrom[_orderId]   = 0;\n', '        goodUntil[_orderId]  = 0;\n', '    }\n', '\n', '// ----------------------------------------------------------------------------------\n', '// Pausing/unpausing the Oracle contract\n', '// ----------------------------------------------------------------------------------\n', '    function pauseOracle() public onlyOwner {\n', '        paused = true;\n', '        emit OraclePaused(true);\n', '    }\n', '\n', '    function unpauseOracle() public onlyOwner {\n', '        paused = false;\n', '        emit OraclePaused(false);\n', '    }\n', '\n', '// ----------------------------------------------------------------------------------\n', '// createLiquidationOrder(address _address, bytes32 _marketId)\n', '// Checks if position has been liquidated since last check. Requires gas for callback\n', '// function. Anyone can issue a liquidation order for any other address and market.\n', '// ----------------------------------------------------------------------------------\n', '    function createLiquidationOrder(\n', '        address _address,\n', '        bytes32 _marketId\n', '        ) public notPaused onlyOracleOperator payable returns (bytes32 _orderId) {\n', '        if (gasForCallback > 0) {\n', '            require(msg.value >= gasForCallback, "MorpherOracle: Must transfer gas costs for Oracle Callback function.");\n', '            callBackCollectionAddress.transfer(msg.value);\n', '        }\n', '        _orderId = tradeEngine.requestOrderId(_address, _marketId, 0, 0, true, 10**8);\n', '        orderIdTradeEngineAddress[_orderId] = address(tradeEngine);\n', '        emit LiquidationOrderCreated(_orderId, msg.sender, _address, _marketId);\n', '        return _orderId;\n', '    }\n', '\n', '// ----------------------------------------------------------------------------------\n', '// __callback(bytes32 _orderId, uint256 _price, uint256 _spread, uint256 _liquidationTimestamp, uint256 _timeStamp)\n', '// Called by the oracle operator. Writes price/spread/liquidiation check to the blockchain.\n', '// Trade engine processes the order and updates the portfolio in state if successful.\n', '// ----------------------------------------------------------------------------------\n', '    function __callback(\n', '        bytes32 _orderId,\n', '        uint256 _price,\n', '        uint256 _unadjustedMarketPrice,\n', '        uint256 _spread,\n', '        uint256 _liquidationTimestamp,\n', '        uint256 _timeStamp,\n', '        uint256 _gasForNextCallback\n', '        ) public onlyOracleOperator notPaused returns (uint256 _newLongShares, uint256 _newShortShares, uint256 _newMeanEntry, uint256 _newMeanSpread, uint256 _newMeanLeverage, uint256 _liquidationPrice)  {\n', '        \n', "        require(checkOrderConditions(_orderId, _price), 'MorpherOracle Error: Order Conditions are not met');\n", '       \n', '       MorpherTradeEngine _tradeEngine = MorpherTradeEngine(getTradeEngineFromOrderId(_orderId));\n', '        (\n', '            _newLongShares,\n', '            _newShortShares,\n', '            _newMeanEntry,\n', '            _newMeanSpread,\n', '            _newMeanLeverage,\n', '            _liquidationPrice\n', '        ) = _tradeEngine.processOrder(_orderId, _price, _spread, _liquidationTimestamp, _timeStamp);\n', '        \n', '        clearOrderConditions(_orderId);\n', '        emit OrderProcessed(\n', '            _orderId,\n', '            _price,\n', '            _unadjustedMarketPrice,\n', '            _spread,\n', '            _liquidationTimestamp,\n', '            _timeStamp,\n', '            _newLongShares,\n', '            _newShortShares,\n', '            _newMeanEntry,\n', '            _newMeanSpread,\n', '            _newMeanLeverage,\n', '            _liquidationPrice\n', '            );\n', '        setGasForCallback(_gasForNextCallback);\n', '        return (_newLongShares, _newShortShares, _newMeanEntry, _newMeanSpread, _newMeanLeverage, _liquidationPrice);\n', '    }\n', '\n', '// ----------------------------------------------------------------------------------\n', '// delistMarket(bytes32 _marketId)\n', '// Administrator closes out all existing positions on _marketId market at current prices\n', '// ----------------------------------------------------------------------------------\n', '\n', '    uint delistMarketFromIx = 0;\n', '    function delistMarket(bytes32 _marketId, bool _startFromScratch) public onlyAdministrator {\n', '        require(state.getMarketActive(_marketId) == true, "Market must be active to process position liquidations.");\n', '        // If no _fromIx and _toIx specified, do entire _list\n', '        if (_startFromScratch) {\n', '            delistMarketFromIx = 0;\n', '        }\n', '        \n', '        uint _toIx = state.getMaxMappingIndex(_marketId);\n', '        \n', '        address _address;\n', '        for (uint256 i = delistMarketFromIx; i <= _toIx; i++) {\n', "             if(gasleft() < 250000 && i != _toIx) { //stop if there's not enough gas to write the next transaction\n", '                delistMarketFromIx = i;\n', '                emit DelistMarketIncomplete(_marketId, _toIx);\n', '                return;\n', '            } \n', '            \n', '            _address = state.getExposureMappingAddress(_marketId, i);\n', '            adminLiquidationOrder(_address, _marketId);\n', '            \n', '        }\n', '        emit DelistMarketComplete(_marketId);\n', '    }\n', '\n', '    /**\n', '     * Course of action would be:\n', '     * 1. de-activate market through state\n', '     * 2. set the Deactivated Market Price\n', '     * 3. let users still close their positions\n', '     */\n', '    function setDeactivatedMarketPrice(bytes32 _marketId, uint256 _price) public onlyAdministrator {\n', '        //todo updateable tradeEngine\n', '        tradeEngine.setDeactivatedMarketPrice(_marketId, _price);\n', '        emit LockedPriceForClosingPositions(_marketId, _price);\n', '\n', '    }\n', '\n', '// ----------------------------------------------------------------------------------\n', '// adminLiquidationOrder(address _address, bytes32 _marketId)\n', '// Administrator closes out an existing position of _address on _marketId market at current price\n', '// ----------------------------------------------------------------------------------\n', '    function adminLiquidationOrder(\n', '        address _address,\n', '        bytes32 _marketId\n', '        ) public onlyAdministrator returns (bytes32 _orderId) {\n', '            uint256 _positionLongShares = state.getLongShares(_address, _marketId);\n', '            uint256 _positionShortShares = state.getShortShares(_address, _marketId);\n', '            if (_positionLongShares > 0) {\n', '                _orderId = tradeEngine.requestOrderId(_address, _marketId, _positionLongShares, 0, false, 10**8);\n', '                emit AdminLiquidationOrderCreated(_orderId, _address, _marketId, _positionLongShares, 0, false, 10**8);\n', '            }\n', '            if (_positionShortShares > 0) {\n', '                _orderId = tradeEngine.requestOrderId(_address, _marketId, _positionShortShares, 0, true, 10**8);\n', '                emit AdminLiquidationOrderCreated(_orderId, _address, _marketId, _positionShortShares, 0, true, 10**8);\n', '            }\n', '            orderIdTradeEngineAddress[_orderId] = address(tradeEngine);\n', '            return _orderId;\n', '    }\n', '    \n', '// ----------------------------------------------------------------------------------\n', '// Auxiliary function to hash a string market name i.e.\n', '// "CRYPTO_BTC" => 0x0bc89e95f9fdaab7e8a11719155f2fd638cb0f665623f3d12aab71d1a125daf9;\n', '// ----------------------------------------------------------------------------------\n', '    function stringToHash(string memory _source) public pure returns (bytes32 _result) {\n', '        return keccak256(abi.encodePacked(_source));\n', '    }\n', '}']