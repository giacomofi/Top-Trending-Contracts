['pragma solidity ^0.4.21;\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', 'library DateTime {\n', '        /*\n', '         *  Date and Time utilities for ethereum contracts\n', '         *\n', '         */\n', '        struct MyDateTime {\n', '                uint16 year;\n', '                uint8 month;\n', '                uint8 day;\n', '                uint8 hour;\n', '                uint8 minute;\n', '                uint8 second;\n', '                uint8 weekday;\n', '        }\n', '        uint constant DAY_IN_SECONDS = 86400;\n', '        uint constant YEAR_IN_SECONDS = 31536000;\n', '        uint constant LEAP_YEAR_IN_SECONDS = 31622400;\n', '        uint constant HOUR_IN_SECONDS = 3600;\n', '        uint constant MINUTE_IN_SECONDS = 60;\n', '        uint16 constant ORIGIN_YEAR = 1970;\n', '        function isLeapYear(uint16 year) internal pure returns (bool) {\n', '                if (year % 4 != 0) {\n', '                        return false;\n', '                }\n', '                if (year % 100 != 0) {\n', '                        return true;\n', '                }\n', '                if (year % 400 != 0) {\n', '                        return false;\n', '                }\n', '                return true;\n', '        }\n', '        function leapYearsBefore(uint year) internal pure returns (uint) {\n', '                year -= 1;\n', '                return year / 4 - year / 100 + year / 400;\n', '        }\n', '        function getDaysInMonth(uint8 month, uint16 year) internal pure returns (uint8) {\n', '                if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {\n', '                        return 31;\n', '                }\n', '                else if (month == 4 || month == 6 || month == 9 || month == 11) {\n', '                        return 30;\n', '                }\n', '                else if (isLeapYear(year)) {\n', '                        return 29;\n', '                }\n', '                else {\n', '                        return 28;\n', '                }\n', '        }\n', '        function parseTimestamp(uint timestamp) internal pure returns (MyDateTime dt) {\n', '                uint secondsAccountedFor = 0;\n', '                uint buf;\n', '                uint8 i;\n', '                // Year\n', '                dt.year = getYear(timestamp);\n', '                buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);\n', '                secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;\n', '                secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);\n', '                // Month\n', '                uint secondsInMonth;\n', '                for (i = 1; i <= 12; i++) {\n', '                        secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);\n', '                        if (secondsInMonth + secondsAccountedFor > timestamp) {\n', '                                dt.month = i;\n', '                                break;\n', '                        }\n', '                        secondsAccountedFor += secondsInMonth;\n', '                }\n', '                // Day\n', '                for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {\n', '                        if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {\n', '                                dt.day = i;\n', '                                break;\n', '                        }\n', '                        secondsAccountedFor += DAY_IN_SECONDS;\n', '                }\n', '                // Hour\n', '                dt.hour = 0;//getHour(timestamp);\n', '                // Minute\n', '                dt.minute = 0;//getMinute(timestamp);\n', '                // Second\n', '                dt.second = 0;//getSecond(timestamp);\n', '                // Day of week.\n', '                dt.weekday = 0;//getWeekday(timestamp);\n', '        }\n', '        function getYear(uint timestamp) internal pure returns (uint16) {\n', '                uint secondsAccountedFor = 0;\n', '                uint16 year;\n', '                uint numLeapYears;\n', '                // Year\n', '                year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);\n', '                numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);\n', '                secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;\n', '                secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);\n', '                while (secondsAccountedFor > timestamp) {\n', '                        if (isLeapYear(uint16(year - 1))) {\n', '                                secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;\n', '                        }\n', '                        else {\n', '                                secondsAccountedFor -= YEAR_IN_SECONDS;\n', '                        }\n', '                        year -= 1;\n', '                }\n', '                return year;\n', '        }\n', '        function getMonth(uint timestamp) internal pure returns (uint8) {\n', '                return parseTimestamp(timestamp).month;\n', '        }\n', '        function getDay(uint timestamp) internal pure returns (uint8) {\n', '                return parseTimestamp(timestamp).day;\n', '        }\n', '        function getHour(uint timestamp) internal pure returns (uint8) {\n', '                return uint8((timestamp / 60 / 60) % 24);\n', '        }\n', '        function getMinute(uint timestamp) internal pure returns (uint8) {\n', '                return uint8((timestamp / 60) % 60);\n', '        }\n', '        function getSecond(uint timestamp) internal pure returns (uint8) {\n', '                return uint8(timestamp % 60);\n', '        }\n', '        function toTimestamp(uint16 year, uint8 month, uint8 day) internal pure returns (uint timestamp) {\n', '                return toTimestamp(year, month, day, 0, 0, 0);\n', '        }\n', '        function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) internal pure returns (uint timestamp) {\n', '                uint16 i;\n', '                // Year\n', '                for (i = ORIGIN_YEAR; i < year; i++) {\n', '                        if (isLeapYear(i)) {\n', '                                timestamp += LEAP_YEAR_IN_SECONDS;\n', '                        }\n', '                        else {\n', '                                timestamp += YEAR_IN_SECONDS;\n', '                        }\n', '                }\n', '                // Month\n', '                uint8[12] memory monthDayCounts;\n', '                monthDayCounts[0] = 31;\n', '                if (isLeapYear(year)) {\n', '                        monthDayCounts[1] = 29;\n', '                }\n', '                else {\n', '                        monthDayCounts[1] = 28;\n', '                }\n', '                monthDayCounts[2] = 31;\n', '                monthDayCounts[3] = 30;\n', '                monthDayCounts[4] = 31;\n', '                monthDayCounts[5] = 30;\n', '                monthDayCounts[6] = 31;\n', '                monthDayCounts[7] = 31;\n', '                monthDayCounts[8] = 30;\n', '                monthDayCounts[9] = 31;\n', '                monthDayCounts[10] = 30;\n', '                monthDayCounts[11] = 31;\n', '                for (i = 1; i < month; i++) {\n', '                        timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];\n', '                }\n', '                // Day\n', '                timestamp += DAY_IN_SECONDS * (day - 1);\n', '                // Hour\n', '                timestamp += HOUR_IN_SECONDS * (hour);\n', '                // Minute\n', '                timestamp += MINUTE_IN_SECONDS * (minute);\n', '                // Second\n', '                timestamp += second;\n', '                return timestamp;\n', '        }\n', '}\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '/**\n', ' * @title Claimable\n', ' * @dev Extension for the Ownable contract, where the ownership needs to be claimed.\n', ' * This allows the new owner to accept the transfer.\n', ' */\n', 'contract Claimable is Ownable {\n', '  address public pendingOwner;\n', '  /**\n', '   * @dev Modifier throws if called by any account other than the pendingOwner.\n', '   */\n', '  modifier onlyPendingOwner() {\n', '    require(msg.sender == pendingOwner);\n', '    _;\n', '  }\n', '  /**\n', '   * @dev Allows the current owner to set the pendingOwner address.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    pendingOwner = newOwner;\n', '  }\n', '  /**\n', '   * @dev Allows the pendingOwner address to finalize the transfer.\n', '   */\n', '  function claimOwnership() onlyPendingOwner public {\n', '    emit OwnershipTransferred(owner, pendingOwner);\n', '    owner = pendingOwner;\n', '    pendingOwner = address(0);\n', '  }\n', '}\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '  mapping(address => uint256) balances;\n', '  uint256 totalSupply_;\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '}\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '}\n', '/**\n', ' * @title Helps contracts guard agains reentrancy attacks.\n', ' * @author Remco Bloemen <remco@2π.com>\n', ' * @notice If you mark a function `nonReentrant`, you should also\n', ' * mark it `external`.\n', ' */\n', 'contract ReentrancyGuard {\n', '  /**\n', '   * @dev We use a single lock for the whole contract.\n', '   */\n', '  bool private reentrancyLock = false;\n', '  /**\n', '   * @dev Prevents a contract from calling itself, directly or indirectly.\n', '   * @notice If you mark a function `nonReentrant`, you should also\n', '   * mark it `external`. Calling one nonReentrant function from\n', '   * another is not supported. Instead, you can implement a\n', '   * `private` function doing the actual work, and a `external`\n', '   * wrapper marked as `nonReentrant`.\n', '   */\n', '  modifier nonReentrant() {\n', '    require(!reentrancyLock);\n', '    reentrancyLock = true;\n', '    _;\n', '    reentrancyLock = false;\n', '  }\n', '}\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract StandardBurnableToken is StandardToken {\n', '    event Burn(address indexed burner, uint256 value);\n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param _value The amount of token to be burned.\n', '     */\n', '    function burn(uint256 _value) public returns (bool) {\n', '        require(_value <= balances[msg.sender]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', "        // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply_ = totalSupply_.sub(_value);\n', '        emit Burn(burner, _value);\n', '        return true;\n', '    }\n', '}\n', 'contract Operational is Claimable {\n', '    address public operator;\n', '    function Operational(address _operator) public {\n', '      operator = _operator;\n', '    }\n', '    modifier onlyOperator() {\n', '      require(msg.sender == operator);\n', '      _;\n', '    }\n', '    function transferOperator(address newOperator) public onlyOwner {\n', '      require(newOperator != address(0));\n', '      operator = newOperator;\n', '    }\n', '}\n', 'contract Frozenable is Operational, StandardBurnableToken, ReentrancyGuard {\n', '    using DateTime for uint256;\n', '    struct FrozenRecord {\n', '        uint256 value;\n', '        uint256 unfreezeIndex;\n', '    }\n', '    uint256 public frozenBalance;\n', '    mapping (uint256 => FrozenRecord) public frozenRecords;\n', '    uint256 mulDecimals = 100000000; // match decimals\n', '    event SystemFreeze(address indexed owner, uint256 value, uint256 unfreezeIndex);\n', '    event Unfreeze(address indexed owner, uint256 value, uint256 unfreezeTime);\n', '    function Frozenable(address _operator) Operational(_operator) public {}\n', "    // freeze system' balance\n", '    function systemFreeze(uint256 _value, uint256 _unfreezeTime) internal {\n', '        uint256 unfreezeIndex = uint256(_unfreezeTime.parseTimestamp().year) * 10000 + uint256(_unfreezeTime.parseTimestamp().month) * 100 + uint256(_unfreezeTime.parseTimestamp().day);\n', '        balances[owner] = balances[owner].sub(_value);\n', '        frozenRecords[unfreezeIndex] = FrozenRecord({value: _value, unfreezeIndex: unfreezeIndex});\n', '        frozenBalance = frozenBalance.add(_value);\n', '        emit SystemFreeze(owner, _value, _unfreezeTime);\n', '    }\n', '    // unfreeze frozen amount\n', '    // everyone can call this function to unfreeze balance\n', '    function unfreeze(uint256 timestamp) public returns (uint256 unfreezeAmount) {\n', '        require(timestamp <= block.timestamp);\n', '        uint256 unfreezeIndex = uint256(timestamp.parseTimestamp().year) * 10000 + uint256(timestamp.parseTimestamp().month) * 100 + uint256(timestamp.parseTimestamp().day);\n', '        frozenBalance = frozenBalance.sub(frozenRecords[unfreezeIndex].value);\n', '        balances[owner] = balances[owner].add(frozenRecords[unfreezeIndex].value);\n', '        unfreezeAmount = frozenRecords[unfreezeIndex].value;\n', '        emit Unfreeze(owner, unfreezeAmount, timestamp);\n', '        frozenRecords[unfreezeIndex].value = 0;\n', '        return unfreezeAmount;\n', '    }\n', '}\n', 'contract Releaseable is Frozenable {\n', '    using SafeMath for uint;\n', '    function Releaseable(\n', '                    address _operator, uint256 _initialSupply\n', '                ) Frozenable(_operator) public {\n', '        balances[owner] = _initialSupply;\n', '        totalSupply_ = _initialSupply;\n', '    }\n', '}\n', 'contract ERCoin is Releaseable {\n', "    string public standard = '2018102500';\n", "    string public name = 'ERCoin';\n", "    string public symbol = 'ERC';\n", '    uint8 public decimals = 8;\n', '    function ERCoin() Releaseable(0xe8358AfA9Bc309c4A106dc41782340b91817BC64, mulDecimals.mul(1000000000)) public {}\n', '}']