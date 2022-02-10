['pragma solidity 0.4.18;\n', '\n', '// File: contracts/ERC20Interface.sol\n', '\n', '// https://github.com/ethereum/EIPs/issues/20\n', 'interface ERC20 {\n', '    function totalSupply() public view returns (uint supply);\n', '    function balanceOf(address _owner) public view returns (uint balance);\n', '    function transfer(address _to, uint _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success);\n', '    function approve(address _spender, uint _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public view returns (uint remaining);\n', '    function decimals() public view returns(uint digits);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '\n', '// File: contracts/ConversionRatesInterface.sol\n', '\n', 'interface ConversionRatesInterface {\n', '\n', '    function recordImbalance(\n', '        ERC20 token,\n', '        int buyAmount,\n', '        uint rateUpdateBlock,\n', '        uint currentBlock\n', '    )\n', '        public;\n', '\n', '    function getRate(ERC20 token, uint currentBlockNumber, bool buy, uint qty) public view returns(uint);\n', '}\n', '\n', '// File: contracts/KyberReserveInterface.sol\n', '\n', '/// @title Kyber Reserve contract\n', 'interface KyberReserveInterface {\n', '\n', '    function trade(\n', '        ERC20 srcToken,\n', '        uint srcAmount,\n', '        ERC20 destToken,\n', '        address destAddress,\n', '        uint conversionRate,\n', '        bool validate\n', '    )\n', '        public\n', '        payable\n', '        returns(bool);\n', '\n', '    function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint);\n', '}\n', '\n', '// File: contracts/SanityRatesInterface.sol\n', '\n', 'interface SanityRatesInterface {\n', '    function getSanityRate(ERC20 src, ERC20 dest) public view returns(uint);\n', '}\n', '\n', '// File: contracts/Utils.sol\n', '\n', '/// @title Kyber constants contract\n', 'contract Utils {\n', '\n', '    ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);\n', '    uint  constant internal PRECISION = (10**18);\n', '    uint  constant internal MAX_QTY   = (10**28); // 10B tokens\n', '    uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH\n', '    uint  constant internal MAX_DECIMALS = 18;\n', '    uint  constant internal ETH_DECIMALS = 18;\n', '    mapping(address=>uint) internal decimals;\n', '\n', '    function setDecimals(ERC20 token) internal {\n', '        if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;\n', '        else decimals[token] = token.decimals();\n', '    }\n', '\n', '    function getDecimals(ERC20 token) internal view returns(uint) {\n', '        if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access\n', '        uint tokenDecimals = decimals[token];\n', '        // technically, there might be token with decimals 0\n', '        // moreover, very possible that old tokens have decimals 0\n', '        // these tokens will just have higher gas fees.\n', '        if(tokenDecimals == 0) return token.decimals();\n', '\n', '        return tokenDecimals;\n', '    }\n', '\n', '    function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {\n', '        require(srcQty <= MAX_QTY);\n', '        require(rate <= MAX_RATE);\n', '\n', '        if (dstDecimals >= srcDecimals) {\n', '            require((dstDecimals - srcDecimals) <= MAX_DECIMALS);\n', '            return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;\n', '        } else {\n', '            require((srcDecimals - dstDecimals) <= MAX_DECIMALS);\n', '            return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));\n', '        }\n', '    }\n', '\n', '    function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {\n', '        require(dstQty <= MAX_QTY);\n', '        require(rate <= MAX_RATE);\n', '        \n', '        //source quantity is rounded up. to avoid dest quantity being too low.\n', '        uint numerator;\n', '        uint denominator;\n', '        if (srcDecimals >= dstDecimals) {\n', '            require((srcDecimals - dstDecimals) <= MAX_DECIMALS);\n', '            numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));\n', '            denominator = rate;\n', '        } else {\n', '            require((dstDecimals - srcDecimals) <= MAX_DECIMALS);\n', '            numerator = (PRECISION * dstQty);\n', '            denominator = (rate * (10**(dstDecimals - srcDecimals)));\n', '        }\n', '        return (numerator + denominator - 1) / denominator; //avoid rounding down errors\n', '    }\n', '}\n', '\n', '// File: contracts/PermissionGroups.sol\n', '\n', 'contract PermissionGroups {\n', '\n', '    address public admin;\n', '    address public pendingAdmin;\n', '    mapping(address=>bool) internal operators;\n', '    mapping(address=>bool) internal alerters;\n', '    address[] internal operatorsGroup;\n', '    address[] internal alertersGroup;\n', '    uint constant internal MAX_GROUP_SIZE = 50;\n', '\n', '    function PermissionGroups() public {\n', '        admin = msg.sender;\n', '    }\n', '\n', '    modifier onlyAdmin() {\n', '        require(msg.sender == admin);\n', '        _;\n', '    }\n', '\n', '    modifier onlyOperator() {\n', '        require(operators[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    modifier onlyAlerter() {\n', '        require(alerters[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    function getOperators () external view returns(address[]) {\n', '        return operatorsGroup;\n', '    }\n', '\n', '    function getAlerters () external view returns(address[]) {\n', '        return alertersGroup;\n', '    }\n', '\n', '    event TransferAdminPending(address pendingAdmin);\n', '\n', '    /**\n', '     * @dev Allows the current admin to set the pendingAdmin address.\n', '     * @param newAdmin The address to transfer ownership to.\n', '     */\n', '    function transferAdmin(address newAdmin) public onlyAdmin {\n', '        require(newAdmin != address(0));\n', '        TransferAdminPending(pendingAdmin);\n', '        pendingAdmin = newAdmin;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.\n', '     * @param newAdmin The address to transfer ownership to.\n', '     */\n', '    function transferAdminQuickly(address newAdmin) public onlyAdmin {\n', '        require(newAdmin != address(0));\n', '        TransferAdminPending(newAdmin);\n', '        AdminClaimed(newAdmin, admin);\n', '        admin = newAdmin;\n', '    }\n', '\n', '    event AdminClaimed( address newAdmin, address previousAdmin);\n', '\n', '    /**\n', '     * @dev Allows the pendingAdmin address to finalize the change admin process.\n', '     */\n', '    function claimAdmin() public {\n', '        require(pendingAdmin == msg.sender);\n', '        AdminClaimed(pendingAdmin, admin);\n', '        admin = pendingAdmin;\n', '        pendingAdmin = address(0);\n', '    }\n', '\n', '    event AlerterAdded (address newAlerter, bool isAdd);\n', '\n', '    function addAlerter(address newAlerter) public onlyAdmin {\n', '        require(!alerters[newAlerter]); // prevent duplicates.\n', '        require(alertersGroup.length < MAX_GROUP_SIZE);\n', '\n', '        AlerterAdded(newAlerter, true);\n', '        alerters[newAlerter] = true;\n', '        alertersGroup.push(newAlerter);\n', '    }\n', '\n', '    function removeAlerter (address alerter) public onlyAdmin {\n', '        require(alerters[alerter]);\n', '        alerters[alerter] = false;\n', '\n', '        for (uint i = 0; i < alertersGroup.length; ++i) {\n', '            if (alertersGroup[i] == alerter) {\n', '                alertersGroup[i] = alertersGroup[alertersGroup.length - 1];\n', '                alertersGroup.length--;\n', '                AlerterAdded(alerter, false);\n', '                break;\n', '            }\n', '        }\n', '    }\n', '\n', '    event OperatorAdded(address newOperator, bool isAdd);\n', '\n', '    function addOperator(address newOperator) public onlyAdmin {\n', '        require(!operators[newOperator]); // prevent duplicates.\n', '        require(operatorsGroup.length < MAX_GROUP_SIZE);\n', '\n', '        OperatorAdded(newOperator, true);\n', '        operators[newOperator] = true;\n', '        operatorsGroup.push(newOperator);\n', '    }\n', '\n', '    function removeOperator (address operator) public onlyAdmin {\n', '        require(operators[operator]);\n', '        operators[operator] = false;\n', '\n', '        for (uint i = 0; i < operatorsGroup.length; ++i) {\n', '            if (operatorsGroup[i] == operator) {\n', '                operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];\n', '                operatorsGroup.length -= 1;\n', '                OperatorAdded(operator, false);\n', '                break;\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/Withdrawable.sol\n', '\n', '/**\n', ' * @title Contracts that should be able to recover tokens or ethers\n', ' * @author Ilan Doron\n', ' * @dev This allows to recover any tokens or Ethers received in a contract.\n', ' * This will prevent any accidental loss of tokens.\n', ' */\n', 'contract Withdrawable is PermissionGroups {\n', '\n', '    event TokenWithdraw(ERC20 token, uint amount, address sendTo);\n', '\n', '    /**\n', '     * @dev Withdraw all ERC20 compatible tokens\n', '     * @param token ERC20 The address of the token contract\n', '     */\n', '    function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {\n', '        require(token.transfer(sendTo, amount));\n', '        TokenWithdraw(token, amount, sendTo);\n', '    }\n', '\n', '    event EtherWithdraw(uint amount, address sendTo);\n', '\n', '    /**\n', '     * @dev Withdraw Ethers\n', '     */\n', '    function withdrawEther(uint amount, address sendTo) external onlyAdmin {\n', '        sendTo.transfer(amount);\n', '        EtherWithdraw(amount, sendTo);\n', '    }\n', '}\n', '\n', '// File: contracts/DigixReserve.sol\n', '\n', 'interface MakerDao {\n', '    function peek() public view returns (bytes32, bool);\n', '}\n', '\n', 'contract DigixReserve is KyberReserveInterface, Withdrawable, Utils {\n', '\n', '    ERC20 public digix;\n', '    MakerDao public makerDaoContract;\n', '    ConversionRatesInterface public conversionRatesContract;\n', '    SanityRatesInterface public sanityRatesContract;\n', '    address public kyberNetwork;\n', '    uint maxBlockDrift = 300;\n', '    mapping(bytes32=>bool) public approvedWithdrawAddresses; // sha3(token,address)=>bool\n', '    uint public priceFeed;\n', '    bool public tradeEnabled;\n', '    uint constant internal POW_2_64 = 2 ** 64;\n', '    uint constant internal etherWei = 10 ** 18;\n', '    uint public buyTransferFee = 13;\n', '    uint public sellTransferFee = 13;\n', '\n', '\n', '    function DigixReserve(address _admin, address _kyberNetwork, ERC20 _digix) public{\n', '        require(_admin != address(0));\n', '        require(_digix != address(0));\n', '        require(_kyberNetwork != address(0));\n', '        admin = _admin;\n', '        digix = _digix;\n', '        setDecimals(digix);\n', '        kyberNetwork = _kyberNetwork;\n', '        sanityRatesContract = SanityRatesInterface(0);\n', '        conversionRatesContract = ConversionRatesInterface(0x901d);\n', '        tradeEnabled = true;\n', '    }\n', '\n', '    function () public payable {}\n', '\n', '    /// @dev Add digix price feed. Valid for @maxBlockDrift blocks\n', '    /// @param blockNumber the block this price feed was signed.\n', '    /// @param nonce the nonce with which this block was signed.\n', '    /// @param ask1KDigix ask price dollars per Kg gold == 1000 digix\n', '    /// @param bid1KDigix bid price dollars per KG gold == 1000 digix\n', '    /// @param v - v part of signature of keccak 256 hash of (block, nonce, ask, bid)\n', '    /// @param r - r part of signature of keccak 256 hash of (block, nonce, ask, bid)\n', '    /// @param s - s part of signature of keccak 256 hash of (block, nonce, ask, bid)\n', '    function setPriceFeed(\n', '        uint blockNumber,\n', '        uint nonce,\n', '        uint ask1KDigix,\n', '        uint bid1KDigix,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '        ) public\n', '    {\n', '        uint prevFeedBlock;\n', '        uint prevNonce;\n', '        uint prevAsk;\n', '        uint prevBid;\n', '\n', '        (prevFeedBlock, prevNonce, prevAsk, prevBid) = getPriceFeed();\n', '        require(nonce > prevNonce);\n', '        require(blockNumber + maxBlockDrift > block.number);\n', '        require(blockNumber <= block.number);\n', '\n', '        require(verifySignature(keccak256(blockNumber, nonce, ask1KDigix, bid1KDigix), v, r, s));\n', '\n', '        priceFeed = encodePriceFeed(blockNumber, nonce, ask1KDigix, bid1KDigix);\n', '    }\n', '\n', '    function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint) {\n', '        if (!tradeEnabled) return 0;\n', '        if (makerDaoContract == MakerDao(0)) return 0;\n', '        uint feedBlock;\n', '        uint nonce;\n', '        uint ask1KDigix;\n', '        uint bid1KDigix;\n', '        blockNumber;\n', '\n', '        (feedBlock, nonce, ask1KDigix, bid1KDigix) = getPriceFeed();\n', '        if (feedBlock + maxBlockDrift <= block.number) return 0;\n', '\n', '        // wei per dollar from makerDao\n', '        bool isRateValid;\n', '        bytes32 dollarsPerEtherWei; //price in dollars of 1 Ether * 10**18\n', '        (dollarsPerEtherWei, isRateValid) = makerDaoContract.peek();\n', '        if (!isRateValid || uint(dollarsPerEtherWei) > MAX_RATE) return 0;\n', '\n', '        uint rate;\n', '        if (ETH_TOKEN_ADDRESS == src && digix == dest) {\n', '            //buy digix with ether == sell ether\n', '            rate = 1000 * uint(dollarsPerEtherWei) * PRECISION / etherWei / ask1KDigix;\n', '        } else if (digix == src && ETH_TOKEN_ADDRESS == dest) {\n', '            //sell digix == buy ether with digix\n', '            rate = bid1KDigix * etherWei * PRECISION / uint(dollarsPerEtherWei) / 1000;\n', '        } else {\n', '            return 0;\n', '        }\n', '\n', '        if (rate > MAX_RATE) return 0;\n', '\n', '        uint destQty = getDestQty(src, dest, srcQty, rate);\n', '\n', '        if (getBalance(dest) < destQty) return 0;\n', '\n', '//        if (sanityRatesContract != address(0)) {\n', '//            uint sanityRate = sanityRatesContract.getSanityRate(src, dest);\n', '//            if (rate > sanityRate) return 0;\n', '//        }\n', '        return rate;\n', '    }\n', '\n', '    function getPriceFeed() public view returns(uint feedBlock, uint nonce, uint ask1KDigix, uint bid1KDigix) {\n', '        (feedBlock, nonce, ask1KDigix, bid1KDigix) = decodePriceFeed(priceFeed);\n', '    }\n', '\n', '    event TradeExecute(\n', '        address indexed origin,\n', '        address src,\n', '        uint srcAmount,\n', '        address destToken,\n', '        uint destAmount,\n', '        address destAddress\n', '    );\n', '\n', '    function trade(\n', '        ERC20 srcToken,\n', '        uint srcAmount,\n', '        ERC20 destToken,\n', '        address destAddress,\n', '        uint conversionRate,\n', '        bool validate\n', '    )\n', '        public\n', '        payable\n', '        returns(bool)\n', '    {\n', '        require(tradeEnabled);\n', '        require(msg.sender == kyberNetwork);\n', '\n', '        // can skip validation if done at kyber network level\n', '        if (validate) {\n', '            require(conversionRate > 0);\n', '            if (srcToken == ETH_TOKEN_ADDRESS) {\n', '                require(msg.value == srcAmount);\n', '                require(ERC20(destToken) == digix);\n', '            } else {\n', '                require(ERC20(srcToken) == digix);\n', '                require(msg.value == 0);\n', '            }\n', '        }\n', '\n', '        uint destAmount = getDestQty(srcToken, destToken, srcAmount, conversionRate);\n', '        uint adjustedAmount;\n', '        // sanity check\n', '        require(destAmount > 0);\n', '\n', '        // collect src tokens\n', '        if (srcToken != ETH_TOKEN_ADDRESS) {\n', '            //due to fee network has less tokens. take amount less fee. reduce 1 to avoid rounding errors.\n', '            adjustedAmount = (srcAmount * (10000 - sellTransferFee) / 10000) - 1;\n', '            require(srcToken.transferFrom(msg.sender, this, adjustedAmount));\n', '        }\n', '\n', '        // send dest tokens\n', '        if (destToken == ETH_TOKEN_ADDRESS) {\n', '            destAddress.transfer(destAmount);\n', '        } else {\n', '            //add 1 to compensate for rounding errors.\n', '            adjustedAmount = (destAmount * 10000 / (10000 - buyTransferFee)) + 1;\n', '            require(destToken.transfer(destAddress, adjustedAmount));\n', '        }\n', '\n', '        TradeExecute(msg.sender, srcToken, srcAmount, destToken, destAmount, destAddress);\n', '\n', '        return true;\n', '    }\n', '\n', '    event TradeEnabled(bool enable);\n', '\n', '    function enableTrade() public onlyAdmin returns(bool) {\n', '        tradeEnabled = true;\n', '        TradeEnabled(true);\n', '\n', '        return true;\n', '    }\n', '\n', '    function disableTrade() public onlyAlerter returns(bool) {\n', '        tradeEnabled = false;\n', '        TradeEnabled(false);\n', '\n', '        return true;\n', '    }\n', '\n', '    event WithdrawAddressApproved(ERC20 token, address addr, bool approve);\n', '\n', '    function approveWithdrawAddress(ERC20 token, address addr, bool approve) public onlyAdmin {\n', '        approvedWithdrawAddresses[keccak256(token, addr)] = approve;\n', '        WithdrawAddressApproved(token, addr, approve);\n', '\n', '        setDecimals(token);\n', '    }\n', '\n', '    event WithdrawFunds(ERC20 token, uint amount, address destination);\n', '\n', '    function withdraw(ERC20 token, uint amount, address destination) public onlyOperator returns(bool) {\n', '        require(approvedWithdrawAddresses[keccak256(token, destination)]);\n', '\n', '        if (token == ETH_TOKEN_ADDRESS) {\n', '            destination.transfer(amount);\n', '        } else {\n', '            require(token.transfer(destination, amount));\n', '        }\n', '\n', '        WithdrawFunds(token, amount, destination);\n', '\n', '        return true;\n', '    }\n', '\n', '    function setMakerDaoContract(MakerDao daoContract) public onlyAdmin{\n', '        require(daoContract != address(0));\n', '        makerDaoContract = daoContract;\n', '    }\n', '\n', '    function setKyberNetworkAddress(address _kyberNetwork) public onlyAdmin{\n', '        require(_kyberNetwork != address(0));\n', '        kyberNetwork = _kyberNetwork;\n', '    }\n', '\n', '    function setMaxBlockDrift(uint numBlocks) public onlyAdmin {\n', '        require(numBlocks > 1);\n', '        maxBlockDrift = numBlocks;\n', '    }\n', '\n', '    function setBuyFeeBps(uint fee) public onlyAdmin {\n', '        require(fee < 10000);\n', '        buyTransferFee = fee;\n', '    }\n', '\n', '    function setSellFeeBps(uint fee) public onlyAdmin {\n', '        require(fee < 10000);\n', '        sellTransferFee = fee;\n', '    }\n', '\n', '    function getBalance(ERC20 token) public view returns(uint) {\n', '        if (token == ETH_TOKEN_ADDRESS)\n', '            return this.balance;\n', '        else\n', '            return token.balanceOf(this);\n', '    }\n', '\n', '    function getDestQty(ERC20 src, ERC20 dest, uint srcQty, uint rate) public view returns(uint) {\n', '        uint dstDecimals = getDecimals(dest);\n', '        uint srcDecimals = getDecimals(src);\n', '        return calcDstQty(srcQty, srcDecimals, dstDecimals, rate);\n', '    }\n', '\n', '    function decodePriceFeed(uint input) internal pure returns(uint blockNumber, uint nonce, uint ask1KDigix, uint bid1KDigix) {\n', '        blockNumber = uint(uint64(input));\n', '        nonce = uint(uint64(input / POW_2_64));\n', '        ask1KDigix = uint(uint64(input / (POW_2_64 * POW_2_64)));\n', '        bid1KDigix = uint(uint64(input / (POW_2_64 * POW_2_64 * POW_2_64)));\n', '    }\n', '\n', '    function encodePriceFeed(uint blockNumber, uint nonce, uint ask1KDigix, uint bid1KDigix) internal pure returns(uint) {\n', '        // check overflows\n', '        require(blockNumber < POW_2_64);\n', '        require(nonce < POW_2_64);\n', '        require(ask1KDigix < POW_2_64);\n', '        require(bid1KDigix < POW_2_64);\n', '\n', '        // do encoding\n', '        uint result = blockNumber;\n', '        result |= nonce * POW_2_64;\n', '        result |= ask1KDigix * POW_2_64 * POW_2_64;\n', '        result |= bid1KDigix * POW_2_64 * POW_2_64 * POW_2_64;\n', '\n', '        return result;\n', '    }\n', '\n', '    function verifySignature(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal view returns(bool){\n', '        address signer = ecrecover(hash, v, r, s);\n', '        return operators[signer];\n', '    }\n', '\n', '}']