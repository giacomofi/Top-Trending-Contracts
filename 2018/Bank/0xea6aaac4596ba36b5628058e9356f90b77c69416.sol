['pragma solidity ^0.4.25;\n', '//---------------------------------------------------------------------------------------\n', "// 'Blocksol' contract\n", '// Deployed to : 0x82B48350C51a0888d8e73d0a300F91A7c0B7ad2d\n', '// Symbol      : BSO\n', '// Name        : Blocksol\n', '// Total supply: 5,000,000,000\n', '// Decimals    : 18\n', '// Copyright (c) 2018 Blockchain Solutions\n', '//---------------------------------------------------------------------------------------\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a / b;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', 'contract ForeignToken {\n', '    function balanceOf(address _owner) constant public returns (uint256);\n', '    function transfer(address _to, uint256 _value) public returns (bool);\n', '}\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public constant returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', 'contract Blocksol is ERC20 {\n', '    using SafeMath for uint256;\n', '    address owner = msg.sender;\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', "    string public constant name = 'Blocksol';\n", "    string public constant symbol = 'BSO';\n", '    uint public constant decimals = 18;\n', '    uint256 public totalSupply = 5000000000e18;\n', '    uint256 public totalDistributed =  2500000000e18;    \n', '    uint256 public constant MIN_CONTRIBUTION = 1 ether / 100;\n', '    uint256 public tokensPerEth = 10000000e18;\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Distr(address indexed to, uint256 amount);\n', '    event DistrFinished();\n', '    event Airdrop(address indexed _owner, uint _amount, uint _balance);\n', '    event TokensPerEthUpdated(uint _tokensPerEth);\n', '    event Burn(address indexed burner, uint256 value);\n', '    bool public distributionFinished = false;\n', '    modifier canDistr() {\n', '        require(!distributionFinished);\n', '        _;\n', '    }\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    constructor () public {\n', '        owner = msg.sender;\n', '        distr(owner, totalDistributed);\n', '    }\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '    function finishDistribution() onlyOwner canDistr public returns (bool) {\n', '        distributionFinished = true;\n', '        emit DistrFinished();\n', '        return true;\n', '    }\n', '    function distr(address _to, uint256 _amount) canDistr private returns (bool) {\n', '        totalDistributed = totalDistributed.add(_amount);        \n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Distr(_to, _amount);\n', '        emit Transfer(address(0), _to, _amount);\n', '        return true;\n', '    }\n', '    function doAirdrop(address _participant, uint _amount) internal {\n', '        require(_amount > 0);      \n', '        require(totalDistributed < totalSupply);\n', '        balances[_participant] = balances[_participant].add(_amount);\n', '        totalDistributed = totalDistributed.add(_amount);\n', '        if (totalDistributed >= totalSupply) {\n', '            distributionFinished = true;\n', '        }\n', '        emit Airdrop(_participant, _amount, balances[_participant]);\n', '        emit Transfer(address(0), _participant, _amount);\n', '    }\n', '    function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        \n', '        doAirdrop(_participant, _amount);\n', '    }\n', '    function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        \n', '        for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);\n', '    }\n', '    function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        \n', '        tokensPerEth = _tokensPerEth;\n', '        emit TokensPerEthUpdated(_tokensPerEth);\n', '    }\n', '    function () external payable {\n', '        getTokens();\n', '    }\n', '    function getTokens() payable canDistr  public {\n', '        uint256 tokens = 0;\n', '        uint256 bonus = 0;\n', '        require(msg.value >= MIN_CONTRIBUTION);\n', '        require(msg.value > 0);\n', '        tokens = tokensPerEth.mul(msg.value) / 1 ether;        \n', '        address investor = msg.sender;\n', '        \n', '        if (msg.value >= 1 ether) {\n', '            bonus = (tokens * 20) / 100;\n', '        }\n', '        if (tokens > 0) {\n', '            distr(investor, (tokens + bonus));\n', '        }\n', '        if (totalDistributed >= totalSupply) {\n', '            distributionFinished = true;\n', '        }\n', '    }\n', '    function balanceOf(address _owner) constant public returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '    modifier onlyPayloadSize(uint size) {\n', '        assert(msg.data.length >= size + 4);\n', '        _;\n', '    }\n', '    function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {\n', '        require(_to != address(0));\n', '        require(_amount <= balances[msg.sender]);\n', '        balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Transfer(msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '    function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {\n', '        require(_to != address(0));\n', '        require(_amount <= balances[_from]);\n', '        require(_amount <= allowed[_from][msg.sender]);\n', '        balances[_from] = balances[_from].sub(_amount);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Transfer(_from, _to, _amount);\n', '        return true;\n', '    }\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    function allowance(address _owner, address _spender) constant public returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    function getTokenBalance(address tokenAddress, address who) constant public returns (uint){\n', '        ForeignToken t = ForeignToken(tokenAddress);\n', '        uint bal = t.balanceOf(who);\n', '        return bal;\n', '    }\n', '    function withdraw() onlyOwner public {\n', '        address myAddress = this;\n', '        uint256 etherBalance = myAddress.balance;\n', '        owner.transfer(etherBalance);\n', '    }\n', '    function burn(uint256 _value) onlyOwner public {\n', '        require(_value <= balances[msg.sender]);\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        totalDistributed = totalDistributed.sub(_value);\n', '        emit Burn(burner, _value);\n', '    }\n', '    function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {\n', '        ForeignToken token = ForeignToken(_tokenContract);\n', '        uint256 amount = token.balanceOf(address(this));\n', '        return token.transfer(owner, amount);\n', '    }\n', '}']