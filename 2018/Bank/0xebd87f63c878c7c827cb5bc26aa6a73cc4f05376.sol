['// Twitter: @HealthAidToken\n', '// Github: @HealthAidToken\n', '// Telegram of developer: @roby_manuel\n', '\n', 'pragma solidity ^0.4.25;\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a / b;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract AltcoinToken {\n', '    function balanceOf(address _owner) constant public returns (uint256);\n', '    function transfer(address _to, uint256 _value) public returns (bool);\n', '}\n', '\n', 'contract ERC20Basic {\n', '    function balanceOf(address who) public constant returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '}\n', '\n', 'contract InvestHAT2 is ERC20 {\n', '    \n', '    using SafeMath for uint256;\n', '    address owner = msg.sender;\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;    \n', '\n', '    address _tokenContract = 0xe6465c1909d5721c3d573fab1198182e4309b1a1;\n', '    AltcoinToken thetoken = AltcoinToken(_tokenContract);\n', '\n', '    uint256 public tokensPerEth = 25000000e8;\n', '    uint256 public tokensPerAirdrop = 500e8;\n', '    uint256 public airdropcounter = 0;\n', '    uint256 public constant minContribution = 1 ether / 100; // 0.01 Ether\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    event Distr(address indexed to, uint256 amount);\n', '\n', '    event TokensPerEthUpdated(uint _tokensPerEth);\n', '    \n', '    event TokensPerAirdropUpdated(uint _tokensPerEth);\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    function InvestHAT2 () public {\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '\n', '    function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        \n', '        tokensPerEth = _tokensPerEth;\n', '        emit TokensPerEthUpdated(_tokensPerEth);\n', '    }\n', '    \n', '    function updateTokensPerAirdrop(uint _tokensPerAirdrop) public onlyOwner {        \n', '        tokensPerAirdrop = _tokensPerAirdrop;\n', '        emit TokensPerAirdropUpdated(_tokensPerAirdrop);\n', '    }\n', '\n', '           \n', '    function () external payable {\n', '        if ( msg.value >= minContribution) {\n', '           sendTokens();\n', '        }\n', '        else if ( msg.value < minContribution) {\n', '           airdropcounter = airdropcounter + 1;\n', '           sendAirdrop();\n', '        }\n', '    }\n', '     \n', '    function sendTokens() private returns (bool) {\n', '        uint256 tokens = 0;\n', '\n', '        require( msg.value >= minContribution );\n', '\n', '        tokens = tokensPerEth.mul(msg.value) / 1 ether;        \n', '        address investor = msg.sender;\n', '\n', '        sendtokens(thetoken, tokens, investor);\n', '        address myAddress = this;\n', '        uint256 etherBalance = myAddress.balance;\n', '        owner.transfer(etherBalance);\n', '    }\n', '    \n', '    function sendAirdrop() private returns (bool) {\n', '        uint256 tokens = 0;\n', '        \n', '        require( airdropcounter < 1000 );\n', '\n', '        tokens = tokensPerAirdrop;        \n', '        address holder = msg.sender;\n', '        sendtokens(thetoken, tokens, holder);\n', '    }\n', '\n', '    function balanceOf(address _owner) constant public returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    // mitigates the ERC20 short address attack\n', '    modifier onlyPayloadSize(uint size) {\n', '        assert(msg.data.length >= size + 4);\n', '        _;\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {\n', '\n', '        require(_to != address(0));\n', '        require(_amount <= balances[msg.sender]);\n', '        \n', '        balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Transfer(msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {\n', '\n', '        require(_to != address(0));\n', '        require(_amount <= balances[_from]);\n', '        require(_amount <= allowed[_from][msg.sender]);\n', '        \n', '        balances[_from] = balances[_from].sub(_amount);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Transfer(_from, _to, _amount);\n', '        return true;\n', '    }\n', '    \n', '    function getTokenBalance(address tokenAddress, address who) constant public returns (uint){\n', '        AltcoinToken t = AltcoinToken(tokenAddress);\n', '        uint bal = t.balanceOf(who);\n', '        return bal;\n', '    }\n', '    \n', '    function withdraw() onlyOwner public {\n', '        address myAddress = this;\n', '        uint256 etherBalance = myAddress.balance;\n', '        owner.transfer(etherBalance);\n', '    }\n', '    \n', '    function resetAirdrop() onlyOwner public {\n', '        airdropcounter=0;\n', '    }\n', '    \n', '    function withdrawAltcoinTokens(address anycontract) onlyOwner public returns (bool) {\n', '        AltcoinToken anytoken = AltcoinToken(anycontract);\n', '        uint256 amount = anytoken.balanceOf(address(this));\n', '        return anytoken.transfer(owner, amount);\n', '    }\n', '    \n', '    function sendtokens(address contrato, uint256 amount, address who) private returns (bool) {\n', '        AltcoinToken alttoken = AltcoinToken(contrato);\n', '        return alttoken.transfer(who, amount);\n', '    }\n', '}']