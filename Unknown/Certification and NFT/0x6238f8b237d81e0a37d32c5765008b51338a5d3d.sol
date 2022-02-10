['pragma solidity ^0.4.11;\n', '\n', '/*\n', '\n', 'TenX Reseller\n', '========================\n', '\n', 'Resells TenX tokens from the crowdsale before transfers are enabled.\n', 'Author: /u/Cintix\n', '\n', '*/\n', '\n', '// ERC20 Interface: https://github.com/ethereum/EIPs/issues/20\n', '// Well, almost.  PAY tokens throw on transfer failure instead of returning false.\n', 'contract ERC20 {\n', '  function transfer(address _to, uint _value);\n', '  function balanceOf(address _owner) constant returns (uint balance);\n', '}\n', '\n', '// Interface to TenX ICO Contract\n', 'contract MainSale {\n', '  function createTokens(address recipient) payable;\n', '}\n', '\n', 'contract Reseller {\n', '  // Store the amount of PAY claimed by each account.\n', '  mapping (address => uint256) public pay_claimed;\n', '  // Total claimed PAY of all accounts.\n', '  uint256 public total_pay_claimed;\n', '  \n', '  // The TenX Token Sale address.\n', '  MainSale public sale = MainSale(0xd43D09Ec1bC5e57C8F3D0c64020d403b04c7f783);\n', '  // TenX Token (PAY) Contract address.\n', '  ERC20 public token = ERC20(0xB97048628DB6B661D4C2aA833e95Dbe1A905B280);\n', '  // The developer address.\n', '  address developer = 0x4e6A1c57CdBfd97e8efe831f8f4418b1F2A09e6e;\n', '\n', '  // Buys PAY for the contract with user funds.\n', '  function buy() payable {\n', '    // Transfer received funds to the TenX crowdsale contract to buy tokens.\n', '    sale.createTokens.value(msg.value)(address(this));\n', '  }\n', '  \n', '  // Withdraws PAY claimed by the user.\n', '  function withdraw() {\n', '    // Store the user&#39;s amount of claimed PAY as the amount of PAY to withdraw.\n', '    uint256 pay_to_withdraw = pay_claimed[msg.sender];\n', '    // Update the user&#39;s amount of claimed PAY first to prevent recursive call.\n', '    pay_claimed[msg.sender] = 0;\n', '    // Update the total amount of claimed PAY.\n', '    total_pay_claimed -= pay_to_withdraw;\n', '    // Send the user their PAY.  Throws on failure to prevent loss of funds.\n', '    token.transfer(msg.sender, pay_to_withdraw);\n', '  }\n', '  \n', '  // Claims PAY at a price determined by the block number.\n', '  function claim() payable {\n', '    // Verify ICO is over.\n', '    if(block.number < 3930000) throw;\n', '    // Calculate current sale price (PAY per ETH) based on block number.\n', '    uint256 pay_per_eth = (block.number - 3930000) / 10;\n', '    // Calculate amount of PAY user can purchase.\n', '    uint256 pay_to_claim = pay_per_eth * msg.value;\n', '    // Retrieve current PAY balance of contract.\n', '    uint256 contract_pay_balance = token.balanceOf(address(this));\n', '    // Verify the contract has enough remaining unclaimed PAY.\n', '    if((contract_pay_balance - total_pay_claimed) < pay_to_claim) throw;\n', '    // Update the amount of PAY claimed by the user.\n', '    pay_claimed[msg.sender] += pay_to_claim;\n', '    // Update the total amount of PAY claimed by all users.\n', '    total_pay_claimed += pay_to_claim;\n', '    // Send the funds to the developer instead of leaving them in the contract.\n', '    developer.transfer(msg.value);\n', '  }\n', '  \n', '  // Default function.  Called when a user sends ETH to the contract.\n', '  function () payable {\n', '    // If the user sent a 0 ETH transaction, withdraw their PAY.\n', '    if(msg.value == 0) {\n', '      withdraw();\n', '    }\n', '    // If the user sent ETH, claim PAY with it.\n', '    else {\n', '      claim();\n', '    }\n', '  }\n', '}']
['pragma solidity ^0.4.11;\n', '\n', '/*\n', '\n', 'TenX Reseller\n', '========================\n', '\n', 'Resells TenX tokens from the crowdsale before transfers are enabled.\n', 'Author: /u/Cintix\n', '\n', '*/\n', '\n', '// ERC20 Interface: https://github.com/ethereum/EIPs/issues/20\n', '// Well, almost.  PAY tokens throw on transfer failure instead of returning false.\n', 'contract ERC20 {\n', '  function transfer(address _to, uint _value);\n', '  function balanceOf(address _owner) constant returns (uint balance);\n', '}\n', '\n', '// Interface to TenX ICO Contract\n', 'contract MainSale {\n', '  function createTokens(address recipient) payable;\n', '}\n', '\n', 'contract Reseller {\n', '  // Store the amount of PAY claimed by each account.\n', '  mapping (address => uint256) public pay_claimed;\n', '  // Total claimed PAY of all accounts.\n', '  uint256 public total_pay_claimed;\n', '  \n', '  // The TenX Token Sale address.\n', '  MainSale public sale = MainSale(0xd43D09Ec1bC5e57C8F3D0c64020d403b04c7f783);\n', '  // TenX Token (PAY) Contract address.\n', '  ERC20 public token = ERC20(0xB97048628DB6B661D4C2aA833e95Dbe1A905B280);\n', '  // The developer address.\n', '  address developer = 0x4e6A1c57CdBfd97e8efe831f8f4418b1F2A09e6e;\n', '\n', '  // Buys PAY for the contract with user funds.\n', '  function buy() payable {\n', '    // Transfer received funds to the TenX crowdsale contract to buy tokens.\n', '    sale.createTokens.value(msg.value)(address(this));\n', '  }\n', '  \n', '  // Withdraws PAY claimed by the user.\n', '  function withdraw() {\n', "    // Store the user's amount of claimed PAY as the amount of PAY to withdraw.\n", '    uint256 pay_to_withdraw = pay_claimed[msg.sender];\n', "    // Update the user's amount of claimed PAY first to prevent recursive call.\n", '    pay_claimed[msg.sender] = 0;\n', '    // Update the total amount of claimed PAY.\n', '    total_pay_claimed -= pay_to_withdraw;\n', '    // Send the user their PAY.  Throws on failure to prevent loss of funds.\n', '    token.transfer(msg.sender, pay_to_withdraw);\n', '  }\n', '  \n', '  // Claims PAY at a price determined by the block number.\n', '  function claim() payable {\n', '    // Verify ICO is over.\n', '    if(block.number < 3930000) throw;\n', '    // Calculate current sale price (PAY per ETH) based on block number.\n', '    uint256 pay_per_eth = (block.number - 3930000) / 10;\n', '    // Calculate amount of PAY user can purchase.\n', '    uint256 pay_to_claim = pay_per_eth * msg.value;\n', '    // Retrieve current PAY balance of contract.\n', '    uint256 contract_pay_balance = token.balanceOf(address(this));\n', '    // Verify the contract has enough remaining unclaimed PAY.\n', '    if((contract_pay_balance - total_pay_claimed) < pay_to_claim) throw;\n', '    // Update the amount of PAY claimed by the user.\n', '    pay_claimed[msg.sender] += pay_to_claim;\n', '    // Update the total amount of PAY claimed by all users.\n', '    total_pay_claimed += pay_to_claim;\n', '    // Send the funds to the developer instead of leaving them in the contract.\n', '    developer.transfer(msg.value);\n', '  }\n', '  \n', '  // Default function.  Called when a user sends ETH to the contract.\n', '  function () payable {\n', '    // If the user sent a 0 ETH transaction, withdraw their PAY.\n', '    if(msg.value == 0) {\n', '      withdraw();\n', '    }\n', '    // If the user sent ETH, claim PAY with it.\n', '    else {\n', '      claim();\n', '    }\n', '  }\n', '}']