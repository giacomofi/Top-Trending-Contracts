['pragma solidity ^0.4.11;\n', '\n', 'library LBCCoin {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', ' \n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', ' \n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', ' \n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', 'contract LBCToken {\n', '    using LBCCoin for uint;\n', '\n', '    string public name = "LeiBaoCoin";      //  token name\n', '    string public symbol = "LBC";           //  token symbol\n', '    uint256 public decimals = 6;            //  token digit\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    uint256 public totalSupply = 0;\n', '    bool public stopped = false;\n', '\n', '    uint256 constant valueFounder = 63000000000000;\n', '    address owner = 0x0;\n', '\n', '    modifier onlyPayloadSize(uint size) {\n', '        require(!(msg.data.length < size + 4));\n', '        _;\n', '    }\n', '\n', '    modifier isOwner {\n', '        assert(owner == msg.sender);\n', '        _;\n', '    }\n', '\n', '    modifier isRunning {\n', '        assert (!stopped);\n', '        _;\n', '    }\n', '\n', '    modifier validAddress {\n', '        assert(0x0 != msg.sender);\n', '        _;\n', '    }\n', '\n', '    function LBCToken(address _addressFounder) {\n', '        owner = msg.sender;\n', '        totalSupply = valueFounder;\n', '        balanceOf[_addressFounder] = valueFounder;\n', '        Transfer(0x0, _addressFounder, valueFounder);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) isRunning validAddress onlyPayloadSize(2 * 32) returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) isRunning validAddress onlyPayloadSize(3 * 32) returns (bool success) {\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        require(allowance[_from][msg.sender] >= _value);\n', '        balanceOf[_to] += _value;\n', '        balanceOf[_from] -= _value;\n', '        allowance[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) isRunning validAddress returns (bool success) {\n', '        require(_value == 0 || allowance[msg.sender][_spender] == 0);\n', '        allowance[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function stop() isOwner {\n', '        stopped = true;\n', '    }\n', '\n', '    function start() isOwner {\n', '        stopped = false;\n', '    }\n', '\n', '    function setName(string _name) isOwner {\n', '        name = _name;\n', '    }\n', '\n', '    function burn(uint256 _value) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[0x0] += _value;\n', '        Transfer(msg.sender, 0x0, _value);\n', '    }\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}']
['pragma solidity ^0.4.11;\n', '\n', 'library LBCCoin {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', ' \n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', ' \n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', ' \n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', 'contract LBCToken {\n', '    using LBCCoin for uint;\n', '\n', '    string public name = "LeiBaoCoin";      //  token name\n', '    string public symbol = "LBC";           //  token symbol\n', '    uint256 public decimals = 6;            //  token digit\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    uint256 public totalSupply = 0;\n', '    bool public stopped = false;\n', '\n', '    uint256 constant valueFounder = 63000000000000;\n', '    address owner = 0x0;\n', '\n', '    modifier onlyPayloadSize(uint size) {\n', '        require(!(msg.data.length < size + 4));\n', '        _;\n', '    }\n', '\n', '    modifier isOwner {\n', '        assert(owner == msg.sender);\n', '        _;\n', '    }\n', '\n', '    modifier isRunning {\n', '        assert (!stopped);\n', '        _;\n', '    }\n', '\n', '    modifier validAddress {\n', '        assert(0x0 != msg.sender);\n', '        _;\n', '    }\n', '\n', '    function LBCToken(address _addressFounder) {\n', '        owner = msg.sender;\n', '        totalSupply = valueFounder;\n', '        balanceOf[_addressFounder] = valueFounder;\n', '        Transfer(0x0, _addressFounder, valueFounder);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) isRunning validAddress onlyPayloadSize(2 * 32) returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) isRunning validAddress onlyPayloadSize(3 * 32) returns (bool success) {\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        require(allowance[_from][msg.sender] >= _value);\n', '        balanceOf[_to] += _value;\n', '        balanceOf[_from] -= _value;\n', '        allowance[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) isRunning validAddress returns (bool success) {\n', '        require(_value == 0 || allowance[msg.sender][_spender] == 0);\n', '        allowance[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function stop() isOwner {\n', '        stopped = true;\n', '    }\n', '\n', '    function start() isOwner {\n', '        stopped = false;\n', '    }\n', '\n', '    function setName(string _name) isOwner {\n', '        name = _name;\n', '    }\n', '\n', '    function burn(uint256 _value) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[0x0] += _value;\n', '        Transfer(msg.sender, 0x0, _value);\n', '    }\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}']
