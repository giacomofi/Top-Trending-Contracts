['pragma solidity ^0.4.11;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', '\n', '/*\n', ' * Haltable\n', ' *\n', ' * Abstract contract that allows children to implement an\n', ' * emergency stop mechanism. Differs from Pausable by requiring a state.\n', ' *\n', ' *\n', ' * Originally envisioned in FirstBlood ICO contract.\n', ' */\n', ' contract Haltable is Ownable {\n', '   bool public halted;\n', '\n', '   modifier inNormalState {\n', '     assert(!halted);\n', '     _;\n', '   }\n', '\n', '   modifier inEmergencyState {\n', '     assert(halted);\n', '     _;\n', '   }\n', '\n', '   // called by the owner on emergency, triggers stopped state\n', '   function halt() external onlyOwner inNormalState {\n', '     halted = true;\n', '   }\n', '\n', '   // called by the owner on end of emergency, returns to normal state\n', '   function unhalt() external onlyOwner inEmergencyState {\n', '     halted = false;\n', '   }\n', '\n', ' }\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool);\n', '  function approve(address spender, uint256 value) returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) returns (bool) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifing the amount of tokens still avaible for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Burnable\n', ' *\n', ' * @dev Standard ERC20 token\n', ' */\n', 'contract Burnable is StandardToken {\n', '  using SafeMath for uint;\n', '\n', '  /* This notifies clients about the amount burnt */\n', '  event Burn(address indexed from, uint256 value);\n', '\n', '  function burn(uint256 _value) returns (bool success) {\n', '    require(balances[msg.sender] >= _value);                // Check if the sender has enough\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);// Subtract from the sender\n', '    totalSupply = totalSupply.sub(_value);                                  // Updates totalSupply\n', '    Burn(msg.sender, _value);\n', '    return true;\n', '  }\n', '\n', '  function burnFrom(address _from, uint256 _value) returns (bool success) {\n', '    require(balances[_from] >= _value);               // Check if the sender has enough\n', '    require(_value <= allowed[_from][msg.sender]);    // Check allowance\n', '    balances[_from] = balances[_from].sub(_value);    // Subtract from the sender\n', '    totalSupply = totalSupply.sub(_value);            // Updates totalSupply\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Burn(_from, _value);\n', '    return true;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) returns (bool success) {\n', '    require(_to != 0x0); //use burn\n', '\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value) returns (bool success) {\n', '    require(_to != 0x0); //use burn\n', '\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '}\n', '\n', '/**\n', ' * @title JincorToken\n', ' *\n', ' * @dev Burnable Ownable ERC20 token\n', ' */\n', ' contract JincorToken is Burnable, Ownable {\n', '\n', '   string public name = "Jincor Token";\n', '   string public symbol = "JCR";\n', '   uint256 public decimals = 18;\n', '   uint256 public INITIAL_SUPPLY = 35000000 * 1 ether;\n', '\n', '   /* The finalizer contract that allows unlift the transfer limits on this token */\n', '   address public releaseAgent;\n', '\n', '   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/\n', '   bool public released = false;\n', '\n', '   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */\n', '   mapping (address => bool) public transferAgents;\n', '\n', '   /**\n', '    * Limit token transfer until the crowdsale is over.\n', '    *\n', '    */\n', '   modifier canTransfer(address _sender) {\n', '     require(transferAgents[_sender] || released);\n', '     _;\n', '   }\n', '\n', '   /** The function can be called only before or after the tokens have been releasesd */\n', '   modifier inReleaseState(bool releaseState) {\n', '     require(releaseState == released);\n', '     _;\n', '   }\n', '\n', '   /** The function can be called only by a whitelisted release agent. */\n', '   modifier onlyReleaseAgent() {\n', '     require(msg.sender == releaseAgent);\n', '     _;\n', '   }\n', '\n', '\n', '   /**\n', '    * @dev Contructor that gives msg.sender all of existing tokens.\n', '    */\n', '   function JincorToken() {\n', '     totalSupply = INITIAL_SUPPLY;\n', '     balances[msg.sender] = INITIAL_SUPPLY;\n', '   }\n', '\n', '\n', '   /**\n', '    * Set the contract that can call release and make the token transferable.\n', '    *\n', '    * Design choice. Allow reset the release agent to fix fat finger mistakes.\n', '    */\n', '   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {\n', '\n', '     // We don&#39;t do interface check here as we might want to a normal wallet address to act as a release agent\n', '     releaseAgent = addr;\n', '   }\n', '\n', '   function release() onlyReleaseAgent inReleaseState(false) public {\n', '     released = true;\n', '   }\n', '\n', '   /**\n', '    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.\n', '    */\n', '   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {\n', '     transferAgents[addr] = state;\n', '   }\n', '\n', '   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {\n', '     // Call Burnable.transfer()\n', '     return super.transfer(_to, _value);\n', '   }\n', '\n', '   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {\n', '     // Call Burnable.transferForm()\n', '     return super.transferFrom(_from, _to, _value);\n', '   }\n', '\n', '   function burn(uint256 _value) onlyOwner returns (bool success) {\n', '     return super.burn(_value);\n', '   }\n', '\n', '   function burnFrom(address _from, uint256 _value) onlyOwner returns (bool success) {\n', '     return super.burnFrom(_from, _value);\n', '   }\n', ' }\n', '\n', '\n', '\n', 'contract JincorTokenPreSale is Ownable, Haltable {\n', '  using SafeMath for uint;\n', '\n', '  string public name = "Jincor Token PreSale";\n', '\n', '  JincorToken public token;\n', '\n', '  address public beneficiary;\n', '\n', '  uint public hardCap;\n', '\n', '  uint public softCap;\n', '\n', '  uint public price;\n', '\n', '  uint public purchaseLimit;\n', '\n', '  uint public collected = 0;\n', '\n', '  uint public tokensSold = 0;\n', '\n', '  uint public investorCount = 0;\n', '\n', '  uint public weiRefunded = 0;\n', '\n', '  uint public startBlock;\n', '\n', '  uint public endBlock;\n', '\n', '  bool public softCapReached = false;\n', '\n', '  bool public crowdsaleFinished = false;\n', '\n', '  mapping (address => bool) refunded;\n', '\n', '  event GoalReached(uint amountRaised);\n', '\n', '  event SoftCapReached(uint softCap);\n', '\n', '  event NewContribution(address indexed holder, uint256 tokenAmount, uint256 etherAmount);\n', '\n', '  event Refunded(address indexed holder, uint256 amount);\n', '\n', '  modifier preSaleActive() {\n', '    require(block.number >= startBlock && block.number < endBlock);\n', '    _;\n', '  }\n', '\n', '  modifier preSaleEnded() {\n', '    require(block.number >= endBlock);\n', '    _;\n', '  }\n', '\n', '  function JincorTokenPreSale(\n', '  uint _hardCapUSD,\n', '  uint _softCapUSD,\n', '  address _token,\n', '  address _beneficiary,\n', '  uint _totalTokens,\n', '  uint _priceETH,\n', '  uint _purchaseLimitUSD,\n', '\n', '  uint _startBlock,\n', '  uint _endBlock\n', '  ) {\n', '    hardCap = _hardCapUSD.mul(1 ether).div(_priceETH);\n', '    softCap = _softCapUSD.mul(1 ether).div(_priceETH);\n', '    price = _totalTokens.mul(1 ether).div(hardCap);\n', '\n', '    purchaseLimit = _purchaseLimitUSD.mul(1 ether).div(_priceETH).mul(price);\n', '    token = JincorToken(_token);\n', '    beneficiary = _beneficiary;\n', '\n', '    startBlock = _startBlock;\n', '    endBlock = _endBlock;\n', '  }\n', '\n', '  function() payable {\n', '    require(msg.value >= 0.1 * 1 ether);\n', '    doPurchase(msg.sender);\n', '  }\n', '\n', '  function refund() external preSaleEnded inNormalState {\n', '    require(softCapReached == false);\n', '    require(refunded[msg.sender] == false);\n', '\n', '    uint balance = token.balanceOf(msg.sender);\n', '    require(balance > 0);\n', '\n', '    uint refund = balance.div(price);\n', '    if (refund > this.balance) {\n', '      refund = this.balance;\n', '    }\n', '\n', '    assert(msg.sender.send(refund));\n', '    refunded[msg.sender] = true;\n', '    weiRefunded = weiRefunded.add(refund);\n', '    Refunded(msg.sender, refund);\n', '  }\n', '\n', '  function withdraw() onlyOwner {\n', '    require(softCapReached);\n', '    assert(beneficiary.send(collected));\n', '    token.transfer(beneficiary, token.balanceOf(this));\n', '    crowdsaleFinished = true;\n', '  }\n', '\n', '  function doPurchase(address _owner) private preSaleActive inNormalState {\n', '\n', '    require(!crowdsaleFinished);\n', '    require(collected.add(msg.value) <= hardCap);\n', '\n', '    if (!softCapReached && collected < softCap && collected.add(msg.value) >= softCap) {\n', '      softCapReached = true;\n', '      SoftCapReached(softCap);\n', '    }\n', '    uint tokens = msg.value * price;\n', '    require(token.balanceOf(msg.sender).add(tokens) <= purchaseLimit);\n', '\n', '    if (token.balanceOf(msg.sender) == 0) investorCount++;\n', '\n', '    collected = collected.add(msg.value);\n', '\n', '    token.transfer(msg.sender, tokens);\n', '\n', '    tokensSold = tokensSold.add(tokens);\n', '\n', '    NewContribution(_owner, tokens, msg.value);\n', '\n', '    if (collected == hardCap) {\n', '      GoalReached(hardCap);\n', '    }\n', '  }\n', '}']