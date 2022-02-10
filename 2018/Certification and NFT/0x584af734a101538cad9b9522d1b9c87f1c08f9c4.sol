['pragma solidity ^0.4.17;\n', '\n', '/*\n', '\n', ' * source       https://github.com/blockbitsio/\n', '\n', ' * @name        Application Entity Generic Contract\n', ' * @package     BlockBitsIO\n', ' * @author      Micky Socaci <micky@nowlive.ro>\n', '\n', '    Used for the ABI interface when assets need to call Application Entity.\n', '\n', '    This is required, otherwise we end up loading the assets themselves when we load the ApplicationEntity contract\n', '    and end up in a loop\n', '*/\n', '\n', '\n', '\n', 'contract ApplicationEntityABI {\n', '\n', '    address public ProposalsEntity;\n', '    address public FundingEntity;\n', '    address public MilestonesEntity;\n', '    address public MeetingsEntity;\n', '    address public BountyManagerEntity;\n', '    address public TokenManagerEntity;\n', '    address public ListingContractEntity;\n', '    address public FundingManagerEntity;\n', '    address public NewsContractEntity;\n', '\n', '    bool public _initialized = false;\n', '    bool public _locked = false;\n', '    uint8 public CurrentEntityState;\n', '    uint8 public AssetCollectionNum;\n', '    address public GatewayInterfaceAddress;\n', '    address public deployerAddress;\n', '    address testAddressAllowUpgradeFrom;\n', '    mapping (bytes32 => uint8) public EntityStates;\n', '    mapping (bytes32 => address) public AssetCollection;\n', '    mapping (uint8 => bytes32) public AssetCollectionIdToName;\n', '    mapping (bytes32 => uint256) public BylawsUint256;\n', '    mapping (bytes32 => bytes32) public BylawsBytes32;\n', '\n', '    function ApplicationEntity() public;\n', '    function getEntityState(bytes32 name) public view returns (uint8);\n', '    function linkToGateway( address _GatewayInterfaceAddress, bytes32 _sourceCodeUrl ) external;\n', '    function setUpgradeState(uint8 state) public ;\n', '    function addAssetProposals(address _assetAddresses) external;\n', '    function addAssetFunding(address _assetAddresses) external;\n', '    function addAssetMilestones(address _assetAddresses) external;\n', '    function addAssetMeetings(address _assetAddresses) external;\n', '    function addAssetBountyManager(address _assetAddresses) external;\n', '    function addAssetTokenManager(address _assetAddresses) external;\n', '    function addAssetFundingManager(address _assetAddresses) external;\n', '    function addAssetListingContract(address _assetAddresses) external;\n', '    function addAssetNewsContract(address _assetAddresses) external;\n', '    function getAssetAddressByName(bytes32 _name) public view returns (address);\n', '    function setBylawUint256(bytes32 name, uint256 value) public;\n', '    function getBylawUint256(bytes32 name) public view returns (uint256);\n', '    function setBylawBytes32(bytes32 name, bytes32 value) public;\n', '    function getBylawBytes32(bytes32 name) public view returns (bytes32);\n', '    function initialize() external returns (bool);\n', '    function getParentAddress() external view returns(address);\n', '    function createCodeUpgradeProposal( address _newAddress, bytes32 _sourceCodeUrl ) external returns (uint256);\n', '    function acceptCodeUpgradeProposal(address _newAddress) external;\n', '    function initializeAssetsToThisApplication() external returns (bool);\n', '    function transferAssetsToNewApplication(address _newAddress) external returns (bool);\n', '    function lock() external returns (bool);\n', '    function canInitiateCodeUpgrade(address _sender) public view returns(bool);\n', '    function doStateChanges() public;\n', '    function hasRequiredStateChanges() public view returns (bool);\n', '    function anyAssetHasChanges() public view returns (bool);\n', '    function extendedAnyAssetHasChanges() internal view returns (bool);\n', '    function getRequiredStateChanges() public view returns (uint8, uint8);\n', '    function getTimestamp() view public returns (uint256);\n', '\n', '}\n', '\n', '/*\n', '\n', ' * source       https://github.com/blockbitsio/\n', '\n', ' * @name        Application Asset Contract\n', ' * @package     BlockBitsIO\n', ' * @author      Micky Socaci <micky@nowlive.ro>\n', '\n', ' Any contract inheriting this will be usable as an Asset in the Application Entity\n', '\n', '*/\n', '\n', '\n', '\n', '\n', 'contract ApplicationAsset {\n', '\n', '    event EventAppAssetOwnerSet(bytes32 indexed _name, address indexed _owner);\n', '    event EventRunBeforeInit(bytes32 indexed _name);\n', '    event EventRunBeforeApplyingSettings(bytes32 indexed _name);\n', '\n', '\n', '    mapping (bytes32 => uint8) public EntityStates;\n', '    mapping (bytes32 => uint8) public RecordStates;\n', '    uint8 public CurrentEntityState;\n', '\n', '    event EventEntityProcessor(bytes32 indexed _assetName, uint8 indexed _current, uint8 indexed _required);\n', '    event DebugEntityRequiredChanges( bytes32 _assetName, uint8 indexed _current, uint8 indexed _required );\n', '\n', '    bytes32 public assetName;\n', '\n', '    /* Asset records */\n', '    uint8 public RecordNum = 0;\n', '\n', '    /* Asset initialised or not */\n', '    bool public _initialized = false;\n', '\n', '    /* Asset settings present or not */\n', '    bool public _settingsApplied = false;\n', '\n', '    /* Asset owner ( ApplicationEntity address ) */\n', '    address public owner = address(0x0) ;\n', '    address public deployerAddress;\n', '\n', '    function ApplicationAsset() public {\n', '        deployerAddress = msg.sender;\n', '    }\n', '\n', '    function setInitialApplicationAddress(address _ownerAddress) public onlyDeployer requireNotInitialised {\n', '        owner = _ownerAddress;\n', '    }\n', '\n', '    function setInitialOwnerAndName(bytes32 _name) external\n', '        requireNotInitialised\n', '        onlyOwner\n', '        returns (bool)\n', '    {\n', '        // init states\n', '        setAssetStates();\n', '        assetName = _name;\n', '        // set initial state\n', '        CurrentEntityState = getEntityState("NEW");\n', '        runBeforeInitialization();\n', '        _initialized = true;\n', '        EventAppAssetOwnerSet(_name, owner);\n', '        return true;\n', '    }\n', '\n', '    function setAssetStates() internal {\n', '        // Asset States\n', '        EntityStates["__IGNORED__"]     = 0;\n', '        EntityStates["NEW"]             = 1;\n', '        // Funding Stage States\n', '        RecordStates["__IGNORED__"]     = 0;\n', '    }\n', '\n', '    function getRecordState(bytes32 name) public view returns (uint8) {\n', '        return RecordStates[name];\n', '    }\n', '\n', '    function getEntityState(bytes32 name) public view returns (uint8) {\n', '        return EntityStates[name];\n', '    }\n', '\n', '    function runBeforeInitialization() internal requireNotInitialised  {\n', '        EventRunBeforeInit(assetName);\n', '    }\n', '\n', '    function applyAndLockSettings()\n', '        public\n', '        onlyDeployer\n', '        requireInitialised\n', '        requireSettingsNotApplied\n', '        returns(bool)\n', '    {\n', '        runBeforeApplyingSettings();\n', '        _settingsApplied = true;\n', '        return true;\n', '    }\n', '\n', '    function runBeforeApplyingSettings() internal requireInitialised requireSettingsNotApplied  {\n', '        EventRunBeforeApplyingSettings(assetName);\n', '    }\n', '\n', '    function transferToNewOwner(address _newOwner) public requireInitialised onlyOwner returns (bool) {\n', '        require(owner != address(0x0) && _newOwner != address(0x0));\n', '        owner = _newOwner;\n', '        EventAppAssetOwnerSet(assetName, owner);\n', '        return true;\n', '    }\n', '\n', '    function getApplicationAssetAddressByName(bytes32 _name)\n', '        public\n', '        view\n', '        returns(address)\n', '    {\n', '        address asset = ApplicationEntityABI(owner).getAssetAddressByName(_name);\n', '        if( asset != address(0x0) ) {\n', '            return asset;\n', '        } else {\n', '            revert();\n', '        }\n', '    }\n', '\n', '    function getApplicationState() public view returns (uint8) {\n', '        return ApplicationEntityABI(owner).CurrentEntityState();\n', '    }\n', '\n', '    function getApplicationEntityState(bytes32 name) public view returns (uint8) {\n', '        return ApplicationEntityABI(owner).getEntityState(name);\n', '    }\n', '\n', '    function getAppBylawUint256(bytes32 name) public view requireInitialised returns (uint256) {\n', '        ApplicationEntityABI CurrentApp = ApplicationEntityABI(owner);\n', '        return CurrentApp.getBylawUint256(name);\n', '    }\n', '\n', '    function getAppBylawBytes32(bytes32 name) public view requireInitialised returns (bytes32) {\n', '        ApplicationEntityABI CurrentApp = ApplicationEntityABI(owner);\n', '        return CurrentApp.getBylawBytes32(name);\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier onlyApplicationEntity() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier requireInitialised() {\n', '        require(_initialized == true);\n', '        _;\n', '    }\n', '\n', '    modifier requireNotInitialised() {\n', '        require(_initialized == false);\n', '        _;\n', '    }\n', '\n', '    modifier requireSettingsApplied() {\n', '        require(_settingsApplied == true);\n', '        _;\n', '    }\n', '\n', '    modifier requireSettingsNotApplied() {\n', '        require(_settingsApplied == false);\n', '        _;\n', '    }\n', '\n', '    modifier onlyDeployer() {\n', '        require(msg.sender == deployerAddress);\n', '        _;\n', '    }\n', '\n', '    modifier onlyAsset(bytes32 _name) {\n', '        address AssetAddress = getApplicationAssetAddressByName(_name);\n', '        require( msg.sender == AssetAddress);\n', '        _;\n', '    }\n', '\n', '    function getTimestamp() view public returns (uint256) {\n', '        return now;\n', '    }\n', '\n', '\n', '}\n', '\n', '/*\n', '\n', ' * source       https://github.com/blockbitsio/\n', '\n', ' * @name        Token Contract\n', ' * @package     BlockBitsIO\n', ' * @author      Micky Socaci <micky@nowlive.ro>\n', '\n', ' Zeppelin ERC20 Standard Token\n', '\n', '*/\n', '\n', '\n', '\n', 'contract ABIToken {\n', '\n', '    string public  symbol;\n', '    string public  name;\n', '    uint8 public   decimals;\n', '    uint256 public totalSupply;\n', '    string public  version;\n', '    mapping (address => uint256) public balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    address public manager;\n', '    address public deployer;\n', '    bool public mintingFinished = false;\n', '    bool public initialized = false;\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool);\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool);\n', '    function approve(address _spender, uint256 _value) public returns (bool);\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool success);\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success);\n', '    function mint(address _to, uint256 _amount) public returns (bool);\n', '    function finishMinting() public returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 indexed value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 indexed value);\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '}\n', '\n', '/*\n', '\n', ' * source       https://github.com/blockbitsio/\n', '\n', ' * @name        Token Stake Calculation And Distribution Algorithm - Type 3 - Sell a variable amount of tokens for a fixed price\n', ' * @package     BlockBitsIO\n', ' * @author      Micky Socaci <micky@nowlive.ro>\n', '\n', '\n', '    Inputs:\n', '\n', '    Defined number of tokens per wei ( X Tokens = 1 wei )\n', '    Received amount of ETH\n', '    Generates:\n', '\n', '    Total Supply of tokens available in Funding Phase respectively Project\n', '    Observations:\n', '\n', '    Will sell the whole supply of Tokens available to Current Funding Phase\n', '    Use cases:\n', '\n', '    Any Funding Phase where you want the first Funding Phase to determine the token supply of the whole Project\n', '\n', '*/\n', '\n', '\n', '\n', '\n', 'contract ABITokenSCADAVariable {\n', '    bool public SCADA_requires_hard_cap = true;\n', '    bool public initialized;\n', '    address public deployerAddress;\n', '    function addSettings(address _fundingContract) public;\n', '    function requiresHardCap() public view returns (bool);\n', '    function getTokensForValueInCurrentStage(uint256 _value) public view returns (uint256);\n', '    function getTokensForValueInStage(uint8 _stage, uint256 _value) public view returns (uint256);\n', '    function getBoughtTokens( address _vaultAddress, bool _direct ) public view returns (uint256);\n', '}\n', '\n', '/*\n', '\n', ' * source       https://github.com/blockbitsio/\n', '\n', ' * @name        Token Manager Contract\n', ' * @package     BlockBitsIO\n', ' * @author      Micky Socaci <micky@nowlive.ro>\n', '\n', '*/\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract TokenManager is ApplicationAsset {\n', '\n', '    ABITokenSCADAVariable public TokenSCADAEntity;\n', '    ABIToken public TokenEntity;\n', '    address public MarketingMethodAddress;\n', '\n', '    function addSettings(address _scadaAddress, address _tokenAddress, address _marketing ) onlyDeployer public {\n', '        TokenSCADAEntity = ABITokenSCADAVariable(_scadaAddress);\n', '        TokenEntity = ABIToken(_tokenAddress);\n', '        MarketingMethodAddress = _marketing;\n', '    }\n', '\n', '    function getTokenSCADARequiresHardCap() public view returns (bool) {\n', '        return TokenSCADAEntity.requiresHardCap();\n', '    }\n', '\n', '    function mint(address _to, uint256 _amount)\n', "        onlyAsset('FundingManager')\n", '        public\n', '        returns (bool)\n', '    {\n', '        return TokenEntity.mint(_to, _amount);\n', '    }\n', '\n', '    function finishMinting()\n', "        onlyAsset('FundingManager')\n", '        public\n', '        returns (bool)\n', '    {\n', '        return TokenEntity.finishMinting();\n', '    }\n', '\n', '    function mintForMarketingPool(address _to, uint256 _amount)\n', '        onlyMarketingPoolAsset\n', '        requireSettingsApplied\n', '        external\n', '        returns (bool)\n', '    {\n', '        return TokenEntity.mint(_to, _amount);\n', '    }\n', '\n', '    modifier onlyMarketingPoolAsset() {\n', '        require(msg.sender == MarketingMethodAddress);\n', '        _;\n', '    }\n', '\n', '    // Development stage complete, release tokens to Project Owners\n', '    event EventOwnerTokenBalancesReleased(address _addr, uint256 _value);\n', '    bool OwnerTokenBalancesReleased = false;\n', '\n', '    function ReleaseOwnersLockedTokens(address _multiSigOutputAddress)\n', '        public\n', "        onlyAsset('FundingManager')\n", '        returns (bool)\n', '    {\n', '        require(OwnerTokenBalancesReleased == false);\n', '        uint256 lockedBalance = TokenEntity.balanceOf(address(this));\n', '        TokenEntity.transfer( _multiSigOutputAddress, lockedBalance );\n', '        EventOwnerTokenBalancesReleased(_multiSigOutputAddress, lockedBalance);\n', '        OwnerTokenBalancesReleased = true;\n', '        return true;\n', '    }\n', '\n', '}']