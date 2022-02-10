['pragma solidity 0.4.24;\n', '\n', '/* \n', '    Algoeuro\n', '    \n', '    By Hybridverse Labs\n', '    \n', '*/\n', '\n', 'contract Initializable {\n', '\n', '  bool private initialized;\n', '  bool private initializing;\n', '\n', '  modifier initializer() {\n', '    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");\n', '\n', '    bool wasInitializing = initializing;\n', '    initializing = true;\n', '    initialized = true;\n', '\n', '    _;\n', '\n', '    initializing = wasInitializing;\n', '  }\n', '\n', '  function isConstructor() private view returns (bool) {\n', '    uint256 cs;\n', '    assembly { cs := extcodesize(address) }\n', '    return cs == 0;\n', '  }\n', '\n', '  uint256[50] private ______gap;\n', '}\n', '\n', 'contract Ownable is Initializable {\n', '\n', '  address private _owner;\n', '  uint256 private _ownershipLocked;\n', '\n', '  event OwnershipLocked(address lockedOwner);\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  function initialize(address sender) internal initializer {\n', '    _owner = sender;\n', '\t_ownershipLocked = 0;\n', '  }\n', '\n', '  function owner() public view returns(address) {\n', '    return _owner;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(isOwner());\n', '    _;\n', '  }\n', '\n', '  function isOwner() public view returns(bool) {\n', '    return msg.sender == _owner;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    _transferOwnership(newOwner);\n', '  }\n', '\n', '  function _transferOwnership(address newOwner) internal {\n', '    require(_ownershipLocked == 0);\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(_owner, newOwner);\n', '    _owner = newOwner;\n', '  }\n', '  \n', '  // Set _ownershipLocked flag to lock contract owner forever\n', '  function lockOwnership() public onlyOwner {\n', '\trequire(_ownershipLocked == 0);\n', '\temit OwnershipLocked(_owner);\n', '    _ownershipLocked = 1;\n', '  }\n', '\n', '  uint256[50] private ______gap;\n', '}\n', '\n', 'interface IERC20 {\n', '  function totalSupply() external view returns (uint256);\n', '\n', '  function balanceOf(address who) external view returns (uint256);\n', '\n', '  function allowance(address owner, address spender)\n', '    external view returns (uint256);\n', '\n', '  function transfer(address to, uint256 value) external returns (bool);\n', '\n', '  function approve(address spender, uint256 value)\n', '    external returns (bool);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    external returns (bool);\n', '\n', '  event Transfer(\n', '    address indexed from,\n', '    address indexed to,\n', '    uint256 value\n', '  );\n', '\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', 'contract ERC20Detailed is Initializable, IERC20 {\n', '  string private _name;\n', '  string private _symbol;\n', '  uint8 private _decimals;\n', '\n', '  function initialize(string name, string symbol, uint8 decimals) internal initializer {\n', '    _name = name;\n', '    _symbol = symbol;\n', '    _decimals = decimals;\n', '  }\n', '\n', '  function name() public view returns(string) {\n', '    return _name;\n', '  }\n', '\n', '  function symbol() public view returns(string) {\n', '    return _symbol;\n', '  }\n', '\n', '  function decimals() public view returns(uint8) {\n', '    return _decimals;\n', '  }\n', '\n', '  uint256[50] private ______gap;\n', '}\n', '\n', 'library SafeMath {\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'library SafeMathInt {\n', '\n', '    int256 private constant MIN_INT256 = int256(1) << 255;\n', '    int256 private constant MAX_INT256 = ~(int256(1) << 255);\n', '\n', '    function mul(int256 a, int256 b)\n', '        internal\n', '        pure\n', '        returns (int256)\n', '    {\n', '        int256 c = a * b;\n', '\n', '        // Detect overflow when multiplying MIN_INT256 with -1\n', '        require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));\n', '        require((b == 0) || (c / b == a));\n', '        return c;\n', '    }\n', '\n', '    function div(int256 a, int256 b)\n', '        internal\n', '        pure\n', '        returns (int256)\n', '    {\n', '        // Prevent overflow when dividing MIN_INT256 by -1\n', '        require(b != -1 || a != MIN_INT256);\n', '\n', '        // Solidity already throws when dividing by 0.\n', '        return a / b;\n', '    }\n', '\n', '    function sub(int256 a, int256 b)\n', '        internal\n', '        pure\n', '        returns (int256)\n', '    {\n', '        int256 c = a - b;\n', '        require((b >= 0 && c <= a) || (b < 0 && c > a));\n', '        return c;\n', '    }\n', '\n', '    function add(int256 a, int256 b)\n', '        internal\n', '        pure\n', '        returns (int256)\n', '    {\n', '        int256 c = a + b;\n', '        require((b >= 0 && c >= a) || (b < 0 && c < a));\n', '        return c;\n', '    }\n', '\n', '    function abs(int256 a)\n', '        internal\n', '        pure\n', '        returns (int256)\n', '    {\n', '        require(a != MIN_INT256);\n', '        return a < 0 ? -a : a;\n', '    }\n', '}\n', '\n', 'contract AEUR is Ownable, ERC20Detailed {\n', '\n', '    using SafeMath for uint256;\n', '    using SafeMathInt for int256;\n', '\t\n', '\tstruct Transaction {\n', '        bool enabled;\n', '        address destination;\n', '        bytes data;\n', '    }\n', '\n', '    event TransactionFailed(address indexed destination, uint index, bytes data);\n', '\t\n', '\t// Stable ordering is not guaranteed.\n', '\n', '    Transaction[] public transactions;\n', '\n', '    event LogRebase(uint256 indexed epoch, uint256 totalSupply);\n', '\n', '    modifier validRecipient(address to) {\n', '        require(to != address(0x0));\n', '        require(to != address(this));\n', '        _;\n', '    }\n', '\n', '    uint256 private constant DECIMALS = 9;\n', '    uint256 private constant MAX_UINT256 = ~uint256(0);\n', '    uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 30 * 10**5 * 10**DECIMALS;\n', '\n', '\t// TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that _gonsPerFragment is an integer.\n', '    // Use the highest value that fits in a uint256 for max granularity.\n', '    uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);\n', '\n', '\t// MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2\n', '    uint256 private constant MAX_SUPPLY = ~uint128(0);  // (2^128) - 1\n', '\t\n', '\tuint256 private _epoch;\n', '\n', '    uint256 private _totalSupply;\n', '    uint256 private _gonsPerFragment;\n', '    mapping(address => uint256) private _gonBalances;\n', '\t\n', '\t// This is denominated in Fragments, because the gons-fragments conversion might change before\n', "    // it's fully paid.\n", '    mapping (address => mapping (address => uint256)) private _allowedFragments;\n', '\n', '\t/**\n', '     * @dev Notifies Fragments contract about a new rebase cycle.\n', '     * @param supplyDelta The number of new fragment tokens to add into circulation via expansion.\n', '     * @return The total number of fragments after the supply adjustment.\n', '     */\n', '    function rebase(int256 supplyDelta)\n', '        external\n', '        onlyOwner\n', '        returns (uint256)\n', '    {\n', '\t\n', '\t\t_epoch = _epoch.add(1);\n', '\t\t\n', '        if (supplyDelta == 0) {\n', '            emit LogRebase(_epoch, _totalSupply);\n', '            return _totalSupply;\n', '        }\n', '\n', '        if (supplyDelta < 0) {\n', '            _totalSupply = _totalSupply.sub(uint256(supplyDelta.abs()));\n', '        } else {\n', '            _totalSupply = _totalSupply.add(uint256(supplyDelta));\n', '        }\n', '\n', '        if (_totalSupply > MAX_SUPPLY) {\n', '            _totalSupply = MAX_SUPPLY;\n', '        }\n', '\n', '        _gonsPerFragment = TOTAL_GONS.div(_totalSupply);\n', '\t\t\n', '\t\temit LogRebase(_epoch, _totalSupply);\n', '\n', '\t\tfor (uint i = 0; i < transactions.length; i++) {\n', '            Transaction storage t = transactions[i];\n', '            if (t.enabled) {\n', '                bool result = externalCall(t.destination, t.data);\n', '                if (!result) {\n', '                    emit TransactionFailed(t.destination, i, t.data);\n', '                    revert("Transaction Failed");\n', '                }\n', '            }\n', '        }\n', '\t\t\n', '        return _totalSupply;\n', '    }\n', '\t\n', '\tconstructor() public {\n', '\t\n', '\t\tOwnable.initialize(msg.sender);\n', '\t\tERC20Detailed.initialize("Algoeuro", "AEUR", uint8(DECIMALS));\n', '        \n', '        _totalSupply = INITIAL_FRAGMENTS_SUPPLY;\n', '        _gonBalances[msg.sender] = TOTAL_GONS;\n', '        _gonsPerFragment = TOTAL_GONS.div(_totalSupply);\n', '\n', '        emit Transfer(address(0x0), msg.sender, _totalSupply);\n', '    }\n', '\t\n', '    function totalSupply()\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address who)\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return _gonBalances[who].div(_gonsPerFragment);\n', '    }\n', '\t \n', '    function transfer(address to, uint256 value)\n', '        public\n', '        validRecipient(to)\n', '        returns (bool)\n', '    {\n', '        uint256 merValue = value.mul(_gonsPerFragment);\n', '        _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(merValue);\n', '        _gonBalances[to] = _gonBalances[to].add(merValue);\n', '        emit Transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\t \n', '    function allowance(address owner_, address spender)\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return _allowedFragments[owner_][spender];\n', '    }\n', '\t\n', '\t/**\n', '     * @dev Transfer tokens from one address to another.\n', '     * @param from The address you want to send tokens from.\n', '     * @param to The address you want to transfer to.\n', '     * @param value The amount of tokens to be transferred.\n', '     */\n', '\n', '    function transferFrom(address from, address to, uint256 value)\n', '        public\n', '        validRecipient(to)\n', '        returns (bool)\n', '    {\n', '        _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);\n', '\n', '        uint256 merValue = value.mul(_gonsPerFragment);\n', '        _gonBalances[from] = _gonBalances[from].sub(merValue);\n', '        _gonBalances[to] = _gonBalances[to].add(merValue);\n', '        emit Transfer(from, to, value);\n', '\n', '        return true;\n', '    }\n', '\t\n', '\t/**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of\n', '     * msg.sender. This method is included for ERC20 compatibility.\n', '     * increaseAllowance and decreaseAllowance should be used instead.\n', '     * Changing an allowance with this method brings the risk that someone may transfer both\n', '     * the old and the new allowance - if they are both greater than zero - if a transfer\n', '     * transaction is mined before the later approve() call is mined.\n', '     *\n', '     * @param spender The address which will spend the funds.\n', '     * @param value The amount of tokens to be spent.\n', '     */\n', '\n', '    function approve(address spender, uint256 value)\n', '        public\n', '        returns (bool)\n', '    {\n', '        _allowedFragments[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue)\n', '        public\n', '        returns (bool)\n', '    {\n', '        _allowedFragments[msg.sender][spender] =\n', '            _allowedFragments[msg.sender][spender].add(addedValue);\n', '        emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\t\n', '\t/**\n', '     * @dev Decrease the amount of tokens that an owner has allowed to a spender.\n', '     *\n', '     * @param spender The address which will spend the funds.\n', '     * @param subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '\n', '    function decreaseAllowance(address spender, uint256 subtractedValue)\n', '        public\n', '        returns (bool)\n', '    {\n', '        uint256 oldValue = _allowedFragments[msg.sender][spender];\n', '        if (subtractedValue >= oldValue) {\n', '            _allowedFragments[msg.sender][spender] = 0;\n', '        } else {\n', '            _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\t\n', '    function addTransaction(address destination, bytes data)\n', '        external\n', '        onlyOwner\n', '    {\n', '        transactions.push(Transaction({\n', '            enabled: true,\n', '            destination: destination,\n', '            data: data\n', '        }));\n', '    }\n', '\n', '    function removeTransaction(uint index)\n', '        external\n', '        onlyOwner\n', '    {\n', '        require(index < transactions.length, "index out of bounds");\n', '\n', '        if (index < transactions.length - 1) {\n', '            transactions[index] = transactions[transactions.length - 1];\n', '        }\n', '\n', '        transactions.length--;\n', '    }\n', '\n', '    function setTransactionEnabled(uint index, bool enabled)\n', '        external\n', '        onlyOwner\n', '    {\n', '        require(index < transactions.length, "index must be in range of stored tx list");\n', '        transactions[index].enabled = enabled;\n', '    }\n', '\n', '    function transactionsSize()\n', '        external\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return transactions.length;\n', '    }\n', '\n', '    function externalCall(address destination, bytes data)\n', '        internal\n', '        returns (bool)\n', '    {\n', '        bool result;\n', '        assembly {  // solhint-disable-line no-inline-assembly\n', '            // "Allocate" memory for output\n', '            // (0x40 is where "free memory" pointer is stored by convention)\n', '            let outputAddress := mload(0x40)\n', '\n', '            // First 32 bytes are the padded length of data, so exclude that\n', '            let dataAddress := add(data, 32)\n', '\n', '            result := call(\n', '                // 34710 is the value that solidity is currently emitting\n', '                // It includes callGas (700) + callVeryLow (3, to pay for SUB)\n', '                // + callValueTransferGas (9000) + callNewAccountGas\n', '                // (25000, in case the destination address does not exist and needs creating)\n', '                sub(gas, 34710),\n', '\n', '\n', '                destination,\n', '                0, // transfer value in wei\n', '                dataAddress,\n', '                mload(data),  // Size of the input, in bytes. Stored in position 0 of the array.\n', '                outputAddress,\n', '                0  // Output is ignored, therefore the output size is zero\n', '            )\n', '        }\n', '        return result;\n', '    }\n', '}']