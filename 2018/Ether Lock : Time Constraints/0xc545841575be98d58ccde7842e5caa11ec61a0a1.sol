['pragma solidity ^0.4.16;\n', '\n', 'interface TrimpoToken {\n', '\n', '  function presaleAddr() constant returns (address);\n', '  function transferPresale(address _to, uint _value) public;\n', '\n', '}\n', '\n', 'contract Admins {\n', '  address public admin1;\n', '\n', '  address public admin2;\n', '\n', '  address public admin3;\n', '\n', '  function Admins(address a1, address a2, address a3) public {\n', '    admin1 = a1;\n', '    admin2 = a2;\n', '    admin3 = a3;\n', '  }\n', '\n', '  modifier onlyAdmins {\n', '    require(msg.sender == admin1 || msg.sender == admin2 || msg.sender == admin3);\n', '    _;\n', '  }\n', '\n', '  function setAdmin(address _adminAddress) onlyAdmins public {\n', '\n', '    require(_adminAddress != admin1);\n', '    require(_adminAddress != admin2);\n', '    require(_adminAddress != admin3);\n', '\n', '    if (admin1 == msg.sender) {\n', '      admin1 = _adminAddress;\n', '    }\n', '    else\n', '    if (admin2 == msg.sender) {\n', '      admin2 = _adminAddress;\n', '    }\n', '    else\n', '    if (admin3 == msg.sender) {\n', '      admin3 = _adminAddress;\n', '    }\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract Presale is Admins {\n', '\n', '\n', '  uint public duration;\n', '\n', '  uint public period;\n', '\n', '  uint public periodAmount;\n', '\n', '  uint public hardCap;\n', '\n', '  uint public raised;\n', '\n', '  address public benefit;\n', '\n', '  uint public start;\n', '\n', '  TrimpoToken token;\n', '\n', '  address public tokenAddress;\n', '\n', '  uint public tokensPerEther;\n', '\n', '  mapping (address => uint) public balanceOf;\n', '\n', '  mapping (uint => uint) public periodBonuses;\n', '\n', '  struct amountBonusStruct {\n', '  uint value;\n', '  uint bonus;\n', '  }\n', '\n', '  mapping (uint => amountBonusStruct)  public amountBonuses;\n', '\n', '\n', '  modifier goodDate {\n', '    require(start > 0);\n', '    require(start <= now);\n', '    require((start+duration) > now);\n', '    _;\n', '  }\n', '\n', '  modifier belowHardCap {\n', '    require(raised < hardCap);\n', '    _;\n', '  }\n', '\n', '  event Investing(address investor, uint investedFunds, uint tokensWithoutBonus, uint periodBounus, uint amountBonus, uint tokens);\n', '  event Raise(address to, uint funds);\n', '\n', '\n', '  function Presale(\n', '  address _tokenAddress,\n', '  address a1,\n', '  address a2,\n', '  address a3\n', '  ) Admins(a1, a2, a3) public {\n', '\n', '    hardCap = 5000 ether;\n', '\n', '    period = 7 days;\n', '\n', '    periodAmount = 4;\n', '\n', '    periodBonuses[0] = 20;\n', '    periodBonuses[1] = 15;\n', '    periodBonuses[2] = 10;\n', '    periodBonuses[3] = 5;\n', '\n', '    duration = periodAmount * (period);\n', '\n', '    amountBonuses[0].value = 125 ether;\n', '    amountBonuses[0].bonus = 5;\n', '\n', '    amountBonuses[1].value = 250 ether;\n', '    amountBonuses[1].bonus = 10;\n', '\n', '    amountBonuses[2].value = 375 ether;\n', '    amountBonuses[2].bonus = 15;\n', '\n', '    amountBonuses[3].value = 500 ether;\n', '    amountBonuses[3].bonus = 20;\n', '\n', '    tokensPerEther = 400;\n', '\n', '    tokenAddress = _tokenAddress;\n', '\n', '    token = TrimpoToken(_tokenAddress);\n', '\n', '    start = 1526342400; //15 May UTC 00:00\n', '\n', '  }\n', '\n', '\n', '  function getPeriodBounus() public returns (uint bonus) {\n', '    if (start == 0) {return 0;}\n', '    else if (start + period > now) {\n', '      return periodBonuses[0];\n', '    } else if (start + period * 2 > now) {\n', '      return periodBonuses[1];\n', '    } else if (start + period * 3 > now) {\n', '      return periodBonuses[2];\n', '    } else if (start + period * 4 > now) {\n', '      return periodBonuses[3];\n', '    }\n', '    return 0;\n', '\n', '\n', '  }\n', '\n', '  function getAmountBounus(uint value) public returns (uint bonus) {\n', '    if (value >= amountBonuses[3].value) {\n', '      return amountBonuses[3].bonus;\n', '    } else if (value >= amountBonuses[2].value) {\n', '      return amountBonuses[2].bonus;\n', '    } else if (value >= amountBonuses[1].value) {\n', '      return amountBonuses[1].bonus;\n', '    } else if (value >= amountBonuses[0].value) {\n', '      return amountBonuses[0].bonus;\n', '    }\n', '    return 0;\n', '  }\n', '\n', '  function() payable public goodDate belowHardCap {\n', '\n', '    uint tokenAmountWithoutBonus = msg.value * tokensPerEther;\n', '\n', '    uint periodBonus = getPeriodBounus();\n', '\n', '    uint amountBonus = getAmountBounus(msg.value);\n', '\n', '    uint tokenAmount = tokenAmountWithoutBonus + (tokenAmountWithoutBonus * (periodBonus + amountBonus)/100);\n', '\n', '    token.transferPresale(msg.sender, tokenAmount);\n', '\n', '    raised+=msg.value;\n', '\n', '    balanceOf[msg.sender]+= msg.value;\n', '\n', '    Investing(msg.sender, msg.value, tokenAmountWithoutBonus, periodBonus, amountBonus, tokenAmount);\n', '\n', '  }\n', '\n', '  function setBenefit(address _benefit) public onlyAdmins {\n', '    benefit = _benefit;\n', '  }\n', '\n', '  function getFunds(uint amount) public onlyAdmins {\n', '    require(benefit != 0x0);\n', '    require(amount <= this.balance);\n', '    Raise(benefit, amount);\n', '    benefit.send(amount);\n', '  }\n', '\n', '\n', '\n', '\n', '}']
['pragma solidity ^0.4.16;\n', '\n', 'interface TrimpoToken {\n', '\n', '  function presaleAddr() constant returns (address);\n', '  function transferPresale(address _to, uint _value) public;\n', '\n', '}\n', '\n', 'contract Admins {\n', '  address public admin1;\n', '\n', '  address public admin2;\n', '\n', '  address public admin3;\n', '\n', '  function Admins(address a1, address a2, address a3) public {\n', '    admin1 = a1;\n', '    admin2 = a2;\n', '    admin3 = a3;\n', '  }\n', '\n', '  modifier onlyAdmins {\n', '    require(msg.sender == admin1 || msg.sender == admin2 || msg.sender == admin3);\n', '    _;\n', '  }\n', '\n', '  function setAdmin(address _adminAddress) onlyAdmins public {\n', '\n', '    require(_adminAddress != admin1);\n', '    require(_adminAddress != admin2);\n', '    require(_adminAddress != admin3);\n', '\n', '    if (admin1 == msg.sender) {\n', '      admin1 = _adminAddress;\n', '    }\n', '    else\n', '    if (admin2 == msg.sender) {\n', '      admin2 = _adminAddress;\n', '    }\n', '    else\n', '    if (admin3 == msg.sender) {\n', '      admin3 = _adminAddress;\n', '    }\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract Presale is Admins {\n', '\n', '\n', '  uint public duration;\n', '\n', '  uint public period;\n', '\n', '  uint public periodAmount;\n', '\n', '  uint public hardCap;\n', '\n', '  uint public raised;\n', '\n', '  address public benefit;\n', '\n', '  uint public start;\n', '\n', '  TrimpoToken token;\n', '\n', '  address public tokenAddress;\n', '\n', '  uint public tokensPerEther;\n', '\n', '  mapping (address => uint) public balanceOf;\n', '\n', '  mapping (uint => uint) public periodBonuses;\n', '\n', '  struct amountBonusStruct {\n', '  uint value;\n', '  uint bonus;\n', '  }\n', '\n', '  mapping (uint => amountBonusStruct)  public amountBonuses;\n', '\n', '\n', '  modifier goodDate {\n', '    require(start > 0);\n', '    require(start <= now);\n', '    require((start+duration) > now);\n', '    _;\n', '  }\n', '\n', '  modifier belowHardCap {\n', '    require(raised < hardCap);\n', '    _;\n', '  }\n', '\n', '  event Investing(address investor, uint investedFunds, uint tokensWithoutBonus, uint periodBounus, uint amountBonus, uint tokens);\n', '  event Raise(address to, uint funds);\n', '\n', '\n', '  function Presale(\n', '  address _tokenAddress,\n', '  address a1,\n', '  address a2,\n', '  address a3\n', '  ) Admins(a1, a2, a3) public {\n', '\n', '    hardCap = 5000 ether;\n', '\n', '    period = 7 days;\n', '\n', '    periodAmount = 4;\n', '\n', '    periodBonuses[0] = 20;\n', '    periodBonuses[1] = 15;\n', '    periodBonuses[2] = 10;\n', '    periodBonuses[3] = 5;\n', '\n', '    duration = periodAmount * (period);\n', '\n', '    amountBonuses[0].value = 125 ether;\n', '    amountBonuses[0].bonus = 5;\n', '\n', '    amountBonuses[1].value = 250 ether;\n', '    amountBonuses[1].bonus = 10;\n', '\n', '    amountBonuses[2].value = 375 ether;\n', '    amountBonuses[2].bonus = 15;\n', '\n', '    amountBonuses[3].value = 500 ether;\n', '    amountBonuses[3].bonus = 20;\n', '\n', '    tokensPerEther = 400;\n', '\n', '    tokenAddress = _tokenAddress;\n', '\n', '    token = TrimpoToken(_tokenAddress);\n', '\n', '    start = 1526342400; //15 May UTC 00:00\n', '\n', '  }\n', '\n', '\n', '  function getPeriodBounus() public returns (uint bonus) {\n', '    if (start == 0) {return 0;}\n', '    else if (start + period > now) {\n', '      return periodBonuses[0];\n', '    } else if (start + period * 2 > now) {\n', '      return periodBonuses[1];\n', '    } else if (start + period * 3 > now) {\n', '      return periodBonuses[2];\n', '    } else if (start + period * 4 > now) {\n', '      return periodBonuses[3];\n', '    }\n', '    return 0;\n', '\n', '\n', '  }\n', '\n', '  function getAmountBounus(uint value) public returns (uint bonus) {\n', '    if (value >= amountBonuses[3].value) {\n', '      return amountBonuses[3].bonus;\n', '    } else if (value >= amountBonuses[2].value) {\n', '      return amountBonuses[2].bonus;\n', '    } else if (value >= amountBonuses[1].value) {\n', '      return amountBonuses[1].bonus;\n', '    } else if (value >= amountBonuses[0].value) {\n', '      return amountBonuses[0].bonus;\n', '    }\n', '    return 0;\n', '  }\n', '\n', '  function() payable public goodDate belowHardCap {\n', '\n', '    uint tokenAmountWithoutBonus = msg.value * tokensPerEther;\n', '\n', '    uint periodBonus = getPeriodBounus();\n', '\n', '    uint amountBonus = getAmountBounus(msg.value);\n', '\n', '    uint tokenAmount = tokenAmountWithoutBonus + (tokenAmountWithoutBonus * (periodBonus + amountBonus)/100);\n', '\n', '    token.transferPresale(msg.sender, tokenAmount);\n', '\n', '    raised+=msg.value;\n', '\n', '    balanceOf[msg.sender]+= msg.value;\n', '\n', '    Investing(msg.sender, msg.value, tokenAmountWithoutBonus, periodBonus, amountBonus, tokenAmount);\n', '\n', '  }\n', '\n', '  function setBenefit(address _benefit) public onlyAdmins {\n', '    benefit = _benefit;\n', '  }\n', '\n', '  function getFunds(uint amount) public onlyAdmins {\n', '    require(benefit != 0x0);\n', '    require(amount <= this.balance);\n', '    Raise(benefit, amount);\n', '    benefit.send(amount);\n', '  }\n', '\n', '\n', '\n', '\n', '}']
