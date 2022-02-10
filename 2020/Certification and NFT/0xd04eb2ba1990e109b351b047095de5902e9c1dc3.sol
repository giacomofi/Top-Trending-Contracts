['// File: openzeppelin-solidity-2.3.0/contracts/ownership/Ownable.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be aplied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the caller is the current owner.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * > Note: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity-2.3.0/contracts/math/SafeMath.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, "SafeMath: division by zero");\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: contracts/BankConfig.sol\n', '\n', 'pragma solidity 0.5.16;\n', '\n', 'interface BankConfig {\n', '    /// @dev Return minimum ETH debt size per position.\n', '    function minDebtSize() external view returns (uint256);\n', '\n', '    /// @dev Return the interest rate per second, using 1e18 as denom.\n', '    function getInterestRate(uint256 debt, uint256 floating) external view returns (uint256);\n', '\n', '    /// @dev Return the bps rate for reserve pool.\n', '    function getReservePoolBps() external view returns (uint256);\n', '\n', '    /// @dev Return the bps rate for Avada Kill caster.\n', '    function getKillBps() external view returns (uint256);\n', '\n', '    /// @dev Return whether the given address is a goblin.\n', '    function isGoblin(address goblin) external view returns (bool);\n', '\n', '    /// @dev Return whether the given goblin accepts more debt. Revert on non-goblin.\n', '    function acceptDebt(address goblin) external view returns (bool);\n', '\n', '    /// @dev Return the work factor for the goblin + ETH debt, using 1e4 as denom. Revert on non-goblin.\n', '    function workFactor(address goblin, uint256 debt) external view returns (uint256);\n', '\n', '    /// @dev Return the kill factor for the goblin + ETH debt, using 1e4 as denom. Revert on non-goblin.\n', '    function killFactor(address goblin, uint256 debt) external view returns (uint256);\n', '}\n', '\n', '// File: contracts/ConfigurableInterestBankConfig.sol\n', '\n', 'pragma solidity 0.5.16;\n', '\n', '\n', '\n', 'interface InterestModel {\n', '    /// @dev Return the interest rate per second, using 1e18 as denom.\n', '    function getInterestRate(uint256 debt, uint256 floating) external view returns (uint256);\n', '}\n', '\n', '\n', 'contract ConfigurableInterestBankConfig is BankConfig, Ownable {\n', '    /// @notice Configuration for each goblin.\n', '    struct GoblinConfig {\n', '        bool isGoblin;\n', '        bool acceptDebt;\n', '        uint256 workFactor;\n', '        uint256 killFactor;\n', '    }\n', '\n', '    /// The minimum ETH debt size per position.\n', '    uint256 public minDebtSize;\n', '    /// The portion of interests allocated to the reserve pool.\n', '    uint256 public getReservePoolBps;\n', '    /// The reward for successfully killing a position.\n', '    uint256 public getKillBps;\n', '    /// Mapping for goblin address to its configuration.\n', '    mapping (address => GoblinConfig) goblins;\n', '    /// Interest rate model\n', '    InterestModel public interestModel;\n', '\n', '    constructor(\n', '        uint256 _minDebtSize,\n', '        uint256 _reservePoolBps,\n', '        uint256 _killBps,\n', '        InterestModel _interestModel\n', '    ) public {\n', '        setParams(_minDebtSize, _reservePoolBps, _killBps, _interestModel);\n', '    }\n', '\n', '    /// @dev Set all the basic parameters. Must only be called by the owner.\n', '    /// @param _minDebtSize The new minimum debt size value.\n', '    /// @param _reservePoolBps The new interests allocated to the reserve pool value.\n', '    /// @param _killBps The new reward for killing a position value.\n', '    /// @param _interestModel The new interest rate model contract.\n', '    function setParams(\n', '        uint256 _minDebtSize,\n', '        uint256 _reservePoolBps,\n', '        uint256 _killBps,\n', '        InterestModel _interestModel\n', '    ) public onlyOwner {\n', '        minDebtSize = _minDebtSize;\n', '        getReservePoolBps = _reservePoolBps;\n', '        getKillBps = _killBps;\n', '        interestModel = _interestModel;\n', '    }\n', '\n', '    /// @dev Set the configuration for the given goblin. Must only be called by the owner.\n', '    /// @param goblin The goblin address to set configuration.\n', '    /// @param _isGoblin Whether the given address is a valid goblin.\n', '    /// @param _acceptDebt Whether the goblin is accepting new debts.\n', '    /// @param _workFactor The work factor value for this goblin.\n', '    /// @param _killFactor The kill factor value for this goblin.\n', '    function setGoblin(\n', '        address goblin,\n', '        bool _isGoblin,\n', '        bool _acceptDebt,\n', '        uint256 _workFactor,\n', '        uint256 _killFactor\n', '    ) public onlyOwner {\n', '        goblins[goblin] = GoblinConfig({\n', '            isGoblin: _isGoblin,\n', '            acceptDebt: _acceptDebt,\n', '            workFactor: _workFactor,\n', '            killFactor: _killFactor\n', '        });\n', '    }\n', '\n', '    /// @dev Return the interest rate per second, using 1e18 as denom.\n', '    function getInterestRate(uint256 debt, uint256 floating) external view returns (uint256) {\n', '        return interestModel.getInterestRate(debt, floating);\n', '    }\n', '\n', '    /// @dev Return whether the given address is a goblin.\n', '    function isGoblin(address goblin) external view returns (bool) {\n', '        return goblins[goblin].isGoblin;\n', '    }\n', '\n', '    /// @dev Return whether the given goblin accepts more debt. Revert on non-goblin.\n', '    function acceptDebt(address goblin) external view returns (bool) {\n', '        require(goblins[goblin].isGoblin, "!goblin");\n', '        return goblins[goblin].acceptDebt;\n', '    }\n', '\n', '    /// @dev Return the work factor for the goblin + ETH debt, using 1e4 as denom. Revert on non-goblin.\n', '    function workFactor(address goblin, uint256 /* debt */) external view returns (uint256) {\n', '        require(goblins[goblin].isGoblin, "!goblin");\n', '        return goblins[goblin].workFactor;\n', '    }\n', '\n', '    /// @dev Return the kill factor for the goblin + ETH debt, using 1e4 as denom. Revert on non-goblin.\n', '    function killFactor(address goblin, uint256 /* debt */) external view returns (uint256) {\n', '        require(goblins[goblin].isGoblin, "!goblin");\n', '        return goblins[goblin].killFactor;\n', '    }\n', '}']