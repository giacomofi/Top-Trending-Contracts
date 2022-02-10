['// DEx.top - Instant Trading on Chain\n', '//\n', '// Author: DEx.top Team\n', '\n', 'pragma solidity 0.4.21;\n', 'pragma experimental "v0.5.0";\n', '\n', 'interface Token {\n', '  function transfer(address to, uint256 value) external returns (bool success);\n', '  function transferFrom(address from, address to, uint256 value) external returns (bool success);\n', '}\n', '\n', 'contract Dex2 {\n', '  //------------------------------ Struct Definitions: ---------------------------------------------\n', '\n', '  struct TokenInfo {\n', '    string  symbol;       // e.g., "ETH", "ADX"\n', '    address tokenAddr;    // ERC20 token address\n', '    uint64  scaleFactor;  // <original token amount> = <scaleFactor> x <DEx amountE8> / 1e8\n', '    uint    minDeposit;   // mininum deposit (original token amount) allowed for this token\n', '  }\n', '\n', '  struct TraderInfo {\n', '    address withdrawAddr;\n', '    uint8   feeRebatePercent;  // range: [0, 100]\n', '  }\n', '\n', '  struct TokenAccount {\n', '    uint64 balanceE8;          // available amount for trading\n', '    uint64 pendingWithdrawE8;  // the amount to be transferred out from this contract to the trader\n', '  }\n', '\n', '  struct Order {\n', '    uint32 pairId;  // <cashId>(16) <stockId>(16)\n', '    uint8  action;  // 0 means BUY; 1 means SELL\n', '    uint8  ioc;     // 0 means a regular order; 1 means an immediate-or-cancel (IOC) order\n', '    uint64 priceE8;\n', '    uint64 amountE8;\n', '    uint64 expireTimeSec;\n', '  }\n', '\n', '  struct Deposit {\n', '    address traderAddr;\n', '    uint16  tokenCode;\n', '    uint64  pendingAmountE8;   // amount to be confirmed for trading purpose\n', '  }\n', '\n', '  struct DealInfo {\n', '    uint16 stockCode;          // stock token code\n', '    uint16 cashCode;           // cash token code\n', '    uint64 stockDealAmountE8;\n', '    uint64 cashDealAmountE8;\n', '  }\n', '\n', '  struct ExeStatus {\n', '    uint64 logicTimeSec;       // logic timestamp for checking order expiration\n', '    uint64 lastOperationIndex; // index of the last executed operation\n', '  }\n', '\n', '  //----------------- Constants: -------------------------------------------------------------------\n', '\n', '  uint constant MAX_UINT256 = 2**256 - 1;\n', '  uint16 constant MAX_FEE_RATE_E4 = 60;  // upper limit of fee rate is 0.6% (60 / 1e4)\n', '\n', '  // <original ETH amount in Wei> = <DEx amountE8> * <ETH_SCALE_FACTOR> / 1e8\n', '  uint64 constant ETH_SCALE_FACTOR = 10**18;\n', '\n', '  uint8 constant ACTIVE = 0;\n', '  uint8 constant CLOSED = 2;\n', '\n', '  bytes32 constant HASHTYPES =\n', '      keccak256(&#39;string title&#39;, &#39;address market_address&#39;, &#39;uint64 nonce&#39;, &#39;uint64 expire_time_sec&#39;,\n', '                &#39;uint64 amount_e8&#39;, &#39;uint64 price_e8&#39;, &#39;uint8 immediate_or_cancel&#39;, &#39;uint8 action&#39;,\n', '                &#39;uint16 cash_token_code&#39;, &#39;uint16 stock_token_code&#39;);\n', '\n', '  //----------------- States that cannot be changed once set: --------------------------------------\n', '\n', '  address public admin;                         // admin address, and it cannot be changed\n', '  mapping (uint16 => TokenInfo) public tokens;  // mapping of token code to token information\n', '\n', '  //----------------- Other states: ----------------------------------------------------------------\n', '\n', '  uint8 public marketStatus;        // market status: 0 - Active; 1 - Suspended; 2 - Closed\n', '\n', '  uint16 public makerFeeRateE4;     // maker fee rate (* 10**4)\n', '  uint16 public takerFeeRateE4;     // taker fee rate (* 10**4)\n', '  uint16 public withdrawFeeRateE4;  // withdraw fee rate (* 10**4)\n', '\n', '  uint64 public lastDepositIndex;   // index of the last deposit operation\n', '\n', '  ExeStatus public exeStatus;       // status of operation execution\n', '\n', '  mapping (address => TraderInfo) public traders;     // mapping of trade address to trader information\n', '  mapping (uint176 => TokenAccount) public accounts;  // mapping of trader token key to its account information\n', '  mapping (uint224 => Order) public orders;           // mapping of order key to order information\n', '  mapping (uint64  => Deposit) public deposits;       // mapping of deposit index to deposit information\n', '\n', '  //------------------------------ Dex2 Events: ----------------------------------------------------\n', '\n', '  event DeployMarketEvent();\n', '  event ChangeMarketStatusEvent(uint8 status);\n', '  event SetTokenInfoEvent(uint16 tokenCode, string symbol, address tokenAddr, uint64 scaleFactor, uint minDeposit);\n', '  event SetWithdrawAddrEvent(address trader, address withdrawAddr);\n', '\n', '  event DepositEvent(address trader, uint16 tokenCode, string symbol, uint64 amountE8, uint64 depositIndex);\n', '  event WithdrawEvent(address trader, uint16 tokenCode, string symbol, uint64 amountE8, uint64 lastOpIndex);\n', '  event TransferFeeEvent(uint16 tokenCode, uint64 amountE8, address toAddr);\n', '\n', '  // `balanceE8` is the total balance after this deposit confirmation\n', '  event ConfirmDepositEvent(address trader, uint16 tokenCode, uint64 balanceE8);\n', '  // `amountE8` is the post-fee initiated withdraw amount\n', '  // `pendingWithdrawE8` is the total pending withdraw amount after this withdraw initiation\n', '  event InitiateWithdrawEvent(address trader, uint16 tokenCode, uint64 amountE8, uint64 pendingWithdrawE8);\n', '  event MatchOrdersEvent(address trader1, uint64 nonce1, address trader2, uint64 nonce2);\n', '  event HardCancelOrderEvent(address trader, uint64 nonce);\n', '  event SetFeeRatesEvent(uint16 makerFeeRateE4, uint16 takerFeeRateE4, uint16 withdrawFeeRateE4);\n', '  event SetFeeRebatePercentEvent(address trader, uint8 feeRebatePercent);\n', '\n', '  //------------------------------ Contract Initialization: ----------------------------------------\n', '\n', '  function Dex2(address admin_) public {\n', '    admin = admin_;\n', '    setTokenInfo(0 /*tokenCode*/, "ETH", 0 /*tokenAddr*/, ETH_SCALE_FACTOR, 0 /*minDeposit*/);\n', '    emit DeployMarketEvent();\n', '  }\n', '\n', '  //------------------------------ External Functions: ---------------------------------------------\n', '\n', '  function() external {\n', '    revert();\n', '  }\n', '\n', '  // Change the market status of DEX.\n', '  function changeMarketStatus(uint8 status_) external {\n', '    if (msg.sender != admin) revert();\n', '    if (marketStatus == CLOSED) revert();  // closed is forever\n', '\n', '    marketStatus = status_;\n', '    emit ChangeMarketStatusEvent(status_);\n', '  }\n', '\n', '  // Each trader can specify a withdraw address (but cannot change it later). Once a trader&#39;s\n', '  // withdraw address is set, following withdrawals of this trader will go to the withdraw address\n', '  // instead of the trader&#39;s address.\n', '  function setWithdrawAddr(address withdrawAddr) external {\n', '    if (withdrawAddr == 0) revert();\n', '    if (traders[msg.sender].withdrawAddr != 0) revert();  // cannot change withdrawAddr once set\n', '    traders[msg.sender].withdrawAddr = withdrawAddr;\n', '    emit SetWithdrawAddrEvent(msg.sender, withdrawAddr);\n', '  }\n', '\n', '  // Deposit ETH from msg.sender for the given trader.\n', '  function depositEth(address traderAddr) external payable {\n', '    if (marketStatus != ACTIVE) revert();\n', '    if (traderAddr == 0) revert();\n', '    if (msg.value < tokens[0].minDeposit) revert();\n', '    if (msg.data.length != 4 + 32) revert();  // length condition of param count\n', '\n', '    uint64 pendingAmountE8 = uint64(msg.value / (ETH_SCALE_FACTOR / 10**8));  // msg.value is in Wei\n', '    if (pendingAmountE8 == 0) revert();\n', '\n', '    uint64 depositIndex = ++lastDepositIndex;\n', '    setDeposits(depositIndex, traderAddr, 0, pendingAmountE8);\n', '    emit DepositEvent(traderAddr, 0, "ETH", pendingAmountE8, depositIndex);\n', '  }\n', '\n', '  // Deposit token (other than ETH) from msg.sender for a specified trader.\n', '  //\n', '  // After the deposit has been confirmed enough times on the blockchain, it will be added to the\n', '  // trader&#39;s token account for trading.\n', '  function depositToken(address traderAddr, uint16 tokenCode, uint originalAmount) external {\n', '    if (marketStatus != ACTIVE) revert();\n', '    if (traderAddr == 0) revert();\n', '    if (tokenCode == 0) revert();  // this function does not handle ETH\n', '    if (msg.data.length != 4 + 32 + 32 + 32) revert();  // length condition of param count\n', '\n', '    TokenInfo memory tokenInfo = tokens[tokenCode];\n', '    if (originalAmount < tokenInfo.minDeposit) revert();\n', '    if (tokenInfo.scaleFactor == 0) revert();  // unsupported token\n', '\n', '    // Need to make approval by calling Token(address).approve() in advance for ERC-20 Tokens.\n', '    if (!Token(tokenInfo.tokenAddr).transferFrom(msg.sender, this, originalAmount)) revert();\n', '\n', '    if (originalAmount > MAX_UINT256 / 10**8) revert();  // avoid overflow\n', '    uint amountE8 = originalAmount * 10**8 / uint(tokenInfo.scaleFactor);\n', '    if (amountE8 >= 2**64 || amountE8 == 0) revert();\n', '\n', '    uint64 depositIndex = ++lastDepositIndex;\n', '    setDeposits(depositIndex, traderAddr, tokenCode, uint64(amountE8));\n', '    emit DepositEvent(traderAddr, tokenCode, tokens[tokenCode].symbol, uint64(amountE8), depositIndex);\n', '  }\n', '\n', '  // Withdraw ETH from the contract.\n', '  function withdrawEth(address traderAddr) external {\n', '    if (traderAddr == 0) revert();\n', '    if (msg.data.length != 4 + 32) revert();  // length condition of param count\n', '\n', '    uint176 accountKey = uint176(traderAddr);\n', '    uint amountE8 = accounts[accountKey].pendingWithdrawE8;\n', '    if (amountE8 == 0) return;\n', '\n', '    // Write back to storage before making the transfer.\n', '    accounts[accountKey].pendingWithdrawE8 = 0;\n', '\n', '    uint truncatedWei = amountE8 * (ETH_SCALE_FACTOR / 10**8);\n', '    address withdrawAddr = traders[traderAddr].withdrawAddr;\n', '    if (withdrawAddr == 0) withdrawAddr = traderAddr;\n', '    withdrawAddr.transfer(truncatedWei);\n', '    emit WithdrawEvent(traderAddr, 0, "ETH", uint64(amountE8), exeStatus.lastOperationIndex);\n', '  }\n', '\n', '  // Withdraw token (other than ETH) from the contract.\n', '  function withdrawToken(address traderAddr, uint16 tokenCode) external {\n', '    if (traderAddr == 0) revert();\n', '    if (tokenCode == 0) revert();  // this function does not handle ETH\n', '    if (msg.data.length != 4 + 32 + 32) revert();  // length condition of param count\n', '\n', '    TokenInfo memory tokenInfo = tokens[tokenCode];\n', '    if (tokenInfo.scaleFactor == 0) revert();  // unsupported token\n', '\n', '    uint176 accountKey = uint176(tokenCode) << 160 | uint176(traderAddr);\n', '    uint amountE8 = accounts[accountKey].pendingWithdrawE8;\n', '    if (amountE8 == 0) return;\n', '\n', '    // Write back to storage before making the transfer.\n', '    accounts[accountKey].pendingWithdrawE8 = 0;\n', '\n', '    uint truncatedAmount = amountE8 * uint(tokenInfo.scaleFactor) / 10**8;\n', '    address withdrawAddr = traders[traderAddr].withdrawAddr;\n', '    if (withdrawAddr == 0) withdrawAddr = traderAddr;\n', '    if (!Token(tokenInfo.tokenAddr).transfer(withdrawAddr, truncatedAmount)) revert();\n', '    emit WithdrawEvent(traderAddr, tokenCode, tokens[tokenCode].symbol, uint64(amountE8),\n', '                       exeStatus.lastOperationIndex);\n', '  }\n', '\n', '  // Transfer the collected fee out of the contract.\n', '  function transferFee(uint16 tokenCode, uint64 amountE8, address toAddr) external {\n', '    if (msg.sender != admin) revert();\n', '    if (toAddr == 0) revert();\n', '    if (msg.data.length != 4 + 32 + 32 + 32) revert();\n', '\n', '    TokenAccount memory feeAccount = accounts[uint176(tokenCode) << 160];\n', '    uint64 withdrawE8 = feeAccount.pendingWithdrawE8;\n', '    if (amountE8 < withdrawE8) {\n', '      withdrawE8 = amountE8;\n', '    }\n', '    feeAccount.pendingWithdrawE8 -= withdrawE8;\n', '    accounts[uint176(tokenCode) << 160] = feeAccount;\n', '\n', '    TokenInfo memory tokenInfo = tokens[tokenCode];\n', '    uint originalAmount = uint(withdrawE8) * uint(tokenInfo.scaleFactor) / 10**8;\n', '    if (tokenCode == 0) {  // ETH\n', '      toAddr.transfer(originalAmount);\n', '    } else {\n', '      if (!Token(tokenInfo.tokenAddr).transfer(toAddr, originalAmount)) revert();\n', '    }\n', '    emit TransferFeeEvent(tokenCode, withdrawE8, toAddr);\n', '  }\n', '\n', '  // Replay the trading sequence from the off-chain ledger exactly onto the on-chain ledger.\n', '  function exeSequence(uint header, uint[] body) external {\n', '    if (msg.sender != admin) revert();\n', '\n', '    uint64 nextOperationIndex = uint64(header);\n', '    if (nextOperationIndex != exeStatus.lastOperationIndex + 1) revert();  // check sequence index\n', '\n', '    uint64 newLogicTimeSec = uint64(header >> 64);\n', '    if (newLogicTimeSec < exeStatus.logicTimeSec) revert();\n', '\n', '    for (uint i = 0; i < body.length; nextOperationIndex++) {\n', '      uint bits = body[i];\n', '      uint opcode = bits & 0xFFFF;\n', '      bits >>= 16;\n', '      if ((opcode >> 8) != 0xDE) revert();  // check the magic number\n', '\n', '      // ConfirmDeposit: <depositIndex>(64)\n', '      if (opcode == 0xDE01) {\n', '        confirmDeposit(uint64(bits));\n', '        i += 1;\n', '        continue;\n', '      }\n', '\n', '      // InitiateWithdraw: <amountE8>(64) <tokenCode>(16) <traderAddr>(160)\n', '      if (opcode == 0xDE02) {\n', '        initiateWithdraw(uint176(bits), uint64(bits >> 176));\n', '        i += 1;\n', '        continue;\n', '      }\n', '\n', '      //-------- The rest operation types are allowed only when the market is active ---------\n', '      if (marketStatus != ACTIVE) revert();\n', '\n', '      // MatchOrders\n', '      if (opcode == 0xDE03) {\n', '        uint8 v1 = uint8(bits);\n', '        bits >>= 8;            // bits is now the key of the maker order\n', '\n', '        Order memory makerOrder;\n', '        if (v1 == 0) {         // order already in storage\n', '          if (i + 1 >= body.length) revert();  // at least 1 body element left\n', '          makerOrder = orders[uint224(bits)];\n', '          i += 1;\n', '        } else {\n', '          if (orders[uint224(bits)].pairId != 0) revert();  // order must not be already in storage\n', '          if (i + 4 >= body.length) revert();  // at least 4 body elements left\n', '          makerOrder = parseNewOrder(uint224(bits) /*makerOrderKey*/, v1, body, i);\n', '          i += 4;\n', '        }\n', '\n', '        uint8 v2 = uint8(body[i]);\n', '        uint224 takerOrderKey = uint224(body[i] >> 8);\n', '        Order memory takerOrder;\n', '        if (v2 == 0) {         // order already in storage\n', '          takerOrder = orders[takerOrderKey];\n', '          i += 1;\n', '        } else {\n', '          if (orders[takerOrderKey].pairId != 0) revert();  // order must not be already in storage\n', '          if (i + 3 >= body.length) revert();  // at least 3 body elements left\n', '          takerOrder = parseNewOrder(takerOrderKey, v2, body, i);\n', '          i += 4;\n', '        }\n', '\n', '        matchOrder(uint224(bits) /*makerOrderKey*/, makerOrder, takerOrderKey, takerOrder);\n', '        continue;\n', '      }\n', '\n', '      // HardCancelOrder: <nonce>(64) <traderAddr>(160)\n', '      if (opcode == 0xDE04) {\n', '        hardCancelOrder(uint224(bits) /*orderKey*/);\n', '        i += 1;\n', '        continue;\n', '      }\n', '\n', '      // SetFeeRates: <withdrawFeeRateE4>(16) <takerFeeRateE4>(16) <makerFeeRateE4>(16)\n', '      if (opcode == 0xDE05) {\n', '        setFeeRates(uint16(bits), uint16(bits >> 16), uint16(bits >> 32));\n', '        i += 1;\n', '        continue;\n', '      }\n', '\n', '      // SetFeeRebatePercent: <rebatePercent>(8) <traderAddr>(160)\n', '      if (opcode == 0xDE06) {\n', '        setFeeRebatePercent(address(bits) /*traderAddr*/, uint8(bits >> 160) /*rebatePercent*/);\n', '        i += 1;\n', '        continue;\n', '      }\n', '    } // for loop\n', '\n', '    setExeStatus(newLogicTimeSec, nextOperationIndex - 1);\n', '  } // function exeSequence\n', '\n', '  //------------------------------ Public Functions: -----------------------------------------------\n', '\n', '  // Set information of a token.\n', '  function setTokenInfo(uint16 tokenCode, string symbol, address tokenAddr, uint64 scaleFactor,\n', '                        uint minDeposit) public {\n', '    if (msg.sender != admin) revert();\n', '    if (marketStatus != ACTIVE) revert();\n', '    if (scaleFactor == 0) revert();\n', '\n', '    TokenInfo memory info = tokens[tokenCode];\n', '    if (info.scaleFactor != 0) {  // this token already exists\n', '      // For an existing token only the minDeposit field can be updated.\n', '      tokens[tokenCode].minDeposit = minDeposit;\n', '      emit SetTokenInfoEvent(tokenCode, info.symbol, info.tokenAddr, info.scaleFactor, minDeposit);\n', '      return;\n', '    }\n', '\n', '    tokens[tokenCode].symbol = symbol;\n', '    tokens[tokenCode].tokenAddr = tokenAddr;\n', '    tokens[tokenCode].scaleFactor = scaleFactor;\n', '    tokens[tokenCode].minDeposit = minDeposit;\n', '    emit SetTokenInfoEvent(tokenCode, symbol, tokenAddr, scaleFactor, minDeposit);\n', '  }\n', '\n', '  //------------------------------ Private Functions: ----------------------------------------------\n', '\n', '  function setDeposits(uint64 depositIndex, address traderAddr, uint16 tokenCode, uint64 amountE8) private {\n', '    deposits[depositIndex].traderAddr = traderAddr;\n', '    deposits[depositIndex].tokenCode = tokenCode;\n', '    deposits[depositIndex].pendingAmountE8 = amountE8;\n', '  }\n', '\n', '  function setExeStatus(uint64 logicTimeSec, uint64 lastOperationIndex) private {\n', '    exeStatus.logicTimeSec = logicTimeSec;\n', '    exeStatus.lastOperationIndex = lastOperationIndex;\n', '  }\n', '\n', '  function confirmDeposit(uint64 depositIndex) private {\n', '    Deposit memory deposit = deposits[depositIndex];\n', '    uint176 accountKey = (uint176(deposit.tokenCode) << 160) | uint176(deposit.traderAddr);\n', '    TokenAccount memory account = accounts[accountKey];\n', '\n', '    // Check that pending amount is non-zero and no overflow would happen.\n', '    if (account.balanceE8 + deposit.pendingAmountE8 <= account.balanceE8) revert();\n', '    account.balanceE8 += deposit.pendingAmountE8;\n', '\n', '    deposits[depositIndex].pendingAmountE8 = 0;\n', '    accounts[accountKey].balanceE8 += deposit.pendingAmountE8;\n', '    emit ConfirmDepositEvent(deposit.traderAddr, deposit.tokenCode, account.balanceE8);\n', '  }\n', '\n', '  function initiateWithdraw(uint176 tokenAccountKey, uint64 amountE8) private {\n', '    uint64 balanceE8 = accounts[tokenAccountKey].balanceE8;\n', '    uint64 pendingWithdrawE8 = accounts[tokenAccountKey].pendingWithdrawE8;\n', '\n', '    if (balanceE8 < amountE8 || amountE8 == 0) revert();\n', '    balanceE8 -= amountE8;\n', '\n', '    uint64 feeE8 = calcFeeE8(amountE8, withdrawFeeRateE4, address(tokenAccountKey));\n', '    amountE8 -= feeE8;\n', '\n', '    if (pendingWithdrawE8 + amountE8 < amountE8) revert();  // check overflow\n', '    pendingWithdrawE8 += amountE8;\n', '\n', '    accounts[tokenAccountKey].balanceE8 = balanceE8;\n', '    accounts[tokenAccountKey].pendingWithdrawE8 = pendingWithdrawE8;\n', '\n', '    // Note that the fee account has a dummy trader address of 0.\n', '    if (accounts[tokenAccountKey & (0xffff << 160)].pendingWithdrawE8 + feeE8 >= feeE8) {  // no overflow\n', '      accounts[tokenAccountKey & (0xffff << 160)].pendingWithdrawE8 += feeE8;\n', '    }\n', '\n', '    emit InitiateWithdrawEvent(address(tokenAccountKey), uint16(tokenAccountKey >> 160) /*tokenCode*/,\n', '                               amountE8, pendingWithdrawE8);\n', '  }\n', '\n', '  function getDealInfo(uint32 pairId, uint64 priceE8, uint64 amount1E8, uint64 amount2E8)\n', '      private pure returns (DealInfo deal) {\n', '    deal.stockCode = uint16(pairId);\n', '    deal.cashCode = uint16(pairId >> 16);\n', '    if (deal.stockCode == deal.cashCode) revert();  // we disallow homogeneous trading\n', '\n', '    deal.stockDealAmountE8 = amount1E8 < amount2E8 ? amount1E8 : amount2E8;\n', '\n', '    uint cashDealAmountE8 = uint(priceE8) * uint(deal.stockDealAmountE8) / 10**8;\n', '    if (cashDealAmountE8 >= 2**64) revert();\n', '    deal.cashDealAmountE8 = uint64(cashDealAmountE8);\n', '  }\n', '\n', '  function calcFeeE8(uint64 amountE8, uint feeRateE4, address traderAddr)\n', '      private view returns (uint64) {\n', '    uint feeE8 = uint(amountE8) * feeRateE4 / 10000;\n', '    feeE8 -= feeE8 * uint(traders[traderAddr].feeRebatePercent) / 100;\n', '    return uint64(feeE8);\n', '  }\n', '\n', '  function settleAccounts(DealInfo deal, address traderAddr, uint feeRateE4, bool isBuyer) private {\n', '    uint16 giveTokenCode = isBuyer ? deal.cashCode : deal.stockCode;\n', '    uint16 getTokenCode = isBuyer ? deal.stockCode : deal.cashCode;\n', '\n', '    uint64 giveAmountE8 = isBuyer ? deal.cashDealAmountE8 : deal.stockDealAmountE8;\n', '    uint64 getAmountE8 = isBuyer ? deal.stockDealAmountE8 : deal.cashDealAmountE8;\n', '\n', '    uint176 giveAccountKey = uint176(giveTokenCode) << 160 | uint176(traderAddr);\n', '    uint176 getAccountKey = uint176(getTokenCode) << 160 | uint176(traderAddr);\n', '\n', '    uint64 feeE8 = calcFeeE8(getAmountE8, feeRateE4, traderAddr);\n', '    getAmountE8 -= feeE8;\n', '\n', '    // Check overflow.\n', '    if (accounts[giveAccountKey].balanceE8 < giveAmountE8) revert();\n', '    if (accounts[getAccountKey].balanceE8 + getAmountE8 < getAmountE8) revert();\n', '\n', '    // Write storage.\n', '    accounts[giveAccountKey].balanceE8 -= giveAmountE8;\n', '    accounts[getAccountKey].balanceE8 += getAmountE8;\n', '\n', '    if (accounts[uint176(getTokenCode) << 160].pendingWithdrawE8 + feeE8 >= feeE8) {  // no overflow\n', '      accounts[uint176(getTokenCode) << 160].pendingWithdrawE8 += feeE8;\n', '    }\n', '  }\n', '\n', '  function setOrders(uint224 orderKey, uint32 pairId, uint8 action, uint8 ioc,\n', '                     uint64 priceE8, uint64 amountE8, uint64 expireTimeSec) private {\n', '    orders[orderKey].pairId = pairId;\n', '    orders[orderKey].action = action;\n', '    orders[orderKey].ioc = ioc;\n', '    orders[orderKey].priceE8 = priceE8;\n', '    orders[orderKey].amountE8 = amountE8;\n', '    orders[orderKey].expireTimeSec = expireTimeSec;\n', '  }\n', '\n', '  function matchOrder(uint224 makerOrderKey, Order makerOrder,\n', '                      uint224 takerOrderKey, Order takerOrder) private {\n', '    // Check trading conditions.\n', '    if (marketStatus != ACTIVE) revert();\n', '    if (makerOrderKey == takerOrderKey) revert();  // the two orders must not have the same key\n', '    if (makerOrder.pairId != takerOrder.pairId) revert();\n', '    if (makerOrder.action == takerOrder.action) revert();\n', '    if (makerOrder.priceE8 == 0 || takerOrder.priceE8 == 0) revert();\n', '    if (makerOrder.action == 0 && makerOrder.priceE8 < takerOrder.priceE8) revert();\n', '    if (takerOrder.action == 0 && takerOrder.priceE8 < makerOrder.priceE8) revert();\n', '    if (makerOrder.amountE8 == 0 || takerOrder.amountE8 == 0) revert();\n', '    if (makerOrder.expireTimeSec <= exeStatus.logicTimeSec) revert();\n', '    if (takerOrder.expireTimeSec <= exeStatus.logicTimeSec) revert();\n', '\n', '    DealInfo memory deal = getDealInfo(\n', '        makerOrder.pairId, makerOrder.priceE8, makerOrder.amountE8, takerOrder.amountE8);\n', '\n', '    // Update accounts.\n', '    settleAccounts(deal, address(makerOrderKey), makerFeeRateE4, (makerOrder.action == 0));\n', '    settleAccounts(deal, address(takerOrderKey), takerFeeRateE4, (takerOrder.action == 0));\n', '\n', '    // Update orders.\n', '    if (makerOrder.ioc == 1) {  // IOC order\n', '      makerOrder.amountE8 = 0;\n', '    } else {\n', '      makerOrder.amountE8 -= deal.stockDealAmountE8;\n', '    }\n', '    if (takerOrder.ioc == 1) {  // IOC order\n', '      takerOrder.amountE8 = 0;\n', '    } else {\n', '      takerOrder.amountE8 -= deal.stockDealAmountE8;\n', '    }\n', '\n', '    // Write orders back to storage.\n', '    setOrders(makerOrderKey, makerOrder.pairId, makerOrder.action, makerOrder.ioc,\n', '              makerOrder.priceE8, makerOrder.amountE8, makerOrder.expireTimeSec);\n', '    setOrders(takerOrderKey, takerOrder.pairId, takerOrder.action, takerOrder.ioc,\n', '              takerOrder.priceE8, takerOrder.amountE8, takerOrder.expireTimeSec);\n', '\n', '    emit MatchOrdersEvent(address(makerOrderKey), uint64(makerOrderKey >> 160) /*nonce*/,\n', '                          address(takerOrderKey), uint64(takerOrderKey >> 160) /*nonce*/);\n', '  }\n', '\n', '  function hardCancelOrder(uint224 orderKey) private {\n', '    orders[orderKey].pairId = 0xFFFFFFFF;\n', '    orders[orderKey].amountE8 = 0;\n', '    emit HardCancelOrderEvent(address(orderKey) /*traderAddr*/, uint64(orderKey >> 160) /*nonce*/);\n', '  }\n', '\n', '  function setFeeRates(uint16 makerE4, uint16 takerE4, uint16 withdrawE4) private {\n', '    if (makerE4 > MAX_FEE_RATE_E4) revert();\n', '    if (takerE4 > MAX_FEE_RATE_E4) revert();\n', '    if (withdrawE4 > MAX_FEE_RATE_E4) revert();\n', '\n', '    makerFeeRateE4 = makerE4;\n', '    takerFeeRateE4 = takerE4;\n', '    withdrawFeeRateE4 = withdrawE4;\n', '    emit SetFeeRatesEvent(makerE4, takerE4, withdrawE4);\n', '  }\n', '\n', '  function setFeeRebatePercent(address traderAddr, uint8 feeRebatePercent) private {\n', '    if (feeRebatePercent > 100) revert();\n', '\n', '    traders[traderAddr].feeRebatePercent = feeRebatePercent;\n', '    emit SetFeeRebatePercentEvent(traderAddr, feeRebatePercent);\n', '  }\n', '\n', '  function parseNewOrder(uint224 orderKey, uint8 v, uint[] body, uint i) private view returns (Order) {\n', '    // bits: <expireTimeSec>(64) <amountE8>(64) <priceE8>(64) <ioc>(8) <action>(8) <pairId>(32)\n', '    uint240 bits = uint240(body[i + 1]);\n', '    uint64 nonce = uint64(orderKey >> 160);\n', '    address traderAddr = address(orderKey);\n', '    if (traderAddr == 0) revert();  // check zero addr early since `ecrecover` returns 0 on error\n', '\n', '    // verify the signature of the trader\n', '    bytes32 hash1 = keccak256("\\x19Ethereum Signed Message:\\n70DEx2 Order: ", address(this), nonce, bits);\n', '    if (traderAddr != ecrecover(hash1, v, bytes32(body[i + 2]), bytes32(body[i + 3]))) {\n', '      bytes32 hashValues = keccak256("DEx2 Order", address(this), nonce, bits);\n', '      bytes32 hash2 = keccak256(HASHTYPES, hashValues);\n', '      if (traderAddr != ecrecover(hash2, v, bytes32(body[i + 2]), bytes32(body[i + 3]))) revert();\n', '    }\n', '\n', '    Order memory order;\n', '    order.pairId = uint32(bits); bits >>= 32;\n', '    order.action = uint8(bits); bits >>= 8;\n', '    order.ioc = uint8(bits); bits >>= 8;\n', '    order.priceE8 = uint64(bits); bits >>= 64;\n', '    order.amountE8 = uint64(bits); bits >>= 64;\n', '    order.expireTimeSec = uint64(bits);\n', '    return order;\n', '  }\n', '\n', '}  // contract']