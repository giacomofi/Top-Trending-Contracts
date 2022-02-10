['pragma solidity ^0.4.18;\n', '\n', '// File: zeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', 'contract MintableToken is StandardToken, Ownable {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '    totalSupply_ = totalSupply_.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    Transfer(address(0), _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner canMint public returns (bool) {\n', '    mintingFinished = true;\n', '    MintFinished();\n', '    return true;\n', '  }\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20/CappedToken.sol\n', '\n', '/**\n', ' * @title Capped token\n', ' * @dev Mintable token with a token cap.\n', ' */\n', 'contract CappedToken is MintableToken {\n', '\n', '  uint256 public cap;\n', '\n', '  function CappedToken(uint256 _cap) public {\n', '    require(_cap > 0);\n', '    cap = _cap;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '    require(totalSupply_.add(_amount) <= cap);\n', '\n', '    return super.mint(_to, _amount);\n', '  }\n', '\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/lifecycle/Pausable.sol\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    Unpause();\n', '  }\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20/PausableToken.sol\n', '\n', '/**\n', ' * @title Pausable token\n', ' * @dev StandardToken modified with pausable transfers.\n', ' **/\n', 'contract PausableToken is StandardToken, Pausable {\n', '\n', '  function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.approve(_spender, _value);\n', '  }\n', '\n', '  function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {\n', '    return super.increaseApproval(_spender, _addedValue);\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {\n', '    return super.decreaseApproval(_spender, _subtractedValue);\n', '  }\n', '}\n', '\n', '// File: contracts/MeshToken.sol\n', '\n', '/**\n', ' * CappedToken token is Mintable token with a max cap on totalSupply that can ever be minted.\n', ' * PausableToken overrides all transfers methods and adds a modifier to check if paused is set to false.\n', ' */\n', 'contract MeshToken is CappedToken, PausableToken {\n', '  string public name = "RightMesh Token";\n', '  string public symbol = "RMESH";\n', '  uint256 public decimals = 18;\n', '  uint256 public cap = 129498559 ether;\n', '\n', '  /**\n', '   * @dev variable to keep track of what addresses are allowed to call transfer functions when token is paused.\n', '   */\n', '  mapping (address => bool) public allowedTransfers;\n', '\n', '  /*------------------------------------constructor------------------------------------*/\n', '  /**\n', '   * @dev constructor for mesh token\n', '   */\n', '  function MeshToken() CappedToken(cap) public {\n', '    paused = true;\n', '  }\n', '\n', '  /*------------------------------------overridden methods------------------------------------*/\n', '  /**\n', '   * @dev Overridder modifier to allow exceptions for pausing for a given address\n', '   * This modifier is added to all transfer methods by PausableToken and only allows if paused is set to false.\n', '   * With this override the function allows either if paused is set to false or msg.sender is allowedTransfers during the pause as well.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused || allowedTransfers[msg.sender]);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev overriding Pausable#pause method to do nothing\n', '   * Paused is set to true in the constructor itself, making the token non-transferrable on deploy.\n', '   * once unpaused the contract cannot be paused again.\n', '   * adding this to limit owner&#39;s ability to pause the token in future.\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {}\n', '\n', '  /**\n', '   * @dev modifier created to prevent short address attack problems.\n', '   * solution based on this blog post https://blog.coinfabrik.com/smart-contract-short-address-attack-mitigation-failure\n', '   */\n', '  modifier onlyPayloadSize(uint size) {\n', '    assert(msg.data.length >= size + 4);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev overriding transfer method to include the onlyPayloadSize check modifier\n', '   */\n', '  function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool) {\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  /**\n', '   * @dev overriding transferFrom method to include the onlyPayloadSize check modifier\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) public returns (bool) {\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  /**\n', '   * @dev overriding approve method to include the onlyPayloadSize check modifier\n', '   */\n', '  function approve(address _spender, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool) {\n', '    return super.approve(_spender, _value);\n', '  }\n', '\n', '  /**\n', '   * @dev overriding increaseApproval method to include the onlyPayloadSize check modifier\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) onlyPayloadSize(2 * 32) public returns (bool) {\n', '    return super.increaseApproval(_spender, _addedValue);\n', '  }\n', '\n', '  /**\n', '   * @dev overriding decreaseApproval method to include the onlyPayloadSize check modifier\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) onlyPayloadSize(2 * 32) public returns (bool) {\n', '    return super.decreaseApproval(_spender, _subtractedValue);\n', '  }\n', '\n', '  /**\n', '   * @dev overriding mint method to include the onlyPayloadSize check modifier\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint onlyPayloadSize(2 * 32) public returns (bool) {\n', '    return super.mint(_to, _amount);\n', '  }\n', '\n', '  /*------------------------------------new methods------------------------------------*/\n', '\n', '  /**\n', '   * @dev method to updated allowedTransfers for an address\n', '   * @param _address that needs to be updated\n', '   * @param _allowedTransfers indicating if transfers are allowed or not\n', '   * @return boolean indicating function success.\n', '   */\n', '  function updateAllowedTransfers(address _address, bool _allowedTransfers)\n', '  external\n', '  onlyOwner\n', '  returns (bool)\n', '  {\n', '    // don&#39;t allow owner to change this for themselves\n', '    // otherwise whenNotPaused will not work as expected for owner,\n', '    // therefore prohibiting them from calling pause/unpause.\n', '    require(_address != owner);\n', '\n', '    allowedTransfers[_address] = _allowedTransfers;\n', '    return true;\n', '  }\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol\n', '\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale.\n', ' * Crowdsales have a start and end timestamps, where investors can make\n', ' * token purchases and the crowdsale will assign them tokens based\n', ' * on a token per ETH rate. Funds collected are forwarded to a wallet\n', ' * as they arrive. The contract requires a MintableToken that will be\n', ' * minted as contributions arrive, note that the crowdsale contract\n', ' * must be owner of the token in order to be able to mint it.\n', ' */\n', 'contract Crowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  // The token being sold\n', '  MintableToken public token;\n', '\n', '  // start and end timestamps where investments are allowed (both inclusive)\n', '  uint256 public startTime;\n', '  uint256 public endTime;\n', '\n', '  // address where funds are collected\n', '  address public wallet;\n', '\n', '  // how many token units a buyer gets per wei\n', '  uint256 public rate;\n', '\n', '  // amount of raised money in wei\n', '  uint256 public weiRaised;\n', '\n', '  /**\n', '   * event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '\n', '  function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, MintableToken _token) public {\n', '    require(_startTime >= now);\n', '    require(_endTime >= _startTime);\n', '    require(_rate > 0);\n', '    require(_wallet != address(0));\n', '    require(_token != address(0));\n', '\n', '    startTime = _startTime;\n', '    endTime = _endTime;\n', '    rate = _rate;\n', '    wallet = _wallet;\n', '    token = _token;\n', '  }\n', '\n', '  // fallback function can be used to buy tokens\n', '  function () external payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  // low level token purchase function\n', '  function buyTokens(address beneficiary) public payable {\n', '    require(beneficiary != address(0));\n', '    require(validPurchase());\n', '\n', '    uint256 weiAmount = msg.value;\n', '\n', '    // calculate token amount to be created\n', '    uint256 tokens = getTokenAmount(weiAmount);\n', '\n', '    // update state\n', '    weiRaised = weiRaised.add(weiAmount);\n', '\n', '    token.mint(beneficiary, tokens);\n', '    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '\n', '    forwardFunds();\n', '  }\n', '\n', '  // @return true if crowdsale event has ended\n', '  function hasEnded() public view returns (bool) {\n', '    return now > endTime;\n', '  }\n', '\n', '  // Override this method to have a way to add business logic to your crowdsale when buying\n', '  function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {\n', '    return weiAmount.mul(rate);\n', '  }\n', '\n', '  // send ether to the fund collection wallet\n', '  // override to create custom fund forwarding mechanisms\n', '  function forwardFunds() internal {\n', '    wallet.transfer(msg.value);\n', '  }\n', '\n', '  // @return true if the transaction can buy tokens\n', '  function validPurchase() internal view returns (bool) {\n', '    bool withinPeriod = now >= startTime && now <= endTime;\n', '    bool nonZeroPurchase = msg.value != 0;\n', '    return withinPeriod && nonZeroPurchase;\n', '  }\n', '\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/crowdsale/CappedCrowdsale.sol\n', '\n', '/**\n', ' * @title CappedCrowdsale\n', ' * @dev Extension of Crowdsale with a max amount of funds raised\n', ' */\n', 'contract CappedCrowdsale is Crowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  uint256 public cap;\n', '\n', '  function CappedCrowdsale(uint256 _cap) public {\n', '    require(_cap > 0);\n', '    cap = _cap;\n', '  }\n', '\n', '  // overriding Crowdsale#hasEnded to add cap logic\n', '  // @return true if crowdsale event has ended\n', '  function hasEnded() public view returns (bool) {\n', '    bool capReached = weiRaised >= cap;\n', '    return capReached || super.hasEnded();\n', '  }\n', '\n', '  // overriding Crowdsale#validPurchase to add extra cap logic\n', '  // @return true if investors can buy at the moment\n', '  function validPurchase() internal view returns (bool) {\n', '    bool withinCap = weiRaised.add(msg.value) <= cap;\n', '    return withinCap && super.validPurchase();\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/MeshCrowdsale.sol\n', '\n', '/**\n', ' * CappedCrowdsale limits the total number of wei that can be collected in the sale.\n', ' */\n', 'contract MeshCrowdsale is CappedCrowdsale, Ownable {\n', '\n', '  using SafeMath for uint256;\n', '\n', '  /**\n', '   * @dev weiLimits keeps track of amount of wei that can be contibuted by an address.\n', '   */\n', '  mapping (address => uint256) public weiLimits;\n', '\n', '  /**\n', '   * @dev weiContributions keeps track of amount of wei that are contibuted by an address.\n', '   */\n', '  mapping (address => uint256) public weiContributions;\n', '\n', '  /**\n', '   * @dev whitelistingAgents keeps track of who is allowed to call the setLimit method\n', '   */\n', '  mapping (address => bool) public whitelistingAgents;\n', '\n', '  /**\n', '   * @dev minimumContribution keeps track of what should be the minimum contribution required per address\n', '   */\n', '  uint256 public minimumContribution;\n', '\n', '  /**\n', '   * @dev variable to keep track of beneficiaries for which we need to mint the tokens directly\n', '   */\n', '  address[] public beneficiaries;\n', '\n', '  /**\n', '   * @dev variable to keep track of amount of tokens to mint for beneficiaries\n', '   */\n', '  uint256[] public beneficiaryAmounts;\n', '\n', '  /**\n', '   * @dev variable to keep track of if predefined tokens have been minted\n', '   */\n', '  bool public mintingFinished;\n', '  /*---------------------------------constructor---------------------------------*/\n', '\n', '  /**\n', '   * @dev Constructor for MeshCrowdsale contract\n', '   */\n', '  function MeshCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, uint256 _cap, uint256 _minimumContribution, MeshToken _token, address[] _beneficiaries, uint256[] _beneficiaryAmounts)\n', '  CappedCrowdsale(_cap)\n', '  Crowdsale(_startTime, _endTime, _rate, _wallet, _token)\n', '  public\n', '  {\n', '    require(_beneficiaries.length == _beneficiaryAmounts.length);\n', '    beneficiaries = _beneficiaries;\n', '    beneficiaryAmounts = _beneficiaryAmounts;\n', '    mintingFinished = false;\n', '\n', '    minimumContribution = _minimumContribution;\n', '  }\n', '\n', '  /*---------------------------------overridden methods---------------------------------*/\n', '\n', '  /**\n', '   * overriding Crowdsale#buyTokens to keep track of wei contributed per address\n', '   */\n', '  function buyTokens(address beneficiary) public payable {\n', '    weiContributions[msg.sender] = weiContributions[msg.sender].add(msg.value);\n', '    super.buyTokens(beneficiary);\n', '  }\n', '\n', '  /**\n', '   * overriding CappedCrowdsale#validPurchase to add extra contribution limit logic\n', '   * @return true if investors can buy at the moment\n', '   */\n', '  function validPurchase() internal view returns (bool) {\n', '    bool withinLimit = weiContributions[msg.sender] <= weiLimits[msg.sender];\n', '    bool atleastMinimumContribution = weiContributions[msg.sender] >= minimumContribution;\n', '    return atleastMinimumContribution && withinLimit && super.validPurchase();\n', '  }\n', '\n', '\n', '\n', '  /*---------------------------------new methods---------------------------------*/\n', '\n', '\n', '  /**\n', '   * @dev Allows owner to add / remove whitelistingAgents\n', '   * @param _address that is being allowed or removed from whitelisting addresses\n', '   * @param _value boolean indicating if address is whitelisting agent or not\n', '   */\n', '  function setWhitelistingAgent(address _address, bool _value) external onlyOwner {\n', '    whitelistingAgents[_address] = _value;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to update contribution limits\n', '   * @param _addresses whose contribution limits should be changed\n', '   * @param _weiLimit new contribution limit\n', '   */\n', '  function setLimit(address[] _addresses, uint256 _weiLimit) external {\n', '    require(whitelistingAgents[msg.sender] == true);\n', '\n', '    for (uint i = 0; i < _addresses.length; i++) {\n', '      address _address = _addresses[i];\n', '\n', '      // only allow changing the limit to be greater than current contribution\n', '      if(_weiLimit >= weiContributions[_address]) {\n', '        weiLimits[_address] = _weiLimit;\n', '      }\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to change the ETH to token generation rate.\n', '   * @param _rate indicating the new token generation rate.\n', '   */\n', '  function setRate(uint256 _rate) external onlyOwner {\n', '    // make sure the crowdsale has not started\n', '    require(weiRaised == 0 && now <= startTime);\n', '\n', '    // make sure new rate is greater than 0\n', '    require(_rate > 0);\n', '\n', '    rate = _rate;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to change the crowdsale cap.\n', '   * @param _cap indicating the new crowdsale cap.\n', '   */\n', '  function setCap(uint256 _cap) external onlyOwner {\n', '    // make sure the crowdsale has not started\n', '    require(weiRaised == 0 && now <= startTime);\n', '\n', '    // make sure new cap is greater than 0\n', '    require(_cap > 0);\n', '\n', '    cap = _cap;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to change the required minimum contribution.\n', '   * @param _minimumContribution indicating the minimum required contribution.\n', '   */\n', '  function setMinimumContribution(uint256 _minimumContribution) external onlyOwner {\n', '    minimumContribution = _minimumContribution;\n', '  }\n', '\n', '  /*\n', '   * @dev Function to perform minting to predefined beneficiaries once crowdsale has started\n', '   * can be called by only once and by owner only\n', '   */\n', '  function mintPredefinedTokens() external onlyOwner {\n', '    // prevent owner from minting twice\n', '    require(!mintingFinished);\n', '\n', '    // make sure the crowdsale has started\n', '    require(weiRaised > 0);\n', '\n', '    // loop through the list and call mint on token directly\n', '    // this minting does not affect any crowdsale numbers\n', '    for (uint i = 0; i < beneficiaries.length; i++) {\n', '      if (beneficiaries[i] != address(0) && token.balanceOf(beneficiaries[i]) == 0) {\n', '        token.mint(beneficiaries[i], beneficiaryAmounts[i]);\n', '      }\n', '    }\n', '    // set it at the end, making sure all transactions have been completed with the gas\n', '    mintingFinished = true;\n', '  }\n', '\n', '  /*---------------------------------proxy methods for token when owned by contract---------------------------------*/\n', '  /**\n', '   * @dev Allows the current owner to transfer token control back to contract owner\n', '   */\n', '  function transferTokenOwnership() external onlyOwner {\n', '    token.transferOwnership(owner);\n', '  }\n', '}']