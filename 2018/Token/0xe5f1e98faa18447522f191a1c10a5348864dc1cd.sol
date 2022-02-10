['pragma solidity ^0.4.11;\n', '\n', 'contract CaterToken {\n', '\n', '    string public name = "Cater";      //  token name\n', '    string public symbol = "CATER";           //  token symbol\n', '    uint256 public decimals = 8;            //  token digit\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    uint256 public totalSupply = 0;\n', '    bool public stopped = false;\n', '\n', '    uint256 constant valueFounder = 20000000000000000;\n', '    address owner = 0x0;\n', '\n', '    modifier isOwner {\n', '        assert(owner == msg.sender);\n', '        _;\n', '    }\n', '\n', '    modifier isRunning {\n', '        assert (!stopped);\n', '        _;\n', '    }\n', '\n', '    modifier validAddress {\n', '        assert(0x0 != msg.sender);\n', '        _;\n', '    }\n', '\n', '    function CaterToken (address _addressFounder) public {\n', '        owner = msg.sender;\n', '        totalSupply = valueFounder;\n', '        balanceOf[_addressFounder] = valueFounder;\n', '        emit Transfer(0x0, _addressFounder, valueFounder);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public isRunning validAddress returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public isRunning validAddress returns (bool success) {\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        require(allowance[_from][msg.sender] >= _value);\n', '        balanceOf[_to] += _value;\n', '        balanceOf[_from] -= _value;\n', '        allowance[_from][msg.sender] -= _value;\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public isRunning validAddress returns (bool success) {\n', '        require(_value == 0 || allowance[msg.sender][_spender] == 0);\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function stop() public isOwner {\n', '        stopped = true;\n', '    }\n', '\n', '    function start() public isOwner {\n', '        stopped = false;\n', '    }\n', '\n', '    function setName(string _name) public isOwner {\n', '        name = _name;\n', '    }\n', '\n', '    function setSymbol(string _symbol) public isOwner {\n', '        symbol = _symbol;\n', '    }\n', '\n', '    function burn(uint256 _value) public {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[0x0] += _value;\n', '        emit Transfer(msg.sender, 0x0, _value);\n', '    }\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}']
['pragma solidity ^0.4.11;\n', '\n', 'contract CaterToken {\n', '\n', '    string public name = "Cater";      //  token name\n', '    string public symbol = "CATER";           //  token symbol\n', '    uint256 public decimals = 8;            //  token digit\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    uint256 public totalSupply = 0;\n', '    bool public stopped = false;\n', '\n', '    uint256 constant valueFounder = 20000000000000000;\n', '    address owner = 0x0;\n', '\n', '    modifier isOwner {\n', '        assert(owner == msg.sender);\n', '        _;\n', '    }\n', '\n', '    modifier isRunning {\n', '        assert (!stopped);\n', '        _;\n', '    }\n', '\n', '    modifier validAddress {\n', '        assert(0x0 != msg.sender);\n', '        _;\n', '    }\n', '\n', '    function CaterToken (address _addressFounder) public {\n', '        owner = msg.sender;\n', '        totalSupply = valueFounder;\n', '        balanceOf[_addressFounder] = valueFounder;\n', '        emit Transfer(0x0, _addressFounder, valueFounder);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public isRunning validAddress returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public isRunning validAddress returns (bool success) {\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        require(allowance[_from][msg.sender] >= _value);\n', '        balanceOf[_to] += _value;\n', '        balanceOf[_from] -= _value;\n', '        allowance[_from][msg.sender] -= _value;\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public isRunning validAddress returns (bool success) {\n', '        require(_value == 0 || allowance[msg.sender][_spender] == 0);\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function stop() public isOwner {\n', '        stopped = true;\n', '    }\n', '\n', '    function start() public isOwner {\n', '        stopped = false;\n', '    }\n', '\n', '    function setName(string _name) public isOwner {\n', '        name = _name;\n', '    }\n', '\n', '    function setSymbol(string _symbol) public isOwner {\n', '        symbol = _symbol;\n', '    }\n', '\n', '    function burn(uint256 _value) public {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[0x0] += _value;\n', '        emit Transfer(msg.sender, 0x0, _value);\n', '    }\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}']
