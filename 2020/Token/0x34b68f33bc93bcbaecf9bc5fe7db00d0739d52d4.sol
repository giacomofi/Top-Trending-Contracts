['// File: contracts/lib/UInt256Lib.sol\n', '\n', 'pragma solidity >=0.4.24;\n', '\n', '\n', '/**\n', ' * @title Various utilities useful for uint256.\n', ' */\n', 'library UInt256Lib {\n', '\n', '    uint256 private constant MAX_INT256 = ~(uint256(1) << 255);\n', '\n', '    /**\n', '     * @dev Safely converts a uint256 to an int256.\n', '     */\n', '    function toInt256Safe(uint256 a)\n', '        internal\n', '        pure\n', '        returns (int256)\n', '    {\n', '        require(a <= MAX_INT256);\n', '        return int256(a);\n', '    }\n', '}\n', '\n', '// File: contracts/lib/SafeMathInt.sol\n', '\n', '/*\n', 'MIT License\n', '\n', 'Copyright (c) 2018 requestnetwork\n', '\n', 'Permission is hereby granted, free of charge, to any person obtaining a copy\n', 'of this software and associated documentation files (the "Software"), to deal\n', 'in the Software without restriction, including without limitation the rights\n', 'to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\n', 'copies of the Software, and to permit persons to whom the Software is\n', 'furnished to do so, subject to the following conditions:\n', '\n', 'The above copyright notice and this permission notice shall be included in all\n', 'copies or substantial portions of the Software.\n', '\n', 'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n', 'IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n', 'FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n', 'AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n', 'LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n', 'OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\n', 'SOFTWARE.\n', '*/\n', '\n', 'pragma solidity >=0.4.24;\n', '\n', '\n', '/**\n', ' * @title SafeMathInt\n', ' * @dev Math operations for int256 with overflow safety checks.\n', ' */\n', 'library SafeMathInt {\n', '    int256 private constant MIN_INT256 = int256(1) << 255;\n', '    int256 private constant MAX_INT256 = ~(int256(1) << 255);\n', '\n', '    /**\n', '     * @dev Multiplies two int256 variables and fails on overflow.\n', '     */\n', '    function mul(int256 a, int256 b)\n', '        internal\n', '        pure\n', '        returns (int256)\n', '    {\n', '        int256 c = a * b;\n', '\n', '        // Detect overflow when multiplying MIN_INT256 with -1\n', '        require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));\n', '        require((b == 0) || (c / b == a));\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Division of two int256 variables and fails on overflow.\n', '     */\n', '    function div(int256 a, int256 b)\n', '        internal\n', '        pure\n', '        returns (int256)\n', '    {\n', '        // Prevent overflow when dividing MIN_INT256 by -1\n', '        require(b != -1 || a != MIN_INT256);\n', '\n', '        // Solidity already throws when dividing by 0.\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Subtracts two int256 variables and fails on overflow.\n', '     */\n', '    function sub(int256 a, int256 b)\n', '        internal\n', '        pure\n', '        returns (int256)\n', '    {\n', '        int256 c = a - b;\n', '        require((b >= 0 && c <= a) || (b < 0 && c > a));\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Adds two int256 variables and fails on overflow.\n', '     */\n', '    function add(int256 a, int256 b)\n', '        internal\n', '        pure\n', '        returns (int256)\n', '    {\n', '        int256 c = a + b;\n', '        require((b >= 0 && c >= a) || (b < 0 && c < a));\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Converts to absolute value, and fails on overflow.\n', '     */\n', '    function abs(int256 a)\n', '        internal\n', '        pure\n', '        returns (int256)\n', '    {\n', '        require(a != MIN_INT256);\n', '        return a < 0 ? -a : a;\n', '    }\n', '}\n', '\n', '// File: contracts/interface/ISeigniorageShares.sol\n', '\n', 'pragma solidity >=0.4.24;\n', '\n', '\n', 'interface ISeigniorageShares {\n', '    function setDividendPoints(address account, uint256 totalDividends) external returns (bool);\n', '    function mintShares(address account, uint256 amount) external returns (bool);\n', '    function lastDividendPoints(address who) external view returns (uint256);\n', '    function externalRawBalanceOf(address who) external view returns (uint256);\n', '    function externalTotalSupply() external view returns (uint256);\n', '}\n', '\n', '// File: openzeppelin-eth/contracts/math/SafeMath.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', '// File: zos-lib/contracts/Initializable.sol\n', '\n', 'pragma solidity >=0.4.24 <0.6.0;\n', '\n', '\n', '/**\n', ' * @title Initializable\n', ' *\n', ' * @dev Helper contract to support initializer functions. To use it, replace\n', ' * the constructor with a function that has the `initializer` modifier.\n', ' * WARNING: Unlike constructors, initializer functions must be manually\n', ' * invoked. This applies both to deploying an Initializable contract, as well\n', ' * as extending an Initializable contract via inheritance.\n', ' * WARNING: When used with inheritance, manual care must be taken to not invoke\n', ' * a parent initializer twice, or ensure that all initializers are idempotent,\n', ' * because this is not dealt with automatically as with constructors.\n', ' */\n', 'contract Initializable {\n', '\n', '  /**\n', '   * @dev Indicates that the contract has been initialized.\n', '   */\n', '  bool private initialized;\n', '\n', '  /**\n', '   * @dev Indicates that the contract is in the process of being initialized.\n', '   */\n', '  bool private initializing;\n', '\n', '  /**\n', '   * @dev Modifier to use in the initializer function of a contract.\n', '   */\n', '  modifier initializer() {\n', '    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");\n', '\n', '    bool isTopLevelCall = !initializing;\n', '    if (isTopLevelCall) {\n', '      initializing = true;\n', '      initialized = true;\n', '    }\n', '\n', '    _;\n', '\n', '    if (isTopLevelCall) {\n', '      initializing = false;\n', '    }\n', '  }\n', '\n', '  /// @dev Returns true if and only if the function is running in the constructor\n', '  function isConstructor() private view returns (bool) {\n', '    // extcodesize checks the size of the code stored in an address, and\n', '    // address returns the current address. Since the code is still not\n', '    // deployed when running a constructor, any checks on its code size will\n', '    // yield zero, making it an effective way to detect if a contract is\n', '    // under construction or not.\n', '    uint256 cs;\n', '    assembly { cs := extcodesize(address) }\n', '    return cs == 0;\n', '  }\n', '\n', '  // Reserved storage space to allow for layout changes in the future.\n', '  uint256[50] private ______gap;\n', '}\n', '\n', '// File: openzeppelin-eth/contracts/token/ERC20/IERC20.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'interface IERC20 {\n', '  function totalSupply() external view returns (uint256);\n', '\n', '  function balanceOf(address who) external view returns (uint256);\n', '\n', '  function allowance(address owner, address spender)\n', '    external view returns (uint256);\n', '\n', '  function transfer(address to, uint256 value) external returns (bool);\n', '\n', '  function approve(address spender, uint256 value)\n', '    external returns (bool);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    external returns (bool);\n', '\n', '  event Transfer(\n', '    address indexed from,\n', '    address indexed to,\n', '    uint256 value\n', '  );\n', '\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '// File: openzeppelin-eth/contracts/token/ERC20/ERC20Detailed.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20Detailed token\n', ' * @dev The decimals are only for visualization purposes.\n', ' * All the operations are done using the smallest and indivisible token unit,\n', ' * just as on Ethereum all the operations are done in wei.\n', ' */\n', 'contract ERC20Detailed is Initializable, IERC20 {\n', '  string private _name;\n', '  string private _symbol;\n', '  uint8 private _decimals;\n', '\n', '  function initialize(string name, string symbol, uint8 decimals) public initializer {\n', '    _name = name;\n', '    _symbol = symbol;\n', '    _decimals = decimals;\n', '  }\n', '\n', '  /**\n', '   * @return the name of the token.\n', '   */\n', '  function name() public view returns(string) {\n', '    return _name;\n', '  }\n', '\n', '  /**\n', '   * @return the symbol of the token.\n', '   */\n', '  function symbol() public view returns(string) {\n', '    return _symbol;\n', '  }\n', '\n', '  /**\n', '   * @return the number of decimals of the token.\n', '   */\n', '  function decimals() public view returns(uint8) {\n', '    return _decimals;\n', '  }\n', '\n', '  uint256[50] private ______gap;\n', '}\n', '\n', '// File: openzeppelin-eth/contracts/ownership/Ownable.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable is Initializable {\n', '  address private _owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function initialize(address sender) public initializer {\n', '    _owner = sender;\n', '  }\n', '\n', '  /**\n', '   * @return the address of the owner.\n', '   */\n', '  function owner() public view returns(address) {\n', '    return _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(isOwner());\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @return true if `msg.sender` is the owner of the contract.\n', '   */\n', '  function isOwner() public view returns(bool) {\n', '    return msg.sender == _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(_owner);\n', '    _owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    _transferOwnership(newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address newOwner) internal {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(_owner, newOwner);\n', '    _owner = newOwner;\n', '  }\n', '\n', '  uint256[50] private ______gap;\n', '}\n', '\n', '// File: contracts/dollars.sol\n', '\n', 'pragma solidity >=0.4.24;\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', 'interface IDollarPolicy {\n', '    function getUsdSharePrice() external view returns (uint256 price);\n', '}\n', '\n', '/*\n', ' *  Dollar ERC20\n', ' */\n', '\n', 'contract Dollars is ERC20Detailed, Ownable {\n', '    using SafeMath for uint256;\n', '    using SafeMathInt for int256;\n', '\n', '    event LogRebase(uint256 indexed epoch, uint256 totalSupply);\n', '    event LogContraction(uint256 indexed epoch, uint256 dollarsToBurn);\n', '    event LogRebasePaused(bool paused);\n', '    event LogBurn(address indexed from, uint256 value);\n', '    event LogClaim(address indexed from, uint256 value);\n', '    event LogMonetaryPolicyUpdated(address monetaryPolicy);\n', '\n', '    // Used for authentication\n', '    address public monetaryPolicy;\n', '    address public sharesAddress;\n', '\n', '    modifier onlyMonetaryPolicy() {\n', '        require(msg.sender == monetaryPolicy);\n', '        _;\n', '    }\n', '\n', '    // Precautionary emergency controls.\n', '    bool public rebasePaused;\n', '\n', '    modifier whenRebaseNotPaused() {\n', '        require(!rebasePaused);\n', '        _;\n', '    }\n', '\n', '    // coins needing to be burned (9 decimals)\n', '    uint256 private _remainingDollarsToBeBurned;\n', '\n', '    modifier validRecipient(address to) {\n', '        require(to != address(0x0));\n', '        require(to != address(this));\n', '        _;\n', '    }\n', '\n', '    uint256 private constant DECIMALS = 9;\n', '    uint256 private constant MAX_UINT256 = ~uint256(0);\n', '    uint256 private constant INITIAL_DOLLAR_SUPPLY = 1 * 10**6 * 10**DECIMALS;\n', '    uint256 private _maxDiscount;\n', '\n', '    modifier validDiscount(uint256 discount) {\n', "        require(discount <= _maxDiscount, 'DISCOUNT_TOO_HIGH');\n", '        _;\n', '    }\n', '\n', '    uint256 private constant MAX_SUPPLY = ~uint128(0);  // (2^128) - 1\n', '\n', '    uint256 private _totalSupply;\n', '\n', '    uint256 private constant POINT_MULTIPLIER = 10 ** 9;\n', '\n', '    uint256 private _totalDividendPoints;\n', '    uint256 private _unclaimedDividends;\n', '\n', '    ISeigniorageShares shares;\n', '\n', '    mapping(address => uint256) private _dollarBalances;\n', '\n', '    // This is denominated in Dollars, because the cents-dollars conversion might change before\n', "    // it's fully paid.\n", '    mapping (address => mapping (address => uint256)) private _allowedDollars;\n', '\n', '    IDollarPolicy dollarPolicy;\n', '    uint256 public burningDiscount; // percentage (10 ** 9 Decimals)\n', '    uint256 public defaultDiscount; // discount on first negative rebase\n', '    uint256 public defaultDailyBonusDiscount; // how much the discount increases per day for consecutive contractions\n', '\n', '    uint256 public minimumBonusThreshold;\n', '\n', '    bool reEntrancyMutex;\n', '    bool reEntrancyRebaseMutex;\n', '\n', '    address public uniswapV2Pool;\n', '\n', '    modifier uniqueAddresses(address addr1, address addr2) {\n', '        require(addr1 != addr2, "Addresses are not unique");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @param monetaryPolicy_ The address of the monetary policy contract to use for authentication.\n', '     */\n', '    function setMonetaryPolicy(address monetaryPolicy_)\n', '        external\n', '        onlyOwner\n', '    {\n', '        monetaryPolicy = monetaryPolicy_;\n', '        dollarPolicy = IDollarPolicy(monetaryPolicy_);\n', '        emit LogMonetaryPolicyUpdated(monetaryPolicy_);\n', '    }\n', '\n', '    function setUniswapV2SyncAddress(address uniswapV2Pair_)\n', '        external\n', '        onlyOwner\n', '    {\n', '        uniswapV2Pool = uniswapV2Pair_;\n', '    }\n', '\n', '    function test()\n', '        external\n', '        onlyOwner\n', '    {\n', "        uniswapV2Pool.call(abi.encodeWithSignature('sync()'));\n", '    }\n', '\n', '    function setBurningDiscount(uint256 discount)\n', '        external\n', '        onlyOwner\n', '        validDiscount(discount)\n', '    {\n', '        burningDiscount = discount;\n', '    }\n', '\n', '    // amount in is 10 ** 9 decimals\n', '    function burn(uint256 amount)\n', '        external\n', '        updateAccount(msg.sender)\n', '    {\n', '        require(!reEntrancyMutex, "RE-ENTRANCY GUARD MUST BE FALSE");\n', '        reEntrancyMutex = true;\n', '\n', "        require(amount != 0, 'AMOUNT_MUST_BE_POSITIVE');\n", "        require(_remainingDollarsToBeBurned != 0, 'COIN_BURN_MUST_BE_GREATER_THAN_ZERO');\n", "        require(amount <= _dollarBalances[msg.sender], 'INSUFFICIENT_DOLLAR_BALANCE');\n", "        require(amount <= _remainingDollarsToBeBurned, 'AMOUNT_MUST_BE_LESS_THAN_OR_EQUAL_TO_REMAINING_COINS');\n", '\n', '        _burn(msg.sender, amount);\n', '\n', '        reEntrancyMutex = false;\n', '    }\n', '\n', '    function setDefaultDiscount(uint256 discount)\n', '        external\n', '        onlyOwner\n', '        validDiscount(discount)\n', '    {\n', '        defaultDiscount = discount;\n', '    }\n', '\n', '    function setMaxDiscount(uint256 discount)\n', '        external\n', '        onlyOwner\n', '    {\n', '        _maxDiscount = discount;\n', '    }\n', '\n', '    function setDefaultDailyBonusDiscount(uint256 discount)\n', '        external\n', '        onlyOwner\n', '        validDiscount(discount)\n', '    {\n', '        defaultDailyBonusDiscount = discount;\n', '    }\n', '\n', '    /**\n', '     * @dev Pauses or unpauses the execution of rebase operations.\n', '     * @param paused Pauses rebase operations if this is true.\n', '     */\n', '    function setRebasePaused(bool paused)\n', '        external\n', '        onlyOwner\n', '    {\n', '        rebasePaused = paused;\n', '        emit LogRebasePaused(paused);\n', '    }\n', '\n', '    // action of claiming funds\n', '    function claimDividends(address account) external updateAccount(account) returns (uint256) {\n', '        uint256 owing = dividendsOwing(account);\n', '        return owing;\n', '    }\n', '\n', '    function setMinimumBonusThreshold(uint256 minimum)\n', '        external\n', '        onlyOwner\n', '    {\n', "        require(minimum < _totalSupply, 'MINIMUM_TOO_HIGH');\n", '        minimumBonusThreshold = minimum;\n', '    }\n', '\n', '    /**\n', '     * @dev Notifies Dollars contract about a new rebase cycle.\n', '     * @param supplyDelta The number of new dollar tokens to add into circulation via expansion.\n', '     * @return The total number of dollars after the supply adjustment.\n', '     */\n', '    function rebase(uint256 epoch, int256 supplyDelta)\n', '        external\n', '        onlyMonetaryPolicy\n', '        whenRebaseNotPaused\n', '        returns (uint256)\n', '    {\n', '        reEntrancyRebaseMutex = true;\n', '        uint256 burningDefaultDiscount = burningDiscount.add(defaultDailyBonusDiscount);\n', '\n', '        if (supplyDelta == 0) {\n', '            if (_remainingDollarsToBeBurned > minimumBonusThreshold) {\n', '\n', '                burningDiscount = burningDefaultDiscount > _maxDiscount ? _maxDiscount : burningDefaultDiscount;\n', '            } else {\n', '                burningDiscount = defaultDiscount;\n', '            }\n', '\n', '            emit LogRebase(epoch, _totalSupply);\n', '        } else if (supplyDelta < 0) {\n', '            uint256 dollarsToBurn = uint256(supplyDelta.abs());\n', '            uint256 tenPercent = _totalSupply.div(10);\n', '\n', '            if (dollarsToBurn > tenPercent) { // maximum contraction is 10% of the total USD Supply\n', '                dollarsToBurn = tenPercent;\n', '            }\n', '\n', '            if (dollarsToBurn.add(_remainingDollarsToBeBurned) > _totalSupply) {\n', '                dollarsToBurn = _totalSupply.sub(_remainingDollarsToBeBurned);\n', '            }\n', '\n', '            if (_remainingDollarsToBeBurned > minimumBonusThreshold) {\n', '                burningDiscount = burningDefaultDiscount > _maxDiscount ?\n', '                    _maxDiscount : burningDefaultDiscount;\n', '            } else {\n', '                burningDiscount = defaultDiscount; // default 1%\n', '            }\n', '\n', '            _remainingDollarsToBeBurned = _remainingDollarsToBeBurned.add(dollarsToBurn);\n', '            emit LogContraction(epoch, dollarsToBurn);\n', '        } else {\n', '            disburse(uint256(supplyDelta));\n', '\n', "            uniswapV2Pool.call(abi.encodeWithSignature('sync()'));\n", '\n', '            emit LogRebase(epoch, _totalSupply);\n', '\n', '            if (_totalSupply > MAX_SUPPLY) {\n', '                _totalSupply = MAX_SUPPLY;\n', '            }\n', '        }\n', '\n', '        reEntrancyRebaseMutex = false;\n', '        return _totalSupply;\n', '    }\n', '\n', '    function initialize(address owner_, address seigniorageAddress)\n', '        public\n', '        initializer\n', '    {\n', '        ERC20Detailed.initialize("Dollars", "USD", uint8(DECIMALS));\n', '        Ownable.initialize(owner_);\n', '\n', '        rebasePaused = false;\n', '        _totalSupply = INITIAL_DOLLAR_SUPPLY;\n', '\n', '        sharesAddress = seigniorageAddress;\n', '        shares = ISeigniorageShares(seigniorageAddress);\n', '\n', '        _dollarBalances[owner_] = _totalSupply;\n', '        _maxDiscount = 50 * 10 ** 9; // 50%\n', '        defaultDiscount = 1 * 10 ** 9;              // 1%\n', '        burningDiscount = defaultDiscount;\n', '        defaultDailyBonusDiscount = 1 * 10 ** 9;    // 1%\n', '        minimumBonusThreshold = 100 * 10 ** 9;    // 100 dollars is the minimum threshold. Anything above warrants increased discount\n', '\n', '        emit Transfer(address(0x0), owner_, _totalSupply);\n', '    }\n', '\n', '    function dividendsOwing(address account) public view returns (uint256) {\n', '        if (_totalDividendPoints > shares.lastDividendPoints(account)) {\n', '            uint256 newDividendPoints = _totalDividendPoints.sub(shares.lastDividendPoints(account));\n', '            uint256 sharesBalance = shares.externalRawBalanceOf(account);\n', '            return sharesBalance.mul(newDividendPoints).div(POINT_MULTIPLIER);\n', '        } else {\n', '            return 0;\n', '        }\n', '    }\n', '\n', '    // auto claim modifier\n', '    // if user is owned, we pay out immedietly\n', '    // if user is not owned, we prevent them from claiming until the next rebase\n', '    modifier updateAccount(address account) {\n', '        uint256 owing = dividendsOwing(account);\n', '\n', '        if (owing != 0) {\n', '            _unclaimedDividends = _unclaimedDividends.sub(owing);\n', '            _dollarBalances[account] += owing;\n', '        }\n', '\n', '        shares.setDividendPoints(account, _totalDividendPoints);\n', '\n', '        emit LogClaim(account, owing);\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * @return The total number of dollars.\n', '     */\n', '    function totalSupply()\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return _totalSupply;\n', '    }\n', '\n', '    /**\n', '     * @param who The address to query.\n', '     * @return The balance of the specified address.\n', '     */\n', '    function balanceOf(address who)\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return _dollarBalances[who].add(dividendsOwing(who));\n', '    }\n', '\n', '    function getRemainingDollarsToBeBurned()\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return _remainingDollarsToBeBurned;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens to a specified address.\n', '     * @param to The address to transfer to.\n', '     * @param value The amount to be transferred.\n', '     * @return True on success, false otherwise.\n', '     */\n', '    function transfer(address to, uint256 value)\n', '        public\n', '        uniqueAddresses(msg.sender, to)\n', '        validRecipient(to)\n', '        updateAccount(msg.sender)\n', '        updateAccount(to)\n', '        returns (bool)\n', '    {\n', '        require(!reEntrancyRebaseMutex, "RE-ENTRANCY GUARD MUST BE FALSE");\n', '        _dollarBalances[msg.sender] = _dollarBalances[msg.sender].sub(value);\n', '        _dollarBalances[to] = _dollarBalances[to].add(value);\n', '        emit Transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner has allowed to a spender.\n', '     * @param owner_ The address which owns the funds.\n', '     * @param spender The address which will spend the funds.\n', '     * @return The number of tokens still available for the spender.\n', '     */\n', '    function allowance(address owner_, address spender)\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return _allowedDollars[owner_][spender];\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another.\n', '     * @param from The address you want to send tokens from.\n', '     * @param to The address you want to transfer to.\n', '     * @param value The amount of tokens to be transferred.\n', '     */\n', '    function transferFrom(address from, address to, uint256 value)\n', '        public\n', '        validRecipient(to)\n', '        updateAccount(from)\n', '        updateAccount(msg.sender)\n', '        updateAccount(to)\n', '        returns (bool)\n', '    {\n', '        require(!reEntrancyRebaseMutex, "RE-ENTRANCY GUARD MUST BE FALSE");\n', '\n', '        _allowedDollars[from][msg.sender] = _allowedDollars[from][msg.sender].sub(value);\n', '\n', '        _dollarBalances[from] = _dollarBalances[from].sub(value);\n', '        _dollarBalances[to] = _dollarBalances[to].add(value);\n', '        emit Transfer(from, to, value);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of\n', '     * msg.sender. This method is included for ERC20 compatibility.\n', '     * increaseAllowance and decreaseAllowance should be used instead.\n', '     * Changing an allowance with this method brings the risk that someone may transfer both\n', '     * the old and the new allowance - if they are both greater than zero - if a transfer\n', '     * transaction is mined before the later approve() call is mined.\n', '     *\n', '     * @param spender The address which will spend the funds.\n', '     * @param value The amount of tokens to be spent.\n', '     */\n', '    function approve(address spender, uint256 value)\n', '        public\n', '        uniqueAddresses(msg.sender, spender)\n', '        validRecipient(spender)\n', '        updateAccount(msg.sender)\n', '        updateAccount(spender)\n', '        returns (bool)\n', '    {\n', '        _allowedDollars[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner has allowed to a spender.\n', '     * This method should be used instead of approve() to avoid the double approval vulnerability\n', '     * described above.\n', '     * @param spender The address which will spend the funds.\n', '     * @param addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseAllowance(address spender, uint256 addedValue)\n', '        public\n', '        uniqueAddresses(msg.sender, spender)\n', '        updateAccount(msg.sender)\n', '        updateAccount(spender)\n', '        returns (bool)\n', '    {\n', '        _allowedDollars[msg.sender][spender] =\n', '            _allowedDollars[msg.sender][spender].add(addedValue);\n', '        emit Approval(msg.sender, spender, _allowedDollars[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner has allowed to a spender.\n', '     *\n', '     * @param spender The address which will spend the funds.\n', '     * @param subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseAllowance(address spender, uint256 subtractedValue)\n', '        public\n', '        uniqueAddresses(msg.sender, spender)\n', '        updateAccount(spender)\n', '        updateAccount(msg.sender)\n', '        returns (bool)\n', '    {\n', '        uint256 oldValue = _allowedDollars[msg.sender][spender];\n', '        if (subtractedValue >= oldValue) {\n', '            _allowedDollars[msg.sender][spender] = 0;\n', '        } else {\n', '            _allowedDollars[msg.sender][spender] = oldValue.sub(subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, spender, _allowedDollars[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '    function consultBurn(uint256 amount)\n', '        public\n', '        returns (uint256)\n', '    {\n', "        require(amount > 0, 'AMOUNT_MUST_BE_POSITIVE');\n", "        require(burningDiscount >= 0, 'DISCOUNT_NOT_VALID');\n", "        require(_remainingDollarsToBeBurned > 0, 'COIN_BURN_MUST_BE_GREATER_THAN_ZERO');\n", "        require(amount <= _dollarBalances[msg.sender].add(dividendsOwing(msg.sender)), 'INSUFFICIENT_DOLLAR_BALANCE');\n", "        require(amount <= _remainingDollarsToBeBurned, 'AMOUNT_MUST_BE_LESS_THAN_OR_EQUAL_TO_REMAINING_COINS');\n", '\n', '        uint256 usdPerShare = dollarPolicy.getUsdSharePrice(); // 1 share = x dollars\n', '        uint256 decimals = 10 ** 9;\n', '        uint256 percentDenominator = 100;\n', '        usdPerShare = usdPerShare.sub(usdPerShare.mul(burningDiscount).div(percentDenominator * decimals)); // 10^9\n', '        uint256 sharesToMint = amount.mul(decimals).div(usdPerShare); // 10^9\n', '\n', '        return sharesToMint;\n', '    }\n', '\n', '    function unclaimedDividends()\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return _unclaimedDividends;\n', '    }\n', '\n', '    function totalDividendPoints()\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return _totalDividendPoints;\n', '    }\n', '\n', '    function disburse(uint256 amount) internal returns (bool) {\n', '        _totalDividendPoints = _totalDividendPoints.add(amount.mul(POINT_MULTIPLIER).div(shares.externalTotalSupply()));\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _unclaimedDividends = _unclaimedDividends.add(amount);\n', '        return true;\n', '    }\n', '\n', '    function _burn(address account, uint256 amount)\n', '        internal \n', '    {\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        _dollarBalances[account] = _dollarBalances[account].sub(amount);\n', '\n', '        uint256 usdPerShare = dollarPolicy.getUsdSharePrice(); // 1 share = x dollars\n', '        uint256 decimals = 10 ** 9;\n', '        uint256 percentDenominator = 100;\n', '\n', '        usdPerShare = usdPerShare.sub(usdPerShare.mul(burningDiscount).div(percentDenominator * decimals)); // 10^9\n', '        uint256 sharesToMint = amount.mul(decimals).div(usdPerShare); // 10^9\n', '        _remainingDollarsToBeBurned = _remainingDollarsToBeBurned.sub(amount);\n', '\n', '        shares.mintShares(account, sharesToMint);\n', '\n', '        emit Transfer(account, address(0), amount);\n', '        emit LogBurn(account, amount);\n', '    }\n', '}']