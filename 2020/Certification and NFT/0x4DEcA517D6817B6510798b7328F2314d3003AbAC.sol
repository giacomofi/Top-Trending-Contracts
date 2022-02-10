['// File: @openzeppelin/upgrades/contracts/upgradeability/Proxy.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @title Proxy\n', ' * @dev Implements delegation of calls to other contracts, with proper\n', ' * forwarding of return values and bubbling of failures.\n', ' * It defines a fallback function that delegates all calls to the address\n', ' * returned by the abstract _implementation() internal function.\n', ' */\n', 'contract Proxy {\n', '  /**\n', '   * @dev Fallback function.\n', '   * Implemented entirely in `_fallback`.\n', '   */\n', '  function () payable external {\n', '    _fallback();\n', '  }\n', '\n', '  /**\n', '   * @return The Address of the implementation.\n', '   */\n', '  function _implementation() internal view returns (address);\n', '\n', '  /**\n', '   * @dev Delegates execution to an implementation contract.\n', "   * This is a low level function that doesn't return to its internal call site.\n", '   * It will return to the external caller whatever the implementation returns.\n', '   * @param implementation Address to delegate.\n', '   */\n', '  function _delegate(address implementation) internal {\n', '    assembly {\n', '      // Copy msg.data. We take full control of memory in this inline assembly\n', '      // block because it will not return to Solidity code. We overwrite the\n', '      // Solidity scratch pad at memory position 0.\n', '      calldatacopy(0, 0, calldatasize)\n', '\n', '      // Call the implementation.\n', "      // out and outsize are 0 because we don't know the size yet.\n", '      let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)\n', '\n', '      // Copy the returned data.\n', '      returndatacopy(0, 0, returndatasize)\n', '\n', '      switch result\n', '      // delegatecall returns 0 on error.\n', '      case 0 { revert(0, returndatasize) }\n', '      default { return(0, returndatasize) }\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Function that is run as the first thing in the fallback function.\n', '   * Can be redefined in derived contracts to add functionality.\n', '   * Redefinitions must call super._willFallback().\n', '   */\n', '  function _willFallback() internal {\n', '  }\n', '\n', '  /**\n', '   * @dev fallback implementation.\n', '   * Extracted to enable manual triggering.\n', '   */\n', '  function _fallback() internal {\n', '    _willFallback();\n', '    _delegate(_implementation());\n', '  }\n', '}\n', '\n', '// File: @openzeppelin/upgrades/contracts/utils/Address.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * Utility library of inline functions on addresses\n', ' *\n', ' * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol\n', ' * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts\n', ' * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the\n', ' * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.\n', ' */\n', 'library OpenZeppelinUpgradesAddress {\n', '    /**\n', '     * Returns whether the target address is a contract\n', '     * @dev This function will return false if invoked during the constructor of a contract,\n', '     * as the code is not actually created until after the constructor finishes.\n', '     * @param account address of the account to check\n', '     * @return whether the target address is a contract\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        uint256 size;\n', '        // XXX Currently there is no better way to check if there is a contract in an address\n', '        // than to check the size of the code at that address.\n', '        // See https://ethereum.stackexchange.com/a/14016/36603\n', '        // for more details about how this works.\n', '        // TODO Check this again before the Serenity release, because all addresses will be\n', '        // contracts then.\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/upgrades/contracts/upgradeability/BaseUpgradeabilityProxy.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '\n', '/**\n', ' * @title BaseUpgradeabilityProxy\n', ' * @dev This contract implements a proxy that allows to change the\n', ' * implementation address to which it will delegate.\n', ' * Such a change is called an implementation upgrade.\n', ' */\n', 'contract BaseUpgradeabilityProxy is Proxy {\n', '  /**\n', '   * @dev Emitted when the implementation is upgraded.\n', '   * @param implementation Address of the new implementation.\n', '   */\n', '  event Upgraded(address indexed implementation);\n', '\n', '  /**\n', '   * @dev Storage slot with the address of the current implementation.\n', '   * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is\n', '   * validated in the constructor.\n', '   */\n', '  bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;\n', '\n', '  /**\n', '   * @dev Returns the current implementation.\n', '   * @return Address of the current implementation\n', '   */\n', '  function _implementation() internal view returns (address impl) {\n', '    bytes32 slot = IMPLEMENTATION_SLOT;\n', '    assembly {\n', '      impl := sload(slot)\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Upgrades the proxy to a new implementation.\n', '   * @param newImplementation Address of the new implementation.\n', '   */\n', '  function _upgradeTo(address newImplementation) internal {\n', '    _setImplementation(newImplementation);\n', '    emit Upgraded(newImplementation);\n', '  }\n', '\n', '  /**\n', '   * @dev Sets the implementation address of the proxy.\n', '   * @param newImplementation Address of the new implementation.\n', '   */\n', '  function _setImplementation(address newImplementation) internal {\n', '    require(OpenZeppelinUpgradesAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");\n', '\n', '    bytes32 slot = IMPLEMENTATION_SLOT;\n', '\n', '    assembly {\n', '      sstore(slot, newImplementation)\n', '    }\n', '  }\n', '}\n', '\n', '// File: @openzeppelin/upgrades/contracts/upgradeability/UpgradeabilityProxy.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '/**\n', ' * @title UpgradeabilityProxy\n', ' * @dev Extends BaseUpgradeabilityProxy with a constructor for initializing\n', ' * implementation and init data.\n', ' */\n', 'contract UpgradeabilityProxy is BaseUpgradeabilityProxy {\n', '  /**\n', '   * @dev Contract constructor.\n', '   * @param _logic Address of the initial implementation.\n', '   * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.\n', '   * It should include the signature and the parameters of the function to be called, as described in\n', '   * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.\n', '   * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.\n', '   */\n', '  constructor(address _logic, bytes memory _data) public payable {\n', "    assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));\n", '    _setImplementation(_logic);\n', '    if(_data.length > 0) {\n', '      (bool success,) = _logic.delegatecall(_data);\n', '      require(success);\n', '    }\n', '  }  \n', '}\n', '\n', '// File: contracts/AudiusAdminUpgradeabilityProxy.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '\n', '/**\n', " * @notice Wrapper around OpenZeppelin's UpgradeabilityProxy contract.\n", ' * Permissions proxy upgrade logic to Audius Governance contract.\n', ' * https://github.com/OpenZeppelin/openzeppelin-sdk/blob/release/2.8/packages/lib/contracts/upgradeability/UpgradeabilityProxy.sol\n', ' * @dev Any logic contract that has a signature clash with this proxy contract will be unable to call those functions\n', ' *      Please ensure logic contract functions do not share a signature with any functions defined in this file\n', ' */\n', 'contract AudiusAdminUpgradeabilityProxy is UpgradeabilityProxy {\n', '    address private proxyAdmin;\n', '    string private constant ERROR_ONLY_ADMIN = (\n', '        "AudiusAdminUpgradeabilityProxy: Caller must be current proxy admin"\n', '    );\n', '\n', '    /**\n', '     * @notice Sets admin address for future upgrades\n', '     * @param _logic - address of underlying logic contract.\n', '     *      Passed to UpgradeabilityProxy constructor.\n', '     * @param _proxyAdmin - address of proxy admin\n', '     *      Set to governance contract address for all non-governance contracts\n', '     *      Governance is deployed and upgraded to have own address as admin\n', '     * @param _data - data of function to be called on logic contract.\n', '     *      Passed to UpgradeabilityProxy constructor.\n', '     */\n', '    constructor(\n', '      address _logic,\n', '      address _proxyAdmin,\n', '      bytes memory _data\n', '    )\n', '    UpgradeabilityProxy(_logic, _data) public payable\n', '    {\n', '        proxyAdmin = _proxyAdmin;\n', '    }\n', '\n', '    /**\n', '     * @notice Upgrade the address of the logic contract for this proxy\n', '     * @dev Recreation of AdminUpgradeabilityProxy._upgradeTo.\n', '     *      Adds a check to ensure msg.sender is the Audius Proxy Admin\n', '     * @param _newImplementation - new address of logic contract that the proxy will point to\n', '     */\n', '    function upgradeTo(address _newImplementation) external {\n', '        require(msg.sender == proxyAdmin, ERROR_ONLY_ADMIN);\n', '        _upgradeTo(_newImplementation);\n', '    }\n', '\n', '    /**\n', '     * @return Current proxy admin address\n', '     */\n', '    function getAudiusProxyAdminAddress() external view returns (address) {\n', '        return proxyAdmin;\n', '    }\n', '\n', '    /**\n', '     * @return The address of the implementation.\n', '     */\n', '    function implementation() external view returns (address) {\n', '        return _implementation();\n', '    }\n', '\n', '    /**\n', '     * @notice Set the Audius Proxy Admin\n', '     * @dev Only callable by current proxy admin address\n', '     * @param _adminAddress - new admin address\n', '     */\n', '    function setAudiusProxyAdminAddress(address _adminAddress) external {\n', '        require(msg.sender == proxyAdmin, ERROR_ONLY_ADMIN);\n', '        proxyAdmin = _adminAddress;\n', '    }\n', '}']