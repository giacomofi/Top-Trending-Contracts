['pragma solidity ^0.4.16;\n', '\n', 'contract Token {\n', '    bytes32 public standard;\n', '    bytes32 public name;\n', '    bytes32 public symbol;\n', '    uint256 public totalSupply;\n', '    uint8 public decimals;\n', '    bool public allowTransactions;\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '}\n', '\n', 'contract Exchange {\n', '  function assert(bool assertion) {\n', '    if (!assertion) throw;\n', '  }\n', '  function safeMul(uint a, uint b) returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '  address public owner;\n', '  mapping (address => uint256) public invalidOrder;\n', '  event SetOwner(address indexed previousOwner, address indexed newOwner);\n', '  modifier onlyOwner {\n', '    assert(msg.sender == owner);\n', '    _;\n', '  }\n', '  function setOwner(address newOwner) onlyOwner {\n', '    SetOwner(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '  function getOwner() returns (address out) {\n', '    return owner;\n', '  }\n', '  function invalidateOrdersBefore(address user, uint256 nonce) onlyAdmin {\n', '    if (nonce < invalidOrder[user]) throw;\n', '    invalidOrder[user] = nonce;\n', '  }\n', '\n', '  mapping (address => mapping (address => uint256)) public tokens; //mapping of token addresses to mapping of account balances\n', '\n', '  mapping (address => bool) public admins;\n', '  mapping (address => uint256) public lastActiveTransaction;\n', '  mapping (bytes32 => uint256) public orderFills;\n', '  address public feeAccount;\n', '  uint256 public inactivityReleasePeriod;\n', '  mapping (bytes32 => bool) public traded;\n', '  mapping (bytes32 => bool) public withdrawn;\n', '  event Order(address tokenBuy, uint256 amountBuy, address tokenSell, uint256 amountSell, uint256 expires, uint256 nonce, address user, uint8 v, bytes32 r, bytes32 s);\n', '  event Cancel(address tokenBuy, uint256 amountBuy, address tokenSell, uint256 amountSell, uint256 expires, uint256 nonce, address user, uint8 v, bytes32 r, bytes32 s);\n', '  event Trade(address tokenBuy, uint256 amountBuy, address tokenSell, uint256 amountSell, address get, address give);\n', '  event Deposit(address token, address user, uint256 amount, uint256 balance);\n', '  event Withdraw(address token, address user, uint256 amount, uint256 balance);\n', '\n', '  function setInactivityReleasePeriod(uint256 expiry) onlyAdmin returns (bool success) {\n', '    if (expiry > 1000000) throw;\n', '    inactivityReleasePeriod = expiry;\n', '    return true;\n', '  }\n', '\n', '  function Exchange(address feeAccount_) {\n', '    owner = msg.sender;\n', '    feeAccount = feeAccount_;\n', '    inactivityReleasePeriod = 100000;\n', '  }\n', '\n', '  function setAdmin(address admin, bool isAdmin) onlyOwner {\n', '    admins[admin] = isAdmin;\n', '  }\n', '\n', '  modifier onlyAdmin {\n', '    if (msg.sender != owner && !admins[msg.sender]) throw;\n', '    _;\n', '  }\n', '\n', '  function() external {\n', '    throw;\n', '  }\n', '\n', '  function depositToken(address token, uint256 amount) {\n', '    tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);\n', '    lastActiveTransaction[msg.sender] = block.number;\n', '    if (!Token(token).transferFrom(msg.sender, this, amount)) throw;\n', '    Deposit(token, msg.sender, amount, tokens[token][msg.sender]);\n', '  }\n', '\n', '  function deposit() payable {\n', '    tokens[address(0)][msg.sender] = safeAdd(tokens[address(0)][msg.sender], msg.value);\n', '    lastActiveTransaction[msg.sender] = block.number;\n', '    Deposit(address(0), msg.sender, msg.value, tokens[address(0)][msg.sender]);\n', '  }\n', '\n', '  function withdraw(address token, uint256 amount) returns (bool success) {\n', '    if (safeSub(block.number, lastActiveTransaction[msg.sender]) < inactivityReleasePeriod) throw;\n', '    if (tokens[token][msg.sender] < amount) throw;\n', '    tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);\n', '    if (token == address(0)) {\n', '      if (!msg.sender.send(amount)) throw;\n', '    } else {\n', '      if (!Token(token).transfer(msg.sender, amount)) throw;\n', '    }\n', '    Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);\n', '  }\n', '\n', '  function adminWithdraw(address token, uint256 amount, address user, uint256 nonce, uint8 v, bytes32 r, bytes32 s, uint256 feeWithdrawal) onlyAdmin returns (bool success) {\n', '    bytes32 hash = keccak256(this, token, amount, user, nonce);\n', '    if (withdrawn[hash]) throw;\n', '    withdrawn[hash] = true;\n', '    if (ecrecover(keccak256("\\x19Ethereum Signed Message:\\n32", hash), v, r, s) != user) throw;\n', '    if (feeWithdrawal > 50 finney) feeWithdrawal = 50 finney;\n', '    if (tokens[token][user] < amount) throw;\n', '    tokens[token][user] = safeSub(tokens[token][user], amount);\n', '    tokens[token][feeAccount] = safeAdd(tokens[token][feeAccount], safeMul(feeWithdrawal, amount) / 1 ether);\n', '    amount = safeMul((1 ether - feeWithdrawal), amount) / 1 ether;\n', '    if (token == address(0)) {\n', '      if (!user.send(amount)) throw;\n', '    } else {\n', '      if (!Token(token).transfer(user, amount)) throw;\n', '    }\n', '    lastActiveTransaction[user] = block.number;\n', '    Withdraw(token, user, amount, tokens[token][user]);\n', '  }\n', '\n', '  function balanceOf(address token, address user) constant returns (uint256) {\n', '    return tokens[token][user];\n', '  }\n', '\n', '  function trade(uint256[8] tradeValues, address[4] tradeAddresses, uint8[2] v, bytes32[4] rs) onlyAdmin returns (bool success) {\n', '    /* amount is in amountBuy terms */\n', '    /* tradeValues\n', '       [0] amountBuy\n', '       [1] amountSell\n', '       [2] expires\n', '       [3] nonce\n', '       [4] amount\n', '       [5] tradeNonce\n', '       [6] feeMake\n', '       [7] feeTake\n', '     tradeAddressses\n', '       [0] tokenBuy\n', '       [1] tokenSell\n', '       [2] maker\n', '       [3] taker\n', '     */\n', '    if (invalidOrder[tradeAddresses[2]] > tradeValues[3]) throw;\n', '    bytes32 orderHash = keccak256(this, tradeAddresses[0], tradeValues[0], tradeAddresses[1], tradeValues[1], tradeValues[2], tradeValues[3], tradeAddresses[2]);\n', '    if (ecrecover(keccak256("\\x19Ethereum Signed Message:\\n32", orderHash), v[0], rs[0], rs[1]) != tradeAddresses[2]) throw;\n', '    bytes32 tradeHash = keccak256(orderHash, tradeValues[4], tradeAddresses[3], tradeValues[5]);\n', '    if (ecrecover(keccak256("\\x19Ethereum Signed Message:\\n32", tradeHash), v[1], rs[2], rs[3]) != tradeAddresses[3]) throw;\n', '    if (traded[tradeHash]) throw;\n', '    traded[tradeHash] = true;\n', '    if (tradeValues[6] > 100 finney) tradeValues[6] = 100 finney;\n', '    if (tradeValues[7] > 100 finney) tradeValues[7] = 100 finney;\n', '    if (safeAdd(orderFills[orderHash], tradeValues[4]) > tradeValues[0]) throw;\n', '    if (tokens[tradeAddresses[0]][tradeAddresses[3]] < tradeValues[4]) throw;\n', '    if (tokens[tradeAddresses[1]][tradeAddresses[2]] < (safeMul(tradeValues[1], tradeValues[4]) / tradeValues[0])) throw;\n', '    tokens[tradeAddresses[0]][tradeAddresses[3]] = safeSub(tokens[tradeAddresses[0]][tradeAddresses[3]], tradeValues[4]);\n', '    tokens[tradeAddresses[0]][tradeAddresses[2]] = safeAdd(tokens[tradeAddresses[0]][tradeAddresses[2]], safeMul(tradeValues[4], ((1 ether) - tradeValues[6])) / (1 ether));\n', '    tokens[tradeAddresses[0]][feeAccount] = safeAdd(tokens[tradeAddresses[0]][feeAccount], safeMul(tradeValues[4], tradeValues[6]) / (1 ether));\n', '    tokens[tradeAddresses[1]][tradeAddresses[2]] = safeSub(tokens[tradeAddresses[1]][tradeAddresses[2]], safeMul(tradeValues[1], tradeValues[4]) / tradeValues[0]);\n', '    tokens[tradeAddresses[1]][tradeAddresses[3]] = safeAdd(tokens[tradeAddresses[1]][tradeAddresses[3]], safeMul(safeMul(((1 ether) - tradeValues[7]), tradeValues[1]), tradeValues[4]) / tradeValues[0] / (1 ether));\n', '    tokens[tradeAddresses[1]][feeAccount] = safeAdd(tokens[tradeAddresses[1]][feeAccount], safeMul(safeMul(tradeValues[7], tradeValues[1]), tradeValues[4]) / tradeValues[0] / (1 ether));\n', '    orderFills[orderHash] = safeAdd(orderFills[orderHash], tradeValues[4]);\n', '    lastActiveTransaction[tradeAddresses[2]] = block.number;\n', '    lastActiveTransaction[tradeAddresses[3]] = block.number;\n', '  }\n', '}']