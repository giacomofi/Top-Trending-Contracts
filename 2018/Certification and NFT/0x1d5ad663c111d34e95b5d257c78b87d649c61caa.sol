['pragma solidity ^0.4.18;\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'pragma solidity ^0.4.18;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale,\n', ' * allowing investors to purchase tokens with ether. This contract implements\n', ' * such functionality in its most fundamental form and can be extended to provide additional\n', ' * functionality and/or custom behavior.\n', ' * The external interface represents the basic interface for purchasing tokens, and conform\n', ' * the base architecture for crowdsales. They are *not* intended to be modified / overriden.\n', ' * The internal interface conforms the extensible and modifiable surface of crowdsales. Override \n', " * the methods to add functionality. Consider using 'super' where appropiate to concatenate\n", ' * behavior.\n', ' */\n', '\n', 'contract Crowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  // The token being sold\n', '  ERC20 public token;\n', '\n', '  // Address where funds are collected\n', '  address public wallet;\n', '\n', '  // How many token units a buyer gets per wei\n', '  uint256 public rate;\n', '\n', '  // Amount of wei raised\n', '  uint256 public weiRaised;\n', '\n', '  /**\n', '   * Event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '  /**\n', '   * @param _rate Number of token units a buyer gets per wei\n', '   * @param _wallet Address where collected funds will be forwarded to\n', '   * @param _token Address of the token being sold\n', '   */\n', '  function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {\n', '    require(_rate > 0);\n', '    require(_wallet != address(0));\n', '    require(_token != address(0));\n', '\n', '    rate = _rate;\n', '    wallet = _wallet;\n', '    token = _token;\n', '  }\n', '\n', '  // -----------------------------------------\n', '  // Crowdsale external interface\n', '  // -----------------------------------------\n', '\n', '  /**\n', '   * @dev fallback function ***DO NOT OVERRIDE***\n', '   */\n', '  function () external payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  /**\n', '   * @dev low level token purchase ***DO NOT OVERRIDE***\n', '   * @param _beneficiary Address performing the token purchase\n', '   */\n', '  function buyTokens(address _beneficiary) public payable {\n', '\n', '    uint256 weiAmount = msg.value;\n', '    _preValidatePurchase(_beneficiary, weiAmount);\n', '\n', '    // calculate token amount to be created\n', '    uint256 tokens = _getTokenAmount(weiAmount);\n', '\n', '    // update state\n', '    weiRaised = weiRaised.add(weiAmount);\n', '\n', '    _processPurchase(_beneficiary, tokens);\n', '    TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);\n', '\n', '    _updatePurchasingState(_beneficiary, weiAmount);\n', '\n', '    _forwardFunds();\n', '    _postValidatePurchase(_beneficiary, weiAmount);\n', '  }\n', '\n', '  // -----------------------------------------\n', '  // Internal interface (extensible)\n', '  // -----------------------------------------\n', '\n', '  /**\n', '   * @dev Validation of an incoming purchase. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.\n', '   * @param _beneficiary Address performing the token purchase\n', '   * @param _weiAmount Value in wei involved in the purchase\n', '   */\n', '  function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {\n', '    require(_beneficiary != address(0));\n', '    require(_weiAmount != 0);\n', '  }\n', '\n', '  /**\n', '   * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.\n', '   * @param _beneficiary Address performing the token purchase\n', '   * @param _weiAmount Value in wei involved in the purchase\n', '   */\n', '  function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {\n', '    // optional override\n', '  }\n', '\n', '  /**\n', '   * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.\n', '   * @param _beneficiary Address performing the token purchase\n', '   * @param _tokenAmount Number of tokens to be emitted\n', '   */\n', '  function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {\n', '    token.transfer(_beneficiary, _tokenAmount);\n', '  }\n', '\n', '  /**\n', '   * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.\n', '   * @param _beneficiary Address receiving the tokens\n', '   * @param _tokenAmount Number of tokens to be purchased\n', '   */\n', '  function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {\n', '    _deliverTokens(_beneficiary, _tokenAmount);\n', '  }\n', '\n', '  /**\n', '   * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)\n', '   * @param _beneficiary Address receiving the tokens\n', '   * @param _weiAmount Value in wei involved in the purchase\n', '   */\n', '  function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {\n', '    // optional override\n', '  }\n', '\n', '  /**\n', '   * @dev Override to extend the way in which ether is converted to tokens.\n', '   * @param _weiAmount Value in wei to be converted into tokens\n', '   * @return Number of tokens that can be purchased with the specified _weiAmount\n', '   */\n', '  function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {\n', '    return _weiAmount.mul(rate);\n', '  }\n', '\n', '  /**\n', '   * @dev Determines how ETH is stored/forwarded on purchases.\n', '   */\n', '  function _forwardFunds() internal {\n', '    wallet.transfer(msg.value);\n', '  }\n', '}\n', '\n', 'pragma solidity ^0.4.18;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'pragma solidity ^0.4.19;\n', '\n', 'contract _Crowdsale is Crowdsale, Ownable {\n', '\n', '    uint public fundingGoal;\n', '\n', '    mapping(address => uint256) public balanceOf;\n', '    bool fundingGoalReached = false;\n', '    bool crowdsaleClosed = false;\n', '\n', '    function _Crowdsale(address wallet, uint goal, uint rate, address token)\n', '        Crowdsale(rate, wallet, ERC20(token)) public {\n', '        fundingGoal = goal * 1 ether;\n', '    }\n', '\n', '    function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {\n', '        // require(!crowdsaleClosed);\n', '        require(_weiAmount <= 10 ether && _weiAmount >= 1 finney);\n', '        super._preValidatePurchase(_beneficiary, _weiAmount);\n', '    }\n', '\n', '    function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {\n', '        //token.transfer(_beneficiary, _tokenAmount);\n', '        token.transferFrom(owner, _beneficiary, _tokenAmount);\n', '    }\n', '\n', '    function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {\n', '        return _weiAmount.div(10 ** rate);\n', '    }\n', '\n', '    event GoalReached(address recipient, uint totalAmountRaised);\n', '\n', '    function checkGoalReached() public {\n', '        if (weiRaised >= fundingGoal) {\n', '            GoalReached(wallet, weiRaised);\n', '        }\n', '    }\n', '\n', '}']