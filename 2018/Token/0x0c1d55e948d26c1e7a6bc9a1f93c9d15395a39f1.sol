['pragma solidity ^0.4.24;\n', '\n', '/*      _____    ______    ________ \n', ' *     /     |  /      \\  /        |\n', ' *     $$$$$ | /$$$$$$  | $$$$$$$$/ \n', ' *        $$ | $$ |  $$/     $$ |  \n', ' *   __   $$ | $$ |          $$ |  \n', ' *  /  |  $$ | $$ |   __     $$ |  \n', ' *  $$ \\__$$ | $$ \\__/  |    $$ |\n', ' *  $$    $$/  $$    $$/     $$ |\n', ' *   $$$$$$/    $$$$$$/      $$/ \n', ' */\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization\n', ' *      control functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '    address public collector;\n', '    address public distributor;\n', '    address public freezer;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    event CollectorshipTransferred(address indexed previousCollector, address indexed newCollector);\n', '    event DistributorshipTransferred(address indexed previousDistributor, address indexed newDistributor);\n', '    event FreezershipTransferred(address indexed previousFreezer, address indexed newFreezer);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner`, `collector`, `distributor` and `freezer` of the contract to the\n', '     *      sender account.\n', '     */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '        collector = msg.sender;\n', '        distributor = msg.sender;\n', '        freezer = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the collector.\n', '     */\n', '    modifier onlyCollector() {\n', '        require(msg.sender == collector);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the distributor.\n', '     */\n', '    modifier onlyDistributor() {\n', '        require(msg.sender == distributor);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the freezer.\n', '     */\n', '    modifier onlyFreezer() {\n', '        require(msg.sender == freezer);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        require(isNonZeroAccount(newOwner));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current collector to transfer control of the contract to a newCollector.\n', '     * @param newCollector The address to transfer collectorship to.\n', '     */\n', '    function transferCollectorship(address newCollector) onlyOwner public {\n', '        require(isNonZeroAccount(newCollector));\n', '        emit CollectorshipTransferred(collector, newCollector);\n', '        collector = newCollector;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current distributor to transfer control of the contract to a newDistributor.\n', '     * @param newDistributor The address to transfer distributorship to.\n', '     */\n', '    function transferDistributorship(address newDistributor) onlyOwner public {\n', '        require(isNonZeroAccount(newDistributor));\n', '        emit DistributorshipTransferred(distributor, newDistributor);\n', '        distributor = newDistributor;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current freezer to transfer control of the contract to a newFreezer.\n', '     * @param newFreezer The address to transfer freezership to.\n', '     */\n', '    function transferFreezership(address newFreezer) onlyOwner public {\n', '        require(isNonZeroAccount(newFreezer));\n', '        emit FreezershipTransferred(freezer, newFreezer);\n', '        freezer = newFreezer;\n', '    }\n', '\n', '    // check if the given account is valid\n', '    function isNonZeroAccount(address _addr) internal pure returns (bool is_nonzero_account) {\n', '        return _addr != address(0);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20\n', ' * @dev ERC20 contract interface\n', ' */\n', 'contract ERC20 {\n', '    uint public totalSupply;\n', '\n', '    function balanceOf(address who) public view returns (uint);\n', '    function totalSupply() public view returns (uint256 _supply);\n', '    function transfer(address to, uint value) public returns (bool ok);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '    function name() public view returns (string _name);\n', '    function symbol() public view returns (string _symbol);\n', '    function decimals() public view returns (uint8 _decimals);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '\n', '/**\n', ' * @title JCT\n', ' * @author Daisuke Hirata & Noriyuki Izawa\n', ' * @dev JCT is an ERC20 Token. First envisioned by NANJCOIN\n', ' */\n', 'contract JCT is ERC20, Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    string public name = "JCT";\n', '    string public symbol = "JCT";\n', '    uint8 public decimals = 8;\n', '    uint256 public totalSupply = 17e7 * 1e8;\n', '\n', '    mapping(address => uint256) public balanceOf;\n', '    mapping(address => mapping (address => uint256)) public allowance;\n', '    mapping (address => bool) public frozenAccount;\n', '    mapping (address => uint256) public unlockUnixTime;\n', '\n', '    event FrozenFunds(address indexed target, bool frozen);\n', '    event LockedFunds(address indexed target, uint256 locked);\n', '\n', '    /**\n', '     * @dev Constructor is called only once and can not be called again\n', '     */\n', '    constructor(address founder) public {\n', '        owner = founder;\n', '        collector = founder;\n', '        distributor = founder;\n', '        freezer = founder;\n', '\n', '        balanceOf[founder] = totalSupply;\n', '    }\n', '\n', '    function name() public view returns (string _name) {\n', '        return name;\n', '    }\n', '\n', '    function symbol() public view returns (string _symbol) {\n', '        return symbol;\n', '    }\n', '\n', '    function decimals() public view returns (uint8 _decimals) {\n', '        return decimals;\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256 _totalSupply) {\n', '        return totalSupply;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balanceOf[_owner];\n', '    }\n', '\n', '    /**\n', '     * @dev Prevent targets from sending or receiving tokens\n', '     * @param targets Addresses to be frozen\n', '     * @param isFrozen either to freeze it or not\n', '     */\n', '    function freezeAccounts(address[] targets, bool isFrozen) onlyFreezer public {\n', '        require(targets.length > 0);\n', '\n', '        for (uint j = 0; j < targets.length; j++) {\n', '            require(isNonZeroAccount(targets[j]));\n', '            frozenAccount[targets[j]] = isFrozen;\n', '            emit FrozenFunds(targets[j], isFrozen);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Prevent targets from sending or receiving tokens by setting Unix times\n', '     * @param targets Addresses to be locked funds\n', '     * @param unixTimes Unix times when locking up will be finished\n', '     */\n', '    function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {\n', '        require(hasSameArrayLength(targets, unixTimes));\n', '\n', '        for(uint j = 0; j < targets.length; j++){\n', '            require(unlockUnixTime[targets[j]] < unixTimes[j]);\n', '            unlockUnixTime[targets[j]] = unixTimes[j];\n', '            emit LockedFunds(targets[j], unixTimes[j]);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Standard function transfer with no _data\n', '     */\n', '    function transfer(address _to, uint _value) public returns (bool success) {\n', '        require(hasEnoughBalance(msg.sender, _value)\n', '                && isAvailableAccount(msg.sender)\n', '                && isAvailableAccount(_to));\n', '\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(isNonZeroAccount(_to)\n', '                && hasEnoughBalance(_from, _value)\n', '                && allowance[_from][msg.sender] >= _value\n', '                && isAvailableAccount(_from)\n', '                && isAvailableAccount(_to));\n', '\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows _spender to spend no more than _value tokens in your behalf\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender\n', '     * @param _owner address The address which owns the funds\n', '     * @param _spender address The address which will spend the funds\n', '     */\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowance[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * @dev Function to collect tokens from the list of addresses\n', '     */\n', '    function collectTokens(address[] addresses, uint[] amounts) onlyCollector public returns (bool) {\n', '        require(hasSameArrayLength(addresses, amounts));\n', '\n', '        uint256 totalAmount = 0;\n', '\n', '        for (uint j = 0; j < addresses.length; j++) {\n', '            require(amounts[j] > 0\n', '                    && isNonZeroAccount(addresses[j])\n', '                    && isAvailableAccount(addresses[j]));\n', '\n', '            require(hasEnoughBalance(addresses[j], amounts[j]));\n', '            balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);\n', '            totalAmount = totalAmount.add(amounts[j]);\n', '            emit Transfer(addresses[j], msg.sender, amounts[j]);\n', '        }\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to distribute tokens to the list of addresses\n', '     */\n', '    function distributeTokens(address[] addresses, uint[] amounts) onlyDistributor public returns (bool) {\n', '        require(hasSameArrayLength(addresses, amounts)\n', '                && isAvailableAccount(msg.sender));\n', '\n', '        uint256 totalAmount = 0;\n', '\n', '        for(uint j = 0; j < addresses.length; j++){\n', '            require(amounts[j] > 0\n', '                    && isNonZeroAccount(addresses[j])\n', '                    && isAvailableAccount(addresses[j]));\n', '\n', '            totalAmount = totalAmount.add(amounts[j]);\n', '        }\n', '        require(hasEnoughBalance(msg.sender, totalAmount));\n', '\n', '        for (j = 0; j < addresses.length; j++) {\n', '            balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);\n', '            emit Transfer(msg.sender, addresses[j], amounts[j]);\n', '        }\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);\n', '        return true;\n', '    }\n', '\n', '    // check if the given account is available\n', '    function isAvailableAccount(address _addr) private view returns (bool is_valid_account) {\n', '        return isUnLockedAccount(_addr) && isUnfrozenAccount(_addr);\n', '    }\n', '\n', '    // check if the given account is not locked up\n', '    function isUnLockedAccount(address _addr) private view returns (bool is_unlocked_account) {\n', '        return now > unlockUnixTime[_addr];\n', '    }\n', '\n', '    // check if the given account is not frozen\n', '    function isUnfrozenAccount(address _addr) private view returns (bool is_unfrozen_account) {\n', '        return frozenAccount[_addr] == false;\n', '    }\n', '\n', '    // check if the given account has enough balance more than given amount\n', '    function hasEnoughBalance(address _addr, uint256 _value) private view returns (bool has_enough_balance) {\n', '        return _value > 0 && balanceOf[_addr] >= _value;\n', '    }\n', '\n', '    // check if the given account is not frozen\n', '    function hasSameArrayLength(address[] addresses, uint[] amounts) private pure returns (bool has_same_array_length) {\n', '        return addresses.length > 0 && addresses.length == amounts.length;\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '/*      _____    ______    ________ \n', ' *     /     |  /      \\  /        |\n', ' *     $$$$$ | /$$$$$$  | $$$$$$$$/ \n', ' *        $$ | $$ |  $$/     $$ |  \n', ' *   __   $$ | $$ |          $$ |  \n', ' *  /  |  $$ | $$ |   __     $$ |  \n', ' *  $$ \\__$$ | $$ \\__/  |    $$ |\n', ' *  $$    $$/  $$    $$/     $$ |\n', ' *   $$$$$$/    $$$$$$/      $$/ \n', ' */\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization\n', ' *      control functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '    address public collector;\n', '    address public distributor;\n', '    address public freezer;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    event CollectorshipTransferred(address indexed previousCollector, address indexed newCollector);\n', '    event DistributorshipTransferred(address indexed previousDistributor, address indexed newDistributor);\n', '    event FreezershipTransferred(address indexed previousFreezer, address indexed newFreezer);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner`, `collector`, `distributor` and `freezer` of the contract to the\n', '     *      sender account.\n', '     */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '        collector = msg.sender;\n', '        distributor = msg.sender;\n', '        freezer = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the collector.\n', '     */\n', '    modifier onlyCollector() {\n', '        require(msg.sender == collector);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the distributor.\n', '     */\n', '    modifier onlyDistributor() {\n', '        require(msg.sender == distributor);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the freezer.\n', '     */\n', '    modifier onlyFreezer() {\n', '        require(msg.sender == freezer);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        require(isNonZeroAccount(newOwner));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current collector to transfer control of the contract to a newCollector.\n', '     * @param newCollector The address to transfer collectorship to.\n', '     */\n', '    function transferCollectorship(address newCollector) onlyOwner public {\n', '        require(isNonZeroAccount(newCollector));\n', '        emit CollectorshipTransferred(collector, newCollector);\n', '        collector = newCollector;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current distributor to transfer control of the contract to a newDistributor.\n', '     * @param newDistributor The address to transfer distributorship to.\n', '     */\n', '    function transferDistributorship(address newDistributor) onlyOwner public {\n', '        require(isNonZeroAccount(newDistributor));\n', '        emit DistributorshipTransferred(distributor, newDistributor);\n', '        distributor = newDistributor;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current freezer to transfer control of the contract to a newFreezer.\n', '     * @param newFreezer The address to transfer freezership to.\n', '     */\n', '    function transferFreezership(address newFreezer) onlyOwner public {\n', '        require(isNonZeroAccount(newFreezer));\n', '        emit FreezershipTransferred(freezer, newFreezer);\n', '        freezer = newFreezer;\n', '    }\n', '\n', '    // check if the given account is valid\n', '    function isNonZeroAccount(address _addr) internal pure returns (bool is_nonzero_account) {\n', '        return _addr != address(0);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20\n', ' * @dev ERC20 contract interface\n', ' */\n', 'contract ERC20 {\n', '    uint public totalSupply;\n', '\n', '    function balanceOf(address who) public view returns (uint);\n', '    function totalSupply() public view returns (uint256 _supply);\n', '    function transfer(address to, uint value) public returns (bool ok);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '    function name() public view returns (string _name);\n', '    function symbol() public view returns (string _symbol);\n', '    function decimals() public view returns (uint8 _decimals);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '\n', '/**\n', ' * @title JCT\n', ' * @author Daisuke Hirata & Noriyuki Izawa\n', ' * @dev JCT is an ERC20 Token. First envisioned by NANJCOIN\n', ' */\n', 'contract JCT is ERC20, Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    string public name = "JCT";\n', '    string public symbol = "JCT";\n', '    uint8 public decimals = 8;\n', '    uint256 public totalSupply = 17e7 * 1e8;\n', '\n', '    mapping(address => uint256) public balanceOf;\n', '    mapping(address => mapping (address => uint256)) public allowance;\n', '    mapping (address => bool) public frozenAccount;\n', '    mapping (address => uint256) public unlockUnixTime;\n', '\n', '    event FrozenFunds(address indexed target, bool frozen);\n', '    event LockedFunds(address indexed target, uint256 locked);\n', '\n', '    /**\n', '     * @dev Constructor is called only once and can not be called again\n', '     */\n', '    constructor(address founder) public {\n', '        owner = founder;\n', '        collector = founder;\n', '        distributor = founder;\n', '        freezer = founder;\n', '\n', '        balanceOf[founder] = totalSupply;\n', '    }\n', '\n', '    function name() public view returns (string _name) {\n', '        return name;\n', '    }\n', '\n', '    function symbol() public view returns (string _symbol) {\n', '        return symbol;\n', '    }\n', '\n', '    function decimals() public view returns (uint8 _decimals) {\n', '        return decimals;\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256 _totalSupply) {\n', '        return totalSupply;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balanceOf[_owner];\n', '    }\n', '\n', '    /**\n', '     * @dev Prevent targets from sending or receiving tokens\n', '     * @param targets Addresses to be frozen\n', '     * @param isFrozen either to freeze it or not\n', '     */\n', '    function freezeAccounts(address[] targets, bool isFrozen) onlyFreezer public {\n', '        require(targets.length > 0);\n', '\n', '        for (uint j = 0; j < targets.length; j++) {\n', '            require(isNonZeroAccount(targets[j]));\n', '            frozenAccount[targets[j]] = isFrozen;\n', '            emit FrozenFunds(targets[j], isFrozen);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Prevent targets from sending or receiving tokens by setting Unix times\n', '     * @param targets Addresses to be locked funds\n', '     * @param unixTimes Unix times when locking up will be finished\n', '     */\n', '    function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {\n', '        require(hasSameArrayLength(targets, unixTimes));\n', '\n', '        for(uint j = 0; j < targets.length; j++){\n', '            require(unlockUnixTime[targets[j]] < unixTimes[j]);\n', '            unlockUnixTime[targets[j]] = unixTimes[j];\n', '            emit LockedFunds(targets[j], unixTimes[j]);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Standard function transfer with no _data\n', '     */\n', '    function transfer(address _to, uint _value) public returns (bool success) {\n', '        require(hasEnoughBalance(msg.sender, _value)\n', '                && isAvailableAccount(msg.sender)\n', '                && isAvailableAccount(_to));\n', '\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(isNonZeroAccount(_to)\n', '                && hasEnoughBalance(_from, _value)\n', '                && allowance[_from][msg.sender] >= _value\n', '                && isAvailableAccount(_from)\n', '                && isAvailableAccount(_to));\n', '\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows _spender to spend no more than _value tokens in your behalf\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender\n', '     * @param _owner address The address which owns the funds\n', '     * @param _spender address The address which will spend the funds\n', '     */\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowance[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * @dev Function to collect tokens from the list of addresses\n', '     */\n', '    function collectTokens(address[] addresses, uint[] amounts) onlyCollector public returns (bool) {\n', '        require(hasSameArrayLength(addresses, amounts));\n', '\n', '        uint256 totalAmount = 0;\n', '\n', '        for (uint j = 0; j < addresses.length; j++) {\n', '            require(amounts[j] > 0\n', '                    && isNonZeroAccount(addresses[j])\n', '                    && isAvailableAccount(addresses[j]));\n', '\n', '            require(hasEnoughBalance(addresses[j], amounts[j]));\n', '            balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);\n', '            totalAmount = totalAmount.add(amounts[j]);\n', '            emit Transfer(addresses[j], msg.sender, amounts[j]);\n', '        }\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to distribute tokens to the list of addresses\n', '     */\n', '    function distributeTokens(address[] addresses, uint[] amounts) onlyDistributor public returns (bool) {\n', '        require(hasSameArrayLength(addresses, amounts)\n', '                && isAvailableAccount(msg.sender));\n', '\n', '        uint256 totalAmount = 0;\n', '\n', '        for(uint j = 0; j < addresses.length; j++){\n', '            require(amounts[j] > 0\n', '                    && isNonZeroAccount(addresses[j])\n', '                    && isAvailableAccount(addresses[j]));\n', '\n', '            totalAmount = totalAmount.add(amounts[j]);\n', '        }\n', '        require(hasEnoughBalance(msg.sender, totalAmount));\n', '\n', '        for (j = 0; j < addresses.length; j++) {\n', '            balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);\n', '            emit Transfer(msg.sender, addresses[j], amounts[j]);\n', '        }\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);\n', '        return true;\n', '    }\n', '\n', '    // check if the given account is available\n', '    function isAvailableAccount(address _addr) private view returns (bool is_valid_account) {\n', '        return isUnLockedAccount(_addr) && isUnfrozenAccount(_addr);\n', '    }\n', '\n', '    // check if the given account is not locked up\n', '    function isUnLockedAccount(address _addr) private view returns (bool is_unlocked_account) {\n', '        return now > unlockUnixTime[_addr];\n', '    }\n', '\n', '    // check if the given account is not frozen\n', '    function isUnfrozenAccount(address _addr) private view returns (bool is_unfrozen_account) {\n', '        return frozenAccount[_addr] == false;\n', '    }\n', '\n', '    // check if the given account has enough balance more than given amount\n', '    function hasEnoughBalance(address _addr, uint256 _value) private view returns (bool has_enough_balance) {\n', '        return _value > 0 && balanceOf[_addr] >= _value;\n', '    }\n', '\n', '    // check if the given account is not frozen\n', '    function hasSameArrayLength(address[] addresses, uint[] amounts) private pure returns (bool has_same_array_length) {\n', '        return addresses.length > 0 && addresses.length == amounts.length;\n', '    }\n', '}']
