['pragma solidity ^0.4.21;\n', '\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', 'contract TraxionWallet is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '\n', '    constructor(){\n', '        transferOwnership(0xC889dFBDc9C1D0FC3E77e46c3b82A3903b2D919c);\n', '    }\n', '\n', '    // Address where funds are collectedt\n', '    address public wallet = 0xbee44A7b93509270dbe90000f7ff31268D8F075e;\n', '  \n', '    // How many token units a buyer gets per wei\n', '    uint256 public rate = 2857;\n', '\n', '    // Minimum investment in wei (0.20 ETH)\n', '    uint256 public minInvestment = 2E17;\n', '\n', '    // Maximum investment in wei (2,000 ETH)\n', '    uint256 public investmentUpperBounds = 2E21;        \n', '\n', '    // Hard cap in wei (100,000 ETH)\n', '    uint256 public hardcap = 45E21;\n', '\n', '    // Amount of wei raised\n', '    uint256 public weiRaised;\n', '\n', '    event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);\n', '  \n', '    // -----------------------------------------\n', '    // Crowdsale external interface\n', '    // -----------------------------------------\n', '\n', '    /**\n', '     * @dev fallback function ***DO NOT OVERRIDE***\n', '     */\n', '    function () external payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    /** Whitelist an address and set max investment **/\n', '    mapping (address => bool) public whitelistedAddr;\n', '    mapping (address => uint256) public totalInvestment;\n', '  \n', '    /** @dev whitelist an Address */\n', '    function whitelistAddress(address[] buyer) external onlyOwner {\n', '        for (uint i = 0; i < buyer.length; i++) {\n', '            whitelistedAddr[buyer[i]] = true;\n', '        }\n', '    }\n', '  \n', '    /** @dev black list an address **/\n', '    function blacklistAddr(address[] buyer) external onlyOwner {\n', '        for (uint i = 0; i < buyer.length; i++) {\n', '            whitelistedAddr[buyer[i]] = false;\n', '        }\n', '    }    \n', '\n', '    /**\n', '     * @dev low level token purchase ***DO NOT OVERRIDE***\n', '     * @param _beneficiary Address performing the token purchase\n', '     */\n', '    function buyTokens(address _beneficiary) public payable {\n', '\n', '        uint256 weiAmount = msg.value;\n', '        _preValidatePurchase(_beneficiary, weiAmount);\n', '\n', '        // calculate token amount to be created\n', '        uint256 tokens = _getTokenAmount(weiAmount);\n', '\n', '        // update state\n', '        weiRaised = weiRaised.add(weiAmount);\n', '\n', '        emit TokenPurchase(msg.sender, weiAmount, tokens);\n', '\n', '        _updatePurchasingState(_beneficiary, weiAmount);\n', '\n', '        _forwardFunds();\n', '    }\n', '\n', '    // -----------------------------------------\n', '    // Internal interface (extensible)\n', '    // -----------------------------------------\n', '\n', '    /**\n', '     * @dev Validation of an incoming purchase. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.\n', '     * @param _beneficiary Address performing the token purchase\n', '     * @param _weiAmount Value in wei involved in the purchase\n', '     */\n', '    function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view {\n', '        require(_beneficiary != address(0)); \n', '        require(_weiAmount != 0);\n', '    \n', '        require(_weiAmount > minInvestment); // Revert if payment is less than 0.40 ETH\n', '        require(whitelistedAddr[_beneficiary]); // Revert if investor is not whitelisted\n', '        require(totalInvestment[_beneficiary].add(_weiAmount) <= investmentUpperBounds); // Revert if the investor already spent over 2k ETH investment or payment is greater than 2k ETH\n', '        require(weiRaised.add(_weiAmount) <= hardcap); // Revert if ICO campaign reached Hard Cap\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)\n', '     * @param _beneficiary Address receiving the tokens\n', '     * @param _weiAmount Value in wei involved in the purchase\n', '     */\n', '    function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {\n', '        totalInvestment[_beneficiary] = totalInvestment[_beneficiary].add(_weiAmount);\n', '    }\n', '\n', '    /**\n', '     * @dev Override to extend the way in which ether is converted to tokens.\n', '     * @param _weiAmount Value in wei to be converted into tokens\n', '     * @return Number of tokens that can be purchased with the specified _weiAmount\n', '     */\n', '    function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {\n', '        return _weiAmount.mul(rate);\n', '    }\n', '\n', '    /**\n', '     * @dev Determines how ETH is stored/forwarded on purchases.\n', '     */\n', '    function _forwardFunds() internal {\n', '        wallet.transfer(msg.value);\n', '    }\n', '}']
['pragma solidity ^0.4.21;\n', '\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', 'contract TraxionWallet is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '\n', '    constructor(){\n', '        transferOwnership(0xC889dFBDc9C1D0FC3E77e46c3b82A3903b2D919c);\n', '    }\n', '\n', '    // Address where funds are collectedt\n', '    address public wallet = 0xbee44A7b93509270dbe90000f7ff31268D8F075e;\n', '  \n', '    // How many token units a buyer gets per wei\n', '    uint256 public rate = 2857;\n', '\n', '    // Minimum investment in wei (0.20 ETH)\n', '    uint256 public minInvestment = 2E17;\n', '\n', '    // Maximum investment in wei (2,000 ETH)\n', '    uint256 public investmentUpperBounds = 2E21;        \n', '\n', '    // Hard cap in wei (100,000 ETH)\n', '    uint256 public hardcap = 45E21;\n', '\n', '    // Amount of wei raised\n', '    uint256 public weiRaised;\n', '\n', '    event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);\n', '  \n', '    // -----------------------------------------\n', '    // Crowdsale external interface\n', '    // -----------------------------------------\n', '\n', '    /**\n', '     * @dev fallback function ***DO NOT OVERRIDE***\n', '     */\n', '    function () external payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    /** Whitelist an address and set max investment **/\n', '    mapping (address => bool) public whitelistedAddr;\n', '    mapping (address => uint256) public totalInvestment;\n', '  \n', '    /** @dev whitelist an Address */\n', '    function whitelistAddress(address[] buyer) external onlyOwner {\n', '        for (uint i = 0; i < buyer.length; i++) {\n', '            whitelistedAddr[buyer[i]] = true;\n', '        }\n', '    }\n', '  \n', '    /** @dev black list an address **/\n', '    function blacklistAddr(address[] buyer) external onlyOwner {\n', '        for (uint i = 0; i < buyer.length; i++) {\n', '            whitelistedAddr[buyer[i]] = false;\n', '        }\n', '    }    \n', '\n', '    /**\n', '     * @dev low level token purchase ***DO NOT OVERRIDE***\n', '     * @param _beneficiary Address performing the token purchase\n', '     */\n', '    function buyTokens(address _beneficiary) public payable {\n', '\n', '        uint256 weiAmount = msg.value;\n', '        _preValidatePurchase(_beneficiary, weiAmount);\n', '\n', '        // calculate token amount to be created\n', '        uint256 tokens = _getTokenAmount(weiAmount);\n', '\n', '        // update state\n', '        weiRaised = weiRaised.add(weiAmount);\n', '\n', '        emit TokenPurchase(msg.sender, weiAmount, tokens);\n', '\n', '        _updatePurchasingState(_beneficiary, weiAmount);\n', '\n', '        _forwardFunds();\n', '    }\n', '\n', '    // -----------------------------------------\n', '    // Internal interface (extensible)\n', '    // -----------------------------------------\n', '\n', '    /**\n', '     * @dev Validation of an incoming purchase. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.\n', '     * @param _beneficiary Address performing the token purchase\n', '     * @param _weiAmount Value in wei involved in the purchase\n', '     */\n', '    function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view {\n', '        require(_beneficiary != address(0)); \n', '        require(_weiAmount != 0);\n', '    \n', '        require(_weiAmount > minInvestment); // Revert if payment is less than 0.40 ETH\n', '        require(whitelistedAddr[_beneficiary]); // Revert if investor is not whitelisted\n', '        require(totalInvestment[_beneficiary].add(_weiAmount) <= investmentUpperBounds); // Revert if the investor already spent over 2k ETH investment or payment is greater than 2k ETH\n', '        require(weiRaised.add(_weiAmount) <= hardcap); // Revert if ICO campaign reached Hard Cap\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)\n', '     * @param _beneficiary Address receiving the tokens\n', '     * @param _weiAmount Value in wei involved in the purchase\n', '     */\n', '    function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {\n', '        totalInvestment[_beneficiary] = totalInvestment[_beneficiary].add(_weiAmount);\n', '    }\n', '\n', '    /**\n', '     * @dev Override to extend the way in which ether is converted to tokens.\n', '     * @param _weiAmount Value in wei to be converted into tokens\n', '     * @return Number of tokens that can be purchased with the specified _weiAmount\n', '     */\n', '    function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {\n', '        return _weiAmount.mul(rate);\n', '    }\n', '\n', '    /**\n', '     * @dev Determines how ETH is stored/forwarded on purchases.\n', '     */\n', '    function _forwardFunds() internal {\n', '        wallet.transfer(msg.value);\n', '    }\n', '}']
