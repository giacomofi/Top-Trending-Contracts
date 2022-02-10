['pragma solidity ^0.4.13;\n', '\n', '// Enjin ICO group buyer\n', '// Avtor: Janez\n', '\n', '// ERC20 Interface: https://github.com/ethereum/EIPs/issues/20\n', 'contract ERC20 {\n', '  function transfer(address _to, uint256 _value) returns (bool success);\n', '  function balanceOf(address _owner) constant returns (uint256 balance);\n', '}\n', '\n', 'contract EnjinBuyer {\n', '  mapping (address => uint256) public balances;\n', '  mapping (address => uint256) public balances_for_refund;\n', '  bool public bought_tokens;\n', '  bool public token_set;\n', '  uint256 public contract_eth_value;\n', '  uint256 public refund_contract_eth_value;\n', '  uint256 public refund_eth_value;\n', '  bool public kill_switch;\n', '  bytes32 password_hash = 0x8bf0720c6e610aace867eba51b03ab8ca908b665898b10faddc95a96e829539d;\n', '  address public developer = 0x0639C169D9265Ca4B4DEce693764CdA8ea5F3882;\n', '  address public sale = 0xc4740f71323129669424d1Ae06c42AEE99da30e2;\n', '  ERC20 public token;\n', '  uint256 public eth_minimum = 3235 ether;\n', '\n', '  function set_token(address _token) {\n', '    require(msg.sender == developer);\n', '    token = ERC20(_token);\n', '    token_set = true;\n', '  }\n', '  \n', '  function activate_kill_switch(string password) {\n', '    require(msg.sender == developer || sha3(password) == password_hash);\n', '    kill_switch = true;\n', '  }\n', '  \n', '  function personal_withdraw(){\n', '    if (balances[msg.sender] == 0) return;\n', '    if (!bought_tokens) {\n', '      uint256 eth_to_withdraw = balances[msg.sender];\n', '      balances[msg.sender] = 0;\n', '      msg.sender.transfer(eth_to_withdraw);\n', '    }\n', '    else {\n', '      require(token_set);\n', '      uint256 contract_token_balance = token.balanceOf(address(this));\n', '      require(contract_token_balance != 0);\n', '      uint256 tokens_to_withdraw = (balances[msg.sender] * contract_token_balance) / contract_eth_value;\n', '      contract_eth_value -= balances[msg.sender];\n', '      balances[msg.sender] = 0;\n', '      uint256 fee = tokens_to_withdraw / 100;\n', '      require(token.transfer(developer, fee));\n', '      require(token.transfer(msg.sender, tokens_to_withdraw - fee));\n', '    }\n', '  }\n', '\n', '\n', '  // Use with caution - use this withdraw function if you do not trust the\n', '  // contract&#39;s token setting. You can only use this once, so if you\n', '  // put in the wrong token address you will burn the Enjin on the contract.\n', '  function withdraw_token(address _token){\n', '    ERC20 myToken = ERC20(_token);\n', '    if (balances[msg.sender] == 0) return;\n', '    require(msg.sender != sale);\n', '    if (!bought_tokens) {\n', '      uint256 eth_to_withdraw = balances[msg.sender];\n', '      balances[msg.sender] = 0;\n', '      msg.sender.transfer(eth_to_withdraw);\n', '    }\n', '    else {\n', '      uint256 contract_token_balance = myToken.balanceOf(address(this));\n', '      require(contract_token_balance != 0);\n', '      uint256 tokens_to_withdraw = (balances[msg.sender] * contract_token_balance) / contract_eth_value;\n', '      contract_eth_value -= balances[msg.sender];\n', '      balances[msg.sender] = 0;\n', '      uint256 fee = tokens_to_withdraw / 100;\n', '      require(myToken.transfer(developer, fee));\n', '      require(myToken.transfer(msg.sender, tokens_to_withdraw - fee));\n', '    }\n', '  }\n', '\n', '  // This handles the withdrawal of refunds. Also works with partial refunds.\n', '  function withdraw_refund(){\n', '    require(refund_eth_value!=0);\n', '    require(balances_for_refund[msg.sender] != 0);\n', '    uint256 eth_to_withdraw = (balances_for_refund[msg.sender] * refund_eth_value) / refund_contract_eth_value;\n', '    refund_contract_eth_value -= balances_for_refund[msg.sender];\n', '    refund_eth_value -= eth_to_withdraw;\n', '    balances_for_refund[msg.sender] = 0;\n', '    msg.sender.transfer(eth_to_withdraw);\n', '  }\n', '\n', '  function () payable {\n', '    if (!bought_tokens) {\n', '      balances[msg.sender] += msg.value;\n', '      balances_for_refund[msg.sender] += msg.value;\n', '      if (this.balance < eth_minimum) return;\n', '      if (kill_switch) return;\n', '      require(sale != 0x0);\n', '      bought_tokens = true;\n', '      contract_eth_value = this.balance;\n', '      refund_contract_eth_value = this.balance;\n', '      require(sale.call.value(contract_eth_value)());\n', '      require(this.balance==0);\n', '    } else {\n', '      // We might be getting a full refund or partial refund if we go over the limit from Enjin&#39;s multisig wallet.\n', '      // We have been assured by the CTO that the refund would only\n', '      // come from the pre-sale wallet.\n', '      require(msg.sender == sale);\n', '      refund_eth_value += msg.value;\n', '    }\n', '  }\n', '}']
['pragma solidity ^0.4.13;\n', '\n', '// Enjin ICO group buyer\n', '// Avtor: Janez\n', '\n', '// ERC20 Interface: https://github.com/ethereum/EIPs/issues/20\n', 'contract ERC20 {\n', '  function transfer(address _to, uint256 _value) returns (bool success);\n', '  function balanceOf(address _owner) constant returns (uint256 balance);\n', '}\n', '\n', 'contract EnjinBuyer {\n', '  mapping (address => uint256) public balances;\n', '  mapping (address => uint256) public balances_for_refund;\n', '  bool public bought_tokens;\n', '  bool public token_set;\n', '  uint256 public contract_eth_value;\n', '  uint256 public refund_contract_eth_value;\n', '  uint256 public refund_eth_value;\n', '  bool public kill_switch;\n', '  bytes32 password_hash = 0x8bf0720c6e610aace867eba51b03ab8ca908b665898b10faddc95a96e829539d;\n', '  address public developer = 0x0639C169D9265Ca4B4DEce693764CdA8ea5F3882;\n', '  address public sale = 0xc4740f71323129669424d1Ae06c42AEE99da30e2;\n', '  ERC20 public token;\n', '  uint256 public eth_minimum = 3235 ether;\n', '\n', '  function set_token(address _token) {\n', '    require(msg.sender == developer);\n', '    token = ERC20(_token);\n', '    token_set = true;\n', '  }\n', '  \n', '  function activate_kill_switch(string password) {\n', '    require(msg.sender == developer || sha3(password) == password_hash);\n', '    kill_switch = true;\n', '  }\n', '  \n', '  function personal_withdraw(){\n', '    if (balances[msg.sender] == 0) return;\n', '    if (!bought_tokens) {\n', '      uint256 eth_to_withdraw = balances[msg.sender];\n', '      balances[msg.sender] = 0;\n', '      msg.sender.transfer(eth_to_withdraw);\n', '    }\n', '    else {\n', '      require(token_set);\n', '      uint256 contract_token_balance = token.balanceOf(address(this));\n', '      require(contract_token_balance != 0);\n', '      uint256 tokens_to_withdraw = (balances[msg.sender] * contract_token_balance) / contract_eth_value;\n', '      contract_eth_value -= balances[msg.sender];\n', '      balances[msg.sender] = 0;\n', '      uint256 fee = tokens_to_withdraw / 100;\n', '      require(token.transfer(developer, fee));\n', '      require(token.transfer(msg.sender, tokens_to_withdraw - fee));\n', '    }\n', '  }\n', '\n', '\n', '  // Use with caution - use this withdraw function if you do not trust the\n', "  // contract's token setting. You can only use this once, so if you\n", '  // put in the wrong token address you will burn the Enjin on the contract.\n', '  function withdraw_token(address _token){\n', '    ERC20 myToken = ERC20(_token);\n', '    if (balances[msg.sender] == 0) return;\n', '    require(msg.sender != sale);\n', '    if (!bought_tokens) {\n', '      uint256 eth_to_withdraw = balances[msg.sender];\n', '      balances[msg.sender] = 0;\n', '      msg.sender.transfer(eth_to_withdraw);\n', '    }\n', '    else {\n', '      uint256 contract_token_balance = myToken.balanceOf(address(this));\n', '      require(contract_token_balance != 0);\n', '      uint256 tokens_to_withdraw = (balances[msg.sender] * contract_token_balance) / contract_eth_value;\n', '      contract_eth_value -= balances[msg.sender];\n', '      balances[msg.sender] = 0;\n', '      uint256 fee = tokens_to_withdraw / 100;\n', '      require(myToken.transfer(developer, fee));\n', '      require(myToken.transfer(msg.sender, tokens_to_withdraw - fee));\n', '    }\n', '  }\n', '\n', '  // This handles the withdrawal of refunds. Also works with partial refunds.\n', '  function withdraw_refund(){\n', '    require(refund_eth_value!=0);\n', '    require(balances_for_refund[msg.sender] != 0);\n', '    uint256 eth_to_withdraw = (balances_for_refund[msg.sender] * refund_eth_value) / refund_contract_eth_value;\n', '    refund_contract_eth_value -= balances_for_refund[msg.sender];\n', '    refund_eth_value -= eth_to_withdraw;\n', '    balances_for_refund[msg.sender] = 0;\n', '    msg.sender.transfer(eth_to_withdraw);\n', '  }\n', '\n', '  function () payable {\n', '    if (!bought_tokens) {\n', '      balances[msg.sender] += msg.value;\n', '      balances_for_refund[msg.sender] += msg.value;\n', '      if (this.balance < eth_minimum) return;\n', '      if (kill_switch) return;\n', '      require(sale != 0x0);\n', '      bought_tokens = true;\n', '      contract_eth_value = this.balance;\n', '      refund_contract_eth_value = this.balance;\n', '      require(sale.call.value(contract_eth_value)());\n', '      require(this.balance==0);\n', '    } else {\n', "      // We might be getting a full refund or partial refund if we go over the limit from Enjin's multisig wallet.\n", '      // We have been assured by the CTO that the refund would only\n', '      // come from the pre-sale wallet.\n', '      require(msg.sender == sale);\n', '      refund_eth_value += msg.value;\n', '    }\n', '  }\n', '}']
