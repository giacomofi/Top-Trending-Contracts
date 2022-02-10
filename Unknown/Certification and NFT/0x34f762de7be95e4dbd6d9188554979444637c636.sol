['pragma solidity ^0.4.15;\n', '\n', '// ERC20 Interface\n', 'contract ERC20 {\n', '    function transfer(address _to, uint _value) returns (bool success);\n', '    function balanceOf(address _owner) constant returns (uint balance);\n', '}\n', '\n', 'contract PresalePool {\n', '    enum State { Open, Failed, Closed, Paid }\n', '    State public state;\n', '\n', '    address[] public admins;\n', '\n', '    uint public minContribution;\n', '    uint public maxContribution;\n', '    uint public maxPoolTotal;\n', '\n', '    address[] public participants;\n', '\n', '    bool public whitelistAll;\n', '\n', '    struct ParticipantState {\n', '        uint contribution;\n', '        uint remaining;\n', '        bool whitelisted;\n', '        bool exists;\n', '    }\n', '    mapping (address => ParticipantState) public balances;\n', '    uint public poolTotal;\n', '\n', '    address presaleAddress;\n', '    bool refundable;\n', '    uint gasFundTotal;\n', '\n', '    ERC20 public token;\n', '\n', '    event Deposit(\n', '        address indexed _from,\n', '        uint _value\n', '    );\n', '    event Payout(\n', '        address indexed _to,\n', '        uint _value\n', '    );\n', '    event Withdrawl(\n', '        address indexed _to,\n', '        uint _value\n', '    );\n', '\n', '    modifier onlyAdmins() {\n', '        require(isAdmin(msg.sender));\n', '        _;\n', '    }\n', '\n', '    modifier onState(State s) {\n', '        require(state == s);\n', '        _;\n', '    }\n', '\n', '    modifier stateAllowsConfiguration() {\n', '        require(state == State.Open || state == State.Closed);\n', '        _;\n', '    }\n', '\n', '    bool locked;\n', '    modifier noReentrancy() {\n', '        require(!locked);\n', '        locked = true;\n', '        _;\n', '        locked = false;\n', '    }\n', '\n', '    function PresalePool(uint _minContribution, uint _maxContribution, uint _maxPoolTotal, address[] _admins) payable {\n', '        state = State.Open;\n', '        admins.push(msg.sender);\n', '\n', '        setContributionSettings(_minContribution, _maxContribution, _maxPoolTotal);\n', '\n', '        whitelistAll = true;\n', '\n', '        for (uint i = 0; i < _admins.length; i++) {\n', '            var admin = _admins[i];\n', '            if (!isAdmin(admin)) {\n', '                admins.push(admin);\n', '            }\n', '        }\n', '\n', '        deposit();\n', '    }\n', '\n', '    function () payable {\n', '        deposit();\n', '    }\n', '\n', '    function close() public onlyAdmins onState(State.Open) {\n', '        state = State.Closed;\n', '    }\n', '\n', '    function open() public onlyAdmins onState(State.Closed) {\n', '        state = State.Open;\n', '    }\n', '\n', '    function fail() public onlyAdmins stateAllowsConfiguration {\n', '        state = State.Failed;\n', '    }\n', '\n', '    function payToPresale(address _presaleAddress) public onlyAdmins onState(State.Closed) {\n', '        state = State.Paid;\n', '        presaleAddress = _presaleAddress;\n', '        refundable = true;\n', '        presaleAddress.transfer(poolTotal);\n', '    }\n', '\n', '    function refundPresale() payable public onState(State.Paid) {\n', '        require(refundable && msg.value >= poolTotal);\n', '        require(msg.sender == presaleAddress || isAdmin(msg.sender));\n', '        gasFundTotal = msg.value - poolTotal;\n', '        state = State.Failed;\n', '    }\n', '\n', '    function setToken(address tokenAddress) public onlyAdmins {\n', '        token = ERC20(tokenAddress);\n', '    }\n', '\n', '    function withdrawAll() public {\n', '        uint total = balances[msg.sender].remaining;\n', '        balances[msg.sender].remaining = 0;\n', '\n', '        if (state == State.Open || state == State.Failed) {\n', '            total += balances[msg.sender].contribution;\n', '            if (gasFundTotal > 0) {\n', '                uint gasRefund = (balances[msg.sender].contribution * gasFundTotal) / (poolTotal);\n', '                gasFundTotal -= gasRefund;\n', '                total += gasRefund;\n', '            }\n', '            poolTotal -= balances[msg.sender].contribution;\n', '            balances[msg.sender].contribution = 0;\n', '        } else {\n', '            require(state == State.Paid);\n', '        }\n', '\n', '        msg.sender.transfer(total);\n', '        Withdrawl(msg.sender, total);\n', '    }\n', '\n', '    function withdraw(uint amount) public onState(State.Open) {\n', '        uint total = balances[msg.sender].remaining + balances[msg.sender].contribution;\n', '        require(total >= amount);\n', '        uint debit = min(balances[msg.sender].remaining, amount);\n', '        balances[msg.sender].remaining -= debit;\n', '        debit = amount - debit;\n', '        balances[msg.sender].contribution -= debit;\n', '        poolTotal -= debit;\n', '\n', '        (balances[msg.sender].contribution, balances[msg.sender].remaining) = getContribution(msg.sender, 0);\n', '        // must respect the minContribution limit\n', '        require(balances[msg.sender].remaining == 0 || balances[msg.sender].contribution > 0);\n', '        msg.sender.transfer(amount);\n', '        Withdrawl(msg.sender, amount);\n', '    }\n', '\n', '    function transferMyTokens() public onState(State.Paid) noReentrancy {\n', '        uint tokenBalance = token.balanceOf(address(this));\n', '        require(tokenBalance > 0);\n', '\n', '        uint participantContribution = balances[msg.sender].contribution;\n', '        uint participantShare = participantContribution * tokenBalance / poolTotal;\n', '\n', '        poolTotal -= participantContribution;\n', '        balances[msg.sender].contribution = 0;\n', '        refundable = false;\n', '        require(token.transfer(msg.sender, participantShare));\n', '\n', '        Payout(msg.sender, participantShare);\n', '    }\n', '\n', '    address[] public failures;\n', '    function transferAllTokens() public onlyAdmins onState(State.Paid) noReentrancy returns (address[]) {\n', '        uint tokenBalance = token.balanceOf(address(this));\n', '        require(tokenBalance > 0);\n', '        delete failures;\n', '\n', '        for (uint i = 0; i < participants.length; i++) {\n', '            address participant = participants[i];\n', '            uint participantContribution = balances[participant].contribution;\n', '\n', '            if (participantContribution > 0) {\n', '                uint participantShare = participantContribution * tokenBalance / poolTotal;\n', '\n', '                poolTotal -= participantContribution;\n', '                balances[participant].contribution = 0;\n', '\n', '                if (token.transfer(participant, participantShare)) {\n', '                    refundable = false;\n', '                    Payout(participant, participantShare);\n', '                    tokenBalance -= participantShare;\n', '                    if (tokenBalance == 0) {\n', '                        break;\n', '                    }\n', '                } else {\n', '                    balances[participant].contribution = participantContribution;\n', '                    poolTotal += participantContribution;\n', '                    failures.push(participant);\n', '                }\n', '            }\n', '        }\n', '\n', '        return failures;\n', '    }\n', '\n', '    function modifyWhitelist(address[] toInclude, address[] toExclude) public onlyAdmins stateAllowsConfiguration {\n', '        bool previous = whitelistAll;\n', '        uint i;\n', '        if (previous) {\n', '            require(toExclude.length == 0);\n', '            for (i = 0; i < participants.length; i++) {\n', '                balances[participants[i]].whitelisted = false;\n', '            }\n', '            whitelistAll = false;\n', '        }\n', '\n', '        for (i = 0; i < toInclude.length; i++) {\n', '            balances[toInclude[i]].whitelisted = true;\n', '        }\n', '\n', '        address excludedParticipant;\n', '        uint contribution;\n', '        if (previous) {\n', '            for (i = 0; i < participants.length; i++) {\n', '                excludedParticipant = participants[i];\n', '                if (!balances[excludedParticipant].whitelisted) {\n', '                    contribution = balances[excludedParticipant].contribution;\n', '                    balances[excludedParticipant].contribution = 0;\n', '                    balances[excludedParticipant].remaining += contribution;\n', '                    poolTotal -= contribution;\n', '                }\n', '            }\n', '        } else {\n', '            for (i = 0; i < toExclude.length; i++) {\n', '                excludedParticipant = toExclude[i];\n', '                balances[excludedParticipant].whitelisted = false;\n', '                contribution = balances[excludedParticipant].contribution;\n', '                balances[excludedParticipant].contribution = 0;\n', '                balances[excludedParticipant].remaining += contribution;\n', '                poolTotal -= contribution;\n', '            }\n', '        }\n', '    }\n', '\n', '    function removeWhitelist() public onlyAdmins stateAllowsConfiguration {\n', '        if (!whitelistAll) {\n', '            whitelistAll = true;\n', '            for (uint i = 0; i < participants.length; i++) {\n', '                balances[participants[i]].whitelisted = true;\n', '            }\n', '        }\n', '    }\n', '\n', '    function setContributionSettings(uint _minContribution, uint _maxContribution, uint _maxPoolTotal) public onlyAdmins stateAllowsConfiguration {\n', '        // we raised the minContribution threshold\n', '        bool recompute = (minContribution < _minContribution);\n', '        // we lowered the maxContribution threshold\n', '        recompute = recompute || (maxContribution > _maxContribution);\n', '        // we did not have a maxContribution threshold and now we do\n', '        recompute = recompute || (maxContribution == 0 && _maxContribution > 0);\n', '        // we want to make maxPoolTotal lower than the current pool total\n', '        recompute = recompute || (poolTotal > _maxPoolTotal);\n', '\n', '        minContribution = _minContribution;\n', '        maxContribution = _maxContribution;\n', '        maxPoolTotal = _maxPoolTotal;\n', '\n', '        if (maxContribution > 0) {\n', '            require(maxContribution >= minContribution);\n', '        }\n', '        if (maxPoolTotal > 0) {\n', '            require(maxPoolTotal >= minContribution);\n', '            require(maxPoolTotal >= maxContribution);\n', '        }\n', '\n', '        if (recompute) {\n', '            poolTotal = 0;\n', '            for (uint i = 0; i < participants.length; i++) {\n', '                address participant = participants[i];\n', '                var balance = balances[participant];\n', '                (balance.contribution, balance.remaining) = getContribution(participant, 0);\n', '                poolTotal += balance.contribution;\n', '            }\n', '        }\n', '    }\n', '\n', '    function getParticipantBalances() public returns(address[], uint[], uint[], bool[], bool[]) {\n', '        uint[] memory contribution = new uint[](participants.length);\n', '        uint[] memory remaining = new uint[](participants.length);\n', '        bool[] memory whitelisted = new bool[](participants.length);\n', '        bool[] memory exists = new bool[](participants.length);\n', '\n', '        for (uint i = 0; i < participants.length; i++) {\n', '            var balance = balances[participants[i]];\n', '            contribution[i] = balance.contribution;\n', '            remaining[i] = balance.remaining;\n', '            whitelisted[i] = balance.whitelisted;\n', '            exists[i] = balance.exists;\n', '        }\n', '\n', '        return (participants, contribution, remaining, whitelisted, exists);\n', '    }\n', '\n', '    function deposit() internal onState(State.Open) {\n', '        if (msg.value > 0) {\n', '            require(included(msg.sender));\n', '            (balances[msg.sender].contribution, balances[msg.sender].remaining) = getContribution(msg.sender, msg.value);\n', '            // must respect the maxContribution and maxPoolTotal limits\n', '            require(balances[msg.sender].remaining == 0);\n', '            balances[msg.sender].whitelisted = true;\n', '            poolTotal += msg.value;\n', '            if (!balances[msg.sender].exists) {\n', '                balances[msg.sender].exists = true;\n', '                participants.push(msg.sender);\n', '            }\n', '            Deposit(msg.sender, msg.value);\n', '        }\n', '    }\n', '\n', '    function isAdmin(address addr) internal constant returns (bool) {\n', '        for (uint i = 0; i < admins.length; i++) {\n', '            if (admins[i] == addr) {\n', '                return true;\n', '            }\n', '        }\n', '        return false;\n', '    }\n', '\n', '    function included(address participant) internal constant returns (bool) {\n', '        return whitelistAll || balances[participant].whitelisted || isAdmin(participant);\n', '    }\n', '\n', '    function getContribution(address participant, uint amount) internal constant returns (uint, uint) {\n', '        var balance = balances[participant];\n', '        uint total = balance.remaining + balance.contribution + amount;\n', '        uint contribution = total;\n', '        if (!included(participant)) {\n', '            return (0, total);\n', '        }\n', '        if (maxContribution > 0) {\n', '            contribution = min(maxContribution, contribution);\n', '        }\n', '        if (maxPoolTotal > 0) {\n', '            contribution = min(maxPoolTotal - poolTotal, contribution);\n', '        }\n', '        if (contribution < minContribution) {\n', '            return (0, total);\n', '        }\n', '        return (contribution, total - contribution);\n', '    }\n', '\n', '    function min(uint a, uint b) internal pure returns (uint _min) {\n', '        if (a < b) {\n', '            return a;\n', '        }\n', '        return b;\n', '    }\n', '}']