['pragma solidity ^0.4.11;\n', '\n', '/*\n', '  Allows buyers to securely/confidently buy recent ICO tokens that are\n', '  still non-transferrable, on an IOU basis. Like HitBTC, but with protection,\n', '  control, and guarantee of either the purchased tokens or ETH refunded.\n', '\n', '  The Buyer&#39;s ETH will be locked into the contract until the purchased\n', '  IOU/tokens arrive here and are ready for the buyer to invoke withdraw(),\n', '  OR until cut-off time defined below is exceeded and as a result ETH\n', '  refunds/withdrawals become enabled.\n', '\n', '  In other words, the seller must fulfill the IOU token purchases any time\n', '  before the cut-off time defined below, otherwise the buyer gains the\n', '  ability to withdraw their ETH.\n', '\n', '  The buyer&#39;s ETH will ONLY be released to the seller AFTER the adequate\n', '  amount of tokens have been deposited for ALL purchases.\n', '\n', '  Estimated Time of Distribution: 3-5 weeks from ICO according to TenX\n', '  Cut-off Time: ~ August 9, 2017\n', '\n', '  Greetz: blast\n', '  <span class="__cf_email__" data-cfemail="47212828252635252e3d2635352207202a262e2b6924282a">[email&#160;protected]</span> (Please report any findings or suggestions for a 1 ETH bounty!)\n', '\n', '  Thank you\n', '*/\n', '\n', 'contract ERC20 {\n', '  function transfer(address _to, uint _value);\n', '  function balanceOf(address _owner) constant returns (uint balance);\n', '}\n', '\n', 'contract IOU {\n', '  // Store the amount of IOUs purchased by a buyer\n', '  mapping (address => uint256) public iou_purchased;\n', '\n', '  // Store the amount of ETH sent in by a buyer\n', '  mapping (address => uint256) public eth_sent;\n', '\n', '  // Total IOUs available to sell\n', '  uint256 public total_iou_available = 52500000000000000000000;\n', '\n', '  // Total IOUs purchased by all buyers\n', '  uint256 public total_iou_purchased;\n', '\n', '  // Total IOU withdrawn by all buyers (keep track to protect buyers)\n', '  uint256 public total_iou_withdrawn;\n', '\n', '  // IOU per ETH (price)\n', '  uint256 public price_per_eth = 160;\n', '\n', '  //  PAY token contract address (IOU offering)\n', '  ERC20 public token = ERC20(0xB97048628DB6B661D4C2aA833e95Dbe1A905B280);\n', '\n', '  // The seller&#39;s address (to receive ETH upon distribution, and for authing safeties)\n', '  address seller = 0xB00Ae1e677B27Eee9955d632FF07a8590210B366;\n', '\n', '  // Halt further purchase ability just in case\n', '  bool public halt_purchases;\n', '\n', '  modifier pwner() { if(msg.sender != seller) throw; _; }\n', '\n', '  /*\n', '    Safety to withdraw unbought tokens back to seller. Ensures the amount\n', '    that buyers still need to withdraw remains available\n', '  */\n', '  function withdrawTokens() pwner {\n', '    token.transfer(seller, token.balanceOf(address(this)) - (total_iou_purchased - total_iou_withdrawn));\n', '  }\n', '\n', '  /*\n', '    Safety to prevent anymore purchases/sales from occurring in the event of\n', '    unforeseen issue. Buyer withdrawals still remain enabled.\n', '  */\n', '  function haltPurchases() pwner {\n', '    halt_purchases = true;\n', '  }\n', '\n', '  function resumePurchases() pwner {\n', '    halt_purchases = false;\n', '  }\n', '\n', '  /*\n', '    Update available IOU to purchase\n', '  */\n', '  function updateAvailability(uint256 _iou_amount) pwner {\n', '    if(_iou_amount < total_iou_purchased) throw;\n', '\n', '    total_iou_available = _iou_amount;\n', '  }\n', '\n', '  /*\n', '    Update IOU price\n', '  */\n', '  function updatePrice(uint256 _price) pwner {\n', '    price_per_eth = _price;\n', '  }\n', '\n', '  /*\n', '    Release buyer&#39;s ETH to seller ONLY if amount of contract&#39;s tokens balance\n', '    is >= to the amount that still needs to be withdrawn. Protects buyer.\n', '\n', '    The seller must call this function manually after depositing the adequate\n', '    amount of tokens for all buyers to collect\n', '\n', '    This effectively ends the sale, but withdrawals remain open\n', '  */\n', '  function paySeller() pwner {\n', '    // not enough tokens in balance to release ETH, protect buyer and abort\n', '    if(token.balanceOf(address(this)) < (total_iou_purchased - total_iou_withdrawn)) throw;\n', '\n', '    // Halt further purchases to prevent accidental over-selling\n', '    halt_purchases = true;\n', '\n', '    // Release buyer&#39;s ETH to the seller\n', '    seller.transfer(this.balance);\n', '  }\n', '\n', '  function withdraw() payable {\n', '    /*\n', '      Main mechanism to ensure a buyer&#39;s purchase/ETH/IOU is safe.\n', '\n', '      Refund the buyer&#39;s ETH if we&#39;re beyond the cut-off date of our distribution\n', '      promise AND if the contract doesn&#39;t have an adequate amount of tokens\n', '      to distribute to the buyer. Time-sensitive buyer/ETH protection is only\n', '      applicable if the contract doesn&#39;t have adequate tokens for the buyer.\n', '\n', '      The "adequacy" check prevents the seller and/or third party attacker\n', '      from locking down buyers&#39; ETH by sending in an arbitrary amount of tokens.\n', '\n', '      If for whatever reason the tokens remain locked for an unexpected period\n', '      beyond the time defined by block.number, patient buyers may still wait until\n', '      the contract is filled with their purchased IOUs/tokens. Once the tokens\n', '      are here, they can initiate a withdraw() to retrieve their tokens. Attempting\n', '      to withdraw any sooner (after the block has been mined, but tokens not arrived)\n', '      will result in a refund of buyer&#39;s ETH.\n', '    */\n', '    if(block.number > 4199999 && iou_purchased[msg.sender] > token.balanceOf(address(this))) {\n', '      // We didn&#39;t fulfill our promise to have adequate tokens withdrawable at xx time\n', '      // Refund the buyer&#39;s ETH automatically instead\n', '      uint256 eth_to_refund = eth_sent[msg.sender];\n', '\n', '      // If the user doesn&#39;t have any ETH or tokens to withdraw, get out ASAP\n', '      if(eth_to_refund == 0 || iou_purchased[msg.sender] == 0) throw;\n', '\n', '      // Adjust total purchased so others can buy, and so numbers align with total_iou_withdrawn\n', '      total_iou_purchased -= iou_purchased[msg.sender];\n', '\n', '      // Clear record of buyer&#39;s ETH and IOU balance before refunding\n', '      eth_sent[msg.sender] = 0;\n', '      iou_purchased[msg.sender] = 0;\n', '\n', '      msg.sender.transfer(eth_to_refund);\n', '      return;\n', '    }\n', '\n', '    /*\n', '      Check if there is an adequate amount of tokens in the contract yet\n', '      and allow the buyer to withdraw tokens\n', '    */\n', '    if(token.balanceOf(address(this)) == 0 || iou_purchased[msg.sender] > token.balanceOf(address(this))) throw;\n', '\n', '    uint256 iou_to_withdraw = iou_purchased[msg.sender];\n', '\n', '    // If the user doesn&#39;t have any IOUs to withdraw, get out ASAP\n', '    if(iou_to_withdraw == 0) throw;\n', '\n', '    // Clear record of buyer&#39;s IOU and ETH balance before transferring out\n', '    iou_purchased[msg.sender] = 0;\n', '    eth_sent[msg.sender] = 0;\n', '\n', '    total_iou_withdrawn += iou_to_withdraw;\n', '\n', '    // Distribute tokens to the buyer\n', '    token.transfer(msg.sender, iou_to_withdraw);\n', '  }\n', '\n', '  function purchase() payable {\n', '    if(halt_purchases) throw;\n', '    if(msg.value == 0) throw;\n', '\n', '    // Determine amount of tokens user wants to/can buy\n', '    uint256 iou_to_purchase = price_per_eth * msg.value;\n', '\n', '    // Check if we have enough IOUs left to sell\n', '    if((total_iou_purchased + iou_to_purchase) > total_iou_available) throw;\n', '\n', '    // Update the amount of IOUs purchased by user. Also keep track of the total ETH they sent in\n', '    iou_purchased[msg.sender] += iou_to_purchase;\n', '    eth_sent[msg.sender] += msg.value;\n', '\n', '    // Update the total amount of IOUs purchased by all buyers\n', '    total_iou_purchased += iou_to_purchase;\n', '  }\n', '\n', '  // Fallback function/entry point\n', '  function () payable {\n', '    if(msg.value == 0) {\n', '      withdraw();\n', '    }\n', '    else {\n', '      purchase();\n', '    }\n', '  }\n', '}']
['pragma solidity ^0.4.11;\n', '\n', '/*\n', '  Allows buyers to securely/confidently buy recent ICO tokens that are\n', '  still non-transferrable, on an IOU basis. Like HitBTC, but with protection,\n', '  control, and guarantee of either the purchased tokens or ETH refunded.\n', '\n', "  The Buyer's ETH will be locked into the contract until the purchased\n", '  IOU/tokens arrive here and are ready for the buyer to invoke withdraw(),\n', '  OR until cut-off time defined below is exceeded and as a result ETH\n', '  refunds/withdrawals become enabled.\n', '\n', '  In other words, the seller must fulfill the IOU token purchases any time\n', '  before the cut-off time defined below, otherwise the buyer gains the\n', '  ability to withdraw their ETH.\n', '\n', "  The buyer's ETH will ONLY be released to the seller AFTER the adequate\n", '  amount of tokens have been deposited for ALL purchases.\n', '\n', '  Estimated Time of Distribution: 3-5 weeks from ICO according to TenX\n', '  Cut-off Time: ~ August 9, 2017\n', '\n', '  Greetz: blast\n', '  foobarbizarre@gmail.com (Please report any findings or suggestions for a 1 ETH bounty!)\n', '\n', '  Thank you\n', '*/\n', '\n', 'contract ERC20 {\n', '  function transfer(address _to, uint _value);\n', '  function balanceOf(address _owner) constant returns (uint balance);\n', '}\n', '\n', 'contract IOU {\n', '  // Store the amount of IOUs purchased by a buyer\n', '  mapping (address => uint256) public iou_purchased;\n', '\n', '  // Store the amount of ETH sent in by a buyer\n', '  mapping (address => uint256) public eth_sent;\n', '\n', '  // Total IOUs available to sell\n', '  uint256 public total_iou_available = 52500000000000000000000;\n', '\n', '  // Total IOUs purchased by all buyers\n', '  uint256 public total_iou_purchased;\n', '\n', '  // Total IOU withdrawn by all buyers (keep track to protect buyers)\n', '  uint256 public total_iou_withdrawn;\n', '\n', '  // IOU per ETH (price)\n', '  uint256 public price_per_eth = 160;\n', '\n', '  //  PAY token contract address (IOU offering)\n', '  ERC20 public token = ERC20(0xB97048628DB6B661D4C2aA833e95Dbe1A905B280);\n', '\n', "  // The seller's address (to receive ETH upon distribution, and for authing safeties)\n", '  address seller = 0xB00Ae1e677B27Eee9955d632FF07a8590210B366;\n', '\n', '  // Halt further purchase ability just in case\n', '  bool public halt_purchases;\n', '\n', '  modifier pwner() { if(msg.sender != seller) throw; _; }\n', '\n', '  /*\n', '    Safety to withdraw unbought tokens back to seller. Ensures the amount\n', '    that buyers still need to withdraw remains available\n', '  */\n', '  function withdrawTokens() pwner {\n', '    token.transfer(seller, token.balanceOf(address(this)) - (total_iou_purchased - total_iou_withdrawn));\n', '  }\n', '\n', '  /*\n', '    Safety to prevent anymore purchases/sales from occurring in the event of\n', '    unforeseen issue. Buyer withdrawals still remain enabled.\n', '  */\n', '  function haltPurchases() pwner {\n', '    halt_purchases = true;\n', '  }\n', '\n', '  function resumePurchases() pwner {\n', '    halt_purchases = false;\n', '  }\n', '\n', '  /*\n', '    Update available IOU to purchase\n', '  */\n', '  function updateAvailability(uint256 _iou_amount) pwner {\n', '    if(_iou_amount < total_iou_purchased) throw;\n', '\n', '    total_iou_available = _iou_amount;\n', '  }\n', '\n', '  /*\n', '    Update IOU price\n', '  */\n', '  function updatePrice(uint256 _price) pwner {\n', '    price_per_eth = _price;\n', '  }\n', '\n', '  /*\n', "    Release buyer's ETH to seller ONLY if amount of contract's tokens balance\n", '    is >= to the amount that still needs to be withdrawn. Protects buyer.\n', '\n', '    The seller must call this function manually after depositing the adequate\n', '    amount of tokens for all buyers to collect\n', '\n', '    This effectively ends the sale, but withdrawals remain open\n', '  */\n', '  function paySeller() pwner {\n', '    // not enough tokens in balance to release ETH, protect buyer and abort\n', '    if(token.balanceOf(address(this)) < (total_iou_purchased - total_iou_withdrawn)) throw;\n', '\n', '    // Halt further purchases to prevent accidental over-selling\n', '    halt_purchases = true;\n', '\n', "    // Release buyer's ETH to the seller\n", '    seller.transfer(this.balance);\n', '  }\n', '\n', '  function withdraw() payable {\n', '    /*\n', "      Main mechanism to ensure a buyer's purchase/ETH/IOU is safe.\n", '\n', "      Refund the buyer's ETH if we're beyond the cut-off date of our distribution\n", "      promise AND if the contract doesn't have an adequate amount of tokens\n", '      to distribute to the buyer. Time-sensitive buyer/ETH protection is only\n', "      applicable if the contract doesn't have adequate tokens for the buyer.\n", '\n', '      The "adequacy" check prevents the seller and/or third party attacker\n', "      from locking down buyers' ETH by sending in an arbitrary amount of tokens.\n", '\n', '      If for whatever reason the tokens remain locked for an unexpected period\n', '      beyond the time defined by block.number, patient buyers may still wait until\n', '      the contract is filled with their purchased IOUs/tokens. Once the tokens\n', '      are here, they can initiate a withdraw() to retrieve their tokens. Attempting\n', '      to withdraw any sooner (after the block has been mined, but tokens not arrived)\n', "      will result in a refund of buyer's ETH.\n", '    */\n', '    if(block.number > 4199999 && iou_purchased[msg.sender] > token.balanceOf(address(this))) {\n', "      // We didn't fulfill our promise to have adequate tokens withdrawable at xx time\n", "      // Refund the buyer's ETH automatically instead\n", '      uint256 eth_to_refund = eth_sent[msg.sender];\n', '\n', "      // If the user doesn't have any ETH or tokens to withdraw, get out ASAP\n", '      if(eth_to_refund == 0 || iou_purchased[msg.sender] == 0) throw;\n', '\n', '      // Adjust total purchased so others can buy, and so numbers align with total_iou_withdrawn\n', '      total_iou_purchased -= iou_purchased[msg.sender];\n', '\n', "      // Clear record of buyer's ETH and IOU balance before refunding\n", '      eth_sent[msg.sender] = 0;\n', '      iou_purchased[msg.sender] = 0;\n', '\n', '      msg.sender.transfer(eth_to_refund);\n', '      return;\n', '    }\n', '\n', '    /*\n', '      Check if there is an adequate amount of tokens in the contract yet\n', '      and allow the buyer to withdraw tokens\n', '    */\n', '    if(token.balanceOf(address(this)) == 0 || iou_purchased[msg.sender] > token.balanceOf(address(this))) throw;\n', '\n', '    uint256 iou_to_withdraw = iou_purchased[msg.sender];\n', '\n', "    // If the user doesn't have any IOUs to withdraw, get out ASAP\n", '    if(iou_to_withdraw == 0) throw;\n', '\n', "    // Clear record of buyer's IOU and ETH balance before transferring out\n", '    iou_purchased[msg.sender] = 0;\n', '    eth_sent[msg.sender] = 0;\n', '\n', '    total_iou_withdrawn += iou_to_withdraw;\n', '\n', '    // Distribute tokens to the buyer\n', '    token.transfer(msg.sender, iou_to_withdraw);\n', '  }\n', '\n', '  function purchase() payable {\n', '    if(halt_purchases) throw;\n', '    if(msg.value == 0) throw;\n', '\n', '    // Determine amount of tokens user wants to/can buy\n', '    uint256 iou_to_purchase = price_per_eth * msg.value;\n', '\n', '    // Check if we have enough IOUs left to sell\n', '    if((total_iou_purchased + iou_to_purchase) > total_iou_available) throw;\n', '\n', '    // Update the amount of IOUs purchased by user. Also keep track of the total ETH they sent in\n', '    iou_purchased[msg.sender] += iou_to_purchase;\n', '    eth_sent[msg.sender] += msg.value;\n', '\n', '    // Update the total amount of IOUs purchased by all buyers\n', '    total_iou_purchased += iou_to_purchase;\n', '  }\n', '\n', '  // Fallback function/entry point\n', '  function () payable {\n', '    if(msg.value == 0) {\n', '      withdraw();\n', '    }\n', '    else {\n', '      purchase();\n', '    }\n', '  }\n', '}']
