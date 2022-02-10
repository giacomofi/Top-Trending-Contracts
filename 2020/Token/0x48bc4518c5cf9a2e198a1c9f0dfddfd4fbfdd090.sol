['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.7.0;\n', '\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', 'interface IMilker is IERC20 {\n', '    // Token management accessed only from StableV2 contracts\n', '    function produceMilk(uint256 amount) external returns (uint256);\n', '    function takeMilk(address account) external returns (uint256);\n', '    // Primary MILK tokenomics events\n', '    function bandits(uint256 percent) external returns (uint256, uint256, uint256);\n', '    function sheriffsVaultCommission() external returns (uint256);\n', '    function sheriffsPotDistribution() external returns (uint256);\n', '    // Getters\n', '    function startTime() external view returns (uint256);\n', '    function isWhitelisted(address account) external view returns (bool);\n', '    function vaultOf(address account) external view returns (uint256);\n', '    function period() external view returns (uint256);\n', '    function periodProgress() external view returns (uint256);\n', '    function periodLength() external view returns (uint256);\n', '    function production() external view returns (uint256);\n', '    function producedTotal() external view returns (uint256);\n', '    function distributedTotal() external view returns (uint256);\n', '    function pendingTotal() external view returns (uint256);\n', '    function pendingTo(address account) external view returns (uint256);\n', '}\n', '\n', '// solium-disable security/no-block-members\n', '\n', 'contract Controller is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    // Contract implementing tokenomics events.\n', '    IMilker private _milker;\n', '\n', '    // Number of last "happened" round.\n', '    uint256 private _lastRound;\n', '\n', '    event Round(\n', '        uint256 indexed round,\n', '        bool indexed banditsComing,\n', '        bool indexed sheriffsPotDistributing,\n', '        uint256 banditsPercent,\n', '        uint256 banditsAmount,\n', '        uint256 arrestedAmount,\n', '        uint256 burntAmount,\n', '        uint256 vaultCommissionAmount,\n', '        uint256 potDistributionAmount,\n', '        uint256 timestamp\n', '    );\n', '\n', '    function setMilker(address milker) external onlyOwner {\n', '        require(address(_milker) == address(0), "Controller: MILK token contract is set up already");\n', '        require(milker != address(0), "Controller: MILK token contract cannot be set up to nothing");\n', '        _milker = IMilker(milker);\n', '    }\n', '\n', '    ////////////////////////////////////////////////////////////////\n', '    // [Event] All in one function to play a round\n', '    ////////////////////////////////////////////////////////////////\n', '\n', '    // Use more gas than estimated since the Random is at the table.\n', '    function round() external {\n', '        uint256 period = _milker.period();\n', '        require(period > _lastRound, "Controller: need to wait for a new round");\n', '        _lastRound = _lastRound.add(1);\n', '\n', '        // Randomization and results\n', '        uint256 randomNumber = _randomNumber();\n', '        bool banditsComing = (((randomNumber >> 24) % 10) < 3); // 30% chance\n', '        bool sheriffsPotDistributing = false; // will be calculated later if necessary\n', '        uint256 banditsPercent = 0; // will be calculated later if necessary\n', '\n', '        // Results\n', '        uint256 banditsAmount = 0;\n', '        uint256 arrestedAmount = 0;\n', '        uint256 burntAmount = 0;\n', '        uint256 vaultCommissionAmount = 0;\n', '        uint256 potDistributionAmount = 0;\n', '\n', '        // Bandits\n', '        if (banditsComing) {\n', '            banditsPercent = (((randomNumber >> 40) % 99) + 1); // from 1% to 99% bandits share\n', '            (banditsAmount, arrestedAmount, burntAmount) = _milker.bandits(banditsPercent);\n', '        }\n', '\n', "        // Sheriff's vault comission\n", '        vaultCommissionAmount = _milker.sheriffsVaultCommission();\n', '\n', "        // Sheriff's pot distribution\n", '        if (!banditsComing) {\n', '            sheriffsPotDistributing = (((randomNumber >> 64) % 10) < 3); // 30% chance\n', '            if (sheriffsPotDistributing) {\n', '                potDistributionAmount = _milker.sheriffsPotDistribution();\n', '            }\n', '        }\n', '\n', '        emit Round(\n', '            _lastRound, banditsComing, sheriffsPotDistributing, banditsPercent,\n', '            banditsAmount, arrestedAmount, burntAmount,\n', '            vaultCommissionAmount, potDistributionAmount,\n', '            block.timestamp\n', '        );\n', '    }\n', '\n', '    ////////////////////////////////////////////////////////////////\n', '    // Contract getters\n', '    ////////////////////////////////////////////////////////////////\n', '\n', '    function milker() external view returns (address) {\n', '        return address(_milker);\n', '    }\n', '\n', '    function lastRound() external view returns (uint256) {\n', '        return _lastRound;\n', '    }\n', '\n', '    function lastRoundTime() external view returns (uint256) {\n', '        if (_lastRound == 0) {\n', '            return 0;\n', '        }\n', '        uint256 startTime = _milker.startTime();\n', '        uint256 periodLength = _milker.periodLength();\n', '        uint256 time = startTime.add(_lastRound.mul(periodLength));\n', '        return time;\n', '    }\n', '\n', '    function nextRoundTime() external view returns (uint256) {\n', '        uint256 startTime = _milker.startTime();\n', '        uint256 periodLength = _milker.periodLength();\n', '        uint256 time = startTime.add(_lastRound.add(1).mul(periodLength));\n', '        return time;\n', '    }\n', '\n', '    ////////////////////////////////////////////////////////////////\n', '    // Internal functions\n', '    ////////////////////////////////////////////////////////////////\n', '\n', '    function _randomNumber() private view returns (uint256) {\n', '        bytes memory seed = abi.encodePacked(\n', '            _milker, _lastRound,block.timestamp,\n', '            blockhash(block.number-1),\n', '            blockhash(block.number-2),\n', '            blockhash(block.number-3),\n', '            blockhash(block.number-4),\n', '            blockhash(block.number-5),\n', '            blockhash(block.number-6),\n', '            blockhash(block.number-7)\n', '        );\n', '        return uint256(keccak256(seed));\n', '    }\n', '}\n', '\n', '// solium-enable security/no-block-members']