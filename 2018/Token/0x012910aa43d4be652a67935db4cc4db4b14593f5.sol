['pragma solidity ^0.4.25;\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a / b;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract AltcoinToken {\n', '    function balanceOf(address _owner) constant public returns (uint256);\n', '    function transfer(address _to, uint256 _value) public returns (bool);\n', '}\n', '\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public constant returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract AllyICO is ERC20 {\n', '    \n', '    using SafeMath for uint256;\n', '    address owner = msg.sender;\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;    \n', '\n', '    address _tokenContract = 0x03e2cE0C0B99998e6906B90Ab6F9eac0deFAFf16;\n', '    AltcoinToken cddtoken = AltcoinToken(_tokenContract);\n', '\n', '    string public constant name = "AllyICO";\n', '    string public constant symbol = "ICO";\n', '    uint public constant decimals = 8;\n', '    uint256 public totalSupply = 12000000000e8;\n', '    uint256 public totalDistributed = 0;        \n', '    uint256 public tokensPerEth = 20000000e8;\n', '    uint256 public constant minContribution = 1 ether / 100; // 0.01 Ether\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    \n', '    event Distr(address indexed to, uint256 amount);\n', '    event DistrFinished();\n', '\n', '    event TokensPerEthUpdated(uint _tokensPerEth);\n', '\n', '    bool public distributionFinished = false;\n', '    \n', '    modifier canDistr() {\n', '        require(!distributionFinished);\n', '        _;\n', '    }\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    function AllyICO () public {\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '\n', '    function finishDistribution() onlyOwner canDistr public returns (bool) {\n', '        distributionFinished = true;\n', '        emit DistrFinished();\n', '        return true;\n', '    }\n', '    \n', '    function distr(address _to, uint256 _amount) canDistr private returns (bool) {\n', '        totalDistributed = totalDistributed.add(_amount);        \n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Distr(_to, _amount);\n', '        emit Transfer(address(0), _to, _amount);\n', '\n', '        return true;\n', '    }\n', '\n', '    function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        \n', '        tokensPerEth = _tokensPerEth;\n', '        emit TokensPerEthUpdated(_tokensPerEth);\n', '    }\n', '           \n', '    function () external payable {\n', '        sendTokens();\n', '    }\n', '     \n', '    function sendTokens() private returns (bool) {\n', '        uint256 tokens = 0;\n', '\n', '        require( msg.value >= minContribution );\n', '\n', '        tokens = tokensPerEth.mul(msg.value) / 1 ether;        \n', '        address investor = msg.sender;\n', '\n', '        sendICO(cddtoken, tokens, investor);\n', '    }\n', '\n', '    function balanceOf(address _owner) constant public returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    // mitigates the ERC20 short address attack\n', '    modifier onlyPayloadSize(uint size) {\n', '        assert(msg.data.length >= size + 4);\n', '        _;\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {\n', '\n', '        require(_to != address(0));\n', '        require(_amount <= balances[msg.sender]);\n', '        \n', '        balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Transfer(msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {\n', '\n', '        require(_to != address(0));\n', '        require(_amount <= balances[_from]);\n', '        require(_amount <= allowed[_from][msg.sender]);\n', '        \n', '        balances[_from] = balances[_from].sub(_amount);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Transfer(_from, _to, _amount);\n', '        return true;\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        // mitigates the ERC20 spend/approval race condition\n', '        if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) constant public returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '    function getTokenBalance(address tokenAddress, address who) constant public returns (uint){\n', '        AltcoinToken t = AltcoinToken(tokenAddress);\n', '        uint bal = t.balanceOf(who);\n', '        return bal;\n', '    }\n', '    \n', '    function withdraw() onlyOwner public {\n', '        address myAddress = this;\n', '        uint256 etherBalance = myAddress.balance;\n', '        owner.transfer(etherBalance);\n', '    }\n', '    \n', '    function withdrawAltcoinTokens(address anycontract) onlyOwner public returns (bool) {\n', '        AltcoinToken anytoken = AltcoinToken(anycontract);\n', '        uint256 amount = anytoken.balanceOf(address(this));\n', '        return anytoken.transfer(owner, amount);\n', '    }\n', '    \n', '    function sendICO(address contrato, uint256 amount, address who) private returns (bool) {\n', '        AltcoinToken alttoken = AltcoinToken(contrato);\n', '        return alttoken.transfer(who, amount);\n', '    }\n', '}']
['pragma solidity ^0.4.25;\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a / b;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract AltcoinToken {\n', '    function balanceOf(address _owner) constant public returns (uint256);\n', '    function transfer(address _to, uint256 _value) public returns (bool);\n', '}\n', '\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public constant returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract AllyICO is ERC20 {\n', '    \n', '    using SafeMath for uint256;\n', '    address owner = msg.sender;\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;    \n', '\n', '    address _tokenContract = 0x03e2cE0C0B99998e6906B90Ab6F9eac0deFAFf16;\n', '    AltcoinToken cddtoken = AltcoinToken(_tokenContract);\n', '\n', '    string public constant name = "AllyICO";\n', '    string public constant symbol = "ICO";\n', '    uint public constant decimals = 8;\n', '    uint256 public totalSupply = 12000000000e8;\n', '    uint256 public totalDistributed = 0;        \n', '    uint256 public tokensPerEth = 20000000e8;\n', '    uint256 public constant minContribution = 1 ether / 100; // 0.01 Ether\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    \n', '    event Distr(address indexed to, uint256 amount);\n', '    event DistrFinished();\n', '\n', '    event TokensPerEthUpdated(uint _tokensPerEth);\n', '\n', '    bool public distributionFinished = false;\n', '    \n', '    modifier canDistr() {\n', '        require(!distributionFinished);\n', '        _;\n', '    }\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    function AllyICO () public {\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '\n', '    function finishDistribution() onlyOwner canDistr public returns (bool) {\n', '        distributionFinished = true;\n', '        emit DistrFinished();\n', '        return true;\n', '    }\n', '    \n', '    function distr(address _to, uint256 _amount) canDistr private returns (bool) {\n', '        totalDistributed = totalDistributed.add(_amount);        \n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Distr(_to, _amount);\n', '        emit Transfer(address(0), _to, _amount);\n', '\n', '        return true;\n', '    }\n', '\n', '    function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        \n', '        tokensPerEth = _tokensPerEth;\n', '        emit TokensPerEthUpdated(_tokensPerEth);\n', '    }\n', '           \n', '    function () external payable {\n', '        sendTokens();\n', '    }\n', '     \n', '    function sendTokens() private returns (bool) {\n', '        uint256 tokens = 0;\n', '\n', '        require( msg.value >= minContribution );\n', '\n', '        tokens = tokensPerEth.mul(msg.value) / 1 ether;        \n', '        address investor = msg.sender;\n', '\n', '        sendICO(cddtoken, tokens, investor);\n', '    }\n', '\n', '    function balanceOf(address _owner) constant public returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    // mitigates the ERC20 short address attack\n', '    modifier onlyPayloadSize(uint size) {\n', '        assert(msg.data.length >= size + 4);\n', '        _;\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {\n', '\n', '        require(_to != address(0));\n', '        require(_amount <= balances[msg.sender]);\n', '        \n', '        balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Transfer(msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {\n', '\n', '        require(_to != address(0));\n', '        require(_amount <= balances[_from]);\n', '        require(_amount <= allowed[_from][msg.sender]);\n', '        \n', '        balances[_from] = balances[_from].sub(_amount);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Transfer(_from, _to, _amount);\n', '        return true;\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        // mitigates the ERC20 spend/approval race condition\n', '        if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) constant public returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '    function getTokenBalance(address tokenAddress, address who) constant public returns (uint){\n', '        AltcoinToken t = AltcoinToken(tokenAddress);\n', '        uint bal = t.balanceOf(who);\n', '        return bal;\n', '    }\n', '    \n', '    function withdraw() onlyOwner public {\n', '        address myAddress = this;\n', '        uint256 etherBalance = myAddress.balance;\n', '        owner.transfer(etherBalance);\n', '    }\n', '    \n', '    function withdrawAltcoinTokens(address anycontract) onlyOwner public returns (bool) {\n', '        AltcoinToken anytoken = AltcoinToken(anycontract);\n', '        uint256 amount = anytoken.balanceOf(address(this));\n', '        return anytoken.transfer(owner, amount);\n', '    }\n', '    \n', '    function sendICO(address contrato, uint256 amount, address who) private returns (bool) {\n', '        AltcoinToken alttoken = AltcoinToken(contrato);\n', '        return alttoken.transfer(who, amount);\n', '    }\n', '}']
