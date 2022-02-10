['pragma solidity ^0.4.11;\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal pure returns (uint) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal pure returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal pure  returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  \n', '}\n', 'contract ERC20Interface {\n', '    function totalSupply() public view returns (uint supply);\n', '    function balanceOf( address owner ) public view returns (uint value);\n', '    function allowance( address owner, address spender ) public view returns (uint _allowance);\n', '\n', '    function transfer( address to, uint value) public returns (bool success);\n', '    function transferFrom( address from, address to, uint value) public returns (bool success);\n', '    function approve( address spender, uint value ) public returns (bool success);\n', '\n', '    event Transfer( address indexed from, address indexed to, uint value);\n', '    event Approval( address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'contract StandardAuth is ERC20Interface {\n', '    address      public  owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function setOwner(address _newOwner) public onlyOwner{\n', '        owner = _newOwner;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '      require(msg.sender == owner);\n', '      _;\n', '    }\n', '}\n', '\n', 'contract StandardToken is StandardAuth {\n', '    using SafeMath for uint;\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping (address => uint256)) allowed;\n', '    mapping(address => bool) optionPoolMembers;\n', '    mapping(address => uint) optionPoolMemberApproveTotal;\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 9;\n', '    uint256 public totalSupply;\n', '    uint256 public optionPoolLockTotal = 500000000;\n', '    uint [2][7] public optionPoolMembersUnlockPlans = [\n', '        [1596211200,15],    //2020-08-01 00:00:00 unlock 15%\n', '        [1612108800,30],    //2021-02-01 00:00:00 unlock 30%\n', '        [1627747200,45],    //2021-08-01 00:00:00 unlock 45%\n', '        [1643644800,60],    //2022-02-01 00:00:00 unlock 60%\n', '        [1659283200,75],    //2022-08-01 00:00:00 unlock 75%\n', '        [1675180800,90],    //2023-02-01 00:00:00 unlock 90%\n', '        [1690819200,100]    //2023-08-01 00:00:00 unlock 100%\n', '    ];\n', '    \n', '    constructor(uint256 _initialAmount, string _tokenName, string _tokenSymbol) public  {\n', '        balances[msg.sender] = _initialAmount;               \n', '        totalSupply = _initialAmount;                        \n', '        name = _tokenName;                                   \n', '        symbol = _tokenSymbol;\n', '        optionPoolMembers[0x36b4F89608B5a5d5bd675b13a9d1075eCb64C2B5] = true;\n', '        optionPoolMembers[0xDdcEb1A0c975Da8f0E0c457e06D6eBfb175570A7] = true;\n', '        optionPoolMembers[0x46b6bA8ff5b91FF6B76964e143f3573767a20c1C] = true;\n', '        optionPoolMembers[0xBF95141188dB8FDeFe85Ce2412407A9266d96dA3] = true;\n', '    }\n', '\n', '    modifier verifyTheLock(uint _value) {\n', '        if(optionPoolMembers[msg.sender] == true) {\n', '            if(balances[msg.sender] - optionPoolMemberApproveTotal[msg.sender] - _value < optionPoolMembersLockTotalOf(msg.sender)) {\n', '                revert();\n', '            } else {\n', '                _;\n', '            }\n', '        } else {\n', '            _;\n', '        }\n', '    }\n', '    \n', '    // Function to access name of token .\n', '    function name() public view returns (string _name) {\n', '        return name;\n', '    }\n', '    // Function to access symbol of token .\n', '    function symbol() public view returns (string _symbol) {\n', '        return symbol;\n', '    }\n', '    // Function to access decimals of token .\n', '    function decimals() public view returns (uint8 _decimals) {\n', '        return decimals;\n', '    }\n', '    // Function to access total supply of tokens .\n', '    function totalSupply() public view returns (uint _totalSupply) {\n', '        return totalSupply;\n', '    }\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    function balanceOf(address _owner) public view returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '    function verifyOptionPoolMembers(address _add) public view returns (bool _verifyResults) {\n', '        return optionPoolMembers[_add];\n', '    }\n', '    \n', '    function optionPoolMembersLockTotalOf(address _memAdd) public view returns (uint _optionPoolMembersLockTotal) {\n', '        if(optionPoolMembers[_memAdd] != true){\n', '            return 0;\n', '        }\n', '        \n', '        uint unlockPercent = 0;\n', '        \n', '        for (uint8 i = 0; i < optionPoolMembersUnlockPlans.length; i++) {\n', '            if(now >= optionPoolMembersUnlockPlans[i][0]) {\n', '                unlockPercent = optionPoolMembersUnlockPlans[i][1];\n', '            } else {\n', '                break;\n', '            }\n', '        }\n', '        \n', '        return optionPoolLockTotal * (100 - unlockPercent) / 100;\n', '    }\n', '    \n', '    function transfer(address _to, uint _value) public verifyTheLock(_value) returns (bool success) {\n', '        assert(_value > 0);\n', '        assert(balances[msg.sender] >= _value);\n', '        assert(msg.sender != _to);\n', '        \n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        \n', '        emit Transfer(msg.sender, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        assert(balances[_from] >= _value);\n', '        assert(allowed[_from][msg.sender] >= _value);\n', '\n', '        if(optionPoolMembers[_from] == true) {\n', '            optionPoolMemberApproveTotal[_from] = optionPoolMemberApproveTotal[_from].sub(_value);\n', '        }\n', '        \n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(_from, _to, _value);\n', '\n', '        return true;\n', '        \n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public verifyTheLock(_value) returns (bool success) {\n', '        assert(_value > 0);\n', '        assert(msg.sender != _spender);\n', '        \n', '        if(optionPoolMembers[msg.sender] == true) {\n', '            \n', '            if(allowed[msg.sender][_spender] > 0){\n', '                optionPoolMemberApproveTotal[msg.sender] = optionPoolMemberApproveTotal[msg.sender].sub(allowed[msg.sender][_spender]);\n', '            }\n', '            \n', '            optionPoolMemberApproveTotal[msg.sender] = optionPoolMemberApproveTotal[msg.sender].add(_value);\n', '        }\n', '        \n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        \n', '        return true;\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.11;\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal pure returns (uint) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal pure returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal pure  returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  \n', '}\n', 'contract ERC20Interface {\n', '    function totalSupply() public view returns (uint supply);\n', '    function balanceOf( address owner ) public view returns (uint value);\n', '    function allowance( address owner, address spender ) public view returns (uint _allowance);\n', '\n', '    function transfer( address to, uint value) public returns (bool success);\n', '    function transferFrom( address from, address to, uint value) public returns (bool success);\n', '    function approve( address spender, uint value ) public returns (bool success);\n', '\n', '    event Transfer( address indexed from, address indexed to, uint value);\n', '    event Approval( address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'contract StandardAuth is ERC20Interface {\n', '    address      public  owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function setOwner(address _newOwner) public onlyOwner{\n', '        owner = _newOwner;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '      require(msg.sender == owner);\n', '      _;\n', '    }\n', '}\n', '\n', 'contract StandardToken is StandardAuth {\n', '    using SafeMath for uint;\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping (address => uint256)) allowed;\n', '    mapping(address => bool) optionPoolMembers;\n', '    mapping(address => uint) optionPoolMemberApproveTotal;\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 9;\n', '    uint256 public totalSupply;\n', '    uint256 public optionPoolLockTotal = 500000000;\n', '    uint [2][7] public optionPoolMembersUnlockPlans = [\n', '        [1596211200,15],    //2020-08-01 00:00:00 unlock 15%\n', '        [1612108800,30],    //2021-02-01 00:00:00 unlock 30%\n', '        [1627747200,45],    //2021-08-01 00:00:00 unlock 45%\n', '        [1643644800,60],    //2022-02-01 00:00:00 unlock 60%\n', '        [1659283200,75],    //2022-08-01 00:00:00 unlock 75%\n', '        [1675180800,90],    //2023-02-01 00:00:00 unlock 90%\n', '        [1690819200,100]    //2023-08-01 00:00:00 unlock 100%\n', '    ];\n', '    \n', '    constructor(uint256 _initialAmount, string _tokenName, string _tokenSymbol) public  {\n', '        balances[msg.sender] = _initialAmount;               \n', '        totalSupply = _initialAmount;                        \n', '        name = _tokenName;                                   \n', '        symbol = _tokenSymbol;\n', '        optionPoolMembers[0x36b4F89608B5a5d5bd675b13a9d1075eCb64C2B5] = true;\n', '        optionPoolMembers[0xDdcEb1A0c975Da8f0E0c457e06D6eBfb175570A7] = true;\n', '        optionPoolMembers[0x46b6bA8ff5b91FF6B76964e143f3573767a20c1C] = true;\n', '        optionPoolMembers[0xBF95141188dB8FDeFe85Ce2412407A9266d96dA3] = true;\n', '    }\n', '\n', '    modifier verifyTheLock(uint _value) {\n', '        if(optionPoolMembers[msg.sender] == true) {\n', '            if(balances[msg.sender] - optionPoolMemberApproveTotal[msg.sender] - _value < optionPoolMembersLockTotalOf(msg.sender)) {\n', '                revert();\n', '            } else {\n', '                _;\n', '            }\n', '        } else {\n', '            _;\n', '        }\n', '    }\n', '    \n', '    // Function to access name of token .\n', '    function name() public view returns (string _name) {\n', '        return name;\n', '    }\n', '    // Function to access symbol of token .\n', '    function symbol() public view returns (string _symbol) {\n', '        return symbol;\n', '    }\n', '    // Function to access decimals of token .\n', '    function decimals() public view returns (uint8 _decimals) {\n', '        return decimals;\n', '    }\n', '    // Function to access total supply of tokens .\n', '    function totalSupply() public view returns (uint _totalSupply) {\n', '        return totalSupply;\n', '    }\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    function balanceOf(address _owner) public view returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '    function verifyOptionPoolMembers(address _add) public view returns (bool _verifyResults) {\n', '        return optionPoolMembers[_add];\n', '    }\n', '    \n', '    function optionPoolMembersLockTotalOf(address _memAdd) public view returns (uint _optionPoolMembersLockTotal) {\n', '        if(optionPoolMembers[_memAdd] != true){\n', '            return 0;\n', '        }\n', '        \n', '        uint unlockPercent = 0;\n', '        \n', '        for (uint8 i = 0; i < optionPoolMembersUnlockPlans.length; i++) {\n', '            if(now >= optionPoolMembersUnlockPlans[i][0]) {\n', '                unlockPercent = optionPoolMembersUnlockPlans[i][1];\n', '            } else {\n', '                break;\n', '            }\n', '        }\n', '        \n', '        return optionPoolLockTotal * (100 - unlockPercent) / 100;\n', '    }\n', '    \n', '    function transfer(address _to, uint _value) public verifyTheLock(_value) returns (bool success) {\n', '        assert(_value > 0);\n', '        assert(balances[msg.sender] >= _value);\n', '        assert(msg.sender != _to);\n', '        \n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        \n', '        emit Transfer(msg.sender, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        assert(balances[_from] >= _value);\n', '        assert(allowed[_from][msg.sender] >= _value);\n', '\n', '        if(optionPoolMembers[_from] == true) {\n', '            optionPoolMemberApproveTotal[_from] = optionPoolMemberApproveTotal[_from].sub(_value);\n', '        }\n', '        \n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(_from, _to, _value);\n', '\n', '        return true;\n', '        \n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public verifyTheLock(_value) returns (bool success) {\n', '        assert(_value > 0);\n', '        assert(msg.sender != _spender);\n', '        \n', '        if(optionPoolMembers[msg.sender] == true) {\n', '            \n', '            if(allowed[msg.sender][_spender] > 0){\n', '                optionPoolMemberApproveTotal[msg.sender] = optionPoolMemberApproveTotal[msg.sender].sub(allowed[msg.sender][_spender]);\n', '            }\n', '            \n', '            optionPoolMemberApproveTotal[msg.sender] = optionPoolMemberApproveTotal[msg.sender].add(_value);\n', '        }\n', '        \n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        \n', '        return true;\n', '    }\n', '\n', '}']