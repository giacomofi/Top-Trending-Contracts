['pragma solidity ^0.5.0;\n', '\n', 'interface IGST2 {\n', '\n', '    function freeUpTo(uint256 value) external returns (uint256 freed);\n', '\n', '    function freeFromUpTo(address from, uint256 value) external returns (uint256 freed);\n', '\n', '    function balanceOf(address who) external view returns (uint256);\n', '}\n', '\n', '\n', '\n', 'library ExternalCall {\n', '    // Source: https://github.com/gnosis/MultiSigWallet/blob/master/contracts/MultiSigWallet.sol\n', '    // call has been separated into its own function in order to take advantage\n', "    // of the Solidity's code generator to produce a loop that copies tx.data into memory.\n", '    function externalCall(address destination, uint value, bytes memory data, uint dataOffset, uint dataLength) internal returns(bool result) {\n', '        // solium-disable-next-line security/no-inline-assembly\n', '        assembly {\n', '            let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)\n', '            let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that\n', '            result := call(\n', '                sub(gas, 34710),   // 34710 is the value that solidity is currently emitting\n', '                                   // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +\n', '                                   // callNewAccountGas (25000, in case the destination address does not exist and needs creating)\n', '                destination,\n', '                value,\n', '                add(d, dataOffset),\n', '                dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem\n', '                x,\n', '                0                  // Output is ignored, therefore the output size is zero\n', '            )\n', '        }\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://eips.ethereum.org/EIPS/eip-20\n', ' */\n', 'interface IERC20 {\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address who) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Unsigned math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Multiplies two unsigned integers, reverts on overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Adds two unsigned integers, reverts on overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '     * reverts when dividing by zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * Utility library of inline functions on addresses\n', ' */\n', 'library Address {\n', '    /**\n', '     * Returns whether the target address is a contract\n', '     * @dev This function will return false if invoked during the constructor of a contract,\n', '     * as the code is not actually created until after the constructor finishes.\n', '     * @param account address of the account to check\n', '     * @return whether the target address is a contract\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        uint256 size;\n', '        // XXX Currently there is no better way to check if there is a contract in an address\n', '        // than to check the size of the code at that address.\n', '        // See https://ethereum.stackexchange.com/a/14016/36603\n', '        // for more details about how this works.\n', '        // TODO Check this again before the Serenity release, because all addresses will be\n', '        // contracts then.\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor () internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @return the address of the owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner());\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @return true if `msg.sender` is the owner of the contract.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to relinquish control of the contract.\n', '     * It will not be possible to call the functions with the `onlyOwner`\n', '     * modifier anymore.\n', '     * @notice Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure (when the token\n', ' * contract returns false). Tokens that return no value (and instead revert or\n', ' * throw on failure) are also supported, non-reverting calls are assumed to be\n', ' * successful.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        require((value == 0) || (token.allowance(address(this), spender) == 0));\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value);\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must equal true).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves.\n", '\n', '        // A Solidity high level call has three parts:\n', '        //  1. The target address is checked to verify it contains contract code\n', '        //  2. The call itself is made, and success asserted\n', '        //  3. The return value is decoded, which in turn checks the size of the returned data.\n', '\n', '        require(address(token).isContract());\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success);\n', '\n', '        if (returndata.length > 0) { // Return data is optional\n', '            require(abi.decode(returndata, (bool)));\n', '        }\n', '    }\n', '}\n', '\n', '\n', '\n', 'contract IWETH is IERC20 {\n', '\n', '    function deposit() external payable;\n', '\n', '    function withdraw(uint256 amount) external;\n', '}\n', '\n', '\n', '\n', 'contract TokenSpender is Ownable {\n', '\n', '    using SafeERC20 for IERC20;\n', '\n', '    function claimTokens(IERC20 token, address who, address dest, uint256 amount) external onlyOwner {\n', '        token.safeTransferFrom(who, dest, amount);\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract AggregatedTokenSwap {\n', '\n', '    using SafeERC20 for IERC20;\n', '    using SafeMath for uint;\n', '    using ExternalCall for address;\n', '\n', '    address constant ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;\n', '\n', '    TokenSpender public spender;\n', '    IGST2 gasToken;\n', '    address payable owner;\n', '    uint fee; // 10000 => 100%, 1 => 0.01%\n', '\n', '    event OneInchFeePaid(\n', '        IERC20 indexed toToken,\n', '        address indexed referrer,\n', '        uint256 fee\n', '    );\n', '\n', '    modifier onlyOwner {\n', '        require(\n', '            msg.sender == owner,\n', '            "Only owner can call this function."\n', '        );\n', '        _;\n', '    }\n', '\n', '    constructor(\n', '        address payable _owner,\n', '        IGST2 _gasToken,\n', '        uint _fee\n', '    )\n', '    public\n', '    {\n', '        spender = new TokenSpender();\n', '        owner = _owner;\n', '        gasToken = _gasToken;\n', '        fee = _fee;\n', '    }\n', '\n', '    function setFee(uint _fee) public onlyOwner {\n', '\n', '        fee = _fee;\n', '    }\n', '\n', '    function aggregate(\n', '        IERC20 fromToken,\n', '        IERC20 toToken,\n', '        uint tokensAmount,\n', '        address[] memory callAddresses,\n', '        bytes memory callDataConcat,\n', '        uint[] memory starts,\n', '        uint[] memory values,\n', '        uint mintGasPrice,\n', '        uint minTokensAmount,\n', '        address payable referrer\n', '    )\n', '    public\n', '    payable\n', '    returns (uint returnAmount)\n', '    {\n', '        returnAmount = gasleft();\n', '        uint gasTokenBalance = gasToken.balanceOf(address(this));\n', '\n', '        require(callAddresses.length + 1 == starts.length);\n', '\n', '        if (address(fromToken) != ETH_ADDRESS) {\n', '\n', '            spender.claimTokens(fromToken, msg.sender, address(this), tokensAmount);\n', '        }\n', '\n', '        for (uint i = 0; i < starts.length - 1; i++) {\n', '\n', '            if (starts[i + 1] - starts[i] > 0) {\n', '\n', '                require(\n', '                    callDataConcat[starts[i] + 0] != spender.claimTokens.selector[0] ||\n', '                    callDataConcat[starts[i] + 1] != spender.claimTokens.selector[1] ||\n', '                    callDataConcat[starts[i] + 2] != spender.claimTokens.selector[2] ||\n', '                    callDataConcat[starts[i] + 3] != spender.claimTokens.selector[3]\n', '                );\n', '                require(callAddresses[i].externalCall(values[i], callDataConcat, starts[i], starts[i + 1] - starts[i]));\n', '            }\n', '        }\n', '\n', '        if (address(toToken) == ETH_ADDRESS) {\n', '            require(address(this).balance >= minTokensAmount);\n', '        } else {\n', '            require(toToken.balanceOf(address(this)) >= minTokensAmount);\n', '        }\n', '\n', '        //\n', '\n', '        require(gasTokenBalance == gasToken.balanceOf(address(this)));\n', '        if (mintGasPrice > 0) {\n', '            audoRefundGas(returnAmount, mintGasPrice);\n', '        }\n', '\n', '        //\n', '\n', '        returnAmount = _balanceOf(toToken, address(this)) * fee / 10000;\n', '        if (referrer != address(0)) {\n', '            returnAmount /= 2;\n', '            if (!_transfer(toToken, referrer, returnAmount, true)) {\n', '                returnAmount *= 2;\n', '                emit OneInchFeePaid(toToken, address(0), returnAmount);\n', '            } else {\n', '                emit OneInchFeePaid(toToken, referrer, returnAmount / 2);\n', '            }\n', '        }\n', '\n', '        _transfer(toToken, owner, returnAmount, false);\n', '\n', '        returnAmount = _balanceOf(toToken, address(this));\n', '        _transfer(toToken, msg.sender, returnAmount, false);\n', '    }\n', '\n', '    function infiniteApproveIfNeeded(IERC20 token, address to) external {\n', '        if (\n', '            address(token) != ETH_ADDRESS &&\n', '            token.allowance(address(this), to) == 0\n', '        ) {\n', '            token.safeApprove(to, uint256(-1));\n', '        }\n', '    }\n', '\n', '    function withdrawAllToken(IWETH token) external {\n', '        uint256 amount = token.balanceOf(address(this));\n', '        token.withdraw(amount);\n', '    }\n', '\n', '    function _balanceOf(IERC20 token, address who) internal view returns(uint256) {\n', '        if (address(token) == ETH_ADDRESS || token == IERC20(0)) {\n', '            return who.balance;\n', '        } else {\n', '            return token.balanceOf(who);\n', '        }\n', '    }\n', '\n', '    function _transfer(IERC20 token, address payable to, uint256 amount, bool allowFail) internal returns(bool) {\n', '        if (address(token) == ETH_ADDRESS || token == IERC20(0)) {\n', '            if (allowFail) {\n', '                return to.send(amount);\n', '            } else {\n', '                to.transfer(amount);\n', '                return true;\n', '            }\n', '        } else {\n', '            token.safeTransfer(to, amount);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    function audoRefundGas(\n', '        uint startGas,\n', '        uint mintGasPrice\n', '    )\n', '    private\n', '    returns (uint freed)\n', '    {\n', '        uint MINT_BASE = 32254;\n', '        uint MINT_TOKEN = 36543;\n', '        uint FREE_BASE = 14154;\n', '        uint FREE_TOKEN = 6870;\n', '        uint REIMBURSE = 24000;\n', '\n', '        uint tokensAmount = ((startGas - gasleft()) + FREE_BASE) / (2 * REIMBURSE - FREE_TOKEN);\n', '        uint maxReimburse = tokensAmount * REIMBURSE;\n', '\n', '        uint mintCost = MINT_BASE + (tokensAmount * MINT_TOKEN);\n', '        uint freeCost = FREE_BASE + (tokensAmount * FREE_TOKEN);\n', '\n', '        uint efficiency = (maxReimburse * 100 * tx.gasprice) / (mintCost * mintGasPrice + freeCost * tx.gasprice);\n', '\n', '        if (efficiency > 100) {\n', '\n', '            return refundGas(\n', '                tokensAmount\n', '            );\n', '        } else {\n', '\n', '            return 0;\n', '        }\n', '    }\n', '\n', '    function refundGas(\n', '        uint tokensAmount\n', '    )\n', '    private\n', '    returns (uint freed)\n', '    {\n', '\n', '        if (tokensAmount > 0) {\n', '\n', '            uint safeNumTokens = 0;\n', '            uint gas = gasleft();\n', '\n', '            if (gas >= 27710) {\n', '                safeNumTokens = (gas - 27710) / (1148 + 5722 + 150);\n', '            }\n', '\n', '            if (tokensAmount > safeNumTokens) {\n', '                tokensAmount = safeNumTokens;\n', '            }\n', '\n', '            uint gasTokenBalance = IERC20(address(gasToken)).balanceOf(address(this));\n', '\n', '            if (tokensAmount > 0 && gasTokenBalance >= tokensAmount) {\n', '\n', '                return gasToken.freeUpTo(tokensAmount);\n', '            } else {\n', '\n', '                return 0;\n', '            }\n', '        } else {\n', '\n', '            return 0;\n', '        }\n', '    }\n', '\n', '    function() external payable {\n', '\n', '        if (msg.value == 0 && msg.sender == owner) {\n', '\n', '            IERC20 _gasToken = IERC20(address(gasToken));\n', '\n', '            owner.transfer(address(this).balance);\n', '            _gasToken.safeTransfer(owner, _gasToken.balanceOf(address(this)));\n', '        }\n', '    }\n', '}\n']