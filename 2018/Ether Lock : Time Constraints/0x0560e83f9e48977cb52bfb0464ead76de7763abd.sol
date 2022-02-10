['pragma solidity ^0.4.23;\n', '\n', '/**\n', ' * EasyInvest 6 Contract\n', ' *  - GAIN 6% PER 24 HOURS\n', ' *  - STRONG MARKETING SUPPORT  \n', ' *  - NEW BETTER IMPROVEMENTS\n', ' * How to use:\n', ' *  1. Send any amount of ether to make an investment;\n', ' *  2a. Claim your profit by sending 0 ether transaction (every day, every week, i don&#39;t care unless you&#39;re spending too much on GAS);\n', ' *  OR\n', ' *  2b. Send more ether to reinvest AND get your profit at the same time;\n', ' *\n', ' * RECOMMENDED GAS LIMIT: 200000\n', ' * RECOMMENDED GAS PRICE: https://ethgasstation.info/\n', ' *\n', ' * Contract is reviewed and approved by professionals!\n', ' */\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // Gas optimization: this is cheaper than requiring &#39;a&#39; not being zero, but the\n', '    // benefit is lost if &#39;b&#39; is also tested.\n', '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor () public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract EasyInvest6 is Ownable\n', '{   \n', '    using SafeMath for uint;\n', '    \n', '    mapping (address => uint) public invested;\n', '    mapping (address => uint) public lastInvest;\n', '    address[] public investors;\n', '    \n', '    address private m1;\n', '    address private m2;\n', '    \n', '    \n', '    function getInvestorsCount() public view returns(uint) \n', '    {   \n', '        return investors.length;\n', '    }\n', '    \n', '    function () external payable \n', '    {   \n', '        if(msg.value > 0) \n', '        {   \n', '            require(msg.value >= 100 finney, "require minimum 0.01 ETH"); // min 0.01 ETH\n', '            \n', '            uint fee = msg.value.mul(7).div(100).add(msg.value.div(200)); // 7.5%;            \n', '            if(m1 != address(0)) m1.transfer(fee);\n', '            if(m2 != address(0)) m2.transfer(fee);\n', '        }\n', '    \n', '        payWithdraw(msg.sender);\n', '        \n', '        if (invested[msg.sender] == 0) \n', '        {\n', '            investors.push(msg.sender);\n', '        }\n', '        \n', '        lastInvest[msg.sender] = now;\n', '        invested[msg.sender] += msg.value;\n', '    }\n', '    \n', '    function getNumberOfPeriods(uint startTime, uint endTime) public pure returns (uint)\n', '    {\n', '        return endTime.sub(startTime).div(1 days);\n', '    }\n', '    \n', '    function getWithdrawAmount(uint investedSum, uint numberOfPeriods) public pure returns (uint)\n', '    {\n', '        return investedSum.mul(6).div(100).mul(numberOfPeriods);\n', '    }\n', '    \n', '    function payWithdraw(address to) internal\n', '    {\n', '        if (invested[to] != 0) \n', '        {\n', '            uint numberOfPeriods = getNumberOfPeriods(lastInvest[to], now);\n', '            uint amount = getWithdrawAmount(invested[to], numberOfPeriods);\n', '            to.transfer(amount);\n', '        }\n', '    }\n', '    \n', '    function batchWithdraw(address[] to) onlyOwner public \n', '    {\n', '        for(uint i = 0; i < to.length; i++)\n', '        {\n', '            payWithdraw(to[i]);\n', '        }\n', '    }\n', '    \n', '    function batchWithdraw(uint startIndex, uint length) onlyOwner public \n', '    {\n', '        for(uint i = startIndex; i < length; i++)\n', '        {\n', '            payWithdraw(investors[i]);\n', '        }\n', '    }\n', '    \n', '    function setM1(address addr) onlyOwner public \n', '    {\n', '        m1 = addr;\n', '    }\n', '    \n', '    function setM2(address addr) onlyOwner public \n', '    {\n', '        m2 = addr;\n', '    }\n', '}']
['pragma solidity ^0.4.23;\n', '\n', '/**\n', ' * EasyInvest 6 Contract\n', ' *  - GAIN 6% PER 24 HOURS\n', ' *  - STRONG MARKETING SUPPORT  \n', ' *  - NEW BETTER IMPROVEMENTS\n', ' * How to use:\n', ' *  1. Send any amount of ether to make an investment;\n', " *  2a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're spending too much on GAS);\n", ' *  OR\n', ' *  2b. Send more ether to reinvest AND get your profit at the same time;\n', ' *\n', ' * RECOMMENDED GAS LIMIT: 200000\n', ' * RECOMMENDED GAS PRICE: https://ethgasstation.info/\n', ' *\n', ' * Contract is reviewed and approved by professionals!\n', ' */\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor () public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract EasyInvest6 is Ownable\n', '{   \n', '    using SafeMath for uint;\n', '    \n', '    mapping (address => uint) public invested;\n', '    mapping (address => uint) public lastInvest;\n', '    address[] public investors;\n', '    \n', '    address private m1;\n', '    address private m2;\n', '    \n', '    \n', '    function getInvestorsCount() public view returns(uint) \n', '    {   \n', '        return investors.length;\n', '    }\n', '    \n', '    function () external payable \n', '    {   \n', '        if(msg.value > 0) \n', '        {   \n', '            require(msg.value >= 100 finney, "require minimum 0.01 ETH"); // min 0.01 ETH\n', '            \n', '            uint fee = msg.value.mul(7).div(100).add(msg.value.div(200)); // 7.5%;            \n', '            if(m1 != address(0)) m1.transfer(fee);\n', '            if(m2 != address(0)) m2.transfer(fee);\n', '        }\n', '    \n', '        payWithdraw(msg.sender);\n', '        \n', '        if (invested[msg.sender] == 0) \n', '        {\n', '            investors.push(msg.sender);\n', '        }\n', '        \n', '        lastInvest[msg.sender] = now;\n', '        invested[msg.sender] += msg.value;\n', '    }\n', '    \n', '    function getNumberOfPeriods(uint startTime, uint endTime) public pure returns (uint)\n', '    {\n', '        return endTime.sub(startTime).div(1 days);\n', '    }\n', '    \n', '    function getWithdrawAmount(uint investedSum, uint numberOfPeriods) public pure returns (uint)\n', '    {\n', '        return investedSum.mul(6).div(100).mul(numberOfPeriods);\n', '    }\n', '    \n', '    function payWithdraw(address to) internal\n', '    {\n', '        if (invested[to] != 0) \n', '        {\n', '            uint numberOfPeriods = getNumberOfPeriods(lastInvest[to], now);\n', '            uint amount = getWithdrawAmount(invested[to], numberOfPeriods);\n', '            to.transfer(amount);\n', '        }\n', '    }\n', '    \n', '    function batchWithdraw(address[] to) onlyOwner public \n', '    {\n', '        for(uint i = 0; i < to.length; i++)\n', '        {\n', '            payWithdraw(to[i]);\n', '        }\n', '    }\n', '    \n', '    function batchWithdraw(uint startIndex, uint length) onlyOwner public \n', '    {\n', '        for(uint i = startIndex; i < length; i++)\n', '        {\n', '            payWithdraw(investors[i]);\n', '        }\n', '    }\n', '    \n', '    function setM1(address addr) onlyOwner public \n', '    {\n', '        m1 = addr;\n', '    }\n', '    \n', '    function setM2(address addr) onlyOwner public \n', '    {\n', '        m2 = addr;\n', '    }\n', '}']
