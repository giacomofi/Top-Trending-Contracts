['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a / b;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract AltcoinToken {\n', '    function balanceOf(address _owner) constant public returns (uint256);\n', '    function transfer(address _to, uint256 _value) public returns (bool);\n', '}\n', '\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public constant returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract MYE is ERC20 {\n', '    \n', '    using SafeMath for uint256;\n', '    address owner = msg.sender;\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;    \n', '\tmapping (address => bool) public blacklist;\n', '\n', '    string public constant name = "Myers Exchange";\t\t\t\t\t\t\n', '    string public constant symbol = "MYE";\t\t\t\t\t\t\t\n', '    uint public constant decimals = 8;    \t\t\t\t\t\t\t\n', '    uint256 public totalSupply = 10000000000e8;\n', '\t\t\n', '\tuint256 public valueToGive = 5000e8;\t\t\t\t\t\t\t\n', '\tuint256 public tokenPerETH = 10000000e8;\n', '\t\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\t\n', '\tuint256 public totalDistributed = 0;\n', '    uint256 public totalRemaining = totalSupply.sub(totalDistributed);\n', '    \n', '    event Distr(address indexed to, uint256 amount);\n', '    event DistrFinished();\n', '    \n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    bool public distributionFinished = false;\n', '    \n', '    modifier canDistr() {\n', '        require(!distributionFinished);\n', '        _;\n', '    }\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    function MYE () public {\n', '        owner = msg.sender;\n', '\t\tuint256 tokenwd = 3000000000e8;\n', '        distr(owner, tokenwd);\n', '    }\n', '    \n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '\n', '    function finishDistribution() onlyOwner canDistr public returns (bool) {\n', '        distributionFinished = true;\n', '        emit DistrFinished();\n', '        return true;\n', '    }\n', '    \n', '    function distr(address _to, uint256 _amount) canDistr private returns (bool) {\n', '        totalDistributed = totalDistributed.add(_amount);   \n', '\t\ttotalRemaining = totalRemaining.sub(_amount);\t\t\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Distr(_to, _amount);\n', '        emit Transfer(address(0), _to, _amount);\n', '\n', '        return true;\n', '    }\n', '           \n', '    function () external payable {\n', '\t\tgetTokens();\n', '\t}\n', '\t\n', '\tfunction getTokens() payable canDistr public {\n', '        address investor = msg.sender;\n', '\t\tuint256 invest = msg.value;\n', '        \n', '\t\tif(invest == 0){\n', '\t\t\trequire(valueToGive <= totalRemaining);\n', '\t\t\trequire(blacklist[investor] == false);\n', '\t\t\t\n', '\t\t\tuint256 toGive = valueToGive;\n', '\t\t\tvalueToGive = valueToGive.div(100000).mul(99998);\n', '\t\t\t\n', '\t\t\tdistr(investor, toGive);\n', '\t\t\t\n', '\t\t\tblacklist[investor] = true;\n', '\t\t}\n', '\t\t\n', '\t\tif(invest > 0){\n', '\t\t\tbuyToken(investor, invest);\n', '\t\t}\n', '    }\n', '\t\n', '\tfunction buyToken(address _investor, uint256 _invest) canDistr public {\n', '\t\tuint256 toGive = tokenPerETH.mul(_invest) / 1 ether;\n', '\t\tuint256 bonus = 0;\n', '\t\t\n', '\t\tif(_invest >= 1 ether/10 && _invest < 1 ether){ //if 0,1\n', '\t\t\tbonus = toGive*20/100;\n', '\t\t}\t\t\n', '\t\tif(_invest >= 1 ether && _invest < 2 ether){ //if 1\n', '\t\t\tbonus = toGive*50/100;\n', '\t\t}\t\t\n', '\t\tif(_invest >= 2 ether){ //if 1\n', '\t\t\tbonus = toGive*75/100;\n', '\t\t}\n', '\t\t\n', '\t\tuint256 totalgive = bonus+toGive;\n', '\t\t\n', '\t\trequire(totalgive <= totalRemaining);\n', '\t\t\n', '\t\tdistr(_investor, totalgive);\n', '\t}\n', '\t\n', '    function balanceOf(address _owner) constant public returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    modifier onlyPayloadSize(uint size) {\n', '        assert(msg.data.length >= size + 4);\n', '        _;\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {\n', '\n', '        require(_to != address(0));\n', '        require(_amount <= balances[msg.sender]);\n', '        \n', '        balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Transfer(msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {\n', '        require(_to != address(0));\n', '        require(_amount <= balances[_from]);\n', '        require(_amount <= allowed[_from][msg.sender]);\n', '        \n', '        balances[_from] = balances[_from].sub(_amount);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Transfer(_from, _to, _amount);\n', '        return true;\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) constant public returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '    function getTokenBalance(address tokenAddress, address who) constant public returns (uint){\n', '        AltcoinToken t = AltcoinToken(tokenAddress);\n', '        uint bal = t.balanceOf(who);\n', '        return bal;\n', '    }\n', '    \n', '    function withdraw() onlyOwner public {\n', '        address myAddress = this;\n', '        uint256 etherBalance = myAddress.balance;\n', '        owner.transfer(etherBalance);\n', '    }\n', '    \n', '    function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {\n', '        AltcoinToken token = AltcoinToken(_tokenContract);\n', '        uint256 amount = token.balanceOf(address(this));\n', '        return token.transfer(owner, amount);\n', '    }\n', '\t\n', '\tfunction burn(uint256 _value) onlyOwner public {\n', '        require(_value <= balances[msg.sender]);\n', '        \n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        totalDistributed = totalDistributed.sub(_value);\n', '        emit Burn(burner, _value);\n', '    }\n', '\t\n', '\tfunction burnFrom(uint256 _value, address _burner) onlyOwner public {\n', '        require(_value <= balances[_burner]);\n', '        \n', '        balances[_burner] = balances[_burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        totalDistributed = totalDistributed.sub(_value);\n', '        emit Burn(_burner, _value);\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a / b;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract AltcoinToken {\n', '    function balanceOf(address _owner) constant public returns (uint256);\n', '    function transfer(address _to, uint256 _value) public returns (bool);\n', '}\n', '\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public constant returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract MYE is ERC20 {\n', '    \n', '    using SafeMath for uint256;\n', '    address owner = msg.sender;\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;    \n', '\tmapping (address => bool) public blacklist;\n', '\n', '    string public constant name = "Myers Exchange";\t\t\t\t\t\t\n', '    string public constant symbol = "MYE";\t\t\t\t\t\t\t\n', '    uint public constant decimals = 8;    \t\t\t\t\t\t\t\n', '    uint256 public totalSupply = 10000000000e8;\n', '\t\t\n', '\tuint256 public valueToGive = 5000e8;\t\t\t\t\t\t\t\n', '\tuint256 public tokenPerETH = 10000000e8;\n', '\t\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\t\n', '\tuint256 public totalDistributed = 0;\n', '    uint256 public totalRemaining = totalSupply.sub(totalDistributed);\n', '    \n', '    event Distr(address indexed to, uint256 amount);\n', '    event DistrFinished();\n', '    \n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    bool public distributionFinished = false;\n', '    \n', '    modifier canDistr() {\n', '        require(!distributionFinished);\n', '        _;\n', '    }\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    function MYE () public {\n', '        owner = msg.sender;\n', '\t\tuint256 tokenwd = 3000000000e8;\n', '        distr(owner, tokenwd);\n', '    }\n', '    \n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '\n', '    function finishDistribution() onlyOwner canDistr public returns (bool) {\n', '        distributionFinished = true;\n', '        emit DistrFinished();\n', '        return true;\n', '    }\n', '    \n', '    function distr(address _to, uint256 _amount) canDistr private returns (bool) {\n', '        totalDistributed = totalDistributed.add(_amount);   \n', '\t\ttotalRemaining = totalRemaining.sub(_amount);\t\t\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Distr(_to, _amount);\n', '        emit Transfer(address(0), _to, _amount);\n', '\n', '        return true;\n', '    }\n', '           \n', '    function () external payable {\n', '\t\tgetTokens();\n', '\t}\n', '\t\n', '\tfunction getTokens() payable canDistr public {\n', '        address investor = msg.sender;\n', '\t\tuint256 invest = msg.value;\n', '        \n', '\t\tif(invest == 0){\n', '\t\t\trequire(valueToGive <= totalRemaining);\n', '\t\t\trequire(blacklist[investor] == false);\n', '\t\t\t\n', '\t\t\tuint256 toGive = valueToGive;\n', '\t\t\tvalueToGive = valueToGive.div(100000).mul(99998);\n', '\t\t\t\n', '\t\t\tdistr(investor, toGive);\n', '\t\t\t\n', '\t\t\tblacklist[investor] = true;\n', '\t\t}\n', '\t\t\n', '\t\tif(invest > 0){\n', '\t\t\tbuyToken(investor, invest);\n', '\t\t}\n', '    }\n', '\t\n', '\tfunction buyToken(address _investor, uint256 _invest) canDistr public {\n', '\t\tuint256 toGive = tokenPerETH.mul(_invest) / 1 ether;\n', '\t\tuint256 bonus = 0;\n', '\t\t\n', '\t\tif(_invest >= 1 ether/10 && _invest < 1 ether){ //if 0,1\n', '\t\t\tbonus = toGive*20/100;\n', '\t\t}\t\t\n', '\t\tif(_invest >= 1 ether && _invest < 2 ether){ //if 1\n', '\t\t\tbonus = toGive*50/100;\n', '\t\t}\t\t\n', '\t\tif(_invest >= 2 ether){ //if 1\n', '\t\t\tbonus = toGive*75/100;\n', '\t\t}\n', '\t\t\n', '\t\tuint256 totalgive = bonus+toGive;\n', '\t\t\n', '\t\trequire(totalgive <= totalRemaining);\n', '\t\t\n', '\t\tdistr(_investor, totalgive);\n', '\t}\n', '\t\n', '    function balanceOf(address _owner) constant public returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    modifier onlyPayloadSize(uint size) {\n', '        assert(msg.data.length >= size + 4);\n', '        _;\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {\n', '\n', '        require(_to != address(0));\n', '        require(_amount <= balances[msg.sender]);\n', '        \n', '        balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Transfer(msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {\n', '        require(_to != address(0));\n', '        require(_amount <= balances[_from]);\n', '        require(_amount <= allowed[_from][msg.sender]);\n', '        \n', '        balances[_from] = balances[_from].sub(_amount);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Transfer(_from, _to, _amount);\n', '        return true;\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) constant public returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '    function getTokenBalance(address tokenAddress, address who) constant public returns (uint){\n', '        AltcoinToken t = AltcoinToken(tokenAddress);\n', '        uint bal = t.balanceOf(who);\n', '        return bal;\n', '    }\n', '    \n', '    function withdraw() onlyOwner public {\n', '        address myAddress = this;\n', '        uint256 etherBalance = myAddress.balance;\n', '        owner.transfer(etherBalance);\n', '    }\n', '    \n', '    function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {\n', '        AltcoinToken token = AltcoinToken(_tokenContract);\n', '        uint256 amount = token.balanceOf(address(this));\n', '        return token.transfer(owner, amount);\n', '    }\n', '\t\n', '\tfunction burn(uint256 _value) onlyOwner public {\n', '        require(_value <= balances[msg.sender]);\n', '        \n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        totalDistributed = totalDistributed.sub(_value);\n', '        emit Burn(burner, _value);\n', '    }\n', '\t\n', '\tfunction burnFrom(uint256 _value, address _burner) onlyOwner public {\n', '        require(_value <= balances[_burner]);\n', '        \n', '        balances[_burner] = balances[_burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        totalDistributed = totalDistributed.sub(_value);\n', '        emit Burn(_burner, _value);\n', '    }\n', '}']
