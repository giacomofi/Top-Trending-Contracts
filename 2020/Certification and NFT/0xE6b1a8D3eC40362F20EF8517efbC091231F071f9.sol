['pragma solidity ^0.5.5;\n', '\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    \n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'contract IERC20 {\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function totalSupply() external view returns (uint256);    \n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '}\n', '\n', '\n', 'pragma solidity ^0.5.5;\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * This test is non-exhaustive, and there may be false-negatives: during the\n', "     * execution of a contract's constructor, its address will be reported as\n", '     * not containing a contract.\n', '     *\n', '     * IMPORTANT: It is unsafe to assume that an address for which this\n', '     * function returns false is an externally-owned account (EOA) and not a\n', '     * contract.\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies in extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', "        // for accounts without code, i.e. `keccak256('')`\n", '        bytes32 codehash;\n', '\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly {\n', '            codehash := extcodehash(account)\n', '        }\n', '        return (codehash != 0x0 && codehash != accountHash);\n', '    }\n', '\n', '     /**\n', '     * @dev Converts an `address` into `address payable`. Note that this is\n', '     * simply a type cast: the actual underlying value is not changed.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function toPayable(address account)\n', '        internal\n', '        pure\n', '        returns (address payable)\n', '    {\n', '        return address(uint160(account));\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol\n', '\n', 'pragma solidity ^0.5.5;\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure (when the token\n', ' * contract returns false). Tokens that return no value (and instead revert or\n', ' * throw on failure) are also supported, non-reverting calls are assumed to be\n', ' * successful.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(\n', '        IERC20 token,\n', '        address to,\n', '        uint256 value\n', '    ) internal {\n', '        callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(token.transfer.selector, to, value)\n', '        );\n', '    }\n', '\n', '    function safeTransferFrom(\n', '        IERC20 token,\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    ) internal {\n', '        callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)\n', '        );\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves.\n", '\n', '        // A Solidity high level call has three parts:\n', '        //  1. The target address is checked to verify it contains contract code\n', '        //  2. The call itself is made, and success asserted\n', '        //  3. The return value is decoded, which in turn checks the size of the returned data.\n', '        // solhint-disable-next-line max-line-length\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) {\n', '            // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(\n', '                abi.decode(returndata, (bool)),\n', '                "SafeERC20: ERC20 operation did not succeed"\n', '            );\n', '        }\n', '    }\n', '}\n', '\n', 'contract PublicFunds is Ownable {\n', '    \n', '  using Address for address;\n', '  using SafeMath for uint256;\n', '  using SafeERC20 for IERC20;\n', '\n', '  IERC20 TOPS = IERC20(0xF5a04b9E798892e96dE68733AD8FFedDa39B7E5A);\n', '\n', '  mapping (address => uint256) public exchanged;\n', '  uint256 public LIMIT = 50000 * 10 ** 8;\n', '  uint256 public totalSupply;\n', '  uint256 public issued;\n', '\n', '  uint256 public rate;\n', '  uint256 public periodStart;\n', '  address public bank;\n', '\n', '  constructor (address _bank, uint256 total, uint256 _rate, uint256 startTimestamp) public {\n', '      bank = _bank;\n', '      totalSupply = total;\n', '      rate = _rate;\n', '      issued = 0;\n', '      periodStart = startTimestamp;\n', '  }\n', '\n', '\n', '  function() external payable{\n', '      exchange();\n', '  }\n', '\n', '  modifier checkStart() {\n', '    require(block.timestamp >= periodStart, "Not started!");\n', '    _;\n', '  }\n', '\n', '  function exchange() public checkStart payable {\n', "    //div(10 ** 10) because ETH's decimals is 18, and the TOPS's decimals is 8;\n", '    uint256 tops = msg.value.mul(rate).div(10 ** 10);\n', '    // check issued over\n', '    require(issued.add(tops) <= totalSupply, "TOPS is insufficient"); \n', '    // check address limit\n', '    require(exchanged[msg.sender].add(tops) <= LIMIT, "Limit 50000 TOPS per address!");\n', '\n', '    TOPS.safeTransferFrom(bank, msg.sender, tops);\n', '    issued = issued.add(tops);\n', '    exchanged[msg.sender] = exchanged[msg.sender].add(tops);\n', '    emit Exchange(msg.sender, msg.value, tops);\n', '  }\n', '\n', '  function withdraw(address to) public onlyOwner{\n', '      uint256 balance = address(this).balance;\n', '      address(to).toPayable().transfer(balance);\n', '      emit Withdraw(to, balance);\n', '  }\n', '\n', '  event Exchange(address indexed from, uint256 eth, uint256 tops);\n', '  event Withdraw(address indexed to, uint256 eth);\n', '}']