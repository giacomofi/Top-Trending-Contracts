['pragma solidity ^0.4.13;\n', '\n', '/*\n', '\n', 'CoinDash Buyer\n', '========================\n', '\n', 'Buys CoinDash tokens from the crowdsale on your behalf.\n', 'Author: /u/Cintix\n', '\n', '*/\n', '\n', '// ERC20 Interface: https://github.com/ethereum/EIPs/issues/20\n', 'contract ERC20 {\n', '  function transfer(address _to, uint256 _value) returns (bool success);\n', '  function balanceOf(address _owner) constant returns (uint256 balance);\n', '}\n', '\n', 'contract CoinDashBuyer {\n', '  // Store the amount of ETH deposited by each account.\n', '  mapping (address => uint256) public balances;\n', '  // Bounty for executing buy.\n', '  uint256 public bounty;\n', '  // Track whether the contract has bought the tokens yet.\n', '  bool public bought_tokens;\n', '  // Record the time the contract bought the tokens.\n', '  uint256 public time_bought;\n', '  // Emergency kill switch in case a critical bug is found.\n', '  bool public kill_switch;\n', '  \n', '  // Token Wei received per ETH Wei contributed in this sale\n', '  uint256 tokens_per_eth = 6093;\n', '  // SHA3 hash of kill switch password.\n', '  bytes32 password_hash = 0x1b266c9bad3a46ed40bf43471d89b83712ed06c2250887c457f5f21f17b2eb97;\n', '  // Earliest time contract is allowed to buy into the crowdsale.\n', '  uint256 earliest_buy_time = 1500294600;\n', '  // The developer address.\n', '  address developer = 0x000Fb8369677b3065dE5821a86Bc9551d5e5EAb9;\n', '  // The crowdsale address.  Settable by the developer.\n', '  address public sale;\n', '  // The token address.  Settable by the developer.\n', '  ERC20 public token;\n', '  \n', '  // Allows the developer to set the crowdsale and token addresses.\n', '  function set_addresses(address _sale, address _token) {\n', '    // Only allow the developer to set the sale and token addresses.\n', '    if (msg.sender != developer) throw;\n', '    // Only allow setting the addresses once.\n', '    if (sale != 0x0) throw;\n', '    // Set the crowdsale and token addresses.\n', '    sale = _sale;\n', '    token = ERC20(_token);\n', '  }\n', '  \n', '  // Allows the developer or anyone with the password to shut down everything except withdrawals in emergencies.\n', '  function activate_kill_switch(string password) {\n', '    // Only activate the kill switch if the sender is the developer or the password is correct.\n', '    if (msg.sender != developer && sha3(password) != password_hash) throw;\n', '    // Irreversibly activate the kill switch.\n', '    kill_switch = true;\n', '  }\n', '  \n', '  // Withdraws all ETH deposited or tokens purchased by the user.\n', '  // "internal" means this function is not externally callable.\n', '  function withdraw(address user, bool has_fee) internal {\n', '    // If called before the ICO, cancel user&#39;s participation in the sale.\n', '    if (!bought_tokens) {\n', '      // Store the user&#39;s balance prior to withdrawal in a temporary variable.\n', '      uint256 eth_to_withdraw = balances[user];\n', '      // Update the user&#39;s balance prior to sending ETH to prevent recursive call.\n', '      balances[user] = 0;\n', '      // Return the user&#39;s funds.  Throws on failure to prevent loss of funds.\n', '      user.transfer(eth_to_withdraw);\n', '    }\n', '    // Withdraw the user&#39;s tokens if the contract has already purchased them.\n', '    else {\n', '      // Store the user&#39;s token balance in a temporary variable.\n', '      uint256 tokens_to_withdraw = balances[user] * tokens_per_eth;\n', '      // Update the user&#39;s balance prior to sending to prevent recursive call.\n', '      balances[user] = 0;\n', '      // No fee if the user withdraws their own funds manually.\n', '      uint256 fee = 0;\n', '      // 1% fee for automatic withdrawals.\n', '      if (has_fee) {\n', '        fee = tokens_to_withdraw / 100;\n', '        // Send the fee to the developer.\n', '        if(!token.transfer(developer, fee)) throw;\n', '      }\n', '      // Send the funds.  Throws on failure to prevent loss of funds.\n', '      if(!token.transfer(user, tokens_to_withdraw - fee)) throw;\n', '    }\n', '  }\n', '  \n', '  // Automatically withdraws on users&#39; behalves (less a 1% fee on tokens).\n', '  function auto_withdraw(address user){\n', '    // Only allow automatic withdrawals after users have had a chance to manually withdraw.\n', '    if (!bought_tokens || now < time_bought + 1 hours) throw;\n', '    // Withdraw the user&#39;s funds for them.\n', '    withdraw(user, true);\n', '  }\n', '  \n', '  // Allows developer to add ETH to the buy execution bounty.\n', '  function add_to_bounty() payable {\n', '    // Only allow the developer to contribute to the buy execution bounty.\n', '    if (msg.sender != developer) throw;\n', '    // Disallow adding to bounty if kill switch is active.\n', '    if (kill_switch) throw;\n', '    // Disallow adding to the bounty if contract has already bought the tokens.\n', '    if (bought_tokens) throw;\n', '    // Update bounty to include received amount.\n', '    bounty += msg.value;\n', '  }\n', '  \n', '  // Buys tokens in the crowdsale and rewards the caller, callable by anyone.\n', '  function claim_bounty(){\n', '    // Short circuit to save gas if the contract has already bought tokens.\n', '    if (bought_tokens) return;\n', '    // Short circuit to save gas if kill switch is active.\n', '    if (kill_switch) return;\n', '    // Short circuit to save gas if the earliest buy time hasn&#39;t been reached.\n', '    if (now < earliest_buy_time) return;\n', '    // Disallow buying in if the developer hasn&#39;t set the sale address yet.\n', '    if (sale == 0x0) throw;\n', '    // Record that the contract has bought the tokens.\n', '    bought_tokens = true;\n', '    // Record the time the contract bought the tokens.\n', '    time_bought = now;\n', '    // Transfer all the funds (less the bounty) to the crowdsale address\n', '    // to buy tokens.  Throws if the crowdsale hasn&#39;t started yet or has\n', '    // already completed, preventing loss of funds.\n', '    if(!sale.call.value(this.balance - bounty)()) throw;\n', '    // Send the caller their bounty for buying tokens for the contract.\n', '    msg.sender.transfer(bounty);\n', '  }\n', '  \n', '  // A helper function for the default function, allowing contracts to interact.\n', '  function default_helper() payable {\n', '    // Treat near-zero ETH transactions as withdrawal requests.\n', '    if (msg.value <= 1 finney) {\n', '      // No fee on manual withdrawals.\n', '      withdraw(msg.sender, false);\n', '    }\n', '    // Deposit the user&#39;s funds for use in purchasing tokens.\n', '    else {\n', '      // Disallow deposits if kill switch is active.\n', '      if (kill_switch) throw;\n', '      // Only allow deposits if the contract hasn&#39;t already purchased the tokens.\n', '      if (bought_tokens) throw;\n', '      // Update records of deposited ETH to include the received amount.\n', '      balances[msg.sender] += msg.value;\n', '    }\n', '  }\n', '  \n', '  // Default function.  Called when a user sends ETH to the contract.\n', '  function () payable {\n', '    // Delegate to the helper function.\n', '    default_helper();\n', '  }\n', '}']
['pragma solidity ^0.4.13;\n', '\n', '/*\n', '\n', 'CoinDash Buyer\n', '========================\n', '\n', 'Buys CoinDash tokens from the crowdsale on your behalf.\n', 'Author: /u/Cintix\n', '\n', '*/\n', '\n', '// ERC20 Interface: https://github.com/ethereum/EIPs/issues/20\n', 'contract ERC20 {\n', '  function transfer(address _to, uint256 _value) returns (bool success);\n', '  function balanceOf(address _owner) constant returns (uint256 balance);\n', '}\n', '\n', 'contract CoinDashBuyer {\n', '  // Store the amount of ETH deposited by each account.\n', '  mapping (address => uint256) public balances;\n', '  // Bounty for executing buy.\n', '  uint256 public bounty;\n', '  // Track whether the contract has bought the tokens yet.\n', '  bool public bought_tokens;\n', '  // Record the time the contract bought the tokens.\n', '  uint256 public time_bought;\n', '  // Emergency kill switch in case a critical bug is found.\n', '  bool public kill_switch;\n', '  \n', '  // Token Wei received per ETH Wei contributed in this sale\n', '  uint256 tokens_per_eth = 6093;\n', '  // SHA3 hash of kill switch password.\n', '  bytes32 password_hash = 0x1b266c9bad3a46ed40bf43471d89b83712ed06c2250887c457f5f21f17b2eb97;\n', '  // Earliest time contract is allowed to buy into the crowdsale.\n', '  uint256 earliest_buy_time = 1500294600;\n', '  // The developer address.\n', '  address developer = 0x000Fb8369677b3065dE5821a86Bc9551d5e5EAb9;\n', '  // The crowdsale address.  Settable by the developer.\n', '  address public sale;\n', '  // The token address.  Settable by the developer.\n', '  ERC20 public token;\n', '  \n', '  // Allows the developer to set the crowdsale and token addresses.\n', '  function set_addresses(address _sale, address _token) {\n', '    // Only allow the developer to set the sale and token addresses.\n', '    if (msg.sender != developer) throw;\n', '    // Only allow setting the addresses once.\n', '    if (sale != 0x0) throw;\n', '    // Set the crowdsale and token addresses.\n', '    sale = _sale;\n', '    token = ERC20(_token);\n', '  }\n', '  \n', '  // Allows the developer or anyone with the password to shut down everything except withdrawals in emergencies.\n', '  function activate_kill_switch(string password) {\n', '    // Only activate the kill switch if the sender is the developer or the password is correct.\n', '    if (msg.sender != developer && sha3(password) != password_hash) throw;\n', '    // Irreversibly activate the kill switch.\n', '    kill_switch = true;\n', '  }\n', '  \n', '  // Withdraws all ETH deposited or tokens purchased by the user.\n', '  // "internal" means this function is not externally callable.\n', '  function withdraw(address user, bool has_fee) internal {\n', "    // If called before the ICO, cancel user's participation in the sale.\n", '    if (!bought_tokens) {\n', "      // Store the user's balance prior to withdrawal in a temporary variable.\n", '      uint256 eth_to_withdraw = balances[user];\n', "      // Update the user's balance prior to sending ETH to prevent recursive call.\n", '      balances[user] = 0;\n', "      // Return the user's funds.  Throws on failure to prevent loss of funds.\n", '      user.transfer(eth_to_withdraw);\n', '    }\n', "    // Withdraw the user's tokens if the contract has already purchased them.\n", '    else {\n', "      // Store the user's token balance in a temporary variable.\n", '      uint256 tokens_to_withdraw = balances[user] * tokens_per_eth;\n', "      // Update the user's balance prior to sending to prevent recursive call.\n", '      balances[user] = 0;\n', '      // No fee if the user withdraws their own funds manually.\n', '      uint256 fee = 0;\n', '      // 1% fee for automatic withdrawals.\n', '      if (has_fee) {\n', '        fee = tokens_to_withdraw / 100;\n', '        // Send the fee to the developer.\n', '        if(!token.transfer(developer, fee)) throw;\n', '      }\n', '      // Send the funds.  Throws on failure to prevent loss of funds.\n', '      if(!token.transfer(user, tokens_to_withdraw - fee)) throw;\n', '    }\n', '  }\n', '  \n', "  // Automatically withdraws on users' behalves (less a 1% fee on tokens).\n", '  function auto_withdraw(address user){\n', '    // Only allow automatic withdrawals after users have had a chance to manually withdraw.\n', '    if (!bought_tokens || now < time_bought + 1 hours) throw;\n', "    // Withdraw the user's funds for them.\n", '    withdraw(user, true);\n', '  }\n', '  \n', '  // Allows developer to add ETH to the buy execution bounty.\n', '  function add_to_bounty() payable {\n', '    // Only allow the developer to contribute to the buy execution bounty.\n', '    if (msg.sender != developer) throw;\n', '    // Disallow adding to bounty if kill switch is active.\n', '    if (kill_switch) throw;\n', '    // Disallow adding to the bounty if contract has already bought the tokens.\n', '    if (bought_tokens) throw;\n', '    // Update bounty to include received amount.\n', '    bounty += msg.value;\n', '  }\n', '  \n', '  // Buys tokens in the crowdsale and rewards the caller, callable by anyone.\n', '  function claim_bounty(){\n', '    // Short circuit to save gas if the contract has already bought tokens.\n', '    if (bought_tokens) return;\n', '    // Short circuit to save gas if kill switch is active.\n', '    if (kill_switch) return;\n', "    // Short circuit to save gas if the earliest buy time hasn't been reached.\n", '    if (now < earliest_buy_time) return;\n', "    // Disallow buying in if the developer hasn't set the sale address yet.\n", '    if (sale == 0x0) throw;\n', '    // Record that the contract has bought the tokens.\n', '    bought_tokens = true;\n', '    // Record the time the contract bought the tokens.\n', '    time_bought = now;\n', '    // Transfer all the funds (less the bounty) to the crowdsale address\n', "    // to buy tokens.  Throws if the crowdsale hasn't started yet or has\n", '    // already completed, preventing loss of funds.\n', '    if(!sale.call.value(this.balance - bounty)()) throw;\n', '    // Send the caller their bounty for buying tokens for the contract.\n', '    msg.sender.transfer(bounty);\n', '  }\n', '  \n', '  // A helper function for the default function, allowing contracts to interact.\n', '  function default_helper() payable {\n', '    // Treat near-zero ETH transactions as withdrawal requests.\n', '    if (msg.value <= 1 finney) {\n', '      // No fee on manual withdrawals.\n', '      withdraw(msg.sender, false);\n', '    }\n', "    // Deposit the user's funds for use in purchasing tokens.\n", '    else {\n', '      // Disallow deposits if kill switch is active.\n', '      if (kill_switch) throw;\n', "      // Only allow deposits if the contract hasn't already purchased the tokens.\n", '      if (bought_tokens) throw;\n', '      // Update records of deposited ETH to include the received amount.\n', '      balances[msg.sender] += msg.value;\n', '    }\n', '  }\n', '  \n', '  // Default function.  Called when a user sends ETH to the contract.\n', '  function () payable {\n', '    // Delegate to the helper function.\n', '    default_helper();\n', '  }\n', '}']
