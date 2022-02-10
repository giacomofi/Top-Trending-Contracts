['pragma solidity ^0.4.21;\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale,\n', ' * allowing investors to purchase tokens with ether. This contract implements\n', ' * such functionality in its most fundamental form and can be extended to provide additional\n', ' * functionality and/or custom behavior.\n', ' * The external interface represents the basic interface for purchasing tokens, and conform\n', ' * the base architecture for crowdsales. They are *not* intended to be modified / overriden.\n', ' * The internal interface conforms the extensible and modifiable surface of crowdsales. Override\n', ' * the methods to add functionality. Consider using &#39;super&#39; where appropiate to concatenate\n', ' * behavior.\n', ' */\n', 'contract Crowdsale {\n', '    using SafeMath for uint256;\n', '\n', '    // The token being sold\n', '    ERC20 public token;\n', '\n', '    // Address where funds are collected\n', '    address public fundWallet;\n', '    \n', '    // the admin of the crowdsale\n', '    address public admin;\n', '\n', '    // Exchange rate:  1 eth = 10,000 TAUR\n', '    uint256 public rate = 10000;\n', '\n', '    // Amount of wei raised\n', '    uint256 public amountRaised;\n', '\n', '    // Crowdsale Status\n', '    bool public crowdsaleOpen;\n', '\n', '    // Crowdsale Cap\n', '    uint256 public cap;\n', '\n', '  /**\n', '   * Event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '    event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);\n', '\n', '  /**\n', '   * @param _token - Address of the token being sold\n', '   * @param _fundWallet - THe wallet where ether will be collected\n', '   */\n', '    function Crowdsale(ERC20 _token, address _fundWallet) public {\n', '        require(_token != address(0));\n', '        require(_fundWallet != address(0));\n', '\n', '        fundWallet = _fundWallet;\n', '        admin = msg.sender;\n', '        token = _token;\n', '        crowdsaleOpen = true;\n', '        cap = 20000 * 1 ether;\n', '    }\n', '\n', '  // -----------------------------------------\n', '  // Crowdsale external interface\n', '  // -----------------------------------------\n', '\n', '  /**\n', '   * @dev fallback function ***DO NOT OVERRIDE***\n', '   */\n', '    function () external payable {\n', '        buyTokens();\n', '    }\n', '\n', '  /**\n', '   * @dev low level token purchase ***DO NOT OVERRIDE***\n', '   */\n', '    function buyTokens() public payable {\n', '\n', '        // do necessary checks\n', '        require(crowdsaleOpen);\n', '        require(msg.sender != address(0));\n', '        require(msg.value != 0);\n', '        require(amountRaised.add(msg.value) <= cap);\n', '        \n', '        // calculate token amount to be created\n', '        uint256 tokens = (msg.value).mul(rate);\n', '\n', '        // update state\n', '        amountRaised = amountRaised.add(msg.value);\n', '\n', '        // transfer tokens to buyer\n', '        token.transfer(msg.sender, tokens);\n', '\n', '        // transfer eth to fund wallet\n', '        fundWallet.transfer(msg.value);\n', '\n', '        emit TokenPurchase (msg.sender, msg.value, tokens);\n', '    }\n', '\n', '    function lockRemainingTokens() onlyAdmin public {\n', '        token.transfer(admin, token.balanceOf(address(this)));\n', '    }\n', '\n', '    function setRate(uint256 _newRate) onlyAdmin public {\n', '        rate = _newRate;    \n', '    }\n', '    \n', '    function setFundWallet(address _fundWallet) onlyAdmin public {\n', '        require(_fundWallet != address(0));\n', '        fundWallet = _fundWallet; \n', '    }\n', '\n', '    function setCrowdsaleOpen(bool _crowdsaleOpen) onlyAdmin public {\n', '        crowdsaleOpen = _crowdsaleOpen;\n', '    }\n', '\n', '    function getEtherRaised() view public returns (uint256){\n', '        return amountRaised / 1 ether;\n', '    }\n', '\n', '    function capReached() public view returns (bool) {\n', '        return amountRaised >= cap;\n', '    }\n', '\n', '    modifier onlyAdmin {\n', '        require(msg.sender == admin);\n', '        _;\n', '    }  \n', '\n', '}']