['pragma solidity ^0.4.9;\n', '\n', 'contract SafeMath {\n', '  function safeMul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) throw;\n', '  }\n', '}\n', '\n', 'contract Token {\n', '  /// @return total amount of tokens\n', '  function totalSupply() constant returns (uint256 supply) {}\n', '\n', '  /// @param _owner The address from which the balance will be retrieved\n', '  /// @return The balance\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {}\n', '\n', '  /// @notice send `_value` token to `_to` from `msg.sender`\n', '  /// @param _to The address of the recipient\n', '  /// @param _value The amount of token to be transferred\n', '  /// @return Whether the transfer was successful or not\n', '  function transfer(address _to, uint256 _value) returns (bool success) {}\n', '\n', '  /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '  /// @param _from The address of the sender\n', '  /// @param _to The address of the recipient\n', '  /// @param _value The amount of token to be transferred\n', '  /// @return Whether the transfer was successful or not\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}\n', '\n', '  /// @notice `msg.sender` approves `_addr` to spend `_value` tokens\n', '  /// @param _spender The address of the account able to transfer the tokens\n', '  /// @param _value The amount of wei to be approved for transfer\n', '  /// @return Whether the approval was successful or not\n', '  function approve(address _spender, uint256 _value) returns (bool success) {}\n', '\n', '  /// @param _owner The address of the account owning tokens\n', '  /// @param _spender The address of the account able to transfer the tokens\n', '  /// @return Amount of remaining tokens allowed to spent\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}\n', '\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '  uint public decimals;\n', '  string public name;\n', '}\n', '\n', 'contract StandardToken is Token {\n', '\n', '  function transfer(address _to, uint256 _value) returns (bool success) {\n', '    //Default assumes totalSupply can&#39;t be over max (2^256 - 1).\n', '    //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn&#39;t wrap.\n', '    //Replace the if with this one instead.\n', '    if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '    //if (balances[msg.sender] >= _value && _value > 0) {\n', '      balances[msg.sender] -= _value;\n', '      balances[_to] += _value;\n', '      Transfer(msg.sender, _to, _value);\n', '      return true;\n', '    } else { return false; }\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '    //same as above. Replace this line with the following if you want to protect against wrapping uints.\n', '    if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '    //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '      balances[_to] += _value;\n', '      balances[_from] -= _value;\n', '      allowed[_from][msg.sender] -= _value;\n', '      Transfer(_from, _to, _value);\n', '      return true;\n', '    } else { return false; }\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) returns (bool success) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '  uint256 public totalSupply;\n', '}\n', '\n', 'contract ReserveToken is StandardToken, SafeMath {\n', '  address public minter;\n', '  function ReserveToken() {\n', '    minter = msg.sender;\n', '  }\n', '  function create(address account, uint amount) {\n', '    if (msg.sender != minter) throw;\n', '    balances[account] = safeAdd(balances[account], amount);\n', '    totalSupply = safeAdd(totalSupply, amount);\n', '  }\n', '  function destroy(address account, uint amount) {\n', '    if (msg.sender != minter) throw;\n', '    if (balances[account] < amount) throw;\n', '    balances[account] = safeSub(balances[account], amount);\n', '    totalSupply = safeSub(totalSupply, amount);\n', '  }\n', '}\n', '\n', '\n', '\n', '\n', 'contract MicroDex is SafeMath {\n', '\n', '  bool locked;\n', '  //check account balances for this token; we do not use ether\n', '\n', '\n', '  mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)\n', '  mapping (address => mapping (bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)\n', '  mapping (address => mapping (bytes32 => uint)) public orderFills; //mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)\n', '\n', '  event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);\n', '  event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);\n', '  event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);\n', '  event Deposit(address token, address user, uint amount, uint balance);\n', '  event Withdraw(address token, address user, uint amount, uint balance);\n', '\n', '  function MicroDex( ) {\n', '\n', '    if(locked)revert();\n', '    locked = true;\n', '  }\n', '\n', '  function() {\n', '    throw;\n', '  }\n', '\n', '\n', '\n', '\n', '   /**\n', '  * This function handles deposits of Ether into the contract.\n', '  * Emits a Deposit event.\n', '  * Note: With the payable modifier, this function accepts Ether.\n', '  */\n', '  function deposit() public payable {\n', '    tokens[0][msg.sender] = safeAdd(tokens[0][msg.sender],msg.value);\n', '    Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);\n', '  }\n', '\n', '  /**\n', '  * This function handles withdrawals of Ether from the contract.\n', '  * Verifies that the user has enough funds to cover the withdrawal.\n', '  * Emits a Withdraw event.\n', '  * @param amount uint of the amount of Ether the user wishes to withdraw\n', '  */\n', '  function withdraw(uint amount) public {\n', '    require(tokens[0][msg.sender] >= amount);\n', '    tokens[0][msg.sender] = safeSub(tokens[0][msg.sender],amount);\n', '    msg.sender.transfer(amount);\n', '    Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);\n', '  }\n', '\n', '\n', '\n', '  //call this using ApproveAndCall\n', '  //allows for interacting with ether directly as token[0]\n', '  function depositToken(address from, address token, uint amount) {\n', '    //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.\n', '    if (token==0) throw;\n', '    if (!Token(token).transferFrom(from, this, amount)) throw;\n', '    tokens[token][from] = safeAdd(tokens[token][from], amount);\n', '    Deposit(token, from, amount, tokens[token][from]);\n', '  }\n', '\n', '  function withdrawToken(address token, uint amount) {\n', '    if (token==0) throw;\n', '    if (tokens[token][msg.sender] < amount) throw;\n', '    tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);\n', '    if (!Token(token).transfer(msg.sender, amount)) throw;\n', '    Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);\n', '  }\n', '\n', '  function balanceOf(address token, address user) constant returns (uint) {\n', '    return tokens[token][user];\n', '  }\n', '\n', '  function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) {\n', '    bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);\n', '    orders[msg.sender][hash] = true;\n', '    Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender);\n', '  }\n', '\n', '  function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) {\n', '    //amount is in amountGet terms\n', '    bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);\n', '    if (!(\n', '      (orders[user][hash] || ecrecover(sha3("\\x19Ethereum Signed Message:\\n32", hash),v,r,s) == user) &&\n', '      block.number <= expires &&\n', '      safeAdd(orderFills[user][hash], amount) <= amountGet\n', '    )) throw;\n', '    tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);\n', '    orderFills[user][hash] = safeAdd(orderFills[user][hash], amount);\n', '    Trade(tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, msg.sender);\n', '  }\n', '\n', '  function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private {\n', '  //  uint feeMakeXfer = safeMul(amount, feeMake) / (1 ether);\n', '  //  uint feeTakeXfer = safeMul(amount, feeTake) / (1 ether);\n', '  //  uint feeRebateXfer = 0;\n', '  //  if (accountLevelsAddr != 0x0) {\n', '  //    uint accountLevel = AccountLevels(accountLevelsAddr).accountLevel(user);\n', '  //    if (accountLevel==1) feeRebateXfer = safeMul(amount, feeRebate) / (1 ether);\n', '  //    if (accountLevel==2) feeRebateXfer = feeTakeXfer;\n', '  //  }\n', '    tokens[tokenGet][msg.sender] = safeSub(tokens[tokenGet][msg.sender], amount);\n', '    tokens[tokenGet][user] = safeAdd(tokens[tokenGet][user], amount);\n', '  //  tokens[tokenGet][feeAccount] = safeAdd(tokens[tokenGet][feeAccount], safeSub(safeAdd(feeMakeXfer, feeTakeXfer), feeRebateXfer));\n', '    tokens[tokenGive][user] = safeSub(tokens[tokenGive][user], safeMul(amountGive, amount) / amountGet);\n', '    tokens[tokenGive][msg.sender] = safeAdd(tokens[tokenGive][msg.sender], safeMul(amountGive, amount) / amountGet);\n', '  }\n', '\n', '  function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) constant returns(bool) {\n', '    if (!(\n', '      tokens[tokenGet][sender] >= amount &&\n', '      availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount\n', '    )) return false;\n', '    return true;\n', '  }\n', '\n', '  function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {\n', '    bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);\n', '    if (!(\n', '      (orders[user][hash] || ecrecover(sha3("\\x19Ethereum Signed Message:\\n32", hash),v,r,s) == user) &&\n', '      block.number <= expires\n', '    )) return 0;\n', '    uint available1 = safeSub(amountGet, orderFills[user][hash]);\n', '    uint available2 = safeMul(tokens[tokenGive][user], amountGet) / amountGive;\n', '    if (available1<available2) return available1;\n', '    return available2;\n', '  }\n', '\n', '  function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {\n', '    bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);\n', '    return orderFills[user][hash];\n', '  }\n', '\n', '  function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) {\n', '    bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);\n', '    if (!(orders[msg.sender][hash] || ecrecover(sha3("\\x19Ethereum Signed Message:\\n32", hash),v,r,s) == msg.sender)) throw;\n', '    orderFills[msg.sender][hash] = amountGet;\n', '    Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);\n', '  }\n', '\n', '\n', '\n', '  /*\n', '    Receive approval to spend tokens and perform any action all in one transaction\n', '  */\n', '  function receiveApproval(address from, uint256 tokens, address token, bytes data) public returns (bool) {\n', '\n', '    //parse the data:   first byte is for &#39;action_id&#39;\n', '    byte action_id = data[0];\n', '\n', '    if(action_id == 0x1)\n', '    {\n', '      depositToken(from, token, tokens );\n', '      return true;\n', '    }\n', '\n', '    return false;\n', '\n', '  }\n', '\n', '}']
['pragma solidity ^0.4.9;\n', '\n', 'contract SafeMath {\n', '  function safeMul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) throw;\n', '  }\n', '}\n', '\n', 'contract Token {\n', '  /// @return total amount of tokens\n', '  function totalSupply() constant returns (uint256 supply) {}\n', '\n', '  /// @param _owner The address from which the balance will be retrieved\n', '  /// @return The balance\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {}\n', '\n', '  /// @notice send `_value` token to `_to` from `msg.sender`\n', '  /// @param _to The address of the recipient\n', '  /// @param _value The amount of token to be transferred\n', '  /// @return Whether the transfer was successful or not\n', '  function transfer(address _to, uint256 _value) returns (bool success) {}\n', '\n', '  /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '  /// @param _from The address of the sender\n', '  /// @param _to The address of the recipient\n', '  /// @param _value The amount of token to be transferred\n', '  /// @return Whether the transfer was successful or not\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}\n', '\n', '  /// @notice `msg.sender` approves `_addr` to spend `_value` tokens\n', '  /// @param _spender The address of the account able to transfer the tokens\n', '  /// @param _value The amount of wei to be approved for transfer\n', '  /// @return Whether the approval was successful or not\n', '  function approve(address _spender, uint256 _value) returns (bool success) {}\n', '\n', '  /// @param _owner The address of the account owning tokens\n', '  /// @param _spender The address of the account able to transfer the tokens\n', '  /// @return Amount of remaining tokens allowed to spent\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}\n', '\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '  uint public decimals;\n', '  string public name;\n', '}\n', '\n', 'contract StandardToken is Token {\n', '\n', '  function transfer(address _to, uint256 _value) returns (bool success) {\n', "    //Default assumes totalSupply can't be over max (2^256 - 1).\n", "    //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.\n", '    //Replace the if with this one instead.\n', '    if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '    //if (balances[msg.sender] >= _value && _value > 0) {\n', '      balances[msg.sender] -= _value;\n', '      balances[_to] += _value;\n', '      Transfer(msg.sender, _to, _value);\n', '      return true;\n', '    } else { return false; }\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '    //same as above. Replace this line with the following if you want to protect against wrapping uints.\n', '    if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '    //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '      balances[_to] += _value;\n', '      balances[_from] -= _value;\n', '      allowed[_from][msg.sender] -= _value;\n', '      Transfer(_from, _to, _value);\n', '      return true;\n', '    } else { return false; }\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) returns (bool success) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '  uint256 public totalSupply;\n', '}\n', '\n', 'contract ReserveToken is StandardToken, SafeMath {\n', '  address public minter;\n', '  function ReserveToken() {\n', '    minter = msg.sender;\n', '  }\n', '  function create(address account, uint amount) {\n', '    if (msg.sender != minter) throw;\n', '    balances[account] = safeAdd(balances[account], amount);\n', '    totalSupply = safeAdd(totalSupply, amount);\n', '  }\n', '  function destroy(address account, uint amount) {\n', '    if (msg.sender != minter) throw;\n', '    if (balances[account] < amount) throw;\n', '    balances[account] = safeSub(balances[account], amount);\n', '    totalSupply = safeSub(totalSupply, amount);\n', '  }\n', '}\n', '\n', '\n', '\n', '\n', 'contract MicroDex is SafeMath {\n', '\n', '  bool locked;\n', '  //check account balances for this token; we do not use ether\n', '\n', '\n', '  mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)\n', '  mapping (address => mapping (bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)\n', '  mapping (address => mapping (bytes32 => uint)) public orderFills; //mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)\n', '\n', '  event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);\n', '  event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);\n', '  event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);\n', '  event Deposit(address token, address user, uint amount, uint balance);\n', '  event Withdraw(address token, address user, uint amount, uint balance);\n', '\n', '  function MicroDex( ) {\n', '\n', '    if(locked)revert();\n', '    locked = true;\n', '  }\n', '\n', '  function() {\n', '    throw;\n', '  }\n', '\n', '\n', '\n', '\n', '   /**\n', '  * This function handles deposits of Ether into the contract.\n', '  * Emits a Deposit event.\n', '  * Note: With the payable modifier, this function accepts Ether.\n', '  */\n', '  function deposit() public payable {\n', '    tokens[0][msg.sender] = safeAdd(tokens[0][msg.sender],msg.value);\n', '    Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);\n', '  }\n', '\n', '  /**\n', '  * This function handles withdrawals of Ether from the contract.\n', '  * Verifies that the user has enough funds to cover the withdrawal.\n', '  * Emits a Withdraw event.\n', '  * @param amount uint of the amount of Ether the user wishes to withdraw\n', '  */\n', '  function withdraw(uint amount) public {\n', '    require(tokens[0][msg.sender] >= amount);\n', '    tokens[0][msg.sender] = safeSub(tokens[0][msg.sender],amount);\n', '    msg.sender.transfer(amount);\n', '    Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);\n', '  }\n', '\n', '\n', '\n', '  //call this using ApproveAndCall\n', '  //allows for interacting with ether directly as token[0]\n', '  function depositToken(address from, address token, uint amount) {\n', '    //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.\n', '    if (token==0) throw;\n', '    if (!Token(token).transferFrom(from, this, amount)) throw;\n', '    tokens[token][from] = safeAdd(tokens[token][from], amount);\n', '    Deposit(token, from, amount, tokens[token][from]);\n', '  }\n', '\n', '  function withdrawToken(address token, uint amount) {\n', '    if (token==0) throw;\n', '    if (tokens[token][msg.sender] < amount) throw;\n', '    tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);\n', '    if (!Token(token).transfer(msg.sender, amount)) throw;\n', '    Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);\n', '  }\n', '\n', '  function balanceOf(address token, address user) constant returns (uint) {\n', '    return tokens[token][user];\n', '  }\n', '\n', '  function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) {\n', '    bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);\n', '    orders[msg.sender][hash] = true;\n', '    Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender);\n', '  }\n', '\n', '  function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) {\n', '    //amount is in amountGet terms\n', '    bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);\n', '    if (!(\n', '      (orders[user][hash] || ecrecover(sha3("\\x19Ethereum Signed Message:\\n32", hash),v,r,s) == user) &&\n', '      block.number <= expires &&\n', '      safeAdd(orderFills[user][hash], amount) <= amountGet\n', '    )) throw;\n', '    tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);\n', '    orderFills[user][hash] = safeAdd(orderFills[user][hash], amount);\n', '    Trade(tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, msg.sender);\n', '  }\n', '\n', '  function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private {\n', '  //  uint feeMakeXfer = safeMul(amount, feeMake) / (1 ether);\n', '  //  uint feeTakeXfer = safeMul(amount, feeTake) / (1 ether);\n', '  //  uint feeRebateXfer = 0;\n', '  //  if (accountLevelsAddr != 0x0) {\n', '  //    uint accountLevel = AccountLevels(accountLevelsAddr).accountLevel(user);\n', '  //    if (accountLevel==1) feeRebateXfer = safeMul(amount, feeRebate) / (1 ether);\n', '  //    if (accountLevel==2) feeRebateXfer = feeTakeXfer;\n', '  //  }\n', '    tokens[tokenGet][msg.sender] = safeSub(tokens[tokenGet][msg.sender], amount);\n', '    tokens[tokenGet][user] = safeAdd(tokens[tokenGet][user], amount);\n', '  //  tokens[tokenGet][feeAccount] = safeAdd(tokens[tokenGet][feeAccount], safeSub(safeAdd(feeMakeXfer, feeTakeXfer), feeRebateXfer));\n', '    tokens[tokenGive][user] = safeSub(tokens[tokenGive][user], safeMul(amountGive, amount) / amountGet);\n', '    tokens[tokenGive][msg.sender] = safeAdd(tokens[tokenGive][msg.sender], safeMul(amountGive, amount) / amountGet);\n', '  }\n', '\n', '  function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) constant returns(bool) {\n', '    if (!(\n', '      tokens[tokenGet][sender] >= amount &&\n', '      availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount\n', '    )) return false;\n', '    return true;\n', '  }\n', '\n', '  function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {\n', '    bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);\n', '    if (!(\n', '      (orders[user][hash] || ecrecover(sha3("\\x19Ethereum Signed Message:\\n32", hash),v,r,s) == user) &&\n', '      block.number <= expires\n', '    )) return 0;\n', '    uint available1 = safeSub(amountGet, orderFills[user][hash]);\n', '    uint available2 = safeMul(tokens[tokenGive][user], amountGet) / amountGive;\n', '    if (available1<available2) return available1;\n', '    return available2;\n', '  }\n', '\n', '  function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {\n', '    bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);\n', '    return orderFills[user][hash];\n', '  }\n', '\n', '  function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) {\n', '    bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);\n', '    if (!(orders[msg.sender][hash] || ecrecover(sha3("\\x19Ethereum Signed Message:\\n32", hash),v,r,s) == msg.sender)) throw;\n', '    orderFills[msg.sender][hash] = amountGet;\n', '    Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);\n', '  }\n', '\n', '\n', '\n', '  /*\n', '    Receive approval to spend tokens and perform any action all in one transaction\n', '  */\n', '  function receiveApproval(address from, uint256 tokens, address token, bytes data) public returns (bool) {\n', '\n', "    //parse the data:   first byte is for 'action_id'\n", '    byte action_id = data[0];\n', '\n', '    if(action_id == 0x1)\n', '    {\n', '      depositToken(from, token, tokens );\n', '      return true;\n', '    }\n', '\n', '    return false;\n', '\n', '  }\n', '\n', '}']
