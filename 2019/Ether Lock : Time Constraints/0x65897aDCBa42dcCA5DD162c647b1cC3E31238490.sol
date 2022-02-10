['pragma solidity 0.4.18;\n', '\n', '// File: contracts/ERC20Interface.sol\n', '\n', '// https://github.com/ethereum/EIPs/issues/20\n', 'interface ERC20 {\n', '    function totalSupply() public view returns (uint supply);\n', '    function balanceOf(address _owner) public view returns (uint balance);\n', '    function transfer(address _to, uint _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success);\n', '    function approve(address _spender, uint _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public view returns (uint remaining);\n', '    function decimals() public view returns(uint digits);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '\n', '// File: contracts/KyberReserveInterface.sol\n', '\n', '/// @title Kyber Reserve contract\n', 'interface KyberReserveInterface {\n', '\n', '    function trade(\n', '        ERC20 srcToken,\n', '        uint srcAmount,\n', '        ERC20 destToken,\n', '        address destAddress,\n', '        uint conversionRate,\n', '        bool validate\n', '    )\n', '        public\n', '        payable\n', '        returns(bool);\n', '\n', '    function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint);\n', '}\n', '\n', '// File: contracts/KyberNetworkInterface.sol\n', '\n', '/// @title Kyber Network interface\n', 'interface KyberNetworkInterface {\n', '    function maxGasPrice() public view returns(uint);\n', '    function getUserCapInWei(address user) public view returns(uint);\n', '    function getUserCapInTokenWei(address user, ERC20 token) public view returns(uint);\n', '    function enabled() public view returns(bool);\n', '    function info(bytes32 id) public view returns(uint);\n', '\n', '    function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty) public view\n', '        returns (uint expectedRate, uint slippageRate);\n', '\n', '    function tradeWithHint(address trader, ERC20 src, uint srcAmount, ERC20 dest, address destAddress,\n', '        uint maxDestAmount, uint minConversionRate, address walletId, bytes hint) public payable returns(uint);\n', '}\n', '\n', '// File: contracts/PermissionGroups.sol\n', '\n', 'contract PermissionGroups {\n', '\n', '    address public admin;\n', '    address public pendingAdmin;\n', '    mapping(address=>bool) internal operators;\n', '    mapping(address=>bool) internal alerters;\n', '    address[] internal operatorsGroup;\n', '    address[] internal alertersGroup;\n', '    uint constant internal MAX_GROUP_SIZE = 50;\n', '\n', '    function PermissionGroups() public {\n', '        admin = msg.sender;\n', '    }\n', '\n', '    modifier onlyAdmin() {\n', '        require(msg.sender == admin);\n', '        _;\n', '    }\n', '\n', '    modifier onlyOperator() {\n', '        require(operators[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    modifier onlyAlerter() {\n', '        require(alerters[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    function getOperators () external view returns(address[]) {\n', '        return operatorsGroup;\n', '    }\n', '\n', '    function getAlerters () external view returns(address[]) {\n', '        return alertersGroup;\n', '    }\n', '\n', '    event TransferAdminPending(address pendingAdmin);\n', '\n', '    /**\n', '     * @dev Allows the current admin to set the pendingAdmin address.\n', '     * @param newAdmin The address to transfer ownership to.\n', '     */\n', '    function transferAdmin(address newAdmin) public onlyAdmin {\n', '        require(newAdmin != address(0));\n', '        TransferAdminPending(pendingAdmin);\n', '        pendingAdmin = newAdmin;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.\n', '     * @param newAdmin The address to transfer ownership to.\n', '     */\n', '    function transferAdminQuickly(address newAdmin) public onlyAdmin {\n', '        require(newAdmin != address(0));\n', '        TransferAdminPending(newAdmin);\n', '        AdminClaimed(newAdmin, admin);\n', '        admin = newAdmin;\n', '    }\n', '\n', '    event AdminClaimed( address newAdmin, address previousAdmin);\n', '\n', '    /**\n', '     * @dev Allows the pendingAdmin address to finalize the change admin process.\n', '     */\n', '    function claimAdmin() public {\n', '        require(pendingAdmin == msg.sender);\n', '        AdminClaimed(pendingAdmin, admin);\n', '        admin = pendingAdmin;\n', '        pendingAdmin = address(0);\n', '    }\n', '\n', '    event AlerterAdded (address newAlerter, bool isAdd);\n', '\n', '    function addAlerter(address newAlerter) public onlyAdmin {\n', '        require(!alerters[newAlerter]); // prevent duplicates.\n', '        require(alertersGroup.length < MAX_GROUP_SIZE);\n', '\n', '        AlerterAdded(newAlerter, true);\n', '        alerters[newAlerter] = true;\n', '        alertersGroup.push(newAlerter);\n', '    }\n', '\n', '    function removeAlerter (address alerter) public onlyAdmin {\n', '        require(alerters[alerter]);\n', '        alerters[alerter] = false;\n', '\n', '        for (uint i = 0; i < alertersGroup.length; ++i) {\n', '            if (alertersGroup[i] == alerter) {\n', '                alertersGroup[i] = alertersGroup[alertersGroup.length - 1];\n', '                alertersGroup.length--;\n', '                AlerterAdded(alerter, false);\n', '                break;\n', '            }\n', '        }\n', '    }\n', '\n', '    event OperatorAdded(address newOperator, bool isAdd);\n', '\n', '    function addOperator(address newOperator) public onlyAdmin {\n', '        require(!operators[newOperator]); // prevent duplicates.\n', '        require(operatorsGroup.length < MAX_GROUP_SIZE);\n', '\n', '        OperatorAdded(newOperator, true);\n', '        operators[newOperator] = true;\n', '        operatorsGroup.push(newOperator);\n', '    }\n', '\n', '    function removeOperator (address operator) public onlyAdmin {\n', '        require(operators[operator]);\n', '        operators[operator] = false;\n', '\n', '        for (uint i = 0; i < operatorsGroup.length; ++i) {\n', '            if (operatorsGroup[i] == operator) {\n', '                operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];\n', '                operatorsGroup.length -= 1;\n', '                OperatorAdded(operator, false);\n', '                break;\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/Withdrawable.sol\n', '\n', '/**\n', ' * @title Contracts that should be able to recover tokens or ethers\n', ' * @author Ilan Doron\n', ' * @dev This allows to recover any tokens or Ethers received in a contract.\n', ' * This will prevent any accidental loss of tokens.\n', ' */\n', 'contract Withdrawable is PermissionGroups {\n', '\n', '    event TokenWithdraw(ERC20 token, uint amount, address sendTo);\n', '\n', '    /**\n', '     * @dev Withdraw all ERC20 compatible tokens\n', '     * @param token ERC20 The address of the token contract\n', '     */\n', '    function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {\n', '        require(token.transfer(sendTo, amount));\n', '        TokenWithdraw(token, amount, sendTo);\n', '    }\n', '\n', '    event EtherWithdraw(uint amount, address sendTo);\n', '\n', '    /**\n', '     * @dev Withdraw Ethers\n', '     */\n', '    function withdrawEther(uint amount, address sendTo) external onlyAdmin {\n', '        sendTo.transfer(amount);\n', '        EtherWithdraw(amount, sendTo);\n', '    }\n', '}\n', '\n', '// File: contracts/Utils.sol\n', '\n', '/// @title Kyber constants contract\n', 'contract Utils {\n', '\n', '    ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);\n', '    uint  constant internal PRECISION = (10**18);\n', '    uint  constant internal MAX_QTY   = (10**28); // 10B tokens\n', '    uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH\n', '    uint  constant internal MAX_DECIMALS = 18;\n', '    uint  constant internal ETH_DECIMALS = 18;\n', '    mapping(address=>uint) internal decimals;\n', '\n', '    function setDecimals(ERC20 token) internal {\n', '        if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;\n', '        else decimals[token] = token.decimals();\n', '    }\n', '\n', '    function getDecimals(ERC20 token) internal view returns(uint) {\n', '        if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access\n', '        uint tokenDecimals = decimals[token];\n', '        // technically, there might be token with decimals 0\n', '        // moreover, very possible that old tokens have decimals 0\n', '        // these tokens will just have higher gas fees.\n', '        if(tokenDecimals == 0) return token.decimals();\n', '\n', '        return tokenDecimals;\n', '    }\n', '\n', '    function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {\n', '        require(srcQty <= MAX_QTY);\n', '        require(rate <= MAX_RATE);\n', '\n', '        if (dstDecimals >= srcDecimals) {\n', '            require((dstDecimals - srcDecimals) <= MAX_DECIMALS);\n', '            return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;\n', '        } else {\n', '            require((srcDecimals - dstDecimals) <= MAX_DECIMALS);\n', '            return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));\n', '        }\n', '    }\n', '\n', '    function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {\n', '        require(dstQty <= MAX_QTY);\n', '        require(rate <= MAX_RATE);\n', '        \n', '        //source quantity is rounded up. to avoid dest quantity being too low.\n', '        uint numerator;\n', '        uint denominator;\n', '        if (srcDecimals >= dstDecimals) {\n', '            require((srcDecimals - dstDecimals) <= MAX_DECIMALS);\n', '            numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));\n', '            denominator = rate;\n', '        } else {\n', '            require((dstDecimals - srcDecimals) <= MAX_DECIMALS);\n', '            numerator = (PRECISION * dstQty);\n', '            denominator = (rate * (10**(dstDecimals - srcDecimals)));\n', '        }\n', '        return (numerator + denominator - 1) / denominator; //avoid rounding down errors\n', '    }\n', '}\n', '\n', '// File: contracts/Utils2.sol\n', '\n', 'contract Utils2 is Utils {\n', '\n', '    /// @dev get the balance of a user.\n', '    /// @param token The token type\n', '    /// @return The balance\n', '    function getBalance(ERC20 token, address user) public view returns(uint) {\n', '        if (token == ETH_TOKEN_ADDRESS)\n', '            return user.balance;\n', '        else\n', '            return token.balanceOf(user);\n', '    }\n', '\n', '    function getDecimalsSafe(ERC20 token) internal returns(uint) {\n', '\n', '        if (decimals[token] == 0) {\n', '            setDecimals(token);\n', '        }\n', '\n', '        return decimals[token];\n', '    }\n', '\n', '    function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal view returns(uint) {\n', '        return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);\n', '    }\n', '\n', '    function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal view returns(uint) {\n', '        return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);\n', '    }\n', '\n', '    function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)\n', '        internal pure returns(uint)\n', '    {\n', '        require(srcAmount <= MAX_QTY);\n', '        require(destAmount <= MAX_QTY);\n', '\n', '        if (dstDecimals >= srcDecimals) {\n', '            require((dstDecimals - srcDecimals) <= MAX_DECIMALS);\n', '            return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));\n', '        } else {\n', '            require((srcDecimals - dstDecimals) <= MAX_DECIMALS);\n', '            return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/WhiteListInterface.sol\n', '\n', 'contract WhiteListInterface {\n', '    function getUserCapInWei(address user) external view returns (uint userCapWei);\n', '}\n', '\n', '// File: contracts/ExpectedRateInterface.sol\n', '\n', 'interface ExpectedRateInterface {\n', '    function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty, bool usePermissionless) public view\n', '        returns (uint expectedRate, uint slippageRate);\n', '}\n', '\n', '// File: contracts/FeeBurnerInterface.sol\n', '\n', 'interface FeeBurnerInterface {\n', '    function handleFees (uint tradeWeiAmount, address reserve, address wallet) public returns(bool);\n', '    function setReserveData(address reserve, uint feesInBps, address kncWallet) public;\n', '}\n', '\n', '// File: contracts/KyberNetwork.sol\n', '\n', '/**\n', ' * @title Helps contracts guard against reentrancy attacks.\n', ' */\n', 'contract ReentrancyGuard {\n', '\n', '    /// @dev counter to allow mutex lock with only one SSTORE operation\n', '    uint256 private guardCounter = 1;\n', '\n', '    /**\n', '     * @dev Prevents a function from calling itself, directly or indirectly.\n', '     * Calling one `nonReentrant` function from\n', '     * another is not supported. Instead, you can implement a\n', '     * `private` function doing the actual work, and an `external`\n', '     * wrapper marked as `nonReentrant`.\n', '     */\n', '    modifier nonReentrant() {\n', '        guardCounter += 1;\n', '        uint256 localCounter = guardCounter;\n', '        _;\n', '        require(localCounter == guardCounter);\n', '    }\n', '}\n', '\n', '\n', '////////////////////////////////////////////////////////////////////////////////////////////////////////\n', '/// @title Kyber Network main contract\n', 'contract KyberNetwork is Withdrawable, Utils2, KyberNetworkInterface, ReentrancyGuard {\n', '\n', '    bytes public constant PERM_HINT = "PERM";\n', '    uint  public constant PERM_HINT_GET_RATE = 1 << 255; // for get rate. bit mask hint.\n', '\n', '    uint public negligibleRateDiff = 10; // basic rate steps will be in 0.01%\n', '    KyberReserveInterface[] public reserves;\n', '    mapping(address=>ReserveType) public reserveType;\n', '    WhiteListInterface public whiteListContract;\n', '    ExpectedRateInterface public expectedRateContract;\n', '    FeeBurnerInterface    public feeBurnerContract;\n', '    address               public kyberNetworkProxyContract;\n', '    uint                  public maxGasPriceValue = 50 * 1000 * 1000 * 1000; // 50 gwei\n', '    bool                  public isEnabled = false; // network is enabled\n', '    mapping(bytes32=>uint) public infoFields; // this is only a UI field for external app.\n', '\n', '    mapping(address=>address[]) public reservesPerTokenSrc; //reserves supporting token to eth\n', '    mapping(address=>address[]) public reservesPerTokenDest;//reserves support eth to token\n', '\n', '    enum ReserveType {NONE, PERMISSIONED, PERMISSIONLESS}\n', '    bytes internal constant EMPTY_HINT = "";\n', '\n', '    function KyberNetwork(address _admin) public {\n', '        require(_admin != address(0));\n', '        admin = _admin;\n', '    }\n', '\n', '    event EtherReceival(address indexed sender, uint amount);\n', '\n', '    /* solhint-disable no-complex-fallback */\n', '    // To avoid users trying to swap tokens using default payable function. We added this short code\n', '    //  to verify Ethers will be received only from reserves if transferred without a specific function call.\n', '    function() public payable {\n', '        require(reserveType[msg.sender] != ReserveType.NONE);\n', '        EtherReceival(msg.sender, msg.value);\n', '    }\n', '    /* solhint-enable no-complex-fallback */\n', '\n', '    struct TradeInput {\n', '        address trader;\n', '        ERC20 src;\n', '        uint srcAmount;\n', '        ERC20 dest;\n', '        address destAddress;\n', '        uint maxDestAmount;\n', '        uint minConversionRate;\n', '        address walletId;\n', '        bytes hint;\n', '    }\n', '\n', '    function tradeWithHint(\n', '        address trader,\n', '        ERC20 src,\n', '        uint srcAmount,\n', '        ERC20 dest,\n', '        address destAddress,\n', '        uint maxDestAmount,\n', '        uint minConversionRate,\n', '        address walletId,\n', '        bytes hint\n', '    )\n', '        public\n', '        nonReentrant\n', '        payable\n', '        returns(uint)\n', '    {\n', '        require(msg.sender == kyberNetworkProxyContract);\n', '        require((hint.length == 0) || (hint.length == 4));\n', '\n', '        TradeInput memory tradeInput;\n', '\n', '        tradeInput.trader = trader;\n', '        tradeInput.src = src;\n', '        tradeInput.srcAmount = srcAmount;\n', '        tradeInput.dest = dest;\n', '        tradeInput.destAddress = destAddress;\n', '        tradeInput.maxDestAmount = maxDestAmount;\n', '        tradeInput.minConversionRate = minConversionRate;\n', '        tradeInput.walletId = walletId;\n', '        tradeInput.hint = hint;\n', '\n', '        return trade(tradeInput);\n', '    }\n', '\n', '    event AddReserveToNetwork(KyberReserveInterface indexed reserve, bool add, bool isPermissionless);\n', '\n', '    /// @notice can be called only by operator\n', '    /// @dev add or deletes a reserve to/from the network.\n', '    /// @param reserve The reserve address.\n', '    /// @param isPermissionless is the new reserve from permissionless type.\n', '    function addReserve(KyberReserveInterface reserve, bool isPermissionless) public onlyOperator\n', '        returns(bool)\n', '    {\n', '        require(reserveType[reserve] == ReserveType.NONE);\n', '        reserves.push(reserve);\n', '\n', '        reserveType[reserve] = isPermissionless ? ReserveType.PERMISSIONLESS : ReserveType.PERMISSIONED;\n', '\n', '        AddReserveToNetwork(reserve, true, isPermissionless);\n', '\n', '        return true;\n', '    }\n', '\n', '    event RemoveReserveFromNetwork(KyberReserveInterface reserve);\n', '\n', '    /// @notice can be called only by operator\n', '    /// @dev removes a reserve from Kyber network.\n', '    /// @param reserve The reserve address.\n', '    /// @param index in reserve array.\n', '    function removeReserve(KyberReserveInterface reserve, uint index) public onlyOperator\n', '        returns(bool)\n', '    {\n', '\n', '        require(reserveType[reserve] != ReserveType.NONE);\n', '        require(reserves[index] == reserve);\n', '\n', '        reserveType[reserve] = ReserveType.NONE;\n', '        reserves[index] = reserves[reserves.length - 1];\n', '        reserves.length--;\n', '\n', '        RemoveReserveFromNetwork(reserve);\n', '\n', '        return true;\n', '    }\n', '\n', '    event ListReservePairs(address indexed reserve, ERC20 src, ERC20 dest, bool add);\n', '\n', '    /// @notice can be called only by operator\n', '    /// @dev allow or prevent a specific reserve to trade a pair of tokens\n', '    /// @param reserve The reserve address.\n', '    /// @param token token address\n', '    /// @param ethToToken will it support ether to token trade\n', '    /// @param tokenToEth will it support token to ether trade\n', '    /// @param add If true then list this pair, otherwise unlist it.\n', '    function listPairForReserve(address reserve, ERC20 token, bool ethToToken, bool tokenToEth, bool add)\n', '        public\n', '        onlyOperator\n', '        returns(bool)\n', '    {\n', '        require(reserveType[reserve] != ReserveType.NONE);\n', '\n', '        if (ethToToken) {\n', '            listPairs(reserve, token, false, add);\n', '\n', '            ListReservePairs(reserve, ETH_TOKEN_ADDRESS, token, add);\n', '        }\n', '\n', '        if (tokenToEth) {\n', '            listPairs(reserve, token, true, add);\n', '\n', '            if (add) {\n', '                require(token.approve(reserve, 2**255)); // approve infinity\n', '            } else {\n', '                require(token.approve(reserve, 0));\n', '            }\n', '\n', '            ListReservePairs(reserve, token, ETH_TOKEN_ADDRESS, add);\n', '        }\n', '\n', '        setDecimals(token);\n', '\n', '        return true;\n', '    }\n', '\n', '    event WhiteListContractSet(WhiteListInterface newContract, WhiteListInterface currentContract);\n', '\n', '    ///@param whiteList can be empty\n', '    function setWhiteList(WhiteListInterface whiteList) public onlyAdmin {\n', '        WhiteListContractSet(whiteList, whiteListContract);\n', '        whiteListContract = whiteList;\n', '    }\n', '\n', '    event ExpectedRateContractSet(ExpectedRateInterface newContract, ExpectedRateInterface currentContract);\n', '\n', '    function setExpectedRate(ExpectedRateInterface expectedRate) public onlyAdmin {\n', '        require(expectedRate != address(0));\n', '\n', '        ExpectedRateContractSet(expectedRate, expectedRateContract);\n', '        expectedRateContract = expectedRate;\n', '    }\n', '\n', '    event FeeBurnerContractSet(FeeBurnerInterface newContract, FeeBurnerInterface currentContract);\n', '\n', '    function setFeeBurner(FeeBurnerInterface feeBurner) public onlyAdmin {\n', '        require(feeBurner != address(0));\n', '\n', '        FeeBurnerContractSet(feeBurner, feeBurnerContract);\n', '        feeBurnerContract = feeBurner;\n', '    }\n', '\n', '    event KyberNetwrokParamsSet(uint maxGasPrice, uint negligibleRateDiff);\n', '\n', '    function setParams(\n', '        uint                  _maxGasPrice,\n', '        uint                  _negligibleRateDiff\n', '    )\n', '        public\n', '        onlyAdmin\n', '    {\n', '        require(_negligibleRateDiff <= 100 * 100); // at most 100%\n', '\n', '        maxGasPriceValue = _maxGasPrice;\n', '        negligibleRateDiff = _negligibleRateDiff;\n', '        KyberNetwrokParamsSet(maxGasPriceValue, negligibleRateDiff);\n', '    }\n', '\n', '    event KyberNetworkSetEnable(bool isEnabled);\n', '\n', '    function setEnable(bool _enable) public onlyAdmin {\n', '        if (_enable) {\n', '            require(feeBurnerContract != address(0));\n', '            require(expectedRateContract != address(0));\n', '            require(kyberNetworkProxyContract != address(0));\n', '        }\n', '        isEnabled = _enable;\n', '\n', '        KyberNetworkSetEnable(isEnabled);\n', '    }\n', '\n', '    function setInfo(bytes32 field, uint value) public onlyOperator {\n', '        infoFields[field] = value;\n', '    }\n', '\n', '    event KyberProxySet(address proxy, address sender);\n', '\n', '    function setKyberProxy(address networkProxy) public onlyAdmin {\n', '        require(networkProxy != address(0));\n', '        kyberNetworkProxyContract = networkProxy;\n', '        KyberProxySet(kyberNetworkProxyContract, msg.sender);\n', '    }\n', '\n', '    /// @dev returns number of reserves\n', '    /// @return number of reserves\n', '    function getNumReserves() public view returns(uint) {\n', '        return reserves.length;\n', '    }\n', '\n', '    /// @notice should be called off chain\n', '    /// @dev get an array of all reserves\n', '    /// @return An array of all reserves\n', '    function getReserves() public view returns(KyberReserveInterface[]) {\n', '        return reserves;\n', '    }\n', '\n', '    function maxGasPrice() public view returns(uint) {\n', '        return maxGasPriceValue;\n', '    }\n', '\n', '    function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty)\n', '        public view\n', '        returns(uint expectedRate, uint slippageRate)\n', '    {\n', '        require(expectedRateContract != address(0));\n', '        bool includePermissionless = true;\n', '\n', '        if (srcQty & PERM_HINT_GET_RATE > 0) {\n', '            includePermissionless = false;\n', '            srcQty = srcQty & ~PERM_HINT_GET_RATE;\n', '        }\n', '\n', '        return expectedRateContract.getExpectedRate(src, dest, srcQty, includePermissionless);\n', '    }\n', '\n', '    function getExpectedRateOnlyPermission(ERC20 src, ERC20 dest, uint srcQty)\n', '        public view\n', '        returns(uint expectedRate, uint slippageRate)\n', '    {\n', '        require(expectedRateContract != address(0));\n', '        return expectedRateContract.getExpectedRate(src, dest, srcQty, false);\n', '    }\n', '\n', '    function getUserCapInWei(address user) public view returns(uint) {\n', '        if (whiteListContract == address(0)) return (2 ** 255);\n', '        return whiteListContract.getUserCapInWei(user);\n', '    }\n', '\n', '    function getUserCapInTokenWei(address user, ERC20 token) public view returns(uint) {\n', '        //future feature\n', '        user;\n', '        token;\n', '        require(false);\n', '    }\n', '\n', '    struct BestRateResult {\n', '        uint rate;\n', '        address reserve1;\n', '        address reserve2;\n', '        uint weiAmount;\n', '        uint rateSrcToEth;\n', '        uint rateEthToDest;\n', '        uint destAmount;\n', '    }\n', '\n', '    /// @notice use token address ETH_TOKEN_ADDRESS for ether\n', '    /// @dev best conversion rate for a pair of tokens, if number of reserves have small differences. randomize\n', '    /// @param src Src token\n', '    /// @param dest Destination token\n', '    /// @return obsolete - used to return best reserve index. not relevant anymore for this API.\n', '    function findBestRate(ERC20 src, ERC20 dest, uint srcAmount) public view returns(uint obsolete, uint rate) {\n', '        BestRateResult memory result = findBestRateTokenToToken(src, dest, srcAmount, EMPTY_HINT);\n', '        return(0, result.rate);\n', '    }\n', '\n', '    function findBestRateOnlyPermission(ERC20 src, ERC20 dest, uint srcAmount)\n', '        public\n', '        view\n', '        returns(uint obsolete, uint rate)\n', '    {\n', '        BestRateResult memory result = findBestRateTokenToToken(src, dest, srcAmount, PERM_HINT);\n', '        return(0, result.rate);\n', '    }\n', '\n', '    function enabled() public view returns(bool) {\n', '        return isEnabled;\n', '    }\n', '\n', '    function info(bytes32 field) public view returns(uint) {\n', '        return infoFields[field];\n', '    }\n', '\n', '    /* solhint-disable code-complexity */\n', '    // Regarding complexity. Below code follows the required algorithm for choosing a reserve.\n', '    //  It has been tested, reviewed and found to be clear enough.\n', '    //@dev this function always src or dest are ether. can&#39;t do token to token\n', '    function searchBestRate(ERC20 src, ERC20 dest, uint srcAmount, bool usePermissionless)\n', '        public\n', '        view\n', '        returns(address, uint)\n', '    {\n', '        uint bestRate = 0;\n', '        uint bestReserve = 0;\n', '        uint numRelevantReserves = 0;\n', '\n', '        //return 1 for ether to ether\n', '        if (src == dest) return (reserves[bestReserve], PRECISION);\n', '\n', '        address[] memory reserveArr;\n', '\n', '        reserveArr = src == ETH_TOKEN_ADDRESS ? reservesPerTokenDest[dest] : reservesPerTokenSrc[src];\n', '\n', '        if (reserveArr.length == 0) return (reserves[bestReserve], bestRate);\n', '\n', '        uint[] memory rates = new uint[](reserveArr.length);\n', '        uint[] memory reserveCandidates = new uint[](reserveArr.length);\n', '\n', '        for (uint i = 0; i < reserveArr.length; i++) {\n', '            //list all reserves that have this token.\n', '            if (!usePermissionless && reserveType[reserveArr[i]] == ReserveType.PERMISSIONLESS) {\n', '                continue;\n', '            }\n', '\n', '            rates[i] = (KyberReserveInterface(reserveArr[i])).getConversionRate(src, dest, srcAmount, block.number);\n', '\n', '            if (rates[i] > bestRate) {\n', '                //best rate is highest rate\n', '                bestRate = rates[i];\n', '            }\n', '        }\n', '\n', '        if (bestRate > 0) {\n', '            uint smallestRelevantRate = (bestRate * 10000) / (10000 + negligibleRateDiff);\n', '\n', '            for (i = 0; i < reserveArr.length; i++) {\n', '                if (rates[i] >= smallestRelevantRate) {\n', '                    reserveCandidates[numRelevantReserves++] = i;\n', '                }\n', '            }\n', '\n', '            if (numRelevantReserves > 1) {\n', '                //when encountering small rate diff from bestRate. draw from relevant reserves\n', '                bestReserve = reserveCandidates[uint(block.blockhash(block.number-1)) % numRelevantReserves];\n', '            } else {\n', '                bestReserve = reserveCandidates[0];\n', '            }\n', '\n', '            bestRate = rates[bestReserve];\n', '        }\n', '\n', '        return (reserveArr[bestReserve], bestRate);\n', '    }\n', '    /* solhint-enable code-complexity */\n', '\n', '    function findBestRateTokenToToken(ERC20 src, ERC20 dest, uint srcAmount, bytes hint) internal view\n', '        returns(BestRateResult result)\n', '    {\n', '        //by default we use permission less reserves\n', '        bool usePermissionless = true;\n', '\n', '        // if hint in first 4 bytes == &#39;PERM&#39; only permissioned reserves will be used.\n', '        if ((hint.length >= 4) && (keccak256(hint[0], hint[1], hint[2], hint[3]) == keccak256(PERM_HINT))) {\n', '            usePermissionless = false;\n', '        }\n', '\n', '        (result.reserve1, result.rateSrcToEth) =\n', '            searchBestRate(src, ETH_TOKEN_ADDRESS, srcAmount, usePermissionless);\n', '\n', '        result.weiAmount = calcDestAmount(src, ETH_TOKEN_ADDRESS, srcAmount, result.rateSrcToEth);\n', '\n', '        (result.reserve2, result.rateEthToDest) =\n', '            searchBestRate(ETH_TOKEN_ADDRESS, dest, result.weiAmount, usePermissionless);\n', '\n', '        result.destAmount = calcDestAmount(ETH_TOKEN_ADDRESS, dest, result.weiAmount, result.rateEthToDest);\n', '\n', '        result.rate = calcRateFromQty(srcAmount, result.destAmount, getDecimals(src), getDecimals(dest));\n', '    }\n', '\n', '    function listPairs(address reserve, ERC20 token, bool isTokenToEth, bool add) internal {\n', '        uint i;\n', '        address[] storage reserveArr = reservesPerTokenDest[token];\n', '\n', '        if (isTokenToEth) {\n', '            reserveArr = reservesPerTokenSrc[token];\n', '        }\n', '\n', '        for (i = 0; i < reserveArr.length; i++) {\n', '            if (reserve == reserveArr[i]) {\n', '                if (add) {\n', '                    break; //already added\n', '                } else {\n', '                    //remove\n', '                    reserveArr[i] = reserveArr[reserveArr.length - 1];\n', '                    reserveArr.length--;\n', '                    break;\n', '                }\n', '            }\n', '        }\n', '\n', '        if (add && i == reserveArr.length) {\n', '            //if reserve wasn&#39;t found add it\n', '            reserveArr.push(reserve);\n', '        }\n', '    }\n', '\n', '    event KyberTrade(address indexed trader, ERC20 src, ERC20 dest, uint srcAmount, uint dstAmount,\n', '        address destAddress, uint ethWeiValue, address reserve1, address reserve2, bytes hint);\n', '\n', '    /* solhint-disable function-max-lines */\n', '    //  Most of the lines here are functions calls spread over multiple lines. We find this function readable enough\n', '    /// @notice use token address ETH_TOKEN_ADDRESS for ether\n', '    /// @dev trade api for kyber network.\n', '    /// @param tradeInput structure of trade inputs\n', '    function trade(TradeInput tradeInput) internal returns(uint) {\n', '        require(isEnabled);\n', '        require(tx.gasprice <= maxGasPriceValue);\n', '        require(validateTradeInput(tradeInput.src, tradeInput.srcAmount, tradeInput.dest, tradeInput.destAddress));\n', '\n', '        BestRateResult memory rateResult =\n', '            findBestRateTokenToToken(tradeInput.src, tradeInput.dest, tradeInput.srcAmount, tradeInput.hint);\n', '\n', '        require(rateResult.rate > 0);\n', '        require(rateResult.rate < MAX_RATE);\n', '        require(rateResult.rate >= tradeInput.minConversionRate);\n', '\n', '        uint actualDestAmount;\n', '        uint weiAmount;\n', '        uint actualSrcAmount;\n', '\n', '        (actualSrcAmount, weiAmount, actualDestAmount) = calcActualAmounts(tradeInput.src,\n', '            tradeInput.dest,\n', '            tradeInput.srcAmount,\n', '            tradeInput.maxDestAmount,\n', '            rateResult);\n', '\n', '        require(getUserCapInWei(tradeInput.trader) >= weiAmount);\n', '        require(handleChange(tradeInput.src, tradeInput.srcAmount, actualSrcAmount, tradeInput.trader));\n', '\n', '        require(doReserveTrade(     //src to ETH\n', '                tradeInput.src,\n', '                actualSrcAmount,\n', '                ETH_TOKEN_ADDRESS,\n', '                this,\n', '                weiAmount,\n', '                KyberReserveInterface(rateResult.reserve1),\n', '                rateResult.rateSrcToEth,\n', '                true));\n', '\n', '        require(doReserveTrade(     //Eth to dest\n', '                ETH_TOKEN_ADDRESS,\n', '                weiAmount,\n', '                tradeInput.dest,\n', '                tradeInput.destAddress,\n', '                actualDestAmount,\n', '                KyberReserveInterface(rateResult.reserve2),\n', '                rateResult.rateEthToDest,\n', '                true));\n', '\n', '        if (tradeInput.src != ETH_TOKEN_ADDRESS) //"fake" trade. (ether to ether) - don&#39;t burn.\n', '            require(feeBurnerContract.handleFees(weiAmount, rateResult.reserve1, tradeInput.walletId));\n', '        if (tradeInput.dest != ETH_TOKEN_ADDRESS) //"fake" trade. (ether to ether) - don&#39;t burn.\n', '            require(feeBurnerContract.handleFees(weiAmount, rateResult.reserve2, tradeInput.walletId));\n', '\n', '        KyberTrade({\n', '            trader: tradeInput.trader,\n', '            src: tradeInput.src,\n', '            dest: tradeInput.dest,\n', '            srcAmount: actualSrcAmount,\n', '            dstAmount: actualDestAmount,\n', '            destAddress: tradeInput.destAddress,\n', '            ethWeiValue: weiAmount,\n', '            reserve1: (tradeInput.src == ETH_TOKEN_ADDRESS) ? address(0) : rateResult.reserve1,\n', '            reserve2:  (tradeInput.dest == ETH_TOKEN_ADDRESS) ? address(0) : rateResult.reserve2,\n', '            hint: tradeInput.hint\n', '        });\n', '\n', '        return actualDestAmount;\n', '    }\n', '    /* solhint-enable function-max-lines */\n', '\n', '    function calcActualAmounts (ERC20 src, ERC20 dest, uint srcAmount, uint maxDestAmount, BestRateResult rateResult)\n', '        internal view returns(uint actualSrcAmount, uint weiAmount, uint actualDestAmount)\n', '    {\n', '        if (rateResult.destAmount > maxDestAmount) {\n', '            actualDestAmount = maxDestAmount;\n', '            weiAmount = calcSrcAmount(ETH_TOKEN_ADDRESS, dest, actualDestAmount, rateResult.rateEthToDest);\n', '            actualSrcAmount = calcSrcAmount(src, ETH_TOKEN_ADDRESS, weiAmount, rateResult.rateSrcToEth);\n', '            require(actualSrcAmount <= srcAmount);\n', '        } else {\n', '            actualDestAmount = rateResult.destAmount;\n', '            actualSrcAmount = srcAmount;\n', '            weiAmount = rateResult.weiAmount;\n', '        }\n', '    }\n', '\n', '    /// @notice use token address ETH_TOKEN_ADDRESS for ether\n', '    /// @dev do one trade with a reserve\n', '    /// @param src Src token\n', '    /// @param amount amount of src tokens\n', '    /// @param dest   Destination token\n', '    /// @param destAddress Address to send tokens to\n', '    /// @param reserve Reserve to use\n', '    /// @param validate If true, additional validations are applicable\n', '    /// @return true if trade is successful\n', '    function doReserveTrade(\n', '        ERC20 src,\n', '        uint amount,\n', '        ERC20 dest,\n', '        address destAddress,\n', '        uint expectedDestAmount,\n', '        KyberReserveInterface reserve,\n', '        uint conversionRate,\n', '        bool validate\n', '    )\n', '        internal\n', '        returns(bool)\n', '    {\n', '        uint callValue = 0;\n', '\n', '        if (src == dest) {\n', '            //this is for a "fake" trade when both src and dest are ethers.\n', '            if (destAddress != (address(this)))\n', '                destAddress.transfer(amount);\n', '            return true;\n', '        }\n', '\n', '        if (src == ETH_TOKEN_ADDRESS) {\n', '            callValue = amount;\n', '        }\n', '\n', '        // reserve sends tokens/eth to network. network sends it to destination\n', '        require(reserve.trade.value(callValue)(src, amount, dest, this, conversionRate, validate));\n', '\n', '        if (destAddress != address(this)) {\n', '            //for token to token dest address is network. and Ether / token already here...\n', '            if (dest == ETH_TOKEN_ADDRESS) {\n', '                destAddress.transfer(expectedDestAmount);\n', '            } else {\n', '                require(dest.transfer(destAddress, expectedDestAmount));\n', '            }\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    /// when user sets max dest amount we could have too many source tokens == change. so we send it back to user.\n', '    function handleChange (ERC20 src, uint srcAmount, uint requiredSrcAmount, address trader) internal returns (bool) {\n', '\n', '        if (requiredSrcAmount < srcAmount) {\n', '            //if there is "change" send back to trader\n', '            if (src == ETH_TOKEN_ADDRESS) {\n', '                trader.transfer(srcAmount - requiredSrcAmount);\n', '            } else {\n', '                require(src.transfer(trader, (srcAmount - requiredSrcAmount)));\n', '            }\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    /// @notice use token address ETH_TOKEN_ADDRESS for ether\n', '    /// @dev checks that user sent ether/tokens to contract before trade\n', '    /// @param src Src token\n', '    /// @param srcAmount amount of src tokens\n', '    /// @return true if tradeInput is valid\n', '    function validateTradeInput(ERC20 src, uint srcAmount, ERC20 dest, address destAddress)\n', '        internal\n', '        view\n', '        returns(bool)\n', '    {\n', '        require(srcAmount <= MAX_QTY);\n', '        require(srcAmount != 0);\n', '        require(destAddress != address(0));\n', '        require(src != dest);\n', '\n', '        if (src == ETH_TOKEN_ADDRESS) {\n', '            require(msg.value == srcAmount);\n', '        } else {\n', '            require(msg.value == 0);\n', '            //funds should have been moved to this contract already.\n', '            require(src.balanceOf(this) >= srcAmount);\n', '        }\n', '\n', '        return true;\n', '    }\n', '}']