['// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * See https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address _who) public view returns (uint256);\n', '  function transfer(address _to, uint256 _value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address _owner, address _spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value)\n', '    public returns (bool);\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', "    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (_a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = _a * _b;\n', '    assert(c / _a == _b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    // assert(_b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = _a / _b;\n', "    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold\n", '    return _a / _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    assert(_b <= _a);\n', '    return _a - _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    c = _a + _b;\n', '    assert(c >= _a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '  function safeTransfer(\n', '    ERC20Basic _token,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    internal\n', '  {\n', '    require(_token.transfer(_to, _value));\n', '  }\n', '\n', '  function safeTransferFrom(\n', '    ERC20 _token,\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    internal\n', '  {\n', '    require(_token.transferFrom(_from, _to, _value));\n', '  }\n', '\n', '  function safeApprove(\n', '    ERC20 _token,\n', '    address _spender,\n', '    uint256 _value\n', '  )\n', '    internal\n', '  {\n', '    require(_token.approve(_spender, _value));\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale,\n', ' * allowing investors to purchase tokens with ether. This contract implements\n', ' * such functionality in its most fundamental form and can be extended to provide additional\n', ' * functionality and/or custom behavior.\n', ' * The external interface represents the basic interface for purchasing tokens, and conform\n', ' * the base architecture for crowdsales. They are *not* intended to be modified / overridden.\n', ' * The internal interface conforms the extensible and modifiable surface of crowdsales. Override\n', " * the methods to add functionality. Consider using 'super' where appropriate to concatenate\n", ' * behavior.\n', ' */\n', 'contract Crowdsale {\n', '  using SafeMath for uint256;\n', '  using SafeERC20 for ERC20;\n', '\n', '  // The token being sold\n', '  ERC20 public token;\n', '\n', '  // Address where funds are collected\n', '  address public wallet;\n', '\n', '  // How many token units a buyer gets per wei.\n', '  // The rate is the conversion between wei and the smallest and indivisible token unit.\n', '  // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK\n', '  // 1 wei will give you 1 unit, or 0.001 TOK.\n', '  uint256 public rate;\n', '\n', '  // Amount of wei raised\n', '  uint256 public weiRaised;\n', '\n', '  /**\n', '   * Event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(\n', '    address indexed purchaser,\n', '    address indexed beneficiary,\n', '    uint256 value,\n', '    uint256 amount\n', '  );\n', '\n', '  /**\n', '   * @param _rate Number of token units a buyer gets per wei\n', '   * @param _wallet Address where collected funds will be forwarded to\n', '   * @param _token Address of the token being sold\n', '   */\n', '  constructor(uint256 _rate, address _wallet, ERC20 _token) public {\n', '    require(_rate > 0);\n', '    require(_wallet != address(0));\n', '    require(_token != address(0));\n', '\n', '    rate = _rate;\n', '    wallet = _wallet;\n', '    token = _token;\n', '  }\n', '\n', '  // -----------------------------------------\n', '  // Crowdsale external interface\n', '  // -----------------------------------------\n', '\n', '  /**\n', '   * @dev fallback function ***DO NOT OVERRIDE***\n', '   */\n', '  function () external payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  /**\n', '   * @dev low level token purchase ***DO NOT OVERRIDE***\n', '   * @param _beneficiary Address performing the token purchase\n', '   */\n', '  function buyTokens(address _beneficiary) public payable {\n', '\n', '    uint256 weiAmount = msg.value;\n', '    _preValidatePurchase(_beneficiary, weiAmount);\n', '\n', '    // calculate token amount to be created\n', '    uint256 tokens = _getTokenAmount(weiAmount);\n', '\n', '    // update state\n', '    weiRaised = weiRaised.add(weiAmount);\n', '\n', '    _processPurchase(_beneficiary, tokens);\n', '    emit TokenPurchase(\n', '      msg.sender,\n', '      _beneficiary,\n', '      weiAmount,\n', '      tokens\n', '    );\n', '\n', '    _updatePurchasingState(_beneficiary, weiAmount);\n', '\n', '    _forwardFunds();\n', '    _postValidatePurchase(_beneficiary, weiAmount);\n', '  }\n', '\n', '  // -----------------------------------------\n', '  // Internal interface (extensible)\n', '  // -----------------------------------------\n', '\n', '  /**\n', '   * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.\n', "   * Example from CappedCrowdsale.sol's _preValidatePurchase method: \n", '   *   super._preValidatePurchase(_beneficiary, _weiAmount);\n', '   *   require(weiRaised.add(_weiAmount) <= cap);\n', '   * @param _beneficiary Address performing the token purchase\n', '   * @param _weiAmount Value in wei involved in the purchase\n', '   */\n', '  function _preValidatePurchase(\n', '    address _beneficiary,\n', '    uint256 _weiAmount\n', '  )\n', '    internal\n', '  {\n', '    require(_beneficiary != address(0));\n', '    require(_weiAmount != 0);\n', '  }\n', '\n', '  /**\n', '   * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.\n', '   * @param _beneficiary Address performing the token purchase\n', '   * @param _weiAmount Value in wei involved in the purchase\n', '   */\n', '  function _postValidatePurchase(\n', '    address _beneficiary,\n', '    uint256 _weiAmount\n', '  )\n', '    internal\n', '  {\n', '    // optional override\n', '  }\n', '\n', '  /**\n', '   * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.\n', '   * @param _beneficiary Address performing the token purchase\n', '   * @param _tokenAmount Number of tokens to be emitted\n', '   */\n', '  function _deliverTokens(\n', '    address _beneficiary,\n', '    uint256 _tokenAmount\n', '  )\n', '    internal\n', '  {\n', '    token.safeTransfer(_beneficiary, _tokenAmount);\n', '  }\n', '\n', '  /**\n', '   * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.\n', '   * @param _beneficiary Address receiving the tokens\n', '   * @param _tokenAmount Number of tokens to be purchased\n', '   */\n', '  function _processPurchase(\n', '    address _beneficiary,\n', '    uint256 _tokenAmount\n', '  )\n', '    internal\n', '  {\n', '    _deliverTokens(_beneficiary, _tokenAmount);\n', '  }\n', '\n', '  /**\n', '   * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)\n', '   * @param _beneficiary Address receiving the tokens\n', '   * @param _weiAmount Value in wei involved in the purchase\n', '   */\n', '  function _updatePurchasingState(\n', '    address _beneficiary,\n', '    uint256 _weiAmount\n', '  )\n', '    internal\n', '  {\n', '    // optional override\n', '  }\n', '\n', '  /**\n', '   * @dev Override to extend the way in which ether is converted to tokens.\n', '   * @param _weiAmount Value in wei to be converted into tokens\n', '   * @return Number of tokens that can be purchased with the specified _weiAmount\n', '   */\n', '  function _getTokenAmount(uint256 _weiAmount)\n', '    internal view returns (uint256)\n', '  {\n', '    return _weiAmount.mul(rate);\n', '  }\n', '\n', '  /**\n', '   * @dev Determines how ETH is stored/forwarded on purchases.\n', '   */\n', '  function _forwardFunds() internal {\n', '    wallet.transfer(msg.value);\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) internal balances;\n', '\n', '  uint256 internal totalSupply_;\n', '\n', '  /**\n', '  * @dev Total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_value <= balances[msg.sender]);\n', '    require(_to != address(0));\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * https://github.com/ethereum/EIPs/issues/20\n', ' * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '    require(_to != address(0));\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(\n', '    address _owner,\n', '    address _spender\n', '   )\n', '    public\n', '    view\n', '    returns (uint256)\n', '  {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(\n', '    address _spender,\n', '    uint256 _addedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    allowed[msg.sender][_spender] = (\n', '      allowed[msg.sender][_spender].add(_addedValue));\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(\n', '    address _spender,\n', '    uint256 _subtractedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    uint256 oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue >= oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', 'contract MintableToken is StandardToken, Ownable {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  modifier hasMintPermission() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(\n', '    address _to,\n', '    uint256 _amount\n', '  )\n', '    public\n', '    hasMintPermission\n', '    canMint\n', '    returns (bool)\n', '  {\n', '    totalSupply_ = totalSupply_.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    emit Mint(_to, _amount);\n', '    emit Transfer(address(0), _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() public onlyOwner canMint returns (bool) {\n', '    mintingFinished = true;\n', '    emit MintFinished();\n', '    return true;\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title MintedCrowdsale\n', ' * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.\n', ' * Token ownership should be transferred to MintedCrowdsale for minting.\n', ' */\n', 'contract MintedCrowdsale is Crowdsale {\n', '\n', '  /**\n', '   * @dev Overrides delivery by minting tokens upon purchase.\n', '   * @param _beneficiary Token purchaser\n', '   * @param _tokenAmount Number of tokens to be minted\n', '   */\n', '  function _deliverTokens(\n', '    address _beneficiary,\n', '    uint256 _tokenAmount\n', '  )\n', '    internal\n', '  {\n', '    // Potentially dangerous assumption about the type of the token.\n', '    require(MintableToken(address(token)).mint(_beneficiary, _tokenAmount));\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title CappedCrowdsale\n', ' * @dev Crowdsale with a limit for total contributions.\n', ' */\n', 'contract CappedCrowdsale is Crowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  uint256 public cap;\n', '\n', '  /**\n', '   * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.\n', '   * @param _cap Max amount of wei to be contributed\n', '   */\n', '  constructor(uint256 _cap) public {\n', '    require(_cap > 0);\n', '    cap = _cap;\n', '  }\n', '\n', '  /**\n', '   * @dev Checks whether the cap has been reached.\n', '   * @return Whether the cap was reached\n', '   */\n', '  function capReached() public view returns (bool) {\n', '    return weiRaised >= cap;\n', '  }\n', '\n', '  /**\n', '   * @dev Extend parent behavior requiring purchase to respect the funding cap.\n', '   * @param _beneficiary Token purchaser\n', '   * @param _weiAmount Amount of wei contributed\n', '   */\n', '  function _preValidatePurchase(\n', '    address _beneficiary,\n', '    uint256 _weiAmount\n', '  )\n', '    internal\n', '  {\n', '    super._preValidatePurchase(_beneficiary, _weiAmount);\n', '    require(weiRaised.add(_weiAmount) <= cap);\n', '  }\n', '\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title TimedCrowdsale\n', ' * @dev Crowdsale accepting contributions only within a time frame.\n', ' */\n', 'contract TimedCrowdsale is Crowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  uint256 public openingTime;\n', '  uint256 public closingTime;\n', '\n', '  /**\n', '   * @dev Reverts if not in crowdsale time range.\n', '   */\n', '  modifier onlyWhileOpen {\n', '    // solium-disable-next-line security/no-block-members\n', '    require(block.timestamp >= openingTime && block.timestamp <= closingTime);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Constructor, takes crowdsale opening and closing times.\n', '   * @param _openingTime Crowdsale opening time\n', '   * @param _closingTime Crowdsale closing time\n', '   */\n', '  constructor(uint256 _openingTime, uint256 _closingTime) public {\n', '    // solium-disable-next-line security/no-block-members\n', '    require(_openingTime >= block.timestamp);\n', '    require(_closingTime >= _openingTime);\n', '\n', '    openingTime = _openingTime;\n', '    closingTime = _closingTime;\n', '  }\n', '\n', '  /**\n', '   * @dev Checks whether the period in which the crowdsale is open has already elapsed.\n', '   * @return Whether crowdsale period has elapsed\n', '   */\n', '  function hasClosed() public view returns (bool) {\n', '    // solium-disable-next-line security/no-block-members\n', '    return block.timestamp > closingTime;\n', '  }\n', '\n', '  /**\n', '   * @dev Extend parent behavior requiring to be within contributing period\n', '   * @param _beneficiary Token purchaser\n', '   * @param _weiAmount Amount of wei contributed\n', '   */\n', '  function _preValidatePurchase(\n', '    address _beneficiary,\n', '    uint256 _weiAmount\n', '  )\n', '    internal\n', '    onlyWhileOpen\n', '  {\n', '    super._preValidatePurchase(_beneficiary, _weiAmount);\n', '  }\n', '\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title FinalizableCrowdsale\n', ' * @dev Extension of Crowdsale where an owner can do extra work\n', ' * after finishing.\n', ' */\n', 'contract FinalizableCrowdsale is Ownable, TimedCrowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  bool public isFinalized = false;\n', '\n', '  event Finalized();\n', '\n', '  /**\n', '   * @dev Must be called after crowdsale ends, to do some extra finalization\n', "   * work. Calls the contract's finalization function.\n", '   */\n', '  function finalize() public onlyOwner {\n', '    require(!isFinalized);\n', '    require(hasClosed());\n', '\n', '    finalization();\n', '    emit Finalized();\n', '\n', '    isFinalized = true;\n', '  }\n', '\n', '  /**\n', '   * @dev Can be overridden to add finalization logic. The overriding function\n', '   * should call super.finalization() to ensure the chain of finalization is\n', '   * executed entirely.\n', '   */\n', '  function finalization() internal {\n', '  }\n', '\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() public onlyOwner whenNotPaused {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() public onlyOwner whenPaused {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', '// File: contracts/ATFCrowdSale.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract ATFCrowdsale is MintedCrowdsale, CappedCrowdsale, Ownable {\n', '\n', '    struct CustomContract {\n', '        bool isReferral;\n', '        bool isSpecial;\n', '        address referralAddress;\n', '    }\n', '\n', '    // ICO Stage\n', '    // ============\n', '    enum CrowdsaleStage { PrivateICO, PreICO, ICO }\n', '    CrowdsaleStage public stage = CrowdsaleStage.PrivateICO;\n', '    // =============\n', '\n', '    // Token Distribution\n', '    // =============================\n', '    uint256 public maxTokens = 300000000 * 10**18; // There will be total 300,000,000 Tokens\n', '    uint256 public tokensForEcosystem = 120000000 * 10**18;//40%\n', '    uint256 public tokensForTeam = 15000000 * 10**18; //5%\n', '    uint256 public tokensForBounty = 15000000 * 10**18;//5%\n', '    uint256 public tokensForMarketing = 30000000 * 10**18; //10%\n', '    uint256 public tokensForOperations = 30000000 * 10**18;//10%\n', '    uint256 public totalTokensForSale = 90000000 * 10**18; // 30%\n', '    // ==============================\n', '\n', '    //minimum investor Contribution - 100000000000000000\n', '    //minimum investor Contribution - 5000000000000000000000\n', '    uint256 public investorMinCap = 1000000000000000000;\n', '    uint256 public investorHardCap = 5000000000000000000000;\n', '\n', '    mapping(address => uint256) public contributions;\n', '\n', '    // customBonuses\n', '    mapping (address => CustomContract) public customBonuses;\n', '\n', '    // Manual kill switch\n', '    bool crowdsaleConcluded = false;\n', '\n', '    constructor(uint256 _rate,\n', '        address _wallet,\n', '        ERC20 _token,\n', '        uint256 _cap)\n', '    Crowdsale(_rate, _wallet, _token)\n', '    CappedCrowdsale(_cap)\n', '    Ownable()\n', '    public{\n', '    }\n', '\n', '\n', '    function _preValidatePurchase(\n', '        address _beneficiary,\n', '        uint256 _weiAmount\n', '    )\n', '    internal\n', '    {\n', '        require(!hasEnded());\n', '        super._preValidatePurchase(_beneficiary, _weiAmount);\n', '        uint256 _existingContribution = contributions[_beneficiary];\n', '        uint256 _newContribution = _existingContribution.add(_weiAmount);\n', '        require(_weiAmount >= investorMinCap && _weiAmount <= investorHardCap);\n', '        contributions[_beneficiary] = _newContribution;\n', '    }\n', '\n', '    // Override this method to have a way to add business logic to your crowdsale when buying\n', '    function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {\n', '        uint256 tokens = getBaseAmount(_weiAmount);\n', '        uint256 percentage = 0;\n', '\n', '         // Special bonuses\n', '        if (customBonuses[msg.sender].isSpecial == true) {\n', '            percentage = 40;\n', '\n', '        // Regular bonuses\n', '        } else {\n', '\n', '          if ( stage == CrowdsaleStage.PrivateICO ) {\n', '            percentage = 40;\n', '          } else if ( stage == CrowdsaleStage.PreICO ) {\n', '            percentage = 20;\n', '          } else if ( stage == CrowdsaleStage.ICO) {\n', '            // Large contributors\n', '            if (msg.value >= 100 ether) {\n', '              percentage = 20;\n', '            } else if (msg.value >= 50 ether) {\n', '              percentage = 10;\n', '            } else if (msg.value >= 10 ether) {\n', '              percentage = 5;\n', '            }\n', '          }\n', '\n', '        }\n', '\n', '        tokens += tokens.mul(percentage).div(100);\n', '\n', '        assert(tokens > 0);\n', '\n', '        return (tokens);\n', '    }\n', '\n', '    // Change Crowdsale Stage. Available Options: PrivateICO, PreICO, ICO\n', '    function setCrowdsaleStage(uint value) onlyOwner public  {\n', '\n', '        CrowdsaleStage _stage;\n', '\n', '        if (uint(CrowdsaleStage.PrivateICO) == value) {\n', '          _stage = CrowdsaleStage.PrivateICO;\n', '        } else if (uint(CrowdsaleStage.PreICO) == value) {\n', '          _stage = CrowdsaleStage.PreICO;\n', '        } else if (uint(CrowdsaleStage.ICO) == value) {\n', '          _stage = CrowdsaleStage.ICO;\n', '        }\n', '\n', '        stage = _stage;\n', '    }\n', '\n', '    function setCustomBonus(address _contract, bool _isReferral, bool _isSpecial, address _referralAddress) onlyOwner public {\n', '      require(_contract != address(0));\n', '\n', '      customBonuses[_contract] = CustomContract({\n', '          isReferral: _isReferral,\n', '          isSpecial: _isSpecial,\n', '          referralAddress: _referralAddress\n', '      });\n', '    }\n', '\n', '    function getBaseAmount(uint256 _weiAmount) public view returns (uint256) {\n', '        return _weiAmount.mul(rate);\n', '    }\n', '\n', '    // ===========================\n', '\n', '    // Finish: Mint Extra Tokens as needed before finalizing the Crowdsale.\n', '    // ====================================================================\n', '\n', '    function finish(address _teamFund, address _ecosystemFund, address _bountyFund, address _operationsFund) public onlyOwner {\n', '\n', '        require(!hasEnded());\n', '        uint256 alreadyMinted = token.totalSupply();\n', '        require(alreadyMinted < maxTokens);\n', '\n', '        uint256 unsoldTokens = totalTokensForSale.add(tokensForMarketing).sub(alreadyMinted);\n', '        if (unsoldTokens > 0) {\n', '          tokensForEcosystem = tokensForEcosystem.add(unsoldTokens);\n', '        }\n', '\n', '        MintableToken(address(token)).mint(_teamFund,tokensForTeam);\n', '        MintableToken(address(token)).mint(_ecosystemFund,tokensForEcosystem);\n', '        MintableToken(address(token)).mint(_bountyFund,tokensForBounty);\n', '        MintableToken(address(token)).mint(_operationsFund,tokensForOperations);\n', '\n', '        endSale();\n', '    }\n', '\n', '    // @return true if crowdsale event has ended\n', '    function hasEnded() public view returns (bool) {\n', '        return crowdsaleConcluded;\n', '    }\n', '\n', '    /**\n', '     * End crowdsale manually\n', '     */\n', '\n', '    function endSale() onlyOwner internal {\n', '      // close crowdsale\n', '      crowdsaleConcluded = true;\n', '      MintableToken(address(token)).transferOwnership(msg.sender);\n', '\n', '    }\n', '\n', '\n', '\n', '\n', '}']