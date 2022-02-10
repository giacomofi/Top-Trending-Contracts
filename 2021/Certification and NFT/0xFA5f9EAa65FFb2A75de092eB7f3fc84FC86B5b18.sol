['/*\n', '░█████╗░██████╗░██╗░░░██╗░██████╗░██████╗\u2003\u2003███████╗██╗███╗░░██╗░█████╗░███╗░░██╗░█████╗░███████╗\n', '██╔══██╗██╔══██╗╚██╗░██╔╝██╔════╝██╔════╝\u2003\u2003██╔════╝██║████╗░██║██╔══██╗████╗░██║██╔══██╗██╔════╝\n', '███████║██████╦╝░╚████╔╝░╚█████╗░╚█████╗░\u2003\u2003█████╗░░██║██╔██╗██║███████║██╔██╗██║██║░░╚═╝█████╗░░\n', '██╔══██║██╔══██╗░░╚██╔╝░░░╚═══██╗░╚═══██╗\u2003\u2003██╔══╝░░██║██║╚████║██╔══██║██║╚████║██║░░██╗██╔══╝░░\n', '██║░░██║██████╦╝░░░██║░░░██████╔╝██████╔╝\u2003\u2003██║░░░░░██║██║░╚███║██║░░██║██║░╚███║╚█████╔╝███████╗\n', '╚═╝░░╚═╝╚═════╝░░░░╚═╝░░░╚═════╝░╚═════╝░\u2003\u2003╚═╝░░░░░╚═╝╚═╝░░╚══╝╚═╝░░╚═╝╚═╝░░╚══╝░╚════╝░╚══════╝\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "@openzeppelin/contracts/access/Ownable.sol";\n', 'import "@openzeppelin/contracts/utils/Pausable.sol";\n', 'import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";\n', 'import "../contracts/interfaces/IDepositContract.sol";\n', '\n', 'contract AbyssEth2Depositor is ReentrancyGuard, Pausable, Ownable {\n', '\n', '    /**\n', '     * @dev Eth2 Deposit Contract address.\n', '     */\n', '    IDepositContract public depositContract;\n', '\n', '    /**\n', '     * @dev Minimal and maximum amount of nodes per transaction.\n', '     */\n', '    uint256 public constant nodesMinAmount = 1;\n', '    uint256 public constant nodesMaxAmount = 100;\n', '    uint256 public constant pubkeyLength = 48;\n', '    uint256 public constant credentialsLength = 32;\n', '    uint256 public constant signatureLength = 96;\n', '\n', '    /**\n', '     * @dev Collateral size of one node.\n', '     */\n', '    uint256 public constant collateral = 32 ether;\n', '\n', '    /**\n', '     * @dev Setting Eth2 Smart Contract address during construction.\n', '     */\n', '    constructor(bool mainnet, address depositContract_) {\n', '        if (mainnet == true) {\n', '            depositContract = IDepositContract(0x00000000219ab540356cBB839Cbe05303d7705Fa);\n', '        } else if (depositContract_ == 0x0000000000000000000000000000000000000000) {\n', '            depositContract = IDepositContract(0x8c5fecdC472E27Bc447696F431E425D02dd46a8c);\n', '        } else {\n', '            depositContract = IDepositContract(depositContract_);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev This contract will not accept direct ETH transactions.\n', '     */\n', '    receive() external payable {\n', '        revert("AbyssEth2Depositor: do not send ETH directly here");\n', '    }\n', '\n', '    /**\n', '     * @dev Function that allows to deposit up to 100 nodes at once.\n', '     *\n', '     * - pubkeys                - Array of BLS12-381 public keys.\n', '     * - withdrawal_credentials - Array of commitments to a public keys for withdrawals.\n', '     * - signatures             - Array of BLS12-381 signatures.\n', '     * - deposit_data_roots     - Array of the SHA-256 hashes of the SSZ-encoded DepositData objects.\n', '     */\n', '    function deposit(\n', '        bytes[] calldata pubkeys,\n', '        bytes[] calldata withdrawal_credentials,\n', '        bytes[] calldata signatures,\n', '        bytes32[] calldata deposit_data_roots\n', '    ) external payable whenNotPaused {\n', '\n', '        uint256 nodesAmount = pubkeys.length;\n', '\n', '        require(nodesAmount > 0 && nodesAmount <= 100, "AbyssEth2Depositor: you can deposit only 1 to 100 nodes per transaction");\n', '        require(msg.value == collateral * nodesAmount, "AbyssEth2Depositor: the amount of ETH does not match the amount of nodes");\n', '\n', '\n', '        require(\n', '            withdrawal_credentials.length == nodesAmount &&\n', '            signatures.length == nodesAmount &&\n', '            deposit_data_roots.length == nodesAmount,\n', '            "AbyssEth2Depositor: amount of parameters do no match");\n', '\n', '        for (uint256 i = 0; i < nodesAmount; ++i) {\n', '            require(pubkeys[i].length == pubkeyLength, "AbyssEth2Depositor: wrong pubkey");\n', '            require(withdrawal_credentials[i].length == credentialsLength, "AbyssEth2Depositor: wrong withdrawal credentials");\n', '            require(signatures[i].length == signatureLength, "AbyssEth2Depositor: wrong signatures");\n', '\n', '            IDepositContract(address(depositContract)).deposit{value: collateral}(\n', '                pubkeys[i],\n', '                withdrawal_credentials[i],\n', '                signatures[i],\n', '                deposit_data_roots[i]\n', '            );\n', '\n', '        }\n', '\n', '        emit DepositEvent(msg.sender, nodesAmount);\n', '    }\n', '\n', '    /**\n', '     * @dev Triggers stopped state.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must not be paused.\n', '     */\n', '    function pause() public onlyOwner {\n', '      _pause();\n', '    }\n', '\n', '    /**\n', '     * @dev Returns to normal state.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must be paused.\n', '     */\n', '    function unpause() public onlyOwner {\n', '      _unpause();\n', '    }\n', '\n', '    event DepositEvent(address from, uint256 nodesAmount);\n', '}\n', '\n', '// SPDX-License-Identifier: CC0-1.0\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '// This interface is designed to be compatible with the Vyper version.\n', '/// @notice This is the Ethereum 2.0 deposit contract interface.\n', '/// For more information see the Phase 0 specification under https://github.com/ethereum/eth2.0-specs\n', 'interface IDepositContract {\n', '    /// @notice A processed deposit event.\n', '    event DepositEvent(\n', '        bytes pubkey,\n', '        bytes withdrawal_credentials,\n', '        bytes amount,\n', '        bytes signature,\n', '        bytes index\n', '    );\n', '\n', '    /// @notice Submit a Phase 0 DepositData object.\n', '    /// @param pubkey A BLS12-381 public key.\n', '    /// @param withdrawal_credentials Commitment to a public key for withdrawals.\n', '    /// @param signature A BLS12-381 signature.\n', '    /// @param deposit_data_root The SHA-256 hash of the SSZ-encoded DepositData object.\n', '    /// Used as a protection against malformed input.\n', '    function deposit(\n', '        bytes calldata pubkey,\n', '        bytes calldata withdrawal_credentials,\n', '        bytes calldata signature,\n', '        bytes32 deposit_data_root\n', '    ) external payable;\n', '\n', '    /// @notice Query the current deposit root hash.\n', '    /// @return The deposit root hash.\n', '    function get_deposit_root() external view returns (bytes32);\n', '\n', '    /// @notice Query the current deposit count.\n', '    /// @return The deposit count encoded as a little endian 64-bit number.\n', '    function get_deposit_count() external view returns (bytes memory);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "../utils/Context.sol";\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'abstract contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view virtual returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(owner() == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes calldata) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "./Context.sol";\n', '\n', '/**\n', ' * @dev Contract module which allows children to implement an emergency stop\n', ' * mechanism that can be triggered by an authorized account.\n', ' *\n', ' * This module is used through inheritance. It will make available the\n', ' * modifiers `whenNotPaused` and `whenPaused`, which can be applied to\n', ' * the functions of your contract. Note that they will not be pausable by\n', ' * simply including this module, only once the modifiers are put in place.\n', ' */\n', 'abstract contract Pausable is Context {\n', '    /**\n', '     * @dev Emitted when the pause is triggered by `account`.\n', '     */\n', '    event Paused(address account);\n', '\n', '    /**\n', '     * @dev Emitted when the pause is lifted by `account`.\n', '     */\n', '    event Unpaused(address account);\n', '\n', '    bool private _paused;\n', '\n', '    /**\n', '     * @dev Initializes the contract in unpaused state.\n', '     */\n', '    constructor () {\n', '        _paused = false;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the contract is paused, and false otherwise.\n', '     */\n', '    function paused() public view virtual returns (bool) {\n', '        return _paused;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must not be paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!paused(), "Pausable: paused");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must be paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(paused(), "Pausable: not paused");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Triggers stopped state.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must not be paused.\n', '     */\n', '    function _pause() internal virtual whenNotPaused {\n', '        _paused = true;\n', '        emit Paused(_msgSender());\n', '    }\n', '\n', '    /**\n', '     * @dev Returns to normal state.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must be paused.\n', '     */\n', '    function _unpause() internal virtual whenPaused {\n', '        _paused = false;\n', '        emit Unpaused(_msgSender());\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/**\n', ' * @dev Contract module that helps prevent reentrant calls to a function.\n', ' *\n', ' * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier\n', ' * available, which can be applied to functions to make sure there are no nested\n', ' * (reentrant) calls to them.\n', ' *\n', ' * Note that because there is a single `nonReentrant` guard, functions marked as\n', ' * `nonReentrant` may not call one another. This can be worked around by making\n', ' * those functions `private`, and then adding `external` `nonReentrant` entry\n', ' * points to them.\n', ' *\n', ' * TIP: If you would like to learn more about reentrancy and alternative ways\n', ' * to protect against it, check out our blog post\n', ' * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].\n', ' */\n', 'abstract contract ReentrancyGuard {\n', '    // Booleans are more expensive than uint256 or any type that takes up a full\n', '    // word because each write operation emits an extra SLOAD to first read the\n', "    // slot's contents, replace the bits taken up by the boolean, and then write\n", "    // back. This is the compiler's defense against contract upgrades and\n", '    // pointer aliasing, and it cannot be disabled.\n', '\n', '    // The values being non-zero value makes deployment a bit more expensive,\n', '    // but in exchange the refund on every call to nonReentrant will be lower in\n', '    // amount. Since refunds are capped to a percentage of the total\n', "    // transaction's gas, it is best to keep them low in cases like this one, to\n", '    // increase the likelihood of the full refund coming into effect.\n', '    uint256 private constant _NOT_ENTERED = 1;\n', '    uint256 private constant _ENTERED = 2;\n', '\n', '    uint256 private _status;\n', '\n', '    constructor () {\n', '        _status = _NOT_ENTERED;\n', '    }\n', '\n', '    /**\n', '     * @dev Prevents a contract from calling itself, directly or indirectly.\n', '     * Calling a `nonReentrant` function from another `nonReentrant`\n', '     * function is not supported. It is possible to prevent this from happening\n', '     * by making the `nonReentrant` function external, and make it call a\n', '     * `private` function that does the actual work.\n', '     */\n', '    modifier nonReentrant() {\n', '        // On the first call to nonReentrant, _notEntered will be true\n', '        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");\n', '\n', '        // Any calls to nonReentrant after this point will fail\n', '        _status = _ENTERED;\n', '\n', '        _;\n', '\n', '        // By storing the original value once again, a refund is triggered (see\n', '        // https://eips.ethereum.org/EIPS/eip-2200)\n', '        _status = _NOT_ENTERED;\n', '    }\n', '}']