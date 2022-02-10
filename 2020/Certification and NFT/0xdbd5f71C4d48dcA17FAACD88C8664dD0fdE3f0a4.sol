['// File: @openzeppelin/upgrades/contracts/ownership/Ownable.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' *\n', ' * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/ownership/Ownable.sol\n', ' * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts\n', ' * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the\n', ' * build/artifacts folder) as well as the vanilla Ownable implementation from an openzeppelin version.\n', ' */\n', 'contract OpenZeppelinUpgradesOwnable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor () internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @return the address of the owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner());\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @return true if `msg.sender` is the owner of the contract.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to relinquish control of the contract.\n', '     * @notice Renouncing to ownership will leave the contract without an owner.\n', '     * It will not be possible to call the functions with the `onlyOwner`\n', '     * modifier anymore.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/upgrades/contracts/upgradeability/Proxy.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @title Proxy\n', ' * @dev Implements delegation of calls to other contracts, with proper\n', ' * forwarding of return values and bubbling of failures.\n', ' * It defines a fallback function that delegates all calls to the address\n', ' * returned by the abstract _implementation() internal function.\n', ' */\n', 'contract Proxy {\n', '  /**\n', '   * @dev Fallback function.\n', '   * Implemented entirely in `_fallback`.\n', '   */\n', '  function () payable external {\n', '    _fallback();\n', '  }\n', '\n', '  /**\n', '   * @return The Address of the implementation.\n', '   */\n', '  function _implementation() internal view returns (address);\n', '\n', '  /**\n', '   * @dev Delegates execution to an implementation contract.\n', "   * This is a low level function that doesn't return to its internal call site.\n", '   * It will return to the external caller whatever the implementation returns.\n', '   * @param implementation Address to delegate.\n', '   */\n', '  function _delegate(address implementation) internal {\n', '    assembly {\n', '      // Copy msg.data. We take full control of memory in this inline assembly\n', '      // block because it will not return to Solidity code. We overwrite the\n', '      // Solidity scratch pad at memory position 0.\n', '      calldatacopy(0, 0, calldatasize)\n', '\n', '      // Call the implementation.\n', "      // out and outsize are 0 because we don't know the size yet.\n", '      let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)\n', '\n', '      // Copy the returned data.\n', '      returndatacopy(0, 0, returndatasize)\n', '\n', '      switch result\n', '      // delegatecall returns 0 on error.\n', '      case 0 { revert(0, returndatasize) }\n', '      default { return(0, returndatasize) }\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Function that is run as the first thing in the fallback function.\n', '   * Can be redefined in derived contracts to add functionality.\n', '   * Redefinitions must call super._willFallback().\n', '   */\n', '  function _willFallback() internal {\n', '  }\n', '\n', '  /**\n', '   * @dev fallback implementation.\n', '   * Extracted to enable manual triggering.\n', '   */\n', '  function _fallback() internal {\n', '    _willFallback();\n', '    _delegate(_implementation());\n', '  }\n', '}\n', '\n', '// File: @openzeppelin/upgrades/contracts/utils/Address.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * Utility library of inline functions on addresses\n', ' *\n', ' * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol\n', ' * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts\n', ' * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the\n', ' * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.\n', ' */\n', 'library OpenZeppelinUpgradesAddress {\n', '    /**\n', '     * Returns whether the target address is a contract\n', '     * @dev This function will return false if invoked during the constructor of a contract,\n', '     * as the code is not actually created until after the constructor finishes.\n', '     * @param account address of the account to check\n', '     * @return whether the target address is a contract\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        uint256 size;\n', '        // XXX Currently there is no better way to check if there is a contract in an address\n', '        // than to check the size of the code at that address.\n', '        // See https://ethereum.stackexchange.com/a/14016/36603\n', '        // for more details about how this works.\n', '        // TODO Check this again before the Serenity release, because all addresses will be\n', '        // contracts then.\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/upgrades/contracts/upgradeability/BaseUpgradeabilityProxy.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '\n', '/**\n', ' * @title BaseUpgradeabilityProxy\n', ' * @dev This contract implements a proxy that allows to change the\n', ' * implementation address to which it will delegate.\n', ' * Such a change is called an implementation upgrade.\n', ' */\n', 'contract BaseUpgradeabilityProxy is Proxy {\n', '  /**\n', '   * @dev Emitted when the implementation is upgraded.\n', '   * @param implementation Address of the new implementation.\n', '   */\n', '  event Upgraded(address indexed implementation);\n', '\n', '  /**\n', '   * @dev Storage slot with the address of the current implementation.\n', '   * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is\n', '   * validated in the constructor.\n', '   */\n', '  bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;\n', '\n', '  /**\n', '   * @dev Returns the current implementation.\n', '   * @return Address of the current implementation\n', '   */\n', '  function _implementation() internal view returns (address impl) {\n', '    bytes32 slot = IMPLEMENTATION_SLOT;\n', '    assembly {\n', '      impl := sload(slot)\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Upgrades the proxy to a new implementation.\n', '   * @param newImplementation Address of the new implementation.\n', '   */\n', '  function _upgradeTo(address newImplementation) internal {\n', '    _setImplementation(newImplementation);\n', '    emit Upgraded(newImplementation);\n', '  }\n', '\n', '  /**\n', '   * @dev Sets the implementation address of the proxy.\n', '   * @param newImplementation Address of the new implementation.\n', '   */\n', '  function _setImplementation(address newImplementation) internal {\n', '    require(OpenZeppelinUpgradesAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");\n', '\n', '    bytes32 slot = IMPLEMENTATION_SLOT;\n', '\n', '    assembly {\n', '      sstore(slot, newImplementation)\n', '    }\n', '  }\n', '}\n', '\n', '// File: @openzeppelin/upgrades/contracts/upgradeability/UpgradeabilityProxy.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '/**\n', ' * @title UpgradeabilityProxy\n', ' * @dev Extends BaseUpgradeabilityProxy with a constructor for initializing\n', ' * implementation and init data.\n', ' */\n', 'contract UpgradeabilityProxy is BaseUpgradeabilityProxy {\n', '  /**\n', '   * @dev Contract constructor.\n', '   * @param _logic Address of the initial implementation.\n', '   * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.\n', '   * It should include the signature and the parameters of the function to be called, as described in\n', '   * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.\n', '   * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.\n', '   */\n', '  constructor(address _logic, bytes memory _data) public payable {\n', "    assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));\n", '    _setImplementation(_logic);\n', '    if(_data.length > 0) {\n', '      (bool success,) = _logic.delegatecall(_data);\n', '      require(success);\n', '    }\n', '  }  \n', '}\n', '\n', '// File: @openzeppelin/upgrades/contracts/upgradeability/BaseAdminUpgradeabilityProxy.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '/**\n', ' * @title BaseAdminUpgradeabilityProxy\n', ' * @dev This contract combines an upgradeability proxy with an authorization\n', ' * mechanism for administrative tasks.\n', ' * All external functions in this contract must be guarded by the\n', ' * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity\n', ' * feature proposal that would enable this to be done automatically.\n', ' */\n', 'contract BaseAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {\n', '  /**\n', '   * @dev Emitted when the administration has been transferred.\n', '   * @param previousAdmin Address of the previous admin.\n', '   * @param newAdmin Address of the new admin.\n', '   */\n', '  event AdminChanged(address previousAdmin, address newAdmin);\n', '\n', '  /**\n', '   * @dev Storage slot with the admin of the contract.\n', '   * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is\n', '   * validated in the constructor.\n', '   */\n', '\n', '  bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;\n', '\n', '  /**\n', '   * @dev Modifier to check whether the `msg.sender` is the admin.\n', '   * If it is, it will run the function. Otherwise, it will delegate the call\n', '   * to the implementation.\n', '   */\n', '  modifier ifAdmin() {\n', '    if (msg.sender == _admin()) {\n', '      _;\n', '    } else {\n', '      _fallback();\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @return The address of the proxy admin.\n', '   */\n', '  function admin() external ifAdmin returns (address) {\n', '    return _admin();\n', '  }\n', '\n', '  /**\n', '   * @return The address of the implementation.\n', '   */\n', '  function implementation() external ifAdmin returns (address) {\n', '    return _implementation();\n', '  }\n', '\n', '  /**\n', '   * @dev Changes the admin of the proxy.\n', '   * Only the current admin can call this function.\n', '   * @param newAdmin Address to transfer proxy administration to.\n', '   */\n', '  function changeAdmin(address newAdmin) external ifAdmin {\n', '    require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");\n', '    emit AdminChanged(_admin(), newAdmin);\n', '    _setAdmin(newAdmin);\n', '  }\n', '\n', '  /**\n', '   * @dev Upgrade the backing implementation of the proxy.\n', '   * Only the admin can call this function.\n', '   * @param newImplementation Address of the new implementation.\n', '   */\n', '  function upgradeTo(address newImplementation) external ifAdmin {\n', '    _upgradeTo(newImplementation);\n', '  }\n', '\n', '  /**\n', '   * @dev Upgrade the backing implementation of the proxy and call a function\n', '   * on the new implementation.\n', '   * This is useful to initialize the proxied contract.\n', '   * @param newImplementation Address of the new implementation.\n', '   * @param data Data to send as msg.data in the low level call.\n', '   * It should include the signature and the parameters of the function to be called, as described in\n', '   * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.\n', '   */\n', '  function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {\n', '    _upgradeTo(newImplementation);\n', '    (bool success,) = newImplementation.delegatecall(data);\n', '    require(success);\n', '  }\n', '\n', '  /**\n', '   * @return The admin slot.\n', '   */\n', '  function _admin() internal view returns (address adm) {\n', '    bytes32 slot = ADMIN_SLOT;\n', '    assembly {\n', '      adm := sload(slot)\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Sets the address of the proxy admin.\n', '   * @param newAdmin Address of the new proxy admin.\n', '   */\n', '  function _setAdmin(address newAdmin) internal {\n', '    bytes32 slot = ADMIN_SLOT;\n', '\n', '    assembly {\n', '      sstore(slot, newAdmin)\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Only fall back when the sender is not the admin.\n', '   */\n', '  function _willFallback() internal {\n', '    require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");\n', '    super._willFallback();\n', '  }\n', '}\n', '\n', '// File: @openzeppelin/upgrades/contracts/upgradeability/AdminUpgradeabilityProxy.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '/**\n', ' * @title AdminUpgradeabilityProxy\n', ' * @dev Extends from BaseAdminUpgradeabilityProxy with a constructor for \n', ' * initializing the implementation, admin, and init data.\n', ' */\n', 'contract AdminUpgradeabilityProxy is BaseAdminUpgradeabilityProxy, UpgradeabilityProxy {\n', '  /**\n', '   * Contract constructor.\n', '   * @param _logic address of the initial implementation.\n', '   * @param _admin Address of the proxy administrator.\n', '   * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.\n', '   * It should include the signature and the parameters of the function to be called, as described in\n', '   * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.\n', '   * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.\n', '   */\n', '  constructor(address _logic, address _admin, bytes memory _data) UpgradeabilityProxy(_logic, _data) public payable {\n', "    assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));\n", '    _setAdmin(_admin);\n', '  }\n', '}\n', '\n', '// File: @openzeppelin/upgrades/contracts/upgradeability/ProxyAdmin.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '\n', '/**\n', ' * @title ProxyAdmin\n', ' * @dev This contract is the admin of a proxy, and is in charge\n', ' * of upgrading it as well as transferring it to another admin.\n', ' */\n', 'contract ProxyAdmin is OpenZeppelinUpgradesOwnable {\n', '  \n', '  /**\n', '   * @dev Returns the current implementation of a proxy.\n', '   * This is needed because only the proxy admin can query it.\n', '   * @return The address of the current implementation of the proxy.\n', '   */\n', '  function getProxyImplementation(AdminUpgradeabilityProxy proxy) public view returns (address) {\n', '    // We need to manually run the static call since the getter cannot be flagged as view\n', '    // bytes4(keccak256("implementation()")) == 0x5c60da1b\n', '    (bool success, bytes memory returndata) = address(proxy).staticcall(hex"5c60da1b");\n', '    require(success);\n', '    return abi.decode(returndata, (address));\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the admin of a proxy. Only the admin can query it.\n', '   * @return The address of the current admin of the proxy.\n', '   */\n', '  function getProxyAdmin(AdminUpgradeabilityProxy proxy) public view returns (address) {\n', '    // We need to manually run the static call since the getter cannot be flagged as view\n', '    // bytes4(keccak256("admin()")) == 0xf851a440\n', '    (bool success, bytes memory returndata) = address(proxy).staticcall(hex"f851a440");\n', '    require(success);\n', '    return abi.decode(returndata, (address));\n', '  }\n', '\n', '  /**\n', '   * @dev Changes the admin of a proxy.\n', '   * @param proxy Proxy to change admin.\n', '   * @param newAdmin Address to transfer proxy administration to.\n', '   */\n', '  function changeProxyAdmin(AdminUpgradeabilityProxy proxy, address newAdmin) public onlyOwner {\n', '    proxy.changeAdmin(newAdmin);\n', '  }\n', '\n', '  /**\n', '   * @dev Upgrades a proxy to the newest implementation of a contract.\n', '   * @param proxy Proxy to be upgraded.\n', '   * @param implementation the address of the Implementation.\n', '   */\n', '  function upgrade(AdminUpgradeabilityProxy proxy, address implementation) public onlyOwner {\n', '    proxy.upgradeTo(implementation);\n', '  }\n', '\n', '  /**\n', '   * @dev Upgrades a proxy to the newest implementation of a contract and forwards a function call to it.\n', '   * This is useful to initialize the proxied contract.\n', '   * @param proxy Proxy to be upgraded.\n', '   * @param implementation Address of the Implementation.\n', '   * @param data Data to send as msg.data in the low level call.\n', '   * It should include the signature and the parameters of the function to be called, as described in\n', '   * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.\n', '   */\n', '  function upgradeAndCall(AdminUpgradeabilityProxy proxy, address implementation, bytes memory data) payable public onlyOwner {\n', '    proxy.upgradeToAndCall.value(msg.value)(implementation, data);\n', '  }\n', '}\n', '\n', '// File: contracts/WOMProxyAdmin.sol\n', '\n', '/**\n', ' * @title WOMProxyAdmin\n', ' * @author WOM Protocol <info@womprotocol.io>\n', ' * @dev Proxy admin contract.\n', '*/\n', 'pragma solidity 0.5.12;\n', '\n', '\n', '\n', 'contract WOMProxyAdmin is ProxyAdmin {\n', '    constructor() public ProxyAdmin() {\n', '    }\n', '}']