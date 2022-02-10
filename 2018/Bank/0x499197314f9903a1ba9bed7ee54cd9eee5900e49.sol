['pragma solidity ^0.4.24;\n', '\n', 'contract SafeMath {\n', '  function safeMul(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) internal pure returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Token {\n', '  function totalSupply() public returns (uint256);\n', '  function balanceOf(address) public returns (uint256) ;\n', '  function transfer(address, uint256) public returns (bool);\n', '  function transferFrom(address, address, uint256) public returns (bool);\n', '  function approve(address, uint256) public returns (bool);\n', '  function allowance(address, address) public returns (uint256);\n', '\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '  uint public decimals;\n', '  string public name;\n', '}\n', '\n', 'contract StandardToken is Token {\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    //Default assumes totalSupply can&#39;t be over max (2^256 - 1).\n', '    //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn&#39;t wrap.\n', '    //Replace the if with this one instead.\n', '    if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '    //if (balances[msg.sender] >= _value && _value > 0) {\n', '      balances[msg.sender] -= _value;\n', '      balances[_to] += _value;\n', '      emit Transfer(msg.sender, _to, _value);\n', '      return true;\n', '    } else { return false; }\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    //same as above. Replace this line with the following if you want to protect against wrapping uints.\n', '    if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '    //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '      balances[_to] += _value;\n', '      balances[_from] -= _value;\n', '      allowed[_from][msg.sender] -= _value;\n', '      emit Transfer(_from, _to, _value);\n', '      return true;\n', '    } else { return false; }\n', '  }\n', '\n', '  function balanceOf(address _owner) public returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '  uint256 public totalSupply;\n', '}\n', '\n', 'contract ReserveToken is StandardToken, SafeMath {\n', '  address public minter;\n', '  constructor(ReserveToken) public {\n', '    minter = msg.sender;\n', '  }\n', '  function create(address account, uint amount) public {\n', '    if (msg.sender != minter) revert();\n', '    balances[account] = safeAdd(balances[account], amount);\n', '    totalSupply = safeAdd(totalSupply, amount);\n', '  }\n', '  function destroy(address account, uint amount) public {\n', '    if (msg.sender != minter) revert();\n', '    if (balances[account] < amount) revert();\n', '    balances[account] = safeSub(balances[account], amount);\n', '    totalSupply = safeSub(totalSupply, amount);\n', '  }\n', '}\n', '\n', 'contract AccountLevels {\n', '  //given a user, returns an account level\n', '  //0 = regular user (pays take fee and make fee)\n', '  //1 = market maker silver (pays take fee, no make fee, gets rebate)\n', '  //2 = market maker gold (pays take fee, no make fee, gets entire counterparty&#39;s take fee as rebate)\n', '  function accountLevel(address) public returns(uint); \n', '}\n', '\n', 'contract AccountLevelsTest is AccountLevels {\n', '  mapping (address => uint) public accountLevels;\n', '\n', '  function setAccountLevel(address user, uint level) public {\n', '    accountLevels[user] = level;\n', '  }\n', '\n', '  function accountLevel(address user) public returns(uint) {\n', '    return accountLevels[user];\n', '  }\n', '}\n', '\n', 'contract Ethernext is SafeMath {\n', '  address public admin; //the admin address\n', '  address public feeAccount; //the account that will receive fees\n', '  address public accountLevelsAddr; //the address of the AccountLevels contract\n', '  uint public feeMake; //percentage times (1 ether)\n', '  uint public feeTake; //percentage times (1 ether)\n', '  uint public feeRebate; //percentage times (1 ether)\n', '  mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)\n', '  mapping (address => mapping (bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)\n', '  mapping (address => mapping (bytes32 => uint)) public orderFills; //mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)\n', '\n', '  event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);\n', '  event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);\n', '  event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);\n', '  event Deposit(address token, address user, uint amount, uint balance);\n', '  event Withdraw(address token, address user, uint amount, uint balance);\n', '\n', '  constructor(address admin_, address feeAccount_, address accountLevelsAddr_, uint feeMake_, uint feeTake_, uint feeRebate_) public {\n', '    admin = admin_;\n', '    feeAccount = feeAccount_;\n', '    accountLevelsAddr = accountLevelsAddr_;\n', '    feeMake = feeMake_;\n', '    feeTake = feeTake_;\n', '    feeRebate = feeRebate_;\n', '  }\n', '\n', '  function() public {\n', '    revert();\n', '  }\n', '\n', '  function changeAdmin(address admin_) public {\n', '    if (msg.sender != admin) revert();\n', '    admin = admin_;\n', '  }\n', '\n', '  function changeAccountLevelsAddr(address accountLevelsAddr_) public {\n', '    if (msg.sender != admin) revert();\n', '    accountLevelsAddr = accountLevelsAddr_;\n', '  }\n', '\n', '  function changeFeeAccount(address feeAccount_) public {\n', '    if (msg.sender != admin) revert();\n', '    feeAccount = feeAccount_;\n', '  }\n', '\n', '  function changeFeeMake(uint feeMake_) public {\n', '    if (msg.sender != admin) revert();\n', '    if (feeMake_ > feeMake) revert();\n', '    feeMake = feeMake_;\n', '  }\n', '\n', '  function changeFeeTake(uint feeTake_) public {\n', '    if (msg.sender != admin) revert();\n', '    if (feeTake_ > feeTake || feeTake_ < feeRebate) revert();\n', '    feeTake = feeTake_;\n', '  }\n', '\n', '  function changeFeeRebate(uint feeRebate_) public {\n', '    if (msg.sender != admin) revert();\n', '    if (feeRebate_ < feeRebate || feeRebate_ > feeTake) revert();\n', '    feeRebate = feeRebate_;\n', '  }\n', '\n', '  function deposit() payable public {\n', '    tokens[0][msg.sender] = safeAdd(tokens[0][msg.sender], msg.value);\n', '    emit Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);\n', '  }\n', '\n', '  function withdraw(uint amount) public{\n', '    if (tokens[0][msg.sender] < amount) revert();\n', '    tokens[0][msg.sender] = safeSub(tokens[0][msg.sender], amount);\n', '    if (!msg.sender.send(amount)) revert();\n', '    emit Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);\n', '  }\n', '\n', '  function depositToken(address token, uint amount) public {\n', '    //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.\n', '    if (token==0) revert();\n', '    if (!Token(token).transferFrom(msg.sender, this, amount)) revert();\n', '    tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);\n', '    emit Deposit(token, msg.sender, amount, tokens[token][msg.sender]);\n', '  }\n', '\n', '  function withdrawToken(address token, uint amount) public {\n', '    if (token==0) revert();\n', '    if (tokens[token][msg.sender] < amount) revert();\n', '    tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);\n', '    if (!Token(token).transfer(msg.sender, amount)) revert();\n', '    emit Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);\n', '  }\n', '\n', '  function balanceOf(address token, address user) public constant returns (uint) {\n', '    return tokens[token][user];\n', '  }\n', '\n', '  function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) public {\n', '    bytes32 hash = sha256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));\n', '    orders[msg.sender][hash] = true;\n', '    emit Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender);\n', '  }\n', '\n', '  function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) public {\n', '    //amount is in amountGet terms\n', '    bytes32 hash = sha256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));\n', '    if (!(\n', '      (orders[user][hash] || ecrecover(keccak256(abi.encodePacked("\\x19Ethereum Signed Message:\\n32", hash)),v,r,s) == user) &&\n', '      block.number <= expires &&\n', '      safeAdd(orderFills[user][hash], amount) <= amountGet\n', '    )) revert();\n', '    tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);\n', '    orderFills[user][hash] = safeAdd(orderFills[user][hash], amount);\n', '    emit Trade(tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, msg.sender);\n', '  }\n', '\n', '  function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private {\n', '    uint feeMakeXfer = safeMul(amount, feeMake) / (1 ether);\n', '    uint feeTakeXfer = safeMul(amount, feeTake) / (1 ether);\n', '    uint feeRebateXfer = 0;\n', '    if (accountLevelsAddr != 0x0) {\n', '      uint accountLevel = AccountLevels(accountLevelsAddr).accountLevel(user);\n', '      if (accountLevel==1) feeRebateXfer = safeMul(amount, feeRebate) / (1 ether);\n', '      if (accountLevel==2) feeRebateXfer = feeTakeXfer;\n', '    }\n', '    tokens[tokenGet][msg.sender] = safeSub(tokens[tokenGet][msg.sender], safeAdd(amount, feeTakeXfer));\n', '    tokens[tokenGet][user] = safeAdd(tokens[tokenGet][user], safeSub(safeAdd(amount, feeRebateXfer), feeMakeXfer));\n', '    tokens[tokenGet][feeAccount] = safeAdd(tokens[tokenGet][feeAccount], safeSub(safeAdd(feeMakeXfer, feeTakeXfer), feeRebateXfer));\n', '    tokens[tokenGive][user] = safeSub(tokens[tokenGive][user], safeMul(amountGive, amount) / amountGet);\n', '    tokens[tokenGive][msg.sender] = safeAdd(tokens[tokenGive][msg.sender], safeMul(amountGive, amount) / amountGet);\n', '  }\n', '\n', '  function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) public constant returns(bool) {\n', '    if (!(\n', '      tokens[tokenGet][sender] >= amount &&\n', '      availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount\n', '    )) return false;\n', '    return true;\n', '  }\n', '\n', '  function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) public constant returns(uint) {\n', '    bytes32 hash = sha256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));\n', '    if (!(\n', '      (orders[user][hash] || ecrecover(keccak256(abi.encodePacked("\\x19Ethereum Signed Message:\\n32", hash)),v,r,s) == user) &&\n', '      block.number <= expires\n', '    )) return 0;\n', '    uint available1 = safeSub(amountGet, orderFills[user][hash]);\n', '    uint available2 = safeMul(tokens[tokenGive][user], amountGet) / amountGive;\n', '    if (available1<available2) return available1;\n', '    return available2;\n', '  }\n', '\n', '  function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8, bytes32, bytes32) public constant returns(uint) {\n', '    bytes32 hash = sha256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));\n', '    return orderFills[user][hash];\n', '  }\n', '\n', '  function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) public {\n', '    bytes32 hash = sha256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));\n', '    if (!(orders[msg.sender][hash] || ecrecover(keccak256(abi.encodePacked("\\x19Ethereum Signed Message:\\n32", hash)),v,r,s) == msg.sender)) revert();\n', '    orderFills[msg.sender][hash] = amountGet;\n', '    emit Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);\n', '  }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', 'contract SafeMath {\n', '  function safeMul(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) internal pure returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Token {\n', '  function totalSupply() public returns (uint256);\n', '  function balanceOf(address) public returns (uint256) ;\n', '  function transfer(address, uint256) public returns (bool);\n', '  function transferFrom(address, address, uint256) public returns (bool);\n', '  function approve(address, uint256) public returns (bool);\n', '  function allowance(address, address) public returns (uint256);\n', '\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '  uint public decimals;\n', '  string public name;\n', '}\n', '\n', 'contract StandardToken is Token {\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', "    //Default assumes totalSupply can't be over max (2^256 - 1).\n", "    //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.\n", '    //Replace the if with this one instead.\n', '    if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '    //if (balances[msg.sender] >= _value && _value > 0) {\n', '      balances[msg.sender] -= _value;\n', '      balances[_to] += _value;\n', '      emit Transfer(msg.sender, _to, _value);\n', '      return true;\n', '    } else { return false; }\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    //same as above. Replace this line with the following if you want to protect against wrapping uints.\n', '    if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '    //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '      balances[_to] += _value;\n', '      balances[_from] -= _value;\n', '      allowed[_from][msg.sender] -= _value;\n', '      emit Transfer(_from, _to, _value);\n', '      return true;\n', '    } else { return false; }\n', '  }\n', '\n', '  function balanceOf(address _owner) public returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '  uint256 public totalSupply;\n', '}\n', '\n', 'contract ReserveToken is StandardToken, SafeMath {\n', '  address public minter;\n', '  constructor(ReserveToken) public {\n', '    minter = msg.sender;\n', '  }\n', '  function create(address account, uint amount) public {\n', '    if (msg.sender != minter) revert();\n', '    balances[account] = safeAdd(balances[account], amount);\n', '    totalSupply = safeAdd(totalSupply, amount);\n', '  }\n', '  function destroy(address account, uint amount) public {\n', '    if (msg.sender != minter) revert();\n', '    if (balances[account] < amount) revert();\n', '    balances[account] = safeSub(balances[account], amount);\n', '    totalSupply = safeSub(totalSupply, amount);\n', '  }\n', '}\n', '\n', 'contract AccountLevels {\n', '  //given a user, returns an account level\n', '  //0 = regular user (pays take fee and make fee)\n', '  //1 = market maker silver (pays take fee, no make fee, gets rebate)\n', "  //2 = market maker gold (pays take fee, no make fee, gets entire counterparty's take fee as rebate)\n", '  function accountLevel(address) public returns(uint); \n', '}\n', '\n', 'contract AccountLevelsTest is AccountLevels {\n', '  mapping (address => uint) public accountLevels;\n', '\n', '  function setAccountLevel(address user, uint level) public {\n', '    accountLevels[user] = level;\n', '  }\n', '\n', '  function accountLevel(address user) public returns(uint) {\n', '    return accountLevels[user];\n', '  }\n', '}\n', '\n', 'contract Ethernext is SafeMath {\n', '  address public admin; //the admin address\n', '  address public feeAccount; //the account that will receive fees\n', '  address public accountLevelsAddr; //the address of the AccountLevels contract\n', '  uint public feeMake; //percentage times (1 ether)\n', '  uint public feeTake; //percentage times (1 ether)\n', '  uint public feeRebate; //percentage times (1 ether)\n', '  mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)\n', '  mapping (address => mapping (bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)\n', '  mapping (address => mapping (bytes32 => uint)) public orderFills; //mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)\n', '\n', '  event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);\n', '  event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);\n', '  event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);\n', '  event Deposit(address token, address user, uint amount, uint balance);\n', '  event Withdraw(address token, address user, uint amount, uint balance);\n', '\n', '  constructor(address admin_, address feeAccount_, address accountLevelsAddr_, uint feeMake_, uint feeTake_, uint feeRebate_) public {\n', '    admin = admin_;\n', '    feeAccount = feeAccount_;\n', '    accountLevelsAddr = accountLevelsAddr_;\n', '    feeMake = feeMake_;\n', '    feeTake = feeTake_;\n', '    feeRebate = feeRebate_;\n', '  }\n', '\n', '  function() public {\n', '    revert();\n', '  }\n', '\n', '  function changeAdmin(address admin_) public {\n', '    if (msg.sender != admin) revert();\n', '    admin = admin_;\n', '  }\n', '\n', '  function changeAccountLevelsAddr(address accountLevelsAddr_) public {\n', '    if (msg.sender != admin) revert();\n', '    accountLevelsAddr = accountLevelsAddr_;\n', '  }\n', '\n', '  function changeFeeAccount(address feeAccount_) public {\n', '    if (msg.sender != admin) revert();\n', '    feeAccount = feeAccount_;\n', '  }\n', '\n', '  function changeFeeMake(uint feeMake_) public {\n', '    if (msg.sender != admin) revert();\n', '    if (feeMake_ > feeMake) revert();\n', '    feeMake = feeMake_;\n', '  }\n', '\n', '  function changeFeeTake(uint feeTake_) public {\n', '    if (msg.sender != admin) revert();\n', '    if (feeTake_ > feeTake || feeTake_ < feeRebate) revert();\n', '    feeTake = feeTake_;\n', '  }\n', '\n', '  function changeFeeRebate(uint feeRebate_) public {\n', '    if (msg.sender != admin) revert();\n', '    if (feeRebate_ < feeRebate || feeRebate_ > feeTake) revert();\n', '    feeRebate = feeRebate_;\n', '  }\n', '\n', '  function deposit() payable public {\n', '    tokens[0][msg.sender] = safeAdd(tokens[0][msg.sender], msg.value);\n', '    emit Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);\n', '  }\n', '\n', '  function withdraw(uint amount) public{\n', '    if (tokens[0][msg.sender] < amount) revert();\n', '    tokens[0][msg.sender] = safeSub(tokens[0][msg.sender], amount);\n', '    if (!msg.sender.send(amount)) revert();\n', '    emit Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);\n', '  }\n', '\n', '  function depositToken(address token, uint amount) public {\n', '    //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.\n', '    if (token==0) revert();\n', '    if (!Token(token).transferFrom(msg.sender, this, amount)) revert();\n', '    tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);\n', '    emit Deposit(token, msg.sender, amount, tokens[token][msg.sender]);\n', '  }\n', '\n', '  function withdrawToken(address token, uint amount) public {\n', '    if (token==0) revert();\n', '    if (tokens[token][msg.sender] < amount) revert();\n', '    tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);\n', '    if (!Token(token).transfer(msg.sender, amount)) revert();\n', '    emit Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);\n', '  }\n', '\n', '  function balanceOf(address token, address user) public constant returns (uint) {\n', '    return tokens[token][user];\n', '  }\n', '\n', '  function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) public {\n', '    bytes32 hash = sha256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));\n', '    orders[msg.sender][hash] = true;\n', '    emit Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender);\n', '  }\n', '\n', '  function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) public {\n', '    //amount is in amountGet terms\n', '    bytes32 hash = sha256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));\n', '    if (!(\n', '      (orders[user][hash] || ecrecover(keccak256(abi.encodePacked("\\x19Ethereum Signed Message:\\n32", hash)),v,r,s) == user) &&\n', '      block.number <= expires &&\n', '      safeAdd(orderFills[user][hash], amount) <= amountGet\n', '    )) revert();\n', '    tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);\n', '    orderFills[user][hash] = safeAdd(orderFills[user][hash], amount);\n', '    emit Trade(tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, msg.sender);\n', '  }\n', '\n', '  function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private {\n', '    uint feeMakeXfer = safeMul(amount, feeMake) / (1 ether);\n', '    uint feeTakeXfer = safeMul(amount, feeTake) / (1 ether);\n', '    uint feeRebateXfer = 0;\n', '    if (accountLevelsAddr != 0x0) {\n', '      uint accountLevel = AccountLevels(accountLevelsAddr).accountLevel(user);\n', '      if (accountLevel==1) feeRebateXfer = safeMul(amount, feeRebate) / (1 ether);\n', '      if (accountLevel==2) feeRebateXfer = feeTakeXfer;\n', '    }\n', '    tokens[tokenGet][msg.sender] = safeSub(tokens[tokenGet][msg.sender], safeAdd(amount, feeTakeXfer));\n', '    tokens[tokenGet][user] = safeAdd(tokens[tokenGet][user], safeSub(safeAdd(amount, feeRebateXfer), feeMakeXfer));\n', '    tokens[tokenGet][feeAccount] = safeAdd(tokens[tokenGet][feeAccount], safeSub(safeAdd(feeMakeXfer, feeTakeXfer), feeRebateXfer));\n', '    tokens[tokenGive][user] = safeSub(tokens[tokenGive][user], safeMul(amountGive, amount) / amountGet);\n', '    tokens[tokenGive][msg.sender] = safeAdd(tokens[tokenGive][msg.sender], safeMul(amountGive, amount) / amountGet);\n', '  }\n', '\n', '  function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) public constant returns(bool) {\n', '    if (!(\n', '      tokens[tokenGet][sender] >= amount &&\n', '      availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount\n', '    )) return false;\n', '    return true;\n', '  }\n', '\n', '  function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) public constant returns(uint) {\n', '    bytes32 hash = sha256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));\n', '    if (!(\n', '      (orders[user][hash] || ecrecover(keccak256(abi.encodePacked("\\x19Ethereum Signed Message:\\n32", hash)),v,r,s) == user) &&\n', '      block.number <= expires\n', '    )) return 0;\n', '    uint available1 = safeSub(amountGet, orderFills[user][hash]);\n', '    uint available2 = safeMul(tokens[tokenGive][user], amountGet) / amountGive;\n', '    if (available1<available2) return available1;\n', '    return available2;\n', '  }\n', '\n', '  function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8, bytes32, bytes32) public constant returns(uint) {\n', '    bytes32 hash = sha256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));\n', '    return orderFills[user][hash];\n', '  }\n', '\n', '  function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) public {\n', '    bytes32 hash = sha256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));\n', '    if (!(orders[msg.sender][hash] || ecrecover(keccak256(abi.encodePacked("\\x19Ethereum Signed Message:\\n32", hash)),v,r,s) == msg.sender)) revert();\n', '    orderFills[msg.sender][hash] = amountGet;\n', '    emit Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);\n', '  }\n', '}']
