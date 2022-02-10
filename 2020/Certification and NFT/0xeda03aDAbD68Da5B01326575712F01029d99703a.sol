['// File: contracts/spec_interfaces/IProtocol.sol\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity 0.6.12;\n', '\n', '/// @title Protocol upgrades contract interface\n', 'interface IProtocol {\n', '    event ProtocolVersionChanged(string deploymentSubset, uint256 currentVersion, uint256 nextVersion, uint256 fromTimestamp);\n', '\n', '    /*\n', '     *   External functions\n', '     */\n', '\n', '    /// Checks whether a deployment subset exists \n', '    /// @param deploymentSubset is the name of the deployment subset to query\n', '    /// @return exists is a bool indicating the deployment subset exists\n', '    function deploymentSubsetExists(string calldata deploymentSubset) external view returns (bool);\n', '\n', '    /// Returns the current protocol version for a given deployment subset to query\n', '    /// @dev an unexisting deployment subset returns protocol version 0\n', '    /// @param deploymentSubset is the name of the deployment subset\n', '    /// @return currentVersion is the current protocol version of the deployment subset\n', '    function getProtocolVersion(string calldata deploymentSubset) external view returns (uint256 currentVersion);\n', '\n', '    /*\n', '     *   Governance functions\n', '     */\n', '\n', '    /// Creates a new deployment subset\n', '    /// @dev governance function called only by the functional manager\n', '    /// @param deploymentSubset is the name of the new deployment subset\n', '    /// @param initialProtocolVersion is the initial protocol version of the deployment subset\n', '    function createDeploymentSubset(string calldata deploymentSubset, uint256 initialProtocolVersion) external /* onlyFunctionalManager */;\n', '\n', '\n', '    /// Schedules a protocol version upgrade for the given deployment subset\n', '    /// @dev governance function called only by the functional manager\n', '    /// @param deploymentSubset is the name of the deployment subset\n', '    /// @param nextVersion is the new protocol version to upgrade to, must be greater or equal to current version\n', '    /// @param fromTimestamp is the time the new protocol version takes effect, must be in the future\n', '    function setProtocolVersion(string calldata deploymentSubset, uint256 nextVersion, uint256 fromTimestamp) external /* onlyFunctionalManager */;\n', '}\n', '\n', '// File: contracts/spec_interfaces/IManagedContract.sol\n', '\n', 'pragma solidity 0.6.12;\n', '\n', '/// @title managed contract interface, used by the contracts registry to notify the contract on updates\n', 'interface IManagedContract /* is ILockable, IContractRegistryAccessor, Initializable */ {\n', '\n', '    /// Refreshes the address of the other contracts the contract interacts with\n', '    /// @dev called by the registry contract upon an update of a contract in the registry\n', '    function refreshContracts() external;\n', '\n', '}\n', '\n', '// File: contracts/spec_interfaces/IContractRegistry.sol\n', '\n', 'pragma solidity 0.6.12;\n', '\n', '/// @title Contract registry contract interface\n', '/// @dev The contract registry holds Orbs PoS contracts and managers lists\n', '/// @dev The contract registry updates the managed contracts on changes in the contract list\n', '/// @dev Governance functions restricted to managers access the registry to retrieve the manager address \n', '/// @dev The contract registry represents the source of truth for Orbs Ethereum contracts \n', '/// @dev By tracking the registry events or query before interaction, one can access the up to date contracts \n', 'interface IContractRegistry {\n', '\n', '\tevent ContractAddressUpdated(string contractName, address addr, bool managedContract);\n', '\tevent ManagerChanged(string role, address newManager);\n', '\tevent ContractRegistryUpdated(address newContractRegistry);\n', '\n', '\t/*\n', '\t* External functions\n', '\t*/\n', '\n', '    /// Updates the contracts address and emits a corresponding event\n', '    /// @dev governance function called only by the migrationManager or registryAdmin\n', '    /// @param contractName is the contract name, used to identify it\n', '    /// @param addr is the contract updated address\n', '    /// @param managedContract indicates whether the contract is managed by the registry and notified on changes\n', '\tfunction setContract(string calldata contractName, address addr, bool managedContract) external /* onlyAdminOrMigrationManager */;\n', '\n', '    /// Returns the current address of the given contracts\n', '    /// @param contractName is the contract name, used to identify it\n', '    /// @return addr is the contract updated address\n', '\tfunction getContract(string calldata contractName) external view returns (address);\n', '\n', '    /// Returns the list of contract addresses managed by the registry\n', '    /// @dev Managed contracts are updated on changes in the registry contracts addresses \n', '    /// @return addrs is the list of managed contracts\n', '\tfunction getManagedContracts() external view returns (address[] memory);\n', '\n', '    /// Locks all the managed contracts \n', '    /// @dev governance function called only by the migrationManager or registryAdmin\n', '    /// @dev When set all onlyWhenActive functions will revert\n', '\tfunction lockContracts() external /* onlyAdminOrMigrationManager */;\n', '\n', '    /// Unlocks all the managed contracts \n', '    /// @dev governance function called only by the migrationManager or registryAdmin\n', '\tfunction unlockContracts() external /* onlyAdminOrMigrationManager */;\n', '\t\n', '    /// Updates a manager address and emits a corresponding event\n', '    /// @dev governance function called only by the registryAdmin\n', "    /// @dev the managers list is a flexible list of role to the manager's address\n", '    /// @param role is the managers\' role name, for example "functionalManager"\n', '    /// @param manager is the manager updated address\n', '\tfunction setManager(string calldata role, address manager) external /* onlyAdmin */;\n', '\n', '    /// Returns the current address of the given manager\n', '    /// @param role is the manager name, used to identify it\n', '    /// @return addr is the manager updated address\n', '\tfunction getManager(string calldata role) external view returns (address);\n', '\n', '    /// Sets a new contract registry to migrate to\n', '    /// @dev governance function called only by the registryAdmin\n', '    /// @dev updates the registry address record in all the managed contracts\n', '    /// @dev by tracking the emitted ContractRegistryUpdated, tools can track the up to date contracts\n', '    /// @param newRegistry is the new registry contract \n', '\tfunction setNewContractRegistry(IContractRegistry newRegistry) external /* onlyAdmin */;\n', '\n', '    /// Returns the previous contract registry address \n', '    /// @dev used when the setting the contract as a new registry to assure a valid registry\n', '    /// @return previousContractRegistry is the previous contract registry\n', '\tfunction getPreviousContractRegistry() external view returns (address);\n', '}\n', '\n', '// File: contracts/spec_interfaces/IContractRegistryAccessor.sol\n', '\n', 'pragma solidity 0.6.12;\n', '\n', '\n', 'interface IContractRegistryAccessor {\n', '\n', '    /// Sets the contract registry address\n', '    /// @dev governance function called only by an admin\n', '    /// @param newRegistry is the new registry contract \n', '    function setContractRegistry(IContractRegistry newRegistry) external /* onlyAdmin */;\n', '\n', '    /// Returns the contract registry address\n', '    /// @return contractRegistry is the contract registry address\n', '    function getContractRegistry() external view returns (IContractRegistry contractRegistry);\n', '\n', '    function setRegistryAdmin(address _registryAdmin) external /* onlyInitializationAdmin */;\n', '\n', '}\n', '\n', '// File: @openzeppelin/contracts/GSN/Context.sol\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '// File: contracts/WithClaimableRegistryManagement.sol\n', '\n', 'pragma solidity 0.6.12;\n', '\n', '\n', '/**\n', ' * @title Claimable\n', ' * @dev Extension for the Ownable contract, where the ownership needs to be claimed.\n', ' * This allows the new owner to accept the transfer.\n', ' */\n', 'contract WithClaimableRegistryManagement is Context {\n', '    address private _registryAdmin;\n', '    address private _pendingRegistryAdmin;\n', '\n', '    event RegistryManagementTransferred(address indexed previousRegistryAdmin, address indexed newRegistryAdmin);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial registryRegistryAdmin.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _registryAdmin = msgSender;\n', '        emit RegistryManagementTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current registryAdmin.\n', '     */\n', '    function registryAdmin() public view returns (address) {\n', '        return _registryAdmin;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the registryAdmin.\n', '     */\n', '    modifier onlyRegistryAdmin() {\n', '        require(isRegistryAdmin(), "WithClaimableRegistryManagement: caller is not the registryAdmin");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the caller is the current registryAdmin.\n', '     */\n', '    function isRegistryAdmin() public view returns (bool) {\n', '        return _msgSender() == _registryAdmin;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without registryAdmin. It will not be possible to call\n', '     * `onlyManager` functions anymore. Can only be called by the current registryAdmin.\n', '     *\n', '     * NOTE: Renouncing registryManagement will leave the contract without an registryAdmin,\n', '     * thereby removing any functionality that is only available to the registryAdmin.\n', '     */\n', '    function renounceRegistryManagement() public onlyRegistryAdmin {\n', '        emit RegistryManagementTransferred(_registryAdmin, address(0));\n', '        _registryAdmin = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers registryManagement of the contract to a new account (`newManager`).\n', '     */\n', '    function _transferRegistryManagement(address newRegistryAdmin) internal {\n', '        require(newRegistryAdmin != address(0), "RegistryAdmin: new registryAdmin is the zero address");\n', '        emit RegistryManagementTransferred(_registryAdmin, newRegistryAdmin);\n', '        _registryAdmin = newRegistryAdmin;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier throws if called by any account other than the pendingManager.\n', '     */\n', '    modifier onlyPendingRegistryAdmin() {\n', '        require(msg.sender == _pendingRegistryAdmin, "Caller is not the pending registryAdmin");\n', '        _;\n', '    }\n', '    /**\n', '     * @dev Allows the current registryAdmin to set the pendingManager address.\n', '     * @param newRegistryAdmin The address to transfer registryManagement to.\n', '     */\n', '    function transferRegistryManagement(address newRegistryAdmin) public onlyRegistryAdmin {\n', '        _pendingRegistryAdmin = newRegistryAdmin;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the _pendingRegistryAdmin address to finalize the transfer.\n', '     */\n', '    function claimRegistryManagement() external onlyPendingRegistryAdmin {\n', '        _transferRegistryManagement(_pendingRegistryAdmin);\n', '        _pendingRegistryAdmin = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the current pendingRegistryAdmin\n', '    */\n', '    function pendingRegistryAdmin() public view returns (address) {\n', '       return _pendingRegistryAdmin;  \n', '    }\n', '}\n', '\n', '// File: contracts/Initializable.sol\n', '\n', 'pragma solidity 0.6.12;\n', '\n', 'contract Initializable {\n', '\n', '    address private _initializationAdmin;\n', '\n', '    event InitializationComplete();\n', '\n', '    /// Constructor\n', '    /// Sets the initializationAdmin to the contract deployer\n', '    /// The initialization admin may call any manager only function until initializationComplete\n', '    constructor() public{\n', '        _initializationAdmin = msg.sender;\n', '    }\n', '\n', '    modifier onlyInitializationAdmin() {\n', '        require(msg.sender == initializationAdmin(), "sender is not the initialization admin");\n', '\n', '        _;\n', '    }\n', '\n', '    /*\n', '    * External functions\n', '    */\n', '\n', '    /// Returns the initializationAdmin address\n', '    function initializationAdmin() public view returns (address) {\n', '        return _initializationAdmin;\n', '    }\n', '\n', '    /// Finalizes the initialization and revokes the initializationAdmin role \n', '    function initializationComplete() external onlyInitializationAdmin {\n', '        _initializationAdmin = address(0);\n', '        emit InitializationComplete();\n', '    }\n', '\n', '    /// Checks if the initialization was completed\n', '    function isInitializationComplete() public view returns (bool) {\n', '        return _initializationAdmin == address(0);\n', '    }\n', '\n', '}\n', '\n', '// File: contracts/ContractRegistryAccessor.sol\n', '\n', 'pragma solidity 0.6.12;\n', '\n', '\n', '\n', '\n', '\n', 'contract ContractRegistryAccessor is IContractRegistryAccessor, WithClaimableRegistryManagement, Initializable {\n', '\n', '    IContractRegistry private contractRegistry;\n', '\n', '    /// Constructor\n', '    /// @param _contractRegistry is the contract registry address\n', '    /// @param _registryAdmin is the registry admin address\n', '    constructor(IContractRegistry _contractRegistry, address _registryAdmin) public {\n', '        require(address(_contractRegistry) != address(0), "_contractRegistry cannot be 0");\n', '        setContractRegistry(_contractRegistry);\n', '        _transferRegistryManagement(_registryAdmin);\n', '    }\n', '\n', '    modifier onlyAdmin {\n', '        require(isAdmin(), "sender is not an admin (registryManger or initializationAdmin)");\n', '\n', '        _;\n', '    }\n', '\n', '    modifier onlyMigrationManager {\n', '        require(isMigrationManager(), "sender is not the migration manager");\n', '\n', '        _;\n', '    }\n', '\n', '    modifier onlyFunctionalManager {\n', '        require(isFunctionalManager(), "sender is not the functional manager");\n', '\n', '        _;\n', '    }\n', '\n', '    /// Checks whether the caller is Admin: either the contract registry, the registry admin, or the initialization admin\n', '    function isAdmin() internal view returns (bool) {\n', '        return msg.sender == address(contractRegistry) || msg.sender == registryAdmin() || msg.sender == initializationAdmin();\n', '    }\n', '\n', '    /// Checks whether the caller is a specific manager role or and Admin\n', '    /// @dev queries the registry contract for the up to date manager assignment\n', '    function isManager(string memory role) internal view returns (bool) {\n', '        IContractRegistry _contractRegistry = contractRegistry;\n', '        return isAdmin() || _contractRegistry != IContractRegistry(0) && contractRegistry.getManager(role) == msg.sender;\n', '    }\n', '\n', '    /// Checks whether the caller is the migration manager\n', '    function isMigrationManager() internal view returns (bool) {\n', "        return isManager('migrationManager');\n", '    }\n', '\n', '    /// Checks whether the caller is the functional manager\n', '    function isFunctionalManager() internal view returns (bool) {\n', "        return isManager('functionalManager');\n", '    }\n', '\n', '    /* \n', '     * Contract getters, return the address of a contract by calling the contract registry \n', '     */ \n', '\n', '    function getProtocolContract() internal view returns (address) {\n', '        return contractRegistry.getContract("protocol");\n', '    }\n', '\n', '    function getStakingRewardsContract() internal view returns (address) {\n', '        return contractRegistry.getContract("stakingRewards");\n', '    }\n', '\n', '    function getFeesAndBootstrapRewardsContract() internal view returns (address) {\n', '        return contractRegistry.getContract("feesAndBootstrapRewards");\n', '    }\n', '\n', '    function getCommitteeContract() internal view returns (address) {\n', '        return contractRegistry.getContract("committee");\n', '    }\n', '\n', '    function getElectionsContract() internal view returns (address) {\n', '        return contractRegistry.getContract("elections");\n', '    }\n', '\n', '    function getDelegationsContract() internal view returns (address) {\n', '        return contractRegistry.getContract("delegations");\n', '    }\n', '\n', '    function getGuardiansRegistrationContract() internal view returns (address) {\n', '        return contractRegistry.getContract("guardiansRegistration");\n', '    }\n', '\n', '    function getCertificationContract() internal view returns (address) {\n', '        return contractRegistry.getContract("certification");\n', '    }\n', '\n', '    function getStakingContract() internal view returns (address) {\n', '        return contractRegistry.getContract("staking");\n', '    }\n', '\n', '    function getSubscriptionsContract() internal view returns (address) {\n', '        return contractRegistry.getContract("subscriptions");\n', '    }\n', '\n', '    function getStakingRewardsWallet() internal view returns (address) {\n', '        return contractRegistry.getContract("stakingRewardsWallet");\n', '    }\n', '\n', '    function getBootstrapRewardsWallet() internal view returns (address) {\n', '        return contractRegistry.getContract("bootstrapRewardsWallet");\n', '    }\n', '\n', '    function getGeneralFeesWallet() internal view returns (address) {\n', '        return contractRegistry.getContract("generalFeesWallet");\n', '    }\n', '\n', '    function getCertifiedFeesWallet() internal view returns (address) {\n', '        return contractRegistry.getContract("certifiedFeesWallet");\n', '    }\n', '\n', '    function getStakingContractHandler() internal view returns (address) {\n', '        return contractRegistry.getContract("stakingContractHandler");\n', '    }\n', '\n', '    /*\n', '    * Governance functions\n', '    */\n', '\n', '    event ContractRegistryAddressUpdated(address addr);\n', '\n', '    /// Sets the contract registry address\n', '    /// @dev governance function called only by an admin\n', '    /// @param newContractRegistry is the new registry contract \n', '    function setContractRegistry(IContractRegistry newContractRegistry) public override onlyAdmin {\n', '        require(newContractRegistry.getPreviousContractRegistry() == address(contractRegistry), "new contract registry must provide the previous contract registry");\n', '        contractRegistry = newContractRegistry;\n', '        emit ContractRegistryAddressUpdated(address(newContractRegistry));\n', '    }\n', '\n', '    /// Returns the contract registry that the contract is set to use\n', '    /// @return contractRegistry is the registry contract address\n', '    function getContractRegistry() public override view returns (IContractRegistry) {\n', '        return contractRegistry;\n', '    }\n', '\n', '    function setRegistryAdmin(address _registryAdmin) external override onlyInitializationAdmin {\n', '        _transferRegistryManagement(_registryAdmin);\n', '    }\n', '\n', '}\n', '\n', '// File: contracts/spec_interfaces/ILockable.sol\n', '\n', 'pragma solidity 0.6.12;\n', '\n', '/// @title lockable contract interface, allows to lock a contract\n', 'interface ILockable {\n', '\n', '    event Locked();\n', '    event Unlocked();\n', '\n', '    /// Locks the contract to external non-governance function calls\n', '    /// @dev governance function called only by the migration manager or an admin\n', '    /// @dev typically called by the registry contract upon locking all managed contracts\n', '    /// @dev getters and migration functions remain active also for locked contracts\n', '    /// @dev checked by the onlyWhenActive modifier\n', '    function lock() external /* onlyMigrationManager */;\n', '\n', '    /// Unlocks the contract \n', '    /// @dev governance function called only by the migration manager or an admin\n', '    /// @dev typically called by the registry contract upon unlocking all managed contracts\n', '    function unlock() external /* onlyMigrationManager */;\n', '\n', '    /// Returns the contract locking status\n', '    /// @return isLocked is a bool indicating the contract is locked \n', '    function isLocked() view external returns (bool);\n', '\n', '}\n', '\n', '// File: contracts/Lockable.sol\n', '\n', 'pragma solidity 0.6.12;\n', '\n', '\n', '\n', '/// @title lockable contract\n', 'contract Lockable is ILockable, ContractRegistryAccessor {\n', '\n', '    bool public locked;\n', '\n', '    /// Constructor\n', '    /// @param _contractRegistry is the contract registry address\n', '    /// @param _registryAdmin is the registry admin address\n', '    constructor(IContractRegistry _contractRegistry, address _registryAdmin) ContractRegistryAccessor(_contractRegistry, _registryAdmin) public {}\n', '\n', '    /// Locks the contract to external non-governance function calls\n', '    /// @dev governance function called only by the migration manager or an admin\n', '    /// @dev typically called by the registry contract upon locking all managed contracts\n', '    /// @dev getters and migration functions remain active also for locked contracts\n', '    /// @dev checked by the onlyWhenActive modifier\n', '    function lock() external override onlyMigrationManager {\n', '        locked = true;\n', '        emit Locked();\n', '    }\n', '\n', '    /// Unlocks the contract \n', '    /// @dev governance function called only by the migration manager or an admin\n', '    /// @dev typically called by the registry contract upon unlocking all managed contracts\n', '    function unlock() external override onlyMigrationManager {\n', '        locked = false;\n', '        emit Unlocked();\n', '    }\n', '\n', '    /// Returns the contract locking status\n', '    /// @return isLocked is a bool indicating the contract is locked \n', '    function isLocked() external override view returns (bool) {\n', '        return locked;\n', '    }\n', '\n', '    modifier onlyWhenActive() {\n', '        require(!locked, "contract is locked for this operation");\n', '\n', '        _;\n', '    }\n', '}\n', '\n', '// File: contracts/ManagedContract.sol\n', '\n', 'pragma solidity 0.6.12;\n', '\n', '\n', '\n', '/// @title managed contract\n', 'contract ManagedContract is IManagedContract, Lockable {\n', '\n', '    /// @param _contractRegistry is the contract registry address\n', '    /// @param _registryAdmin is the registry admin address\n', '    constructor(IContractRegistry _contractRegistry, address _registryAdmin) Lockable(_contractRegistry, _registryAdmin) public {}\n', '\n', '    /// Refreshes the address of the other contracts the contract interacts with\n', '    /// @dev called by the registry contract upon an update of a contract in the registry\n', '    function refreshContracts() virtual override external {}\n', '\n', '}\n', '\n', '// File: contracts/Protocol.sol\n', '\n', 'pragma solidity 0.6.12;\n', '\n', '\n', '\n', '/// @title Protocol upgrades contract\n', 'contract Protocol is IProtocol, ManagedContract {\n', '\n', '    struct DeploymentSubset {\n', '        bool exists;\n', '        uint256 nextVersion;\n', '        uint fromTimestamp;\n', '        uint256 currentVersion;\n', '    }\n', '\n', '    mapping(string => DeploymentSubset) public deploymentSubsets;\n', '\n', '    /// @param _contractRegistry is the contract registry address\n', '    /// @param _registryAdmin is the registry admin address\n', '    constructor(IContractRegistry _contractRegistry, address _registryAdmin) ManagedContract(_contractRegistry, _registryAdmin) public {}\n', '\n', '    /*\n', '     * External functions\n', '     */\n', '\n', '    /// Checks whether a deployment subset exists \n', '    /// @param deploymentSubset is the name of the deployment subset to query\n', '    /// @return exists is a bool indicating the deployment subset exists\n', '    function deploymentSubsetExists(string calldata deploymentSubset) external override view returns (bool) {\n', '        return deploymentSubsets[deploymentSubset].exists;\n', '    }\n', '\n', '    /// Returns the current protocol version for a given deployment subset to query\n', '    /// @dev an unexisting deployment subset returns protocol version 0\n', '    /// @param deploymentSubset is the name of the deployment subset\n', '    /// @return currentVersion is the current protocol version of the deployment subset\n', '    function getProtocolVersion(string calldata deploymentSubset) external override view returns (uint256 currentVersion) {\n', '        (, currentVersion) = checkPrevUpgrades(deploymentSubset);\n', '    }\n', '\n', '    /// Creates a new deployment subset\n', '    /// @dev governance function called only by the functional manager\n', '    /// @param deploymentSubset is the name of the new deployment subset\n', '    /// @param initialProtocolVersion is the initial protocol version of the deployment subset\n', '    function createDeploymentSubset(string calldata deploymentSubset, uint256 initialProtocolVersion) external override onlyFunctionalManager {\n', '        require(!deploymentSubsets[deploymentSubset].exists, "deployment subset already exists");\n', '\n', '        deploymentSubsets[deploymentSubset].currentVersion = initialProtocolVersion;\n', '        deploymentSubsets[deploymentSubset].nextVersion = initialProtocolVersion;\n', '        deploymentSubsets[deploymentSubset].fromTimestamp = now;\n', '        deploymentSubsets[deploymentSubset].exists = true;\n', '\n', '        emit ProtocolVersionChanged(deploymentSubset, initialProtocolVersion, initialProtocolVersion, now);\n', '    }\n', '\n', '    /// Schedules a protocol version upgrade for the given deployment subset\n', '    /// @dev governance function called only by the functional manager\n', '    /// @param deploymentSubset is the name of the deployment subset\n', '    /// @param nextVersion is the new protocol version to upgrade to, must be greater or equal to current version\n', '    /// @param fromTimestamp is the time the new protocol version takes effect, must be in the future\n', '    function setProtocolVersion(string calldata deploymentSubset, uint256 nextVersion, uint256 fromTimestamp) external override onlyFunctionalManager {\n', '        require(deploymentSubsets[deploymentSubset].exists, "deployment subset does not exist");\n', '        require(fromTimestamp > now, "a protocol update can only be scheduled for the future");\n', '\n', '        (bool prevUpgradeExecuted, uint256 currentVersion) = checkPrevUpgrades(deploymentSubset);\n', '\n', '        require(nextVersion >= currentVersion, "protocol version must be greater or equal to current version");\n', '\n', '        deploymentSubsets[deploymentSubset].nextVersion = nextVersion;\n', '        deploymentSubsets[deploymentSubset].fromTimestamp = fromTimestamp;\n', '        if (prevUpgradeExecuted) {\n', '            deploymentSubsets[deploymentSubset].currentVersion = currentVersion;\n', '        }\n', '\n', '        emit ProtocolVersionChanged(deploymentSubset, currentVersion, nextVersion, fromTimestamp);\n', '    }\n', '\n', '    /*\n', '     * Private functions\n', '     */\n', '\n', '    /// Checks whether a previously set protocol upgrade was executed and returns the current protocol version \n', '    /// @param deploymentSubset is the name of the deployment subset to query\n', '    /// @return prevUpgradeExecuted indicates whether the previous protocol upgrade was executed \n', '    /// @return currentVersion is the active protocol version for the deployment subset    \n', '    function checkPrevUpgrades(string memory deploymentSubset) private view returns (bool prevUpgradeExecuted, uint256 currentVersion) {\n', '        prevUpgradeExecuted = deploymentSubsets[deploymentSubset].fromTimestamp <= now;\n', '        currentVersion = prevUpgradeExecuted ? deploymentSubsets[deploymentSubset].nextVersion :\n', '                                               deploymentSubsets[deploymentSubset].currentVersion;\n', '    }\n', '\n', '    /*\n', '     * Contracts topology / registry interface\n', '     */\n', '\n', '    /// Refreshes the address of the other contracts the contract interacts with\n', '    /// @dev called by the registry contract upon an update of a contract in the registry\n', '    /// @dev the protocol upgrades contract does not interact with other contracts and therefore implements an empty refreshContracts function\n', '    function refreshContracts() external override {}\n', '}']