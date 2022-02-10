['pragma solidity ^0.4.4;\n', '\n', 'contract DutchAuctionInterface {\n', '    function bid(address receiver) payable returns (uint);\n', '    function claimTokens(address receiver);\n', '    function stage() returns (uint);\n', '    TokenInterface public gnosisToken;\n', '}\n', '\n', '\n', 'contract TokenInterface {\n', '    function transfer(address to, uint256 value) returns (bool success);\n', '    function balanceOf(address owner) constant returns (uint256 balance);\n', '}\n', '\n', '\n', 'contract ProxySender {\n', '\n', '    event BidSubmission(address indexed sender, uint256 amount);\n', '    event RefundSubmission(address indexed sender, uint256 amount);\n', '    event RefundReceived(uint256 amount);\n', '\n', '    uint public constant AUCTION_STARTED = 2;\n', '    uint public constant TRADING_STARTED = 4;\n', '\n', '    DutchAuctionInterface public dutchAuction;\n', '    TokenInterface public gnosisToken;\n', '    uint public totalContributions;\n', '    uint public totalTokens;\n', '    uint public totalBalance;\n', '    mapping (address => uint) public contributions;\n', '    Stages public stage;\n', '\n', '    enum Stages {\n', '        ContributionsCollection,\n', '        ContributionsSent,\n', '        TokensClaimed\n', '    }\n', '\n', '    modifier atStage(Stages _stage) {\n', '        if (stage != _stage)\n', '            throw;\n', '        _;\n', '    }\n', '\n', '    function ProxySender(address _dutchAuction)\n', '        public\n', '    {\n', '        if (_dutchAuction == 0) throw;\n', '        dutchAuction = DutchAuctionInterface(_dutchAuction);\n', '        gnosisToken = dutchAuction.gnosisToken();\n', '        if (address(gnosisToken) == 0) throw;\n', '        stage = Stages.ContributionsCollection;\n', '    }\n', '\n', '    function()\n', '        public\n', '        payable\n', '    {\n', '        if (msg.sender == address(dutchAuction))\n', '            RefundReceived(msg.value);\n', '        else if (stage == Stages.ContributionsCollection)\n', '            contribute();\n', '        else if(stage == Stages.TokensClaimed)\n', '            transfer();\n', '        else\n', '            throw;\n', '    }\n', '\n', '    function contribute()\n', '        public\n', '        payable\n', '        atStage(Stages.ContributionsCollection)\n', '    {\n', '        contributions[msg.sender] += msg.value;\n', '        totalContributions += msg.value;\n', '        BidSubmission(msg.sender, msg.value);\n', '    }\n', '\n', '    function refund()\n', '        public\n', '        atStage(Stages.ContributionsCollection)\n', '    {\n', '        uint contribution = contributions[msg.sender];\n', '        contributions[msg.sender] = 0;\n', '        totalContributions -= contribution;\n', '        RefundSubmission(msg.sender, contribution);\n', '        if (!msg.sender.send(contribution)) throw;\n', '    }\n', '\n', '    function bidProxy()\n', '        public\n', '        atStage(Stages.ContributionsCollection)\n', '        returns(bool)\n', '    {\n', '        // Check auction has started\n', '        if (dutchAuction.stage() != AUCTION_STARTED)\n', '            throw;\n', '        // Send all money to auction contract\n', '        stage = Stages.ContributionsSent;\n', '        dutchAuction.bid.value(this.balance)(0);\n', '        return true;\n', '    }\n', '\n', '    function claimProxy()\n', '        public\n', '        atStage(Stages.ContributionsSent)\n', '    {\n', '        // Auction is over\n', '        if (dutchAuction.stage() != TRADING_STARTED)\n', '            throw;\n', '        dutchAuction.claimTokens(0);\n', '        totalTokens = gnosisToken.balanceOf(this);\n', '        totalBalance = this.balance;\n', '        stage = Stages.TokensClaimed;\n', '    }\n', '\n', '    function transfer()\n', '        public\n', '        atStage(Stages.TokensClaimed)\n', '        returns (uint amount)\n', '    {\n', '        uint contribution = contributions[msg.sender];\n', '        contributions[msg.sender] = 0;\n', '        // Calc. percentage of tokens for sender\n', '        amount = totalTokens * contribution / totalContributions;\n', '        gnosisToken.transfer(msg.sender, amount);\n', '        // Send possible refund share\n', '        uint refund = totalBalance * contribution / totalContributions;\n', '        if (refund > 0)\n', '            if (!msg.sender.send(refund)) throw;\n', '    }\n', '}']