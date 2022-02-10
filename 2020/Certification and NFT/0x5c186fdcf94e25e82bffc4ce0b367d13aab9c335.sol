['pragma solidity 0.4.25;\n', '\n', '// File: openzeppelin-solidity-v1.12.0/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity-v1.12.0/contracts/ownership/Claimable.sol\n', '\n', '/**\n', ' * @title Claimable\n', ' * @dev Extension for the Ownable contract, where the ownership needs to be claimed.\n', ' * This allows the new owner to accept the transfer.\n', ' */\n', 'contract Claimable is Ownable {\n', '  address public pendingOwner;\n', '\n', '  /**\n', '   * @dev Modifier throws if called by any account other than the pendingOwner.\n', '   */\n', '  modifier onlyPendingOwner() {\n', '    require(msg.sender == pendingOwner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to set the pendingOwner address.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    pendingOwner = newOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the pendingOwner address to finalize the transfer.\n', '   */\n', '  function claimOwnership() public onlyPendingOwner {\n', '    emit OwnershipTransferred(owner, pendingOwner);\n', '    owner = pendingOwner;\n', '    pendingOwner = address(0);\n', '  }\n', '}\n', '\n', '// File: contracts/utils/Adminable.sol\n', '\n', '/**\n', ' * @title Adminable.\n', ' */\n', 'contract Adminable is Claimable {\n', '    address[] public adminArray;\n', '\n', '    struct AdminInfo {\n', '        bool valid;\n', '        uint256 index;\n', '    }\n', '\n', '    mapping(address => AdminInfo) public adminTable;\n', '\n', '    event AdminAccepted(address indexed _admin);\n', '    event AdminRejected(address indexed _admin);\n', '\n', '    /**\n', '     * @dev Reverts if called by any account other than one of the administrators.\n', '     */\n', '    modifier onlyAdmin() {\n', '        require(adminTable[msg.sender].valid, "caller is illegal");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Accept a new administrator.\n', "     * @param _admin The administrator's address.\n", '     */\n', '    function accept(address _admin) external onlyOwner {\n', '        require(_admin != address(0), "administrator is illegal");\n', '        AdminInfo storage adminInfo = adminTable[_admin];\n', '        require(!adminInfo.valid, "administrator is already accepted");\n', '        adminInfo.valid = true;\n', '        adminInfo.index = adminArray.length;\n', '        adminArray.push(_admin);\n', '        emit AdminAccepted(_admin);\n', '    }\n', '\n', '    /**\n', '     * @dev Reject an existing administrator.\n', "     * @param _admin The administrator's address.\n", '     */\n', '    function reject(address _admin) external onlyOwner {\n', '        AdminInfo storage adminInfo = adminTable[_admin];\n', '        require(adminArray.length > adminInfo.index, "administrator is already rejected");\n', '        require(_admin == adminArray[adminInfo.index], "administrator is already rejected");\n', '        // at this point we know that adminArray.length > adminInfo.index >= 0\n', '        address lastAdmin = adminArray[adminArray.length - 1]; // will never underflow\n', '        adminTable[lastAdmin].index = adminInfo.index;\n', '        adminArray[adminInfo.index] = lastAdmin;\n', '        adminArray.length -= 1; // will never underflow\n', '        delete adminTable[_admin];\n', '        emit AdminRejected(_admin);\n', '    }\n', '\n', '    /**\n', '     * @dev Get an array of all the administrators.\n', '     * @return An array of all the administrators.\n', '     */\n', '    function getAdminArray() external view returns (address[] memory) {\n', '        return adminArray;\n', '    }\n', '\n', '    /**\n', '     * @dev Get the total number of administrators.\n', '     * @return The total number of administrators.\n', '     */\n', '    function getAdminCount() external view returns (uint256) {\n', '        return adminArray.length;\n', '    }\n', '}\n', '\n', '// File: contracts/wallet_trading_limiter/interfaces/IWalletsTradingLimiterValueConverter.sol\n', '\n', '/**\n', ' * @title Wallets Trading Limiter Value Converter Interface.\n', ' */\n', 'interface IWalletsTradingLimiterValueConverter {\n', '    /**\n', '     * @dev Get the current limiter currency worth of a given SGR amount.\n', '     * @param _sgrAmount The amount of SGR to convert.\n', '     * @return The equivalent amount of the limiter currency.\n', '     */\n', '    function toLimiterValue(uint256 _sgrAmount) external view returns (uint256);\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', '// File: contracts/wallet_trading_limiter/WalletsTradingLimiterValueConverter.sol\n', '\n', '/**\n', ' * Details of usage of licenced software see here: https://www.sogur.com/software/readme_v1\n', ' */\n', '\n', '/**\n', ' * @title Wallets Trading Limiter Value Converter.\n', ' */\n', 'contract WalletsTradingLimiterValueConverter is IWalletsTradingLimiterValueConverter, Adminable {\n', '    string public constant VERSION = "1.0.1";\n', '\n', '    using SafeMath for uint256;\n', '\n', '    /**\n', '     * @dev price maximum resolution.\n', '     * @notice Allow for sufficiently-high resolution.\n', '     * @notice Prevents multiplication-overflow.\n', '     */\n', '    uint256 public constant MAX_RESOLUTION = 0x10000000000000000;\n', '\n', '    uint256 public sequenceNum = 0;\n', '    uint256 public priceN = 0;\n', '    uint256 public priceD = 0;\n', '\n', '    event PriceSaved(uint256 _priceN, uint256 _priceD);\n', '    event PriceNotSaved(uint256 _priceN, uint256 _priceD);\n', '\n', '    /**\n', '     * @dev Set the price.\n', '     * @param _sequenceNum The sequence-number of the operation.\n', '     * @param _priceN The numerator of the price.\n', '     * @param _priceD The denominator of the price.\n', '     */\n', '    function setPrice(uint256 _sequenceNum, uint256 _priceN, uint256 _priceD) external onlyAdmin {\n', '        require(1 <= _priceN && _priceN <= MAX_RESOLUTION, "price numerator is out of range");\n', '        require(1 <= _priceD && _priceD <= MAX_RESOLUTION, "price denominator is out of range");\n', '\n', '        if (sequenceNum < _sequenceNum) {\n', '            sequenceNum = _sequenceNum;\n', '            priceN = _priceN;\n', '            priceD = _priceD;\n', '            emit PriceSaved(_priceN, _priceD);\n', '        }\n', '        else {\n', '            emit PriceNotSaved(_priceN, _priceD);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Get the current limiter worth of a given SGR amount.\n', '     * @param _sgrAmount The amount of SGR to convert.\n', '     * @return The equivalent limiter amount.\n', '     */\n', '    function toLimiterValue(uint256 _sgrAmount) external view returns (uint256) {\n', '        assert(priceN > 0 && priceD > 0);\n', '        return _sgrAmount.mul(priceN) / priceD;\n', '    }\n', '}']