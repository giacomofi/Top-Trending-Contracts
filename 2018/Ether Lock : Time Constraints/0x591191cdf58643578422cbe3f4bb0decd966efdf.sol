['pragma solidity 0.4.18;\n', '\n', '\n', '/*\n', ' * https://github.com/OpenZeppelin/zeppelin-solidity\n', ' *\n', ' * The MIT License (MIT)\n', ' * Copyright (c) 2016 Smart Contract Solutions, Inc.\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '/*\n', ' * https://github.com/OpenZeppelin/zeppelin-solidity\n', ' *\n', ' * The MIT License (MIT)\n', ' * Copyright (c) 2016 Smart Contract Solutions, Inc.\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Token pools registry\n', ' * @dev Allows to register multiple pools of token with lockup period\n', ' * @author Wojciech Harzowski (https://github.com/harzo)\n', ' * @author Jakub Stefanski (https://github.com/jstefanski)\n', ' */\n', 'contract TokenPool is Ownable {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    /**\n', '     * @dev Represents registered pool\n', '     */\n', '    struct Pool {\n', '        uint256 availableAmount;\n', '        uint256 lockTimestamp;\n', '    }\n', '\n', '    /**\n', '     * @dev Address of mintable token instance\n', '     */\n', '    MintableToken public token;\n', '\n', '    /**\n', '     * @dev Indicates available token amounts for each pool\n', '     */\n', '    mapping (string => Pool) private pools;\n', '\n', '    modifier onlyNotZero(uint256 amount) {\n', '        require(amount != 0);\n', '        _;\n', '    }\n', '\n', '    modifier onlySufficientAmount(string poolId, uint256 amount) {\n', '        require(amount <= pools[poolId].availableAmount);\n', '        _;\n', '    }\n', '\n', '    modifier onlyUnlockedPool(string poolId) {\n', '        /* solhint-disable not-rely-on-time */\n', '        require(block.timestamp > pools[poolId].lockTimestamp);\n', '        /* solhint-enable not-rely-on-time */\n', '        _;\n', '    }\n', '\n', '    modifier onlyUniquePool(string poolId) {\n', '        require(pools[poolId].availableAmount == 0);\n', '        _;\n', '    }\n', '\n', '    modifier onlyValid(address _address) {\n', '        require(_address != address(0));\n', '        _;\n', '    }\n', '\n', '    function TokenPool(MintableToken _token)\n', '        public\n', '        onlyValid(_token)\n', '    {\n', '        token = _token;\n', '    }\n', '\n', '    /**\n', '     * @dev New pool registered\n', '     * @param poolId string The unique pool id\n', '     * @param amount uint256 The amount of available tokens\n', '     */\n', '    event PoolRegistered(string poolId, uint256 amount);\n', '\n', '    /**\n', '     * @dev Pool locked until the specified timestamp\n', '     * @param poolId string The unique pool id\n', '     * @param lockTimestamp uint256 The lock timestamp as Unix Epoch (seconds from 1970)\n', '     */\n', '    event PoolLocked(string poolId, uint256 lockTimestamp);\n', '\n', '    /**\n', '     * @dev Tokens transferred from pool\n', '     * @param poolId string The unique pool id\n', '     * @param amount uint256 The amount of transferred tokens\n', '     */\n', '    event PoolTransferred(string poolId, address to, uint256 amount);\n', '\n', '    /**\n', '     * @dev Register a new pool and mint its tokens\n', '     * @param poolId string The unique pool id\n', '     * @param availableAmount uint256 The amount of available tokens\n', '     * @param lockTimestamp uint256 The optional lock timestamp as Unix Epoch (seconds from 1970),\n', '     *                              leave zero if not applicable\n', '     */\n', '    function registerPool(string poolId, uint256 availableAmount, uint256 lockTimestamp)\n', '        public\n', '        onlyOwner\n', '        onlyNotZero(availableAmount)\n', '        onlyUniquePool(poolId)\n', '    {\n', '        pools[poolId] = Pool({\n', '            availableAmount: availableAmount,\n', '            lockTimestamp: lockTimestamp\n', '        });\n', '\n', '        token.mint(this, availableAmount);\n', '\n', '        PoolRegistered(poolId, availableAmount);\n', '\n', '        if (lockTimestamp > 0) {\n', '            PoolLocked(poolId, lockTimestamp);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer given amount of tokens to specified address\n', '     * @param to address The address to transfer to\n', '     * @param poolId string The unique pool id\n', '     * @param amount uint256 The amount of tokens to transfer\n', '     */\n', '    function transfer(string poolId, address to, uint256 amount)\n', '        public\n', '        onlyOwner\n', '        onlyValid(to)\n', '        onlyNotZero(amount)\n', '        onlySufficientAmount(poolId, amount)\n', '        onlyUnlockedPool(poolId)\n', '    {\n', '        pools[poolId].availableAmount = pools[poolId].availableAmount.sub(amount);\n', '        require(token.transfer(to, amount));\n', '\n', '        PoolTransferred(poolId, to, amount);\n', '    }\n', '\n', '    /**\n', '     * @dev Get available amount of tokens in the specified pool\n', '     * @param poolId string The unique pool id\n', '     * @return The available amount of tokens in the specified pool\n', '     */\n', '    function getAvailableAmount(string poolId)\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return pools[poolId].availableAmount;\n', '    }\n', '\n', '    /**\n', '     * @dev Get lock timestamp of the pool or zero\n', '     * @param poolId string The unique pool id\n', '     * @return The lock expiration timestamp of the pool or zero if not specified\n', '     */\n', '    function getLockTimestamp(string poolId)\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return pools[poolId].lockTimestamp;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * https://github.com/OpenZeppelin/zeppelin-solidity\n', ' *\n', ' * The MIT License (MIT)\n', ' * Copyright (c) 2016 Smart Contract Solutions, Inc.\n', ' */\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Mintable token interface\n', ' * @author Wojciech Harzowski (https://github.com/harzo)\n', ' * @author Jakub Stefanski (https://github.com/jstefanski)\n', ' */\n', 'contract MintableToken is ERC20Basic {\n', '    function mint(address to, uint256 amount) public;\n', '}']
['pragma solidity 0.4.18;\n', '\n', '\n', '/*\n', ' * https://github.com/OpenZeppelin/zeppelin-solidity\n', ' *\n', ' * The MIT License (MIT)\n', ' * Copyright (c) 2016 Smart Contract Solutions, Inc.\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '/*\n', ' * https://github.com/OpenZeppelin/zeppelin-solidity\n', ' *\n', ' * The MIT License (MIT)\n', ' * Copyright (c) 2016 Smart Contract Solutions, Inc.\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Token pools registry\n', ' * @dev Allows to register multiple pools of token with lockup period\n', ' * @author Wojciech Harzowski (https://github.com/harzo)\n', ' * @author Jakub Stefanski (https://github.com/jstefanski)\n', ' */\n', 'contract TokenPool is Ownable {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    /**\n', '     * @dev Represents registered pool\n', '     */\n', '    struct Pool {\n', '        uint256 availableAmount;\n', '        uint256 lockTimestamp;\n', '    }\n', '\n', '    /**\n', '     * @dev Address of mintable token instance\n', '     */\n', '    MintableToken public token;\n', '\n', '    /**\n', '     * @dev Indicates available token amounts for each pool\n', '     */\n', '    mapping (string => Pool) private pools;\n', '\n', '    modifier onlyNotZero(uint256 amount) {\n', '        require(amount != 0);\n', '        _;\n', '    }\n', '\n', '    modifier onlySufficientAmount(string poolId, uint256 amount) {\n', '        require(amount <= pools[poolId].availableAmount);\n', '        _;\n', '    }\n', '\n', '    modifier onlyUnlockedPool(string poolId) {\n', '        /* solhint-disable not-rely-on-time */\n', '        require(block.timestamp > pools[poolId].lockTimestamp);\n', '        /* solhint-enable not-rely-on-time */\n', '        _;\n', '    }\n', '\n', '    modifier onlyUniquePool(string poolId) {\n', '        require(pools[poolId].availableAmount == 0);\n', '        _;\n', '    }\n', '\n', '    modifier onlyValid(address _address) {\n', '        require(_address != address(0));\n', '        _;\n', '    }\n', '\n', '    function TokenPool(MintableToken _token)\n', '        public\n', '        onlyValid(_token)\n', '    {\n', '        token = _token;\n', '    }\n', '\n', '    /**\n', '     * @dev New pool registered\n', '     * @param poolId string The unique pool id\n', '     * @param amount uint256 The amount of available tokens\n', '     */\n', '    event PoolRegistered(string poolId, uint256 amount);\n', '\n', '    /**\n', '     * @dev Pool locked until the specified timestamp\n', '     * @param poolId string The unique pool id\n', '     * @param lockTimestamp uint256 The lock timestamp as Unix Epoch (seconds from 1970)\n', '     */\n', '    event PoolLocked(string poolId, uint256 lockTimestamp);\n', '\n', '    /**\n', '     * @dev Tokens transferred from pool\n', '     * @param poolId string The unique pool id\n', '     * @param amount uint256 The amount of transferred tokens\n', '     */\n', '    event PoolTransferred(string poolId, address to, uint256 amount);\n', '\n', '    /**\n', '     * @dev Register a new pool and mint its tokens\n', '     * @param poolId string The unique pool id\n', '     * @param availableAmount uint256 The amount of available tokens\n', '     * @param lockTimestamp uint256 The optional lock timestamp as Unix Epoch (seconds from 1970),\n', '     *                              leave zero if not applicable\n', '     */\n', '    function registerPool(string poolId, uint256 availableAmount, uint256 lockTimestamp)\n', '        public\n', '        onlyOwner\n', '        onlyNotZero(availableAmount)\n', '        onlyUniquePool(poolId)\n', '    {\n', '        pools[poolId] = Pool({\n', '            availableAmount: availableAmount,\n', '            lockTimestamp: lockTimestamp\n', '        });\n', '\n', '        token.mint(this, availableAmount);\n', '\n', '        PoolRegistered(poolId, availableAmount);\n', '\n', '        if (lockTimestamp > 0) {\n', '            PoolLocked(poolId, lockTimestamp);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer given amount of tokens to specified address\n', '     * @param to address The address to transfer to\n', '     * @param poolId string The unique pool id\n', '     * @param amount uint256 The amount of tokens to transfer\n', '     */\n', '    function transfer(string poolId, address to, uint256 amount)\n', '        public\n', '        onlyOwner\n', '        onlyValid(to)\n', '        onlyNotZero(amount)\n', '        onlySufficientAmount(poolId, amount)\n', '        onlyUnlockedPool(poolId)\n', '    {\n', '        pools[poolId].availableAmount = pools[poolId].availableAmount.sub(amount);\n', '        require(token.transfer(to, amount));\n', '\n', '        PoolTransferred(poolId, to, amount);\n', '    }\n', '\n', '    /**\n', '     * @dev Get available amount of tokens in the specified pool\n', '     * @param poolId string The unique pool id\n', '     * @return The available amount of tokens in the specified pool\n', '     */\n', '    function getAvailableAmount(string poolId)\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return pools[poolId].availableAmount;\n', '    }\n', '\n', '    /**\n', '     * @dev Get lock timestamp of the pool or zero\n', '     * @param poolId string The unique pool id\n', '     * @return The lock expiration timestamp of the pool or zero if not specified\n', '     */\n', '    function getLockTimestamp(string poolId)\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return pools[poolId].lockTimestamp;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * https://github.com/OpenZeppelin/zeppelin-solidity\n', ' *\n', ' * The MIT License (MIT)\n', ' * Copyright (c) 2016 Smart Contract Solutions, Inc.\n', ' */\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Mintable token interface\n', ' * @author Wojciech Harzowski (https://github.com/harzo)\n', ' * @author Jakub Stefanski (https://github.com/jstefanski)\n', ' */\n', 'contract MintableToken is ERC20Basic {\n', '    function mint(address to, uint256 amount) public;\n', '}']
