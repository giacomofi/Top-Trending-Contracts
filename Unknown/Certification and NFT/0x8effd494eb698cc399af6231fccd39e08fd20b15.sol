['pragma solidity ^0.4.13;\n', '\n', '/**\n', ' * Overflow aware uint math functions.\n', ' *\n', ' * Inspired by https://github.com/MakerDAO/maker-otc/blob/master/contracts/simple_market.sol\n', ' */\n', 'contract SafeMath {\n', '    //internals\n', '\n', '    function safeMul(uint a, uint b) internal returns (uint) {\n', '        uint c = a * b;\n', '        require(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function safeSub(uint a, uint b) internal returns (uint) {\n', '        require(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function safeAdd(uint a, uint b) internal returns (uint) {\n', '        uint c = a + b;\n', '        require(c>=a && c>=b);\n', '        return c;\n', '    }\n', '\n', '    function safeDiv(uint a, uint b) internal returns (uint) {\n', '        require(b > 0);\n', '        uint c = a / b;\n', '        require(a == b * c + a % b);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * ERC 20 token\n', ' *\n', ' * https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'interface Token {\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_addr` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of wei to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '}\n', '\n', '/**\n', ' * ERC 20 token\n', ' *\n', ' * https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract StandardToken is Token {\n', '\n', '    /**\n', '     * Reviewed:\n', '     * - Integer overflow = OK, checked\n', '     */\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        //Default assumes totalSupply can&#39;t be over max (2^256 - 1).\n', '        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn&#39;t wrap.\n', '        //Replace the if with this one instead.\n', '        if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            //if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        //same as above. Replace this line with the following if you want to protect against wrapping uints.\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    uint256 public totalSupply;\n', '}\n', '\n', '\n', '/**\n', ' * PIX crowdsale ICO contract.\n', ' *\n', ' * Security criteria evaluated against http://ethereum.stackexchange.com/questions/8551/methodological-security-review-of-a-smart-contract\n', ' *\n', ' *\n', ' */\n', 'contract PIXToken is StandardToken, SafeMath {\n', '\n', '    string public name = "PIX Token";\n', '    string public symbol = "PIX";\n', '\n', '    // Initial founder address (set in constructor)\n', '    // This address is used as a controller address, in order to properly handle administration of the token.\n', '    address public founder = 0x0;\n', '\n', '    // Deposit Address - The funds will be sent here immediately after payments are made to the contract\n', '    address public deposit = 0x0;\n', '\n', '    /*\n', '    Multi-stage sale contract.\n', '\n', '    Notes:\n', '    All token sales are tied to USD.  No token sales are for a fixed amount of Wei, this can shift and change over time.\n', '    Due to this, the following needs to be paid attention to:\n', '    1. The value of the token fluctuates in reference to the centsPerEth set on the contract.\n', '    2. The tokens are priced in cents.  So all token purchases will be calculated out live at that time.\n', '\n', '    Funding Stages:\n', '    1. Pre-Sale, there will be 15M USD ( 125M tokens ) for sale. Bonus of 20%\n', '    2. Day 1 sale, there will be 20M USD - the pre-sale amount of tokens for sale. (~166.6m tokens - Pre-Sale tokens) Bonus of 15%\n', '    3. Day 2 sale, there will be 20M USD (~166.6m tokens) tokens for sale.  Bonus of 10%\n', '    4. Days 3-10 sale, there will be 20M USD (~166.6m tokens) tokens for sale.  Bonus of 5%\n', '\n', '    Post-Sale:\n', '    1. 30% of the total token count is reserved for release every year, at 1/4th of the originally reserved value per year.\n', '    2. 20% of the total token count [Minus the number of excess bonus tokens from the pre-sale] is issued out to the team when the sale has completed.\n', '    3. Purchased tokens come available to be withdrawn 31 days after the sale has completed.\n', '    */\n', '\n', '    enum State { PreSale, Day1, Day2, Day3, Running, Halted } // the states through which this contract goes\n', '    State state;\n', '\n', '    // Pricing for the pre-sale in US Cents.\n', '    uint public capPreSale = 15 * 10**8;  // 15M USD cap for pre-sale, this subtracts from day1 cap\n', '    uint public capDay1 = 20 * 10**8;  // 20M USD cap for day 1\n', '    uint public capDay2 = 20 * 10**8;  // 20M USD cap for day 2\n', '    uint public capDay3 = 20 * 10**8;  // 20M USD cap for day 3 - 10\n', '\n', '    // Token pricing information\n', '    uint public weiPerEther = 10**18;\n', '    uint public centsPerEth = 23000;\n', '    uint public centsPerToken = 12;\n', '\n', '    // Amount of funds raised in stages of pre-sale\n', '    uint public raisePreSale = 0;  // USD raise during the pre-sale period\n', '    uint public raiseDay1 = 0;  // USD raised on Day 1\n', '    uint public raiseDay2 = 0;  // USD raised on Day 2\n', '    uint public raiseDay3 = 0;  // USD raised during days 3-10\n', '\n', '    // Block timing/contract unlocking information\n', '    uint public publicSaleStart = 1502280000; // Aug 9, 2017 Noon UTC\n', '    uint public day2Start = 1502366400; // Aug 10, 2017 Noon UTC\n', '    uint public day3Start = 1502452800; // Aug 11, 2017 Noon UTC\n', '    uint public saleEnd = 1503144000; // Aug 19, 2017 Noon UTC\n', '    uint public coinTradeStart = 1505822400; // Sep 19, 2017 Noon UTC\n', '    uint public year1Unlock = 1534680000; // Aug 19, 2018 Noon UTC\n', '    uint public year2Unlock = 1566216000; // Aug 19, 2019 Noon UTC\n', '    uint public year3Unlock = 1597838400; // Aug 19, 2020 Noon UTC\n', '    uint public year4Unlock = 1629374400; // Aug 19, 2021 Noon UTC\n', '\n', '    // Have the post-reward allocations been completed\n', '    bool public allocatedFounders = false;\n', '    bool public allocated1Year = false;\n', '    bool public allocated2Year = false;\n', '    bool public allocated3Year = false;\n', '    bool public allocated4Year = false;\n', '\n', '    // Token count information\n', '    uint public totalTokensSale = 500000000; //total number of tokens being sold in the ICO, excluding bonuses, reserve, and team distributions\n', '    uint public totalTokensReserve = 330000000;\n', '    uint public totalTokensCompany = 220000000;\n', '\n', '    bool public halted = false; //the founder address can set this to true to halt the crowdsale due to emergency.\n', '\n', '    mapping(address => uint256) presaleWhitelist; // Pre-sale Whitelist\n', '\n', '    event Buy(address indexed sender, uint eth, uint fbt);\n', '    event Withdraw(address indexed sender, address to, uint eth);\n', '    event AllocateTokens(address indexed sender);\n', '\n', '    function PIXToken(address depositAddress) {\n', '        /*\n', '            Initialize the contract with a sane set of owners\n', '        */\n', '        founder = msg.sender;  // Allocate the founder address as a usable address separate from deposit.\n', '        deposit = depositAddress;  // Store the deposit address.\n', '    }\n', '\n', '    function setETHUSDRate(uint centsPerEthInput) public {\n', '        /*\n', '            Sets the current ETH/USD Exchange rate in cents.  This modifies the token price in Wei.\n', '        */\n', '        require(msg.sender == founder);\n', '        centsPerEth = centsPerEthInput;\n', '    }\n', '\n', '    /*\n', '        Gets the current state of the contract based on the block number involved in the current transaction.\n', '    */\n', '    function getCurrentState() constant public returns (State) {\n', '\n', '        if(halted) return State.Halted;\n', '        else if(block.timestamp < publicSaleStart) return State.PreSale;\n', '        else if(block.timestamp > publicSaleStart && block.timestamp <= day2Start) return State.Day1;\n', '        else if(block.timestamp > day2Start && block.timestamp <= day3Start) return State.Day2;\n', '        else if(block.timestamp > day3Start && block.timestamp <= saleEnd) return State.Day3;\n', '        else return State.Running;\n', '    }\n', '\n', '    /*\n', '        Gets the current amount of bonus per purchase in percent.\n', '    */\n', '    function getCurrentBonusInPercent() constant public returns (uint) {\n', '        State s = getCurrentState();\n', '        if (s == State.Halted) revert();\n', '        else if(s == State.PreSale) return 20;\n', '        else if(s == State.Day1) return 15;\n', '        else if(s == State.Day2) return 10;\n', '        else if(s == State.Day3) return 5;\n', '        else return 0;\n', '    }\n', '\n', '    /*\n', '        Get the current price of the token in WEI.  This should be the weiPerEther/centsPerEth * centsPerToken\n', '    */\n', '    function getTokenPriceInWEI() constant public returns (uint){\n', '        uint weiPerCent = safeDiv(weiPerEther, centsPerEth);\n', '        return safeMul(weiPerCent, centsPerToken);\n', '    }\n', '\n', '    /*\n', '        Entry point for purchasing for one&#39;s self.\n', '    */\n', '    function buy() payable public {\n', '        buyRecipient(msg.sender);\n', '    }\n', '\n', '    /*\n', '        Main purchasing function for the contract\n', '        1. Should validate the current state, from the getCurrentState() function\n', '        2. Should only allow the founder to order during the pre-sale\n', '        3. Should correctly calculate the values to be paid out during different stages of the contract.\n', '    */\n', '    function buyRecipient(address recipient) payable public {\n', '        State current_state = getCurrentState(); // Get the current state of the contract.\n', '        uint usdCentsRaise = safeDiv(safeMul(msg.value, centsPerEth), weiPerEther); // Get the current number of cents raised by the payment.\n', '\n', '        if(current_state == State.PreSale)\n', '        {\n', '            require (presaleWhitelist[msg.sender] > 0);\n', '            raisePreSale = safeAdd(raisePreSale, usdCentsRaise); //add current raise to pre-sell amount\n', '            require(raisePreSale < capPreSale && usdCentsRaise < presaleWhitelist[msg.sender]); //ensure pre-sale cap, 15m usd * 100 so we have cents\n', '            presaleWhitelist[msg.sender] = presaleWhitelist[msg.sender] - usdCentsRaise; // Remove the amount purchased from the pre-sale permitted for that user\n', '        }\n', '        else if (current_state == State.Day1)\n', '        {\n', '            raiseDay1 = safeAdd(raiseDay1, usdCentsRaise); //add current raise to pre-sell amount\n', '            require(raiseDay1 < (capDay1 - raisePreSale)); //ensure day 1 cap, which is lower by the amount we pre-sold\n', '        }\n', '        else if (current_state == State.Day2)\n', '        {\n', '            raiseDay2 = safeAdd(raiseDay2, usdCentsRaise); //add current raise to pre-sell amount\n', '            require(raiseDay2 < capDay2); //ensure day 2 cap\n', '        }\n', '        else if (current_state == State.Day3)\n', '        {\n', '            raiseDay3 = safeAdd(raiseDay3, usdCentsRaise); //add current raise to pre-sell amount\n', '            require(raiseDay3 < capDay3); //ensure day 3 cap\n', '        }\n', '        else revert();\n', '\n', '        uint tokens = safeDiv(msg.value, getTokenPriceInWEI()); // Calculate number of tokens to be paid out\n', '        uint bonus = safeDiv(safeMul(tokens, getCurrentBonusInPercent()), 100); // Calculate number of bonus tokens\n', '\n', '        if (current_state == State.PreSale) {\n', '            // Remove the extra 5% from the totalTokensCompany, in order to keep the 550m on track.\n', '            totalTokensCompany = safeSub(totalTokensCompany, safeDiv(bonus, 4));\n', '        }\n', '\n', '        uint totalTokens = safeAdd(tokens, bonus);\n', '\n', '        balances[recipient] = safeAdd(balances[recipient], totalTokens);\n', '        totalSupply = safeAdd(totalSupply, totalTokens);\n', '\n', '        deposit.transfer(msg.value); // Send deposited Ether to the deposit address on file.\n', '\n', '        Buy(recipient, msg.value, totalTokens);\n', '    }\n', '\n', '    /*\n', '        Allocate reserved and founders tokens based on the running time and state of the contract.\n', '     */\n', '    function allocateReserveAndFounderTokens() {\n', '        require(msg.sender==founder);\n', '        require(getCurrentState() == State.Running);\n', '        uint tokens = 0;\n', '\n', '        if(block.timestamp > saleEnd && !allocatedFounders)\n', '        {\n', '            allocatedFounders = true;\n', '            tokens = totalTokensCompany;\n', '            balances[founder] = safeAdd(balances[founder], tokens);\n', '            totalSupply = safeAdd(totalSupply, tokens);\n', '        }\n', '        else if(block.timestamp > year1Unlock && !allocated1Year)\n', '        {\n', '            allocated1Year = true;\n', '            tokens = safeDiv(totalTokensReserve, 4);\n', '            balances[founder] = safeAdd(balances[founder], tokens);\n', '            totalSupply = safeAdd(totalSupply, tokens);\n', '        }\n', '        else if(block.timestamp > year2Unlock && !allocated2Year)\n', '        {\n', '            allocated2Year = true;\n', '            tokens = safeDiv(totalTokensReserve, 4);\n', '            balances[founder] = safeAdd(balances[founder], tokens);\n', '            totalSupply = safeAdd(totalSupply, tokens);\n', '        }\n', '        else if(block.timestamp > year3Unlock && !allocated3Year)\n', '        {\n', '            allocated3Year = true;\n', '            tokens = safeDiv(totalTokensReserve, 4);\n', '            balances[founder] = safeAdd(balances[founder], tokens);\n', '            totalSupply = safeAdd(totalSupply, tokens);\n', '        }\n', '        else if(block.timestamp > year4Unlock && !allocated4Year)\n', '        {\n', '            allocated4Year = true;\n', '            tokens = safeDiv(totalTokensReserve, 4);\n', '            balances[founder] = safeAdd(balances[founder], tokens);\n', '            totalSupply = safeAdd(totalSupply, tokens);\n', '        }\n', '        else revert();\n', '\n', '        AllocateTokens(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * Emergency Stop ICO.\n', '     *\n', '     *  Applicable tests:\n', '     *\n', '     * - Test unhalting, buying, and succeeding\n', '     */\n', '    function halt() {\n', '        require(msg.sender==founder);\n', '        halted = true;\n', '    }\n', '\n', '    function unhalt() {\n', '        require(msg.sender==founder);\n', '        halted = false;\n', '    }\n', '\n', '    /*\n', '        Change founder address (Controlling address for contract)\n', '    */\n', '    function changeFounder(address newFounder) {\n', '        require(msg.sender==founder);\n', '        founder = newFounder;\n', '    }\n', '\n', '    /*\n', '        Change deposit address (Address to which funds are deposited)\n', '    */\n', '    function changeDeposit(address newDeposit) {\n', '        require(msg.sender==founder);\n', '        deposit = newDeposit;\n', '    }\n', '\n', '    /*\n', '        Add people to the pre-sale whitelist\n', '        Amount should be the value in USD that the purchaser is allowed to buy\n', '        IE: 100 is $100 is 10000 cents.  The correct value to enter is 100\n', '    */\n', '    function addPresaleWhitelist(address toWhitelist, uint256 amount){\n', '        require(msg.sender==founder && amount > 0);\n', '        presaleWhitelist[toWhitelist] = amount * 100;\n', '    }\n', '\n', '    /**\n', '     * ERC 20 Standard Token interface transfer function\n', '     *\n', '     * Prevent transfers until freeze period is over.\n', '     *\n', '     * Applicable tests:\n', '     *\n', '     * - Test restricted early transfer\n', '     * - Test transfer after restricted period\n', '     */\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        require(block.timestamp > coinTradeStart);\n', '        return super.transfer(_to, _value);\n', '    }\n', '    /**\n', '     * ERC 20 Standard Token interface transfer function\n', '     *\n', '     * Prevent transfers until freeze period is over.\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        require(block.timestamp > coinTradeStart);\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function() payable {\n', '        buyRecipient(msg.sender);\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.13;\n', '\n', '/**\n', ' * Overflow aware uint math functions.\n', ' *\n', ' * Inspired by https://github.com/MakerDAO/maker-otc/blob/master/contracts/simple_market.sol\n', ' */\n', 'contract SafeMath {\n', '    //internals\n', '\n', '    function safeMul(uint a, uint b) internal returns (uint) {\n', '        uint c = a * b;\n', '        require(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function safeSub(uint a, uint b) internal returns (uint) {\n', '        require(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function safeAdd(uint a, uint b) internal returns (uint) {\n', '        uint c = a + b;\n', '        require(c>=a && c>=b);\n', '        return c;\n', '    }\n', '\n', '    function safeDiv(uint a, uint b) internal returns (uint) {\n', '        require(b > 0);\n', '        uint c = a / b;\n', '        require(a == b * c + a % b);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * ERC 20 token\n', ' *\n', ' * https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'interface Token {\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_addr` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of wei to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '}\n', '\n', '/**\n', ' * ERC 20 token\n', ' *\n', ' * https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract StandardToken is Token {\n', '\n', '    /**\n', '     * Reviewed:\n', '     * - Integer overflow = OK, checked\n', '     */\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', "        //Default assumes totalSupply can't be over max (2^256 - 1).\n", "        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.\n", '        //Replace the if with this one instead.\n', '        if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            //if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        //same as above. Replace this line with the following if you want to protect against wrapping uints.\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    uint256 public totalSupply;\n', '}\n', '\n', '\n', '/**\n', ' * PIX crowdsale ICO contract.\n', ' *\n', ' * Security criteria evaluated against http://ethereum.stackexchange.com/questions/8551/methodological-security-review-of-a-smart-contract\n', ' *\n', ' *\n', ' */\n', 'contract PIXToken is StandardToken, SafeMath {\n', '\n', '    string public name = "PIX Token";\n', '    string public symbol = "PIX";\n', '\n', '    // Initial founder address (set in constructor)\n', '    // This address is used as a controller address, in order to properly handle administration of the token.\n', '    address public founder = 0x0;\n', '\n', '    // Deposit Address - The funds will be sent here immediately after payments are made to the contract\n', '    address public deposit = 0x0;\n', '\n', '    /*\n', '    Multi-stage sale contract.\n', '\n', '    Notes:\n', '    All token sales are tied to USD.  No token sales are for a fixed amount of Wei, this can shift and change over time.\n', '    Due to this, the following needs to be paid attention to:\n', '    1. The value of the token fluctuates in reference to the centsPerEth set on the contract.\n', '    2. The tokens are priced in cents.  So all token purchases will be calculated out live at that time.\n', '\n', '    Funding Stages:\n', '    1. Pre-Sale, there will be 15M USD ( 125M tokens ) for sale. Bonus of 20%\n', '    2. Day 1 sale, there will be 20M USD - the pre-sale amount of tokens for sale. (~166.6m tokens - Pre-Sale tokens) Bonus of 15%\n', '    3. Day 2 sale, there will be 20M USD (~166.6m tokens) tokens for sale.  Bonus of 10%\n', '    4. Days 3-10 sale, there will be 20M USD (~166.6m tokens) tokens for sale.  Bonus of 5%\n', '\n', '    Post-Sale:\n', '    1. 30% of the total token count is reserved for release every year, at 1/4th of the originally reserved value per year.\n', '    2. 20% of the total token count [Minus the number of excess bonus tokens from the pre-sale] is issued out to the team when the sale has completed.\n', '    3. Purchased tokens come available to be withdrawn 31 days after the sale has completed.\n', '    */\n', '\n', '    enum State { PreSale, Day1, Day2, Day3, Running, Halted } // the states through which this contract goes\n', '    State state;\n', '\n', '    // Pricing for the pre-sale in US Cents.\n', '    uint public capPreSale = 15 * 10**8;  // 15M USD cap for pre-sale, this subtracts from day1 cap\n', '    uint public capDay1 = 20 * 10**8;  // 20M USD cap for day 1\n', '    uint public capDay2 = 20 * 10**8;  // 20M USD cap for day 2\n', '    uint public capDay3 = 20 * 10**8;  // 20M USD cap for day 3 - 10\n', '\n', '    // Token pricing information\n', '    uint public weiPerEther = 10**18;\n', '    uint public centsPerEth = 23000;\n', '    uint public centsPerToken = 12;\n', '\n', '    // Amount of funds raised in stages of pre-sale\n', '    uint public raisePreSale = 0;  // USD raise during the pre-sale period\n', '    uint public raiseDay1 = 0;  // USD raised on Day 1\n', '    uint public raiseDay2 = 0;  // USD raised on Day 2\n', '    uint public raiseDay3 = 0;  // USD raised during days 3-10\n', '\n', '    // Block timing/contract unlocking information\n', '    uint public publicSaleStart = 1502280000; // Aug 9, 2017 Noon UTC\n', '    uint public day2Start = 1502366400; // Aug 10, 2017 Noon UTC\n', '    uint public day3Start = 1502452800; // Aug 11, 2017 Noon UTC\n', '    uint public saleEnd = 1503144000; // Aug 19, 2017 Noon UTC\n', '    uint public coinTradeStart = 1505822400; // Sep 19, 2017 Noon UTC\n', '    uint public year1Unlock = 1534680000; // Aug 19, 2018 Noon UTC\n', '    uint public year2Unlock = 1566216000; // Aug 19, 2019 Noon UTC\n', '    uint public year3Unlock = 1597838400; // Aug 19, 2020 Noon UTC\n', '    uint public year4Unlock = 1629374400; // Aug 19, 2021 Noon UTC\n', '\n', '    // Have the post-reward allocations been completed\n', '    bool public allocatedFounders = false;\n', '    bool public allocated1Year = false;\n', '    bool public allocated2Year = false;\n', '    bool public allocated3Year = false;\n', '    bool public allocated4Year = false;\n', '\n', '    // Token count information\n', '    uint public totalTokensSale = 500000000; //total number of tokens being sold in the ICO, excluding bonuses, reserve, and team distributions\n', '    uint public totalTokensReserve = 330000000;\n', '    uint public totalTokensCompany = 220000000;\n', '\n', '    bool public halted = false; //the founder address can set this to true to halt the crowdsale due to emergency.\n', '\n', '    mapping(address => uint256) presaleWhitelist; // Pre-sale Whitelist\n', '\n', '    event Buy(address indexed sender, uint eth, uint fbt);\n', '    event Withdraw(address indexed sender, address to, uint eth);\n', '    event AllocateTokens(address indexed sender);\n', '\n', '    function PIXToken(address depositAddress) {\n', '        /*\n', '            Initialize the contract with a sane set of owners\n', '        */\n', '        founder = msg.sender;  // Allocate the founder address as a usable address separate from deposit.\n', '        deposit = depositAddress;  // Store the deposit address.\n', '    }\n', '\n', '    function setETHUSDRate(uint centsPerEthInput) public {\n', '        /*\n', '            Sets the current ETH/USD Exchange rate in cents.  This modifies the token price in Wei.\n', '        */\n', '        require(msg.sender == founder);\n', '        centsPerEth = centsPerEthInput;\n', '    }\n', '\n', '    /*\n', '        Gets the current state of the contract based on the block number involved in the current transaction.\n', '    */\n', '    function getCurrentState() constant public returns (State) {\n', '\n', '        if(halted) return State.Halted;\n', '        else if(block.timestamp < publicSaleStart) return State.PreSale;\n', '        else if(block.timestamp > publicSaleStart && block.timestamp <= day2Start) return State.Day1;\n', '        else if(block.timestamp > day2Start && block.timestamp <= day3Start) return State.Day2;\n', '        else if(block.timestamp > day3Start && block.timestamp <= saleEnd) return State.Day3;\n', '        else return State.Running;\n', '    }\n', '\n', '    /*\n', '        Gets the current amount of bonus per purchase in percent.\n', '    */\n', '    function getCurrentBonusInPercent() constant public returns (uint) {\n', '        State s = getCurrentState();\n', '        if (s == State.Halted) revert();\n', '        else if(s == State.PreSale) return 20;\n', '        else if(s == State.Day1) return 15;\n', '        else if(s == State.Day2) return 10;\n', '        else if(s == State.Day3) return 5;\n', '        else return 0;\n', '    }\n', '\n', '    /*\n', '        Get the current price of the token in WEI.  This should be the weiPerEther/centsPerEth * centsPerToken\n', '    */\n', '    function getTokenPriceInWEI() constant public returns (uint){\n', '        uint weiPerCent = safeDiv(weiPerEther, centsPerEth);\n', '        return safeMul(weiPerCent, centsPerToken);\n', '    }\n', '\n', '    /*\n', "        Entry point for purchasing for one's self.\n", '    */\n', '    function buy() payable public {\n', '        buyRecipient(msg.sender);\n', '    }\n', '\n', '    /*\n', '        Main purchasing function for the contract\n', '        1. Should validate the current state, from the getCurrentState() function\n', '        2. Should only allow the founder to order during the pre-sale\n', '        3. Should correctly calculate the values to be paid out during different stages of the contract.\n', '    */\n', '    function buyRecipient(address recipient) payable public {\n', '        State current_state = getCurrentState(); // Get the current state of the contract.\n', '        uint usdCentsRaise = safeDiv(safeMul(msg.value, centsPerEth), weiPerEther); // Get the current number of cents raised by the payment.\n', '\n', '        if(current_state == State.PreSale)\n', '        {\n', '            require (presaleWhitelist[msg.sender] > 0);\n', '            raisePreSale = safeAdd(raisePreSale, usdCentsRaise); //add current raise to pre-sell amount\n', '            require(raisePreSale < capPreSale && usdCentsRaise < presaleWhitelist[msg.sender]); //ensure pre-sale cap, 15m usd * 100 so we have cents\n', '            presaleWhitelist[msg.sender] = presaleWhitelist[msg.sender] - usdCentsRaise; // Remove the amount purchased from the pre-sale permitted for that user\n', '        }\n', '        else if (current_state == State.Day1)\n', '        {\n', '            raiseDay1 = safeAdd(raiseDay1, usdCentsRaise); //add current raise to pre-sell amount\n', '            require(raiseDay1 < (capDay1 - raisePreSale)); //ensure day 1 cap, which is lower by the amount we pre-sold\n', '        }\n', '        else if (current_state == State.Day2)\n', '        {\n', '            raiseDay2 = safeAdd(raiseDay2, usdCentsRaise); //add current raise to pre-sell amount\n', '            require(raiseDay2 < capDay2); //ensure day 2 cap\n', '        }\n', '        else if (current_state == State.Day3)\n', '        {\n', '            raiseDay3 = safeAdd(raiseDay3, usdCentsRaise); //add current raise to pre-sell amount\n', '            require(raiseDay3 < capDay3); //ensure day 3 cap\n', '        }\n', '        else revert();\n', '\n', '        uint tokens = safeDiv(msg.value, getTokenPriceInWEI()); // Calculate number of tokens to be paid out\n', '        uint bonus = safeDiv(safeMul(tokens, getCurrentBonusInPercent()), 100); // Calculate number of bonus tokens\n', '\n', '        if (current_state == State.PreSale) {\n', '            // Remove the extra 5% from the totalTokensCompany, in order to keep the 550m on track.\n', '            totalTokensCompany = safeSub(totalTokensCompany, safeDiv(bonus, 4));\n', '        }\n', '\n', '        uint totalTokens = safeAdd(tokens, bonus);\n', '\n', '        balances[recipient] = safeAdd(balances[recipient], totalTokens);\n', '        totalSupply = safeAdd(totalSupply, totalTokens);\n', '\n', '        deposit.transfer(msg.value); // Send deposited Ether to the deposit address on file.\n', '\n', '        Buy(recipient, msg.value, totalTokens);\n', '    }\n', '\n', '    /*\n', '        Allocate reserved and founders tokens based on the running time and state of the contract.\n', '     */\n', '    function allocateReserveAndFounderTokens() {\n', '        require(msg.sender==founder);\n', '        require(getCurrentState() == State.Running);\n', '        uint tokens = 0;\n', '\n', '        if(block.timestamp > saleEnd && !allocatedFounders)\n', '        {\n', '            allocatedFounders = true;\n', '            tokens = totalTokensCompany;\n', '            balances[founder] = safeAdd(balances[founder], tokens);\n', '            totalSupply = safeAdd(totalSupply, tokens);\n', '        }\n', '        else if(block.timestamp > year1Unlock && !allocated1Year)\n', '        {\n', '            allocated1Year = true;\n', '            tokens = safeDiv(totalTokensReserve, 4);\n', '            balances[founder] = safeAdd(balances[founder], tokens);\n', '            totalSupply = safeAdd(totalSupply, tokens);\n', '        }\n', '        else if(block.timestamp > year2Unlock && !allocated2Year)\n', '        {\n', '            allocated2Year = true;\n', '            tokens = safeDiv(totalTokensReserve, 4);\n', '            balances[founder] = safeAdd(balances[founder], tokens);\n', '            totalSupply = safeAdd(totalSupply, tokens);\n', '        }\n', '        else if(block.timestamp > year3Unlock && !allocated3Year)\n', '        {\n', '            allocated3Year = true;\n', '            tokens = safeDiv(totalTokensReserve, 4);\n', '            balances[founder] = safeAdd(balances[founder], tokens);\n', '            totalSupply = safeAdd(totalSupply, tokens);\n', '        }\n', '        else if(block.timestamp > year4Unlock && !allocated4Year)\n', '        {\n', '            allocated4Year = true;\n', '            tokens = safeDiv(totalTokensReserve, 4);\n', '            balances[founder] = safeAdd(balances[founder], tokens);\n', '            totalSupply = safeAdd(totalSupply, tokens);\n', '        }\n', '        else revert();\n', '\n', '        AllocateTokens(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * Emergency Stop ICO.\n', '     *\n', '     *  Applicable tests:\n', '     *\n', '     * - Test unhalting, buying, and succeeding\n', '     */\n', '    function halt() {\n', '        require(msg.sender==founder);\n', '        halted = true;\n', '    }\n', '\n', '    function unhalt() {\n', '        require(msg.sender==founder);\n', '        halted = false;\n', '    }\n', '\n', '    /*\n', '        Change founder address (Controlling address for contract)\n', '    */\n', '    function changeFounder(address newFounder) {\n', '        require(msg.sender==founder);\n', '        founder = newFounder;\n', '    }\n', '\n', '    /*\n', '        Change deposit address (Address to which funds are deposited)\n', '    */\n', '    function changeDeposit(address newDeposit) {\n', '        require(msg.sender==founder);\n', '        deposit = newDeposit;\n', '    }\n', '\n', '    /*\n', '        Add people to the pre-sale whitelist\n', '        Amount should be the value in USD that the purchaser is allowed to buy\n', '        IE: 100 is $100 is 10000 cents.  The correct value to enter is 100\n', '    */\n', '    function addPresaleWhitelist(address toWhitelist, uint256 amount){\n', '        require(msg.sender==founder && amount > 0);\n', '        presaleWhitelist[toWhitelist] = amount * 100;\n', '    }\n', '\n', '    /**\n', '     * ERC 20 Standard Token interface transfer function\n', '     *\n', '     * Prevent transfers until freeze period is over.\n', '     *\n', '     * Applicable tests:\n', '     *\n', '     * - Test restricted early transfer\n', '     * - Test transfer after restricted period\n', '     */\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        require(block.timestamp > coinTradeStart);\n', '        return super.transfer(_to, _value);\n', '    }\n', '    /**\n', '     * ERC 20 Standard Token interface transfer function\n', '     *\n', '     * Prevent transfers until freeze period is over.\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        require(block.timestamp > coinTradeStart);\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function() payable {\n', '        buyRecipient(msg.sender);\n', '    }\n', '\n', '}']
