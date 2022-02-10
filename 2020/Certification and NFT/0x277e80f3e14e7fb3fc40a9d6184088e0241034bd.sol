['pragma solidity 0.5.11;\n', '\n', '/**\n', ' * @title Proxy\n', ' * @dev Implements delegation of calls to other contracts, with proper\n', ' * forwarding of return values and bubbling of failures.\n', ' * It defines a fallback function that delegates all calls to the address\n', ' * returned by the abstract _implementation() internal function.\n', ' */\n', 'contract Proxy {\n', '  /**\n', '   * @dev Fallback function.\n', '   * Implemented entirely in `_fallback`.\n', '   */\n', '  function () payable external {\n', '    _fallback();\n', '  }\n', '\n', '  /**\n', '   * @return The Address of the implementation.\n', '   */\n', '  function _implementation() internal view returns (address);\n', '\n', '  /**\n', '   * @dev Delegates execution to an implementation contract.\n', "   * This is a low level function that doesn't return to its internal call site.\n", '   * It will return to the external caller whatever the implementation returns.\n', '   * @param implementation Address to delegate.\n', '   */\n', '  function _delegate(address implementation) internal {\n', '    assembly {\n', '      // Copy msg.data. We take full control of memory in this inline assembly\n', '      // block because it will not return to Solidity code. We overwrite the\n', '      // Solidity scratch pad at memory position 0.\n', '      calldatacopy(0, 0, calldatasize)\n', '\n', '      // Call the implementation.\n', "      // out and outsize are 0 because we don't know the size yet.\n", '      let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)\n', '\n', '      // Copy the returned data.\n', '      returndatacopy(0, 0, returndatasize)\n', '\n', '      switch result\n', '      // delegatecall returns 0 on error.\n', '      case 0 { revert(0, returndatasize) }\n', '      default { return(0, returndatasize) }\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Function that is run as the first thing in the fallback function.\n', '   * Can be redefined in derived contracts to add functionality.\n', '   * Redefinitions must call super._willFallback().\n', '   */\n', '  function _willFallback() internal {\n', '  }\n', '\n', '  /**\n', '   * @dev fallback implementation.\n', '   * Extracted to enable manual triggering.\n', '   */\n', '  function _fallback() internal {\n', '    _willFallback();\n', '    _delegate(_implementation());\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * Utility library of inline functions on addresses\n', ' *\n', ' * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol\n', ' * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts\n', ' * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the\n', ' * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.\n', ' */\n', 'library OpenZeppelinUpgradesAddress {\n', '    /**\n', '     * Returns whether the target address is a contract\n', '     * @dev This function will return false if invoked during the constructor of a contract,\n', '     * as the code is not actually created until after the constructor finishes.\n', '     * @param account address of the account to check\n', '     * @return whether the target address is a contract\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        uint256 size;\n', '        // XXX Currently there is no better way to check if there is a contract in an address\n', '        // than to check the size of the code at that address.\n', '        // See https://ethereum.stackexchange.com/a/14016/36603\n', '        // for more details about how this works.\n', '        // TODO Check this again before the Serenity release, because all addresses will be\n', '        // contracts then.\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title BaseUpgradeabilityProxy\n', ' * @dev This contract implements a proxy that allows to change the\n', ' * implementation address to which it will delegate.\n', ' * Such a change is called an implementation upgrade.\n', ' */\n', 'contract BaseUpgradeabilityProxy is Proxy {\n', '  /**\n', '   * @dev Emitted when the implementation is upgraded.\n', '   * @param implementation Address of the new implementation.\n', '   */\n', '  event Upgraded(address indexed implementation);\n', '\n', '  /**\n', '   * @dev Storage slot with the address of the current implementation.\n', '   * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is\n', '   * validated in the constructor.\n', '   */\n', '  bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;\n', '\n', '  /**\n', '   * @dev Returns the current implementation.\n', '   * @return Address of the current implementation\n', '   */\n', '  function _implementation() internal view returns (address impl) {\n', '    bytes32 slot = IMPLEMENTATION_SLOT;\n', '    assembly {\n', '      impl := sload(slot)\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Upgrades the proxy to a new implementation.\n', '   * @param newImplementation Address of the new implementation.\n', '   */\n', '  function _upgradeTo(address newImplementation) internal {\n', '    _setImplementation(newImplementation);\n', '    emit Upgraded(newImplementation);\n', '  }\n', '\n', '  /**\n', '   * @dev Sets the implementation address of the proxy.\n', '   * @param newImplementation Address of the new implementation.\n', '   */\n', '  function _setImplementation(address newImplementation) internal {\n', '    require(OpenZeppelinUpgradesAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");\n', '\n', '    bytes32 slot = IMPLEMENTATION_SLOT;\n', '\n', '    assembly {\n', '      sstore(slot, newImplementation)\n', '    }\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title OUSD Governable Contract\n', ' * @dev Copy of the openzeppelin Ownable.sol contract with nomenclature change\n', ' *      from owner to governor and renounce methods removed. Does not use\n', ' *      Context.sol like Ownable.sol does for simplification.\n', ' * @author Origin Protocol Inc\n', ' */\n', 'contract Governable {\n', '    // Storage position of the owner and pendingOwner of the contract\n', '    bytes32\n', '        private constant governorPosition = 0x7bea13895fa79d2831e0a9e28edede30099005a50d652d8957cf8a607ee6ca4a;\n', '    //keccak256("OUSD.governor");\n', '\n', '    bytes32\n', '        private constant pendingGovernorPosition = 0x44c4d30b2eaad5130ad70c3ba6972730566f3e6359ab83e800d905c61b1c51db;\n', '    //keccak256("OUSD.pending.governor");\n', '\n', '    event PendingGovernorshipTransfer(\n', '        address indexed previousGovernor,\n', '        address indexed newGovernor\n', '    );\n', '\n', '    event GovernorshipTransferred(\n', '        address indexed previousGovernor,\n', '        address indexed newGovernor\n', '    );\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial Governor.\n', '     */\n', '    constructor() internal {\n', '        _setGovernor(msg.sender);\n', '        emit GovernorshipTransferred(address(0), _governor());\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current Governor.\n', '     */\n', '    function governor() public view returns (address) {\n', '        return _governor();\n', '    }\n', '\n', '    function _governor() internal view returns (address governorOut) {\n', '        bytes32 position = governorPosition;\n', '        assembly {\n', '            governorOut := sload(position)\n', '        }\n', '    }\n', '\n', '    function _pendingGovernor()\n', '        internal\n', '        view\n', '        returns (address pendingGovernor)\n', '    {\n', '        bytes32 position = pendingGovernorPosition;\n', '        assembly {\n', '            pendingGovernor := sload(position)\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the Governor.\n', '     */\n', '    modifier onlyGovernor() {\n', '        require(isGovernor(), "Caller is not the Governor");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the caller is the current Governor.\n', '     */\n', '    function isGovernor() public view returns (bool) {\n', '        return msg.sender == _governor();\n', '    }\n', '\n', '    function _setGovernor(address newGovernor) internal {\n', '        bytes32 position = governorPosition;\n', '        assembly {\n', '            sstore(position, newGovernor)\n', '        }\n', '    }\n', '\n', '    function _setPendingGovernor(address newGovernor) internal {\n', '        bytes32 position = pendingGovernorPosition;\n', '        assembly {\n', '            sstore(position, newGovernor)\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers Governance of the contract to a new account (`newGovernor`).\n', '     * Can only be called by the current Governor. Must be claimed for this to complete\n', '     * @param _newGovernor Address of the new Governor\n', '     */\n', '    function transferGovernance(address _newGovernor) external onlyGovernor {\n', '        _setPendingGovernor(_newGovernor);\n', '        emit PendingGovernorshipTransfer(_governor(), _newGovernor);\n', '    }\n', '\n', '    /**\n', '     * @dev Claim Governance of the contract to a new account (`newGovernor`).\n', '     * Can only be called by the new Governor.\n', '     */\n', '    function claimGovernance() external {\n', '        require(\n', '            msg.sender == _pendingGovernor(),\n', '            "Only the pending Governor can complete the claim"\n', '        );\n', '        _changeGovernor(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @dev Change Governance of the contract to a new account (`newGovernor`).\n', '     * @param _newGovernor Address of the new Governor\n', '     */\n', '    function _changeGovernor(address _newGovernor) internal {\n', '        require(_newGovernor != address(0), "New Governor is address(0)");\n', '        emit GovernorshipTransferred(_governor(), _newGovernor);\n', '        _setGovernor(_newGovernor);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title BaseGovernedUpgradeabilityProxy\n', ' * @dev This contract combines an upgradeability proxy with our governor system\n', ' * @author Origin Protocol Inc\n', ' */\n', 'contract InitializeGovernedUpgradeabilityProxy is\n', '    Governable,\n', '    BaseUpgradeabilityProxy\n', '{\n', '    /**\n', '     * @dev Contract initializer with Governor enforcement\n', '     * @param _logic Address of the initial implementation.\n', '     * @param _initGovernor Address of the initial Governor.\n', '     * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.\n', '     * It should include the signature and the parameters of the function to be called, as described in\n', '     * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.\n', '     * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.\n', '     */\n', '    function initialize(\n', '        address _logic,\n', '        address _initGovernor,\n', '        bytes memory _data\n', '    ) public payable onlyGovernor {\n', '        require(_implementation() == address(0));\n', '        assert(\n', '            IMPLEMENTATION_SLOT ==\n', '                bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1)\n', '        );\n', '        _setImplementation(_logic);\n', '        if (_data.length > 0) {\n', '            (bool success, ) = _logic.delegatecall(_data);\n', '            require(success);\n', '        }\n', '        _changeGovernor(_initGovernor);\n', '    }\n', '\n', '    /**\n', "     * @return The address of the proxy admin/it's also the governor.\n", '     */\n', '    function admin() external view returns (address) {\n', '        return _governor();\n', '    }\n', '\n', '    /**\n', '     * @return The address of the implementation.\n', '     */\n', '    function implementation() external view returns (address) {\n', '        return _implementation();\n', '    }\n', '\n', '    /**\n', '     * @dev Upgrade the backing implementation of the proxy.\n', '     * Only the admin can call this function.\n', '     * @param newImplementation Address of the new implementation.\n', '     */\n', '    function upgradeTo(address newImplementation) external onlyGovernor {\n', '        _upgradeTo(newImplementation);\n', '    }\n', '\n', '    /**\n', '     * @dev Upgrade the backing implementation of the proxy and call a function\n', '     * on the new implementation.\n', '     * This is useful to initialize the proxied contract.\n', '     * @param newImplementation Address of the new implementation.\n', '     * @param data Data to send as msg.data in the low level call.\n', '     * It should include the signature and the parameters of the function to be called, as described in\n', '     * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.\n', '     */\n', '    function upgradeToAndCall(address newImplementation, bytes calldata data)\n', '        external\n', '        payable\n', '        onlyGovernor\n', '    {\n', '        _upgradeTo(newImplementation);\n', '        (bool success, ) = newImplementation.delegatecall(data);\n', '        require(success);\n', '    }\n', '}\n', '\n', '/**\n', ' * @notice VaultProxy delegates calls to a Vault implementation\n', ' */\n', 'contract VaultProxy is InitializeGovernedUpgradeabilityProxy {\n', '\n', '}']