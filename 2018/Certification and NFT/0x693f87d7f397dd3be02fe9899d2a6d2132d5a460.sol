['pragma solidity ^0.4.23;\n', '\n', '// File: contracts/grapevine/crowdsale/BurnableTokenInterface.sol\n', '\n', '/**\n', ' * @title Burnable Token Interface, defining one single function to burn tokens.\n', ' * @dev Grapevine Crowdsale\n', ' **/\n', 'contract BurnableTokenInterface {\n', '\n', '  /**\n', '  * @dev Burns a specific amount of tokens.\n', '  * @param _value The amount of token to be burned.\n', '  */\n', '  function burn(uint256 _value) public;\n', '}\n', '\n', '// File: contracts/grapevine/crowdsale/GrapevineWhitelistInterface.sol\n', '\n', '/**\n', ' * @title Grapevine Whitelist extends the zeppelin Whitelist and adding off-chain signing capabilities.\n', ' * @dev Grapevine Crowdsale\n', ' **/\n', 'contract GrapevineWhitelistInterface {\n', '\n', '  /**\n', '   * @dev Function to check if an address is whitelisted or not\n', '   * @param _address address The address to be checked.\n', '   */\n', '  function whitelist(address _address) view external returns (bool);\n', '\n', ' \n', '  /**\n', '   * @dev Handles the off-chain whitelisting.\n', '   * @param _addr Address of the sender.\n', '   * @param _sig signed message provided by the sender.\n', '   */\n', '  function handleOffchainWhitelisted(address _addr, bytes _sig) external returns (bool);\n', '}\n', '\n', '// File: contracts/grapevine/crowdsale/TokenTimelockControllerInterface.sol\n', '\n', '/**\n', ' * @title TokenTimelock Controller Interface\n', ' * @dev This contract allows the crowdsale to create locked bonuses and activate the controller.\n', ' **/\n', 'contract TokenTimelockControllerInterface {\n', '\n', '  /**\n', '   * @dev Function to activate the controller.\n', '   * It can be called only by the crowdsale address.\n', '   */\n', '  function activate() external;\n', '\n', '  /**\n', '   * @dev Creates a lock for the provided _beneficiary with the provided amount\n', '   * The creation can be peformed only if:\n', '   * - the sender is the address of the crowdsale;\n', '   * - the _beneficiary and _tokenHolder are valid addresses;\n', '   * - the _amount is greater than 0 and was appoved by the _tokenHolder prior to the transaction.\n', '   * The investors will have a lock with a lock period of 6 months.\n', '   * @param _beneficiary Address that will own the lock.\n', '   * @param _amount the amount of the locked tokens.\n', '   * @param _start when the lock should start.\n', '   * @param _tokenHolder the account that approved the amount for this contract.\n', '   */\n', '  function createInvestorTokenTimeLock(\n', '    address _beneficiary,\n', '    uint256 _amount, \n', '    uint256 _start,\n', '    address _tokenHolder\n', '    ) external returns (bool);\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    // Gas optimization: this is cheaper than asserting &#39;a&#39; not being zero, but the\n', '    // benefit is lost if &#39;b&#39; is also tested.\n', '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    public returns (bool);\n', '\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol\n', '\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale,\n', ' * allowing investors to purchase tokens with ether. This contract implements\n', ' * such functionality in its most fundamental form and can be extended to provide additional\n', ' * functionality and/or custom behavior.\n', ' * The external interface represents the basic interface for purchasing tokens, and conform\n', ' * the base architecture for crowdsales. They are *not* intended to be modified / overriden.\n', ' * The internal interface conforms the extensible and modifiable surface of crowdsales. Override\n', ' * the methods to add functionality. Consider using &#39;super&#39; where appropiate to concatenate\n', ' * behavior.\n', ' */\n', 'contract Crowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  // The token being sold\n', '  ERC20 public token;\n', '\n', '  // Address where funds are collected\n', '  address public wallet;\n', '\n', '  // How many token units a buyer gets per wei.\n', '  // The rate is the conversion between wei and the smallest and indivisible token unit.\n', '  // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK\n', '  // 1 wei will give you 1 unit, or 0.001 TOK.\n', '  uint256 public rate;\n', '\n', '  // Amount of wei raised\n', '  uint256 public weiRaised;\n', '\n', '  /**\n', '   * Event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(\n', '    address indexed purchaser,\n', '    address indexed beneficiary,\n', '    uint256 value,\n', '    uint256 amount\n', '  );\n', '\n', '  /**\n', '   * @param _rate Number of token units a buyer gets per wei\n', '   * @param _wallet Address where collected funds will be forwarded to\n', '   * @param _token Address of the token being sold\n', '   */\n', '  constructor(uint256 _rate, address _wallet, ERC20 _token) public {\n', '    require(_rate > 0);\n', '    require(_wallet != address(0));\n', '    require(_token != address(0));\n', '\n', '    rate = _rate;\n', '    wallet = _wallet;\n', '    token = _token;\n', '  }\n', '\n', '  // -----------------------------------------\n', '  // Crowdsale external interface\n', '  // -----------------------------------------\n', '\n', '  /**\n', '   * @dev fallback function ***DO NOT OVERRIDE***\n', '   */\n', '  function () external payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  /**\n', '   * @dev low level token purchase ***DO NOT OVERRIDE***\n', '   * @param _beneficiary Address performing the token purchase\n', '   */\n', '  function buyTokens(address _beneficiary) public payable {\n', '\n', '    uint256 weiAmount = msg.value;\n', '    _preValidatePurchase(_beneficiary, weiAmount);\n', '\n', '    // calculate token amount to be created\n', '    uint256 tokens = _getTokenAmount(weiAmount);\n', '\n', '    // update state\n', '    weiRaised = weiRaised.add(weiAmount);\n', '\n', '    _processPurchase(_beneficiary, tokens);\n', '    emit TokenPurchase(\n', '      msg.sender,\n', '      _beneficiary,\n', '      weiAmount,\n', '      tokens\n', '    );\n', '\n', '    _updatePurchasingState(_beneficiary, weiAmount);\n', '\n', '    _forwardFunds();\n', '    _postValidatePurchase(_beneficiary, weiAmount);\n', '  }\n', '\n', '  // -----------------------------------------\n', '  // Internal interface (extensible)\n', '  // -----------------------------------------\n', '\n', '  /**\n', '   * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.\n', '   * @param _beneficiary Address performing the token purchase\n', '   * @param _weiAmount Value in wei involved in the purchase\n', '   */\n', '  function _preValidatePurchase(\n', '    address _beneficiary,\n', '    uint256 _weiAmount\n', '  )\n', '    internal\n', '  {\n', '    require(_beneficiary != address(0));\n', '    require(_weiAmount != 0);\n', '  }\n', '\n', '  /**\n', '   * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.\n', '   * @param _beneficiary Address performing the token purchase\n', '   * @param _weiAmount Value in wei involved in the purchase\n', '   */\n', '  function _postValidatePurchase(\n', '    address _beneficiary,\n', '    uint256 _weiAmount\n', '  )\n', '    internal\n', '  {\n', '    // optional override\n', '  }\n', '\n', '  /**\n', '   * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.\n', '   * @param _beneficiary Address performing the token purchase\n', '   * @param _tokenAmount Number of tokens to be emitted\n', '   */\n', '  function _deliverTokens(\n', '    address _beneficiary,\n', '    uint256 _tokenAmount\n', '  )\n', '    internal\n', '  {\n', '    token.transfer(_beneficiary, _tokenAmount);\n', '  }\n', '\n', '  /**\n', '   * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.\n', '   * @param _beneficiary Address receiving the tokens\n', '   * @param _tokenAmount Number of tokens to be purchased\n', '   */\n', '  function _processPurchase(\n', '    address _beneficiary,\n', '    uint256 _tokenAmount\n', '  )\n', '    internal\n', '  {\n', '    _deliverTokens(_beneficiary, _tokenAmount);\n', '  }\n', '\n', '  /**\n', '   * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)\n', '   * @param _beneficiary Address receiving the tokens\n', '   * @param _weiAmount Value in wei involved in the purchase\n', '   */\n', '  function _updatePurchasingState(\n', '    address _beneficiary,\n', '    uint256 _weiAmount\n', '  )\n', '    internal\n', '  {\n', '    // optional override\n', '  }\n', '\n', '  /**\n', '   * @dev Override to extend the way in which ether is converted to tokens.\n', '   * @param _weiAmount Value in wei to be converted into tokens\n', '   * @return Number of tokens that can be purchased with the specified _weiAmount\n', '   */\n', '  function _getTokenAmount(uint256 _weiAmount)\n', '    internal view returns (uint256)\n', '  {\n', '    return _weiAmount.mul(rate);\n', '  }\n', '\n', '  /**\n', '   * @dev Determines how ETH is stored/forwarded on purchases.\n', '   */\n', '  function _forwardFunds() internal {\n', '    wallet.transfer(msg.value);\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol\n', '\n', '/**\n', ' * @title TimedCrowdsale\n', ' * @dev Crowdsale accepting contributions only within a time frame.\n', ' */\n', 'contract TimedCrowdsale is Crowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  uint256 public openingTime;\n', '  uint256 public closingTime;\n', '\n', '  /**\n', '   * @dev Reverts if not in crowdsale time range.\n', '   */\n', '  modifier onlyWhileOpen {\n', '    // solium-disable-next-line security/no-block-members\n', '    require(block.timestamp >= openingTime && block.timestamp <= closingTime);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Constructor, takes crowdsale opening and closing times.\n', '   * @param _openingTime Crowdsale opening time\n', '   * @param _closingTime Crowdsale closing time\n', '   */\n', '  constructor(uint256 _openingTime, uint256 _closingTime) public {\n', '    // solium-disable-next-line security/no-block-members\n', '    require(_openingTime >= block.timestamp);\n', '    require(_closingTime >= _openingTime);\n', '\n', '    openingTime = _openingTime;\n', '    closingTime = _closingTime;\n', '  }\n', '\n', '  /**\n', '   * @dev Checks whether the period in which the crowdsale is open has already elapsed.\n', '   * @return Whether crowdsale period has elapsed\n', '   */\n', '  function hasClosed() public view returns (bool) {\n', '    // solium-disable-next-line security/no-block-members\n', '    return block.timestamp > closingTime;\n', '  }\n', '\n', '  /**\n', '   * @dev Extend parent behavior requiring to be within contributing period\n', '   * @param _beneficiary Token purchaser\n', '   * @param _weiAmount Amount of wei contributed\n', '   */\n', '  function _preValidatePurchase(\n', '    address _beneficiary,\n', '    uint256 _weiAmount\n', '  )\n', '    internal\n', '    onlyWhileOpen\n', '  {\n', '    super._preValidatePurchase(_beneficiary, _weiAmount);\n', '  }\n', '\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/crowdsale/distribution/PostDeliveryCrowdsale.sol\n', '\n', '/**\n', ' * @title PostDeliveryCrowdsale\n', ' * @dev Crowdsale that locks tokens from withdrawal until it ends.\n', ' */\n', 'contract PostDeliveryCrowdsale is TimedCrowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) public balances;\n', '\n', '  /**\n', '   * @dev Withdraw tokens only after crowdsale ends.\n', '   */\n', '  function withdrawTokens() public {\n', '    require(hasClosed());\n', '    uint256 amount = balances[msg.sender];\n', '    require(amount > 0);\n', '    balances[msg.sender] = 0;\n', '    _deliverTokens(msg.sender, amount);\n', '  }\n', '\n', '  /**\n', '   * @dev Overrides parent by storing balances instead of issuing tokens right away.\n', '   * @param _beneficiary Token purchaser\n', '   * @param _tokenAmount Amount of tokens purchased\n', '   */\n', '  function _processPurchase(\n', '    address _beneficiary,\n', '    uint256 _tokenAmount\n', '  )\n', '    internal\n', '  {\n', '    balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);\n', '  }\n', '\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol\n', '\n', '/**\n', ' * @title FinalizableCrowdsale\n', ' * @dev Extension of Crowdsale where an owner can do extra work\n', ' * after finishing.\n', ' */\n', 'contract FinalizableCrowdsale is TimedCrowdsale, Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  bool public isFinalized = false;\n', '\n', '  event Finalized();\n', '\n', '  /**\n', '   * @dev Must be called after crowdsale ends, to do some extra finalization\n', '   * work. Calls the contract&#39;s finalization function.\n', '   */\n', '  function finalize() onlyOwner public {\n', '    require(!isFinalized);\n', '    require(hasClosed());\n', '\n', '    finalization();\n', '    emit Finalized();\n', '\n', '    isFinalized = true;\n', '  }\n', '\n', '  /**\n', '   * @dev Can be overridden to add finalization logic. The overriding function\n', '   * should call super.finalization() to ensure the chain of finalization is\n', '   * executed entirely.\n', '   */\n', '  function finalization() internal {\n', '  }\n', '\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/crowdsale/distribution/utils/RefundVault.sol\n', '\n', '/**\n', ' * @title RefundVault\n', ' * @dev This contract is used for storing funds while a crowdsale\n', ' * is in progress. Supports refunding the money if crowdsale fails,\n', ' * and forwarding it if crowdsale is successful.\n', ' */\n', 'contract RefundVault is Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  enum State { Active, Refunding, Closed }\n', '\n', '  mapping (address => uint256) public deposited;\n', '  address public wallet;\n', '  State public state;\n', '\n', '  event Closed();\n', '  event RefundsEnabled();\n', '  event Refunded(address indexed beneficiary, uint256 weiAmount);\n', '\n', '  /**\n', '   * @param _wallet Vault address\n', '   */\n', '  constructor(address _wallet) public {\n', '    require(_wallet != address(0));\n', '    wallet = _wallet;\n', '    state = State.Active;\n', '  }\n', '\n', '  /**\n', '   * @param investor Investor address\n', '   */\n', '  function deposit(address investor) onlyOwner public payable {\n', '    require(state == State.Active);\n', '    deposited[investor] = deposited[investor].add(msg.value);\n', '  }\n', '\n', '  function close() onlyOwner public {\n', '    require(state == State.Active);\n', '    state = State.Closed;\n', '    emit Closed();\n', '    wallet.transfer(address(this).balance);\n', '  }\n', '\n', '  function enableRefunds() onlyOwner public {\n', '    require(state == State.Active);\n', '    state = State.Refunding;\n', '    emit RefundsEnabled();\n', '  }\n', '\n', '  /**\n', '   * @param investor Investor address\n', '   */\n', '  function refund(address investor) public {\n', '    require(state == State.Refunding);\n', '    uint256 depositedValue = deposited[investor];\n', '    deposited[investor] = 0;\n', '    investor.transfer(depositedValue);\n', '    emit Refunded(investor, depositedValue);\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/crowdsale/distribution/RefundableCrowdsale.sol\n', '\n', '/**\n', ' * @title RefundableCrowdsale\n', ' * @dev Extension of Crowdsale contract that adds a funding goal, and\n', ' * the possibility of users getting a refund if goal is not met.\n', ' * Uses a RefundVault as the crowdsale&#39;s vault.\n', ' */\n', 'contract RefundableCrowdsale is FinalizableCrowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  // minimum amount of funds to be raised in weis\n', '  uint256 public goal;\n', '\n', '  // refund vault used to hold funds while crowdsale is running\n', '  RefundVault public vault;\n', '\n', '  /**\n', '   * @dev Constructor, creates RefundVault.\n', '   * @param _goal Funding goal\n', '   */\n', '  constructor(uint256 _goal) public {\n', '    require(_goal > 0);\n', '    vault = new RefundVault(wallet);\n', '    goal = _goal;\n', '  }\n', '\n', '  /**\n', '   * @dev Investors can claim refunds here if crowdsale is unsuccessful\n', '   */\n', '  function claimRefund() public {\n', '    require(isFinalized);\n', '    require(!goalReached());\n', '\n', '    vault.refund(msg.sender);\n', '  }\n', '\n', '  /**\n', '   * @dev Checks whether funding goal was reached.\n', '   * @return Whether funding goal was reached\n', '   */\n', '  function goalReached() public view returns (bool) {\n', '    return weiRaised >= goal;\n', '  }\n', '\n', '  /**\n', '   * @dev vault finalization task, called when owner calls finalize()\n', '   */\n', '  function finalization() internal {\n', '    if (goalReached()) {\n', '      vault.close();\n', '    } else {\n', '      vault.enableRefunds();\n', '    }\n', '\n', '    super.finalization();\n', '  }\n', '\n', '  /**\n', '   * @dev Overrides Crowdsale fund forwarding, sending funds to vault.\n', '   */\n', '  function _forwardFunds() internal {\n', '    vault.deposit.value(msg.value)(msg.sender);\n', '  }\n', '\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol\n', '\n', '/**\n', ' * @title CappedCrowdsale\n', ' * @dev Crowdsale with a limit for total contributions.\n', ' */\n', 'contract CappedCrowdsale is Crowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  uint256 public cap;\n', '\n', '  /**\n', '   * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.\n', '   * @param _cap Max amount of wei to be contributed\n', '   */\n', '  constructor(uint256 _cap) public {\n', '    require(_cap > 0);\n', '    cap = _cap;\n', '  }\n', '\n', '  /**\n', '   * @dev Checks whether the cap has been reached.\n', '   * @return Whether the cap was reached\n', '   */\n', '  function capReached() public view returns (bool) {\n', '    return weiRaised >= cap;\n', '  }\n', '\n', '  /**\n', '   * @dev Extend parent behavior requiring purchase to respect the funding cap.\n', '   * @param _beneficiary Token purchaser\n', '   * @param _weiAmount Amount of wei contributed\n', '   */\n', '  function _preValidatePurchase(\n', '    address _beneficiary,\n', '    uint256 _weiAmount\n', '  )\n', '    internal\n', '  {\n', '    super._preValidatePurchase(_beneficiary, _weiAmount);\n', '    require(weiRaised.add(_weiAmount) <= cap);\n', '  }\n', '\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', '// File: contracts/grapevine/crowdsale/GrapevineCrowdsale.sol\n', '\n', '/**\n', ' * @title Grapevine Crowdsale, combining capped, timed, PostDelivery and refundable crowdsales\n', ' * while being pausable.\n', ' * @dev Grapevine Crowdsale\n', ' **/\n', 'contract GrapevineCrowdsale is CappedCrowdsale, TimedCrowdsale, Pausable, RefundableCrowdsale, PostDeliveryCrowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  TokenTimelockControllerInterface public timelockController;\n', '  GrapevineWhitelistInterface  public authorisedInvestors;\n', '  GrapevineWhitelistInterface public earlyInvestors;\n', '\n', '  mapping(address => uint256) public bonuses;\n', '\n', '  uint256 deliveryTime;\n', '  uint256 tokensToBeDelivered;\n', '\n', '  /**\n', '    * @param _timelockController address of the controller managing the bonus token lock\n', '    * @param _rate Number of token units a buyer gets per wei\n', '    * @param _wallet Address where collected funds will be forwarded to\n', '    * @param _token Address of the token being sold\n', '    * @param _openingTime Crowdsale opening time\n', '    * @param _closingTime Crowdsale closing time\n', '    * @param _softCap Funding goal\n', '    * @param _hardCap Max amount of wei to be contributed\n', '    */\n', '  constructor(\n', '    TokenTimelockControllerInterface _timelockController,\n', '    GrapevineWhitelistInterface _authorisedInvestors,\n', '    GrapevineWhitelistInterface _earlyInvestors,\n', '    uint256 _rate, \n', '    address _wallet,\n', '    ERC20 _token, \n', '    uint256 _openingTime, \n', '    uint256 _closingTime, \n', '    uint256 _softCap, \n', '    uint256 _hardCap)\n', '    Crowdsale(_rate, _wallet, _token)\n', '    CappedCrowdsale(_hardCap)\n', '    TimedCrowdsale(_openingTime, _closingTime) \n', '    RefundableCrowdsale(_softCap)\n', '    public \n', '    {\n', '    timelockController = _timelockController;\n', '    authorisedInvestors = _authorisedInvestors;\n', '    earlyInvestors = _earlyInvestors;\n', '    // token delivery starts 5 days after the crowdsale ends.\n', '    //deliveryTime = _closingTime.add(60*60*24*5);\n', '    deliveryTime = _closingTime.add(60*5);\n', '  }\n', '\n', '  /**\n', '   * @dev low level token purchase\n', '   * @param _beneficiary Address performing the token purchase\n', '   */\n', '  function buyTokens(address _beneficiary, bytes _whitelistSign) public payable {\n', '    // since the earlyInvestors are by definition autorised, we check first the earlyInvestors.\n', '    if (!earlyInvestors.handleOffchainWhitelisted(_beneficiary, _whitelistSign)) {\n', '      authorisedInvestors.handleOffchainWhitelisted(_beneficiary, _whitelistSign);\n', '    }\n', '    super.buyTokens(_beneficiary);\n', '  }\n', '\n', '  /**\n', '   * @dev Withdraw tokens only after the deliveryTime.\n', '   */\n', '  function withdrawTokens() public {\n', '    require(goalReached());\n', '    // solium-disable-next-line security/no-block-members\n', '    require(block.timestamp > deliveryTime);\n', '    super.withdrawTokens();\n', '    uint256 _bonusTokens = bonuses[msg.sender];\n', '    if (_bonusTokens > 0) {\n', '      bonuses[msg.sender] = 0;\n', '      require(token.approve(address(timelockController), _bonusTokens));\n', '      require(\n', '        timelockController.createInvestorTokenTimeLock(\n', '          msg.sender,\n', '          _bonusTokens,\n', '          deliveryTime,\n', '          this\n', '        )\n', '      );\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.\n', '   * It computes the bonus and store it using the timelockController.\n', '   * @param _beneficiary Address receiving the tokens\n', '   * @param _tokenAmount Number of tokens to be purchased\n', '   */\n', '  function _processPurchase( address _beneficiary, uint256 _tokenAmount ) internal {\n', '    uint256 _totalTokens = _tokenAmount;\n', '    // solium-disable-next-line security/no-block-members\n', '    uint256 _bonus = getBonus(block.timestamp, _beneficiary, msg.value);\n', '    if (_bonus>0) {\n', '      uint256 _bonusTokens = _tokenAmount.mul(_bonus).div(100);\n', '      // make sure the crowdsale contract has enough tokens to transfer the purchased tokens and to create the timelock bonus.\n', '      uint256 _currentBalance = token.balanceOf(this);\n', '      require(_currentBalance >= _totalTokens.add(_bonusTokens));\n', '      bonuses[_beneficiary] = bonuses[_beneficiary].add(_bonusTokens);\n', '      _totalTokens = _totalTokens.add(_bonusTokens);\n', '    }\n', '    tokensToBeDelivered = tokensToBeDelivered.add(_totalTokens);\n', '    super._processPurchase(_beneficiary, _tokenAmount);\n', '  }\n', '\n', '  /**\n', '   * @dev Validation of an incoming purchase. Allowas purchases only when crowdsale is not paused and the _beneficiary is authorized to buy.\n', '   * The early investors went through the KYC process, so they are authorised by default.\n', '   * @param _beneficiary Address performing the token purchase\n', '   * @param _weiAmount Value in wei involved in the purchase\n', '   */\n', '  function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal whenNotPaused {\n', '    require(authorisedInvestors.whitelist(_beneficiary) || earlyInvestors.whitelist(_beneficiary));\n', '    super._preValidatePurchase(_beneficiary, _weiAmount);\n', '  }\n', '\n', '  /**\n', '   * @dev Computes the bonus. The bonus is\n', '   * - 0 by default\n', '   * - 30% before reaching the softCap for those whitelisted.\n', '   * - 15% the first week\n', '   * - 10% the second week\n', '   * - 8% the third week\n', '   * - 6% the remaining time.\n', '   * @param _time when the purchased happened.\n', '   * @param _beneficiary Address performing the token purchase.\n', '   * @param _value Value in wei involved in the purchase.\n', '   */\n', '  function getBonus(uint256 _time, address _beneficiary, uint256 _value) view internal returns (uint256 _bonus) {\n', '    //default bonus is 0.\n', '    _bonus = 0;\n', '    \n', '    // at this level the amount was added to weiRaised\n', '    if ( (weiRaised.sub(_value) < goal) && earlyInvestors.whitelist(_beneficiary) ) {\n', '      _bonus = 30;\n', '    } else {\n', '      if (_time < openingTime.add(7 days)) {\n', '        _bonus = 15;\n', '      } else if (_time < openingTime.add(14 days)) {\n', '        _bonus = 10;\n', '      } else if (_time < openingTime.add(21 days)) {\n', '        _bonus = 8;\n', '      } else {\n', '        _bonus = 6;\n', '      }\n', '    }\n', '    return _bonus;\n', '  }\n', '\n', '  /**\n', '   * @dev Performs the finalization tasks:\n', '   * - if goal reached, activate the controller and burn the remaining tokens\n', '   * - transfer the ownership of the token contract back to the owner.\n', '   */\n', '  function finalization() internal {\n', '    // only when the goal is reached we burn the tokens and activate the controller.\n', '    if (goalReached()) {\n', '      // activate the controller to enable the investors and team members \n', '      // to claim their tokens when the time comes.\n', '      timelockController.activate();\n', '\n', '      // calculate the quantity of tokens to be burnt. The bonuses are already transfered to the Controller.\n', '      uint256 balance = token.balanceOf(this);\n', '      uint256 remainingTokens = balance.sub(tokensToBeDelivered);\n', '      if (remainingTokens>0) {\n', '        BurnableTokenInterface(address(token)).burn(remainingTokens);\n', '      }\n', '    }\n', '    Ownable(address(token)).transferOwnership(owner);\n', '    super.finalization();\n', '  }\n', '}']