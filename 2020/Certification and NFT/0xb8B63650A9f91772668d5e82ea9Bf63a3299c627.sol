['pragma solidity ^0.5.16;\n', '\n', 'contract WanttrollerErrorReporter {\n', '    enum Error {\n', '        NO_ERROR,\n', '        DIVISION_BY_ZERO,\n', '        INTEGER_OVERFLOW,\n', '        INTEGER_UNDERFLOW,\n', '        UNAUTHORIZED\n', '    }   \n', '\n', '    enum FailureInfo {\n', '      ACCEPT_ADMIN_PENDING_ADMIN_CHECK,\n', '      ACCEPT_PENDING_IMPLEMENTATION_ADDRESS_CHECK,\n', '      SET_PENDING_ADMIN_OWNER_CHECK,\n', '      SET_PAUSE_GUARDIAN_OWNER_CHECK,\n', '      SET_IMPLEMENTATION_OWNER_CHECK,\n', '      SET_PENDING_IMPLEMENTATION_OWNER_CHECK\n', '    }   \n', '\n', '    /**\n', '      * @dev `error` corresponds to enum Error; `info` corresponds to enum FailureInfo, and `detail` is an arbitrary\n', '      * contract-specific code that enables us to report opaque error codes from upgradeable contracts.\n', '      **/\n', '    event Failure(uint error, uint info, uint detail);\n', '\n', '    /**\n', '      * @dev use this when reporting a known error from the money market or a non-upgradeable collaborator\n', '      */\n', '    function fail(Error err, FailureInfo info) internal returns (uint) {\n', '        emit Failure(uint(err), uint(info), 0);\n', '        return uint(err);\n', '    }\n', '\n', '    /**\n', '      * @dev use this when reporting an opaque error from an upgradeable collaborator contract\n', '      */\n', '    function failOpaque(Error err, FailureInfo info, uint opaqueError) internal returns (uint) {\n', '        emit Failure(uint(err), uint(info), opaqueError);\n', '\n', '        return uint(err);\n', '    }\n', '}\n', '\n']
['pragma solidity ^0.5.16;\n', 'import "./Exponential.sol";\n', 'contract UnitrollerAdminStorage {\n', '    /**\n', '    * @notice Administrator for this contract\n', '    */\n', '    address public admin;\n', '\n', '    /**\n', '    * @notice Pending administrator for this contract\n', '    */\n', '    address public pendingAdmin;\n', '\n', '    /**\n', '    * @notice Active brains of Unitroller\n', '    */\n', '    address public wanttrollerImplementation;\n', '\n', '    /**\n', '    * @notice Pending brains of Unitroller\n', '    */\n', '    address public pendingWanttrollerImplementation;\n', '}\n', 'contract WanttrollerV1Storage is UnitrollerAdminStorage, Exponential {\n', '  struct WantDrop {\n', '    /// @notice Total accounts requesting piece of drop \n', '    uint numRegistrants;\n', '    \n', '    /// @notice Total amount to be dropped\n', '    uint totalDrop;\n', '  }\n', '\n', '  // @notice Total amount dropped\n', '  uint public totalDropped;\n', '  \n', '  // @notice Min time between drops\n', '  uint public waitblocks = 200; \n', '\n', '  // @notice Tracks beginning of this drop \n', '  uint public currentDropStartBlock;\n', '  \n', '  // @notice Tracks the index of the current drop\n', '  uint public currentDropIndex;\n', '  \n', '  /// @notice Store total registered and total reward for that drop \n', '  mapping(uint => WantDrop) public wantDropState;\n', '\n', '  /// @notice Any WANT rewards accrued but not yet collected \n', '  mapping(address => uint) public accruedRewards;\n', '  \n', '  /// @notice Track the last drop this account was part of \n', '  mapping(address => uint) public lastDropRegistered;\n', '\n', '  address wantTokenAddress;\n', '\n', '  address[] public accountsRegisteredForDrop;\n', '\n', '  /// @notice Stores the current amount of drop being awarded\n', '  uint public currentReward;\n', '  \n', '  /// @notice Each time rewards are distributed next rewards reduced by applying this factor\n', '  uint public discountFactor = 0.9995e18;\n', '\n', '  // Store faucet address \n', '  address public wantFaucetAddress;\n', '}\n']
['pragma solidity ^0.5.16;\n', '\n', '/**\n', '  * @title Careful Math\n', '  * @author Compound\n', "  * @notice Derived from OpenZeppelin's SafeMath library\n", '  *         https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol\n', '  */\n', 'contract CarefulMath {\n', '\n', '    /**\n', '     * @dev Possible error codes that we can return\n', '     */\n', '    enum MathError {\n', '        NO_ERROR,\n', '        DIVISION_BY_ZERO,\n', '        INTEGER_OVERFLOW,\n', '        INTEGER_UNDERFLOW\n', '    }\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, returns an error on overflow.\n', '    */\n', '    function mulUInt(uint a, uint b) internal pure returns (MathError, uint) {\n', '        if (a == 0) {\n', '            return (MathError.NO_ERROR, 0);\n', '        }\n', '\n', '        uint c = a * b;\n', '\n', '        if (c / a != b) {\n', '            return (MathError.INTEGER_OVERFLOW, 0);\n', '        } else {\n', '            return (MathError.NO_ERROR, c);\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function divUInt(uint a, uint b) internal pure returns (MathError, uint) {\n', '        if (b == 0) {\n', '            return (MathError.DIVISION_BY_ZERO, 0);\n', '        }\n', '\n', '        return (MathError.NO_ERROR, a / b);\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, returns an error on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function subUInt(uint a, uint b) internal pure returns (MathError, uint) {\n', '        if (b <= a) {\n', '            return (MathError.NO_ERROR, a - b);\n', '        } else {\n', '            return (MathError.INTEGER_UNDERFLOW, 0);\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, returns an error on overflow.\n', '    */\n', '    function addUInt(uint a, uint b) internal pure returns (MathError, uint) {\n', '        uint c = a + b;\n', '\n', '        if (c >= a) {\n', '            return (MathError.NO_ERROR, c);\n', '        } else {\n', '            return (MathError.INTEGER_OVERFLOW, 0);\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @dev add a and b and then subtract c\n', '    */\n', '    function addThenSubUInt(uint a, uint b, uint c) internal pure returns (MathError, uint) {\n', '        (MathError err0, uint sum) = addUInt(a, b);\n', '\n', '        if (err0 != MathError.NO_ERROR) {\n', '            return (err0, 0);\n', '        }\n', '\n', '        return subUInt(sum, c);\n', '    }\n', '}']
['pragma solidity ^0.5.16;\n', '\n', 'import "./ErrorReporter.sol";\n', 'import "./WanttrollerStorage.sol";\n', '/**\n', ' * @title WanttrollerCore\n', ' * @dev Storage for the wanttroller is at this address, while execution is delegated to the `wanttrollerImplementation`.\n', ' */\n', 'contract Unitroller is UnitrollerAdminStorage, WanttrollerErrorReporter {\n', '\n', '    /**\n', '      * @notice Emitted when pendingWanttrollerImplementation is changed\n', '      */\n', '    event NewPendingImplementation(address oldPendingImplementation, address newPendingImplementation);\n', '\n', '    /**\n', '      * @notice Emitted when pendingWanttrollerImplementation is accepted, which means wanttroller implementation is updated\n', '      */\n', '    event NewImplementation(address oldImplementation, address newImplementation);\n', '\n', '    /**\n', '      * @notice Emitted when pendingAdmin is changed\n', '      */\n', '    event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);\n', '\n', '    /**\n', '      * @notice Emitted when pendingAdmin is accepted, which means admin is updated\n', '      */\n', '    event NewAdmin(address oldAdmin, address newAdmin);\n', '\n', '    constructor() public {\n', '        // Set admin to caller\n', '        admin = msg.sender;\n', '    }\n', '\n', '    /*** Admin Functions ***/\n', '    function _setPendingImplementation(address newPendingImplementation) public returns (uint) {\n', '\n', '        if (msg.sender != admin) {\n', '            return fail(Error.UNAUTHORIZED, FailureInfo.SET_PENDING_IMPLEMENTATION_OWNER_CHECK);\n', '        }\n', '\n', '        address oldPendingImplementation = pendingWanttrollerImplementation;\n', '\n', '        pendingWanttrollerImplementation = newPendingImplementation;\n', '\n', '        emit NewPendingImplementation(oldPendingImplementation, pendingWanttrollerImplementation);\n', '\n', '        return uint(Error.NO_ERROR);\n', '    }\n', '\n', '    /**\n', '    * @notice Accepts new implementation of wanttroller. msg.sender must be pendingImplementation\n', "    * @dev Admin function for new implementation to accept it's role as implementation\n", '    * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)\n', '    */\n', '    function _acceptImplementation() public returns (uint) {\n', '        // Check caller is pendingImplementation and pendingImplementation ≠ address(0)\n', '        if (msg.sender != pendingWanttrollerImplementation || pendingWanttrollerImplementation == address(0)) {\n', '            return fail(Error.UNAUTHORIZED, FailureInfo.ACCEPT_PENDING_IMPLEMENTATION_ADDRESS_CHECK);\n', '        }\n', '\n', '        // Save current values for inclusion in log\n', '        address oldImplementation = wanttrollerImplementation;\n', '        address oldPendingImplementation = pendingWanttrollerImplementation;\n', '\n', '        wanttrollerImplementation = pendingWanttrollerImplementation;\n', '\n', '        pendingWanttrollerImplementation = address(0);\n', '\n', '        emit NewImplementation(oldImplementation, wanttrollerImplementation);\n', '        emit NewPendingImplementation(oldPendingImplementation, pendingWanttrollerImplementation);\n', '\n', '        return uint(Error.NO_ERROR);\n', '    }\n', '\n', '\n', '    function _transferOwnership(address newAdmin) public returns (uint) {\n', '        // Check caller = admin\n', '        if (msg.sender != admin) {\n', '            return fail(Error.UNAUTHORIZED, FailureInfo.SET_PENDING_ADMIN_OWNER_CHECK);\n', '        }\n', '        emit NewAdmin(admin, newAdmin);\n', '        admin = newAdmin;\n', '\n', '        return uint(Error.NO_ERROR);\n', '    }\n', '\n', '    /**\n', '      * @notice Begins transfer of admin rights. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.\n', '      * @dev Admin function to begin change of admin. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.\n', '      * @param newPendingAdmin New pending admin.\n', '      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)\n', '      */\n', '    function _setPendingAdmin(address newPendingAdmin) public returns (uint) {\n', '        // Check caller = admin\n', '        if (msg.sender != admin) {\n', '            return fail(Error.UNAUTHORIZED, FailureInfo.SET_PENDING_ADMIN_OWNER_CHECK);\n', '        }\n', '\n', '        // Save current value, if any, for inclusion in log\n', '        address oldPendingAdmin = pendingAdmin;\n', '\n', '        // Store pendingAdmin with value newPendingAdmin\n', '        pendingAdmin = newPendingAdmin;\n', '\n', '        // Emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin)\n', '        emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin);\n', '\n', '        return uint(Error.NO_ERROR);\n', '    }\n', '\n', '    /**\n', '      * @notice Accepts transfer of admin rights. msg.sender must be pendingAdmin\n', '      * @dev Admin function for pending admin to accept role and update admin\n', '      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)\n', '      */\n', '    function _acceptAdmin() public returns (uint) {\n', '        // Check caller is pendingAdmin and pendingAdmin ≠ address(0)\n', '        if (msg.sender != pendingAdmin || msg.sender == address(0)) {\n', '            return fail(Error.UNAUTHORIZED, FailureInfo.ACCEPT_ADMIN_PENDING_ADMIN_CHECK);\n', '        }\n', '\n', '        // Save current values for inclusion in log\n', '        address oldAdmin = admin;\n', '        address oldPendingAdmin = pendingAdmin;\n', '\n', '        // Store admin with value pendingAdmin\n', '        admin = pendingAdmin;\n', '\n', '        // Clear the pending value\n', '        pendingAdmin = address(0);\n', '\n', '        emit NewAdmin(oldAdmin, admin);\n', '        emit NewPendingAdmin(oldPendingAdmin, pendingAdmin);\n', '\n', '        return uint(Error.NO_ERROR);\n', '    }\n', '\n', '    /**\n', '     * @dev Delegates execution to an implementation contract.\n', '     * It returns to the external caller whatever the implementation returns\n', '     * or forwards reverts.\n', '     */\n', '    function () payable external {\n', '        // delegate all other functions to current implementation\n', '        (bool success, ) = wanttrollerImplementation.delegatecall(msg.data);\n', '\n', '        assembly {\n', '              let free_mem_ptr := mload(0x40)\n', '              returndatacopy(free_mem_ptr, 0, returndatasize)\n', '\n', '              switch success\n', '              case 0 { revert(free_mem_ptr, returndatasize) }\n', '              default { return(free_mem_ptr, returndatasize) }\n', '        }\n', '    }\n', '}\n']
['pragma solidity ^0.5.16;\n', '\n', 'import "./CarefulMath.sol";\n', '\n', '/**\n', ' * @title Exponential module for storing fixed-precision decimals\n', ' * @author Compound\n', ' * @notice Exp is a struct which stores decimals with a fixed precision of 18 decimal places.\n', ' *         Thus, if we wanted to store the 5.1, mantissa would store 5.1e18. That is:\n', ' *         `Exp({mantissa: 5100000000000000000})`.\n', ' */\n', 'contract Exponential is CarefulMath {\n', '    uint constant expScale = 1e18;\n', '    uint constant doubleScale = 1e36;\n', '    uint constant halfExpScale = expScale/2;\n', '    uint constant mantissaOne = expScale;\n', '\n', '    struct Exp {\n', '        uint mantissa;\n', '    }\n', '\n', '    struct Double {\n', '        uint mantissa;\n', '    }\n', '\n', '    /**\n', '     * @dev Creates an exponential from numerator and denominator values.\n', '     *      Note: Returns an error if (`num` * 10e18) > MAX_INT,\n', '     *            or if `denom` is zero.\n', '     */\n', '    function getExp(uint num, uint denom) pure internal returns (MathError, Exp memory) {\n', '        (MathError err0, uint scaledNumerator) = mulUInt(num, expScale);\n', '        if (err0 != MathError.NO_ERROR) {\n', '            return (err0, Exp({mantissa: 0}));\n', '        }\n', '\n', '        (MathError err1, uint rational) = divUInt(scaledNumerator, denom);\n', '        if (err1 != MathError.NO_ERROR) {\n', '            return (err1, Exp({mantissa: 0}));\n', '        }\n', '\n', '        return (MathError.NO_ERROR, Exp({mantissa: rational}));\n', '    }\n', '\n', '    /**\n', '     * @dev Adds two exponentials, returning a new exponential.\n', '     */\n', '    function addExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {\n', '        (MathError error, uint result) = addUInt(a.mantissa, b.mantissa);\n', '\n', '        return (error, Exp({mantissa: result}));\n', '    }\n', '\n', '    /**\n', '     * @dev Subtracts two exponentials, returning a new exponential.\n', '     */\n', '    function subExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {\n', '        (MathError error, uint result) = subUInt(a.mantissa, b.mantissa);\n', '\n', '        return (error, Exp({mantissa: result}));\n', '    }\n', '\n', '    /**\n', '     * @dev Multiply an Exp by a scalar, returning a new Exp.\n', '     */\n', '    function mulScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {\n', '        (MathError err0, uint scaledMantissa) = mulUInt(a.mantissa, scalar);\n', '        if (err0 != MathError.NO_ERROR) {\n', '            return (err0, Exp({mantissa: 0}));\n', '        }\n', '\n', '        return (MathError.NO_ERROR, Exp({mantissa: scaledMantissa}));\n', '    }\n', '\n', '    /**\n', '     * @dev Multiply an Exp by a scalar, then truncate to return an unsigned integer.\n', '     */\n', '    function mulScalarTruncate(Exp memory a, uint scalar) pure internal returns (MathError, uint) {\n', '        (MathError err, Exp memory product) = mulScalar(a, scalar);\n', '        if (err != MathError.NO_ERROR) {\n', '            return (err, 0);\n', '        }\n', '\n', '        return (MathError.NO_ERROR, truncate(product));\n', '    }\n', '\n', '    /**\n', '     * @dev Multiply an Exp by a scalar, truncate, then add an to an unsigned integer, returning an unsigned integer.\n', '     */\n', '    function mulScalarTruncateAddUInt(Exp memory a, uint scalar, uint addend) pure internal returns (MathError, uint) {\n', '        (MathError err, Exp memory product) = mulScalar(a, scalar);\n', '        if (err != MathError.NO_ERROR) {\n', '            return (err, 0);\n', '        }\n', '\n', '        return addUInt(truncate(product), addend);\n', '    }\n', '\n', '    /**\n', '     * @dev Divide an Exp by a scalar, returning a new Exp.\n', '     */\n', '    function divScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {\n', '        (MathError err0, uint descaledMantissa) = divUInt(a.mantissa, scalar);\n', '        if (err0 != MathError.NO_ERROR) {\n', '            return (err0, Exp({mantissa: 0}));\n', '        }\n', '\n', '        return (MathError.NO_ERROR, Exp({mantissa: descaledMantissa}));\n', '    }\n', '\n', '    /**\n', '     * @dev Divide a scalar by an Exp, returning a new Exp.\n', '     */\n', '    function divScalarByExp(uint scalar, Exp memory divisor) pure internal returns (MathError, Exp memory) {\n', '        /*\n', '          We are doing this as:\n', '          getExp(mulUInt(expScale, scalar), divisor.mantissa)\n', '\n', '          How it works:\n', '          Exp = a / b;\n', '          Scalar = s;\n', '          `s / (a / b)` = `b * s / a` and since for an Exp `a = mantissa, b = expScale`\n', '        */\n', '        (MathError err0, uint numerator) = mulUInt(expScale, scalar);\n', '        if (err0 != MathError.NO_ERROR) {\n', '            return (err0, Exp({mantissa: 0}));\n', '        }\n', '        return getExp(numerator, divisor.mantissa);\n', '    }\n', '\n', '    /**\n', '     * @dev Divide a scalar by an Exp, then truncate to return an unsigned integer.\n', '     */\n', '    function divScalarByExpTruncate(uint scalar, Exp memory divisor) pure internal returns (MathError, uint) {\n', '        (MathError err, Exp memory fraction) = divScalarByExp(scalar, divisor);\n', '        if (err != MathError.NO_ERROR) {\n', '            return (err, 0);\n', '        }\n', '\n', '        return (MathError.NO_ERROR, truncate(fraction));\n', '    }\n', '\n', '    /**\n', '     * @dev Multiplies two exponentials, returning a new exponential.\n', '     */\n', '    function mulExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {\n', '\n', '        (MathError err0, uint doubleScaledProduct) = mulUInt(a.mantissa, b.mantissa);\n', '        if (err0 != MathError.NO_ERROR) {\n', '            return (err0, Exp({mantissa: 0}));\n', '        }\n', '\n', '        // We add half the scale before dividing so that we get rounding instead of truncation.\n', '        //  See "Listing 6" and text above it at https://accu.org/index.php/journals/1717\n', '        // Without this change, a result like 6.6...e-19 will be truncated to 0 instead of being rounded to 1e-18.\n', '        (MathError err1, uint doubleScaledProductWithHalfScale) = addUInt(halfExpScale, doubleScaledProduct);\n', '        if (err1 != MathError.NO_ERROR) {\n', '            return (err1, Exp({mantissa: 0}));\n', '        }\n', '\n', '        (MathError err2, uint product) = divUInt(doubleScaledProductWithHalfScale, expScale);\n', '        // The only error `div` can return is MathError.DIVISION_BY_ZERO but we control `expScale` and it is not zero.\n', '        assert(err2 == MathError.NO_ERROR);\n', '\n', '        return (MathError.NO_ERROR, Exp({mantissa: product}));\n', '    }\n', '\n', '    /**\n', '     * @dev Multiplies two exponentials given their mantissas, returning a new exponential.\n', '     */\n', '    function mulExp(uint a, uint b) pure internal returns (MathError, Exp memory) {\n', '        return mulExp(Exp({mantissa: a}), Exp({mantissa: b}));\n', '    }\n', '\n', '    /**\n', '     * @dev Multiplies three exponentials, returning a new exponential.\n', '     */\n', '    function mulExp3(Exp memory a, Exp memory b, Exp memory c) pure internal returns (MathError, Exp memory) {\n', '        (MathError err, Exp memory ab) = mulExp(a, b);\n', '        if (err != MathError.NO_ERROR) {\n', '            return (err, ab);\n', '        }\n', '        return mulExp(ab, c);\n', '    }\n', '\n', '    /**\n', '     * @dev Divides two exponentials, returning a new exponential.\n', '     *     (a/scale) / (b/scale) = (a/scale) * (scale/b) = a/b,\n', '     *  which we can scale as an Exp by calling getExp(a.mantissa, b.mantissa)\n', '     */\n', '    function divExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {\n', '        return getExp(a.mantissa, b.mantissa);\n', '    }\n', '\n', '    /**\n', '     * @dev Truncates the given exp to a whole number value.\n', '     *      For example, truncate(Exp{mantissa: 15 * expScale}) = 15\n', '     */\n', '    function truncate(Exp memory exp) pure internal returns (uint) {\n', "        // Note: We are not using careful math here as we're performing a division that cannot fail\n", '        return exp.mantissa / expScale;\n', '    }\n', '\n', '    /**\n', '     * @dev Checks if first Exp is less than second Exp.\n', '     */\n', '    function lessThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {\n', '        return left.mantissa < right.mantissa;\n', '    }\n', '\n', '    /**\n', '     * @dev Checks if left Exp <= right Exp.\n', '     */\n', '    function lessThanOrEqualExp(Exp memory left, Exp memory right) pure internal returns (bool) {\n', '        return left.mantissa <= right.mantissa;\n', '    }\n', '\n', '    /**\n', '     * @dev Checks if left Exp > right Exp.\n', '     */\n', '    function greaterThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {\n', '        return left.mantissa > right.mantissa;\n', '    }\n', '\n', '    /**\n', '     * @dev returns true if Exp is exactly zero\n', '     */\n', '    function isZeroExp(Exp memory value) pure internal returns (bool) {\n', '        return value.mantissa == 0;\n', '    }\n', '\n', '    function safe224(uint n, string memory errorMessage) pure internal returns (uint224) {\n', '        require(n < 2**224, errorMessage);\n', '        return uint224(n);\n', '    }\n', '\n', '    function safe32(uint n, string memory errorMessage) pure internal returns (uint32) {\n', '        require(n < 2**32, errorMessage);\n', '        return uint32(n);\n', '    }\n', '\n', '    function add_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {\n', '        return Exp({mantissa: add_(a.mantissa, b.mantissa)});\n', '    }\n', '\n', '    function add_(Double memory a, Double memory b) pure internal returns (Double memory) {\n', '        return Double({mantissa: add_(a.mantissa, b.mantissa)});\n', '    }\n', '\n', '    function add_(uint a, uint b) pure internal returns (uint) {\n', '        return add_(a, b, "addition overflow");\n', '    }\n', '\n', '    function add_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {\n', '        uint c = a + b;\n', '        require(c >= a, errorMessage);\n', '        return c;\n', '    }\n', '\n', '    function sub_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {\n', '        return Exp({mantissa: sub_(a.mantissa, b.mantissa)});\n', '    }\n', '\n', '    function sub_(Double memory a, Double memory b) pure internal returns (Double memory) {\n', '        return Double({mantissa: sub_(a.mantissa, b.mantissa)});\n', '    }\n', '\n', '    function sub_(uint a, uint b) pure internal returns (uint) {\n', '        return sub_(a, b, "subtraction underflow");\n', '    }\n', '\n', '    function sub_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {\n', '        require(b <= a, errorMessage);\n', '        return a - b;\n', '    }\n', '\n', '    function mul_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {\n', '        return Exp({mantissa: mul_(a.mantissa, b.mantissa) / expScale});\n', '    }\n', '\n', '    function mul_(Exp memory a, uint b) pure internal returns (Exp memory) {\n', '        return Exp({mantissa: mul_(a.mantissa, b)});\n', '    }\n', '\n', '    function mul_(uint a, Exp memory b) pure internal returns (uint) {\n', '        return mul_(a, b.mantissa) / expScale;\n', '    }\n', '\n', '    function mul_(Double memory a, Double memory b) pure internal returns (Double memory) {\n', '        return Double({mantissa: mul_(a.mantissa, b.mantissa) / doubleScale});\n', '    }\n', '\n', '    function mul_(Double memory a, uint b) pure internal returns (Double memory) {\n', '        return Double({mantissa: mul_(a.mantissa, b)});\n', '    }\n', '\n', '    function mul_(uint a, Double memory b) pure internal returns (uint) {\n', '        return mul_(a, b.mantissa) / doubleScale;\n', '    }\n', '\n', '    function mul_(uint a, uint b) pure internal returns (uint) {\n', '        return mul_(a, b, "multiplication overflow");\n', '    }\n', '\n', '    function mul_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {\n', '        if (a == 0 || b == 0) {\n', '            return 0;\n', '        }\n', '        uint c = a * b;\n', '        require(c / a == b, errorMessage);\n', '        return c;\n', '    }\n', '\n', '    function div_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {\n', '        return Exp({mantissa: div_(mul_(a.mantissa, expScale), b.mantissa)});\n', '    }\n', '\n', '    function div_(Exp memory a, uint b) pure internal returns (Exp memory) {\n', '        return Exp({mantissa: div_(a.mantissa, b)});\n', '    }\n', '\n', '    function div_(uint a, Exp memory b) pure internal returns (uint) {\n', '        return div_(mul_(a, expScale), b.mantissa);\n', '    }\n', '\n', '    function div_(Double memory a, Double memory b) pure internal returns (Double memory) {\n', '        return Double({mantissa: div_(mul_(a.mantissa, doubleScale), b.mantissa)});\n', '    }\n', '\n', '    function div_(Double memory a, uint b) pure internal returns (Double memory) {\n', '        return Double({mantissa: div_(a.mantissa, b)});\n', '    }\n', '\n', '    function div_(uint a, Double memory b) pure internal returns (uint) {\n', '        return div_(mul_(a, doubleScale), b.mantissa);\n', '    }\n', '\n', '    function div_(uint a, uint b) pure internal returns (uint) {\n', '        return div_(a, b, "divide by zero");\n', '    }\n', '\n', '    function div_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {\n', '        require(b > 0, errorMessage);\n', '        return a / b;\n', '    }\n', '\n', '    function fraction(uint a, uint b) pure internal returns (Double memory) {\n', '        return Double({mantissa: div_(mul_(a, doubleScale), b)});\n', '    }\n', '}\n']