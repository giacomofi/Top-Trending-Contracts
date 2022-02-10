['pragma solidity ^0.4.21;\n', '\n', '// File: node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: contracts/cupExchange/CupExchange.sol\n', '\n', 'interface token {\n', '    function transfer(address receiver, uint amount) external returns(bool);\n', '    function transferFrom(address from, address to, uint amount) external returns(bool);\n', '    function allowance(address owner, address spender) external returns(uint256);\n', '    function balanceOf(address owner) external returns(uint256);\n', '}\n', '\n', 'contract CupExchange {\n', '    using SafeMath for uint256;\n', '    using SafeMath for int256;\n', '\n', '    address public owner;\n', '    token internal teamCup;\n', '    token internal cup;\n', '    uint256 public exchangePrice; // with decimals\n', '    bool public halting = true;\n', '\n', '    event Halted(bool halting);\n', '    event Exchange(address user, uint256 distributedAmount, uint256 collectedAmount);\n', '\n', '    /**\n', '     * Constructor function\n', '     *\n', '     * Setup the contract owner\n', '     */\n', '    constructor(address cupToken, address teamCupToken) public {\n', '        owner = msg.sender;\n', '        teamCup = token(teamCupToken);\n', '        cup = token(cupToken);\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * User exchange for team cup\n', '     */\n', '    function exchange() public {\n', '        require(msg.sender != address(0x0));\n', '        require(msg.sender != address(this));\n', '        require(!halting);\n', '\n', '        // collect cup token\n', '        uint256 allowance = cup.allowance(msg.sender, this);\n', '        require(allowance > 0);\n', '        require(cup.transferFrom(msg.sender, this, allowance));\n', '\n', '        // transfer team cup token\n', '        uint256 teamCupBalance = teamCup.balanceOf(address(this));\n', '        uint256 teamCupAmount = allowance * exchangePrice;\n', '        require(teamCupAmount <= teamCupBalance);\n', '        require(teamCup.transfer(msg.sender, teamCupAmount));\n', '\n', '        emit Exchange(msg.sender, teamCupAmount, allowance);\n', '    }\n', '\n', '    /**\n', '     * Withdraw the funds\n', '     */\n', '    function safeWithdrawal(address safeAddress) public onlyOwner {\n', '        require(safeAddress != address(0x0));\n', '        require(safeAddress != address(this));\n', '\n', '        uint256 balance = teamCup.balanceOf(address(this));\n', '        teamCup.transfer(safeAddress, balance);\n', '    }\n', '\n', '    /**\n', '    * Set finalPriceForThisCoin\n', '    */\n', '    function setExchangePrice(int256 price) public onlyOwner {\n', '        require(price > 0);\n', '        exchangePrice = uint256(price);\n', '    }\n', '\n', '    function halt() public onlyOwner {\n', '        halting = true;\n', '        emit Halted(halting);\n', '    }\n', '\n', '    function unhalt() public onlyOwner {\n', '        halting = false;\n', '        emit Halted(halting);\n', '    }\n', '}\n', '\n', '// File: contracts/cupExchange/cupExchangeImpl/JACupExchange.sol\n', '\n', 'contract JACupExchange is CupExchange {\n', '    address public cup = 0x0750167667190A7Cd06a1e2dBDd4006eD5b522Cc;\n', '    address public teamCup = 0x1735ce83332E8be63D371a99A842C19737651308;\n', '    constructor() CupExchange(cup, teamCup) public {}\n', '}']
['pragma solidity ^0.4.21;\n', '\n', '// File: node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: contracts/cupExchange/CupExchange.sol\n', '\n', 'interface token {\n', '    function transfer(address receiver, uint amount) external returns(bool);\n', '    function transferFrom(address from, address to, uint amount) external returns(bool);\n', '    function allowance(address owner, address spender) external returns(uint256);\n', '    function balanceOf(address owner) external returns(uint256);\n', '}\n', '\n', 'contract CupExchange {\n', '    using SafeMath for uint256;\n', '    using SafeMath for int256;\n', '\n', '    address public owner;\n', '    token internal teamCup;\n', '    token internal cup;\n', '    uint256 public exchangePrice; // with decimals\n', '    bool public halting = true;\n', '\n', '    event Halted(bool halting);\n', '    event Exchange(address user, uint256 distributedAmount, uint256 collectedAmount);\n', '\n', '    /**\n', '     * Constructor function\n', '     *\n', '     * Setup the contract owner\n', '     */\n', '    constructor(address cupToken, address teamCupToken) public {\n', '        owner = msg.sender;\n', '        teamCup = token(teamCupToken);\n', '        cup = token(cupToken);\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * User exchange for team cup\n', '     */\n', '    function exchange() public {\n', '        require(msg.sender != address(0x0));\n', '        require(msg.sender != address(this));\n', '        require(!halting);\n', '\n', '        // collect cup token\n', '        uint256 allowance = cup.allowance(msg.sender, this);\n', '        require(allowance > 0);\n', '        require(cup.transferFrom(msg.sender, this, allowance));\n', '\n', '        // transfer team cup token\n', '        uint256 teamCupBalance = teamCup.balanceOf(address(this));\n', '        uint256 teamCupAmount = allowance * exchangePrice;\n', '        require(teamCupAmount <= teamCupBalance);\n', '        require(teamCup.transfer(msg.sender, teamCupAmount));\n', '\n', '        emit Exchange(msg.sender, teamCupAmount, allowance);\n', '    }\n', '\n', '    /**\n', '     * Withdraw the funds\n', '     */\n', '    function safeWithdrawal(address safeAddress) public onlyOwner {\n', '        require(safeAddress != address(0x0));\n', '        require(safeAddress != address(this));\n', '\n', '        uint256 balance = teamCup.balanceOf(address(this));\n', '        teamCup.transfer(safeAddress, balance);\n', '    }\n', '\n', '    /**\n', '    * Set finalPriceForThisCoin\n', '    */\n', '    function setExchangePrice(int256 price) public onlyOwner {\n', '        require(price > 0);\n', '        exchangePrice = uint256(price);\n', '    }\n', '\n', '    function halt() public onlyOwner {\n', '        halting = true;\n', '        emit Halted(halting);\n', '    }\n', '\n', '    function unhalt() public onlyOwner {\n', '        halting = false;\n', '        emit Halted(halting);\n', '    }\n', '}\n', '\n', '// File: contracts/cupExchange/cupExchangeImpl/JACupExchange.sol\n', '\n', 'contract JACupExchange is CupExchange {\n', '    address public cup = 0x0750167667190A7Cd06a1e2dBDd4006eD5b522Cc;\n', '    address public teamCup = 0x1735ce83332E8be63D371a99A842C19737651308;\n', '    constructor() CupExchange(cup, teamCup) public {}\n', '}']