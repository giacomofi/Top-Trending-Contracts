['pragma solidity ^0.4.23;\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '/// @title BlockchainCuties: Collectible and breedable cuties on the Ethereum blockchain.\n', '/// @author https://BlockChainArchitect.io\n', '/// @dev This is the BlockchainCuties configuration. It can be changed redeploying another version.\n', 'interface ConfigInterface\n', '{\n', '    function isConfig() external pure returns (bool);\n', '\n', '    function getCooldownIndexFromGeneration(uint16 _generation, uint40 _cutieId) external view returns (uint16);\n', '    function getCooldownEndTimeFromIndex(uint16 _cooldownIndex, uint40 _cutieId) external view returns (uint40);\n', '    function getCooldownIndexFromGeneration(uint16 _generation) external view returns (uint16);\n', '    function getCooldownEndTimeFromIndex(uint16 _cooldownIndex) external view returns (uint40);\n', '\n', '    function getCooldownIndexCount() external view returns (uint256);\n', '\n', '    function getBabyGenFromId(uint40 _momId, uint40 _dadId) external view returns (uint16);\n', '    function getBabyGen(uint16 _momGen, uint16 _dadGen) external pure returns (uint16);\n', '\n', '    function getTutorialBabyGen(uint16 _dadGen) external pure returns (uint16);\n', '\n', '    function getBreedingFee(uint40 _momId, uint40 _dadId) external view returns (uint256);\n', '}\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '\n', '\n', 'contract CutieCoreInterface\n', '{\n', '    function isCutieCore() pure public returns (bool);\n', '\n', '    ConfigInterface public config;\n', '\n', '    function transferFrom(address _from, address _to, uint256 _cutieId) external;\n', '    function transfer(address _to, uint256 _cutieId) external;\n', '\n', '    function ownerOf(uint256 _cutieId)\n', '        external\n', '        view\n', '        returns (address owner);\n', '\n', '    function getCutie(uint40 _id)\n', '        external\n', '        view\n', '        returns (\n', '        uint256 genes,\n', '        uint40 birthTime,\n', '        uint40 cooldownEndTime,\n', '        uint40 momId,\n', '        uint40 dadId,\n', '        uint16 cooldownIndex,\n', '        uint16 generation\n', '    );\n', '\n', '    function getGenes(uint40 _id)\n', '        public\n', '        view\n', '        returns (\n', '        uint256 genes\n', '    );\n', '\n', '\n', '    function getCooldownEndTime(uint40 _id)\n', '        public\n', '        view\n', '        returns (\n', '        uint40 cooldownEndTime\n', '    );\n', '\n', '    function getCooldownIndex(uint40 _id)\n', '        public\n', '        view\n', '        returns (\n', '        uint16 cooldownIndex\n', '    );\n', '\n', '\n', '    function getGeneration(uint40 _id)\n', '        public\n', '        view\n', '        returns (\n', '        uint16 generation\n', '    );\n', '\n', '    function getOptional(uint40 _id)\n', '        public\n', '        view\n', '        returns (\n', '        uint64 optional\n', '    );\n', '\n', '\n', '    function changeGenes(\n', '        uint40 _cutieId,\n', '        uint256 _genes)\n', '        public;\n', '\n', '    function changeCooldownEndTime(\n', '        uint40 _cutieId,\n', '        uint40 _cooldownEndTime)\n', '        public;\n', '\n', '    function changeCooldownIndex(\n', '        uint40 _cutieId,\n', '        uint16 _cooldownIndex)\n', '        public;\n', '\n', '    function changeOptional(\n', '        uint40 _cutieId,\n', '        uint64 _optional)\n', '        public;\n', '\n', '    function changeGeneration(\n', '        uint40 _cutieId,\n', '        uint16 _generation)\n', '        public;\n', '\n', '    function createSaleAuction(\n', '        uint40 _cutieId,\n', '        uint128 _startPrice,\n', '        uint128 _endPrice,\n', '        uint40 _duration\n', '    )\n', '    public;\n', '\n', '    function getApproved(uint256 _tokenId) external returns (address);\n', '    function totalSupply() view external returns (uint256);\n', '    function createPromoCutie(uint256 _genes, address _owner) external;\n', '    function checkOwnerAndApprove(address _claimant, uint40 _cutieId, address _pluginsContract) external view;\n', '    function breedWith(uint40 _momId, uint40 _dadId) public payable returns (uint40);\n', '    function getBreedingFee(uint40 _momId, uint40 _dadId) public view returns (uint256);\n', '}\n', '\n', '\n', '/// @title BlockchainCuties: Collectible and breedable cuties on the Ethereum blockchain.\n', '/// @author https://BlockChainArchitect.io\n', '/// @dev This is the BlockchainCuties configuration. It can be changed redeploying another version.\n', '\n', 'contract Config is Ownable, ConfigInterface\n', '{\n', '    mapping(uint40 => bool) public freeBreeding;\n', '\n', '\tfunction isConfig() external pure returns (bool)\n', '\t{\n', '\t\treturn true;\n', '\t}\n', '\n', '    /// @dev A lookup table that shows the cooldown duration after a successful\n', '    ///  breeding action, called "breeding cooldown". The cooldown roughly doubles each time\n', "    /// a cutie is bred, so that owners don't breed the same cutie continuously. Maximum cooldown is seven days.\n", '    uint32[14] public cooldowns = [\n', '        uint32(1 minutes),\n', '        uint32(2 minutes),\n', '        uint32(5 minutes),\n', '        uint32(10 minutes),\n', '        uint32(30 minutes),\n', '        uint32(1 hours),\n', '        uint32(2 hours),\n', '        uint32(4 hours),\n', '        uint32(8 hours),\n', '        uint32(16 hours),\n', '        uint32(1 days),\n', '        uint32(2 days),\n', '        uint32(4 days),\n', '        uint32(7 days)\n', '    ];\n', '\n', '/*    function setCooldown(uint16 index, uint32 newCooldown) public onlyOwner\n', '    {\n', '        cooldowns[index] = newCooldown;\n', '    }*/\n', '\n', '    CutieCoreInterface public coreContract;\n', '\n', '    function setup(address _coreAddress) external onlyOwner\n', '    {\n', '        CutieCoreInterface candidateContract = CutieCoreInterface(_coreAddress);\n', '        require(candidateContract.isCutieCore());\n', '        coreContract = candidateContract;\n', '    }\n', '\n', '    function getCooldownIndexFromGeneration(uint16 _generation, uint40 /*_cutieId*/) external view returns (uint16)\n', '    {\n', '        return getCooldownIndexFromGeneration(_generation);\n', '    }\n', '\n', '    function getCooldownIndexFromGeneration(uint16 _generation) public view returns (uint16)\n', '    {\n', '        uint16 result = _generation;\n', '        if (result >= cooldowns.length) {\n', '            result = uint16(cooldowns.length - 1);\n', '        }\n', '        return result;\n', '    }\n', '\n', '    function getCooldownEndTimeFromIndex(uint16 _cooldownIndex) public view returns (uint40)\n', '    {\n', '        return uint40(now + cooldowns[_cooldownIndex]);\n', '    }\n', '\n', '    function getCooldownEndTimeFromIndex(uint16 _cooldownIndex, uint40 /*_cutieId*/) external view returns (uint40)\n', '    {\n', '        return getCooldownEndTimeFromIndex(_cooldownIndex);\n', '    }\n', '\n', '    function getCooldownIndexCount() public view returns (uint256)\n', '    {\n', '        return cooldowns.length;\n', '    }\n', '\n', '    function getBabyGenFromId(uint40 _momId, uint40 _dadId) external view returns (uint16)\n', '    {\n', '        uint16 momGen = coreContract.getGeneration(_momId);\n', '        uint16 dadGen = coreContract.getGeneration(_dadId);\n', '\n', '        return getBabyGen(momGen, dadGen);\n', '    }\n', '\n', '    function getBabyGen(uint16 _momGen, uint16 _dadGen) public pure returns (uint16)\n', '    {\n', '        uint16 babyGen = _momGen;\n', '        if (_dadGen > _momGen) {\n', '            babyGen = _dadGen;\n', '        }\n', '        babyGen = babyGen + 1;\n', '        return babyGen;\n', '    }\n', '\n', '    function getTutorialBabyGen(uint16 _dadGen) external pure returns (uint16)\n', '    {\n', '        // Tutorial pet gen is 1\n', '        return getBabyGen(1, _dadGen);\n', '    }\n', '\n', '    function getBreedingFee(uint40 _momId, uint40 _dadId)\n', '        external\n', '        view\n', '        returns (uint256)\n', '    {\n', '        if (freeBreeding[_momId] || freeBreeding[_dadId])\n', '        {\n', '            return 0;\n', '        }\n', '\n', '        uint16 momGen = coreContract.getGeneration(_momId);\n', '        uint16 dadGen = coreContract.getGeneration(_dadId);\n', '        uint16 momCooldown = coreContract.getCooldownIndex(_momId);\n', '        uint16 dadCooldown = coreContract.getCooldownIndex(_dadId);\n', '\n', '        uint256 sum = uint256(momCooldown) + dadCooldown - momGen - dadGen;\n', '        return 1 finney + 3 szabo*sum*sum;\n', '    }\n', '\n', '    function setFreeBreeding(uint40 _cutieId) external onlyOwner\n', '    {\n', '        freeBreeding[_cutieId] = true;\n', '    }\n', '\n', '    function removeFreeBreeding(uint40 _cutieId) external onlyOwner\n', '    {\n', '        delete freeBreeding[_cutieId];\n', '    }\n', '}']