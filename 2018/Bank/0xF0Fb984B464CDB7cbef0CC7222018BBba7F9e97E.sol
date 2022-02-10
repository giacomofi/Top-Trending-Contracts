['pragma solidity ^0.4.19;\n', '\n', 'contract Token {\n', '    bytes32 public standard;\n', '    bytes32 public name;\n', '    bytes32 public symbol;\n', '    uint256 public totalSupply;\n', '    uint8 public decimals;\n', '    bool public allowTransactions;\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success); \n', '}\n', '\n', 'contract EthermiumAffiliates {\n', '    mapping(address => address[]) public referrals; // mapping of affiliate address to referral addresses\n', '    mapping(address => address) public affiliates; // mapping of referrals addresses to affiliate addresses\n', '    mapping(address => bool) public admins; // mapping of admin accounts\n', '    string[] public affiliateList;\n', '    address public owner;\n', '\n', '    function setOwner(address newOwner);\n', '    function setAdmin(address admin, bool isAdmin) public;\n', '    function assignReferral (address affiliate, address referral) public;    \n', '\n', '    function getAffiliateCount() returns (uint);\n', '    function getAffiliate(address refferal) public returns (address);\n', '    function getReferrals(address affiliate) public returns (address[]);\n', '}\n', '\n', 'contract EthermiumTokenList {\n', '    function isTokenInList(address tokenAddress) public constant returns (bool);\n', '}\n', '\n', '\n', 'contract Exchange {\n', '    function assert(bool assertion) {\n', '        if (!assertion) throw;\n', '    }\n', '    function safeMul(uint a, uint b) returns (uint) {\n', '        uint c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function safeSub(uint a, uint b) returns (uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function safeAdd(uint a, uint b) returns (uint) {\n', '        uint c = a + b;\n', '        assert(c>=a && c>=b);\n', '        return c;\n', '    }\n', '    address public owner;\n', '    mapping (address => uint256) public invalidOrder;\n', '\n', '    event SetOwner(address indexed previousOwner, address indexed newOwner);\n', '    modifier onlyOwner {\n', '        assert(msg.sender == owner);\n', '        _;\n', '    }\n', '    function setOwner(address newOwner) onlyOwner {\n', '        SetOwner(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '    function getOwner() returns (address out) {\n', '        return owner;\n', '    }\n', '    function invalidateOrdersBefore(address user, uint256 nonce) onlyAdmin {\n', '        if (nonce < invalidOrder[user]) throw;\n', '        invalidOrder[user] = nonce;\n', '    }\n', '\n', '    mapping (address => mapping (address => uint256)) public tokens; //mapping of token addresses to mapping of account balances\n', '\n', '    mapping (address => bool) public admins;\n', '    mapping (address => uint256) public lastActiveTransaction;\n', '    mapping (bytes32 => uint256) public orderFills;\n', '    address public feeAccount;\n', '    uint256 public feeAffiliate; // percentage times (1 ether)\n', '    uint256 public inactivityReleasePeriod;\n', '    mapping (bytes32 => bool) public traded;\n', '    mapping (bytes32 => bool) public withdrawn;\n', '    uint256 public makerFee; // fraction * 1 ether\n', '    uint256 public takerFee; // fraction * 1 ether\n', '    uint256 public affiliateFee; // fraction as proportion of 1 ether\n', '    uint256 public makerAffiliateFee; // wei deductible from makerFee\n', '    uint256 public takerAffiliateFee; // wei deductible form takerFee\n', '\n', '    mapping (address => address) public referrer;  // mapping of user addresses to their referrer addresses\n', '\n', '    address public affiliateContract;\n', '    address public tokenListContract;\n', '\n', '\n', '    enum Errors {\n', '        INVLID_PRICE,           // Order prices don&#39;t match\n', '        INVLID_SIGNATURE,       // Signature is invalid\n', '        TOKENS_DONT_MATCH,      // Maker/taker tokens don&#39;t match\n', '        ORDER_ALREADY_FILLED,    // Order was already filled\n', '        GAS_TOO_HIGH    // Order was already filled\n', '    }\n', '  \n', '    event Order(address tokenBuy, uint256 amountBuy, address tokenSell, uint256 amountSell, uint256 expires, uint256 nonce, address user, uint8 v, bytes32 r, bytes32 s);\n', '    event Cancel(address tokenBuy, uint256 amountBuy, address tokenSell, uint256 amountSell, uint256 expires, uint256 nonce, address user, uint8 v, bytes32 r, bytes32 s);\n', '    event Trade(\n', '        address takerTokenBuy, uint256 takerAmountBuy,\n', '        address takerTokenSell, uint256 takerAmountSell,\n', '        address maker, address taker,\n', '        uint256 makerFee, uint256 takerFee,\n', '        uint256 makerAmountTaken, uint256 takerAmountTaken,\n', '        bytes32 makerOrderHash, bytes32 takerOrderHash\n', '    );\n', '    event Deposit(address token, address user, uint256 amount, uint256 balance, address referrerAddress);\n', '    event Withdraw(address token, address user, uint256 amount, uint256 balance);\n', '    event FeeChange(uint256 makerFee, uint256 takerFee, uint256 affiliateFee);\n', '    event AffiliateFeeChange(uint256 newAffiliateFee);\n', '    event LogError(uint8 indexed errorId, bytes32 indexed orderHash);\n', '    event CancelOrder(bytes32 cancelHash, bytes32 orderHash, address user, address tokenSell, uint256 amountSell, uint256 cancelFee);\n', '\n', '    function setInactivityReleasePeriod(uint256 expiry) onlyAdmin returns (bool success) {\n', '        if (expiry > 1000000) throw;\n', '        inactivityReleasePeriod = expiry;\n', '        return true;\n', '    }\n', '\n', '    function Exchange(address feeAccount_, uint256 makerFee_, uint256 takerFee_, uint256 affiliateFee_, address affiliateContract_, address tokenListContract_) {\n', '        owner = msg.sender;\n', '        feeAccount = feeAccount_;\n', '        inactivityReleasePeriod = 100000;\n', '        makerFee = makerFee_;\n', '        takerFee = takerFee_;\n', '        affiliateFee = affiliateFee_;\n', '\n', '\n', '\n', '        makerAffiliateFee = safeMul(makerFee, affiliateFee_) / (1 ether);\n', '        takerAffiliateFee = safeMul(takerFee, affiliateFee_) / (1 ether);\n', '\n', '        affiliateContract = affiliateContract_;\n', '        tokenListContract = tokenListContract_;\n', '    }\n', '\n', '    function setFees(uint256 makerFee_, uint256 takerFee_, uint256 affiliateFee_) onlyOwner {\n', '        require(makerFee_ < 10 finney && takerFee_ < 10 finney);\n', '        require(affiliateFee_ > affiliateFee);\n', '        makerFee = makerFee_;\n', '        takerFee = takerFee_;\n', '        affiliateFee = affiliateFee_;\n', '        makerAffiliateFee = safeMul(makerFee, affiliateFee_) / (1 ether);\n', '        takerAffiliateFee = safeMul(takerFee, affiliateFee_) / (1 ether);\n', '\n', '        FeeChange(makerFee, takerFee, affiliateFee_);\n', '    }\n', '\n', '    function setAdmin(address admin, bool isAdmin) onlyOwner {\n', '        admins[admin] = isAdmin;\n', '    }\n', '\n', '    modifier onlyAdmin {\n', '        if (msg.sender != owner && !admins[msg.sender]) throw;\n', '        _;\n', '    }\n', '\n', '    function() external {\n', '        throw;\n', '    }\n', '\n', '    function depositToken(address token, uint256 amount, address referrerAddress) {\n', '        //require(EthermiumTokenList(tokenListContract).isTokenInList(token));\n', '        if (referrerAddress == msg.sender) referrerAddress = address(0);\n', '        if (referrer[msg.sender] == address(0x0))   {\n', '            if (referrerAddress != address(0x0) && EthermiumAffiliates(affiliateContract).getAffiliate(msg.sender) == address(0))\n', '            {\n', '                referrer[msg.sender] = referrerAddress;\n', '                EthermiumAffiliates(affiliateContract).assignReferral(referrerAddress, msg.sender);\n', '            }\n', '            else\n', '            {\n', '                referrer[msg.sender] = EthermiumAffiliates(affiliateContract).getAffiliate(msg.sender);\n', '            }\n', '        } \n', '        tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);\n', '        lastActiveTransaction[msg.sender] = block.number;\n', '        if (!Token(token).transferFrom(msg.sender, this, amount)) throw;\n', '        Deposit(token, msg.sender, amount, tokens[token][msg.sender], referrer[msg.sender]);\n', '    }\n', '\n', '    function deposit(address referrerAddress) payable {\n', '        if (referrerAddress == msg.sender) referrerAddress = address(0);\n', '        if (referrer[msg.sender] == address(0x0))   {\n', '            if (referrerAddress != address(0x0) && EthermiumAffiliates(affiliateContract).getAffiliate(msg.sender) == address(0))\n', '            {\n', '                referrer[msg.sender] = referrerAddress;\n', '                EthermiumAffiliates(affiliateContract).assignReferral(referrerAddress, msg.sender);\n', '            }\n', '            else\n', '            {\n', '                referrer[msg.sender] = EthermiumAffiliates(affiliateContract).getAffiliate(msg.sender);\n', '            }\n', '        } \n', '        tokens[address(0)][msg.sender] = safeAdd(tokens[address(0)][msg.sender], msg.value);\n', '        lastActiveTransaction[msg.sender] = block.number;\n', '        Deposit(address(0), msg.sender, msg.value, tokens[address(0)][msg.sender], referrer[msg.sender]);\n', '    }\n', '\n', '    function withdraw(address token, uint256 amount) returns (bool success) {\n', '        if (safeSub(block.number, lastActiveTransaction[msg.sender]) < inactivityReleasePeriod) throw;\n', '        if (tokens[token][msg.sender] < amount) throw;\n', '        tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);\n', '        if (token == address(0)) {\n', '            if (!msg.sender.send(amount)) throw;\n', '        } else {\n', '            if (!Token(token).transfer(msg.sender, amount)) throw;\n', '        }\n', '        Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);\n', '    }\n', '\n', '    function adminWithdraw(address token, uint256 amount, address user, uint256 nonce, uint8 v, bytes32 r, bytes32 s, uint256 feeWithdrawal) onlyAdmin returns (bool success) {\n', '        bytes32 hash = keccak256(this, token, amount, user, nonce);\n', '        if (withdrawn[hash]) throw;\n', '        withdrawn[hash] = true;\n', '        if (ecrecover(keccak256("\\x19Ethereum Signed Message:\\n32", hash), v, r, s) != user) throw;\n', '        if (feeWithdrawal > 50 finney) feeWithdrawal = 50 finney;\n', '        if (tokens[token][user] < amount) throw;\n', '        tokens[token][user] = safeSub(tokens[token][user], amount);\n', '        tokens[address(0)][user] = safeSub(tokens[address(0x0)][user], feeWithdrawal);\n', '        //tokens[token][feeAccount] = safeAdd(tokens[token][feeAccount], safeMul(feeWithdrawal, amount) / 1 ether);\n', '        tokens[address(0)][feeAccount] = safeAdd(tokens[address(0)][feeAccount], feeWithdrawal);\n', '\n', '        //amount = safeMul((1 ether - feeWithdrawal), amount) / 1 ether;\n', '        if (token == address(0)) {\n', '            if (!user.send(amount)) throw;\n', '        } else {\n', '            if (!Token(token).transfer(user, amount)) throw;\n', '        }\n', '        lastActiveTransaction[user] = block.number;\n', '        Withdraw(token, user, amount, tokens[token][user]);\n', '    }\n', '\n', '    function balanceOf(address token, address user) constant returns (uint256) {\n', '        return tokens[token][user];\n', '    }\n', '\n', '    struct OrderPair {\n', '        uint256 makerAmountBuy;\n', '        uint256 makerAmountSell;\n', '        uint256 makerNonce;\n', '        uint256 takerAmountBuy;\n', '        uint256 takerAmountSell;\n', '        uint256 takerNonce;\n', '        uint256 takerGasFee;\n', '\n', '        address makerTokenBuy;\n', '        address makerTokenSell;\n', '        address maker;\n', '        address takerTokenBuy;\n', '        address takerTokenSell;\n', '        address taker;\n', '\n', '        bytes32 makerOrderHash;\n', '        bytes32 takerOrderHash;\n', '    }\n', '\n', '    struct TradeValues {\n', '        uint256 qty;\n', '        uint256 invQty;\n', '        uint256 makerAmountTaken;\n', '        uint256 takerAmountTaken;\n', '        address makerReferrer;\n', '        address takerReferrer;\n', '    }\n', '\n', '\n', '\n', '  \n', '    function trade(\n', '        uint8[2] v,\n', '        bytes32[4] rs,\n', '        uint256[7] tradeValues,\n', '        address[6] tradeAddresses\n', '    ) onlyAdmin returns (uint filledTakerTokenAmount) \n', '    {\n', '    \n', '        /* tradeValues\n', '          [0] makerAmountBuy\n', '          [1] makerAmountSell\n', '          [2] makerNonce\n', '          [3] takerAmountBuy\n', '          [4] takerAmountSell\n', '          [5] takerNonce\n', '          [6] takerGasFee\n', '\n', '          tradeAddresses\n', '          [0] makerTokenBuy\n', '          [1] makerTokenSell\n', '          [2] maker\n', '          [3] takerTokenBuy\n', '          [4] takerTokenSell\n', '          [5] taker\n', '        */\n', '\n', '        OrderPair memory t  = OrderPair({\n', '            makerAmountBuy  : tradeValues[0],\n', '            makerAmountSell : tradeValues[1],\n', '            makerNonce      : tradeValues[2],\n', '            takerAmountBuy  : tradeValues[3],\n', '            takerAmountSell : tradeValues[4],\n', '            takerNonce      : tradeValues[5],\n', '            takerGasFee     : tradeValues[6],\n', '\n', '            makerTokenBuy   : tradeAddresses[0],\n', '            makerTokenSell  : tradeAddresses[1],\n', '            maker           : tradeAddresses[2],\n', '            takerTokenBuy   : tradeAddresses[3],\n', '            takerTokenSell  : tradeAddresses[4],\n', '            taker           : tradeAddresses[5],\n', '\n', '            makerOrderHash  : keccak256(this, tradeAddresses[0], tradeValues[0], tradeAddresses[1], tradeValues[1], tradeValues[2], tradeAddresses[2]),\n', '            takerOrderHash  : keccak256(this, tradeAddresses[3], tradeValues[3], tradeAddresses[4], tradeValues[4], tradeValues[5], tradeAddresses[5])\n', '        });\n', '\n', '        //bytes32 makerOrderHash = keccak256(this, tradeAddresses[0], tradeValues[0], tradeAddresses[1], tradeValues[1], tradeValues[2], tradeAddresses[2]);\n', '        //bytes32 makerOrderHash = &#167;\n', '        if (ecrecover(keccak256("\\x19Ethereum Signed Message:\\n32", t.makerOrderHash), v[0], rs[0], rs[1]) != t.maker) \n', '        {\n', '            LogError(uint8(Errors.INVLID_SIGNATURE), t.makerOrderHash);\n', '            return 0;\n', '        }\n', '        //bytes32 takerOrderHash = keccak256(this, tradeAddresses[3], tradeValues[3], tradeAddresses[4], tradeValues[4], tradeValues[5], tradeAddresses[5]);\n', '        //bytes32 takerOrderHash = keccak256(this, t.takerTokenBuy, t.takerAmountBuy, t.takerTokenSell, t.takerAmountSell, t.takerNonce, t.taker);\n', '        if (ecrecover(keccak256("\\x19Ethereum Signed Message:\\n32", t.takerOrderHash), v[1], rs[2], rs[3]) != t.taker)\n', '        {\n', '            LogError(uint8(Errors.INVLID_SIGNATURE), t.takerOrderHash);\n', '            return 0;\n', '        }\n', '\n', '        if (t.makerTokenBuy != t.takerTokenSell || t.makerTokenSell != t.takerTokenBuy) \n', '        {\n', '            LogError(uint8(Errors.TOKENS_DONT_MATCH), t.takerOrderHash);\n', '            return 0;\n', '        } // tokens don&#39;t match\n', '\n', '        if (t.takerGasFee > 100 finney)\n', '        {\n', '            LogError(uint8(Errors.GAS_TOO_HIGH), t.makerOrderHash);\n', '            return 0;\n', '        } // takerGasFee too high\n', '\n', '\n', '\n', '        if (!(\n', '        (t.makerTokenBuy != address(0x0) && safeMul(t.makerAmountSell, 1 ether) / t.makerAmountBuy >= safeMul(t.takerAmountBuy, 1 ether) / t.takerAmountSell)\n', '        ||\n', '        (t.makerTokenBuy == address(0x0) && safeMul(t.makerAmountBuy, 1 ether) / t.makerAmountSell <= safeMul(t.takerAmountSell, 1 ether) / t.takerAmountBuy)\n', '        )) \n', '        {\n', '            LogError(uint8(Errors.INVLID_PRICE), t.makerOrderHash);\n', '            return 0; // prices don&#39;t match\n', '        }\n', '\n', '        TradeValues memory tv = TradeValues({\n', '            qty                 : 0,\n', '            invQty              : 0,\n', '            makerAmountTaken    : 0,\n', '            takerAmountTaken    : 0,\n', '            makerReferrer       : referrer[t.maker],\n', '            takerReferrer       : referrer[t.taker]\n', '        });\n', '\n', '        if (tv.makerReferrer == address(0x0)) tv.makerReferrer = feeAccount;\n', '        if (tv.takerReferrer == address(0x0)) tv.takerReferrer = feeAccount;\n', '\n', '        \n', '\n', '        // maker buy, taker sell\n', '        if (t.makerTokenBuy != address(0x0)) \n', '        {\n', '            \n', '\n', '            tv.qty = min(safeSub(t.makerAmountBuy, orderFills[t.makerOrderHash]), safeSub(t.takerAmountSell, safeMul(orderFills[t.takerOrderHash], t.takerAmountSell) / t.takerAmountBuy));\n', '            if (tv.qty == 0)\n', '            {\n', '                LogError(uint8(Errors.ORDER_ALREADY_FILLED), t.makerOrderHash);\n', '                return 0;\n', '            }\n', '\n', '            tv.invQty = safeMul(tv.qty, t.makerAmountSell) / t.makerAmountBuy;\n', '\n', '            tokens[t.makerTokenSell][t.maker]           = safeSub(tokens[t.makerTokenSell][t.maker],           tv.invQty);\n', '            tv.makerAmountTaken                         = safeSub(tv.qty, safeMul(tv.qty, makerFee) / (1 ether));\n', '            tokens[t.makerTokenBuy][t.maker]            = safeAdd(tokens[t.makerTokenBuy][t.maker],            tv.makerAmountTaken);\n', '            tokens[t.makerTokenBuy][tv.makerReferrer]   = safeAdd(tokens[t.makerTokenBuy][tv.makerReferrer],   safeMul(tv.qty,    makerAffiliateFee) / (1 ether));\n', '            \n', '            tokens[t.takerTokenSell][t.taker]           = safeSub(tokens[t.takerTokenSell][t.taker],           tv.qty);\n', '            tv.takerAmountTaken                         = safeSub(safeSub(tv.invQty, safeMul(tv.invQty, takerFee) / (1 ether)), safeMul(tv.invQty, t.takerGasFee) / (1 ether));\n', '            tokens[t.takerTokenBuy][t.taker]            = safeAdd(tokens[t.takerTokenBuy][t.taker],            tv.takerAmountTaken);\n', '            tokens[t.takerTokenBuy][tv.takerReferrer]   = safeAdd(tokens[t.takerTokenBuy][tv.takerReferrer],   safeMul(tv.invQty, takerAffiliateFee) / (1 ether));\n', '\n', '            tokens[t.makerTokenBuy][feeAccount]     = safeAdd(tokens[t.makerTokenBuy][feeAccount],      safeMul(tv.qty,    safeSub(makerFee, makerAffiliateFee)) / (1 ether));\n', '            tokens[t.takerTokenBuy][feeAccount]     = safeAdd(tokens[t.takerTokenBuy][feeAccount],      safeAdd(safeMul(tv.invQty, safeSub(takerFee, takerAffiliateFee)) / (1 ether), safeMul(tv.invQty, t.takerGasFee) / (1 ether)));\n', '\n', '           \n', '            orderFills[t.makerOrderHash]            = safeAdd(orderFills[t.makerOrderHash], tv.qty);\n', '            orderFills[t.takerOrderHash]            = safeAdd(orderFills[t.takerOrderHash], safeMul(tv.qty, t.takerAmountBuy) / t.takerAmountSell);\n', '            lastActiveTransaction[t.maker]          = block.number;\n', '            lastActiveTransaction[t.taker]          = block.number;\n', '\n', '            Trade(\n', '                t.takerTokenBuy, tv.qty,\n', '                t.takerTokenSell, tv.invQty,\n', '                t.maker, t.taker,\n', '                makerFee, takerFee,\n', '                tv.makerAmountTaken , tv.takerAmountTaken,\n', '                t.makerOrderHash, t.takerOrderHash\n', '            );\n', '            return tv.qty;\n', '        }\n', '        // maker sell, taker buy\n', '        else\n', '        {\n', '\n', '            tv.qty = min(safeSub(t.makerAmountSell,  safeMul(orderFills[t.makerOrderHash], t.makerAmountSell) / t.makerAmountBuy), safeSub(t.takerAmountBuy, orderFills[t.takerOrderHash]));\n', '            if (tv.qty == 0)\n', '            {\n', '                LogError(uint8(Errors.ORDER_ALREADY_FILLED), t.makerOrderHash);\n', '                return 0;\n', '            }\n', '\n', '            tv.invQty = safeMul(tv.qty, t.makerAmountBuy) / t.makerAmountSell;\n', '\n', '            tokens[t.makerTokenSell][t.maker]           = safeSub(tokens[t.makerTokenSell][t.maker],           tv.qty);\n', '            tv.makerAmountTaken                         = safeSub(tv.invQty, safeMul(tv.invQty, makerFee) / (1 ether));\n', '            tokens[t.makerTokenBuy][t.maker]            = safeAdd(tokens[t.makerTokenBuy][t.maker],            tv.makerAmountTaken);\n', '            tokens[t.makerTokenBuy][tv.makerReferrer]   = safeAdd(tokens[t.makerTokenBuy][tv.makerReferrer],   safeMul(tv.invQty, makerAffiliateFee) / (1 ether));\n', '            \n', '            tokens[t.takerTokenSell][t.taker]           = safeSub(tokens[t.takerTokenSell][t.taker],           tv.invQty);\n', '            tv.takerAmountTaken                         = safeSub(safeSub(tv.qty,    safeMul(tv.qty, takerFee) / (1 ether)), safeMul(tv.qty, t.takerGasFee) / (1 ether));\n', '            tokens[t.takerTokenBuy][t.taker]            = safeAdd(tokens[t.takerTokenBuy][t.taker],            tv.takerAmountTaken);\n', '            tokens[t.takerTokenBuy][tv.takerReferrer]   = safeAdd(tokens[t.takerTokenBuy][tv.takerReferrer],   safeMul(tv.qty,    takerAffiliateFee) / (1 ether));\n', '\n', '            tokens[t.makerTokenBuy][feeAccount]     = safeAdd(tokens[t.makerTokenBuy][feeAccount],      safeMul(tv.invQty, safeSub(makerFee, makerAffiliateFee)) / (1 ether));\n', '            tokens[t.takerTokenBuy][feeAccount]     = safeAdd(tokens[t.takerTokenBuy][feeAccount],      safeAdd(safeMul(tv.qty,    safeSub(takerFee, takerAffiliateFee)) / (1 ether), safeMul(tv.qty, t.takerGasFee) / (1 ether)));\n', '\n', '            orderFills[t.makerOrderHash]            = safeAdd(orderFills[t.makerOrderHash], tv.invQty);\n', '            orderFills[t.takerOrderHash]            = safeAdd(orderFills[t.takerOrderHash], tv.qty); //safeMul(qty, tradeValues[takerAmountBuy]) / tradeValues[takerAmountSell]);\n', '\n', '            lastActiveTransaction[t.maker]          = block.number;\n', '            lastActiveTransaction[t.taker]          = block.number;\n', '\n', '            Trade(\n', '                t.takerTokenBuy, tv.qty,\n', '                t.takerTokenSell, tv.invQty,\n', '                t.maker, t.taker,\n', '                makerFee, takerFee,\n', '                tv.makerAmountTaken , tv.takerAmountTaken,\n', '                t.makerOrderHash, t.takerOrderHash\n', '            );\n', '            return tv.qty;\n', '        }\n', '    }\n', '    \n', '    function batchOrderTrade(\n', '        uint8[2][] v,\n', '        bytes32[4][] rs,\n', '        uint256[7][] tradeValues,\n', '        address[6][] tradeAddresses\n', '    )\n', '    {\n', '        for (uint i = 0; i < tradeAddresses.length; i++) {\n', '            trade(\n', '                v[i],\n', '                rs[i],\n', '                tradeValues[i],\n', '                tradeAddresses[i]            \n', '            );\n', '        }\n', '    }\n', '\n', '    function cancelOrder(\n', '\t\t/*\n', '\t\t[0] orderV\n', '\t\t[1] cancelV\n', '\t\t*/\n', '\t    uint8[2] v,\n', '\n', '\t\t/*\n', '\t\t[0] orderR\n', '\t\t[1] orderS\n', '\t\t[2] cancelR\n', '\t\t[3] cancelS\n', '\t\t*/\n', '\t    bytes32[4] rs,\n', '\n', '\t\t/*\n', '\t\t[0] orderAmountBuy\n', '\t\t[1] orderAmountSell\n', '\t\t[2] orderNonce\n', '\t\t[3] cancelNonce\n', '\t\t[4] cancelFee\n', '\t\t*/\n', '\t\tuint256[5] cancelValues,\n', '\n', '\t\t/*\n', '\t\t[0] orderTokenBuy\n', '\t\t[1] orderTokenSell\n', '\t\t[2] orderUser\n', '\t\t[3] cancelUser\n', '\t\t*/\n', '\t\taddress[4] cancelAddresses\n', '    ) public onlyAdmin {\n', '        // Order values should be valid and signed by order owner\n', '        bytes32 orderHash = keccak256(\n', '\t        this, cancelAddresses[0], cancelValues[0], cancelAddresses[1],\n', '\t        cancelValues[1], cancelValues[2], cancelAddresses[2]\n', '        );\n', '        require(ecrecover(keccak256("\\x19Ethereum Signed Message:\\n32", orderHash), v[0], rs[0], rs[1]) == cancelAddresses[2]);\n', '\n', '        // Cancel action should be signed by cancel&#39;s initiator\n', '        bytes32 cancelHash = keccak256(this, orderHash, cancelAddresses[3], cancelValues[3]);\n', '        require(ecrecover(keccak256("\\x19Ethereum Signed Message:\\n32", cancelHash), v[1], rs[2], rs[3]) == cancelAddresses[3]);\n', '\n', '        // Order owner should be same as cancel&#39;s initiator\n', '        require(cancelAddresses[2] == cancelAddresses[3]);\n', '\n', '        // Do not allow to cancel already canceled or filled orders\n', '        require(orderFills[orderHash] != cancelValues[0]);\n', '\n', '        // Limit cancel fee\n', '        if (cancelValues[4] > 50 finney) {\n', '            cancelValues[4] = 50 finney;\n', '        }\n', '\n', '        // Take cancel fee\n', '        // This operation throw an error if fee amount is more than user balance\n', '        tokens[address(0)][cancelAddresses[3]] = safeSub(tokens[address(0)][cancelAddresses[3]], cancelValues[4]);\n', '\n', '        // Cancel order by filling it with amount buy value\n', '        orderFills[orderHash] = cancelValues[0];\n', '\n', '        // Emit cancel order\n', '        CancelOrder(cancelHash, orderHash, cancelAddresses[3], cancelAddresses[1], cancelValues[1], cancelValues[4]);\n', '    }\n', '\n', '    function min(uint a, uint b) private pure returns (uint) {\n', '        return a < b ? a : b;\n', '    }\n', '}']