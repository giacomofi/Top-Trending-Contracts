['pragma solidity ^0.4.13;\n', '\n', '/**\n', ' * Contract "Math"\n', ' * Purpose: Math operations with safety checks\n', ' */\n', 'library Math {\n', '\n', '    /**\n', '    * Multiplication with safety check\n', '    */\n', '    function Mul(uint a, uint b) constant internal returns (uint) {\n', '      uint c = a * b;\n', '      //check result should not be other wise until a=0\n', '      assert(a == 0 || c / a == b);\n', '      return c;\n', '    }\n', '\n', '    /**\n', '    * Division with safety check\n', '    */\n', '    function Div(uint a, uint b) constant internal returns (uint) {\n', '      //overflow check; b must not be 0\n', '      assert(b > 0);\n', '      uint c = a / b;\n', '      assert(a == b * c + a % b);\n', '      return c;\n', '    }\n', '\n', '    /**\n', '    * Subtraction with safety check\n', '    */\n', '    function Sub(uint a, uint b) constant internal returns (uint) {\n', '      //b must be greater that a as we need to store value in unsigned integer\n', '      assert(b <= a);\n', '      return a - b;\n', '    }\n', '\n', '    /**\n', '    * Addition with safety check\n', '    */\n', '    function Add(uint a, uint b) constant internal returns (uint) {\n', '      uint c = a + b;\n', '      //result must be greater as a or b can not be negative\n', '      assert(c>=a && c>=b);\n', '      return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * Contract "ERC20Basic"\n', ' * Purpose: Defining ERC20 standard with basic functionality like - CheckBalance and Transfer including Transfer event\n', ' */\n', 'contract ERC20Basic {\n', '  \n', '  //Give realtime totalSupply of EXH token\n', '  uint public totalSupply;\n', '\n', '  //Get EXH token balance for provided address in lowest denomination\n', '  function balanceOf(address who) constant public returns (uint);\n', '\n', '  //Transfer EXH token to provided address\n', '  function transfer(address _to, uint _value) public returns(bool ok);\n', '\n', '  //Emit Transfer event outside of blockchain for every EXH token transfers\n', '  event Transfer(address indexed _from, address indexed _to, uint _value);\n', '}\n', '\n', '/**\n', ' * Contract "ERC20"\n', ' * Purpose: Defining ERC20 standard with more advanced functionality like - Authorize spender to transfer EXH token\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '\n', "  //Get EXH token amount that spender can spend from provided owner's account \n", '  function allowance(address owner, address spender) public constant returns (uint);\n', '\n', '  //Transfer initiated by spender \n', '  function transferFrom(address _from, address _to, uint _value) public returns(bool ok);\n', '\n', '  //Add spender to authrize for spending specified amount of EXH Token\n', '  function approve(address _spender, uint _value) public returns(bool ok);\n', '\n', '  //Emit event for any approval provided to spender\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', '/**\n', ' * Contract "Ownable"\n', ' * Purpose: Defines Owner for contract and provide functionality to transfer ownership to another account\n', ' */\n', 'contract Ownable {\n', '\n', '  //owner variable to store contract owner account\n', '  address public owner;\n', '\n', "  //Constructor for the contract to store owner's account on deployement\n", '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '  \n', '  //modifier to check transaction initiator is only owner\n', '  modifier onlyOwner() {\n', '    if (msg.sender == owner)\n', '      _;\n', '  }\n', '\n', "  //ownership can be transferred to provided newOwner. Function can only be initiated by contract owner's account\n", '  function transferOwnership(address newOwner) public onlyOwner {\n', '    if (newOwner != address(0)) \n', '        owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * Contract "Pausable"\n', ' * Purpose: Contract to provide functionality to pause and resume Sale in case of emergency\n', ' */\n', 'contract Pausable is Ownable {\n', '\n', '  //flag to indicate whether Sale is paused or not\n', '  bool public stopped;\n', '\n', '  //Emit event when any change happens in crowdsale state\n', '  event StateChanged(bool changed);\n', '\n', '  //modifier to continue with transaction only when Sale is not paused\n', '  modifier stopInEmergency {\n', '    require(!stopped);\n', '    _;\n', '  }\n', '\n', '  //modifier to continue with transaction only when Sale is paused\n', '  modifier onlyInEmergency {\n', '    require(stopped);\n', '    _;\n', '  }\n', '\n', '  // called by the owner on emergency, pause Sale\n', '  function emergencyStop() external onlyOwner  {\n', '    stopped = true;\n', '    //Emit event when crowdsale state changes\n', '    StateChanged(true);\n', '  }\n', '\n', '  // called by the owner on end of emergency, resumes Sale\n', '  function release() external onlyOwner onlyInEmergency {\n', '    stopped = false;\n', '    //Emit event when crowdsale state changes\n', '    StateChanged(true);\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * Contract "EXH"\n', ' * Purpose: Create EXH token\n', ' */\n', 'contract EXH is ERC20, Ownable {\n', '\n', '  using Math for uint;\n', '\n', '  /* Public variables of the token */\n', '  //To store name for token\n', '  string public name;\n', '\n', '  //To store symbol for token       \n', '  string public symbol;\n', '\n', '  //To store decimal places for token\n', '  uint8 public decimals;    \n', '\n', '  //To store decimal version for token\n', "  string public version = 'v1.0'; \n", '\n', '  //To store current supply of EXH Token\n', '  uint public totalSupply;\n', '\n', '  //flag to indicate whether transfer of EXH Token is allowed or not\n', '  bool public locked;\n', '\n', '  //map to store EXH Token balance corresponding to address\n', '  mapping(address => uint) balances;\n', '\n', "  //To store spender with allowed amount of EXH Token to spend corresponding to EXH Token holder's account\n", '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '  //To handle ERC20 short address attack  \n', '  modifier onlyPayloadSize(uint size) {\n', '     require(msg.data.length >= size + 4);\n', '     _;\n', '  }\n', '  \n', '  // Lock transfer during Sale\n', '  modifier onlyUnlocked() {\n', '    require(!locked || msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  //Contructor to define EXH Token token properties\n', '  function EXH() public {\n', '\n', '    // lock the transfer function during Sale\n', '    locked = true;\n', '\n', '    //initial token supply is 0\n', '    totalSupply = 0;\n', '\n', '    //Name for token set to EXH Token\n', "    name = 'EXH Token';\n", '\n', "    // Symbol for token set to 'EXH'\n", "    symbol = 'EXH';\n", ' \n', '    decimals = 18;\n', '  }\n', ' \n', '  //Implementation for transferring EXH Token to provided address \n', '  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) public onlyUnlocked returns (bool){\n', '\n', '    //Check provided EXH Token should not be 0\n', '    if (_value > 0 && !(_to == address(0))) {\n', '      //deduct EXH Token amount from transaction initiator\n', '      balances[msg.sender] = balances[msg.sender].Sub(_value);\n', '      //Add EXH Token to balace of target account\n', '      balances[_to] = balances[_to].Add(_value);\n', '      //Emit event for transferring EXH Token\n', '      Transfer(msg.sender, _to, _value);\n', '      return true;\n', '    }\n', '    else{\n', '      return false;\n', '    }\n', '  }\n', '\n', '  //Transfer initiated by spender \n', '  function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) public onlyUnlocked returns (bool) {\n', '\n', '    //Check provided EXH Token should not be 0\n', '    if (_value > 0 && (_to != address(0) && _from != address(0))) {\n', '      //Get amount of EXH Token for which spender is authorized\n', '      var _allowance = allowed[_from][msg.sender];\n', "      //Add amount of EXH Token in trarget account's balance\n", '      balances[_to] = balances[_to].Add( _value);\n', '      //Deduct EXH Token amount from _from account\n', '      balances[_from] = balances[_from].Sub( _value);\n', '      //Deduct Authorized amount for spender\n', '      allowed[_from][msg.sender] = _allowance.Sub( _value);\n', '      //Emit event for Transfer\n', '      Transfer(_from, _to, _value);\n', '      return true;\n', '    }else{\n', '      return false;\n', '    }\n', '  }\n', '\n', '  //Get EXH Token balance for provided address\n', '  function balanceOf(address _owner) public constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '  \n', '  //Add spender to authorize for spending specified amount of EXH Token \n', '  function approve(address _spender, uint _value) public returns (bool) {\n', '    require(_spender != address(0));\n', '    allowed[msg.sender][_spender] = _value;\n', '    //Emit event for approval provided to spender\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', "  //Get EXH Token amount that spender can spend from provided owner's account \n", '  function allowance(address _owner, address _spender) public constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '  \n', '}\n', '\n', '/**\n', ' * Contract "Crowdsale"\n', ' * Purpose: Contract for crowdsale of EXH Token\n', ' */\n', 'contract Crowdsale is EXH, Pausable {\n', '\n', '  using Math for uint;\n', '  \n', '  /* Public variables for Sale */\n', '\n', '  // Sale start block\n', '  uint public startBlock;   \n', '\n', '  // Sale end block  \n', '  uint public endBlock;  \n', '\n', '  // To store maximum number of EXH Token to sell\n', '  uint public maxCap;   \n', '\n', '  // To store maximum number of EXH Token to sell in PreSale\n', '  uint public maxCapPreSale;   \n', '\n', '  // To store total number of ETH received\n', '  uint public ETHReceived;    \n', '\n', '  // Number of tokens that can be purchased with 1 Ether\n', '  uint public PRICE;   \n', '\n', '  // To indicate Sale status; crowdsaleStatus=0 => crowdsale not started; crowdsaleStatus=1=> crowdsale started; crowdsaleStatus=2=> crowdsale finished\n', '  uint public crowdsaleStatus; \n', '\n', '  // To store crowdSale type; crowdSaleType=0 => PreSale; crowdSaleType=1 => CrowdSale\n', '  uint public crowdSaleType; \n', '\n', '  //Total Supply in PreSale\n', '  uint public totalSupplyPreSale; \n', '\n', '  //No of days for which presale will be open\n', '  uint public durationPreSale;\n', '\n', '  //Value of 1 ether, ie, 1 followed by 18 zero\n', '  uint valueOneEther = 1e18;\n', '\n', '  //No of days for which the complete crowdsale will run- presale  + crowdsale\n', '  uint public durationCrowdSale;\n', '\n', '  //Store total number of investors\n', '  uint public countTotalInvestors;\n', '\n', '  //Number of investors who have received refund\n', '  uint public countInvestorsRefunded;\n', '  \n', '  //Set status of refund\n', '  uint public refundStatus;\n', '\n', ' //maxCAp for mint and transfer\n', '  uint public maxCapMintTransfer ;\n', '\n', '  //total supply for mint and transfer\n', '  uint public totalSupplyMintTransfer;\n', '\n', '  //total tokens sold in crowdsale\n', '  uint public totalSupplyCrowdsale;\n', '\n', '  //Stores total investros in crowdsale\n', '  uint256 public countTotalInvestorsInCrowdsale;\n', '\n', '  uint256 public countInvestorsRefundedInCrowdsale;\n', '\n', '  //Structure for investors; holds received wei amount and EXH Token sent\n', '  struct Investor {\n', '    //wei received during PreSale\n', '    uint weiReceivedCrowdsaleType0;\n', '    //wei received during CrowdSale\n', '    uint weiReceivedCrowdsaleType1;\n', '    //Tokens sent during PreSale\n', '    uint exhSentCrowdsaleType0;\n', '    //Tokens sent during CrowdSale\n', '    uint exhSentCrowdsaleType1;\n', '    //Uniquely identify an investor(used for iterating)\n', '    uint investorID;\n', '  }\n', '\n', '  //investors indexed by their ETH address\n', '  mapping(address => Investor) public investors;\n', '  //investors indexed by their IDs\n', '  mapping (uint => address) public investorList;\n', '\n', '  \n', '  //Emit event on receiving ETH\n', '  event ReceivedETH(address addr, uint value);\n', '\n', '  //Emit event on transferring EXH Token to user when payment is received in traditional ways or B type EXH Token converted to A type EXH Token\n', '  event MintAndTransferEXH(address addr, uint value, bytes32 comment);\n', '\n', '  //constructor to initialize contract variables\n', '  function Crowdsale() public {\n', '\n', '    //Will be set in function start; Makes sure Sale will be started only when start() function is called\n', '    startBlock = 0;   \n', '    //Will be set in function start; Makes sure Sale will be started only when start() function is called        \n', '    endBlock = 0;    \n', '    //Max number of EXH Token to sell in CrowdSale[Includes the tokens sold in presale](33M)\n', '    maxCap = 31750000e18;\n', '    //Max number of EXH Token to sell in Presale(0.5M)\n', '    maxCapPreSale = 500000e18;\n', '    //1250000 Tokens avalable for Mint and Transfer\n', '    maxCapMintTransfer = 1250000e18;\n', '    // EXH Token per ether\n', '    PRICE = 10; \n', '    //Indicates Sale status; Sale is not started yet\n', '    crowdsaleStatus = 0;    \n', '    //At time of deployment crowdSale type is set to Presale\n', '    crowdSaleType = 0;\n', '    // Number of days after which sale will start since the starting of presale, a single value to replace the hardcoded\n', '    durationPreSale = 8 days + 1 hours;\n', '    // Number of days for which complete crowdsale will run, ie, presale and crowdsale period\n', '    durationCrowdSale = 28 days;\n', '    // Investor count is 0 initially\n', '    countTotalInvestors = 0;\n', '    //Initially no investor has been refunded\n', '    countInvestorsRefunded = 0;\n', '    //Refund eligible or not\n', '    refundStatus = 0;\n', '\n', '    countTotalInvestorsInCrowdsale = 0;\n', '    countInvestorsRefundedInCrowdsale = 0;\n', '    \n', '  }\n', '\n', '  //Modifier to make sure transaction is happening during Sale\n', '  modifier respectTimeFrame() {\n', '    assert(!((now < startBlock) || (now > endBlock )));\n', '    _;\n', '  }\n', '\n', '  /*\n', '  * To start Sale from Presale\n', '  */\n', '  function start() public onlyOwner {\n', '    //Set block number to current block number\n', '    assert(startBlock == 0);\n', '    startBlock = now;            \n', '    //Set end block number\n', '    endBlock = now.Add(durationCrowdSale.Add(durationPreSale));\n', '    //Sale presale is started\n', '    crowdsaleStatus = 1;\n', '    //Emit event when crowdsale state changes\n', '    StateChanged(true);  \n', '  }\n', '\n', '  /*\n', '  * To start Crowdsale\n', '  */\n', '  function startSale() public onlyOwner\n', '  {\n', '    if(now > startBlock.Add(durationPreSale) && now <= endBlock){\n', '        crowdsaleStatus = 1;\n', '        crowdSaleType = 1;\n', '        if(crowdSaleType != 1)\n', '        {\n', '          totalSupplyCrowdsale = totalSupplyPreSale;\n', '        }\n', '        //Emit event when crowdsale state changes\n', '        StateChanged(true); \n', '    }\n', '    else\n', '      revert();\n', '  }\n', '\n', '  /*\n', '  * To extend duration of Crowdsale\n', '  */\n', '  function updateDuration(uint time) public onlyOwner\n', '  {\n', '      require(time != 0);\n', '      assert(startBlock != 0);\n', '      assert(crowdSaleType == 1 && crowdsaleStatus != 2);\n', '      durationCrowdSale = durationCrowdSale.Add(time);\n', '      endBlock = endBlock.Add(time);\n', '      //Emit event when crowdsale state changes\n', '      StateChanged(true);\n', '  }\n', '\n', '  /*\n', '  * To set price for EXH Token\n', '  */\n', '  function setPrice(uint price) public onlyOwner\n', '  {\n', '      require( price != 0);\n', '      PRICE = price;\n', '      //Emit event when crowdsale state changes\n', '      StateChanged(true);\n', '  }\n', '  \n', '  /*\n', '  * To enable transfers of EXH Token after completion of Sale\n', '  */\n', '  function unlock() public onlyOwner\n', '  {\n', '    locked = false;\n', '    //Emit event when crowdsale state changes\n', '    StateChanged(true);\n', '  }\n', '  \n', '  //fallback function i.e. payable; initiates when any address transfers Eth to Contract address\n', '  function () public payable {\n', '  //call createToken function with account who transferred Eth to contract address\n', '    createTokens(msg.sender);\n', '  }\n', '\n', '  /*\n', '  * To create EXH Token and assign to transaction initiator\n', '  */\n', '  function createTokens(address beneficiary) internal stopInEmergency  respectTimeFrame {\n', '    //Make sure Sale is running\n', '    assert(crowdsaleStatus == 1); \n', "    //Don't accept fund to purchase less than 1 EXH Token   \n", '    require(msg.value >= 1 ether/getPrice());   \n', '    //Make sure sent Eth is not 0           \n', '    require(msg.value != 0);\n', '    //Calculate EXH Token to send\n', '    uint exhToSend = msg.value.Mul(getPrice());\n', '\n', '    //Make entry in Investor indexed with address\n', '    Investor storage investorStruct = investors[beneficiary];\n', '\n', '    // For Presale\n', '    if(crowdSaleType == 0){\n', '      require(exhToSend.Add(totalSupplyPreSale) <= maxCapPreSale);\n', '      totalSupplyPreSale = totalSupplyPreSale.Add(exhToSend);\n', '      if((maxCapPreSale.Sub(totalSupplyPreSale) < valueOneEther)||(now > (startBlock.Add(7 days + 1 hours)))){\n', '        crowdsaleStatus = 2;\n', '      }        \n', '      investorStruct.weiReceivedCrowdsaleType0 = investorStruct.weiReceivedCrowdsaleType0.Add(msg.value);\n', '      investorStruct.exhSentCrowdsaleType0 = investorStruct.exhSentCrowdsaleType0.Add(exhToSend);\n', '    }\n', '\n', '    // For CrowdSale\n', '    else if (crowdSaleType == 1){\n', '      if (exhToSend.Add(totalSupply) > maxCap ) {\n', '        revert();\n', '      }\n', '      totalSupplyCrowdsale = totalSupplyCrowdsale.Add(exhToSend);\n', '      if(maxCap.Sub(totalSupplyCrowdsale) < valueOneEther)\n', '      {\n', '        crowdsaleStatus = 2;\n', '      }\n', '      if(investorStruct.investorID == 0 || investorStruct.weiReceivedCrowdsaleType1 == 0){\n', '        countTotalInvestorsInCrowdsale++;\n', '      }\n', '      investorStruct.weiReceivedCrowdsaleType1 = investorStruct.weiReceivedCrowdsaleType1.Add(msg.value);\n', '      investorStruct.exhSentCrowdsaleType1 = investorStruct.exhSentCrowdsaleType1.Add(exhToSend);\n', '    }\n', '\n', '    //If it is a new investor, then create a new id\n', '    if(investorStruct.investorID == 0){\n', '        countTotalInvestors++;\n', '        investorStruct.investorID = countTotalInvestors;\n', '        investorList[countTotalInvestors] = beneficiary;\n', '    }\n', '\n', '    //update total supply of EXH Token\n', '    totalSupply = totalSupply.Add(exhToSend);\n', '    // Update the total wei collected during Sale\n', '    ETHReceived = ETHReceived.Add(msg.value);  \n', '    //Update EXH Token balance for transaction initiator\n', '    balances[beneficiary] = balances[beneficiary].Add(exhToSend);\n', '    //Emit event for contribution\n', '    ReceivedETH(beneficiary,ETHReceived); \n', '    //ETHReceived during Sale will remain with contract\n', '    GetEXHFundAccount().transfer(msg.value);\n', '    //Emit event when crowdsale state changes\n', '    StateChanged(true);\n', '  }\n', '\n', '  /*\n', '  * To enable vesting of B type EXH Token\n', '  */\n', '  function MintAndTransferToken(address beneficiary,uint exhToCredit,bytes32 comment) external onlyOwner {\n', '    //Available after the crowdsale is started\n', '    assert(startBlock != 0);\n', '    //Check whether tokens are available or not\n', '    assert(totalSupplyMintTransfer <= maxCapMintTransfer);\n', '    //Check whether the amount of token are available to transfer\n', '    require(totalSupplyMintTransfer.Add(exhToCredit) <= maxCapMintTransfer);\n', '    //Update EXH Token balance for beneficiary\n', '    balances[beneficiary] = balances[beneficiary].Add(exhToCredit);\n', '    //Update total supply for EXH Token\n', '    totalSupply = totalSupply.Add(exhToCredit);\n', '    //update total supply for EXH token in mint and transfer\n', '    totalSupplyMintTransfer = totalSupplyMintTransfer.Add(exhToCredit);\n', '    // send event for transferring EXH Token on offline payment\n', '    MintAndTransferEXH(beneficiary, exhToCredit,comment);\n', '    //Emit event when crowdsale state changes\n', '    StateChanged(true);  \n', '  }\n', '\n', '  /*\n', '  * To get price for EXH Token\n', '  */\n', '  function getPrice() public constant returns (uint result) {\n', '      if (crowdSaleType == 0) {\n', '            return (PRICE.Mul(100)).Div(70);\n', '      }\n', '      if (crowdSaleType == 1) {\n', '          uint crowdsalePriceBracket = 1 weeks;\n', '          uint startCrowdsale = startBlock.Add(durationPreSale);\n', '            if (now > startCrowdsale && now <= startCrowdsale.Add(crowdsalePriceBracket)) {\n', '                return ((PRICE.Mul(100)).Div(80));\n', '            }else if (now > startCrowdsale.Add(crowdsalePriceBracket) && now <= (startCrowdsale.Add(crowdsalePriceBracket.Mul(2)))) {\n', '                return (PRICE.Mul(100)).Div(85);\n', '            }else if (now > (startCrowdsale.Add(crowdsalePriceBracket.Mul(2))) && now <= (startCrowdsale.Add(crowdsalePriceBracket.Mul(3)))) {\n', '                return (PRICE.Mul(100)).Div(90);\n', '            }else if (now > (startCrowdsale.Add(crowdsalePriceBracket.Mul(3))) && now <= (startCrowdsale.Add(crowdsalePriceBracket.Mul(4)))) {\n', '                return (PRICE.Mul(100)).Div(95);\n', '            }\n', '      }\n', '      return PRICE;\n', '  }\n', '\n', '  function GetEXHFundAccount() internal returns (address) {\n', '    uint remainder = block.number%10;\n', '    if(remainder==0){\n', '      return 0xda141e704601f8C8E343C5cA246355c812238D91;\n', '    } else if(remainder==1){\n', '      return 0x2381963906C434dD4639489Bec9A2bB55D83cC14;\n', '    } else if(remainder==2){\n', '      return 0x537C7119452A7814ABD1C4ED71F6eCD25225C0F6;\n', '    } else if(remainder==3){\n', '      return 0x1F04880fFdFff05d36307f69EAAc8645B98449E2;\n', '    } else if(remainder==4){\n', '      return 0xd72B82b69FEe29d81f5e2DA66aB91014aDaE0AA0;\n', '    } else if(remainder==5){\n', '      return 0xf63bef6B67064053191dc4bC6F1D06592C07925f;\n', '    } else if(remainder==6){\n', '      return 0x7381F9C5d35E895e80aDeC1e1A3541860F876600;\n', '    } else if(remainder==7){\n', '      return 0x370301AE4659D2975be9F976011c787EC59e0645;\n', '    } else if(remainder==8){\n', '      return 0x2C041b6A7fF277966cB0b4cb966aaB8Fc1178ac5;\n', '    }else {\n', '      return 0x8A401290A39Dc8D046e42BABaf5a818e29ae4fda;\n', '    }\n', '  }\n', '\n', '  /*\n', '  * Finalize the crowdsale\n', '  */\n', '  function finalize() public onlyOwner {\n', '    //Make sure Sale is running\n', '    assert(crowdsaleStatus==1 && crowdSaleType==1);\n', '    // cannot finalise before end or until maxcap is reached\n', '      assert(!((totalSupplyCrowdsale < maxCap && now < endBlock) && (maxCap.Sub(totalSupplyCrowdsale) >= valueOneEther)));  \n', '      //Indicates Sale is ended\n', '      \n', '      //Checks if the fundraising goal is reached in crowdsale or not\n', '      if (totalSupply < 5300000e18)\n', '        refundStatus = 2;\n', '      else\n', '        refundStatus = 1;\n', '      \n', '    //crowdsale is ended\n', '    crowdsaleStatus = 2;\n', '    //Emit event when crowdsale state changes\n', '    StateChanged(true);\n', '  }\n', '\n', '  /*\n', '  * Refund the investors in case target of crowdsale not achieved\n', '  */\n', '  function refund() public onlyOwner {\n', '      assert(refundStatus == 2);\n', '      uint batchSize = countInvestorsRefunded.Add(50) < countTotalInvestors ? countInvestorsRefunded.Add(50): countTotalInvestors;\n', '      for(uint i=countInvestorsRefunded.Add(1); i <= batchSize; i++){\n', '          address investorAddress = investorList[i];\n', '          Investor storage investorStruct = investors[investorAddress];\n', '          //If purchase has been made during CrowdSale\n', '          if(investorStruct.exhSentCrowdsaleType1 > 0 && investorStruct.exhSentCrowdsaleType1 <= balances[investorAddress]){\n', '              //return everything\n', '              investorAddress.transfer(investorStruct.weiReceivedCrowdsaleType1);\n', '              //Reduce ETHReceived\n', '              ETHReceived = ETHReceived.Sub(investorStruct.weiReceivedCrowdsaleType1);\n', '              //Update totalSupply\n', '              totalSupply = totalSupply.Sub(investorStruct.exhSentCrowdsaleType1);\n', '              // reduce balances\n', '              balances[investorAddress] = balances[investorAddress].Sub(investorStruct.exhSentCrowdsaleType1);\n', '              //set everything to zero after transfer successful\n', '              investorStruct.weiReceivedCrowdsaleType1 = 0;\n', '              investorStruct.exhSentCrowdsaleType1 = 0;\n', '              countInvestorsRefundedInCrowdsale = countInvestorsRefundedInCrowdsale.Add(1);\n', '          }\n', '      }\n', '      //Update the number of investors that have recieved refund\n', '      countInvestorsRefunded = batchSize;\n', '      StateChanged(true);\n', '  }\n', '\n', '  /*\n', '   * Failsafe drain\n', '   */\n', '  function drain() public onlyOwner {\n', '    GetEXHFundAccount().transfer(this.balance);\n', '  }\n', '\n', '  /*\n', '  * Function to add Ether in the contract \n', '  */\n', '  function fundContractForRefund() payable{\n', '    // StateChanged(true);\n', '  }\n', '\n', '}']