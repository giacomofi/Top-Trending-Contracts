['pragma solidity ^0.4.21;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', '\n', 'library SafeMath {\n', '\tfunction mul(uint256 x, uint256 y) internal pure returns (uint256) {\n', '\t\tif (x == 0) {\n', '\t\t\treturn 0;\n', '\t\t}\n', '\t\tuint256 z = x * y;\n', '\t\tassert(z / x == y);\n', '\t\treturn z;\n', '\t}\n', '\t\n', '\tfunction div(uint256 x, uint256 y) internal pure returns (uint256) {\n', '\t    // assert(y > 0);//Solidity automatically throws when dividing by 0 \n', '\t    uint256 z = x / y;\n', '\t    // assert(x == y * z + x % y); // There is no case in which this doesn`t hold\n', '\t    return z;\n', '\t}\n', '\t\n', '\tfunction sub(uint256 x, uint256 y) internal pure returns (uint256) {\n', '\t    assert(y <= x);\n', '\t    return x - y;\n', '\t}\n', '\t\n', '\tfunction add(uint256 x, uint256 y) internal pure returns (uint256) {\n', '\t    uint256 z = x + y;\n', '\t    assert(z >= x);\n', '\t    return z;\n', '\t}\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization\n', ' *      control function,this simplifies the implementation of "user permissions".\n', ' */\n', ' \n', ' contract Ownable {\n', '     address public owner;\n', '     \n', '     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '     \n', '     /**\n', '      * \n', '      * @dev The Ownable constructor sets the original &#39;owner&#39; of the contract to the\n', '      *         sender account.\n', '      */\n', '      \n', '     function Ownable() public {\n', '         owner = msg.sender;\n', ' }\n', ' \n', ' /**\n', '  * @dev Throws if called by any account other than the owner.\n', '  */\n', '  \n', ' modifier onlyOwner() {\n', '     require(msg.sender == owner);\n', '     _;\n', ' }\n', ' \n', ' /**\n', '  * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '  * @param newOwner The address to transfer ownership to.\n', '  */\n', '  \n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '      require(newOwner !=address(0));\n', '      emit OwnershipTransferred(owner, newOwner);\n', '      owner = newOwner;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ContractReceiver\n', ' * @dev Receiver for ERC223 tokens\n', ' */\n', ' \n', 'contract ContractReceiver {\n', '    \n', '    struct TKN {\n', '        address sender;\n', '        uint value;\n', '        bytes data;\n', '        bytes4 sig;\n', '    }\n', '    function tokenFallback(address _from, uint _value, bytes _data) public pure {\n', '        TKN memory tkn;\n', '        tkn.sender = _from;\n', '        tkn.value = _value;\n', '        tkn.data = _data;\n', '        uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) <<16) + (uint32(_data[0]) << 24);\n', '        tkn.sig = bytes4(u);\n', '        \n', '        /*\n', '         *tkn variable is analogue of msg variable of Ether transaction\n', '         *tkn.sender is person who initiated this token transaction (analogue of msg.sender)\n', '         *tkn.value the number of tokens that were sent (analogue of msg.value)\n', '         *tkn.data is data of token transaction (analogue of msg.data)\n', '         *tkn.sig is 4 bytes signature of function\n', '         *if data of token transaction is a function execution\n', '         */\n', '         \n', '    }\n', '}\n', '\n', 'contract ERC223 {\n', '    uint public totalSupply;\n', '    function name() public view returns (string _name);\n', '    function symbol() public view returns (string _symbol);\n', '    function decimals() public view returns (uint8 _decimals);\n', '    function totalSupply() public view returns (uint256 _supply);\n', '    function balanceOf(address who) public view returns (uint);\n', '\n', '    function transfer(address to, uint value) public returns (bool ok);\n', '    function transfer(address to, uint value, bytes data) public returns (bool ok);\n', '    function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '}\n', '\n', '/**\n', ' * Wishing for circulation of QSHUCOIN!\n', ' * I wish for prosperity for a long time!\n', ' * Flapping from Kyusyu to the world!\n', ' * We will work with integrity and sincerity!\n', ' * ARIGATOH!\n', ' */\n', '\n', 'contract QSHU is ERC223, Ownable {\n', '    using SafeMath for uint256;\n', '    \n', '    string public name = "QSHUCOIN";\n', '    string public symbol = "QSHU";\n', '    uint8 public decimals = 8;\n', '    uint256 public initialSupply = 50e9 * 1e8;\n', '    uint256 public totalSupply;\n', '    uint256 public distributeAmount = 0;\n', '    bool public mintingFinished = false;\n', '    \n', '    mapping (address => uint) balances;\n', '    mapping (address => bool) public frozenAccount;\n', '    mapping (address => uint256) public unlockUnixTime;\n', '    \n', '    event FrozenFunds(address indexed target, bool frozen);\n', '    event LockedFunds(address indexed target, uint256 locked);\n', '    event Burn(address indexed burner, uint256 value);\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '    \n', '    function QSHU() public {\n', '        totalSupply = initialSupply;\n', '        balances[msg.sender] = totalSupply;\n', '    }\n', '    \n', '    function name() public view returns (string _name) {\n', '        return name;\n', '    }\n', '    function symbol() public view returns (string _symbol) {\n', '        return symbol;\n', '    }\n', '    function decimals() public view returns (uint8 _decimals) {\n', '        return decimals;\n', '    }\n', '    function totalSupply() public view returns (uint256 _totalSupply) {\n', '        return totalSupply;\n', '    }\n', '    function balanceOf(address _owner) public view returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '    \n', '    modifier onlyPayloadSize(uint256 size){\n', '        assert(msg.data.length >= size + 4);\n', '        _;\n', '    }\n', '    \n', '    function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {\n', '        require(_value > 0\n', '            && frozenAccount[msg.sender] == false\n', '            && frozenAccount[_to] == false\n', '            && now > unlockUnixTime[msg.sender]\n', '            && now > unlockUnixTime[_to]);\n', '        \n', '        if(isContract(_to)) {\n', '            if (balanceOf(msg.sender) < _value) revert();\n', '            balances[msg.sender] = SafeMath.sub(balanceOf(msg.sender), _value);\n', '            balances[_to] = SafeMath.add(balanceOf(_to), _value);\n', '            assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));\n', '            emit Transfer(msg.sender, _to, _value, _data);\n', '            emit Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        }\n', '        else {\n', '            return transferToAddress(_to, _value, _data);\n', '        }\n', '    }\n', '    \n', '    function transfer(address _to, uint _value, bytes _data) public returns (bool success) {\n', '        require(_value > 0\n', '            && frozenAccount[msg.sender] == false\n', '            && frozenAccount[_to] == false\n', '            && now > unlockUnixTime[msg.sender]\n', '            && now > unlockUnixTime[_to]);\n', '\n', '        if(isContract(_to)) {\n', '            return transferToContract(_to, _value, _data);\n', '        }\n', '        else {\n', '            return transferToAddress(_to, _value, _data);\n', '        }\n', '    }\n', '    \n', '    function transfer(address _to, uint _value) public returns (bool success) {\n', '        require(_value > 0\n', '            && frozenAccount[msg.sender] == false\n', '            && frozenAccount[_to] == false\n', '            && now > unlockUnixTime[msg.sender]\n', '            && now > unlockUnixTime[_to]);\n', '    bytes memory empty;\n', '    if(isContract(_to)) {\n', '        return transferToContract(_to, _value, empty);\n', '    }\n', '    else {\n', '        return transferToAddress(_to, _value, empty);\n', '        }\n', '    }\n', '    \n', '    function isContract(address _addr) private view returns (bool is_contract) {\n', '        uint length;\n', '        assembly {\n', '            length := extcodesize(_addr)\n', '        }\n', '        return (length > 0);\n', '    }\n', '    \n', '    function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {\n', '        if (balanceOf(msg.sender) < _value) revert();\n', '        balances[msg.sender] = SafeMath.sub(balanceOf(msg.sender), _value);\n', '        balances[_to] = SafeMath.add(balanceOf(_to), _value);\n', '        emit Transfer(msg.sender, _to, _value, _data);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {\n', '        if (balanceOf(msg.sender) < _value) revert();\n', '        balances[msg.sender] = SafeMath.sub(balanceOf(msg.sender), _value);\n', '        balances[_to] = SafeMath.add(balanceOf(_to), _value);\n', '        ContractReceiver receiver = ContractReceiver(_to);\n', '        receiver.tokenFallback(msg.sender, _value, _data);\n', '        emit Transfer(msg.sender, _to, _value, _data);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '/**\n', ' * @dev Prevent targets from sending or receiving tokens\n', ' * @param targets Addresses to be frozen\n', ' * @param isFrozen either to freeze it or not\n', ' */\n', '\n', '    function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {\n', '        require(targets.length > 0);\n', '\n', '        for (uint q = 0; q < targets.length; q++) {\n', '            require(targets[q] != 0x0);\n', '            frozenAccount[targets[q]] = isFrozen;\n', '            emit FrozenFunds(targets[q], isFrozen);\n', '        }\n', '    }\n', '    \n', '/**\n', ' * @dev Prevent targets from sending or receiving tokens by setting Unix times \n', ' * @param targets Addresses to be locked funds \n', ' * @param unixTimes Unix times when locking up will be finished \n', ' */\n', ' \n', '    function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {\n', '        require(targets.length > 0 \n', '            && targets.length == unixTimes.length);\n', '            \n', '        for(uint q = 0; q < targets.length; q++){\n', '            require(unlockUnixTime[targets[q]] < unixTimes[q]);\n', '            unlockUnixTime[targets[q]] = unixTimes[q];\n', '            emit LockedFunds(targets[q], unixTimes[q]);\n', '        }\n', '    }\n', '\n', '/**\n', ' * @dev Burns a specific amount of tokens.\n', ' * @param _from The address that will burn the tokens.\n', ' * @param _unitAmount The amount of token to be burned.\n', ' */\n', ' \n', '    function burn(address _from, uint256 _unitAmount) onlyOwner public {\n', '        require(_unitAmount > 0\n', '            && balanceOf(_from) >= _unitAmount);\n', '        \n', '        balances[_from] = SafeMath.sub(balances[_from], _unitAmount);\n', '        totalSupply = SafeMath.sub(totalSupply, _unitAmount);\n', '        emit Burn(_from, _unitAmount);\n', '    }\n', '    \n', '    modifier canMint() {\n', '        require(!mintingFinished);\n', '        _;\n', '    }\n', '    \n', '/**\n', ' * @dev Function to mint tokens\n', ' * @param _to The address that will receive the minted tokens.\n', ' * @param _unitAmount The amount of tokens to mint.\n', ' */\n', ' \n', '    function mint (address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {\n', '        require(_unitAmount > 0);\n', '        \n', '        totalSupply = SafeMath.add(totalSupply, _unitAmount);\n', '        balances[_to] = SafeMath.add(balances[_to], _unitAmount);\n', '        emit Mint(_to, _unitAmount);\n', '        emit Transfer(address(0), _to, _unitAmount);\n', '        return true;\n', '    }\n', '\n', '\n', '/**\n', ' * dev Function to stop minting new tokens.\n', ' */\n', ' \n', '    function finishMinting() onlyOwner canMint public returns (bool) {\n', '        mintingFinished = true;\n', '        emit MintFinished();\n', '        return true;\n', '    }\n', '    \n', '/**\n', ' * @dev Function to distribute tokens to the list of addresses by the provided amount\n', ' */\n', ' \n', '\n', '    function distributeTokens(address[] addresses, uint256 amount) public returns (bool) {\n', '        require(amount > 0\n', '            && addresses.length > 0\n', '            && frozenAccount[msg.sender] == false\n', '            && now > unlockUnixTime[msg.sender]);\n', '        \n', '        amount = SafeMath.mul(amount,1e8);\n', '        uint256 totalAmount = SafeMath.mul(amount, addresses.length);\n', '        require(balances[msg.sender] >= totalAmount);\n', '        \n', '        for (uint q = 0; q < addresses.length; q++) {\n', '            require(addresses[q] != 0x0\n', '                && frozenAccount[addresses[q]] == false\n', '                && now > unlockUnixTime[addresses[q]]);\n', '            \n', '            balances[addresses[q]] = SafeMath.add(balances[addresses[q]], amount);\n', '            emit Transfer(msg.sender, addresses[q], amount);\n', '        }\n', '        balances[msg.sender] = SafeMath.sub(balances[msg.sender],totalAmount);\n', '        return true;\n', '    }\n', '    \n', '/**\n', ' * @dev Function to collect tokens from the list of addresses\n', ' */\n', '\n', '    function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {\n', '        require(addresses.length > 0\n', '                && addresses.length == amounts.length);\n', '        \n', '        uint256 totalAmount = 0;\n', '        \n', '        for (uint q = 0; q < addresses.length; q++) {\n', '            require(amounts[q] > 0\n', '                    && addresses[q] != 0x0\n', '                    && frozenAccount[addresses[q]] == false\n', '                    && now > unlockUnixTime[addresses[q]]);\n', '            \n', '            amounts[q] = SafeMath.mul(amounts[q], 1e8);\n', '            require(balances[addresses[q]] >= amounts[q]);\n', '            balances[addresses[q]] = SafeMath.sub(balances[addresses[q]], amounts[q]);\n', '            totalAmount = SafeMath.add(totalAmount, amounts[q]);\n', '            emit Transfer(addresses[q], msg.sender, amounts[q]);\n', '        }\n', '        balances[msg.sender] = SafeMath.add(balances[msg.sender], totalAmount);\n', '        return true;\n', '    }\n', '    function setDistributeAmount(uint256 _unitAmount) onlyOwner public {\n', '        distributeAmount = _unitAmount;\n', '    }\n', '    \n', '/**\n', ' * @dev Function to distribute tokens to the msg.sender automatically\n', ' * If distributeAmount is 0 , this function doesn&#39;t work&#39;\n', ' */\n', ' \n', '    function autoDistribute() payable public {\n', '        require(distributeAmount > 0\n', '                && balanceOf(owner) >= distributeAmount\n', '                && frozenAccount[msg.sender] == false\n', '                && now > unlockUnixTime[msg.sender]);\n', '        if (msg.value > 0) owner.transfer(msg.value);\n', '        \n', '        balances[owner] = SafeMath.sub(balances[owner], distributeAmount);\n', '        balances[msg.sender] = SafeMath.add(balances[msg.sender], distributeAmount);\n', '        emit Transfer(owner, msg.sender, distributeAmount);\n', '    }\n', '    \n', '/**\n', ' * @dev token fallback function\n', ' */\n', ' \n', '    function() payable public {\n', '        autoDistribute();\n', '    }\n', '}\n', '\n', '/**\n', ' * My thought is strong!\n', ' * The reconstruction of Kyusyu is the power of everyone!\n', ' */']
['pragma solidity ^0.4.21;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', '\n', 'library SafeMath {\n', '\tfunction mul(uint256 x, uint256 y) internal pure returns (uint256) {\n', '\t\tif (x == 0) {\n', '\t\t\treturn 0;\n', '\t\t}\n', '\t\tuint256 z = x * y;\n', '\t\tassert(z / x == y);\n', '\t\treturn z;\n', '\t}\n', '\t\n', '\tfunction div(uint256 x, uint256 y) internal pure returns (uint256) {\n', '\t    // assert(y > 0);//Solidity automatically throws when dividing by 0 \n', '\t    uint256 z = x / y;\n', '\t    // assert(x == y * z + x % y); // There is no case in which this doesn`t hold\n', '\t    return z;\n', '\t}\n', '\t\n', '\tfunction sub(uint256 x, uint256 y) internal pure returns (uint256) {\n', '\t    assert(y <= x);\n', '\t    return x - y;\n', '\t}\n', '\t\n', '\tfunction add(uint256 x, uint256 y) internal pure returns (uint256) {\n', '\t    uint256 z = x + y;\n', '\t    assert(z >= x);\n', '\t    return z;\n', '\t}\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization\n', ' *      control function,this simplifies the implementation of "user permissions".\n', ' */\n', ' \n', ' contract Ownable {\n', '     address public owner;\n', '     \n', '     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '     \n', '     /**\n', '      * \n', "      * @dev The Ownable constructor sets the original 'owner' of the contract to the\n", '      *         sender account.\n', '      */\n', '      \n', '     function Ownable() public {\n', '         owner = msg.sender;\n', ' }\n', ' \n', ' /**\n', '  * @dev Throws if called by any account other than the owner.\n', '  */\n', '  \n', ' modifier onlyOwner() {\n', '     require(msg.sender == owner);\n', '     _;\n', ' }\n', ' \n', ' /**\n', '  * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '  * @param newOwner The address to transfer ownership to.\n', '  */\n', '  \n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '      require(newOwner !=address(0));\n', '      emit OwnershipTransferred(owner, newOwner);\n', '      owner = newOwner;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ContractReceiver\n', ' * @dev Receiver for ERC223 tokens\n', ' */\n', ' \n', 'contract ContractReceiver {\n', '    \n', '    struct TKN {\n', '        address sender;\n', '        uint value;\n', '        bytes data;\n', '        bytes4 sig;\n', '    }\n', '    function tokenFallback(address _from, uint _value, bytes _data) public pure {\n', '        TKN memory tkn;\n', '        tkn.sender = _from;\n', '        tkn.value = _value;\n', '        tkn.data = _data;\n', '        uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) <<16) + (uint32(_data[0]) << 24);\n', '        tkn.sig = bytes4(u);\n', '        \n', '        /*\n', '         *tkn variable is analogue of msg variable of Ether transaction\n', '         *tkn.sender is person who initiated this token transaction (analogue of msg.sender)\n', '         *tkn.value the number of tokens that were sent (analogue of msg.value)\n', '         *tkn.data is data of token transaction (analogue of msg.data)\n', '         *tkn.sig is 4 bytes signature of function\n', '         *if data of token transaction is a function execution\n', '         */\n', '         \n', '    }\n', '}\n', '\n', 'contract ERC223 {\n', '    uint public totalSupply;\n', '    function name() public view returns (string _name);\n', '    function symbol() public view returns (string _symbol);\n', '    function decimals() public view returns (uint8 _decimals);\n', '    function totalSupply() public view returns (uint256 _supply);\n', '    function balanceOf(address who) public view returns (uint);\n', '\n', '    function transfer(address to, uint value) public returns (bool ok);\n', '    function transfer(address to, uint value, bytes data) public returns (bool ok);\n', '    function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '}\n', '\n', '/**\n', ' * Wishing for circulation of QSHUCOIN!\n', ' * I wish for prosperity for a long time!\n', ' * Flapping from Kyusyu to the world!\n', ' * We will work with integrity and sincerity!\n', ' * ARIGATOH!\n', ' */\n', '\n', 'contract QSHU is ERC223, Ownable {\n', '    using SafeMath for uint256;\n', '    \n', '    string public name = "QSHUCOIN";\n', '    string public symbol = "QSHU";\n', '    uint8 public decimals = 8;\n', '    uint256 public initialSupply = 50e9 * 1e8;\n', '    uint256 public totalSupply;\n', '    uint256 public distributeAmount = 0;\n', '    bool public mintingFinished = false;\n', '    \n', '    mapping (address => uint) balances;\n', '    mapping (address => bool) public frozenAccount;\n', '    mapping (address => uint256) public unlockUnixTime;\n', '    \n', '    event FrozenFunds(address indexed target, bool frozen);\n', '    event LockedFunds(address indexed target, uint256 locked);\n', '    event Burn(address indexed burner, uint256 value);\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '    \n', '    function QSHU() public {\n', '        totalSupply = initialSupply;\n', '        balances[msg.sender] = totalSupply;\n', '    }\n', '    \n', '    function name() public view returns (string _name) {\n', '        return name;\n', '    }\n', '    function symbol() public view returns (string _symbol) {\n', '        return symbol;\n', '    }\n', '    function decimals() public view returns (uint8 _decimals) {\n', '        return decimals;\n', '    }\n', '    function totalSupply() public view returns (uint256 _totalSupply) {\n', '        return totalSupply;\n', '    }\n', '    function balanceOf(address _owner) public view returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '    \n', '    modifier onlyPayloadSize(uint256 size){\n', '        assert(msg.data.length >= size + 4);\n', '        _;\n', '    }\n', '    \n', '    function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {\n', '        require(_value > 0\n', '            && frozenAccount[msg.sender] == false\n', '            && frozenAccount[_to] == false\n', '            && now > unlockUnixTime[msg.sender]\n', '            && now > unlockUnixTime[_to]);\n', '        \n', '        if(isContract(_to)) {\n', '            if (balanceOf(msg.sender) < _value) revert();\n', '            balances[msg.sender] = SafeMath.sub(balanceOf(msg.sender), _value);\n', '            balances[_to] = SafeMath.add(balanceOf(_to), _value);\n', '            assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));\n', '            emit Transfer(msg.sender, _to, _value, _data);\n', '            emit Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        }\n', '        else {\n', '            return transferToAddress(_to, _value, _data);\n', '        }\n', '    }\n', '    \n', '    function transfer(address _to, uint _value, bytes _data) public returns (bool success) {\n', '        require(_value > 0\n', '            && frozenAccount[msg.sender] == false\n', '            && frozenAccount[_to] == false\n', '            && now > unlockUnixTime[msg.sender]\n', '            && now > unlockUnixTime[_to]);\n', '\n', '        if(isContract(_to)) {\n', '            return transferToContract(_to, _value, _data);\n', '        }\n', '        else {\n', '            return transferToAddress(_to, _value, _data);\n', '        }\n', '    }\n', '    \n', '    function transfer(address _to, uint _value) public returns (bool success) {\n', '        require(_value > 0\n', '            && frozenAccount[msg.sender] == false\n', '            && frozenAccount[_to] == false\n', '            && now > unlockUnixTime[msg.sender]\n', '            && now > unlockUnixTime[_to]);\n', '    bytes memory empty;\n', '    if(isContract(_to)) {\n', '        return transferToContract(_to, _value, empty);\n', '    }\n', '    else {\n', '        return transferToAddress(_to, _value, empty);\n', '        }\n', '    }\n', '    \n', '    function isContract(address _addr) private view returns (bool is_contract) {\n', '        uint length;\n', '        assembly {\n', '            length := extcodesize(_addr)\n', '        }\n', '        return (length > 0);\n', '    }\n', '    \n', '    function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {\n', '        if (balanceOf(msg.sender) < _value) revert();\n', '        balances[msg.sender] = SafeMath.sub(balanceOf(msg.sender), _value);\n', '        balances[_to] = SafeMath.add(balanceOf(_to), _value);\n', '        emit Transfer(msg.sender, _to, _value, _data);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {\n', '        if (balanceOf(msg.sender) < _value) revert();\n', '        balances[msg.sender] = SafeMath.sub(balanceOf(msg.sender), _value);\n', '        balances[_to] = SafeMath.add(balanceOf(_to), _value);\n', '        ContractReceiver receiver = ContractReceiver(_to);\n', '        receiver.tokenFallback(msg.sender, _value, _data);\n', '        emit Transfer(msg.sender, _to, _value, _data);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '/**\n', ' * @dev Prevent targets from sending or receiving tokens\n', ' * @param targets Addresses to be frozen\n', ' * @param isFrozen either to freeze it or not\n', ' */\n', '\n', '    function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {\n', '        require(targets.length > 0);\n', '\n', '        for (uint q = 0; q < targets.length; q++) {\n', '            require(targets[q] != 0x0);\n', '            frozenAccount[targets[q]] = isFrozen;\n', '            emit FrozenFunds(targets[q], isFrozen);\n', '        }\n', '    }\n', '    \n', '/**\n', ' * @dev Prevent targets from sending or receiving tokens by setting Unix times \n', ' * @param targets Addresses to be locked funds \n', ' * @param unixTimes Unix times when locking up will be finished \n', ' */\n', ' \n', '    function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {\n', '        require(targets.length > 0 \n', '            && targets.length == unixTimes.length);\n', '            \n', '        for(uint q = 0; q < targets.length; q++){\n', '            require(unlockUnixTime[targets[q]] < unixTimes[q]);\n', '            unlockUnixTime[targets[q]] = unixTimes[q];\n', '            emit LockedFunds(targets[q], unixTimes[q]);\n', '        }\n', '    }\n', '\n', '/**\n', ' * @dev Burns a specific amount of tokens.\n', ' * @param _from The address that will burn the tokens.\n', ' * @param _unitAmount The amount of token to be burned.\n', ' */\n', ' \n', '    function burn(address _from, uint256 _unitAmount) onlyOwner public {\n', '        require(_unitAmount > 0\n', '            && balanceOf(_from) >= _unitAmount);\n', '        \n', '        balances[_from] = SafeMath.sub(balances[_from], _unitAmount);\n', '        totalSupply = SafeMath.sub(totalSupply, _unitAmount);\n', '        emit Burn(_from, _unitAmount);\n', '    }\n', '    \n', '    modifier canMint() {\n', '        require(!mintingFinished);\n', '        _;\n', '    }\n', '    \n', '/**\n', ' * @dev Function to mint tokens\n', ' * @param _to The address that will receive the minted tokens.\n', ' * @param _unitAmount The amount of tokens to mint.\n', ' */\n', ' \n', '    function mint (address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {\n', '        require(_unitAmount > 0);\n', '        \n', '        totalSupply = SafeMath.add(totalSupply, _unitAmount);\n', '        balances[_to] = SafeMath.add(balances[_to], _unitAmount);\n', '        emit Mint(_to, _unitAmount);\n', '        emit Transfer(address(0), _to, _unitAmount);\n', '        return true;\n', '    }\n', '\n', '\n', '/**\n', ' * dev Function to stop minting new tokens.\n', ' */\n', ' \n', '    function finishMinting() onlyOwner canMint public returns (bool) {\n', '        mintingFinished = true;\n', '        emit MintFinished();\n', '        return true;\n', '    }\n', '    \n', '/**\n', ' * @dev Function to distribute tokens to the list of addresses by the provided amount\n', ' */\n', ' \n', '\n', '    function distributeTokens(address[] addresses, uint256 amount) public returns (bool) {\n', '        require(amount > 0\n', '            && addresses.length > 0\n', '            && frozenAccount[msg.sender] == false\n', '            && now > unlockUnixTime[msg.sender]);\n', '        \n', '        amount = SafeMath.mul(amount,1e8);\n', '        uint256 totalAmount = SafeMath.mul(amount, addresses.length);\n', '        require(balances[msg.sender] >= totalAmount);\n', '        \n', '        for (uint q = 0; q < addresses.length; q++) {\n', '            require(addresses[q] != 0x0\n', '                && frozenAccount[addresses[q]] == false\n', '                && now > unlockUnixTime[addresses[q]]);\n', '            \n', '            balances[addresses[q]] = SafeMath.add(balances[addresses[q]], amount);\n', '            emit Transfer(msg.sender, addresses[q], amount);\n', '        }\n', '        balances[msg.sender] = SafeMath.sub(balances[msg.sender],totalAmount);\n', '        return true;\n', '    }\n', '    \n', '/**\n', ' * @dev Function to collect tokens from the list of addresses\n', ' */\n', '\n', '    function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {\n', '        require(addresses.length > 0\n', '                && addresses.length == amounts.length);\n', '        \n', '        uint256 totalAmount = 0;\n', '        \n', '        for (uint q = 0; q < addresses.length; q++) {\n', '            require(amounts[q] > 0\n', '                    && addresses[q] != 0x0\n', '                    && frozenAccount[addresses[q]] == false\n', '                    && now > unlockUnixTime[addresses[q]]);\n', '            \n', '            amounts[q] = SafeMath.mul(amounts[q], 1e8);\n', '            require(balances[addresses[q]] >= amounts[q]);\n', '            balances[addresses[q]] = SafeMath.sub(balances[addresses[q]], amounts[q]);\n', '            totalAmount = SafeMath.add(totalAmount, amounts[q]);\n', '            emit Transfer(addresses[q], msg.sender, amounts[q]);\n', '        }\n', '        balances[msg.sender] = SafeMath.add(balances[msg.sender], totalAmount);\n', '        return true;\n', '    }\n', '    function setDistributeAmount(uint256 _unitAmount) onlyOwner public {\n', '        distributeAmount = _unitAmount;\n', '    }\n', '    \n', '/**\n', ' * @dev Function to distribute tokens to the msg.sender automatically\n', " * If distributeAmount is 0 , this function doesn't work'\n", ' */\n', ' \n', '    function autoDistribute() payable public {\n', '        require(distributeAmount > 0\n', '                && balanceOf(owner) >= distributeAmount\n', '                && frozenAccount[msg.sender] == false\n', '                && now > unlockUnixTime[msg.sender]);\n', '        if (msg.value > 0) owner.transfer(msg.value);\n', '        \n', '        balances[owner] = SafeMath.sub(balances[owner], distributeAmount);\n', '        balances[msg.sender] = SafeMath.add(balances[msg.sender], distributeAmount);\n', '        emit Transfer(owner, msg.sender, distributeAmount);\n', '    }\n', '    \n', '/**\n', ' * @dev token fallback function\n', ' */\n', ' \n', '    function() payable public {\n', '        autoDistribute();\n', '    }\n', '}\n', '\n', '/**\n', ' * My thought is strong!\n', ' * The reconstruction of Kyusyu is the power of everyone!\n', ' */']
