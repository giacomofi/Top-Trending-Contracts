['// SPDX-License-Identifier: UNLICENSED\n', '\n', 'pragma solidity 0.6.12;\n', '\n', 'import "./Lockable.sol";\n', '\n', 'contract ManagedContract is Lockable {\n', '\n', '    constructor(IContractRegistry _contractRegistry, address _registryAdmin) Lockable(_contractRegistry, _registryAdmin) public {}\n', '\n', '    modifier onlyMigrationManager {\n', '        require(isManager("migrationManager"), "sender is not the migration manager");\n', '\n', '        _;\n', '    }\n', '\n', '    modifier onlyFunctionalManager {\n', '        require(isManager("functionalManager"), "sender is not the functional manager");\n', '\n', '        _;\n', '    }\n', '\n', '    function refreshContracts() virtual external {}\n', '\n', '}']
['// SPDX-License-Identifier: UNLICENSED\n', '\n', 'pragma solidity 0.6.12;\n', '\n', 'import "./IProtocol.sol";\n', 'import "./ManagedContract.sol";\n', '\n', 'contract Protocol is IProtocol, ManagedContract {\n', '\n', '    struct DeploymentSubset {\n', '        bool exists;\n', '        uint256 nextVersion;\n', '        uint fromTimestamp;\n', '        uint256 currentVersion;\n', '    }\n', '\n', '    mapping(string => DeploymentSubset) public deploymentSubsets;\n', '\n', '    constructor(IContractRegistry _contractRegistry, address _registryAdmin) ManagedContract(_contractRegistry, _registryAdmin) public {}\n', '\n', '    /*\n', '     * External functions\n', '     */\n', '\n', '    function deploymentSubsetExists(string calldata deploymentSubset) external override view returns (bool) {\n', '        return deploymentSubsets[deploymentSubset].exists;\n', '    }\n', '\n', '    function getProtocolVersion(string calldata deploymentSubset) external override view returns (uint256 currentVersion) {\n', '        (, currentVersion) = checkPrevUpgrades(deploymentSubset);\n', '    }\n', '\n', '    function createDeploymentSubset(string calldata deploymentSubset, uint256 initialProtocolVersion) external override onlyFunctionalManager {\n', '        require(!deploymentSubsets[deploymentSubset].exists, "deployment subset already exists");\n', '\n', '        deploymentSubsets[deploymentSubset].currentVersion = initialProtocolVersion;\n', '        deploymentSubsets[deploymentSubset].nextVersion = initialProtocolVersion;\n', '        deploymentSubsets[deploymentSubset].fromTimestamp = now;\n', '        deploymentSubsets[deploymentSubset].exists = true;\n', '\n', '        emit ProtocolVersionChanged(deploymentSubset, initialProtocolVersion, initialProtocolVersion, now);\n', '    }\n', '\n', '    function setProtocolVersion(string calldata deploymentSubset, uint256 nextVersion, uint256 fromTimestamp) external override onlyFunctionalManager {\n', '        require(deploymentSubsets[deploymentSubset].exists, "deployment subset does not exist");\n', '        require(fromTimestamp > now, "a protocol update can only be scheduled for the future");\n', '\n', '        (bool prevUpgradeExecuted, uint256 currentVersion) = checkPrevUpgrades(deploymentSubset);\n', '\n', '        require(nextVersion >= currentVersion, "protocol version must be greater or equal to current version");\n', '\n', '        deploymentSubsets[deploymentSubset].nextVersion = nextVersion;\n', '        deploymentSubsets[deploymentSubset].fromTimestamp = fromTimestamp;\n', '        if (prevUpgradeExecuted) {\n', '            deploymentSubsets[deploymentSubset].currentVersion = currentVersion;\n', '        }\n', '\n', '        emit ProtocolVersionChanged(deploymentSubset, currentVersion, nextVersion, fromTimestamp);\n', '    }\n', '\n', '    /*\n', '     * Private functions\n', '     */\n', '\n', '    function checkPrevUpgrades(string memory deploymentSubset) private view returns (bool prevUpgradeExecuted, uint256 currentVersion) {\n', '        prevUpgradeExecuted = deploymentSubsets[deploymentSubset].fromTimestamp <= now;\n', '        currentVersion = prevUpgradeExecuted ? deploymentSubsets[deploymentSubset].nextVersion :\n', '                                               deploymentSubsets[deploymentSubset].currentVersion;\n', '    }\n', '\n', '    /*\n', '     * Contracts topology / registry interface\n', '     */\n', '\n', '    function refreshContracts() external override {}\n', '}\n']
['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n']
['// SPDX-License-Identifier: UNLICENSED\n', '\n', 'pragma solidity 0.6.12;\n', '\n', 'interface IProtocol {\n', '    event ProtocolVersionChanged(string deploymentSubset, uint256 currentVersion, uint256 nextVersion, uint256 fromTimestamp);\n', '\n', '    /*\n', '     *   External functions\n', '     */\n', '\n', '    /// @dev returns true if the given deployment subset exists (i.e - is registered with a protocol version)\n', '    function deploymentSubsetExists(string calldata deploymentSubset) external view returns (bool);\n', '\n', '    /// @dev returns the current protocol version for the given deployment subset.\n', '    function getProtocolVersion(string calldata deploymentSubset) external view returns (uint256);\n', '\n', '    /*\n', '     *   Governance functions\n', '     */\n', '\n', '    /// @dev create a new deployment subset.\n', '    function createDeploymentSubset(string calldata deploymentSubset, uint256 initialProtocolVersion) external /* onlyFunctionalManager */;\n', '\n', '    /// @dev schedules a protocol version upgrade for the given deployment subset.\n', '    function setProtocolVersion(string calldata deploymentSubset, uint256 nextVersion, uint256 fromTimestamp) external /* onlyFunctionalManager */;\n', '}\n']
['// SPDX-License-Identifier: UNLICENSED\n', '\n', 'pragma solidity 0.6.12;\n', '\n', 'import "./IContractRegistry.sol";\n', 'import "./WithClaimableRegistryManagement.sol";\n', 'import "./Initializable.sol";\n', '\n', 'contract ContractRegistryAccessor is WithClaimableRegistryManagement, Initializable {\n', '\n', '    IContractRegistry private contractRegistry;\n', '\n', '    constructor(IContractRegistry _contractRegistry, address _registryAdmin) public {\n', '        require(address(_contractRegistry) != address(0), "_contractRegistry cannot be 0");\n', '        setContractRegistry(_contractRegistry);\n', '        _transferRegistryManagement(_registryAdmin);\n', '    }\n', '\n', '    modifier onlyAdmin {\n', '        require(isAdmin(), "sender is not an admin (registryManger or initializationAdmin)");\n', '\n', '        _;\n', '    }\n', '\n', '    function isManager(string memory role) internal view returns (bool) {\n', '        IContractRegistry _contractRegistry = contractRegistry;\n', '        return isAdmin() || _contractRegistry != IContractRegistry(0) && contractRegistry.getManager(role) == msg.sender;\n', '    }\n', '\n', '    function isAdmin() internal view returns (bool) {\n', '        return msg.sender == registryAdmin() || msg.sender == initializationAdmin() || msg.sender == address(contractRegistry);\n', '    }\n', '\n', '    function getProtocolContract() internal view returns (address) {\n', '        return contractRegistry.getContract("protocol");\n', '    }\n', '\n', '    function getStakingRewardsContract() internal view returns (address) {\n', '        return contractRegistry.getContract("stakingRewards");\n', '    }\n', '\n', '    function getFeesAndBootstrapRewardsContract() internal view returns (address) {\n', '        return contractRegistry.getContract("feesAndBootstrapRewards");\n', '    }\n', '\n', '    function getCommitteeContract() internal view returns (address) {\n', '        return contractRegistry.getContract("committee");\n', '    }\n', '\n', '    function getElectionsContract() internal view returns (address) {\n', '        return contractRegistry.getContract("elections");\n', '    }\n', '\n', '    function getDelegationsContract() internal view returns (address) {\n', '        return contractRegistry.getContract("delegations");\n', '    }\n', '\n', '    function getGuardiansRegistrationContract() internal view returns (address) {\n', '        return contractRegistry.getContract("guardiansRegistration");\n', '    }\n', '\n', '    function getCertificationContract() internal view returns (address) {\n', '        return contractRegistry.getContract("certification");\n', '    }\n', '\n', '    function getStakingContract() internal view returns (address) {\n', '        return contractRegistry.getContract("staking");\n', '    }\n', '\n', '    function getSubscriptionsContract() internal view returns (address) {\n', '        return contractRegistry.getContract("subscriptions");\n', '    }\n', '\n', '    function getStakingRewardsWallet() internal view returns (address) {\n', '        return contractRegistry.getContract("stakingRewardsWallet");\n', '    }\n', '\n', '    function getBootstrapRewardsWallet() internal view returns (address) {\n', '        return contractRegistry.getContract("bootstrapRewardsWallet");\n', '    }\n', '\n', '    function getGeneralFeesWallet() internal view returns (address) {\n', '        return contractRegistry.getContract("generalFeesWallet");\n', '    }\n', '\n', '    function getCertifiedFeesWallet() internal view returns (address) {\n', '        return contractRegistry.getContract("certifiedFeesWallet");\n', '    }\n', '\n', '    function getStakingContractHandler() internal view returns (address) {\n', '        return contractRegistry.getContract("stakingContractHandler");\n', '    }\n', '\n', '    /*\n', '    * Governance functions\n', '    */\n', '\n', '    event ContractRegistryAddressUpdated(address addr);\n', '\n', '    function setContractRegistry(IContractRegistry newContractRegistry) public onlyAdmin {\n', '        require(newContractRegistry.getPreviousContractRegistry() == address(contractRegistry), "new contract registry must provide the previous contract registry");\n', '        contractRegistry = newContractRegistry;\n', '        emit ContractRegistryAddressUpdated(address(newContractRegistry));\n', '    }\n', '\n', '    function getContractRegistry() public view returns (IContractRegistry) {\n', '        return contractRegistry;\n', '    }\n', '\n', '}\n']
['// SPDX-License-Identifier: UNLICENSED\n', '\n', 'pragma solidity 0.6.12;\n', '\n', 'interface IContractRegistry {\n', '\n', '\tevent ContractAddressUpdated(string contractName, address addr, bool managedContract);\n', '\tevent ManagerChanged(string role, address newManager);\n', '\tevent ContractRegistryUpdated(address newContractRegistry);\n', '\n', '\t/*\n', '\t* External functions\n', '\t*/\n', '\n', '\t/// @dev updates the contracts address and emits a corresponding event\n', '\t/// managedContract indicates whether the contract is managed by the registry and notified on changes\n', '\tfunction setContract(string calldata contractName, address addr, bool managedContract) external /* onlyAdmin */;\n', '\n', '\t/// @dev returns the current address of the given contracts\n', '\tfunction getContract(string calldata contractName) external view returns (address);\n', '\n', '\t/// @dev returns the list of contract addresses managed by the registry\n', '\tfunction getManagedContracts() external view returns (address[] memory);\n', '\n', '\tfunction setManager(string calldata role, address manager) external /* onlyAdmin */;\n', '\n', '\tfunction getManager(string calldata role) external view returns (address);\n', '\n', '\tfunction lockContracts() external /* onlyAdmin */;\n', '\n', '\tfunction unlockContracts() external /* onlyAdmin */;\n', '\n', '\tfunction setNewContractRegistry(IContractRegistry newRegistry) external /* onlyAdmin */;\n', '\n', '\tfunction getPreviousContractRegistry() external view returns (address);\n', '\n', '}\n']
['// SPDX-License-Identifier: UNLICENSED\n', '\n', 'pragma solidity 0.6.12;\n', '\n', 'contract Initializable {\n', '\n', '    address private _initializationAdmin;\n', '\n', '    event InitializationComplete();\n', '\n', '    constructor() public{\n', '        _initializationAdmin = msg.sender;\n', '    }\n', '\n', '    modifier onlyInitializationAdmin() {\n', '        require(msg.sender == initializationAdmin(), "sender is not the initialization admin");\n', '\n', '        _;\n', '    }\n', '\n', '    /*\n', '    * External functions\n', '    */\n', '\n', '    function initializationAdmin() public view returns (address) {\n', '        return _initializationAdmin;\n', '    }\n', '\n', '    function initializationComplete() external onlyInitializationAdmin {\n', '        _initializationAdmin = address(0);\n', '        emit InitializationComplete();\n', '    }\n', '\n', '    function isInitializationComplete() public view returns (bool) {\n', '        return _initializationAdmin == address(0);\n', '    }\n', '\n', '}']
['// SPDX-License-Identifier: UNLICENSED\n', '\n', 'pragma solidity 0.6.12;\n', '\n', 'interface ILockable {\n', '\n', '    event Locked();\n', '    event Unlocked();\n', '\n', '    function lock() external /* onlyLockOwner */;\n', '    function unlock() external /* onlyLockOwner */;\n', '    function isLocked() view external returns (bool);\n', '\n', '}\n']
['// SPDX-License-Identifier: UNLICENSED\n', '\n', 'pragma solidity 0.6.12;\n', '\n', 'import "./ContractRegistryAccessor.sol";\n', 'import "./ILockable.sol";\n', '\n', 'contract Lockable is ILockable, ContractRegistryAccessor {\n', '\n', '    bool public locked;\n', '\n', '    constructor(IContractRegistry _contractRegistry, address _registryAdmin) ContractRegistryAccessor(_contractRegistry, _registryAdmin) public {}\n', '\n', '    modifier onlyLockOwner() {\n', '        require(msg.sender == registryAdmin() || msg.sender == address(getContractRegistry()), "caller is not a lock owner");\n', '\n', '        _;\n', '    }\n', '\n', '    function lock() external override onlyLockOwner {\n', '        locked = true;\n', '        emit Locked();\n', '    }\n', '\n', '    function unlock() external override onlyLockOwner {\n', '        locked = false;\n', '        emit Unlocked();\n', '    }\n', '\n', '    function isLocked() external override view returns (bool) {\n', '        return locked;\n', '    }\n', '\n', '    modifier onlyWhenActive() {\n', '        require(!locked, "contract is locked for this operation");\n', '\n', '        _;\n', '    }\n', '}\n']
['// SPDX-License-Identifier: UNLICENSED\n', '\n', 'pragma solidity 0.6.12;\n', '\n', 'import "./Context.sol";\n', '\n', '/**\n', ' * @title Claimable\n', ' * @dev Extension for the Ownable contract, where the ownership needs to be claimed.\n', ' * This allows the new owner to accept the transfer.\n', ' */\n', 'contract WithClaimableRegistryManagement is Context {\n', '    address private _registryAdmin;\n', '    address private _pendingRegistryAdmin;\n', '\n', '    event RegistryManagementTransferred(address indexed previousRegistryAdmin, address indexed newRegistryAdmin);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial registryRegistryAdmin.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _registryAdmin = msgSender;\n', '        emit RegistryManagementTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current registryAdmin.\n', '     */\n', '    function registryAdmin() public view returns (address) {\n', '        return _registryAdmin;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the registryAdmin.\n', '     */\n', '    modifier onlyRegistryAdmin() {\n', '        require(isRegistryAdmin(), "WithClaimableRegistryManagement: caller is not the registryAdmin");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the caller is the current registryAdmin.\n', '     */\n', '    function isRegistryAdmin() public view returns (bool) {\n', '        return _msgSender() == _registryAdmin;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without registryAdmin. It will not be possible to call\n', '     * `onlyManager` functions anymore. Can only be called by the current registryAdmin.\n', '     *\n', '     * NOTE: Renouncing registryManagement will leave the contract without an registryAdmin,\n', '     * thereby removing any functionality that is only available to the registryAdmin.\n', '     */\n', '    function renounceRegistryManagement() public onlyRegistryAdmin {\n', '        emit RegistryManagementTransferred(_registryAdmin, address(0));\n', '        _registryAdmin = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers registryManagement of the contract to a new account (`newManager`).\n', '     */\n', '    function _transferRegistryManagement(address newRegistryAdmin) internal {\n', '        require(newRegistryAdmin != address(0), "RegistryAdmin: new registryAdmin is the zero address");\n', '        emit RegistryManagementTransferred(_registryAdmin, newRegistryAdmin);\n', '        _registryAdmin = newRegistryAdmin;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier throws if called by any account other than the pendingManager.\n', '     */\n', '    modifier onlyPendingRegistryAdmin() {\n', '        require(msg.sender == _pendingRegistryAdmin, "Caller is not the pending registryAdmin");\n', '        _;\n', '    }\n', '    /**\n', '     * @dev Allows the current registryAdmin to set the pendingManager address.\n', '     * @param newRegistryAdmin The address to transfer registryManagement to.\n', '     */\n', '    function transferRegistryManagement(address newRegistryAdmin) public onlyRegistryAdmin {\n', '        _pendingRegistryAdmin = newRegistryAdmin;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the _pendingRegistryAdmin address to finalize the transfer.\n', '     */\n', '    function claimRegistryManagement() external onlyPendingRegistryAdmin {\n', '        _transferRegistryManagement(_pendingRegistryAdmin);\n', '        _pendingRegistryAdmin = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the current pendingRegistryAdmin\n', '    */\n', '    function pendingRegistryAdmin() public view returns (address) {\n', '       return _pendingRegistryAdmin;  \n', '    }\n', '}\n']
