['/*\n', 'W A G E\n', 'An inflationary, decentralized store of value\n', 'https://wage.money\n', 'https://wagie.life\n', 'https://t.me/WageMoney\n', '\n', '-----------------------------------------------------------------------\n', '\n', 'This is free and unencumbered software released into the public domain.\n', '\n', 'Anyone is free to copy, modify, publish, use, compile, sell, or\n', 'distribute this software, either in source code form or as a compiled\n', 'binary, for any purpose, commercial or non-commercial, and by any\n', 'means.\n', '\n', 'In jurisdictions that recognize copyright laws, the author or authors\n', 'of this software dedicate any and all copyright interest in the\n', 'software to the public domain. We make this dedication for the benefit\n', 'of the public at large and to the detriment of our heirs and\n', 'successors. We intend this dedication to be an overt act of\n', 'relinquishment in perpetuity of all present and future rights to this\n', 'software under copyright law.\n', '\n', 'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,\n', 'EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF\n', 'MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.\n', 'IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR\n', 'OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,\n', 'ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR\n', 'OTHER DEALINGS IN THE SOFTWARE.\n', '\n', 'For more information, please refer to <http://unlicense.org/>\n', '\n', '*/\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'contract Context {\n', '    constructor () internal { }\n', '\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this;\n', '        return msg.data;\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.6.2;\n', '\n', 'library Address {\n', '    function isContract(address account) internal view returns (bool) {\n', '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != accountHash && codehash != 0x0);\n', '    }\n', '\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/* "sync() functions as a recovery mechanism in the case that a token asynchronously \n', 'deflates the balance of a pair. In this case, trades will receive sub-optimal rates, and if no liquidity provider \n', 'is willing to rectify the situation, the pair is stuck. sync() exists to set the reserves of the contract to the current balances, \n', 'providing a somewhat graceful recovery from this situation." */\n', '\n', 'interface UniV2PairI {\n', '    function sync() external; //\n', '}\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'abstract contract ERC20 is Context, IERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '\n', '    constructor (string memory name, string memory symbol) public {\n', '        _name = name;\n', '        _symbol = symbol;\n', '    }\n', '\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '\n', '    function _setupDecimals(uint8 decimals_) internal {\n', '        _decimals = decimals_;\n', '    }\n', '\n', '    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }\n', '\n', '\n', '    // Overriden ERC-20 functions (Ampleforth):\n', '    /*\n', '    totalSupply\n', '    balanceOf\n', '    transfer\n', '    allowance\n', '    approve\n', '    transferFrom\n', '    increaseAllowance\n', '    decreaseAlloance\n', '    _approve\n', '    _transfer\n', '    */\n', '\n', '}\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'interface IERC165 {\n', '    function supportsInterface(bytes4 interfaceId) external view returns (bool);\n', '}\n', '\n', 'pragma solidity ^0.6.2;\n', '\n', 'library ERC165Checker {\n', '    bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;\n', '\n', '    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;\n', '\n', '    function supportsERC165(address account) internal view returns (bool) {\n', '        return _supportsERC165Interface(account, _INTERFACE_ID_ERC165) &&\n', '            !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);\n', '    }\n', '\n', '    function supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {\n', '        return supportsERC165(account) &&\n', '            _supportsERC165Interface(account, interfaceId);\n', '    }\n', '\n', '\n', '    function supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {\n', '        if (!supportsERC165(account)) {\n', '            return false;\n', '        }\n', '\n', '        for (uint256 i = 0; i < interfaceIds.length; i++) {\n', '            if (!_supportsERC165Interface(account, interfaceIds[i])) {\n', '                return false;\n', '            }\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '\n', '    function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {\n', '        (bool success, bool result) = _callERC165SupportsInterface(account, interfaceId);\n', '\n', '        return (success && result);\n', '    }\n', '\n', '\n', '    function _callERC165SupportsInterface(address account, bytes4 interfaceId)\n', '        private\n', '        view\n', '        returns (bool, bool)\n', '    {\n', '        bytes memory encodedParams = abi.encodeWithSelector(_INTERFACE_ID_ERC165, interfaceId);\n', '        (bool success, bytes memory result) = account.staticcall{ gas: 30000 }(encodedParams);\n', '        if (result.length < 32) return (false, false);\n', '        return (success, abi.decode(result, (bool)));\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'contract ERC165 is IERC165 {\n', '\n', '    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;\n', '\n', '\n', '    mapping(bytes4 => bool) private _supportedInterfaces;\n', '\n', '    constructor () internal {\n', '        _registerInterface(_INTERFACE_ID_ERC165);\n', '    }\n', '\n', '\n', '    function supportsInterface(bytes4 interfaceId) public view override returns (bool) {\n', '        return _supportedInterfaces[interfaceId];\n', '    }\n', '\n', '\n', '    function _registerInterface(bytes4 interfaceId) internal virtual {\n', '        require(interfaceId != 0xffffffff, "ERC165: invalid interface id");\n', '        _supportedInterfaces[interfaceId] = true;\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'contract TokenRecover is Ownable {\n', '\n', '\n', '    function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {\n', '        IERC20(tokenAddress).transfer(owner(), tokenAmount);\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'library EnumerableSet {\n', '\n', '    struct Set {\n', '        bytes32[] _values;\n', '\n', '        mapping (bytes32 => uint256) _indexes;\n', '    }\n', '\n', '\n', '    function _add(Set storage set, bytes32 value) private returns (bool) {\n', '        if (!_contains(set, value)) {\n', '            set._values.push(value);\n', '            set._indexes[value] = set._values.length;\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '\n', '    function _remove(Set storage set, bytes32 value) private returns (bool) {\n', '        uint256 valueIndex = set._indexes[value];\n', '\n', '        if (valueIndex != 0) {\n', '            uint256 toDeleteIndex = valueIndex - 1;\n', '            uint256 lastIndex = set._values.length - 1;\n', '\n', '            bytes32 lastvalue = set._values[lastIndex];\n', '\n', '            set._values[toDeleteIndex] = lastvalue;\n', '            set._indexes[lastvalue] = toDeleteIndex + 1;\n', '            set._values.pop();\n', '\n', '            delete set._indexes[value];\n', '\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '\n', '    function _contains(Set storage set, bytes32 value) private view returns (bool) {\n', '        return set._indexes[value] != 0;\n', '    }\n', '\n', '\n', '    function _length(Set storage set) private view returns (uint256) {\n', '        return set._values.length;\n', '    }\n', '\n', '    function _at(Set storage set, uint256 index) private view returns (bytes32) {\n', '        require(set._values.length > index, "EnumerableSet: index out of bounds");\n', '        return set._values[index];\n', '    }\n', '\n', '    struct AddressSet {\n', '        Set _inner;\n', '    }\n', '\n', '\n', '    function add(AddressSet storage set, address value) internal returns (bool) {\n', '        return _add(set._inner, bytes32(uint256(value)));\n', '    }\n', '\n', '\n', '    function remove(AddressSet storage set, address value) internal returns (bool) {\n', '        return _remove(set._inner, bytes32(uint256(value)));\n', '    }\n', '\n', '\n', '    function contains(AddressSet storage set, address value) internal view returns (bool) {\n', '        return _contains(set._inner, bytes32(uint256(value)));\n', '    }\n', '\n', '\n', '    function length(AddressSet storage set) internal view returns (uint256) {\n', '        return _length(set._inner);\n', '    }\n', '\n', '    function at(AddressSet storage set, uint256 index) internal view returns (address) {\n', '        return address(uint256(_at(set._inner, index)));\n', '    }\n', '\n', '\n', '    struct UintSet {\n', '        Set _inner;\n', '    }\n', '\n', '\n', '    function add(UintSet storage set, uint256 value) internal returns (bool) {\n', '        return _add(set._inner, bytes32(value));\n', '    }\n', '\n', '\n', '    function remove(UintSet storage set, uint256 value) internal returns (bool) {\n', '        return _remove(set._inner, bytes32(value));\n', '    }\n', '\n', '\n', '    function contains(UintSet storage set, uint256 value) internal view returns (bool) {\n', '        return _contains(set._inner, bytes32(value));\n', '    }\n', '\n', '\n', '    function length(UintSet storage set) internal view returns (uint256) {\n', '        return _length(set._inner);\n', '    }\n', '\n', '    function at(UintSet storage set, uint256 index) internal view returns (uint256) {\n', '        return uint256(_at(set._inner, index));\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'contract WAGE is ERC20, TokenRecover {\n', '\n', '    /* \n', '    Rebase \n', '    Mechanism\n', '    Forked \n', '    from\n', '    Ampleforth\n', '    Protocol\n', '    */\n', '\n', '    using SafeMath for uint256;\n', '\n', '    event LogRebase(uint256 epoch, uint256 totalSupply);\n', '    event LogMonetaryPolicyUpdated(address monetaryPolicy);\n', '    event ChangeRebase(uint256 indexed amount);\n', '    event ChangeRebaseRate(uint256 indexed rate);\n', '    event RebaseState(bool state);\n', '    address public monetaryPolicy;\n', '\n', '    modifier onlyMonetaryPolicy() {\n', '        require(msg.sender == monetaryPolicy);\n', '        _;\n', '    }\n', '\n', '    modifier validRecipient(address to) {\n', '        require(to != address(0x0));\n', '        require(to != address(this));\n', '        _;\n', '    }\n', '\n', '    uint256 private constant MAX_UINT256 = ~uint256(0);\n', '    uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 24 * 10**18; // initial supply: 24\n', '\n', '    // TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that _gonsPerFragment is an integer.\n', '    // Use the highest value that fits in a uint256 for max granularity.\n', '    uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);\n', '\n', '    // MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2\n', '    uint256 private _totalSupply;\n', '    uint256 private constant MAX_SUPPLY = ~uint128(0); \n', '    uint256 private _gonsPerFragment;\n', '    mapping(address => uint256) private _gonBalances;\n', '\n', '    \n', '    // Union Governance / Rebase Settings\n', '    uint256 public genesis; // beginning of contract\n', "    uint256 public nextReb; // when's it time for the next rebase?\n", '    uint256 public rebaseAmount = 1e18; // initial is 1\n', '    uint256 public rebaseRate = 10800; // initial is every 3 hours\n', '    bool public rebState; // Is rebase active?\n', '    uint256 public rebaseCount = 0;\n', '\n', '    modifier rebaseEnabled() {\n', '          require(rebState == true);\n', '          _;\n', '    }\n', '    // End of Union Governance / Rebase Settings\n', '\n', '\n', '    // This is denominated in Fragments, because the gons-fragments conversion might change before\n', "    // it's fully paid.\n", '    mapping (address => mapping (address => uint256)) private _allowedFragments;\n', '\n', '    /**\n', '     * @param monetaryPolicy_ The address of the monetary policy contract to use for authentication.\n', '     */\n', '    function setMonetaryPolicy(address monetaryPolicy_)\n', '        public\n', '        onlyOwner\n', '    {\n', '        monetaryPolicy = monetaryPolicy_;\n', '        emit LogMonetaryPolicyUpdated(monetaryPolicy_);\n', '    }\n', '\n', '    /**\n', '     * @dev Notifies Fragments contract about a new rebase cycle.\n', '     * @param supplyDelta The number of new fragment tokens to add into circulation via expansion.\n', '     * @return The total number of fragments after the supply adjustment.\n', '     */\n', '    function rebase(uint256 supplyDelta) public rebaseEnabled onlyMonetaryPolicy returns (uint256) {\n', '      \n', '        require(supplyDelta >= 0, "rebase amount must be positive");\n', '        require(now >= nextReb, "not enough time has passed");\n', '        nextReb = now.add(rebaseRate);  \n', '\n', '\n', '        if (supplyDelta == 0) {\n', '            emit LogRebase(rebaseCount, _totalSupply);\n', '            return _totalSupply;\n', '        }\n', '\n', '        _totalSupply = _totalSupply.add(supplyDelta);\n', '        \n', '        if (_totalSupply > MAX_SUPPLY) {\n', '            _totalSupply = MAX_SUPPLY;\n', '        }\n', '\n', '        _gonsPerFragment = TOTAL_GONS.div(_totalSupply);\n', '\n', '        // From this point forward, _gonsPerFragment is taken as the source of truth.\n', '        // We recalculate a new _totalSupply to be in agreement with the _gonsPerFragmenta\n', '        // conversion rate.\n', '        // This means our applied supplyDelta can deviate from the requested supplyDelta,\n', '        // but this deviation is guaranteed to be < (_totalSupply^2)/(TOTAL_GONS - _totalSupply).\n', '        //\n', '        // In the case of _totalSupply <= MAX_UINT128 (our current supply cap), this\n', '        // deviation is guaranteed to be < 1, so we can omit this step. If the supply cap is\n', '        // ever increased, it must be re-included.\n', '        // _totalSupply = TOTAL_GONS.div(_gonsPerFragment)\n', '        \n', '        // updates trading pairs sync()\n', '        for (uint i = 0; i < iterateLength; i++) {\n', '            // using low level call to prevent reverts on remote error/non-existence\n', '            uniSyncs[i].sync();\n', '        }\n', '\n', '\n', '        rebaseCount = rebaseCount.add(1); // tracks rebases since genesis\n', '        emit LogRebase(rebaseCount, _totalSupply);\n', '        return _totalSupply;\n', '        \n', '    }\n', '\n', '    /* \n', '    End \n', '    Of\n', '    Fork\n', '    from\n', '    Ampleforth\n', '    Protocol\n', '    */\n', '\n', '    // indicates if transfer is enabled\n', '    bool private _transferEnabled = false;\n', '    mapping(address => bool) public transferWhitelisted;\n', '    event TransferEnabled();\n', '\n', '    // pair synchronization setup\n', '    UniV2PairI[5] public uniSyncs;\n', '    uint8 public iterateLength;\n', '    address constant uniFactory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;\n', '\n', '    // https://uniswap.org/docs/v2/smart-contract-integration/getting-pair-addresses/\n', '    function genUniAddr(address left, address right) internal pure returns (UniV2PairI) {\n', '        address first = left < right ? left : right;\n', '        address second = left < right ? right : left;\n', '        address pair = address(uint(keccak256(abi.encodePacked(\n', "          hex'ff',\n", '          uniFactory,\n', '          keccak256(abi.encodePacked(first, second)),\n', "          hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f'\n", '        ))));\n', '        return UniV2PairI(pair);\n', '    }\n', '\n', '    function setPairAddr(uint8 id, address token1, address token2) public onlyMonetaryPolicy {\n', '        uniSyncs[id] = genUniAddr(token1, token2);\n', '    }\n', '\n', "    function setIterateLength(uint8 number) public onlyMonetaryPolicy { // UniV2PairI[x] where x can be null, and null can't be synced.\n", '        iterateLength = number;\n', '    }\n', '\n', '\n', '    modifier canTransfer(address from) {\n', '        require(\n', '            _transferEnabled || transferWhitelisted[msg.sender] == true,\n', '            "WAGE: transfer is not enabled or sender is not owner!"\n', '        );\n', '        _;\n', '    }\n', '\n', '      constructor(\n', '            string memory name,\n', '            string memory symbol,\n', '            uint8 decimals,\n', '            uint256 initialSupply,\n', '            bool transferEnabled\n', '      )\n', '            public\n', '            ERC20(name, symbol)\n', '      {\n', '\n', '            whitelistTransferer(msg.sender);\n', '\n', '            _gonBalances[msg.sender] = TOTAL_GONS;\n', '            _gonsPerFragment = TOTAL_GONS.div(initialSupply);\n', '            _totalSupply = initialSupply;\n', '            emit Transfer(address(0x0), msg.sender, initialSupply);\n', '\n', '            monetaryPolicy = msg.sender; // Owner initially controls monetary policy\n', '            genesis = now; // Beginning of project WAGE\n', '            nextReb = genesis; // Timer begins at genesis\n', '            rebState = false; // Rebase is off initially\n', '            \n', '            _setupDecimals(decimals);\n', '\n', '            if (transferEnabled) {\n', '                  enableTransfer();\n', '            }\n', '      }\n', '\n', '    function transferEnabled() public view returns (bool) {\n', '        return _transferEnabled;\n', '    }\n', '\n', '    function enableTransfer() public onlyOwner {\n', '        _transferEnabled = true;\n', '\n', '        emit TransferEnabled();\n', '    }\n', '\n', '    function whitelistTransferer(address user) public onlyOwner {\n', '        transferWhitelisted[user] = true; \n', '    }\n', '\n', '\n', '    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20) {\n', '        super._beforeTokenTransfer(from, to, amount);\n', '    }\n', '\n', '\n', '    /* Begin Ampleforth ERC-20 Implementation */\n', '    \n', '    function totalSupply() public view override returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address who) public view override returns (uint256) {\n', '        return _gonBalances[who].div(_gonsPerFragment);\n', '    }\n', '\n', '    function transfer(address to, uint value) public override validRecipient(to) canTransfer(msg.sender) returns(bool success) {\n', '        _transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint value) public override validRecipient(to) canTransfer(from) returns (bool success) {\n', "        require(value <= _allowedFragments[from][msg.sender], 'Must not send more than allowance');\n", '        _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);\n', '        _transfer(from, to, value);\n', '        return true;\n', '    }\n', '\n', '    function _transfer(address from, address to, uint256 value) internal returns (bool success) {\n', '         uint256 gonValue = value.mul(_gonsPerFragment);\n', '        _gonBalances[from] = _gonBalances[from].sub(gonValue);\n', '        _gonBalances[to] = _gonBalances[to].add(gonValue);\n', '\n', '        /* \n', '        Rebase mechanism is built into transfer to automate the function call. Timing will be dependent on transaction volume.\n', '        Rebase can be altered through governance. The frequency, amount, and state will be made modular through the Union contract.\n', '        */\n', '        if (rebState == true) { // checks if rebases are enabled \n', '            if (now >= nextReb) { // prevents errors\n', '                rebase(rebaseAmount);\n', '            }\n', '        }\n', '\n', '        emit Transfer(from, to, value);       \n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner has allowed to a spender.\n', '     * @param owner_ The address which owns the funds.\n', '     * @param spender The address which will spend the funds.\n', '     * @return The number of tokens still available for the spender.\n', '     */\n', '    function allowance(address owner_, address spender)\n', '        public\n', '        override\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return _allowedFragments[owner_][spender];\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of\n', '     * msg.sender. This method is included for ERC20 compatibility.\n', '     * increaseAllowance and decreaseAllowance should be used instead.\n', '     * Changing an allowance with this method brings the risk that someone may transfer both\n', '     * the old and the new allowance - if they are both greater than zero - if a transfer\n', '     * transaction is mined before the later approve() call is mined.\n', '     *\n', '     * @param spender The address which will spend the funds.\n', '     * @param value The amount of tokens to be spent.\n', '     */\n', '    function approve(address spender, uint256 value)\n', '        public\n', '        override\n', '        returns (bool)\n', '    {\n', '        _allowedFragments[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner has allowed to a spender.\n', '     * This method should be used instead of approve() to avoid the double approval vulnerability\n', '     * described above.\n', '     * @param spender The address which will spend the funds.\n', '     * @param addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseAllowance(address spender, uint256 addedValue)\n', '        public\n', '        returns (bool)\n', '    {\n', '        _allowedFragments[msg.sender][spender] =_allowedFragments[msg.sender][spender].add(addedValue);\n', '        emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner has allowed to a spender.\n', '     *\n', '     * @param spender The address which will spend the funds.\n', '     * @param subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseAllowance(address spender, uint256 subtractedValue)\n', '        public\n', '        returns (bool)\n', '    {\n', '        uint256 oldValue = _allowedFragments[msg.sender][spender];\n', '        if (subtractedValue >= oldValue) {\n', '            _allowedFragments[msg.sender][spender] = 0;\n', '        } else {\n', '            _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '    /* Conclude Ampleforth ERC-20 Implementation */\n', '\n', '    /* Begin Union functions */\n', "    function publicRebase() rebaseEnabled external { // Anyone can call the rebase if it's time to do so\n", '        rebase(rebaseAmount);\n', '    }\n', '\n', '    function changeRebase(uint256 amount) public onlyMonetaryPolicy { //alters rebaseAmount\n', '        require(amount > 0); // To pause, use rebaseState()\n', '        rebaseAmount = amount;\n', '        emit ChangeRebase(amount);\n', '    }\n', '\n', '    function changeRebaseFreq(uint256 rate) public onlyMonetaryPolicy { //alters rebaseFreq \n', '        require(rate > 0); // To pause, use rebaseState()\n', '        rebaseRate = rate;\n', '        emit ChangeRebaseRate(rate);\n', '    }\n', '\n', '    function rebaseState(bool state) public onlyMonetaryPolicy {\n', '        rebState = state;\n', '        emit RebaseState(state);\n', '    }\n', '\n', '    function resetTime() public onlyMonetaryPolicy {\n', '        nextReb = now; // In case of emergency.. (nextReb might be too far away)\n', '    }\n', '    /* End Union functions */\n', '\n', '\n', '\n', '}']