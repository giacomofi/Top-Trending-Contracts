['contract Token { \n', '    function issue(address _recipient, uint256 _value) returns (bool success) {} \n', '    function balanceOf(address _owner) constant returns (uint256 balance) {}\n', '    function unlock() returns (bool success) {}\n', '    function startIncentiveDistribution() returns (bool success) {}\n', '    function transferOwnership(address _newOwner) {}\n', '    function owner() returns (address _owner) {}\n', '}\n', '\n', 'contract DRPCrowdsale {\n', '\n', '    // Crowdsale details\n', '    address public beneficiary; // Company address multisig (49% funding)\n', '    address public confirmedBy; // Address that confirmed beneficiary\n', '    uint256 public minAmount = 4137 ether; // ≈ 724.000 euro\n', '    uint256 public maxAmount = 54285 ether; // ≈ 9.5 mln euro\n', '    uint256 public minAcceptedAmount = 40 finney; // 1/25 ether\n', '\n', '    /**\n', '     * 51% of the raised amount remains in the crowdsale contract \n', '     * to be released to DCORP on launch with aproval of tokenholders.\n', '     *\n', '     * See whitepaper for more information\n', '     */\n', '    uint256 public percentageOfRaisedAmountThatRemainsInContract = 51; // 0.51 * 10^2\n', '\n', '    // Eth to DRP rate\n', '    uint256 public rateAngelDay = 650;\n', '    uint256 public rateFirstWeek = 550;\n', '    uint256 public rateSecondWeek = 475;\n', '    uint256 public rateThirdWeek = 425;\n', '    uint256 public rateLastWeek = 400;\n', '\n', '    uint256 public rateAngelDayEnd = 1 days;\n', '    uint256 public rateFirstWeekEnd = 8 days;\n', '    uint256 public rateSecondWeekEnd = 15 days;\n', '    uint256 public rateThirdWeekEnd = 22 days;\n', '    uint256 public rateLastWeekEnd = 29 days;\n', '\n', '    enum Stages {\n', '        InProgress,\n', '        Ended,\n', '        Withdrawn,\n', '        Proposed,\n', '        Accepted\n', '    }\n', '\n', '    Stages public stage = Stages.InProgress;\n', '\n', '    // Crowdsale state\n', '    uint256 public start;\n', '    uint256 public end;\n', '    uint256 public raised;\n', '\n', '    // DRP token\n', '    Token public drpToken;\n', '\n', '    // Invested balances\n', '    mapping (address => uint256) balances;\n', '\n', '    struct Proposal {\n', '        address dcorpAddress;\n', '        uint256 deadline;\n', '        uint256 approvedWeight;\n', '        uint256 disapprovedWeight;\n', '        mapping (address => uint256) voted;\n', '    }\n', '\n', '    // Ownership transfer proposal\n', '    Proposal public transferProposal;\n', '\n', '    // Time to vote\n', '    uint256 public transferProposalEnd = 7 days;\n', '\n', '    // Time between proposals\n', '    uint256 public transferProposalCooldown = 1 days;\n', '\n', '\n', '    /**\n', '     * Throw if at stage other than current stage\n', '     * \n', '     * @param _stage expected stage to test for\n', '     */\n', '    modifier atStage(Stages _stage) {\n', '        if (stage != _stage) {\n', '            throw;\n', '        }\n', '        _;\n', '    }\n', '    \n', '\n', '    /**\n', '     * Throw if at stage other than current stage\n', '     * \n', '     * @param _stage1 expected stage to test for\n', '     * @param _stage2 expected stage to test for\n', '     */\n', '    modifier atStages(Stages _stage1, Stages _stage2) {\n', '        if (stage != _stage1 && stage != _stage2) {\n', '            throw;\n', '        }\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * Throw if sender is not beneficiary\n', '     */\n', '    modifier onlyBeneficiary() {\n', '        if (beneficiary != msg.sender) {\n', '            throw;\n', '        }\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * Throw if sender has a DCP balance of zero\n', '     */\n', '    modifier onlyShareholders() {\n', '        if (drpToken.balanceOf(msg.sender) == 0) {\n', '            throw;\n', '        }\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', "     * Throw if the current transfer proposal's deadline\n", '     * is in the past\n', '     */\n', '    modifier beforeDeadline() {\n', '        if (now > transferProposal.deadline) {\n', '            throw;\n', '        }\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', "     * Throw if the current transfer proposal's deadline \n", '     * is in the future\n', '     */\n', '    modifier afterDeadline() {\n', '        if (now < transferProposal.deadline) {\n', '            throw;\n', '        }\n', '        _;\n', '    }\n', '\n', '\n', '    /** \n', '     * Get balance of `_investor` \n', '     * \n', '     * @param _investor The address from which the balance will be retrieved\n', '     * @return The balance\n', '     */\n', '    function balanceOf(address _investor) constant returns (uint256 balance) {\n', '        return balances[_investor];\n', '    }\n', '\n', '\n', '    /**\n', '     * Most params are hardcoded for clarity\n', '     *\n', '     * @param _tokenAddress The address of the DRP token contact\n', '     */\n', '    function DRPCrowdsale(address _tokenAddress, address _beneficiary, uint256 _start) {\n', '        drpToken = Token(_tokenAddress);\n', '        beneficiary = _beneficiary;\n', '        start = _start;\n', '        end = start + 29 days;\n', '    }\n', '\n', '\n', '    /**\n', '     * For testing purposes\n', '     *\n', '     * @return The beneficiary address\n', '     */\n', '    function confirmBeneficiary() onlyBeneficiary {\n', '        confirmedBy = msg.sender;\n', '    }\n', '\n', '\n', '    /**\n', '     * Convert `_wei` to an amount in DRP using \n', '     * the current rate\n', '     *\n', '     * @param _wei amount of wei to convert\n', '     * @return The amount in DRP\n', '     */\n', '    function toDRP(uint256 _wei) returns (uint256 amount) {\n', '        uint256 rate = 0;\n', '        if (stage != Stages.Ended && now >= start && now <= end) {\n', '\n', '            // Check for angelday\n', '            if (now <= start + rateAngelDayEnd) {\n', '                rate = rateAngelDay;\n', '            }\n', '\n', '            // Check first week\n', '            else if (now <= start + rateFirstWeekEnd) {\n', '                rate = rateFirstWeek;\n', '            }\n', '\n', '            // Check second week\n', '            else if (now <= start + rateSecondWeekEnd) {\n', '                rate = rateSecondWeek;\n', '            }\n', '\n', '            // Check third week\n', '            else if (now <= start + rateThirdWeekEnd) {\n', '                rate = rateThirdWeek;\n', '            }\n', '\n', '            // Check last week\n', '            else if (now <= start + rateLastWeekEnd) {\n', '                rate = rateLastWeek;\n', '            }\n', '        }\n', '\n', '        return _wei * rate * 10**2 / 1 ether; // 10**2 for 2 decimals\n', '    }\n', '\n', '\n', '    /**\n', '     * Function to end the crowdsale by setting \n', '     * the stage to Ended\n', '     */\n', '    function endCrowdsale() atStage(Stages.InProgress) {\n', '\n', '        // Crowdsale not ended yet\n', '        if (now < end) {\n', '            throw;\n', '        }\n', '\n', '        stage = Stages.Ended;\n', '    }\n', '\n', '\n', '    /**\n', '     * Transfer appropriate percentage of raised amount \n', '     * to the company address\n', '     */\n', '    function withdraw() onlyBeneficiary atStage(Stages.Ended) {\n', '\n', '        // Confirm that minAmount is raised\n', '        if (raised < minAmount) {\n', '            throw;\n', '        }\n', '\n', '        uint256 amountToSend = raised * (100 - percentageOfRaisedAmountThatRemainsInContract) / 10**2;\n', '        if (!beneficiary.send(amountToSend)) {\n', '            throw;\n', '        }\n', '\n', '        stage = Stages.Withdrawn;\n', '    }\n', '\n', '\n', '    /**\n', '     * Refund in the case of an unsuccessful crowdsale. The \n', '     * crowdsale is considered unsuccessful if minAmount was \n', '     * not raised before end\n', '     */\n', '    function refund() atStage(Stages.Ended) {\n', '\n', '        // Only allow refunds if minAmount is not raised\n', '        if (raised >= minAmount) {\n', '            throw;\n', '        }\n', '\n', '        uint256 receivedAmount = balances[msg.sender];\n', '        balances[msg.sender] = 0;\n', '\n', '        if (receivedAmount > 0 && !msg.sender.send(receivedAmount)) {\n', '            balances[msg.sender] = receivedAmount;\n', '        }\n', '    }\n', '\n', '\n', '    /**\n', '     * Propose the transfer of the token contract ownership\n', '     * to `_dcorpAddress` \n', '     *\n', '     * @param _dcorpAddress the address of the proposed token owner \n', '     */\n', '    function proposeTransfer(address _dcorpAddress) onlyBeneficiary atStages(Stages.Withdrawn, Stages.Proposed) {\n', '        \n', '        // Check for a pending proposal\n', '        if (stage == Stages.Proposed && now < transferProposal.deadline + transferProposalCooldown) {\n', '            throw;\n', '        }\n', '\n', '        transferProposal = Proposal({\n', '            dcorpAddress: _dcorpAddress,\n', '            deadline: now + transferProposalEnd,\n', '            approvedWeight: 0,\n', '            disapprovedWeight: 0\n', '        });\n', '\n', '        stage = Stages.Proposed;\n', '    }\n', '\n', '\n', '    /**\n', '     * Allows DRP holders to vote on the poposed transfer of \n', '     * ownership. Weight is calculated directly, this is no problem \n', '     * because tokens cannot be transferred yet\n', '     *\n', '     * @param _approve indicates if the sender supports the proposal\n', '     */\n', '    function vote(bool _approve) onlyShareholders beforeDeadline atStage(Stages.Proposed) {\n', '\n', '        // One vote per proposal\n', '        if (transferProposal.voted[msg.sender] >= transferProposal.deadline - transferProposalEnd) {\n', '            throw;\n', '        }\n', '\n', '        transferProposal.voted[msg.sender] = now;\n', '        uint256 weight = drpToken.balanceOf(msg.sender);\n', '\n', '        if (_approve) {\n', '            transferProposal.approvedWeight += weight;\n', '        } else {\n', '            transferProposal.disapprovedWeight += weight;\n', '        }\n', '    }\n', '\n', '\n', '    /**\n', '     * Calculates the votes and if the majority weigt approved \n', '     * the proposal the transfer of ownership is executed.\n', '     \n', '     * The Crowdsale contact transferres the ownership of the \n', '     * token contract to DCorp and starts the insentive \n', '     * distribution recorded in the token contract.\n', '     */\n', '    function executeTransfer() afterDeadline atStage(Stages.Proposed) {\n', '\n', '        // Check approved\n', '        if (transferProposal.approvedWeight <= transferProposal.disapprovedWeight) {\n', '            throw;\n', '        }\n', '\n', '        if (!drpToken.unlock()) {\n', '            throw;\n', '        }\n', '        \n', '        if (!drpToken.startIncentiveDistribution()) {\n', '            throw;\n', '        }\n', '\n', '        drpToken.transferOwnership(transferProposal.dcorpAddress);\n', '        if (drpToken.owner() != transferProposal.dcorpAddress) {\n', '            throw;\n', '        }\n', '\n', '        if (!transferProposal.dcorpAddress.send(this.balance)) {\n', '            throw;\n', '        }\n', '\n', '        stage = Stages.Accepted;\n', '    }\n', '\n', '    \n', '    /**\n', '     * Receives Eth and issue DRP tokens to the sender\n', '     */\n', '    function () payable atStage(Stages.InProgress) {\n', '\n', '        // Crowdsale not started yet\n', '        if (now < start) {\n', '            throw;\n', '        }\n', '\n', '        // Crowdsale expired\n', '        if (now > end) {\n', '            throw;\n', '        }\n', '\n', '        // Enforce min amount\n', '        if (msg.value < minAcceptedAmount) {\n', '            throw;\n', '        }\n', ' \n', '        uint256 received = msg.value;\n', '        uint256 valueInDRP = toDRP(msg.value);\n', '        if (!drpToken.issue(msg.sender, valueInDRP)) {\n', '            throw;\n', '        }\n', '\n', '        balances[msg.sender] += received;\n', '        raised += received;\n', '\n', '        // Check maxAmount raised\n', '        if (raised >= maxAmount) {\n', '            stage = Stages.Ended;\n', '        }\n', '    }\n', '}']