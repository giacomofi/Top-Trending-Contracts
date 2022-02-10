['pragma solidity ^0.4.18;\n', '\n', '/**\n', '* @title SafeMath\n', '* @dev Math operations with safety checks that throw on error\n', '*/\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract ERC20Interface {\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed from, address indexed spender, uint256 value);\n', '    string public symbol;\n', '\n', '    function totalSupply() constant returns (uint256 supply);\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '}\n', '\n', '/// @title ServiceAllowance.\n', '///\n', '/// Provides a way to delegate operation allowance decision to a service contract\n', 'contract ServiceAllowance {\n', '    function isTransferAllowed(address _from, address _to, address _sender, address _token, uint _value) public view returns (bool);\n', '}\n', '\n', '/// @title DepositWalletInterface\n', '///\n', '/// Defines an interface for a wallet that can be deposited/withdrawn by 3rd contract\n', 'contract DepositWalletInterface {\n', '    function deposit(address _asset, address _from, uint256 amount) public returns (uint);\n', '    function withdraw(address _asset, address _to, uint256 amount) public returns (uint);\n', '}\n', '\n', '/**\n', ' * @title Owned contract with safe ownership pass.\n', ' *\n', ' * Note: all the non constant functions return false instead of throwing in case if state change\n', ' * didn&#39;t happen yet.\n', ' */\n', 'contract Owned {\n', '    /**\n', '     * Contract owner address\n', '     */\n', '    address public contractOwner;\n', '\n', '    /**\n', '     * Contract owner address\n', '     */\n', '    address public pendingContractOwner;\n', '\n', '    function Owned() {\n', '        contractOwner = msg.sender;\n', '    }\n', '\n', '    /**\n', '    * @dev Owner check modifier\n', '    */\n', '    modifier onlyContractOwner() {\n', '        if (contractOwner == msg.sender) {\n', '            _;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Destroy contract and scrub a data\n', '     * @notice Only owner can call it\n', '     */\n', '    function destroy() onlyContractOwner {\n', '        suicide(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * Prepares ownership pass.\n', '     *\n', '     * Can only be called by current owner.\n', '     *\n', '     * @param _to address of the next owner. 0x0 is not allowed.\n', '     *\n', '     * @return success.\n', '     */\n', '    function changeContractOwnership(address _to) onlyContractOwner() returns(bool) {\n', '        if (_to  == 0x0) {\n', '            return false;\n', '        }\n', '\n', '        pendingContractOwner = _to;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Finalize ownership pass.\n', '     *\n', '     * Can only be called by pending owner.\n', '     *\n', '     * @return success.\n', '     */\n', '    function claimContractOwnership() returns(bool) {\n', '        if (pendingContractOwner != msg.sender) {\n', '            return false;\n', '        }\n', '\n', '        contractOwner = pendingContractOwner;\n', '        delete pendingContractOwner;\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Generic owned destroyable contract\n', ' */\n', 'contract Object is Owned {\n', '    /**\n', '    *  Common result code. Means everything is fine.\n', '    */\n', '    uint constant OK = 1;\n', '    uint constant OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER = 8;\n', '\n', '    function withdrawnTokens(address[] tokens, address _to) onlyContractOwner returns(uint) {\n', '        for(uint i=0;i<tokens.length;i++) {\n', '            address token = tokens[i];\n', '            uint balance = ERC20Interface(token).balanceOf(this);\n', '            if(balance != 0)\n', '                ERC20Interface(token).transfer(_to,balance);\n', '        }\n', '        return OK;\n', '    }\n', '\n', '    function checkOnlyContractOwner() internal constant returns(uint) {\n', '        if (contractOwner == msg.sender) {\n', '            return OK;\n', '        }\n', '\n', '        return OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER;\n', '    }\n', '}\n', '\n', 'contract OracleContractAdapter is Object {\n', '\n', '    event OracleAdded(address _oracle);\n', '    event OracleRemoved(address _oracle);\n', '\n', '    mapping(address => bool) public oracles;\n', '\n', '    /// @dev Allow access only for oracle\n', '    modifier onlyOracle {\n', '        if (oracles[msg.sender]) {\n', '            _;\n', '        }\n', '    }\n', '\n', '    modifier onlyOracleOrOwner {\n', '        if (oracles[msg.sender] || msg.sender == contractOwner) {\n', '            _;\n', '        }\n', '    }\n', '\n', '    /// @notice Add oracles to whitelist.\n', '    ///\n', '    /// @param _whitelist user list.\n', '    function addOracles(address[] _whitelist) external onlyContractOwner returns (uint)    {\n', '        for (uint _idx = 0; _idx < _whitelist.length; ++_idx) {\n', '            address _oracle = _whitelist[_idx];\n', '            if (!oracles[_oracle]) {\n', '                oracles[_oracle] = true;\n', '                _emitOracleAdded(_oracle);\n', '            }\n', '        }\n', '        return OK;\n', '    }\n', '\n', '    /// @notice Removes oracles from whitelist.\n', '    ///\n', '    /// @param _blacklist user in whitelist.\n', '    function removeOracles(address[] _blacklist) external onlyContractOwner returns (uint)    {\n', '        for (uint _idx = 0; _idx < _blacklist.length; ++_idx) {\n', '            address _oracle = _blacklist[_idx];\n', '            if (oracles[_oracle]) {\n', '                delete oracles[_oracle];\n', '                _emitOracleRemoved(_oracle);\n', '            }\n', '        }\n', '        return OK;\n', '    }\n', '\n', '    function _emitOracleAdded(address _oracle) internal {\n', '        OracleAdded(_oracle);\n', '    }\n', '\n', '    function _emitOracleRemoved(address _oracle) internal {\n', '        OracleRemoved(_oracle);\n', '    }\n', '}\n', '\n', 'contract ProfiteroleEmitter {\n', '\n', '    event DepositPendingAdded(uint amount, address from, uint timestamp);\n', '    event BonusesWithdrawn(bytes32 userKey, uint amount, uint timestamp);\n', '\n', '    event Error(uint errorCode);\n', '\n', '    function _emitError(uint _errorCode) internal returns (uint) {\n', '        Error(_errorCode);\n', '        return _errorCode;\n', '    }\n', '}\n', '\n', 'contract TreasuryEmitter {\n', '    event TreasuryDeposited(bytes32 userKey, uint value, uint lockupDate);\n', '    event TreasuryWithdrawn(bytes32 userKey, uint value);\n', '}\n', '\n', 'contract ERC20 {\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed from, address indexed spender, uint256 value);\n', '    string public symbol;\n', '\n', '    function totalSupply() constant returns (uint256 supply);\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '}\n', '\n', '\n', '\n', '\n', '\n', '/// @title Treasury contract.\n', '///\n', '/// Treasury for CCs deposits for particular fund with bmc-days calculations.\n', '/// Accept BMC deposits from Continuous Contributors via oracle and\n', '/// calculates bmc-days metric for each CC&#39;s role.\n', 'contract Treasury is OracleContractAdapter, ServiceAllowance, TreasuryEmitter {\n', '\n', '    /* ERROR CODES */\n', '\n', '    uint constant PERCENT_PRECISION = 10000;\n', '\n', '    uint constant TREASURY_ERROR_SCOPE = 108000;\n', '    uint constant TREASURY_ERROR_TOKEN_NOT_SET_ALLOWANCE = TREASURY_ERROR_SCOPE + 1;\n', '\n', '    using SafeMath for uint;\n', '\n', '    struct LockedDeposits {\n', '        uint counter;\n', '        mapping(uint => uint) index2Date;\n', '        mapping(uint => uint) date2deposit;\n', '    }\n', '\n', '    struct Period {\n', '        uint transfersCount;\n', '        uint totalBmcDays;\n', '        uint bmcDaysPerDay;\n', '        uint startDate;\n', '        mapping(bytes32 => uint) user2bmcDays;\n', '        mapping(bytes32 => uint) user2lastTransferIdx;\n', '        mapping(bytes32 => uint) user2balance;\n', '        mapping(uint => uint) transfer2date;\n', '    }\n', '\n', '    /* FIELDS */\n', '\n', '    address token;\n', '    address profiterole;\n', '    uint periodsCount;\n', '\n', '    mapping(uint => Period) periods;\n', '    mapping(uint => uint) periodDate2periodIdx;\n', '    mapping(bytes32 => uint) user2lastPeriodParticipated;\n', '    mapping(bytes32 => LockedDeposits) user2lockedDeposits;\n', '\n', '    /* MODIFIERS */\n', '\n', '    /// @dev Only profiterole contract allowed to invoke guarded functions\n', '    modifier onlyProfiterole {\n', '        require(profiterole == msg.sender);\n', '        _;\n', '    }\n', '\n', '    /* PUBLIC */\n', '    \n', '    function Treasury(address _token) public {\n', '        require(address(_token) != 0x0);\n', '        token = _token;\n', '        periodsCount = 1;\n', '    }\n', '\n', '    function init(address _profiterole) public onlyContractOwner returns (uint) {\n', '        require(_profiterole != 0x0);\n', '        profiterole = _profiterole;\n', '        return OK;\n', '    }\n', '\n', '    /// @notice Do not accept Ether transfers\n', '    function() payable public {\n', '        revert();\n', '    }\n', '\n', '    /* EXTERNAL */\n', '\n', '    /// @notice Deposits tokens on behalf of users\n', '    /// Allowed only for oracle.\n', '    ///\n', '    /// @param _userKey aggregated user key (user ID + role ID)\n', '    /// @param _value amount of tokens to deposit\n', '    /// @param _feeAmount amount of tokens that will be taken from _value as fee\n', '    /// @param _feeAddress destination address for fee transfer\n', '    /// @param _lockupDate lock up date for deposit. Until that date the deposited value couldn&#39;t be withdrawn\n', '    ///\n', '    /// @return result code of an operation\n', '    function deposit(bytes32 _userKey, uint _value, uint _feeAmount, address _feeAddress, uint _lockupDate) external onlyOracle returns (uint) {\n', '        require(_userKey != bytes32(0));\n', '        require(_value != 0);\n', '        require(_feeAmount < _value);\n', '\n', '        ERC20 _token = ERC20(token);\n', '        if (_token.allowance(msg.sender, address(this)) < _value) {\n', '            return TREASURY_ERROR_TOKEN_NOT_SET_ALLOWANCE;\n', '        }\n', '\n', '        uint _depositedAmount = _value - _feeAmount;\n', '        _makeDepositForPeriod(_userKey, _depositedAmount, _lockupDate);\n', '\n', '        uint _periodsCount = periodsCount;\n', '        user2lastPeriodParticipated[_userKey] = _periodsCount;\n', '        delete periods[_periodsCount].startDate;\n', '\n', '        if (!_token.transferFrom(msg.sender, address(this), _value)) {\n', '            revert();\n', '        }\n', '\n', '        if (!(_feeAddress == 0x0 || _feeAmount == 0 || _token.transfer(_feeAddress, _feeAmount))) {\n', '            revert();\n', '        }\n', '\n', '        TreasuryDeposited(_userKey, _depositedAmount, _lockupDate);\n', '        return OK;\n', '    }\n', '\n', '    /// @notice Withdraws deposited tokens on behalf of users\n', '    /// Allowed only for oracle\n', '    ///\n', '    /// @param _userKey aggregated user key (user ID + role ID)\n', '    /// @param _value an amount of tokens that is requrested to withdraw\n', '    /// @param _withdrawAddress address to withdraw; should not be 0x0\n', '    /// @param _feeAmount amount of tokens that will be taken from _value as fee\n', '    /// @param _feeAddress destination address for fee transfer\n', '    ///\n', '    /// @return result of an operation\n', '    function withdraw(bytes32 _userKey, uint _value, address _withdrawAddress, uint _feeAmount, address _feeAddress) external onlyOracle returns (uint) {\n', '        require(_userKey != bytes32(0));\n', '        require(_value != 0);\n', '        require(_feeAmount < _value);\n', '\n', '        _makeWithdrawForPeriod(_userKey, _value);\n', '        uint _periodsCount = periodsCount;\n', '        user2lastPeriodParticipated[_userKey] = periodsCount;\n', '        delete periods[_periodsCount].startDate;\n', '\n', '        ERC20 _token = ERC20(token);\n', '        if (!(_feeAddress == 0x0 || _feeAmount == 0 || _token.transfer(_feeAddress, _feeAmount))) {\n', '            revert();\n', '        }\n', '\n', '        uint _withdrawnAmount = _value - _feeAmount;\n', '        if (!_token.transfer(_withdrawAddress, _withdrawnAmount)) {\n', '            revert();\n', '        }\n', '\n', '        TreasuryWithdrawn(_userKey, _withdrawnAmount);\n', '        return OK;\n', '    }\n', '\n', '    /// @notice Gets shares (in percents) the user has on provided date\n', '    ///\n', '    /// @param _userKey aggregated user key (user ID + role ID)\n', '    /// @param _date date where period ends\n', '    ///\n', '    /// @return percent from total amount of bmc-days the treasury has on this date.\n', '    /// Use PERCENT_PRECISION to get right precision\n', '    function getSharesPercentForPeriod(bytes32 _userKey, uint _date) public view returns (uint) {\n', '        uint _periodIdx = periodDate2periodIdx[_date];\n', '        if (_date != 0 && _periodIdx == 0) {\n', '            return 0;\n', '        }\n', '\n', '        if (_date == 0) {\n', '            _date = now;\n', '            _periodIdx = periodsCount;\n', '        }\n', '\n', '        uint _bmcDays = _getBmcDaysAmountForUser(_userKey, _date, _periodIdx);\n', '        uint _totalBmcDeposit = _getTotalBmcDaysAmount(_date, _periodIdx);\n', '        return _totalBmcDeposit != 0 ? _bmcDays * PERCENT_PRECISION / _totalBmcDeposit : 0;\n', '    }\n', '\n', '    /// @notice Gets user balance that is deposited\n', '    /// @param _userKey aggregated user key (user ID + role ID)\n', '    /// @return an amount of tokens deposited on behalf of user\n', '    function getUserBalance(bytes32 _userKey) public view returns (uint) {\n', '        uint _lastPeriodForUser = user2lastPeriodParticipated[_userKey];\n', '        if (_lastPeriodForUser == 0) {\n', '            return 0;\n', '        }\n', '\n', '        if (_lastPeriodForUser <= periodsCount.sub(1)) {\n', '            return periods[_lastPeriodForUser].user2balance[_userKey];\n', '        }\n', '\n', '        return periods[periodsCount].user2balance[_userKey];\n', '    }\n', '\n', '    /// @notice Gets amount of locked deposits for user\n', '    /// @param _userKey aggregated user key (user ID + role ID)\n', '    /// @return an amount of tokens locked\n', '    function getLockedUserBalance(bytes32 _userKey) public returns (uint) {\n', '        return _syncLockedDepositsAmount(_userKey);\n', '    }\n', '\n', '    /// @notice Gets list of locked up deposits with dates when they will be available to withdraw\n', '    /// @param _userKey aggregated user key (user ID + role ID)\n', '    /// @return {\n', '    ///     "_lockupDates": "list of lockup dates of deposits",\n', '    ///     "_deposits": "list of deposits"\n', '    /// }\n', '    function getLockedUserDeposits(bytes32 _userKey) public view returns (uint[] _lockupDates, uint[] _deposits) {\n', '        LockedDeposits storage _lockedDeposits = user2lockedDeposits[_userKey];\n', '        uint _lockedDepositsCounter = _lockedDeposits.counter;\n', '        _lockupDates = new uint[](_lockedDepositsCounter);\n', '        _deposits = new uint[](_lockedDepositsCounter);\n', '\n', '        uint _pointer = 0;\n', '        for (uint _idx = 1; _idx < _lockedDepositsCounter; ++_idx) {\n', '            uint _lockDate = _lockedDeposits.index2Date[_idx];\n', '\n', '            if (_lockDate > now) {\n', '                _lockupDates[_pointer] = _lockDate;\n', '                _deposits[_pointer] = _lockedDeposits.date2deposit[_lockDate];\n', '                ++_pointer;\n', '            }\n', '        }\n', '    }\n', '\n', '    /// @notice Gets total amount of bmc-day accumulated due provided date\n', '    /// @param _date date where period ends\n', '    /// @return an amount of bmc-days\n', '    function getTotalBmcDaysAmount(uint _date) public view returns (uint) {\n', '        return _getTotalBmcDaysAmount(_date, periodsCount);\n', '    }\n', '\n', '    /// @notice Makes a checkpoint to start counting a new period\n', '    /// @dev Should be used only by Profiterole contract\n', '    function addDistributionPeriod() public onlyProfiterole returns (uint) {\n', '        uint _periodsCount = periodsCount;\n', '        uint _nextPeriod = _periodsCount.add(1);\n', '        periodDate2periodIdx[now] = _periodsCount;\n', '\n', '        Period storage _previousPeriod = periods[_periodsCount];\n', '        uint _totalBmcDeposit = _getTotalBmcDaysAmount(now, _periodsCount);\n', '        periods[_nextPeriod].startDate = now;\n', '        periods[_nextPeriod].bmcDaysPerDay = _previousPeriod.bmcDaysPerDay;\n', '        periods[_nextPeriod].totalBmcDays = _totalBmcDeposit;\n', '        periodsCount = _nextPeriod;\n', '\n', '        return OK;\n', '    }\n', '\n', '    function isTransferAllowed(address, address, address, address, uint) public view returns (bool) {\n', '        return true;\n', '    }\n', '\n', '    /* INTERNAL */\n', '\n', '    function _makeDepositForPeriod(bytes32 _userKey, uint _value, uint _lockupDate) internal {\n', '        Period storage _transferPeriod = periods[periodsCount];\n', '\n', '        _transferPeriod.user2bmcDays[_userKey] = _getBmcDaysAmountForUser(_userKey, now, periodsCount);\n', '        _transferPeriod.totalBmcDays = _getTotalBmcDaysAmount(now, periodsCount);\n', '        _transferPeriod.bmcDaysPerDay = _transferPeriod.bmcDaysPerDay.add(_value);\n', '\n', '        uint _userBalance = getUserBalance(_userKey);\n', '        uint _updatedTransfersCount = _transferPeriod.transfersCount.add(1);\n', '        _transferPeriod.transfersCount = _updatedTransfersCount;\n', '        _transferPeriod.transfer2date[_transferPeriod.transfersCount] = now;\n', '        _transferPeriod.user2balance[_userKey] = _userBalance.add(_value);\n', '        _transferPeriod.user2lastTransferIdx[_userKey] = _updatedTransfersCount;\n', '\n', '        _registerLockedDeposits(_userKey, _value, _lockupDate);\n', '    }\n', '\n', '    function _makeWithdrawForPeriod(bytes32 _userKey, uint _value) internal {\n', '        uint _userBalance = getUserBalance(_userKey);\n', '        uint _lockedBalance = _syncLockedDepositsAmount(_userKey);\n', '        require(_userBalance.sub(_lockedBalance) >= _value);\n', '\n', '        uint _periodsCount = periodsCount;\n', '        Period storage _transferPeriod = periods[_periodsCount];\n', '\n', '        _transferPeriod.user2bmcDays[_userKey] = _getBmcDaysAmountForUser(_userKey, now, _periodsCount);\n', '        uint _totalBmcDeposit = _getTotalBmcDaysAmount(now, _periodsCount);\n', '        _transferPeriod.totalBmcDays = _totalBmcDeposit;\n', '        _transferPeriod.bmcDaysPerDay = _transferPeriod.bmcDaysPerDay.sub(_value);\n', '\n', '        uint _updatedTransferCount = _transferPeriod.transfersCount.add(1);\n', '        _transferPeriod.transfer2date[_updatedTransferCount] = now;\n', '        _transferPeriod.user2lastTransferIdx[_userKey] = _updatedTransferCount;\n', '        _transferPeriod.user2balance[_userKey] = _userBalance.sub(_value);\n', '        _transferPeriod.transfersCount = _updatedTransferCount;\n', '    }\n', '\n', '    function _registerLockedDeposits(bytes32 _userKey, uint _amount, uint _lockupDate) internal {\n', '        if (_lockupDate <= now) {\n', '            return;\n', '        }\n', '\n', '        LockedDeposits storage _lockedDeposits = user2lockedDeposits[_userKey];\n', '        uint _lockedBalance = _lockedDeposits.date2deposit[_lockupDate];\n', '\n', '        if (_lockedBalance == 0) {\n', '            uint _lockedDepositsCounter = _lockedDeposits.counter.add(1);\n', '            _lockedDeposits.counter = _lockedDepositsCounter;\n', '            _lockedDeposits.index2Date[_lockedDepositsCounter] = _lockupDate;\n', '        }\n', '        _lockedDeposits.date2deposit[_lockupDate] = _lockedBalance.add(_amount);\n', '    }\n', '\n', '    function _syncLockedDepositsAmount(bytes32 _userKey) internal returns (uint _lockedSum) {\n', '        LockedDeposits storage _lockedDeposits = user2lockedDeposits[_userKey];\n', '        uint _lockedDepositsCounter = _lockedDeposits.counter;\n', '\n', '        for (uint _idx = 1; _idx <= _lockedDepositsCounter; ++_idx) {\n', '            uint _lockDate = _lockedDeposits.index2Date[_idx];\n', '\n', '            if (_lockDate <= now) {\n', '                _lockedDeposits.index2Date[_idx] = _lockedDeposits.index2Date[_lockedDepositsCounter];\n', '\n', '                delete _lockedDeposits.index2Date[_lockedDepositsCounter];\n', '                delete _lockedDeposits.date2deposit[_lockDate];\n', '\n', '                _lockedDepositsCounter = _lockedDepositsCounter.sub(1);\n', '                continue;\n', '            }\n', '\n', '            _lockedSum = _lockedSum.add(_lockedDeposits.date2deposit[_lockDate]);\n', '        }\n', '\n', '        _lockedDeposits.counter = _lockedDepositsCounter;\n', '    }\n', '\n', '    function _getBmcDaysAmountForUser(bytes32 _userKey, uint _date, uint _periodIdx) internal view returns (uint) {\n', '        uint _lastPeriodForUserIdx = user2lastPeriodParticipated[_userKey];\n', '        if (_lastPeriodForUserIdx == 0) {\n', '            return 0;\n', '        }\n', '\n', '        Period storage _transferPeriod = _lastPeriodForUserIdx <= _periodIdx ? periods[_lastPeriodForUserIdx] : periods[_periodIdx];\n', '        uint _lastTransferDate = _transferPeriod.transfer2date[_transferPeriod.user2lastTransferIdx[_userKey]];\n', '        // NOTE: It is an intended substraction separation to correctly round dates\n', '        uint _daysLong = (_date / 1 days) - (_lastTransferDate / 1 days);\n', '        uint _bmcDays = _transferPeriod.user2bmcDays[_userKey];\n', '        return _bmcDays.add(_transferPeriod.user2balance[_userKey] * _daysLong);\n', '    }\n', '\n', '    /* PRIVATE */\n', '\n', '    function _getTotalBmcDaysAmount(uint _date, uint _periodIdx) private view returns (uint) {\n', '        Period storage _depositPeriod = periods[_periodIdx];\n', '        uint _transfersCount = _depositPeriod.transfersCount;\n', '        uint _lastRecordedDate = _transfersCount != 0 ? _depositPeriod.transfer2date[_transfersCount] : _depositPeriod.startDate;\n', '\n', '        if (_lastRecordedDate == 0) {\n', '            return 0;\n', '        }\n', '\n', '        // NOTE: It is an intended substraction separation to correctly round dates\n', '        uint _daysLong = (_date / 1 days).sub((_lastRecordedDate / 1 days));\n', '        uint _totalBmcDeposit = _depositPeriod.totalBmcDays.add(_depositPeriod.bmcDaysPerDay.mul(_daysLong));\n', '        return _totalBmcDeposit;\n', '    }\n', '}\n', '\n', '/// @title Profiterole contract\n', '/// Collector and distributor for creation and redemption fees.\n', '/// Accepts bonus tokens from EmissionProvider, BurningMan or other distribution source.\n', '/// Calculates CCs shares in bonuses. Uses Treasury Contract as source of shares in bmc-days.\n', '/// Allows to withdraw bonuses on request.\n', 'contract Profiterole is OracleContractAdapter, ServiceAllowance, ProfiteroleEmitter {\n', '\n', '    uint constant PERCENT_PRECISION = 10000;\n', '\n', '    uint constant PROFITEROLE_ERROR_SCOPE = 102000;\n', '    uint constant PROFITEROLE_ERROR_INSUFFICIENT_DISTRIBUTION_BALANCE = PROFITEROLE_ERROR_SCOPE + 1;\n', '    uint constant PROFITEROLE_ERROR_INSUFFICIENT_BONUS_BALANCE = PROFITEROLE_ERROR_SCOPE + 2;\n', '    uint constant PROFITEROLE_ERROR_TRANSFER_ERROR = PROFITEROLE_ERROR_SCOPE + 3;\n', '\n', '    using SafeMath for uint;\n', '\n', '    struct Balance {\n', '        uint left;\n', '        bool initialized;\n', '    }\n', '\n', '    struct Deposit {\n', '        uint balance;\n', '        uint left;\n', '        uint nextDepositDate;\n', '        mapping(bytes32 => Balance) leftToWithdraw;\n', '    }\n', '\n', '    struct UserBalance {\n', '        uint lastWithdrawDate;\n', '    }\n', '\n', '    mapping(address => bool) distributionSourcesList;\n', '    mapping(bytes32 => UserBalance) bonusBalances;\n', '    mapping(uint => Deposit) public distributionDeposits;\n', '\n', '    uint public firstDepositDate;\n', '    uint public lastDepositDate;\n', '\n', '    address public bonusToken;\n', '    address public treasury;\n', '    address public wallet;\n', '\n', '    /// @dev Guards functions only for distributionSource invocations\n', '    modifier onlyDistributionSource {\n', '        if (!distributionSourcesList[msg.sender]) {\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '\n', '    function Profiterole(address _bonusToken, address _treasury, address _wallet) public {\n', '        require(_bonusToken != 0x0);\n', '        require(_treasury != 0x0);\n', '        require(_wallet != 0x0);\n', '\n', '        bonusToken = _bonusToken;\n', '        treasury = _treasury;\n', '        wallet = _wallet;\n', '    }\n', '\n', '    function() payable public {\n', '        revert();\n', '    }\n', '\n', '    /* EXTERNAL */\n', '\n', '    /// @notice Sets new treasury address\n', '    /// Only for contract owner.\n', '    function updateTreasury(address _treasury) external onlyContractOwner returns (uint) {\n', '        require(_treasury != 0x0);\n', '        treasury = _treasury;\n', '        return OK;\n', '    }\n', '\n', '    /// @notice Sets new wallet address for profiterole\n', '    /// Only for contract owner.\n', '    function updateWallet(address _wallet) external onlyContractOwner returns (uint) {\n', '        require(_wallet != 0x0);\n', '        wallet = _wallet;\n', '        return OK;\n', '    }\n', '\n', '    /// @notice Add distribution sources to whitelist.\n', '    ///\n', '    /// @param _whitelist addresses list.\n', '    function addDistributionSources(address[] _whitelist) external onlyContractOwner returns (uint) {\n', '        for (uint _idx = 0; _idx < _whitelist.length; ++_idx) {\n', '            distributionSourcesList[_whitelist[_idx]] = true;\n', '        }\n', '        return OK;\n', '    }\n', '\n', '    /// @notice Removes distribution sources from whitelist.\n', '    /// Only for contract owner.\n', '    ///\n', '    /// @param _blacklist addresses in whitelist.\n', '    function removeDistributionSources(address[] _blacklist) external onlyContractOwner returns (uint) {\n', '        for (uint _idx = 0; _idx < _blacklist.length; ++_idx) {\n', '            delete distributionSourcesList[_blacklist[_idx]];\n', '        }\n', '        return OK;\n', '    }\n', '\n', '    /// @notice Allows to withdraw user&#39;s bonuses that he deserves due to Treasury shares for\n', '    /// every distribution period.\n', '    /// Only oracles allowed to invoke this function.\n', '    ///\n', '    /// @param _userKey aggregated user key (user ID + role ID) on behalf of whom bonuses will be withdrawn\n', '    /// @param _value an amount of tokens to withdraw\n', '    /// @param _withdrawAddress destination address of withdrawal (usually user&#39;s address)\n', '    /// @param _feeAmount an amount of fee that will be taken from resulted _value\n', '    /// @param _feeAddress destination address of fee transfer\n', '    ///\n', '    /// @return result code of an operation\n', '    function withdrawBonuses(bytes32 _userKey, uint _value, address _withdrawAddress, uint _feeAmount, address _feeAddress) external onlyOracle returns (uint) {\n', '        require(_userKey != bytes32(0));\n', '        require(_value != 0);\n', '        require(_feeAmount < _value);\n', '        require(_withdrawAddress != 0x0);\n', '\n', '        DepositWalletInterface _wallet = DepositWalletInterface(wallet);\n', '        ERC20Interface _bonusToken = ERC20Interface(bonusToken);\n', '        if (_bonusToken.balanceOf(_wallet) < _value) {\n', '            return _emitError(PROFITEROLE_ERROR_INSUFFICIENT_BONUS_BALANCE);\n', '        }\n', '\n', '        if (OK != _withdrawBonuses(_userKey, _value)) {\n', '            revert();\n', '        }\n', '\n', '        if (!(_feeAddress == 0x0 || _feeAmount == 0 || OK == _wallet.withdraw(_bonusToken, _feeAddress, _feeAmount))) {\n', '            revert();\n', '        }\n', '\n', '        if (OK != _wallet.withdraw(_bonusToken, _withdrawAddress, _value - _feeAmount)) {\n', '            revert();\n', '        }\n', '\n', '        BonusesWithdrawn(_userKey, _value, now);\n', '        return OK;\n', '    }\n', '\n', '    /* PUBLIC */\n', '\n', '    /// @notice Gets total amount of bonuses user has during all distribution periods\n', '    /// @param _userKey aggregated user key (user ID + role ID)\n', '    /// @return _sum available amount of bonuses to withdraw\n', '    function getTotalBonusesAmountAvailable(bytes32 _userKey) public view returns (uint _sum) {\n', '        uint _startDate = _getCalculationStartDate(_userKey);\n', '        Treasury _treasury = Treasury(treasury);\n', '\n', '        for (\n', '            uint _endDate = lastDepositDate;\n', '            _startDate <= _endDate && _startDate != 0;\n', '            _startDate = distributionDeposits[_startDate].nextDepositDate\n', '        ) {\n', '            Deposit storage _pendingDeposit = distributionDeposits[_startDate];\n', '            Balance storage _userBalance = _pendingDeposit.leftToWithdraw[_userKey];\n', '\n', '            if (_userBalance.initialized) {\n', '                _sum = _sum.add(_userBalance.left);\n', '            } else {\n', '                uint _sharesPercent = _treasury.getSharesPercentForPeriod(_userKey, _startDate);\n', '                _sum = _sum.add(_pendingDeposit.balance.mul(_sharesPercent).div(PERCENT_PRECISION));\n', '            }\n', '        }\n', '    }\n', '\n', '    /// @notice Gets an amount of bonuses user has for concrete distribution date\n', '    /// @param _userKey aggregated user key (user ID + role ID)\n', '    /// @param _distributionDate date of distribution operation\n', '    /// @return available amount of bonuses to withdraw for selected distribution date\n', '    function getBonusesAmountAvailable(bytes32 _userKey, uint _distributionDate) public view returns (uint) {\n', '        Deposit storage _deposit = distributionDeposits[_distributionDate];\n', '        if (_deposit.leftToWithdraw[_userKey].initialized) {\n', '            return _deposit.leftToWithdraw[_userKey].left;\n', '        }\n', '\n', '        uint _sharesPercent = Treasury(treasury).getSharesPercentForPeriod(_userKey, _distributionDate);\n', '        return _deposit.balance.mul(_sharesPercent).div(PERCENT_PRECISION);\n', '    }\n', '\n', '    /// @notice Gets total amount of deposits that has left after users&#39; bonus withdrawals\n', '    /// @return amount of deposits available for bonus payments\n', '    function getTotalDepositsAmountLeft() public view returns (uint _amount) {\n', '        uint _lastDepositDate = lastDepositDate;\n', '        for (\n', '            uint _startDate = firstDepositDate;\n', '            _startDate <= _lastDepositDate || _startDate != 0;\n', '            _startDate = distributionDeposits[_startDate].nextDepositDate\n', '        ) {\n', '            _amount = _amount.add(distributionDeposits[_startDate].left);\n', '        }\n', '    }\n', '\n', '    /// @notice Gets an amount of deposits that has left after users&#39; bonus withdrawals for selected date\n', '    /// @param _distributionDate date of distribution operation\n', '    /// @return amount of deposits available for bonus payments for concrete distribution date\n', '    function getDepositsAmountLeft(uint _distributionDate) public view returns (uint _amount) {\n', '        return distributionDeposits[_distributionDate].left;\n', '    }\n', '\n', '    /// @notice Makes checkmark and deposits tokens on profiterole account\n', '    /// to pay them later as bonuses for Treasury shares holders. Timestamp of transaction\n', '    /// counts as the distribution period date.\n', '    /// Only addresses that were added as a distributionSource are allowed to call this function.\n', '    ///\n', '    /// @param _amount an amount of tokens to distribute\n', '    ///\n', '    /// @return result code of an operation.\n', '    /// PROFITEROLE_ERROR_INSUFFICIENT_DISTRIBUTION_BALANCE, PROFITEROLE_ERROR_TRANSFER_ERROR errors\n', '    /// are possible\n', '    function distributeBonuses(uint _amount) public onlyDistributionSource returns (uint) {\n', '\n', '        ERC20Interface _bonusToken = ERC20Interface(bonusToken);\n', '\n', '        if (_bonusToken.allowance(msg.sender, address(this)) < _amount) {\n', '            return _emitError(PROFITEROLE_ERROR_INSUFFICIENT_DISTRIBUTION_BALANCE);\n', '        }\n', '\n', '        if (!_bonusToken.transferFrom(msg.sender, wallet, _amount)) {\n', '            return _emitError(PROFITEROLE_ERROR_TRANSFER_ERROR);\n', '        }\n', '\n', '        if (firstDepositDate == 0) {\n', '            firstDepositDate = now;\n', '        }\n', '\n', '        uint _lastDepositDate = lastDepositDate;\n', '        if (_lastDepositDate != 0) {\n', '            distributionDeposits[_lastDepositDate].nextDepositDate = now;\n', '        }\n', '\n', '        lastDepositDate = now;\n', '        distributionDeposits[now] = Deposit(_amount, _amount, 0);\n', '\n', '        Treasury(treasury).addDistributionPeriod();\n', '\n', '        DepositPendingAdded(_amount, msg.sender, now);\n', '        return OK;\n', '    }\n', '\n', '    function isTransferAllowed(address, address, address, address, uint) public view returns (bool) {\n', '        return false;\n', '    }\n', '\n', '    /* PRIVATE */\n', '\n', '    function _getCalculationStartDate(bytes32 _userKey) private view returns (uint _startDate) {\n', '        _startDate = bonusBalances[_userKey].lastWithdrawDate;\n', '        return _startDate != 0 ? _startDate : firstDepositDate;\n', '    }\n', '\n', '    function _withdrawBonuses(bytes32 _userKey, uint _value) private returns (uint) {\n', '        uint _startDate = _getCalculationStartDate(_userKey);\n', '        uint _lastWithdrawDate = _startDate;\n', '        Treasury _treasury = Treasury(treasury);\n', '\n', '        for (\n', '            uint _endDate = lastDepositDate;\n', '            _startDate <= _endDate && _startDate != 0 && _value > 0;\n', '            _startDate = distributionDeposits[_startDate].nextDepositDate\n', '        ) {\n', '            uint _balanceToWithdraw = _withdrawBonusesFromDeposit(_userKey, _startDate, _value, _treasury);\n', '            _value = _value.sub(_balanceToWithdraw);\n', '        }\n', '\n', '        if (_lastWithdrawDate != _startDate) {\n', '            bonusBalances[_userKey].lastWithdrawDate = _lastWithdrawDate;\n', '        }\n', '\n', '        if (_value > 0) {\n', '            revert();\n', '        }\n', '\n', '        return OK;\n', '    }\n', '\n', '    function _withdrawBonusesFromDeposit(bytes32 _userKey, uint _periodDate, uint _value, Treasury _treasury) private returns (uint) {\n', '        Deposit storage _pendingDeposit = distributionDeposits[_periodDate];\n', '        Balance storage _userBalance = _pendingDeposit.leftToWithdraw[_userKey];\n', '\n', '        uint _balanceToWithdraw;\n', '        if (_userBalance.initialized) {\n', '            _balanceToWithdraw = _userBalance.left;\n', '        } else {\n', '            uint _sharesPercent = _treasury.getSharesPercentForPeriod(_userKey, _periodDate);\n', '            _balanceToWithdraw = _pendingDeposit.balance.mul(_sharesPercent).div(PERCENT_PRECISION);\n', '            _userBalance.initialized = true;\n', '        }\n', '\n', '        if (_balanceToWithdraw > _value) {\n', '            _userBalance.left = _balanceToWithdraw - _value;\n', '            _balanceToWithdraw = _value;\n', '        } else {\n', '            delete _userBalance.left;\n', '        }\n', '\n', '        _pendingDeposit.left = _pendingDeposit.left.sub(_balanceToWithdraw);\n', '        return _balanceToWithdraw;\n', '    }\n', '}']