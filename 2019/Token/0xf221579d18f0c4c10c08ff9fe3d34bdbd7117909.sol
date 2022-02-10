['pragma solidity ^0.4.20;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public constant returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract AtomCirculationCoin is ERC20 {\n', '    \n', '    using SafeMath for uint256; \n', '    address owner1 = msg.sender; \n', '    address owner2; \n', '\n', '    mapping (address => uint256) balances; \n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    mapping (address => uint256) times;\n', '    mapping (address => mapping (uint256 => uint256)) dorpnum;\n', '    mapping (address => mapping (uint256 => uint256)) dorptime;\n', '    mapping (address => mapping (uint256 => uint256)) freeday;\n', '    \n', '    \n', '    mapping (address => bool) public frozenAccount;\n', '    mapping (address => bool) public airlist;\n', '\n', '    string public constant name = "AtomCirculationCoin";\n', '    string public constant symbol = "ATMCC";\n', '    uint public constant decimals = 8;\n', '    uint256 _Rate = 10 ** decimals; \n', '    uint256 public totalSupply = 10000000000 * _Rate;\n', '\n', '    uint256 public totalDistributed = 0;\n', '    uint256 public totalRemaining = totalSupply.sub(totalDistributed);\n', '    uint256 public value;\n', '    uint256 public _per = 1;\n', '    bool public distributionClosed = true;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event FrozenFunds(address target, bool frozen);\n', '    event Distr(address indexed to, uint256 amount);\n', '    event DistrClosed(bool Closed);\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner1 || msg.sender == owner2);\n', '        _;\n', '    }\n', '\n', '    modifier onlyPayloadSize(uint size) {\n', '        assert(msg.data.length >= size + 4);\n', '        _;\n', '    }\n', '\n', '     function AtomCirculationCoin (address _owner) public {\n', '        owner1 = msg.sender;\n', '        owner2 = _owner;\n', '        value = 200 * _Rate;\n', '    }\n', '     function nowInSeconds() returns (uint256){\n', '        return now;\n', '    }\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        if (newOwner != address(0) && newOwner != owner1 && newOwner != owner2) {\n', '            if(msg.sender == owner1){\n', '             owner1 = newOwner;   \n', '            }\n', '            if(msg.sender == owner2){\n', '             owner2 = newOwner;   \n', '            }\n', '        }\n', '    }\n', '\n', '    function closeDistribution(bool Closed) onlyOwner public returns (bool) {\n', '        distributionClosed = Closed;\n', '        DistrClosed(Closed);\n', '        return true;\n', '    }\n', '\n', '   function Set_per(uint256 per) onlyOwner public returns (bool) {\n', '   require(per <= 100 && per >= 1);\n', '\n', '        _per  = per;\n', '        return true;\n', '    }\n', '\n', '    function distr(address _to, uint256 _amount, uint256 _freeday) private returns (bool) {\n', '         if (_amount > totalRemaining) {\n', '            _amount = totalRemaining;\n', '        }\n', '        totalDistributed = totalDistributed.add(_amount);\n', '        totalRemaining = totalRemaining.sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        if (_freeday>0) {times[_to] += 1;\n', '        dorptime[_to][times[_to]] = now;\n', '        freeday[_to][times[_to]] = _freeday * 1 days;\n', '        dorpnum[_to][times[_to]] = _amount;}\n', '\n', '        if (totalDistributed >= totalSupply) {\n', '            distributionClosed = true;\n', '        }        \n', '        Distr(_to, _amount);\n', '        Transfer(address(0), _to, _amount);\n', '        return true;\n', '        \n', '\n', '    }\n', ' \n', '\n', '    function distribute(address[] addresses, uint256[] amounts, uint256 _freeday) onlyOwner public {\n', '\n', '        require(addresses.length <= 255);\n', '        require(addresses.length == amounts.length);\n', '        \n', '        for (uint8 i = 0; i < addresses.length; i++) {\n', '            require(amounts[i] * _Rate <= totalRemaining);\n', '            distr(addresses[i], amounts[i] * _Rate, _freeday);\n', '        }\n', '    }\n', '\n', '    function () external payable {\n', '            getTokens();\n', '     }\n', '\n', '    function getTokens() payable public {\n', '        if(!distributionClosed){\n', '        if (value > totalRemaining) {\n', '            value = totalRemaining;\n', '        }\n', '        address investor = msg.sender;\n', '        uint256 toGive = value;\n', '        require(value <= totalRemaining);\n', '        \n', '        if(!airlist[investor]){\n', '        totalDistributed = totalDistributed.add(toGive);\n', '        totalRemaining = totalRemaining.sub(toGive);\n', '        balances[investor] = balances[investor].add(toGive);\n', '        times[investor] += 1;\n', '        dorptime[investor][times[investor]] = now;\n', '        freeday[investor][times[investor]] = 180 * 1 days;\n', '        dorpnum[investor][times[investor]] = toGive;\n', '        airlist[investor] = true;\n', '        if (totalDistributed >= totalSupply) {\n', '            distributionClosed = true;\n', '        }        \n', '        Distr(investor, toGive);\n', '        Transfer(address(0), investor, toGive);\n', '        }\n', '        }\n', '    }\n', '    //\n', '    function freeze(address[] addresses,bool locked) onlyOwner public {\n', '        \n', '        require(addresses.length <= 255);\n', '        \n', '        for (uint i = 0; i < addresses.length; i++) {\n', '            freezeAccount(addresses[i], locked);\n', '        }\n', '    }\n', '    \n', '    function freezeAccount(address target, bool B) private {\n', '        frozenAccount[target] = B;\n', '        FrozenFunds(target, B);\n', '    }\n', '\n', '    function balanceOf(address _owner) constant public returns (uint256) {\n', '      if(!distributionClosed && !airlist[_owner]){\n', '       return balances[_owner] + value;\n', '       }\n', '\t    return balances[_owner];\n', '    }\n', '//??????????????\n', '    function lockOf(address _owner) constant public returns (uint256) {\n', '    uint locknum = 0;\n', '    for (uint8 i = 1; i < times[_owner] + 1; i++){\n', '      if(now < dorptime[_owner][i] + freeday[_owner][i] + 1* 1 days){\n', '            locknum += dorpnum[_owner][i];\n', '        }\n', '       else{\n', '            if(now < dorptime[_owner][i] + freeday[_owner][i] + 100/_per* 1 days){\n', '               locknum += ((now - dorptime[_owner][i] - freeday[_owner][i] )/(1 * 1 days)*dorpnum[_owner][i]*_per/100);\n', '              }\n', '              else{\n', '                 locknum += 0;\n', '              }\n', '        }\n', '    }\n', '\t    return locknum;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {\n', '\n', '        require(_to != address(0));\n', '        require(_amount <= (balances[msg.sender] - lockOf(msg.sender)));\n', '        require(!frozenAccount[msg.sender]);                     \n', '        require(!frozenAccount[_to]);                      \n', '        balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        Transfer(msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '  \n', '    function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {\n', '\n', '        require(_to != address(0));\n', '        require(_amount <= balances[_from]);\n', '        require(_amount <= (allowed[_from][msg.sender] - lockOf(msg.sender)));\n', '\n', '        \n', '        balances[_from] = balances[_from].sub(_amount);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        Transfer(_from, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant public returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function withdraw() onlyOwner public {\n', '        uint256 etherBalance = this.balance;\n', '        address owner = msg.sender;\n', '        owner.transfer(etherBalance);\n', '    }\n', '}']