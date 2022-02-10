['pragma solidity ^0.4.23;\n', '\n', 'library SafeMath {\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '\t\tif (a == 0) {\n', '\t\t\treturn 0;\n', '\t\t}\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '\t}\n', '}\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', 'contract BurnableToken is BasicToken {\n', '  event Burn(address indexed burner, uint256 value);\n', '  function burn(uint256 _value) public {\n', '    _burn(msg.sender, _value);\n', '  }\n', '  function _burn(address _who, uint256 _value) internal {\n', '    require(_value <= balances[_who]);\n', '    balances[_who] = balances[_who].sub(_value);\n', '    totalSupply_ = totalSupply_.sub(_value);\n', '    emit Burn(_who, _value);\n', '    emit Transfer(_who, address(0), _value);\n', '  }\n', '}\n', 'contract StandardToken is ERC20, BurnableToken {\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '  function allowance(\n', '    address _owner,\n', '    address _spender\n', '   )\n', '    public\n', '    view\n', '    returns (uint256)\n', '  {\n', '    return allowed[_owner][_spender];\n', '  }\n', '  function increaseApproval(\n', '    address _spender,\n', '    uint _addedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    allowed[msg.sender][_spender] = (\n', '      allowed[msg.sender][_spender].add(_addedValue));\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '  function decreaseApproval(\n', '    address _spender,\n', '    uint _subtractedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '}\n', '\n', 'contract UniDAG is StandardToken{\n', '\n', '  string public constant name = "UniDAG";\n', '  string public constant symbol = "UDAG";\n', '  uint8 public constant decimals = 18;\n', '  address public owner;\n', '  address public CrowdsaleContract;\n', '\n', '  constructor () public {\n', '   \t//Token Distribution\n', '     totalSupply_ = 60600000e18;\n', '\towner = 0x653859383f60741880f377085Ec44Cf75702C373;\n', '\tCrowdsaleContract = msg.sender;\n', '    balances[msg.sender] = 30300000e18;\n', '\t\n', '\t//Airdrop\n', '\tbalances[0x1b3481e6c425baD0C8C44e563553BADF8Aca9415] = 6060000e18;\n', '\n', '\t//Partnership\n', '\tbalances[0x174cc6965Dd694f3BCE8B51434b7972ed8497374] = 7575000e18;\n', '\n', '\t//Marketing \n', '\tbalances[0xF4A966739FF81B09CDb075Bf896B5Bd943C50f52] = 7575000e18;\n', '\n', '\t//Bounty \n', '\tbalances[0x42373a7cE8dBF539e0b39D25C3F5064CFabBE227] = 9090000e18;\n', '  }\n', '  modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '\t}\n', '\n', '  function burnCrowdsale() public onlyOwner {\n', '    _burn(CrowdsaleContract, balances[CrowdsaleContract]);\n', '  }\n', '}\n', '\n', 'contract UniDAGCrowdsale {\n', '    using SafeMath for uint256;\t\n', '    UniDAG public token;\n', '    address public owner;\t\n', '    uint256 public rateFirstRound = 4000;\n', '    uint256 public rateSecondRound = 3500;\n', '    uint256 public rateThirdRound = 3000;\n', '\n', '\tuint256 public openingTime = 1530403200;             \n', '   \t//1.07.2018 0:00:00 GMT+0\n', '\n', '\tuint256 public secondRoundTime = 1539129600;      \n', ' \t//10.10.2018 0:00:00 GMT+0\n', '\n', '\tuint256 public thirdRoundTime = 1547856000;        \n', '  \t//19.01.2019 0:00:00 GMT+0\n', '\n', '\tuint256 public closingTime = 1556582399;               \n', ' \t //29.04.2019 23:59:59 GMT +0\n', '\t\n', '\tuint256 public weiRaised;\n', '    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount, uint256 timestamp);\n', '\t\n', '\tmodifier onlyWhileOpen {\n', '\t\trequire(block.timestamp >= openingTime && block.timestamp <= closingTime);\n', '\t\t_;\n', '\t}\n', '    constructor () public {\t\n', '        token = new UniDAG();\n', '        owner = msg.sender;\n', '    }\n', '    function () external payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '    function buyTokens(address _beneficiary) public payable {\n', '        uint256 weiAmount = msg.value;\n', '        _preValidatePurchase(_beneficiary, weiAmount);\n', '        uint256 tokens = _getTokenAmount(weiAmount);\n', '        weiRaised = weiRaised.add(weiAmount);\n', '        _processPurchase(_beneficiary, tokens);\n', '        emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens, block.timestamp);\n', '        _forwardFunds();\n', '    }\n', '    function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) view internal onlyWhileOpen {\n', '        require(_beneficiary != address(0));\n', '   \n', ' //Minimum 0.01 ETH\n', '\n', '        require(_weiAmount >= 10e15);\n', '    }\n', '    function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {\n', '        token.transfer(_beneficiary, _tokenAmount);\n', '    }\n', '    function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {\n', '        _deliverTokens(_beneficiary, _tokenAmount);\n', '    }\n', '    function _getTokenAmount(uint256 _weiAmount) view internal returns (uint256) {\n', '        if(block.timestamp < secondRoundTime) return _weiAmount.mul(rateFirstRound);\n', '        if(block.timestamp < thirdRoundTime) return _weiAmount.mul(rateSecondRound);\n', '\t\treturn _weiAmount.mul(rateThirdRound);\n', '    }\n', '    function _forwardFunds() internal {\n', '        owner.transfer(msg.value);\n', '    }\n', '}']