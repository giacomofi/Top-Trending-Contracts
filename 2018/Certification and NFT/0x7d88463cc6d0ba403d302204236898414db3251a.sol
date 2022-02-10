['pragma solidity ^0.4.17;\n', '\n', '/*\n', '\n', ' * source       https://github.com/blockbitsio/\n', '\n', ' * @name        Application Entity Generic Contract\n', ' * @package     BlockBitsIO\n', ' * @author      Micky Socaci <micky@nowlive.ro>\n', '\n', '    Used for the ABI interface when assets need to call Application Entity.\n', '\n', '    This is required, otherwise we end up loading the assets themselves when we load the ApplicationEntity contract\n', '    and end up in a loop\n', '*/\n', '\n', '\n', '\n', 'contract ApplicationEntityABI {\n', '\n', '    address public ProposalsEntity;\n', '    address public FundingEntity;\n', '    address public MilestonesEntity;\n', '    address public MeetingsEntity;\n', '    address public BountyManagerEntity;\n', '    address public TokenManagerEntity;\n', '    address public ListingContractEntity;\n', '    address public FundingManagerEntity;\n', '    address public NewsContractEntity;\n', '\n', '    bool public _initialized = false;\n', '    bool public _locked = false;\n', '    uint8 public CurrentEntityState;\n', '    uint8 public AssetCollectionNum;\n', '    address public GatewayInterfaceAddress;\n', '    address public deployerAddress;\n', '    address testAddressAllowUpgradeFrom;\n', '    mapping (bytes32 => uint8) public EntityStates;\n', '    mapping (bytes32 => address) public AssetCollection;\n', '    mapping (uint8 => bytes32) public AssetCollectionIdToName;\n', '    mapping (bytes32 => uint256) public BylawsUint256;\n', '    mapping (bytes32 => bytes32) public BylawsBytes32;\n', '\n', '    function ApplicationEntity() public;\n', '    function getEntityState(bytes32 name) public view returns (uint8);\n', '    function linkToGateway( address _GatewayInterfaceAddress, bytes32 _sourceCodeUrl ) external;\n', '    function setUpgradeState(uint8 state) public ;\n', '    function addAssetProposals(address _assetAddresses) external;\n', '    function addAssetFunding(address _assetAddresses) external;\n', '    function addAssetMilestones(address _assetAddresses) external;\n', '    function addAssetMeetings(address _assetAddresses) external;\n', '    function addAssetBountyManager(address _assetAddresses) external;\n', '    function addAssetTokenManager(address _assetAddresses) external;\n', '    function addAssetFundingManager(address _assetAddresses) external;\n', '    function addAssetListingContract(address _assetAddresses) external;\n', '    function addAssetNewsContract(address _assetAddresses) external;\n', '    function getAssetAddressByName(bytes32 _name) public view returns (address);\n', '    function setBylawUint256(bytes32 name, uint256 value) public;\n', '    function getBylawUint256(bytes32 name) public view returns (uint256);\n', '    function setBylawBytes32(bytes32 name, bytes32 value) public;\n', '    function getBylawBytes32(bytes32 name) public view returns (bytes32);\n', '    function initialize() external returns (bool);\n', '    function getParentAddress() external view returns(address);\n', '    function createCodeUpgradeProposal( address _newAddress, bytes32 _sourceCodeUrl ) external returns (uint256);\n', '    function acceptCodeUpgradeProposal(address _newAddress) external;\n', '    function initializeAssetsToThisApplication() external returns (bool);\n', '    function transferAssetsToNewApplication(address _newAddress) external returns (bool);\n', '    function lock() external returns (bool);\n', '    function canInitiateCodeUpgrade(address _sender) public view returns(bool);\n', '    function doStateChanges() public;\n', '    function hasRequiredStateChanges() public view returns (bool);\n', '    function anyAssetHasChanges() public view returns (bool);\n', '    function extendedAnyAssetHasChanges() internal view returns (bool);\n', '    function getRequiredStateChanges() public view returns (uint8, uint8);\n', '    function getTimestamp() view public returns (uint256);\n', '\n', '}\n', '\n', '/*\n', '\n', ' * source       https://github.com/blockbitsio/\n', '\n', ' * @name        Application Asset Contract\n', ' * @package     BlockBitsIO\n', ' * @author      Micky Socaci <micky@nowlive.ro>\n', '\n', ' Any contract inheriting this will be usable as an Asset in the Application Entity\n', '\n', '*/\n', '\n', '\n', '\n', '\n', 'contract ApplicationAsset {\n', '\n', '    event EventAppAssetOwnerSet(bytes32 indexed _name, address indexed _owner);\n', '    event EventRunBeforeInit(bytes32 indexed _name);\n', '    event EventRunBeforeApplyingSettings(bytes32 indexed _name);\n', '\n', '\n', '    mapping (bytes32 => uint8) public EntityStates;\n', '    mapping (bytes32 => uint8) public RecordStates;\n', '    uint8 public CurrentEntityState;\n', '\n', '    event EventEntityProcessor(bytes32 indexed _assetName, uint8 indexed _current, uint8 indexed _required);\n', '    event DebugEntityRequiredChanges( bytes32 _assetName, uint8 indexed _current, uint8 indexed _required );\n', '\n', '    bytes32 public assetName;\n', '\n', '    /* Asset records */\n', '    uint8 public RecordNum = 0;\n', '\n', '    /* Asset initialised or not */\n', '    bool public _initialized = false;\n', '\n', '    /* Asset settings present or not */\n', '    bool public _settingsApplied = false;\n', '\n', '    /* Asset owner ( ApplicationEntity address ) */\n', '    address public owner = address(0x0) ;\n', '    address public deployerAddress;\n', '\n', '    function ApplicationAsset() public {\n', '        deployerAddress = msg.sender;\n', '    }\n', '\n', '    function setInitialApplicationAddress(address _ownerAddress) public onlyDeployer requireNotInitialised {\n', '        owner = _ownerAddress;\n', '    }\n', '\n', '    function setInitialOwnerAndName(bytes32 _name) external\n', '        requireNotInitialised\n', '        onlyOwner\n', '        returns (bool)\n', '    {\n', '        // init states\n', '        setAssetStates();\n', '        assetName = _name;\n', '        // set initial state\n', '        CurrentEntityState = getEntityState("NEW");\n', '        runBeforeInitialization();\n', '        _initialized = true;\n', '        EventAppAssetOwnerSet(_name, owner);\n', '        return true;\n', '    }\n', '\n', '    function setAssetStates() internal {\n', '        // Asset States\n', '        EntityStates["__IGNORED__"]     = 0;\n', '        EntityStates["NEW"]             = 1;\n', '        // Funding Stage States\n', '        RecordStates["__IGNORED__"]     = 0;\n', '    }\n', '\n', '    function getRecordState(bytes32 name) public view returns (uint8) {\n', '        return RecordStates[name];\n', '    }\n', '\n', '    function getEntityState(bytes32 name) public view returns (uint8) {\n', '        return EntityStates[name];\n', '    }\n', '\n', '    function runBeforeInitialization() internal requireNotInitialised  {\n', '        EventRunBeforeInit(assetName);\n', '    }\n', '\n', '    function applyAndLockSettings()\n', '        public\n', '        onlyDeployer\n', '        requireInitialised\n', '        requireSettingsNotApplied\n', '        returns(bool)\n', '    {\n', '        runBeforeApplyingSettings();\n', '        _settingsApplied = true;\n', '        return true;\n', '    }\n', '\n', '    function runBeforeApplyingSettings() internal requireInitialised requireSettingsNotApplied  {\n', '        EventRunBeforeApplyingSettings(assetName);\n', '    }\n', '\n', '    function transferToNewOwner(address _newOwner) public requireInitialised onlyOwner returns (bool) {\n', '        require(owner != address(0x0) && _newOwner != address(0x0));\n', '        owner = _newOwner;\n', '        EventAppAssetOwnerSet(assetName, owner);\n', '        return true;\n', '    }\n', '\n', '    function getApplicationAssetAddressByName(bytes32 _name)\n', '        public\n', '        view\n', '        returns(address)\n', '    {\n', '        address asset = ApplicationEntityABI(owner).getAssetAddressByName(_name);\n', '        if( asset != address(0x0) ) {\n', '            return asset;\n', '        } else {\n', '            revert();\n', '        }\n', '    }\n', '\n', '    function getApplicationState() public view returns (uint8) {\n', '        return ApplicationEntityABI(owner).CurrentEntityState();\n', '    }\n', '\n', '    function getApplicationEntityState(bytes32 name) public view returns (uint8) {\n', '        return ApplicationEntityABI(owner).getEntityState(name);\n', '    }\n', '\n', '    function getAppBylawUint256(bytes32 name) public view requireInitialised returns (uint256) {\n', '        ApplicationEntityABI CurrentApp = ApplicationEntityABI(owner);\n', '        return CurrentApp.getBylawUint256(name);\n', '    }\n', '\n', '    function getAppBylawBytes32(bytes32 name) public view requireInitialised returns (bytes32) {\n', '        ApplicationEntityABI CurrentApp = ApplicationEntityABI(owner);\n', '        return CurrentApp.getBylawBytes32(name);\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier onlyApplicationEntity() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier requireInitialised() {\n', '        require(_initialized == true);\n', '        _;\n', '    }\n', '\n', '    modifier requireNotInitialised() {\n', '        require(_initialized == false);\n', '        _;\n', '    }\n', '\n', '    modifier requireSettingsApplied() {\n', '        require(_settingsApplied == true);\n', '        _;\n', '    }\n', '\n', '    modifier requireSettingsNotApplied() {\n', '        require(_settingsApplied == false);\n', '        _;\n', '    }\n', '\n', '    modifier onlyDeployer() {\n', '        require(msg.sender == deployerAddress);\n', '        _;\n', '    }\n', '\n', '    modifier onlyAsset(bytes32 _name) {\n', '        address AssetAddress = getApplicationAssetAddressByName(_name);\n', '        require( msg.sender == AssetAddress);\n', '        _;\n', '    }\n', '\n', '    function getTimestamp() view public returns (uint256) {\n', '        return now;\n', '    }\n', '\n', '\n', '}\n', '\n', '/*\n', '\n', ' * source       https://github.com/blockbitsio/\n', '\n', ' * @name        News Contract\n', ' * @package     BlockBitsIO\n', ' * @author      Micky Socaci <micky@nowlive.ro>\n', '\n', " Contains This Application's News Items\n", '\n', '*/\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract NewsContract is ApplicationAsset {\n', '\n', '    // state types\n', '    // 1 - generic news item\n', '\n', '    // 2 - FUNDING FAILED\n', '    // 3 - FUNDING SUCCESSFUL\n', '    // 4 - MEETING DATE AND TIME SET\n', '    // 5 - VOTING INITIATED\n', '\n', '    // 10 - GLOBAL CASHBACK AVAILABLE\n', '    // 50 - CODE UPGRADE PROPOSAL INITIATED\n', '\n', '    // 100 - DEVELOPMENT COMPLETE, HELLO SKYNET\n', '\n', '    // news items\n', '    struct item {\n', '        string hash;\n', '        uint8 itemType;\n', '        uint256 length;\n', '    }\n', '\n', '    mapping ( uint256 => item ) public items;\n', '    uint256 public itemNum = 0;\n', '\n', '    event EventNewsItem(string _hash);\n', '    event EventNewsState(uint8 itemType);\n', '\n', '    function NewsContract() ApplicationAsset() public {\n', '\n', '    }\n', '\n', '    function addInternalMessage(uint8 state) public requireInitialised {\n', '        require(msg.sender == owner); // only application\n', '        item storage child = items[++itemNum];\n', '        child.itemType = state;\n', '        EventNewsState(state);\n', '    }\n', '\n', '    function addItem(string _hash, uint256 _length) public onlyAppDeployer requireInitialised {\n', '        item storage child = items[++itemNum];\n', '        child.hash = _hash;\n', '        child.itemType = 1;\n', '        child.length = _length;\n', '        EventNewsItem(_hash);\n', '    }\n', '\n', '    modifier onlyAppDeployer() {\n', '        ApplicationEntityABI currentApp = ApplicationEntityABI(owner);\n', '        require(msg.sender == currentApp.deployerAddress());\n', '        _;\n', '    }\n', '}']