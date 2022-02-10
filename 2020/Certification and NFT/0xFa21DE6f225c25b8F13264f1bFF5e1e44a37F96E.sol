['// File: @openzeppelin/contracts/math/Math.sol\n', '\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @dev Standard math utilities missing in the Solidity language.\n', ' */\n', 'library Math {\n', '    /**\n', '     * @dev Returns the largest of two numbers.\n', '     */\n', '    function max(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the smallest of two numbers.\n', '     */\n', '    function min(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the average of two numbers. The result is rounded towards\n', '     * zero.\n', '     */\n', '    function average(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // (a + b) / 2 can overflow, so we distribute\n', '        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/token/ERC20/IERC20.sol\n', '\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: contracts/interfaces/IVat.sol\n', '\n', 'pragma solidity ^0.6.10;\n', '\n', '\n', '/// @dev Interface to interact with the vat contract from MakerDAO\n', '/// Taken from https://github.com/makerdao/developerguides/blob/master/devtools/working-with-dsproxy/working-with-dsproxy.md\n', 'interface IVat {\n', '    // function can(address, address) external view returns (uint);\n', '    function hope(address) external;\n', '    function nope(address) external;\n', '    function live() external view returns (uint);\n', '    function ilks(bytes32) external view returns (uint, uint, uint, uint, uint);\n', '    function urns(bytes32, address) external view returns (uint, uint);\n', '    function gem(bytes32, address) external view returns (uint);\n', '    // function dai(address) external view returns (uint);\n', '    function frob(bytes32, address, address, address, int, int) external;\n', '    function fork(bytes32, address, address, int, int) external;\n', '    function move(address, address, uint) external;\n', '    function flux(bytes32, address, address, uint) external;\n', '}\n', '\n', '// File: contracts/interfaces/IDaiJoin.sol\n', '\n', 'pragma solidity ^0.6.10;\n', '\n', '\n', '/// @dev Interface to interact with the `Join.sol` contract from MakerDAO using Dai\n', 'interface IDaiJoin {\n', '    function rely(address usr) external;\n', '    function deny(address usr) external;\n', '    function cage() external;\n', '    function join(address usr, uint WAD) external;\n', '    function exit(address usr, uint WAD) external;\n', '}\n', '\n', '// File: contracts/interfaces/IGemJoin.sol\n', '\n', 'pragma solidity ^0.6.10;\n', '\n', '\n', '/// @dev Interface to interact with the `Join.sol` contract from MakerDAO using ERC20\n', 'interface IGemJoin {\n', '    function rely(address usr) external;\n', '    function deny(address usr) external;\n', '    function cage() external;\n', '    function join(address usr, uint WAD) external;\n', '    function exit(address usr, uint WAD) external;\n', '}\n', '\n', '// File: contracts/interfaces/IPot.sol\n', '\n', 'pragma solidity ^0.6.10;\n', '\n', '\n', '/// @dev interface for the pot contract from MakerDao\n', '/// Taken from https://github.com/makerdao/developerguides/blob/master/dai/dsr-integration-guide/dsr.sol\n', 'interface IPot {\n', '    function chi() external view returns (uint256);\n', '    function pie(address) external view returns (uint256); // Not a function, but a public variable.\n', '    function rho() external returns (uint256);\n', '    function drip() external returns (uint256);\n', '    function join(uint256) external;\n', '    function exit(uint256) external;\n', '}\n', '\n', '// File: contracts/interfaces/IChai.sol\n', '\n', 'pragma solidity ^0.6.10;\n', '\n', '\n', '/// @dev interface for the chai contract\n', '/// Taken from https://github.com/makerdao/developerguides/blob/master/dai/dsr-integration-guide/dsr.sol\n', 'interface IChai {\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address dst, uint wad) external returns (bool);\n', '    function move(address src, address dst, uint wad) external returns (bool);\n', '    function transferFrom(address src, address dst, uint wad) external returns (bool);\n', '    function approve(address usr, uint wad) external returns (bool);\n', '    function dai(address usr) external returns (uint wad);\n', '    function join(address dst, uint wad) external;\n', '    function exit(address src, uint wad) external;\n', '    function draw(address src, uint wad) external;\n', '    function permit(address holder, address spender, uint256 nonce, uint256 expiry, bool allowed, uint8 v, bytes32 r, bytes32 s) external;\n', '    function nonces(address account) external view returns (uint256);\n', '}\n', '\n', '// File: contracts/interfaces/IWeth.sol\n', '\n', 'pragma solidity ^0.6.10;\n', '\n', '\n', 'interface IWeth {\n', '    function deposit() external payable;\n', '    function withdraw(uint) external;\n', '    function approve(address, uint) external returns (bool) ;\n', '    function transfer(address, uint) external returns (bool);\n', '    function transferFrom(address, address, uint) external returns (bool);\n', '}\n', '\n', '// File: contracts/interfaces/ITreasury.sol\n', '\n', 'pragma solidity ^0.6.10;\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', 'interface ITreasury {\n', '    function debt() external view returns(uint256);\n', '    function savings() external view returns(uint256);\n', '    function pushDai(address user, uint256 dai) external;\n', '    function pullDai(address user, uint256 dai) external;\n', '    function pushChai(address user, uint256 chai) external;\n', '    function pullChai(address user, uint256 chai) external;\n', '    function pushWeth(address to, uint256 weth) external;\n', '    function pullWeth(address to, uint256 weth) external;\n', '    function shutdown() external;\n', '    function live() external view returns(bool);\n', '\n', '    function vat() external view returns (IVat);\n', '    function weth() external view returns (IWeth);\n', '    function dai() external view returns (IERC20);\n', '    function daiJoin() external view returns (IDaiJoin);\n', '    function wethJoin() external view returns (IGemJoin);\n', '    function pot() external view returns (IPot);\n', '    function chai() external view returns (IChai);\n', '}\n', '\n', '// File: @openzeppelin/contracts/math/SafeMath.sol\n', '\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: contracts/helpers/DecimalMath.sol\n', '\n', 'pragma solidity ^0.6.10;\n', '\n', '\n', '\n', '/// @dev Implements simple fixed point math mul and div operations for 27 decimals.\n', 'contract DecimalMath {\n', '    using SafeMath for uint256;\n', '\n', '    uint256 constant public UNIT = 1e27;\n', '\n', '    /// @dev Multiplies x and y, assuming they are both fixed point with 27 digits.\n', '    function muld(uint256 x, uint256 y) internal pure returns (uint256) {\n', '        return x.mul(y).div(UNIT);\n', '    }\n', '\n', '    /// @dev Divides x between y, assuming they are both fixed point with 27 digits.\n', '    function divd(uint256 x, uint256 y) internal pure returns (uint256) {\n', '        return x.mul(UNIT).div(y);\n', '    }\n', '\n', '    /// @dev Multiplies x and y, rounding up to the closest representable number.\n', '    /// Assumes x and y are both fixed point with `decimals` digits.\n', '    function muldrup(uint256 x, uint256 y) internal pure returns (uint256)\n', '    {\n', '        uint256 z = x.mul(y);\n', '        return z.mod(UNIT) == 0 ? z.div(UNIT) : z.div(UNIT).add(1);\n', '    }\n', '\n', '    /// @dev Divides x between y, rounding up to the closest representable number.\n', '    /// Assumes x and y are both fixed point with `decimals` digits.\n', '    function divdrup(uint256 x, uint256 y) internal pure returns (uint256)\n', '    {\n', '        uint256 z = x.mul(UNIT);\n', '        return z.mod(y) == 0 ? z.div(y) : z.div(y).add(1);\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/GSN/Context.sol\n', '\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/access/Ownable.sol\n', '\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: contracts/helpers/Orchestrated.sol\n', '\n', 'pragma solidity ^0.6.10;\n', '\n', '\n', '\n', '/**\n', ' * @dev Orchestrated allows to define static access control between multiple contracts.\n', ' * This contract would be used as a parent contract of any contract that needs to restrict access to some methods,\n', ' * which would be marked with the `onlyOrchestrated` modifier.\n', ' * During deployment, the contract deployer (`owner`) can register any contracts that have privileged access by calling `orchestrate`.\n', ' * Once deployment is completed, `owner` should call `transferOwnership(address(0))` to avoid any more contracts ever gaining privileged access.\n', ' */\n', '\n', 'contract Orchestrated is Ownable {\n', '    event GrantedAccess(address access, bytes4 signature);\n', '\n', '    mapping(address => mapping (bytes4 => bool)) public orchestration;\n', '\n', '    constructor () public Ownable() {}\n', '\n', '    /// @dev Restrict usage to authorized users\n', '    /// @param err The error to display if the validation fails \n', '    modifier onlyOrchestrated(string memory err) {\n', '        require(orchestration[msg.sender][msg.sig], err);\n', '        _;\n', '    }\n', '\n', '    /// @dev Add orchestration\n', '    /// @param user Address of user or contract having access to this contract.\n', '    /// @param signature bytes4 signature of the function we are giving orchestrated access to.\n', '    /// It seems to me a bad idea to give access to humans, and would use this only for predictable smart contracts.\n', '    function orchestrate(address user, bytes4 signature) public onlyOwner {\n', '        orchestration[user][signature] = true;\n', '        emit GrantedAccess(user, signature);\n', '    }\n', '\n', '    /// @dev Adds orchestration for the provided function signatures\n', '    function batchOrchestrate(address user, bytes4[] memory signatures) public onlyOwner {\n', '        for (uint256 i = 0; i < signatures.length; i++) {\n', '            orchestrate(user, signatures[i]);\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/Treasury.sol\n', '\n', 'pragma solidity ^0.6.10;\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @dev Treasury manages asset transfers between all contracts in the Yield Protocol and other external contracts such as Chai and MakerDAO.\n', " * Treasury doesn't have any transactional functions available for regular users.\n", ' * All transactional methods are to be available only for orchestrated contracts.\n', ' * Treasury will ensure that all Weth is always stored as collateral in MAkerDAO.\n', ' * Treasury will use all Dai to pay off system debt in MakerDAO first, and if there is no system debt the surplus Dai will be wrapped as Chai.\n', " * Treasury will use any Chai it holds when requested to provide Dai. If there isn't enough Chai, it will borrow Dai from MakerDAO.\n", ' */\n', 'contract Treasury is ITreasury, Orchestrated(), DecimalMath {\n', '    bytes32 constant WETH = "ETH-A";\n', '\n', '    IVat public override vat;\n', '    IWeth public override weth;\n', '    IERC20 public override dai;\n', '    IDaiJoin public override daiJoin;\n', '    IGemJoin public override wethJoin;\n', '    IPot public override pot;\n', '    IChai public override chai;\n', '    address public unwind;\n', '\n', '    bool public override live = true;\n', '\n', '    /// @dev As part of the constructor:\n', '    /// Treasury allows the `chai` and `wethJoin` contracts to take as many tokens as wanted.\n', '    /// Treasury approves the `daiJoin` and `wethJoin` contracts to move assets in MakerDAO.\n', '    constructor (\n', '        address vat_,\n', '        address weth_,\n', '        address dai_,\n', '        address wethJoin_,\n', '        address daiJoin_,\n', '        address pot_,\n', '        address chai_\n', '    ) public {\n', '        // These could be hardcoded for mainnet deployment.\n', '        dai = IERC20(dai_);\n', '        chai = IChai(chai_);\n', '        pot = IPot(pot_);\n', '        weth = IWeth(weth_);\n', '        daiJoin = IDaiJoin(daiJoin_);\n', '        wethJoin = IGemJoin(wethJoin_);\n', '        vat = IVat(vat_);\n', '        vat.hope(wethJoin_);\n', '        vat.hope(daiJoin_);\n', '\n', '        dai.approve(address(chai), uint256(-1));      // Chai will never cheat on us\n', '        dai.approve(address(daiJoin), uint256(-1));   // DaiJoin will never cheat on us\n', '        weth.approve(address(wethJoin), uint256(-1)); // WethJoin will never cheat on us\n', '    }\n', '\n', '    /// @dev Only while the Treasury is not unwinding due to a MakerDAO shutdown.\n', '    modifier onlyLive() {\n', '        require(live == true, "Treasury: Not available during unwind");\n', '        _;\n', '    }\n', '\n', '    /// @dev Safe casting from uint256 to int256\n', '    function toInt(uint256 x) internal pure returns(int256) {\n', '        require(\n', '            x <= uint256(type(int256).max),\n', '            "Treasury: Cast overflow"\n', '        );\n', '        return int256(x);\n', '    }\n', '\n', '    /// @dev Disables pulling and pushing. Can only be called if MakerDAO shuts down.\n', '    function shutdown() public override {\n', '        require(\n', '            vat.live() == 0,\n', '            "Treasury: MakerDAO is live"\n', '        );\n', '        live = false;\n', '    }\n', '\n', '    /// @dev Returns the Treasury debt towards MakerDAO, in Dai.\n', '    /// We have borrowed (rate * art)\n', '    /// Borrowing limit (rate * art) <= (ink * spot)\n', '    function debt() public view override returns(uint256) {\n', '        (, uint256 rate,,,) = vat.ilks(WETH);            // Retrieve the MakerDAO stability fee for Weth\n', '        (, uint256 art) = vat.urns(WETH, address(this)); // Retrieve the Treasury debt in MakerDAO\n', '        return muld(art, rate);\n', '    }\n', '\n', '    /// @dev Returns the amount of chai in this contract, converted to Dai.\n', '    function savings() public view override returns(uint256){\n', '        return muld(chai.balanceOf(address(this)), pot.chi());\n', '    }\n', '\n', '    /// @dev Takes dai from user and pays as much system debt as possible, saving the rest as chai.\n', '    /// User needs to have approved Treasury to take the Dai.\n', '    /// This function can only be called by other Yield contracts, not users directly.\n', '    /// @param from Wallet to take Dai from.\n', '    /// @param daiAmount Dai quantity to take.\n', '    function pushDai(address from, uint256 daiAmount)\n', '        public override\n', '        onlyOrchestrated("Treasury: Not Authorized")\n', '        onlyLive\n', '    {\n', '        require(dai.transferFrom(from, address(this), daiAmount));  // Take dai from user to Treasury\n', '\n', '        // Due to the DSR being mostly lower than the SF, it is better for us to\n', '        // immediately pay back as much as possible from the current debt to\n', "        // minimize our future stability fee liabilities. If we didn't do this,\n", '        // the treasury would simultaneously owe DAI (and need to pay the SF) and\n', '        // hold Chai, which is inefficient.\n', '        uint256 toRepay = Math.min(debt(), daiAmount);\n', '        if (toRepay > 0) {\n', '            daiJoin.join(address(this), toRepay);\n', '            // Remove debt from vault using frob\n', '            (, uint256 rate,,,) = vat.ilks(WETH); // Retrieve the MakerDAO stability fee\n', '            vat.frob(\n', '                WETH,\n', '                address(this),\n', '                address(this),\n', '                address(this),\n', '                0,                           // Weth collateral to add\n', '                -toInt(divd(toRepay, rate))  // Dai debt to remove\n', '            );\n', '        }\n', '\n', "        uint256 toSave = daiAmount - toRepay;         // toRepay can't be greater than dai\n", '        if (toSave > 0) {\n', '            chai.join(address(this), toSave);    // Give dai to Chai, take chai back\n', '        }\n', '    }\n', '\n', '    /// @dev Takes Chai from user and pays as much system debt as possible, saving the rest as chai.\n', '    /// User needs to have approved Treasury to take the Chai.\n', '    /// This function can only be called by other Yield contracts, not users directly.\n', '    /// @param from Wallet to take Chai from.\n', '    /// @param chaiAmount Chai quantity to take.\n', '    function pushChai(address from, uint256 chaiAmount)\n', '        public override\n', '        onlyOrchestrated("Treasury: Not Authorized")\n', '        onlyLive\n', '    {\n', '        require(chai.transferFrom(from, address(this), chaiAmount));\n', '        uint256 daiAmount = chai.dai(address(this));\n', '\n', '        uint256 toRepay = Math.min(debt(), daiAmount);\n', '        if (toRepay > 0) {\n', '            chai.draw(address(this), toRepay);     // Grab dai from Chai, converted from chai\n', '            daiJoin.join(address(this), toRepay);\n', '            // Remove debt from vault using frob\n', '            (, uint256 rate,,,) = vat.ilks(WETH); // Retrieve the MakerDAO stability fee\n', '            vat.frob(\n', '                WETH,\n', '                address(this),\n', '                address(this),\n', '                address(this),\n', '                0,                           // Weth collateral to add\n', '                -toInt(divd(toRepay, rate))  // Dai debt to remove\n', '            );\n', '        }\n', '        // Anything that is left from repaying, is chai savings\n', '    }\n', '\n', '    /// @dev Takes Weth collateral from user into the Treasury Maker vault\n', '    /// User needs to have approved Treasury to take the Weth.\n', '    /// This function can only be called by other Yield contracts, not users directly.\n', '    /// @param from Wallet to take Weth from.\n', '    /// @param wethAmount Weth quantity to take.\n', '    function pushWeth(address from, uint256 wethAmount)\n', '        public override\n', '        onlyOrchestrated("Treasury: Not Authorized")\n', '        onlyLive\n', '    {\n', '        require(weth.transferFrom(from, address(this), wethAmount));\n', '\n', '        wethJoin.join(address(this), wethAmount); // GemJoin reverts if anything goes wrong.\n', '        // All added collateral should be locked into the vault using frob\n', '        vat.frob(\n', '            WETH,\n', '            address(this),\n', '            address(this),\n', '            address(this),\n', '            toInt(wethAmount), // Collateral to add - WAD\n', '            0 // Normalized Dai to receive - WAD\n', '        );\n', '    }\n', '\n', '    /// @dev Returns dai using chai savings as much as possible, and borrowing the rest.\n', '    /// This function can only be called by other Yield contracts, not users directly.\n', '    /// @param to Wallet to send Dai to.\n', '    /// @param daiAmount Dai quantity to send.\n', '    function pullDai(address to, uint256 daiAmount)\n', '        public override\n', '        onlyOrchestrated("Treasury: Not Authorized")\n', '        onlyLive\n', '    {\n', '        uint256 toRelease = Math.min(savings(), daiAmount);\n', '        if (toRelease > 0) {\n', '            chai.draw(address(this), toRelease);     // Grab dai from Chai, converted from chai\n', '        }\n', '\n', "        uint256 toBorrow = daiAmount - toRelease;    // toRelease can't be greater than dai\n", '        if (toBorrow > 0) {\n', '            (, uint256 rate,,,) = vat.ilks(WETH); // Retrieve the MakerDAO stability fee\n', '            // Increase the dai debt by the dai to receive divided by the stability fee\n', '            // `frob` deals with "normalized debt", instead of DAI.\n', '            // "normalized debt" is used to account for the fact that debt grows\n', '            // by the stability fee. The stability fee is accumulated by the "rate"\n', '            // variable, so if you store Dai balances in "normalized dai" you can\n', '            // deal with the stability fee accumulation with just a multiplication.\n', '            // This means that the `frob` call needs to be divided by the `rate`\n', '            // while the `GemJoin.exit` call can be done with the raw `toBorrow`\n', '            // number.\n', '            vat.frob(\n', '                WETH,\n', '                address(this),\n', '                address(this),\n', '                address(this),\n', '                0,\n', "                toInt(divdrup(toBorrow, rate))      // We need to round up, otherwise we won't exit toBorrow\n", '            );\n', '            daiJoin.exit(address(this), toBorrow); // `daiJoin` reverts on failures\n', '        }\n', '\n', '        require(dai.transfer(to, daiAmount));                            // Give dai to user\n', '    }\n', '\n', '    /// @dev Returns chai using chai savings as much as possible, and borrowing the rest.\n', '    /// This function can only be called by other Yield contracts, not users directly.\n', '    /// @param to Wallet to send Chai to.\n', '    /// @param chaiAmount Chai quantity to send.\n', '    function pullChai(address to, uint256 chaiAmount)\n', '        public override\n', '        onlyOrchestrated("Treasury: Not Authorized")\n', '        onlyLive\n', '    {\n', '        uint256 chi = pot.chi();\n', "        uint256 daiAmount = muldrup(chaiAmount, chi);   // dai = price * chai, we round up, otherwise we won't borrow enough dai\n", '        uint256 toRelease = Math.min(savings(), daiAmount);\n', '        // As much chai as the Treasury has, can be used, we borrow dai and convert it to chai for the rest\n', '\n', "        uint256 toBorrow = daiAmount - toRelease;    // toRelease can't be greater than daiAmount\n", '        if (toBorrow > 0) {\n', '            (, uint256 rate,,,) = vat.ilks(WETH); // Retrieve the MakerDAO stability fee\n', '            // Increase the dai debt by the dai to receive divided by the stability fee\n', '            vat.frob(\n', '                WETH,\n', '                address(this),\n', '                address(this),\n', '                address(this),\n', '                0,\n', "                toInt(divdrup(toBorrow, rate))       // We need to round up, otherwise we won't exit toBorrow\n", '            ); // `vat.frob` reverts on failure\n', '            daiJoin.exit(address(this), toBorrow);  // `daiJoin` reverts on failures\n', '            chai.join(address(this), toBorrow);     // Grab chai from Chai, converted from dai\n', '        }\n', '\n', '        require(chai.transfer(to, chaiAmount));                            // Give dai to user\n', '    }\n', '\n', '    /// @dev Moves Weth collateral from Treasury controlled Maker Eth vault to `to` address.\n', '    /// This function can only be called by other Yield contracts, not users directly.\n', '    /// @param to Wallet to send Weth to.\n', '    /// @param wethAmount Weth quantity to send.\n', '    function pullWeth(address to, uint256 wethAmount)\n', '        public override\n', '        onlyOrchestrated("Treasury: Not Authorized")\n', '        onlyLive\n', '    {\n', '        // Remove collateral from vault using frob\n', '        vat.frob(\n', '            WETH,\n', '            address(this),\n', '            address(this),\n', '            address(this),\n', '            -toInt(wethAmount), // Weth collateral to remove - WAD\n', '            0              // Dai debt to add - WAD\n', '        );\n', '        wethJoin.exit(to, wethAmount); // `GemJoin` reverts on failures\n', '    }\n', '\n', '    /// @dev Registers the one contract that will take assets from the Treasury if MakerDAO shuts down.\n', '    /// This function can only be called by the contract owner, which should only be possible during deployment.\n', '    /// This function allows Unwind to take all the Chai savings and operate with the Treasury MakerDAO vault.\n', '    /// @param unwind_ The address of the Unwild.sol contract.\n', '    function registerUnwind(address unwind_)\n', '        public\n', '        onlyOwner\n', '    {\n', '        require(\n', '            unwind == address(0),\n', '            "Treasury: Unwind already set"\n', '        );\n', '        unwind = unwind_;\n', '        chai.approve(address(unwind), uint256(-1)); // Unwind will never cheat on us\n', '        vat.hope(address(unwind));                  // Unwind will never cheat on us\n', '    }\n', '}']