['pragma solidity ^0.4.24;\n', '\n', '// ----------------------------------------------------------------------------\n', '// &#39;Boss.exchange&#39; DEX contract\n', '//\n', '// Admin       : 0x10e7FC79D42a373E02AEBaa598DB07e34833a11a\n', '// fees        : zero (0)\n', '//\n', '//\n', '// Copyright (c) Boss.Exchange. The MIT Licence.\n', '// Contract crafted by: Boss Team\n', '// ----------------------------------------------------------------------------\n', '\n', 'interface transferToken {\n', '    function transfer(address receiver, uint amount) external;\n', '}\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '    /// Total amount of tokens\n', '  uint256 public totalSupply;\n', '  \n', '  function balanceOf(address _owner) public view returns (uint256 balance);\n', '  \n', '  function transfer(address _to, uint256 _amount) public returns (bool success);\n', '  \n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '  \n', '  function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);\n', '  \n', '  function approve(address _spender, uint256 _amount) public returns (bool success);\n', '  \n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  //balance in each address account\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _amount The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _amount) public returns (bool success) {\n', '    require(_to != address(0));\n', '    require(balances[msg.sender] >= _amount && _amount > 0\n', '        && balances[_to].add(_amount) > balances[_to]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    emit Transfer(msg.sender, _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '  \n', '  \n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _amount uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {\n', '    require(_to != address(0));\n', '    require(balances[_from] >= _amount);\n', '    require(allowed[_from][msg.sender] >= _amount);\n', '    require(_amount > 0 && balances[_to].add(_amount) > balances[_to]);\n', '\n', '    balances[_from] = balances[_from].sub(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);\n', '    emit Transfer(_from, _to, _amount);\n', '    return true;\n', '  }\n', '\t\n', '\tfunction transfer(address _to, uint256 _amount) public returns (bool success) {\n', '    require(_to != address(0));\n', '    require(balances[msg.sender] >= _amount && _amount > 0\n', '        && balances[_to].add(_amount) > balances[_to]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    emit Transfer(msg.sender, _to, _amount);\n', '    return true;\n', '  }\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _amount The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _amount) public returns (bool success) {\n', '    allowed[msg.sender][_spender] = _amount;\n', '    emit Approval(msg.sender, _spender, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', 'contract ReserveToken is StandardToken {\n', '  using SafeMath for uint256;\n', '  address public minter;\n', '  constructor() public {\n', '    minter = msg.sender;\n', '  }\n', '  function create(address account, uint amount) public {\n', '    require(msg.sender == minter);\n', '    balances[account] = balances[account].add(amount);\n', '    totalSupply = totalSupply.add(amount);\n', '  }\n', '  function destroy(address account, uint amount) public {\n', '    require(msg.sender == minter);\n', '    require(balances[account] >= amount);\n', '    balances[account] = balances[account].add(amount);\n', '    totalSupply = totalSupply.sub(amount);\n', '  }\n', '}\n', '\n', 'contract AccountLevels {\n', '  mapping (address => uint) public accountLevels;\n', '  //given a user, returns an account level\n', '  //0 = regular user (pays take fee and make fee)\n', '  //1 = market maker silver (pays take fee, no make fee, gets rebate)\n', '  //2 = market maker gold (pays take fee, no make fee, gets entire counterparty&#39;s take fee as rebate)\n', '  function accountLevel(address user) public constant returns(uint) {\n', '      return accountLevels[user];\n', '  }\n', '}\n', '\n', 'contract AccountLevelsTest is AccountLevels {\n', '  //mapping (address => uint) public accountLevels;\n', '\n', '  function setAccountLevel(address user, uint level) public {\n', '    accountLevels[user] = level;\n', '  }\n', '}\n', '\n', 'contract BossExchange is Ownable {\n', '  using SafeMath for uint256;\n', '  address public admin; //the admin address\n', '  address public feeAccount; //the account that will receive fees\n', '  address public accountLevelsAddr; //the address of the AccountLevels contract\n', '  uint public feeMake; //percentage times (1 ether)\n', '  uint public feeTake; //percentage times (1 ether)\n', '  uint public feeRebate; //percentage times (1 ether)\n', '  mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)\n', '  mapping (address => mapping (bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)\n', '  mapping (address => mapping (bytes32 => uint)) public orderFills; //mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)\n', '  transferToken public tokenReward;  \n', '  \n', '  event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);\n', '  event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);\n', '  event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);\n', '  event Deposit(address token, address user, uint amount, uint balance);\n', '  event Withdraw(address token, address user, uint amount, uint balance);\n', '\n', '\n', '  constructor(address admin_, address feeAccount_, address accountLevelsAddr_, uint feeMake_, uint feeTake_, uint feeRebate_) public {\n', '    owner = admin_;\n', '    admin = admin_;\n', '    feeAccount = feeAccount_;\n', '    accountLevelsAddr = accountLevelsAddr_;\n', '    feeMake = feeMake_;\n', '    feeTake = feeTake_;\n', '    feeRebate = feeRebate_;\n', '  }\n', '\n', '  function() public {\n', '    revert();\n', '  }\n', '\n', '  function changeAdmin(address admin_) public onlyOwner {\n', '    admin = admin_;\n', '  }\n', '\n', '  function changeAccountLevelsAddr(address accountLevelsAddr_) public onlyOwner {\n', '    accountLevelsAddr = accountLevelsAddr_;\n', '  }\n', '\n', '  function changeFeeAccount(address feeAccount_) public onlyOwner {\n', '    feeAccount = feeAccount_;\n', '  }\n', '\n', '  function changeFeeMake(uint feeMake_) public onlyOwner{\n', '    require(feeMake_ <= feeMake);\n', '    feeMake = feeMake_;\n', '  }\n', '\n', '  function changeFeeTake(uint feeTake_) public onlyOwner {\n', '    require (feeTake_ <= feeTake && feeTake_ >= feeRebate);\n', '    feeTake = feeTake_;\n', '  }\n', '\n', '  function changeFeeRebate(uint feeRebate_) public onlyOwner {\n', '    require(feeRebate_ >= feeRebate && feeRebate_ <=feeTake);\n', '    feeRebate = feeRebate_;\n', '  }\n', '\n', '  function deposit() public payable {\n', '    tokens[0][msg.sender] = tokens[0][msg.sender].add(msg.value);\n', '    emit Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);\n', '  }\n', '\n', '  function withdraw(uint amount) public {\n', '    require(tokens[0][msg.sender] >= amount);\n', '    tokens[0][msg.sender] = tokens[0][msg.sender].sub(amount);\n', '    msg.sender.transfer(amount);\n', '    emit Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);\n', '  }\n', '\n', '  function depositToken(address token, uint amount) public {\n', '    //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.\n', '    require(token!=0);\n', '    require(StandardToken(token).transferFrom(msg.sender, this, amount));\n', '    tokens[token][msg.sender] = tokens[token][msg.sender].add(amount);\n', '    emit Deposit(token, msg.sender, amount, tokens[token][msg.sender]);\n', '  }\n', '\t\n', '  function withdrawToken(address token, uint amount) public {\n', '    require(token!=0);\n', '    require(tokens[token][msg.sender] >= amount);\n', '    tokens[token][msg.sender] = tokens[token][msg.sender].sub(amount);\n', '    tokenReward = transferToken(token);\n', '\ttokenReward.transfer(msg.sender, amount);\n', '    emit Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);\n', '  }\n', '\n', '  function balanceOf(address token, address user) public constant returns (uint) {\n', '    return tokens[token][user];\n', '  }\n', '\n', '  function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) public {\n', '    bytes32 hash = keccak256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));\n', '    orders[msg.sender][hash] = true;\n', '    emit Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender);\n', '  }\n', '\n', '  function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) public {\n', '    //amount is in amountGet terms\n', '    bytes32 hash = keccak256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));\n', '    require((\n', '      (orders[user][hash] || ecrecover(keccak256(abi.encodePacked("\\x19Ethereum Signed Message:\\n32", hash)),v,r,s) == user) &&\n', '      block.number <= expires &&\n', '      orderFills[user][hash].add(amount) <= amountGet\n', '    ));\n', '    tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);\n', '    orderFills[user][hash] = orderFills[user][hash].add(amount);\n', '    emit Trade(tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, msg.sender);\n', '  }\n', '\n', '  function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private {\n', '    uint feeMakeXfer = amount.mul(feeMake) / (1 ether);\n', '    uint feeTakeXfer = amount.mul(feeTake) / (1 ether);\n', '    uint feeRebateXfer = 0;\n', '    feeRebateXfer = feeTakeXfer; \n', '    /*if (accountLevelsAddr != 0x0) {\n', '      uint accountLevel = AccountLevels(accountLevelsAddr).accountLevel(user);\n', '      if (accountLevel==1) feeRebateXfer = amount.mul(feeRebate) / (1 ether);\n', '      if (accountLevel==2) feeRebateXfer = feeTakeXfer;\n', '    }*/\n', '    tokens[tokenGet][msg.sender] = tokens[tokenGet][msg.sender].sub(amount.add(feeTakeXfer));\n', '    tokens[tokenGet][user] = tokens[tokenGet][user].add(amount.add(feeRebateXfer).sub(feeMakeXfer));\n', '    //tokens[tokenGet][feeAccount] = tokens[tokenGet][feeAccount].add(feeMakeXfer.add(feeTakeXfer).sub(feeRebateXfer));\n', '    tokens[tokenGive][user] = tokens[tokenGive][user].sub(amountGive.mul(amount) / amountGet);\n', '    tokens[tokenGive][msg.sender] = tokens[tokenGive][msg.sender].add(amountGive.mul(amount) / amountGet);\n', '  }\n', '\n', '  function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) public constant returns(bool) {\n', '    \n', '    if (!(\n', '      tokens[tokenGet][sender] >= amount &&\n', '      availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount\n', '    )) return false;\n', '    return true;\n', '  }\n', '\n', '  function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) public constant returns(uint) {\n', '    bytes32 hash = keccak256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));\n', '    uint available1;\n', '    if (!(\n', '      (orders[user][hash] || ecrecover(keccak256(abi.encodePacked("\\x19Ethereum Signed Message:\\n32", hash)),v,r,s) == user) &&\n', '      block.number <= expires\n', '    )) return 0;\n', '    available1 = tokens[tokenGive][user].mul(amountGet) / amountGive;\n', '    \n', '    if (amountGet.sub(orderFills[user][hash])<available1) return amountGet.sub(orderFills[user][hash]);\n', '    return available1;\n', '    \n', '  }\n', '\n', '  function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user) public constant returns(uint) {\n', '    bytes32 hash = keccak256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));\n', '    return orderFills[user][hash];\n', '  }\n', '\n', '  function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) public {\n', '    bytes32 hash = keccak256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));\n', '    require((orders[msg.sender][hash] || ecrecover(keccak256(abi.encodePacked("\\x19Ethereum Signed Message:\\n32", hash)),v,r,s) == msg.sender));\n', '    orderFills[msg.sender][hash] = amountGet;\n', '    emit Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);\n', '  }\n', '}']