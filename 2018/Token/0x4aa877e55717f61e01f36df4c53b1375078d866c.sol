['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * Math operations to avoid overflows\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '}\n', '\n', 'contract FarmChain {\n', '    /*using the SafeMath keep from the up/down overflows*/\n', '    using SafeMath for uint256;\n', '    \n', '    /*the name of the token*/\n', '    string public name;\n', '    \n', "    /*the token's symbol*/\n", '    string public symbol;\n', '    /*the decimal of the token */\n', '    \n', '    uint8 public decimals;\n', '    \n', '    /* the totalSupply of token */\n', '    uint256 public totalSupply;\n', '\n', '    /*the owner of the contract*/\n', '\taddress public owner;\n', '\t\n', '\taddress[] public ownerables;\n', '\t\n', '\tbool  public isRunning = false;\n', '\t\n', '//\tuint startTime;\n', '\t\n', '\taddress public burnAddress;\n', '\t\n', '\tmapping(address => bool) public isOwner;\n', '\t\n', '\tmapping (address => bool) public isFrezze;\n', '\t\n', '//\taddress public LockBinAddress;\n', '\n', "    /* The hot_balance of users , users' totalBalance = balanceOf + freezeOf */\n", '    mapping (address => uint256) public balanceOf;\n', '    /*the Lock-bin balance of users */\n', '//\tmapping (address => uint256) public lockbinOf;\n', '\t\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 value);\n', '    \n', '    event Approval(address indexed _from, address indexed _spender, uint256 _value);\n', '\t\n', '    event Freeze(address indexed _who, address indexed _option);\n', '    \n', '    event UnFrezze(address indexed _who, address indexed _option);\n', '    \n', '    event Burn(address indexed _from, uint256 _amount);\n', '    \n', '    modifier onlyOwnerable() {\n', '        assert(isOwner[msg.sender]);\n', '        _;\n', '    }\n', '    modifier onlyOwner() {\n', '        assert(msg.sender == owner);\n', '        _;\n', '    }\n', '    /*Let the contract keep from the short-address attack*/\n', '    modifier onlyPayloadSize(uint size) {\n', '        assert((msg.data.length >= size + 4));\n', '        _;\n', '    }\n', '    modifier onlyRuning {\n', '        require(isRunning, "the contract has been stoped");\n', '        _;\n', '    }\n', '    modifier onlyUnFrezze {\n', '        assert(!isFrezze[msg.sender]);\n', '        _;\n', '    }\n', '  \n', '\n', '    /* the constructor of the contract */\n', 'constructor() public {\n', '        \n', '        totalSupply = 100000000000000000;\n', '       \n', '        balanceOf[msg.sender] = totalSupply;\n', '        \n', '        name = "Farm Chain";                                  \n', '        \n', '        symbol = "FAC";                               \n', '      \n', '        decimals = 8;                            \n', '\t\n', '\t\towner = msg.sender;\n', '\t\t\n', '\t\tisOwner[owner] = true;\n', '\t\n', '\t\tisRunning = true;\n', '\t\t\n', '\t\t//addOwners(_admins);\n', '\t\t\n', '    }\n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) public onlyRuning onlyUnFrezze onlyPayloadSize(32 * 2) returns (bool success){\n', '        require(_to != 0x0);\n', '        require( balanceOf[msg.sender] >= _value);\n', '        require(balanceOf[_to] + _value > balanceOf[_to]); \n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);                     \n', '        balanceOf[_to] = balanceOf[_to].add(_value);                            \n', '        emit Transfer(msg.sender, _to, _value); \n', '        return true;\n', '    }\n', '\n', '    \n', '    function approve(address _spender , uint256 _value) public onlyUnFrezze onlyRuning returns (bool success) {\n', '\t\tallowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '       \n', '\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value) public onlyUnFrezze onlyRuning returns (bool success) {\n', '            \n', '            assert(balanceOf[_from] >= _value);\n', '            assert(allowance[_from][msg.sender] >= _value);\n', '            balanceOf[_from] = balanceOf[_from].sub(_value);\n', '            allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);\n', '            balanceOf[_to] = balanceOf[_to].add(_value);\n', '            emit Transfer(_from, _to, _value);\n', '            return true;\n', '    }\n', '    \n', '    function stopContract() public onlyOwnerable {\n', '        require(isRunning,"the contract has been stoped");\n', '        \n', '        isRunning = false;\n', '    }\n', '    \n', '    function startContract() public onlyOwnerable {\n', '        require(!isRunning,"the contract has been started");\n', '        \n', '        isRunning = true;\n', '    }\n', '    \n', '    function freeze (address _option) public onlyOwnerable {\n', '        require(!isFrezze[_option],"the account has been feezed");\n', '       \n', '        isFrezze[_option] = true;\n', '       \n', '        emit Freeze(msg.sender, _option);\n', '    }\n', '   \n', '    function unFreeze(address _option) public onlyOwnerable {\n', '        \n', '        require(isFrezze[_option],"the account has been unFrezzed");\n', '       \n', '        isFrezze[_option] = false;\n', '        \n', '        emit UnFrezze(msg.sender, _option);\n', '    }\n', '\n', '    function setOwners(address[] _admin) public onlyOwner {\n', '        uint len = _admin.length;\n', '        for(uint i= 0; i< len; i++) {\n', '            require(!isContract(_admin[i]),"not support contract address as owner");\n', '            require(!isOwner[_admin[i]],"the address is admin already");\n', '            isOwner[_admin[i]] = true;\n', '        }\n', '    }\n', '\n', '    function deletOwners(address[] _todel) public onlyOwner {\n', '        uint len = _todel.length;\n', '        for(uint i= 0; i< len; i++) {\n', '            require(isOwner[_todel[i]],"the address is not a admin");\n', '            isOwner[_todel[i]] = false;\n', '        }\n', '        \n', '    }\n', '\n', '    function setBurnAddress(address _toBurn) public onlyOwnerable returns(bool success) {\n', '        \n', '        burnAddress = _toBurn;\n', '        return true;\n', '    }\n', '\n', '    function burn(uint256 _amount)  public onlyOwnerable {\n', '        require(balanceOf[burnAddress] >= _amount,"there is no enough money to burn");\n', '        balanceOf[burnAddress] = balanceOf[burnAddress].sub(_amount);\n', '        totalSupply = totalSupply.sub(_amount);\n', '        emit Burn(burnAddress, _amount);\n', '    }\n', '\n', '    function isContract(address _addr) constant internal returns(bool) {\n', '        require(_addr != 0x0);\n', '        uint size;\n', '         assembly {\n', '            /*:= reference external variable*/\n', '            size := extcodesize(_addr)\n', '        }\n', '        return size > 0;\n', '    }\n', '}']