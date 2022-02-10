['// Author : shift\n', '\n', 'pragma solidity ^0.4.18;\n', '\n', '//--------- OpenZeppelin&#39;s Safe Math\n', '//Source : https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '//-----------------------------------------------------\n', '\n', '// ERC20 Interface: https://github.com/ethereum/EIPs/issues/20\n', 'contract ERC20 {\n', '  function transfer(address _to, uint256 _value) public returns (bool success);\n', '  function balanceOf(address _owner) public constant returns (uint256 balance);\n', '}\n', '\n', '/*\n', '  This contract stores twice every key value in order to be able to redistribute funds\n', '  when the bonus tokens are received (which is typically X months after the initial buy).\n', '*/\n', '\n', 'contract Moongang {\n', '  using SafeMath for uint256;\n', '  modifier onlyOwner {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  modifier minAmountReached {\n', '    //In reality, the correct amount is the amount + 1%\n', '    require(this.balance >= SafeMath.div(SafeMath.mul(min_amount, 100), 99));\n', '    _;\n', '  }\n', '\n', '  modifier underMaxAmount {\n', '    require(max_amount == 0 || this.balance <= max_amount);\n', '    _;\n', '  }\n', '\n', '  //Constants of the contract\n', '  uint256 constant FEE = 40;    //2.5% fee\n', '  //SafeMath.div(20, 3) = 6\n', '  uint256 constant FEE_DEV = 6; //15% on the 1% fee\n', '  uint256 constant FEE_AUDIT = 12; //7.5% on the 1% fee\n', '  address public owner;\n', '  address constant public developer = 0xEE06BdDafFA56a303718DE53A5bc347EfbE4C68f;\n', '  address constant public auditor = 0x63F7547Ac277ea0B52A0B060Be6af8C5904953aa;\n', '  uint256 public individual_cap;\n', '\n', '  //Variables subject to changes\n', '  uint256 public max_amount;  //0 means there is no limit\n', '  uint256 public min_amount;\n', '\n', '  //Store the amount of ETH deposited by each account.\n', '  mapping (address => uint256) public balances;\n', '  mapping (address => uint256) public balances_bonus;\n', '  // Track whether the contract has bought the tokens yet.\n', '  bool public bought_tokens;\n', '  // Record ETH value of tokens currently held by contract.\n', '  uint256 public contract_eth_value;\n', '  uint256 public contract_eth_value_bonus;\n', '  //Set by the owner in order to allow the withdrawal of bonus tokens.\n', '  bool public bonus_received;\n', '  //The address of the contact.\n', '  address public sale;\n', '  //Token address\n', '  ERC20 public token;\n', '  //Records the fees that have to be sent\n', '  uint256 fees;\n', '  //Set by the owner. Allows people to refund totally or partially.\n', '  bool public allow_refunds;\n', '  //The reduction of the allocation in % | example : 40 -> 40% reduction\n', '  uint256 public percent_reduction;\n', '  bool public owner_supplied_eth;\n', '  bool public allow_contributions;\n', '\n', '  //Internal functions\n', '  function Moongang(uint256 max, uint256 min, uint256 cap) {\n', '    /*\n', '    Constructor\n', '    */\n', '    owner = msg.sender;\n', '    max_amount = SafeMath.div(SafeMath.mul(max, 100), 99);\n', '    min_amount = min;\n', '    individual_cap = cap;\n', '    allow_contributions = true;\n', '  }\n', '\n', '  //Functions for the owner\n', '\n', '  // Buy the tokens. Sends ETH to the presale wallet and records the ETH amount held in the contract.\n', '  function buy_the_tokens() onlyOwner minAmountReached underMaxAmount {\n', '    //Avoids burning the funds\n', '    require(!bought_tokens && sale != 0x0);\n', '    //Record that the contract has bought the tokens.\n', '    bought_tokens = true;\n', '    //Sends the fee before so the contract_eth_value contains the correct balance\n', '    uint256 dev_fee = SafeMath.div(fees, FEE_DEV);\n', '    uint256 audit_fee = SafeMath.div(fees, FEE_AUDIT);\n', '    owner.transfer(SafeMath.sub(SafeMath.sub(fees, dev_fee), audit_fee));\n', '    developer.transfer(dev_fee);\n', '    auditor.transfer(audit_fee);\n', '    //Record the amount of ETH sent as the contract&#39;s current value.\n', '    contract_eth_value = this.balance;\n', '    contract_eth_value_bonus = this.balance;\n', '    // Transfer all the funds to the crowdsale address.\n', '    sale.transfer(contract_eth_value);\n', '  }\n', '\n', '  function force_refund(address _to_refund) onlyOwner {\n', '    require(!bought_tokens);\n', '    uint256 eth_to_withdraw = SafeMath.div(SafeMath.mul(balances[_to_refund], 100), 99);\n', '    balances[_to_refund] = 0;\n', '    balances_bonus[_to_refund] = 0;\n', '    fees = SafeMath.sub(fees, SafeMath.div(eth_to_withdraw, FEE));\n', '    _to_refund.transfer(eth_to_withdraw);\n', '  }\n', '\n', '  function force_partial_refund(address _to_refund) onlyOwner {\n', '    require(bought_tokens && percent_reduction > 0);\n', '    //Amount to refund is the amount minus the X% of the reduction\n', '    //amount_to_refund = balance*X\n', '    uint256 amount = SafeMath.div(SafeMath.mul(balances[_to_refund], percent_reduction), 100);\n', '    balances[_to_refund] = SafeMath.sub(balances[_to_refund], amount);\n', '    balances_bonus[_to_refund] = balances[_to_refund];\n', '    if (owner_supplied_eth) {\n', '      //dev fees aren&#39;t refunded, only owner fees\n', '      uint256 fee = amount.div(FEE).mul(percent_reduction).div(100);\n', '      amount = amount.add(fee);\n', '    }\n', '    _to_refund.transfer(amount);\n', '  }\n', '\n', '  function set_sale_address(address _sale) onlyOwner {\n', '    //Avoid mistake of putting 0x0 and can&#39;t change twice the sale address\n', '    require(_sale != 0x0);\n', '    sale = _sale;\n', '  }\n', '\n', '  function set_token_address(address _token) onlyOwner {\n', '    require(_token != 0x0);\n', '    token = ERC20(_token);\n', '  }\n', '\n', '  function set_bonus_received(bool _boolean) onlyOwner {\n', '    bonus_received = _boolean;\n', '  }\n', '\n', '  function set_allow_refunds(bool _boolean) onlyOwner {\n', '    /*\n', '    In case, for some reasons, the project refunds the money\n', '    */\n', '    allow_refunds = _boolean;\n', '  }\n', '\n', '  function set_allow_contributions(bool _boolean) onlyOwner {\n', '      allow_contributions = _boolean;\n', '  }\n', '\n', '  function set_percent_reduction(uint256 _reduction) onlyOwner payable {\n', '    require(bought_tokens && _reduction <= 100);\n', '    percent_reduction = _reduction;\n', '    if (msg.value > 0) {\n', '      owner_supplied_eth = true;\n', '    }\n', '    //we substract by contract_eth_value*_reduction basically\n', '    contract_eth_value = contract_eth_value.sub((contract_eth_value.mul(_reduction)).div(100));\n', '    contract_eth_value_bonus = contract_eth_value;\n', '  }\n', '\n', '  function change_individual_cap(uint256 _cap) onlyOwner {\n', '    individual_cap = _cap;\n', '  }\n', '\n', '  function change_owner(address new_owner) onlyOwner {\n', '    require(new_owner != 0x0);\n', '    owner = new_owner;\n', '  }\n', '\n', '  function change_max_amount(uint256 _amount) onlyOwner {\n', '      //ATTENTION! The new amount should be in wei\n', '      //Use https://etherconverter.online/\n', '      max_amount = SafeMath.div(SafeMath.mul(_amount, 100), 99);\n', '  }\n', '\n', '  function change_min_amount(uint256 _amount) onlyOwner {\n', '      //ATTENTION! The new amount should be in wei\n', '      //Use https://etherconverter.online/\n', '      min_amount = _amount;\n', '  }\n', '\n', '  //Public functions\n', '\n', '  // Allows any user to withdraw his tokens.\n', '  function withdraw() {\n', '    // Disallow withdraw if tokens haven&#39;t been bought yet.\n', '    require(bought_tokens);\n', '    uint256 contract_token_balance = token.balanceOf(address(this));\n', '    // Disallow token withdrawals if there are no tokens to withdraw.\n', '    require(contract_token_balance != 0);\n', '    uint256 tokens_to_withdraw = SafeMath.div(SafeMath.mul(balances[msg.sender], contract_token_balance), contract_eth_value);\n', '    // Update the value of tokens currently held by the contract.\n', '    contract_eth_value = SafeMath.sub(contract_eth_value, balances[msg.sender]);\n', '    // Update the user&#39;s balance prior to sending to prevent recursive call.\n', '    balances[msg.sender] = 0;\n', '    // Send the funds.  Throws on failure to prevent loss of funds.\n', '    require(token.transfer(msg.sender, tokens_to_withdraw));\n', '  }\n', '\n', '  function withdraw_bonus() {\n', '  /*\n', '    Special function to withdraw the bonus tokens after the 6 months lockup.\n', '    bonus_received has to be set to true.\n', '  */\n', '    require(bought_tokens && bonus_received);\n', '    uint256 contract_token_balance = token.balanceOf(address(this));\n', '    require(contract_token_balance != 0);\n', '    uint256 tokens_to_withdraw = SafeMath.div(SafeMath.mul(balances_bonus[msg.sender], contract_token_balance), contract_eth_value_bonus);\n', '    contract_eth_value_bonus = SafeMath.sub(contract_eth_value_bonus, balances_bonus[msg.sender]);\n', '    balances_bonus[msg.sender] = 0;\n', '    require(token.transfer(msg.sender, tokens_to_withdraw));\n', '  }\n', '\n', '  // Allows any user to get his eth refunded before the purchase is made.\n', '  function refund() {\n', '    require(!bought_tokens && allow_refunds && percent_reduction == 0);\n', '    //balance of contributor = contribution * 0.99\n', '    //so contribution = balance/0.99\n', '    uint256 eth_to_withdraw = SafeMath.div(SafeMath.mul(balances[msg.sender], 100), 99);\n', '    // Update the user&#39;s balance prior to sending ETH to prevent recursive call.\n', '    balances[msg.sender] = 0;\n', '    //Updates the balances_bonus too\n', '    balances_bonus[msg.sender] = 0;\n', '    //Updates the fees variable by substracting the refunded fee\n', '    fees = SafeMath.sub(fees, SafeMath.div(eth_to_withdraw, FEE));\n', '    // Return the user&#39;s funds.  Throws on failure to prevent loss of funds.\n', '    msg.sender.transfer(eth_to_withdraw);\n', '  }\n', '\n', '  //Allows any user to get a part of his ETH refunded, in proportion\n', '  //to the % reduced of the allocation\n', '  function partial_refund() {\n', '    require(bought_tokens && percent_reduction > 0);\n', '    //Amount to refund is the amount minus the X% of the reduction\n', '    //amount_to_refund = balance*X\n', '    uint256 amount = SafeMath.div(SafeMath.mul(balances[msg.sender], percent_reduction), 100);\n', '    balances[msg.sender] = SafeMath.sub(balances[msg.sender], amount);\n', '    balances_bonus[msg.sender] = balances[msg.sender];\n', '    if (owner_supplied_eth) {\n', '      //dev fees aren&#39;t refunded, only owner fees\n', '      uint256 fee = amount.div(FEE).mul(percent_reduction).div(100);\n', '      amount = amount.add(fee);\n', '    }\n', '    msg.sender.transfer(amount);\n', '  }\n', '\n', '  // Default function.  Called when a user sends ETH to the contract.\n', '  function () payable underMaxAmount {\n', '    require(!bought_tokens && allow_contributions);\n', '    //1% fee is taken on the ETH\n', '    uint256 fee = SafeMath.div(msg.value, FEE);\n', '    fees = SafeMath.add(fees, fee);\n', '    //Updates both of the balances\n', '    balances[msg.sender] = SafeMath.add(balances[msg.sender], SafeMath.sub(msg.value, fee));\n', '    //Checks if the individual cap is respected\n', '    //If it&#39;s not, changes are reverted\n', '    require(individual_cap == 0 || balances[msg.sender] <= individual_cap);\n', '    balances_bonus[msg.sender] = balances[msg.sender];\n', '  }\n', '}']
['// Author : shift\n', '\n', 'pragma solidity ^0.4.18;\n', '\n', "//--------- OpenZeppelin's Safe Math\n", '//Source : https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '//-----------------------------------------------------\n', '\n', '// ERC20 Interface: https://github.com/ethereum/EIPs/issues/20\n', 'contract ERC20 {\n', '  function transfer(address _to, uint256 _value) public returns (bool success);\n', '  function balanceOf(address _owner) public constant returns (uint256 balance);\n', '}\n', '\n', '/*\n', '  This contract stores twice every key value in order to be able to redistribute funds\n', '  when the bonus tokens are received (which is typically X months after the initial buy).\n', '*/\n', '\n', 'contract Moongang {\n', '  using SafeMath for uint256;\n', '  modifier onlyOwner {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  modifier minAmountReached {\n', '    //In reality, the correct amount is the amount + 1%\n', '    require(this.balance >= SafeMath.div(SafeMath.mul(min_amount, 100), 99));\n', '    _;\n', '  }\n', '\n', '  modifier underMaxAmount {\n', '    require(max_amount == 0 || this.balance <= max_amount);\n', '    _;\n', '  }\n', '\n', '  //Constants of the contract\n', '  uint256 constant FEE = 40;    //2.5% fee\n', '  //SafeMath.div(20, 3) = 6\n', '  uint256 constant FEE_DEV = 6; //15% on the 1% fee\n', '  uint256 constant FEE_AUDIT = 12; //7.5% on the 1% fee\n', '  address public owner;\n', '  address constant public developer = 0xEE06BdDafFA56a303718DE53A5bc347EfbE4C68f;\n', '  address constant public auditor = 0x63F7547Ac277ea0B52A0B060Be6af8C5904953aa;\n', '  uint256 public individual_cap;\n', '\n', '  //Variables subject to changes\n', '  uint256 public max_amount;  //0 means there is no limit\n', '  uint256 public min_amount;\n', '\n', '  //Store the amount of ETH deposited by each account.\n', '  mapping (address => uint256) public balances;\n', '  mapping (address => uint256) public balances_bonus;\n', '  // Track whether the contract has bought the tokens yet.\n', '  bool public bought_tokens;\n', '  // Record ETH value of tokens currently held by contract.\n', '  uint256 public contract_eth_value;\n', '  uint256 public contract_eth_value_bonus;\n', '  //Set by the owner in order to allow the withdrawal of bonus tokens.\n', '  bool public bonus_received;\n', '  //The address of the contact.\n', '  address public sale;\n', '  //Token address\n', '  ERC20 public token;\n', '  //Records the fees that have to be sent\n', '  uint256 fees;\n', '  //Set by the owner. Allows people to refund totally or partially.\n', '  bool public allow_refunds;\n', '  //The reduction of the allocation in % | example : 40 -> 40% reduction\n', '  uint256 public percent_reduction;\n', '  bool public owner_supplied_eth;\n', '  bool public allow_contributions;\n', '\n', '  //Internal functions\n', '  function Moongang(uint256 max, uint256 min, uint256 cap) {\n', '    /*\n', '    Constructor\n', '    */\n', '    owner = msg.sender;\n', '    max_amount = SafeMath.div(SafeMath.mul(max, 100), 99);\n', '    min_amount = min;\n', '    individual_cap = cap;\n', '    allow_contributions = true;\n', '  }\n', '\n', '  //Functions for the owner\n', '\n', '  // Buy the tokens. Sends ETH to the presale wallet and records the ETH amount held in the contract.\n', '  function buy_the_tokens() onlyOwner minAmountReached underMaxAmount {\n', '    //Avoids burning the funds\n', '    require(!bought_tokens && sale != 0x0);\n', '    //Record that the contract has bought the tokens.\n', '    bought_tokens = true;\n', '    //Sends the fee before so the contract_eth_value contains the correct balance\n', '    uint256 dev_fee = SafeMath.div(fees, FEE_DEV);\n', '    uint256 audit_fee = SafeMath.div(fees, FEE_AUDIT);\n', '    owner.transfer(SafeMath.sub(SafeMath.sub(fees, dev_fee), audit_fee));\n', '    developer.transfer(dev_fee);\n', '    auditor.transfer(audit_fee);\n', "    //Record the amount of ETH sent as the contract's current value.\n", '    contract_eth_value = this.balance;\n', '    contract_eth_value_bonus = this.balance;\n', '    // Transfer all the funds to the crowdsale address.\n', '    sale.transfer(contract_eth_value);\n', '  }\n', '\n', '  function force_refund(address _to_refund) onlyOwner {\n', '    require(!bought_tokens);\n', '    uint256 eth_to_withdraw = SafeMath.div(SafeMath.mul(balances[_to_refund], 100), 99);\n', '    balances[_to_refund] = 0;\n', '    balances_bonus[_to_refund] = 0;\n', '    fees = SafeMath.sub(fees, SafeMath.div(eth_to_withdraw, FEE));\n', '    _to_refund.transfer(eth_to_withdraw);\n', '  }\n', '\n', '  function force_partial_refund(address _to_refund) onlyOwner {\n', '    require(bought_tokens && percent_reduction > 0);\n', '    //Amount to refund is the amount minus the X% of the reduction\n', '    //amount_to_refund = balance*X\n', '    uint256 amount = SafeMath.div(SafeMath.mul(balances[_to_refund], percent_reduction), 100);\n', '    balances[_to_refund] = SafeMath.sub(balances[_to_refund], amount);\n', '    balances_bonus[_to_refund] = balances[_to_refund];\n', '    if (owner_supplied_eth) {\n', "      //dev fees aren't refunded, only owner fees\n", '      uint256 fee = amount.div(FEE).mul(percent_reduction).div(100);\n', '      amount = amount.add(fee);\n', '    }\n', '    _to_refund.transfer(amount);\n', '  }\n', '\n', '  function set_sale_address(address _sale) onlyOwner {\n', "    //Avoid mistake of putting 0x0 and can't change twice the sale address\n", '    require(_sale != 0x0);\n', '    sale = _sale;\n', '  }\n', '\n', '  function set_token_address(address _token) onlyOwner {\n', '    require(_token != 0x0);\n', '    token = ERC20(_token);\n', '  }\n', '\n', '  function set_bonus_received(bool _boolean) onlyOwner {\n', '    bonus_received = _boolean;\n', '  }\n', '\n', '  function set_allow_refunds(bool _boolean) onlyOwner {\n', '    /*\n', '    In case, for some reasons, the project refunds the money\n', '    */\n', '    allow_refunds = _boolean;\n', '  }\n', '\n', '  function set_allow_contributions(bool _boolean) onlyOwner {\n', '      allow_contributions = _boolean;\n', '  }\n', '\n', '  function set_percent_reduction(uint256 _reduction) onlyOwner payable {\n', '    require(bought_tokens && _reduction <= 100);\n', '    percent_reduction = _reduction;\n', '    if (msg.value > 0) {\n', '      owner_supplied_eth = true;\n', '    }\n', '    //we substract by contract_eth_value*_reduction basically\n', '    contract_eth_value = contract_eth_value.sub((contract_eth_value.mul(_reduction)).div(100));\n', '    contract_eth_value_bonus = contract_eth_value;\n', '  }\n', '\n', '  function change_individual_cap(uint256 _cap) onlyOwner {\n', '    individual_cap = _cap;\n', '  }\n', '\n', '  function change_owner(address new_owner) onlyOwner {\n', '    require(new_owner != 0x0);\n', '    owner = new_owner;\n', '  }\n', '\n', '  function change_max_amount(uint256 _amount) onlyOwner {\n', '      //ATTENTION! The new amount should be in wei\n', '      //Use https://etherconverter.online/\n', '      max_amount = SafeMath.div(SafeMath.mul(_amount, 100), 99);\n', '  }\n', '\n', '  function change_min_amount(uint256 _amount) onlyOwner {\n', '      //ATTENTION! The new amount should be in wei\n', '      //Use https://etherconverter.online/\n', '      min_amount = _amount;\n', '  }\n', '\n', '  //Public functions\n', '\n', '  // Allows any user to withdraw his tokens.\n', '  function withdraw() {\n', "    // Disallow withdraw if tokens haven't been bought yet.\n", '    require(bought_tokens);\n', '    uint256 contract_token_balance = token.balanceOf(address(this));\n', '    // Disallow token withdrawals if there are no tokens to withdraw.\n', '    require(contract_token_balance != 0);\n', '    uint256 tokens_to_withdraw = SafeMath.div(SafeMath.mul(balances[msg.sender], contract_token_balance), contract_eth_value);\n', '    // Update the value of tokens currently held by the contract.\n', '    contract_eth_value = SafeMath.sub(contract_eth_value, balances[msg.sender]);\n', "    // Update the user's balance prior to sending to prevent recursive call.\n", '    balances[msg.sender] = 0;\n', '    // Send the funds.  Throws on failure to prevent loss of funds.\n', '    require(token.transfer(msg.sender, tokens_to_withdraw));\n', '  }\n', '\n', '  function withdraw_bonus() {\n', '  /*\n', '    Special function to withdraw the bonus tokens after the 6 months lockup.\n', '    bonus_received has to be set to true.\n', '  */\n', '    require(bought_tokens && bonus_received);\n', '    uint256 contract_token_balance = token.balanceOf(address(this));\n', '    require(contract_token_balance != 0);\n', '    uint256 tokens_to_withdraw = SafeMath.div(SafeMath.mul(balances_bonus[msg.sender], contract_token_balance), contract_eth_value_bonus);\n', '    contract_eth_value_bonus = SafeMath.sub(contract_eth_value_bonus, balances_bonus[msg.sender]);\n', '    balances_bonus[msg.sender] = 0;\n', '    require(token.transfer(msg.sender, tokens_to_withdraw));\n', '  }\n', '\n', '  // Allows any user to get his eth refunded before the purchase is made.\n', '  function refund() {\n', '    require(!bought_tokens && allow_refunds && percent_reduction == 0);\n', '    //balance of contributor = contribution * 0.99\n', '    //so contribution = balance/0.99\n', '    uint256 eth_to_withdraw = SafeMath.div(SafeMath.mul(balances[msg.sender], 100), 99);\n', "    // Update the user's balance prior to sending ETH to prevent recursive call.\n", '    balances[msg.sender] = 0;\n', '    //Updates the balances_bonus too\n', '    balances_bonus[msg.sender] = 0;\n', '    //Updates the fees variable by substracting the refunded fee\n', '    fees = SafeMath.sub(fees, SafeMath.div(eth_to_withdraw, FEE));\n', "    // Return the user's funds.  Throws on failure to prevent loss of funds.\n", '    msg.sender.transfer(eth_to_withdraw);\n', '  }\n', '\n', '  //Allows any user to get a part of his ETH refunded, in proportion\n', '  //to the % reduced of the allocation\n', '  function partial_refund() {\n', '    require(bought_tokens && percent_reduction > 0);\n', '    //Amount to refund is the amount minus the X% of the reduction\n', '    //amount_to_refund = balance*X\n', '    uint256 amount = SafeMath.div(SafeMath.mul(balances[msg.sender], percent_reduction), 100);\n', '    balances[msg.sender] = SafeMath.sub(balances[msg.sender], amount);\n', '    balances_bonus[msg.sender] = balances[msg.sender];\n', '    if (owner_supplied_eth) {\n', "      //dev fees aren't refunded, only owner fees\n", '      uint256 fee = amount.div(FEE).mul(percent_reduction).div(100);\n', '      amount = amount.add(fee);\n', '    }\n', '    msg.sender.transfer(amount);\n', '  }\n', '\n', '  // Default function.  Called when a user sends ETH to the contract.\n', '  function () payable underMaxAmount {\n', '    require(!bought_tokens && allow_contributions);\n', '    //1% fee is taken on the ETH\n', '    uint256 fee = SafeMath.div(msg.value, FEE);\n', '    fees = SafeMath.add(fees, fee);\n', '    //Updates both of the balances\n', '    balances[msg.sender] = SafeMath.add(balances[msg.sender], SafeMath.sub(msg.value, fee));\n', '    //Checks if the individual cap is respected\n', "    //If it's not, changes are reverted\n", '    require(individual_cap == 0 || balances[msg.sender] <= individual_cap);\n', '    balances_bonus[msg.sender] = balances[msg.sender];\n', '  }\n', '}']
