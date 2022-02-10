['// SPDX-License-Identifier: MIT\n', 'pragma solidity >=0.4.22 <0.8.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'interface IRebaseToken is IERC20 {\n', '    function rebase(\n', '        uint256 epoch,\n', '        uint256 numerator,\n', '        uint256 denominator\n', '    ) external returns (uint256);\n', '}\n', '\n', 'interface IUniswapV2Pair {\n', '    function sync() external;\n', '}\n', '\n', 'contract UniPriceRebaseInvoker is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    uint256 private _epoch;\n', '    uint256 private _startTime;\n', '    uint256 private _interval;\n', '\n', '    uint256 private _targetPrice;\n', '    uint256 private _minPrice;\n', '    uint256 private _maxPrice;\n', '\n', '    IRebaseToken private _token;\n', '    IERC20 private _usdt;\n', '    IERC20 private _eth;\n', '\n', '    IUniswapV2Pair private _tokenUsdtPair;\n', '    IUniswapV2Pair private _tokenEthPair;\n', '    IUniswapV2Pair private _ethUsdtPair;\n', '\n', '    modifier onlyCanRebase() {\n', '        uint256 epoch = currentEpoch();\n', '        require(epoch > _epoch, "Rebase: current epoch is rebased");\n', '        if (owner() != address(0x0)) {\n', '            require(owner() == _msgSender(), "Rebase: caller is not the owner");\n', '        }\n', '        _;\n', '    }\n', '\n', '    constructor() public {\n', '        _startTime = 1599004800;\n', '        _interval = 86400;\n', '\n', '        _targetPrice = 10**6;\n', '        _minPrice = 96 * 10**4;\n', '        _maxPrice = 106 * 10**4;\n', '\n', '        _token = IRebaseToken(\n', '            address(0x95DA1E3eECaE3771ACb05C145A131Dca45C67FD4)\n', '        );\n', '        _usdt = IERC20(address(0xdAC17F958D2ee523a2206206994597C13D831ec7));\n', '        _eth = IERC20(address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2));\n', '\n', '        _tokenUsdtPair = IUniswapV2Pair(\n', '            address(0xFBC57CE413631dd910457f4476AFAC4D8590dA00)\n', '        );\n', '\n', '        _tokenEthPair = IUniswapV2Pair(\n', '            address(0x0d4a11d5EEaaC28EC3F61d100daF4d40471f1852)\n', '        );\n', '\n', '        _ethUsdtPair = IUniswapV2Pair(\n', '            address(0xFBC57CE413631dd910457f4476AFAC4D8590dA00)\n', '        );\n', '    }\n', '\n', '    function epoch() public view returns (uint256) {\n', '        return _epoch;\n', '    }\n', '\n', '    function startTime() public view returns (uint256) {\n', '        return _startTime;\n', '    }\n', '\n', '    function interval() public view returns (uint256) {\n', '        return _interval;\n', '    }\n', '\n', '    function targetPrice() public view returns (uint256) {\n', '        return _targetPrice;\n', '    }\n', '\n', '    function minPrice() public view returns (uint256) {\n', '        return _minPrice;\n', '    }\n', '\n', '    function maxPrice() public view returns (uint256) {\n', '        return _maxPrice;\n', '    }\n', '\n', '    function token() public view returns (IRebaseToken) {\n', '        return _token;\n', '    }\n', '\n', '    function usdt() public view returns (IERC20) {\n', '        return _usdt;\n', '    }\n', '\n', '    function eth() public view returns (IERC20) {\n', '        return _eth;\n', '    }\n', '\n', '    function tokenUsdtPair() public view returns (IUniswapV2Pair) {\n', '        return _tokenUsdtPair;\n', '    }\n', '\n', '    function tokenEthPair() public view returns (IUniswapV2Pair) {\n', '        return _tokenEthPair;\n', '    }\n', '\n', '    function ethUsdtPair() public view returns (IUniswapV2Pair) {\n', '        return _ethUsdtPair;\n', '    }\n', '\n', '    function currentEpoch() public view returns (uint256) {\n', '        return now.sub(_startTime).div(_interval);\n', '    }\n', '\n', '    function ethToUsdt(uint256 amount) public view returns (uint256) {\n', '        uint256 usdtAmount = _usdt.balanceOf(address(_ethUsdtPair));\n', '        uint256 ethAmount = _eth.balanceOf(address(_ethUsdtPair));\n', '        return amount.mul(usdtAmount).mul(10**12).div(ethAmount);\n', '    }\n', '\n', '    function getPrice() public view returns (uint256) {\n', '        uint256 usdtAmount = _usdt.balanceOf(address(_tokenUsdtPair));\n', '        uint256 tokenAmount = _token.balanceOf(address(_tokenUsdtPair));\n', '\n', '        usdtAmount = usdtAmount.add(\n', '            ethToUsdt(_eth.balanceOf(address(_tokenEthPair)))\n', '        );\n', '        tokenAmount = tokenAmount.add(_token.balanceOf(address(_tokenEthPair)));\n', '        return usdtAmount.mul(10**12).mul(_targetPrice).div(tokenAmount);\n', '    }\n', '\n', '    function _rebase(uint256 rebaseEepoch) private {\n', '        uint256 price = getPrice();\n', '        if (price >= _minPrice && price <= _maxPrice) {\n', '            return;\n', '        }\n', '        uint256 denumerator = _targetPrice;\n', '        if (price > _targetPrice) {\n', '            denumerator = _targetPrice.add(\n', '                price.sub(_targetPrice).mul(10).div(100)\n', '            );\n', '        } else {\n', '            denumerator = _targetPrice.sub(\n', '                _targetPrice.sub(price).mul(10).div(100)\n', '            );\n', '        }\n', '        _token.rebase(rebaseEepoch, _targetPrice, denumerator);\n', '        _tokenUsdtPair.sync();\n', '        _tokenEthPair.sync();\n', '    }\n', '\n', '    function rebase() external onlyCanRebase {\n', '        uint256 rebaseEepoch = currentEpoch();\n', '        _rebase(rebaseEepoch);\n', '        _epoch = rebaseEepoch;\n', '    }\n', '}']