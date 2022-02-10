['// File: contracts/interface/IDollars.sol\n', '\n', 'pragma solidity >=0.4.24;\n', '\n', '\n', 'interface IDollars {\n', '    function claimDividends(address account) external returns (uint256);\n', '}\n', '\n', '// File: openzeppelin-eth/contracts/math/SafeMath.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', '// File: zos-lib/contracts/Initializable.sol\n', '\n', 'pragma solidity >=0.4.24 <0.6.0;\n', '\n', '\n', '/**\n', ' * @title Initializable\n', ' *\n', ' * @dev Helper contract to support initializer functions. To use it, replace\n', ' * the constructor with a function that has the `initializer` modifier.\n', ' * WARNING: Unlike constructors, initializer functions must be manually\n', ' * invoked. This applies both to deploying an Initializable contract, as well\n', ' * as extending an Initializable contract via inheritance.\n', ' * WARNING: When used with inheritance, manual care must be taken to not invoke\n', ' * a parent initializer twice, or ensure that all initializers are idempotent,\n', ' * because this is not dealt with automatically as with constructors.\n', ' */\n', 'contract Initializable {\n', '\n', '  /**\n', '   * @dev Indicates that the contract has been initialized.\n', '   */\n', '  bool private initialized;\n', '\n', '  /**\n', '   * @dev Indicates that the contract is in the process of being initialized.\n', '   */\n', '  bool private initializing;\n', '\n', '  /**\n', '   * @dev Modifier to use in the initializer function of a contract.\n', '   */\n', '  modifier initializer() {\n', '    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");\n', '\n', '    bool isTopLevelCall = !initializing;\n', '    if (isTopLevelCall) {\n', '      initializing = true;\n', '      initialized = true;\n', '    }\n', '\n', '    _;\n', '\n', '    if (isTopLevelCall) {\n', '      initializing = false;\n', '    }\n', '  }\n', '\n', '  /// @dev Returns true if and only if the function is running in the constructor\n', '  function isConstructor() private view returns (bool) {\n', '    // extcodesize checks the size of the code stored in an address, and\n', '    // address returns the current address. Since the code is still not\n', '    // deployed when running a constructor, any checks on its code size will\n', '    // yield zero, making it an effective way to detect if a contract is\n', '    // under construction or not.\n', '    uint256 cs;\n', '    assembly { cs := extcodesize(address) }\n', '    return cs == 0;\n', '  }\n', '\n', '  // Reserved storage space to allow for layout changes in the future.\n', '  uint256[50] private ______gap;\n', '}\n', '\n', '// File: openzeppelin-eth/contracts/ownership/Ownable.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable is Initializable {\n', '  address private _owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function initialize(address sender) public initializer {\n', '    _owner = sender;\n', '  }\n', '\n', '  /**\n', '   * @return the address of the owner.\n', '   */\n', '  function owner() public view returns(address) {\n', '    return _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(isOwner());\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @return true if `msg.sender` is the owner of the contract.\n', '   */\n', '  function isOwner() public view returns(bool) {\n', '    return msg.sender == _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(_owner);\n', '    _owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    _transferOwnership(newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address newOwner) internal {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(_owner, newOwner);\n', '    _owner = newOwner;\n', '  }\n', '\n', '  uint256[50] private ______gap;\n', '}\n', '\n', '// File: openzeppelin-eth/contracts/token/ERC20/IERC20.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'interface IERC20 {\n', '  function totalSupply() external view returns (uint256);\n', '\n', '  function balanceOf(address who) external view returns (uint256);\n', '\n', '  function allowance(address owner, address spender)\n', '    external view returns (uint256);\n', '\n', '  function transfer(address to, uint256 value) external returns (bool);\n', '\n', '  function approve(address spender, uint256 value)\n', '    external returns (bool);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    external returns (bool);\n', '\n', '  event Transfer(\n', '    address indexed from,\n', '    address indexed to,\n', '    uint256 value\n', '  );\n', '\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '// File: openzeppelin-eth/contracts/token/ERC20/ERC20Detailed.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20Detailed token\n', ' * @dev The decimals are only for visualization purposes.\n', ' * All the operations are done using the smallest and indivisible token unit,\n', ' * just as on Ethereum all the operations are done in wei.\n', ' */\n', 'contract ERC20Detailed is Initializable, IERC20 {\n', '  string private _name;\n', '  string private _symbol;\n', '  uint8 private _decimals;\n', '\n', '  function initialize(string name, string symbol, uint8 decimals) public initializer {\n', '    _name = name;\n', '    _symbol = symbol;\n', '    _decimals = decimals;\n', '  }\n', '\n', '  /**\n', '   * @return the name of the token.\n', '   */\n', '  function name() public view returns(string) {\n', '    return _name;\n', '  }\n', '\n', '  /**\n', '   * @return the symbol of the token.\n', '   */\n', '  function symbol() public view returns(string) {\n', '    return _symbol;\n', '  }\n', '\n', '  /**\n', '   * @return the number of decimals of the token.\n', '   */\n', '  function decimals() public view returns(uint8) {\n', '    return _decimals;\n', '  }\n', '\n', '  uint256[50] private ______gap;\n', '}\n', '\n', '// File: contracts/lib/SafeMathInt.sol\n', '\n', '/*\n', 'MIT License\n', '\n', 'Copyright (c) 2018 requestnetwork\n', '\n', 'Permission is hereby granted, free of charge, to any person obtaining a copy\n', 'of this software and associated documentation files (the "Software"), to deal\n', 'in the Software without restriction, including without limitation the rights\n', 'to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\n', 'copies of the Software, and to permit persons to whom the Software is\n', 'furnished to do so, subject to the following conditions:\n', '\n', 'The above copyright notice and this permission notice shall be included in all\n', 'copies or substantial portions of the Software.\n', '\n', 'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n', 'IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n', 'FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n', 'AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n', 'LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n', 'OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\n', 'SOFTWARE.\n', '*/\n', '\n', 'pragma solidity >=0.4.24;\n', '\n', '\n', '/**\n', ' * @title SafeMathInt\n', ' * @dev Math operations for int256 with overflow safety checks.\n', ' */\n', 'library SafeMathInt {\n', '    int256 private constant MIN_INT256 = int256(1) << 255;\n', '    int256 private constant MAX_INT256 = ~(int256(1) << 255);\n', '\n', '    /**\n', '     * @dev Multiplies two int256 variables and fails on overflow.\n', '     */\n', '    function mul(int256 a, int256 b)\n', '        internal\n', '        pure\n', '        returns (int256)\n', '    {\n', '        int256 c = a * b;\n', '\n', '        // Detect overflow when multiplying MIN_INT256 with -1\n', '        require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));\n', '        require((b == 0) || (c / b == a));\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Division of two int256 variables and fails on overflow.\n', '     */\n', '    function div(int256 a, int256 b)\n', '        internal\n', '        pure\n', '        returns (int256)\n', '    {\n', '        // Prevent overflow when dividing MIN_INT256 by -1\n', '        require(b != -1 || a != MIN_INT256);\n', '\n', '        // Solidity already throws when dividing by 0.\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Subtracts two int256 variables and fails on overflow.\n', '     */\n', '    function sub(int256 a, int256 b)\n', '        internal\n', '        pure\n', '        returns (int256)\n', '    {\n', '        int256 c = a - b;\n', '        require((b >= 0 && c <= a) || (b < 0 && c > a));\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Adds two int256 variables and fails on overflow.\n', '     */\n', '    function add(int256 a, int256 b)\n', '        internal\n', '        pure\n', '        returns (int256)\n', '    {\n', '        int256 c = a + b;\n', '        require((b >= 0 && c >= a) || (b < 0 && c < a));\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Converts to absolute value, and fails on overflow.\n', '     */\n', '    function abs(int256 a)\n', '        internal\n', '        pure\n', '        returns (int256)\n', '    {\n', '        require(a != MIN_INT256);\n', '        return a < 0 ? -a : a;\n', '    }\n', '}\n', '\n', '// File: contracts/seigniorageShares.sol\n', '\n', 'pragma solidity >=0.4.24;\n', '\n', '\n', '\n', '\n', '\n', '\n', '/*\n', ' *  SeigniorageShares ERC20\n', ' */\n', '\n', '\n', 'contract SeigniorageShares is ERC20Detailed, Ownable {\n', '    address private _minter;\n', '\n', '    modifier onlyMinter() {\n', '        require(msg.sender == _minter, "DOES_NOT_HAVE_MINTER_ROLE");\n', '        _;\n', '    }\n', '\n', '    using SafeMath for uint256;\n', '    using SafeMathInt for int256;\n', '\n', '    uint256 private constant DECIMALS = 9;\n', '    uint256 private constant MAX_UINT256 = ~uint256(0);\n', '    uint256 private constant INITIAL_SHARE_SUPPLY = 21 * 10**6 * 10**DECIMALS;\n', '\n', '    uint256 private constant MAX_SUPPLY = ~uint128(0);  // (2^128) - 1\n', '\n', '    uint256 private _totalSupply;\n', '\n', '    struct Account {\n', '        uint256 balance;\n', '        uint256 lastDividendPoints;\n', '    }\n', '\n', '    bool private _initializedDollar;\n', '    // eslint-ignore\n', '    IDollars dollars;\n', '\n', '    mapping(address=>Account) private _shareBalances;\n', '    mapping (address => mapping (address => uint256)) private _allowedShares;\n', '\n', '    function setDividendPoints(address who, uint256 amount) external onlyMinter {\n', '        require(who != address(0), "Invalid recipient address");\n', '        _shareBalances[who].lastDividendPoints = amount;\n', '    }\n', '\n', '    function mintShares(address who, uint256 amount) external onlyMinter {\n', '        require(who != address(0), "Invalid recipient address");\n', '\n', '        _shareBalances[who].balance = _shareBalances[who].balance.add(amount);\n', '        _totalSupply = _totalSupply.add(amount);\n', '    }\n', '\n', '    function externalTotalSupply()\n', '        external\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function externalRawBalanceOf(address who)\n', '        external\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return _shareBalances[who].balance;\n', '    }\n', '\n', '    function lastDividendPoints(address who)\n', '        external\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return _shareBalances[who].lastDividendPoints;\n', '    }\n', '\n', '    function initialize(address owner_)\n', '        public\n', '        initializer\n', '    {\n', '        ERC20Detailed.initialize("Seigniorage Shares", "SHARE", uint8(DECIMALS));\n', '        Ownable.initialize(owner_);\n', '\n', '        _initializedDollar = false;\n', '\n', '        _totalSupply = INITIAL_SHARE_SUPPLY;\n', '        _shareBalances[owner_].balance = _totalSupply;\n', '\n', '        emit Transfer(address(0x0), owner_, _totalSupply);\n', '    }\n', '\n', '    // instantiate dollar\n', '    function initializeDollar(address dollarAddress) public onlyOwner {\n', '        require(dollarAddress != address(0), "INVALID_DOLLAR_ADDRESS");\n', '        require(!_initializedDollar, "ALREADY_INITIALIZED");\n', '        dollars = IDollars(dollarAddress);\n', '        _initializedDollar = true;\n', '        _minter = dollarAddress;\n', '    }\n', '\n', '     /**\n', '     * @return The total number of dollars.\n', '     */\n', '    function totalSupply()\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address who)\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return _shareBalances[who].balance;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens to a specified address.\n', '     * @param to The address to transfer to.\n', '     * @param value The amount to be transferred.\n', '     * @return True on success, false otherwise.\n', '     */\n', '    function transfer(address to, uint256 value)\n', '        public\n', '        uniqueAddresses(msg.sender, to)\n', '        validRecipient(to)\n', '        updateAccount(msg.sender)\n', '        updateAccount(to)\n', '        returns (bool)\n', '    {\n', '        _shareBalances[msg.sender].balance = _shareBalances[msg.sender].balance.sub(value);\n', '        _shareBalances[to].balance = _shareBalances[to].balance.add(value);\n', '        emit Transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner has allowed to a spender.\n', '     * @param owner_ The address which owns the funds.\n', '     * @param spender The address which will spend the funds.\n', '     * @return The number of tokens still available for the spender.\n', '     */\n', '    function allowance(address owner_, address spender)\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return _allowedShares[owner_][spender];\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another.\n', '     * @param from The address you want to send tokens from.\n', '     * @param to The address you want to transfer to.\n', '     * @param value The amount of tokens to be transferred.\n', '     */\n', '    function transferFrom(address from, address to, uint256 value)\n', '        public\n', '        uniqueAddresses(msg.sender, from)\n', '        uniqueAddresses(msg.sender, to)\n', '        validRecipient(to)\n', '        updateAccount(from)\n', '        updateAccount(msg.sender)\n', '        updateAccount(to)\n', '        returns (bool)\n', '    {\n', '        _allowedShares[from][msg.sender] = _allowedShares[from][msg.sender].sub(value);\n', '\n', '        _shareBalances[from].balance = _shareBalances[from].balance.sub(value);\n', '        _shareBalances[to].balance = _shareBalances[to].balance.add(value);\n', '        emit Transfer(from, to, value);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of\n', '     * msg.sender. This method is included for ERC20 compatibility.\n', '     * increaseAllowance and decreaseAllowance should be used instead.\n', '     * Changing an allowance with this method brings the risk that someone may transfer both\n', '     * the old and the new allowance - if they are both greater than zero - if a transfer\n', '     * transaction is mined before the later approve() call is mined.\n', '     *\n', '     * @param spender The address which will spend the funds.\n', '     * @param value The amount of tokens to be spent.\n', '     */\n', '    function approve(address spender, uint256 value)\n', '        public\n', '        uniqueAddresses(msg.sender, spender)\n', '        validRecipient(spender)\n', '        updateAccount(msg.sender)\n', '        updateAccount(spender)\n', '        returns (bool)\n', '    {\n', '        _allowedShares[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    modifier validRecipient(address to) {\n', '        require(to != address(0x0));\n', '        require(to != address(this));\n', '        _;\n', '    }\n', '\n', '    modifier uniqueAddresses(address addr1, address addr2) {\n', '        require(addr1 != addr2, "Addresses are not unique");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner has allowed to a spender.\n', '     * This method should be used instead of approve() to avoid the double approval vulnerability\n', '     * described above.\n', '     * @param spender The address which will spend the funds.\n', '     * @param addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseAllowance(address spender, uint256 addedValue)\n', '        public\n', '        uniqueAddresses(msg.sender, spender)\n', '        updateAccount(msg.sender)\n', '        updateAccount(spender)\n', '        returns (bool)\n', '    {\n', '        _allowedShares[msg.sender][spender] =\n', '            _allowedShares[msg.sender][spender].add(addedValue);\n', '        emit Approval(msg.sender, spender, _allowedShares[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner has allowed to a spender.\n', '     *\n', '     * @param spender The address which will spend the funds.\n', '     * @param subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseAllowance(address spender, uint256 subtractedValue)\n', '        public\n', '        uniqueAddresses(msg.sender, spender)\n', '        updateAccount(msg.sender)\n', '        updateAccount(spender)\n', '        returns (bool)\n', '    {\n', '        uint256 oldValue = _allowedShares[msg.sender][spender];\n', '        if (subtractedValue >= oldValue) {\n', '            _allowedShares[msg.sender][spender] = 0;\n', '        } else {\n', '            _allowedShares[msg.sender][spender] = oldValue.sub(subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, spender, _allowedShares[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '    // attach this to any action to auto claim\n', '    modifier updateAccount(address account) {\n', '        require(_initializedDollar == true, "DOLLAR_NEEDS_INITIALIZATION");\n', '\n', '        dollars.claimDividends(account);\n', '        _;\n', '    }\n', '}']