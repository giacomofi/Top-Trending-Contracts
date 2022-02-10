['// SPDX-License-Identifier: GPL-3.0-or-later\n', 'pragma solidity 0.6.12;\n', '\n', 'import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";\n', 'import {SafeMath} from "@openzeppelin/contracts/math/SafeMath.sol";\n', '\n', 'import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', 'import {IAmpleforth} from "uFragments/contracts/interfaces/IAmpleforth.sol";\n', 'import {ITokenVault} from "../../_interfaces/ITokenVault.sol";\n', 'import {IBridgeGateway} from "../../_interfaces/IBridgeGateway.sol";\n', '\n', '/**\n', ' * @title AMPLChainBridgeGateway: AMPL-ChainBridge Gateway Contract\n', ' * @dev This contract is deployed on the base chain (Ethereum).\n', ' *\n', " *      It's a pass-through contract between the ChainBridge handler contract and\n", ' *      the Ampleforth policy and the Token vault.\n', ' *\n', ' *      The contract is owned by the ChainBridge handler contract.\n', ' *\n', ' *      When rebase is transmitted across the bridge, It checks the consistency of rebase data\n', ' *      from the ChainBridge handler contract with the recorded on-chain value.\n', ' *\n', ' *      When a sender initiates a cross-chain AMPL transfer from the\n', ' *      current chain (source chain) to a target chain through chain-bridge,\n', ' *      `validateAndLock` is executed.\n', ' *      It validates if total supply reported is consistent with the\n', ' *      recorded on-chain value and locks AMPLS in a token vault.\n', ' *\n', ' *      When a sender has initiated a cross-chain AMPL transfer from a source chain\n', ' *      to a recipient on the current chain (target chain),\n', ' *      chain-bridge executes the `unlock` function.\n', ' *      The amount of tokens to be unlocked to the recipient is calculated based on\n', ' *      the globalAMPLSupply on the source chain, at the time of transfer initiation\n', ' *      and the total ERC-20 AMPL supply on the current chain, at the time of unlock.\n', ' *\n', ' */\n', 'contract AMPLChainBridgeGateway is IBridgeGateway, Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    address public immutable ampl;\n', '    address public immutable policy;\n', '    address public immutable vault;\n', '\n', '    /**\n', '     * @dev Validates if the data from the handler is consistent with the\n', '     *      recorded value on the current chain.\n', '     * @param globalAmpleforthEpoch Ampleforth monetary policy epoch.\n', '     * @param globalAMPLSupply AMPL ERC-20 total supply.\n', '     */\n', '    function validateRebaseReport(uint256 globalAmpleforthEpoch, uint256 globalAMPLSupply)\n', '        external\n', '        onlyOwner\n', '    {\n', '        uint256 recordedGlobalAmpleforthEpoch = IAmpleforth(policy).epoch();\n', '        uint256 recordedGlobalAMPLSupply = IERC20(ampl).totalSupply();\n', '\n', '        require(\n', '            globalAmpleforthEpoch == recordedGlobalAmpleforthEpoch,\n', '            "AMPLChainBridgeGateway: epoch not consistent"\n', '        );\n', '        require(\n', '            globalAMPLSupply == recordedGlobalAMPLSupply,\n', '            "AMPLChainBridgeGateway: total supply not consistent"\n', '        );\n', '\n', '        emit XCRebaseReportOut(globalAmpleforthEpoch, globalAMPLSupply);\n', '    }\n', '\n', '    /**\n', '     * @dev Validates the data from the handler and transfers specified amount from\n', "     *      the sender's wallet and locks it in the vault contract.\n", '     * @param sender Address of the sender wallet on the base chain.\n', '     * @param recipientAddressInTargetChain Address of the recipient wallet in the target chain.\n', '     * @param amount Amount of tokens to be locked on the current chain (source chain).\n', '     * @param globalAMPLSupply AMPL ERC-20 total supply at the time of transfer locking.\n', '     */\n', '    function validateAndLock(\n', '        address sender,\n', '        address recipientAddressInTargetChain,\n', '        uint256 amount,\n', '        uint256 globalAMPLSupply\n', '    ) external onlyOwner {\n', '        uint256 recordedGlobalAMPLSupply = IERC20(ampl).totalSupply();\n', '\n', '        require(\n', '            globalAMPLSupply == recordedGlobalAMPLSupply,\n', '            "AMPLChainBridgeGateway: total supply not consistent"\n', '        );\n', '\n', '        ITokenVault(vault).lock(ampl, sender, amount);\n', '\n', '        emit XCTransferOut(sender, amount, recordedGlobalAMPLSupply);\n', '    }\n', '\n', '    /**\n', '     * @dev Calculates the amount of amples to be unlocked based on the share of total supply and\n', '     *      transfers it to the recipient.\n', '     * @param senderAddressInSourceChain Address of the sender wallet in the transaction originating chain.\n', '     * @param recipient Address of the recipient wallet in the current chain (target chain).\n', '     * @param amount Amount of tokens that were {locked/burnt} on the base chain.\n', '     * @param globalAMPLSupply AMPL ERC-20 total supply at the time of transfer.\n', '     */\n', '    function unlock(\n', '        address senderAddressInSourceChain,\n', '        address recipient,\n', '        uint256 amount,\n', '        uint256 globalAMPLSupply\n', '    ) external onlyOwner {\n', '        uint256 recordedGlobalAMPLSupply = IERC20(ampl).totalSupply();\n', '        uint256 unlockAmount = amount.mul(recordedGlobalAMPLSupply).div(globalAMPLSupply);\n', '\n', '        emit XCTransferIn(recipient, globalAMPLSupply, unlockAmount, recordedGlobalAMPLSupply);\n', '\n', '        ITokenVault(vault).unlock(ampl, recipient, unlockAmount);\n', '    }\n', '\n', '    constructor(\n', '        address bridgeHandler,\n', '        address ampl_,\n', '        address policy_,\n', '        address vault_\n', '    ) public {\n', '        ampl = ampl_;\n', '        policy = policy_;\n', '        vault = vault_;\n', '\n', '        transferOwnership(bridgeHandler);\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'import "../GSN/Context.sol";\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// pragma solidity ^0.4.24;\n', '\n', '// Public interface definition for the Ampleforth supply policy on Ethereum (the base-chain)\n', 'interface IAmpleforth {\n', '    function epoch() external view returns (uint256);\n', '\n', '    function lastRebaseTimestampSec() external view returns (uint256);\n', '\n', '    function inRebaseWindow() external view returns (bool);\n', '\n', '    function globalAmpleforthEpochAndAMPLSupply() external view returns (uint256, uint256);\n', '}\n', '\n', '// SPDX-License-Identifier: GPL-3.0-or-later\n', 'pragma solidity 0.6.12;\n', '\n', 'interface ITokenVault {\n', '    function lock(\n', '        address token,\n', '        address depositor,\n', '        uint256 amount\n', '    ) external;\n', '\n', '    function unlock(\n', '        address token,\n', '        address recipient,\n', '        uint256 amount\n', '    ) external;\n', '}\n', '\n', '// SPDX-License-Identifier: GPL-3.0-or-later\n', 'pragma solidity 0.6.12;\n', '\n', '/*\n', '    INTERFACE NAMING CONVENTION:\n', '\n', '    Base Chain: Ethereum; chain where actual AMPL tokens are locked/unlocked\n', '    Satellite Chain: (tron, acala, ..); chain where xc-ample tokens are mint/burnt\n', '\n', '    Source chain: Chain where a cross-chain transaction is initiated. (any chain ethereum, tron, acala ...)\n', '    Target chain: Chain where a cross-chain transaction is finalized. (any chain ethereum, tron, acala ...)\n', '\n', '    If a variable is prefixed with recorded: It refers to the existing value on the current-chain.\n', '    eg) When rebase is reported to tron through a bridge, globalAMPLSupply is the new value\n', '    reported through the bridge and recordedGlobalAMPLSupply refers to the current value on tron.\n', '\n', '    On the Base chain:\n', '    * ampl.totalSupply is the globalAMPLSupply.\n', '\n', '    On Satellite chains:\n', '    * xcAmple.totalSupply returns the current supply of xc-amples in circulation\n', "    * xcAmple.globalAMPLSupply returns the chain's copy of the base chain's globalAMPLSupply.\n", '*/\n', '\n', 'interface IBridgeGateway {\n', '    // Logged on the base chain gateway (ethereum) when rebase report is propagated out\n', '    event XCRebaseReportOut(\n', '        uint256 globalAmpleforthEpoch, // epoch from the Ampleforth Monetary Policy on the base chain\n', '        uint256 globalAMPLSupply // totalSupply of AMPL ERC-20 contract on the base chain\n', '    );\n', '\n', '    // Logged on the satellite chain gateway (tron, acala, near) when bridge reports most recent rebase\n', '    event XCRebaseReportIn(\n', '        uint256 globalAmpleforthEpoch, // new value coming in from the base chain\n', '        uint256 globalAMPLSupply, // new value coming in from the base chain\n', '        uint256 recordedGlobalAmpleforthEpoch, // existing value on the satellite chain\n', '        uint256 recordedGlobalAMPLSupply // existing value on the satellite chain\n', '    );\n', '\n', '    // Logged on source chain when cross-chain transfer is initiated\n', '    event XCTransferOut(\n', '        address sender, // user sending funds\n', '        uint256 amount, // amount to be locked/burnt\n', '        uint256 recordedGlobalAMPLSupply // existing value on the current source chain\n', '    );\n', '\n', '    // Logged on target chain when cross-chain transfer is completed\n', '    event XCTransferIn(\n', '        address recipient, // user receiving funds\n', '        uint256 globalAMPLSupply, // value on remote chain when transaction was initiated\n', '        uint256 amount, // amount to be unlocked/mint\n', '        uint256 recordedGlobalAMPLSupply // existing value on the current target chain\n', '    );\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 200\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "libraries": {}\n', '}']