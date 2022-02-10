['pragma solidity ^0.4.24;\n', '\n', 'contract ERC20Basic {}\n', 'contract ERC20 is ERC20Basic {}\n', 'contract Ownable {}\n', 'contract BasicToken is ERC20Basic {}\n', 'contract StandardToken is ERC20, BasicToken {}\n', 'contract Pausable is Ownable {}\n', 'contract PausableToken is StandardToken, Pausable {}\n', 'contract MintableToken is StandardToken, Ownable {}\n', '\n', 'contract OpiriaToken is MintableToken, PausableToken {\n', '  mapping(address => uint256) balances;\n', '  function transfer(address _to, uint256 _value) public returns (bool);\n', '  function balanceOf(address who) public view returns (uint256);\n', '}\n', '\n', 'contract VestingContractCT {\n', '  //storage\n', '  address public owner;\n', '  OpiriaToken public company_token;\n', '\n', '  address public PartnerAccount;\n', '  uint public originalBalance;\n', '  uint public currentBalance;\n', '  uint public alreadyTransfered;\n', '  uint public startDateOfPayments;\n', '  uint public endDateOfPayments;\n', '  uint public periodOfOnePayments;\n', '  uint public limitPerPeriod;\n', '  uint public daysOfPayments;\n', '\n', '  //modifiers\n', '  modifier onlyOwner\n', '  {\n', '    require(owner == msg.sender);\n', '    _;\n', '  }\n', '  \n', '  \n', '  //Events\n', '  event Transfer(address indexed to, uint indexed value);\n', '  event OwnerChanged(address indexed owner);\n', '\n', '\n', '  //constructor\n', '  constructor (OpiriaToken _company_token) public {\n', '    owner = msg.sender;\n', '    PartnerAccount = 0x89a380E3d71a71C51441EBd7bf512543a4F6caE7;\n', '    company_token = _company_token;\n', '    originalBalance = 2500000 * 10**18; // 2 500 000 PDATA\n', '    currentBalance = originalBalance;\n', '    alreadyTransfered = 0;\n', '    startDateOfPayments = 1554069600; //From 01 Apr 2019, 00:00:00\n', '    endDateOfPayments = 1569880800; //From 01 Oct 2019, 00:00:00\n', '    periodOfOnePayments = 24 * 60 * 60; // 1 day in seconds\n', '    daysOfPayments = (endDateOfPayments - startDateOfPayments) / periodOfOnePayments; // 183 days\n', '    limitPerPeriod = originalBalance / daysOfPayments;\n', '  }\n', '\n', '\n', '  /// @dev Fallback function: don&#39;t accept ETH\n', '  function()\n', '    public\n', '    payable\n', '  {\n', '    revert();\n', '  }\n', '\n', '\n', '  /// @dev Get current balance of the contract\n', '  function getBalance()\n', '    constant\n', '    public\n', '    returns(uint)\n', '  {\n', '    return company_token.balanceOf(this);\n', '  }\n', '\n', '\n', '  function setOwner(address _owner) \n', '    public \n', '    onlyOwner \n', '  {\n', '    require(_owner != 0);\n', '    \n', '    owner = _owner;\n', '    emit OwnerChanged(owner);\n', '  }\n', '  \n', '  function sendCurrentPayment() public {\n', '    uint currentPeriod = (now - startDateOfPayments) / periodOfOnePayments;\n', '    uint currentLimit = currentPeriod * limitPerPeriod;\n', '    uint unsealedAmount = currentLimit - alreadyTransfered;\n', '    if (unsealedAmount > 0) {\n', '      if (currentBalance >= unsealedAmount) {\n', '        company_token.transfer(PartnerAccount, unsealedAmount);\n', '        alreadyTransfered += unsealedAmount;\n', '        currentBalance -= unsealedAmount;\n', '        emit Transfer(PartnerAccount, unsealedAmount);\n', '      } else {\n', '        company_token.transfer(PartnerAccount, currentBalance);\n', '        alreadyTransfered += currentBalance;\n', '        currentBalance -= currentBalance;\n', '        emit Transfer(PartnerAccount, currentBalance);\n', '      }\n', '    }\n', '  }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', 'contract ERC20Basic {}\n', 'contract ERC20 is ERC20Basic {}\n', 'contract Ownable {}\n', 'contract BasicToken is ERC20Basic {}\n', 'contract StandardToken is ERC20, BasicToken {}\n', 'contract Pausable is Ownable {}\n', 'contract PausableToken is StandardToken, Pausable {}\n', 'contract MintableToken is StandardToken, Ownable {}\n', '\n', 'contract OpiriaToken is MintableToken, PausableToken {\n', '  mapping(address => uint256) balances;\n', '  function transfer(address _to, uint256 _value) public returns (bool);\n', '  function balanceOf(address who) public view returns (uint256);\n', '}\n', '\n', 'contract VestingContractCT {\n', '  //storage\n', '  address public owner;\n', '  OpiriaToken public company_token;\n', '\n', '  address public PartnerAccount;\n', '  uint public originalBalance;\n', '  uint public currentBalance;\n', '  uint public alreadyTransfered;\n', '  uint public startDateOfPayments;\n', '  uint public endDateOfPayments;\n', '  uint public periodOfOnePayments;\n', '  uint public limitPerPeriod;\n', '  uint public daysOfPayments;\n', '\n', '  //modifiers\n', '  modifier onlyOwner\n', '  {\n', '    require(owner == msg.sender);\n', '    _;\n', '  }\n', '  \n', '  \n', '  //Events\n', '  event Transfer(address indexed to, uint indexed value);\n', '  event OwnerChanged(address indexed owner);\n', '\n', '\n', '  //constructor\n', '  constructor (OpiriaToken _company_token) public {\n', '    owner = msg.sender;\n', '    PartnerAccount = 0x89a380E3d71a71C51441EBd7bf512543a4F6caE7;\n', '    company_token = _company_token;\n', '    originalBalance = 2500000 * 10**18; // 2 500 000 PDATA\n', '    currentBalance = originalBalance;\n', '    alreadyTransfered = 0;\n', '    startDateOfPayments = 1554069600; //From 01 Apr 2019, 00:00:00\n', '    endDateOfPayments = 1569880800; //From 01 Oct 2019, 00:00:00\n', '    periodOfOnePayments = 24 * 60 * 60; // 1 day in seconds\n', '    daysOfPayments = (endDateOfPayments - startDateOfPayments) / periodOfOnePayments; // 183 days\n', '    limitPerPeriod = originalBalance / daysOfPayments;\n', '  }\n', '\n', '\n', "  /// @dev Fallback function: don't accept ETH\n", '  function()\n', '    public\n', '    payable\n', '  {\n', '    revert();\n', '  }\n', '\n', '\n', '  /// @dev Get current balance of the contract\n', '  function getBalance()\n', '    constant\n', '    public\n', '    returns(uint)\n', '  {\n', '    return company_token.balanceOf(this);\n', '  }\n', '\n', '\n', '  function setOwner(address _owner) \n', '    public \n', '    onlyOwner \n', '  {\n', '    require(_owner != 0);\n', '    \n', '    owner = _owner;\n', '    emit OwnerChanged(owner);\n', '  }\n', '  \n', '  function sendCurrentPayment() public {\n', '    uint currentPeriod = (now - startDateOfPayments) / periodOfOnePayments;\n', '    uint currentLimit = currentPeriod * limitPerPeriod;\n', '    uint unsealedAmount = currentLimit - alreadyTransfered;\n', '    if (unsealedAmount > 0) {\n', '      if (currentBalance >= unsealedAmount) {\n', '        company_token.transfer(PartnerAccount, unsealedAmount);\n', '        alreadyTransfered += unsealedAmount;\n', '        currentBalance -= unsealedAmount;\n', '        emit Transfer(PartnerAccount, unsealedAmount);\n', '      } else {\n', '        company_token.transfer(PartnerAccount, currentBalance);\n', '        alreadyTransfered += currentBalance;\n', '        currentBalance -= currentBalance;\n', '        emit Transfer(PartnerAccount, currentBalance);\n', '      }\n', '    }\n', '  }\n', '}']
