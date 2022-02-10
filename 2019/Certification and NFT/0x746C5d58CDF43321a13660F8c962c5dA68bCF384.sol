['pragma solidity ^0.5.0;\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor () internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @return the address of the owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner());\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @return true if `msg.sender` is the owner of the contract.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to relinquish control of the contract.\n', '     * @notice Renouncing to ownership will leave the contract without an owner.\n', '     * It will not be possible to call the functions with the `onlyOwner`\n', '     * modifier anymore.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: contracts/Whitelisted.sol\n', '\n', 'contract Whitelisted is Ownable {\n', '\n', '    mapping (address => uint16) public whitelist;\n', '    mapping (address => bool) public provider;\n', '\n', '    // Only whitelisted\n', '    modifier onlyWhitelisted {\n', '      require(isWhitelisted(msg.sender));\n', '      _;\n', '    }\n', '\n', '      modifier onlyProvider {\n', '        require(isProvider(msg.sender));\n', '        _;\n', '      }\n', '\n', '      // Check if address is KYC provider\n', '      function isProvider(address _provider) public view returns (bool){\n', '        if (owner() == _provider){\n', '          return true;\n', '        }\n', '        return provider[_provider] == true ? true : false;\n', '      }\n', '      // Set new provider\n', '      function setProvider(address _provider) public onlyOwner {\n', '         provider[_provider] = true;\n', '      }\n', '      // Deactive current provider\n', '      function deactivateProvider(address _provider) public onlyOwner {\n', '         require(provider[_provider] == true);\n', '         provider[_provider] = false;\n', '      }\n', '      // Set purchaser to whitelist with zone code\n', '      function setWhitelisted(address _purchaser, uint16 _zone) public onlyProvider {\n', '         whitelist[_purchaser] = _zone;\n', '      }\n', '      // Delete purchaser from whitelist\n', '      function deleteFromWhitelist(address _purchaser) public onlyProvider {\n', '         whitelist[_purchaser] = 0;\n', '      }\n', '      // Get purchaser zone code\n', '      function getWhitelistedZone(address _purchaser) public view returns(uint16) {\n', '        return whitelist[_purchaser] > 0 ? whitelist[_purchaser] : 0;\n', '      }\n', '      // Check if purchaser is whitelisted : return true or false\n', '      function isWhitelisted(address _purchaser) public view returns (bool){\n', '        return whitelist[_purchaser] > 0;\n', '      }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Unsigned math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '    /**\n', '    * @dev Multiplies two unsigned integers, reverts on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Gas optimization: this is cheaper than requiring &#39;a&#39; not being zero, but the\n', '        // benefit is lost if &#39;b&#39; is also tested.\n', '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two unsigned integers, reverts on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '    * reverts when dividing by zero.\n', '    */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'interface IERC20 {\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address who) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        require(token.transfer(to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        require(token.transferFrom(from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', '        // &#39;safeIncreaseAllowance&#39; and &#39;safeDecreaseAllowance&#39;\n', '        require((value == 0) || (token.allowance(msg.sender, spender) == 0));\n', '        require(token.approve(spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        require(token.approve(spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value);\n', '        require(token.approve(spender, newAllowance));\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol\n', '\n', '/**\n', ' * @title Helps contracts guard against reentrancy attacks.\n', ' * @author Remco Bloemen <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="5e2c3b333d311e6c">[email&#160;protected]</a>π.com>, Eenae <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="b9d8d5dcc1dcc0f9d4d0c1dbc0cddcca97d0d6">[email&#160;protected]</a>>\n', ' * @dev If you mark a function `nonReentrant`, you should also\n', ' * mark it `external`.\n', ' */\n', 'contract ReentrancyGuard {\n', '    /// @dev counter to allow mutex lock with only one SSTORE operation\n', '    uint256 private _guardCounter;\n', '\n', '    constructor () internal {\n', '        // The counter starts at one to prevent changing it from zero to a non-zero\n', '        // value, which is a more expensive operation.\n', '        _guardCounter = 1;\n', '    }\n', '\n', '    /**\n', '     * @dev Prevents a contract from calling itself, directly or indirectly.\n', '     * Calling a `nonReentrant` function from another `nonReentrant`\n', '     * function is not supported. It is possible to prevent this from happening\n', '     * by making the `nonReentrant` function external, and make it call a\n', '     * `private` function that does the actual work.\n', '     */\n', '    modifier nonReentrant() {\n', '        _guardCounter += 1;\n', '        uint256 localCounter = _guardCounter;\n', '        _;\n', '        require(localCounter == _guardCounter);\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol\n', '\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale,\n', ' * allowing investors to purchase tokens with ether. This contract implements\n', ' * such functionality in its most fundamental form and can be extended to provide additional\n', ' * functionality and/or custom behavior.\n', ' * The external interface represents the basic interface for purchasing tokens, and conform\n', ' * the base architecture for crowdsales. They are *not* intended to be modified / overridden.\n', ' * The internal interface conforms the extensible and modifiable surface of crowdsales. Override\n', ' * the methods to add functionality. Consider using &#39;super&#39; where appropriate to concatenate\n', ' * behavior.\n', ' */\n', 'contract Crowdsale is ReentrancyGuard {\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for IERC20;\n', '\n', '    // The token being sold\n', '    IERC20 private _token;\n', '\n', '    // Address where funds are collected\n', '    address payable private _wallet;\n', '\n', '    // How many token units a buyer gets per wei.\n', '    // The rate is the conversion between wei and the smallest and indivisible token unit.\n', '    // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK\n', '    // 1 wei will give you 1 unit, or 0.001 TOK.\n', '    uint256 private _rate;\n', '\n', '    // Amount of wei raised\n', '    uint256 private _weiRaised;\n', '\n', '    /**\n', '     * Event for token purchase logging\n', '     * @param purchaser who paid for the tokens\n', '     * @param beneficiary who got the tokens\n', '     * @param value weis paid for purchase\n', '     * @param amount amount of tokens purchased\n', '     */\n', '    event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '    /**\n', '     * @param rate Number of token units a buyer gets per wei\n', '     * @dev The rate is the conversion between wei and the smallest and indivisible\n', '     * token unit. So, if you are using a rate of 1 with a ERC20Detailed token\n', '     * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.\n', '     * @param wallet Address where collected funds will be forwarded to\n', '     * @param token Address of the token being sold\n', '     */\n', '    constructor (uint256 rate, address payable wallet, IERC20 token) public {\n', '        require(rate > 0);\n', '        require(wallet != address(0));\n', '        require(address(token) != address(0));\n', '\n', '        _rate = rate;\n', '        _wallet = wallet;\n', '        _token = token;\n', '    }\n', '\n', '    /**\n', '     * @dev fallback function ***DO NOT OVERRIDE***\n', '     * Note that other contracts will transfer fund with a base gas stipend\n', '     * of 2300, which is not enough to call buyTokens. Consider calling\n', '     * buyTokens directly when purchasing tokens from a contract.\n', '     */\n', '    function () external payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @return the token being sold.\n', '     */\n', '    function token() public view returns (IERC20) {\n', '        return _token;\n', '    }\n', '\n', '    /**\n', '     * @return the address where funds are collected.\n', '     */\n', '    function wallet() public view returns (address payable) {\n', '        return _wallet;\n', '    }\n', '\n', '    /**\n', '     * @return the number of token units a buyer gets per wei.\n', '     */\n', '    function rate() public view returns (uint256) {\n', '        return _rate;\n', '    }\n', '\n', '    /**\n', '     * @return the amount of wei raised.\n', '     */\n', '    function weiRaised() public view returns (uint256) {\n', '        return _weiRaised;\n', '    }\n', '\n', '    /**\n', '     * @dev low level token purchase ***DO NOT OVERRIDE***\n', '     * This function has a non-reentrancy guard, so it shouldn&#39;t be called by\n', '     * another `nonReentrant` function.\n', '     * @param beneficiary Recipient of the token purchase\n', '     */\n', '    function buyTokens(address beneficiary) public nonReentrant payable {\n', '        uint256 weiAmount = msg.value;\n', '        _preValidatePurchase(beneficiary, weiAmount);\n', '\n', '        // calculate token amount to be created\n', '        uint256 tokens = _getTokenAmount(weiAmount);\n', '\n', '        // update state\n', '        _weiRaised = _weiRaised.add(weiAmount);\n', '\n', '        _processPurchase(beneficiary, tokens);\n', '        emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);\n', '\n', '        _updatePurchasingState(beneficiary, weiAmount);\n', '\n', '        _forwardFunds();\n', '        _postValidatePurchase(beneficiary, weiAmount);\n', '    }\n', '\n', '    /**\n', '     * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.\n', '     * Use `super` in contracts that inherit from Crowdsale to extend their validations.\n', '     * Example from CappedCrowdsale.sol&#39;s _preValidatePurchase method:\n', '     *     super._preValidatePurchase(beneficiary, weiAmount);\n', '     *     require(weiRaised().add(weiAmount) <= cap);\n', '     * @param beneficiary Address performing the token purchase\n', '     * @param weiAmount Value in wei involved in the purchase\n', '     */\n', '    function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {\n', '        require(beneficiary != address(0));\n', '        require(weiAmount != 0);\n', '    }\n', '\n', '    /**\n', '     * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid\n', '     * conditions are not met.\n', '     * @param beneficiary Address performing the token purchase\n', '     * @param weiAmount Value in wei involved in the purchase\n', '     */\n', '    function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {\n', '        // solhint-disable-previous-line no-empty-blocks\n', '    }\n', '\n', '    /**\n', '     * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends\n', '     * its tokens.\n', '     * @param beneficiary Address performing the token purchase\n', '     * @param tokenAmount Number of tokens to be emitted\n', '     */\n', '    function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {\n', '        _token.safeTransfer(beneficiary, tokenAmount);\n', '    }\n', '\n', '    /**\n', '     * @dev Executed when a purchase has been validated and is ready to be executed. Doesn&#39;t necessarily emit/send\n', '     * tokens.\n', '     * @param beneficiary Address receiving the tokens\n', '     * @param tokenAmount Number of tokens to be purchased\n', '     */\n', '    function _processPurchase(address beneficiary, uint256 tokenAmount) internal {\n', '        _deliverTokens(beneficiary, tokenAmount);\n', '    }\n', '\n', '    /**\n', '     * @dev Override for extensions that require an internal state to check for validity (current user contributions,\n', '     * etc.)\n', '     * @param beneficiary Address receiving the tokens\n', '     * @param weiAmount Value in wei involved in the purchase\n', '     */\n', '    function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {\n', '        // solhint-disable-previous-line no-empty-blocks\n', '    }\n', '\n', '    /**\n', '     * @dev Override to extend the way in which ether is converted to tokens.\n', '     * @param weiAmount Value in wei to be converted into tokens\n', '     * @return Number of tokens that can be purchased with the specified _weiAmount\n', '     */\n', '    function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {\n', '        return weiAmount.mul(_rate);\n', '    }\n', '\n', '    /**\n', '     * @dev Determines how ETH is stored/forwarded on purchases.\n', '     */\n', '    function _forwardFunds() internal {\n', '        _wallet.transfer(msg.value);\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol\n', '\n', '/**\n', ' * @title TimedCrowdsale\n', ' * @dev Crowdsale accepting contributions only within a time frame.\n', ' */\n', 'contract TimedCrowdsale is Crowdsale {\n', '    using SafeMath for uint256;\n', '\n', '    uint256 private _openingTime;\n', '    uint256 private _closingTime;\n', '\n', '    /**\n', '     * @dev Reverts if not in crowdsale time range.\n', '     */\n', '    modifier onlyWhileOpen {\n', '        require(isOpen());\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Constructor, takes crowdsale opening and closing times.\n', '     * @param openingTime Crowdsale opening time\n', '     * @param closingTime Crowdsale closing time\n', '     */\n', '    constructor (uint256 openingTime, uint256 closingTime) public {\n', '        // solhint-disable-next-line not-rely-on-time\n', '        require(openingTime >= block.timestamp);\n', '        require(closingTime > openingTime);\n', '\n', '        _openingTime = openingTime;\n', '        _closingTime = closingTime;\n', '    }\n', '\n', '    /**\n', '     * @return the crowdsale opening time.\n', '     */\n', '    function openingTime() public view returns (uint256) {\n', '        return _openingTime;\n', '    }\n', '\n', '    /**\n', '     * @return the crowdsale closing time.\n', '     */\n', '    function closingTime() public view returns (uint256) {\n', '        return _closingTime;\n', '    }\n', '\n', '    /**\n', '     * @return true if the crowdsale is open, false otherwise.\n', '     */\n', '    function isOpen() public view returns (bool) {\n', '        // solhint-disable-next-line not-rely-on-time\n', '        return block.timestamp >= _openingTime && block.timestamp <= _closingTime;\n', '    }\n', '\n', '    /**\n', '     * @dev Checks whether the period in which the crowdsale is open has already elapsed.\n', '     * @return Whether crowdsale period has elapsed\n', '     */\n', '    function hasClosed() public view returns (bool) {\n', '        // solhint-disable-next-line not-rely-on-time\n', '        return block.timestamp > _closingTime;\n', '    }\n', '\n', '    /**\n', '     * @dev Extend parent behavior requiring to be within contributing period\n', '     * @param beneficiary Token purchaser\n', '     * @param weiAmount Amount of wei contributed\n', '     */\n', '    function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {\n', '        super._preValidatePurchase(beneficiary, weiAmount);\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/crowdsale/distribution/PostDeliveryCrowdsale.sol\n', '\n', '/**\n', ' * @title PostDeliveryCrowdsale\n', ' * @dev Crowdsale that locks tokens from withdrawal until it ends.\n', ' */\n', 'contract PostDeliveryCrowdsale is TimedCrowdsale {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) private _balances;\n', '\n', '    /**\n', '     * @dev Withdraw tokens only after crowdsale ends.\n', '     * @param beneficiary Whose tokens will be withdrawn.\n', '     */\n', '    function withdrawTokens(address beneficiary) public {\n', '        require(hasClosed());\n', '        uint256 amount = _balances[beneficiary];\n', '        require(amount > 0);\n', '        _balances[beneficiary] = 0;\n', '        _deliverTokens(beneficiary, amount);\n', '    }\n', '\n', '    /**\n', '     * @return the balance of an account.\n', '     */\n', '    function balanceOf(address account) public view returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    /**\n', '     * @dev Overrides parent by storing balances instead of issuing tokens right away.\n', '     * @param beneficiary Token purchaser\n', '     * @param tokenAmount Amount of tokens purchased\n', '     */\n', '    function _processPurchase(address beneficiary, uint256 tokenAmount) internal {\n', '        _balances[beneficiary] = _balances[beneficiary].add(tokenAmount);\n', '    }\n', '\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/math/Math.sol\n', '\n', '/**\n', ' * @title Math\n', ' * @dev Assorted math operations\n', ' */\n', 'library Math {\n', '    /**\n', '    * @dev Returns the largest of two numbers.\n', '    */\n', '    function max(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    /**\n', '    * @dev Returns the smallest of two numbers.\n', '    */\n', '    function min(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    /**\n', '    * @dev Calculates the average of two numbers. Since these are integers,\n', '    * averages of an even and odd number cannot be represented, and will be\n', '    * rounded down.\n', '    */\n', '    function average(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // (a + b) / 2 can overflow, so we distribute\n', '        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/crowdsale/emission/AllowanceCrowdsale.sol\n', '\n', '/**\n', ' * @title AllowanceCrowdsale\n', ' * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.\n', ' */\n', 'contract AllowanceCrowdsale is Crowdsale {\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for IERC20;\n', '\n', '    address private _tokenWallet;\n', '\n', '    /**\n', '     * @dev Constructor, takes token wallet address.\n', '     * @param tokenWallet Address holding the tokens, which has approved allowance to the crowdsale\n', '     */\n', '    constructor (address tokenWallet) public {\n', '        require(tokenWallet != address(0));\n', '        _tokenWallet = tokenWallet;\n', '    }\n', '\n', '    /**\n', '     * @return the address of the wallet that will hold the tokens.\n', '     */\n', '    function tokenWallet() public view returns (address) {\n', '        return _tokenWallet;\n', '    }\n', '\n', '    /**\n', '     * @dev Checks the amount of tokens left in the allowance.\n', '     * @return Amount of tokens left in the allowance\n', '     */\n', '    function remainingTokens() public view returns (uint256) {\n', '        return Math.min(token().balanceOf(_tokenWallet), token().allowance(_tokenWallet, address(this)));\n', '    }\n', '\n', '    /**\n', '     * @dev Overrides parent behavior by transferring tokens from wallet.\n', '     * @param beneficiary Token purchaser\n', '     * @param tokenAmount Amount of tokens purchased\n', '     */\n', '    function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {\n', '        token().safeTransferFrom(_tokenWallet, beneficiary, tokenAmount);\n', '    }\n', '}\n', '\n', '// File: contracts/MocoCrowdsale.sol\n', '\n', 'contract MocoCrowdsale is TimedCrowdsale, AllowanceCrowdsale, Whitelisted {\n', '  // Amount of wei raised\n', '\n', '  uint256 public bonusPeriod;\n', '\n', '  uint256 public bonusAmount;\n', '  // Unlock period 1 - 6 month\n', '  uint256 private _unlock1;\n', '\n', '  // Unlock period 2 - 12 month\n', '  uint256 private _unlock2;\n', '\n', '  // Specify locked zone for 2nd period\n', '  uint8 private _lockedZone;\n', '\n', '  // Total tokens distributed\n', '  uint256 private _totalTokensDistributed;\n', '\n', '\n', '  // Total tokens locked\n', '  uint256 private _totalTokensLocked;\n', '\n', '\n', '  event TokensPurchased(\n', '    address indexed purchaser,\n', '    address indexed beneficiary,\n', '    address asset,\n', '    uint256 value,\n', '    uint256 amount\n', '  );\n', '\n', '  struct Asset {\n', '    uint256 weiRaised;\n', '    uint256 minAmount;\n', '    uint256 rate;\n', '    bool active;\n', '  }\n', '\n', '  mapping (address => Asset) private asset;\n', '  mapping (address => uint256) private _balances;\n', '\n', '\n', '  constructor(\n', '    uint256 _openingTime,\n', '    uint256 _closingTime,\n', '    uint256 _unlockPeriod1,\n', '    uint256 _unlockPeriod2,\n', '    uint256 _bonusPeriodEnd,\n', '    uint256 _bonusAmount,\n', '    uint256 _rate,\n', '    address payable _wallet,\n', '    IERC20 _token,\n', '    address _tokenWallet\n', '  ) public\n', '  TimedCrowdsale(_openingTime, _closingTime)\n', '  Crowdsale(_rate, _wallet, _token)\n', '  AllowanceCrowdsale(_tokenWallet){\n', '       _unlock1 = _unlockPeriod1;\n', '       _unlock2 = _unlockPeriod2;\n', '       bonusPeriod = _bonusPeriodEnd;\n', '      bonusAmount  = _bonusAmount;\n', '      asset[address(0)].rate  = _rate;\n', '  }\n', '  function getAssetRaised(address _assetAddress) public view returns(uint256) {\n', '      return asset[_assetAddress].weiRaised;\n', '  }\n', '  function getAssetMinAmount(address _assetAddress) public view returns(uint256) {\n', '      return asset[_assetAddress].minAmount;\n', '  }\n', '  function getAssetRate(address _assetAddress) public view returns(uint256) {\n', '      return asset[_assetAddress].rate;\n', '  }\n', '  function isAssetActive(address _assetAddress) public view returns(bool) {\n', '      return asset[_assetAddress].active == true ? true : false;\n', '  }\n', '  // Add asset\n', '  function setAsset(address _assetAddress, uint256 _weiRaised, uint256 _minAmount, uint256 _rate) public onlyOwner {\n', '      asset[_assetAddress].weiRaised = _weiRaised;\n', '      asset[_assetAddress].minAmount = _minAmount;\n', '      asset[_assetAddress].rate = _rate;\n', '      asset[_assetAddress].active = true;\n', '  }\n', '\n', '  //\n', '\n', '  function weiRaised(address _asset) public view returns (uint256) {\n', '    return asset[_asset].weiRaised;\n', '  }\n', '  function _getTokenAmount(uint256 weiAmount, address asst)\n', '    internal view returns (uint256)\n', '  {\n', '    return weiAmount.mul(asset[asst].rate);\n', '  }\n', '\n', '  function minAmount(address _asset) public view returns (uint256) {\n', '    return asset[_asset].minAmount;\n', '  }\n', '\n', '  // Buy Tokens\n', '  function buyTokens(address beneficiary) public onlyWhitelisted payable {\n', '    uint256 weiAmount = msg.value;\n', '    _preValidatePurchase(beneficiary, weiAmount, address(0));\n', '\n', '    // calculate token amount to be created\n', '    uint256 tokens = _getTokenAmount(weiAmount, address(0));\n', '\n', '    // update state\n', '    asset[address(0)].weiRaised = asset[address(0)].weiRaised.add(weiAmount);\n', '\n', '    _processPurchase(beneficiary, tokens);\n', '\n', '    emit TokensPurchased(\n', '      msg.sender,\n', '      beneficiary,\n', '      address(0),\n', '      weiAmount,\n', '      tokens\n', '    );\n', '\n', '    // super._updatePurchasingState(beneficiary, weiAmount);\n', '\n', '    super._forwardFunds();\n', '    // super._postValidatePurchase(beneficiary, weiAmount);\n', '  }\n', '  // Buy tokens for assets\n', '  function buyTokensAsset(address beneficiary, address asst, uint256 amount) public onlyWhitelisted {\n', '     require(isAssetActive(asst));\n', '    _preValidatePurchase(beneficiary, amount, asst);\n', '\n', '    // calculate token amount to be created\n', '    uint256 tokens = _getTokenAmount(amount, asst);\n', '\n', '    // update state\n', '    asset[asst].weiRaised = asset[asst].weiRaised.add(amount);\n', '\n', '    _processPurchase(beneficiary, tokens);\n', '\n', '    emit TokensPurchased(\n', '      msg.sender,\n', '      beneficiary,\n', '      asst,\n', '      amount,\n', '      tokens\n', '    );\n', '\n', '     address _wallet  = wallet();\n', '     IERC20(asst).safeTransferFrom(beneficiary, _wallet, amount);\n', '\n', '    // super._postValidatePurchase(beneficiary, weiAmount);\n', '  }\n', '\n', '  // Check if locked is end\n', '  function lockedHasEnd() public view returns (bool) {\n', '    return block.timestamp > _unlock1 ? true : false;\n', '  }\n', '  // Check if locked is end\n', '  function lockedTwoHasEnd() public view returns (bool) {\n', '    return block.timestamp > _unlock2 ? true : false;\n', '  }\n', '// Withdraw tokens after locked period is finished\n', '  function withdrawTokens(address beneficiary) public {\n', '    require(lockedHasEnd());\n', '    uint256 amount = _balances[beneficiary];\n', '    require(amount > 0);\n', '    uint256 zone = super.getWhitelistedZone(beneficiary);\n', '    if (zone == 840){\n', '      // require(lockedTwoHasEnd());\n', '      if(lockedTwoHasEnd()){\n', '        _balances[beneficiary] = 0;\n', '        _deliverTokens(beneficiary, amount);\n', '      }\n', '    } else {\n', '    _balances[beneficiary] = 0;\n', '    _deliverTokens(beneficiary, amount);\n', '    }\n', '  }\n', '\n', '  // Locked tokens balance\n', '  function balanceOf(address account) public view returns(uint256) {\n', '    return _balances[account];\n', '  }\n', '  // Pre validation token buy\n', '  function _preValidatePurchase(\n', '    address beneficiary,\n', '    uint256 weiAmount,\n', '    address asst\n', '  )\n', '    internal\n', '    view\n', '  {\n', '    require(beneficiary != address(0));\n', '    require(weiAmount != 0);\n', '    require(weiAmount >= minAmount(asst));\n', '}\n', '  function getBonusAmount(uint256 _tokenAmount) public view returns(uint256) {\n', '    return block.timestamp < bonusPeriod ? _tokenAmount.div(bonusAmount) : 0;\n', '  }\n', '\n', '  function calculateTokens(uint256 _weiAmount) public view returns(uint256) {\n', '    uint256 tokens  = _getTokenAmount(_weiAmount);\n', '    return  tokens + getBonusAmount(tokens);\n', '  }\n', '  function lockedTokens(address beneficiary, uint256 tokenAmount) public onlyOwner returns(bool) {\n', '    _balances[beneficiary] = _balances[beneficiary].add(tokenAmount);\n', '    return true;\n', '  }\n', '  function _processPurchase(\n', '    address beneficiary,\n', '    uint256 tokenAmount\n', '  )\n', '    internal\n', '  {\n', '    uint256 zone = super.getWhitelistedZone(beneficiary);\n', '   uint256 bonusTokens = getBonusAmount(tokenAmount);\n', '    if (zone == 840){\n', '      uint256 totalTokens = bonusTokens.add(tokenAmount);\n', '      _balances[beneficiary] = _balances[beneficiary].add(totalTokens);\n', '    }\n', '    else {\n', '      super._deliverTokens(beneficiary, tokenAmount);\n', '      _balances[beneficiary] = _balances[beneficiary].add(bonusTokens);\n', '    }\n', '\n', '  }\n', '\n', '}']