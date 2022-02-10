['pragma solidity 0.5.4;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', "        // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipRenounced(address indexed previousOwner);\n', '    event OwnershipTransferred(\n', '        address indexed previousOwner,\n', '        address indexed newOwner\n', '    );\n', '\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to relinquish control of the contract.\n', '     * @notice Renouncing to ownership will leave the contract without an owner.\n', '     * It will not be possible to call the functions with the `onlyOwner`\n', '     * modifier anymore.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipRenounced(owner);\n', '        owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param _newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        _transferOwnership(_newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers control of the contract to a newOwner.\n', '     * @param _newOwner The address to transfer ownership to.\n', '     */\n', '    function _transferOwnership(address _newOwner) internal {\n', '        require(_newOwner != address(0));\n', '        emit OwnershipTransferred(owner, _newOwner);\n', '        owner = _newOwner;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20  {\n', '    function allowance(address owner, address spender)\n', '    public view returns (uint256);\n', '\n', '    function transferFrom(address from, address to, uint256 value)\n', '    public returns (bool);\n', '\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    );\n', '\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    function safeTransfer(ERC20 token, address to, uint256 value) internal {\n', '        require(token.transfer(to, value));\n', '    }\n', '\n', '    function safeTransferFrom(\n', '        ERC20 token,\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    )\n', '    internal\n', '    {\n', '        require(token.transferFrom(from, to, value));\n', '    }\n', '\n', '    function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '        require(token.approve(spender, value));\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale,\n', ' * allowing investors to purchase tokens with ether. This contract implements\n', ' * such functionality in its most fundamental form and can be extended to provide additional\n', ' * functionality and/or custom behavior.\n', ' * The external interface represents the basic interface for purchasing tokens, and conform\n', ' * the base architecture for crowdsales. They are *not* intended to be modified / overriden.\n', ' * The internal interface conforms the extensible and modifiable surface of crowdsales. Override\n', " * the methods to add functionality. Consider using 'super' where appropiate to concatenate\n", ' * behavior.\n', ' */\n', 'contract Crowdsale is Ownable {\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for ERC20;\n', '\n', '\n', '    // The token being sold\n', '    ERC20 public token;\n', '\n', '    // Address where funds are collected\n', '    address payable public wallet;\n', '\n', '    // Amount of wei raised\n', '    uint256 public weiRaised;\n', '    uint256 public tokensSold;\n', '\n', '    uint256 public cap = 30000000 ether; //cap in tokens\n', '\n', '    mapping (uint => uint) prices;\n', '    mapping (address => address) referrals;\n', '\n', '    /**\n', '     * Event for token purchase logging\n', '     * @param purchaser who paid for the tokens\n', '     * @param beneficiary who got the tokens\n', '     * @param value weis paid for purchase\n', '     * @param amount amount of tokens purchased\n', '     */\n', '    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '    event Finalized();\n', '    /**\n', '     * @dev Reverts if not in crowdsale time range.\n', '     */\n', '\n', '    constructor(address payable _wallet, address _token) public {\n', '        require(_wallet != address(0));\n', '        require(_token != address(0));\n', '\n', '        wallet = _wallet;\n', '        token = ERC20(_token);\n', '\n', '        prices[1] = 75000000000000000;\n', '        prices[2] = 105000000000000000;\n', '        prices[3] = 120000000000000000;\n', '        prices[4] = 135000000000000000;\n', '\n', '    }\n', '\n', '    // -----------------------------------------\n', '    // Crowdsale external interface\n', '    // -----------------------------------------\n', '\n', '    /**\n', '     * @dev fallback function ***DO NOT OVERRIDE***\n', '     */\n', '    function () external payable {\n', '        buyTokens(msg.sender, bytesToAddress(msg.data));\n', '    }\n', '\n', '    /**\n', '     * @dev low level token purchase ***DO NOT OVERRIDE***\n', '     * @param _beneficiary Address performing the token purchase\n', '     */\n', '    function buyTokens(address _beneficiary, address _referrer) public payable {\n', '        uint256 weiAmount = msg.value;\n', '        _preValidatePurchase(_beneficiary, weiAmount);\n', '\n', '        // calculate token amount to be created\n', '        uint256 tokens;\n', '        uint256 bonus;\n', '        uint256 price;\n', '        (tokens, bonus, price) = _getTokenAmount(weiAmount);\n', '\n', '        require(tokens >= 10 ether);\n', '\n', '        price = tokens.div(1 ether).mul(price);\n', '        uint256 _diff =  weiAmount.sub(price);\n', '\n', '        if (_diff > 0) {\n', '            weiAmount = weiAmount.sub(_diff);\n', '            msg.sender.transfer(_diff);\n', '        }\n', '\n', '\n', '        if (_referrer != address(0) && _referrer != _beneficiary) {\n', '            referrals[_beneficiary] = _referrer;\n', '        }\n', '\n', '        if (referrals[_beneficiary] != address(0)) {\n', '            uint refTokens = valueFromPercent(tokens, 1000);\n', '            _processPurchase(referrals[_beneficiary], refTokens);\n', '            tokensSold = tokensSold.add(refTokens);\n', '        }\n', '\n', '        tokens = tokens.add(bonus);\n', '\n', '        require(tokensSold.add(tokens) <= cap);\n', '\n', '        // update state\n', '        weiRaised = weiRaised.add(weiAmount);\n', '        tokensSold = tokensSold.add(tokens);\n', '\n', '        _processPurchase(_beneficiary, tokens);\n', '        emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);\n', '\n', '        _forwardFunds(weiAmount);\n', '    }\n', '\n', '    // -----------------------------------------\n', '    // Internal interface (extensible)\n', '    // -----------------------------------------\n', '\n', '    /**\n', '     * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.\n', '     * @param _beneficiary Address performing the token purchase\n', '     * @param _weiAmount Value in wei involved in the purchase\n', '     */\n', '    function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal pure {\n', '        require(_beneficiary != address(0));\n', '        require(_weiAmount != 0);\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.\n', '     * @param _beneficiary Address performing the token purchase\n', '     * @param _tokenAmount Number of tokens to be emitted\n', '     */\n', '    function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {\n', '        token.safeTransfer(_beneficiary, _tokenAmount);\n', '    }\n', '\n', '    /**\n', '     * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.\n', '     * @param _beneficiary Address receiving the tokens\n', '     * @param _tokenAmount Number of tokens to be purchased\n', '     */\n', '    function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {\n', '        _deliverTokens(_beneficiary, _tokenAmount);\n', '    }\n', '\n', '    /**\n', '     * @dev Override to extend the way in which ether is converted to tokens.\n', '     * @param _weiAmount Value in wei to be converted into tokens\n', '     * @return Number of tokens that can be purchased with the specified _weiAmount\n', '     */\n', '    function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256, uint256, uint256) {\n', '        if (block.timestamp >= 1551387600 && block.timestamp < 1554066000) {\n', '            return _calculateTokens(_weiAmount, 1);\n', '        } else if (block.timestamp >= 1554066000 && block.timestamp < 1556658000) {\n', '            return _calculateTokens(_weiAmount, 2);\n', '        } else if (block.timestamp >= 1556658000 && block.timestamp < 1559336400) {\n', '            return _calculateTokens(_weiAmount, 3);\n', '        } else if (block.timestamp >= 1559336400 && block.timestamp < 1561928400) {\n', '            return _calculateTokens(_weiAmount, 4);\n', '        } else return (0,0,0);\n', '\n', '    }\n', '\n', '\n', '    function _calculateTokens(uint256 _weiAmount, uint _stage) internal view returns (uint256, uint256, uint256) {\n', '        uint price = prices[_stage];\n', '        uint tokens = _weiAmount.div(price);\n', '        uint bonus;\n', '        if (tokens >= 10 && tokens <= 100) {\n', '            bonus = 1000;\n', '        } else if (tokens > 100 && tokens <= 1000) {\n', '            bonus = 1500;\n', '        } else if (tokens > 1000 && tokens <= 10000) {\n', '            bonus = 2000;\n', '        } else if (tokens > 10000 && tokens <= 100000) {\n', '            bonus = 2500;\n', '        } else if (tokens > 100000 && tokens <= 1000000) {\n', '            bonus = 3000;\n', '        } else if (tokens > 1000000 && tokens <= 10000000) {\n', '            bonus = 3500;\n', '        } else if (tokens > 10000000) {\n', '            bonus = 4000;\n', '        }\n', '\n', '        bonus = valueFromPercent(tokens, bonus);\n', '        return (tokens.mul(1 ether), bonus.mul(1 ether), price);\n', '\n', '    }\n', '\n', '    /**\n', '     * @dev Determines how ETH is stored/forwarded on purchases.\n', '     */\n', '    function _forwardFunds(uint _weiAmount) internal {\n', '        wallet.transfer(_weiAmount);\n', '    }\n', '\n', '\n', '    /**\n', '    * @dev Checks whether the cap has been reached.\n', '    * @return Whether the cap was reached\n', '    */\n', '    function capReached() public view returns (bool) {\n', '        return tokensSold >= cap;\n', '    }\n', '\n', '    /**\n', '     * @dev Must be called after crowdsale ends, to do some extra finalization\n', "     * work. Calls the contract's finalization function.\n", '     */\n', '    function finalize() onlyOwner public {\n', '        finalization();\n', '        emit Finalized();\n', '    }\n', '\n', '    /**\n', '     * @dev Can be overridden to add finalization logic. The overriding function\n', '     * should call super.finalization() to ensure the chain of finalization is\n', '     * executed entirely.\n', '     */\n', '    function finalization() internal {\n', '        token.safeTransfer(wallet, token.balanceOf(address(this)));\n', '    }\n', '\n', '\n', '    function updatePrice(uint _stage, uint _newPrice) onlyOwner external {\n', '        prices[_stage] = _newPrice;\n', '    }\n', '\n', '    function bytesToAddress(bytes memory bys) private pure returns (address addr) {\n', '        assembly {\n', '            addr := mload(add(bys, 20))\n', '        }\n', '    }\n', '\n', '    //1% - 100, 10% - 1000 50% - 5000\n', '    function valueFromPercent(uint _value, uint _percent) internal pure returns (uint amount)    {\n', '        uint _amount = _value.mul(_percent).div(10000);\n', '        return (_amount);\n', '    }\n', '}']