['pragma solidity ^0.4.16;\n', '\n', '\n', 'contract ForeignToken {\n', '    function balanceOf(address _owner) public constant returns (uint256);\n', '    function transfer(address _to, uint256 _value) public returns (bool);\n', '}\n', '\n', '\n', 'contract ERC20Basic {\n', '\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '}\n', '\n', '\n', '\n', 'contract ERC20 is ERC20Basic {\n', '\n', '  function allowance(address owner, address spender) public constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '}\n', '\n', '\n', 'contract Learn is ERC20 {\n', '    \n', '    address owner = msg.sender;\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    \n', '    uint256 public totalSupply = 1000000000 * 10**8;\n', '\n', '    function name() public constant returns (string) { return "Learn"; }\n', '    function symbol() public constant returns (string) { return "LRN"; }\n', '    function decimals() public constant returns (uint8) { return 8; }\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    event DistrFinished();\n', '\n', '    bool public distributionFinished = false;\n', '\n', '    modifier canDistr() {\n', '    require(!distributionFinished);\n', '    _;\n', '    }\n', '\n', '    function Learn() public {\n', '        owner = msg.sender;\n', '        balances[msg.sender] = totalSupply;\n', '    }\n', '\n', '    modifier onlyOwner { \n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '\n', '    function getEthBalance(address _addr) constant public returns(uint) {\n', '    return _addr.balance;\n', '    }\n', '\n', '    function distributeLRN(address[] addresses, uint256 _value) onlyOwner canDistr public {\n', '         for (uint i = 0; i < addresses.length; i++) {\n', '             balances[owner] -= _value;\n', '             balances[addresses[i]] += _value;\n', '             Transfer(owner, addresses[i], _value);\n', '         }\n', '    }\n', '    \n', '    function balanceOf(address _owner) constant public returns (uint256) {\n', '\t return balances[_owner];\n', '    }\n', '\n', '    // mitigates the ERC20 short address attack\n', '    modifier onlyPayloadSize(uint size) {\n', '        assert(msg.data.length >= size + 4);\n', '        _;\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {\n', '\n', '         if (balances[msg.sender] >= _amount\n', '             && _amount > 0\n', '             && balances[_to] + _amount > balances[_to]) {\n', '             balances[msg.sender] -= _amount;\n', '             balances[_to] += _amount;\n', '             Transfer(msg.sender, _to, _amount);\n', '             return true;\n', '         } else {\n', '             return false;\n', '         }\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {\n', '\n', '         if (balances[_from] >= _amount\n', '             && allowed[_from][msg.sender] >= _amount\n', '             && _amount > 0\n', '             && balances[_to] + _amount > balances[_to]) {\n', '             balances[_from] -= _amount;\n', '             allowed[_from][msg.sender] -= _amount;\n', '             balances[_to] += _amount;\n', '             Transfer(_from, _to, _amount);\n', '             return true;\n', '         } else {\n', '            return false;\n', '         }\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        // mitigates the ERC20 spend/approval race condition\n', '        if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }\n', '        \n', '        allowed[msg.sender][_spender] = _value;\n', '        \n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) constant public returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function finishDistribution() onlyOwner public returns (bool) {\n', '    distributionFinished = true;\n', '    DistrFinished();\n', '    return true;\n', '    }\n', '\n', '    function withdrawForeignTokens(address _tokenContract) public returns (bool) {\n', '        require(msg.sender == owner);\n', '        ForeignToken token = ForeignToken(_tokenContract);\n', '        uint256 amount = token.balanceOf(address(this));\n', '        return token.transfer(owner, amount);\n', '    }\n', '\n', '\n', '}']
['pragma solidity ^0.4.16;\n', '\n', '\n', 'contract ForeignToken {\n', '    function balanceOf(address _owner) public constant returns (uint256);\n', '    function transfer(address _to, uint256 _value) public returns (bool);\n', '}\n', '\n', '\n', 'contract ERC20Basic {\n', '\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '}\n', '\n', '\n', '\n', 'contract ERC20 is ERC20Basic {\n', '\n', '  function allowance(address owner, address spender) public constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '}\n', '\n', '\n', 'contract Learn is ERC20 {\n', '    \n', '    address owner = msg.sender;\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    \n', '    uint256 public totalSupply = 1000000000 * 10**8;\n', '\n', '    function name() public constant returns (string) { return "Learn"; }\n', '    function symbol() public constant returns (string) { return "LRN"; }\n', '    function decimals() public constant returns (uint8) { return 8; }\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    event DistrFinished();\n', '\n', '    bool public distributionFinished = false;\n', '\n', '    modifier canDistr() {\n', '    require(!distributionFinished);\n', '    _;\n', '    }\n', '\n', '    function Learn() public {\n', '        owner = msg.sender;\n', '        balances[msg.sender] = totalSupply;\n', '    }\n', '\n', '    modifier onlyOwner { \n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '\n', '    function getEthBalance(address _addr) constant public returns(uint) {\n', '    return _addr.balance;\n', '    }\n', '\n', '    function distributeLRN(address[] addresses, uint256 _value) onlyOwner canDistr public {\n', '         for (uint i = 0; i < addresses.length; i++) {\n', '             balances[owner] -= _value;\n', '             balances[addresses[i]] += _value;\n', '             Transfer(owner, addresses[i], _value);\n', '         }\n', '    }\n', '    \n', '    function balanceOf(address _owner) constant public returns (uint256) {\n', '\t return balances[_owner];\n', '    }\n', '\n', '    // mitigates the ERC20 short address attack\n', '    modifier onlyPayloadSize(uint size) {\n', '        assert(msg.data.length >= size + 4);\n', '        _;\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {\n', '\n', '         if (balances[msg.sender] >= _amount\n', '             && _amount > 0\n', '             && balances[_to] + _amount > balances[_to]) {\n', '             balances[msg.sender] -= _amount;\n', '             balances[_to] += _amount;\n', '             Transfer(msg.sender, _to, _amount);\n', '             return true;\n', '         } else {\n', '             return false;\n', '         }\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {\n', '\n', '         if (balances[_from] >= _amount\n', '             && allowed[_from][msg.sender] >= _amount\n', '             && _amount > 0\n', '             && balances[_to] + _amount > balances[_to]) {\n', '             balances[_from] -= _amount;\n', '             allowed[_from][msg.sender] -= _amount;\n', '             balances[_to] += _amount;\n', '             Transfer(_from, _to, _amount);\n', '             return true;\n', '         } else {\n', '            return false;\n', '         }\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        // mitigates the ERC20 spend/approval race condition\n', '        if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }\n', '        \n', '        allowed[msg.sender][_spender] = _value;\n', '        \n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) constant public returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function finishDistribution() onlyOwner public returns (bool) {\n', '    distributionFinished = true;\n', '    DistrFinished();\n', '    return true;\n', '    }\n', '\n', '    function withdrawForeignTokens(address _tokenContract) public returns (bool) {\n', '        require(msg.sender == owner);\n', '        ForeignToken token = ForeignToken(_tokenContract);\n', '        uint256 amount = token.balanceOf(address(this));\n', '        return token.transfer(owner, amount);\n', '    }\n', '\n', '\n', '}']
