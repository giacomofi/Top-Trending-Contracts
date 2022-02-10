['pragma solidity ^0.4.21;\n', '\n', '// ----------------- \n', '//begin SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    // Gas optimization: this is cheaper than asserting &#39;a&#39; not being zero, but the\n', '    // benefit is lost if &#39;b&#39; is also tested.\n', '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '//end SafeMath.sol\n', '// ----------------- \n', '//begin Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '//end Ownable.sol\n', '// ----------------- \n', '//begin ERC20Basic.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * See https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '//end ERC20Basic.sol\n', '// ----------------- \n', '//begin Pausable.sol\n', '\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', '//end Pausable.sol\n', '// ----------------- \n', '//begin ERC20.sol\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    public returns (bool);\n', '\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '//end ERC20.sol\n', '// ----------------- \n', '//begin BasicToken.sol\n', '\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev Total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '//end BasicToken.sol\n', '// ----------------- \n', '//begin StandardToken.sol\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * https://github.com/ethereum/EIPs/issues/20\n', ' * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(\n', '    address _owner,\n', '    address _spender\n', '   )\n', '    public\n', '    view\n', '    returns (uint256)\n', '  {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(\n', '    address _spender,\n', '    uint256 _addedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    allowed[msg.sender][_spender] = (\n', '      allowed[msg.sender][_spender].add(_addedValue));\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(\n', '    address _spender,\n', '    uint256 _subtractedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    uint256 oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '//end StandardToken.sol\n', '// ----------------- \n', '//begin SafeERC20.sol\n', '\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '  function safeTransfer(ERC20Basic token, address to, uint256 value) internal {\n', '    require(token.transfer(to, value));\n', '  }\n', '\n', '  function safeTransferFrom(\n', '    ERC20 token,\n', '    address from,\n', '    address to,\n', '    uint256 value\n', '  )\n', '    internal\n', '  {\n', '    require(token.transferFrom(from, to, value));\n', '  }\n', '\n', '  function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '    require(token.approve(spender, value));\n', '  }\n', '}\n', '\n', '//end SafeERC20.sol\n', '// ----------------- \n', '//begin PausableToken.sol\n', '\n', '\n', '/**\n', ' * @title Pausable token\n', ' * @dev StandardToken modified with pausable transfers.\n', ' **/\n', 'contract PausableToken is StandardToken, Pausable {\n', '\n', '  function transfer(\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool)\n', '  {\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool)\n', '  {\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  function approve(\n', '    address _spender,\n', '    uint256 _value\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool)\n', '  {\n', '    return super.approve(_spender, _value);\n', '  }\n', '\n', '  function increaseApproval(\n', '    address _spender,\n', '    uint _addedValue\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool success)\n', '  {\n', '    return super.increaseApproval(_spender, _addedValue);\n', '  }\n', '\n', '  function decreaseApproval(\n', '    address _spender,\n', '    uint _subtractedValue\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool success)\n', '  {\n', '    return super.decreaseApproval(_spender, _subtractedValue);\n', '  }\n', '}\n', '\n', '//end PausableToken.sol\n', '// ----------------- \n', '//begin Crowdsale.sol\n', '\n', '\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale,\n', ' * allowing investors to purchase tokens with ether. This contract implements\n', ' * such functionality in its most fundamental form and can be extended to provide additional\n', ' * functionality and/or custom behavior.\n', ' * The external interface represents the basic interface for purchasing tokens, and conform\n', ' * the base architecture for crowdsales. They are *not* intended to be modified / overriden.\n', ' * The internal interface conforms the extensible and modifiable surface of crowdsales. Override\n', ' * the methods to add functionality. Consider using &#39;super&#39; where appropiate to concatenate\n', ' * behavior.\n', ' */\n', 'contract Crowdsale {\n', '  using SafeMath for uint256;\n', '  using SafeERC20 for ERC20;\n', '\n', '  // The token being sold\n', '  ERC20 public token;\n', '\n', '  // Address where funds are collected\n', '  address public wallet;\n', '\n', '  // How many token units a buyer gets per wei.\n', '  // The rate is the conversion between wei and the smallest and indivisible token unit.\n', '  // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK\n', '  // 1 wei will give you 1 unit, or 0.001 TOK.\n', '  uint256 public rate;\n', '\n', '  // Amount of wei raised\n', '  uint256 public weiRaised;\n', '\n', '  /**\n', '   * Event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(\n', '    address indexed purchaser,\n', '    address indexed beneficiary,\n', '    uint256 value,\n', '    uint256 amount\n', '  );\n', '\n', '  /**\n', '   * @param _rate Number of token units a buyer gets per wei\n', '   * @param _wallet Address where collected funds will be forwarded to\n', '   * @param _token Address of the token being sold\n', '   */\n', '  constructor(uint256 _rate, address _wallet, ERC20 _token) public {\n', '    require(_rate > 0);\n', '    require(_wallet != address(0));\n', '    require(_token != address(0));\n', '\n', '    rate = _rate;\n', '    wallet = _wallet;\n', '    token = _token;\n', '  }\n', '\n', '  // -----------------------------------------\n', '  // Crowdsale external interface\n', '  // -----------------------------------------\n', '\n', '  /**\n', '   * @dev fallback function ***DO NOT OVERRIDE***\n', '   */\n', '  function () external payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  /**\n', '   * @dev low level token purchase ***DO NOT OVERRIDE***\n', '   * @param _beneficiary Address performing the token purchase\n', '   */\n', '  function buyTokens(address _beneficiary) public payable {\n', '\n', '    uint256 weiAmount = msg.value;\n', '    _preValidatePurchase(_beneficiary, weiAmount);\n', '\n', '    // calculate token amount to be created\n', '    uint256 tokens = _getTokenAmount(weiAmount);\n', '\n', '    // update state\n', '    weiRaised = weiRaised.add(weiAmount);\n', '\n', '    _processPurchase(_beneficiary, tokens);\n', '    emit TokenPurchase(\n', '      msg.sender,\n', '      _beneficiary,\n', '      weiAmount,\n', '      tokens\n', '    );\n', '\n', '    _updatePurchasingState(_beneficiary, weiAmount);\n', '\n', '    _forwardFunds();\n', '    _postValidatePurchase(_beneficiary, weiAmount);\n', '  }\n', '\n', '  // -----------------------------------------\n', '  // Internal interface (extensible)\n', '  // -----------------------------------------\n', '\n', '  /**\n', '   * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.\n', '   * @param _beneficiary Address performing the token purchase\n', '   * @param _weiAmount Value in wei involved in the purchase\n', '   */\n', '  function _preValidatePurchase(\n', '    address _beneficiary,\n', '    uint256 _weiAmount\n', '  )\n', '    internal\n', '  {\n', '    require(_beneficiary != address(0));\n', '    require(_weiAmount != 0);\n', '  }\n', '\n', '  /**\n', '   * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.\n', '   * @param _beneficiary Address performing the token purchase\n', '   * @param _weiAmount Value in wei involved in the purchase\n', '   */\n', '  function _postValidatePurchase(\n', '    address _beneficiary,\n', '    uint256 _weiAmount\n', '  )\n', '    internal\n', '  {\n', '    // optional override\n', '  }\n', '\n', '  /**\n', '   * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.\n', '   * @param _beneficiary Address performing the token purchase\n', '   * @param _tokenAmount Number of tokens to be emitted\n', '   */\n', '  function _deliverTokens(\n', '    address _beneficiary,\n', '    uint256 _tokenAmount\n', '  )\n', '    internal\n', '  {\n', '    token.safeTransfer(_beneficiary, _tokenAmount);\n', '  }\n', '\n', '  /**\n', '   * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.\n', '   * @param _beneficiary Address receiving the tokens\n', '   * @param _tokenAmount Number of tokens to be purchased\n', '   */\n', '  function _processPurchase(\n', '    address _beneficiary,\n', '    uint256 _tokenAmount\n', '  )\n', '    internal\n', '  {\n', '    _deliverTokens(_beneficiary, _tokenAmount);\n', '  }\n', '\n', '  /**\n', '   * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)\n', '   * @param _beneficiary Address receiving the tokens\n', '   * @param _weiAmount Value in wei involved in the purchase\n', '   */\n', '  function _updatePurchasingState(\n', '    address _beneficiary,\n', '    uint256 _weiAmount\n', '  )\n', '    internal\n', '  {\n', '    // optional override\n', '  }\n', '\n', '  /**\n', '   * @dev Override to extend the way in which ether is converted to tokens.\n', '   * @param _weiAmount Value in wei to be converted into tokens\n', '   * @return Number of tokens that can be purchased with the specified _weiAmount\n', '   */\n', '  function _getTokenAmount(uint256 _weiAmount)\n', '    internal view returns (uint256)\n', '  {\n', '    return _weiAmount.mul(rate);\n', '  }\n', '\n', '  /**\n', '   * @dev Determines how ETH is stored/forwarded on purchases.\n', '   */\n', '  function _forwardFunds() internal {\n', '    wallet.transfer(msg.value);\n', '  }\n', '}\n', '//end Crowdsale.sol\n', '// ----------------- \n', '//begin MintableToken.sol\n', '\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', 'contract MintableToken is StandardToken, Ownable {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  modifier hasMintPermission() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(\n', '    address _to,\n', '    uint256 _amount\n', '  )\n', '    hasMintPermission\n', '    canMint\n', '    public\n', '    returns (bool)\n', '  {\n', '    totalSupply_ = totalSupply_.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    emit Mint(_to, _amount);\n', '    emit Transfer(address(0), _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner canMint public returns (bool) {\n', '    mintingFinished = true;\n', '    emit MintFinished();\n', '    return true;\n', '  }\n', '}\n', '\n', '//end MintableToken.sol\n', '// ----------------- \n', '//begin MintedCrowdsale.sol\n', '\n', '\n', '/**\n', ' * @title MintedCrowdsale\n', ' * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.\n', ' * Token ownership should be transferred to MintedCrowdsale for minting.\n', ' */\n', 'contract MintedCrowdsale is Crowdsale {\n', '\n', '  /**\n', '   * @dev Overrides delivery by minting tokens upon purchase.\n', '   * @param _beneficiary Token purchaser\n', '   * @param _tokenAmount Number of tokens to be minted\n', '   */\n', '  function _deliverTokens(\n', '    address _beneficiary,\n', '    uint256 _tokenAmount\n', '  )\n', '    internal\n', '  {\n', '    require(MintableToken(token).mint(_beneficiary, _tokenAmount));\n', '  }\n', '}\n', '\n', '//end MintedCrowdsale.sol\n', '// ----------------- \n', '//begin TimedCrowdsale.sol\n', '\n', '\n', '/**\n', ' * @title TimedCrowdsale\n', ' * @dev Crowdsale accepting contributions only within a time frame.\n', ' */\n', 'contract TimedCrowdsale is Crowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  uint256 public openingTime;\n', '  uint256 public closingTime;\n', '\n', '  /**\n', '   * @dev Reverts if not in crowdsale time range.\n', '   */\n', '  modifier onlyWhileOpen {\n', '    // solium-disable-next-line security/no-block-members\n', '    require(block.timestamp >= openingTime && block.timestamp <= closingTime);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Constructor, takes crowdsale opening and closing times.\n', '   * @param _openingTime Crowdsale opening time\n', '   * @param _closingTime Crowdsale closing time\n', '   */\n', '  constructor(uint256 _openingTime, uint256 _closingTime) public {\n', '    // solium-disable-next-line security/no-block-members\n', '    require(_openingTime >= block.timestamp);\n', '    require(_closingTime >= _openingTime);\n', '\n', '    openingTime = _openingTime;\n', '    closingTime = _closingTime;\n', '  }\n', '\n', '  /**\n', '   * @dev Checks whether the period in which the crowdsale is open has already elapsed.\n', '   * @return Whether crowdsale period has elapsed\n', '   */\n', '  function hasClosed() public view returns (bool) {\n', '    // solium-disable-next-line security/no-block-members\n', '    return block.timestamp > closingTime;\n', '  }\n', '\n', '  /**\n', '   * @dev Extend parent behavior requiring to be within contributing period\n', '   * @param _beneficiary Token purchaser\n', '   * @param _weiAmount Amount of wei contributed\n', '   */\n', '  function _preValidatePurchase(\n', '    address _beneficiary,\n', '    uint256 _weiAmount\n', '  )\n', '    internal\n', '    onlyWhileOpen\n', '  {\n', '    super._preValidatePurchase(_beneficiary, _weiAmount);\n', '  }\n', '\n', '}\n', '\n', '//end TimedCrowdsale.sol\n', '// ----------------- \n', '//begin FinalizableCrowdsale.sol\n', '\n', '\n', '/**\n', ' * @title FinalizableCrowdsale\n', ' * @dev Extension of Crowdsale where an owner can do extra work\n', ' * after finishing.\n', ' */\n', 'contract FinalizableCrowdsale is TimedCrowdsale, Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  bool public isFinalized = false;\n', '\n', '  event Finalized();\n', '\n', '  /**\n', '   * @dev Must be called after crowdsale ends, to do some extra finalization\n', '   * work. Calls the contract&#39;s finalization function.\n', '   */\n', '  function finalize() onlyOwner public {\n', '    require(!isFinalized);\n', '    require(hasClosed());\n', '\n', '    finalization();\n', '    emit Finalized();\n', '\n', '    isFinalized = true;\n', '  }\n', '\n', '  /**\n', '   * @dev Can be overridden to add finalization logic. The overriding function\n', '   * should call super.finalization() to ensure the chain of finalization is\n', '   * executed entirely.\n', '   */\n', '  function finalization() internal {\n', '  }\n', '\n', '}\n', '\n', '//end FinalizableCrowdsale.sol\n', '// ----------------- \n', '//begin TimedPresaleCrowdsale.sol\n', '\n', 'contract TimedPresaleCrowdsale is FinalizableCrowdsale {\n', '    using SafeMath for uint256;\n', '\n', '    uint256 public presaleOpeningTime;\n', '    uint256 public presaleClosingTime;\n', '\n', '    uint256 public bonusUnlockTime;\n', '\n', '    event CrowdsaleTimesChanged(uint256 presaleOpeningTime, uint256 presaleClosingTime, uint256 openingTime, uint256 closingTime);\n', '\n', '    /**\n', '     * @dev Reverts if not in crowdsale time range.\n', '     */\n', '    modifier onlyWhileOpen {\n', '        require(isPresale() || isSale());\n', '        _;\n', '    }\n', '\n', '\n', '    constructor(uint256 _presaleOpeningTime, uint256 _presaleClosingTime, uint256 _openingTime, uint256 _closingTime) public\n', '    TimedCrowdsale(_openingTime, _closingTime) {\n', '\n', '        changeTimes(_presaleOpeningTime, _presaleClosingTime, _openingTime, _closingTime);\n', '    }\n', '\n', '    function changeTimes(uint256 _presaleOpeningTime, uint256 _presaleClosingTime, uint256 _openingTime, uint256 _closingTime) public onlyOwner {\n', '        require(!isFinalized);\n', '        require(_presaleClosingTime >= _presaleOpeningTime);\n', '        require(_openingTime >= _presaleClosingTime);\n', '        require(_closingTime >= _openingTime);\n', '\n', '        presaleOpeningTime = _presaleOpeningTime;\n', '        presaleClosingTime = _presaleClosingTime;\n', '        openingTime = _openingTime;\n', '        closingTime = _closingTime;\n', '\n', '        emit CrowdsaleTimesChanged(_presaleOpeningTime, _presaleClosingTime, _openingTime, _closingTime);\n', '    }\n', '\n', '    function isPresale() public view returns (bool) {\n', '        return now >= presaleOpeningTime && now <= presaleClosingTime;\n', '    }\n', '\n', '    function isSale() public view returns (bool) {\n', '        return now >= openingTime && now <= closingTime;\n', '    }\n', '}\n', '\n', '//end TimedPresaleCrowdsale.sol\n', '// ----------------- \n', '//begin TokenCappedCrowdsale.sol\n', '\n', '\n', '\n', 'contract TokenCappedCrowdsale is FinalizableCrowdsale {\n', '    using SafeMath for uint256;\n', '\n', '    uint256 public cap;\n', '    uint256 public totalTokens;\n', '    uint256 public soldTokens = 0;\n', '    bool public capIncreased = false;\n', '\n', '    event CapIncreased();\n', '\n', '    constructor() public {\n', '\n', '        cap = 400 * 1000 * 1000 * 1 ether;\n', '        totalTokens = 750 * 1000 * 1000 * 1 ether;\n', '    }\n', '\n', '    function notExceedingSaleCap(uint256 amount) internal view returns (bool) {\n', '        return cap >= amount.add(soldTokens);\n', '    }\n', '\n', '    /**\n', '    * Finalization logic. We take the expected sale cap\n', '    * ether and find the difference from the actual minted tokens.\n', '    * The remaining balance and the reserved amount for the team are minted\n', '    * to the team wallet.\n', '    */\n', '    function finalization() internal {\n', '        super.finalization();\n', '    }\n', '}\n', '\n', '//end TokenCappedCrowdsale.sol\n', '// ----------------- \n', '//begin OpiriaCrowdsale.sol\n', '\n', 'contract OpiriaCrowdsale is TimedPresaleCrowdsale, MintedCrowdsale, TokenCappedCrowdsale {\n', '    using SafeMath for uint256;\n', '\n', '    uint256 public presaleWeiLimit;\n', '\n', '    address public tokensWallet;\n', '\n', '    uint256 public totalBonus = 0;\n', '\n', '    bool public hiddenCapTriggered;\n', '\n', '    uint16 public additionalBonusPercent = 0;\n', '\n', '    mapping(address => uint256) public bonusOf;\n', '\n', '    // Crowdsale(uint256 _rate, address _wallet, ERC20 _token)\n', '    constructor(ERC20 _token, uint16 _initialEtherUsdRate, address _wallet, address _tokensWallet,\n', '        uint256 _presaleOpeningTime, uint256 _presaleClosingTime, uint256 _openingTime, uint256 _closingTime\n', '    ) public\n', '    TimedPresaleCrowdsale(_presaleOpeningTime, _presaleClosingTime, _openingTime, _closingTime)\n', '    Crowdsale(_initialEtherUsdRate, _wallet, _token) {\n', '        setEtherUsdRate(_initialEtherUsdRate);\n', '        tokensWallet = _tokensWallet;\n', '\n', '        require(PausableToken(token).paused());\n', '    }\n', '\n', '    //overridden\n', '    function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {\n', '        // 1 ether * etherUsdRate * 10\n', '\n', '        return _weiAmount.mul(rate).mul(10);\n', '    }\n', '\n', '    function _getBonusAmount(uint256 tokens) internal view returns (uint256) {\n', '        uint16 bonusPercent = _getBonusPercent();\n', '        uint256 bonusAmount = tokens.mul(bonusPercent).div(100);\n', '        return bonusAmount;\n', '    }\n', '\n', '    function _getBonusPercent() internal view returns (uint16) {\n', '        if (isPresale()) {\n', '            return 20;\n', '        }\n', '        uint256 daysPassed = (now - openingTime) / 1 days;\n', '        uint16 calcPercent = 0;\n', '        if (daysPassed < 15) {\n', '            // daysPassed will be less than 15 so no worries about overflow here\n', '            calcPercent = (15 - uint8(daysPassed));\n', '        }\n', '\n', '        calcPercent = additionalBonusPercent + calcPercent;\n', '\n', '        return calcPercent;\n', '    }\n', '\n', '    //overridden\n', '    function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {\n', '        _saveBonus(_beneficiary, _tokenAmount);\n', '        _deliverTokens(_beneficiary, _tokenAmount);\n', '\n', '        soldTokens = soldTokens.add(_tokenAmount);\n', '    }\n', '\n', '    function _saveBonus(address _beneficiary, uint256 tokens) internal {\n', '        uint256 bonusAmount = _getBonusAmount(tokens);\n', '        if (bonusAmount > 0) {\n', '            totalBonus = totalBonus.add(bonusAmount);\n', '            soldTokens = soldTokens.add(bonusAmount);\n', '            bonusOf[_beneficiary] = bonusOf[_beneficiary].add(bonusAmount);\n', '        }\n', '    }\n', '\n', '    //overridden\n', '    function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {\n', '        super._preValidatePurchase(_beneficiary, _weiAmount);\n', '        if (isPresale()) {\n', '            require(_weiAmount >= presaleWeiLimit);\n', '        }\n', '\n', '        uint256 tokens = _getTokenAmount(_weiAmount);\n', '        uint256 bonusTokens = _getBonusAmount(tokens);\n', '        require(notExceedingSaleCap(tokens.add(bonusTokens)));\n', '    }\n', '\n', '    function setEtherUsdRate(uint16 _etherUsdRate) public onlyOwner {\n', '        rate = _etherUsdRate;\n', '\n', '        // the presaleWeiLimit must be $5000 in eth at the defined &#39;etherUsdRate&#39;\n', '        // presaleWeiLimit = 1 ether / etherUsdRate * 5000\n', '        presaleWeiLimit = uint256(1 ether).mul(2500).div(rate);\n', '    }\n', '\n', '    function setAdditionalBonusPercent(uint8 _additionalBonusPercent) public onlyOwner {\n', '        additionalBonusPercent = _additionalBonusPercent;\n', '    }\n', '    /**\n', '    * Send tokens by the owner directly to an address.\n', '    */\n', '    function sendTokensTo(uint256 amount, address to) public onlyOwner {\n', '        require(!isFinalized);\n', '        require(notExceedingSaleCap(amount));\n', '\n', '        require(MintableToken(token).mint(to, amount));\n', '        soldTokens = soldTokens.add(amount);\n', '\n', '        emit TokenPurchase(msg.sender, to, 0, amount);\n', '    }\n', '\n', '    function sendTokensToBatch(uint256[] amounts, address[] recipients) public onlyOwner {\n', '        require(amounts.length == recipients.length);\n', '        for (uint i = 0; i < recipients.length; i++) {\n', '            sendTokensTo(amounts[i], recipients[i]);\n', '        }\n', '    }\n', '\n', '    function addBonusBatch(uint256[] amounts, address[] recipients) public onlyOwner {\n', '\n', '        for (uint i = 0; i < recipients.length; i++) {\n', '            require(PausableToken(token).balanceOf(recipients[i]) > 0);\n', '            require(notExceedingSaleCap(amounts[i]));\n', '\n', '            totalBonus = totalBonus.add(amounts[i]);\n', '            soldTokens = soldTokens.add(amounts[i]);\n', '            bonusOf[recipients[i]] = bonusOf[recipients[i]].add(amounts[i]);\n', '        }\n', '    }\n', '\n', '    function unlockTokenTransfers() public onlyOwner {\n', '        require(isFinalized);\n', '        require(now > closingTime + 30 days);\n', '        require(PausableToken(token).paused());\n', '        bonusUnlockTime = now + 30 days;\n', '        PausableToken(token).unpause();\n', '    }\n', '\n', '\n', '    function distributeBonus(address[] addresses) public onlyOwner {\n', '        require(now > bonusUnlockTime);\n', '        for (uint i = 0; i < addresses.length; i++) {\n', '            if (bonusOf[addresses[i]] > 0) {\n', '                uint256 bonusAmount = bonusOf[addresses[i]];\n', '                _deliverTokens(addresses[i], bonusAmount);\n', '                totalBonus = totalBonus.sub(bonusAmount);\n', '                bonusOf[addresses[i]] = 0;\n', '            }\n', '        }\n', '        if (totalBonus == 0 && reservedTokensClaimStage == 3) {\n', '            MintableToken(token).finishMinting();\n', '        }\n', '    }\n', '\n', '    function withdrawBonus() public {\n', '        require(now > bonusUnlockTime);\n', '        require(bonusOf[msg.sender] > 0);\n', '\n', '        _deliverTokens(msg.sender, bonusOf[msg.sender]);\n', '        totalBonus = totalBonus.sub(bonusOf[msg.sender]);\n', '        bonusOf[msg.sender] = 0;\n', '\n', '        if (totalBonus == 0 && reservedTokensClaimStage == 3) {\n', '            MintableToken(token).finishMinting();\n', '        }\n', '    }\n', '\n', '\n', '    function finalization() internal {\n', '        super.finalization();\n', '\n', '        // mint 25% of total Tokens (13% for development, 5% for company/team, 6% for advisors, 2% bounty) into team wallet\n', '        uint256 toMintNow = totalTokens.mul(25).div(100);\n', '\n', '        if (!capIncreased) {\n', '            // if the cap didn&#39;t increase (according to whitepaper) mint the 50MM tokens to the team wallet too\n', '            toMintNow = toMintNow.add(50 * 1000 * 1000);\n', '        }\n', '        _deliverTokens(tokensWallet, toMintNow);\n', '    }\n', '\n', '    uint8 public reservedTokensClaimStage = 0;\n', '\n', '    function claimReservedTokens() public onlyOwner {\n', '\n', '        uint256 toMintNow = totalTokens.mul(5).div(100);\n', '        if (reservedTokensClaimStage == 0) {\n', '            require(now > closingTime + 6 * 30 days);\n', '            reservedTokensClaimStage = 1;\n', '            _deliverTokens(tokensWallet, toMintNow);\n', '        }\n', '        else if (reservedTokensClaimStage == 1) {\n', '            require(now > closingTime + 12 * 30 days);\n', '            reservedTokensClaimStage = 2;\n', '            _deliverTokens(tokensWallet, toMintNow);\n', '        }\n', '        else if (reservedTokensClaimStage == 2) {\n', '            require(now > closingTime + 24 * 30 days);\n', '            reservedTokensClaimStage = 3;\n', '            _deliverTokens(tokensWallet, toMintNow);\n', '            if (totalBonus == 0) {\n', '                MintableToken(token).finishMinting();\n', '                MintableToken(token).transferOwnership(owner);\n', '            }\n', '        }\n', '        else {\n', '            revert();\n', '        }\n', '    }\n', '\n', '    function increaseCap() public onlyOwner {\n', '        require(!capIncreased);\n', '        require(!isFinalized);\n', '        require(now < openingTime + 5 days);\n', '\n', '        capIncreased = true;\n', '        cap = cap.add(50 * 1000 * 1000);\n', '        emit CapIncreased();\n', '    }\n', '\n', '    function triggerHiddenCap() public onlyOwner {\n', '        require(!hiddenCapTriggered);\n', '        require(now > presaleOpeningTime);\n', '        require(now < presaleClosingTime);\n', '\n', '        presaleClosingTime = now;\n', '        openingTime = now + 24 hours;\n', '\n', '        hiddenCapTriggered = true;\n', '    }\n', '}\n', '\n', '//end OpiriaCrowdsale.sol']