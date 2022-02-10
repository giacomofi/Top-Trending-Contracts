['// File: contracts/EternalStorage.sol\n', '\n', '// Roman Storm Multi Sender\n', '// To Use this Dapp: https://rstormsf.github.io/multisender\n', 'pragma solidity 0.4.23;\n', '\n', '\n', '/**\n', ' * @title EternalStorage\n', ' * @dev This contract holds all the necessary state variables to carry out the storage of any contract.\n', ' */\n', 'contract EternalStorage {\n', '\n', '    mapping(bytes32 => uint256) internal uintStorage;\n', '    mapping(bytes32 => string) internal stringStorage;\n', '    mapping(bytes32 => address) internal addressStorage;\n', '    mapping(bytes32 => bytes) internal bytesStorage;\n', '    mapping(bytes32 => bool) internal boolStorage;\n', '    mapping(bytes32 => int256) internal intStorage;\n', '\n', '}\n', '\n', '// File: contracts/UpgradeabilityStorage.sol\n', '\n', '// Roman Storm Multi Sender\n', '// To Use this Dapp: https://rstormsf.github.io/multisender\n', 'pragma solidity 0.4.23;\n', '\n', '\n', '/**\n', ' * @title UpgradeabilityStorage\n', ' * @dev This contract holds all the necessary state variables to support the upgrade functionality\n', ' */\n', 'contract UpgradeabilityStorage {\n', '  // Version name of the current implementation\n', '    string internal _version;\n', '\n', '    // Address of the current implementation\n', '    address internal _implementation;\n', '\n', '    /**\n', '    * @dev Tells the version name of the current implementation\n', '    * @return string representing the name of the current version\n', '    */\n', '    function version() public view returns (string) {\n', '        return _version;\n', '    }\n', '\n', '    /**\n', '    * @dev Tells the address of the current implementation\n', '    * @return address of the current implementation\n', '    */\n', '    function implementation() public view returns (address) {\n', '        return _implementation;\n', '    }\n', '}\n', '\n', '// File: contracts/UpgradeabilityOwnerStorage.sol\n', '\n', '// Roman Storm Multi Sender\n', '// To Use this Dapp: https://rstormsf.github.io/multisender\n', 'pragma solidity 0.4.23;\n', '\n', '\n', '/**\n', ' * @title UpgradeabilityOwnerStorage\n', ' * @dev This contract keeps track of the upgradeability owner\n', ' */\n', 'contract UpgradeabilityOwnerStorage {\n', '  // Owner of the contract\n', '    address private _upgradeabilityOwner;\n', '\n', '    /**\n', '    * @dev Tells the address of the owner\n', '    * @return the address of the owner\n', '    */\n', '    function upgradeabilityOwner() public view returns (address) {\n', '        return _upgradeabilityOwner;\n', '    }\n', '\n', '    /**\n', '    * @dev Sets the address of the owner\n', '    */\n', '    function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {\n', '        _upgradeabilityOwner = newUpgradeabilityOwner;\n', '    }\n', '\n', '}\n', '\n', '// File: contracts/OwnedUpgradeabilityStorage.sol\n', '\n', '// Roman Storm Multi Sender\n', '// To Use this Dapp: https://rstormsf.github.io/multisender\n', 'pragma solidity 0.4.23;\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title OwnedUpgradeabilityStorage\n', ' * @dev This is the storage necessary to perform upgradeable contracts.\n', ' * This means, required state variables for upgradeability purpose and eternal storage per se.\n', ' */\n', 'contract OwnedUpgradeabilityStorage is UpgradeabilityOwnerStorage, UpgradeabilityStorage, EternalStorage {}\n', '\n', '// File: contracts/multisender/Ownable.sol\n', '\n', '// Roman Storm Multi Sender\n', '// To Use this Dapp: https://rstormsf.github.io/multisender\n', 'pragma solidity 0.4.23;\n', '\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev This contract has an owner address providing basic authorization control\n', ' */\n', 'contract Ownable is EternalStorage {\n', '    /**\n', '    * @dev Event to show ownership has been transferred\n', '    * @param previousOwner representing the address of the previous owner\n', '    * @param newOwner representing the address of the new owner\n', '    */\n', '    event OwnershipTransferred(address previousOwner, address newOwner);\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner());\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Tells the address of the owner\n', '    * @return the address of the owner\n', '    */\n', '    function owner() public view returns (address) {\n', '        return addressStorage[keccak256("owner")];\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner the address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        setOwner(newOwner);\n', '    }\n', '\n', '    /**\n', '    * @dev Sets a new owner address\n', '    */\n', '    function setOwner(address newOwner) internal {\n', '        OwnershipTransferred(owner(), newOwner);\n', '        addressStorage[keccak256("owner")] = newOwner;\n', '    }\n', '}\n', '\n', '// File: contracts/multisender/Claimable.sol\n', '\n', '// Roman Storm Multi Sender\n', '// To Use this Dapp: https://rstormsf.github.io/multisender\n', 'pragma solidity 0.4.23;\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Claimable\n', ' * @dev Extension for the Ownable contract, where the ownership needs to be claimed.\n', ' * This allows the new owner to accept the transfer.\n', ' */\n', 'contract Claimable is EternalStorage, Ownable {\n', '    function pendingOwner() public view returns (address) {\n', '        return addressStorage[keccak256("pendingOwner")];\n', '    }\n', '\n', '    /**\n', '    * @dev Modifier throws if called by any account other than the pendingOwner.\n', '    */\n', '    modifier onlyPendingOwner() {\n', '        require(msg.sender == pendingOwner());\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to set the pendingOwner address.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        addressStorage[keccak256("pendingOwner")] = newOwner;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the pendingOwner address to finalize the transfer.\n', '    */\n', '    function claimOwnership() public onlyPendingOwner {\n', '        OwnershipTransferred(owner(), pendingOwner());\n', '        addressStorage[keccak256("owner")] = addressStorage[keccak256("pendingOwner")];\n', '        addressStorage[keccak256("pendingOwner")] = address(0);\n', '    }\n', '}\n', '\n', '// File: contracts/SafeMath.sol\n', '\n', '// Roman Storm Multi Sender\n', '// To Use this Dapp: https://rstormsf.github.io/multisender\n', 'pragma solidity 0.4.23;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: contracts/multisender/UpgradebleStormSender.sol\n', '\n', '// Roman Storm Multi Sender\n', '// To Use this Dapp: https://rstormsf.github.io/multisender\n', 'pragma solidity 0.4.23;\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'contract UpgradebleStormSender is OwnedUpgradeabilityStorage, Claimable {\n', '    using SafeMath for uint256;\n', '\n', '    event Multisended(uint256 total, address tokenAddress);\n', '    event ClaimedTokens(address token, address owner, uint256 balance);\n', '\n', '    modifier hasFee() {\n', '        if (currentFee(msg.sender) > 0) {\n', '            require(msg.value >= currentFee(msg.sender));\n', '        }\n', '        _;\n', '    }\n', '\n', '    function() public payable {}\n', '\n', '    function initialize(address _owner) public {\n', '        require(!initialized());\n', '        setOwner(_owner);\n', '        setArrayLimit(200);\n', '        setDiscountStep(0.00005 ether);\n', '        setFee(0.005 ether);\n', '        boolStorage[keccak256("rs_multisender_initialized")] = true;\n', '    }\n', '\n', '    function initialized() public view returns (bool) {\n', '        return boolStorage[keccak256("rs_multisender_initialized")];\n', '    }\n', '\n', '    function txCount(address customer) public view returns(uint256) {\n', '        return uintStorage[keccak256("txCount", customer)];\n', '    }\n', '\n', '    function arrayLimit() public view returns(uint256) {\n', '        return uintStorage[keccak256("arrayLimit")];\n', '    }\n', '\n', '    function setArrayLimit(uint256 _newLimit) public onlyOwner {\n', '        require(_newLimit != 0);\n', '        uintStorage[keccak256("arrayLimit")] = _newLimit;\n', '    }\n', '\n', '    function discountStep() public view returns(uint256) {\n', '        return uintStorage[keccak256("discountStep")];\n', '    }\n', '\n', '    function setDiscountStep(uint256 _newStep) public onlyOwner {\n', '        require(_newStep != 0);\n', '        uintStorage[keccak256("discountStep")] = _newStep;\n', '    }\n', '\n', '    function fee() public view returns(uint256) {\n', '        return uintStorage[keccak256("fee")];\n', '    }\n', '\n', '    function currentFee(address _customer) public view returns(uint256) {\n', '        if (fee() > discountRate(msg.sender)) {\n', '            return fee().sub(discountRate(_customer));\n', '        } else {\n', '            return 0;\n', '        }\n', '    }\n', '\n', '    function setFee(uint256 _newStep) public onlyOwner {\n', '        require(_newStep != 0);\n', '        uintStorage[keccak256("fee")] = _newStep;\n', '    }\n', '\n', '    function discountRate(address _customer) public view returns(uint256) {\n', '        uint256 count = txCount(_customer);\n', '        return count.mul(discountStep());\n', '    }\n', '\n', '    function multisendToken(address token, address[] _contributors, uint256[] _balances) public hasFee payable {\n', '        if (token == 0x000000000000000000000000000000000000bEEF){\n', '            multisendEther(_contributors, _balances);\n', '        } else {\n', '            uint256 total = 0;\n', '            require(_contributors.length <= arrayLimit());\n', '            ERC20 erc20token = ERC20(token);\n', '            uint8 i = 0;\n', '            for (i; i < _contributors.length; i++) {\n', '                erc20token.transferFrom(msg.sender, _contributors[i], _balances[i]);\n', '                total += _balances[i];\n', '            }\n', '            setTxCount(msg.sender, txCount(msg.sender).add(1));\n', '            Multisended(total, token);\n', '        }\n', '    }\n', '\n', '    function multisendEther(address[] _contributors, uint256[] _balances) public payable {\n', '        uint256 total = msg.value;\n', '        uint256 fee = currentFee(msg.sender);\n', '        require(total >= fee);\n', '        require(_contributors.length <= arrayLimit());\n', '        total = total.sub(fee);\n', '        uint256 i = 0;\n', '        for (i; i < _contributors.length; i++) {\n', '            require(total >= _balances[i]);\n', '            total = total.sub(_balances[i]);\n', '            _contributors[i].transfer(_balances[i]);\n', '        }\n', '        setTxCount(msg.sender, txCount(msg.sender).add(1));\n', '        Multisended(msg.value, 0x000000000000000000000000000000000000bEEF);\n', '    }\n', '\n', '    function claimTokens(address _token) public onlyOwner {\n', '        if (_token == 0x0) {\n', '            owner().transfer(this.balance);\n', '            return;\n', '        }\n', '        ERC20 erc20token = ERC20(_token);\n', '        uint256 balance = erc20token.balanceOf(this);\n', '        erc20token.transfer(owner(), balance);\n', '        ClaimedTokens(_token, owner(), balance);\n', '    }\n', '\n', '    function setTxCount(address customer, uint256 _txCount) private {\n', '        uintStorage[keccak256("txCount", customer)] = _txCount;\n', '    }\n', '\n', '}']
['// File: contracts/EternalStorage.sol\n', '\n', '// Roman Storm Multi Sender\n', '// To Use this Dapp: https://rstormsf.github.io/multisender\n', 'pragma solidity 0.4.23;\n', '\n', '\n', '/**\n', ' * @title EternalStorage\n', ' * @dev This contract holds all the necessary state variables to carry out the storage of any contract.\n', ' */\n', 'contract EternalStorage {\n', '\n', '    mapping(bytes32 => uint256) internal uintStorage;\n', '    mapping(bytes32 => string) internal stringStorage;\n', '    mapping(bytes32 => address) internal addressStorage;\n', '    mapping(bytes32 => bytes) internal bytesStorage;\n', '    mapping(bytes32 => bool) internal boolStorage;\n', '    mapping(bytes32 => int256) internal intStorage;\n', '\n', '}\n', '\n', '// File: contracts/UpgradeabilityStorage.sol\n', '\n', '// Roman Storm Multi Sender\n', '// To Use this Dapp: https://rstormsf.github.io/multisender\n', 'pragma solidity 0.4.23;\n', '\n', '\n', '/**\n', ' * @title UpgradeabilityStorage\n', ' * @dev This contract holds all the necessary state variables to support the upgrade functionality\n', ' */\n', 'contract UpgradeabilityStorage {\n', '  // Version name of the current implementation\n', '    string internal _version;\n', '\n', '    // Address of the current implementation\n', '    address internal _implementation;\n', '\n', '    /**\n', '    * @dev Tells the version name of the current implementation\n', '    * @return string representing the name of the current version\n', '    */\n', '    function version() public view returns (string) {\n', '        return _version;\n', '    }\n', '\n', '    /**\n', '    * @dev Tells the address of the current implementation\n', '    * @return address of the current implementation\n', '    */\n', '    function implementation() public view returns (address) {\n', '        return _implementation;\n', '    }\n', '}\n', '\n', '// File: contracts/UpgradeabilityOwnerStorage.sol\n', '\n', '// Roman Storm Multi Sender\n', '// To Use this Dapp: https://rstormsf.github.io/multisender\n', 'pragma solidity 0.4.23;\n', '\n', '\n', '/**\n', ' * @title UpgradeabilityOwnerStorage\n', ' * @dev This contract keeps track of the upgradeability owner\n', ' */\n', 'contract UpgradeabilityOwnerStorage {\n', '  // Owner of the contract\n', '    address private _upgradeabilityOwner;\n', '\n', '    /**\n', '    * @dev Tells the address of the owner\n', '    * @return the address of the owner\n', '    */\n', '    function upgradeabilityOwner() public view returns (address) {\n', '        return _upgradeabilityOwner;\n', '    }\n', '\n', '    /**\n', '    * @dev Sets the address of the owner\n', '    */\n', '    function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {\n', '        _upgradeabilityOwner = newUpgradeabilityOwner;\n', '    }\n', '\n', '}\n', '\n', '// File: contracts/OwnedUpgradeabilityStorage.sol\n', '\n', '// Roman Storm Multi Sender\n', '// To Use this Dapp: https://rstormsf.github.io/multisender\n', 'pragma solidity 0.4.23;\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title OwnedUpgradeabilityStorage\n', ' * @dev This is the storage necessary to perform upgradeable contracts.\n', ' * This means, required state variables for upgradeability purpose and eternal storage per se.\n', ' */\n', 'contract OwnedUpgradeabilityStorage is UpgradeabilityOwnerStorage, UpgradeabilityStorage, EternalStorage {}\n', '\n', '// File: contracts/multisender/Ownable.sol\n', '\n', '// Roman Storm Multi Sender\n', '// To Use this Dapp: https://rstormsf.github.io/multisender\n', 'pragma solidity 0.4.23;\n', '\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev This contract has an owner address providing basic authorization control\n', ' */\n', 'contract Ownable is EternalStorage {\n', '    /**\n', '    * @dev Event to show ownership has been transferred\n', '    * @param previousOwner representing the address of the previous owner\n', '    * @param newOwner representing the address of the new owner\n', '    */\n', '    event OwnershipTransferred(address previousOwner, address newOwner);\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner());\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Tells the address of the owner\n', '    * @return the address of the owner\n', '    */\n', '    function owner() public view returns (address) {\n', '        return addressStorage[keccak256("owner")];\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner the address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        setOwner(newOwner);\n', '    }\n', '\n', '    /**\n', '    * @dev Sets a new owner address\n', '    */\n', '    function setOwner(address newOwner) internal {\n', '        OwnershipTransferred(owner(), newOwner);\n', '        addressStorage[keccak256("owner")] = newOwner;\n', '    }\n', '}\n', '\n', '// File: contracts/multisender/Claimable.sol\n', '\n', '// Roman Storm Multi Sender\n', '// To Use this Dapp: https://rstormsf.github.io/multisender\n', 'pragma solidity 0.4.23;\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Claimable\n', ' * @dev Extension for the Ownable contract, where the ownership needs to be claimed.\n', ' * This allows the new owner to accept the transfer.\n', ' */\n', 'contract Claimable is EternalStorage, Ownable {\n', '    function pendingOwner() public view returns (address) {\n', '        return addressStorage[keccak256("pendingOwner")];\n', '    }\n', '\n', '    /**\n', '    * @dev Modifier throws if called by any account other than the pendingOwner.\n', '    */\n', '    modifier onlyPendingOwner() {\n', '        require(msg.sender == pendingOwner());\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to set the pendingOwner address.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        addressStorage[keccak256("pendingOwner")] = newOwner;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the pendingOwner address to finalize the transfer.\n', '    */\n', '    function claimOwnership() public onlyPendingOwner {\n', '        OwnershipTransferred(owner(), pendingOwner());\n', '        addressStorage[keccak256("owner")] = addressStorage[keccak256("pendingOwner")];\n', '        addressStorage[keccak256("pendingOwner")] = address(0);\n', '    }\n', '}\n', '\n', '// File: contracts/SafeMath.sol\n', '\n', '// Roman Storm Multi Sender\n', '// To Use this Dapp: https://rstormsf.github.io/multisender\n', 'pragma solidity 0.4.23;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: contracts/multisender/UpgradebleStormSender.sol\n', '\n', '// Roman Storm Multi Sender\n', '// To Use this Dapp: https://rstormsf.github.io/multisender\n', 'pragma solidity 0.4.23;\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'contract UpgradebleStormSender is OwnedUpgradeabilityStorage, Claimable {\n', '    using SafeMath for uint256;\n', '\n', '    event Multisended(uint256 total, address tokenAddress);\n', '    event ClaimedTokens(address token, address owner, uint256 balance);\n', '\n', '    modifier hasFee() {\n', '        if (currentFee(msg.sender) > 0) {\n', '            require(msg.value >= currentFee(msg.sender));\n', '        }\n', '        _;\n', '    }\n', '\n', '    function() public payable {}\n', '\n', '    function initialize(address _owner) public {\n', '        require(!initialized());\n', '        setOwner(_owner);\n', '        setArrayLimit(200);\n', '        setDiscountStep(0.00005 ether);\n', '        setFee(0.005 ether);\n', '        boolStorage[keccak256("rs_multisender_initialized")] = true;\n', '    }\n', '\n', '    function initialized() public view returns (bool) {\n', '        return boolStorage[keccak256("rs_multisender_initialized")];\n', '    }\n', '\n', '    function txCount(address customer) public view returns(uint256) {\n', '        return uintStorage[keccak256("txCount", customer)];\n', '    }\n', '\n', '    function arrayLimit() public view returns(uint256) {\n', '        return uintStorage[keccak256("arrayLimit")];\n', '    }\n', '\n', '    function setArrayLimit(uint256 _newLimit) public onlyOwner {\n', '        require(_newLimit != 0);\n', '        uintStorage[keccak256("arrayLimit")] = _newLimit;\n', '    }\n', '\n', '    function discountStep() public view returns(uint256) {\n', '        return uintStorage[keccak256("discountStep")];\n', '    }\n', '\n', '    function setDiscountStep(uint256 _newStep) public onlyOwner {\n', '        require(_newStep != 0);\n', '        uintStorage[keccak256("discountStep")] = _newStep;\n', '    }\n', '\n', '    function fee() public view returns(uint256) {\n', '        return uintStorage[keccak256("fee")];\n', '    }\n', '\n', '    function currentFee(address _customer) public view returns(uint256) {\n', '        if (fee() > discountRate(msg.sender)) {\n', '            return fee().sub(discountRate(_customer));\n', '        } else {\n', '            return 0;\n', '        }\n', '    }\n', '\n', '    function setFee(uint256 _newStep) public onlyOwner {\n', '        require(_newStep != 0);\n', '        uintStorage[keccak256("fee")] = _newStep;\n', '    }\n', '\n', '    function discountRate(address _customer) public view returns(uint256) {\n', '        uint256 count = txCount(_customer);\n', '        return count.mul(discountStep());\n', '    }\n', '\n', '    function multisendToken(address token, address[] _contributors, uint256[] _balances) public hasFee payable {\n', '        if (token == 0x000000000000000000000000000000000000bEEF){\n', '            multisendEther(_contributors, _balances);\n', '        } else {\n', '            uint256 total = 0;\n', '            require(_contributors.length <= arrayLimit());\n', '            ERC20 erc20token = ERC20(token);\n', '            uint8 i = 0;\n', '            for (i; i < _contributors.length; i++) {\n', '                erc20token.transferFrom(msg.sender, _contributors[i], _balances[i]);\n', '                total += _balances[i];\n', '            }\n', '            setTxCount(msg.sender, txCount(msg.sender).add(1));\n', '            Multisended(total, token);\n', '        }\n', '    }\n', '\n', '    function multisendEther(address[] _contributors, uint256[] _balances) public payable {\n', '        uint256 total = msg.value;\n', '        uint256 fee = currentFee(msg.sender);\n', '        require(total >= fee);\n', '        require(_contributors.length <= arrayLimit());\n', '        total = total.sub(fee);\n', '        uint256 i = 0;\n', '        for (i; i < _contributors.length; i++) {\n', '            require(total >= _balances[i]);\n', '            total = total.sub(_balances[i]);\n', '            _contributors[i].transfer(_balances[i]);\n', '        }\n', '        setTxCount(msg.sender, txCount(msg.sender).add(1));\n', '        Multisended(msg.value, 0x000000000000000000000000000000000000bEEF);\n', '    }\n', '\n', '    function claimTokens(address _token) public onlyOwner {\n', '        if (_token == 0x0) {\n', '            owner().transfer(this.balance);\n', '            return;\n', '        }\n', '        ERC20 erc20token = ERC20(_token);\n', '        uint256 balance = erc20token.balanceOf(this);\n', '        erc20token.transfer(owner(), balance);\n', '        ClaimedTokens(_token, owner(), balance);\n', '    }\n', '\n', '    function setTxCount(address customer, uint256 _txCount) private {\n', '        uintStorage[keccak256("txCount", customer)] = _txCount;\n', '    }\n', '\n', '}']
