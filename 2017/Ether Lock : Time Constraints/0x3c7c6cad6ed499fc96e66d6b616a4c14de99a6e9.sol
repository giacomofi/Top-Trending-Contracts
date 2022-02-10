['pragma solidity ^0.4.15;\n', '\n', 'contract EngravedToken {\n', '    uint256 public totalSupply;\n', '    function issue(address, uint256) returns (bool) {}\n', '    function balanceOf(address) constant returns (uint256) {}\n', '    function unlock() returns (bool) {}\n', '    function startIncentiveDistribution() returns (bool) {}\n', '    function transferOwnership(address) {}\n', '    function owner() returns (address) {}\n', '}\n', '\n', 'contract EGRCrowdsale {\n', '    // Crowdsale details\n', '    address public beneficiary;\n', '    address public confirmedBy; // Address that confirmed beneficiary\n', '\n', '    // Maximum tokens supply\n', '    uint256 public maxSupply = 1000000000; // 1 billion\n', '\n', '    // Minum amount of ether to be exchanged for EGR\n', '    uint256 public minAcceptedAmount = 10 finney; // 0.01 ETH\n', '\n', '    //Amount of free tokens per user in airdrop period\n', '    uint256 public rateAirDrop = 1000;\n', '\n', '    // Number of airdrop participants\n', '    uint256 public airdropParticipants;\n', '\n', '    //Maximum number of airdrop participants\n', '    uint256 public maxAirdropParticipants = 500;\n', '\n', '    // Check if this is the first participation in the airdrop\n', '    mapping (address => bool) participatedInAirdrop;\n', '\n', '    // ETH to EGR rate\n', '    uint256 public rateAngelsDay = 100000;\n', '    uint256 public rateFirstWeek = 80000;\n', '    uint256 public rateSecondWeek = 70000;\n', '    uint256 public rateThirdWeek = 60000;\n', '    uint256 public rateLastWeek = 50000;\n', '\n', '    uint256 public airdropEnd = 3 days;\n', '    uint256 public airdropCooldownEnd = 7 days;\n', '    uint256 public rateAngelsDayEnd = 8 days;\n', '    uint256 public angelsDayCooldownEnd = 14 days;\n', '    uint256 public rateFirstWeekEnd = 21 days;\n', '    uint256 public rateSecondWeekEnd = 28 days;\n', '    uint256 public rateThirdWeekEnd = 35 days;\n', '    uint256 public rateLastWeekEnd = 42 days;\n', '\n', '    enum Stages {\n', '        Airdrop,\n', '        InProgress,\n', '        Ended,\n', '        Withdrawn,\n', '        Proposed,\n', '        Accepted\n', '    }\n', '\n', '    Stages public stage = Stages.Airdrop;\n', '\n', '    // Crowdsale state\n', '    uint256 public start;\n', '    uint256 public end;\n', '    uint256 public raised;\n', '\n', '    // EGR EngravedToken\n', '    EngravedToken public EGREngravedToken;\n', '\n', '    // Invested balances\n', '    mapping (address => uint256) balances;\n', '\n', '    struct Proposal {\n', '        address engravedAddress;\n', '        uint256 deadline;\n', '        uint256 approvedWeight;\n', '        uint256 disapprovedWeight;\n', '        mapping (address => uint256) voted;\n', '    }\n', '\n', '    // Ownership transfer proposal\n', '    Proposal public transferProposal;\n', '\n', '    // Time to vote\n', '    uint256 public transferProposalEnd = 7 days;\n', '\n', '    // Time between proposals\n', '    uint256 public transferProposalCooldown = 1 days;\n', '\n', '\n', '    /**\n', '     * Throw if at stage other than current stage\n', '     *\n', '     * @param _stage expected stage to test for\n', '     */\n', '    modifier atStage(Stages _stage) {\n', '\t\t    require(stage == _stage);\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * Throw if at stage other than current stage\n', '     *\n', '     * @param _stage1 expected stage to test for\n', '     * @param _stage2 expected stage to test for\n', '     */\n', '    modifier atStages(Stages _stage1, Stages _stage2) {\n', '\t\t    require(stage == _stage1 || stage == _stage2);\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * Throw if sender is not beneficiary\n', '     */\n', '    modifier onlyBeneficiary() {\n', '\t\t    require(beneficiary == msg.sender);\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * Throw if sender has a EGR balance of zero\n', '     */\n', '    modifier onlyTokenholders() {\n', '\t\t    require(EGREngravedToken.balanceOf(msg.sender) > 0);\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', "     * Throw if the current transfer proposal's deadline\n", '     * is in the past\n', '     */\n', '    modifier beforeDeadline() {\n', '\t\t    require(now < transferProposal.deadline);\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', "     * Throw if the current transfer proposal's deadline\n", '     * is in the future\n', '     */\n', '    modifier afterDeadline() {\n', '\t\t    require(now > transferProposal.deadline);\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * Get balance of `_investor`\n', '     *\n', '     * @param _investor The address from which the balance will be retrieved\n', '     * @return The balance\n', '     */\n', '    function balanceOf(address _investor) constant returns (uint256 balance) {\n', '        return balances[_investor];\n', '    }\n', '\n', '\n', '    /**\n', '     * Most params are hardcoded for clarity\n', '     *\n', '     * @param _EngravedTokenAddress The address of the EGR EngravedToken contact\n', '     * @param _beneficiary Company address\n', '     * @param _start airdrop start date\n', '     */\n', '    function EGRCrowdsale(address _EngravedTokenAddress, address _beneficiary, uint256 _start) {\n', '        EGREngravedToken = EngravedToken(_EngravedTokenAddress);\n', '        beneficiary = _beneficiary;\n', '        start = _start;\n', '        end = start + 42 days;\n', '    }\n', '\n', '\n', '    /**\n', '     * For testing purposes\n', '     *\n', '     * @return The beneficiary address\n', '     */\n', '    function confirmBeneficiary() onlyBeneficiary {\n', '        confirmedBy = msg.sender;\n', '    }\n', '\n', '\n', '    /**\n', '     * Convert `_wei` to an amount in EGR using\n', '     * the current rate\n', '     *\n', '     * @param _wei amount of wei to convert\n', '     * @return The amount in EGR\n', '     */\n', '    function toEGR(uint256 _wei) returns (uint256 amount) {\n', '        uint256 rate = 0;\n', '        if (stage != Stages.Ended && now >= start && now <= end) {\n', '\n', '            // Check for cool down after airdrop\n', '            if (now <= start + airdropCooldownEnd) {\n', '                rate = 0;\n', '            }\n', '\n', '            // Check for AngelsDay\n', '            else if (now <= start + rateAngelsDayEnd) {\n', '                rate = rateAngelsDay;\n', '            }\n', '\n', '            // Check for cool down after the angels day\n', '            else if (now <= start + angelsDayCooldownEnd) {\n', '      \t\t\t    rate = 0;\n', '            }\n', '\n', '            // Check first week\n', '            else if (now <= start + rateFirstWeekEnd) {\n', '                rate = rateFirstWeek;\n', '            }\n', '\n', '            // Check second week\n', '            else if (now <= start + rateSecondWeekEnd) {\n', '                rate = rateSecondWeek;\n', '            }\n', '\n', '            // Check third week\n', '            else if (now <= start + rateThirdWeekEnd) {\n', '                rate = rateThirdWeek;\n', '            }\n', '\n', '            // Check last week\n', '            else if (now <= start + rateLastWeekEnd) {\n', '                rate = rateLastWeek;\n', '            }\n', '        }\n', '\t      require(rate != 0); // Check for cool down periods\n', '        return _wei * rate * 10**3 / 1 ether; // 10**3 for 3 decimals\n', '    }\n', '\n', '    /**\n', '    * Function to participate in the airdrop\n', '    */\n', '    function claim() atStage(Stages.Airdrop) {\n', '        require(airdropParticipants < maxAirdropParticipants);\n', '\n', '        // Crowdsal not started yet\n', '        require(now > start);\n', '\n', '        // Airdrop expired\n', '        require(now < start + airdropEnd);\n', '\n', '        require(participatedInAirdrop[msg.sender] == false); // Only once per address\n', '\n', '        require(EGREngravedToken.issue(msg.sender, rateAirDrop * 10**3));\n', '\n', '        participatedInAirdrop[msg.sender] = true;\n', '        airdropParticipants += 1;\n', '    }\n', '\n', '    /**\n', '     * Function to end the airdrop and start crowdsale\n', '     */\n', '    function endAirdrop() atStage(Stages.Airdrop) {\n', '\t      require(now > start + airdropEnd);\n', '\n', '        stage = Stages.InProgress;\n', '    }\n', '\n', '    /**\n', '     * Function to end the crowdsale by setting\n', '     * the stage to Ended\n', '     */\n', '    function endCrowdsale() atStage(Stages.InProgress) {\n', '\n', '        // Crowdsale not ended yet\n', '\t      require(now > end);\n', '\n', '        stage = Stages.Ended;\n', '    }\n', '\n', '\n', '    /**\n', '     * Transfer raised amount to the company address\n', '     */\n', '    function withdraw() onlyBeneficiary atStage(Stages.Ended) {\n', '        require(beneficiary.send(raised));\n', '\n', '        stage = Stages.Withdrawn;\n', '    }\n', '\n', '    /**\n', '     * Propose the transfer of the EngravedToken contract ownership\n', '     * to `_engravedAddress`\n', '     *\n', '     * @param _engravedAddress the address of the proposed EngravedToken owner\n', '     */\n', '    function proposeTransfer(address _engravedAddress) onlyBeneficiary atStages(Stages.Withdrawn, Stages.Proposed) {\n', '\n', '        // Check for a pending proposal\n', '\t      require(stage != Stages.Proposed || now > transferProposal.deadline + transferProposalCooldown);\n', '\n', '        transferProposal = Proposal({\n', '            engravedAddress: _engravedAddress,\n', '            deadline: now + transferProposalEnd,\n', '            approvedWeight: 0,\n', '            disapprovedWeight: 0\n', '        });\n', '\n', '        stage = Stages.Proposed;\n', '    }\n', '\n', '\n', '    /**\n', '     * Allows EGR holders to vote on the poposed transfer of\n', '     * ownership. Weight is calculated directly, this is no problem\n', '     * because EngravedTokens cannot be transferred yet\n', '     *\n', '     * @param _approve indicates if the sender supports the proposal\n', '     */\n', '    function vote(bool _approve) onlyTokenholders beforeDeadline atStage(Stages.Proposed) {\n', '\n', '        // One vote per proposal\n', '\t      require(transferProposal.voted[msg.sender] < transferProposal.deadline - transferProposalEnd);\n', '\n', '        transferProposal.voted[msg.sender] = now;\n', '        uint256 weight = EGREngravedToken.balanceOf(msg.sender);\n', '\n', '        if (_approve) {\n', '            transferProposal.approvedWeight += weight;\n', '        } else {\n', '            transferProposal.disapprovedWeight += weight;\n', '        }\n', '    }\n', '\n', '\n', '    /**\n', '     * Calculates the votes and if the majority weigt approved\n', '     * the proposal the transfer of ownership is executed.\n', '\n', '     * The Crowdsale contact transferres the ownership of the\n', '     * EngravedToken contract to Engraved\n', '     */\n', '    function executeTransfer() afterDeadline atStage(Stages.Proposed) {\n', '\n', '        // Check approved\n', '\t      require(transferProposal.approvedWeight > transferProposal.disapprovedWeight);\n', '\n', '\t      require(EGREngravedToken.unlock());\n', '\n', '        require(EGREngravedToken.startIncentiveDistribution());\n', '\n', '        EGREngravedToken.transferOwnership(transferProposal.engravedAddress);\n', '\t      require(EGREngravedToken.owner() == transferProposal.engravedAddress);\n', '\n', '        require(transferProposal.engravedAddress.send(this.balance));\n', '\n', '        stage = Stages.Accepted;\n', '    }\n', '\n', '\n', '    /**\n', '     * Receives ETH and issue EGR EngravedTokens to the sender\n', '     */\n', '    function () payable atStage(Stages.InProgress) {\n', '\n', '        // Crowdsale not started yet\n', '        require(now > start);\n', '\n', '        // Crowdsale expired\n', '        require(now < end);\n', '\n', '        // Enforce min amount\n', '\t      require(msg.value >= minAcceptedAmount);\n', '\n', '        uint256 received = msg.value;\n', '        uint256 valueInEGR = toEGR(msg.value);\n', '\n', '        require((EGREngravedToken.totalSupply() + valueInEGR) <= (maxSupply * 10**3));\n', '\n', '        require(EGREngravedToken.issue(msg.sender, valueInEGR));\n', '\n', '        balances[msg.sender] += received;\n', '        raised += received;\n', '    }\n', '}']