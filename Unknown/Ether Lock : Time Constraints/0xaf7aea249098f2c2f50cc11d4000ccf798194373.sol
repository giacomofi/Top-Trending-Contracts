['pragma solidity ^0.4.15;\n', '\n', '/*\n', '- The ZTT pre-sale will last between September 5 to 15 with a 5% bonus payable in ZTT on all purchases.\n', '- The ICO is expected to start September 15, 2017, and run for exactly 30 days.\n', '- The PreICO price is 290ZTT/ETH. Bonus of 25 ZTT on the first day. The first week price is 250 ZTT/ETH. The price then increases approximately 26%/week and 3.6%/raised ZTT in multiples of minimum amount to be raised. In the first day, price is 275 - times funds raised discount factor. In first, second, third and fourth week, price is 250, 198, 157, 125 respectively times discount factor. The discount factor for each successive multiple (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, etc) of the minimum funds raised so far, of 1, .966, .933, .901, .871, .841, .812, .785, .758, .732, .707, etc.\n', '- Tradable when issued to the public for consideration, after the ICO closes.\n', '- Dividends of 4% per annum are payable as increased territory size\n', '- Deputy Mayor crypto-currency governance role.\n', '- Democratic governance applies to traffic congestion. All crowd funders who own ZTT coins are "Deputy Mayors" of their district below and may democratically advise ZeroTraffic on congested areas in their district on a regular basis. District maybe re-centered.\n', '- Coins are optionally retractable and redeemable by ZeroTraffic, individually from each owner any time after 5 years after IOD. Once an owner is exchanged, the market price average for the last 5 days shall be used to compute payment.\n', '- At least 1250 ZTTs&#39; are required to fill the role of Deputy Mayor.\n', '- Price per each non-exclusive circle of radius 1/2 km, around any ZTT coin owner specified GPS point, for a map of traffic standstill congestion management advice = (1250 ZTT). Additional size regions are priced for a R&#39; km radius at (R&#39;/R)**2 *price for 1/2km radius in ZTT coin.\n', '- To be exempt from securities laws, there is no share ownership to ZTT coin holders, right to dividends, proceeds from sales. The parties agree that the Howey test is not met: "investment of money from an expectation of profits arising from a common enterprise depending solely on the efforts of a promoter or third party". Proceeds will fund initial and continuing development and business development, depending on level of funds raised, for several years.\n', '- Funds raised in ICO are refundable if minimum isn&#39;t met during ICO and presale, however funds raised during the PreICO are not subject to refund on minimum raise.\n', '*/\n', '\n', 'contract Token { \n', '    function issue(address _recipient, uint256 _value) returns (bool success);\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function owner() returns (address _owner);\n', '}\n', '\n', 'contract ZTCrowdsale {\n', '\n', '    // Crowdsale details\n', '    address public beneficiary; // Company address\n', '    address public creator; // Creator address\n', '    address public confirmedBy; // Address that confirmed beneficiary\n', '    uint256 public minAmount = 20000 ether; \n', '    uint256 public maxAmount = 400000 ether; \n', '    uint256 public minAcceptedAmount = 40 finney; // 1/25 ether\n', '\n', '    // Eth to ZT rate\n', '    uint256 public ratePreICO = 290;\n', '    uint256 public rateAngelDay = 275;\n', '    uint256 public rateFirstWeek = 250;\n', '    uint256 public rateSecondWeek = 198;\n', '    uint256 public rateThirdWeek = 157;\n', '    uint256 public rateLastWeek = 125;\n', '\n', '    uint256 public ratePreICOEnd = 10 days;\n', '    uint256 public rateAngelDayEnd = 11 days;\n', '    uint256 public rateFirstWeekEnd = 18 days;\n', '    uint256 public rateSecondWeekEnd = 25 days;\n', '    uint256 public rateThirdWeekEnd = 32 days;\n', '    uint256 public rateLastWeekEnd = 39 days;\n', '\n', '    enum Stages {\n', '        InProgress,\n', '        Ended,\n', '        Withdrawn\n', '    }\n', '\n', '    Stages public stage = Stages.InProgress;\n', '\n', '    // Crowdsale state\n', '    uint256 public start;\n', '    uint256 public end;\n', '    uint256 public raised;\n', '\n', '    // ZT token\n', '    Token public ztToken;\n', '\n', '    // Invested balances\n', '    mapping (address => uint256) balances;\n', '\n', '\n', '    /**\n', '     * Throw if at stage other than current stage\n', '     * \n', '     * @param _stage expected stage to test for\n', '     */\n', '    modifier atStage(Stages _stage) {\n', '        require(stage == _stage);\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * Throw if sender is not beneficiary\n', '     */\n', '    modifier onlyBeneficiary() {\n', '        require(beneficiary == msg.sender);\n', '        _;\n', '    }\n', '\n', '\n', '    /** \n', '     * Get balance of `_investor` \n', '     * \n', '     * @param _investor The address from which the balance will be retrieved\n', '     * @return The balance\n', '     */\n', '    function balanceOf(address _investor) constant returns (uint256 balance) {\n', '        return balances[_investor];\n', '    }\n', '\n', '\n', '    /**\n', '     * Most params are hardcoded for clarity\n', '     *\n', '     * @param _tokenAddress The address of the ZT token contact\n', '     */\n', '    function ZTCrowdsale(address _tokenAddress, address _beneficiary, address _creator, uint256 _start) {\n', '        ztToken = Token(_tokenAddress);\n', '        beneficiary = _beneficiary;\n', '        creator = _creator;\n', '        start = _start;\n', '        end = start + rateLastWeekEnd;\n', '    }\n', '\n', '\n', '    /**\n', '     * For testing purposes\n', '     *\n', '     * @return The beneficiary address\n', '     */\n', '    function confirmBeneficiary() onlyBeneficiary {\n', '        confirmedBy = msg.sender;\n', '    }\n', '\n', '\n', '    /**\n', '     * Convert `_wei` to an amount in ZT using \n', '     * the current rate\n', '     *\n', '     * @param _wei amount of wei to convert\n', '     * @return The amount in ZT\n', '     */\n', '    function toZT(uint256 _wei) returns (uint256 amount) {\n', '        uint256 rate = 0;\n', '        if (stage != Stages.Ended && now >= start && now <= end) {\n', '\n', '            // Check for preico\n', '            if (now <= start + ratePreICOEnd) {\n', '                rate = ratePreICO;\n', '            }\n', '\n', '            // Check for angelday\n', '            else if (now <= start + rateAngelDayEnd) {\n', '                rate = rateAngelDay;\n', '            }\n', '\n', '            // Check first week\n', '            else if (now <= start + rateFirstWeekEnd) {\n', '                rate = rateFirstWeek;\n', '            }\n', '\n', '            // Check second week\n', '            else if (now <= start + rateSecondWeekEnd) {\n', '                rate = rateSecondWeek;\n', '            }\n', '\n', '            // Check third week\n', '            else if (now <= start + rateThirdWeekEnd) {\n', '                rate = rateThirdWeek;\n', '            }\n', '\n', '            // Check last week\n', '            else if (now <= start + rateLastWeekEnd) {\n', '                rate = rateLastWeek;\n', '            }\n', '        }\n', '\n', '        uint256 ztAmount = _wei * rate * 10**8 / 1 ether; // 10**8 for 8 decimals\n', '\n', '        // Increase price after min amount is reached\n', '        if (raised > minAmount) {\n', '            uint256 multiplier = raised / minAmount; // Remainder discarded\n', '            for (uint256 i = 0; i < multiplier; i++) {\n', '                ztAmount = ztAmount * 965936329 / 10**9;\n', '            }\n', '        }\n', '\n', '        return ztAmount;\n', '    }\n', '\n', '\n', '    /**\n', '     * Function to end the crowdsale by setting \n', '     * the stage to Ended\n', '     */\n', '    function endCrowdsale() atStage(Stages.InProgress) {\n', '\n', '        // Crowdsale not ended yet\n', '        require(now >= end);\n', '\n', '        stage = Stages.Ended;\n', '    }\n', '\n', '\n', '    /**\n', '     * Transfer appropriate percentage of raised amount \n', '     * to the company address\n', '     */\n', '    function withdraw() atStage(Stages.Ended) {\n', '\n', '        // Confirm that minAmount is raised\n', '        require(raised >= minAmount);\n', '\n', '        uint256 ethBalance = this.balance;\n', '        uint256 ethFees = ethBalance * 5 / 10**3; // 0.005\n', '        creator.transfer(ethFees);\n', '        beneficiary.transfer(ethBalance - ethFees);\n', '\n', '        stage = Stages.Withdrawn;\n', '    }\n', '\n', '\n', '    /**\n', '     * Refund in the case of an unsuccessful crowdsale. The \n', '     * crowdsale is considered unsuccessful if minAmount was \n', '     * not raised before end\n', '     */\n', '    function refund() atStage(Stages.Ended) {\n', '\n', '        // Only allow refunds if minAmount is not raised\n', '        require(raised < minAmount);\n', '\n', '        uint256 receivedAmount = balances[msg.sender];\n', '        balances[msg.sender] = 0;\n', '\n', '        if (receivedAmount > 0 && !msg.sender.send(receivedAmount)) {\n', '            balances[msg.sender] = receivedAmount;\n', '        }\n', '    }\n', '\n', '    \n', '    /**\n', '     * Receives Eth and issue ZT tokens to the sender\n', '     */\n', '    function () payable atStage(Stages.InProgress) {\n', '\n', '        // Require Crowdsale started\n', '        require(now > start);\n', '\n', '        // Require Crowdsale not expired\n', '        require(now < end);\n', '\n', '        // Enforce min amount\n', '        require(msg.value >= minAcceptedAmount);\n', '        \n', '        address sender = msg.sender;\n', '        uint256 received = msg.value;\n', '        uint256 valueInZT = toZT(msg.value);\n', '        if (!ztToken.issue(sender, valueInZT)) {\n', '            revert();\n', '        }\n', '\n', '        if (now <= start + ratePreICOEnd) {\n', '\n', '            // Fees\n', '            uint256 ethFees = received * 5 / 10**3; // 0.005\n', '\n', '            // 0.5% eth\n', '            if (!creator.send(ethFees)) {\n', '                revert();\n', '            }\n', '\n', '            // During pre-ico - Non-Refundable\n', '            if (!beneficiary.send(received - ethFees)) {\n', '                revert();\n', '            }\n', '\n', '        } else {\n', '\n', '            // During the ICO\n', '            balances[sender] += received; // 100% refundable\n', '        }\n', '\n', '        raised += received;\n', '\n', '        // Check maxAmount raised\n', '        if (raised >= maxAmount) {\n', '            stage = Stages.Ended;\n', '        }\n', '    }\n', '}']
['pragma solidity ^0.4.15;\n', '\n', '/*\n', '- The ZTT pre-sale will last between September 5 to 15 with a 5% bonus payable in ZTT on all purchases.\n', '- The ICO is expected to start September 15, 2017, and run for exactly 30 days.\n', '- The PreICO price is 290ZTT/ETH. Bonus of 25 ZTT on the first day. The first week price is 250 ZTT/ETH. The price then increases approximately 26%/week and 3.6%/raised ZTT in multiples of minimum amount to be raised. In the first day, price is 275 - times funds raised discount factor. In first, second, third and fourth week, price is 250, 198, 157, 125 respectively times discount factor. The discount factor for each successive multiple (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, etc) of the minimum funds raised so far, of 1, .966, .933, .901, .871, .841, .812, .785, .758, .732, .707, etc.\n', '- Tradable when issued to the public for consideration, after the ICO closes.\n', '- Dividends of 4% per annum are payable as increased territory size\n', '- Deputy Mayor crypto-currency governance role.\n', '- Democratic governance applies to traffic congestion. All crowd funders who own ZTT coins are "Deputy Mayors" of their district below and may democratically advise ZeroTraffic on congested areas in their district on a regular basis. District maybe re-centered.\n', '- Coins are optionally retractable and redeemable by ZeroTraffic, individually from each owner any time after 5 years after IOD. Once an owner is exchanged, the market price average for the last 5 days shall be used to compute payment.\n', "- At least 1250 ZTTs' are required to fill the role of Deputy Mayor.\n", "- Price per each non-exclusive circle of radius 1/2 km, around any ZTT coin owner specified GPS point, for a map of traffic standstill congestion management advice = (1250 ZTT). Additional size regions are priced for a R' km radius at (R'/R)**2 *price for 1/2km radius in ZTT coin.\n", '- To be exempt from securities laws, there is no share ownership to ZTT coin holders, right to dividends, proceeds from sales. The parties agree that the Howey test is not met: "investment of money from an expectation of profits arising from a common enterprise depending solely on the efforts of a promoter or third party". Proceeds will fund initial and continuing development and business development, depending on level of funds raised, for several years.\n', "- Funds raised in ICO are refundable if minimum isn't met during ICO and presale, however funds raised during the PreICO are not subject to refund on minimum raise.\n", '*/\n', '\n', 'contract Token { \n', '    function issue(address _recipient, uint256 _value) returns (bool success);\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function owner() returns (address _owner);\n', '}\n', '\n', 'contract ZTCrowdsale {\n', '\n', '    // Crowdsale details\n', '    address public beneficiary; // Company address\n', '    address public creator; // Creator address\n', '    address public confirmedBy; // Address that confirmed beneficiary\n', '    uint256 public minAmount = 20000 ether; \n', '    uint256 public maxAmount = 400000 ether; \n', '    uint256 public minAcceptedAmount = 40 finney; // 1/25 ether\n', '\n', '    // Eth to ZT rate\n', '    uint256 public ratePreICO = 290;\n', '    uint256 public rateAngelDay = 275;\n', '    uint256 public rateFirstWeek = 250;\n', '    uint256 public rateSecondWeek = 198;\n', '    uint256 public rateThirdWeek = 157;\n', '    uint256 public rateLastWeek = 125;\n', '\n', '    uint256 public ratePreICOEnd = 10 days;\n', '    uint256 public rateAngelDayEnd = 11 days;\n', '    uint256 public rateFirstWeekEnd = 18 days;\n', '    uint256 public rateSecondWeekEnd = 25 days;\n', '    uint256 public rateThirdWeekEnd = 32 days;\n', '    uint256 public rateLastWeekEnd = 39 days;\n', '\n', '    enum Stages {\n', '        InProgress,\n', '        Ended,\n', '        Withdrawn\n', '    }\n', '\n', '    Stages public stage = Stages.InProgress;\n', '\n', '    // Crowdsale state\n', '    uint256 public start;\n', '    uint256 public end;\n', '    uint256 public raised;\n', '\n', '    // ZT token\n', '    Token public ztToken;\n', '\n', '    // Invested balances\n', '    mapping (address => uint256) balances;\n', '\n', '\n', '    /**\n', '     * Throw if at stage other than current stage\n', '     * \n', '     * @param _stage expected stage to test for\n', '     */\n', '    modifier atStage(Stages _stage) {\n', '        require(stage == _stage);\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * Throw if sender is not beneficiary\n', '     */\n', '    modifier onlyBeneficiary() {\n', '        require(beneficiary == msg.sender);\n', '        _;\n', '    }\n', '\n', '\n', '    /** \n', '     * Get balance of `_investor` \n', '     * \n', '     * @param _investor The address from which the balance will be retrieved\n', '     * @return The balance\n', '     */\n', '    function balanceOf(address _investor) constant returns (uint256 balance) {\n', '        return balances[_investor];\n', '    }\n', '\n', '\n', '    /**\n', '     * Most params are hardcoded for clarity\n', '     *\n', '     * @param _tokenAddress The address of the ZT token contact\n', '     */\n', '    function ZTCrowdsale(address _tokenAddress, address _beneficiary, address _creator, uint256 _start) {\n', '        ztToken = Token(_tokenAddress);\n', '        beneficiary = _beneficiary;\n', '        creator = _creator;\n', '        start = _start;\n', '        end = start + rateLastWeekEnd;\n', '    }\n', '\n', '\n', '    /**\n', '     * For testing purposes\n', '     *\n', '     * @return The beneficiary address\n', '     */\n', '    function confirmBeneficiary() onlyBeneficiary {\n', '        confirmedBy = msg.sender;\n', '    }\n', '\n', '\n', '    /**\n', '     * Convert `_wei` to an amount in ZT using \n', '     * the current rate\n', '     *\n', '     * @param _wei amount of wei to convert\n', '     * @return The amount in ZT\n', '     */\n', '    function toZT(uint256 _wei) returns (uint256 amount) {\n', '        uint256 rate = 0;\n', '        if (stage != Stages.Ended && now >= start && now <= end) {\n', '\n', '            // Check for preico\n', '            if (now <= start + ratePreICOEnd) {\n', '                rate = ratePreICO;\n', '            }\n', '\n', '            // Check for angelday\n', '            else if (now <= start + rateAngelDayEnd) {\n', '                rate = rateAngelDay;\n', '            }\n', '\n', '            // Check first week\n', '            else if (now <= start + rateFirstWeekEnd) {\n', '                rate = rateFirstWeek;\n', '            }\n', '\n', '            // Check second week\n', '            else if (now <= start + rateSecondWeekEnd) {\n', '                rate = rateSecondWeek;\n', '            }\n', '\n', '            // Check third week\n', '            else if (now <= start + rateThirdWeekEnd) {\n', '                rate = rateThirdWeek;\n', '            }\n', '\n', '            // Check last week\n', '            else if (now <= start + rateLastWeekEnd) {\n', '                rate = rateLastWeek;\n', '            }\n', '        }\n', '\n', '        uint256 ztAmount = _wei * rate * 10**8 / 1 ether; // 10**8 for 8 decimals\n', '\n', '        // Increase price after min amount is reached\n', '        if (raised > minAmount) {\n', '            uint256 multiplier = raised / minAmount; // Remainder discarded\n', '            for (uint256 i = 0; i < multiplier; i++) {\n', '                ztAmount = ztAmount * 965936329 / 10**9;\n', '            }\n', '        }\n', '\n', '        return ztAmount;\n', '    }\n', '\n', '\n', '    /**\n', '     * Function to end the crowdsale by setting \n', '     * the stage to Ended\n', '     */\n', '    function endCrowdsale() atStage(Stages.InProgress) {\n', '\n', '        // Crowdsale not ended yet\n', '        require(now >= end);\n', '\n', '        stage = Stages.Ended;\n', '    }\n', '\n', '\n', '    /**\n', '     * Transfer appropriate percentage of raised amount \n', '     * to the company address\n', '     */\n', '    function withdraw() atStage(Stages.Ended) {\n', '\n', '        // Confirm that minAmount is raised\n', '        require(raised >= minAmount);\n', '\n', '        uint256 ethBalance = this.balance;\n', '        uint256 ethFees = ethBalance * 5 / 10**3; // 0.005\n', '        creator.transfer(ethFees);\n', '        beneficiary.transfer(ethBalance - ethFees);\n', '\n', '        stage = Stages.Withdrawn;\n', '    }\n', '\n', '\n', '    /**\n', '     * Refund in the case of an unsuccessful crowdsale. The \n', '     * crowdsale is considered unsuccessful if minAmount was \n', '     * not raised before end\n', '     */\n', '    function refund() atStage(Stages.Ended) {\n', '\n', '        // Only allow refunds if minAmount is not raised\n', '        require(raised < minAmount);\n', '\n', '        uint256 receivedAmount = balances[msg.sender];\n', '        balances[msg.sender] = 0;\n', '\n', '        if (receivedAmount > 0 && !msg.sender.send(receivedAmount)) {\n', '            balances[msg.sender] = receivedAmount;\n', '        }\n', '    }\n', '\n', '    \n', '    /**\n', '     * Receives Eth and issue ZT tokens to the sender\n', '     */\n', '    function () payable atStage(Stages.InProgress) {\n', '\n', '        // Require Crowdsale started\n', '        require(now > start);\n', '\n', '        // Require Crowdsale not expired\n', '        require(now < end);\n', '\n', '        // Enforce min amount\n', '        require(msg.value >= minAcceptedAmount);\n', '        \n', '        address sender = msg.sender;\n', '        uint256 received = msg.value;\n', '        uint256 valueInZT = toZT(msg.value);\n', '        if (!ztToken.issue(sender, valueInZT)) {\n', '            revert();\n', '        }\n', '\n', '        if (now <= start + ratePreICOEnd) {\n', '\n', '            // Fees\n', '            uint256 ethFees = received * 5 / 10**3; // 0.005\n', '\n', '            // 0.5% eth\n', '            if (!creator.send(ethFees)) {\n', '                revert();\n', '            }\n', '\n', '            // During pre-ico - Non-Refundable\n', '            if (!beneficiary.send(received - ethFees)) {\n', '                revert();\n', '            }\n', '\n', '        } else {\n', '\n', '            // During the ICO\n', '            balances[sender] += received; // 100% refundable\n', '        }\n', '\n', '        raised += received;\n', '\n', '        // Check maxAmount raised\n', '        if (raised >= maxAmount) {\n', '            stage = Stages.Ended;\n', '        }\n', '    }\n', '}']