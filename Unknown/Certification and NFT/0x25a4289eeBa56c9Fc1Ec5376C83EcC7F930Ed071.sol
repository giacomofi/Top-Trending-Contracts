['pragma solidity ^0.4.11;\n', '\n', '\n', '// **-----------------------------------------------\n', '// Betstreak Token sale contract\n', '// Revision 1.1\n', '// Refunds integrated, full test suite passed\n', '// **-----------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/issues/20\n', '// -------------------------------------------------\n', '// ICO configuration:\n', '// Presale Bonus      +30% = 1,300 BST   = 1 ETH       [blocks: start   -> s+25200]\n', '// First Week Bonus   +20% = 1,200 BST  = 1 ETH       [blocks: s+3601  -> s+50400]\n', '// Second Week Bonus  +10% = 1,100 BST  = 1 ETH       [blocks: s+25201 -> s+75600]\n', '// Third Week Bonus   +5% = 1,050 BST   = 1 ETH       [blocks: s+50401 -> s+100800]\n', '// Final Week         +0% = 1,000 BST   = 1 ETH       [blocks: s+75601 -> end]\n', '// -------------------------------------------------\n', '\n', 'contract owned {\n', '    address public owner;\n', '  \n', '\t\n', '    function owned() {\n', '        owner = msg.sender;\n', '        \n', '    }\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract safeMath {\n', '  function safeMul(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a * b;\n', '    safeAssert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint256 a, uint256 b) internal returns (uint256) {\n', '    safeAssert(b > 0);\n', '    uint256 c = a / b;\n', '    safeAssert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint256 a, uint256 b) internal returns (uint256) {\n', '    safeAssert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a + b;\n', '    safeAssert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  function safeAssert(bool assertion) internal {\n', '    if (!assertion) revert();\n', '  }\n', '}\n', '\n', 'contract StandardToken is owned, safeMath {\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract BetstreakICO is owned, safeMath {\n', '    \n', '  // owner/admin & token reward\n', '  address        public admin = owner;      // admin address\n', '  StandardToken  public tokenReward;        // address of the token used as reward\n', '  \n', '\n', '  // deployment variables for static supply sale\n', '  uint256 public initialSupply;\n', '\n', '  uint256 public tokensRemaining;\n', '\n', '  // multi-sig addresses and price variable\n', '  address public beneficiaryWallet;\n', '  // beneficiaryMultiSig (founder group) or wallet account, live is 0x361e14cC5b3CfBa5D197D8a9F02caf71B3dca6Fd\n', '  \n', '  \n', '  uint256 public tokensPerEthPrice;                           // set initial value floating priceVar 1,300 tokens per Eth\n', '\n', '  // uint256 values for min,max,caps,tracking\n', '  uint256 public amountRaisedInWei;                           //\n', '  uint256 public fundingMinCapInWei;                          //\n', '\n', '  // loop control, ICO startup and limiters\n', '  string  public CurrentStatus                   = "";        // current crowdsale status\n', '  uint256 public fundingStartBlock;                           // crowdsale start block#\n', '  uint256 public fundingEndBlock;                             // crowdsale end block#\n', '  bool    public isCrowdSaleClosed               = false;     // crowdsale completion boolean\n', '  bool    public areFundsReleasedToBeneficiary   = false;     // boolean for founders to receive Eth or not\n', '  bool    public isCrowdSaleSetup                = false;     // boolean for crowdsale setup\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '  event Buy(address indexed _sender, uint256 _eth, uint256 _BST);\n', '  event Refund(address indexed _refunder, uint256 _value);\n', '  event Burn(address _from, uint256 _value);\n', '  mapping(address => uint256) balancesArray;\n', '  mapping(address => uint256) fundValue;\n', '\n', '  // default function, map admin\n', '  function BetstreakICO() onlyOwner {\n', '    admin = msg.sender;\n', '    CurrentStatus = "Crowdsale deployed to chain";\n', '  }\n', '\n', '  // total number of tokens initially\n', '  function initialBSTSupply() constant returns (uint256 tokenTotalSupply) {\n', '      tokenTotalSupply = safeDiv(initialSupply,100); \n', '  }\n', '\n', '  // remaining number of tokens\n', '  function remainingSupply() constant returns (uint256 tokensLeft) {\n', '      tokensLeft = tokensRemaining;\n', '  }\n', '\n', '  // setup the CrowdSale parameters\n', '  function SetupCrowdsale(uint256 _fundingStartBlock, uint256 _fundingEndBlock) onlyOwner returns (bytes32 response) {\n', '      \n', '      if ((msg.sender == admin)\n', '      && (!(isCrowdSaleSetup))  \n', '      && (!(beneficiaryWallet > 0))){\n', '      \n', '          // init addresses\n', '          tokenReward                             = StandardToken(0xA7F40CCD6833a65dD514088F4d419Afd9F0B0B52);  \n', '          \n', '          \n', '          \n', '          beneficiaryWallet                       = 0x361e14cC5b3CfBa5D197D8a9F02caf71B3dca6Fd;\n', '          \n', '         \n', '          tokensPerEthPrice                       = 1300;                                         \n', '          // set day1 initial value floating priceVar 1,300 tokens per Eth\n', '\n', '          // funding targets\n', '          fundingMinCapInWei                      = 1000000000000000000000;                          \n', '          //300000000000000000000 =  1000 Eth (min cap) - crowdsale is considered success after this value  \n', '          //testnet 5000000000000000000 = 5Eth\n', '\n', '\n', '          // update values\n', '          amountRaisedInWei                       = 0;\n', '          initialSupply                           = 20000000000;                                      \n', '          //   200,000,000 + 2 decimals = 200,000,000,00 \n', '          //testnet 1100000 = 11,000\n', '          \n', '          tokensRemaining                         = safeDiv(initialSupply,100);\n', '\n', '          fundingStartBlock                       = _fundingStartBlock;\n', '          fundingEndBlock                         = _fundingEndBlock;\n', '\n', '          // configure crowdsale\n', '          isCrowdSaleSetup                        = true;\n', '          isCrowdSaleClosed                       = false;\n', '          CurrentStatus                           = "Crowdsale is setup";\n', '\n', '          //gas reduction experiment\n', '          setPrice();\n', '          return "Crowdsale is setup";\n', '          \n', '      } else if (msg.sender != admin) {\n', '          return "not authorized";\n', '          \n', '      } else  {\n', '          return "campaign cannot be changed";\n', '      }\n', '    }\n', '\n', '\n', '    function setPrice() {\n', '        \n', '        // ICO configuration:\n', '        // Presale Bonus      +30% = 1,300 BST   = 1 ETH       [blocks: start   -> s+25200]\n', '        // First Week Bonus   +20% = 1,200 BST  = 1 ETH       [blocks: s+25201  -> s+50400]\n', '        // Second Week Bonus  +10% = 1,100 BST  = 1 ETH       [blocks: s+50401 -> s+75600]\n', '        // Third Week Bonus   +5% = 1,050 BST   = 1 ETH       [blocks: s+75601 -> s+100800]\n', '        // Final Week         +0% = 1,000 BST   = 1 ETH       [blocks: s+100801 -> end]\n', '        \n', '      if (block.number >= fundingStartBlock && block.number <= fundingStartBlock+25200) { \n', '          // Presale Bonus      +30% = 1,300 BST   = 1 ETH       [blocks: start   -> s+25200]\n', '          \n', '        tokensPerEthPrice=1300;\n', '        \n', '      } else if (block.number >= fundingStartBlock+25201 && block.number <= fundingStartBlock+50400) { \n', '          // First Week Bonus   +20% = 1,200 BST  = 1 ETH       [blocks: s+25201  -> s+50400]\n', '          \n', '        tokensPerEthPrice=1200;\n', '        \n', '      } else if (block.number >= fundingStartBlock+50401 && block.number <= fundingStartBlock+75600) { \n', '          // Second Week Bonus  +10% = 1,100 BST  = 1 ETH       [blocks: s+50401 -> s+75600]\n', '          \n', '        tokensPerEthPrice=1100;\n', '        \n', '      } else if (block.number >= fundingStartBlock+75601 && block.number <= fundingStartBlock+100800) { \n', '          // Third Week Bonus   +5% = 1,050 BST   = 1 ETH       [blocks: s+75601 -> s+100800]\n', '          \n', '        tokensPerEthPrice=1050;\n', '        \n', '      } else if (block.number >= fundingStartBlock+100801 && block.number <= fundingEndBlock) { \n', '          // Final Week         +0% = 1,000 BST   = 1 ETH       [blocks: s+100801 -> end]\n', '          \n', '        tokensPerEthPrice=1000;\n', '      }\n', '    }\n', '\n', '    // default payable function when sending ether to this contract\n', '    function () payable {\n', '      require(msg.data.length == 0);\n', '      BuyBSTtokens();\n', '    }\n', '\n', '    function BuyBSTtokens() payable {\n', '        \n', '      // 0. conditions (length, crowdsale setup, zero check, \n', '      //exceed funding contrib check, contract valid check, within funding block range check, balance overflow check etc)\n', '      require(!(msg.value == 0)\n', '      && (isCrowdSaleSetup)\n', '      && (block.number >= fundingStartBlock)\n', '      && (block.number <= fundingEndBlock)\n', '      && (tokensRemaining > 0));\n', '\n', '      // 1. vars\n', '      uint256 rewardTransferAmount    = 0;\n', '\n', '      // 2. effects\n', '      setPrice();\n', '      amountRaisedInWei               = safeAdd(amountRaisedInWei,msg.value);\n', '      rewardTransferAmount            = safeDiv(safeMul(msg.value,tokensPerEthPrice),10000000000000000);\n', '\n', '      // 3. interaction\n', '      tokensRemaining                 = safeSub(tokensRemaining, safeDiv(rewardTransferAmount,100));  \n', '      // will cause throw if attempt to purchase over the token limit in one tx or at all once limit reached\n', '      tokenReward.transfer(msg.sender, rewardTransferAmount);\n', '\n', '      // 4. events\n', '      fundValue[msg.sender]           = safeAdd(fundValue[msg.sender], msg.value);\n', '      Transfer(this, msg.sender, msg.value);\n', '      Buy(msg.sender, msg.value, rewardTransferAmount);\n', '    }\n', '    \n', '\n', '    function beneficiaryMultiSigWithdraw(uint256 _amount) onlyOwner {\n', '      require(areFundsReleasedToBeneficiary && (amountRaisedInWei >= fundingMinCapInWei));\n', '      beneficiaryWallet.transfer(_amount);\n', '    }\n', '\n', '    function checkGoalReached() onlyOwner returns (bytes32 response) {\n', '        \n', '        // return crowdfund status to owner for each result case, update public constant\n', '        // update state & status variables\n', '      require (isCrowdSaleSetup);\n', '      \n', '      if ((amountRaisedInWei < fundingMinCapInWei) && (block.number <= fundingEndBlock && block.number >= fundingStartBlock)) { \n', '        // ICO in progress, under softcap\n', '        areFundsReleasedToBeneficiary = false;\n', '        isCrowdSaleClosed = false;\n', '        CurrentStatus = "In progress (Eth < Softcap)";\n', '        return "In progress (Eth < Softcap)";\n', '        \n', '      } else if ((amountRaisedInWei < fundingMinCapInWei) && (block.number < fundingStartBlock)) { // ICO has not started\n', '        areFundsReleasedToBeneficiary = false;\n', '        isCrowdSaleClosed = false;\n', '        CurrentStatus = "Presale is setup";\n', '        return "Presale is setup";\n', '        \n', '        \n', '      } else if ((amountRaisedInWei < fundingMinCapInWei) && (block.number > fundingEndBlock)) { // ICO ended, under softcap\n', '        areFundsReleasedToBeneficiary = false;\n', '        isCrowdSaleClosed = true;\n', '        CurrentStatus = "Unsuccessful (Eth < Softcap)";\n', '        return "Unsuccessful (Eth < Softcap)";\n', '        \n', '      } else if ((amountRaisedInWei >= fundingMinCapInWei) && (tokensRemaining == 0)) { // ICO ended, all tokens gone\n', '          areFundsReleasedToBeneficiary = true;\n', '          isCrowdSaleClosed = true;\n', '          CurrentStatus = "Successful (BST >= Hardcap)!";\n', '          return "Successful (BST >= Hardcap)!";\n', '          \n', '          \n', '      } else if ((amountRaisedInWei >= fundingMinCapInWei) && (block.number > fundingEndBlock) && (tokensRemaining > 0)) { \n', '          \n', '          // ICO ended, over softcap!\n', '          areFundsReleasedToBeneficiary = true;\n', '          isCrowdSaleClosed = true;\n', '          CurrentStatus = "Successful (Eth >= Softcap)!";\n', '          return "Successful (Eth >= Softcap)!";\n', '          \n', '          \n', '      } else if ((amountRaisedInWei >= fundingMinCapInWei) && (tokensRemaining > 0) && (block.number <= fundingEndBlock)) { \n', '          \n', '          // ICO in progress, over softcap!\n', '        areFundsReleasedToBeneficiary = true;\n', '        isCrowdSaleClosed = false;\n', '        CurrentStatus = "In progress (Eth >= Softcap)!";\n', '        return "In progress (Eth >= Softcap)!";\n', '      }\n', '      \n', '      setPrice();\n', '    }\n', '\n', '    function refund() { \n', '        \n', '        // any contributor can call this to have their Eth returned. \n', '        // user&#39;s purchased BST tokens are burned prior refund of Eth.\n', '        //require minCap not reached\n', '        \n', '      require ((amountRaisedInWei < fundingMinCapInWei)\n', '      && (isCrowdSaleClosed)\n', '      && (block.number > fundingEndBlock)\n', '      && (fundValue[msg.sender] > 0));\n', '\n', '      //burn user&#39;s token BST token balance, refund Eth sent\n', '      uint256 ethRefund = fundValue[msg.sender];\n', '      balancesArray[msg.sender] = 0;\n', '      fundValue[msg.sender] = 0;\n', '      Burn(msg.sender, ethRefund);\n', '\n', '      //send Eth back, burn tokens\n', '      msg.sender.transfer(ethRefund);\n', '      Refund(msg.sender, ethRefund);\n', '    }\n', '}']