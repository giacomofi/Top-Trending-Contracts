['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', 'contract RTcoin {\n', '    using SafeMath for uint256;\n', '    \n', '\taddress public owner;\n', '    address public saleAgent;\n', '    uint256 public totalSupply;\n', '\tstring public name;\n', '\tuint8 public decimals;\n', '\tstring public symbol;\n', '\tbool private allowEmission = true;\n', '\tmapping (address => uint256) balances;\n', '    \n', '    \n', '    function RTcoin(string _name, string _symbol, uint8 _decimals) public {\n', '\t\tdecimals = _decimals;\n', '\t\tname = _name;\n', '\t\tsymbol = _symbol;\n', '\t\towner = msg.sender;\n', '\t}\n', '\t\n', '\t\n', '    function changeSaleAgent(address newSaleAgent) public onlyOwner {\n', '        require (newSaleAgent!=address(0));\n', '        uint256 tokenAmount = balances[saleAgent];\n', '        if (tokenAmount>0) {\n', '            balances[newSaleAgent] = balances[newSaleAgent].add(tokenAmount);\n', '            balances[saleAgent] = balances[saleAgent].sub(tokenAmount);\n', '            Transfer(saleAgent, newSaleAgent, tokenAmount);\n', '        }\n', '        saleAgent = newSaleAgent;\n', '    }\n', '\t\n', '\t\n', '\tfunction emission(uint256 amount) public onlyOwner {\n', '\t    require(allowEmission);\n', '\t    require(saleAgent!=address(0));\n', '\t    totalSupply = amount * (uint256(10) ** decimals);\n', '\t\tbalances[saleAgent] = totalSupply;\n', '\t\tTransfer(0x0, saleAgent, totalSupply);\n', '\t\tallowEmission = false;\n', '\t}\n', '    \n', '    \n', '    function burn(uint256 _value) public {\n', '        require(_value > 0);\n', '        address burner;\n', '        if (msg.sender==owner)\n', '            burner = saleAgent;\n', '        else\n', '            burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        Burn(burner, _value);\n', '    }\n', '     \n', '    event Burn(address indexed burner, uint indexed value);\n', '\t\n', '\t\n', '\tfunction transfer(address _to, uint256 _value) public returns (bool) {\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    \n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\t\n', '\t\n', '\tfunction transferOwnership(address newOwner) onlyOwner public {\n', '        require(newOwner != address(0));\n', '        owner = newOwner; \n', '    }\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '\n', '\t\n', '\tevent Transfer(\n', '\t\taddress indexed _from,\n', '\t\taddress indexed _to,\n', '\t\tuint _value\n', '\t);\n', '}\n', '\n', 'contract Crowdsale {\n', '    \n', '    using SafeMath for uint256;\n', '    address fundsWallet;\n', '    RTcoin public token;\n', '    address public owner;\n', '\tbool public open = false;\n', '    uint256 public tokenLimit;\n', '    \n', '    uint256 public rate = 20000;  \n', '    \n', '    \n', '    function Crowdsale(address _fundsWallet, address tokenAddress, \n', '                       uint256 _rate, uint256 _tokenLimit) public {\n', '        fundsWallet = _fundsWallet;\n', '        token = RTcoin(tokenAddress);\n', '        rate = _rate;\n', '        owner = msg.sender;\n', '        tokenLimit = _tokenLimit * (uint256(10) ** token.decimals());\n', '    }\n', '    \n', '    \n', '    function() external isOpen payable {\n', '        require(tokenLimit>0);\n', '        fundsWallet.transfer(msg.value);\n', '        uint256 tokens = calculateTokenAmount(msg.value);\n', '        token.transfer(msg.sender, tokens);\n', '        tokenLimit = tokenLimit.sub(tokens);\n', '    }\n', '  \n', '    \n', '    function changeFundAddress(address newAddress) public onlyOwner {\n', '        require(newAddress != address(0));\n', '        fundsWallet = newAddress;\n', '\t}\n', '\t\n', '\t\n', '    function changeRate(uint256 newRate) public onlyOwner {\n', '        require(newRate>0);\n', '        rate = newRate;\n', '    }\n', '    \n', '    \n', '    function calculateTokenAmount(uint256 weiAmount) public constant returns(uint256) {\n', '        if (token.decimals()!=18){\n', '            uint256 tokenAmount = weiAmount.mul(rate).div(uint256(10) ** (18-token.decimals())); \n', '            return tokenAmount;\n', '        }\n', '        else return weiAmount.mul(rate);\n', '    }\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    \n', '    function allowSale() public onlyOwner {\n', '        open = true;\n', '    }\n', '    \n', '   \n', '    function disallowSale() public onlyOwner {\n', '        open = false;\n', '    }\n', '    \n', '    modifier isOpen() {\n', '        require(open == true);\n', '        _;\n', '    }\n', '}']