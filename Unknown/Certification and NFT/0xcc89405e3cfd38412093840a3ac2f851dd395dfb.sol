['pragma solidity ^0.4.11;\n', '\n', '/*\n', '\n', 'Status Buyer\n', '========================\n', '\n', 'Buys Status tokens from the crowdsale on your behalf.\n', 'Author: /u/Cintix\n', '\n', '*/\n', '\n', '// ERC20 Interface: https://github.com/ethereum/EIPs/issues/20\n', 'contract ERC20 {\n', '  function transfer(address _to, uint256 _value) returns (bool success);\n', '  function balanceOf(address _owner) constant returns (uint256 balance);\n', '}\n', '\n', '// Interface to Status ICO Contract\n', 'contract StatusContribution {\n', '  uint256 public maxGasPrice;\n', '  uint256 public startBlock;\n', '  uint256 public totalNormalCollected;\n', '  uint256 public finalizedBlock;\n', '  function proxyPayment(address _th) payable returns (bool);\n', '}\n', '\n', '// Interface to Status Cap Determination Contract\n', 'contract DynamicCeiling {\n', '  function curves(uint currentIndex) returns (bytes32 hash, \n', '                                              uint256 limit, \n', '                                              uint256 slopeFactor, \n', '                                              uint256 collectMinimum);\n', '  uint256 public currentIndex;\n', '  uint256 public revealedCurves;\n', '}\n', '\n', 'contract StatusBuyer {\n', '  // Store the amount of ETH deposited by each account.\n', '  mapping (address => uint256) public deposits;\n', '  // Track how much SNT each account would have been able to purchase on their own.\n', '  mapping (address => uint256) public simulated_snt;\n', '  // Bounty for executing buy.\n', '  uint256 public bounty;\n', '  // Track whether the contract has bought tokens yet.\n', '  bool public bought_tokens;\n', '  \n', '  // The Status Token Sale address.\n', '  StatusContribution public sale = StatusContribution(0x55d34b686aa8C04921397c5807DB9ECEdba00a4c);\n', '  // The Status DynamicCeiling Contract address.\n', '  DynamicCeiling public dynamic = DynamicCeiling(0xc636e73Ff29fAEbCABA9E0C3f6833EaD179FFd5c);\n', '  // Status Network Token (SNT) Contract address.\n', '  ERC20 public token = ERC20(0x744d70FDBE2Ba4CF95131626614a1763DF805B9E);\n', '  // The developer address.\n', '  address developer = 0x4e6A1c57CdBfd97e8efe831f8f4418b1F2A09e6e;\n', '  \n', '  // Withdraws all ETH/SNT owned by the user in the ratio currently owned by the contract.\n', '  function withdraw() {\n', '    // Store the user&#39;s deposit prior to withdrawal in a temporary variable.\n', '    uint256 user_deposit = deposits[msg.sender];\n', '    // Update the user&#39;s deposit prior to sending ETH to prevent recursive call.\n', '    deposits[msg.sender] = 0;\n', '    // Retrieve current ETH balance of contract (less the bounty).\n', '    uint256 contract_eth_balance = this.balance - bounty;\n', '    // Retrieve current SNT balance of contract.\n', '    uint256 contract_snt_balance = token.balanceOf(address(this));\n', '    // Calculate total SNT value of ETH and SNT owned by the contract.\n', '    // 1 ETH Wei -> 10000 SNT Wei\n', '    uint256 contract_value = (contract_eth_balance * 10000) + contract_snt_balance;\n', '    // Calculate amount of ETH to withdraw.\n', '    uint256 eth_amount = (user_deposit * contract_eth_balance * 10000) / contract_value;\n', '    // Calculate amount of SNT to withdraw.\n', '    uint256 snt_amount = 10000 * ((user_deposit * contract_snt_balance) / contract_value);\n', '    // No fee for withdrawing if user would have made it into the crowdsale alone.\n', '    uint256 fee = 0;\n', '    // 1% fee on portion of tokens user would not have been able to buy alone.\n', '    if (simulated_snt[msg.sender] < snt_amount) {\n', '      fee = (snt_amount - simulated_snt[msg.sender]) / 100;\n', '    }\n', '    // Send the funds.  Throws on failure to prevent loss of funds.\n', '    if(!token.transfer(msg.sender, snt_amount - fee)) throw;\n', '    if(!token.transfer(developer, fee)) throw;\n', '    msg.sender.transfer(eth_amount);\n', '  }\n', '  \n', '  // Allow anyone to contribute to the buy execution bounty.\n', '  function add_to_bounty() payable {\n', '    // Disallow adding to the bounty if contract has already bought the tokens.\n', '    if (bought_tokens) throw;\n', '    // Update bounty to include received amount.\n', '    bounty += msg.value;\n', '  }\n', '  \n', '  // Allow users to simulate entering the crowdsale to avoid the fee.  Callable by anyone.\n', '  function simulate_ico() {\n', '    // Limit maximum gas price to the same value as the Status ICO (50 GWei).\n', '    if (tx.gasprice > sale.maxGasPrice()) throw;\n', '    // Restrict until after the ICO has started.\n', '    if (block.number < sale.startBlock()) throw;\n', '    if (dynamic.revealedCurves() == 0) throw;\n', '    // Extract the buy limit and rate-limiting slope factor of the current curve/cap.\n', '    uint256 limit;\n', '    uint256 slopeFactor;\n', '    (,limit,slopeFactor,) = dynamic.curves(dynamic.currentIndex());\n', '    // Retrieve amount of ETH the ICO has collected so far.\n', '    uint256 totalNormalCollected = sale.totalNormalCollected();\n', '    // Verify the ICO is not currently at a cap, waiting for a reveal.\n', '    if (limit <= totalNormalCollected) throw;\n', '    // Add the maximum contributable amount to the user&#39;s simulated SNT balance.\n', '    simulated_snt[msg.sender] += ((limit - totalNormalCollected) / slopeFactor);\n', '  }\n', '  \n', '  // Buys tokens in the crowdsale and rewards the sender.  Callable by anyone.\n', '  function buy() {\n', '    // Short circuit to save gas if the contract has already bought tokens.\n', '    if (bought_tokens) return;\n', '    // Record that the contract has bought tokens first to prevent recursive call.\n', '    bought_tokens = true;\n', '    // Transfer all the funds (less the bounty) to the Status ICO contract \n', '    // to buy tokens.  Throws if the crowdsale hasn&#39;t started yet or has \n', '    // already completed, preventing loss of funds.\n', '    sale.proxyPayment.value(this.balance - bounty)(address(this));\n', '    // Send the user their bounty for buying tokens for the contract.\n', '    msg.sender.transfer(bounty);\n', '  }\n', '  \n', '  // A helper function for the default function, allowing contracts to interact.\n', '  function default_helper() payable {\n', '    // Only allow deposits if the contract hasn&#39;t already purchased the tokens.\n', '    if (!bought_tokens) {\n', '      // Update records of deposited ETH to include the received amount.\n', '      deposits[msg.sender] += msg.value;\n', '      // Block each user from contributing more than 30 ETH.  No whales!  >:C\n', '      if (deposits[msg.sender] > 30 ether) throw;\n', '    }\n', '    else {\n', '      // Reject ETH sent after the contract has already purchased tokens.\n', '      if (msg.value != 0) throw;\n', '      // If the ICO isn&#39;t over yet, simulate entering the crowdsale.\n', '      if (sale.finalizedBlock() == 0) {\n', '        simulate_ico();\n', '      }\n', '      else {\n', '        // Withdraw user&#39;s funds if they sent 0 ETH to the contract after the ICO.\n', '        withdraw();\n', '      }\n', '    }\n', '  }\n', '  \n', '  // Default function.  Called when a user sends ETH to the contract.\n', '  function () payable {\n', '    // Avoid recursively buying tokens when the sale contract refunds ETH.\n', '    if (msg.sender == address(sale)) return;\n', '    // Delegate to the helper function.\n', '    default_helper();\n', '  }\n', '}']
['pragma solidity ^0.4.11;\n', '\n', '/*\n', '\n', 'Status Buyer\n', '========================\n', '\n', 'Buys Status tokens from the crowdsale on your behalf.\n', 'Author: /u/Cintix\n', '\n', '*/\n', '\n', '// ERC20 Interface: https://github.com/ethereum/EIPs/issues/20\n', 'contract ERC20 {\n', '  function transfer(address _to, uint256 _value) returns (bool success);\n', '  function balanceOf(address _owner) constant returns (uint256 balance);\n', '}\n', '\n', '// Interface to Status ICO Contract\n', 'contract StatusContribution {\n', '  uint256 public maxGasPrice;\n', '  uint256 public startBlock;\n', '  uint256 public totalNormalCollected;\n', '  uint256 public finalizedBlock;\n', '  function proxyPayment(address _th) payable returns (bool);\n', '}\n', '\n', '// Interface to Status Cap Determination Contract\n', 'contract DynamicCeiling {\n', '  function curves(uint currentIndex) returns (bytes32 hash, \n', '                                              uint256 limit, \n', '                                              uint256 slopeFactor, \n', '                                              uint256 collectMinimum);\n', '  uint256 public currentIndex;\n', '  uint256 public revealedCurves;\n', '}\n', '\n', 'contract StatusBuyer {\n', '  // Store the amount of ETH deposited by each account.\n', '  mapping (address => uint256) public deposits;\n', '  // Track how much SNT each account would have been able to purchase on their own.\n', '  mapping (address => uint256) public simulated_snt;\n', '  // Bounty for executing buy.\n', '  uint256 public bounty;\n', '  // Track whether the contract has bought tokens yet.\n', '  bool public bought_tokens;\n', '  \n', '  // The Status Token Sale address.\n', '  StatusContribution public sale = StatusContribution(0x55d34b686aa8C04921397c5807DB9ECEdba00a4c);\n', '  // The Status DynamicCeiling Contract address.\n', '  DynamicCeiling public dynamic = DynamicCeiling(0xc636e73Ff29fAEbCABA9E0C3f6833EaD179FFd5c);\n', '  // Status Network Token (SNT) Contract address.\n', '  ERC20 public token = ERC20(0x744d70FDBE2Ba4CF95131626614a1763DF805B9E);\n', '  // The developer address.\n', '  address developer = 0x4e6A1c57CdBfd97e8efe831f8f4418b1F2A09e6e;\n', '  \n', '  // Withdraws all ETH/SNT owned by the user in the ratio currently owned by the contract.\n', '  function withdraw() {\n', "    // Store the user's deposit prior to withdrawal in a temporary variable.\n", '    uint256 user_deposit = deposits[msg.sender];\n', "    // Update the user's deposit prior to sending ETH to prevent recursive call.\n", '    deposits[msg.sender] = 0;\n', '    // Retrieve current ETH balance of contract (less the bounty).\n', '    uint256 contract_eth_balance = this.balance - bounty;\n', '    // Retrieve current SNT balance of contract.\n', '    uint256 contract_snt_balance = token.balanceOf(address(this));\n', '    // Calculate total SNT value of ETH and SNT owned by the contract.\n', '    // 1 ETH Wei -> 10000 SNT Wei\n', '    uint256 contract_value = (contract_eth_balance * 10000) + contract_snt_balance;\n', '    // Calculate amount of ETH to withdraw.\n', '    uint256 eth_amount = (user_deposit * contract_eth_balance * 10000) / contract_value;\n', '    // Calculate amount of SNT to withdraw.\n', '    uint256 snt_amount = 10000 * ((user_deposit * contract_snt_balance) / contract_value);\n', '    // No fee for withdrawing if user would have made it into the crowdsale alone.\n', '    uint256 fee = 0;\n', '    // 1% fee on portion of tokens user would not have been able to buy alone.\n', '    if (simulated_snt[msg.sender] < snt_amount) {\n', '      fee = (snt_amount - simulated_snt[msg.sender]) / 100;\n', '    }\n', '    // Send the funds.  Throws on failure to prevent loss of funds.\n', '    if(!token.transfer(msg.sender, snt_amount - fee)) throw;\n', '    if(!token.transfer(developer, fee)) throw;\n', '    msg.sender.transfer(eth_amount);\n', '  }\n', '  \n', '  // Allow anyone to contribute to the buy execution bounty.\n', '  function add_to_bounty() payable {\n', '    // Disallow adding to the bounty if contract has already bought the tokens.\n', '    if (bought_tokens) throw;\n', '    // Update bounty to include received amount.\n', '    bounty += msg.value;\n', '  }\n', '  \n', '  // Allow users to simulate entering the crowdsale to avoid the fee.  Callable by anyone.\n', '  function simulate_ico() {\n', '    // Limit maximum gas price to the same value as the Status ICO (50 GWei).\n', '    if (tx.gasprice > sale.maxGasPrice()) throw;\n', '    // Restrict until after the ICO has started.\n', '    if (block.number < sale.startBlock()) throw;\n', '    if (dynamic.revealedCurves() == 0) throw;\n', '    // Extract the buy limit and rate-limiting slope factor of the current curve/cap.\n', '    uint256 limit;\n', '    uint256 slopeFactor;\n', '    (,limit,slopeFactor,) = dynamic.curves(dynamic.currentIndex());\n', '    // Retrieve amount of ETH the ICO has collected so far.\n', '    uint256 totalNormalCollected = sale.totalNormalCollected();\n', '    // Verify the ICO is not currently at a cap, waiting for a reveal.\n', '    if (limit <= totalNormalCollected) throw;\n', "    // Add the maximum contributable amount to the user's simulated SNT balance.\n", '    simulated_snt[msg.sender] += ((limit - totalNormalCollected) / slopeFactor);\n', '  }\n', '  \n', '  // Buys tokens in the crowdsale and rewards the sender.  Callable by anyone.\n', '  function buy() {\n', '    // Short circuit to save gas if the contract has already bought tokens.\n', '    if (bought_tokens) return;\n', '    // Record that the contract has bought tokens first to prevent recursive call.\n', '    bought_tokens = true;\n', '    // Transfer all the funds (less the bounty) to the Status ICO contract \n', "    // to buy tokens.  Throws if the crowdsale hasn't started yet or has \n", '    // already completed, preventing loss of funds.\n', '    sale.proxyPayment.value(this.balance - bounty)(address(this));\n', '    // Send the user their bounty for buying tokens for the contract.\n', '    msg.sender.transfer(bounty);\n', '  }\n', '  \n', '  // A helper function for the default function, allowing contracts to interact.\n', '  function default_helper() payable {\n', "    // Only allow deposits if the contract hasn't already purchased the tokens.\n", '    if (!bought_tokens) {\n', '      // Update records of deposited ETH to include the received amount.\n', '      deposits[msg.sender] += msg.value;\n', '      // Block each user from contributing more than 30 ETH.  No whales!  >:C\n', '      if (deposits[msg.sender] > 30 ether) throw;\n', '    }\n', '    else {\n', '      // Reject ETH sent after the contract has already purchased tokens.\n', '      if (msg.value != 0) throw;\n', "      // If the ICO isn't over yet, simulate entering the crowdsale.\n", '      if (sale.finalizedBlock() == 0) {\n', '        simulate_ico();\n', '      }\n', '      else {\n', "        // Withdraw user's funds if they sent 0 ETH to the contract after the ICO.\n", '        withdraw();\n', '      }\n', '    }\n', '  }\n', '  \n', '  // Default function.  Called when a user sends ETH to the contract.\n', '  function () payable {\n', '    // Avoid recursively buying tokens when the sale contract refunds ETH.\n', '    if (msg.sender == address(sale)) return;\n', '    // Delegate to the helper function.\n', '    default_helper();\n', '  }\n', '}']