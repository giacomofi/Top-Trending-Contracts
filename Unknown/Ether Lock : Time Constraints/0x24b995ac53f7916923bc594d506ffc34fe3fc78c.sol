['pragma solidity ^0.4.13;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control \n', ' * functions, this simplifies the implementation of "user permissions". \n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /** \n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner. \n', '   */\n', '  modifier onlyOwner() {\n', '    if (msg.sender != owner) {\n', '      throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to. \n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool);\n', '  function approve(address spender, uint256 value) returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances. \n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of. \n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // if (_value > _allowance) throw;\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) returns (bool) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifing the amount of tokens still avaible for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract GenesisToken is StandardToken, Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  // metadata\n', '  string public constant name = &#39;Genesis&#39;;\n', '  string public constant symbol = &#39;GNS&#39;;\n', '  uint256 public constant decimals = 18;\n', '  string public version = &#39;0.0.1&#39;;\n', '\n', '  // events\n', '  event EarnedGNS(address indexed contributor, uint256 amount);\n', '  event TransferredGNS(address indexed from, address indexed to, uint256 value);\n', '\n', '  // constructor\n', '  function GenesisToken(\n', '    address _owner,\n', '    uint256 initialBalance)\n', '  {\n', '    owner = _owner;\n', '    totalSupply = initialBalance;\n', '    balances[_owner] = initialBalance;\n', '    EarnedGNS(_owner, initialBalance);\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will recieve the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function giveTokens(address _to, uint256 _amount) onlyOwner returns (bool) {\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    EarnedGNS(_to, _amount);\n', '    return true;\n', '  }\n', '}\n', '\n', '/**\n', ' * This contract holds all the revenues generated by the DAO, and pays out to\n', ' * token holders on a periodic basis.\n', ' */\n', 'contract CrowdWallet is Ownable {\n', '  using SafeMath for uint;\n', '\n', '  struct Deposit {\n', '    uint amount;\n', '    uint block;\n', '  }\n', '\n', '  struct Payout {\n', '    uint amount;\n', '    uint block;\n', '  }\n', '\n', '  // Genesis Tokens determine the payout for each contributor.\n', '  GenesisToken public token;\n', '\n', '  // Track deposits/payouts by address\n', '  mapping (address => Deposit[]) public deposits;\n', '  mapping (address => Payout[]) public payouts;\n', '\n', '  // Track the sum of all payouts & deposits ever made to this contract.\n', '  uint public lifetimeDeposits;\n', '  uint public lifetimePayouts;\n', '\n', '  // Time between pay periods are defined as a number of blocks.\n', '  uint public blocksPerPayPeriod = 172800; // ~30 days\n', '  uint public previousPayoutBlock;\n', '  uint public nextPayoutBlock;\n', '\n', '  // The balance at the end of each period is saved here and allocated to token\n', '  // holders from the previous period.\n', '  uint public payoutPool;\n', '\n', '  // For doing division. Numerator should be multiplied by this.\n', '  uint multiplier = 10**18;\n', '\n', '  // Set a minimum that a user must have earned in order to withdraw it.\n', '  uint public minWithdrawalThreshold = 100000000000000000; // 0.1 ETH in wei\n', '\n', '  // Events\n', '  event onDeposit(address indexed _from, uint _amount);\n', '  event onPayout(address indexed _to, uint _amount);\n', '  event onPayoutFailure(address indexed _to, uint amount);\n', '\n', '  /**\n', '   * Constructor - set the GNS token address and the initial number of blocks\n', '   * in-between each pay period.\n', '   */\n', '  function CrowdWallet(address _gns, address _owner, uint _blocksPerPayPeriod) {\n', '    token = GenesisToken(_gns);\n', '    owner = _owner;\n', '    blocksPerPayPeriod = _blocksPerPayPeriod;\n', '    nextPayoutBlock = now.add(blocksPerPayPeriod);\n', '  }\n', '\n', '  function setMinimumWithdrawal(uint _weiAmount) onlyOwner {\n', '    minWithdrawalThreshold = _weiAmount;\n', '  }\n', '\n', '  function setBlocksPerPayPeriod(uint _blocksPerPayPeriod) onlyOwner {\n', '    blocksPerPayPeriod = _blocksPerPayPeriod;\n', '  }\n', '\n', '  /**\n', '   * To prevent cheating, when a withdrawal is made, the tokens for that address\n', '   * become immediately locked until the next period. Otherwise, they could send\n', '   * their tokens to another wallet and withdraw again.\n', '   */\n', '  function withdraw() {\n', '    require(previousPayoutBlock > 0);\n', '\n', '    // Ensure the user has not already made a withdrawal this period.\n', '    require(!isAddressLocked(msg.sender));\n', '\n', '    uint payoutAmount = calculatePayoutForAddress(msg.sender);\n', '\n', '    // Ensure user&#39;s payout is above the minimum threshold for withdrawals.\n', '    require(payoutAmount > minWithdrawalThreshold);\n', '\n', '    // User qualifies. Save the transaction with the current block number,\n', '    // effectively locking their tokens until the next payout date.\n', '    payouts[msg.sender].push(Payout({ amount: payoutAmount, block: now }));\n', '\n', '    require(this.balance >= payoutAmount);\n', '\n', '    onPayout(msg.sender, payoutAmount);\n', '\n', '    lifetimePayouts += payoutAmount;\n', '\n', '    msg.sender.transfer(payoutAmount);\n', '  }\n', '\n', '  /**\n', '   * Once a user gets paid out for a period, we lock up the tokens they own\n', '   * until the next period. Otherwise, they can send their tokens to a fresh\n', '   * address and then double dip.\n', '   */\n', '  function isAddressLocked(address contributor) constant returns(bool) {\n', '    var paymentHistory = payouts[contributor];\n', '\n', '    if (paymentHistory.length == 0) {\n', '      return false;\n', '    }\n', '\n', '    var lastPayment = paymentHistory[paymentHistory.length - 1];\n', '\n', '    return (lastPayment.block >= previousPayoutBlock) && (lastPayment.block < nextPayoutBlock);\n', '  }\n', '\n', '  /**\n', '   * Check if we are in a new payout cycle.\n', '   */\n', '  function isNewPayoutPeriod() constant returns(bool) {\n', '    return now >= nextPayoutBlock;\n', '  }\n', '\n', '  /**\n', '   * Start a new payout cycle\n', '   */\n', '  function startNewPayoutPeriod() {\n', '    require(isNewPayoutPeriod());\n', '\n', '    previousPayoutBlock = nextPayoutBlock;\n', '    nextPayoutBlock = nextPayoutBlock.add(blocksPerPayPeriod);\n', '    payoutPool = this.balance;\n', '  }\n', '\n', '  /**\n', '   * Determine the amount that should be paid out.\n', '   */\n', '  function calculatePayoutForAddress(address payee) constant returns(uint) {\n', '    uint ownedAmount = token.balanceOf(payee);\n', '    uint totalSupply = token.totalSupply();\n', '    uint percentage = (ownedAmount * multiplier) / totalSupply;\n', '    uint payout = (payoutPool * percentage) / multiplier;\n', '\n', '    return payout;\n', '  }\n', '\n', '  /**\n', '   * Check the contract&#39;s ETH balance.\n', '   */\n', '  function ethBalance() constant returns(uint) {\n', '    return this.balance;\n', '  }\n', '\n', '  /**\n', '   * Income should go here.\n', '   */\n', '  function deposit() payable {\n', '    onDeposit(msg.sender, msg.value);\n', '    lifetimeDeposits += msg.value;\n', '    deposits[msg.sender].push(Deposit({ amount: msg.value, block: now }));\n', '  }\n', '\n', '  function () payable {\n', '    deposit();\n', '  }\n', '}']
['pragma solidity ^0.4.13;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control \n', ' * functions, this simplifies the implementation of "user permissions". \n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /** \n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner. \n', '   */\n', '  modifier onlyOwner() {\n', '    if (msg.sender != owner) {\n', '      throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to. \n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool);\n', '  function approve(address spender, uint256 value) returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances. \n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of. \n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // if (_value > _allowance) throw;\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) returns (bool) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifing the amount of tokens still avaible for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract GenesisToken is StandardToken, Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  // metadata\n', "  string public constant name = 'Genesis';\n", "  string public constant symbol = 'GNS';\n", '  uint256 public constant decimals = 18;\n', "  string public version = '0.0.1';\n", '\n', '  // events\n', '  event EarnedGNS(address indexed contributor, uint256 amount);\n', '  event TransferredGNS(address indexed from, address indexed to, uint256 value);\n', '\n', '  // constructor\n', '  function GenesisToken(\n', '    address _owner,\n', '    uint256 initialBalance)\n', '  {\n', '    owner = _owner;\n', '    totalSupply = initialBalance;\n', '    balances[_owner] = initialBalance;\n', '    EarnedGNS(_owner, initialBalance);\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will recieve the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function giveTokens(address _to, uint256 _amount) onlyOwner returns (bool) {\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    EarnedGNS(_to, _amount);\n', '    return true;\n', '  }\n', '}\n', '\n', '/**\n', ' * This contract holds all the revenues generated by the DAO, and pays out to\n', ' * token holders on a periodic basis.\n', ' */\n', 'contract CrowdWallet is Ownable {\n', '  using SafeMath for uint;\n', '\n', '  struct Deposit {\n', '    uint amount;\n', '    uint block;\n', '  }\n', '\n', '  struct Payout {\n', '    uint amount;\n', '    uint block;\n', '  }\n', '\n', '  // Genesis Tokens determine the payout for each contributor.\n', '  GenesisToken public token;\n', '\n', '  // Track deposits/payouts by address\n', '  mapping (address => Deposit[]) public deposits;\n', '  mapping (address => Payout[]) public payouts;\n', '\n', '  // Track the sum of all payouts & deposits ever made to this contract.\n', '  uint public lifetimeDeposits;\n', '  uint public lifetimePayouts;\n', '\n', '  // Time between pay periods are defined as a number of blocks.\n', '  uint public blocksPerPayPeriod = 172800; // ~30 days\n', '  uint public previousPayoutBlock;\n', '  uint public nextPayoutBlock;\n', '\n', '  // The balance at the end of each period is saved here and allocated to token\n', '  // holders from the previous period.\n', '  uint public payoutPool;\n', '\n', '  // For doing division. Numerator should be multiplied by this.\n', '  uint multiplier = 10**18;\n', '\n', '  // Set a minimum that a user must have earned in order to withdraw it.\n', '  uint public minWithdrawalThreshold = 100000000000000000; // 0.1 ETH in wei\n', '\n', '  // Events\n', '  event onDeposit(address indexed _from, uint _amount);\n', '  event onPayout(address indexed _to, uint _amount);\n', '  event onPayoutFailure(address indexed _to, uint amount);\n', '\n', '  /**\n', '   * Constructor - set the GNS token address and the initial number of blocks\n', '   * in-between each pay period.\n', '   */\n', '  function CrowdWallet(address _gns, address _owner, uint _blocksPerPayPeriod) {\n', '    token = GenesisToken(_gns);\n', '    owner = _owner;\n', '    blocksPerPayPeriod = _blocksPerPayPeriod;\n', '    nextPayoutBlock = now.add(blocksPerPayPeriod);\n', '  }\n', '\n', '  function setMinimumWithdrawal(uint _weiAmount) onlyOwner {\n', '    minWithdrawalThreshold = _weiAmount;\n', '  }\n', '\n', '  function setBlocksPerPayPeriod(uint _blocksPerPayPeriod) onlyOwner {\n', '    blocksPerPayPeriod = _blocksPerPayPeriod;\n', '  }\n', '\n', '  /**\n', '   * To prevent cheating, when a withdrawal is made, the tokens for that address\n', '   * become immediately locked until the next period. Otherwise, they could send\n', '   * their tokens to another wallet and withdraw again.\n', '   */\n', '  function withdraw() {\n', '    require(previousPayoutBlock > 0);\n', '\n', '    // Ensure the user has not already made a withdrawal this period.\n', '    require(!isAddressLocked(msg.sender));\n', '\n', '    uint payoutAmount = calculatePayoutForAddress(msg.sender);\n', '\n', "    // Ensure user's payout is above the minimum threshold for withdrawals.\n", '    require(payoutAmount > minWithdrawalThreshold);\n', '\n', '    // User qualifies. Save the transaction with the current block number,\n', '    // effectively locking their tokens until the next payout date.\n', '    payouts[msg.sender].push(Payout({ amount: payoutAmount, block: now }));\n', '\n', '    require(this.balance >= payoutAmount);\n', '\n', '    onPayout(msg.sender, payoutAmount);\n', '\n', '    lifetimePayouts += payoutAmount;\n', '\n', '    msg.sender.transfer(payoutAmount);\n', '  }\n', '\n', '  /**\n', '   * Once a user gets paid out for a period, we lock up the tokens they own\n', '   * until the next period. Otherwise, they can send their tokens to a fresh\n', '   * address and then double dip.\n', '   */\n', '  function isAddressLocked(address contributor) constant returns(bool) {\n', '    var paymentHistory = payouts[contributor];\n', '\n', '    if (paymentHistory.length == 0) {\n', '      return false;\n', '    }\n', '\n', '    var lastPayment = paymentHistory[paymentHistory.length - 1];\n', '\n', '    return (lastPayment.block >= previousPayoutBlock) && (lastPayment.block < nextPayoutBlock);\n', '  }\n', '\n', '  /**\n', '   * Check if we are in a new payout cycle.\n', '   */\n', '  function isNewPayoutPeriod() constant returns(bool) {\n', '    return now >= nextPayoutBlock;\n', '  }\n', '\n', '  /**\n', '   * Start a new payout cycle\n', '   */\n', '  function startNewPayoutPeriod() {\n', '    require(isNewPayoutPeriod());\n', '\n', '    previousPayoutBlock = nextPayoutBlock;\n', '    nextPayoutBlock = nextPayoutBlock.add(blocksPerPayPeriod);\n', '    payoutPool = this.balance;\n', '  }\n', '\n', '  /**\n', '   * Determine the amount that should be paid out.\n', '   */\n', '  function calculatePayoutForAddress(address payee) constant returns(uint) {\n', '    uint ownedAmount = token.balanceOf(payee);\n', '    uint totalSupply = token.totalSupply();\n', '    uint percentage = (ownedAmount * multiplier) / totalSupply;\n', '    uint payout = (payoutPool * percentage) / multiplier;\n', '\n', '    return payout;\n', '  }\n', '\n', '  /**\n', "   * Check the contract's ETH balance.\n", '   */\n', '  function ethBalance() constant returns(uint) {\n', '    return this.balance;\n', '  }\n', '\n', '  /**\n', '   * Income should go here.\n', '   */\n', '  function deposit() payable {\n', '    onDeposit(msg.sender, msg.value);\n', '    lifetimeDeposits += msg.value;\n', '    deposits[msg.sender].push(Deposit({ amount: msg.value, block: now }));\n', '  }\n', '\n', '  function () payable {\n', '    deposit();\n', '  }\n', '}']
