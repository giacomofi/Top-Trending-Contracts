['// SPDX-License-Identifier: MIT\n', '\n', '/**\n', ' * @title Liquidity Contract\n', ' * @author: Muhammad Zaryab Khan\n', ' * Developed By: BLOCK360\n', ' * Date: Septemeber 17, 2020\n', ' * Version: 1.0.0\n', ' */\n', '\n', 'pragma solidity 0.6.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal virtual view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal virtual view returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(\n', '        address indexed previousOwner,\n', '        address indexed newOwner\n', '    );\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor() internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(\n', '            newOwner != address(0),\n', '            "Ownable: new owner is the zero address"\n', '        );\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'interface TokenInterface {\n', '    function symbol() external view returns (string memory);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    function transfer(address recipient, uint256 amount)\n', '        external\n', '        returns (bool);\n', '}\n', '\n', 'interface DexInterface {\n', '    function collectedFee(string calldata currency)\n', '        external\n', '        view\n', '        returns (uint256);\n', '}\n', '\n', 'contract Liquidity is Ownable {\n', '    using SafeMath for uint256;\n', '    string public version = "1.0.0";\n', '    address public DEX;\n', '    string[] public allLiquidities;\n', '    mapping(string => address) public contractAddress;\n', '\n', '    event DEXUpdated(address oldDEX, address newDEX);\n', '    event TokenUpdated(string symbol, address newContract);\n', '    event PaymentReceived(address from, uint256 amount);\n', '    event LiquidityWithdraw(\n', '        string symbol,\n', '        address indexed to,\n', '        uint256 amount,\n', '        uint256 timestamp\n', '    );\n', '    event LiquidityTransfer(\n', '        string symbol,\n', '        address indexed to,\n', '        uint256 amount,\n', '        uint256 timestamp\n', '    );\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the DEX.\n', '     */\n', '    modifier onlyDEX() {\n', '        require(DEX == _msgSender(), "Liquidity: caller is not DEX");\n', '        _;\n', '    }\n', '\n', '    constructor(\n', '        address owner,\n', '        address gsu,\n', '        address usdt\n', '    ) public {\n', '        require(owner != address(0x0), "[Liquidity], owner is zero address");\n', '        require(gsu != address(0x0), "[Liquidity], gsu is zero address");\n', '        require(usdt != address(0x0), "[Liquidity], usdt is zero address");\n', '\n', '        allLiquidities.push("ETH");\n', '\n', '        newLiquidity(gsu);\n', '        newLiquidity(usdt);\n', '        transferOwnership(owner);\n', '    }\n', '\n', '    fallback() external payable {\n', '        emit PaymentReceived(_msgSender(), msg.value);\n', '    }\n', '\n', '    receive() external payable {\n', '        emit PaymentReceived(_msgSender(), msg.value);\n', '    }\n', '\n', '    function withdraw(string calldata symbol, uint256 amount)\n', '        external\n', '        onlyOwner\n', '    {\n', '        require(amount > 0, "[Liquidity] amount is zero");\n', '        require(\n', '            balanceOf(symbol).sub(amount) >=\n', '                DexInterface(DEX).collectedFee(symbol),\n', '            "[Liquidity] amount exceeds available funds"\n', '        );\n', '\n', '        if (isERC20Token(symbol))\n', '            TokenInterface(contractAddress[symbol]).transfer(owner(), amount);\n', '        else address(uint160(owner())).transfer(amount);\n', '\n', '        emit LiquidityWithdraw(symbol, owner(), amount, block.timestamp);\n', '    }\n', '\n', '    function transfer(\n', '        string calldata symbol,\n', '        address payable recipient,\n', '        uint256 amount\n', '    ) external onlyDEX returns (bool) {\n', '        if (isERC20Token(symbol))\n', '            TokenInterface(contractAddress[symbol]).transfer(recipient, amount);\n', '        else recipient.transfer(amount);\n', '\n', '        emit LiquidityTransfer(symbol, recipient, amount, block.timestamp);\n', '\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(string memory symbol) public view returns (uint256) {\n', '        if (isERC20Token(symbol))\n', '            return\n', '                TokenInterface(contractAddress[symbol]).balanceOf(\n', '                    address(this)\n', '                );\n', '        else return address(this).balance;\n', '    }\n', '\n', '    function isERC20Token(string memory symbol) public view returns (bool) {\n', '        return contractAddress[symbol] != address(0x0);\n', '    }\n', '\n', '    function setDex(address newDEX) external onlyOwner returns (bool) {\n', '        emit DEXUpdated(DEX, newDEX);\n', '        DEX = newDEX;\n', '        return true;\n', '    }\n', '\n', '    function newLiquidity(address _contract) private onlyOwner returns (bool) {\n', '        string memory symbol = TokenInterface(_contract).symbol();\n', '        allLiquidities.push(symbol);\n', '        contractAddress[symbol] = _contract;\n', '        return true;\n', '    }\n', '\n', '    function setTokenContract(string calldata symbol, address newContract)\n', '        external\n', '        onlyOwner\n', '        returns (bool)\n', '    {\n', '        require(isERC20Token(symbol));\n', '        contractAddress[symbol] = newContract;\n', '        emit TokenUpdated(symbol, newContract);\n', '        return true;\n', '    }\n', '\n', '    function totalLiquidities() external view returns (uint256) {\n', '        return allLiquidities.length;\n', '    }\n', '\n', '    function destroy() external onlyOwner {\n', '        // index 0 is ethereum\n', '        for (uint8 a = 1; a < allLiquidities.length; a++) {\n', '            string memory currency = allLiquidities[a];\n', '            TokenInterface(contractAddress[currency]).transfer(\n', '                owner(),\n', '                balanceOf(currency)\n', '            );\n', '        }\n', '\n', '        selfdestruct(payable(owner()));\n', '    }\n', '}']