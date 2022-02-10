['// SPDX-License-Identifier: UNLICENSED\n', 'pragma solidity ^0.8.0;\n', 'pragma abicoder v2;\n', '\n', '// OpenZeppelin v4\n', 'import { Ownable } from  "@openzeppelin/contracts/access/Ownable.sol";\n', '\n', '/**\n', ' * @title Delegator\n', ' * @author Railgun Contributors\n', " * @notice 'Owner' contract for all railgun contracts\n", ' * delegates permissions to other contracts (voter, role)\n', ' */\n', 'contract Delegator is Ownable {\n', '  /*\n', '  Mapping structure is calling address => contract => function signature\n', '  0 is used as a wildcard, so permission for contract 0 is permission for\n', '  any contract, and permission for function signature 0 is permission for\n', '  any function.\n', '\n', '  Comments below use * to signify wildcard and . notation to seperate address/contract/function.\n', '\n', '  caller.*.* allows caller to call any function on any contract\n', '  caller.X.* allows caller to call any function on contract X\n', '  caller.*.Y allows caller to call function Y on any contract\n', '  */\n', '  mapping(\n', '    address => mapping(\n', '      address => mapping(bytes4 => bool)\n', '    )\n', '  ) public permissions;\n', '\n', '  event GrantPermission(address indexed caller, address indexed contractAddress, bytes4 indexed selector);\n', '  event RevokePermission(address indexed caller, address indexed contractAddress, bytes4 indexed selector);\n', '\n', '  /**\n', '   * @notice Sets initial admin\n', '   */\n', '  constructor(address _admin) {\n', '    Ownable.transferOwnership(_admin);\n', '  }\n', '\n', '  /**\n', '   * @notice Sets permission bit\n', '   * @dev See comment on permissions mapping for wildcard format\n', '   * @param _caller - caller to set permissions for\n', '   * @param _contract - contract to set permissions for\n', '   * @param _selector - selector to set permissions for\n', '   * @param _permission - permission bit to set\n', '   */\n', '  function setPermission(\n', '    address _caller,\n', '    address _contract,\n', '    bytes4 _selector,\n', '    bool _permission\n', '   ) public onlyOwner {\n', '    // If permission set is different to new permission then we execute, otherwise skip\n', '    if (permissions[_caller][_contract][_selector] != _permission) {\n', '      // Set permission bit\n', '      permissions[_caller][_contract][_selector] = _permission;\n', '\n', '      // Emit event\n', '      if (_permission) {\n', '        emit GrantPermission(_caller, _contract, _selector);\n', '      } else {\n', '        emit RevokePermission(_caller, _contract, _selector);\n', '      }\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @notice Checks if caller has permission to execute function\n', '   * @param _caller - caller to check permissions for\n', '   * @param _contract - contract to check\n', '   * @param _selector - function signature to check\n', '   * @return if caller has permission\n', '   */\n', '  function checkPermission(address _caller, address _contract, bytes4 _selector) public view returns (bool) {\n', '    /* \n', '    See comment on permissions mapping for structure\n', '    Comments below use * to signify wildcard and . notation to seperate contract/function\n', '    */\n', '    return (\n', '      _caller == Ownable.owner()\n', '      || permissions[_caller][_contract][_selector] // Owner always has global permissions\n', '      || permissions[_caller][_contract][0x0] // Permission for function is given\n', '      || permissions[_caller][address(0)][_selector] // Permission for _contract.* is given\n', '      || permissions[_caller][address(0)][0x0] // Global permission is given\n', '    );\n', '  }\n', '\n', '  /**\n', '   * @notice Calls function\n', '   * @dev calls to functions on this contract are intercepted and run directly\n', "   * this is so the voting contract doesn't need to have special cases for calling\n", '   * functions other than this one.\n', '   * @param _contract - contract to call\n', '   * @param _data - calldata to pass to contract\n', '   * @return success - whether call succeeded\n', '   * @return returnData - return data from function call\n', '   */\n', '  function callContract(address _contract, bytes calldata _data, uint256 _value) public returns (bool success, bytes memory returnData) {\n', '    // Get selector\n', '    bytes4 selector = bytes4(_data);\n', '\n', '    // Intercept calls to this contract\n', '    if (_contract == address(this)) {\n', '      if (selector == this.setPermission.selector) {\n', '        // Decode call data\n', '        (\n', '          address caller,\n', '          address calledContract,\n', '          bytes4 _permissionSelector,\n', '          bool permission\n', '        ) = abi.decode(abi.encodePacked(_data[4:]), (address, address, bytes4, bool));\n', '\n', '        // Call setPermission\n', '        setPermission(caller, calledContract, _permissionSelector, permission);\n', '\n', '        // Return success with empty returndata bytes\n', '        bytes memory empty;\n', '        return (true, empty);\n', '      } else if (selector == this.transferOwnership.selector) {\n', '        // Decode call data\n', '        (\n', '          address newOwner\n', '        ) = abi.decode(abi.encodePacked(_data[4:]), (address));\n', '\n', '        // Call transferOwnership\n', '        Ownable.transferOwnership(newOwner);\n', '\n', '        // Return success with empty returndata bytes\n', '        bytes memory empty;\n', '        return (true, empty);\n', '      } else if (selector == this.renounceOwnership.selector) {\n', '        // Call renounceOwnership\n', '        Ownable.renounceOwnership();\n', '\n', '        // Return success with empty returndata bytes\n', '        bytes memory empty;\n', '        return (true, empty);\n', '      } else { \n', '        // Return failed with empty returndata bytes\n', '        bytes memory empty;\n', '        return (false, empty);\n', '      }\n', '    }\n', '\n', '    // Check permissions\n', '    require(checkPermission(msg.sender, _contract, selector), "Delegator: Caller doesn\'t have permission");\n', '\n', '    // Call external contract and return\n', '    // solhint-disable-next-line avoid-low-level-calls\n', '    return _contract.call{value: _value}(_data);\n', '  }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "../utils/Context.sol";\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'abstract contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view virtual returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(owner() == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes calldata) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 1600\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "libraries": {}\n', '}']