['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-19\n', '*/\n', '\n', '// File: @openzeppelin/contracts/math/SafeMath.sol\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: contracts/interfaces/IFeeChecker.sol\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'interface IFeeChecker {\n', '\n', '    function isTransferTaxed(address sender, address recipient) external view returns (bool);\n', '\n', '    function isTransferTaxed2() external view returns (bool);\n', '\n', '    function calculateFeeAmount(address sender, address recipient, uint256 amount) external view returns (uint256 feeAmount);\n', '}\n', '\n', '// File: contracts/interfaces/IOracle.sol\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'interface IOracle {\n', '    function update() external;\n', '\n', '    function consult(address token, uint256 amountIn)\n', '        external\n', '        view\n', '        returns (uint256 amountOut);\n', '    // function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestamp);\n', '}\n', '\n', '// File: @openzeppelin/contracts/GSN/Context.sol\n', '\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/access/Ownable.sol\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: contracts/owner/Operator.sol\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '\n', '\n', 'contract Operator is Context, Ownable {\n', '    address private _operator;\n', '\n', '    event OperatorTransferred(\n', '        address indexed previousOperator,\n', '        address indexed newOperator\n', '    );\n', '\n', '    constructor() internal {\n', '        _operator = _msgSender();\n', '        emit OperatorTransferred(address(0), _operator);\n', '    }\n', '\n', '    function operator() public view returns (address) {\n', '        return _operator;\n', '    }\n', '\n', '    modifier onlyOperator() {\n', '        require(\n', '            _operator == msg.sender,\n', "            'operator: caller is not the operator'\n", '        );\n', '        _;\n', '    }\n', '\n', '    function isOperator() public view returns (bool) {\n', '        return _msgSender() == _operator;\n', '    }\n', '\n', '    function transferOperator(address newOperator_) public onlyOwner {\n', '        _transferOperator(newOperator_);\n', '    }\n', '\n', '    function _transferOperator(address newOperator_) internal {\n', '        require(\n', '            newOperator_ != address(0),\n', "            'operator: zero address given for new operator'\n", '        );\n', '        emit OperatorTransferred(address(0), newOperator_);\n', '        _operator = newOperator_;\n', '    }\n', '}\n', '\n', '// File: contracts/FeeChecker.sol\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '\n', '\n', '\n', '\n', 'contract FeeChecker is IFeeChecker, Operator {\n', '    using SafeMath for uint256;\n', '\n', '    IOracle public oracle;\n', '    address public tokenAddress;\n', '    address constant stakeLockContract = 0xE144303f7FC3E99A9dE5474fD6c7B40add83a1dA;\n', '    uint256 tax_below_price = 1e18; //The value of $1 worth of Basis returned by the oracle ( 18 decimals, which is why we do oracle.consult(tokenAddress, 10 ** 18) )\n', '\n', '    //If price < tax_below_price, sending Basis to addresses in feeList will have a fee\n', '    mapping(address => bool) public feeList;\n', '\n', '    //Addresses in whiteList are allowed to send transactions to addresses in feeList\n', '    mapping(address => bool) public whiteList; \n', '\n', '    constructor(address _tokenAddress) public {\n', '        tokenAddress = _tokenAddress;\n', '    }\n', '\n', '    /* ========== VIEW FUNCTIONS ========== */\n', '\n', "    //Checks in the Cashv2 contract if the transfer is allowed, blocks transfers to addresses in feeList if sender isn't in whiteList\n", '    function isTransferTaxed(address sender, address recipient) \n', '        external \n', '        override\n', '        view\n', '        returns (bool) \n', '    {\n', '        if (sender == stakeLockContract || recipient == stakeLockContract) {\n', '            if (whiteList[sender] == true || whiteList[recipient]) {\n', '                return false;\n', '            }\n', '            return true;\n', '        }\n', '\n', '        if(oracle.consult(tokenAddress, 10 ** 18) < tax_below_price) {\n', '            require(feeList[recipient] == false || whiteList[sender] == true, "Please use the main website when selling MIC");\n', '        }\n', '        return false;\n', '    }\n', '\n', '    //This is ugly, but creating a duplicate function to keep "is the transfer taxed?" logic in one file is better than splitting it between multiple files\n', '    //Used by the ProxyCurve contract\n', '    function isTransferTaxed2() \n', '        external \n', '        override\n', '        view\n', '        returns (bool) \n', '    {\n', '        return oracle.consult(tokenAddress, 10 ** 18) < tax_below_price;\n', '    }\n', '\n', '\n', "    //Right now sender/recipient args aren't used, but they may be in the future\n", '    function calculateFeeAmount(address sender, address recipient, uint256 amount) \n', '        external \n', '        override\n', '        view \n', '        returns (uint256 feeAmount)\n', '    {\n', '        if (sender == stakeLockContract) {\n', '            return amount.mul(7500).div(10000);\n', '        }\n', '        if (recipient == stakeLockContract) {\n', '            // stop users from transferring to the lock contract.\n', '            return amount;\n', '        }\n', '        feeAmount = amount.mul(calculateTaxPercent()).div(tax_below_price.mul(tax_below_price));\n', '    }\n', '\n', '    //Tax = 1 - currPrice ** 2\n', '    function calculateTaxPercent() \n', '        public \n', '        view \n', '        returns (uint256 taxPercent)\n', '    {\n', '        uint256 currPrice = oracle.consult(tokenAddress, 10 ** 18);\n', '        taxPercent = tax_below_price.mul(tax_below_price) - currPrice.mul(currPrice);\n', '    }\n', '\n', '    /* ========== GOVERNANCE ========== */\n', '    function addToFeeList(address _address) public onlyOperator {\n', '        feeList[_address] = true;\n', '    }\n', '\n', '    function removeFromFeeList(address _address) public onlyOperator {\n', '        feeList[_address] = false;\n', '    }\n', '\n', '    function addToWhiteList(address _address) public onlyOperator {\n', '        whiteList[_address] = true;\n', '    }\n', '\n', '    function removeFromWhiteList(address _address) public onlyOperator {\n', '        whiteList[_address] = false;\n', '    }\n', '    \n', '    function setOracle(address _address) public onlyOperator {\n', '        oracle = IOracle(_address);\n', '    }\n', '}']