['pragma solidity ^0.4.19;\n', '\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ForeignToken {\n', '    function balanceOf(address _owner) constant returns (uint256);\n', '    function transfer(address _to, uint256 _value) returns (bool);\n', '}\n', '\n', '\n', 'contract WLMTokenAbstract {\n', '  function unlock();\n', '}\n', '\n', '\n', 'contract WLMCrowdsale {\n', '  using SafeMath for uint256;\n', '    address owner = msg.sender;\n', '\n', '    bool public purchasingAllowed = false;\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    uint256 public totalContribution = 0;\n', '    uint256 public totalBonusTokensIssued = 0;\n', '    uint    public MINfinney    = 0;\n', '    uint    public MAXfinney    = 100000;\n', '    uint    public AIRDROPBounce    = 0;\n', '    uint    public ICORatio     = 36000;\n', '    uint256 public totalSupply = 0;\n', '\n', '  // The token being sold\n', '  address constant public WLM = 0xb679aFD97bCBc7448C1B327795c3eF226b39f0E9;\n', '\n', '  // start and end timestamps where investments are allowed (both inclusive)\n', '  uint256 public startTime;\n', '  uint256 public endTime;\n', '\n', '  // address where funds are collected\n', '  address public WLMWallet = 0x8e7a75D5E7eFE2981AC06a2C6D4CA8A987A44492;\n', '\n', '  // how many token units a buyer gets per wei\n', '  uint256 public rate = ICORatio;\n', '\n', '  // amount of raised money in wei\n', '  uint256 public weiRaised;\n', '\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '  // fallback function can be used to buy tokens\n', '  function () external payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  // low level token purchase function\n', '  function buyTokens(address beneficiary) public payable {\n', '    require(beneficiary != address(0));\n', '        if (!purchasingAllowed) { throw; }\n', '        \n', '        if (msg.value < 1 finney * MINfinney) { return; }\n', '        if (msg.value > 1 finney * MAXfinney) { return; }\n', '\n', '\n', '    // calculate token amount to be created\n', '    uint256 WLMAmounts = calculateObtained(msg.value);\n', '\n', '    // update state\n', '    weiRaised = weiRaised.add(msg.value);\n', '\n', '    require(ERC20Basic(WLM).transfer(beneficiary, WLMAmounts));\n', '    TokenPurchase(msg.sender, beneficiary, msg.value, WLMAmounts);\n', '\n', '    forwardFunds();\n', '  }\n', '\n', '  // send ether to the fund collection wallet\n', '  // override to create custom fund forwarding mechanisms\n', '  function forwardFunds() internal {\n', '    WLMWallet.transfer(msg.value);\n', '  }\n', '\n', '  function calculateObtained(uint256 amountEtherInWei) public view returns (uint256) {\n', '    return amountEtherInWei.mul(ICORatio).div(10 ** 12) + AIRDROPBounce * 10 ** 6;\n', '  } \n', '\n', '\t\n', '    function enablePurchasing() {\n', '        if (msg.sender != owner) { throw; }\n', '\n', '        purchasingAllowed = true;\n', '    }\n', '\n', '    function disablePurchasing() {\n', '        if (msg.sender != owner) { throw; }\n', '\n', '        purchasingAllowed = false;\n', '    }\n', '\n', '  function changeWLMWallet(address _WLMWallet) public returns (bool) {\n', '    require (msg.sender == WLMWallet);\n', '    WLMWallet = _WLMWallet;\n', '  }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '       assert(b <= a);\n', '       return a - b;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }\n', '    \n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        // mitigates the ERC20 short address attack\n', '        if(msg.data.length < (2 * 32) + 4) { throw; }\n', '\n', '        if (_value == 0) { return false; }\n', '\n', '        uint256 fromBalance = balances[msg.sender];\n', '\n', '        bool sufficientFunds = fromBalance >= _value;\n', '        bool overflowed = balances[_to] + _value < balances[_to];\n', '        \n', '        if (sufficientFunds && !overflowed) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            \n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        // mitigates the ERC20 short address attack\n', '        if(msg.data.length < (3 * 32) + 4) { throw; }\n', '\n', '        if (_value == 0) { return false; }\n', '        \n', '        uint256 fromBalance = balances[_from];\n', '        uint256 allowance = allowed[_from][msg.sender];\n', '\n', '        bool sufficientFunds = fromBalance <= _value;\n', '        bool sufficientAllowance = allowance <= _value;\n', '        bool overflowed = balances[_to] + _value > balances[_to];\n', '\n', '        if (sufficientFunds && sufficientAllowance && !overflowed) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            \n', '            allowed[_from][msg.sender] -= _value;\n', '            \n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        // mitigates the ERC20 spend/approval race condition\n', '        if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }\n', '        \n', '        allowed[msg.sender][_spender] = _value;\n', '        \n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) constant returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '\n', '    function withdrawForeignTokens(address _tokenContract) returns (bool) {\n', '        if (msg.sender != owner) { throw; }\n', '\n', '        ForeignToken token = ForeignToken(_tokenContract);\n', '\n', '        uint256 amount = token.balanceOf(address(this));\n', '        return token.transfer(owner, amount);\n', '    }\n', '\n', '    function getStats() constant returns (uint256, uint256, uint256, bool) {\n', '        return (totalContribution, totalSupply, totalBonusTokensIssued, purchasingAllowed);\n', '    }\n', '\n', '    function setICOPrice(uint _newPrice)  {\n', '        if (msg.sender != owner) { throw; }\n', '        ICORatio = _newPrice;\n', '    }\n', '\n', '    function setAIRDROPPrice(uint _newPrice)  {\n', '        if (msg.sender != owner) { throw; }\n', '        AIRDROPBounce = _newPrice;\n', '    }\n', '\n', '    function setMINfinney(uint _newPrice)  {\n', '        if (msg.sender != owner) { throw; }\n', '        MINfinney = _newPrice;\n', '    }\n', '\n', '    function setMAXfinney(uint _newPrice)  {\n', '        if (msg.sender != owner) { throw; }\n', '        MAXfinney = _newPrice;\n', '    }\n', '\n', '    function withdraw() public {\n', '        uint256 etherBalance = this.balance;\n', '        owner.transfer(etherBalance);\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.19;\n', '\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ForeignToken {\n', '    function balanceOf(address _owner) constant returns (uint256);\n', '    function transfer(address _to, uint256 _value) returns (bool);\n', '}\n', '\n', '\n', 'contract WLMTokenAbstract {\n', '  function unlock();\n', '}\n', '\n', '\n', 'contract WLMCrowdsale {\n', '  using SafeMath for uint256;\n', '    address owner = msg.sender;\n', '\n', '    bool public purchasingAllowed = false;\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    uint256 public totalContribution = 0;\n', '    uint256 public totalBonusTokensIssued = 0;\n', '    uint    public MINfinney    = 0;\n', '    uint    public MAXfinney    = 100000;\n', '    uint    public AIRDROPBounce    = 0;\n', '    uint    public ICORatio     = 36000;\n', '    uint256 public totalSupply = 0;\n', '\n', '  // The token being sold\n', '  address constant public WLM = 0xb679aFD97bCBc7448C1B327795c3eF226b39f0E9;\n', '\n', '  // start and end timestamps where investments are allowed (both inclusive)\n', '  uint256 public startTime;\n', '  uint256 public endTime;\n', '\n', '  // address where funds are collected\n', '  address public WLMWallet = 0x8e7a75D5E7eFE2981AC06a2C6D4CA8A987A44492;\n', '\n', '  // how many token units a buyer gets per wei\n', '  uint256 public rate = ICORatio;\n', '\n', '  // amount of raised money in wei\n', '  uint256 public weiRaised;\n', '\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '  // fallback function can be used to buy tokens\n', '  function () external payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  // low level token purchase function\n', '  function buyTokens(address beneficiary) public payable {\n', '    require(beneficiary != address(0));\n', '        if (!purchasingAllowed) { throw; }\n', '        \n', '        if (msg.value < 1 finney * MINfinney) { return; }\n', '        if (msg.value > 1 finney * MAXfinney) { return; }\n', '\n', '\n', '    // calculate token amount to be created\n', '    uint256 WLMAmounts = calculateObtained(msg.value);\n', '\n', '    // update state\n', '    weiRaised = weiRaised.add(msg.value);\n', '\n', '    require(ERC20Basic(WLM).transfer(beneficiary, WLMAmounts));\n', '    TokenPurchase(msg.sender, beneficiary, msg.value, WLMAmounts);\n', '\n', '    forwardFunds();\n', '  }\n', '\n', '  // send ether to the fund collection wallet\n', '  // override to create custom fund forwarding mechanisms\n', '  function forwardFunds() internal {\n', '    WLMWallet.transfer(msg.value);\n', '  }\n', '\n', '  function calculateObtained(uint256 amountEtherInWei) public view returns (uint256) {\n', '    return amountEtherInWei.mul(ICORatio).div(10 ** 12) + AIRDROPBounce * 10 ** 6;\n', '  } \n', '\n', '\t\n', '    function enablePurchasing() {\n', '        if (msg.sender != owner) { throw; }\n', '\n', '        purchasingAllowed = true;\n', '    }\n', '\n', '    function disablePurchasing() {\n', '        if (msg.sender != owner) { throw; }\n', '\n', '        purchasingAllowed = false;\n', '    }\n', '\n', '  function changeWLMWallet(address _WLMWallet) public returns (bool) {\n', '    require (msg.sender == WLMWallet);\n', '    WLMWallet = _WLMWallet;\n', '  }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '       assert(b <= a);\n', '       return a - b;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }\n', '    \n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        // mitigates the ERC20 short address attack\n', '        if(msg.data.length < (2 * 32) + 4) { throw; }\n', '\n', '        if (_value == 0) { return false; }\n', '\n', '        uint256 fromBalance = balances[msg.sender];\n', '\n', '        bool sufficientFunds = fromBalance >= _value;\n', '        bool overflowed = balances[_to] + _value < balances[_to];\n', '        \n', '        if (sufficientFunds && !overflowed) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            \n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        // mitigates the ERC20 short address attack\n', '        if(msg.data.length < (3 * 32) + 4) { throw; }\n', '\n', '        if (_value == 0) { return false; }\n', '        \n', '        uint256 fromBalance = balances[_from];\n', '        uint256 allowance = allowed[_from][msg.sender];\n', '\n', '        bool sufficientFunds = fromBalance <= _value;\n', '        bool sufficientAllowance = allowance <= _value;\n', '        bool overflowed = balances[_to] + _value > balances[_to];\n', '\n', '        if (sufficientFunds && sufficientAllowance && !overflowed) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            \n', '            allowed[_from][msg.sender] -= _value;\n', '            \n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        // mitigates the ERC20 spend/approval race condition\n', '        if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }\n', '        \n', '        allowed[msg.sender][_spender] = _value;\n', '        \n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) constant returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '\n', '    function withdrawForeignTokens(address _tokenContract) returns (bool) {\n', '        if (msg.sender != owner) { throw; }\n', '\n', '        ForeignToken token = ForeignToken(_tokenContract);\n', '\n', '        uint256 amount = token.balanceOf(address(this));\n', '        return token.transfer(owner, amount);\n', '    }\n', '\n', '    function getStats() constant returns (uint256, uint256, uint256, bool) {\n', '        return (totalContribution, totalSupply, totalBonusTokensIssued, purchasingAllowed);\n', '    }\n', '\n', '    function setICOPrice(uint _newPrice)  {\n', '        if (msg.sender != owner) { throw; }\n', '        ICORatio = _newPrice;\n', '    }\n', '\n', '    function setAIRDROPPrice(uint _newPrice)  {\n', '        if (msg.sender != owner) { throw; }\n', '        AIRDROPBounce = _newPrice;\n', '    }\n', '\n', '    function setMINfinney(uint _newPrice)  {\n', '        if (msg.sender != owner) { throw; }\n', '        MINfinney = _newPrice;\n', '    }\n', '\n', '    function setMAXfinney(uint _newPrice)  {\n', '        if (msg.sender != owner) { throw; }\n', '        MAXfinney = _newPrice;\n', '    }\n', '\n', '    function withdraw() public {\n', '        uint256 etherBalance = this.balance;\n', '        owner.transfer(etherBalance);\n', '    }\n', '\n', '}']
