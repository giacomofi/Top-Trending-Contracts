['pragma solidity ^0.4.17;\n', '\n', 'contract Enums {\n', '    enum ResultCode {\n', '        SUCCESS,\n', '        ERROR_CLASS_NOT_FOUND,\n', '        ERROR_LOW_BALANCE,\n', '        ERROR_SEND_FAIL,\n', '        ERROR_NOT_OWNER,\n', '        ERROR_NOT_ENOUGH_MONEY,\n', '        ERROR_INVALID_AMOUNT\n', '    }\n', '\n', '    enum AngelAura { \n', '        Blue, \n', '        Yellow, \n', '        Purple, \n', '        Orange, \n', '        Red, \n', '        Green \n', '    }\n', '}\n', 'contract AccessControl {\n', '    address public creatorAddress;\n', '    uint16 public totalSeraphims = 0;\n', '    mapping (address => bool) public seraphims;\n', '\n', '    bool public isMaintenanceMode = true;\n', ' \n', '    modifier onlyCREATOR() {\n', '        require(msg.sender == creatorAddress);\n', '        _;\n', '    }\n', '\n', '    modifier onlySERAPHIM() {\n', '      \n', '      require(seraphims[msg.sender] == true);\n', '        _;\n', '    }\n', '    modifier isContractActive {\n', '        require(!isMaintenanceMode);\n', '        _;\n', '    }\n', '    \n', '   // Constructor\n', '    function AccessControl() public {\n', '        creatorAddress = msg.sender;\n', '    }\n', '    \n', '\n', '    function addSERAPHIM(address _newSeraphim) onlyCREATOR public {\n', '        if (seraphims[_newSeraphim] == false) {\n', '            seraphims[_newSeraphim] = true;\n', '            totalSeraphims += 1;\n', '        }\n', '    }\n', '    \n', '    function removeSERAPHIM(address _oldSeraphim) onlyCREATOR public {\n', '        if (seraphims[_oldSeraphim] == true) {\n', '            seraphims[_oldSeraphim] = false;\n', '            totalSeraphims -= 1;\n', '        }\n', '    }\n', '\n', '    function updateMaintenanceMode(bool _isMaintaining) onlyCREATOR public {\n', '        isMaintenanceMode = _isMaintaining;\n', '    }\n', '\n', '  \n', '} \n', 'contract IABToken is AccessControl {\n', ' \n', ' \n', '    function balanceOf(address owner) public view returns (uint256);\n', '    function totalSupply() external view returns (uint256) ;\n', '    function ownerOf(uint256 tokenId) public view returns (address) ;\n', '    function setMaxAngels() external;\n', '    function setMaxAccessories() external;\n', '    function setMaxMedals()  external ;\n', '    function initAngelPrices() external;\n', '    function initAccessoryPrices() external ;\n', '    function setCardSeriesPrice(uint8 _cardSeriesId, uint _newPrice) external;\n', '    function approve(address to, uint256 tokenId) public;\n', '    function getRandomNumber(uint16 maxRandom, uint8 min, address privateAddress) view public returns(uint8) ;\n', '    function tokenURI(uint256 _tokenId) public pure returns (string memory) ;\n', '    function baseTokenURI() public pure returns (string memory) ;\n', '    function name() external pure returns (string memory _name) ;\n', '    function symbol() external pure returns (string memory _symbol) ;\n', '    function getApproved(uint256 tokenId) public view returns (address) ;\n', '    function setApprovalForAll(address to, bool approved) public ;\n', '    function isApprovedForAll(address owner, address operator) public view returns (bool);\n', '    function transferFrom(address from, address to, uint256 tokenId) public ;\n', '    function safeTransferFrom(address from, address to, uint256 tokenId) public ;\n', '    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public ;\n', '    function _exists(uint256 tokenId) internal view returns (bool) ;\n', '    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) ;\n', '    function _mint(address to, uint256 tokenId) internal ;\n', '    function mintABToken(address owner, uint8 _cardSeriesId, uint16 _power, uint16 _auraRed, uint16 _auraYellow, uint16 _auraBlue, string memory _name, uint16 _experience, uint16 _oldId) public;\n', '    function addABTokenIdMapping(address _owner, uint256 _tokenId) private ;\n', '    function getPrice(uint8 _cardSeriesId) public view returns (uint);\n', '    function buyAngel(uint8 _angelSeriesId) public payable ;\n', '    function buyAccessory(uint8 _accessorySeriesId) public payable ;\n', '    function getAura(uint8 _angelSeriesId) pure public returns (uint8 auraRed, uint8 auraYellow, uint8 auraBlue) ;\n', '    function getAngelPower(uint8 _angelSeriesId) private view returns (uint16) ;\n', '    function getABToken(uint256 tokenId) view public returns(uint8 cardSeriesId, uint16 power, uint16 auraRed, uint16 auraYellow, uint16 auraBlue, string memory name, uint16 experience, uint64 lastBattleTime, uint16 lastBattleResult, address owner, uint16 oldId);\n', '    function setAuras(uint256 tokenId, uint16 _red, uint16 _blue, uint16 _yellow) external;\n', '    function setName(uint256 tokenId,string memory namechange) public ;\n', '    function setExperience(uint256 tokenId, uint16 _experience) external;\n', '    function setLastBattleResult(uint256 tokenId, uint16 _result) external ;\n', '    function setLastBattleTime(uint256 tokenId) external;\n', '    function setLastBreedingTime(uint256 tokenId) external ;\n', '    function setoldId(uint256 tokenId, uint16 _oldId) external;\n', '    function getABTokenByIndex(address _owner, uint64 _index) view external returns(uint256) ;\n', '    function _burn(address owner, uint256 tokenId) internal ;\n', '    function _burn(uint256 tokenId) internal ;\n', '    function _transferFrom(address from, address to, uint256 tokenId) internal ;\n', '    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) internal returns (bool);\n', '    function _clearApproval(uint256 tokenId) private ;\n', '}\n', '\n', '\n', 'contract IPetCardData is AccessControl, Enums {\n', '    uint8 public totalPetCardSeries;    \n', '    uint64 public totalPets;\n', '    \n', '    // write\n', '    function createPetCardSeries(uint8 _petCardSeriesId, uint32 _maxTotal) onlyCREATOR public returns(uint8);\n', '    function setPet(uint8 _petCardSeriesId, address _owner, string _name, uint8 _luck, uint16 _auraRed, uint16 _auraYellow, uint16 _auraBlue) onlySERAPHIM external returns(uint64);\n', '    function setPetAuras(uint64 _petId, uint8 _auraRed, uint8 _auraBlue, uint8 _auraYellow) onlySERAPHIM external;\n', '    function setPetLastTrainingTime(uint64 _petId) onlySERAPHIM external;\n', '    function setPetLastBreedingTime(uint64 _petId) onlySERAPHIM external;\n', '    function addPetIdMapping(address _owner, uint64 _petId) private;\n', '    function transferPet(address _from, address _to, uint64 _petId) onlySERAPHIM public returns(ResultCode);\n', '    function ownerPetTransfer (address _to, uint64 _petId)  public;\n', '    function setPetName(string _name, uint64 _petId) public;\n', '\n', '    // read\n', '    function getPetCardSeries(uint8 _petCardSeriesId) constant public returns(uint8 petCardSeriesId, uint32 currentPetTotal, uint32 maxPetTotal);\n', '    function getPet(uint _petId) constant public returns(uint petId, uint8 petCardSeriesId, string name, uint8 luck, uint16 auraRed, uint16 auraBlue, uint16 auraYellow, uint64 lastTrainingTime, uint64 lastBreedingTime, address owner);\n', '    function getOwnerPetCount(address _owner) constant public returns(uint);\n', '    function getPetByIndex(address _owner, uint _index) constant public returns(uint);\n', '    function getTotalPetCardSeries() constant public returns (uint8);\n', '    function getTotalPets() constant public returns (uint);\n', '}\n', '\n', 'contract IAngelCardData is AccessControl, Enums {\n', '    uint8 public totalAngelCardSeries;\n', '    uint64 public totalAngels;\n', '\n', '    \n', '    // write\n', '    // angels\n', '    function createAngelCardSeries(uint8 _angelCardSeriesId, uint _basePrice,  uint64 _maxTotal, uint8 _baseAura, uint16 _baseBattlePower, uint64 _liveTime) onlyCREATOR external returns(uint8);\n', '    function updateAngelCardSeries(uint8 _angelCardSeriesId, uint64 _newPrice, uint64 _newMaxTotal) onlyCREATOR external;\n', '    function setAngel(uint8 _angelCardSeriesId, address _owner, uint _price, uint16 _battlePower) onlySERAPHIM external returns(uint64);\n', '    function addToAngelExperienceLevel(uint64 _angelId, uint _value) onlySERAPHIM external;\n', '    function setAngelLastBattleTime(uint64 _angelId) onlySERAPHIM external;\n', '    function setAngelLastVsBattleTime(uint64 _angelId) onlySERAPHIM external;\n', '    function setLastBattleResult(uint64 _angelId, uint16 _value) onlySERAPHIM external;\n', '    function addAngelIdMapping(address _owner, uint64 _angelId) private;\n', '    function transferAngel(address _from, address _to, uint64 _angelId) onlySERAPHIM public returns(ResultCode);\n', '    function ownerAngelTransfer (address _to, uint64 _angelId)  public;\n', '    function updateAngelLock (uint64 _angelId, bool newValue) public;\n', '    function removeCreator() onlyCREATOR external;\n', '\n', '    // read\n', '    function getAngelCardSeries(uint8 _angelCardSeriesId) constant public returns(uint8 angelCardSeriesId, uint64 currentAngelTotal, uint basePrice, uint64 maxAngelTotal, uint8 baseAura, uint baseBattlePower, uint64 lastSellTime, uint64 liveTime);\n', '    function getAngel(uint64 _angelId) constant public returns(uint64 angelId, uint8 angelCardSeriesId, uint16 battlePower, uint8 aura, uint16 experience, uint price, uint64 createdTime, uint64 lastBattleTime, uint64 lastVsBattleTime, uint16 lastBattleResult, address owner);\n', '    function getOwnerAngelCount(address _owner) constant public returns(uint);\n', '    function getAngelByIndex(address _owner, uint _index) constant public returns(uint64);\n', '    function getTotalAngelCardSeries() constant public returns (uint8);\n', '    function getTotalAngels() constant public returns (uint64);\n', '    function getAngelLockStatus(uint64 _angelId) constant public returns (bool);\n', '}\n', '\n', 'contract IAccessoryData is AccessControl, Enums {\n', '    uint8 public totalAccessorySeries;    \n', '    uint32 public totalAccessories;\n', '    \n', ' \n', '    /*** FUNCTIONS ***/\n', '    //*** Write Access ***//\n', '    function createAccessorySeries(uint8 _AccessorySeriesId, uint32 _maxTotal, uint _price) onlyCREATOR public returns(uint8) ;\n', '\tfunction setAccessory(uint8 _AccessorySeriesId, address _owner) onlySERAPHIM external returns(uint64);\n', '   function addAccessoryIdMapping(address _owner, uint64 _accessoryId) private;\n', '\tfunction transferAccessory(address _from, address _to, uint64 __accessoryId) onlySERAPHIM public returns(ResultCode);\n', '    function ownerAccessoryTransfer (address _to, uint64 __accessoryId)  public;\n', '    function updateAccessoryLock (uint64 _accessoryId, bool newValue) public;\n', '    function removeCreator() onlyCREATOR external;\n', '    \n', '    //*** Read Access ***//\n', '    function getAccessorySeries(uint8 _accessorySeriesId) constant public returns(uint8 accessorySeriesId, uint32 currentTotal, uint32 maxTotal, uint price) ;\n', '\tfunction getAccessory(uint _accessoryId) constant public returns(uint accessoryID, uint8 AccessorySeriesID, address owner);\n', '\tfunction getOwnerAccessoryCount(address _owner) constant public returns(uint);\n', '\tfunction getAccessoryByIndex(address _owner, uint _index) constant public returns(uint) ;\n', '    function getTotalAccessorySeries() constant public returns (uint8) ;\n', '    function getTotalAccessories() constant public returns (uint);\n', '    function getAccessoryLockStatus(uint64 _acessoryId) constant public returns (bool);\n', '}\n', '\n', '\n', 'contract ABTokenTransfer is AccessControl {\n', '    // Addresses for other contracts ABTokenTransfer interacts with. \n', '  \n', '    address public angelCardDataContract = 0x6D2E76213615925c5fc436565B5ee788Ee0E86DC;\n', '    address public petCardDataContract = 0xB340686da996b8B3d486b4D27E38E38500A9E926;\n', '    address public accessoryDataContract = 0x466c44812835f57b736ef9F63582b8a6693A14D0;\n', '    address public ABTokenDataContract = 0xDC32FF5aaDA11b5cE3CAf2D00459cfDA05293F96;\n', ' \n', '\n', '    \n', '    /*** DATA TYPES ***/\n', '\n', '\n', '    struct Angel {\n', '        uint64 angelId;\n', '        uint8 angelCardSeriesId;\n', '        address owner;\n', '        uint16 battlePower;\n', '        uint8 aura;\n', '        uint16 experience;\n', '        uint price;\n', '        uint64 createdTime;\n', '        uint64 lastBattleTime;\n', '        uint64 lastVsBattleTime;\n', '        uint16 lastBattleResult;\n', '    }\n', '\n', '    struct Pet {\n', '        uint petId;\n', '        uint8 petCardSeriesId;\n', '        address owner;\n', '        string name;\n', '        uint8 luck;\n', '        uint16 auraRed;\n', '        uint16 auraYellow;\n', '        uint16 auraBlue;\n', '        uint64 lastTrainingTime;\n', '        uint64 lastBreedingTime;\n', '        uint price; \n', '        uint64 liveTime;\n', '    }\n', '    \n', '     struct Accessory {\n', '        uint16 accessoryId;\n', '        uint8 accessorySeriesId;\n', '        address owner;\n', '    }\n', '\n', '\n', '    // write functions\n', '    function DataContacts(address _angelCardDataContract, address _petCardDataContract, address _accessoryDataContract, address _ABTokenDataContract) onlyCREATOR external {\n', '        angelCardDataContract = _angelCardDataContract;\n', '        petCardDataContract = _petCardDataContract;\n', '        accessoryDataContract = _accessoryDataContract;\n', '        ABTokenDataContract = _ABTokenDataContract;\n', '     \n', '      \n', '    }\n', '   \n', '  function claimPet(uint64 petID) public {\n', '       IPetCardData petCardData = IPetCardData(petCardDataContract);\n', '       IABToken ABTokenData = IABToken(ABTokenDataContract);\n', '       if ((petID <= 0) || (petID > petCardData.getTotalPets())) {revert();}\n', '       Pet memory pet;\n', '       (pet.petId,pet.petCardSeriesId,,pet.luck,pet.auraRed,pet.auraBlue,pet.auraYellow,,,pet.owner) = petCardData.getPet(petID);\n', '       if ((msg.sender != pet.owner) && (seraphims[msg.sender] == false)) {revert();}\n', '       //First burn the old pet by transfering to 0x0;\n', '       petCardData.transferPet(pet.owner,0x0,petID);\n', '       //finally create the new one. \n', '       ABTokenData.mintABToken(pet.owner,pet.petCardSeriesId + 23, pet.luck, pet.auraRed, pet.auraYellow, pet.auraBlue, pet.name,0, uint16(pet.petId));\n', '  }\n', '       \n', '    function claimAccessory(uint64 accessoryID) public {\n', '       IAccessoryData accessoryData = IAccessoryData(accessoryDataContract);\n', '       IABToken ABTokenData = IABToken(ABTokenDataContract);\n', '       if ((accessoryID <= 0) || (accessoryID > accessoryData.getTotalAccessories())) {revert();}\n', '      Accessory memory accessory;\n', '       (,accessory.accessorySeriesId,accessory.owner) = accessoryData.getAccessory(accessoryID);\n', '       \n', '       //First burn the old accessory by transfering to 0x0;\n', '       // transfer function will revert if the accessory is still locked. \n', '       accessoryData.transferAccessory(accessory.owner,0x0,accessoryID);\n', '       //finally create the new one. \n', '       ABTokenData.mintABToken(accessory.owner,accessory.accessorySeriesId + 42, 0, 0, 0, 0, "0",0, uint16(accessoryID));\n', '  }\n', '       \n', '       function claimAngel(uint64 angelID) public {\n', '       IAngelCardData angelCardData = IAngelCardData(angelCardDataContract);\n', '       IABToken ABTokenData = IABToken(ABTokenDataContract);\n', '       if ((angelID <= 0) || (angelID > angelCardData.getTotalAngels())) {revert();}\n', '       Angel memory angel;\n', '       (angel.angelId, angel.angelCardSeriesId, angel.battlePower, angel.aura, angel.experience,,,,,, angel.owner) = angelCardData.getAngel(angelID);\n', '       \n', '       //First burn the old angel by transfering to 0x0;\n', '       //transfer will fail if card is locked. \n', '       angelCardData.transferAngel(angel.owner,0x0,angel.angelId);\n', '       //finally create the new one.\n', '       uint16 auraRed = 0;\n', '       uint16 auraYellow = 0;\n', '       uint16 auraBlue = 0;\n', '       if (angel.aura == 1)  {auraBlue = 1;} //blue aura\n', '       if (angel.aura == 2)  {auraYellow = 1;} //yellow Aura \n', '       if (angel.aura == 3)  {auraBlue = 1; auraRed = 1;} //purple Aura\n', '       if (angel.aura == 4)  {auraYellow = 1; auraRed = 1;} //orange Aura  \n', '       if (angel.aura == 5)  {auraRed = 1;} //red Aura\n', '       if (angel.aura == 6)  {auraBlue = 1; auraYellow =1;} //green Aura\n', '       ABTokenData.mintABToken(angel.owner,angel.angelCardSeriesId, angel.battlePower, auraRed, auraYellow, auraBlue,"0",angel.experience, uint16(angel.angelId));\n', '  }\n', '       \n', '       \n', '        \n', '     \n', '      function kill() onlyCREATOR external {\n', '        selfdestruct(creatorAddress);\n', '    }\n', '}']