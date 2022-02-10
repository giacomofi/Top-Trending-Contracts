['pragma solidity 0.4.18;\n', '\n', '// File: contracts/FeeBurnerInterface.sol\n', '\n', 'interface FeeBurnerInterface {\n', '    function handleFees (uint tradeWeiAmount, address reserve, address wallet) public returns(bool);\n', '    function setReserveData(address reserve, uint feesInBps, address kncWallet) public;\n', '}\n', '\n', '// File: contracts/ERC20Interface.sol\n', '\n', '// https://github.com/ethereum/EIPs/issues/20\n', 'interface ERC20 {\n', '    function totalSupply() public view returns (uint supply);\n', '    function balanceOf(address _owner) public view returns (uint balance);\n', '    function transfer(address _to, uint _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success);\n', '    function approve(address _spender, uint _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public view returns (uint remaining);\n', '    function decimals() public view returns(uint digits);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '\n', '// File: contracts/KyberNetworkInterface.sol\n', '\n', '/// @title Kyber Network interface\n', 'interface KyberNetworkInterface {\n', '    function maxGasPrice() public view returns(uint);\n', '    function getUserCapInWei(address user) public view returns(uint);\n', '    function getUserCapInTokenWei(address user, ERC20 token) public view returns(uint);\n', '    function enabled() public view returns(bool);\n', '    function info(bytes32 id) public view returns(uint);\n', '\n', '    function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty) public view\n', '        returns (uint expectedRate, uint slippageRate);\n', '\n', '    function tradeWithHint(address trader, ERC20 src, uint srcAmount, ERC20 dest, address destAddress,\n', '        uint maxDestAmount, uint minConversionRate, address walletId, bytes hint) public payable returns(uint);\n', '}\n', '\n', '// File: contracts/Utils.sol\n', '\n', '/// @title Kyber constants contract\n', 'contract Utils {\n', '\n', '    ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);\n', '    uint  constant internal PRECISION = (10**18);\n', '    uint  constant internal MAX_QTY   = (10**28); // 10B tokens\n', '    uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH\n', '    uint  constant internal MAX_DECIMALS = 18;\n', '    uint  constant internal ETH_DECIMALS = 18;\n', '    mapping(address=>uint) internal decimals;\n', '\n', '    function setDecimals(ERC20 token) internal {\n', '        if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;\n', '        else decimals[token] = token.decimals();\n', '    }\n', '\n', '    function getDecimals(ERC20 token) internal view returns(uint) {\n', '        if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access\n', '        uint tokenDecimals = decimals[token];\n', '        // technically, there might be token with decimals 0\n', '        // moreover, very possible that old tokens have decimals 0\n', '        // these tokens will just have higher gas fees.\n', '        if(tokenDecimals == 0) return token.decimals();\n', '\n', '        return tokenDecimals;\n', '    }\n', '\n', '    function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {\n', '        require(srcQty <= MAX_QTY);\n', '        require(rate <= MAX_RATE);\n', '\n', '        if (dstDecimals >= srcDecimals) {\n', '            require((dstDecimals - srcDecimals) <= MAX_DECIMALS);\n', '            return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;\n', '        } else {\n', '            require((srcDecimals - dstDecimals) <= MAX_DECIMALS);\n', '            return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));\n', '        }\n', '    }\n', '\n', '    function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {\n', '        require(dstQty <= MAX_QTY);\n', '        require(rate <= MAX_RATE);\n', '        \n', '        //source quantity is rounded up. to avoid dest quantity being too low.\n', '        uint numerator;\n', '        uint denominator;\n', '        if (srcDecimals >= dstDecimals) {\n', '            require((srcDecimals - dstDecimals) <= MAX_DECIMALS);\n', '            numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));\n', '            denominator = rate;\n', '        } else {\n', '            require((dstDecimals - srcDecimals) <= MAX_DECIMALS);\n', '            numerator = (PRECISION * dstQty);\n', '            denominator = (rate * (10**(dstDecimals - srcDecimals)));\n', '        }\n', '        return (numerator + denominator - 1) / denominator; //avoid rounding down errors\n', '    }\n', '}\n', '\n', '// File: contracts/Utils2.sol\n', '\n', 'contract Utils2 is Utils {\n', '\n', '    /// @dev get the balance of a user.\n', '    /// @param token The token type\n', '    /// @return The balance\n', '    function getBalance(ERC20 token, address user) public view returns(uint) {\n', '        if (token == ETH_TOKEN_ADDRESS)\n', '            return user.balance;\n', '        else\n', '            return token.balanceOf(user);\n', '    }\n', '\n', '    function getDecimalsSafe(ERC20 token) internal returns(uint) {\n', '\n', '        if (decimals[token] == 0) {\n', '            setDecimals(token);\n', '        }\n', '\n', '        return decimals[token];\n', '    }\n', '\n', '    function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal view returns(uint) {\n', '        return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);\n', '    }\n', '\n', '    function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal view returns(uint) {\n', '        return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);\n', '    }\n', '\n', '    function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)\n', '        internal pure returns(uint)\n', '    {\n', '        require(srcAmount <= MAX_QTY);\n', '        require(destAmount <= MAX_QTY);\n', '\n', '        if (dstDecimals >= srcDecimals) {\n', '            require((dstDecimals - srcDecimals) <= MAX_DECIMALS);\n', '            return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));\n', '        } else {\n', '            require((srcDecimals - dstDecimals) <= MAX_DECIMALS);\n', '            return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/PermissionGroups.sol\n', '\n', 'contract PermissionGroups {\n', '\n', '    address public admin;\n', '    address public pendingAdmin;\n', '    mapping(address=>bool) internal operators;\n', '    mapping(address=>bool) internal alerters;\n', '    address[] internal operatorsGroup;\n', '    address[] internal alertersGroup;\n', '    uint constant internal MAX_GROUP_SIZE = 50;\n', '\n', '    function PermissionGroups() public {\n', '        admin = msg.sender;\n', '    }\n', '\n', '    modifier onlyAdmin() {\n', '        require(msg.sender == admin);\n', '        _;\n', '    }\n', '\n', '    modifier onlyOperator() {\n', '        require(operators[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    modifier onlyAlerter() {\n', '        require(alerters[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    function getOperators () external view returns(address[]) {\n', '        return operatorsGroup;\n', '    }\n', '\n', '    function getAlerters () external view returns(address[]) {\n', '        return alertersGroup;\n', '    }\n', '\n', '    event TransferAdminPending(address pendingAdmin);\n', '\n', '    /**\n', '     * @dev Allows the current admin to set the pendingAdmin address.\n', '     * @param newAdmin The address to transfer ownership to.\n', '     */\n', '    function transferAdmin(address newAdmin) public onlyAdmin {\n', '        require(newAdmin != address(0));\n', '        TransferAdminPending(pendingAdmin);\n', '        pendingAdmin = newAdmin;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.\n', '     * @param newAdmin The address to transfer ownership to.\n', '     */\n', '    function transferAdminQuickly(address newAdmin) public onlyAdmin {\n', '        require(newAdmin != address(0));\n', '        TransferAdminPending(newAdmin);\n', '        AdminClaimed(newAdmin, admin);\n', '        admin = newAdmin;\n', '    }\n', '\n', '    event AdminClaimed( address newAdmin, address previousAdmin);\n', '\n', '    /**\n', '     * @dev Allows the pendingAdmin address to finalize the change admin process.\n', '     */\n', '    function claimAdmin() public {\n', '        require(pendingAdmin == msg.sender);\n', '        AdminClaimed(pendingAdmin, admin);\n', '        admin = pendingAdmin;\n', '        pendingAdmin = address(0);\n', '    }\n', '\n', '    event AlerterAdded (address newAlerter, bool isAdd);\n', '\n', '    function addAlerter(address newAlerter) public onlyAdmin {\n', '        require(!alerters[newAlerter]); // prevent duplicates.\n', '        require(alertersGroup.length < MAX_GROUP_SIZE);\n', '\n', '        AlerterAdded(newAlerter, true);\n', '        alerters[newAlerter] = true;\n', '        alertersGroup.push(newAlerter);\n', '    }\n', '\n', '    function removeAlerter (address alerter) public onlyAdmin {\n', '        require(alerters[alerter]);\n', '        alerters[alerter] = false;\n', '\n', '        for (uint i = 0; i < alertersGroup.length; ++i) {\n', '            if (alertersGroup[i] == alerter) {\n', '                alertersGroup[i] = alertersGroup[alertersGroup.length - 1];\n', '                alertersGroup.length--;\n', '                AlerterAdded(alerter, false);\n', '                break;\n', '            }\n', '        }\n', '    }\n', '\n', '    event OperatorAdded(address newOperator, bool isAdd);\n', '\n', '    function addOperator(address newOperator) public onlyAdmin {\n', '        require(!operators[newOperator]); // prevent duplicates.\n', '        require(operatorsGroup.length < MAX_GROUP_SIZE);\n', '\n', '        OperatorAdded(newOperator, true);\n', '        operators[newOperator] = true;\n', '        operatorsGroup.push(newOperator);\n', '    }\n', '\n', '    function removeOperator (address operator) public onlyAdmin {\n', '        require(operators[operator]);\n', '        operators[operator] = false;\n', '\n', '        for (uint i = 0; i < operatorsGroup.length; ++i) {\n', '            if (operatorsGroup[i] == operator) {\n', '                operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];\n', '                operatorsGroup.length -= 1;\n', '                OperatorAdded(operator, false);\n', '                break;\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/Withdrawable.sol\n', '\n', '/**\n', ' * @title Contracts that should be able to recover tokens or ethers\n', ' * @author Ilan Doron\n', ' * @dev This allows to recover any tokens or Ethers received in a contract.\n', ' * This will prevent any accidental loss of tokens.\n', ' */\n', 'contract Withdrawable is PermissionGroups {\n', '\n', '    event TokenWithdraw(ERC20 token, uint amount, address sendTo);\n', '\n', '    /**\n', '     * @dev Withdraw all ERC20 compatible tokens\n', '     * @param token ERC20 The address of the token contract\n', '     */\n', '    function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {\n', '        require(token.transfer(sendTo, amount));\n', '        TokenWithdraw(token, amount, sendTo);\n', '    }\n', '\n', '    event EtherWithdraw(uint amount, address sendTo);\n', '\n', '    /**\n', '     * @dev Withdraw Ethers\n', '     */\n', '    function withdrawEther(uint amount, address sendTo) external onlyAdmin {\n', '        sendTo.transfer(amount);\n', '        EtherWithdraw(amount, sendTo);\n', '    }\n', '}\n', '\n', '// File: contracts/FeeBurner.sol\n', '\n', 'interface BurnableToken {\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool);\n', '    function burnFrom(address _from, uint256 _value) public returns (bool);\n', '}\n', '\n', '\n', 'contract FeeBurner is Withdrawable, FeeBurnerInterface, Utils2 {\n', '\n', '    mapping(address=>uint) public reserveFeesInBps;\n', '    mapping(address=>address) public reserveKNCWallet; //wallet holding knc per reserve. from here burn and send fees.\n', '    mapping(address=>uint) public walletFeesInBps; // wallet that is the source of tx is entitled so some fees.\n', '    mapping(address=>uint) public reserveFeeToBurn;\n', '    mapping(address=>uint) public feePayedPerReserve; // track burned fees and sent wallet fees per reserve.\n', '    mapping(address=>mapping(address=>uint)) public reserveFeeToWallet;\n', '    address public taxWallet;\n', '    uint public taxFeeBps = 0; // burned fees are taxed. % out of burned fees.\n', '\n', '    BurnableToken public knc;\n', '    KyberNetworkInterface public kyberNetwork;\n', '    uint public kncPerEthRatePrecision = 600 * PRECISION; //--> 1 ether = 600 knc tokens\n', '\n', '    function FeeBurner(\n', '        address _admin,\n', '        BurnableToken _kncToken,\n', '        KyberNetworkInterface _kyberNetwork,\n', '        uint _initialKncToEthRatePrecision\n', '    )\n', '        public\n', '    {\n', '        require(_admin != address(0));\n', '        require(_kncToken != address(0));\n', '        require(_kyberNetwork != address(0));\n', '        require(_initialKncToEthRatePrecision != 0);\n', '\n', '        kyberNetwork = _kyberNetwork;\n', '        admin = _admin;\n', '        knc = _kncToken;\n', '        kncPerEthRatePrecision = _initialKncToEthRatePrecision;\n', '    }\n', '\n', '    event ReserveDataSet(address reserve, uint feeInBps, address kncWallet);\n', '\n', '    function setReserveData(address reserve, uint feesInBps, address kncWallet) public onlyOperator {\n', '        require(feesInBps < 100); // make sure it is always < 1%\n', '        require(kncWallet != address(0));\n', '        reserveFeesInBps[reserve] = feesInBps;\n', '        reserveKNCWallet[reserve] = kncWallet;\n', '        ReserveDataSet(reserve, feesInBps, kncWallet);\n', '    }\n', '\n', '    event WalletFeesSet(address wallet, uint feesInBps);\n', '\n', '    function setWalletFees(address wallet, uint feesInBps) public onlyAdmin {\n', '        require(feesInBps < 10000); // under 100%\n', '        walletFeesInBps[wallet] = feesInBps;\n', '        WalletFeesSet(wallet, feesInBps);\n', '    }\n', '\n', '    event TaxFeesSet(uint feesInBps);\n', '\n', '    function setTaxInBps(uint _taxFeeBps) public onlyAdmin {\n', '        require(_taxFeeBps < 10000); // under 100%\n', '        taxFeeBps = _taxFeeBps;\n', '        TaxFeesSet(_taxFeeBps);\n', '    }\n', '\n', '    event TaxWalletSet(address taxWallet);\n', '\n', '    function setTaxWallet(address _taxWallet) public onlyAdmin {\n', '        require(_taxWallet != address(0));\n', '        taxWallet = _taxWallet;\n', '        TaxWalletSet(_taxWallet);\n', '    }\n', '\n', '    event KNCRateSet(uint ethToKncRatePrecision, uint kyberEthKnc, uint kyberKncEth, address updater);\n', '\n', '    function setKNCRate() public {\n', '        //query kyber for knc rate sell and buy\n', '        uint kyberEthKncRate;\n', '        uint kyberKncEthRate;\n', '        (kyberEthKncRate, ) = kyberNetwork.getExpectedRate(ETH_TOKEN_ADDRESS, ERC20(knc), (10 ** 18));\n', '        (kyberKncEthRate, ) = kyberNetwork.getExpectedRate(ERC20(knc), ETH_TOKEN_ADDRESS, (10 ** 18));\n', '\n', '        //check "reasonable" spread == diff not too big. rate wasn&#39;t tampered.\n', '        require(kyberEthKncRate * kyberKncEthRate < PRECISION ** 2 * 2);\n', '        require(kyberEthKncRate * kyberKncEthRate > PRECISION ** 2 / 2);\n', '\n', '        require(kyberEthKncRate <= MAX_RATE);\n', '        kncPerEthRatePrecision = kyberEthKncRate;\n', '        KNCRateSet(kncPerEthRatePrecision, kyberEthKncRate, kyberKncEthRate, msg.sender);\n', '    }\n', '\n', '    event AssignFeeToWallet(address reserve, address wallet, uint walletFee);\n', '    event AssignBurnFees(address reserve, uint burnFee);\n', '\n', '    function handleFees(uint tradeWeiAmount, address reserve, address wallet) public returns(bool) {\n', '        require(msg.sender == address(kyberNetwork));\n', '        require(tradeWeiAmount <= MAX_QTY);\n', '\n', '        uint kncAmount = calcDestAmount(ETH_TOKEN_ADDRESS, ERC20(knc), tradeWeiAmount, kncPerEthRatePrecision);\n', '        uint fee = kncAmount * reserveFeesInBps[reserve] / 10000;\n', '\n', '        uint walletFee = fee * walletFeesInBps[wallet] / 10000;\n', '        require(fee >= walletFee);\n', '        uint feeToBurn = fee - walletFee;\n', '\n', '        if (walletFee > 0) {\n', '            reserveFeeToWallet[reserve][wallet] += walletFee;\n', '            AssignFeeToWallet(reserve, wallet, walletFee);\n', '        }\n', '\n', '        if (feeToBurn > 0) {\n', '            AssignBurnFees(reserve, feeToBurn);\n', '            reserveFeeToBurn[reserve] += feeToBurn;\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    event BurnAssignedFees(address indexed reserve, address sender, uint quantity);\n', '\n', '    event SendTaxFee(address indexed reserve, address sender, address taxWallet, uint quantity);\n', '\n', '    // this function is callable by anyone\n', '    function burnReserveFees(address reserve) public {\n', '        uint burnAmount = reserveFeeToBurn[reserve];\n', '        uint taxToSend = 0;\n', '        require(burnAmount > 2);\n', '        reserveFeeToBurn[reserve] = 1; // leave 1 twei to avoid spikes in gas fee\n', '        if (taxWallet != address(0) && taxFeeBps != 0) {\n', '            taxToSend = (burnAmount - 1) * taxFeeBps / 10000;\n', '            require(burnAmount - 1 > taxToSend);\n', '            burnAmount -= taxToSend;\n', '            if (taxToSend > 0) {\n', '                require(knc.transferFrom(reserveKNCWallet[reserve], taxWallet, taxToSend));\n', '                SendTaxFee(reserve, msg.sender, taxWallet, taxToSend);\n', '            }\n', '        }\n', '        require(knc.burnFrom(reserveKNCWallet[reserve], burnAmount - 1));\n', '\n', '        //update reserve "payments" so far\n', '        feePayedPerReserve[reserve] += (taxToSend + burnAmount - 1);\n', '\n', '        BurnAssignedFees(reserve, msg.sender, (burnAmount - 1));\n', '    }\n', '\n', '    event SendWalletFees(address indexed wallet, address reserve, address sender);\n', '\n', '    // this function is callable by anyone\n', '    function sendFeeToWallet(address wallet, address reserve) public {\n', '        uint feeAmount = reserveFeeToWallet[reserve][wallet];\n', '        require(feeAmount > 1);\n', '        reserveFeeToWallet[reserve][wallet] = 1; // leave 1 twei to avoid spikes in gas fee\n', '        require(knc.transferFrom(reserveKNCWallet[reserve], wallet, feeAmount - 1));\n', '\n', '        feePayedPerReserve[reserve] += (feeAmount - 1);\n', '        SendWalletFees(wallet, reserve, msg.sender);\n', '    }\n', '}\n', '\n', '// File: contracts/wrapperContracts/WrapperBase.sol\n', '\n', 'contract WrapperBase is Withdrawable {\n', '\n', '    PermissionGroups public wrappedContract;\n', '\n', '    struct DataTracker {\n', '        address [] approveSignatureArray;\n', '        uint lastSetNonce;\n', '    }\n', '\n', '    DataTracker[] internal dataInstances;\n', '\n', '    function WrapperBase(PermissionGroups _wrappedContract, address _admin, uint _numDataInstances) public {\n', '        require(_wrappedContract != address(0));\n', '        require(_admin != address(0));\n', '        wrappedContract = _wrappedContract;\n', '        admin = _admin;\n', '\n', '        for (uint i = 0; i < _numDataInstances; i++){\n', '            addDataInstance();\n', '        }\n', '    }\n', '\n', '    function claimWrappedContractAdmin() public onlyOperator {\n', '        wrappedContract.claimAdmin();\n', '    }\n', '\n', '    function transferWrappedContractAdmin (address newAdmin) public onlyAdmin {\n', '        wrappedContract.transferAdmin(newAdmin);\n', '    }\n', '\n', '    function addDataInstance() internal {\n', '        address[] memory add = new address[](0);\n', '        dataInstances.push(DataTracker(add, 0));\n', '    }\n', '\n', '    function setNewData(uint dataIndex) internal {\n', '        require(dataIndex < dataInstances.length);\n', '        dataInstances[dataIndex].lastSetNonce++;\n', '        dataInstances[dataIndex].approveSignatureArray.length = 0;\n', '    }\n', '\n', '    function addSignature(uint dataIndex, uint signedNonce, address signer) internal returns(bool allSigned) {\n', '        require(dataIndex < dataInstances.length);\n', '        require(dataInstances[dataIndex].lastSetNonce == signedNonce);\n', '\n', '        for(uint i = 0; i < dataInstances[dataIndex].approveSignatureArray.length; i++) {\n', '            if (signer == dataInstances[dataIndex].approveSignatureArray[i]) revert();\n', '        }\n', '        dataInstances[dataIndex].approveSignatureArray.push(signer);\n', '\n', '        if (dataInstances[dataIndex].approveSignatureArray.length == operatorsGroup.length) {\n', '            allSigned = true;\n', '        } else {\n', '            allSigned = false;\n', '        }\n', '    }\n', '\n', '    function getDataTrackingParameters(uint index) internal view returns (address[], uint) {\n', '        require(index < dataInstances.length);\n', '        return(dataInstances[index].approveSignatureArray, dataInstances[index].lastSetNonce);\n', '    }\n', '}\n', '\n', '// File: contracts/wrapperContracts/WrapFeeBurner.sol\n', '\n', 'contract WrapFeeBurner is WrapperBase {\n', '\n', '    FeeBurner public feeBurnerContract;\n', '    address[] internal feeSharingWallets;\n', '    uint public feeSharingBps = 3000; // out of 10000 = 30%\n', '\n', '    //add reserve pending data\n', '    struct AddReserveData {\n', '        address reserve;\n', '        uint    feeBps;\n', '        address kncWallet;\n', '    }\n', '\n', '    AddReserveData internal addReserve;\n', '\n', '    //wallet fee pending parameters\n', '    struct WalletFee {\n', '        address walletAddress;\n', '        uint    feeBps;\n', '    }\n', '\n', '    WalletFee internal walletFee;\n', '\n', '    //tax pending parameters\n', '    struct TaxData {\n', '        address wallet;\n', '        uint    feeBps;\n', '    }\n', '\n', '    TaxData internal taxData;\n', '    \n', '    //data indexes\n', '    uint internal constant ADD_RESERVE_INDEX = 1;\n', '    uint internal constant WALLET_FEE_INDEX = 2;\n', '    uint internal constant TAX_DATA_INDEX = 3;\n', '    uint internal constant LAST_DATA_INDEX = 4;\n', '\n', '    //general functions\n', '    function WrapFeeBurner(FeeBurner feeBurner, address _admin) public\n', '        WrapperBase(PermissionGroups(address(feeBurner)), _admin, LAST_DATA_INDEX)\n', '    {\n', '        require(feeBurner != address(0));\n', '        feeBurnerContract = feeBurner;\n', '    }\n', '\n', '    //register wallets for fee sharing\n', '    /////////////////////////////////\n', '    function setFeeSharingValue(uint feeBps) public onlyAdmin {\n', '        require(feeBps < 10000);\n', '        feeSharingBps = feeBps;\n', '    }\n', '\n', '    function getFeeSharingWallets() public view returns(address[]) {\n', '        return feeSharingWallets;\n', '    }\n', '\n', '    event WalletRegisteredForFeeSharing(address sender, address walletAddress);\n', '    function registerWalletForFeeSharing(address walletAddress) public {\n', '        require(feeBurnerContract.walletFeesInBps(walletAddress) == 0);\n', '\n', '        // if fee sharing value is 0. means the wallet wasn&#39;t added.\n', '        feeBurnerContract.setWalletFees(walletAddress, feeSharingBps);\n', '        feeSharingWallets.push(walletAddress);\n', '        WalletRegisteredForFeeSharing(msg.sender, walletAddress);\n', '    }\n', '\n', '    //set reserve data\n', '    //////////////////\n', '    function setPendingReserveData(address reserve, uint feeBps, address kncWallet) public onlyOperator {\n', '        require(reserve != address(0));\n', '        require(kncWallet != address(0));\n', '        require(feeBps > 0);\n', '        require(feeBps < 10000);\n', '\n', '        addReserve.reserve = reserve;\n', '        addReserve.feeBps = feeBps;\n', '        addReserve.kncWallet = kncWallet;\n', '        setNewData(ADD_RESERVE_INDEX);\n', '    }\n', '\n', '    function getPendingAddReserveData() public view\n', '        returns(address reserve, uint feeBps, address kncWallet, uint nonce)\n', '    {\n', '        address[] memory signatures;\n', '        (signatures, nonce) = getDataTrackingParameters(ADD_RESERVE_INDEX);\n', '        return(addReserve.reserve, addReserve.feeBps, addReserve.kncWallet, nonce);\n', '    }\n', '\n', '    function getAddReserveSignatures() public view returns (address[] signatures) {\n', '        uint nonce;\n', '        (signatures, nonce) = getDataTrackingParameters(ADD_RESERVE_INDEX);\n', '        return(signatures);\n', '    }\n', '\n', '    function approveAddReserveData(uint nonce) public onlyOperator {\n', '        if (addSignature(ADD_RESERVE_INDEX, nonce, msg.sender)) {\n', '            // can perform operation.\n', '            feeBurnerContract.setReserveData(addReserve.reserve, addReserve.feeBps, addReserve.kncWallet);\n', '        }\n', '    }\n', '\n', '    //wallet fee\n', '    /////////////\n', '    function setPendingWalletFee(address wallet, uint feeBps) public onlyOperator {\n', '        require(wallet != address(0));\n', '        require(feeBps > 0);\n', '        require(feeBps < 10000);\n', '\n', '        walletFee.walletAddress = wallet;\n', '        walletFee.feeBps = feeBps;\n', '        setNewData(WALLET_FEE_INDEX);\n', '    }\n', '\n', '    function getPendingWalletFeeData() public view returns(address wallet, uint feeBps, uint nonce) {\n', '        address[] memory signatures;\n', '        (signatures, nonce) = getDataTrackingParameters(WALLET_FEE_INDEX);\n', '        return(walletFee.walletAddress, walletFee.feeBps, nonce);\n', '    }\n', '\n', '    function getWalletFeeSignatures() public view returns (address[] signatures) {\n', '        uint nonce;\n', '        (signatures, nonce) = getDataTrackingParameters(WALLET_FEE_INDEX);\n', '        return(signatures);\n', '    }\n', '\n', '    function approveWalletFeeData(uint nonce) public onlyOperator {\n', '        if (addSignature(WALLET_FEE_INDEX, nonce, msg.sender)) {\n', '            // can perform operation.\n', '            feeBurnerContract.setWalletFees(walletFee.walletAddress, walletFee.feeBps);\n', '        }\n', '    }\n', '\n', '    //tax parameters\n', '    ////////////////\n', '    function setPendingTaxParameters(address taxWallet, uint feeBps) public onlyOperator {\n', '        require(taxWallet != address(0));\n', '        require(feeBps > 0);\n', '        require(feeBps < 10000);\n', '\n', '        taxData.wallet = taxWallet;\n', '        taxData.feeBps = feeBps;\n', '        setNewData(TAX_DATA_INDEX);\n', '    }\n', '\n', '    function getPendingTaxData() public view returns(address wallet, uint feeBps, uint nonce) {\n', '        address[] memory signatures;\n', '        (signatures, nonce) = getDataTrackingParameters(TAX_DATA_INDEX);\n', '        return(taxData.wallet, taxData.feeBps, nonce);\n', '    }\n', '\n', '    function getTaxDataSignatures() public view returns (address[] signatures) {\n', '        uint nonce;\n', '        (signatures, nonce) = getDataTrackingParameters(TAX_DATA_INDEX);\n', '        return(signatures);\n', '    }\n', '\n', '    function approveTaxData(uint nonce) public onlyOperator {\n', '        if (addSignature(TAX_DATA_INDEX, nonce, msg.sender)) {\n', '            // can perform operation.\n', '            feeBurnerContract.setTaxInBps(taxData.feeBps);\n', '            feeBurnerContract.setTaxWallet(taxData.wallet);\n', '        }\n', '    }\n', '}']