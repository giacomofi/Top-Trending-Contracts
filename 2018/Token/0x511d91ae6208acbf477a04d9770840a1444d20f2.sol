['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization\n', ' *      control functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the\n', '     *      sender account.\n', '     */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        require(newOwner != address(0));\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * 彡(^)(^)\n', ' * @title ERC223\n', ' * @dev ERC223 contract interface with ERC20 functions and events\n', ' *      Fully backward compatible with ERC20\n', ' *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended\n', ' */\n', 'contract ERC223 {\n', '    uint public totalSupply;\n', '\n', '    // ERC223 and ERC20 functions and events\n', '    function balanceOf(address who) public view returns (uint);\n', '    function totalSupply() public view returns (uint256 _supply);\n', '    function transfer(address to, uint value) public returns (bool ok);\n', '    function transfer(address to, uint value, bytes data) public returns (bool ok);\n', '    function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);\n', '    event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);\n', '\n', '    // ERC223 functions\n', '    function name() public view returns (string _name);\n', '    function symbol() public view returns (string _symbol);\n', '    function decimals() public view returns (uint8 _decimals);\n', '\n', '    // ERC20 functions and events\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title ContractReceiver\n', ' * @dev Contract that is working with ERC223 tokens\n', ' */\n', ' contract ContractReceiver {\n', '\n', '    struct TKN {\n', '        address sender;\n', '        uint value;\n', '        bytes data;\n', '        bytes4 sig;\n', '    }\n', '\n', '    function tokenFallback(address _from, uint _value, bytes _data) public pure {\n', '        TKN memory tkn;\n', '        tkn.sender = _from;\n', '        tkn.value = _value;\n', '        tkn.data = _data;\n', '        uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);\n', '        tkn.sig = bytes4(u);\n', '        \n', '        /*\n', '         * tkn variable is analogue of msg variable of Ether transaction\n', '         * tkn.sender is person who initiated this token transaction   (analogue of msg.sender)\n', '         * tkn.value the number of tokens that were sent   (analogue of msg.value)\n', '         * tkn.data is data of token transaction   (analogue of msg.data)\n', '         * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution\n', '         */\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Visualrockcoin\n', ' * @author Visualrockcoin\n', ' * @dev Visualrockcoin is an ERC223 Token with ERC20 functions and events\n', ' *      Fully backward compatible with ERC20\n', ' */\n', 'contract Visualrockcoin is ERC223, Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    string public name = "Visualrockcoin";\n', '    string public symbol = "VRC";\n', '    string public constant AAcontributors = "Visualrockcoin";\n', '    uint8 public decimals = 8;\n', '    uint256 public totalSupply = 200e9 * 1e8;\n', '    uint256 public distributeAmount = 0;\n', '    bool public mintingFinished = false;\n', '    \n', '    address public founder = 0xD6C42a084A28fDaff78E29Ec5486598A626Cd228;\n', '    address public preSeasonGame = 0xD6C42a084A28fDaff78E29Ec5486598A626Cd228;\n', '    address public activityFunds = 0xD6C42a084A28fDaff78E29Ec5486598A626Cd228;\n', '    address public lockedFundsForthefuture = 0xD6C42a084A28fDaff78E29Ec5486598A626Cd228;\n', '\n', '    mapping(address => uint256) public balanceOf;\n', '    mapping(address => mapping (address => uint256)) public allowance;\n', '    mapping (address => bool) public frozenAccount;\n', '    mapping (address => uint256) public unlockUnixTime;\n', '    \n', '    event FrozenFunds(address indexed target, bool frozen);\n', '    event LockedFunds(address indexed target, uint256 locked);\n', '    event Burn(address indexed from, uint256 amount);\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '\n', '\n', '    /** \n', '     * @dev Constructor is called only once and can not be called again\n', '     */\n', '    function Visualrockcoin() public {\n', '        owner = activityFunds;\n', '        \n', '        balanceOf[founder] = totalSupply.mul(25).div(100);\n', '        balanceOf[preSeasonGame] = totalSupply.mul(55).div(100);\n', '        balanceOf[activityFunds] = totalSupply.mul(10).div(100);\n', '        balanceOf[lockedFundsForthefuture] = totalSupply.mul(10).div(100);\n', '    }\n', '\n', '\n', '    function name() public view returns (string _name) {\n', '        return name;\n', '    }\n', '\n', '    function symbol() public view returns (string _symbol) {\n', '        return symbol;\n', '    }\n', '\n', '    function decimals() public view returns (uint8 _decimals) {\n', '        return decimals;\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256 _totalSupply) {\n', '        return totalSupply;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balanceOf[_owner];\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Prevent targets from sending or receiving tokens\n', '     * @param targets Addresses to be frozen\n', '     * @param isFrozen either to freeze it or not\n', '     */\n', '    function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {\n', '        require(targets.length > 0);\n', '\n', '        for (uint j = 0; j < targets.length; j++) {\n', '            require(targets[j] != 0x0);\n', '            frozenAccount[targets[j]] = isFrozen;\n', '            FrozenFunds(targets[j], isFrozen);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Prevent targets from sending or receiving tokens by setting Unix times\n', '     * @param targets Addresses to be locked funds\n', '     * @param unixTimes Unix times when locking up will be finished\n', '     */\n', '    function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {\n', '        require(targets.length > 0\n', '                && targets.length == unixTimes.length);\n', '                \n', '        for(uint j = 0; j < targets.length; j++){\n', '            require(unlockUnixTime[targets[j]] < unixTimes[j]);\n', '            unlockUnixTime[targets[j]] = unixTimes[j];\n', '            LockedFunds(targets[j], unixTimes[j]);\n', '        }\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Function that is called when a user or another contract wants to transfer funds\n', '     */\n', '    function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {\n', '        require(_value > 0\n', '                && frozenAccount[msg.sender] == false \n', '                && frozenAccount[_to] == false\n', '                && now > unlockUnixTime[msg.sender] \n', '                && now > unlockUnixTime[_to]);\n', '\n', '        if (isContract(_to)) {\n', '            require(balanceOf[msg.sender] >= _value);\n', '            balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '            balanceOf[_to] = balanceOf[_to].add(_value);\n', '            assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));\n', '            Transfer(msg.sender, _to, _value, _data);\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else {\n', '            return transferToAddress(_to, _value, _data);\n', '        }\n', '    }\n', '\n', '    function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {\n', '        require(_value > 0\n', '                && frozenAccount[msg.sender] == false \n', '                && frozenAccount[_to] == false\n', '                && now > unlockUnixTime[msg.sender] \n', '                && now > unlockUnixTime[_to]);\n', '\n', '        if (isContract(_to)) {\n', '            return transferToContract(_to, _value, _data);\n', '        } else {\n', '            return transferToAddress(_to, _value, _data);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Standard function transfer similar to ERC20 transfer with no _data\n', '     *      Added due to backwards compatibility reasons\n', '     */\n', '    function transfer(address _to, uint _value) public returns (bool success) {\n', '        require(_value > 0\n', '                && frozenAccount[msg.sender] == false \n', '                && frozenAccount[_to] == false\n', '                && now > unlockUnixTime[msg.sender] \n', '                && now > unlockUnixTime[_to]);\n', '\n', '        bytes memory empty;\n', '        if (isContract(_to)) {\n', '            return transferToContract(_to, _value, empty);\n', '        } else {\n', '            return transferToAddress(_to, _value, empty);\n', '        }\n', '    }\n', '\n', '    // assemble the given address bytecode. If bytecode exists then the _addr is a contract.\n', '    function isContract(address _addr) private view returns (bool is_contract) {\n', '        uint length;\n', '        assembly {\n', '            //retrieve the size of the code on target address, this needs assembly\n', '            length := extcodesize(_addr)\n', '        }\n', '        return (length > 0);\n', '    }\n', '\n', '    // function that is called when transaction target is an address\n', '    function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value, _data);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    // function that is called when transaction target is a contract\n', '    function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        ContractReceiver receiver = ContractReceiver(_to);\n', '        receiver.tokenFallback(msg.sender, _value, _data);\n', '        Transfer(msg.sender, _to, _value, _data);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     *      Added due to backwards compatibility with ERC20\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_to != address(0)\n', '                && _value > 0\n', '                && balanceOf[_from] >= _value\n', '                && allowance[_from][msg.sender] >= _value\n', '                && frozenAccount[_from] == false \n', '                && frozenAccount[_to] == false\n', '                && now > unlockUnixTime[_from] \n', '                && now > unlockUnixTime[_to]);\n', '\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows _spender to spend no more than _value tokens in your behalf\n', '     *      Added due to backwards compatibility with ERC20\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender\n', '     *      Added due to backwards compatibility with ERC20\n', '     * @param _owner address The address which owns the funds\n', '     * @param _spender address The address which will spend the funds\n', '     */\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowance[_owner][_spender];\n', '    }\n', '\n', '\n', '\n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param _from The address that will burn the tokens.\n', '     * @param _unitAmount The amount of token to be burned.\n', '     */\n', '    function burn(address _from, uint256 _unitAmount) onlyOwner public {\n', '        require(_unitAmount > 0\n', '                && balanceOf[_from] >= _unitAmount);\n', '\n', '        balanceOf[_from] = balanceOf[_from].sub(_unitAmount);\n', '        totalSupply = totalSupply.sub(_unitAmount);\n', '        Burn(_from, _unitAmount);\n', '    }\n', '\n', '\n', '    modifier canMint() {\n', '        require(!mintingFinished);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to mint tokens\n', '     * @param _to The address that will receive the minted tokens.\n', '     * @param _unitAmount The amount of tokens to mint.\n', '     */\n', '    function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {\n', '        require(_unitAmount > 0);\n', '        \n', '        totalSupply = totalSupply.add(_unitAmount);\n', '        balanceOf[_to] = balanceOf[_to].add(_unitAmount);\n', '        Mint(_to, _unitAmount);\n', '        Transfer(address(0), _to, _unitAmount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to stop minting new tokens.\n', '     */\n', '    function finishMinting() onlyOwner canMint public returns (bool) {\n', '        mintingFinished = true;\n', '        MintFinished();\n', '        return true;\n', '    }\n', '\n', '\n', '\n', '    /**\n', '     * @dev Function to distribute tokens to the list of addresses by the provided amount\n', '     */\n', '    function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {\n', '        require(amount > 0 \n', '                && addresses.length > 0\n', '                && frozenAccount[msg.sender] == false\n', '                && now > unlockUnixTime[msg.sender]);\n', '\n', '        amount = amount.mul(1e8);\n', '        uint256 totalAmount = amount.mul(addresses.length);\n', '        require(balanceOf[msg.sender] >= totalAmount);\n', '        \n', '        for (uint j = 0; j < addresses.length; j++) {\n', '            require(addresses[j] != 0x0\n', '                    && frozenAccount[addresses[j]] == false\n', '                    && now > unlockUnixTime[addresses[j]]);\n', '\n', '            balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);\n', '            Transfer(msg.sender, addresses[j], amount);\n', '        }\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);\n', '        return true;\n', '    }\n', '\n', '    function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {\n', '        require(addresses.length > 0\n', '                && addresses.length == amounts.length\n', '                && frozenAccount[msg.sender] == false\n', '                && now > unlockUnixTime[msg.sender]);\n', '                \n', '        uint256 totalAmount = 0;\n', '        \n', '        for(uint j = 0; j < addresses.length; j++){\n', '            require(amounts[j] > 0\n', '                    && addresses[j] != 0x0\n', '                    && frozenAccount[addresses[j]] == false\n', '                    && now > unlockUnixTime[addresses[j]]);\n', '                    \n', '            amounts[j] = amounts[j].mul(1e8);\n', '            totalAmount = totalAmount.add(amounts[j]);\n', '        }\n', '        require(balanceOf[msg.sender] >= totalAmount);\n', '        \n', '        for (j = 0; j < addresses.length; j++) {\n', '            balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);\n', '            Transfer(msg.sender, addresses[j], amounts[j]);\n', '        }\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to collect tokens from the list of addresses\n', '     */\n', '    function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {\n', '        require(addresses.length > 0\n', '                && addresses.length == amounts.length);\n', '\n', '        uint256 totalAmount = 0;\n', '        \n', '        for (uint j = 0; j < addresses.length; j++) {\n', '            require(amounts[j] > 0\n', '                    && addresses[j] != 0x0\n', '                    && frozenAccount[addresses[j]] == false\n', '                    && now > unlockUnixTime[addresses[j]]);\n', '                    \n', '            amounts[j] = amounts[j].mul(1e8);\n', '            require(balanceOf[addresses[j]] >= amounts[j]);\n', '            balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);\n', '            totalAmount = totalAmount.add(amounts[j]);\n', '            Transfer(addresses[j], msg.sender, amounts[j]);\n', '        }\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);\n', '        return true;\n', '    }\n', '\n', '\n', '    function setDistributeAmount(uint256 _unitAmount) onlyOwner public {\n', '        distributeAmount = _unitAmount;\n', '    }\n', '    \n', '    /**\n', '     * @dev Function to distribute tokens to the msg.sender automatically\n', '     *      If distributeAmount is 0, this function doesn&#39;t work\n', '     */\n', '    function autoDistribute() payable public {\n', '        require(distributeAmount > 0\n', '                && balanceOf[owner] >= distributeAmount\n', '                && frozenAccount[msg.sender] == false\n', '                && now > unlockUnixTime[msg.sender]);\n', '        if(msg.value > 0) owner.transfer(msg.value);\n', '        \n', '        balanceOf[owner] = balanceOf[owner].sub(distributeAmount);\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);\n', '        Transfer(owner, msg.sender, distributeAmount);\n', '    }\n', '\n', '    /**\n', '     * @dev fallback function\n', '     */\n', '    function() payable public {\n', '        autoDistribute();\n', '     }\n', '\n', '}']