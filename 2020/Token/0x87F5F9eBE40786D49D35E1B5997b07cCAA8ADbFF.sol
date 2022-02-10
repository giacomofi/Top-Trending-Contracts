['// SPDX-License-Identifier: MIT\n', '\n', '/*\n', 'MIT License\n', '\n', 'Copyright (c) 2018 requestnetwork\n', 'Copyright (c) 2018 Fragments, Inc.\n', 'Copyright (c) 2020 Rebased\n', '\n', 'Permission is hereby granted, free of charge, to any person obtaining a copy\n', 'of this software and associated documentation files (the "Software"), to deal\n', 'in the Software without restriction, including without limitation the rights\n', 'to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\n', 'copies of the Software, and to permit persons to whom the Software is\n', 'furnished to do so, subject to the following conditions:\n', '\n', 'The above copyright notice and this permission notice shall be included in all\n', 'copies or substantial portions of the Software.\n', '\n', 'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n', 'IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n', 'FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n', 'AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n', 'LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n', 'OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\n', 'SOFTWARE.\n', '*/\n', '\n', 'pragma solidity 0.5.17;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'interface IERC20 {\n', '  function totalSupply() external view returns (uint256);\n', '\n', '  function balanceOf(address who) external view returns (uint256);\n', '\n', '  function allowance(address owner, address spender)\n', '    external view returns (uint256);\n', '\n', '  function transfer(address to, uint256 value) external returns (bool);\n', '\n', '  function approve(address spender, uint256 value)\n', '    external returns (bool);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    external returns (bool);\n', '\n', '  event Transfer(\n', '    address indexed from,\n', '    address indexed to,\n', '    uint256 value\n', '  );\n', '\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', 'contract ERC20Detailed is IERC20 {\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '\n', '    /**\n', '     * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of\n', '     * these values are immutable: they can only be set once during\n', '     * construction.\n', '     */\n', '    constructor (string memory name, string memory symbol, uint8 decimals) public {\n', '        _name = name;\n', '        _symbol = symbol;\n', '        _decimals = decimals;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the name of the token.\n', '     */\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the symbol of the token, usually a shorter version of the\n', '     * name.\n', '     */\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the number of decimals used to get its user representation.\n', '     * For example, if `decimals` equals `2`, a balance of `505` tokens should\n', '     * be displayed to a user as `5,05` (`505 / 10 ** 2`).\n', '     *\n', '     * Tokens usually opt for a value of 18, imitating the relationship between\n', '     * Ether and Wei.\n', '     *\n', '     * NOTE: This information is only used for _display_ purposes: it in\n', '     * no way affects any of the arithmetic of the contract, including\n', '     * {IERC20-balanceOf} and {IERC20-transfer}.\n', '     */\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeMathInt\n', ' * @dev Math operations for int256 with overflow safety checks.\n', ' */\n', 'library SafeMathInt {\n', '    int256 private constant MIN_INT256 = int256(1) << 255;\n', '    int256 private constant MAX_INT256 = ~(int256(1) << 255);\n', '\n', '    /**\n', '     * @dev Multiplies two int256 variables and fails on overflow.\n', '     */\n', '    function mul(int256 a, int256 b)\n', '        internal\n', '        pure\n', '        returns (int256)\n', '    {\n', '        int256 c = a * b;\n', '\n', '        // Detect overflow when multiplying MIN_INT256 with -1\n', '        require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));\n', '        require((b == 0) || (c / b == a));\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Division of two int256 variables and fails on overflow.\n', '     */\n', '    function div(int256 a, int256 b)\n', '        internal\n', '        pure\n', '        returns (int256)\n', '    {\n', '        // Prevent overflow when dividing MIN_INT256 by -1\n', '        require(b != -1 || a != MIN_INT256);\n', '\n', '        // Solidity already throws when dividing by 0.\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Subtracts two int256 variables and fails on overflow.\n', '     */\n', '    function sub(int256 a, int256 b)\n', '        internal\n', '        pure\n', '        returns (int256)\n', '    {\n', '        int256 c = a - b;\n', '        require((b >= 0 && c <= a) || (b < 0 && c > a));\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Adds two int256 variables and fails on overflow.\n', '     */\n', '    function add(int256 a, int256 b)\n', '        internal\n', '        pure\n', '        returns (int256)\n', '    {\n', '        int256 c = a + b;\n', '        require((b >= 0 && c >= a) || (b < 0 && c < a));\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Converts to absolute value, and fails on overflow.\n', '     */\n', '    function abs(int256 a)\n', '        internal\n', '        pure\n', '        returns (int256)\n', '    {\n', '        require(a != MIN_INT256);\n', '        return a < 0 ? -a : a;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address private _owner;\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  \n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    _owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @return the address of the owner.\n', '   */\n', '  function owner() public view returns(address) {\n', '    return _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(isOwner());\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @return true if `msg.sender` is the owner of the contract.\n', '   */\n', '  function isOwner() public view returns(bool) {\n', '    return msg.sender == _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(_owner);\n', '    _owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    _transferOwnership(newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address newOwner) internal {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(_owner, newOwner);\n', '    _owner = newOwner;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Rebased V2 ERC20 token\n', ' * @dev Rebased is based on the uFragments protocol first debuted by Ampleforth.\n', ' *      uFragments is a normal ERC20 token, but its supply can be adjusted by splitting and\n', ' *      combining tokens proportionally across all wallets.\n', ' *\n', " *      uFragment balances are internally represented with a hidden denomination, 'gons'.\n", ' *      We support splitting the currency in expansion and combining the currency on contraction by\n', " *      changing the exchange rate between the hidden 'gons' and the public 'fragments'.\n", ' */\n', 'contract RebasedV2 is ERC20Detailed, Ownable {\n', '    using SafeMath for uint256;\n', '    using SafeMathInt for int256;\n', '\n', '    event LogRebase(uint256 indexed epoch, uint256 totalSupply);\n', '\n', '    // Used for authentication\n', '    address public controller;\n', '\n', '    modifier onlyController() {\n', '        require(msg.sender == controller);\n', '        _;\n', '    }\n', '\n', '    modifier validRecipient(address to) {\n', '        require(to != address(0x0));\n', '        require(to != address(this));\n', '        _;\n', '    }\n', '\n', '    uint256 private constant DECIMALS = 9;\n', '    uint256 private constant MAX_UINT256 = ~uint256(0);\n', '    uint256 private constant INITIAL_FRAGMENTS_SUPPLY =  2082412747493439;\n', '\n', '    // TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that _gonsPerFragment is an integer.\n', '    // Use the highest value that fits in a uint256 for max granularity.\n', '    uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);\n', '\n', '    // MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2\n', '    uint256 private constant MAX_SUPPLY = ~uint128(0);  // (2^128) - 1\n', '\n', '    uint256 private _totalSupply;\n', '    uint256 private _gonsPerFragment;\n', '    mapping(address => uint256) private _gonBalances;\n', '\n', '    // This is denominated in Fragments, because the gons-fragments conversion might change before\n', "    // it's fully paid.\n", '    mapping (address => mapping (address => uint256)) private _allowedFragments;\n', '\n', '    /**\n', '     * @dev Notifies Fragments contract about a new rebase cycle.\n', '     * @param supplyDelta The number of new fragment tokens to add into circulation via expansion.\n', '     * @return The total number of fragments after the supply adjustment.\n', '     */\n', '    function rebase(uint256 epoch, int256 supplyDelta)\n', '        external\n', '        onlyController\n', '        returns (uint256)\n', '    {\n', '        if (supplyDelta == 0) {\n', '            emit LogRebase(epoch, _totalSupply);\n', '            return _totalSupply;\n', '        }\n', '\n', '        if (supplyDelta < 0) {\n', '            _totalSupply = _totalSupply.sub(uint256(supplyDelta.abs()));\n', '        } else {\n', '            _totalSupply = _totalSupply.add(uint256(supplyDelta));\n', '        }\n', '\n', '        if (_totalSupply > MAX_SUPPLY) {\n', '            _totalSupply = MAX_SUPPLY;\n', '        }\n', '\n', '        _gonsPerFragment = TOTAL_GONS.div(_totalSupply);\n', '\n', '        emit LogRebase(epoch, _totalSupply);\n', '        return _totalSupply;\n', '    }\n', '\n', '    constructor()\n', '        ERC20Detailed("Rebased v2", "REB2", uint8(DECIMALS))\n', '        public\n', '    {\n', '        _totalSupply = INITIAL_FRAGMENTS_SUPPLY;\n', '        _gonBalances[msg.sender] = TOTAL_GONS;\n', '        _gonsPerFragment = TOTAL_GONS.div(_totalSupply);\n', '        \n', '        emit Transfer(address(0x0), msg.sender, _totalSupply);\n', '    }\n', '\n', '    /**\n', '     * @notice Sets a new controller\n', '     */\n', '    function setController(address _controller)\n', '        external\n', '        onlyOwner\n', '        returns (uint256)\n', '    {\n', '        controller = _controller;\n', '    }\n', '\n', '\n', '    /**\n', '     * @return The total number of fragments.\n', '     */\n', '    function totalSupply()\n', '        external\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return _totalSupply;\n', '    }\n', '\n', '    /**\n', '     * @param who The address to query.\n', '     * @return The balance of the specified address.\n', '     */\n', '    function balanceOf(address who)\n', '        external\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return _gonBalances[who].div(_gonsPerFragment);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens to a specified address.\n', '     * @param to The address to transfer to.\n', '     * @param value The amount to be transferred.\n', '     * @return True on success, false otherwise.\n', '     */\n', '    function transfer(address to, uint256 value)\n', '        external\n', '        validRecipient(to)\n', '        returns (bool)\n', '    {\n', '        uint256 gonValue = value.mul(_gonsPerFragment);\n', '        _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(gonValue);\n', '        _gonBalances[to] = _gonBalances[to].add(gonValue);\n', '        emit Transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner has allowed to a spender.\n', '     * @param owner_ The address which owns the funds.\n', '     * @param spender The address which will spend the funds.\n', '     * @return The number of tokens still available for the spender.\n', '     */\n', '    function allowance(address owner_, address spender)\n', '        external\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return _allowedFragments[owner_][spender];\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another.\n', '     * @param from The address you want to send tokens from.\n', '     * @param to The address you want to transfer to.\n', '     * @param value The amount of tokens to be transferred.\n', '     */\n', '    function transferFrom(address from, address to, uint256 value)\n', '        external\n', '        validRecipient(to)\n', '        returns (bool)\n', '    {\n', '        _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);\n', '\n', '        uint256 gonValue = value.mul(_gonsPerFragment);\n', '        _gonBalances[from] = _gonBalances[from].sub(gonValue);\n', '        _gonBalances[to] = _gonBalances[to].add(gonValue);\n', '        emit Transfer(from, to, value);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of\n', '     * msg.sender. This method is included for ERC20 compatibility.\n', '     * increaseAllowance and decreaseAllowance should be used instead.\n', '     * Changing an allowance with this method brings the risk that someone may transfer both\n', '     * the old and the new allowance - if they are both greater than zero - if a transfer\n', '     * transaction is mined before the later approve() call is mined.\n', '     *\n', '     * @param spender The address which will spend the funds.\n', '     * @param value The amount of tokens to be spent.\n', '     */\n', '    function approve(address spender, uint256 value)\n', '        external\n', '        returns (bool)\n', '    {\n', '        _allowedFragments[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner has allowed to a spender.\n', '     * This method should be used instead of approve() to avoid the double approval vulnerability\n', '     * described above.\n', '     * @param spender The address which will spend the funds.\n', '     * @param addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseAllowance(address spender, uint256 addedValue)\n', '        external\n', '        returns (bool)\n', '    {\n', '        _allowedFragments[msg.sender][spender] =\n', '            _allowedFragments[msg.sender][spender].add(addedValue);\n', '        emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner has allowed to a spender.\n', '     *\n', '     * @param spender The address which will spend the funds.\n', '     * @param subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseAllowance(address spender, uint256 subtractedValue)\n', '        external\n', '        returns (bool)\n', '    {\n', '        uint256 oldValue = _allowedFragments[msg.sender][spender];\n', '        if (subtractedValue >= oldValue) {\n', '            _allowedFragments[msg.sender][spender] = 0;\n', '        } else {\n', '            _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);\n', '        return true;\n', '    }\n', '}']