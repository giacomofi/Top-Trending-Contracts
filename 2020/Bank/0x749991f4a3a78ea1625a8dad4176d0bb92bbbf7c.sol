['// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * See https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address _who) public view returns (uint256);\n', '  function transfer(address _to, uint256 _value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address _owner, address _spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value)\n', '    public returns (bool);\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '// File: contracts/interfaces/ERC677.sol\n', '\n', 'pragma solidity 0.4.24;\n', '\n', '\n', 'contract ERC677 is ERC20 {\n', '    event Transfer(address indexed from, address indexed to, uint256 value, bytes data);\n', '\n', '    function transferAndCall(address, uint256, bytes) external returns (bool);\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue) public returns (bool);\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool);\n', '}\n', '\n', '// File: contracts/interfaces/IBurnableMintableERC677Token.sol\n', '\n', 'pragma solidity 0.4.24;\n', '\n', '\n', 'contract IBurnableMintableERC677Token is ERC677 {\n', '    function mint(address _to, uint256 _amount) public returns (bool);\n', '    function burn(uint256 _value) public;\n', '    function claimTokens(address _token, address _to) public;\n', '}\n', '\n', '// File: contracts/upgradeable_contracts/Sacrifice.sol\n', '\n', 'pragma solidity 0.4.24;\n', '\n', 'contract Sacrifice {\n', '    constructor(address _recipient) public payable {\n', '        selfdestruct(_recipient);\n', '    }\n', '}\n', '\n', '// File: contracts/libraries/Address.sol\n', '\n', 'pragma solidity 0.4.24;\n', '\n', '\n', '/**\n', ' * @title Address\n', ' * @dev Helper methods for Address type.\n', ' */\n', 'library Address {\n', '    /**\n', '    * @dev Try to send native tokens to the address. If it fails, it will force the transfer by creating a selfdestruct contract\n', '    * @param _receiver address that will receive the native tokens\n', '    * @param _value the amount of native tokens to send\n', '    */\n', '    function safeSendValue(address _receiver, uint256 _value) internal {\n', '        if (!_receiver.send(_value)) {\n', '            (new Sacrifice).value(_value)(_receiver);\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/upgradeability/EternalStorage.sol\n', '\n', 'pragma solidity 0.4.24;\n', '\n', '/**\n', ' * @title EternalStorage\n', ' * @dev This contract holds all the necessary state variables to carry out the storage of any contract.\n', ' */\n', 'contract EternalStorage {\n', '    mapping(bytes32 => uint256) internal uintStorage;\n', '    mapping(bytes32 => string) internal stringStorage;\n', '    mapping(bytes32 => address) internal addressStorage;\n', '    mapping(bytes32 => bytes) internal bytesStorage;\n', '    mapping(bytes32 => bool) internal boolStorage;\n', '    mapping(bytes32 => int256) internal intStorage;\n', '\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', "    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (_a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = _a * _b;\n', '    assert(c / _a == _b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    // assert(_b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = _a / _b;\n', "    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold\n", '    return _a / _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    assert(_b <= _a);\n', '    return _a - _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    c = _a + _b;\n', '    assert(c >= _a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: contracts/interfaces/IRewardableValidators.sol\n', '\n', 'pragma solidity 0.4.24;\n', '\n', 'interface IRewardableValidators {\n', '    function isValidator(address _validator) external view returns (bool);\n', '    function requiredSignatures() external view returns (uint256);\n', '    function owner() external view returns (address);\n', '    function validatorList() external view returns (address[]);\n', '    function getValidatorRewardAddress(address _validator) external view returns (address);\n', '    function validatorCount() external view returns (uint256);\n', '    function getNextValidator(address _address) external view returns (address);\n', '}\n', '\n', '// File: contracts/upgradeable_contracts/FeeTypes.sol\n', '\n', 'pragma solidity 0.4.24;\n', '\n', 'contract FeeTypes {\n', '    bytes32 internal constant HOME_FEE = 0x89d93e5e92f7e37e490c25f0e50f7f4aad7cc94b308a566553280967be38bcf1; // keccak256(abi.encodePacked("home-fee"))\n', '    bytes32 internal constant FOREIGN_FEE = 0xdeb7f3adca07d6d1f708c1774389db532a2b2f18fd05a62b957e4089f4696ed5; // keccak256(abi.encodePacked("foreign-fee"))\n', '}\n', '\n', '// File: contracts/upgradeable_contracts/BaseFeeManager.sol\n', '\n', 'pragma solidity 0.4.24;\n', '\n', '\n', '\n', '\n', '\n', 'contract BaseFeeManager is EternalStorage, FeeTypes {\n', '    using SafeMath for uint256;\n', '\n', '    event HomeFeeUpdated(uint256 fee);\n', '    event ForeignFeeUpdated(uint256 fee);\n', '\n', '    // This is not a real fee value but a relative value used to calculate the fee percentage\n', '    uint256 internal constant MAX_FEE = 1 ether;\n', '    bytes32 internal constant HOME_FEE_STORAGE_KEY = 0xc3781f3cec62d28f56efe98358f59c2105504b194242dbcb2cc0806850c306e7; // keccak256(abi.encodePacked("homeFee"))\n', '    bytes32 internal constant FOREIGN_FEE_STORAGE_KEY = 0x68c305f6c823f4d2fa4140f9cf28d32a1faccf9b8081ff1c2de11cf32c733efc; // keccak256(abi.encodePacked("foreignFee"))\n', '\n', '    function calculateFee(uint256 _value, bool _recover, bytes32 _feeType) public view returns (uint256) {\n', '        uint256 fee = _feeType == HOME_FEE ? getHomeFee() : getForeignFee();\n', '        if (!_recover) {\n', '            return _value.mul(fee).div(MAX_FEE);\n', '        }\n', '        return _value.mul(fee).div(MAX_FEE.sub(fee));\n', '    }\n', '\n', '    modifier validFee(uint256 _fee) {\n', '        require(_fee < MAX_FEE);\n', '        /* solcov ignore next */\n', '        _;\n', '    }\n', '\n', '    function setHomeFee(uint256 _fee) external validFee(_fee) {\n', '        uintStorage[HOME_FEE_STORAGE_KEY] = _fee;\n', '        emit HomeFeeUpdated(_fee);\n', '    }\n', '\n', '    function getHomeFee() public view returns (uint256) {\n', '        return uintStorage[HOME_FEE_STORAGE_KEY];\n', '    }\n', '\n', '    function setForeignFee(uint256 _fee) external validFee(_fee) {\n', '        uintStorage[FOREIGN_FEE_STORAGE_KEY] = _fee;\n', '        emit ForeignFeeUpdated(_fee);\n', '    }\n', '\n', '    function getForeignFee() public view returns (uint256) {\n', '        return uintStorage[FOREIGN_FEE_STORAGE_KEY];\n', '    }\n', '\n', '    /* solcov ignore next */\n', '    function distributeFeeFromAffirmation(uint256 _fee) external;\n', '\n', '    /* solcov ignore next */\n', '    function distributeFeeFromSignatures(uint256 _fee) external;\n', '\n', '    /* solcov ignore next */\n', '    function getFeeManagerMode() external pure returns (bytes4);\n', '\n', '    function random(uint256 _count) internal view returns (uint256) {\n', '        return uint256(blockhash(block.number.sub(1))) % _count;\n', '    }\n', '}\n', '\n', '// File: contracts/upgradeable_contracts/ValidatorStorage.sol\n', '\n', 'pragma solidity 0.4.24;\n', '\n', 'contract ValidatorStorage {\n', '    bytes32 internal constant VALIDATOR_CONTRACT = 0x5a74bb7e202fb8e4bf311841c7d64ec19df195fee77d7e7ae749b27921b6ddfe; // keccak256(abi.encodePacked("validatorContract"))\n', '}\n', '\n', '// File: contracts/upgradeable_contracts/ValidatorsFeeManager.sol\n', '\n', 'pragma solidity 0.4.24;\n', '\n', '\n', '\n', '\n', 'contract ValidatorsFeeManager is BaseFeeManager, ValidatorStorage {\n', '    bytes32 public constant REWARD_FOR_TRANSFERRING_FROM_HOME = 0x2a11db67c480122765825a7e4bc5428e8b7b9eca0d4e62b91aac194f99edd0d7; // keccak256(abi.encodePacked("reward-transferring-from-home"))\n', '    bytes32 public constant REWARD_FOR_TRANSFERRING_FROM_FOREIGN = 0xb14796d751eb4f2570065a479f9e526eabeb2077c564c8a1c5ea559883ea2fab; // keccak256(abi.encodePacked("reward-transferring-from-foreign"))\n', '\n', '    function distributeFeeFromAffirmation(uint256 _fee) external {\n', '        distributeFeeProportionally(_fee, REWARD_FOR_TRANSFERRING_FROM_FOREIGN);\n', '    }\n', '\n', '    function distributeFeeFromSignatures(uint256 _fee) external {\n', '        distributeFeeProportionally(_fee, REWARD_FOR_TRANSFERRING_FROM_HOME);\n', '    }\n', '\n', '    function rewardableValidatorContract() internal view returns (IRewardableValidators) {\n', '        return IRewardableValidators(addressStorage[VALIDATOR_CONTRACT]);\n', '    }\n', '\n', '    function distributeFeeProportionally(uint256 _fee, bytes32 _direction) internal {\n', '        IRewardableValidators validators = rewardableValidatorContract();\n', '        // solhint-disable-next-line var-name-mixedcase\n', '        address F_ADDR = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;\n', '        uint256 numOfValidators = validators.validatorCount();\n', '\n', '        uint256 feePerValidator = _fee.div(numOfValidators);\n', '\n', '        uint256 randomValidatorIndex;\n', '        uint256 diff = _fee.sub(feePerValidator.mul(numOfValidators));\n', '        if (diff > 0) {\n', '            randomValidatorIndex = random(numOfValidators);\n', '        }\n', '\n', '        address nextValidator = validators.getNextValidator(F_ADDR);\n', '        require((nextValidator != F_ADDR) && (nextValidator != address(0)));\n', '\n', '        uint256 i = 0;\n', '        while (nextValidator != F_ADDR) {\n', '            uint256 feeToDistribute = feePerValidator;\n', '            if (diff > 0 && randomValidatorIndex == i) {\n', '                feeToDistribute = feeToDistribute.add(diff);\n', '            }\n', '\n', '            address rewardAddress = validators.getValidatorRewardAddress(nextValidator);\n', '            onFeeDistribution(rewardAddress, feeToDistribute, _direction);\n', '\n', '            nextValidator = validators.getNextValidator(nextValidator);\n', '            require(nextValidator != address(0));\n', '            i = i + 1;\n', '        }\n', '    }\n', '\n', '    function onFeeDistribution(address _rewardAddress, uint256 _fee, bytes32 _direction) internal {\n', '        if (_direction == REWARD_FOR_TRANSFERRING_FROM_FOREIGN) {\n', '            onAffirmationFeeDistribution(_rewardAddress, _fee);\n', '        } else {\n', '            onSignatureFeeDistribution(_rewardAddress, _fee);\n', '        }\n', '    }\n', '\n', '    /* solcov ignore next */\n', '    function onAffirmationFeeDistribution(address _rewardAddress, uint256 _fee) internal;\n', '\n', '    /* solcov ignore next */\n', '    function onSignatureFeeDistribution(address _rewardAddress, uint256 _fee) internal;\n', '}\n', '\n', '// File: contracts/upgradeable_contracts/ERC677Storage.sol\n', '\n', 'pragma solidity 0.4.24;\n', '\n', 'contract ERC677Storage {\n', '    bytes32 internal constant ERC677_TOKEN = 0xa8b0ade3e2b734f043ce298aca4cc8d19d74270223f34531d0988b7d00cba21d; // keccak256(abi.encodePacked("erc677token"))\n', '}\n', '\n', '// File: contracts/upgradeable_contracts/native_to_erc20/FeeManagerNativeToErc.sol\n', '\n', 'pragma solidity 0.4.24;\n', '\n', '\n', '\n', '\n', '\n', 'contract FeeManagerNativeToErc is ValidatorsFeeManager, ERC677Storage {\n', '    function getFeeManagerMode() external pure returns (bytes4) {\n', '        return 0xf2aed8f7; // bytes4(keccak256(abi.encodePacked("manages-one-direction")))\n', '    }\n', '\n', '    function erc677token() public view returns (IBurnableMintableERC677Token) {\n', '        return IBurnableMintableERC677Token(addressStorage[ERC677_TOKEN]);\n', '    }\n', '\n', '    function onAffirmationFeeDistribution(address _rewardAddress, uint256 _fee) internal {\n', '        Address.safeSendValue(_rewardAddress, _fee);\n', '    }\n', '\n', '    function onSignatureFeeDistribution(address _rewardAddress, uint256 _fee) internal {\n', '        erc677token().mint(_rewardAddress, _fee);\n', '    }\n', '}']