['pragma solidity ^0.4.11;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool);\n', '  function approve(address spender, uint256 value) returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '  function transfer(address _to, uint256 _value) returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '  function approve(address _spender, uint256 _value) returns (bool) {\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    require(newOwner != address(0));      \n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', 'contract MintableToken is StandardToken, Ownable {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '    modifier canMint() {\n', '      require(!mintingFinished);\n', '    _;\n', '  }\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    Transfer(0x0, _to, _amount);\n', '    return true;\n', '  }\n', '  function finishMinting() onlyOwner returns (bool) {\n', '    mintingFinished = true;\n', '    MintFinished();\n', '    return true;\n', '  }\n', '}\n', 'contract LightningQiwiToken is MintableToken {\n', '    string public name = "Lightning Qiwi token";\t\t\n', '  string public symbol = "QIWI";\t\t\n', '  uint256 public decimals = 18;\t\n', '  uint256 public INITIAL_SUPPLY = 2000000000 * (10 ** uint256(decimals));\n', '  function LightningQiwiToken() {\n', '    totalSupply = INITIAL_SUPPLY;\n', '    balances[0xeBA036468a1ec330996D9dB7bD0d7B18Cb33953f] = INITIAL_SUPPLY;\n', '  }\n', '  \n', '}\n', 'contract LightningQiwiCrowdsale is Ownable{\n', '  using SafeMath for uint256;\n', '  MintableToken public token;\n', '  uint256 public startTime;\n', '  uint256 public endTime;\n', '  address public wallet;\n', '  uint256 public rate;\n', '  uint256 public weiRaised;\n', '  event TokenPurchase (address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '\n', '  function LightningQiwiCrowdsale() {\n', '    token = createTokenContract();\n', '    startTime = 1507411037;\n', '    endTime = 1514764799;\n', '    rate = 50000;\n', '    wallet = 0xeBA036468a1ec330996D9dB7bD0d7B18Cb33953f;\n', '  }\n', '  function createTokenContract() internal returns (MintableToken) {\n', '    return new LightningQiwiToken();\n', '  }\n', '  function () payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '    event purch(address indexed from, address indexed to, uint256 value);\n', '  function Ended (address _to, uint256 _value) public onlyOwner  {\n', '    token.mint(_to, _value);\n', '    purch(0x0, _to, _value);\n', '\n', '  }\n', '\n', '  function buyTokens(address beneficiary) public payable {\n', '    require(beneficiary != 0x0);\n', '    require(validPurchase());\n', '\n', '    uint256 weiAmount = msg.value;\n', '    uint256 tokens = weiAmount.mul(rate);\n', '\n', '    weiRaised = weiRaised.add(weiAmount);\n', '\n', '    token.mint(beneficiary, tokens);\n', '    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '\n', '    forwardFunds();\n', '  }\n', '  function forwardFunds() internal {\n', '    wallet.transfer(msg.value);\n', '  }\n', '\n', '  function validPurchase() internal constant returns (bool) {\n', '    bool withinPeriod = now >= startTime && now <= endTime;\n', '    bool nonZeroPurchase = msg.value != 0;\n', '    return withinPeriod && nonZeroPurchase;\n', '  }\n', '\n', '  function hasEnded() public constant returns (bool) {\n', '    return now > endTime;\n', '  }\n', '\n', '}']