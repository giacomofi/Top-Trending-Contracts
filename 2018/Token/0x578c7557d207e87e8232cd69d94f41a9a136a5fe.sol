['pragma solidity ^0.4.21;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public constant returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '    function transferFrom(address from, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract DQCoin is ERC20 {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    address public owner;\n', '\n', '    mapping (address => uint256) balances;\n', '\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    string public name = "DaQianCoin";\n', '    string public constant symbol = "DQC";\n', '    uint public constant decimals = 18;\n', '    bool public stopped;\n', '    \n', '    modifier stoppable {\n', '        assert(!stopped);\n', '        _;\n', '    }\n', '    \n', '    uint256 public totalSupply = 24000000000*(10**18);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event LOCK(address indexed _owner, uint256 _value);\n', '\n', '    mapping (address => uint256) public lockAddress;\n', '    \n', '    modifier lock(address _add){\n', '        require(_add != address(0));\n', '        uint256 releaseTime = lockAddress[_add];\n', '        if(releaseTime > 0){\n', '             require(block.timestamp >= releaseTime);\n', '              _;\n', '        }else{\n', '             _;\n', '        }\n', '    }\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    function DQCoin() public {\n', '        owner = msg.sender;\n', '        balances[msg.sender] = totalSupply;\n', '    }\n', '\n', '    function stop() onlyOwner public {\n', '        stopped = true;\n', '    }\n', '    function start() onlyOwner public {\n', '        stopped = false;\n', '    }\n', '    \n', '    function lockTime(address _to,uint256 _value) onlyOwner public {\n', '       if(_value > block.timestamp){\n', '         lockAddress[_to] = _value;\n', '         emit LOCK(_to, _value);\n', '       }\n', '    }\n', '    \n', '    function lockOf(address _owner) constant public returns (uint256) {\n', '\t    return lockAddress[_owner];\n', '    }\n', '    \n', '    function transferOwnership(address _newOwner) onlyOwner public {\n', '        if (_newOwner != address(0)) {\n', '            owner = _newOwner;\n', '        }\n', '    }\n', '    \n', '    function () public payable {\n', '        address myAddress = this;\n', '        emit Transfer(msg.sender, myAddress, msg.value);\n', '     }\n', '\n', '    function balanceOf(address _owner) constant public returns (uint256) {\n', '\t    return balances[_owner];\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _amount) stoppable lock(msg.sender) public returns (bool success) {\n', '        require(_to != address(0));\n', '        require(_amount <= balances[msg.sender]);\n', '        \n', '        balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Transfer(msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address _from, uint256 _amount) stoppable lock(_from) public returns (bool success) {\n', '        require(_amount <= balances[_from]);\n', '        require(_amount <= allowed[_from][msg.sender]);\n', '        \n', '        balances[_from] = balances[_from].sub(_amount);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);\n', '        balances[msg.sender] = balances[msg.sender].add(_amount);\n', '        emit Transfer(_from, msg.sender, _amount);\n', '        return true;\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _value) stoppable lock(_spender) public returns (bool success) {\n', '        if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender)  constant public returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '    function withdraw() onlyOwner public {\n', '        address myAddress = this;\n', '        uint256 etherBalance = myAddress.balance;\n', '        owner.transfer(etherBalance);\n', '    }\n', '    \n', '    function kill() onlyOwner public {\n', '       selfdestruct(msg.sender);\n', '    }\n', '    \n', '    function setName(string _name) onlyOwner public  {\n', '        name = _name;\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.21;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public constant returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '    function transferFrom(address from, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract DQCoin is ERC20 {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    address public owner;\n', '\n', '    mapping (address => uint256) balances;\n', '\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    string public name = "DaQianCoin";\n', '    string public constant symbol = "DQC";\n', '    uint public constant decimals = 18;\n', '    bool public stopped;\n', '    \n', '    modifier stoppable {\n', '        assert(!stopped);\n', '        _;\n', '    }\n', '    \n', '    uint256 public totalSupply = 24000000000*(10**18);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event LOCK(address indexed _owner, uint256 _value);\n', '\n', '    mapping (address => uint256) public lockAddress;\n', '    \n', '    modifier lock(address _add){\n', '        require(_add != address(0));\n', '        uint256 releaseTime = lockAddress[_add];\n', '        if(releaseTime > 0){\n', '             require(block.timestamp >= releaseTime);\n', '              _;\n', '        }else{\n', '             _;\n', '        }\n', '    }\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    function DQCoin() public {\n', '        owner = msg.sender;\n', '        balances[msg.sender] = totalSupply;\n', '    }\n', '\n', '    function stop() onlyOwner public {\n', '        stopped = true;\n', '    }\n', '    function start() onlyOwner public {\n', '        stopped = false;\n', '    }\n', '    \n', '    function lockTime(address _to,uint256 _value) onlyOwner public {\n', '       if(_value > block.timestamp){\n', '         lockAddress[_to] = _value;\n', '         emit LOCK(_to, _value);\n', '       }\n', '    }\n', '    \n', '    function lockOf(address _owner) constant public returns (uint256) {\n', '\t    return lockAddress[_owner];\n', '    }\n', '    \n', '    function transferOwnership(address _newOwner) onlyOwner public {\n', '        if (_newOwner != address(0)) {\n', '            owner = _newOwner;\n', '        }\n', '    }\n', '    \n', '    function () public payable {\n', '        address myAddress = this;\n', '        emit Transfer(msg.sender, myAddress, msg.value);\n', '     }\n', '\n', '    function balanceOf(address _owner) constant public returns (uint256) {\n', '\t    return balances[_owner];\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _amount) stoppable lock(msg.sender) public returns (bool success) {\n', '        require(_to != address(0));\n', '        require(_amount <= balances[msg.sender]);\n', '        \n', '        balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Transfer(msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address _from, uint256 _amount) stoppable lock(_from) public returns (bool success) {\n', '        require(_amount <= balances[_from]);\n', '        require(_amount <= allowed[_from][msg.sender]);\n', '        \n', '        balances[_from] = balances[_from].sub(_amount);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);\n', '        balances[msg.sender] = balances[msg.sender].add(_amount);\n', '        emit Transfer(_from, msg.sender, _amount);\n', '        return true;\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _value) stoppable lock(_spender) public returns (bool success) {\n', '        if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender)  constant public returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '    function withdraw() onlyOwner public {\n', '        address myAddress = this;\n', '        uint256 etherBalance = myAddress.balance;\n', '        owner.transfer(etherBalance);\n', '    }\n', '    \n', '    function kill() onlyOwner public {\n', '       selfdestruct(msg.sender);\n', '    }\n', '    \n', '    function setName(string _name) onlyOwner public  {\n', '        name = _name;\n', '    }\n', '\n', '}']
