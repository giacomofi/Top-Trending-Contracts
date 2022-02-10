['pragma solidity ^0.4.23;\n', '\n', 'contract token {\n', '    function transferFrom(address sender, address receiver, uint amount) returns(bool success) {}\n', '    function burn() {}\n', '}\n', '\n', 'library SafeMath {\n', '    function mul(uint a, uint b) internal returns (uint) {\n', '        uint c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function sub(uint a, uint b) internal returns (uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint a, uint b) internal returns (uint) {\n', '        uint c = a + b;\n', '        assert(c >= a && c >= b);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract EphronIndiaCoinICO {\n', '    using SafeMath for uint;\n', '    // The maximum amount of tokens to be sold\n', '    uint constant public maxGoal = 900000; // 275 Milion CoinPoker Tokens\n', '    // There are different prices and amount available in each period\n', '    uint public prices = 100000; // 1ETH = 4200CHP, 1ETH = 3500CHP\n', '    uint public amount_stages = 27500; // the amount stages for different prices\n', '    // How much has been raised by crowdsale (in ETH)\n', '    uint public amountRaised;\n', '    // The number of tokens already sold\n', '    uint public tokensSold = 0;\n', '    // The start date of the crowdsale\n', '    uint constant public start = 1526470200; // Friday, 19 January 2018 10:00:00 GMT\n', '    // The end date of the crowdsale\n', '    uint constant public end = 1531675800; // Friday, 26 January 2018 10:00:00 GMT\n', '    // The balances (in ETH) of all token holders\n', '    mapping(address => uint) public balances;\n', '    // Indicates if the crowdsale has been ended already\n', '    bool public crowdsaleEnded = false;\n', '    // Tokens will be transfered from this address\n', '    address public tokenOwner;\n', '    // The address of the token contract\n', '    token public tokenReward;\n', '    // The wallet on which the funds will be stored\n', '    address wallet;\n', '    // Notifying transfers and the success of the crowdsale\n', '    event Finalize(address _tokenOwner, uint _amountRaised);\n', '    event FundTransfer(address backer, uint amount, bool isContribution, uint _amountRaised);\n', '\n', '    // ---- FOR TEST ONLY ----\n', '    uint _current = 0;\n', '    function current() public returns (uint) {\n', '        // Override not in use\n', '        if(_current == 0) {\n', '            return now;\n', '        }\n', '        return _current;\n', '    }\n', '    function setCurrent(uint __current) {\n', '        _current = __current;\n', '    }\n', '    //------------------------\n', '\n', '    // Constructor/initialization\n', '    function EphronIndiaCoinICO(address tokenAddr, address walletAddr, address tokenOwnerAddr) {\n', '        tokenReward = token(tokenAddr);\n', '        wallet = walletAddr;\n', '        tokenOwner = tokenOwnerAddr;\n', '    }\n', '\n', '    // Exchange CHP by sending ether to the contract.\n', '    function() payable {\n', '        if (msg.sender != wallet) // Do not trigger exchange if the wallet is returning the funds\n', '            exchange(msg.sender);\n', '    }\n', '\n', '    // Make an exchangement. Only callable if the crowdsale started and hasn&#39;t been ended, also the maxGoal wasn&#39;t reached yet.\n', '    // The current token price is looked up by available amount. Bought tokens is transfered to the receiver.\n', '    // The sent value is directly forwarded to a safe wallet.\n', '    function exchange(address receiver) payable {\n', '        uint amount = msg.value;\n', '        uint price = getPrice();\n', '        uint numTokens = amount.mul(price);\n', '\n', '        require(numTokens > 0);\n', '        require(!crowdsaleEnded && current() >= start && current() <= end && tokensSold.add(numTokens) <= maxGoal);\n', '\n', '        wallet.transfer(amount);\n', '        balances[receiver] = balances[receiver].add(amount);\n', '\n', '        // Calculate how much raised and tokens sold\n', '        amountRaised = amountRaised.add(amount);\n', '        tokensSold = tokensSold.add(numTokens);\n', '\n', '        assert(tokenReward.transferFrom(tokenOwner, receiver, numTokens));\n', '        FundTransfer(receiver, amount, true, amountRaised);\n', '    }\n', '    \n', '     // Looks up the current token price\n', '    function getPrice() constant returns (uint price) {\n', '        return prices;\n', '    }\n', '\n', '    // Manual exchange tokens for BTC,LTC,Fiat contributions.\n', '    // @param receiver who tokens will go to.\n', '    // @param value an amount of tokens.\n', '    function manualExchange(address receiver, uint value) {\n', '        require(msg.sender == tokenOwner);\n', '        require(tokensSold.add(value) <= maxGoal);\n', '        tokensSold = tokensSold.add(value);\n', '        assert(tokenReward.transferFrom(tokenOwner, receiver, value));\n', '    }\n', '\n', '   \n', '\n', '    modifier afterDeadline() { if (current() >= end) _; }\n', '\n', '    // Checks if the goal or time limit has been reached and ends the campaign\n', '    function finalize() afterDeadline {\n', '        require(!crowdsaleEnded);\n', '        tokenReward.burn(); // Burn remaining tokens but the reserved ones\n', '        Finalize(tokenOwner, amountRaised);\n', '        crowdsaleEnded = true;\n', '    }\n', '\n', '    // Allows the funders to withdraw their funds if the goal has not been reached.\n', '    // Only works after funds have been returned from the wallet.\n', '    function safeWithdrawal() afterDeadline {\n', '        uint amount = balances[msg.sender];\n', '        if (address(this).balance >= amount) {\n', '            balances[msg.sender] = 0;\n', '            if (amount > 0) {\n', '                msg.sender.transfer(amount);\n', '                FundTransfer(msg.sender, amount, false, amountRaised);\n', '            }\n', '        }\n', '    }\n', '}']
['pragma solidity ^0.4.23;\n', '\n', 'contract token {\n', '    function transferFrom(address sender, address receiver, uint amount) returns(bool success) {}\n', '    function burn() {}\n', '}\n', '\n', 'library SafeMath {\n', '    function mul(uint a, uint b) internal returns (uint) {\n', '        uint c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function sub(uint a, uint b) internal returns (uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint a, uint b) internal returns (uint) {\n', '        uint c = a + b;\n', '        assert(c >= a && c >= b);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract EphronIndiaCoinICO {\n', '    using SafeMath for uint;\n', '    // The maximum amount of tokens to be sold\n', '    uint constant public maxGoal = 900000; // 275 Milion CoinPoker Tokens\n', '    // There are different prices and amount available in each period\n', '    uint public prices = 100000; // 1ETH = 4200CHP, 1ETH = 3500CHP\n', '    uint public amount_stages = 27500; // the amount stages for different prices\n', '    // How much has been raised by crowdsale (in ETH)\n', '    uint public amountRaised;\n', '    // The number of tokens already sold\n', '    uint public tokensSold = 0;\n', '    // The start date of the crowdsale\n', '    uint constant public start = 1526470200; // Friday, 19 January 2018 10:00:00 GMT\n', '    // The end date of the crowdsale\n', '    uint constant public end = 1531675800; // Friday, 26 January 2018 10:00:00 GMT\n', '    // The balances (in ETH) of all token holders\n', '    mapping(address => uint) public balances;\n', '    // Indicates if the crowdsale has been ended already\n', '    bool public crowdsaleEnded = false;\n', '    // Tokens will be transfered from this address\n', '    address public tokenOwner;\n', '    // The address of the token contract\n', '    token public tokenReward;\n', '    // The wallet on which the funds will be stored\n', '    address wallet;\n', '    // Notifying transfers and the success of the crowdsale\n', '    event Finalize(address _tokenOwner, uint _amountRaised);\n', '    event FundTransfer(address backer, uint amount, bool isContribution, uint _amountRaised);\n', '\n', '    // ---- FOR TEST ONLY ----\n', '    uint _current = 0;\n', '    function current() public returns (uint) {\n', '        // Override not in use\n', '        if(_current == 0) {\n', '            return now;\n', '        }\n', '        return _current;\n', '    }\n', '    function setCurrent(uint __current) {\n', '        _current = __current;\n', '    }\n', '    //------------------------\n', '\n', '    // Constructor/initialization\n', '    function EphronIndiaCoinICO(address tokenAddr, address walletAddr, address tokenOwnerAddr) {\n', '        tokenReward = token(tokenAddr);\n', '        wallet = walletAddr;\n', '        tokenOwner = tokenOwnerAddr;\n', '    }\n', '\n', '    // Exchange CHP by sending ether to the contract.\n', '    function() payable {\n', '        if (msg.sender != wallet) // Do not trigger exchange if the wallet is returning the funds\n', '            exchange(msg.sender);\n', '    }\n', '\n', "    // Make an exchangement. Only callable if the crowdsale started and hasn't been ended, also the maxGoal wasn't reached yet.\n", '    // The current token price is looked up by available amount. Bought tokens is transfered to the receiver.\n', '    // The sent value is directly forwarded to a safe wallet.\n', '    function exchange(address receiver) payable {\n', '        uint amount = msg.value;\n', '        uint price = getPrice();\n', '        uint numTokens = amount.mul(price);\n', '\n', '        require(numTokens > 0);\n', '        require(!crowdsaleEnded && current() >= start && current() <= end && tokensSold.add(numTokens) <= maxGoal);\n', '\n', '        wallet.transfer(amount);\n', '        balances[receiver] = balances[receiver].add(amount);\n', '\n', '        // Calculate how much raised and tokens sold\n', '        amountRaised = amountRaised.add(amount);\n', '        tokensSold = tokensSold.add(numTokens);\n', '\n', '        assert(tokenReward.transferFrom(tokenOwner, receiver, numTokens));\n', '        FundTransfer(receiver, amount, true, amountRaised);\n', '    }\n', '    \n', '     // Looks up the current token price\n', '    function getPrice() constant returns (uint price) {\n', '        return prices;\n', '    }\n', '\n', '    // Manual exchange tokens for BTC,LTC,Fiat contributions.\n', '    // @param receiver who tokens will go to.\n', '    // @param value an amount of tokens.\n', '    function manualExchange(address receiver, uint value) {\n', '        require(msg.sender == tokenOwner);\n', '        require(tokensSold.add(value) <= maxGoal);\n', '        tokensSold = tokensSold.add(value);\n', '        assert(tokenReward.transferFrom(tokenOwner, receiver, value));\n', '    }\n', '\n', '   \n', '\n', '    modifier afterDeadline() { if (current() >= end) _; }\n', '\n', '    // Checks if the goal or time limit has been reached and ends the campaign\n', '    function finalize() afterDeadline {\n', '        require(!crowdsaleEnded);\n', '        tokenReward.burn(); // Burn remaining tokens but the reserved ones\n', '        Finalize(tokenOwner, amountRaised);\n', '        crowdsaleEnded = true;\n', '    }\n', '\n', '    // Allows the funders to withdraw their funds if the goal has not been reached.\n', '    // Only works after funds have been returned from the wallet.\n', '    function safeWithdrawal() afterDeadline {\n', '        uint amount = balances[msg.sender];\n', '        if (address(this).balance >= amount) {\n', '            balances[msg.sender] = 0;\n', '            if (amount > 0) {\n', '                msg.sender.transfer(amount);\n', '                FundTransfer(msg.sender, amount, false, amountRaised);\n', '            }\n', '        }\n', '    }\n', '}']
