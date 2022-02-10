['pragma solidity ^0.4.13;\n', '// -------------------------------------------------\n', '// 0.4.13+commit.0fb4cb1a\n', '// [Assistive Reality ARX token ETH cap presale contract]\n', '// [Contact <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="d0a3a4b1b6b690b1a2bfbebcb9beb5feb9bf">[email&#160;protected]</a> for any queries]\n', '// [Join us in changing the world]\n', '// [aronline.io]\n', '// -------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/issues/20\n', '// -------------------------------------------------\n', '// 1,000 ETH capped Pre-sale contract\n', '// Security reviews completed 26/09/17 [passed OK]\n', '// Functional reviews completed 26/09/17 [passed OK]\n', '// Final code revision and regression test cycle complete 26/09/17 [passed OK]\n', '// -------------------------------------------------\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() {\n', '        owner = msg.sender;\n', '    }\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract safeMath {\n', '  function safeMul(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a * b;\n', '    safeAssert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint256 a, uint256 b) internal returns (uint256) {\n', '    safeAssert(b > 0);\n', '    uint256 c = a / b;\n', '    safeAssert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint256 a, uint256 b) internal returns (uint256) {\n', '    safeAssert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a + b;\n', '    safeAssert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  function safeAssert(bool assertion) internal {\n', '    if (!assertion) revert();\n', '  }\n', '}\n', '\n', 'contract ERC20Interface is owned, safeMath {\n', '  function balanceOf(address _owner) constant returns (uint256 balance);\n', '  function transfer(address _to, uint256 _value) returns (bool success);\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '  function approve(address _spender, uint256 _value) returns (bool success);\n', '  function increaseApproval (address _spender, uint _addedValue) returns (bool success);\n', '  function decreaseApproval (address _spender, uint _subtractedValue) returns (bool success);\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '  event Buy(address indexed _sender, uint256 _eth, uint256 _ARX);\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract ARXpresale is owned, safeMath {\n', '  // owner/admin & token reward\n', '  address         public admin                   = owner;     // admin address\n', '  ERC20Interface  public tokenReward;                         // address of the token used as reward\n', '\n', '  // multi-sig addresses and price variable\n', '  address public foundationWallet;                            // foundationMultiSig (foundation fund) or wallet account, for company operations/licensing of Assistive Reality products\n', '  address public beneficiaryWallet;                           // beneficiaryMultiSig (founder group) or wallet account, live is 0x00F959866E977698D14a36eB332686304a4d6AbA\n', '  uint256 public tokensPerEthPrice;                           // set initial value floating priceVar 1,500 tokens per Eth\n', '\n', '  // uint256 values for min,max caps & tracking\n', '  uint256 public amountRaisedInWei;                           // 0 initially (0)\n', '  uint256 public fundingMinCapInWei;                          // 100 ETH (10%) (100 000 000 000 000 000 000)\n', '  uint256 public fundingMaxCapInWei;                          // 1,000 ETH in Wei (1000 000 000 000 000 000 000)\n', '  uint256 public fundingRemainingAvailableInEth;              // ==((fundingMaxCapInWei - amountRaisedInWei)/1 ether); (resolution will only be to integer)\n', '\n', '  // loop control, ICO startup and limiters\n', '  string  public currentStatus                   = "";        // current presale status\n', '  uint256 public fundingStartBlock;                           // presale start block#\n', '  uint256 public fundingEndBlock;                             // presale end block#\n', '  bool    public isPresaleClosed                 = false;     // presale completion boolean\n', '  bool    public isPresaleSetup                  = false;     // boolean for presale setup\n', '\n', '  event Buy(address indexed _sender, uint256 _eth, uint256 _ARX);\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '  event Refund(address indexed _refunder, uint256 _value);\n', '  event Burn(address _from, uint256 _value);\n', '\n', '  mapping(address => uint256) balances;\n', '  mapping(address => uint256) fundValue;\n', '\n', '  // default function, map admin\n', '  function ARXpresale() onlyOwner {\n', '    admin = msg.sender;\n', '    currentStatus = "presale deployed to chain";\n', '  }\n', '\n', '  // setup the presale parameters\n', '  function Setuppresale(uint256 _fundingStartBlock, uint256 _fundingEndBlock) onlyOwner returns (bytes32 response) {\n', '      if ((msg.sender == admin)\n', '      && (!(isPresaleSetup))\n', '      && (!(beneficiaryWallet > 0))){\n', '          // init addresses\n', '          tokenReward                             = ERC20Interface(0xb0D926c1BC3d78064F3e1075D5bD9A24F35Ae6C5);   // mainnet is 0xb0D926c1BC3d78064F3e1075D5bD9A24F35Ae6C5\n', '          beneficiaryWallet                       = 0xd93333f8cb765397A5D0d0e0ba53A2899B48511f;                   // mainnet is 0xd93333f8cb765397A5D0d0e0ba53A2899B48511f\n', '          foundationWallet                        = 0x70A0bE1a5d8A9F39afED536Ec7b55d87067371aA;                   // mainnet is 0x70A0bE1a5d8A9F39afED536Ec7b55d87067371aA\n', '          tokensPerEthPrice                       = 8000;                                                         // set day1 presale value floating priceVar 8,000 ARX tokens per 1 ETH\n', '\n', '          // funding targets\n', '          fundingMinCapInWei                      = 100000000000000000000;                                        // 100000000000000000000  = 100 Eth (min cap) //testnet 2500000000000000000   = 2.5 Eth\n', '          fundingMaxCapInWei                      = 1000000000000000000000;                                       // 1000000000000000000000 = 1000 Eth (max cap) //testnet 6500000000000000000  = 6.5 Eth\n', '\n', '          // update values\n', '          amountRaisedInWei                       = 0;                                                            // init value to 0\n', '          fundingRemainingAvailableInEth          = safeDiv(fundingMaxCapInWei,1 ether);\n', '\n', '          fundingStartBlock                       = _fundingStartBlock;\n', '          fundingEndBlock                         = _fundingEndBlock;\n', '\n', '          // configure presale\n', '          isPresaleSetup                          = true;\n', '          isPresaleClosed                         = false;\n', '          currentStatus                           = "presale is setup";\n', '\n', '          //gas reduction experiment\n', '          setPrice();\n', '          return "presale is setup";\n', '      } else if (msg.sender != admin) {\n', '          return "not authorized";\n', '      } else  {\n', '          return "campaign cannot be changed";\n', '      }\n', '    }\n', '\n', '    function setPrice() {\n', '      // Price configuration mainnet:\n', '      // Day 0-1 Price   1 ETH = 8000 ARX [blocks: start    -> s+3600]  0 - +24hr\n', '      // Day 1-3 Price   1 ETH = 7250 ARX [blocks: s+3601   -> s+10800] +24hr - +72hr\n', '      // Day 3-5 Price   1 ETH = 6750 ARX [blocks: s+10801  -> s+18000] +72hr - +120hr\n', '      // Dau 5-7 Price   1 ETH = 6250 ARX [blocks: s+18001  -> <=fundingEndBlock] = +168hr (168/24 = 7 [x])\n', '\n', '      if (block.number >= fundingStartBlock && block.number <= fundingStartBlock+3600) { // 8000 ARX Day 1 level only\n', '        tokensPerEthPrice=8000;\n', '      } else if (block.number >= fundingStartBlock+3601 && block.number <= fundingStartBlock+10800) { // 7250 ARX Day 2,3\n', '        tokensPerEthPrice=7250;\n', '      } else if (block.number >= fundingStartBlock+10801 && block.number <= fundingStartBlock+18000) { // 6750 ARX Day 4,5\n', '        tokensPerEthPrice=6750;\n', '      } else if (block.number >= fundingStartBlock+18001 && block.number <= fundingEndBlock) { // 6250 ARX Day 6,7\n', '        tokensPerEthPrice=6250;\n', '      } else {\n', '        tokensPerEthPrice=6250; // default back out to this value instead of failing to return or return 0/halting;\n', '      }\n', '    }\n', '\n', '    // default payable function when sending ether to this contract\n', '    function () payable {\n', '      require(msg.data.length == 0);\n', '      BuyARXtokens();\n', '    }\n', '\n', '    function BuyARXtokens() payable {\n', '      // 0. conditions (length, presale setup, zero check, exceed funding contrib check, contract valid check, within funding block range check, balance overflow check etc)\n', '      require(!(msg.value == 0)\n', '      && (isPresaleSetup)\n', '      && (block.number >= fundingStartBlock)\n', '      && (block.number <= fundingEndBlock)\n', '      && !(safeAdd(amountRaisedInWei,msg.value) > fundingMaxCapInWei));\n', '\n', '      // 1. vars\n', '      uint256 rewardTransferAmount    = 0;\n', '\n', '      // 2. effects\n', '      setPrice();\n', '      amountRaisedInWei               = safeAdd(amountRaisedInWei,msg.value);\n', '      rewardTransferAmount            = safeMul(msg.value,tokensPerEthPrice);\n', '      fundingRemainingAvailableInEth  = safeDiv(safeSub(fundingMaxCapInWei,amountRaisedInWei),1 ether);\n', '\n', '      // 3. interaction\n', '      tokenReward.transfer(msg.sender, rewardTransferAmount);\n', '      fundValue[msg.sender]           = safeAdd(fundValue[msg.sender], msg.value);\n', '\n', '      // 4. events\n', '      Transfer(this, msg.sender, msg.value);\n', '      Buy(msg.sender, msg.value, rewardTransferAmount);\n', '    }\n', '\n', '    function beneficiaryMultiSigWithdraw(uint256 _amount) onlyOwner {\n', '      require(amountRaisedInWei >= fundingMinCapInWei);\n', '      beneficiaryWallet.transfer(_amount);\n', '    }\n', '\n', '    function checkGoalandPrice() onlyOwner returns (bytes32 response) {\n', '      // update state & status variables\n', '      require (isPresaleSetup);\n', '      if ((amountRaisedInWei < fundingMinCapInWei) && (block.number <= fundingEndBlock && block.number >= fundingStartBlock)) { // presale in progress, under softcap\n', '        currentStatus = "In progress (Eth < Softcap)";\n', '        return "In progress (Eth < Softcap)";\n', '      } else if ((amountRaisedInWei < fundingMinCapInWei) && (block.number < fundingStartBlock)) { // presale has not started\n', '        currentStatus = "presale is setup";\n', '        return "presale is setup";\n', '      } else if ((amountRaisedInWei < fundingMinCapInWei) && (block.number > fundingEndBlock)) { // presale ended, under softcap\n', '        currentStatus = "Unsuccessful (Eth < Softcap)";\n', '        return "Unsuccessful (Eth < Softcap)";\n', '      } else if (amountRaisedInWei >= fundingMaxCapInWei) {  // presale successful, at hardcap!\n', '          currentStatus = "Successful (ARX >= Hardcap)!";\n', '          return "Successful (ARX >= Hardcap)!";\n', '      } else if ((amountRaisedInWei >= fundingMinCapInWei) && (block.number > fundingEndBlock)) { // presale ended, over softcap!\n', '          currentStatus = "Successful (Eth >= Softcap)!";\n', '          return "Successful (Eth >= Softcap)!";\n', '      } else if ((amountRaisedInWei >= fundingMinCapInWei) && (block.number <= fundingEndBlock)) { // presale in progress, over softcap!\n', '        currentStatus = "In progress (Eth >= Softcap)!";\n', '        return "In progress (Eth >= Softcap)!";\n', '      }\n', '      setPrice();\n', '    }\n', '\n', '    function refund() { // any contributor can call this to have their Eth returned. user&#39;s purchased ARX tokens are burned prior refund of Eth.\n', '      //require minCap not reached\n', '      require ((amountRaisedInWei < fundingMinCapInWei)\n', '      && (isPresaleClosed)\n', '      && (block.number > fundingEndBlock)\n', '      && (fundValue[msg.sender] > 0));\n', '\n', '      //burn user&#39;s token ARX token balance, refund Eth sent\n', '      uint256 ethRefund = fundValue[msg.sender];\n', '      balances[msg.sender] = 0;\n', '      fundValue[msg.sender] = 0;\n', '      Burn(msg.sender, ethRefund);\n', '\n', '      //send Eth back, burn tokens\n', '      msg.sender.transfer(ethRefund);\n', '      Refund(msg.sender, ethRefund);\n', '    }\n', '\n', '    function withdrawRemainingTokens(uint256 _amountToPull) onlyOwner {\n', '      require(block.number >= fundingEndBlock);\n', '      tokenReward.transfer(msg.sender, _amountToPull);\n', '    }\n', '\n', '    function updateStatus() onlyOwner {\n', '      require((block.number >= fundingEndBlock) || (amountRaisedInWei >= fundingMaxCapInWei));\n', '      isPresaleClosed = true;\n', '      currentStatus = "packagesale is closed";\n', '    }\n', '  }']
['pragma solidity ^0.4.13;\n', '// -------------------------------------------------\n', '// 0.4.13+commit.0fb4cb1a\n', '// [Assistive Reality ARX token ETH cap presale contract]\n', '// [Contact staff@aronline.io for any queries]\n', '// [Join us in changing the world]\n', '// [aronline.io]\n', '// -------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/issues/20\n', '// -------------------------------------------------\n', '// 1,000 ETH capped Pre-sale contract\n', '// Security reviews completed 26/09/17 [passed OK]\n', '// Functional reviews completed 26/09/17 [passed OK]\n', '// Final code revision and regression test cycle complete 26/09/17 [passed OK]\n', '// -------------------------------------------------\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() {\n', '        owner = msg.sender;\n', '    }\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract safeMath {\n', '  function safeMul(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a * b;\n', '    safeAssert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint256 a, uint256 b) internal returns (uint256) {\n', '    safeAssert(b > 0);\n', '    uint256 c = a / b;\n', '    safeAssert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint256 a, uint256 b) internal returns (uint256) {\n', '    safeAssert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a + b;\n', '    safeAssert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  function safeAssert(bool assertion) internal {\n', '    if (!assertion) revert();\n', '  }\n', '}\n', '\n', 'contract ERC20Interface is owned, safeMath {\n', '  function balanceOf(address _owner) constant returns (uint256 balance);\n', '  function transfer(address _to, uint256 _value) returns (bool success);\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '  function approve(address _spender, uint256 _value) returns (bool success);\n', '  function increaseApproval (address _spender, uint _addedValue) returns (bool success);\n', '  function decreaseApproval (address _spender, uint _subtractedValue) returns (bool success);\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '  event Buy(address indexed _sender, uint256 _eth, uint256 _ARX);\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract ARXpresale is owned, safeMath {\n', '  // owner/admin & token reward\n', '  address         public admin                   = owner;     // admin address\n', '  ERC20Interface  public tokenReward;                         // address of the token used as reward\n', '\n', '  // multi-sig addresses and price variable\n', '  address public foundationWallet;                            // foundationMultiSig (foundation fund) or wallet account, for company operations/licensing of Assistive Reality products\n', '  address public beneficiaryWallet;                           // beneficiaryMultiSig (founder group) or wallet account, live is 0x00F959866E977698D14a36eB332686304a4d6AbA\n', '  uint256 public tokensPerEthPrice;                           // set initial value floating priceVar 1,500 tokens per Eth\n', '\n', '  // uint256 values for min,max caps & tracking\n', '  uint256 public amountRaisedInWei;                           // 0 initially (0)\n', '  uint256 public fundingMinCapInWei;                          // 100 ETH (10%) (100 000 000 000 000 000 000)\n', '  uint256 public fundingMaxCapInWei;                          // 1,000 ETH in Wei (1000 000 000 000 000 000 000)\n', '  uint256 public fundingRemainingAvailableInEth;              // ==((fundingMaxCapInWei - amountRaisedInWei)/1 ether); (resolution will only be to integer)\n', '\n', '  // loop control, ICO startup and limiters\n', '  string  public currentStatus                   = "";        // current presale status\n', '  uint256 public fundingStartBlock;                           // presale start block#\n', '  uint256 public fundingEndBlock;                             // presale end block#\n', '  bool    public isPresaleClosed                 = false;     // presale completion boolean\n', '  bool    public isPresaleSetup                  = false;     // boolean for presale setup\n', '\n', '  event Buy(address indexed _sender, uint256 _eth, uint256 _ARX);\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '  event Refund(address indexed _refunder, uint256 _value);\n', '  event Burn(address _from, uint256 _value);\n', '\n', '  mapping(address => uint256) balances;\n', '  mapping(address => uint256) fundValue;\n', '\n', '  // default function, map admin\n', '  function ARXpresale() onlyOwner {\n', '    admin = msg.sender;\n', '    currentStatus = "presale deployed to chain";\n', '  }\n', '\n', '  // setup the presale parameters\n', '  function Setuppresale(uint256 _fundingStartBlock, uint256 _fundingEndBlock) onlyOwner returns (bytes32 response) {\n', '      if ((msg.sender == admin)\n', '      && (!(isPresaleSetup))\n', '      && (!(beneficiaryWallet > 0))){\n', '          // init addresses\n', '          tokenReward                             = ERC20Interface(0xb0D926c1BC3d78064F3e1075D5bD9A24F35Ae6C5);   // mainnet is 0xb0D926c1BC3d78064F3e1075D5bD9A24F35Ae6C5\n', '          beneficiaryWallet                       = 0xd93333f8cb765397A5D0d0e0ba53A2899B48511f;                   // mainnet is 0xd93333f8cb765397A5D0d0e0ba53A2899B48511f\n', '          foundationWallet                        = 0x70A0bE1a5d8A9F39afED536Ec7b55d87067371aA;                   // mainnet is 0x70A0bE1a5d8A9F39afED536Ec7b55d87067371aA\n', '          tokensPerEthPrice                       = 8000;                                                         // set day1 presale value floating priceVar 8,000 ARX tokens per 1 ETH\n', '\n', '          // funding targets\n', '          fundingMinCapInWei                      = 100000000000000000000;                                        // 100000000000000000000  = 100 Eth (min cap) //testnet 2500000000000000000   = 2.5 Eth\n', '          fundingMaxCapInWei                      = 1000000000000000000000;                                       // 1000000000000000000000 = 1000 Eth (max cap) //testnet 6500000000000000000  = 6.5 Eth\n', '\n', '          // update values\n', '          amountRaisedInWei                       = 0;                                                            // init value to 0\n', '          fundingRemainingAvailableInEth          = safeDiv(fundingMaxCapInWei,1 ether);\n', '\n', '          fundingStartBlock                       = _fundingStartBlock;\n', '          fundingEndBlock                         = _fundingEndBlock;\n', '\n', '          // configure presale\n', '          isPresaleSetup                          = true;\n', '          isPresaleClosed                         = false;\n', '          currentStatus                           = "presale is setup";\n', '\n', '          //gas reduction experiment\n', '          setPrice();\n', '          return "presale is setup";\n', '      } else if (msg.sender != admin) {\n', '          return "not authorized";\n', '      } else  {\n', '          return "campaign cannot be changed";\n', '      }\n', '    }\n', '\n', '    function setPrice() {\n', '      // Price configuration mainnet:\n', '      // Day 0-1 Price   1 ETH = 8000 ARX [blocks: start    -> s+3600]  0 - +24hr\n', '      // Day 1-3 Price   1 ETH = 7250 ARX [blocks: s+3601   -> s+10800] +24hr - +72hr\n', '      // Day 3-5 Price   1 ETH = 6750 ARX [blocks: s+10801  -> s+18000] +72hr - +120hr\n', '      // Dau 5-7 Price   1 ETH = 6250 ARX [blocks: s+18001  -> <=fundingEndBlock] = +168hr (168/24 = 7 [x])\n', '\n', '      if (block.number >= fundingStartBlock && block.number <= fundingStartBlock+3600) { // 8000 ARX Day 1 level only\n', '        tokensPerEthPrice=8000;\n', '      } else if (block.number >= fundingStartBlock+3601 && block.number <= fundingStartBlock+10800) { // 7250 ARX Day 2,3\n', '        tokensPerEthPrice=7250;\n', '      } else if (block.number >= fundingStartBlock+10801 && block.number <= fundingStartBlock+18000) { // 6750 ARX Day 4,5\n', '        tokensPerEthPrice=6750;\n', '      } else if (block.number >= fundingStartBlock+18001 && block.number <= fundingEndBlock) { // 6250 ARX Day 6,7\n', '        tokensPerEthPrice=6250;\n', '      } else {\n', '        tokensPerEthPrice=6250; // default back out to this value instead of failing to return or return 0/halting;\n', '      }\n', '    }\n', '\n', '    // default payable function when sending ether to this contract\n', '    function () payable {\n', '      require(msg.data.length == 0);\n', '      BuyARXtokens();\n', '    }\n', '\n', '    function BuyARXtokens() payable {\n', '      // 0. conditions (length, presale setup, zero check, exceed funding contrib check, contract valid check, within funding block range check, balance overflow check etc)\n', '      require(!(msg.value == 0)\n', '      && (isPresaleSetup)\n', '      && (block.number >= fundingStartBlock)\n', '      && (block.number <= fundingEndBlock)\n', '      && !(safeAdd(amountRaisedInWei,msg.value) > fundingMaxCapInWei));\n', '\n', '      // 1. vars\n', '      uint256 rewardTransferAmount    = 0;\n', '\n', '      // 2. effects\n', '      setPrice();\n', '      amountRaisedInWei               = safeAdd(amountRaisedInWei,msg.value);\n', '      rewardTransferAmount            = safeMul(msg.value,tokensPerEthPrice);\n', '      fundingRemainingAvailableInEth  = safeDiv(safeSub(fundingMaxCapInWei,amountRaisedInWei),1 ether);\n', '\n', '      // 3. interaction\n', '      tokenReward.transfer(msg.sender, rewardTransferAmount);\n', '      fundValue[msg.sender]           = safeAdd(fundValue[msg.sender], msg.value);\n', '\n', '      // 4. events\n', '      Transfer(this, msg.sender, msg.value);\n', '      Buy(msg.sender, msg.value, rewardTransferAmount);\n', '    }\n', '\n', '    function beneficiaryMultiSigWithdraw(uint256 _amount) onlyOwner {\n', '      require(amountRaisedInWei >= fundingMinCapInWei);\n', '      beneficiaryWallet.transfer(_amount);\n', '    }\n', '\n', '    function checkGoalandPrice() onlyOwner returns (bytes32 response) {\n', '      // update state & status variables\n', '      require (isPresaleSetup);\n', '      if ((amountRaisedInWei < fundingMinCapInWei) && (block.number <= fundingEndBlock && block.number >= fundingStartBlock)) { // presale in progress, under softcap\n', '        currentStatus = "In progress (Eth < Softcap)";\n', '        return "In progress (Eth < Softcap)";\n', '      } else if ((amountRaisedInWei < fundingMinCapInWei) && (block.number < fundingStartBlock)) { // presale has not started\n', '        currentStatus = "presale is setup";\n', '        return "presale is setup";\n', '      } else if ((amountRaisedInWei < fundingMinCapInWei) && (block.number > fundingEndBlock)) { // presale ended, under softcap\n', '        currentStatus = "Unsuccessful (Eth < Softcap)";\n', '        return "Unsuccessful (Eth < Softcap)";\n', '      } else if (amountRaisedInWei >= fundingMaxCapInWei) {  // presale successful, at hardcap!\n', '          currentStatus = "Successful (ARX >= Hardcap)!";\n', '          return "Successful (ARX >= Hardcap)!";\n', '      } else if ((amountRaisedInWei >= fundingMinCapInWei) && (block.number > fundingEndBlock)) { // presale ended, over softcap!\n', '          currentStatus = "Successful (Eth >= Softcap)!";\n', '          return "Successful (Eth >= Softcap)!";\n', '      } else if ((amountRaisedInWei >= fundingMinCapInWei) && (block.number <= fundingEndBlock)) { // presale in progress, over softcap!\n', '        currentStatus = "In progress (Eth >= Softcap)!";\n', '        return "In progress (Eth >= Softcap)!";\n', '      }\n', '      setPrice();\n', '    }\n', '\n', "    function refund() { // any contributor can call this to have their Eth returned. user's purchased ARX tokens are burned prior refund of Eth.\n", '      //require minCap not reached\n', '      require ((amountRaisedInWei < fundingMinCapInWei)\n', '      && (isPresaleClosed)\n', '      && (block.number > fundingEndBlock)\n', '      && (fundValue[msg.sender] > 0));\n', '\n', "      //burn user's token ARX token balance, refund Eth sent\n", '      uint256 ethRefund = fundValue[msg.sender];\n', '      balances[msg.sender] = 0;\n', '      fundValue[msg.sender] = 0;\n', '      Burn(msg.sender, ethRefund);\n', '\n', '      //send Eth back, burn tokens\n', '      msg.sender.transfer(ethRefund);\n', '      Refund(msg.sender, ethRefund);\n', '    }\n', '\n', '    function withdrawRemainingTokens(uint256 _amountToPull) onlyOwner {\n', '      require(block.number >= fundingEndBlock);\n', '      tokenReward.transfer(msg.sender, _amountToPull);\n', '    }\n', '\n', '    function updateStatus() onlyOwner {\n', '      require((block.number >= fundingEndBlock) || (amountRaisedInWei >= fundingMaxCapInWei));\n', '      isPresaleClosed = true;\n', '      currentStatus = "packagesale is closed";\n', '    }\n', '  }']