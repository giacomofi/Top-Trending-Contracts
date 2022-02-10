['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'pragma solidity ^0.4.11;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract DebtToken {\n', '  using SafeMath for uint256;\n', '  /**\n', '  Recognition data\n', '  */\n', '  string public name;\n', '  string public symbol;\n', "  string public version = 'DT0.1';\n", '  uint256 public decimals = 18;\n', '\n', '  /**\n', '  ERC20 properties\n', '  */\n', '  uint256 public totalSupply;\n', '  mapping(address => uint256) public balances;\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '  /**\n', '  Mintable Token properties\n', '  */\n', '  bool public mintingFinished = true;\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  /**\n', '  Actual logic data\n', '  */\n', '  uint256 public dayLength;//Number of seconds in a day\n', '  uint256 public loanTerm;//Loan term in days\n', '  uint256 public exchangeRate; //Exchange rate for Ether to loan coins\n', '  uint256 public initialSupply; //Keep record of Initial value of Loan\n', '  uint256 public loanActivation; //Timestamp the loan was funded\n', '  \n', '  uint256 public interestRatePerCycle; //Interest rate per interest cycle\n', '  uint256 public interestCycleLength; //Total number of days per interest cycle\n', '  \n', '  uint256 public totalInterestCycles; //Total number of interest cycles completed\n', '  uint256 public lastInterestCycle; //Keep record of Initial value of Loan\n', '  \n', '  address public lender; //The address from which the loan will be funded, and to which the refund will be directed\n', '  address public borrower;\n', '  \n', '  uint256 public constant PERCENT_DIVISOR = 100;\n', '  \n', '  function DebtToken(\n', '      string _tokenName,\n', '      string _tokenSymbol,\n', '      uint256 _initialAmount,\n', '      uint256 _exchangeRate,\n', '      uint256 _dayLength,\n', '      uint256 _loanTerm,\n', '      uint256 _loanCycle,\n', '      uint256 _interestRatePerCycle,\n', '      address _lender,\n', '      address _borrower\n', '      ) {\n', '\n', '      require(_exchangeRate > 0);\n', '      require(_initialAmount > 0);\n', '      require(_dayLength > 0);\n', '      require(_loanCycle > 0);\n', '\n', '      require(_lender != 0x0);\n', '      require(_borrower != 0x0);\n', '      \n', '      exchangeRate = _exchangeRate;                           // Exchange rate for the coins\n', '      initialSupply = _initialAmount.mul(exchangeRate);            // Update initial supply\n', '      totalSupply = initialSupply;                           //Update total supply\n', '      balances[_borrower] = initialSupply;                 // Give the creator all initial tokens\n', '\n', '      name = _tokenName;                                    // Amount of decimals for display purposes\n', '      symbol = _tokenSymbol;                              // Set the symbol for display purposes\n', '      \n', '      dayLength = _dayLength;                             //Set the length of each day in seconds...For dev purposes\n', '      loanTerm = _loanTerm;                               //Set the number of days, for loan maturity\n', '      interestCycleLength = _loanCycle;                   //set the Interest cycle period\n', '      interestRatePerCycle = _interestRatePerCycle;                      //Set the Interest rate per cycle\n', '      lender = _lender;                             //set lender address\n', '      borrower = _borrower;\n', '\n', '      Transfer(0,_borrower,totalSupply);//Allow funding be tracked\n', '  }\n', '\n', '  /**\n', '  Debt token functionality\n', '   */\n', '  function actualTotalSupply() public constant returns(uint) {\n', '    uint256 coins;\n', '    uint256 cycle;\n', '    (coins,cycle) = calculateInterestDue();\n', '    return totalSupply.add(coins);\n', '  }\n', '\n', '  /**\n', '  Fetch total value of loan in wei (Initial +interest)\n', '  */\n', '  function getLoanValue(bool initial) public constant returns(uint){\n', '    //TODO get a more dynamic way to calculate\n', '    if(initial == true)\n', '      return initialSupply.div(exchangeRate);\n', '    else{\n', '      uint totalTokens = actualTotalSupply().sub(balances[borrower]);\n', '      return totalTokens.div(exchangeRate);\n', '    }\n', '  }\n', '\n', '  /**\n', '  Fetch total coins gained from interest\n', '  */\n', '  function getInterest() public constant returns (uint){\n', '    return actualTotalSupply().sub(initialSupply);\n', '  }\n', '\n', '  /**\n', "  Checks that caller's address is the lender\n", '  */\n', '  function isLender() private constant returns(bool){\n', '    return msg.sender == lender;\n', '  }\n', '\n', '  /**\n', "  Check that caller's address is the borrower\n", '  */\n', '  function isBorrower() private constant returns (bool){\n', '    return msg.sender == borrower;\n', '  }\n', '\n', '  function isLoanFunded() public constant returns(bool) {\n', '    return balances[lender] > 0 && balances[borrower] == 0;\n', '  }\n', '\n', '  /**\n', '  Check if the loan is mature for interest\n', '  */\n', '  function isTermOver() public constant returns (bool){\n', '    if(loanActivation == 0)\n', '      return false;\n', '    else\n', '      return now >= loanActivation.add( dayLength.mul(loanTerm) );\n', '  }\n', '\n', '  /**\n', '  Check if updateInterest() needs to be called before refundLoan()\n', '  */\n', '  function isInterestStatusUpdated() public constant returns(bool){\n', '    if(!isTermOver())\n', '      return true;\n', '    else\n', '      return !( now >= lastInterestCycle.add( interestCycleLength.mul(dayLength) ) );\n', '  }\n', '\n', '  /**\n', '  calculate the total number of passed interest cycles and coin value\n', '  */\n', '  function calculateInterestDue() public constant returns(uint256 _coins,uint256 _cycle){\n', '    if(!isTermOver() || !isLoanFunded())\n', '      return (0,0);\n', '    else{\n', '      uint timeDiff = now.sub(lastInterestCycle);\n', '      _cycle = timeDiff.div(dayLength.mul(interestCycleLength) );\n', '      _coins = _cycle.mul( interestRatePerCycle.mul(initialSupply) ).div(PERCENT_DIVISOR);//Delayed division to avoid too early floor\n', '    }\n', '  }\n', '\n', '  /**\n', '  Update the interest of the contract\n', '  */\n', '  function updateInterest() public {\n', '    require( isTermOver() );\n', '    uint interest_coins;\n', '    uint256 interest_cycle;\n', '    (interest_coins,interest_cycle) = calculateInterestDue();\n', '    assert(interest_coins > 0 && interest_cycle > 0);\n', '    totalInterestCycles =  totalInterestCycles.add(interest_cycle);\n', '    lastInterestCycle = lastInterestCycle.add( interest_cycle.mul( interestCycleLength.mul(dayLength) ) );\n', '    mint(lender , interest_coins);\n', '  }\n', '\n', '  /**\n', '  Make payment to inititate loan\n', '  */\n', '  function fundLoan() public payable{\n', '    require(isLender());\n', '    require(msg.value == getLoanValue(true)); //Ensure input available\n', '    require(!isLoanFunded()); //Avoid double payment\n', '\n', '    loanActivation = now;  //store the time loan was activated\n', '    lastInterestCycle = now.add(dayLength.mul(loanTerm) ) ; //store the date interest matures\n', '    mintingFinished = false;                 //Enable minting\n', '    transferFrom(borrower,lender,totalSupply);\n', '\n', '    borrower.transfer(msg.value);\n', '  }\n', '\n', '  /**\n', '  Make payment to refund loan\n', '  */\n', '  function refundLoan() onlyBorrower public payable{\n', '    if(! isInterestStatusUpdated() )\n', '        updateInterest(); //Ensure Interest is updated\n', '\n', '    require(msg.value == getLoanValue(false));\n', '    require(isLoanFunded());\n', '\n', '    finishMinting() ;//Prevent further Minting\n', '    transferFrom(lender,borrower,totalSupply);\n', '\n', '    lender.transfer(msg.value);\n', '  }\n', '\n', '  /**\n', '  Partial ERC20 functionality\n', '   */\n', '\n', '  function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) internal {\n', '    require(_to != address(0));\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(_from, _to, _value);\n', '  }\n', '\n', '  /**\n', '  MintableToken functionality\n', '   */\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) canMint internal returns (bool) {\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    Transfer(0x0, _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyBorrower internal returns (bool) {\n', '    mintingFinished = true;\n', '    MintFinished();\n', '    return true;\n', '  }\n', '\n', '\n', '  /**\n', '  Fallback function\n', '  */\n', '  function() public payable{\n', '    require(initialSupply > 0);//Stop the whole process if initialSupply not set\n', '    if(isBorrower())\n', '      refundLoan();\n', '    else if(isLender())\n', '      fundLoan();\n', '    else revert(); //Throw if neither of cases apply, ensure no free money\n', '  }\n', '\n', '  /**\n', '  Modifiers\n', '  */\n', '  modifier onlyBorrower() {\n', '    require(isBorrower());\n', '    _;\n', '  }\n', '}\n', '\n', 'contract DebtTokenDeployer is Ownable{\n', '\n', '    address public dayTokenAddress;\n', '    uint public dayTokenFees; //DAY tokens to be paid for deploying custom DAY contract\n', '    ERC20 dayToken;\n', '\n', '    event FeeUpdated(uint _fee, uint _time);\n', '    event DebtTokenCreated(address  _creator, address _debtTokenAddress, uint256 _time);\n', '\n', '    function DebtTokenDeployer(address _dayTokenAddress, uint _dayTokenFees){\n', '        dayTokenAddress = _dayTokenAddress;\n', '        dayTokenFees = _dayTokenFees;\n', '        dayToken = ERC20(dayTokenAddress);\n', '    }\n', '\n', '    function updateDayTokenFees(uint _dayTokenFees) onlyOwner public {\n', '        dayTokenFees = _dayTokenFees;\n', '        FeeUpdated(dayTokenFees, now);\n', '    }\n', '\n', '    function createDebtToken(string _tokenName,\n', '        string _tokenSymbol,\n', '        uint256 _initialAmount,\n', '        uint256 _exchangeRate,\n', '        uint256 _dayLength,\n', '        uint256 _loanTerm,\n', '        uint256 _loanCycle,\n', '        uint256 _intrestRatePerCycle,\n', '        address _lender)\n', '    public\n', '    {\n', '        if(dayToken.transferFrom(msg.sender, this, dayTokenFees)){\n', '            DebtToken newDebtToken = new DebtToken(_tokenName, _tokenSymbol, _initialAmount, _exchangeRate,\n', '                 _dayLength, _loanTerm, _loanCycle,\n', '                _intrestRatePerCycle, _lender, msg.sender);\n', '            DebtTokenCreated(msg.sender, address(newDebtToken), now);\n', '        }\n', '    }\n', '\n', '    // to collect all fees paid till now\n', '    function fetchDayTokens() onlyOwner public {\n', '        dayToken.transfer(owner, dayToken.balanceOf(this));\n', '    }\n', '}']