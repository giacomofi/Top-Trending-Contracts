['/**\n', ' * Copyright 2017-2020, bZeroX, LLC <https://bzx.network/>. All Rights Reserved.\n', ' * Licensed under the Apache License, Version 2.0.\n', ' */\n', '\n', 'pragma solidity 0.5.17;\n', '\n', '\n', 'interface IWeth {\n', '    function deposit() external payable;\n', '    function withdraw(uint256 wad) external;\n', '}\n', '\n', 'contract IERC20 {\n', '    string public name;\n', '    uint8 public decimals;\n', '    string public symbol;\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address _who) public view returns (uint256);\n', '    function allowance(address _owner, address _spender) public view returns (uint256);\n', '    function approve(address _spender, uint256 _value) public returns (bool);\n', '    function transfer(address _to, uint256 _value) public returns (bool);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract IWethERC20 is IWeth, IERC20 {}\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b != 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, rounding up and truncating the quotient\n', '    */\n', '    function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return divCeil(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, rounding up and truncating the quotient\n', '    */\n', '    function divCeil(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b != 0, errorMessage);\n', '\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = ((a - 1) / b) + 1;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '\n', '    function min256(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        return _a < _b ? _a : _b;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SignedSafeMath\n', ' * @dev Signed math operations with safety checks that revert on error.\n', ' */\n', 'library SignedSafeMath {\n', '    int256 constant private _INT256_MIN = -2**255;\n', '\n', '        /**\n', '     * @dev Returns the multiplication of two signed integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(int256 a, int256 b) internal pure returns (int256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        require(!(a == -1 && b == _INT256_MIN), "SignedSafeMath: multiplication overflow");\n', '\n', '        int256 c = a * b;\n', '        require(c / a == b, "SignedSafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two signed integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(int256 a, int256 b) internal pure returns (int256) {\n', '        require(b != 0, "SignedSafeMath: division by zero");\n', '        require(!(b == -1 && a == _INT256_MIN), "SignedSafeMath: division overflow");\n', '\n', '        int256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two signed integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(int256 a, int256 b) internal pure returns (int256) {\n', '        int256 c = a - b;\n', '        require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the addition of two signed integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(int256 a, int256 b) internal pure returns (int256) {\n', '        int256 c = a + b;\n', '        require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Helps contracts guard against reentrancy attacks.\n', ' * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>\n', ' * @dev If you mark a function `nonReentrant`, you should also\n', ' * mark it `external`.\n', ' */\n', 'contract ReentrancyGuard {\n', '\n', '    /// @dev Constant for unlocked guard state - non-zero to prevent extra gas costs.\n', '    /// See: https://github.com/OpenZeppelin/openzeppelin-solidity/issues/1056\n', '    uint256 internal constant REENTRANCY_GUARD_FREE = 1;\n', '\n', '    /// @dev Constant for locked guard state\n', '    uint256 internal constant REENTRANCY_GUARD_LOCKED = 2;\n', '\n', '    /**\n', '    * @dev We use a single lock for the whole contract.\n', '    */\n', '    uint256 internal reentrancyLock = REENTRANCY_GUARD_FREE;\n', '\n', '    /**\n', '    * @dev Prevents a contract from calling itself, directly or indirectly.\n', '    * If you mark a function `nonReentrant`, you should also\n', '    * mark it `external`. Calling one `nonReentrant` function from\n', '    * another is not supported. Instead, you can implement a\n', '    * `private` function doing the actual work, and an `external`\n', '    * wrapper marked as `nonReentrant`.\n', '    */\n', '    modifier nonReentrant() {\n', '        require(reentrancyLock == REENTRANCY_GUARD_FREE, "nonReentrant");\n', '        reentrancyLock = REENTRANCY_GUARD_LOCKED;\n', '        _;\n', '        reentrancyLock = REENTRANCY_GUARD_FREE;\n', '    }\n', '}\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following \n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', "        // for accounts without code, i.e. `keccak256('')`\n", '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != accountHash && codehash != 0x0);\n', '    }\n', '\n', '    /**\n', '     * @dev Converts an `address` into `address payable`. Note that this is\n', '     * simply a type cast: the actual underlying value is not changed.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function toPayable(address account) internal pure returns (address payable) {\n', '        return address(uint160(account));\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sendValue(address recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-call-value\n', '        (bool success, ) = recipient.call.value(amount)("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '}\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'contract Context {\n', '    // Empty internal constructor, to prevent people from mistakenly deploying\n', '    // an instance of this contract, which should be used via inheritance.\n', '    constructor () internal { }\n', '    // solhint-disable-previous-line no-empty-blocks\n', '\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "unauthorized");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the caller is the current owner.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return _msgSender() == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract Pausable {\n', '\n', '    // keccak256("Pausable_FunctionPause")\n', '    bytes32 internal constant Pausable_FunctionPause = 0xa7143c84d793a15503da6f19bf9119a2dac94448ca45d77c8bf08f57b2e91047;\n', '\n', '    modifier pausable(bytes4 sig) {\n', '        require(!_isPaused(sig), "unauthorized");\n', '        _;\n', '    }\n', '\n', '    function _isPaused(\n', '        bytes4 sig)\n', '        internal\n', '        view\n', '        returns (bool isPaused)\n', '    {\n', '        bytes32 slot = keccak256(abi.encodePacked(sig, Pausable_FunctionPause));\n', '        assembly {\n', '            isPaused := sload(slot)\n', '        }\n', '    }\n', '}\n', '\n', 'contract LoanTokenBase is ReentrancyGuard, Ownable, Pausable {\n', '\n', '    uint256 internal constant WEI_PRECISION = 10**18;\n', '    uint256 internal constant WEI_PERCENT_PRECISION = 10**20;\n', '\n', '    int256 internal constant sWEI_PRECISION = 10**18;\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '\n', '    // uint88 for tight packing -> 8 + 88 + 160 = 256\n', '    uint88 internal lastSettleTime_;\n', '\n', '    address public loanTokenAddress;\n', '\n', '    uint256 public baseRate;\n', '    uint256 public rateMultiplier;\n', '    uint256 public lowUtilBaseRate;\n', '    uint256 public lowUtilRateMultiplier;\n', '\n', '    uint256 public targetLevel;\n', '    uint256 public kinkLevel;\n', '    uint256 public maxScaleRate;\n', '\n', '    uint256 internal _flTotalAssetSupply;\n', '    uint256 public checkpointSupply;\n', '    uint256 public initialPrice;\n', '\n', '    mapping (uint256 => bytes32) public loanParamsIds; // mapping of keccak256(collateralToken, isTorqueLoan) to loanParamsId\n', '    mapping (address => uint256) internal checkpointPrices_; // price of token at last user checkpoint\n', '}\n', '\n', 'contract AdvancedTokenStorage is LoanTokenBase {\n', '    using SafeMath for uint256;\n', '\n', '    event Transfer(\n', '        address indexed from,\n', '        address indexed to,\n', '        uint256 value\n', '    );\n', '\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    );\n', '\n', '    event Mint(\n', '        address indexed minter,\n', '        uint256 tokenAmount,\n', '        uint256 assetAmount,\n', '        uint256 price\n', '    );\n', '\n', '    event Burn(\n', '        address indexed burner,\n', '        uint256 tokenAmount,\n', '        uint256 assetAmount,\n', '        uint256 price\n', '    );\n', '\n', '    mapping(address => uint256) internal balances;\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '    uint256 internal totalSupply_;\n', '\n', '    function totalSupply()\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return totalSupply_;\n', '    }\n', '\n', '    function balanceOf(\n', '        address _owner)\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function allowance(\n', '        address _owner,\n', '        address _spender)\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', 'contract LoanToken is AdvancedTokenStorage {\n', '\n', '    address internal target_;\n', '\n', '    constructor(\n', '        address _newOwner,\n', '        address _newTarget)\n', '        public\n', '    {\n', '        transferOwnership(_newOwner);\n', '        _setTarget(_newTarget);\n', '    }\n', '\n', '    function()\n', '        external\n', '        payable\n', '    {\n', '        if (gasleft() <= 2300) {\n', '            return;\n', '        }\n', '\n', '        address target = target_;\n', '        bytes memory data = msg.data;\n', '        assembly {\n', '            let result := delegatecall(gas, target, add(data, 0x20), mload(data), 0, 0)\n', '            let size := returndatasize\n', '            let ptr := mload(0x40)\n', '            returndatacopy(ptr, 0, size)\n', '            switch result\n', '            case 0 { revert(ptr, size) }\n', '            default { return(ptr, size) }\n', '        }\n', '    }\n', '\n', '    function setTarget(\n', '        address _newTarget)\n', '        public\n', '        onlyOwner\n', '    {\n', '        _setTarget(_newTarget);\n', '    }\n', '\n', '    function _setTarget(\n', '        address _newTarget)\n', '        internal\n', '    {\n', '        require(Address.isContract(_newTarget), "target not a contract");\n', '        target_ = _newTarget;\n', '    }\n', '}']