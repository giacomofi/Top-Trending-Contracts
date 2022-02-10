['pragma solidity 0.4.18;\n', '\n', '\n', 'import "./ERC20Interface.sol";\n', '\n', '\n', '/// @title Kyber constants contract\n', 'contract Utils {\n', '\n', '    ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);\n', '    uint  constant internal PRECISION = (10**18);\n', '    uint  constant internal MAX_QTY   = (10**28); // 10B tokens\n', '    uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH\n', '    uint  constant internal MAX_DECIMALS = 18;\n', '    uint  constant internal ETH_DECIMALS = 18;\n', '    mapping(address=>uint) internal decimals;\n', '\n', '    function setDecimals(ERC20 token) internal {\n', '        if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;\n', '        else decimals[token] = token.decimals();\n', '    }\n', '\n', '    function getDecimals(ERC20 token) internal view returns(uint) {\n', '        if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access\n', '        uint tokenDecimals = decimals[token];\n', '        // technically, there might be token with decimals 0\n', '        // moreover, very possible that old tokens have decimals 0\n', '        // these tokens will just have higher gas fees.\n', '        if(tokenDecimals == 0) return token.decimals();\n', '\n', '        return tokenDecimals;\n', '    }\n', '\n', '    function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {\n', '        require(srcQty <= MAX_QTY);\n', '        require(rate <= MAX_RATE);\n', '\n', '        if (dstDecimals >= srcDecimals) {\n', '            require((dstDecimals - srcDecimals) <= MAX_DECIMALS);\n', '            return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;\n', '        } else {\n', '            require((srcDecimals - dstDecimals) <= MAX_DECIMALS);\n', '            return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));\n', '        }\n', '    }\n', '\n', '    function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {\n', '        require(dstQty <= MAX_QTY);\n', '        require(rate <= MAX_RATE);\n', '        \n', '        //source quantity is rounded up. to avoid dest quantity being too low.\n', '        uint numerator;\n', '        uint denominator;\n', '        if (srcDecimals >= dstDecimals) {\n', '            require((srcDecimals - dstDecimals) <= MAX_DECIMALS);\n', '            numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));\n', '            denominator = rate;\n', '        } else {\n', '            require((dstDecimals - srcDecimals) <= MAX_DECIMALS);\n', '            numerator = (PRECISION * dstQty);\n', '            denominator = (rate * (10**(dstDecimals - srcDecimals)));\n', '        }\n', '        return (numerator + denominator - 1) / denominator; //avoid rounding down errors\n', '    }\n', '}\n']
['pragma solidity 0.4.18;\n', '\n', '\n', 'import "./ERC20Interface.sol";\n', 'import "./PermissionGroups.sol";\n', '\n', '\n', '/**\n', ' * @title Contracts that should be able to recover tokens or ethers\n', ' * @author Ilan Doron\n', ' * @dev This allows to recover any tokens or Ethers received in a contract.\n', ' * This will prevent any accidental loss of tokens.\n', ' */\n', 'contract Withdrawable is PermissionGroups {\n', '\n', '    event TokenWithdraw(ERC20 token, uint amount, address sendTo);\n', '\n', '    /**\n', '     * @dev Withdraw all ERC20 compatible tokens\n', '     * @param token ERC20 The address of the token contract\n', '     */\n', '    function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {\n', '        require(token.transfer(sendTo, amount));\n', '        TokenWithdraw(token, amount, sendTo);\n', '    }\n', '\n', '    event EtherWithdraw(uint amount, address sendTo);\n', '\n', '    /**\n', '     * @dev Withdraw Ethers\n', '     */\n', '    function withdrawEther(uint amount, address sendTo) external onlyAdmin {\n', '        sendTo.transfer(amount);\n', '        EtherWithdraw(amount, sendTo);\n', '    }\n', '}\n']
['pragma solidity 0.4.18;\n', '\n', '\n', 'contract UtilMath {\n', '    uint public constant BIG_NUMBER = (uint(1)<<uint(200));\n', '\n', '    function checkMultOverflow(uint x, uint y) public pure returns(bool) {\n', '        if (y == 0) return false;\n', '        return (((x*y) / y) != x);\n', '    }\n', '\n', '    function compactFraction(uint p, uint q, uint precision) public pure returns (uint, uint) {\n', '        if (q < precision * precision) return (p, q);\n', '        return compactFraction(p/precision, q/precision, precision);\n', '    }\n', '\n', '    /* solhint-disable code-complexity */\n', '    function exp(uint p, uint q, uint precision) public pure returns (uint) {\n', '        uint n = 0;\n', '        uint nFact = 1;\n', '        uint currentP = 1;\n', '        uint currentQ = 1;\n', '\n', '        uint sum = 0;\n', '        uint prevSum = 0;\n', '\n', '        while (true) {\n', '            if (checkMultOverflow(currentP, precision)) return sum;\n', '            if (checkMultOverflow(currentQ, nFact)) return sum;\n', '\n', '            sum += (currentP * precision) / (currentQ * nFact);\n', '\n', '            if (sum == prevSum) return sum;\n', '            prevSum = sum;\n', '\n', '            n++;\n', '\n', '            if (checkMultOverflow(currentP, p)) return sum;\n', '            if (checkMultOverflow(currentQ, q)) return sum;\n', '            if (checkMultOverflow(nFact, n)) return sum;\n', '\n', '            currentP *= p;\n', '            currentQ *= q;\n', '            nFact *= n;\n', '\n', '            (currentP, currentQ) = compactFraction(currentP, currentQ, precision);\n', '        }\n', '    }\n', '    /* solhint-enable code-complexity */\n', '\n', '    function countLeadingZeros(uint p, uint q) public pure returns (uint) {\n', '        uint denomator = (uint(1)<<255);\n', '        for (int i = 255; i >= 0; i--) {\n', '            if ((q*denomator)/denomator != q) {\n', '                // overflow\n', '                denomator = denomator/2;\n', '                continue;\n', '            }\n', '            if (p/(q*denomator) > 0) return uint(i);\n', '            denomator = denomator/2;\n', '        }\n', '\n', '        return uint(-1);\n', '    }\n', '\n', '    // log2 for a number that it in [1,2)\n', '    function log2ForSmallNumber(uint x, uint numPrecisionBits) public pure returns (uint) {\n', '        uint res = 0;\n', '        uint one = (uint(1)<<numPrecisionBits);\n', '        uint two = 2 * one;\n', '        uint addition = one;\n', '\n', '        require((x >= one) && (x <= two));\n', '        require(numPrecisionBits < 125);\n', '\n', '        for (uint i = numPrecisionBits; i > 0; i--) {\n', '            x = (x*x) / one;\n', '            addition = addition/2;\n', '            if (x >= two) {\n', '                x = x/2;\n', '                res += addition;\n', '            }\n', '        }\n', '\n', '        return res;\n', '    }\n', '\n', '    function logBase2 (uint p, uint q, uint numPrecisionBits) public pure returns (uint) {\n', '        uint n = 0;\n', '        uint precision = (uint(1)<<numPrecisionBits);\n', '\n', '        if (p > q) {\n', '            n = countLeadingZeros(p, q);\n', '        }\n', '\n', '        require(!checkMultOverflow(p, precision));\n', '        require(!checkMultOverflow(n, precision));\n', '        require(!checkMultOverflow(uint(1)<<n, q));\n', '\n', '        uint y = p * precision / (q * (uint(1)<<n));\n', '        uint log2Small = log2ForSmallNumber(y, numPrecisionBits);\n', '\n', '        require(n*precision <= BIG_NUMBER);\n', '        require(log2Small <= BIG_NUMBER);\n', '\n', '        return n * precision + log2Small;\n', '    }\n', '\n', '    function ln(uint p, uint q, uint numPrecisionBits) public pure returns (uint) {\n', '        uint ln2Numerator   = 6931471805599453094172;\n', '        uint ln2Denomerator = 10000000000000000000000;\n', '\n', '        uint log2x = logBase2(p, q, numPrecisionBits);\n', '\n', '        require(!checkMultOverflow(ln2Numerator, log2x));\n', '\n', '        return ln2Numerator * log2x / ln2Denomerator;\n', '    }\n', '}\n', '\n', '\n', 'contract LiquidityFormula is UtilMath {\n', '    function pE(uint r, uint pMIn, uint e, uint precision) public pure returns (uint) {\n', '        require(!checkMultOverflow(r, e));\n', '        uint expRE = exp(r*e, precision*precision, precision);\n', '        require(!checkMultOverflow(expRE, pMIn));\n', '        return pMIn*expRE / precision;\n', '    }\n', '\n', '    function deltaTFunc(uint r, uint pMIn, uint e, uint deltaE, uint precision) public pure returns (uint) {\n', '        uint pe = pE(r, pMIn, e, precision);\n', '        uint rpe = r * pe;\n', '\n', '        require(!checkMultOverflow(r, deltaE));\n', '        uint erdeltaE = exp(r*deltaE, precision*precision, precision);\n', '\n', '        require(erdeltaE >= precision);\n', '        require(!checkMultOverflow(erdeltaE - precision, precision));\n', '        require(!checkMultOverflow((erdeltaE - precision)*precision, precision));\n', '        require(!checkMultOverflow((erdeltaE - precision)*precision*precision, precision));\n', '        require(!checkMultOverflow(rpe, erdeltaE));\n', '        require(!checkMultOverflow(r, pe));\n', '\n', '        return (erdeltaE - precision) * precision * precision * precision / (rpe*erdeltaE);\n', '    }\n', '\n', '    function deltaEFunc(uint r, uint pMIn, uint e, uint deltaT, uint precision, uint numPrecisionBits)\n', '        public pure\n', '        returns (uint)\n', '    {\n', '        uint pe = pE(r, pMIn, e, precision);\n', '        uint rpe = r * pe;\n', '\n', '        require(!checkMultOverflow(rpe, deltaT));\n', '        require(precision * precision + rpe * deltaT/precision > precision * precision);\n', '        uint lnPart = ln(precision*precision + rpe*deltaT/precision, precision*precision, numPrecisionBits);\n', '\n', '        require(!checkMultOverflow(r, pe));\n', '        require(!checkMultOverflow(precision, precision));\n', '        require(!checkMultOverflow(rpe, deltaT));\n', '        require(!checkMultOverflow(lnPart, precision));\n', '\n', '        return lnPart * precision / r;\n', '    }\n', '}\n']
['pragma solidity 0.4.18;\n', '\n', '\n', 'contract PermissionGroups {\n', '\n', '    address public admin;\n', '    address public pendingAdmin;\n', '    mapping(address=>bool) internal operators;\n', '    mapping(address=>bool) internal alerters;\n', '    address[] internal operatorsGroup;\n', '    address[] internal alertersGroup;\n', '    uint constant internal MAX_GROUP_SIZE = 50;\n', '\n', '    function PermissionGroups() public {\n', '        admin = msg.sender;\n', '    }\n', '\n', '    modifier onlyAdmin() {\n', '        require(msg.sender == admin);\n', '        _;\n', '    }\n', '\n', '    modifier onlyOperator() {\n', '        require(operators[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    modifier onlyAlerter() {\n', '        require(alerters[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    function getOperators () external view returns(address[]) {\n', '        return operatorsGroup;\n', '    }\n', '\n', '    function getAlerters () external view returns(address[]) {\n', '        return alertersGroup;\n', '    }\n', '\n', '    event TransferAdminPending(address pendingAdmin);\n', '\n', '    /**\n', '     * @dev Allows the current admin to set the pendingAdmin address.\n', '     * @param newAdmin The address to transfer ownership to.\n', '     */\n', '    function transferAdmin(address newAdmin) public onlyAdmin {\n', '        require(newAdmin != address(0));\n', '        TransferAdminPending(pendingAdmin);\n', '        pendingAdmin = newAdmin;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.\n', '     * @param newAdmin The address to transfer ownership to.\n', '     */\n', '    function transferAdminQuickly(address newAdmin) public onlyAdmin {\n', '        require(newAdmin != address(0));\n', '        TransferAdminPending(newAdmin);\n', '        AdminClaimed(newAdmin, admin);\n', '        admin = newAdmin;\n', '    }\n', '\n', '    event AdminClaimed( address newAdmin, address previousAdmin);\n', '\n', '    /**\n', '     * @dev Allows the pendingAdmin address to finalize the change admin process.\n', '     */\n', '    function claimAdmin() public {\n', '        require(pendingAdmin == msg.sender);\n', '        AdminClaimed(pendingAdmin, admin);\n', '        admin = pendingAdmin;\n', '        pendingAdmin = address(0);\n', '    }\n', '\n', '    event AlerterAdded (address newAlerter, bool isAdd);\n', '\n', '    function addAlerter(address newAlerter) public onlyAdmin {\n', '        require(!alerters[newAlerter]); // prevent duplicates.\n', '        require(alertersGroup.length < MAX_GROUP_SIZE);\n', '\n', '        AlerterAdded(newAlerter, true);\n', '        alerters[newAlerter] = true;\n', '        alertersGroup.push(newAlerter);\n', '    }\n', '\n', '    function removeAlerter (address alerter) public onlyAdmin {\n', '        require(alerters[alerter]);\n', '        alerters[alerter] = false;\n', '\n', '        for (uint i = 0; i < alertersGroup.length; ++i) {\n', '            if (alertersGroup[i] == alerter) {\n', '                alertersGroup[i] = alertersGroup[alertersGroup.length - 1];\n', '                alertersGroup.length--;\n', '                AlerterAdded(alerter, false);\n', '                break;\n', '            }\n', '        }\n', '    }\n', '\n', '    event OperatorAdded(address newOperator, bool isAdd);\n', '\n', '    function addOperator(address newOperator) public onlyAdmin {\n', '        require(!operators[newOperator]); // prevent duplicates.\n', '        require(operatorsGroup.length < MAX_GROUP_SIZE);\n', '\n', '        OperatorAdded(newOperator, true);\n', '        operators[newOperator] = true;\n', '        operatorsGroup.push(newOperator);\n', '    }\n', '\n', '    function removeOperator (address operator) public onlyAdmin {\n', '        require(operators[operator]);\n', '        operators[operator] = false;\n', '\n', '        for (uint i = 0; i < operatorsGroup.length; ++i) {\n', '            if (operatorsGroup[i] == operator) {\n', '                operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];\n', '                operatorsGroup.length -= 1;\n', '                OperatorAdded(operator, false);\n', '                break;\n', '            }\n', '        }\n', '    }\n', '}\n']
['pragma solidity 0.4.18;\n', '\n', '\n', 'import "./ERC20Interface.sol";\n', '\n', '\n', 'interface ConversionRatesInterface {\n', '\n', '    function recordImbalance(\n', '        ERC20 token,\n', '        int buyAmount,\n', '        uint rateUpdateBlock,\n', '        uint currentBlock\n', '    )\n', '        public;\n', '\n', '    function getRate(ERC20 token, uint currentBlockNumber, bool buy, uint qty) public view returns(uint);\n', '}\n']
['pragma solidity 0.4.18;\n', '\n', '\n', 'import "../../ConversionRatesInterface.sol";\n', 'import "../../Withdrawable.sol";\n', 'import "../../Utils.sol";\n', 'import "./LiquidityFormula.sol";\n', '\n', '\n', 'contract LiquidityConversionRates is ConversionRatesInterface, LiquidityFormula, Withdrawable, Utils {\n', '\n', '    uint constant FORMULA_PRECISION_BITS = 40;\n', '\n', '    ERC20 public token;\n', '    address public reserveContract;\n', '\n', '    uint public numFpBits;\n', '    uint public formulaPrecision;\n', '\n', '    uint public rInFp;\n', '    uint public pMinInFp;\n', '\n', '    uint public maxEthCapBuyInFp;\n', '    uint public maxEthCapSellInFp;\n', '    uint public maxQtyInFp;\n', '\n', '    uint public feeInBps;\n', '    uint public collectedFeesInTwei = 0;\n', '\n', '    uint public maxBuyRateInPrecision;\n', '    uint public minBuyRateInPrecision;\n', '    uint public maxSellRateInPrecision;\n', '    uint public minSellRateInPrecision;\n', '\n', '    function LiquidityConversionRates(address _admin, ERC20 _token) public {\n', '        transferAdminQuickly(_admin);\n', '        token = _token;\n', '        setDecimals(token);\n', '        require(getDecimals(token) <= MAX_DECIMALS);\n', '    }\n', '\n', '    event ReserveAddressSet(address reserve);\n', '\n', '    function setReserveAddress(address reserve) public onlyAdmin {\n', '        reserveContract = reserve;\n', '        ReserveAddressSet(reserve);\n', '    }\n', '\n', '    event LiquidityParamsSet(\n', '        uint rInFp,\n', '        uint pMinInFp,\n', '        uint numFpBits,\n', '        uint maxCapBuyInFp,\n', '        uint maxEthCapSellInFp,\n', '        uint feeInBps,\n', '        uint formulaPrecision,\n', '        uint maxQtyInFp,\n', '        uint maxBuyRateInPrecision,\n', '        uint minBuyRateInPrecision,\n', '        uint maxSellRateInPrecision,\n', '        uint minSellRateInPrecision\n', '    );\n', '\n', '    function setLiquidityParams(\n', '        uint _rInFp,\n', '        uint _pMinInFp,\n', '        uint _numFpBits,\n', '        uint _maxCapBuyInWei,\n', '        uint _maxCapSellInWei,\n', '        uint _feeInBps,\n', '        uint _maxTokenToEthRateInPrecision,\n', '        uint _minTokenToEthRateInPrecision\n', '    ) public onlyAdmin {\n', '        require(_numFpBits == FORMULA_PRECISION_BITS); // only used config, but keep in API\n', '        formulaPrecision = uint(1)<<_numFpBits; // require(formulaPrecision <= MAX_QTY)\n', '        require(_feeInBps < 10000);\n', '        require(_minTokenToEthRateInPrecision < _maxTokenToEthRateInPrecision);\n', '        require(_minTokenToEthRateInPrecision > 0);\n', '        require(_rInFp > 0);\n', '        require(_pMinInFp > 0);\n', '\n', '        rInFp = _rInFp;\n', '        pMinInFp = _pMinInFp;\n', '        maxQtyInFp = fromWeiToFp(MAX_QTY);\n', '        numFpBits = _numFpBits;\n', '        maxEthCapBuyInFp = fromWeiToFp(_maxCapBuyInWei);\n', '        maxEthCapSellInFp = fromWeiToFp(_maxCapSellInWei);\n', '        feeInBps = _feeInBps;\n', '        maxBuyRateInPrecision = PRECISION * PRECISION / _minTokenToEthRateInPrecision;\n', '        minBuyRateInPrecision = PRECISION * PRECISION / _maxTokenToEthRateInPrecision;\n', '        maxSellRateInPrecision = _maxTokenToEthRateInPrecision;\n', '        minSellRateInPrecision = _minTokenToEthRateInPrecision;\n', '\n', '        LiquidityParamsSet(\n', '            rInFp,\n', '            pMinInFp,\n', '            numFpBits,\n', '            maxEthCapBuyInFp,\n', '            maxEthCapSellInFp,\n', '            feeInBps,\n', '            formulaPrecision,\n', '            maxQtyInFp,\n', '            maxBuyRateInPrecision,\n', '            minBuyRateInPrecision,\n', '            maxSellRateInPrecision,\n', '            minSellRateInPrecision\n', '        );\n', '    }\n', '\n', '    function recordImbalance(\n', '        ERC20 conversionToken,\n', '        int buyAmountInTwei,\n', '        uint rateUpdateBlock,\n', '        uint currentBlock\n', '    )\n', '        public\n', '    {\n', '        conversionToken;\n', '        rateUpdateBlock;\n', '        currentBlock;\n', '\n', '        require(msg.sender == reserveContract);\n', '        if (buyAmountInTwei > 0) {\n', '            // Buy case\n', '            collectedFeesInTwei += calcCollectedFee(abs(buyAmountInTwei));\n', '        } else {\n', '            // Sell case\n', '            collectedFeesInTwei += abs(buyAmountInTwei) * feeInBps / 10000;\n', '        }\n', '    }\n', '\n', '    event CollectedFeesReset(uint resetFeesInTwei);\n', '\n', '    function resetCollectedFees() public onlyAdmin {\n', '        uint resetFeesInTwei = collectedFeesInTwei;\n', '        collectedFeesInTwei = 0;\n', '\n', '        CollectedFeesReset(resetFeesInTwei);\n', '    }\n', '\n', '    function getRate(\n', '            ERC20 conversionToken,\n', '            uint currentBlockNumber,\n', '            bool buy,\n', '            uint qtyInSrcWei\n', '    ) public view returns(uint) {\n', '\n', '        currentBlockNumber;\n', '\n', '        require(qtyInSrcWei <= MAX_QTY);\n', '        uint eInFp = fromWeiToFp(reserveContract.balance);\n', '        uint rateInPrecision = getRateWithE(conversionToken, buy, qtyInSrcWei, eInFp);\n', '        require(rateInPrecision <= MAX_RATE);\n', '        return rateInPrecision;\n', '    }\n', '\n', '    function getRateWithE(ERC20 conversionToken, bool buy, uint qtyInSrcWei, uint eInFp) public view returns(uint) {\n', '        uint deltaEInFp;\n', '        uint sellInputTokenQtyInFp;\n', '        uint deltaTInFp;\n', '        uint rateInPrecision;\n', '\n', '        require(qtyInSrcWei <= MAX_QTY);\n', '        require(eInFp <= maxQtyInFp);\n', '        if (conversionToken != token) return 0;\n', '\n', '        if (buy) {\n', '            // ETH goes in, token goes out\n', '            deltaEInFp = fromWeiToFp(qtyInSrcWei);\n', '            if (deltaEInFp > maxEthCapBuyInFp) return 0;\n', '\n', '            if (deltaEInFp == 0) {\n', '                rateInPrecision = buyRateZeroQuantity(eInFp);\n', '            } else {\n', '                rateInPrecision = buyRate(eInFp, deltaEInFp);\n', '            }\n', '        } else {\n', '            sellInputTokenQtyInFp = fromTweiToFp(qtyInSrcWei);\n', '            deltaTInFp = valueAfterReducingFee(sellInputTokenQtyInFp);\n', '            if (deltaTInFp == 0) {\n', '                rateInPrecision = sellRateZeroQuantity(eInFp);\n', '                deltaEInFp = 0;\n', '            } else {\n', '                (rateInPrecision, deltaEInFp) = sellRate(eInFp, sellInputTokenQtyInFp, deltaTInFp);\n', '            }\n', '\n', '            if (deltaEInFp > maxEthCapSellInFp) return 0;\n', '        }\n', '\n', '        rateInPrecision = rateAfterValidation(rateInPrecision, buy);\n', '        return rateInPrecision;\n', '    }\n', '\n', '    function rateAfterValidation(uint rateInPrecision, bool buy) public view returns(uint) {\n', '        uint minAllowRateInPrecision;\n', '        uint maxAllowedRateInPrecision;\n', '\n', '        if (buy) {\n', '            minAllowRateInPrecision = minBuyRateInPrecision;\n', '            maxAllowedRateInPrecision = maxBuyRateInPrecision;\n', '        } else {\n', '            minAllowRateInPrecision = minSellRateInPrecision;\n', '            maxAllowedRateInPrecision = maxSellRateInPrecision;\n', '        }\n', '\n', '        if ((rateInPrecision > maxAllowedRateInPrecision) || (rateInPrecision < minAllowRateInPrecision)) {\n', '            return 0;\n', '        } else if (rateInPrecision > MAX_RATE) {\n', '            return 0;\n', '        } else {\n', '            return rateInPrecision;\n', '        }\n', '    }\n', '\n', '    function buyRate(uint eInFp, uint deltaEInFp) public view returns(uint) {\n', '        uint deltaTInFp = deltaTFunc(rInFp, pMinInFp, eInFp, deltaEInFp, formulaPrecision);\n', '        require(deltaTInFp <= maxQtyInFp);\n', '        deltaTInFp = valueAfterReducingFee(deltaTInFp);\n', '        return deltaTInFp * PRECISION / deltaEInFp;\n', '    }\n', '\n', '    function buyRateZeroQuantity(uint eInFp) public view returns(uint) {\n', '        uint ratePreReductionInPrecision = formulaPrecision * PRECISION / pE(rInFp, pMinInFp, eInFp, formulaPrecision);\n', '        return valueAfterReducingFee(ratePreReductionInPrecision);\n', '    }\n', '\n', '    function sellRate(\n', '        uint eInFp,\n', '        uint sellInputTokenQtyInFp,\n', '        uint deltaTInFp\n', '    ) public view returns(uint rateInPrecision, uint deltaEInFp) {\n', '        deltaEInFp = deltaEFunc(rInFp, pMinInFp, eInFp, deltaTInFp, formulaPrecision, numFpBits);\n', '        require(deltaEInFp <= maxQtyInFp);\n', '        rateInPrecision = deltaEInFp * PRECISION / sellInputTokenQtyInFp;\n', '    }\n', '\n', '    function sellRateZeroQuantity(uint eInFp) public view returns(uint) {\n', '        uint ratePreReductionInPrecision = pE(rInFp, pMinInFp, eInFp, formulaPrecision) * PRECISION / formulaPrecision;\n', '        return valueAfterReducingFee(ratePreReductionInPrecision);\n', '    }\n', '\n', '    function fromTweiToFp(uint qtyInTwei) public view returns(uint) {\n', '        require(qtyInTwei <= MAX_QTY);\n', '        return qtyInTwei * formulaPrecision / (10 ** getDecimals(token));\n', '    }\n', '\n', '    function fromWeiToFp(uint qtyInwei) public view returns(uint) {\n', '        require(qtyInwei <= MAX_QTY);\n', '        return qtyInwei * formulaPrecision / (10 ** ETH_DECIMALS);\n', '    }\n', '\n', '    function valueAfterReducingFee(uint val) public view returns(uint) {\n', '        require(val <= BIG_NUMBER);\n', '        return ((10000 - feeInBps) * val) / 10000;\n', '    }\n', '\n', '    function calcCollectedFee(uint val) public view returns(uint) {\n', '        require(val <= MAX_QTY);\n', '        return val * feeInBps / (10000 - feeInBps);\n', '    }\n', '\n', '    function abs(int val) public pure returns(uint) {\n', '        if (val < 0) {\n', '            return uint(val * (-1));\n', '        } else {\n', '            return uint(val);\n', '        }\n', '    }\n', '}\n']
['pragma solidity 0.4.18;\n', '\n', '\n', '// https://github.com/ethereum/EIPs/issues/20\n', 'interface ERC20 {\n', '    function totalSupply() public view returns (uint supply);\n', '    function balanceOf(address _owner) public view returns (uint balance);\n', '    function transfer(address _to, uint _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success);\n', '    function approve(address _spender, uint _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public view returns (uint remaining);\n', '    function decimals() public view returns(uint digits);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n']
