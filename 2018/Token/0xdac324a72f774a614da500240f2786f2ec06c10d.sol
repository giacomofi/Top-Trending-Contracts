['pragma solidity ^0.4.23;\n', '\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint _value, address _token, bytes _extraData) external; }\n', '\n', '\n', 'contract TokenBase is Owned {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;\n', '    uint public totalSupply;\n', '    uint public tokenUnit = 10 ** uint(decimals);\n', '    uint public wanUnit = 10000 * tokenUnit;\n', '    uint public foundingTime;\n', '\n', '    mapping (address => uint) public balanceOf;\n', '    mapping (address => mapping (address => uint)) public allowance;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '\n', '    constructor() public {\n', '        foundingTime = now;\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require(_to != 0x0);\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    function transfer(address _to, uint _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint _value, bytes _extraData) public returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '}\n', '\n', '\n', '\n', 'contract Token is TokenBase {\n', '    uint public initialSupply = 0 * wanUnit;\n', '    uint public reserveSupply = 500000 * wanUnit;\n', '\n', '    constructor() public {\n', '        totalSupply = initialSupply;\n', '        balanceOf[msg.sender] = initialSupply;\n', '        name = "CDCC";\n', '        symbol = "CDCC";\n', '    }\n', '\n', '    function releaseReserve(uint value) onlyOwner public {\n', '        require(reserveSupply >= value);\n', '        balanceOf[owner] += value;\n', '        totalSupply += value;\n', '        reserveSupply -= value;\n', '        emit Transfer(0, this, value);\n', '        emit Transfer(this, owner, value);\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.23;\n', '\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint _value, address _token, bytes _extraData) external; }\n', '\n', '\n', 'contract TokenBase is Owned {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;\n', '    uint public totalSupply;\n', '    uint public tokenUnit = 10 ** uint(decimals);\n', '    uint public wanUnit = 10000 * tokenUnit;\n', '    uint public foundingTime;\n', '\n', '    mapping (address => uint) public balanceOf;\n', '    mapping (address => mapping (address => uint)) public allowance;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '\n', '    constructor() public {\n', '        foundingTime = now;\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require(_to != 0x0);\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    function transfer(address _to, uint _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint _value, bytes _extraData) public returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '}\n', '\n', '\n', '\n', 'contract Token is TokenBase {\n', '    uint public initialSupply = 0 * wanUnit;\n', '    uint public reserveSupply = 500000 * wanUnit;\n', '\n', '    constructor() public {\n', '        totalSupply = initialSupply;\n', '        balanceOf[msg.sender] = initialSupply;\n', '        name = "CDCC";\n', '        symbol = "CDCC";\n', '    }\n', '\n', '    function releaseReserve(uint value) onlyOwner public {\n', '        require(reserveSupply >= value);\n', '        balanceOf[owner] += value;\n', '        totalSupply += value;\n', '        reserveSupply -= value;\n', '        emit Transfer(0, this, value);\n', '        emit Transfer(this, owner, value);\n', '    }\n', '\n', '}']
