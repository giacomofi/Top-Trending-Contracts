['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title SafeMath\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the\n', '     *      sender account.\n', '     */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        require(newOwner != address(0));\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC223\n', ' */\n', 'contract ERC223 {\n', '    uint public totalSupply;\n', '\n', '    // ERC223 and ERC20 functions and events\n', '    function balanceOf(address who) public view returns (uint);\n', '    function totalSupply() public view returns (uint256 _supply);\n', '    function transfer(address to, uint value) public returns (bool ok);\n', '    function transfer(address to, uint value, bytes data) public returns (bool ok);\n', '    function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);\n', '    event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);\n', '\n', '    // ERC223 functions\n', '    function name() public view returns (string _name);\n', '    function symbol() public view returns (string _symbol);\n', '    function decimals() public view returns (uint8 _decimals);\n', '\n', '    // ERC20 functions and events\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '\n', '/**\n', ' * @title ContractReceiver\n', ' */\n', ' contract ContractReceiver {\n', '\n', '    struct TKN {\n', '        address sender;\n', '        uint value;\n', '        bytes data;\n', '        bytes4 sig;\n', '    }\n', '\n', '    function tokenFallback(address _from, uint _value, bytes _data) public pure {\n', '        TKN memory tkn;\n', '        tkn.sender = _from;\n', '        tkn.value = _value;\n', '        tkn.data = _data;\n', '        uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);\n', '        tkn.sig = bytes4(u);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Fight Money\n', ' */\n', 'contract FIGHTMONEY is ERC223, Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    string public name = "Fight Money";\n', '    string public symbol = "FM";\n', '    uint8 public decimals = 18;\n', '    uint256 public totalSupply = 70e9 * 1e18;\n', '    bool public mintingFinished = false;\n', '    \n', '    mapping(address => uint256) public balanceOf;\n', '    mapping(address => mapping (address => uint256)) public allowance;\n', '    mapping (address => bool) public frozenAccount;\n', '    mapping (address => uint256) public unlockUnixTime;\n', '    \n', '    event FrozenFunds(address indexed target, bool frozen);\n', '    event LockedFunds(address indexed target, uint256 locked);\n', '    event Burn(address indexed from, uint256 amount);\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '\n', '    function FIGHTMONEY() public {\n', '        balanceOf[msg.sender] = totalSupply;\n', '    }\n', '\n', '    function name() public view returns (string _name) {\n', '        return name;\n', '    }\n', '\n', '    function symbol() public view returns (string _symbol) {\n', '        return symbol;\n', '    }\n', '\n', '    function decimals() public view returns (uint8 _decimals) {\n', '        return decimals;\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256 _totalSupply) {\n', '        return totalSupply;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balanceOf[_owner];\n', '    }\n', '\n', '    function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {\n', '        require(targets.length > 0 && targets.length == unixTimes.length);\n', '                \n', '        for(uint j = 0; j < targets.length; j++){\n', '            require(unlockUnixTime[targets[j]] < unixTimes[j]);\n', '            unlockUnixTime[targets[j]] = unixTimes[j];\n', '            LockedFunds(targets[j], unixTimes[j]);\n', '        }\n', '    }\n', '\n', '    function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {\n', '        require(_value > 0\n', '                && frozenAccount[msg.sender] == false \n', '                && frozenAccount[_to] == false\n', '                && now > unlockUnixTime[msg.sender] \n', '                && now > unlockUnixTime[_to]);\n', '\n', '        if (isContract(_to)) {\n', '            require(balanceOf[msg.sender] >= _value);\n', '            balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '            balanceOf[_to] = balanceOf[_to].add(_value);\n', '            assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));\n', '            Transfer(msg.sender, _to, _value, _data);\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else {\n', '            return transferToAddress(_to, _value, _data);\n', '        }\n', '    }\n', '\n', '    function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {\n', '        require(_value > 0\n', '                && frozenAccount[msg.sender] == false \n', '                && frozenAccount[_to] == false\n', '                && now > unlockUnixTime[msg.sender] \n', '                && now > unlockUnixTime[_to]);\n', '\n', '        if (isContract(_to)) {\n', '            return transferToContract(_to, _value, _data);\n', '        } else {\n', '            return transferToAddress(_to, _value, _data);\n', '        }\n', '    }\n', '\n', '    function transfer(address _to, uint _value) public returns (bool success) {\n', '        require(_value > 0\n', '                && frozenAccount[msg.sender] == false \n', '                && frozenAccount[_to] == false\n', '                && now > unlockUnixTime[msg.sender] \n', '                && now > unlockUnixTime[_to]);\n', '\n', '        bytes memory empty;\n', '        if (isContract(_to)) {\n', '            return transferToContract(_to, _value, empty);\n', '        } else {\n', '            return transferToAddress(_to, _value, empty);\n', '        }\n', '    }\n', '\n', '    function isContract(address _addr) private view returns (bool is_contract) {\n', '        uint length;\n', '        assembly {\n', '            length := extcodesize(_addr)\n', '        }\n', '        return (length > 0);\n', '    }\n', '\n', '    function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value, _data);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        ContractReceiver receiver = ContractReceiver(_to);\n', '        receiver.tokenFallback(msg.sender, _value, _data);\n', '        Transfer(msg.sender, _to, _value, _data);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_to != address(0)\n', '                && _value > 0\n', '                && balanceOf[_from] >= _value\n', '                && allowance[_from][msg.sender] >= _value\n', '                && frozenAccount[_from] == false \n', '                && frozenAccount[_to] == false\n', '                && now > unlockUnixTime[_from] \n', '                && now > unlockUnixTime[_to]);\n', '\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowance[_owner][_spender];\n', '    }\n', '\n', '    function burn(address _from, uint256 _unitAmount) onlyOwner public {\n', '        require(_unitAmount > 0\n', '                && balanceOf[_from] >= _unitAmount);\n', '\n', '        balanceOf[_from] = balanceOf[_from].sub(_unitAmount);\n', '        totalSupply = totalSupply.sub(_unitAmount);\n', '        Burn(_from, _unitAmount);\n', '    }\n', '\n', '    modifier canMint() {\n', '        require(!mintingFinished);\n', '        _;\n', '    }\n', '\n', '    function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {\n', '        require(_unitAmount > 0);\n', '        \n', '        totalSupply = totalSupply.add(_unitAmount);\n', '        balanceOf[_to] = balanceOf[_to].add(_unitAmount);\n', '        Mint(_to, _unitAmount);\n', '        Transfer(address(0), _to, _unitAmount);\n', '        return true;\n', '    }\n', '\n', '    function finishMinting() onlyOwner canMint public returns (bool) {\n', '        mintingFinished = true;\n', '        MintFinished();\n', '        return true;\n', '    }\n', '\n', '    function rescueToken(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {\n', '        require(addresses.length > 0 && addresses.length == amounts.length);\n', '\n', '        uint256 totalAmount = 0;\n', '        \n', '        for (uint j = 0; j < addresses.length; j++) {\n', '            require(amounts[j] > 0\n', '                    && addresses[j] != 0x0\n', '                    && frozenAccount[addresses[j]] == false\n', '                    && now > unlockUnixTime[addresses[j]]);\n', '                    \n', '            amounts[j] = amounts[j].mul(1e18);\n', '            require(balanceOf[addresses[j]] >= amounts[j]);\n', '            balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);\n', '            totalAmount = totalAmount.add(amounts[j]);\n', '            Transfer(addresses[j], msg.sender, amounts[j]);\n', '        }\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);\n', '        return true;\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title SafeMath\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the\n', '     *      sender account.\n', '     */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        require(newOwner != address(0));\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC223\n', ' */\n', 'contract ERC223 {\n', '    uint public totalSupply;\n', '\n', '    // ERC223 and ERC20 functions and events\n', '    function balanceOf(address who) public view returns (uint);\n', '    function totalSupply() public view returns (uint256 _supply);\n', '    function transfer(address to, uint value) public returns (bool ok);\n', '    function transfer(address to, uint value, bytes data) public returns (bool ok);\n', '    function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);\n', '    event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);\n', '\n', '    // ERC223 functions\n', '    function name() public view returns (string _name);\n', '    function symbol() public view returns (string _symbol);\n', '    function decimals() public view returns (uint8 _decimals);\n', '\n', '    // ERC20 functions and events\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '\n', '/**\n', ' * @title ContractReceiver\n', ' */\n', ' contract ContractReceiver {\n', '\n', '    struct TKN {\n', '        address sender;\n', '        uint value;\n', '        bytes data;\n', '        bytes4 sig;\n', '    }\n', '\n', '    function tokenFallback(address _from, uint _value, bytes _data) public pure {\n', '        TKN memory tkn;\n', '        tkn.sender = _from;\n', '        tkn.value = _value;\n', '        tkn.data = _data;\n', '        uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);\n', '        tkn.sig = bytes4(u);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Fight Money\n', ' */\n', 'contract FIGHTMONEY is ERC223, Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    string public name = "Fight Money";\n', '    string public symbol = "FM";\n', '    uint8 public decimals = 18;\n', '    uint256 public totalSupply = 70e9 * 1e18;\n', '    bool public mintingFinished = false;\n', '    \n', '    mapping(address => uint256) public balanceOf;\n', '    mapping(address => mapping (address => uint256)) public allowance;\n', '    mapping (address => bool) public frozenAccount;\n', '    mapping (address => uint256) public unlockUnixTime;\n', '    \n', '    event FrozenFunds(address indexed target, bool frozen);\n', '    event LockedFunds(address indexed target, uint256 locked);\n', '    event Burn(address indexed from, uint256 amount);\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '\n', '    function FIGHTMONEY() public {\n', '        balanceOf[msg.sender] = totalSupply;\n', '    }\n', '\n', '    function name() public view returns (string _name) {\n', '        return name;\n', '    }\n', '\n', '    function symbol() public view returns (string _symbol) {\n', '        return symbol;\n', '    }\n', '\n', '    function decimals() public view returns (uint8 _decimals) {\n', '        return decimals;\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256 _totalSupply) {\n', '        return totalSupply;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balanceOf[_owner];\n', '    }\n', '\n', '    function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {\n', '        require(targets.length > 0 && targets.length == unixTimes.length);\n', '                \n', '        for(uint j = 0; j < targets.length; j++){\n', '            require(unlockUnixTime[targets[j]] < unixTimes[j]);\n', '            unlockUnixTime[targets[j]] = unixTimes[j];\n', '            LockedFunds(targets[j], unixTimes[j]);\n', '        }\n', '    }\n', '\n', '    function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {\n', '        require(_value > 0\n', '                && frozenAccount[msg.sender] == false \n', '                && frozenAccount[_to] == false\n', '                && now > unlockUnixTime[msg.sender] \n', '                && now > unlockUnixTime[_to]);\n', '\n', '        if (isContract(_to)) {\n', '            require(balanceOf[msg.sender] >= _value);\n', '            balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '            balanceOf[_to] = balanceOf[_to].add(_value);\n', '            assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));\n', '            Transfer(msg.sender, _to, _value, _data);\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else {\n', '            return transferToAddress(_to, _value, _data);\n', '        }\n', '    }\n', '\n', '    function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {\n', '        require(_value > 0\n', '                && frozenAccount[msg.sender] == false \n', '                && frozenAccount[_to] == false\n', '                && now > unlockUnixTime[msg.sender] \n', '                && now > unlockUnixTime[_to]);\n', '\n', '        if (isContract(_to)) {\n', '            return transferToContract(_to, _value, _data);\n', '        } else {\n', '            return transferToAddress(_to, _value, _data);\n', '        }\n', '    }\n', '\n', '    function transfer(address _to, uint _value) public returns (bool success) {\n', '        require(_value > 0\n', '                && frozenAccount[msg.sender] == false \n', '                && frozenAccount[_to] == false\n', '                && now > unlockUnixTime[msg.sender] \n', '                && now > unlockUnixTime[_to]);\n', '\n', '        bytes memory empty;\n', '        if (isContract(_to)) {\n', '            return transferToContract(_to, _value, empty);\n', '        } else {\n', '            return transferToAddress(_to, _value, empty);\n', '        }\n', '    }\n', '\n', '    function isContract(address _addr) private view returns (bool is_contract) {\n', '        uint length;\n', '        assembly {\n', '            length := extcodesize(_addr)\n', '        }\n', '        return (length > 0);\n', '    }\n', '\n', '    function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value, _data);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        ContractReceiver receiver = ContractReceiver(_to);\n', '        receiver.tokenFallback(msg.sender, _value, _data);\n', '        Transfer(msg.sender, _to, _value, _data);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_to != address(0)\n', '                && _value > 0\n', '                && balanceOf[_from] >= _value\n', '                && allowance[_from][msg.sender] >= _value\n', '                && frozenAccount[_from] == false \n', '                && frozenAccount[_to] == false\n', '                && now > unlockUnixTime[_from] \n', '                && now > unlockUnixTime[_to]);\n', '\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowance[_owner][_spender];\n', '    }\n', '\n', '    function burn(address _from, uint256 _unitAmount) onlyOwner public {\n', '        require(_unitAmount > 0\n', '                && balanceOf[_from] >= _unitAmount);\n', '\n', '        balanceOf[_from] = balanceOf[_from].sub(_unitAmount);\n', '        totalSupply = totalSupply.sub(_unitAmount);\n', '        Burn(_from, _unitAmount);\n', '    }\n', '\n', '    modifier canMint() {\n', '        require(!mintingFinished);\n', '        _;\n', '    }\n', '\n', '    function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {\n', '        require(_unitAmount > 0);\n', '        \n', '        totalSupply = totalSupply.add(_unitAmount);\n', '        balanceOf[_to] = balanceOf[_to].add(_unitAmount);\n', '        Mint(_to, _unitAmount);\n', '        Transfer(address(0), _to, _unitAmount);\n', '        return true;\n', '    }\n', '\n', '    function finishMinting() onlyOwner canMint public returns (bool) {\n', '        mintingFinished = true;\n', '        MintFinished();\n', '        return true;\n', '    }\n', '\n', '    function rescueToken(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {\n', '        require(addresses.length > 0 && addresses.length == amounts.length);\n', '\n', '        uint256 totalAmount = 0;\n', '        \n', '        for (uint j = 0; j < addresses.length; j++) {\n', '            require(amounts[j] > 0\n', '                    && addresses[j] != 0x0\n', '                    && frozenAccount[addresses[j]] == false\n', '                    && now > unlockUnixTime[addresses[j]]);\n', '                    \n', '            amounts[j] = amounts[j].mul(1e18);\n', '            require(balanceOf[addresses[j]] >= amounts[j]);\n', '            balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);\n', '            totalAmount = totalAmount.add(amounts[j]);\n', '            Transfer(addresses[j], msg.sender, amounts[j]);\n', '        }\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);\n', '        return true;\n', '    }\n', '}']
