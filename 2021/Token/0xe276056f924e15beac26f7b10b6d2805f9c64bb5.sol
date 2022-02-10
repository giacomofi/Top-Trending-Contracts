['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-28\n', '*/\n', '\n', '// SPDX-License-Identifier: Unlicensed\n', '\n', '\n', '\n', 'pragma solidity ^0.6.12;\n', '\n', '\n', '\n', 'abstract contract Context {\n', '\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '\n', '        return msg.sender;\n', '\n', '    }\n', '\n', '\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '\n', '        return msg.data;\n', '\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', 'interface IERC20 {\n', '\n', '    /**\n', '\n', '     * @dev Returns the amount of tokens in existence.\n', '\n', '     */\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '\n', '\n', '    /**\n', '\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '\n', '     */\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '\n', '\n', '    /**\n', '\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '\n', '     *\n', '\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '\n', '     *\n', '\n', '     * Emits a {Transfer} event.\n', '\n', '     */\n', '\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '\n', '\n', '    /**\n', '\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '\n', '     * zero by default.\n', '\n', '     *\n', '\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '\n', '     */\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '\n', '\n', '    /**\n', '\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '\n', '     *\n', '\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '\n', '     *\n', '\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '\n', '     * transaction ordering. One possible solution to mitigate this race\n', '\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '\n', '     * desired value afterwards:\n', '\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '\n', '     *\n', '\n', '     * Emits an {Approval} event.\n', '\n', '     */\n', '\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '\n', '\n', '    /**\n', '\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', '\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '\n', '     * allowance.\n', '\n', '     *\n', '\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '\n', '     *\n', '\n', '     * Emits a {Transfer} event.\n', '\n', '     */\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '\n', '\n', '    /**\n', '\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '\n', '     * another (`to`).\n', '\n', '     *\n', '\n', '     * Note that `value` may be zero.\n', '\n', '     */\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '\n', '\n', '    /**\n', '\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '\n', '     * a call to {approve}. `value` is the new allowance.\n', '\n', '     */\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '}\n', '\n', '\n', '\n', 'library SafeMath {\n', '\n', '    /**\n', '\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '\n', '     * overflow.\n', '\n', '     *\n', '\n', "     * Counterpart to Solidity's `+` operator.\n", '\n', '     *\n', '\n', '     * Requirements:\n', '\n', '     *\n', '\n', '     * - Addition cannot overflow.\n', '\n', '     */\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\n', '        uint256 c = a + b;\n', '\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '\n', '\n', '        return c;\n', '\n', '    }\n', '\n', '\n', '\n', '    /**\n', '\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '\n', '     * overflow (when the result is negative).\n', '\n', '     *\n', '\n', "     * Counterpart to Solidity's `-` operator.\n", '\n', '     *\n', '\n', '     * Requirements:\n', '\n', '     *\n', '\n', '     * - Subtraction cannot overflow.\n', '\n', '     */\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '\n', '    }\n', '\n', '\n', '\n', '    /**\n', '\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '\n', '     * overflow (when the result is negative).\n', '\n', '     *\n', '\n', "     * Counterpart to Solidity's `-` operator.\n", '\n', '     *\n', '\n', '     * Requirements:\n', '\n', '     *\n', '\n', '     * - Subtraction cannot overflow.\n', '\n', '     */\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '\n', '        require(b <= a, errorMessage);\n', '\n', '        uint256 c = a - b;\n', '\n', '\n', '\n', '        return c;\n', '\n', '    }\n', '\n', '\n', '\n', '    /**\n', '\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '\n', '     * overflow.\n', '\n', '     *\n', '\n', "     * Counterpart to Solidity's `*` operator.\n", '\n', '     *\n', '\n', '     * Requirements:\n', '\n', '     *\n', '\n', '     * - Multiplication cannot overflow.\n', '\n', '     */\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", '\n', "        // benefit is lost if 'b' is also tested.\n", '\n', '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '\n', '        if (a == 0) {\n', '\n', '            return 0;\n', '\n', '        }\n', '\n', '\n', '\n', '        uint256 c = a * b;\n', '\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '\n', '\n', '        return c;\n', '\n', '    }\n', '\n', '\n', '\n', '    /**\n', '\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '\n', '     * division by zero. The result is rounded towards zero.\n', '\n', '     *\n', '\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '\n', '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '\n', '     *\n', '\n', '     * Requirements:\n', '\n', '     *\n', '\n', '     * - The divisor cannot be zero.\n', '\n', '     */\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\n', '        return div(a, b, "SafeMath: division by zero");\n', '\n', '    }\n', '\n', '\n', '\n', '    /**\n', '\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '\n', '     * division by zero. The result is rounded towards zero.\n', '\n', '     *\n', '\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '\n', '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '\n', '     *\n', '\n', '     * Requirements:\n', '\n', '     *\n', '\n', '     * - The divisor cannot be zero.\n', '\n', '     */\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '\n', '        require(b > 0, errorMessage);\n', '\n', '        uint256 c = a / b;\n', '\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '\n', '\n', '        return c;\n', '\n', '    }\n', '\n', '\n', '\n', '    /**\n', '\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '\n', '     * Reverts when dividing by zero.\n', '\n', '     *\n', '\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '\n', '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '\n', '     *\n', '\n', '     * Requirements:\n', '\n', '     *\n', '\n', '     * - The divisor cannot be zero.\n', '\n', '     */\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '\n', '    }\n', '\n', '\n', '\n', '    /**\n', '\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '\n', '     * Reverts with custom message when dividing by zero.\n', '\n', '     *\n', '\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '\n', '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '\n', '     *\n', '\n', '     * Requirements:\n', '\n', '     *\n', '\n', '     * - The divisor cannot be zero.\n', '\n', '     */\n', '\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '\n', '        require(b != 0, errorMessage);\n', '\n', '        return a % b;\n', '\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', 'library Address {\n', '\n', '    /**\n', '\n', '     * @dev Returns true if `account` is a contract.\n', '\n', '     *\n', '\n', '     * [IMPORTANT]\n', '\n', '     * ====\n', '\n', '     * It is unsafe to assume that an address for which this function returns\n', '\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '\n', '     *\n', '\n', '     * Among others, `isContract` will return false for the following\n', '\n', '     * types of addresses:\n', '\n', '     *\n', '\n', '     *  - an externally-owned account\n', '\n', '     *  - a contract in construction\n', '\n', '     *  - an address where a contract will be created\n', '\n', '     *  - an address where a contract lived, but was destroyed\n', '\n', '     * ====\n', '\n', '     */\n', '\n', '    function isContract(address account) internal view returns (bool) {\n', '\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', '\n', "        // for accounts without code, i.e. `keccak256('')`\n", '\n', '        bytes32 codehash;\n', '\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '\n', '        // solhint-disable-next-line no-inline-assembly\n', '\n', '        assembly { codehash := extcodehash(account) }\n', '\n', '        return (codehash != accountHash && codehash != 0x0);\n', '\n', '    }\n', '\n', '\n', '\n', '    /**\n', '\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '\n', '     * `recipient`, forwarding all available gas and reverting on errors.\n', '\n', '     *\n', '\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '\n', '     * `transfer`. {sendValue} removes this limitation.\n', '\n', '     *\n', '\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '\n', '     *\n', '\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '\n', '     * {ReentrancyGuard} or the\n', '\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '\n', '     */\n', '\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '\n', '    }\n', '\n', '\n', '\n', '    /**\n', '\n', '     * @dev Performs a Solidity function call using a low level `call`. A\n', '\n', '     * plain`call` is an unsafe replacement for a function call: use this\n', '\n', '     * function instead.\n', '\n', '     *\n', '\n', '     * If `target` reverts with a revert reason, it is bubbled up by this\n', '\n', '     * function (like regular Solidity function calls).\n', '\n', '     *\n', '\n', '     * Returns the raw returned data. To convert to the expected return value,\n', '\n', '     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\n', '\n', '     *\n', '\n', '     * Requirements:\n', '\n', '     *\n', '\n', '     * - `target` must be a contract.\n', '\n', '     * - calling `target` with `data` must not revert.\n', '\n', '     *\n', '\n', '     * _Available since v3.1._\n', '\n', '     */\n', '\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '\n', '    }\n', '\n', '\n', '\n', '    /**\n', '\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\n', '\n', '     * `errorMessage` as a fallback revert reason when `target` reverts.\n', '\n', '     *\n', '\n', '     * _Available since v3.1._\n', '\n', '     */\n', '\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '\n', '        return _functionCallWithValue(target, data, 0, errorMessage);\n', '\n', '    }\n', '\n', '\n', '\n', '    /**\n', '\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '\n', '     * but also transferring `value` wei to `target`.\n', '\n', '     *\n', '\n', '     * Requirements:\n', '\n', '     *\n', '\n', '     * - the calling contract must have an ETH balance of at least `value`.\n', '\n', '     * - the called Solidity function must be `payable`.\n', '\n', '     *\n', '\n', '     * _Available since v3.1._\n', '\n', '     */\n', '\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '\n', '    }\n', '\n', '\n', '\n', '    /**\n', '\n', '     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\n', '\n', '     * with `errorMessage` as a fallback revert reason when `target` reverts.\n', '\n', '     *\n', '\n', '     * _Available since v3.1._\n', '\n', '     */\n', '\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '\n', '        return _functionCallWithValue(target, data, value, errorMessage);\n', '\n', '    }\n', '\n', '\n', '\n', '    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {\n', '\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '\n', '        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);\n', '\n', '        if (success) {\n', '\n', '            return returndata;\n', '\n', '        } else {\n', '\n', '            // Look for revert reason and bubble it up if present\n', '\n', '            if (returndata.length > 0) {\n', '\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '\n', '                assembly {\n', '\n', '                    let returndata_size := mload(returndata)\n', '\n', '                    revert(add(32, returndata), returndata_size)\n', '\n', '                }\n', '\n', '            } else {\n', '\n', '                revert(errorMessage);\n', '\n', '            }\n', '\n', '        }\n', '\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', 'contract Ownable is Context {\n', '\n', '    address private _owner;\n', '\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '\n', '    /**\n', '\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '\n', '     */\n', '\n', '    constructor () internal {\n', '\n', '        address msgSender = _msgSender();\n', '\n', '        _owner = msgSender;\n', '\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '\n', '    }\n', '\n', '\n', '\n', '    /**\n', '\n', '     * @dev Returns the address of the current owner.\n', '\n', '     */\n', '\n', '    function owner() public view returns (address) {\n', '\n', '        return _owner;\n', '\n', '    }\n', '\n', '\n', '\n', '    /**\n', '\n', '     * @dev Throws if called by any account other than the owner.\n', '\n', '     */\n', '\n', '    modifier onlyOwner() {\n', '\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '\n', '        _;\n', '\n', '    }\n', '\n', '\n', '\n', '    /**\n', '\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '\n', '     *\n', '\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '\n', '     * thereby removing any functionality that is only available to the owner.\n', '\n', '     */\n', '\n', '    function renounceOwnership() public virtual onlyOwner {\n', '\n', '        emit OwnershipTransferred(_owner, address(0));\n', '\n', '        _owner = address(0);\n', '\n', '    }\n', '\n', '\n', '\n', '    /**\n', '\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '\n', '     * Can only be called by the current owner.\n', '\n', '     */\n', '\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '\n', '        _owner = newOwner;\n', '\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract Firulais is Context, IERC20, Ownable {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    using Address for address;\n', '\n', '\n', '\n', '    mapping (address => uint256) private _rOwned;\n', '\n', '    mapping (address => uint256) private _tOwned;\n', '\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '\n', '\n', '\n', '    mapping (address => bool) private _isExcluded;\n', '\n', '    address[] private _excluded;\n', '\n', '   \n', '\n', '    uint256 private constant MAX = ~uint256(0);\n', '\n', '    uint256 private constant _tTotal = 100000000000 * 10**6 * 10**9;\n', '\n', '    uint256 private _rTotal = (MAX - (MAX % _tTotal));\n', '\n', '    uint256 private _tFeeTotal;\n', '\n', '\n', '\n', "    string private _name = 'Firulais';\n", '\n', "    string private _symbol = 'FIRU';\n", '\n', '    uint8 private _decimals = 9;\n', '\n', '\n', '\n', '    constructor () public {\n', '\n', '        _rOwned[_msgSender()] = _rTotal;\n', '\n', '        emit Transfer(address(0), _msgSender(), _tTotal);\n', '\n', '    }\n', '\n', '\n', '\n', '    function name() public view returns (string memory) {\n', '\n', '        return _name;\n', '\n', '    }\n', '\n', '\n', '\n', '    function symbol() public view returns (string memory) {\n', '\n', '        return _symbol;\n', '\n', '    }\n', '\n', '\n', '\n', '    function decimals() public view returns (uint8) {\n', '\n', '        return _decimals;\n', '\n', '    }\n', '\n', '\n', '\n', '    function totalSupply() public view override returns (uint256) {\n', '\n', '        return _tTotal;\n', '\n', '    }\n', '\n', '\n', '\n', '    function balanceOf(address account) public view override returns (uint256) {\n', '\n', '        if (_isExcluded[account]) return _tOwned[account];\n', '\n', '        return tokenFromReflection(_rOwned[account]);\n', '\n', '    }\n', '\n', '\n', '\n', '    function transfer(address recipient, uint256 amount) public override returns (bool) {\n', '\n', '        _transfer(_msgSender(), recipient, amount);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    function allowance(address owner, address spender) public view override returns (uint256) {\n', '\n', '        return _allowances[owner][spender];\n', '\n', '    }\n', '\n', '\n', '\n', '    function approve(address spender, uint256 amount) public override returns (bool) {\n', '\n', '        _approve(_msgSender(), spender, amount);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {\n', '\n', '        _transfer(sender, recipient, amount);\n', '\n', '        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n', '\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n', '\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    function isExcluded(address account) public view returns (bool) {\n', '\n', '        return _isExcluded[account];\n', '\n', '    }\n', '\n', '\n', '\n', '    function totalFees() public view returns (uint256) {\n', '\n', '        return _tFeeTotal;\n', '\n', '    }\n', '\n', '\n', '\n', '    function reflect(uint256 tAmount) public {\n', '\n', '        address sender = _msgSender();\n', '\n', '        require(!_isExcluded[sender], "Excluded addresses cannot call this function");\n', '\n', '        (uint256 rAmount,,,,) = _getValues(tAmount);\n', '\n', '        _rOwned[sender] = _rOwned[sender].sub(rAmount);\n', '\n', '        _rTotal = _rTotal.sub(rAmount);\n', '\n', '        _tFeeTotal = _tFeeTotal.add(tAmount);\n', '\n', '    }\n', '\n', '\n', '\n', '    function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {\n', '\n', '        require(tAmount <= _tTotal, "Amount must be less than supply");\n', '\n', '        if (!deductTransferFee) {\n', '\n', '            (uint256 rAmount,,,,) = _getValues(tAmount);\n', '\n', '            return rAmount;\n', '\n', '        } else {\n', '\n', '            (,uint256 rTransferAmount,,,) = _getValues(tAmount);\n', '\n', '            return rTransferAmount;\n', '\n', '        }\n', '\n', '    }\n', '\n', '\n', '\n', '    function tokenFromReflection(uint256 rAmount) public view returns(uint256) {\n', '\n', '        require(rAmount <= _rTotal, "Amount must be less than total reflections");\n', '\n', '        uint256 currentRate =  _getRate();\n', '\n', '        return rAmount.div(currentRate);\n', '\n', '    }\n', '\n', '\n', '\n', '    function excludeAccount(address account) external onlyOwner() {\n', '\n', '        require(!_isExcluded[account], "Account is already excluded");\n', '\n', '        if(_rOwned[account] > 0) {\n', '\n', '            _tOwned[account] = tokenFromReflection(_rOwned[account]);\n', '\n', '        }\n', '\n', '        _isExcluded[account] = true;\n', '\n', '        _excluded.push(account);\n', '\n', '    }\n', '\n', '\n', '\n', '    function includeAccount(address account) external onlyOwner() {\n', '\n', '        require(_isExcluded[account], "Account is already excluded");\n', '\n', '        for (uint256 i = 0; i < _excluded.length; i++) {\n', '\n', '            if (_excluded[i] == account) {\n', '\n', '                _excluded[i] = _excluded[_excluded.length - 1];\n', '\n', '                _tOwned[account] = 0;\n', '\n', '                _isExcluded[account] = false;\n', '\n', '                _excluded.pop();\n', '\n', '                break;\n', '\n', '            }\n', '\n', '        }\n', '\n', '    }\n', '\n', '\n', '\n', '    function _approve(address owner, address spender, uint256 amount) private {\n', '\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '\n', '\n', '        _allowances[owner][spender] = amount;\n', '\n', '        emit Approval(owner, spender, amount);\n', '\n', '    }\n', '\n', '\n', '\n', '    function _transfer(address sender, address recipient, uint256 amount) private {\n', '\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        require(amount > 0, "Transfer amount must be greater than zero");\n', '\n', '        if (_isExcluded[sender] && !_isExcluded[recipient]) {\n', '\n', '            _transferFromExcluded(sender, recipient, amount);\n', '\n', '        } else if (!_isExcluded[sender] && _isExcluded[recipient]) {\n', '\n', '            _transferToExcluded(sender, recipient, amount);\n', '\n', '        } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {\n', '\n', '            _transferStandard(sender, recipient, amount);\n', '\n', '        } else if (_isExcluded[sender] && _isExcluded[recipient]) {\n', '\n', '            _transferBothExcluded(sender, recipient, amount);\n', '\n', '        } else {\n', '\n', '            _transferStandard(sender, recipient, amount);\n', '\n', '        }\n', '\n', '    }\n', '\n', '\n', '\n', '    function _transferStandard(address sender, address recipient, uint256 tAmount) private {\n', '\n', '        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);\n', '\n', '        _rOwned[sender] = _rOwned[sender].sub(rAmount);\n', '\n', '        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       \n', '\n', '        _reflectFee(rFee, tFee);\n', '\n', '        emit Transfer(sender, recipient, tTransferAmount);\n', '\n', '    }\n', '\n', '\n', '\n', '    function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {\n', '\n', '        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);\n', '\n', '        _rOwned[sender] = _rOwned[sender].sub(rAmount);\n', '\n', '        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);\n', '\n', '        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           \n', '\n', '        _reflectFee(rFee, tFee);\n', '\n', '        emit Transfer(sender, recipient, tTransferAmount);\n', '\n', '    }\n', '\n', '\n', '\n', '    function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {\n', '\n', '        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);\n', '\n', '        _tOwned[sender] = _tOwned[sender].sub(tAmount);\n', '\n', '        _rOwned[sender] = _rOwned[sender].sub(rAmount);\n', '\n', '        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   \n', '\n', '        _reflectFee(rFee, tFee);\n', '\n', '        emit Transfer(sender, recipient, tTransferAmount);\n', '\n', '    }\n', '\n', '\n', '\n', '    function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {\n', '\n', '        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);\n', '\n', '        _tOwned[sender] = _tOwned[sender].sub(tAmount);\n', '\n', '        _rOwned[sender] = _rOwned[sender].sub(rAmount);\n', '\n', '        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);\n', '\n', '        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        \n', '\n', '        _reflectFee(rFee, tFee);\n', '\n', '        emit Transfer(sender, recipient, tTransferAmount);\n', '\n', '    }\n', '\n', '\n', '\n', '    function _reflectFee(uint256 rFee, uint256 tFee) private {\n', '\n', '        _rTotal = _rTotal.sub(rFee);\n', '\n', '        _tFeeTotal = _tFeeTotal.add(tFee);\n', '\n', '    }\n', '\n', '\n', '\n', '    function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {\n', '\n', '        (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);\n', '\n', '        uint256 currentRate =  _getRate();\n', '\n', '        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);\n', '\n', '        return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);\n', '\n', '    }\n', '\n', '\n', '\n', '    function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {\n', '\n', '        uint256 tFee = tAmount.div(100).mul(2);\n', '\n', '        uint256 tTransferAmount = tAmount.sub(tFee);\n', '\n', '        return (tTransferAmount, tFee);\n', '\n', '    }\n', '\n', '\n', '\n', '    function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {\n', '\n', '        uint256 rAmount = tAmount.mul(currentRate);\n', '\n', '        uint256 rFee = tFee.mul(currentRate);\n', '\n', '        uint256 rTransferAmount = rAmount.sub(rFee);\n', '\n', '        return (rAmount, rTransferAmount, rFee);\n', '\n', '    }\n', '\n', '\n', '\n', '    function _getRate() private view returns(uint256) {\n', '\n', '        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();\n', '\n', '        return rSupply.div(tSupply);\n', '\n', '    }\n', '\n', '\n', '\n', '    function _getCurrentSupply() private view returns(uint256, uint256) {\n', '\n', '        uint256 rSupply = _rTotal;\n', '\n', '        uint256 tSupply = _tTotal;      \n', '\n', '        for (uint256 i = 0; i < _excluded.length; i++) {\n', '\n', '            if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);\n', '\n', '            rSupply = rSupply.sub(_rOwned[_excluded[i]]);\n', '\n', '            tSupply = tSupply.sub(_tOwned[_excluded[i]]);\n', '\n', '        }\n', '\n', '        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);\n', '\n', '        return (rSupply, tSupply);\n', '\n', '    }\n', '\n', '}']