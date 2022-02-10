['pragma solidity ^0.4.24;\n', '\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', '\n', 'contract SafeMath {\n', '  function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b > 0);\n', '    uint256 c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', 'contract BankToken is SafeMath {\n', '    address public owner;\n', '    string public name;\n', '    string public symbol;\n', '    uint public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Burn(address indexed from, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    \n', '    mapping (address => bool) public frozenAccount;\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    bool lock = false;\n', '\n', '    constructor(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol,\n', '        uint decimalUnits\n', '    ) public {\n', '        owner = msg.sender;\n', '        name = tokenName;\n', '        symbol = tokenSymbol; \n', '        decimals = decimalUnits;\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);\n', '        balanceOf[msg.sender] = totalSupply;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier isLock {\n', '        require(!lock);\n', '        _;\n', '    }\n', '    \n', '    function setLock(bool _lock) onlyOwner public{\n', '        lock = _lock;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', ' \n', '\n', '    function _transfer(address _from, address _to, uint _value) isLock internal {\n', '        require (_to != 0x0);\n', '        require (balanceOf[_from] >= _value);\n', '        require (balanceOf[_to] + _value > balanceOf[_to]);\n', '        require(!frozenAccount[_from]);\n', '        require(!frozenAccount[_to]);\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burn(uint256 _value) onlyOwner public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        balanceOf[msg.sender] -= _value;\n', '        totalSupply -= _value;\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {\n', '        require(balanceOf[_from] >= _value); \n', '        require(_value <= allowance[_from][msg.sender]); \n', '        balanceOf[_from] -= _value;\n', '        allowance[_from][msg.sender] -= _value;\n', '        totalSupply -= _value;\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '        uint256 _amount = mintedAmount * 10 ** uint256(decimals);\n', '        balanceOf[target] += _amount;\n', '        totalSupply += _amount;\n', '        emit Transfer(this, target, _amount);\n', '    }\n', '    \n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '\n', '    function transferBatch(address[] _to, uint256 _value) public returns (bool success) {\n', '        for (uint i=0; i<_to.length; i++) {\n', '            _transfer(msg.sender, _to[i], _value);\n', '        }\n', '        return true;\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', '\n', 'contract SafeMath {\n', '  function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b > 0);\n', '    uint256 c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', 'contract BankToken is SafeMath {\n', '    address public owner;\n', '    string public name;\n', '    string public symbol;\n', '    uint public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Burn(address indexed from, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    \n', '    mapping (address => bool) public frozenAccount;\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    bool lock = false;\n', '\n', '    constructor(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol,\n', '        uint decimalUnits\n', '    ) public {\n', '        owner = msg.sender;\n', '        name = tokenName;\n', '        symbol = tokenSymbol; \n', '        decimals = decimalUnits;\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);\n', '        balanceOf[msg.sender] = totalSupply;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier isLock {\n', '        require(!lock);\n', '        _;\n', '    }\n', '    \n', '    function setLock(bool _lock) onlyOwner public{\n', '        lock = _lock;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', ' \n', '\n', '    function _transfer(address _from, address _to, uint _value) isLock internal {\n', '        require (_to != 0x0);\n', '        require (balanceOf[_from] >= _value);\n', '        require (balanceOf[_to] + _value > balanceOf[_to]);\n', '        require(!frozenAccount[_from]);\n', '        require(!frozenAccount[_to]);\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burn(uint256 _value) onlyOwner public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        balanceOf[msg.sender] -= _value;\n', '        totalSupply -= _value;\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {\n', '        require(balanceOf[_from] >= _value); \n', '        require(_value <= allowance[_from][msg.sender]); \n', '        balanceOf[_from] -= _value;\n', '        allowance[_from][msg.sender] -= _value;\n', '        totalSupply -= _value;\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '        uint256 _amount = mintedAmount * 10 ** uint256(decimals);\n', '        balanceOf[target] += _amount;\n', '        totalSupply += _amount;\n', '        emit Transfer(this, target, _amount);\n', '    }\n', '    \n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '\n', '    function transferBatch(address[] _to, uint256 _value) public returns (bool success) {\n', '        for (uint i=0; i<_to.length; i++) {\n', '            _transfer(msg.sender, _to[i], _value);\n', '        }\n', '        return true;\n', '    }\n', '}']
