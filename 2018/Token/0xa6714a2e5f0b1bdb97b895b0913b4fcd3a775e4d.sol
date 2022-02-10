['pragma solidity ^0.4.18;\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', 'contract DateTime {\n', '        /*\n', '         *  Date and Time utilities for ethereum contracts\n', '         *\n', '         */\n', '        struct _DateTime {\n', '                uint16 year;\n', '                uint8 month;\n', '                uint8 day;\n', '                uint8 hour;\n', '                uint8 minute;\n', '                uint8 second;\n', '                uint8 weekday;\n', '        }\n', '\n', '        uint constant DAY_IN_SECONDS = 86400;\n', '        uint constant YEAR_IN_SECONDS = 31536000;\n', '        uint constant LEAP_YEAR_IN_SECONDS = 31622400;\n', '\n', '        uint constant HOUR_IN_SECONDS = 3600;\n', '        uint constant MINUTE_IN_SECONDS = 60;\n', '\n', '        uint16 constant ORIGIN_YEAR = 1970;\n', '\n', '        function isLeapYear(uint16 year) public pure returns (bool) {\n', '                if (year % 4 != 0) {\n', '                        return false;\n', '                }\n', '                if (year % 100 != 0) {\n', '                        return true;\n', '                }\n', '                if (year % 400 != 0) {\n', '                        return false;\n', '                }\n', '                return true;\n', '        }\n', '\n', '        function leapYearsBefore(uint year) public pure returns (uint) {\n', '                year -= 1;\n', '                return year / 4 - year / 100 + year / 400;\n', '        }\n', '\n', '        function getDaysInMonth(uint8 month, uint16 year) public pure returns (uint8) {\n', '                if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {\n', '                    return 31;\n', '                } else if (month == 4 || month == 6 || month == 9 || month == 11) {\n', '                    return 30;\n', '                } else if (isLeapYear(year)) {\n', '                    return 29;\n', '                } else {\n', '                    return 28;\n', '                }\n', '        }\n', '\n', '        function parseTimestamp(uint timestamp) internal pure returns (_DateTime dt) {\n', '                uint secondsAccountedFor = 0;\n', '                uint buf;\n', '                uint8 i;\n', '\n', '                // Year\n', '                dt.year = getYear(timestamp);\n', '                buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);\n', '\n', '                secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;\n', '                secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);\n', '\n', '                // Month\n', '                uint secondsInMonth;\n', '                for (i = 1; i <= 12; i++) {\n', '                        secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);\n', '                        if (secondsInMonth + secondsAccountedFor > timestamp) {\n', '                                dt.month = i;\n', '                                break;\n', '                        }\n', '                        secondsAccountedFor += secondsInMonth;\n', '                }\n', '\n', '                // Day\n', '                for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {\n', '                        if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {\n', '                                dt.day = i;\n', '                                break;\n', '                        }\n', '                        secondsAccountedFor += DAY_IN_SECONDS;\n', '                }\n', '\n', '                // Hour\n', '                dt.hour = getHour(timestamp);\n', '\n', '                // Minute\n', '                dt.minute = getMinute(timestamp);\n', '\n', '                // Second\n', '                dt.second = getSecond(timestamp);\n', '\n', '                // Day of week.\n', '                dt.weekday = getWeekday(timestamp);\n', '        }\n', '\n', '        function getYear(uint timestamp) public pure returns (uint16) {\n', '                uint secondsAccountedFor = 0;\n', '                uint16 year;\n', '                uint numLeapYears;\n', '\n', '                // Year\n', '                year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);\n', '                numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);\n', '\n', '                secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;\n', '                secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);\n', '\n', '                while (secondsAccountedFor > timestamp) {\n', '                        if (isLeapYear(uint16(year - 1))) {\n', '                                secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;\n', '                        } else {\n', '                                secondsAccountedFor -= YEAR_IN_SECONDS;\n', '                        }\n', '                        year -= 1;\n', '                }\n', '                return year;\n', '        }\n', '\n', '        function getMonth(uint timestamp) public pure returns (uint8) {\n', '                return parseTimestamp(timestamp).month;\n', '        }\n', '\n', '        function getDay(uint timestamp) public pure returns (uint8) {\n', '                return parseTimestamp(timestamp).day;\n', '        }\n', '\n', '        function getHour(uint timestamp) public pure returns (uint8) {\n', '                return uint8((timestamp / 60 / 60) % 24);\n', '        }\n', '\n', '        function getMinute(uint timestamp) public pure returns (uint8) {\n', '                return uint8((timestamp / 60) % 60);\n', '        }\n', '\n', '        function getSecond(uint timestamp) public pure returns (uint8) {\n', '                return uint8(timestamp % 60);\n', '        }\n', '\n', '        function getWeekday(uint timestamp) public pure returns (uint8) {\n', '                return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);\n', '        }\n', '\n', '        function toTimestamp(uint16 year, uint8 month, uint8 day) public pure returns (uint timestamp) {\n', '                return toTimestamp(year, month, day, 0, 0, 0);\n', '        }\n', '\n', '        function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) public pure returns (uint timestamp) {\n', '                return toTimestamp(year, month, day, hour, 0, 0);\n', '        }\n', '\n', '        function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) public pure returns (uint timestamp) {\n', '                return toTimestamp(year, month, day, hour, minute, 0);\n', '        }\n', '\n', '        function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) public pure returns (uint timestamp) {\n', '                uint16 i;\n', '\n', '                // Year\n', '                for (i = ORIGIN_YEAR; i < year; i++) {\n', '                        if (isLeapYear(i)) {\n', '                            timestamp += LEAP_YEAR_IN_SECONDS;\n', '                        } else {\n', '                            timestamp += YEAR_IN_SECONDS;\n', '                        }\n', '                }\n', '\n', '                // Month\n', '                uint8[12] memory monthDayCounts;\n', '                monthDayCounts[0] = 31;\n', '                if (isLeapYear(year)) {\n', '                    monthDayCounts[1] = 29;\n', '                } else {\n', '                    monthDayCounts[1] = 28;\n', '                }\n', '                monthDayCounts[2] = 31;\n', '                monthDayCounts[3] = 30;\n', '                monthDayCounts[4] = 31;\n', '                monthDayCounts[5] = 30;\n', '                monthDayCounts[6] = 31;\n', '                monthDayCounts[7] = 31;\n', '                monthDayCounts[8] = 30;\n', '                monthDayCounts[9] = 31;\n', '                monthDayCounts[10] = 30;\n', '                monthDayCounts[11] = 31;\n', '\n', '                for (i = 1; i < month; i++) {\n', '                        timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];\n', '                }\n', '\n', '                // Day\n', '                timestamp += DAY_IN_SECONDS * (day - 1);\n', '\n', '                // Hour\n', '                timestamp += HOUR_IN_SECONDS * (hour);\n', '\n', '                // Minute\n', '                timestamp += MINUTE_IN_SECONDS * (minute);\n', '\n', '                // Second\n', '                timestamp += second;\n', '\n', '                return timestamp;\n', '        }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Authorizable\n', ' * @dev Allows to authorize access to certain function calls\n', ' *\n', ' * ABI\n', ' * [{"constant":true,"inputs":[{"name":"authorizerIndex","type":"uint256"}],"name":"getAuthorizer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"inputs":[],"payable":false,"type":"constructor"}]\n', ' */\n', 'contract Authorizable {\n', '\n', '    address[] authorizers;\n', '    mapping(address => uint) authorizerIndex;\n', '\n', '    /**\n', '     * @dev Throws if called by any account tat is not authorized.\n', '     */\n', '    modifier onlyAuthorized {\n', '        require(isAuthorized(msg.sender));\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Contructor that authorizes the msg.sender.\n', '     */\n', '    function Authorizable() public {\n', '        authorizers.length = 2;\n', '        authorizers[1] = msg.sender;\n', '        authorizerIndex[msg.sender] = 1;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to get a specific authorizer\n', '     * @param _authorizerIndex index of the authorizer to be retrieved.\n', '     * @return The address of the authorizer.\n', '     */\n', '    function getAuthorizer(uint _authorizerIndex) external view returns(address) {\n', '        return address(authorizers[_authorizerIndex + 1]);\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check if an address is authorized\n', '     * @param _addr the address to check if it is authorized.\n', '     * @return boolean flag if address is authorized.\n', '     */\n', '    function isAuthorized(address _addr) public view returns(bool) {\n', '        return authorizerIndex[_addr] > 0;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to add a new authorizer\n', '     * @param _addr the address to add as a new authorizer.\n', '     */\n', '    function addAuthorized(address _addr) external onlyAuthorized {\n', '        authorizerIndex[_addr] = authorizers.length;\n', '        authorizers.length++;\n', '        authorizers[authorizers.length - 1] = _addr;\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) public onlyOwner canMint  returns (bool) {\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    Transfer(address(0), _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() public onlyOwner canMint  returns (bool) {\n', '    mintingFinished = true;\n', '    MintFinished();\n', '    return true;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title PromotionCoin\n', ' * @dev The main PC token contract\n', ' */\n', 'contract PromotionCoin is MintableToken {\n', '\n', '    string public name = "PromotionCoin";\n', '    string public symbol = "PC";\n', '    uint public decimals = 5;\n', '\n', '    /**\n', '     * @dev Allows anyone to transfer \n', '     * @param _to the recipient address of the tokens.\n', '     * @param _value number of tokens to be transfered.\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        super.transfer(_to, _value);\n', '    }\n', '\n', '    /**\n', '    * @dev Allows anyone to transfer \n', '    * @param _from address The address which you want to send tokens from\n', '    * @param _to address The address which you want to transfer to\n', '    * @param _value uint the amout of tokens to be transfered\n', '    */\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool) {\n', '        super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title PromotionCoinDistribution\n', ' * @dev The main PC token sale contract\n', ' *\n', ' * ABI\n', ' */\n', 'contract PromotionCoinDistribution is Ownable, Authorizable {\n', '    using SafeMath for uint;\n', '\n', '    event AuthorizedCreateToPrivate(address recipient, uint pay_amount);\n', '    event Mined(address recipient, uint pay_amount);\n', '    event CreateTokenToTeam(address recipient, uint pay_amount);\n', '    event CreateTokenToMarket(address recipient, uint pay_amount);\n', '    event CreateTokenToOperation(address recipient, uint pay_amount);\n', '    event CreateTokenToTax(address recipient, uint pay_amount);\n', '    event PromotionCoinMintFinished();\n', '    \n', '    PromotionCoin public token = new PromotionCoin();\n', '    DateTime internal dateTime = new DateTime();\n', '    \n', '    uint public DICIMALS = 5;\n', '\n', '    uint totalToken = 21000000000 * (10 ** DICIMALS); //210亿\n', '\n', '    uint public privateTokenCap = 5000000000 * (10 ** DICIMALS); //私募发行50亿\n', '    uint public marketToken2018 = 0.50 * 1500000000 * (10 ** DICIMALS); //全球推广15亿，第一年 50%\n', '    uint public marketToken2019 = 0.25 * 1500000000 * (10 ** DICIMALS); //全球推广15亿, 第二年 25%\n', '    uint public marketToken2020 = 0.15 * 1500000000 * (10 ** DICIMALS); //全球推广15亿, 第三年 15%\n', '    uint public marketToken2021 = 0.10 * 1500000000 * (10 ** DICIMALS); //全球推广15亿, 第四年 10%\n', '    \n', '\n', '    uint public operationToken = 2000000000 * (10 ** DICIMALS); //社区运营20亿\n', '    uint public minedTokenCap = 11000000000 * (10 ** DICIMALS); //挖矿110亿\n', '    uint public teamToken2018 = 500000000 * (10 ** DICIMALS); //团队预留10亿(10%),2018年发放5亿\n', '    uint public teamToken2019 = 500000000 * (10 ** DICIMALS); //团队预留10亿(10%),2019年发放5亿\n', '    uint public taxToken = 500000000 * (10 ** DICIMALS); //税务及法务年发放5亿\n', '\n', '    uint public privateToken = 0; //私募已发行数量\n', '\n', '    address public teamAddress;\n', '    address public operationAddress;\n', '    address public marketAddress;\n', '    address public taxAddress;\n', '\n', '    bool public team2018TokenCreated = false;\n', '    bool public team2019TokenCreated = false;\n', '    bool public operationTokenCreated = false;\n', '    bool public market2018TokenCreated = false;\n', '    bool public market2019TokenCreated = false;\n', '    bool public market2020TokenCreated = false;\n', '    bool public market2021TokenCreated = false;\n', '    bool public taxTokenCreated = false;\n', '\n', '    //year => token\n', '    mapping(uint16 => uint) public minedToken; //游戏挖矿已发行数量\n', '\n', '    uint public firstYearMinedTokenCap = 5500000000 * (10 ** DICIMALS); //2018年55亿(110亿*0.5)，以后逐年减半 \n', '\n', '    uint public minedTokenStartTime = 1514736000; //new Date("Jan 01 2018 00:00:00 GMT+8").getTime() / 1000;\n', '\n', '    function isContract(address _addr) internal view returns(bool) {\n', '        uint size;\n', '        if (_addr == 0) \n', '            return false;\n', '\n', '        assembly {\n', '            size := extcodesize(_addr)\n', '        }\n', '        return size > 0;\n', '    }\n', '\n', '    //2018年55亿(110亿*0.5)，以后逐年减半，到2028年发放剩余的全部\n', '    function getCurrentYearMinedTokenCap(uint _currentYear) public view returns(uint) {\n', '        require(_currentYear <= 2028);\n', '\n', '        if (_currentYear < 2028) {\n', '            uint divTimes = 2 ** (_currentYear - 2018);\n', '            uint currentYearMinedTokenCap = firstYearMinedTokenCap.div(divTimes).div(10 ** DICIMALS).mul(10 ** DICIMALS);\n', '            return currentYearMinedTokenCap;\n', '        } else if (_currentYear == 2028) {\n', '            return 10742188 * (10 ** DICIMALS);\n', '        } else {\n', '            revert();\n', '        }\n', '    }\n', '\n', '    function getCurrentYearRemainToken(uint16 _currentYear) public view returns(uint) {\n', '        uint currentYearMinedTokenCap = getCurrentYearMinedTokenCap(_currentYear);\n', '\n', '         if (minedToken[_currentYear] == 0) {\n', '             return currentYearMinedTokenCap;\n', '         } else {\n', '             return currentYearMinedTokenCap.sub(minedToken[_currentYear]);\n', '         }\n', '    }\n', '\n', '    function setTeamAddress(address _address) public onlyAuthorized {\n', '        teamAddress = _address;\n', '    }\n', '\n', '    function setMarketAddress(address _address) public onlyAuthorized {\n', '        marketAddress = _address;\n', '    }\n', '\n', '    function setOperationAddress(address _address) public onlyAuthorized {\n', '        operationAddress = _address;\n', '    }\n', '    \n', '    function setTaxAddress(address _address) public onlyAuthorized {\n', '        taxAddress = _address;\n', '    }\n', '\n', '    function createTokenToMarket2018() public onlyAuthorized {\n', '        require(marketAddress != address(0));\n', '        require(market2018TokenCreated == false);\n', '\n', '        market2018TokenCreated = true;\n', '        token.mint(marketAddress, marketToken2018);\n', '        CreateTokenToMarket(marketAddress, marketToken2018);\n', '    }\n', '\n', '\n', '    function createTokenToMarket2019() public onlyAuthorized {\n', '        require(marketAddress != address(0));\n', '        require(market2018TokenCreated == false);\n', '\n', '        market2019TokenCreated = true;\n', '        token.mint(marketAddress, marketToken2019);\n', '        CreateTokenToMarket(marketAddress, marketToken2019);\n', '    }\n', '\n', '    function createTokenToMarket2020() public onlyAuthorized {\n', '        require(marketAddress != address(0));\n', '        require(market2020TokenCreated == false);\n', '\n', '        market2020TokenCreated = true;\n', '        token.mint(marketAddress, marketToken2020);\n', '        CreateTokenToMarket(marketAddress, marketToken2020);\n', '    }\n', '\n', '    function createTokenToMarket2021() public onlyAuthorized {\n', '        require(marketAddress != address(0));\n', '        require(market2021TokenCreated == false);\n', '\n', '        market2021TokenCreated = true;\n', '        token.mint(marketAddress, marketToken2021);\n', '        CreateTokenToMarket(marketAddress, marketToken2021);\n', '    }\n', '\n', '\n', '    function createTokenToOperation() public onlyAuthorized {\n', '        require(operationAddress != address(0));\n', '        require(operationTokenCreated == false);\n', '\n', '        operationTokenCreated = true;\n', '        token.mint(operationAddress, operationToken);\n', '        CreateTokenToOperation(operationAddress, operationToken);\n', '    }\n', '\n', '    function createTokenToTax() public onlyAuthorized {\n', '        require(taxAddress != address(0));\n', '        require(taxTokenCreated == false);\n', '\n', '        taxTokenCreated = true;\n', '        token.mint(taxAddress, taxToken);\n', '        CreateTokenToOperation(taxAddress, taxToken);\n', '    }\n', '\n', '\n', '    function _createTokenToTeam(uint16 _currentYear) internal {\n', '        if (_currentYear == 2018) {\n', '            require(team2018TokenCreated == false);\n', '            team2018TokenCreated = true;\n', '            token.mint(teamAddress, teamToken2018);\n', '            CreateTokenToTeam(teamAddress, teamToken2018);\n', '        } else if (_currentYear == 2019) {\n', '            require(team2019TokenCreated == false);\n', '            team2019TokenCreated = true;\n', '            token.mint(teamAddress, teamToken2019);\n', '            CreateTokenToTeam(teamAddress, teamToken2019);\n', '        } else {\n', '            revert();\n', '        }\n', '    }\n', '\n', '    function createTokenToTeam() public onlyAuthorized {\n', '        require(teamAddress != address(0));\n', '        uint16 currentYear = dateTime.getYear(now);\n', '        require(currentYear == 2018 || currentYear == 2019);\n', '        _createTokenToTeam(currentYear);\n', '    }\n', '\n', '    function mined(address recipient, uint _tokens) public onlyAuthorized {\n', '        require(now > minedTokenStartTime);\n', '        uint16 currentYear = dateTime.getYear(now);\n', '        uint currentYearRemainTokens = getCurrentYearRemainToken(currentYear);\n', '        require(_tokens <= currentYearRemainTokens);\n', '\n', '        minedToken[currentYear] += _tokens; \n', '\n', '        token.mint(recipient, _tokens);\n', '        Mined(recipient, _tokens); \n', '    }\n', '\n', '    function authorizedCreateTokensToPrivate(address recipient, uint _tokens) public onlyAuthorized {\n', '        require(privateToken + _tokens <= privateTokenCap);\n', '        privateToken += _tokens;\n', '        token.mint(recipient, _tokens);\n', '        AuthorizedCreateToPrivate(recipient, _tokens);\n', '    }\n', '\n', '    function finishMinting() public onlyOwner {\n', '        token.finishMinting();\n', '        token.transferOwnership(owner);\n', '        PromotionCoinMintFinished();\n', '    }\n', '\n', '    //不允许直接转账以太币购买\n', '    function () external {\n', '        revert();\n', '    }\n', '}']