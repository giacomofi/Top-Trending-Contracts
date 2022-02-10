['// SPDX-License-Identifier: MIT\n', '/*                 | |                            | |      \n', '**   __ _ _ __   __| |_ __ ___  _ __ ___   ___  __| | __ _ \n', "**  / _` | '_ \\ / _` | '__/ _ \\| '_ ` _ \\ / _ \\/ _` |/ _` |\n", '** | (_| | | | | (_| | | | (_) | | | | | |  __/ (_| | (_| |\n', '**  \\__,_|_| |_|\\__,_|_|  \\___/|_| |_| |_|\\___|\\__,_|\\__,_|\n', '*/\n', 'pragma solidity ^0.6.12;\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract Andromeda is Ownable {\n', '    \n', '    using SafeMath for uint;\n', '    \n', '    address payable public top = 0x036908228b1c3Ab35C48212398B9d469A8D6F886;\n', '    address[] empty;\n', '    struct User {\n', '        address payable inviter;\n', '        address payable self;\n', '        address[] myReferred;\n', '    }\n', '    mapping(address => User) public tree;\n', '\n', '    constructor() public {\n', '        tree[top] = User(top, top, empty);\n', '    }\n', '\n', '    function enter(address payable inviter) external payable {\n', '        require(msg.value == 0.25 ether, "Debes enviar 0.25 ETH");\n', '        require(tree[msg.sender].inviter == address(0), "No puedes registrarte más de una vez con el mismo patrocinador");\n', '        require(tree[inviter].self == inviter, "Ese patrocinador no existe");\n', '        require(tree[inviter].myReferred.length < 90, "Tu patrocinador ya alcanzó su máximo de invitados");\n', '        \n', '        tree[msg.sender] = User(inviter, msg.sender, empty);\n', '        tree[inviter].myReferred.push(msg.sender);\n', '        \n', '        if (\n', '            tree[inviter].myReferred.length == 3 || \n', '            tree[inviter].myReferred.length == 6 ||\n', '            tree[inviter].myReferred.length == 9 ||\n', '            tree[inviter].myReferred.length == 10 ||\n', '            tree[inviter].myReferred.length == 12 ||\n', '            tree[inviter].myReferred.length == 15 ||\n', '            tree[inviter].myReferred.length == 18 ||\n', '            tree[inviter].myReferred.length == 19 ||\n', '            tree[inviter].myReferred.length == 21 ||\n', '            tree[inviter].myReferred.length == 24 || \n', '            tree[inviter].myReferred.length == 27 ||\n', '            tree[inviter].myReferred.length == 28 ||\n', '            tree[inviter].myReferred.length == 30 ||\n', '            tree[inviter].myReferred.length == 33 ||\n', '            tree[inviter].myReferred.length == 36 ||\n', '            tree[inviter].myReferred.length == 37 ||\n', '            tree[inviter].myReferred.length == 39 ||\n', '            tree[inviter].myReferred.length == 42 ||\n', '            tree[inviter].myReferred.length == 45 ||\n', '            tree[inviter].myReferred.length == 46 ||\n', '            tree[inviter].myReferred.length == 48 ||\n', '            tree[inviter].myReferred.length == 51 ||\n', '            tree[inviter].myReferred.length == 54 ||\n', '            tree[inviter].myReferred.length == 55 ||\n', '            tree[inviter].myReferred.length == 57 ||\n', '            tree[inviter].myReferred.length == 60 ||\n', '            tree[inviter].myReferred.length == 63 ||\n', '            tree[inviter].myReferred.length == 64 ||\n', '            tree[inviter].myReferred.length == 66 ||\n', '            tree[inviter].myReferred.length == 69 ||\n', '            tree[inviter].myReferred.length == 72 ||\n', '            tree[inviter].myReferred.length == 73 ||\n', '            tree[inviter].myReferred.length == 75 ||\n', '            tree[inviter].myReferred.length == 78 ||\n', '            tree[inviter].myReferred.length == 81 ||\n', '            tree[inviter].myReferred.length == 82 ||\n', '            tree[inviter].myReferred.length == 84 ||\n', '            tree[inviter].myReferred.length == 87 ||\n', '            tree[inviter].myReferred.length == 90 \n', '            ) {\n', '                inviter.transfer (0.125 ether);\n', '                top.transfer (0.125 ether); \n', '        } else {\n', '                inviter.transfer (0.175 ether);\n', '                top.transfer (0.075 ether); \n', '        }\n', '    }\n', '    \n', '    function ReferredNumber(address consultado) external view returns(uint) {\n', '        return tree[consultado].myReferred.length;\n', '    }\n', '    function ReferredList(address consultado) external view returns(address[] memory) {\n', '        return tree[consultado].myReferred;\n', '    }\n', '    \n', '    function send() public onlyOwner payable {\n', '        top.transfer(address(this).balance);\n', '    }  \n', '}']