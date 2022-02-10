['//last compiled with soljson-v0.3.5-2016-07-21-6610add.js\n', '\n', 'contract SafeMath {\n', '  //internals\n', '\n', '  function safeMul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) throw;\n', '  }\n', '}\n', '\n', 'contract Token {\n', '\n', '    /// @return total amount of tokens\n', '    function totalSupply() constant returns (uint256 supply) {}\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {}\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) returns (bool success) {}\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}\n', '\n', '    /// @notice `msg.sender` approves `_addr` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of wei to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) returns (bool success) {}\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '}\n', '\n', 'contract StandardToken is Token {\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', "        //Default assumes totalSupply can't be over max (2^256 - 1).\n", "        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.\n", '        //Replace the if with this one instead.\n', '        if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '        //if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        //same as above. Replace this line with the following if you want to protect against wrapping uints.\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '        //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    uint256 public totalSupply;\n', '\n', '}\n', '\n', 'contract ReserveToken is StandardToken, SafeMath {\n', '    address public minter;\n', '    function ReserveToken() {\n', '      minter = msg.sender;\n', '    }\n', '    function create(address account, uint amount) {\n', '      if (msg.sender != minter) throw;\n', '      balances[account] = safeAdd(balances[account], amount);\n', '      totalSupply = safeAdd(totalSupply, amount);\n', '    }\n', '    function destroy(address account, uint amount) {\n', '      if (msg.sender != minter) throw;\n', '      if (balances[account] < amount) throw;\n', '      balances[account] = safeSub(balances[account], amount);\n', '      totalSupply = safeSub(totalSupply, amount);\n', '    }\n', '}\n', '\n', 'contract YesNo is SafeMath {\n', '\n', '  ReserveToken public yesToken;\n', '  ReserveToken public noToken;\n', '\n', '  //Reality Keys:\n', '  bytes32 public factHash;\n', '  address public ethAddr;\n', '  string public url;\n', '\n', '  uint public outcome;\n', '  bool public resolved = false;\n', '\n', '  address public feeAccount;\n', '  uint public fee; //percentage of 1 ether\n', '\n', '  event Create(address indexed account, uint value);\n', '  event Redeem(address indexed account, uint value, uint yesTokens, uint noTokens);\n', '  event Resolve(bool resolved, uint outcome);\n', '\n', '  function() {\n', '    throw;\n', '  }\n', '\n', '  function YesNo(bytes32 factHash_, address ethAddr_, string url_, address feeAccount_, uint fee_) {\n', '    yesToken = new ReserveToken();\n', '    noToken = new ReserveToken();\n', '    factHash = factHash_;\n', '    ethAddr = ethAddr_;\n', '    url = url_;\n', '    feeAccount = feeAccount_;\n', '    fee = fee_;\n', '  }\n', '\n', '  function create() {\n', '    //send X Ether, get X Yes tokens and X No tokens\n', '    yesToken.create(msg.sender, msg.value);\n', '    noToken.create(msg.sender, msg.value);\n', '    Create(msg.sender, msg.value);\n', '  }\n', '\n', '  function redeem(uint tokens) {\n', '    if (!feeAccount.call.value(safeMul(tokens,fee)/(1 ether))()) throw;\n', '    if (!resolved) {\n', '      yesToken.destroy(msg.sender, tokens);\n', '      noToken.destroy(msg.sender, tokens);\n', '      if (!msg.sender.call.value(safeMul(tokens,(1 ether)-fee)/(1 ether))()) throw;\n', '      Redeem(msg.sender, tokens, tokens, tokens);\n', '    } else if (resolved) {\n', '      if (outcome==0) { //no\n', '        noToken.destroy(msg.sender, tokens);\n', '        if (!msg.sender.call.value(safeMul(tokens,(1 ether)-fee)/(1 ether))()) throw;\n', '        Redeem(msg.sender, tokens, 0, tokens);\n', '      } else if (outcome==1) { //yes\n', '        yesToken.destroy(msg.sender, tokens);\n', '        if (!msg.sender.call.value(safeMul(tokens,(1 ether)-fee)/(1 ether))()) throw;\n', '        Redeem(msg.sender, tokens, tokens, 0);\n', '      }\n', '    }\n', '  }\n', '\n', '  function resolve(uint8 v, bytes32 r, bytes32 s, bytes32 value) {\n', '    if (ecrecover(sha3(factHash, value), v, r, s) != ethAddr) throw;\n', '    if (resolved) throw;\n', '    uint valueInt = uint(value);\n', '    if (valueInt==0 || valueInt==1) {\n', '      outcome = valueInt;\n', '      resolved = true;\n', '      Resolve(resolved, outcome);\n', '    } else {\n', '      throw;\n', '    }\n', '  }\n', '}']