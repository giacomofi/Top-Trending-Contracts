['pragma solidity 0.5.17;\n', '\n', '\n', '\n', 'contract Initializable\n', '{\n', '\n', '  bool private initialized;\n', 'bool private initializing;\n', '\n', 'modifier initializer()\n', '{\n', '    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");\n', '\n', '    bool wasInitializing = initializing;\n', '    initializing = true;\n', '    initialized = true;\n', '\n', '    _;\n', '\n', '    initializing = wasInitializing;\n', '}\n', '\n', 'function isConstructor() private view returns(bool)\n', '{\n', '    uint256 cs;\n', '    assembly { cs:= extcodesize(address) }\n', '    return cs == 0;\n', '}\n', '\n', 'uint256[50] private ______gap;\n', '}\n', '\n', 'contract Ownable is Initializable {\n', '\n', '  address private _owner;\n', 'uint256 private _ownershipLocked;\n', '\n', 'event OwnershipLocked(address lockedOwner);\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', 'function initialize(address sender) internal initializer\n', '{\n', '    _owner = sender;\n', '    _ownershipLocked = 0;\n', '}\n', '\n', 'function owner() public view returns(address)\n', '{\n', '    return _owner;\n', '}\n', '\n', 'modifier onlyOwner()\n', '{\n', '    require(isOwner());\n', '    _;\n', '}\n', '\n', 'function isOwner() public view returns(bool)\n', '{\n', '    return msg.sender == _owner;\n', '}\n', '\n', 'function transferOwnership(address newOwner) public onlyOwner\n', '{\n', '    _transferOwnership(newOwner);\n', '}\n', '\n', 'function _transferOwnership(address newOwner) internal\n', '{\n', '    require(_ownershipLocked == 0);\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(_owner, newOwner);\n', '    _owner = newOwner;\n', '}\n', '\n', '// Set _ownershipLocked flag to lock contract owner forever\n', 'function lockOwnership() public onlyOwner\n', '{\n', '    require(_ownershipLocked == 0);\n', '    emit OwnershipLocked(_owner);\n', '    _ownershipLocked = 1;\n', '}\n', '\n', 'uint256[50] private ______gap;\n', '}\n', '\n', 'interface IERC20\n', '{\n', '    function totalSupply() external view returns(uint256);\n', '\n', '    function balanceOf(address who) external view returns(uint256);\n', '\n', '    function allowance(address owner, address spender)\n', '    external view returns(uint256);\n', '\n', '    function transfer(address to, uint256 value) external returns(bool);\n', '\n', '    function approve(address spender, uint256 value)\n', '    external returns(bool);\n', '\n', '    function transferFrom(address from, address to, uint256 value)\n', '    external returns(bool);\n', '\n', '    event Transfer(\n', '      address indexed from,\n', '      address indexed to,\n', '      uint256 value\n', '  );\n', '\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', 'contract ERC20Detailed is Initializable, IERC20 {\n', '  string private _name;\n', 'string private _symbol;\n', 'uint8 private _decimals;\n', '\n', 'function initialize(string memory name, string memory symbol, uint8 decimals) internal initializer\n', '{\n', '    _name = name;\n', '    _symbol = symbol;\n', '    _decimals = decimals;\n', '}\n', '\n', 'function name() public view returns(string memory)\n', '{\n', '    return _name;\n', '}\n', '\n', 'function symbol() public view returns(string memory)\n', '{\n', '    return _symbol;\n', '}\n', '\n', 'function decimals() public view returns(uint8)\n', '{\n', '    return _decimals;\n', '}\n', '\n', 'uint256[50] private ______gap;\n', '}\n', '\n', 'library SafeMath\n', '{\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns(uint256)\n', '    {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns(uint256)\n', '    {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256)\n', '    {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns(uint256)\n', '    {\n', '        if (a == 0)\n', '        {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns(uint256)\n', '    {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256)\n', '    {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns(uint256)\n', '    {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256)\n', '    {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '    }\n', '\n', '    /*\n', '    MIT License\n', '\n', '    Copyright (c) 2018 requestnetwork\n', '    Copyright (c) 2018 Fragments, Inc.\n', '\n', '    Permission is hereby granted, free of charge, to any person obtaining a copy\n', '    of this software and associated documentation files (the "Software"), to deal\n', '    in the Software without restriction, including without limitation the rights\n', '    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\n', '    copies of the Software, and to permit persons to whom the Software is\n', '    furnished to do so, subject to the following conditions:\n', '\n', '    The above copyright notice and this permission notice shall be included in all\n', '    copies or substantial portions of the Software.\n', '\n', '    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n', '    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n', '    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n', '    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n', '    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n', '    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\n', '    SOFTWARE.\n', '    */\n', '\n', '    library SafeMathInt\n', '    {\n', '\n', '        int256 private constant MIN_INT256 = int256(1) << 255;\n', 'int256 private constant MAX_INT256 = ~(int256(1) << 255);\n', '\n', 'function mul(int256 a, int256 b)\n', '        internal\n', '        pure\n', '        returns(int256)\n', '{\n', '    int256 c = a * b;\n', '\n', '    // Detect overflow when multiplying MIN_INT256 with -1\n', '    require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));\n', '    require((b == 0) || (c / b == a));\n', '    return c;\n', '}\n', '\n', 'function div(int256 a, int256 b)\n', '        internal\n', '        pure\n', '        returns(int256)\n', '{\n', '    // Prevent overflow when dividing MIN_INT256 by -1\n', '    require(b != -1 || a != MIN_INT256);\n', '\n', '    // Solidity already throws when dividing by 0.\n', '    return a / b;\n', '}\n', '\n', 'function sub(int256 a, int256 b)\n', '        internal\n', '        pure\n', '        returns(int256)\n', '{\n', '    int256 c = a - b;\n', '    require((b >= 0 && c <= a) || (b < 0 && c > a));\n', '    return c;\n', '}\n', '\n', 'function add(int256 a, int256 b)\n', '        internal\n', '        pure\n', '        returns(int256)\n', '{\n', '    int256 c = a + b;\n', '    require((b >= 0 && c >= a) || (b < 0 && c < a));\n', '    return c;\n', '}\n', '\n', 'function abs(int256 a)\n', '        internal\n', '        pure\n', '        returns(int256)\n', '{\n', '    require(a != MIN_INT256);\n', '    return a < 0 ? -a : a;\n', '}\n', '}\n', '\n', 'contract EVA is Ownable, ERC20Detailed {\n', '\n', '\t// PLEASE READ BEFORE CHANGING ANY ACCOUNTING OR MATH\n', '    // Anytime there is division, there is a risk of numerical instability from rounding errors. In\n', '    // order to minimize this risk, we adhere to the following guidelines:\n', '    // 1) The conversion rate adopted is the number of gons that equals 1 fragment.\n', '    //    The inverse rate must not be used--TOTAL_GONS is always the numerator and _totalSupply is\n', '    //    always the denominator. (i.e. If you want to convert gons to fragments instead of\n', '    //    multiplying by the inverse rate, you should divide by the normal rate)\n', '    // 2) Gon balances converted into Fragments are always rounded down (truncated).\n', '    //\n', '    // We make the following guarantees:\n', "    // - If address 'A' transfers x Fragments to address 'B'. A's resulting external balance will\n", "    //   be decreased by precisely x Fragments, and B's external balance will be precisely\n", '    //   increased by x Fragments.\n', '    //\n', '    // We do not guarantee that the sum of all balances equals the result of calling totalSupply().\n', "    // This is because, for any conversion function 'f()' that has non-zero rounding error,\n", '    // f(x0) + f(x1) + ... + f(xn) is not always equal to f(x0 + x1 + ... xn).\n', '\t\n', '\n', '    using SafeMath for uint256;\n', '    using SafeMathInt for int256;\n', '\n', '\n', '    struct Transaction\n', '{\n', '    bool enabled;\n', '    address destination;\n', '    bytes data;\n', '}\n', '\n', 'event TransactionFailed(address indexed destination, uint index, bytes data);\n', '\n', '// Stable ordering is not guaranteed.\n', '\n', 'Transaction []\n', 'public transactions;\n', '\n', '    event LogRebase(uint256 indexed epoch, uint256 totalSupply);\n', '\n', 'modifier validRecipient(address to) {\n', '    require(to != address(0x0));\n', '    require(to != address(this));\n', '    _;\n', '}\n', '\n', 'uint256 private constant DECIMALS = 18;\n', 'uint256 private constant MAX_UINT256 = ~uint256(0);\n', 'uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 1500000 * 10**DECIMALS;\n', '\n', '// TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that _gonsPerFragment is an integer.\n', '// Use the highest value that fits in a uint256 for max granularity.\n', 'uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);\n', '\n', '// MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2\n', 'uint256 private constant MAX_SUPPLY = ~uint128(0);  // (2^128) - 1\n', '\n', 'uint256 private _epoch;\n', '\n', 'uint256 private _totalSupply;\n', 'uint256 private _gonsPerFragment;\n', 'address private rebaser;\n', 'mapping(address => uint256) private _gonBalances;\n', '\n', '// This is denominated in Fragments, because the gons-fragments conversion might change before\n', "// it's fully paid.\n", 'mapping(address => mapping(address => uint256)) private _allowedFragments;\n', '\n', '\n', 'modifier onlyRebaser()\n', '{\n', '    require(msg.sender == rebaser);\n', '    _;\n', '}\n', '\n', 'function setRebaser(address _rebaser) public onlyOwner\n', '{\n', '    rebaser = _rebaser;\n', '}\n', '\n', '/**\n', ' * @dev Notifies Fragments contract about a new rebase cycle.\n', ' * @param supplyDelta The number of new fragment tokens to add into circulation via expansion.\n', ' * @return The total number of fragments after the supply adjustment.\n', ' */\n', 'function rebase(int256 supplyDelta)\n', '        external\n', '        onlyRebaser\n', '        returns (uint256)\n', '    {\n', '\n', '    _epoch = _epoch.add(1);\n', '\n', '    if (supplyDelta == 0)\n', '    {\n', '        emit LogRebase(_epoch, _totalSupply);\n', '        return _totalSupply;\n', '    }\n', '\n', '    if (supplyDelta < 0)\n', '    {\n', '        _totalSupply = _totalSupply.sub(uint256(supplyDelta.abs()));\n', '    }\n', '    else\n', '    {\n', '        _totalSupply = _totalSupply.add(uint256(supplyDelta));\n', '    }\n', '\n', '    if (_totalSupply > MAX_SUPPLY)\n', '    {\n', '        _totalSupply = MAX_SUPPLY;\n', '    }\n', '\n', '    _gonsPerFragment = TOTAL_GONS.div(_totalSupply);\n', '\n', '    // From this point forward, _gonsPerFragment is taken as the source of truth.\n', '    // We recalculate a new _totalSupply to be in agreement with the _gonsPerFragment\n', '    // conversion rate.\n', '    // This means our applied supplyDelta can deviate from the requested supplyDelta,\n', '    // but this deviation is guaranteed to be < (_totalSupply^2)/(TOTAL_GONS - _totalSupply).\n', '    //\n', '    // In the case of _totalSupply <= MAX_UINT128 (our current supply cap), this\n', '    // deviation is guaranteed to be < 1, so we can omit this step. If the supply cap is\n', '    // ever increased, it must be re-included.\n', '    // _totalSupply = TOTAL_GONS.div(_gonsPerFragment)\n', '\n', '    emit LogRebase(_epoch, _totalSupply);\n', '\n', '    for (uint i = 0; i < transactions.length; i++)\n', '    {\n', '        Transaction storage t = transactions[i];\n', '        if (t.enabled)\n', '        {\n', '            bool result = externalCall(t.destination, t.data);\n', '            if (!result)\n', '            {\n', '                emit TransactionFailed(t.destination, i, t.data);\n', '                revert("Transaction Failed");\n', '            }\n', '        }\n', '    }\n', '\n', '    return _totalSupply;\n', '}\n', '\n', 'constructor() public\n', '{\n', '\n', '    Ownable.initialize(msg.sender);\n', '    ERC20Detailed.initialize("Evalanche", "EVA", uint8(DECIMALS));\n', '\n', '    _totalSupply = INITIAL_FRAGMENTS_SUPPLY;\n', '    _gonBalances[msg.sender] = TOTAL_GONS;\n', '    _gonsPerFragment = TOTAL_GONS.div(_totalSupply);\n', '\n', '    emit Transfer(address(0x0), msg.sender, _totalSupply);\n', '}\n', '\n', '\n', '/**\n', ' * @return The total number of fragments.\n', ' */\n', '\n', 'function totalSupply()\n', '        public\n', '        view\n', '        returns(uint256)\n', '{\n', '    return _totalSupply;\n', '}\n', '\n', '/**\n', ' * @param who The address to query.\n', ' * @return The balance of the specified address.\n', ' */\n', '\n', 'function balanceOf(address who)\n', '        public\n', '        view\n', '        returns(uint256)\n', '{\n', '    return _gonBalances[who].div(_gonsPerFragment);\n', '}\n', '\n', '/**\n', ' * @dev Transfer tokens to a specified address.\n', ' * @param to The address to transfer to.\n', ' * @param value The amount to be transferred.\n', ' * @return True on success, false otherwise.\n', ' */\n', '\n', 'function transfer(address to, uint256 value)\n', '        public\n', '        validRecipient(to)\n', '        returns(bool)\n', '    {\n', '    uint256 merValue = value.mul(_gonsPerFragment);\n', '    _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(merValue);\n', '    _gonBalances[to] = _gonBalances[to].add(merValue);\n', '    emit Transfer(msg.sender, to, value);\n', '    return true;\n', '}\n', '\n', '/**\n', ' * @dev Function to check the amount of tokens that an owner has allowed to a spender.\n', ' * @param owner_ The address which owns the funds.\n', ' * @param spender The address which will spend the funds.\n', ' * @return The number of tokens still available for the spender.\n', ' */\n', '\n', 'function allowance(address owner_, address spender)\n', '        public\n', '        view\n', '        returns(uint256)\n', '{\n', '    return _allowedFragments[owner_][spender];\n', '}\n', '\n', '/**\n', ' * @dev Transfer tokens from one address to another.\n', ' * @param from The address you want to send tokens from.\n', ' * @param to The address you want to transfer to.\n', ' * @param value The amount of tokens to be transferred.\n', ' */\n', '\n', 'function transferFrom(address from, address to, uint256 value)\n', '        public\n', '        validRecipient(to)\n', '        returns(bool)\n', '    {\n', '    _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);\n', '\n', '    uint256 merValue = value.mul(_gonsPerFragment);\n', '    _gonBalances[from] = _gonBalances[from].sub(merValue);\n', '    _gonBalances[to] = _gonBalances[to].add(merValue);\n', '    emit Transfer(from, to, value);\n', '\n', '    return true;\n', '}\n', '\n', '/**\n', ' * @dev Approve the passed address to spend the specified amount of tokens on behalf of\n', ' * msg.sender. This method is included for ERC20 compatibility.\n', ' * increaseAllowance and decreaseAllowance should be used instead.\n', ' * Changing an allowance with this method brings the risk that someone may transfer both\n', ' * the old and the new allowance - if they are both greater than zero - if a transfer\n', ' * transaction is mined before the later approve() call is mined.\n', ' *\n', ' * @param spender The address which will spend the funds.\n', ' * @param value The amount of tokens to be spent.\n', ' */\n', '\n', 'function approve(address spender, uint256 value)\n', '        public\n', '        returns (bool)\n', '{\n', '    _allowedFragments[msg.sender][spender] = value;\n', '    emit Approval(msg.sender, spender, value);\n', '    return true;\n', '}\n', '\n', '/**\n', ' * @dev Increase the amount of tokens that an owner has allowed to a spender.\n', ' * This method should be used instead of approve() to avoid the double approval vulnerability\n', ' * described above.\n', ' * @param spender The address which will spend the funds.\n', ' * @param addedValue The amount of tokens to increase the allowance by.\n', ' */\n', '\n', 'function increaseAllowance(address spender, uint256 addedValue)\n', '        public\n', '        returns (bool)\n', '{\n', '    _allowedFragments[msg.sender][spender] =\n', '        _allowedFragments[msg.sender][spender].add(addedValue);\n', '    emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);\n', '    return true;\n', '}\n', '\n', '/**\n', ' * @dev Decrease the amount of tokens that an owner has allowed to a spender.\n', ' *\n', ' * @param spender The address which will spend the funds.\n', ' * @param subtractedValue The amount of tokens to decrease the allowance by.\n', ' */\n', '\n', 'function decreaseAllowance(address spender, uint256 subtractedValue)\n', '        public\n', '        returns (bool)\n', '{\n', '    uint256 oldValue = _allowedFragments[msg.sender][spender];\n', '    if (subtractedValue >= oldValue)\n', '    {\n', '        _allowedFragments[msg.sender][spender] = 0;\n', '    }\n', '    else\n', '    {\n', '        _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);\n', '    return true;\n', '}\n', '\n', '/**\n', ' * @notice Adds a transaction that gets called for a downstream receiver of rebases\n', ' * @param destination Address of contract destination\n', ' * @param data Transaction data payload\n', ' */\n', '\n', 'function addTransaction(address destination, bytes calldata data)\n', '        external\n', '        onlyOwner\n', '{\n', '    transactions.push(Transaction({\n', '    enabled: true,\n', '            destination: destination,\n', '            data: data\n', '        }));\n', '}\n', '\n', '/**\n', ' * @param index Index of transaction to remove.\n', ' *              Transaction ordering may have changed since adding.\n', ' */\n', '\n', 'function removeTransaction(uint index)\n', '        external\n', '        onlyOwner\n', '{\n', '    require(index < transactions.length, "index out of bounds");\n', '\n', '        if (index < transactions.length - 1) {\n', '        transactions[index] = transactions[transactions.length - 1];\n', '    }\n', '\n', '    transactions.length--;\n', '}\n', '\n', '/**\n', ' * @param index Index of transaction. Transaction ordering may have changed since adding.\n', ' * @param enabled True for enabled, false for disabled.\n', ' */\n', '\n', 'function setTransactionEnabled(uint index, bool enabled)\n', '        external\n', '        onlyOwner\n', '{\n', '    require(index < transactions.length, "index must be in range of stored tx list");\n', '    transactions [index].enabled = enabled;\n', '}\n', '\n', '/**\n', ' * @return Number of transactions, both enabled and disabled, in transactions list.\n', ' */\n', '\n', 'function transactionsSize()\n', '        external\n', '        view\n', '        returns (uint256)\n', '    {\n', '    return transactions.length;\n', '}\n', '\n', '/**\n', ' * @dev wrapper to call the encoded transactions on downstream consumers.\n', ' * @param destination Address of destination contract.\n', ' * @param data The encoded data payload.\n', ' * @return True on success\n', ' */\n', '\n', 'function externalCall(address destination, bytes memory data)\n', '        internal\n', '        returns (bool)\n', '{\n', '    bool result;\n', '    assembly {  // solhint-disable-line no-inline-assembly\n', '                // "Allocate" memory for output\n', '                // (0x40 is where "free memory" pointer is stored by convention)\n', '        let outputAddress := mload(0x40)\n', '\n', '            // First 32 bytes are the padded length of data, so exclude that\n', 'let dataAddress := add(data, 32)\n', '\n', '            result:= call(\n', '               // 34710 is the value that solidity is currently emitting\n', '               // It includes callGas (700) + callVeryLow (3, to pay for SUB)\n', '               // + callValueTransferGas (9000) + callNewAccountGas\n', '               // (25000, in case the destination address does not exist and needs creating)\n', '               sub(gas, 34710),\n', '\n', '\n', '               destination,\n', '               0, // transfer value in wei\n', '               dataAddress,\n', '               mload(data),  // Size of the input, in bytes. Stored in position 0 of the array.\n', '               outputAddress,\n', '               0  // Output is ignored, therefore the output size is zero\n', '           )\n', '        }\n', '        return result;\n', '    }\n', '}']