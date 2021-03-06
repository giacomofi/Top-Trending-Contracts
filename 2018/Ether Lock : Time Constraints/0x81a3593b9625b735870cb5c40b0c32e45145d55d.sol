['pragma solidity ^0.4.24;\n', '\n', 'contract Ownable {}\n', 'contract AddressesFilterFeature is Ownable {}\n', 'contract ERC20Basic {}\n', 'contract BasicToken is ERC20Basic {}\n', 'contract ERC20 {}\n', 'contract StandardToken is ERC20, BasicToken {}\n', 'contract MintableToken is AddressesFilterFeature, StandardToken {}\n', '\n', 'contract Token is MintableToken {\n', '  mapping(address => uint256) balances;\n', '  function transfer(address _to, uint256 _value) public returns (bool);\n', '  function balanceOf(address owner) public view returns (uint256);\n', '}\n', '\n', 'contract VestingContractCT {\n', '  //storage\n', '  address public owner;\n', '  Token public company_token;\n', '\n', '  address public PartnerAccount;\n', '  uint public originalBalance;\n', '  uint public currentBalance;\n', '  uint public alreadyTransfered;\n', '  uint public startDateOfPayments;\n', '  uint public endDateOfPayments;\n', '  uint public periodOfOnePayments;\n', '  uint public limitPerPeriod;\n', '  uint public daysOfPayments;\n', '\n', '  //modifiers\n', '  modifier onlyOwner\n', '  {\n', '    require(owner == msg.sender);\n', '    _;\n', '  }\n', '  \n', '  \n', '  //Events\n', '  event Transfer(address indexed to, uint indexed value);\n', '  event OwnerChanged(address indexed owner);\n', '\n', '\n', '  //constructor\n', '  constructor (Token _company_token) public {\n', '    owner = msg.sender;\n', '    PartnerAccount = 0xD99cc20B0699Ae9C8DA1640e03D05925ddD8acd2;\n', '    company_token = _company_token;\n', '    originalBalance = 1785714 * 10**18; // 1 785 714 WPT\n', '    currentBalance = originalBalance;\n', '    alreadyTransfered = 0;\n', '    startDateOfPayments = 1554069600; //From 01 Apr 2019, 00:00:00\n', '    endDateOfPayments = 1569880800; //From 01 Oct 2019, 00:00:00\n', '    periodOfOnePayments = 24 * 60 * 60; // 1 day in seconds\n', '    daysOfPayments = (endDateOfPayments - startDateOfPayments) / periodOfOnePayments; // 183 days\n', '    limitPerPeriod = originalBalance / daysOfPayments;\n', '  }\n', '\n', '\n', '  /// @dev Fallback function: don&#39;t accept ETH\n', '  function()\n', '    public\n', '    payable\n', '  {\n', '    revert();\n', '  }\n', '\n', '\n', '  /// @dev Get current balance of the contract\n', '  function getBalance()\n', '    constant\n', '    public\n', '    returns(uint)\n', '  {\n', '    return company_token.balanceOf(this);\n', '  }\n', '\n', '\n', '  function setOwner(address _owner) \n', '    public \n', '    onlyOwner \n', '  {\n', '    require(_owner != 0);\n', '    \n', '    owner = _owner;\n', '    emit OwnerChanged(owner);\n', '  }\n', '  \n', '  function sendCurrentPayment() public {\n', '    uint currentPeriod = (now - startDateOfPayments) / periodOfOnePayments;\n', '    uint currentLimit = currentPeriod * limitPerPeriod;\n', '    uint unsealedAmount = currentLimit - alreadyTransfered;\n', '    if (unsealedAmount > 0) {\n', '      if (currentBalance >= unsealedAmount) {\n', '        company_token.transfer(PartnerAccount, unsealedAmount);\n', '        alreadyTransfered += unsealedAmount;\n', '        currentBalance -= unsealedAmount;\n', '        emit Transfer(PartnerAccount, unsealedAmount);\n', '      } else {\n', '        company_token.transfer(PartnerAccount, currentBalance);\n', '        alreadyTransfered += currentBalance;\n', '        currentBalance -= currentBalance;\n', '        emit Transfer(PartnerAccount, currentBalance);\n', '      }\n', '    }\n', '  }\n', '}']