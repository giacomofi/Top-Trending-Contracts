['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-04\n', '*/\n', '\n', '// File: @openzeppelin/contracts/math/SafeMath.sol\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', 'library SafeMath {\n', '    \n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    \n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    \n', '    function sub(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    \n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    \n', '    function div(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP. Does not include\n', ' * the optional functions; to access them see {ERC20Detailed}.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount)\n', '        external\n', '        returns (bool);\n', '\n', '    function mint(address account, uint amount) external;\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender)\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    );\n', '}\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    \n', '    event OwnershipRenounced(address indexed previousOwner);\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    \n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    function renounceOwnership() public onlyOwner {\n', '        owner = address(0);\n', '    }\n', '    \n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        _transferOwnership(_newOwner);\n', '    }\n', '    \n', '    function _transferOwnership(address _newOwner) internal {\n', '        require(_newOwner != address(0));\n', '        emit OwnershipTransferred(owner, _newOwner);\n', '        owner = _newOwner;\n', '    }\n', '}\n', '\n', '\n', '// File: @openzeppelin/contracts/utils/Address.sol\n', '\n', 'pragma solidity ^0.5.5;\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * This test is non-exhaustive, and there may be false-negatives: during the\n', "     * execution of a contract's constructor, its address will be reported as\n", '     * not containing a contract.\n', '     *\n', '     * IMPORTANT: It is unsafe to assume that an address for which this\n', '     * function returns false is an externally-owned account (EOA) and not a\n', '     * contract.\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies in extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', "        // for accounts without code, i.e. `keccak256('')`\n", '        bytes32 codehash;\n', '\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly {\n', '            codehash := extcodehash(account)\n', '        }\n', '        return (codehash != 0x0 && codehash != accountHash);\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure (when the token\n', ' * contract returns false). Tokens that return no value (and instead revert or\n', ' * throw on failure) are also supported, non-reverting calls are assumed to be\n', ' * successful.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(\n', '        IERC20 token,\n', '        address to,\n', '        uint256 value\n', '    ) internal {\n', '        callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(token.transfer.selector, to, value)\n', '        );\n', '    }\n', '\n', '    function safeTransferFrom(\n', '        IERC20 token,\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    ) internal {\n', '        callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)\n', '        );\n', '    }\n', '\n', '    function safeApprove(\n', '        IERC20 token,\n', '        address spender,\n', '        uint256 value\n', '    ) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require(\n', '            (value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(token.approve.selector, spender, value)\n', '        );\n', '    }\n', '\n', '    function safeIncreaseAllowance(\n', '        IERC20 token,\n', '        address spender,\n', '        uint256 value\n', '    ) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(\n', '            value\n', '        );\n', '        callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(\n', '                token.approve.selector,\n', '                spender,\n', '                newAllowance\n', '            )\n', '        );\n', '    }\n', '\n', '    function safeDecreaseAllowance(\n', '        IERC20 token,\n', '        address spender,\n', '        uint256 value\n', '    ) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(\n', '            value,\n', '            "SafeERC20: decreased allowance below zero"\n', '        );\n', '        callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(\n', '                token.approve.selector,\n', '                spender,\n', '                newAllowance\n', '            )\n', '        );\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves.\n", '\n', '        // A Solidity high level call has three parts:\n', '        //  1. The target address is checked to verify it contains contract code\n', '        //  2. The call itself is made, and success asserted\n', '        //  3. The return value is decoded, which in turn checks the size of the returned data.\n', '        // solhint-disable-next-line max-line-length\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) {\n', '            // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(\n', '                abi.decode(returndata, (bool)),\n', '                "SafeERC20: ERC20 operation did not succeed"\n', '            );\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'contract Bridge is Ownable{\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for IERC20;\n', '    \n', '    event Send2Bridge(address indexed user, uint256 amount);\n', '    event Send2User(address indexed user, uint256 amount, string hash);\n', '    event WithdrawTops(address indexed toAddress, uint256 amount);\n', '    \n', '    IERC20 public tops = IERC20(0xF5a04b9E798892e96dE68733AD8FFedDa39B7E5A);\n', '    mapping(string => bool) public records;\n', '    uint256 public limit = 5000000000;\n', '    \n', '    function send2Bridge(uint256 amount) public {\n', '        require(amount >= limit, "amount must greater than limit");\n', '        tops.safeTransferFrom(msg.sender, address(this), amount);\n', '        emit Send2Bridge(msg.sender, amount);\n', '    }\n', '    \n', '    function setLimit(uint256 newLimit) public onlyOwner{\n', '        limit = newLimit;\n', '    }\n', '    \n', '    function send2User(address user, uint256 amount, string memory hash) public onlyOwner {\n', '        if(!records[hash]){\n', '            tops.safeTransfer(user, amount);\n', '            emit Send2User(user, amount, hash);\n', '            records[hash] = true;\n', '        }\n', '    }\n', '    \n', '    function withdrawTops(address toAddress) public onlyOwner{\n', '        uint256 balance = tops.balanceOf(address(this));\n', '        tops.safeTransfer(toAddress, balance);\n', '        emit WithdrawTops(toAddress, balance);\n', '        \n', '    }\n', '}']