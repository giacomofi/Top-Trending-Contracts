['pragma solidity ^0.4.15;\n', '\n', 'library SafeMathLib {\n', '\n', '  function times(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function minus(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function plus(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a);\n', '    return c;\n', '  }\n', '\n', '  function divide(uint a, uint b) internal returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', '//basic ownership contract\n', 'contract Owned {\n', '    address public owner;\n', '\n', '    //ensures only owner can call functions\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    //constructor makes sets owner to contract deployer\n', '    function Owned() public { owner = msg.sender;}\n', '\n', '    //update owner\n', '    function changeOwner(address _newOwner) public onlyOwner {\n', '        owner = _newOwner;\n', '        NewOwner(msg.sender, _newOwner);\n', '    }\n', '\n', '    event NewOwner(address indexed oldOwner, address indexed newOwner);\n', '}\n', '\n', '/**\n', ' * Collect funds from presale investors to be manually send to the crowdsale smart contract later.\n', ' *\n', ' * - Collect funds from pre-sale investors\n', ' * - Send funds to an specified address when the pre-sale ends\n', ' * \n', ' */ \n', 'contract DadaPresaleFundCollector is Owned {\n', '\n', '  using SafeMathLib for uint;\n', '\n', '  address public presaleAddressAmountHolder = 0xF636c93F98588b7F1624C8EC4087702E5BE876b6;\n', '\n', '  /** How much they have invested */\n', '  mapping(address => uint) public balances;\n', '\n', '  /** What is the minimum buy in */\n', '  uint constant maximumIndividualCap = 500 ether;\n', '  // Limit in Ether for this contract to allow investment\n', '  uint constant etherCap = 3000 ether;\n', '\n', '  /** Have we begun to move funds */\n', '  bool public moving;\n', '\n', '  // turned off while doing initial configuration of the whitelist\n', '  bool public isExecutionAllowed;\n', '\n', '  // turned on when the refund function is allowed to be isExecutionAllowed\n', '  bool public isRefundAllowed;\n', '  \n', '  // Used to handle if the cap was reached due to investment received \n', '  // in either Bitcoin or USD\n', '  bool public isCapReached;\n', '\n', '  bool public isFinalized;\n', '\n', '  mapping (address => bool) public whitelist;\n', '\n', '  event Invested(address investor, uint value);\n', '  event Refunded(address investor, uint value);\n', '  event WhitelistUpdated(address whitelistedAddress, bool isWhitelisted);\n', '  event EmptiedToWallet(address wallet);\n', '\n', '  /**\n', '   * Create presale contract where lock up period is given days\n', '   */\n', '  function DadaPresaleFundCollector() public {\n', '\n', '  }\n', '\n', '  /**\n', '  * Whitelist handler function \n', '  **/\n', '  function updateWhitelist(address whitelistedAddress, bool isWhitelisted) public onlyOwner {\n', '    whitelist[whitelistedAddress] = isWhitelisted;\n', '    WhitelistUpdated(whitelistedAddress, isWhitelisted);\n', '  }\n', '\n', '  /**\n', '   * Participate in the presale.\n', '   */\n', '  function invest() public payable {\n', '    // execution shoulf be turned ON\n', '    require(isExecutionAllowed);\n', "    // the cap shouldn't be reached yet\n", '    require(!isCapReached);\n', '    // the final balance of the contract should not be greater than\n', '    // the etherCap\n', '    uint currentBalance = this.balance;\n', '    require(currentBalance <= etherCap);\n', '\n', '    // Cannot invest anymore through crowdsale when moving has begun\n', '    require(!moving);\n', '    address investor = msg.sender;\n', '    // the investor is whitlisted\n', '    require(whitelist[investor]);\n', '    \n', "    // the total balance of the user shouldn't be greater than the maximumIndividualCap\n", '    require((balances[investor].plus(msg.value)) <= maximumIndividualCap);\n', '\n', '    require(msg.value <= maximumIndividualCap);\n', '    balances[investor] = balances[investor].plus(msg.value);\n', '    // if the cap is reached then turn ON the flag\n', '    if (currentBalance == etherCap){\n', '      isCapReached = true;\n', '    }\n', '    Invested(investor, msg.value);\n', '  }\n', '\n', '  /**\n', '   * Allow refund if isRefundAllowed is ON.\n', '   */\n', '  function refund() public {\n', '    require(isRefundAllowed);\n', '    address investor = msg.sender;\n', '    require(this.balance > 0);\n', '    require(balances[investor] > 0);\n', '    // We have started to move funds\n', '    moving = true;\n', '    uint amount = balances[investor];\n', '    balances[investor] = 0;\n', '    investor.transfer(amount);\n', '    Refunded(investor, amount);\n', '  }\n', '\n', '  // utility functions\n', '  function emptyToWallet() public onlyOwner {\n', '    require(!isFinalized);\n', '    isFinalized = true;\n', '    moving = true;\n', '    presaleAddressAmountHolder.transfer(this.balance);\n', '    EmptiedToWallet(presaleAddressAmountHolder); \n', '  }  \n', '\n', '  function flipExecutionSwitchTo(bool state) public onlyOwner{\n', '    isExecutionAllowed = state;\n', '  }\n', '\n', '  function flipCapSwitchTo(bool state) public onlyOwner{\n', '    isCapReached = state;\n', '  }\n', '\n', '  function flipRefundSwitchTo(bool state) public onlyOwner{\n', '    isRefundAllowed = state;\n', '  }\n', '\n', '  function flipFinalizedSwitchTo(bool state) public onlyOwner{\n', '    isFinalized = state;\n', '  }\n', '\n', '  function flipMovingSwitchTo(bool state) public onlyOwner{\n', '    moving = state;\n', '  }  \n', '\n', '  /** Explicitly call function from your wallet. */\n', '  function() public payable {\n', '    revert();\n', '  }\n', '}']