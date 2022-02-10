['pragma solidity ^0.4.11;\n', '\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      throw;\n', '    }\n', '  }\n', '}\n', '\n', '/*\n', ' * ERC20Basic\n', ' * Simpler version of ERC20 interface\n', ' * see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20Basic {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function transfer(address to, uint value);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', '\n', '/*\n', ' * ERC20 interface\n', ' * see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '  function transferFrom(address from, address to, uint value);\n', '  function approve(address spender, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '/*\n', ' * Basic token\n', ' * Basic version of StandardToken, with no allowances\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint;\n', '\n', '  mapping(address => uint) balances;\n', '\n', '  /*\n', '   * Fix for the ERC20 short address attack  \n', '   */\n', '  modifier onlyPayloadSize(uint size) {\n', '     if(msg.data.length < size + 4) {\n', '       throw;\n', '     }\n', '     _;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '  \n', '}\n', '\n', 'contract StandardToken is BasicToken, ERC20 {\n', '\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '  function transferFrom(address _from, address _to, uint _value) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // if (_value > _allowance) throw;\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '  }\n', '\n', '  function approve(address _spender, uint _value) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    if (msg.sender != owner) {\n', '      throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', 'contract BITSDToken is StandardToken, Ownable {\n', '  using SafeMath for uint;\n', '\n', '  event BITSDTokenInitialized(address _owner);\n', '  event OwnerTokensAllocated(uint _amount);\n', '  event TeamTokensAllocated(uint _amount);\n', '  event TokensCreated(address indexed _tokenHolder, uint256 _contributionAmount, uint256 _tokenAmount);\n', '  event SaleStarted(uint _saleStartime);\n', '\n', '  string public name = "BITSDToken";\n', '  string public symbol = "BITSD";\n', '\n', '  uint public decimals = 3;\n', '  uint public multiplier = 10**decimals;\n', '  uint public etherRatio = SafeMath.div(1 ether, multiplier);\n', '\n', '  uint public TOTAL_SUPPLY = SafeMath.mul(7000000, multiplier);\n', '  uint public TEAM_SUPPLY = SafeMath.mul(700000, multiplier);\n', '  uint public PRICE = 300; //1 Ether buys 300 BITSD\n', '  uint public MIN_PURCHASE = 10**18; // 1 Ether\n', '\n', '  uint256 public saleStartTime = 0;\n', '  bool public teamTokensAllocated = false;\n', '  bool public ownerTokensAllocated = false;\n', '\n', '  function BITSDToken() {\n', '    BITSDTokenInitialized(msg.sender);\n', '  }\n', '\n', '  function allocateTeamTokens() public {\n', '    if (teamTokensAllocated) {\n', '      throw;\n', '    }\n', '    balances[owner] = balances[owner].add(TEAM_SUPPLY);\n', '    totalSupply = totalSupply.add(TEAM_SUPPLY);\n', '    teamTokensAllocated = true;\n', '    TeamTokensAllocated(TEAM_SUPPLY);\n', '  }\n', '\n', '  function canBuyTokens() constant public returns (bool) {\n', '    //Sale runs for 31 days\n', '    if (saleStartTime == 0) {\n', '      return false;\n', '    }\n', '    if (getNow() > SafeMath.add(saleStartTime, 31 days)) {\n', '      return false;\n', '    }\n', '    return true;\n', '  }\n', '\n', '  function startSale() onlyOwner {\n', '    //Must allocate team tokens before starting sale, or you may lose the opportunity\n', '    //to do so if the whole supply is sold to the crowd.\n', '    if (!teamTokensAllocated) {\n', '      throw;\n', '    }\n', '    //Can only start once\n', '    if (saleStartTime != 0) {\n', '      throw;\n', '    }\n', '    saleStartTime = getNow();\n', '    SaleStarted(saleStartTime);\n', '  }\n', '\n', '  function () payable {\n', '    createTokens(msg.sender);\n', '  }\n', '\n', '  function createTokens(address recipient) payable {\n', '\n', '    //Only allow purchases over the MIN_PURCHASE\n', '    if (msg.value < MIN_PURCHASE) {\n', '      throw;\n', '    }\n', '\n', '    //Reject if sale has completed\n', '    if (!canBuyTokens()) {\n', '      throw;\n', '    }\n', '\n', '    //Otherwise generate tokens\n', '    uint tokens = msg.value.mul(PRICE);\n', '\n', '    //Add on any bonus\n', '    uint bonusPercentage = SafeMath.add(100, bonus());\n', '    if (bonusPercentage != 100) {\n', '      tokens = tokens.mul(percent(bonusPercentage)).div(percent(100));\n', '    }\n', '\n', '    tokens = tokens.div(etherRatio);\n', '\n', '    totalSupply = totalSupply.add(tokens);\n', '\n', '    //Don&#39;t allow totalSupply to be larger than TOTAL_SUPPLY\n', '    if (totalSupply > TOTAL_SUPPLY) {\n', '      throw;\n', '    }\n', '\n', '    balances[recipient] = balances[recipient].add(tokens);\n', '\n', '    //Transfer Ether to owner\n', '    owner.transfer(msg.value);\n', '\n', '    TokensCreated(recipient, msg.value, tokens);\n', '\n', '  }\n', '\n', '  //Function to assign team & bounty tokens to owner\n', '  function allocateOwnerTokens() public {\n', '\n', '    //Can only be called once\n', '    if (ownerTokensAllocated) {\n', '      throw;\n', '    }\n', '\n', '    //Can only be called after sale has completed\n', '    if ((saleStartTime == 0) || canBuyTokens()) {\n', '      throw;\n', '    }\n', '\n', '    ownerTokensAllocated = true;\n', '\n', '    uint amountToAllocate = SafeMath.sub(TOTAL_SUPPLY, totalSupply);\n', '    balances[owner] = balances[owner].add(amountToAllocate);\n', '    totalSupply = totalSupply.add(amountToAllocate);\n', '\n', '    OwnerTokensAllocated(amountToAllocate);\n', '\n', '  }\n', '\n', '  function bonus() constant returns(uint) {\n', '\n', '    uint elapsed = SafeMath.sub(getNow(), saleStartTime);\n', '\n', '    if (elapsed < 1 weeks) return 10;\n', '    if (elapsed < 2 weeks) return 5;\n', '\n', '    return 0;\n', '  }\n', '\n', '  function percent(uint256 p) internal returns (uint256) {\n', '    return p.mul(10**16);\n', '  }\n', '\n', '  //Function is mocked for tests\n', '  function getNow() internal constant returns (uint256) {\n', '    return now;\n', '  }\n', '\n', '}']
['pragma solidity ^0.4.11;\n', '\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      throw;\n', '    }\n', '  }\n', '}\n', '\n', '/*\n', ' * ERC20Basic\n', ' * Simpler version of ERC20 interface\n', ' * see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20Basic {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function transfer(address to, uint value);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', '\n', '/*\n', ' * ERC20 interface\n', ' * see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '  function transferFrom(address from, address to, uint value);\n', '  function approve(address spender, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '/*\n', ' * Basic token\n', ' * Basic version of StandardToken, with no allowances\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint;\n', '\n', '  mapping(address => uint) balances;\n', '\n', '  /*\n', '   * Fix for the ERC20 short address attack  \n', '   */\n', '  modifier onlyPayloadSize(uint size) {\n', '     if(msg.data.length < size + 4) {\n', '       throw;\n', '     }\n', '     _;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '  \n', '}\n', '\n', 'contract StandardToken is BasicToken, ERC20 {\n', '\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '  function transferFrom(address _from, address _to, uint _value) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // if (_value > _allowance) throw;\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '  }\n', '\n', '  function approve(address _spender, uint _value) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    if (msg.sender != owner) {\n', '      throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', 'contract BITSDToken is StandardToken, Ownable {\n', '  using SafeMath for uint;\n', '\n', '  event BITSDTokenInitialized(address _owner);\n', '  event OwnerTokensAllocated(uint _amount);\n', '  event TeamTokensAllocated(uint _amount);\n', '  event TokensCreated(address indexed _tokenHolder, uint256 _contributionAmount, uint256 _tokenAmount);\n', '  event SaleStarted(uint _saleStartime);\n', '\n', '  string public name = "BITSDToken";\n', '  string public symbol = "BITSD";\n', '\n', '  uint public decimals = 3;\n', '  uint public multiplier = 10**decimals;\n', '  uint public etherRatio = SafeMath.div(1 ether, multiplier);\n', '\n', '  uint public TOTAL_SUPPLY = SafeMath.mul(7000000, multiplier);\n', '  uint public TEAM_SUPPLY = SafeMath.mul(700000, multiplier);\n', '  uint public PRICE = 300; //1 Ether buys 300 BITSD\n', '  uint public MIN_PURCHASE = 10**18; // 1 Ether\n', '\n', '  uint256 public saleStartTime = 0;\n', '  bool public teamTokensAllocated = false;\n', '  bool public ownerTokensAllocated = false;\n', '\n', '  function BITSDToken() {\n', '    BITSDTokenInitialized(msg.sender);\n', '  }\n', '\n', '  function allocateTeamTokens() public {\n', '    if (teamTokensAllocated) {\n', '      throw;\n', '    }\n', '    balances[owner] = balances[owner].add(TEAM_SUPPLY);\n', '    totalSupply = totalSupply.add(TEAM_SUPPLY);\n', '    teamTokensAllocated = true;\n', '    TeamTokensAllocated(TEAM_SUPPLY);\n', '  }\n', '\n', '  function canBuyTokens() constant public returns (bool) {\n', '    //Sale runs for 31 days\n', '    if (saleStartTime == 0) {\n', '      return false;\n', '    }\n', '    if (getNow() > SafeMath.add(saleStartTime, 31 days)) {\n', '      return false;\n', '    }\n', '    return true;\n', '  }\n', '\n', '  function startSale() onlyOwner {\n', '    //Must allocate team tokens before starting sale, or you may lose the opportunity\n', '    //to do so if the whole supply is sold to the crowd.\n', '    if (!teamTokensAllocated) {\n', '      throw;\n', '    }\n', '    //Can only start once\n', '    if (saleStartTime != 0) {\n', '      throw;\n', '    }\n', '    saleStartTime = getNow();\n', '    SaleStarted(saleStartTime);\n', '  }\n', '\n', '  function () payable {\n', '    createTokens(msg.sender);\n', '  }\n', '\n', '  function createTokens(address recipient) payable {\n', '\n', '    //Only allow purchases over the MIN_PURCHASE\n', '    if (msg.value < MIN_PURCHASE) {\n', '      throw;\n', '    }\n', '\n', '    //Reject if sale has completed\n', '    if (!canBuyTokens()) {\n', '      throw;\n', '    }\n', '\n', '    //Otherwise generate tokens\n', '    uint tokens = msg.value.mul(PRICE);\n', '\n', '    //Add on any bonus\n', '    uint bonusPercentage = SafeMath.add(100, bonus());\n', '    if (bonusPercentage != 100) {\n', '      tokens = tokens.mul(percent(bonusPercentage)).div(percent(100));\n', '    }\n', '\n', '    tokens = tokens.div(etherRatio);\n', '\n', '    totalSupply = totalSupply.add(tokens);\n', '\n', "    //Don't allow totalSupply to be larger than TOTAL_SUPPLY\n", '    if (totalSupply > TOTAL_SUPPLY) {\n', '      throw;\n', '    }\n', '\n', '    balances[recipient] = balances[recipient].add(tokens);\n', '\n', '    //Transfer Ether to owner\n', '    owner.transfer(msg.value);\n', '\n', '    TokensCreated(recipient, msg.value, tokens);\n', '\n', '  }\n', '\n', '  //Function to assign team & bounty tokens to owner\n', '  function allocateOwnerTokens() public {\n', '\n', '    //Can only be called once\n', '    if (ownerTokensAllocated) {\n', '      throw;\n', '    }\n', '\n', '    //Can only be called after sale has completed\n', '    if ((saleStartTime == 0) || canBuyTokens()) {\n', '      throw;\n', '    }\n', '\n', '    ownerTokensAllocated = true;\n', '\n', '    uint amountToAllocate = SafeMath.sub(TOTAL_SUPPLY, totalSupply);\n', '    balances[owner] = balances[owner].add(amountToAllocate);\n', '    totalSupply = totalSupply.add(amountToAllocate);\n', '\n', '    OwnerTokensAllocated(amountToAllocate);\n', '\n', '  }\n', '\n', '  function bonus() constant returns(uint) {\n', '\n', '    uint elapsed = SafeMath.sub(getNow(), saleStartTime);\n', '\n', '    if (elapsed < 1 weeks) return 10;\n', '    if (elapsed < 2 weeks) return 5;\n', '\n', '    return 0;\n', '  }\n', '\n', '  function percent(uint256 p) internal returns (uint256) {\n', '    return p.mul(10**16);\n', '  }\n', '\n', '  //Function is mocked for tests\n', '  function getNow() internal constant returns (uint256) {\n', '    return now;\n', '  }\n', '\n', '}']