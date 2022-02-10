['pragma solidity ^0.4.22;\n', '\n', '// File: zeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/MainFabric.sol\n', '\n', '//import "./tokens/ERC20StandardToken.sol";\n', '//import "./tokens/ERC20MintableToken.sol";\n', '//import "./crowdsale/RefundCrowdsale.sol";\n', '\n', 'contract MainFabric is Ownable {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    struct Contract {\n', '        address addr;\n', '        address owner;\n', '        address fabric;\n', '        string contractType;\n', '        uint256 index;\n', '    }\n', '\n', '    struct Fabric {\n', '        address addr;\n', '        address owner;\n', '        bool isActive;\n', '        uint256 index;\n', '    }\n', '\n', '    struct Admin {\n', '        address addr;\n', '        address[] contratcs;\n', '        uint256 numContratcs;\n', '        uint256 index;\n', '    }\n', '\n', '    // ---====== CONTRACTS ======---\n', '    /**\n', '     * @dev Get contract object by address\n', '     */\n', '    mapping(address => Contract) public contracts;\n', '\n', '    /**\n', '     * @dev Contracts addresses list\n', '     */\n', '    address[] public contractsAddr;\n', '\n', '    /**\n', '     * @dev Count of contracts in list\n', '     */\n', '    function numContracts() public view returns (uint256)\n', '    { return contractsAddr.length; }\n', '\n', '\n', '    // ---====== ADMINS ======---\n', '    /**\n', '     * @dev Get contract object by address\n', '     */\n', '    mapping(address => Admin) public admins;\n', '\n', '    /**\n', '     * @dev Contracts addresses list\n', '     */\n', '    address[] public adminsAddr;\n', '\n', '    /**\n', '     * @dev Count of contracts in list\n', '     */\n', '    function numAdmins() public view returns (uint256)\n', '    { return adminsAddr.length; }\n', '\n', '    function getAdminContract(address _adminAddress, uint256 _index) public view returns (\n', '        address\n', '    ) {\n', '        return (\n', '            admins[_adminAddress].contratcs[_index]\n', '        );\n', '    }\n', '\n', '    // ---====== FABRICS ======---\n', '    /**\n', '     * @dev Get fabric object by address\n', '     */\n', '    mapping(address => Fabric) public fabrics;\n', '\n', '    /**\n', '     * @dev Fabrics addresses list\n', '     */\n', '    address[] public fabricsAddr;\n', '\n', '    /**\n', '     * @dev Count of fabrics in list\n', '     */\n', '    function numFabrics() public view returns (uint256)\n', '    { return fabricsAddr.length; }\n', '\n', '    /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '    modifier onlyFabric() {\n', '        require(fabrics[msg.sender].isActive);\n', '        _;\n', '    }\n', '\n', '    // ---====== CONSTRUCTOR ======---\n', '\n', '    function MainFabric() public {\n', '\n', '    }\n', '\n', '    /**\n', '     * @dev Add fabric\n', '     * @param _address Fabric address\n', '     */\n', '    function addFabric(\n', '        address _address\n', '    )\n', '    public\n', '    onlyOwner\n', '    returns (bool)\n', '    {\n', '        fabrics[_address].addr = _address;\n', '        fabrics[_address].owner = msg.sender;\n', '        fabrics[_address].isActive = true;\n', '        fabrics[_address].index = fabricsAddr.push(_address) - 1;\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Remove fabric\n', '     * @param _address Fabric address\n', '     */\n', '    function removeFabric(\n', '        address _address\n', '    )\n', '    public\n', '    onlyOwner\n', '    returns (bool)\n', '    {\n', '        require(fabrics[_address].isActive);\n', '        fabrics[_address].isActive = false;\n', '\n', '        uint rowToDelete = fabrics[_address].index;\n', '        address keyToMove   = fabricsAddr[fabricsAddr.length-1];\n', '        fabricsAddr[rowToDelete] = keyToMove;\n', '        fabrics[keyToMove].index = rowToDelete;\n', '        fabricsAddr.length--;\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Create refund crowdsale\n', '     * @param _address Fabric address\n', '     */\n', '    function addContract(\n', '        address _address,\n', '        address _owner,\n', '        string _contractType\n', '    )\n', '    public\n', '    onlyFabric\n', '    returns (bool)\n', '    {\n', '        contracts[_address].addr = _address;\n', '        contracts[_address].owner = _owner;\n', '        contracts[_address].fabric = msg.sender;\n', '        contracts[_address].contractType = _contractType;\n', '        contracts[_address].index = contractsAddr.push(_address) - 1;\n', '\n', '        if (admins[_owner].addr != _owner) {\n', '            admins[_owner].addr = _owner;\n', '            admins[_owner].index = adminsAddr.push(_owner) - 1;\n', '        }\n', '\n', '        admins[_owner].contratcs.push(contracts[_address].addr);\n', '        admins[_owner].numContratcs++;\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol\n', '\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale,\n', ' * allowing investors to purchase tokens with ether. This contract implements\n', ' * such functionality in its most fundamental form and can be extended to provide additional\n', ' * functionality and/or custom behavior.\n', ' * The external interface represents the basic interface for purchasing tokens, and conform\n', ' * the base architecture for crowdsales. They are *not* intended to be modified / overriden.\n', ' * The internal interface conforms the extensible and modifiable surface of crowdsales. Override \n', ' * the methods to add functionality. Consider using &#39;super&#39; where appropiate to concatenate\n', ' * behavior.\n', ' */\n', '\n', 'contract Crowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  // The token being sold\n', '  ERC20 public token;\n', '\n', '  // Address where funds are collected\n', '  address public wallet;\n', '\n', '  // How many token units a buyer gets per wei\n', '  uint256 public rate;\n', '\n', '  // Amount of wei raised\n', '  uint256 public weiRaised;\n', '\n', '  /**\n', '   * Event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '  /**\n', '   * @param _rate Number of token units a buyer gets per wei\n', '   * @param _wallet Address where collected funds will be forwarded to\n', '   * @param _token Address of the token being sold\n', '   */\n', '  function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {\n', '    require(_rate > 0);\n', '    require(_wallet != address(0));\n', '    require(_token != address(0));\n', '\n', '    rate = _rate;\n', '    wallet = _wallet;\n', '    token = _token;\n', '  }\n', '\n', '  // -----------------------------------------\n', '  // Crowdsale external interface\n', '  // -----------------------------------------\n', '\n', '  /**\n', '   * @dev fallback function ***DO NOT OVERRIDE***\n', '   */\n', '  function () external payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  /**\n', '   * @dev low level token purchase ***DO NOT OVERRIDE***\n', '   * @param _beneficiary Address performing the token purchase\n', '   */\n', '  function buyTokens(address _beneficiary) public payable {\n', '\n', '    uint256 weiAmount = msg.value;\n', '    _preValidatePurchase(_beneficiary, weiAmount);\n', '\n', '    // calculate token amount to be created\n', '    uint256 tokens = _getTokenAmount(weiAmount);\n', '\n', '    // update state\n', '    weiRaised = weiRaised.add(weiAmount);\n', '\n', '    _processPurchase(_beneficiary, tokens);\n', '    TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);\n', '\n', '    _updatePurchasingState(_beneficiary, weiAmount);\n', '\n', '    _forwardFunds();\n', '    _postValidatePurchase(_beneficiary, weiAmount);\n', '  }\n', '\n', '  // -----------------------------------------\n', '  // Internal interface (extensible)\n', '  // -----------------------------------------\n', '\n', '  /**\n', '   * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.\n', '   * @param _beneficiary Address performing the token purchase\n', '   * @param _weiAmount Value in wei involved in the purchase\n', '   */\n', '  function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {\n', '    require(_beneficiary != address(0));\n', '    require(_weiAmount != 0);\n', '  }\n', '\n', '  /**\n', '   * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.\n', '   * @param _beneficiary Address performing the token purchase\n', '   * @param _weiAmount Value in wei involved in the purchase\n', '   */\n', '  function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {\n', '    // optional override\n', '  }\n', '\n', '  /**\n', '   * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.\n', '   * @param _beneficiary Address performing the token purchase\n', '   * @param _tokenAmount Number of tokens to be emitted\n', '   */\n', '  function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {\n', '    token.transfer(_beneficiary, _tokenAmount);\n', '  }\n', '\n', '  /**\n', '   * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.\n', '   * @param _beneficiary Address receiving the tokens\n', '   * @param _tokenAmount Number of tokens to be purchased\n', '   */\n', '  function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {\n', '    _deliverTokens(_beneficiary, _tokenAmount);\n', '  }\n', '\n', '  /**\n', '   * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)\n', '   * @param _beneficiary Address receiving the tokens\n', '   * @param _weiAmount Value in wei involved in the purchase\n', '   */\n', '  function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {\n', '    // optional override\n', '  }\n', '\n', '  /**\n', '   * @dev Override to extend the way in which ether is converted to tokens.\n', '   * @param _weiAmount Value in wei to be converted into tokens\n', '   * @return Number of tokens that can be purchased with the specified _weiAmount\n', '   */\n', '  function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {\n', '    return _weiAmount.mul(rate);\n', '  }\n', '\n', '  /**\n', '   * @dev Determines how ETH is stored/forwarded on purchases.\n', '   */\n', '  function _forwardFunds() internal {\n', '    wallet.transfer(msg.value);\n', '  }\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', 'contract MintableToken is StandardToken, Ownable {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '    totalSupply_ = totalSupply_.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    Transfer(address(0), _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner canMint public returns (bool) {\n', '    mintingFinished = true;\n', '    MintFinished();\n', '    return true;\n', '  }\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol\n', '\n', '/**\n', ' * @title MintedCrowdsale\n', ' * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.\n', ' * Token ownership should be transferred to MintedCrowdsale for minting. \n', ' */\n', 'contract MintedCrowdsale is Crowdsale {\n', '\n', '  /**\n', '   * @dev Overrides delivery by minting tokens upon purchase.\n', '   * @param _beneficiary Token purchaser\n', '   * @param _tokenAmount Number of tokens to be minted\n', '   */\n', '  function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {\n', '    require(MintableToken(token).mint(_beneficiary, _tokenAmount));\n', '  }\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol\n', '\n', '/**\n', ' * @title CappedCrowdsale\n', ' * @dev Crowdsale with a limit for total contributions.\n', ' */\n', 'contract CappedCrowdsale is Crowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  uint256 public cap;\n', '\n', '  /**\n', '   * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.\n', '   * @param _cap Max amount of wei to be contributed\n', '   */\n', '  function CappedCrowdsale(uint256 _cap) public {\n', '    require(_cap > 0);\n', '    cap = _cap;\n', '  }\n', '\n', '  /**\n', '   * @dev Checks whether the cap has been reached. \n', '   * @return Whether the cap was reached\n', '   */\n', '  function capReached() public view returns (bool) {\n', '    return weiRaised >= cap;\n', '  }\n', '\n', '  /**\n', '   * @dev Extend parent behavior requiring purchase to respect the funding cap.\n', '   * @param _beneficiary Token purchaser\n', '   * @param _weiAmount Amount of wei contributed\n', '   */\n', '  function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {\n', '    super._preValidatePurchase(_beneficiary, _weiAmount);\n', '    require(weiRaised.add(_weiAmount) <= cap);\n', '  }\n', '\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol\n', '\n', '/**\n', ' * @title TimedCrowdsale\n', ' * @dev Crowdsale accepting contributions only within a time frame.\n', ' */\n', 'contract TimedCrowdsale is Crowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  uint256 public openingTime;\n', '  uint256 public closingTime;\n', '\n', '  /**\n', '   * @dev Reverts if not in crowdsale time range. \n', '   */\n', '  modifier onlyWhileOpen {\n', '    require(now >= openingTime && now <= closingTime);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Constructor, takes crowdsale opening and closing times.\n', '   * @param _openingTime Crowdsale opening time\n', '   * @param _closingTime Crowdsale closing time\n', '   */\n', '  function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {\n', '    require(_openingTime >= now);\n', '    require(_closingTime >= _openingTime);\n', '\n', '    openingTime = _openingTime;\n', '    closingTime = _closingTime;\n', '  }\n', '\n', '  /**\n', '   * @dev Checks whether the period in which the crowdsale is open has already elapsed.\n', '   * @return Whether crowdsale period has elapsed\n', '   */\n', '  function hasClosed() public view returns (bool) {\n', '    return now > closingTime;\n', '  }\n', '  \n', '  /**\n', '   * @dev Extend parent behavior requiring to be within contributing period\n', '   * @param _beneficiary Token purchaser\n', '   * @param _weiAmount Amount of wei contributed\n', '   */\n', '  function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {\n', '    super._preValidatePurchase(_beneficiary, _weiAmount);\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/crowdsale/RefundCrowdsale.sol\n', '\n', '/**\n', ' * @title RefundCrowdsale\n', ' * @dev RefundCrowdsale is a contract for managing a token crowdsale\n', ' */\n', '\n', 'contract RefundCrowdsale is TimedCrowdsale, MintedCrowdsale, CappedCrowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  /**\n', '   * @param _rate Number of token units a buyer gets per wei\n', '   * @param _wallet Address where collected funds will be forwarded to\n', '   * @param _token Address of the token being sold\n', '   */\n', '  function RefundCrowdsale(\n', '    uint256 _rate,\n', '    address _wallet,\n', '    ERC20 _token,\n', '    uint256 _cap,\n', '    uint256 _openingTime,\n', '    uint256 _closingTime\n', '  )\n', '  Crowdsale(_rate, _wallet, _token)\n', '  TimedCrowdsale(_openingTime, _closingTime)\n', '  CappedCrowdsale(_cap)\n', '  public\n', '  {\n', '\n', '  }\n', '}\n', '\n', '// File: contracts/tokens/ERC223/ERC223_receiving_contract.sol\n', '\n', '/**\n', '* @title Contract that will work with ERC223 tokens.\n', '*/\n', '\n', 'contract ERC223ReceivingContract {\n', '    /**\n', '     * @dev Standard ERC223 function that will handle incoming token transfers.\n', '     *\n', '     * @param _from  Token sender address.\n', '     * @param _value Amount of tokens.\n', '     * @param _data  Transaction metadata.\n', '     */\n', '    function tokenFallback(address _from, uint _value, bytes _data);\n', '}\n', '\n', '// File: contracts/tokens/ERC223/ERC223.sol\n', '\n', '/**\n', ' * @title Reference implementation of the ERC223 standard token.\n', ' */\n', 'contract ERC223 is StandardToken {\n', '\n', '    event Transfer(address indexed from, address indexed to, uint value, bytes data);\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint _value) public returns (bool) {\n', '        bytes memory empty;\n', '        return transfer(_to, _value, empty);\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    * @param _data Optional metadata.\n', '    */\n', '    function transfer(address _to, uint _value, bytes _data) public returns (bool) {\n', '        super.transfer(_to, _value);\n', '\n', '        if (isContract(_to)) {\n', '            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '            receiver.tokenFallback(msg.sender, _value, _data);\n', '            Transfer(msg.sender, _to, _value, _data);\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool) {\n', '        bytes memory empty;\n', '        return transferFrom(_from, _to, _value, empty);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint the amount of tokens to be transferred\n', '     * @param _data Optional metadata.\n', '     */\n', '    function transferFrom(address _from, address _to, uint _value, bytes _data) public returns (bool) {\n', '        super.transferFrom(_from, _to, _value);\n', '\n', '        if (isContract(_to)) {\n', '            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '            receiver.tokenFallback(_from, _value, _data);\n', '        }\n', '\n', '        Transfer(_from, _to, _value, _data);\n', '        return true;\n', '    }\n', '\n', '    function isContract(address _addr) private view returns (bool) {\n', '        uint length;\n', '        assembly {\n', '            //retrieve the size of the code on target address, this needs assembly\n', '            length := extcodesize(_addr)\n', '        }\n', '        return (length>0);\n', '    }\n', '}\n', '\n', '// File: contracts/tokens/ERC223MintableToken.sol\n', '\n', 'contract ERC223MintableToken is MintableToken, ERC223 {\n', '\n', '    string public name = "";\n', '    string public symbol = "";\n', '    uint public decimals = 18;\n', '\n', '    function ERC223MintableToken(string _name, string _symbol, uint8 _decimals, address _owner) public {\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '\n', '        owner = _owner;\n', '    }\n', '}\n', '\n', '// File: contracts/factories/BaseFactory.sol\n', '\n', 'contract BaseFactory {\n', '\n', '    address public mainFabricAddress;\n', '    string public title;\n', '\n', '    struct Parameter {\n', '        string title;\n', '        string paramType;\n', '    }\n', '\n', '    /**\n', '     * @dev params list\n', '     */\n', '    Parameter[] public params;\n', '\n', '    /**\n', '     * @dev Count of parameters in factory\n', '     */\n', '    function numParameters() public view returns (uint256)\n', '    {\n', '        return params.length;\n', '    }\n', '\n', '    function getParam(uint _i) public view returns (\n', '        string title,\n', '        string paramType\n', '    ) {\n', '        return (\n', '        params[_i].title,\n', '        params[_i].paramType\n', '        );\n', '    }\n', '}\n', '\n', '// File: contracts/factories/RefundCrowdsaleFactory.sol\n', '\n', 'contract RefundCrowdsaleFactory is BaseFactory {\n', '\n', '    function RefundCrowdsaleFactory(address _mainFactory) public {\n', '        require(_mainFactory != 0x0);\n', '        mainFabricAddress = _mainFactory;\n', '\n', '        title = "RefundCrowdsale";\n', '\n', '\n', '        params.push(Parameter({\n', '            title: "Token name",\n', '            paramType: "string"\n', '        }));\n', '\n', '        params.push(Parameter({\n', '            title: "Token symbol",\n', '            paramType: "string"\n', '        }));\n', '\n', '        params.push(Parameter({\n', '            title: "Decimals",\n', '            paramType: "uint8"\n', '        }));\n', '\n', '        params.push(Parameter({\n', '            title: "Token Rate",\n', '            paramType: "uint256"\n', '        }));\n', '\n', '        params.push(Parameter({\n', '            title: "Wallet",\n', '            paramType: "address"\n', '        }));\n', '\n', '        params.push(Parameter({\n', '            title: "Hard cap in ETH",\n', '            paramType: "uint256"\n', '        }));\n', '\n', '        params.push(Parameter({\n', '            title: "Opening time",\n', '            paramType: "uint256"\n', '        }));\n', '\n', '        params.push(Parameter({\n', '            title: "Closing time",\n', '            paramType: "uint256"\n', '        }));\n', '    }\n', '   \n', '    function create( \n', '        string _name, \n', '        string _symbol,\n', '        uint8 _decimals,\n', '        uint256 _rate,\n', '        address _wallet,\n', '        uint256 _cap,\n', '        uint256 _openingTime,\n', '        uint256 _closingTime\n', '    ) public returns (RefundCrowdsale) {\n', '\n', '        ERC223MintableToken newToken = new ERC223MintableToken(_name, _symbol, _decimals, address(this));\n', '\n', '        RefundCrowdsale newCrowdsale = new RefundCrowdsale(\n', '            _rate,\n', '            _wallet,\n', '            ERC20(newToken),\n', '            _cap,\n', '            _openingTime,\n', '            _closingTime\n', '        );\n', '\n', '        newToken.transferOwnership(newCrowdsale);\n', '\n', '        MainFabric fabric = MainFabric(mainFabricAddress);\n', '        fabric.addContract(address(newToken), msg.sender, &#39;ERC223MintableToken&#39;);\n', '        fabric.addContract(address(newCrowdsale), msg.sender, title);\n', '\n', '        return newCrowdsale;\n', '    }\n', '}']