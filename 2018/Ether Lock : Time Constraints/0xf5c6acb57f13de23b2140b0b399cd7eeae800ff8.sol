['pragma solidity 0.4.25;\n', '\n', 'library SafeMath8 {\n', '\n', '    function mul(uint8 a, uint8 b) internal pure returns (uint8) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint8 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint8 a, uint8 b) internal pure returns (uint8) {\n', '        return a / b;\n', '    }\n', '\n', '    function sub(uint8 a, uint8 b) internal pure returns (uint8) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint8 a, uint8 b) internal pure returns (uint8) {\n', '        uint8 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function pow(uint8 a, uint8 b) internal pure returns (uint8) {\n', '        if (a == 0) return 0;\n', '        if (b == 0) return 1;\n', '\n', '        uint8 c = a ** b;\n', '        assert(c / (a ** (b - 1)) == a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'library SafeMath16 {\n', '\n', '    function mul(uint16 a, uint16 b) internal pure returns (uint16) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint16 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint16 a, uint16 b) internal pure returns (uint16) {\n', '        return a / b;\n', '    }\n', '\n', '    function sub(uint16 a, uint16 b) internal pure returns (uint16) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint16 a, uint16 b) internal pure returns (uint16) {\n', '        uint16 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function pow(uint16 a, uint16 b) internal pure returns (uint16) {\n', '        if (a == 0) return 0;\n', '        if (b == 0) return 1;\n', '\n', '        uint16 c = a ** b;\n', '        assert(c / (a ** (b - 1)) == a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'library SafeMath32 {\n', '\n', '    function mul(uint32 a, uint32 b) internal pure returns (uint32) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint32 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint32 a, uint32 b) internal pure returns (uint32) {\n', '        return a / b;\n', '    }\n', '\n', '    function sub(uint32 a, uint32 b) internal pure returns (uint32) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint32 a, uint32 b) internal pure returns (uint32) {\n', '        uint32 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function pow(uint32 a, uint32 b) internal pure returns (uint32) {\n', '        if (a == 0) return 0;\n', '        if (b == 0) return 1;\n', '\n', '        uint32 c = a ** b;\n', '        assert(c / (a ** (b - 1)) == a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'library SafeMath256 {\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a / b;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function pow(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) return 0;\n', '        if (b == 0) return 1;\n', '\n', '        uint256 c = a ** b;\n', '        assert(c / (a ** (b - 1)) == a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    function _validateAddress(address _addr) internal pure {\n', '        require(_addr != address(0), "invalid address");\n', '    }\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner, "not a contract owner");\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _validateAddress(newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', 'contract Controllable is Ownable {\n', '    mapping(address => bool) controllers;\n', '\n', '    modifier onlyController {\n', '        require(_isController(msg.sender), "no controller rights");\n', '        _;\n', '    }\n', '\n', '    function _isController(address _controller) internal view returns (bool) {\n', '        return controllers[_controller];\n', '    }\n', '\n', '    function _setControllers(address[] _controllers) internal {\n', '        for (uint256 i = 0; i < _controllers.length; i++) {\n', '            _validateAddress(_controllers[i]);\n', '            controllers[_controllers[i]] = true;\n', '        }\n', '    }\n', '}\n', '\n', 'contract Upgradable is Controllable {\n', '    address[] internalDependencies;\n', '    address[] externalDependencies;\n', '\n', '    function getInternalDependencies() public view returns(address[]) {\n', '        return internalDependencies;\n', '    }\n', '\n', '    function getExternalDependencies() public view returns(address[]) {\n', '        return externalDependencies;\n', '    }\n', '\n', '    function setInternalDependencies(address[] _newDependencies) public onlyOwner {\n', '        for (uint256 i = 0; i < _newDependencies.length; i++) {\n', '            _validateAddress(_newDependencies[i]);\n', '        }\n', '        internalDependencies = _newDependencies;\n', '    }\n', '\n', '    function setExternalDependencies(address[] _newDependencies) public onlyOwner {\n', '        externalDependencies = _newDependencies;\n', '        _setControllers(_newDependencies);\n', '    }\n', '}\n', '\n', 'contract DragonCore {\n', '    function setRemainingHealthAndMana(uint256, uint32, uint32) external;\n', '    function increaseExperience(uint256, uint256) external;\n', '    function payDNAPointsForBreeding(uint256) external;\n', '    function upgradeGenes(uint256, uint16[10]) external;\n', '    function increaseWins(uint256) external;\n', '    function increaseDefeats(uint256) external;\n', '    function setTactics(uint256, uint8, uint8) external;\n', '    function setSpecialPeacefulSkill(uint256, uint8) external;\n', '    function useSpecialPeacefulSkill(address, uint256, uint256) external;\n', '    function setBuff(uint256, uint8, uint32) external;\n', '    function createDragon(address, uint16, uint256[2], uint256[4], uint8[11]) external returns (uint256);\n', '    function setName(uint256, string) external returns (bytes32);\n', '}\n', '\n', 'contract DragonGetter {\n', '    function getAmount() external view returns (uint256);\n', '    function getComposedGenome(uint256) external view returns (uint256[4]);\n', '    function getCoolness(uint256) public view returns (uint32);\n', '    function getFullRegenerationTime(uint256) external view returns (uint32);\n', '    function getDragonTypes(uint256) external view returns (uint8[11]);\n', '    function getGeneration(uint256) external view returns (uint16);\n', '    function getParents(uint256) external view returns (uint256[2]);\n', '}\n', '\n', 'contract DragonGenetics {\n', '    function createGenome(uint256[2], uint256[4], uint256[4], uint256) external view returns (uint256[4], uint8[11]);\n', '    function createGenomeForGenesis(uint8, uint256) external view returns (uint256[4]);\n', '}\n', '\n', 'contract EggCore {\n', '    function ownerOf(uint256) external view returns (address);\n', '    function get(uint256) external view returns (uint256[2], uint8);\n', '    function isOwner(address, uint256) external view returns (bool);\n', '    function getAllEggs() external view returns (uint256[]);\n', '    function create(address, uint256[2], uint8) external returns (uint256);\n', '    function remove(address, uint256) external;\n', '}\n', '\n', 'contract DragonLeaderboard {\n', '    function update(uint256, uint32) external;\n', '    function getDragonsFromLeaderboard() external view returns (uint256[10]);\n', '    function updateRewardTime() external;\n', '    function getRewards(uint256) external view returns (uint256[10]);\n', '    function getDate() external view returns (uint256, uint256);\n', '}\n', '\n', 'contract Nest {\n', '    mapping (uint256 => bool) public inNest;\n', '    function getEggs() external view returns (uint256[2]);\n', '    function add(uint256) external returns (bool, uint256, uint256);\n', '}\n', '\n', '\n', '\n', '\n', '//////////////CONTRACT//////////////\n', '\n', '\n', '\n', '\n', 'contract Core is Upgradable {\n', '    using SafeMath8 for uint8;\n', '    using SafeMath16 for uint16;\n', '    using SafeMath32 for uint32;\n', '    using SafeMath256 for uint256;\n', '\n', '    DragonCore dragonCore;\n', '    DragonGetter dragonGetter;\n', '    DragonGenetics dragonGenetics;\n', '    EggCore eggCore;\n', '    DragonLeaderboard leaderboard;\n', '    Nest nest;\n', '\n', '    function _max(uint16 lth, uint16 rth) internal pure returns (uint16) {\n', '        if (lth > rth) {\n', '            return lth;\n', '        } else {\n', '            return rth;\n', '        }\n', '    }\n', '\n', '    function createEgg(\n', '        address _sender,\n', '        uint8 _dragonType\n', '    ) external onlyController returns (uint256) {\n', '        return eggCore.create(_sender, [uint256(0), uint256(0)], _dragonType);\n', '    }\n', '\n', '    function sendToNest(\n', '        uint256 _id\n', '    ) external onlyController returns (\n', '        bool isHatched,\n', '        uint256 newDragonId,\n', '        uint256 hatchedId,\n', '        address owner\n', '    ) {\n', '        uint256 _randomForEggOpening;\n', '        (isHatched, hatchedId, _randomForEggOpening) = nest.add(_id);\n', '        // if any egg was hatched\n', '        if (isHatched) {\n', '            owner = eggCore.ownerOf(hatchedId);\n', '            newDragonId = openEgg(owner, hatchedId, _randomForEggOpening);\n', '        }\n', '    }\n', '\n', '    function openEgg(\n', '        address _owner,\n', '        uint256 _eggId,\n', '        uint256 _random\n', '    ) internal returns (uint256 newDragonId) {\n', '        uint256[2] memory _parents;\n', '        uint8 _dragonType;\n', '        (_parents, _dragonType) = eggCore.get(_eggId);\n', '\n', '        uint256[4] memory _genome;\n', '        uint8[11] memory _dragonTypesArray;\n', '        uint16 _generation;\n', '        // if genesis\n', '        if (_parents[0] == 0 && _parents[1] == 0) {\n', '            _generation = 0;\n', '            _genome = dragonGenetics.createGenomeForGenesis(_dragonType, _random);\n', '            _dragonTypesArray[_dragonType] = 40; // 40 genes of 1 type\n', '        } else {\n', '            uint256[4] memory _momGenome = dragonGetter.getComposedGenome(_parents[0]);\n', '            uint256[4] memory _dadGenome = dragonGetter.getComposedGenome(_parents[1]);\n', '            (_genome, _dragonTypesArray) = dragonGenetics.createGenome(_parents, _momGenome, _dadGenome, _random);\n', '            _generation = _max(\n', '                dragonGetter.getGeneration(_parents[0]),\n', '                dragonGetter.getGeneration(_parents[1])\n', '            ).add(1);\n', '        }\n', '\n', '        newDragonId = dragonCore.createDragon(_owner, _generation, _parents, _genome, _dragonTypesArray);\n', '        eggCore.remove(_owner, _eggId);\n', '\n', '        uint32 _coolness = dragonGetter.getCoolness(newDragonId);\n', '        leaderboard.update(newDragonId, _coolness);\n', '    }\n', '\n', '    function breed(\n', '        address _sender,\n', '        uint256 _momId,\n', '        uint256 _dadId\n', '    ) external onlyController returns (uint256) {\n', '        dragonCore.payDNAPointsForBreeding(_momId);\n', '        dragonCore.payDNAPointsForBreeding(_dadId);\n', '        return eggCore.create(_sender, [_momId, _dadId], 0);\n', '    }\n', '\n', '    function setDragonRemainingHealthAndMana(uint256 _id, uint32 _health, uint32 _mana) external onlyController {\n', '        return dragonCore.setRemainingHealthAndMana(_id, _health, _mana);\n', '    }\n', '\n', '    function increaseDragonExperience(uint256 _id, uint256 _factor) external onlyController {\n', '        dragonCore.increaseExperience(_id, _factor);\n', '    }\n', '\n', '    function upgradeDragonGenes(uint256 _id, uint16[10] _dnaPoints) external onlyController {\n', '        dragonCore.upgradeGenes(_id, _dnaPoints);\n', '\n', '        uint32 _coolness = dragonGetter.getCoolness(_id);\n', '        leaderboard.update(_id, _coolness);\n', '    }\n', '\n', '    function increaseDragonWins(uint256 _id) external onlyController {\n', '        dragonCore.increaseWins(_id);\n', '    }\n', '\n', '    function increaseDragonDefeats(uint256 _id) external onlyController {\n', '        dragonCore.increaseDefeats(_id);\n', '    }\n', '\n', '    function setDragonTactics(uint256 _id, uint8 _melee, uint8 _attack) external onlyController {\n', '        dragonCore.setTactics(_id, _melee, _attack);\n', '    }\n', '\n', '    function setDragonName(uint256 _id, string _name) external onlyController returns (bytes32) {\n', '        return dragonCore.setName(_id, _name);\n', '    }\n', '\n', '    function setDragonSpecialPeacefulSkill(uint256 _id, uint8 _class) external onlyController {\n', '        dragonCore.setSpecialPeacefulSkill(_id, _class);\n', '    }\n', '\n', '    function useDragonSpecialPeacefulSkill(\n', '        address _sender,\n', '        uint256 _id,\n', '        uint256 _target\n', '    ) external onlyController {\n', '        dragonCore.useSpecialPeacefulSkill(_sender, _id, _target);\n', '    }\n', '\n', '    function resetDragonBuffs(uint256 _id) external onlyController {\n', '        dragonCore.setBuff(_id, 1, 0); // attack\n', '        dragonCore.setBuff(_id, 2, 0); // defense\n', '        dragonCore.setBuff(_id, 3, 0); // stamina\n', '        dragonCore.setBuff(_id, 4, 0); // speed\n', '        dragonCore.setBuff(_id, 5, 0); // intelligence\n', '    }\n', '\n', '    function updateLeaderboardRewardTime() external onlyController {\n', '        return leaderboard.updateRewardTime();\n', '    }\n', '\n', '    // GETTERS\n', '\n', '    function getDragonFullRegenerationTime(uint256 _id) external view returns (uint32 time) {\n', '        return dragonGetter.getFullRegenerationTime(_id);\n', '    }\n', '\n', '    function isEggOwner(address _user, uint256 _tokenId) external view returns (bool) {\n', '        return eggCore.isOwner(_user, _tokenId);\n', '    }\n', '\n', '    function isEggInNest(uint256 _id) external view returns (bool) {\n', '        return nest.inNest(_id);\n', '    }\n', '\n', '    function getEggsInNest() external view returns (uint256[2]) {\n', '        return nest.getEggs();\n', '    }\n', '\n', '    function getEgg(uint256 _id) external view returns (uint16, uint32, uint256[2], uint8[11], uint8[11]) {\n', '        uint256[2] memory parents;\n', '        uint8 _dragonType;\n', '        (parents, _dragonType) = eggCore.get(_id);\n', '\n', '        uint8[11] memory momDragonTypes;\n', '        uint8[11] memory dadDragonTypes;\n', '        uint32 coolness;\n', '        uint16 gen;\n', '        // if genesis\n', '        if (parents[0] == 0 && parents[1] == 0) {\n', '            momDragonTypes[_dragonType] = 100;\n', '            dadDragonTypes[_dragonType] = 100;\n', '            coolness = 3600;\n', '        } else {\n', '            momDragonTypes = dragonGetter.getDragonTypes(parents[0]);\n', '            dadDragonTypes = dragonGetter.getDragonTypes(parents[1]);\n', '            coolness = dragonGetter.getCoolness(parents[0]).add(dragonGetter.getCoolness(parents[1])).div(2);\n', '            uint16 _momGeneration = dragonGetter.getGeneration(parents[0]);\n', '            uint16 _dadGeneration = dragonGetter.getGeneration(parents[1]);\n', '            gen = _max(_momGeneration, _dadGeneration).add(1);\n', '        }\n', '        return (gen, coolness, parents, momDragonTypes, dadDragonTypes);\n', '    }\n', '\n', '    function getDragonChildren(uint256 _id) external view returns (\n', '        uint256[10] dragonsChildren,\n', '        uint256[10] eggsChildren\n', '    ) {\n', '        uint8 _counter;\n', '        uint256[2] memory _parents;\n', '        uint256 i;\n', '        for (i = _id.add(1); i <= dragonGetter.getAmount() && _counter < 10; i++) {\n', '            _parents = dragonGetter.getParents(i);\n', '            if (_parents[0] == _id || _parents[1] == _id) {\n', '                dragonsChildren[_counter] = i;\n', '                _counter = _counter.add(1);\n', '            }\n', '        }\n', '        _counter = 0;\n', '        uint256[] memory eggs = eggCore.getAllEggs();\n', '        for (i = 0; i < eggs.length && _counter < 10; i++) {\n', '            (_parents, ) = eggCore.get(eggs[i]);\n', '            if (_parents[0] == _id || _parents[1] == _id) {\n', '                eggsChildren[_counter] = eggs[i];\n', '                _counter = _counter.add(1);\n', '            }\n', '        }\n', '    }\n', '\n', '    function getDragonsFromLeaderboard() external view returns (uint256[10]) {\n', '        return leaderboard.getDragonsFromLeaderboard();\n', '    }\n', '\n', '    function getLeaderboardRewards(\n', '        uint256 _hatchingPrice\n', '    ) external view returns (\n', '        uint256[10]\n', '    ) {\n', '        return leaderboard.getRewards(_hatchingPrice);\n', '    }\n', '\n', '    function getLeaderboardRewardDate() external view returns (uint256, uint256) {\n', '        return leaderboard.getDate();\n', '    }\n', '\n', '    // UPDATE CONTRACT\n', '\n', '    function setInternalDependencies(address[] _newDependencies) public onlyOwner {\n', '        super.setInternalDependencies(_newDependencies);\n', '\n', '        dragonCore = DragonCore(_newDependencies[0]);\n', '        dragonGetter = DragonGetter(_newDependencies[1]);\n', '        dragonGenetics = DragonGenetics(_newDependencies[2]);\n', '        eggCore = EggCore(_newDependencies[3]);\n', '        leaderboard = DragonLeaderboard(_newDependencies[4]);\n', '        nest = Nest(_newDependencies[5]);\n', '    }\n', '}']