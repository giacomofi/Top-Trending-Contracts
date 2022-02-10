['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-01\n', '*/\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', 'contract IHandleCampaignDeployment {\n', '\n', '    /**\n', '     * @notice Function which will be used as simulation for constructor under TwoKeyAcquisitionCampaign contract\n', '     * @dev This is just an interface of the function, the actual logic\n', '     * is implemented under TwoKeyAcquisitionCampaignERC20.sol contract\n', '     * This function can be called only once per proxy address\n', '     */\n', '    function setInitialParamsCampaign(\n', '        address _twoKeySingletonesRegistry,\n', '        address _twoKeyAcquisitionLogicHandler,\n', '        address _conversionHandler,\n', '        address _moderator,\n', '        address _assetContractERC20,\n', '        address _contractor,\n', '        address _twoKeyEconomy,\n', '        uint [] values\n', '    ) public;\n', '\n', '    /**\n', '     * @notice Function which will be used as simulation for constructor under TwoKeyAcquisitionLogicHandler contract\n', '     * @dev This is just an interface of the function, the actual logic\n', '     * is implemented under TwoKeyAcquisitionLogicHandler.sol contract\n', '     * This function can be called only once per proxy address\n', '     */\n', '    function setInitialParamsLogicHandler(\n', '        uint [] values,\n', '        string _currency,\n', '        address _assetContractERC20,\n', '        address _moderator,\n', '        address _contractor,\n', '        address _acquisitionCampaignAddress,\n', '        address _twoKeySingletoneRegistry,\n', '        address _twoKeyConversionHandler\n', '    ) public;\n', '\n', '    /**\n', '     * @notice Function which will be used as simulation for constructor under TwoKeyConversionHandler contract\n', '     * @dev This is just an interface of the function, the actual logic\n', '     * is implemented under TwoKeyConversionHandler.sol contract\n', '     * This function can be called only once per proxy address\n', '     */\n', '    function setInitialParamsConversionHandler(\n', '        uint [] values,\n', '        address _twoKeyAcquisitionCampaignERC20,\n', '        address _twoKeyPurchasesHandler,\n', '        address _contractor,\n', '        address _assetContractERC20,\n', '        address _twoKeySingletonRegistry\n', '    ) public;\n', '\n', '\n', '    /**\n', '     * @notice Function which will be used as simulation for constructor under TwoKeyPurchasesHandler contract\n', '     * @dev This is just an interface of the function, the actual logic\n', '     * is implemented under TwoKeyPurchasesHandler.sol contract\n', '     * This function can be called only once per proxy address\n', '     */\n', '    function setInitialParamsPurchasesHandler(\n', '        uint[] values,\n', '        address _contractor,\n', '        address _assetContractERC20,\n', '        address _twoKeyEventSource,\n', '        address _proxyConversionHandler\n', '    ) public;\n', '\n', '\n', '    /**\n', '     * @notice Function which will be used as simulation for constructor under TwoKeyDonationCampaign contract\n', '     * @dev This is just an interface of the function, the actual logic\n', '     * is implemented under TwoKeyDonationCampaign.sol contract\n', '     * This function can be called only once per proxy address\n', '     */\n', '    function setInitialParamsDonationCampaign(\n', '        address _contractor,\n', '        address _moderator,\n', '        address _twoKeySingletonRegistry,\n', '        address _twoKeyDonationConversionHandler,\n', '        address _twoKeyDonationLogicHandler,\n', '        uint [] numberValues,\n', '        bool [] booleanValues\n', '    ) public;\n', '\n', '    /**\n', '     * @notice Function which will be used as simulation for constructor under TwoKeyDonationConversionHandler contract\n', '     * @dev This is just an interface of the function, the actual logic\n', '     * is implemented under TwoKeyDonationConversionHandler.sol contract\n', '     * This function can be called only once per proxy address\n', '     */\n', '    function setInitialParamsDonationConversionHandler(\n', '        string tokenName,\n', '        string tokenSymbol,\n', '        string _currency,\n', '        address _contractor,\n', '        address _twoKeyDonationCampaign,\n', '        address _twoKeySingletonRegistry\n', '    ) public;\n', '\n', '\n', '    function setInitialParamsDonationLogicHandler(\n', '        uint[] numberValues,\n', '        string currency,\n', '        address contractor,\n', '        address moderator,\n', '        address twoKeySingletonRegistry,\n', '        address twoKeyDonationCampaign,\n', '        address twokeyDonationConversionHandler\n', '    ) public;\n', '\n', '\n', '    function setInitialParamsCPCCampaign(\n', '        address _contractor,\n', '        address _twoKeySingletonRegistry,\n', '        string _url,\n', '        address _mirrorCampaignOnPlasma,\n', '        uint _bountyPerConversion,\n', '        address _twoKeyEconomy\n', '    )\n', '    public;\n', '}\n', '\n', 'contract IStructuredStorage {\n', '\n', '    function setProxyLogicContractAndDeployer(address _proxyLogicContract, address _deployer) external;\n', '    function setProxyLogicContract(address _proxyLogicContract) external;\n', '\n', '    // *** Getter Methods ***\n', '    function getUint(bytes32 _key) external view returns(uint);\n', '    function getString(bytes32 _key) external view returns(string);\n', '    function getAddress(bytes32 _key) external view returns(address);\n', '    function getBytes(bytes32 _key) external view returns(bytes);\n', '    function getBool(bytes32 _key) external view returns(bool);\n', '    function getInt(bytes32 _key) external view returns(int);\n', '    function getBytes32(bytes32 _key) external view returns(bytes32);\n', '\n', '    // *** Getter Methods For Arrays ***\n', '    function getBytes32Array(bytes32 _key) external view returns (bytes32[]);\n', '    function getAddressArray(bytes32 _key) external view returns (address[]);\n', '    function getUintArray(bytes32 _key) external view returns (uint[]);\n', '    function getIntArray(bytes32 _key) external view returns (int[]);\n', '    function getBoolArray(bytes32 _key) external view returns (bool[]);\n', '\n', '    // *** Setter Methods ***\n', '    function setUint(bytes32 _key, uint _value) external;\n', '    function setString(bytes32 _key, string _value) external;\n', '    function setAddress(bytes32 _key, address _value) external;\n', '    function setBytes(bytes32 _key, bytes _value) external;\n', '    function setBool(bytes32 _key, bool _value) external;\n', '    function setInt(bytes32 _key, int _value) external;\n', '    function setBytes32(bytes32 _key, bytes32 _value) external;\n', '\n', '    // *** Setter Methods For Arrays ***\n', '    function setBytes32Array(bytes32 _key, bytes32[] _value) external;\n', '    function setAddressArray(bytes32 _key, address[] _value) external;\n', '    function setUintArray(bytes32 _key, uint[] _value) external;\n', '    function setIntArray(bytes32 _key, int[] _value) external;\n', '    function setBoolArray(bytes32 _key, bool[] _value) external;\n', '\n', '    // *** Delete Methods ***\n', '    function deleteUint(bytes32 _key) external;\n', '    function deleteString(bytes32 _key) external;\n', '    function deleteAddress(bytes32 _key) external;\n', '    function deleteBytes(bytes32 _key) external;\n', '    function deleteBool(bytes32 _key) external;\n', '    function deleteInt(bytes32 _key) external;\n', '    function deleteBytes32(bytes32 _key) external;\n', '}\n', '\n', 'contract ITwoKeyCampaignValidator {\n', '    function isCampaignValidated(address campaign) public view returns (bool);\n', '    function validateAcquisitionCampaign(address campaign, string nonSingletonHash) public;\n', '    function validateDonationCampaign(address campaign, address donationConversionHandler, address donationLogicHandler, string nonSingletonHash) public;\n', '    function validateCPCCampaign(address campaign, string nonSingletonHash) public;\n', '}\n', '\n', 'contract ITwoKeyMaintainersRegistry {\n', '    function checkIsAddressMaintainer(address _sender) public view returns (bool);\n', '    function checkIsAddressCoreDev(address _sender) public view returns (bool);\n', '\n', '    function addMaintainers(address [] _maintainers) public;\n', '    function addCoreDevs(address [] _coreDevs) public;\n', '    function removeMaintainers(address [] _maintainers) public;\n', '    function removeCoreDevs(address [] _coreDevs) public;\n', '}\n', '\n', 'interface ITwoKeySingletonesRegistry {\n', '\n', '    /**\n', '    * @dev This event will be emitted every time a new proxy is created\n', '    * @param proxy representing the address of the proxy created\n', '    */\n', '    event ProxyCreated(address proxy);\n', '\n', '\n', '    /**\n', '    * @dev This event will be emitted every time a new implementation is registered\n', '    * @param version representing the version name of the registered implementation\n', '    * @param implementation representing the address of the registered implementation\n', '    * @param contractName is the name of the contract we added new version\n', '    */\n', '    event VersionAdded(string version, address implementation, string contractName);\n', '\n', '    /**\n', '    * @dev Registers a new version with its implementation address\n', '    * @param version representing the version name of the new implementation to be registered\n', '    * @param implementation representing the address of the new implementation to be registered\n', '    */\n', '    function addVersion(string _contractName, string version, address implementation) public;\n', '\n', '    /**\n', '    * @dev Tells the address of the implementation for a given version\n', "    * @param _contractName is the name of the contract we're querying\n", '    * @param version to query the implementation of\n', '    * @return address of the implementation registered for the given version\n', '    */\n', '    function getVersion(string _contractName, string version) public view returns (address);\n', '}\n', '\n', 'contract TwoKeySingletonRegistryAbstract is ITwoKeySingletonesRegistry {\n', '\n', '    address public deployer;\n', '\n', '    string congress;\n', '    string maintainersRegistry;\n', '\n', '    mapping (string => mapping(string => address)) internal versions;\n', '\n', '    mapping (string => address) contractNameToProxyAddress;\n', '    mapping (string => string) contractNameToLatestAddedVersion;\n', '    mapping (string => address) nonUpgradableContractToAddress;\n', '    mapping (string => string) campaignTypeToLastApprovedVersion;\n', '\n', '\n', '    event ProxiesDeployed(\n', '        address logicProxy,\n', '        address storageProxy\n', '    );\n', '\n', '    modifier onlyMaintainer {\n', '        address twoKeyMaintainersRegistry = contractNameToProxyAddress[maintainersRegistry];\n', '        require(msg.sender == deployer || ITwoKeyMaintainersRegistry(twoKeyMaintainersRegistry).checkIsAddressMaintainer(msg.sender));\n', '        _;\n', '    }\n', '\n', '    modifier onlyCoreDev {\n', '        address twoKeyMaintainersRegistry = contractNameToProxyAddress[maintainersRegistry];\n', '        require(msg.sender == deployer || ITwoKeyMaintainersRegistry(twoKeyMaintainersRegistry).checkIsAddressCoreDev(msg.sender));\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Tells the address of the implementation for a given version\n', '     * @param version to query the implementation of\n', '     * @return address of the implementation registered for the given version\n', '     */\n', '    function getVersion(\n', '        string contractName,\n', '        string version\n', '    )\n', '    public\n', '    view\n', '    returns (address)\n', '    {\n', '        return versions[contractName][version];\n', '    }\n', '\n', '\n', '\n', '    /**\n', '     * @notice Gets the latest contract version\n', '     * @param contractName is the name of the contract\n', '     * @return string representation of the last version\n', '     */\n', '    function getLatestAddedContractVersion(\n', '        string contractName\n', '    )\n', '    public\n', '    view\n', '    returns (string)\n', '    {\n', '        return contractNameToLatestAddedVersion[contractName];\n', '    }\n', '\n', '\n', '    /**\n', '     * @notice Function to get address of non-upgradable contract\n', '     * @param contractName is the name of the contract\n', '     */\n', '    function getNonUpgradableContractAddress(\n', '        string contractName\n', '    )\n', '    public\n', '    view\n', '    returns (address)\n', '    {\n', '        return nonUpgradableContractToAddress[contractName];\n', '    }\n', '\n', '    /**\n', '     * @notice Function to return address of proxy for specific contract\n', "     * @param _contractName is the name of the contract we'd like to get proxy address\n", '     * @return is the address of the proxy for the specific contract\n', '     */\n', '    function getContractProxyAddress(\n', '        string _contractName\n', '    )\n', '    public\n', '    view\n', '    returns (address)\n', '    {\n', '        return contractNameToProxyAddress[_contractName];\n', '    }\n', '\n', '    /**\n', '     * @notice Function to get latest campaign approved version\n', '     * @param campaignType is type of campaign\n', '     */\n', '    function getLatestCampaignApprovedVersion(\n', '        string campaignType\n', '    )\n', '    public\n', '    view\n', '    returns (string)\n', '    {\n', '        return campaignTypeToLastApprovedVersion[campaignType];\n', '    }\n', '\n', '\n', '    /**\n', '     * @notice Function to add non upgradable contract in registry of all contracts\n', '     * @param contractName is the name of the contract\n', '     * @param contractAddress is the contract address\n', '     * @dev only maintainer can issue call to this method\n', '     */\n', '    function addNonUpgradableContractToAddress(\n', '        string contractName,\n', '        address contractAddress\n', '    )\n', '    public\n', '    onlyCoreDev\n', '    {\n', '        require(nonUpgradableContractToAddress[contractName] == 0x0);\n', '        nonUpgradableContractToAddress[contractName] = contractAddress;\n', '    }\n', '\n', '    /**\n', '     * @notice Function in case of hard fork, or congress replacement\n', '     * @param contractName is the name of contract we want to add\n', '     * @param contractAddress is the address of contract\n', '     */\n', '    function changeNonUpgradableContract(\n', '        string contractName,\n', '        address contractAddress\n', '    )\n', '    public\n', '    {\n', '        require(msg.sender == nonUpgradableContractToAddress[congress]);\n', '        nonUpgradableContractToAddress[contractName] = contractAddress;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Registers a new version with its implementation address\n', '     * @param version representing the version name of the new implementation to be registered\n', '     * @param implementation representing the address of the new implementation to be registered\n', '     */\n', '    function addVersion(\n', '        string contractName,\n', '        string version,\n', '        address implementation\n', '    )\n', '    public\n', '    onlyCoreDev\n', '    {\n', '        require(implementation != address(0)); //Require that version implementation is not 0x0\n', '        require(versions[contractName][version] == 0x0); //No overriding of existing versions\n', '        versions[contractName][version] = implementation; //Save the version for the campaign\n', '        contractNameToLatestAddedVersion[contractName] = version;\n', '        emit VersionAdded(version, implementation, contractName);\n', '    }\n', '\n', '    function addVersionDuringCreation(\n', '        string contractLogicName,\n', '        string contractStorageName,\n', '        address contractLogicImplementation,\n', '        address contractStorageImplementation,\n', '        string version\n', '    )\n', '    public\n', '    {\n', '        require(msg.sender == deployer);\n', '        bytes memory logicVersion = bytes(contractNameToLatestAddedVersion[contractLogicName]);\n', '        bytes memory storageVersion = bytes(contractNameToLatestAddedVersion[contractStorageName]);\n', '\n', '        require(logicVersion.length == 0 && storageVersion.length == 0); //Requiring that this is first time adding a version\n', '        require(keccak256(version) == keccak256("1.0.0")); //Requiring that first version is 1.0.0\n', '\n', '        versions[contractLogicName][version] = contractLogicImplementation; //Storing version\n', '        versions[contractStorageName][version] = contractStorageImplementation; //Storing version\n', '\n', '        contractNameToLatestAddedVersion[contractLogicName] = version; // Mapping latest contract name to the version\n', '        contractNameToLatestAddedVersion[contractStorageName] = version; //Mapping latest contract name to the version\n', '    }\n', '\n', '    /**\n', '     * @notice Internal function to deploy proxy for the contract\n', '     * @param contractName is the name of the contract\n', '     * @param version is the new version\n', '     */\n', '    function deployProxy(\n', '        string contractName,\n', '        string version\n', '    )\n', '    internal\n', '    returns (address)\n', '    {\n', '        UpgradeabilityProxy proxy = new UpgradeabilityProxy(contractName, version);\n', '        contractNameToProxyAddress[contractName] = proxy;\n', '        emit ProxyCreated(proxy);\n', '        return address(proxy);\n', '    }\n', '\n', '    /**\n', '     * @notice Function to upgrade contract to new version\n', '     * @param contractName is the name of the contract\n', '     * @param version is the new version\n', '     */\n', '    function upgradeContract(\n', '        string contractName,\n', '        string version\n', '    )\n', '    public\n', '    {\n', '        require(msg.sender == nonUpgradableContractToAddress[congress]);\n', '        address proxyAddress = getContractProxyAddress(contractName);\n', '        address _impl = getVersion(contractName, version);\n', '\n', '        UpgradeabilityProxy(proxyAddress).upgradeTo(contractName, version, _impl);\n', '    }\n', '\n', '    /**\n', "     * @notice Function to approve campaign version per type during it's creation\n", '     * @param campaignType is the type of campaign we want to approve during creation\n', '     */\n', '    function approveCampaignVersionDuringCreation(\n', '        string campaignType\n', '    )\n', '    public\n', '    onlyCoreDev\n', '    {\n', '        bytes memory campaign = bytes(campaignTypeToLastApprovedVersion[campaignType]);\n', '\n', '        require(campaign.length == 0);\n', '\n', '        campaignTypeToLastApprovedVersion[campaignType] = "1.0.0";\n', '    }\n', '\n', '    /**\n', '     * @notice Function to approve selected version for specific type of campaign\n', '     * @param campaignType is the type of campaign\n', '     * @param versionToApprove is the version for that type we want to approve\n', '     */\n', '    function approveCampaignVersion(\n', '        string campaignType,\n', '        string versionToApprove\n', '    )\n', '    public\n', '    {\n', '        require(msg.sender == nonUpgradableContractToAddress[congress]);\n', '        campaignTypeToLastApprovedVersion[campaignType] = versionToApprove;\n', '    }\n', '\n', '    /**\n', '     * @dev Creates an upgradeable proxy for both Storage and Logic\n', '     * @param version representing the first version to be set for the proxy\n', '     */\n', '    function createProxy(\n', '        string contractName,\n', '        string contractNameStorage,\n', '        string version\n', '    )\n', '    public\n', '    {\n', '        require(msg.sender == deployer);\n', '        require(contractNameToProxyAddress[contractName] == address(0));\n', '        address logicProxy = deployProxy(contractName, version);\n', '        address storageProxy = deployProxy(contractNameStorage, version);\n', '\n', '        IStructuredStorage(storageProxy).setProxyLogicContractAndDeployer(logicProxy, msg.sender);\n', '        emit ProxiesDeployed(logicProxy, storageProxy);\n', '    }\n', '\n', '    /**\n', '     * @notice Function to transfer deployer privileges to another address\n', '     * @param _newOwner is the new contract "owner" (called deployer in this case)\n', '     */\n', '    function transferOwnership(\n', '        address _newOwner\n', '    )\n', '    public\n', '    {\n', '        require(msg.sender == deployer);\n', '        deployer = _newOwner;\n', '    }\n', '\n', '\n', '\n', '}\n', '\n', 'contract TwoKeySingletonesRegistry is TwoKeySingletonRegistryAbstract {\n', '\n', '    constructor()\n', '    public\n', '    {\n', '        deployer = msg.sender;\n', '        congress = "TwoKeyCongress";\n', '        maintainersRegistry = "TwoKeyMaintainersRegistry";\n', '    }\n', '\n', '}\n', '\n', 'contract Proxy {\n', '\n', '\n', '    // Gives the possibility to delegate any call to a foreign implementation.\n', '\n', '\n', '    /**\n', '    * @dev Tells the address of the implementation where every call will be delegated.\n', '    * @return address of the implementation to which it will be delegated\n', '    */\n', '    function implementation() public view returns (address);\n', '\n', '    /**\n', '    * @dev Fallback function allowing to perform a delegatecall to the given implementation.\n', '    * This function will return whatever the implementation call returns\n', '    */\n', '    function () payable public {\n', '        address _impl = implementation();\n', '        require(_impl != address(0));\n', '\n', '        assembly {\n', '            let ptr := mload(0x40)\n', '            calldatacopy(ptr, 0, calldatasize)\n', '            let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)\n', '            let size := returndatasize\n', '            returndatacopy(ptr, 0, size)\n', '\n', '            switch result\n', '            case 0 { revert(ptr, size) }\n', '            default { return(ptr, size) }\n', '        }\n', '    }\n', '}\n', '\n', 'contract UpgradeabilityStorage {\n', '    // Versions registry\n', '    ITwoKeySingletonesRegistry internal registry;\n', '\n', '    // Address of the current implementation\n', '    address internal _implementation;\n', '\n', '    /**\n', '    * @dev Tells the address of the current implementation\n', '    * @return address of the current implementation\n', '    */\n', '    function implementation() public view returns (address) {\n', '        return _implementation;\n', '    }\n', '}\n', '\n', 'contract UpgradabilityProxyAcquisition is Proxy, UpgradeabilityStorage {\n', '\n', '    constructor (string _contractName, string _version) public {\n', '        registry = ITwoKeySingletonesRegistry(msg.sender);\n', '        _implementation = registry.getVersion(_contractName, _version);\n', '    }\n', '}\n', '\n', 'contract UpgradeabilityProxy is Proxy, UpgradeabilityStorage {\n', '\n', '    //TODO: Add event through event source whenever someone calls upgradeTo\n', '    /**\n', '    * @dev Constructor function\n', '    */\n', '    constructor (string _contractName, string _version) public {\n', '        registry = ITwoKeySingletonesRegistry(msg.sender);\n', '        _implementation = registry.getVersion(_contractName, _version);\n', '    }\n', '\n', '    /**\n', '    * @dev Upgrades the implementation to the requested version\n', '    * @param _version representing the version name of the new implementation to be set\n', '    */\n', '    function upgradeTo(string _contractName, string _version, address _impl) public {\n', '        require(msg.sender == address(registry));\n', '        require(_impl != address(0));\n', '        _implementation = _impl;\n', '    }\n', '\n', '}\n', '\n', 'contract Upgradeable is UpgradeabilityStorage {\n', '    /**\n', '     * @dev Validates the caller is the versions registry.\n', '     * @param sender representing the address deploying the initial behavior of the contract\n', '     */\n', '    function initialize(address sender) public payable {\n', '        require(msg.sender == address(registry));\n', '    }\n', '}']