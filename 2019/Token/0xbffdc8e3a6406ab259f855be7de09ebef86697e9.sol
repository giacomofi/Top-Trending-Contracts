['pragma solidity ^0.4.23;\n', '\n', 'contract Base{\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;\n', '    uint256 public totalSupply;\n', '    uint256 public tokenUnit = 10 ** uint(decimals);\n', '    uint256 public kUnit = 1000 * tokenUnit;\n', '    uint256 public foundingTime;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    constructor() public {\n', '        foundingTime = now;\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint256 _value) internal {\n', '        require(_to != 0x0);\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    } \n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract UHC is Base {\n', '    uint256 public release = 20000000 * kUnit;\n', '    constructor() public {\n', '        totalSupply = release;\n', '        balanceOf[msg.sender] = totalSupply;\n', '        name = "Global Medical Chain";\n', '        symbol = "UHC";\n', '    }\n', '}']
['pragma solidity ^0.4.23;\n', '\n', 'contract Base{\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;\n', '    uint256 public totalSupply;\n', '    uint256 public tokenUnit = 10 ** uint(decimals);\n', '    uint256 public kUnit = 1000 * tokenUnit;\n', '    uint256 public foundingTime;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    constructor() public {\n', '        foundingTime = now;\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint256 _value) internal {\n', '        require(_to != 0x0);\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    } \n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract UHC is Base {\n', '    uint256 public release = 20000000 * kUnit;\n', '    constructor() public {\n', '        totalSupply = release;\n', '        balanceOf[msg.sender] = totalSupply;\n', '        name = "Global Medical Chain";\n', '        symbol = "UHC";\n', '    }\n', '}']
