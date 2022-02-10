['pragma solidity ^0.4.20;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', '\n', '\n', '/// @title BlockchainCuties: Collectible and breedable cuties on the Ethereum blockchain.\n', '/// @author https://BlockChainArchitect.io\n', '/// @dev This is the BlockchainCuties configuration. It can be changed redeploying another version.\n', 'contract ConfigInterface\n', '{\n', '    function isConfig() public pure returns (bool);\n', '\n', '    function getCooldownIndexFromGeneration(uint16 _generation) public view returns (uint16);\n', '    \n', '    function getCooldownEndTimeFromIndex(uint16 _cooldownIndex) public view returns (uint40);\n', '\n', '    function getCooldownIndexCount() public view returns (uint256);\n', '    \n', '    function getBabyGen(uint16 _momGen, uint16 _dadGen) public pure returns (uint16);\n', '\n', '    function getTutorialBabyGen(uint16 _dadGen) public pure returns (uint16);\n', '\n', '    function getBreedingFee(uint40 _momId, uint40 _dadId) public pure returns (uint256);\n', '}\n', '\n', '\n', '/// @title BlockchainCuties: Collectible and breedable cuties on the Ethereum blockchain.\n', '/// @author https://BlockChainArchitect.io\n', '/// @dev This is the BlockchainCuties configuration. It can be changed redeploying another version.\n', '\n', 'contract Config is Ownable, ConfigInterface\n', '{\n', '\tfunction isConfig() public pure returns (bool)\n', '\t{\n', '\t\treturn true;\n', '\t}\n', '\n', '    /// @dev A lookup table that shows the cooldown duration after a successful\n', '    ///  breeding action, called "breeding cooldown". The cooldown roughly doubles each time\n', '    /// a cutie is bred, so that owners don&#39;t breed the same cutie continuously. Maximum cooldown is seven days.\n', '    uint32[14] public cooldowns = [\n', '        uint32(1 minutes),\n', '        uint32(2 minutes),\n', '        uint32(5 minutes),\n', '        uint32(10 minutes),\n', '        uint32(30 minutes),\n', '        uint32(1 hours),\n', '        uint32(2 hours),\n', '        uint32(4 hours),\n', '        uint32(8 hours),\n', '        uint32(16 hours),\n', '        uint32(1 days),\n', '        uint32(2 days),\n', '        uint32(4 days),\n', '        uint32(7 days)\n', '    ];\n', '\n', '/*    function setCooldown(uint16 index, uint32 newCooldown) public onlyOwner\n', '    {\n', '        cooldowns[index] = newCooldown;\n', '    }*/\n', '\n', '    function getCooldownIndexFromGeneration(uint16 _generation) public view returns (uint16)\n', '    {\n', '        uint16 result = uint16(_generation / 2);\n', '        if (result > getCooldownIndexCount()) {\n', '            result = uint16(getCooldownIndexCount() - 1);\n', '        }\n', '        return result;\n', '    }\n', '\n', '    function getCooldownEndTimeFromIndex(uint16 _cooldownIndex) public view returns (uint40)\n', '    {\n', '        return uint40(now + cooldowns[_cooldownIndex]);\n', '    }\n', '\n', '    function getCooldownIndexCount() public view returns (uint256)\n', '    {\n', '        return cooldowns.length;\n', '    }\n', '\n', '    function getBabyGen(uint16 _momGen, uint16 _dadGen) public pure returns (uint16)\n', '    {\n', '        uint16 babyGen = _momGen;\n', '        if (_dadGen > _momGen) {\n', '            babyGen = _dadGen;\n', '        }\n', '        babyGen = babyGen + 1;\n', '        return babyGen;\n', '    }\n', '\n', '    function getTutorialBabyGen(uint16 _dadGen) public pure returns (uint16)\n', '    {\n', '        // Tutorial pet gen is 26\n', '        return getBabyGen(26, _dadGen);\n', '    }\n', '\n', '    function getBreedingFee(uint40 /*_momId*/, uint40 /*_dadId*/)\n', '        public\n', '        pure\n', '        returns (uint256)\n', '    {\n', '        return 2000000000000000;\n', '    }\n', '}']