['pragma solidity ^0.4.11;\n', '\n', '/*\n', '\n', 'BET Buyer\n', '========================\n', '\n', 'Buys BET tokens from the DAO.Casino crowdsale on your behalf.\n', 'Author: /u/Cintix\n', '\n', '*/\n', '\n', '// Interface to BET ICO Contract\n', 'contract DaoCasinoToken {\n', '  uint256 public CAP;\n', '  uint256 public totalEthers;\n', '  function proxyPayment(address participant) payable;\n', '  function transfer(address _to, uint _amount) returns (bool success);\n', '}\n', '\n', 'contract BetBuyer {\n', '  // Store the amount of ETH deposited by each account.\n', '  mapping (address => uint256) public balances;\n', '  // Store whether or not each account would have made it into the crowdsale.\n', '  mapping (address => bool) public checked_in;\n', '  // Bounty for executing buy.\n', '  uint256 public bounty;\n', '  // Track whether the contract has bought the tokens yet.\n', '  bool public bought_tokens;\n', '  // Record the time the contract bought the tokens.\n', '  uint256 public time_bought;\n', '  // Emergency kill switch in case a critical bug is found.\n', '  bool public kill_switch;\n', '  \n', '  // Ratio of BET tokens received to ETH contributed\n', '  uint256 bet_per_eth = 2000;\n', '  \n', '  // The BET Token address and sale address are the same.\n', '  DaoCasinoToken public token = DaoCasinoToken(0x2B09b52d42DfB4e0cBA43F607dD272ea3FE1FB9F);\n', '  // The developer address.\n', '  address developer = 0x000Fb8369677b3065dE5821a86Bc9551d5e5EAb9;\n', '  \n', '  // Allows the developer to shut down everything except withdrawals in emergencies.\n', '  function activate_kill_switch() {\n', '    // Only allow the developer to activate the kill switch.\n', '    if (msg.sender != developer) throw;\n', '    // Irreversibly activate the kill switch.\n', '    kill_switch = true;\n', '  }\n', '  \n', '  // Withdraws all ETH deposited or BET purchased by the sender.\n', '  function withdraw(){\n', '    // If called before the ICO, cancel caller&#39;s participation in the sale.\n', '    if (!bought_tokens) {\n', '      // Store the user&#39;s balance prior to withdrawal in a temporary variable.\n', '      uint256 eth_amount = balances[msg.sender];\n', '      // Update the user&#39;s balance prior to sending ETH to prevent recursive call.\n', '      balances[msg.sender] = 0;\n', '      // Return the user&#39;s funds.  Throws on failure to prevent loss of funds.\n', '      msg.sender.transfer(eth_amount);\n', '    }\n', '    // Withdraw the sender&#39;s tokens if the contract has already purchased them.\n', '    else {\n', '      // Store the user&#39;s BET balance in a temporary variable (1 ETHWei -> 2000 BETWei).\n', '      uint256 bet_amount = balances[msg.sender] * bet_per_eth;\n', '      // Update the user&#39;s balance prior to sending BET to prevent recursive call.\n', '      balances[msg.sender] = 0;\n', '      // No fee for withdrawing if the user would have made it into the crowdsale alone.\n', '      uint256 fee = 0;\n', '      // 1% fee if the user didn&#39;t check in during the crowdsale.\n', '      if (!checked_in[msg.sender]) {\n', '        fee = bet_amount / 100;\n', '        // Send any non-zero fees to developer.\n', '        if(!token.transfer(developer, fee)) throw;\n', '      }\n', '      // Send the user their tokens.  Throws if the crowdsale isn&#39;t over.\n', '      if(!token.transfer(msg.sender, bet_amount - fee)) throw;\n', '    }\n', '  }\n', '  \n', '  // Allow developer to add ETH to the buy execution bounty.\n', '  function add_to_bounty() payable {\n', '    // Only allow the developer to contribute to the buy execution bounty.\n', '    if (msg.sender != developer) throw;\n', '    // Disallow adding to bounty if kill switch is active.\n', '    if (kill_switch) throw;\n', '    // Disallow adding to the bounty if contract has already bought the tokens.\n', '    if (bought_tokens) throw;\n', '    // Update bounty to include received amount.\n', '    bounty += msg.value;\n', '  }\n', '  \n', '  // Buys tokens in the crowdsale and rewards the caller, callable by anyone.\n', '  function claim_bounty(){\n', '    // Short circuit to save gas if the contract has already bought tokens.\n', '    if (bought_tokens) return;\n', '    // Disallow buying into the crowdsale if kill switch is active.\n', '    if (kill_switch) throw;\n', '    // Record that the contract has bought the tokens.\n', '    bought_tokens = true;\n', '    // Record the time the contract bought the tokens.\n', '    time_bought = now;\n', '    // Transfer all the funds (less the bounty) to the BET crowdsale contract\n', '    // to buy tokens.  Throws if the crowdsale hasn&#39;t started yet or has\n', '    // already completed, preventing loss of funds.\n', '    token.proxyPayment.value(this.balance - bounty)(address(this));\n', '    // Send the caller their bounty for buying tokens for the contract.\n', '    msg.sender.transfer(bounty);\n', '  }\n', '  \n', '  // A helper function for the default function, allowing contracts to interact.\n', '  function default_helper() payable {\n', '    // Treat near-zero ETH transactions as check ins and withdrawal requests.\n', '    if (msg.value <= 1 finney) {\n', '      // Check in during the crowdsale before it has reached the cap.\n', '      if (bought_tokens && token.totalEthers() < token.CAP()) {\n', '        // Mark user as checked in, meaning they would have been able to enter alone.\n', '        checked_in[msg.sender] = true;\n', '      }\n', '      // Withdraw funds if the crowdsale hasn&#39;t begun yet or is already over.\n', '      else {\n', '        withdraw();\n', '      }\n', '    }\n', '    // Deposit the user&#39;s funds for use in purchasing tokens.\n', '    else {\n', '      // Disallow deposits if kill switch is active.\n', '      if (kill_switch) throw;\n', '      // Only allow deposits if the contract hasn&#39;t already purchased the tokens.\n', '      if (bought_tokens) throw;\n', '      // Update records of deposited ETH to include the received amount.\n', '      balances[msg.sender] += msg.value;\n', '    }\n', '  }\n', '  \n', '  // Default function.  Called when a user sends ETH to the contract.\n', '  function () payable {\n', '    // Delegate to the helper function.\n', '    default_helper();\n', '  }\n', '}']