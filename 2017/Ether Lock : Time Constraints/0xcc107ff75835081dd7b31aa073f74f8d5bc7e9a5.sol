['pragma solidity ^0.4.18;\n', '\n', '/**\n', '* @title SafeMath\n', '* @dev Math operations with safety checks that throw on error\n', '*/\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract IERC20Token {\n', '  function name() public constant returns (string) { name; }\n', '  function symbol() public constant returns (string) { symbol; }\n', '  function decimals() public constant returns (uint8) { decimals; }\n', '  function totalSupply() public constant returns (uint256) { totalSupply; }\n', '  function balanceOf(address _owner) public constant returns (uint256 balance) { _owner; balance; }\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { _owner; _spender; remaining; }\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool);\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool);\n', '  function approve(address _spender, uint256 _value) public returns (bool);\n', '}\n', '\n', 'contract ERC20Token is IERC20Token {\n', '  using SafeMath for uint256;\n', '\n', "  string public standard = 'Token 0.1';\n", "  string public name = '';\n", "  string public symbol = '';\n", '  uint8 public decimals = 0;\n', '  uint256 public totalSupply = 0;\n', '  mapping (address => uint256) public balanceOf;\n', '  mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '  function ERC20Token(string _name, string _symbol, uint8 _decimals) public {\n', '    require(bytes(_name).length > 0 && bytes(_symbol).length > 0);\n', '    name = _name;\n', '    symbol = _symbol;\n', '    decimals = _decimals;\n', '  }\n', '\n', '  modifier validAddress(address _address) {\n', '    require(_address != 0x0);\n', '    _;\n', '  }\n', '\n', '  function transfer(address _to, uint256 _value) public validAddress(_to) returns (bool) {\n', '    balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '    balanceOf[_to] = balanceOf[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    \n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public validAddress(_to) returns (bool) {\n', '    allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);\n', '    balanceOf[_from] = balanceOf[_from].sub(_value);\n', '    balanceOf[_to] = balanceOf[_to].add(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public validAddress(_spender) returns (bool) {\n', '    require(_value == 0 || allowance[msg.sender][_spender] == 0);\n', '    allowance[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '}\n', '\n', '\n', 'contract IOwned {\n', '  function owner() public constant returns (address) { owner; }\n', '  function transferOwnership(address _newOwner) public;\n', '}\n', '\n', 'contract Owned is IOwned {\n', '  address public owner;\n', '\n', '  function Owned() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier validAddress(address _address) {\n', '    require(_address != 0x0);\n', '    _;\n', '  }\n', '  modifier onlyOwner {\n', '    assert(msg.sender == owner);\n', '    _;\n', '  }\n', '  \n', '  function transferOwnership(address _newOwner) public validAddress(_newOwner) onlyOwner {\n', '    require(_newOwner != owner);\n', '    \n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '\n', 'contract ISerenityToken {\n', '  function initialSupply () public constant returns (uint256) { initialSupply; }\n', '\n', '  function totalSoldTokens () public constant returns (uint256) { totalSoldTokens; }\n', '  function totalProjectToken() public constant returns (uint256) { totalProjectToken; }\n', '\n', '  function fundingEnabled() public constant returns (bool) { fundingEnabled; }\n', '  function transfersEnabled() public constant returns (bool) { transfersEnabled; }\n', '}\n', '\n', 'contract SerenityToken is ISerenityToken, ERC20Token, Owned {\n', '  using SafeMath for uint256;\n', ' \n', '  address public fundingWallet;\n', '  bool public fundingEnabled = true;\n', '  uint256 public maxSaleToken = 3500000;\n', '  uint256 public initialSupply = 350000 ether;\n', '  uint256 public totalSoldTokens;\n', '  uint256 public totalProjectToken;\n', '  uint256 private totalLockToken;\n', '  bool public transfersEnabled = false; \n', '\n', '  mapping (address => bool) private fundingWallets;\n', '  mapping (address => allocationLock) public allocations;\n', '\n', '  struct allocationLock {\n', '    uint256 value;\n', '    uint256 end;\n', '    bool locked;\n', '  }\n', '\n', '  event Finalize(address indexed _from, uint256 _value);\n', '  event Lock(address indexed _from, address indexed _to, uint256 _value, uint256 _end);\n', '  event Unlock(address indexed _from, address indexed _to, uint256 _value);\n', '  event DisableTransfers(address indexed _from);\n', '\n', '  function SerenityToken() ERC20Token("SERENITY INVEST", "SERENITY", 18) public {\n', '    fundingWallet = msg.sender; \n', '\n', '    balanceOf[fundingWallet] = maxSaleToken;\n', '    balanceOf[0xCAD0AfB8Ec657D0DB9518B930855534f6433360f] = maxSaleToken;\n', '    balanceOf[0x47c8F28e6056374aBA3DF0854306c2556B104601] = maxSaleToken;\n', '\n', '    fundingWallets[fundingWallet] = true;\n', '    fundingWallets[0x47c8F28e6056374aBA3DF0854306c2556B104601] = true;\n', '    fundingWallets[0xCAD0AfB8Ec657D0DB9518B930855534f6433360f] = true;\n', '  }\n', '\n', '  modifier validAddress(address _address) {\n', '    require(_address != 0x0);\n', '    _;\n', '  }\n', '\n', '  modifier transfersAllowed(address _address) {\n', '    if (fundingEnabled) {\n', '      require(fundingWallets[_address]);\n', '    }\n', '    else {\n', '      require(transfersEnabled);\n', '    }\n', '    _;\n', '  }\n', '\n', '  function transfer(address _to, uint256 _value) public validAddress(_to) transfersAllowed(msg.sender) returns (bool) {\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  function autoTransfer(address _to, uint256 _value) public validAddress(_to) onlyOwner returns (bool) {\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public validAddress(_to) transfersAllowed(_from) returns (bool) {\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  function lock(address _to, uint256 _value, uint256 _end) internal validAddress(_to) onlyOwner returns (bool) {\n', '    require(_value > 0);\n', '\n', '    assert(totalProjectToken > 0);\n', '    totalLockToken = totalLockToken.add(_value);\n', '    assert(totalProjectToken >= totalLockToken);\n', '\n', '    require(allocations[_to].value == 0);\n', '\n', '    // Assign a new lock.\n', '    allocations[_to] = allocationLock({\n', '      value: _value,\n', '      end: _end,\n', '      locked: true\n', '    });\n', '\n', '    Lock(this, _to, _value, _end);\n', '\n', '    return true;\n', '  }\n', '\n', '  function unlock() external {\n', '    require(allocations[msg.sender].locked);\n', '    require(now >= allocations[msg.sender].end);\n', '    \n', '    balanceOf[msg.sender] = balanceOf[msg.sender].add(allocations[msg.sender].value);\n', '\n', '    allocations[msg.sender].locked = false;\n', '\n', '    Transfer(this, msg.sender, allocations[msg.sender].value);\n', '    Unlock(this, msg.sender, allocations[msg.sender].value);\n', '  }\n', '\n', '  function finalize() external onlyOwner {\n', '    require(fundingEnabled);\n', '    \n', '    totalSoldTokens = maxSaleToken.sub(balanceOf[fundingWallet]);\n', '\n', '    totalProjectToken = totalSoldTokens.mul(15).div(100);\n', '\n', '    lock(0x47c8F28e6056374aBA3DF0854306c2556B104601, totalProjectToken, now);\n', '    \n', '    // Zeroing a cold wallet.\n', '    balanceOf[fundingWallet] = 0;\n', '    balanceOf[0x47c8F28e6056374aBA3DF0854306c2556B104601] = 0;\n', '    balanceOf[0xCAD0AfB8Ec657D0DB9518B930855534f6433360f] = 0;\n', '\n', '    // End of crowdfunding.\n', '    fundingEnabled = false;\n', '    transfersEnabled = true;\n', '\n', '    // End of crowdfunding.\n', '    Transfer(this, fundingWallet, 0);\n', '    Finalize(msg.sender, totalSupply);\n', '  }\n', '\n', '  function disableTransfers() external onlyOwner {\n', '    require(transfersEnabled);\n', '\n', '    transfersEnabled = false;\n', '\n', '    DisableTransfers(msg.sender);\n', '  }\n', '\n', '  function disableFundingWallets(address _address) external onlyOwner {\n', '    require(fundingEnabled);\n', '    require(fundingWallet != _address);\n', '    require(fundingWallets[_address]);\n', '\n', '    fundingWallets[_address] = false;\n', '  }\n', '}\n', '\n', '\n', 'contract Crowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  SerenityToken public token;\n', '\n', '  mapping(uint256 => uint8) icoWeeksDiscounts; \n', '\n', '  uint256 public preStartTime = 1510704000;\n', '  uint256 public preEndTime = 1512086400; \n', '\n', '  bool public isICOStarted = false; \n', '  uint256 public icoStartTime; \n', '  uint256 public icoEndTime; \n', '\n', '  address public wallet = 0x47c8F28e6056374aBA3DF0854306c2556B104601;\n', '  uint256 public finneyPerToken = 100;\n', '  uint256 public weiRaised;\n', '  uint256 public ethRaised;\n', '\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '  modifier validAddress(address _address) {\n', '    require(_address != 0x0);\n', '    _;\n', '  }\n', '\n', '  function Crowdsale() public {\n', '    token = createTokenContract();\n', '    initDiscounts();\n', '  }\n', '\n', '  function initDiscounts() internal {\n', '    icoWeeksDiscounts[0] = 40;\n', '    icoWeeksDiscounts[1] = 35;\n', '    icoWeeksDiscounts[2] = 30;\n', '    icoWeeksDiscounts[3] = 25;\n', '    icoWeeksDiscounts[4] = 20;\n', '    icoWeeksDiscounts[5] = 10;\n', '  }\n', '\n', '  function createTokenContract() internal returns (SerenityToken) {\n', '    return new SerenityToken();\n', '  }\n', '\n', '  function () public payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  function getTimeDiscount() internal returns(uint8) {\n', '    require(isICOStarted == true);\n', '    require(icoStartTime < now);\n', '    require(icoEndTime > now);\n', '\n', '    uint256 weeksPassed = (now - icoStartTime) / 7 days;\n', '    return icoWeeksDiscounts[weeksPassed];\n', '  } \n', '\n', '  function getTotalSoldDiscount() internal returns(uint8) {\n', '    require(isICOStarted == true);\n', '    require(icoStartTime < now);\n', '    require(icoEndTime > now);\n', '\n', '    uint256 totalSold = token.totalSoldTokens();\n', '\n', '    if (totalSold < 150000)\n', '      return 50;\n', '    else if (totalSold < 250000)\n', '      return 40;\n', '    else if (totalSold < 500000)\n', '      return 35;\n', '    else if (totalSold < 700000)\n', '      return 30;\n', '    else if (totalSold < 1100000)\n', '      return 25;\n', '    else if (totalSold < 2100000)\n', '      return 20;\n', '    else if (totalSold < 3500000)\n', '      return 10;\n', '  }\n', '\n', '  function getDiscount() internal constant returns (uint8) {\n', '    if (!isICOStarted)\n', '      return 50;\n', '    else {\n', '      uint8 timeDiscount = getTimeDiscount();\n', '      uint8 totalSoldDiscount = getTotalSoldDiscount();\n', '\n', '      if (timeDiscount < totalSoldDiscount)\n', '        return timeDiscount;\n', '      else \n', '        return totalSoldDiscount;\n', '    }\n', '  }\n', '\n', '  function buyTokens(address beneficiary) public validAddress(beneficiary) payable {\n', '    require(validPurchase());\n', '\n', '    uint256 finneyAmount = msg.value / 1 finney;\n', '\n', '    uint8 discountPercents = getDiscount();\n', '    uint256 tokens = finneyAmount.mul(100).div(100 - discountPercents).div(finneyPerToken);\n', '\n', '    require(tokens > 0);\n', '\n', '    weiRaised = weiRaised.add(finneyAmount * 1 finney);\n', '    \n', '    token.autoTransfer(beneficiary, tokens);\n', '    TokenPurchase(msg.sender, beneficiary, finneyAmount * 1 finney, tokens);\n', '\n', '    forwardFunds();\n', '  }\n', '\n', '  function activeteICO(uint256 _icoEndTime) public {\n', '    require(msg.sender == wallet);\n', '    require(_icoEndTime >= now);\n', '    require(_icoEndTime >= preEndTime);\n', '    require(isICOStarted == false);\n', '      \n', '    isICOStarted = true;\n', '    icoEndTime = _icoEndTime;\n', '  }\n', '\n', '  function forwardFunds() internal {\n', '    wallet.transfer(msg.value);\n', '  }\n', '\n', '  function validPurchase() internal constant returns (bool) {\n', '    bool withinPresalePeriod = now >= preStartTime && now <= preEndTime;\n', '    bool withinICOPeriod = isICOStarted && now >= icoStartTime && now <= icoEndTime;\n', '\n', '    bool nonZeroPurchase = msg.value != 0;\n', '    \n', '    return (withinPresalePeriod || withinICOPeriod) && nonZeroPurchase;\n', '  }\n', '}']