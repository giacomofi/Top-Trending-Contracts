['// File: contracts/upgradeability/EternalStorage.sol\n', '\n', 'pragma solidity 0.4.24;\n', '\n', '/**\n', ' * @title EternalStorage\n', ' * @dev This contract holds all the necessary state variables to carry out the storage of any contract.\n', ' */\n', 'contract EternalStorage {\n', '    mapping(bytes32 => uint256) internal uintStorage;\n', '    mapping(bytes32 => string) internal stringStorage;\n', '    mapping(bytes32 => address) internal addressStorage;\n', '    mapping(bytes32 => bytes) internal bytesStorage;\n', '    mapping(bytes32 => bool) internal boolStorage;\n', '    mapping(bytes32 => int256) internal intStorage;\n', '\n', '}\n', '\n', '// File: contracts/interfaces/IUpgradeabilityOwnerStorage.sol\n', '\n', 'pragma solidity 0.4.24;\n', '\n', 'interface IUpgradeabilityOwnerStorage {\n', '    function upgradeabilityOwner() external view returns (address);\n', '}\n', '\n', '// File: contracts/upgradeable_contracts/Ownable.sol\n', '\n', 'pragma solidity 0.4.24;\n', '\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev This contract has an owner address providing basic authorization control\n', ' */\n', 'contract Ownable is EternalStorage {\n', '    bytes4 internal constant UPGRADEABILITY_OWNER = 0x6fde8202; // upgradeabilityOwner()\n', '\n', '    /**\n', '    * @dev Event to show ownership has been transferred\n', '    * @param previousOwner representing the address of the previous owner\n', '    * @param newOwner representing the address of the new owner\n', '    */\n', '    event OwnershipTransferred(address previousOwner, address newOwner);\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner());\n', '        /* solcov ignore next */\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than contract itself or owner.\n', '    */\n', '    modifier onlyRelevantSender() {\n', '        // proxy owner if used through proxy, address(0) otherwise\n', '        require(\n', '            !address(this).call(abi.encodeWithSelector(UPGRADEABILITY_OWNER)) || // covers usage without calling through storage proxy\n', '                msg.sender == IUpgradeabilityOwnerStorage(this).upgradeabilityOwner() || // covers usage through regular proxy calls\n', '                msg.sender == address(this) // covers calls through upgradeAndCall proxy method\n', '        );\n', '        /* solcov ignore next */\n', '        _;\n', '    }\n', '\n', '    bytes32 internal constant OWNER = 0x02016836a56b71f0d02689e69e326f4f4c1b9057164ef592671cf0d37c8040c0; // keccak256(abi.encodePacked("owner"))\n', '\n', '    /**\n', '    * @dev Tells the address of the owner\n', '    * @return the address of the owner\n', '    */\n', '    function owner() public view returns (address) {\n', '        return addressStorage[OWNER];\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner the address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address newOwner) external onlyOwner {\n', '        require(newOwner != address(0));\n', '        setOwner(newOwner);\n', '    }\n', '\n', '    /**\n', '    * @dev Sets a new owner address\n', '    */\n', '    function setOwner(address newOwner) internal {\n', '        emit OwnershipTransferred(owner(), newOwner);\n', '        addressStorage[OWNER] = newOwner;\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', "    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (_a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = _a * _b;\n', '    assert(c / _a == _b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    // assert(_b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = _a / _b;\n', "    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold\n", '    return _a / _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    assert(_b <= _a);\n', '    return _a - _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    c = _a + _b;\n', '    assert(c >= _a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: contracts/upgradeable_contracts/Initializable.sol\n', '\n', 'pragma solidity 0.4.24;\n', '\n', '\n', 'contract Initializable is EternalStorage {\n', '    bytes32 internal constant INITIALIZED = 0x0a6f646cd611241d8073675e00d1a1ff700fbf1b53fcf473de56d1e6e4b714ba; // keccak256(abi.encodePacked("isInitialized"))\n', '\n', '    function setInitialize() internal {\n', '        boolStorage[INITIALIZED] = true;\n', '    }\n', '\n', '    function isInitialized() public view returns (bool) {\n', '        return boolStorage[INITIALIZED];\n', '    }\n', '}\n', '\n', '// File: contracts/upgradeable_contracts/InitializableBridge.sol\n', '\n', 'pragma solidity 0.4.24;\n', '\n', '\n', 'contract InitializableBridge is Initializable {\n', '    bytes32 internal constant DEPLOYED_AT_BLOCK = 0xb120ceec05576ad0c710bc6e85f1768535e27554458f05dcbb5c65b8c7a749b0; // keccak256(abi.encodePacked("deployedAtBlock"))\n', '\n', '    function deployedAtBlock() external view returns (uint256) {\n', '        return uintStorage[DEPLOYED_AT_BLOCK];\n', '    }\n', '}\n', '\n', '// File: contracts/upgradeable_contracts/BaseBridgeValidators.sol\n', '\n', 'pragma solidity 0.4.24;\n', '\n', '\n', '\n', '\n', 'contract BaseBridgeValidators is InitializableBridge, Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    address public constant F_ADDR = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;\n', '    uint256 internal constant MAX_VALIDATORS = 50;\n', '    bytes32 internal constant REQUIRED_SIGNATURES = 0xd18ea17c351d6834a0e568067fb71804d2a588d5e26d60f792b1c724b1bd53b1; // keccak256(abi.encodePacked("requiredSignatures"))\n', '    bytes32 internal constant VALIDATOR_COUNT = 0x8656d603d9f985c3483946a92789d52202f49736384ba131cb92f62c4c1aa082; // keccak256(abi.encodePacked("validatorCount"))\n', '\n', '    event ValidatorAdded(address indexed validator);\n', '    event ValidatorRemoved(address indexed validator);\n', '    event RequiredSignaturesChanged(uint256 requiredSignatures);\n', '\n', '    function setRequiredSignatures(uint256 _requiredSignatures) external onlyOwner {\n', '        require(validatorCount() >= _requiredSignatures);\n', '        require(_requiredSignatures != 0);\n', '        uintStorage[REQUIRED_SIGNATURES] = _requiredSignatures;\n', '        emit RequiredSignaturesChanged(_requiredSignatures);\n', '    }\n', '\n', '    function getBridgeValidatorsInterfacesVersion() external pure returns (uint64 major, uint64 minor, uint64 patch) {\n', '        return (2, 3, 0);\n', '    }\n', '\n', '    function validatorList() external view returns (address[]) {\n', '        address[] memory list = new address[](validatorCount());\n', '        uint256 counter = 0;\n', '        address nextValidator = getNextValidator(F_ADDR);\n', '        require(nextValidator != address(0));\n', '\n', '        while (nextValidator != F_ADDR) {\n', '            list[counter] = nextValidator;\n', '            nextValidator = getNextValidator(nextValidator);\n', '            counter++;\n', '\n', '            require(nextValidator != address(0));\n', '        }\n', '\n', '        return list;\n', '    }\n', '\n', '    function _addValidator(address _validator) internal {\n', '        require(_validator != address(0) && _validator != F_ADDR);\n', '        require(!isValidator(_validator));\n', '\n', '        address firstValidator = getNextValidator(F_ADDR);\n', '        require(firstValidator != address(0));\n', '        setNextValidator(_validator, firstValidator);\n', '        setNextValidator(F_ADDR, _validator);\n', '        setValidatorCount(validatorCount().add(1));\n', '    }\n', '\n', '    function _removeValidator(address _validator) internal {\n', '        require(validatorCount() > requiredSignatures());\n', '        require(isValidator(_validator));\n', '        address validatorsNext = getNextValidator(_validator);\n', '        address index = F_ADDR;\n', '        address next = getNextValidator(index);\n', '        require(next != address(0));\n', '\n', '        while (next != _validator) {\n', '            index = next;\n', '            next = getNextValidator(index);\n', '\n', '            require(next != F_ADDR && next != address(0));\n', '        }\n', '\n', '        setNextValidator(index, validatorsNext);\n', '        deleteItemFromAddressStorage("validatorsList", _validator);\n', '        setValidatorCount(validatorCount().sub(1));\n', '    }\n', '\n', '    function requiredSignatures() public view returns (uint256) {\n', '        return uintStorage[REQUIRED_SIGNATURES];\n', '    }\n', '\n', '    function validatorCount() public view returns (uint256) {\n', '        return uintStorage[VALIDATOR_COUNT];\n', '    }\n', '\n', '    function isValidator(address _validator) public view returns (bool) {\n', '        return _validator != F_ADDR && getNextValidator(_validator) != address(0);\n', '    }\n', '\n', '    function getNextValidator(address _address) public view returns (address) {\n', '        return addressStorage[keccak256(abi.encodePacked("validatorsList", _address))];\n', '    }\n', '\n', '    function deleteItemFromAddressStorage(string _mapName, address _address) internal {\n', '        delete addressStorage[keccak256(abi.encodePacked(_mapName, _address))];\n', '    }\n', '\n', '    function setValidatorCount(uint256 _validatorCount) internal {\n', '        require(_validatorCount <= MAX_VALIDATORS);\n', '        uintStorage[VALIDATOR_COUNT] = _validatorCount;\n', '    }\n', '\n', '    function setNextValidator(address _prevValidator, address _validator) internal {\n', '        addressStorage[keccak256(abi.encodePacked("validatorsList", _prevValidator))] = _validator;\n', '    }\n', '\n', '    function isValidatorDuty(address _validator) external view returns (bool) {\n', '        uint256 counter = 0;\n', '        address next = getNextValidator(F_ADDR);\n', '        require(next != address(0));\n', '\n', '        while (next != F_ADDR) {\n', '            if (next == _validator) {\n', '                return (block.number % validatorCount() == counter);\n', '            }\n', '\n', '            next = getNextValidator(next);\n', '            counter++;\n', '\n', '            require(next != address(0));\n', '        }\n', '\n', '        return false;\n', '    }\n', '}\n', '\n', '// File: contracts/upgradeable_contracts/RewardableValidators.sol\n', '\n', 'pragma solidity 0.4.24;\n', '\n', '\n', 'contract RewardableValidators is BaseBridgeValidators {\n', '    function initialize(\n', '        uint256 _requiredSignatures,\n', '        address[] _initialValidators,\n', '        address[] _initialRewards,\n', '        address _owner\n', '    ) external onlyRelevantSender returns (bool) {\n', '        require(!isInitialized());\n', '        require(_owner != address(0));\n', '        setOwner(_owner);\n', '        require(_requiredSignatures != 0);\n', '        require(_initialValidators.length >= _requiredSignatures);\n', '        require(_initialValidators.length == _initialRewards.length);\n', '\n', '        for (uint256 i = 0; i < _initialValidators.length; i++) {\n', '            require(_initialValidators[i] != address(0) && _initialValidators[i] != F_ADDR);\n', '            require(_initialRewards[i] != address(0));\n', '            require(!isValidator(_initialValidators[i]));\n', '\n', '            if (i == 0) {\n', '                setNextValidator(F_ADDR, _initialValidators[i]);\n', '                if (_initialValidators.length == 1) {\n', '                    setNextValidator(_initialValidators[i], F_ADDR);\n', '                }\n', '            } else if (i == _initialValidators.length - 1) {\n', '                setNextValidator(_initialValidators[i - 1], _initialValidators[i]);\n', '                setNextValidator(_initialValidators[i], F_ADDR);\n', '            } else {\n', '                setNextValidator(_initialValidators[i - 1], _initialValidators[i]);\n', '            }\n', '\n', '            setValidatorRewardAddress(_initialValidators[i], _initialRewards[i]);\n', '            emit ValidatorAdded(_initialValidators[i]);\n', '        }\n', '\n', '        setValidatorCount(_initialValidators.length);\n', '        uintStorage[REQUIRED_SIGNATURES] = _requiredSignatures;\n', '        uintStorage[DEPLOYED_AT_BLOCK] = block.number;\n', '        setInitialize();\n', '        emit RequiredSignaturesChanged(_requiredSignatures);\n', '\n', '        return isInitialized();\n', '    }\n', '\n', '    function addRewardableValidator(address _validator, address _reward) external onlyOwner {\n', '        require(_reward != address(0));\n', '        _addValidator(_validator);\n', '        setValidatorRewardAddress(_validator, _reward);\n', '        emit ValidatorAdded(_validator);\n', '    }\n', '\n', '    function removeValidator(address _validator) external onlyOwner {\n', '        _removeValidator(_validator);\n', '        deleteItemFromAddressStorage("validatorsRewards", _validator);\n', '        emit ValidatorRemoved(_validator);\n', '    }\n', '\n', '    function getValidatorRewardAddress(address _validator) external view returns (address) {\n', '        return addressStorage[keccak256(abi.encodePacked("validatorsRewards", _validator))];\n', '    }\n', '\n', '    function setValidatorRewardAddress(address _validator, address _reward) internal {\n', '        addressStorage[keccak256(abi.encodePacked("validatorsRewards", _validator))] = _reward;\n', '    }\n', '}']