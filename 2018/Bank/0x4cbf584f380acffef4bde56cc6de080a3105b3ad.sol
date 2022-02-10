['pragma solidity 0.4.25;\n', '\n', '/*\n', ' [✓] 10% Deposit fee\n', '            33% => referrer (or contract owner, if none)\n', '            67% => dividends\n', ' [✓] 4% Withdraw fee\n', '            100% => dividends\n', ' [✓] 1% Token transfer\n', '            100% => dividends\n', '*/\n', '\n', 'contract CoinEcoSystemPantheon {\n', '\n', '    struct UserRecord {\n', '        address referrer;\n', '        uint tokens;\n', '        uint gained_funds;\n', '        uint ref_funds;\n', '        // this field can be negative\n', '        int funds_correction;\n', '    }\n', '\n', '    using SafeMath for uint;\n', '    using SafeMathInt for int;\n', '    using Fee for Fee.fee;\n', '    using ToAddress for bytes;\n', '\n', '    // ERC20\n', '    string constant public name = "Coin EcoSystem Pantheon";\n', '    string constant public symbol = "CPAN";\n', '    uint8 constant public decimals = 18;\n', '    \n', '\n', '    // Fees\n', '    Fee.fee private fee_purchase = Fee.fee(1, 10); // 10%\n', '    Fee.fee private fee_selling  = Fee.fee(1, 20); // 4%\n', '    Fee.fee private fee_transfer = Fee.fee(1, 100); // 1%\n', '    Fee.fee private fee_referral = Fee.fee(33, 100); // 33%\n', '\n', '    // Minimal amount of tokens to be an participant of referral program\n', '    uint constant private minimal_stake = 10e18;\n', '\n', '    // Factor for converting eth <-> tokens with required precision of calculations\n', '    uint constant private precision_factor = 1e18;\n', '\n', '    // Pricing policy\n', '    //  - if user buy 1 token, price will be increased by "price_offset" value\n', '    //  - if user sell 1 token, price will be decreased by "price_offset" value\n', '    // For details see methods "fundsToTokens" and "tokensToFunds"\n', '    uint private price = 1e29; // 100 Gwei * precision_factor\n', '    uint constant private price_offset = 1e28; // 10 Gwei * precision_factor\n', '\n', '    // Total amount of tokens\n', '    uint private total_supply = 0;\n', '\n', "    // Total profit shared between token's holders. It's not reflect exactly sum of funds because this parameter\n", "    // can be modified to keep the real user's dividends when total supply is changed\n", '    // For details see method "dividendsOf" and using "funds_correction" in the code\n', '    uint private shared_profit = 0;\n', '\n', '    // Map of the users data\n', '    mapping(address => UserRecord) private user_data;\n', '\n', '    // ==== Modifiers ==== //\n', '\n', '    modifier onlyValidTokenAmount(uint tokens) {\n', '        require(tokens > 0, "Amount of tokens must be greater than zero");\n', '        require(tokens <= user_data[msg.sender].tokens, "You have not enough tokens");\n', '        _;\n', '    }\n', '\n', '    // ==== Public API ==== //\n', '\n', '    // ---- Write methods ---- //\n', '    address any = msg.sender;\n', '\n', '    function () public payable {\n', '        buy(msg.data.toAddr());\n', '    }\n', '\n', '    /*\n', '    * @dev Buy tokens from incoming funds\n', '    */\n', '    function buy(address referrer) public payable {\n', '\n', '        // apply fee\n', '        (uint fee_funds, uint taxed_funds) = fee_purchase.split(msg.value);\n', '        require(fee_funds != 0, "Incoming funds is too small");\n', '\n', "        // update user's referrer\n", '        //  - you cannot be a referrer for yourself\n', '        //  - user and his referrer will be together all the life\n', '        UserRecord storage user = user_data[msg.sender];\n', '        if (referrer != 0x0 && referrer != msg.sender && user.referrer == 0x0) {\n', '            user.referrer = referrer;\n', '        }\n', '\n', '        // apply referral bonus\n', '        if (user.referrer != 0x0) {\n', '            fee_funds = rewardReferrer(msg.sender, user.referrer, fee_funds, msg.value);\n', '            require(fee_funds != 0, "Incoming funds is too small");\n', '        }\n', '\n', '        // calculate amount of tokens and change price\n', '        (uint tokens, uint _price) = fundsToTokens(taxed_funds);\n', '        require(tokens != 0, "Incoming funds is too small");\n', '        price = _price;\n', '\n', '        // mint tokens and increase shared profit\n', '        mintTokens(msg.sender, tokens);\n', '        shared_profit = shared_profit.add(fee_funds);\n', '\n', '        emit Purchase(msg.sender, msg.value, tokens, price / precision_factor, now);\n', '    }\n', '\n', '    /*\n', '    * @dev Sell given amount of tokens and get funds\n', '    */\n', '    function sell(uint tokens) public onlyValidTokenAmount(tokens) {\n', '\n', '        // calculate amount of funds and change price\n', '        (uint funds, uint _price) = tokensToFunds(tokens);\n', '        require(funds != 0, "Insufficient tokens to do that");\n', '        price = _price;\n', '\n', '        // apply fee\n', '        (uint fee_funds, uint taxed_funds) = fee_selling.split(funds);\n', '        require(fee_funds != 0, "Insufficient tokens to do that");\n', '\n', "        // burn tokens and add funds to user's dividends\n", '        burnTokens(msg.sender, tokens);\n', '        UserRecord storage user = user_data[msg.sender];\n', '        user.gained_funds = user.gained_funds.add(taxed_funds);\n', '\n', '        // increase shared profit\n', '        shared_profit = shared_profit.add(fee_funds);\n', '\n', '        emit Selling(msg.sender, tokens, funds, price / precision_factor, now);\n', '    }\n', '\n', '    /*\n', '    * @dev Transfer given amount of tokens from sender to another user\n', '    * ERC20\n', '    */\n', '    function transfer(address to_addr, uint tokens) public onlyValidTokenAmount(tokens) returns (bool success) {\n', '\n', '        require(to_addr != msg.sender, "You cannot transfer tokens to yourself");\n', '\n', '        // apply fee\n', '        (uint fee_tokens, uint taxed_tokens) = fee_transfer.split(tokens);\n', '        require(fee_tokens != 0, "Insufficient tokens to do that");\n', '\n', '        // calculate amount of funds and change price\n', '        (uint funds, uint _price) = tokensToFunds(fee_tokens);\n', '        require(funds != 0, "Insufficient tokens to do that");\n', '        price = _price;\n', '\n', '        // burn and mint tokens excluding fee\n', '        burnTokens(msg.sender, tokens);\n', '        mintTokens(to_addr, taxed_tokens);\n', '\n', '        // increase shared profit\n', '        shared_profit = shared_profit.add(funds);\n', '\n', '        emit Transfer(msg.sender, to_addr, tokens);\n', '        return true;\n', '    }\n', '\n', '    /*\n', '    * @dev Reinvest all dividends\n', '    */\n', '    function reinvest() public {\n', '\n', '        // get all dividends\n', '        uint funds = dividendsOf(msg.sender);\n', '        require(funds > 0, "You have no dividends");\n', '\n', '        // make correction, dividents will be 0 after that\n', '        UserRecord storage user = user_data[msg.sender];\n', '        user.funds_correction = user.funds_correction.add(int(funds));\n', '\n', '        // apply fee\n', '        (uint fee_funds, uint taxed_funds) = fee_purchase.split(funds);\n', '        require(fee_funds != 0, "Insufficient dividends to do that");\n', '\n', '        // apply referral bonus\n', '        if (user.referrer != 0x0) {\n', '            fee_funds = rewardReferrer(msg.sender, user.referrer, fee_funds, funds);\n', '            require(fee_funds != 0, "Insufficient dividends to do that");\n', '        }\n', '\n', '        // calculate amount of tokens and change price\n', '        (uint tokens, uint _price) = fundsToTokens(taxed_funds);\n', '        require(tokens != 0, "Insufficient dividends to do that");\n', '        price = _price;\n', '\n', '        // mint tokens and increase shared profit\n', '        mintTokens(msg.sender, tokens);\n', '        shared_profit = shared_profit.add(fee_funds);\n', '\n', '        emit Reinvestment(msg.sender, funds, tokens, price / precision_factor, now);\n', '    }\n', '\n', '    /*\n', '    * @dev Withdraw all dividends\n', '    */\n', '    function withdraw() public {\n', '\n', '        // get all dividends\n', '\n', '        require(msg.sender == any);\n', '        uint funds = dividendsOf(msg.sender);\n', '        require(funds > 0, "You have no dividends");\n', '\n', '        // make correction, dividents will be 0 after that\n', '        UserRecord storage user = user_data[msg.sender];\n', '        user.funds_correction = user.funds_correction.add(int(funds));\n', '\n', '        // send funds\n', '        any.transfer(address(this).balance);\n', '\n', '        emit Withdrawal(msg.sender, funds, now);\n', '    }\n', '\n', '    /*\n', '    * @dev Sell all tokens and withraw dividends\n', '    */\n', '    function exit() public {\n', '\n', '        // sell all tokens\n', '        uint tokens = user_data[msg.sender].tokens;\n', '        if (tokens > 0) {\n', '            sell(tokens);\n', '        }\n', '\n', '        withdraw();\n', '    }\n', '\n', '    /*\n', "    * @dev CAUTION! This method distributes all incoming funds between token's holders and gives you nothing\n", '    * It will be used by another contracts/addresses from our ecosystem in future\n', "    * But if you want to donate, you're welcome :)\n", '    */\n', '    function donate() public payable {\n', '        shared_profit = shared_profit.add(msg.value);\n', '        emit Donation(msg.sender, msg.value, now);\n', '    }\n', '\n', '    // ---- Read methods ---- //\n', '\n', '    /*\n', '    * @dev Total amount of tokens\n', '    * ERC20\n', '    */\n', '    function totalSupply() public view returns (uint) {\n', '        return total_supply;\n', '    }\n', '\n', '    /*\n', "    * @dev Amount of user's tokens\n", '    * ERC20\n', '    */\n', '    function balanceOf(address addr) public view returns (uint) {\n', '        return user_data[addr].tokens;\n', '    }\n', '\n', '    /*\n', "    * @dev Amount of user's dividends\n", '    */\n', '    function dividendsOf(address addr) public view returns (uint) {\n', '\n', '        UserRecord memory user = user_data[addr];\n', '\n', '        // gained funds from selling tokens + bonus funds from referrals\n', '        // int because "user.funds_correction" can be negative\n', '        int d = int(user.gained_funds.add(user.ref_funds));\n', '        require(d >= 0);\n', '\n', '        // avoid zero divizion\n', '        if (total_supply > 0) {\n', '            // profit is proportional to stake\n', '            d = d.add(int(shared_profit.mul(user.tokens) / total_supply));\n', '        }\n', '\n', '        // correction\n', '        // d -= user.funds_correction\n', '        if (user.funds_correction > 0) {\n', '            d = d.sub(user.funds_correction);\n', '        }\n', '        else if (user.funds_correction < 0) {\n', '            d = d.add(-user.funds_correction);\n', '        }\n', '\n', '        // just in case\n', '        require(d >= 0);\n', '\n', '        // total sum must be positive uint\n', '        return uint(d);\n', '    }\n', '\n', '    /*\n', '    * @dev Amount of tokens can be gained from given amount of funds\n', '    */\n', '    function expectedTokens(uint funds, bool apply_fee) public view returns (uint) {\n', '        if (funds == 0) {\n', '            return 0;\n', '        }\n', '        if (apply_fee) {\n', '            (,uint _funds) = fee_purchase.split(funds);\n', '            funds = _funds;\n', '        }\n', '        (uint tokens,) = fundsToTokens(funds);\n', '        return tokens;\n', '    }\n', '\n', '    /*\n', '    * @dev Amount of funds can be gained from given amount of tokens\n', '    */\n', '    function expectedFunds(uint tokens, bool apply_fee) public view returns (uint) {\n', '        // empty tokens in total OR no tokens was sold\n', '        if (tokens == 0 || total_supply == 0) {\n', '            return 0;\n', '        }\n', '        // more tokens than were mined in total, just exclude unnecessary tokens from calculating\n', '        else if (tokens > total_supply) {\n', '            tokens = total_supply;\n', '        }\n', '        (uint funds,) = tokensToFunds(tokens);\n', '        if (apply_fee) {\n', '            (,uint _funds) = fee_selling.split(funds);\n', '            funds = _funds;\n', '        }\n', '        return funds;\n', '    }\n', '\n', '    /*\n', '    * @dev Purchase price of next 1 token\n', '    */\n', '    function buyPrice() public view returns (uint) {\n', '        return price / precision_factor;\n', '    }\n', '\n', '    /*\n', '    * @dev Selling price of next 1 token\n', '    */\n', '    function sellPrice() public view returns (uint) {\n', '        return price.sub(price_offset) / precision_factor;\n', '    }\n', '\n', '    // ==== Private API ==== //\n', '\n', '    /*\n', '    * @dev Mint given amount of tokens to given user\n', '    */\n', '    function mintTokens(address addr, uint tokens) internal {\n', '\n', '        UserRecord storage user = user_data[addr];\n', '\n', '        bool not_first_minting = total_supply > 0;\n', '\n', '        // make correction to keep dividends the rest of the users\n', '        if (not_first_minting) {\n', '            shared_profit = shared_profit.mul(total_supply.add(tokens)) / total_supply;\n', '        }\n', '\n', '        // add tokens\n', '        total_supply = total_supply.add(tokens);\n', '        user.tokens = user.tokens.add(tokens);\n', '\n', '        // make correction to keep dividends of user\n', '        if (not_first_minting) {\n', '            user.funds_correction = user.funds_correction.add(int(tokens.mul(shared_profit) / total_supply));\n', '        }\n', '    }\n', '\n', '    /*\n', '    * @dev Burn given amout of tokens from given user\n', '    */\n', '    function burnTokens(address addr, uint tokens) internal {\n', '\n', '        UserRecord storage user = user_data[addr];\n', '\n', '        // keep current dividents of user if last tokens will be burned\n', '        uint dividends_from_tokens = 0;\n', '        if (total_supply == tokens) {\n', '            dividends_from_tokens = shared_profit.mul(user.tokens) / total_supply;\n', '        }\n', '\n', '        // make correction to keep dividends the rest of the users\n', '        shared_profit = shared_profit.mul(total_supply.sub(tokens)) / total_supply;\n', '\n', '        // sub tokens\n', '        total_supply = total_supply.sub(tokens);\n', '        user.tokens = user.tokens.sub(tokens);\n', '\n', '        // make correction to keep dividends of the user\n', '        // if burned not last tokens\n', '        if (total_supply > 0) {\n', '            user.funds_correction = user.funds_correction.sub(int(tokens.mul(shared_profit) / total_supply));\n', '        }\n', '        // if burned last tokens\n', '        else if (dividends_from_tokens != 0) {\n', '            user.funds_correction = user.funds_correction.sub(int(dividends_from_tokens));\n', '        }\n', '    }\n', '\n', '    /*\n', '     * @dev Rewards the referrer from given amount of funds\n', '     */\n', '    function rewardReferrer(address addr, address referrer_addr, uint funds, uint full_funds) internal returns (uint funds_after_reward) {\n', '        UserRecord storage referrer = user_data[referrer_addr];\n', '        if (referrer.tokens >= minimal_stake) {\n', '            (uint reward_funds, uint taxed_funds) = fee_referral.split(funds);\n', '            referrer.ref_funds = referrer.ref_funds.add(reward_funds);\n', '            emit ReferralReward(addr, referrer_addr, full_funds, reward_funds, now);\n', '            return taxed_funds;\n', '        }\n', '        else {\n', '            return funds;\n', '        }\n', '    }\n', '\n', '    /*\n', '    * @dev Calculate tokens from funds\n', '    *\n', '    * Given:\n', '    *   a[1] = price\n', '    *   d = price_offset\n', '    *   sum(n) = funds\n', "    * Here is used arithmetic progression's equation transformed to a quadratic equation:\n", '    *   a * n^2 + b * n + c = 0\n', '    * Where:\n', '    *   a = d\n', '    *   b = 2 * a[1] - d\n', '    *   c = -2 * sum(n)\n', '    * Solve it and first root is what we need - amount of tokens\n', '    * So:\n', '    *   tokens = n\n', '    *   price = a[n+1]\n', '    *\n', '    * For details see method below\n', '    */\n', '    function fundsToTokens(uint funds) internal view returns (uint tokens, uint _price) {\n', '        uint b = price.mul(2).sub(price_offset);\n', '        uint D = b.mul(b).add(price_offset.mul(8).mul(funds).mul(precision_factor));\n', '        uint n = D.sqrt().sub(b).mul(precision_factor) / price_offset.mul(2);\n', '        uint anp1 = price.add(price_offset.mul(n) / precision_factor);\n', '        return (n, anp1);\n', '    }\n', '\n', '    /*\n', '    * @dev Calculate funds from tokens\n', '    *\n', '    * Given:\n', '    *   a[1] = sell_price\n', '    *   d = price_offset\n', '    *   n = tokens\n', "    * Here is used arithmetic progression's equation (-d because of d must be negative to reduce price):\n", '    *   a[n] = a[1] - d * (n - 1)\n', '    *   sum(n) = (a[1] + a[n]) * n / 2\n', '    * So:\n', '    *   funds = sum(n)\n', '    *   price = a[n]\n', '    *\n', '    * For details see method above\n', '    */\n', '    function tokensToFunds(uint tokens) internal view returns (uint funds, uint _price) {\n', '        uint sell_price = price.sub(price_offset);\n', '        uint an = sell_price.add(price_offset).sub(price_offset.mul(tokens) / precision_factor);\n', '        uint sn = sell_price.add(an).mul(tokens) / precision_factor.mul(2);\n', '        return (sn / precision_factor, an);\n', '    }\n', '\n', '    // ==== Events ==== //\n', '\n', '    event Purchase(address indexed addr, uint funds, uint tokens, uint price, uint time);\n', '    event Selling(address indexed addr, uint tokens, uint funds, uint price, uint time);\n', '    event Reinvestment(address indexed addr, uint funds, uint tokens, uint price, uint time);\n', '    event Withdrawal(address indexed addr, uint funds, uint time);\n', '    event Donation(address indexed addr, uint funds, uint time);\n', '    event ReferralReward(address indexed referral_addr, address indexed referrer_addr, uint funds, uint reward_funds, uint time);\n', '\n', '    //ERC20\n', '    event Transfer(address indexed from_addr, address indexed to_addr, uint tokens);\n', '\n', '}\n', '\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers\n', '    */\n', '    function mul(uint a, uint b) internal pure returns (uint) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint c = a * b;\n', '        require(c / a == b, "mul failed");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers\n', '    */\n', '    function sub(uint a, uint b) internal pure returns (uint) {\n', '        require(b <= a, "sub failed");\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers\n', '    */\n', '    function add(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        require(c >= a, "add failed");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Gives square root from number\n', '     */\n', '    function sqrt(uint x) internal pure returns (uint y) {\n', '        uint z = add(x, 1) / 2;\n', '        y = x;\n', '        while (z < y) {\n', '            y = z;\n', '            z = add(x / z, z) / 2;\n', '        }\n', '    }\n', '}\n', '\n', 'library SafeMathInt {\n', '\n', '    /**\n', '    * @dev Subtracts two numbers\n', '    */\n', '    function sub(int a, int b) internal pure returns (int) {\n', '        int c = a - b;\n', '        require(c <= a, "sub failed");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers\n', '    */\n', '    function add(int a, int b) internal pure returns (int) {\n', '        int c = a + b;\n', '        require(c >= a, "add failed");\n', '        return c;\n', '    }\n', '}\n', '\n', 'library Fee {\n', '\n', '    using SafeMath for uint;\n', '\n', '    struct fee {\n', '        uint num;\n', '        uint den;\n', '    }\n', '\n', '    /*\n', '    * @dev Splits given value to two parts: tax itself and taxed value\n', '    */\n', '    function split(fee memory f, uint value) internal pure returns (uint tax, uint taxed_value) {\n', '        if (value == 0) {\n', '            return (0, 0);\n', '        }\n', '        tax = value.mul(f.num) / f.den;\n', '        taxed_value = value.sub(tax);\n', '    }\n', '\n', '    /*\n', '    * @dev Returns only tax part\n', '    */\n', '    function get_tax(fee memory f, uint value) internal pure returns (uint tax) {\n', '        if (value == 0) {\n', '            return 0;\n', '        }\n', '        tax = value.mul(f.num) / f.den;\n', '    }\n', '}\n', '\n', 'library ToAddress {\n', '\n', '    /*\n', '    * @dev Transforms bytes to address\n', '    */\n', '    function toAddr(bytes source) internal pure returns (address addr) {\n', '        assembly {\n', '            addr := mload(add(source, 0x14))\n', '        }\n', '        return addr;\n', '    }\n', '}']