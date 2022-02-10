['pragma solidity ^0.4.11;\n', '\n', '  /*\n', '\n', '    Ziber.io Contract\n', '    ========================\n', '    Buys ZBR tokens from the DAO crowdsale on your behalf.\n', '    Author: /u/Leo\n', '\n', '  */\n', '\n', '\n', '  // Interface to ZBR ICO Contract\n', '  contract DaoToken {\n', '    uint256 public CAP;\n', '    uint256 public totalEthers;\n', '    function proxyPayment(address participant) payable;\n', '    function transfer(address _to, uint _amount) returns (bool success);\n', '  }\n', '\n', '  contract ZiberToken {\n', '    // Store the amount of ETH deposited by each account.\n', '    mapping (address => uint256) public balances;\n', '    // Store whether or not each account would have made it into the crowdsale.\n', '    mapping (address => bool) public checked_in;\n', '    // Bounty for executing buy.\n', '    uint256 public bounty;\n', '    // Track whether the contract has bought the tokens yet.\n', '    bool public bought_tokens;\n', '    // Record the time the contract bought the tokens.\n', '    uint256 public time_bought;\n', '    // Emergency kill switch in case a critical bug is found.\n', '    bool public kill_switch;\n', '    \n', '    /* Public variables of the token */\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    \n', '    // Ratio of ZBR tokens received to ETH contributed\n', '    // 1.000.000 BGP = 80.000.000 ZBR\n', '    // 1ETH = 218 BGP (03.07.2017: https://www.coingecko.com/en/price_charts/ethereum/gbp)\n', '    // 1 ETH = 17440 ZBR\n', '    uint256 ZBR_per_eth = 17440;\n', '    //Total ZBR Tokens Reserve\n', '    uint256 ZBR_total_reserve = 100000000;\n', '    // ZBR Tokens for Developers\n', '    uint256 ZBR_dev_reserved = 10000000;\n', '    // ZBR Tokens for Selling over ICO\n', '    uint256 ZBR_for_selling = 80000000;\n', '    // ZBR Tokens for Bounty\n', '    uint256 ZBR_for_bounty= 10000000;\n', '    // ETH for activate kill-switch in contract\n', '    uint256 ETH_to_end = 50000 ether;\n', '    uint registredTo;\n', '    uint256 loadedRefund;\n', '    uint256 _supply = 10000000000;\n', '    string _name = "ZIBER TEST TOKEN";\n', '    string _symbol = "ZBRX";\n', '    uint8 _decimals = 2;\n', '\n', '    // The ZBR Token address and sale address are the same.\n', '    DaoToken public token = DaoToken(0xa9d585CE3B227d69985c3F7A866fE7d0e510da50);\n', '    // The developer address.\n', '    address developer_address = 0x650887B33BFA423240ED7Bc4BD26c66075E3bEaf;\n', '\n', '\n', '    /* This creates an array with all balances */\n', '      mapping (address => uint256) public balanceOf;\n', '      \n', '      /* This generates a public event on the blockchain that will notify clients */\n', '      event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '      /// SafeMath contract - math operations with safety checks\n', '      /// @author <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="1773726157647a766563747879636576746372767a3974787a">[email&#160;protected]</a>\n', '      function safeMul(uint a, uint b) internal returns (uint) {\n', '        uint c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '      }\n', '\n', '      function safeDiv(uint a, uint b) internal returns (uint) {\n', '        assert(b > 0);\n', '        uint c = a / b;\n', '        assert(a == b * c + a % b);\n', '        return c;\n', '      }\n', '\n', '      function safeSub(uint a, uint b) internal returns (uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '      }\n', '\n', '      function safeAdd(uint a, uint b) internal returns (uint) {\n', '        uint c = a + b;\n', '        assert(c>=a && c>=b);\n', '        return c;\n', '      }\n', '\n', '      function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '        return a >= b ? a : b;\n', '      }\n', '\n', '      function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '        return a < b ? a : b;\n', '      }\n', '\n', '      function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        return a >= b ? a : b;\n', '      }\n', '\n', '      function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        return a < b ? a : b;\n', '      }\n', '\n', '      function assert(bool assertion) internal {\n', '        if (!assertion) {\n', '          throw;\n', '        }\n', '      }\n', '\n', '\n', '      /**\n', '      * Allow load refunds back on the contract for the refunding.\n', '      *\n', '      * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..\n', '      */\n', '      function loadRefund() payable {\n', '        if(msg.value == 0) throw;\n', '        loadedRefund = safeAdd(loadedRefund, msg.value);\n', '      }\n', '\n', '      /**\n', '      * Investors can claim refund.\n', '      */\n', '      function refund() private  {\n', '        uint256 weiValue = this.balance;\n', '        if (weiValue == 0) throw;\n', '        uint256 weiRefunded;\n', '        weiRefunded = safeAdd(weiRefunded, weiValue);\n', '        refund();\n', '        if (!msg.sender.send(weiValue)) throw;\n', '      }\n', '\n', '      /* Send coins */\n', '      function transfer(address _to, uint256 _value) {\n', '          /* if the sender doenst have enough balance then stop */\n', '          if (balanceOf[msg.sender] < _value) throw;\n', '          if (balanceOf[_to] + _value < balanceOf[_to]) throw;\n', '          \n', '          /* Add and subtract new balances */\n', '          balanceOf[msg.sender] -= _value;\n', '          balanceOf[_to] += _value;\n', '          \n', '          /* Notifiy anyone listening that this transfer took place */\n', '          Transfer(msg.sender, _to, _value);\n', '      }\n', '    \n', '    // Allows the developer to shut down everything except withdrawals in emergencies.\n', '    function activate_kill_switch() {\n', '      // Only allow the developer to activate the kill switch.\n', '      if (msg.sender != developer_address) throw;\n', '      // Irreversibly activate the kill switch.\n', '      kill_switch = true;\n', '    }\n', '    \n', '    // Withdraws all ETH deposited or ZBR purchased by the sender.\n', '    function withdraw(){\n', '      // If called before the ICO, cancel caller&#39;s participation in the sale.\n', '      if (!bought_tokens) {\n', '        // Store the user&#39;s balance prior to withdrawal in a temporary variable.\n', '        uint256 eth_amount = balances[msg.sender];\n', '        // Update the user&#39;s balance prior to sending ETH to prevent recursive call.\n', '        balances[msg.sender] = 0;\n', '        // Return the user&#39;s funds.  Throws on failure to prevent loss of funds.\n', '        msg.sender.transfer(eth_amount);\n', '      }\n', '      // Withdraw the sender&#39;s tokens if the contract has already purchased them.\n', '      else {\n', '        // Store the user&#39;s ZBR balance in a temporary variable (1 ETHWei -> 2000 ZBRWei).\n', '        uint256 ZBR_amount = balances[msg.sender] * ZBR_per_eth;\n', '        // Update the user&#39;s balance prior to sending ZBR to prevent recursive call.\n', '        balances[msg.sender] = 0;\n', '        // No fee for withdrawing if the user would have made it into the crowdsale alone.\n', '        uint256 fee = 0;\n', '        // 1% fee if the user didn&#39;t check in during the crowdsale.\n', '        if (!checked_in[msg.sender]) {\n', '          fee = ZBR_amount / 100;\n', '          // Send any non-zero fees to developer.\n', '          if(!token.transfer(developer_address, fee)) throw;\n', '        }\n', '        // Send the user their tokens.  Throws if the crowdsale isn&#39;t over.\n', '        if(!token.transfer(msg.sender, ZBR_amount - fee)) throw;\n', '      }\n', '    }\n', '    \n', '    // Allow developer to add ETH to the buy execution bounty.\n', '    function add_to_bounty() payable {\n', '      // Only allow the developer to contribute to the buy execution bounty.\n', '      if (msg.sender != developer_address) throw;\n', '      // Disallow adding to bounty if kill switch is active.\n', '      if (kill_switch) throw;\n', '      // Disallow adding to the bounty if contract has already bought the tokens.\n', '      if (bought_tokens) throw;\n', '      // Update bounty to include received amount.\n', '      bounty += msg.value;\n', '    }\n', '    \n', '    // Buys tokens in the crowdsale and rewards the caller, callable by anyone.\n', '    function claim_bounty(){\n', '      // Short circuit to save gas if the contract has already bought tokens.\n', '      if (bought_tokens) return;\n', '      // Disallow buying into the crowdsale if kill switch is active.\n', '      if (kill_switch) throw;\n', '      // Record that the contract has bought the tokens.\n', '      bought_tokens = true;\n', '      // Record the time the contract bought the tokens.\n', '      time_bought = now + 1 days;\n', '      // Transfer all the funds (less the bounty) to the ZBR crowdsale contract\n', '      // to buy tokens.  Throws if the crowdsale hasn&#39;t started yet or has\n', '      // already completed, preventing loss of funds.\n', '      token.proxyPayment.value(this.balance - bounty)(address(this));\n', '      // Send the caller their bounty for buying tokens for the contract.\n', '      if(this.balance > ETH_to_end)\n', '      {\n', '          msg.sender.transfer(bounty);\n', '      }\n', '      else {\n', '          time_bought = now +  1 days * 9;\n', '          if(this.balance > ETH_to_end) {\n', '            msg.sender.transfer(bounty);\n', '          }\n', '        }\n', '    }\n', '    \n', '    // A helper function for the default function, allowing contracts to interact.\n', '    function default_helper() payable {\n', '      // Treat near-zero ETH transactions as check ins and withdrawal requests.\n', '      if (msg.value <= 1 finney) {\n', '        // Check in during the crowdsale.\n', '        if (bought_tokens) {\n', '          // Only allow checking in before the crowdsale has reached the cap.\n', '          if (token.totalEthers() >= token.CAP()) throw;\n', '          // Mark user as checked in, meaning they would have been able to enter alone.\n', '          checked_in[msg.sender] = true;\n', '        }\n', '        // Withdraw funds if the crowdsale hasn&#39;t begun yet or is already over.\n', '        else {\n', '          withdraw();\n', '        }\n', '      }\n', '      // Deposit the user&#39;s funds for use in purchasing tokens.\n', '      else {\n', '        // Disallow deposits if kill switch is active.\n', '        if (kill_switch) throw;\n', '        // Only allow deposits if the contract hasn&#39;t already purchased the tokens.\n', '        if (bought_tokens) throw;\n', '        // Update records of deposited ETH to include the received amount.\n', '        balances[msg.sender] += msg.value;\n', '      }\n', '    }\n', '    \n', '    // Default function.  Called when a user sends ETH to the contract.\n', '    function () payable {\n', '      // Delegate to the helper function.\n', '      default_helper();\n', '    }\n', '    \n', '    //Check is msg_sender is contract dev\n', '    modifier onlyOwner() {\n', '      if (msg.sender != developer_address) {\n', '        throw;\n', '      }\n', '      _;\n', '    }\n', '    \n', '    // Send fund when ico end\n', '    function withdrawEth() onlyOwner {        \n', '          msg.sender.transfer(this.balance);\n', '    }\n', '    \n', '    //Kill contract\n', '    function kill() onlyOwner {        \n', '          selfdestruct(developer_address);\n', '    }\n', '  }']