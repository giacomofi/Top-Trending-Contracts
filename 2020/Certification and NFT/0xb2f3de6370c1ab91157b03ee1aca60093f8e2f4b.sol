['pragma solidity ^0.5.17;\n', '\n', '/**\n', ' * @title Initializable\n', ' *\n', ' * @dev Helper contract to support initializer functions. To use it, replace\n', ' * the constructor with a function that has the `initializer` modifier.\n', ' * WARNING: Unlike constructors, initializer functions must be manually\n', ' * invoked. This applies both to deploying an Initializable contract, as well\n', ' * as extending an Initializable contract via inheritance.\n', ' * WARNING: When used with inheritance, manual care must be taken to not invoke\n', ' * a parent initializer twice, or ensure that all initializers are idempotent,\n', ' * because this is not dealt with automatically as with constructors.\n', ' */\n', 'contract Initializable {\n', '\n', '  /**\n', '   * @dev Indicates that the contract has been initialized.\n', '   */\n', '  bool private initialized;\n', '\n', '  /**\n', '   * @dev Indicates that the contract is in the process of being initialized.\n', '   */\n', '  bool private initializing;\n', '\n', '  /**\n', '   * @dev Modifier to use in the initializer function of a contract.\n', '   */\n', '  modifier initializer() {\n', '    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");\n', '\n', '    bool isTopLevelCall = !initializing;\n', '    if (isTopLevelCall) {\n', '      initializing = true;\n', '      initialized = true;\n', '    }\n', '\n', '    _;\n', '\n', '    if (isTopLevelCall) {\n', '      initializing = false;\n', '    }\n', '  }\n', '\n', '  /// @dev Returns true if and only if the function is running in the constructor\n', '  function isConstructor() private view returns (bool) {\n', '    // extcodesize checks the size of the code stored in an address, and\n', '    // address returns the current address. Since the code is still not\n', '    // deployed when running a constructor, any checks on its code size will\n', '    // yield zero, making it an effective way to detect if a contract is\n', '    // under construction or not.\n', '    address self = address(this);\n', '    uint256 cs;\n', '    assembly { cs := extcodesize(self) }\n', '    return cs == 0;\n', '  }\n', '\n', '  // Reserved storage space to allow for layout changes in the future.\n', '  uint256[50] private ______gap;\n', '}\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'contract Context is Initializable {\n', '    // Empty internal constructor, to prevent people from mistakenly deploying\n', '    // an instance of this contract, which should be used via inheritance.\n', '    constructor () internal { }\n', '    // solhint-disable-previous-line no-empty-blocks\n', '\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be aplied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable is Initializable, Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    function initialize(address sender) public initializer {\n', '        _owner = sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the caller is the current owner.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return _msgSender() == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * > Note: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '\n', '    uint256[50] private ______gap;\n', '}\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'interface ERC20Basic {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address who) external view returns (uint256);\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 Advanced interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'interface ERC20Advanced {\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20Standard\n', ' * @dev Full ERC20 interface\n', ' */\n', 'contract ERC20Standard is ERC20Basic, ERC20Advanced {}\n', '\n', 'contract TokenDistribution is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    /*                                               GENERAL VARIABLES                                                */\n', '    /* ============================================================================================================== */\n', '\n', '    ERC20Standard public token;                         // ERC20Token contract variable\n', '\n', '    uint256 constant internal base18 = 1000000000000000000;\n', '\n', '    uint256 public standardRate;\n', '\n', '    uint256 public percentBonus;                        // Percentage Bonus\n', '    uint256 public withdrawDate;                        // Withdraw Date\n', '    uint256 public totalNumberOfInvestments;            // total number of investments\n', '    uint256 public totalEtherInvested;                  // total amount of ethers invested from all investments\n', '\n', '    // details of an Investment\n', '    struct Investment {\n', '        address investAddr;\n', '        uint256 ethAmount;\n', '        bool hasClaimed;\n', '        uint256 principalClaimed;\n', '        uint256 bonusClaimed;\n', '        uint256 claimTime;\n', '    }\n', '\n', '    // mapping investment number to the details of the investment\n', '    mapping(uint256 => Investment) public investments;\n', '\n', '    // mapping investment address to the investment ID of all the investments made by this address\n', '    mapping(address => uint256[]) public investmentIDs;\n', '\n', '    uint256 private unlocked;\n', '\n', '    /*                                                   MODIFIERS                                                    */\n', '    /* ============================================================================================================== */\n', '    modifier lock() {\n', "        require(unlocked == 1, 'Locked');\n", '        unlocked = 0;\n', '        _;\n', '        unlocked = 1;\n', '    }          \n', '\n', '    /*                                                   INITIALIZER                                                  */\n', '    /* ============================================================================================================== */\n', '    function initialize\n', '    (\n', '        address[] calldata _investors,\n', '        uint256[] calldata _ethAmounts,\n', '        ERC20Standard _erc20Token,\n', '        uint256 _withdrawDate,\n', '        uint256 _standardRate,\n', '        uint256 _percentBonus\n', '    )\n', '        external initializer\n', '    {\n', '        Ownable.initialize(_msgSender());\n', '\n', '        // set investments\n', '        addInvestments(_investors, _ethAmounts);\n', '        // set ERC20Token contract variable\n', '        setERC20Token(_erc20Token);\n', '\n', '        // Set withdraw date\n', '        withdrawDate = _withdrawDate;\n', '\n', '        standardRate = _standardRate;\n', '\n', '        // Set percentage bonus\n', '        percentBonus = _percentBonus;\n', '\n', '        //Reentrancy lock\n', '        unlocked = 1;\n', '    }\n', '\n', '    /*                                                      EVENTS                                                    */\n', '    /* ============================================================================================================== */\n', '    event WithDrawn(\n', '        address indexed investor,\n', '        uint256 indexed investmentID,\n', '        uint256 principal,\n', '        uint256 bonus,\n', '        uint256 withdrawTime\n', '    );\n', '\n', '    /*                                                 YIELD FARMING FUNCTIONS                                        */\n', '    /* ============================================================================================================== */\n', '\n', '    /**\n', '     * @notice Withdraw tokens\n', '     * @param investmentID uint256 investment ID of the investment for which the bonus tokens are distributed\n', '     * @return bool true if the withdraw is successful\n', '     */\n', '    function withdraw(uint256 investmentID) external lock returns (bool) {\n', '        require(investments[investmentID].investAddr == msg.sender, "You are not the investor of this investment");\n', '        require(block.timestamp >= withdrawDate, "Can only withdraw after withdraw date");\n', '        require(!investments[investmentID].hasClaimed, "Tokens already withdrawn for this investment");\n', '        require(investments[investmentID].ethAmount > 0, "0 ether in this investment");\n', '\n', '        // get the ether amount of this investment\n', '        uint256 _ethAmount = investments[investmentID].ethAmount;\n', '\n', '        (uint256 _principal, uint256 _bonus, uint256 _principalAndBonus) = calculatePrincipalAndBonus(_ethAmount);\n', '\n', '        _updateWithdraw(investmentID, _principal, _bonus);\n', '\n', '        // transfer tokens to this investor\n', '        require(token.transfer(msg.sender, _principalAndBonus), "Fail to transfer tokens");\n', '\n', '        emit WithDrawn(msg.sender, investmentID, _principal, _bonus, block.timestamp);\n', '        return true;\n', '    }\n', '\n', '    /*                                                 SETTER FUNCTIONS                                               */\n', '    /* ============================================================================================================== */\n', '    /**\n', '     * @dev Add new investments\n', '     * @dev This function can only be carreid out by the owner of this contract.\n', '     */\n', '    function addInvestments(address[] memory _investors, uint256[] memory _ethAmounts) public onlyOwner {\n', '        require(_investors.length == _ethAmounts.length, "The number of investing addresses should equal the number of ether amounts");\n', '        for (uint256 i = 0; i < _investors.length; i++) {\n', '             addInvestment(_investors[i], _ethAmounts[i]); \n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Set ERC20Token contract\n', '     * @dev This function can only be carreid out by the owner of this contract.\n', '     */\n', '    function setERC20Token(ERC20Standard _erc20Token) public onlyOwner {\n', '        token = _erc20Token; \n', '    }\n', '\n', '    /**\n', '     * @dev Set percentage bonus. Percentage bonus is amplified 10**8 times for float precision\n', '     * @dev This function can only be carreid out by the owner of this contract.\n', '     */\n', '    function setPercentBonus(uint256 _percentBonus) public onlyOwner {\n', '        percentBonus = _percentBonus; \n', '    }\n', '\n', '    /**\n', '     * @notice This function transfers tokens out of this contract to a new address\n', '     * @dev This function is used to transfer unclaimed KittieFightToken to a new address,\n', '     *      or transfer other tokens erroneously tranferred to this contract back to their original owner\n', '     * @dev This function can only be carreid out by the owner of this contract.\n', '     */\n', '    function returnTokens(address _token, uint256 _amount, address _newAddress) external onlyOwner {\n', '        require(block.timestamp >= withdrawDate.add(7 * 24 * 60 * 60), "Cannot return any token within 7 days of withdraw date");\n', '        uint256 balance = ERC20Standard(_token).balanceOf(address(this));\n', '        require(_amount <= balance, "Exceeds balance");\n', '        require(ERC20Standard(_token).transfer(_newAddress, _amount), "Fail to transfer tokens");\n', '    }\n', '\n', '    /**\n', '     * @notice Set withdraw date for the token\n', '     * @param _withdrawDate uint256 withdraw date for the token\n', '     * @dev    This function can only be carreid out by the owner of this contract.\n', '     */\n', '    function setWithdrawDate(uint256 _withdrawDate) public onlyOwner {\n', '        withdrawDate = _withdrawDate;\n', '    }\n', '\n', '    /*                                                 GETTER FUNCTIONS                                               */\n', '    /* ============================================================================================================== */\n', '    \n', '    /**\n', '     * @return true and 0 if it is time to withdraw, false and time until withdraw if it is not the time to withdraw yet\n', '     */\n', '    function canWithdraw() public view returns (bool, uint256) {\n', '        if (block.timestamp >= withdrawDate) {\n', '            return (true, 0);\n', '        } else {\n', '            return (false, withdrawDate.sub(block.timestamp));\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @return uint256 bonus tokens calculated for the amount of ether specified\n', '     */\n', '    function calculatePrincipalAndBonus(uint256 _ether)\n', '        public view returns (uint256, uint256, uint256)\n', '    {\n', '        uint256 principal = _ether.mul(standardRate).div(base18);\n', '        uint256 bonus = principal.mul(percentBonus).div(base18);\n', '        uint256 principalAndBonus = principal.add(bonus);\n', '        return (principal, bonus, principalAndBonus);\n', '    }\n', '\n', '    /**\n', '     * @return address an array of the ID of each investment belonging to the investor\n', '     */\n', '    function getInvestmentIDs(address _investAddr) external view returns (uint256[] memory) {\n', '        return investmentIDs[_investAddr];\n', '    }\n', '\n', '    /**\n', '     * @return the details of an investment associated with an investment ID, including the address \n', '     *         of the investor, the amount of ether invested in this investment, whether bonus tokens\n', '     *         have been claimed for this investment, the amount of bonus tokens already claimed for\n', '     *         this investment(0 if bonus tokens are not claimed yet), the unix time when the bonus tokens\n', '     *         have been claimed(0 if bonus tokens are not claimed yet)\n', '     */\n', '    function getInvestment(uint256 _investmentID) external view\n', '        returns(address _investAddr, uint256 _ethAmount, bool _hasClaimed,\n', '                uint256 _principalClaimed, uint256 _bonusClaimed, uint256 _claimTime)\n', '    {\n', '        _investAddr = investments[_investmentID].investAddr;\n', '        _ethAmount = investments[_investmentID].ethAmount;\n', '        _hasClaimed = investments[_investmentID].hasClaimed;\n', '        _principalClaimed = investments[_investmentID].principalClaimed;\n', '        _bonusClaimed = investments[_investmentID].bonusClaimed;\n', '        _claimTime = investments[_investmentID].claimTime;\n', '    }\n', '    \n', '\n', '    /*                                                 PRIVATE FUNCTIONS                                             */\n', '    /* ============================================================================================================== */\n', '    /**\n', '     * @param _investmentID uint256 investment ID of the investment for which tokens are withdrawn\n', '     * @param _bonus uint256 tokens distributed to this investor\n', '     * @dev this function updates the storage upon successful withdraw of tokens.\n', '     */\n', '    function _updateWithdraw(uint256 _investmentID, uint256 _principal, uint256 _bonus) \n', '        private\n', '    {\n', '        investments[_investmentID].hasClaimed = true;\n', '        investments[_investmentID].principalClaimed = _principal;\n', '        investments[_investmentID].bonusClaimed = _bonus;\n', '        investments[_investmentID].claimTime = block.timestamp;\n', '        investments[_investmentID].ethAmount = 0;\n', '    }\n', '\n', '    /**\n', '     * @dev Add one new investment\n', '     */\n', '    function addInvestment(address _investor, uint256 _eth) private {\n', '        uint256 investmentID = totalNumberOfInvestments.add(1);\n', '        investments[investmentID].investAddr = _investor;\n', '        investments[investmentID].ethAmount = _eth;\n', '   \n', '        totalEtherInvested = totalEtherInvested.add(_eth);\n', '        totalNumberOfInvestments = investmentID;\n', '\n', '        investmentIDs[_investor].push(investmentID);\n', '    }\n', '}']