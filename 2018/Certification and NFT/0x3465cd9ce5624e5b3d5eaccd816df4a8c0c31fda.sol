['pragma solidity ^0.4.18;\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    Unpause();\n', '  }\n', '}\n', '\n', 'contract SkinBase is Pausable {\n', '\n', '    struct Skin {\n', '        uint128 appearance;\n', '        uint64 cooldownEndTime;\n', '        uint64 mixingWithId;\n', '    }\n', '\n', '    // All skins, mapping from skin id to skin apprance\n', '    mapping (uint256 => Skin) skins;\n', '\n', '    // Mapping from skin id to owner\n', '    mapping (uint256 => address) public skinIdToOwner;\n', '\n', '    // Whether a skin is on sale\n', '    mapping (uint256 => bool) public isOnSale;\n', '\n', '    // Number of all total valid skins\n', '    // skinId 0 should not correspond to any skin, because skin.mixingWithId==0 indicates not mixing\n', '    uint256 public nextSkinId = 1;  \n', '\n', '    // Number of skins an account owns\n', '    mapping (address => uint256) public numSkinOfAccounts;\n', '\n', '    // // Give some skins to init account for unit tests\n', '    // function SkinBase() public {\n', '    //     address account0 = 0x627306090abaB3A6e1400e9345bC60c78a8BEf57;\n', '    //     address account1 = 0xf17f52151EbEF6C7334FAD080c5704D77216b732;\n', '\n', '    //     // Create simple skins\n', '    //     Skin memory skin = Skin({appearance: 0, cooldownEndTime:0, mixingWithId: 0});\n', '    //     for (uint256 i = 1; i <= 15; i++) {\n', '    //         if (i < 10) {\n', '    //             skin.appearance = uint128(i);\n', '    //             if (i < 7) { \n', '    //                 skinIdToOwner[i] = account0;\n', '    //                 numSkinOfAccounts[account0] += 1;\n', '    //             } else {  \n', '    //                 skinIdToOwner[i] = account1;\n', '    //                 numSkinOfAccounts[account1] += 1;\n', '    //             }\n', '    //         } else {  \n', '    //             skin.appearance = uint128(block.blockhash(block.number - i + 9));\n', '    //             skinIdToOwner[i] = account1;\n', '    //             numSkinOfAccounts[account1] += 1;\n', '    //         }\n', '    //         skins[i] = skin;\n', '    //         isOnSale[i] = false;\n', '    //         nextSkinId += 1;\n', '    //     }\n', '    // } \n', '\n', '    // Get the i-th skin an account owns, for off-chain usage only\n', '    function skinOfAccountById(address account, uint256 id) external view returns (uint256) {\n', '       uint256 count = 0;\n', '       uint256 numSkinOfAccount = numSkinOfAccounts[account];\n', '       require(numSkinOfAccount > 0);\n', '       require(id < numSkinOfAccount);\n', '       for (uint256 i = 1; i < nextSkinId; i++) {\n', '           if (skinIdToOwner[i] == account) {\n', '               // This skin belongs to current account\n', '               if (count == id) {\n', '                   // This is the id-th skin of current account, a.k.a, what we need\n', '                    return i;\n', '               } \n', '               count++;\n', '           }\n', '        }\n', '        revert();\n', '    }\n', '\n', '    // Get skin by id\n', '    function getSkin(uint256 id) public view returns (uint128, uint64, uint64) {\n', '        require(id > 0);\n', '        require(id < nextSkinId);\n', '        Skin storage skin = skins[id];\n', '        return (skin.appearance, skin.cooldownEndTime, skin.mixingWithId);\n', '    }\n', '\n', '    function withdrawETH() external onlyOwner {\n', '        owner.transfer(this.balance);\n', '    }\n', '}\n', 'contract MixFormulaInterface {\n', '    function calcNewSkinAppearance(uint128 x, uint128 y) public pure returns (uint128);\n', '\n', '    // create random appearance\n', '    function randomSkinAppearance() public view returns (uint128);\n', '\n', '    // bleach\n', '    function bleachAppearance(uint128 appearance, uint128 attributes) public pure returns (uint128);\n', '}\n', 'contract SkinMix is SkinBase {\n', '\n', '    // Mix formula\n', '    MixFormulaInterface public mixFormula;\n', '\n', '\n', '    // Pre-paid ether for synthesization, will be returned to user if the synthesization failed (minus gas).\n', '    uint256 public prePaidFee = 1000000 * 3000000000; // (1million gas * 3 gwei)\n', '\n', '    // Events\n', '    event MixStart(address account, uint256 skinAId, uint256 skinBId);\n', '    event AutoMix(address account, uint256 skinAId, uint256 skinBId, uint64 cooldownEndTime);\n', '    event MixSuccess(address account, uint256 skinId, uint256 skinAId, uint256 skinBId);\n', '\n', '    // Set mix formula contract address \n', '    function setMixFormulaAddress(address mixFormulaAddress) external onlyOwner {\n', '        mixFormula = MixFormulaInterface(mixFormulaAddress);\n', '    }\n', '\n', '    // setPrePaidFee: set advance amount, only owner can call this\n', '    function setPrePaidFee(uint256 newPrePaidFee) external onlyOwner {\n', '        prePaidFee = newPrePaidFee;\n', '    }\n', '\n', '    // _isCooldownReady: check whether cooldown period has been passed\n', '    function _isCooldownReady(uint256 skinAId, uint256 skinBId) private view returns (bool) {\n', '        return (skins[skinAId].cooldownEndTime <= uint64(now)) && (skins[skinBId].cooldownEndTime <= uint64(now));\n', '    }\n', '\n', '    // _isNotMixing: check whether two skins are in another mixing process\n', '    function _isNotMixing(uint256 skinAId, uint256 skinBId) private view returns (bool) {\n', '        return (skins[skinAId].mixingWithId == 0) && (skins[skinBId].mixingWithId == 0);\n', '    }\n', '\n', '    // _setCooldownTime: set new cooldown time\n', '    function _setCooldownEndTime(uint256 skinAId, uint256 skinBId) private {\n', '        uint256 end = now + 5 minutes;\n', '        // uint256 end = now;\n', '        skins[skinAId].cooldownEndTime = uint64(end);\n', '        skins[skinBId].cooldownEndTime = uint64(end);\n', '    }\n', '\n', '    // _isValidSkin: whether an account can mix using these skins\n', '    // Make sure two things:\n', '    // 1. these two skins do exist\n', '    // 2. this account owns these skins\n', '    function _isValidSkin(address account, uint256 skinAId, uint256 skinBId) private view returns (bool) {\n', '        // Make sure those two skins belongs to this account\n', '        if (skinAId == skinBId) {\n', '            return false;\n', '        }\n', '        if ((skinAId == 0) || (skinBId == 0)) {\n', '            return false;\n', '        }\n', '        if ((skinAId >= nextSkinId) || (skinBId >= nextSkinId)) {\n', '            return false;\n', '        }\n', '        return (skinIdToOwner[skinAId] == account) && (skinIdToOwner[skinBId] == account);\n', '    }\n', '\n', '    // _isNotOnSale: whether a skin is not on sale\n', '    function _isNotOnSale(uint256 skinId) private view returns (bool) {\n', '        return (isOnSale[skinId] == false);\n', '    }\n', '\n', '    // mix  \n', '    function mix(uint256 skinAId, uint256 skinBId) public whenNotPaused {\n', '\n', '        // Check whether skins are valid\n', '        require(_isValidSkin(msg.sender, skinAId, skinBId));\n', '\n', '        // Check whether skins are neither on sale\n', '        require(_isNotOnSale(skinAId) && _isNotOnSale(skinBId));\n', '\n', '        // Check cooldown\n', '        require(_isCooldownReady(skinAId, skinBId));\n', '\n', '        // Check these skins are not in another process\n', '        require(_isNotMixing(skinAId, skinBId));\n', '\n', '        // Set new cooldown time\n', '        _setCooldownEndTime(skinAId, skinBId);\n', '\n', '        // Mark skins as in mixing\n', '        skins[skinAId].mixingWithId = uint64(skinBId);\n', '        skins[skinBId].mixingWithId = uint64(skinAId);\n', '\n', '        // Emit MixStart event\n', '        MixStart(msg.sender, skinAId, skinBId);\n', '    }\n', '\n', '    // Mixing auto\n', '    function mixAuto(uint256 skinAId, uint256 skinBId) public payable whenNotPaused {\n', '        require(msg.value >= prePaidFee);\n', '\n', '        mix(skinAId, skinBId);\n', '\n', '        Skin storage skin = skins[skinAId];\n', '\n', '        AutoMix(msg.sender, skinAId, skinBId, skin.cooldownEndTime);\n', '    }\n', '\n', '    // Get mixing result, return the resulted skin id\n', '    function getMixingResult(uint256 skinAId, uint256 skinBId) public whenNotPaused {\n', '        // Check these two skins belongs to the same account\n', '        address account = skinIdToOwner[skinAId];\n', '        require(account == skinIdToOwner[skinBId]);\n', '\n', '        // Check these two skins are in the same mixing process\n', '        Skin storage skinA = skins[skinAId];\n', '        Skin storage skinB = skins[skinBId];\n', '        require(skinA.mixingWithId == uint64(skinBId));\n', '        require(skinB.mixingWithId == uint64(skinAId));\n', '\n', '        // Check cooldown\n', '        require(_isCooldownReady(skinAId, skinBId));\n', '\n', '        // Create new skin\n', '        uint128 newSkinAppearance = mixFormula.calcNewSkinAppearance(skinA.appearance, skinB.appearance);\n', '        Skin memory newSkin = Skin({appearance: newSkinAppearance, cooldownEndTime: uint64(now), mixingWithId: 0});\n', '        skins[nextSkinId] = newSkin;\n', '        skinIdToOwner[nextSkinId] = account;\n', '        isOnSale[nextSkinId] = false;\n', '        nextSkinId++;\n', '\n', '        // Clear old skins\n', '        skinA.mixingWithId = 0;\n', '        skinB.mixingWithId = 0;\n', '\n', '        // In order to distinguish created skins in minting with destroyed skins\n', '        // skinIdToOwner[skinAId] = owner;\n', '        // skinIdToOwner[skinBId] = owner;\n', '        delete skinIdToOwner[skinAId];\n', '        delete skinIdToOwner[skinBId];\n', '        // require(numSkinOfAccounts[account] >= 2);\n', '        numSkinOfAccounts[account] -= 1;\n', '\n', '        MixSuccess(account, nextSkinId - 1, skinAId, skinBId);\n', '    }\n', '}\n', 'contract SkinMarket is SkinMix {\n', '\n', '    // Cut ratio for a transaction\n', '    // Values 0-10,000 map to 0%-100%\n', '    uint128 public trCut = 400;\n', '\n', '    // Sale orders list \n', '    mapping (uint256 => uint256) public desiredPrice;\n', '\n', '    // events\n', '    event PutOnSale(address account, uint256 skinId);\n', '    event WithdrawSale(address account, uint256 skinId);\n', '    event BuyInMarket(address buyer, uint256 skinId);\n', '\n', '    // functions\n', '\n', '    // Put asset on sale\n', '    function putOnSale(uint256 skinId, uint256 price) public whenNotPaused {\n', '        // Only owner of skin pass\n', '        require(skinIdToOwner[skinId] == msg.sender);\n', '\n', '        // Check whether skin is mixing \n', '        require(skins[skinId].mixingWithId == 0);\n', '\n', '        // Check whether skin is already on sale\n', '        require(isOnSale[skinId] == false);\n', '\n', '        require(price > 0); \n', '\n', '        // Put on sale\n', '        desiredPrice[skinId] = price;\n', '        isOnSale[skinId] = true;\n', '\n', '        // Emit the Approval event\n', '        PutOnSale(msg.sender, skinId);\n', '    }\n', '  \n', '    // Withdraw an sale order\n', '    function withdrawSale(uint256 skinId) external whenNotPaused {\n', '        // Check whether this skin is on sale\n', '        require(isOnSale[skinId] == true);\n', '        \n', '        // Can only withdraw self&#39;s sale\n', '        require(skinIdToOwner[skinId] == msg.sender);\n', '\n', '        // Withdraw\n', '        isOnSale[skinId] = false;\n', '        desiredPrice[skinId] = 0;\n', '\n', '        // Emit the cancel event\n', '        WithdrawSale(msg.sender, skinId);\n', '    }\n', ' \n', '    // Buy skin in market\n', '    function buyInMarket(uint256 skinId) external payable whenNotPaused {\n', '        // Check whether this skin is on sale\n', '        require(isOnSale[skinId] == true);\n', '\n', '        address seller = skinIdToOwner[skinId];\n', '\n', '        // Check the sender isn&#39;t the seller\n', '        require(msg.sender != seller);\n', '\n', '        uint256 _price = desiredPrice[skinId];\n', '        // Check whether pay value is enough\n', '        require(msg.value >= _price);\n', '\n', '        // Cut and then send the proceeds to seller\n', '        uint256 sellerProceeds = _price - _computeCut(_price);\n', '\n', '        seller.transfer(sellerProceeds);\n', '\n', '        // Transfer skin from seller to buyer\n', '        numSkinOfAccounts[seller] -= 1;\n', '        skinIdToOwner[skinId] = msg.sender;\n', '        numSkinOfAccounts[msg.sender] += 1;\n', '        isOnSale[skinId] = false;\n', '        desiredPrice[skinId] = 0;\n', '\n', '        // Emit the buy event\n', '        BuyInMarket(msg.sender, skinId);\n', '    }\n', '\n', '    // Compute the marketCut\n', '    function _computeCut(uint256 _price) internal view returns (uint256) {\n', '        return _price * trCut / 10000;\n', '    }\n', '}\n', 'contract SkinMinting is SkinMarket {\n', '\n', '    // Limits the number of skins the contract owner can ever create.\n', '    uint256 public skinCreatedLimit = 50000;\n', '\n', '    // The summon numbers of each accouts: will be cleared every day\n', '    mapping (address => uint256) public accoutToSummonNum;\n', '\n', '    // Pay level of each accouts\n', '    mapping (address => uint256) public accoutToPayLevel;\n', '    mapping (address => uint256) public accountsLastClearTime;\n', '\n', '    uint256 public levelClearTime = now;\n', '\n', '    // price\n', '    uint256 public baseSummonPrice = 3 finney;\n', '    uint256 public bleachPrice = 30 finney;\n', '\n', '    // Pay level\n', '    uint256[5] public levelSplits = [10,\n', '                                     20,\n', '                                     50,\n', '                                     100,\n', '                                     200];\n', '    \n', '    uint256[6] public payMultiple = [1,\n', '                                     2,\n', '                                     4,\n', '                                     8,\n', '                                     20,\n', '                                     100];\n', '\n', '\n', '    // events\n', '    event CreateNewSkin(uint256 skinId, address account);\n', '    event Bleach(uint256 skinId, uint128 newAppearance);\n', '\n', '    // functions\n', '\n', '    // Set price \n', '    function setBaseSummonPrice(uint256 newPrice) external onlyOwner {\n', '        baseSummonPrice = newPrice;\n', '    }\n', '\n', '    function setBleachPrice(uint256 newPrice) external onlyOwner {\n', '        bleachPrice = newPrice;\n', '    }\n', '\n', '    // Create base skin for sell. Only owner can create\n', '    function createSkin(uint128 specifiedAppearance, uint256 salePrice) external onlyOwner whenNotPaused {\n', '        require(numSkinOfAccounts[owner] < skinCreatedLimit);\n', '\n', '        // Create specified skin\n', '        // uint128 randomAppearance = mixFormula.randomSkinAppearance();\n', '        Skin memory newSkin = Skin({appearance: specifiedAppearance, cooldownEndTime: uint64(now), mixingWithId: 0});\n', '        skins[nextSkinId] = newSkin;\n', '        skinIdToOwner[nextSkinId] = owner;\n', '        isOnSale[nextSkinId] = false;\n', '\n', '        // Emit the create event\n', '        CreateNewSkin(nextSkinId, owner);\n', '\n', '        // Put this skin on sale\n', '        putOnSale(nextSkinId, salePrice);\n', '\n', '        nextSkinId++;\n', '        numSkinOfAccounts[owner] += 1;   \n', '    }\n', '\n', '    // Summon\n', '    function summon() external payable whenNotPaused {\n', '        // Clear daily summon numbers\n', '        if (accountsLastClearTime[msg.sender] == uint256(0)) {\n', '            // This account&#39;s first time to summon, we do not need to clear summon numbers\n', '            accountsLastClearTime[msg.sender] = now;\n', '        } else {\n', '            if (accountsLastClearTime[msg.sender] < levelClearTime && now > levelClearTime) {\n', '                accoutToSummonNum[msg.sender] = 0;\n', '                accoutToPayLevel[msg.sender] = 0;\n', '                accountsLastClearTime[msg.sender] = now;\n', '            }\n', '        }\n', '\n', '        uint256 payLevel = accoutToPayLevel[msg.sender];\n', '        uint256 price = payMultiple[payLevel] * baseSummonPrice;\n', '        require(msg.value >= price);\n', '\n', '        // Create random skin\n', '        uint128 randomAppearance = mixFormula.randomSkinAppearance();\n', '        // uint128 randomAppearance = 0;\n', '        Skin memory newSkin = Skin({appearance: randomAppearance, cooldownEndTime: uint64(now), mixingWithId: 0});\n', '        skins[nextSkinId] = newSkin;\n', '        skinIdToOwner[nextSkinId] = msg.sender;\n', '        isOnSale[nextSkinId] = false;\n', '\n', '        // Emit the create event\n', '        CreateNewSkin(nextSkinId, msg.sender);\n', '\n', '        nextSkinId++;\n', '        numSkinOfAccounts[msg.sender] += 1;\n', '        \n', '        accoutToSummonNum[msg.sender] += 1;\n', '        \n', '        // Handle the paylevel        \n', '        if (payLevel < 5) {\n', '            if (accoutToSummonNum[msg.sender] >= levelSplits[payLevel]) {\n', '                accoutToPayLevel[msg.sender] = payLevel + 1;\n', '            }\n', '        }\n', '    }\n', '\n', '    // Bleach some attributes\n', '    function bleach(uint128 skinId, uint128 attributes) external payable whenNotPaused {\n', '        // Check whether msg.sender is owner of the skin \n', '        require(msg.sender == skinIdToOwner[skinId]);\n', '\n', '        // Check whether this skin is on sale \n', '        require(isOnSale[skinId] == false);\n', '\n', '        // Check whether there is enough money\n', '        require(msg.value >= bleachPrice);\n', '\n', '        Skin storage originSkin = skins[skinId];\n', '        // Check whether this skin is in mixing \n', '        require(originSkin.mixingWithId == 0);\n', '\n', '        uint128 newAppearance = mixFormula.bleachAppearance(originSkin.appearance, attributes);\n', '        originSkin.appearance = newAppearance;\n', '\n', '        // Emit bleach event\n', '        Bleach(skinId, newAppearance);\n', '    }\n', '\n', '    // Our daemon will clear daily summon numbers\n', '    function clearSummonNum() external onlyOwner {\n', '        uint256 nextDay = levelClearTime + 1 days;\n', '        if (now > nextDay) {\n', '            levelClearTime = nextDay;\n', '        }\n', '    }\n', '}']