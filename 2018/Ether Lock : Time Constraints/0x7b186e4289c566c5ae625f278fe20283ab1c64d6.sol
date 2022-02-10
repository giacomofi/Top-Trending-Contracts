['pragma solidity ^0.4.16;\n', '\n', 'interface Token {\n', '    function transfer(address _to, uint256 _value) external;\n', '}\n', '\n', 'contract TPCCrowdsale {\n', '    \n', '    Token public tokenReward;\n', '    address public creator;\n', '    address public owner = 0x1a7416F68b0e7D917Baa86010BD8FF2B0e5C12a0;\n', '\n', '    uint256 public startDate;\n', '\n', '    modifier isCreator() {\n', '        require(msg.sender == creator);\n', '        _;\n', '    }\n', '\n', '    event FundTransfer(address backer, uint amount, bool isContribution);\n', '\n', '    function TPCCrowdsale() public {\n', '        creator = msg.sender;\n', '        startDate = now;\n', '        tokenReward = Token(0x414B23B9deb0dA531384c5Db2ac5a99eE2e07a57);\n', '    }\n', '\n', '    function setOwner(address _owner) isCreator public {\n', '        owner = _owner;      \n', '    }\n', '\n', '    function setCreator(address _creator) isCreator public {\n', '        creator = _creator;      \n', '    }\n', '\n', '    function setStartDate(uint256 _startDate) isCreator public {\n', '        startDate = _startDate;      \n', '    }\n', '\n', '    function setToken(address _token) isCreator public {\n', '        tokenReward = Token(_token);      \n', '    }\n', '\n', '    function sendToken(address _to, uint256 _value) isCreator public {\n', '        tokenReward.transfer(_to, _value);      \n', '    }\n', '\n', '    function kill() isCreator public {\n', '        selfdestruct(owner);\n', '    }\n', '\n', '    function () payable public {\n', '        require(msg.value > 0);\n', '        require(now > startDate);\n', '        uint256 amount;\n', '        uint256 _amount;\n', '        \n', '        // Pre-sale period\n', '        if (now > startDate && now < 1519862400) {\n', '            amount = msg.value * 12477;\n', '            _amount = amount / 5;\n', '            amount += _amount * 3;\n', '        }\n', '\n', '        // Spring period\n', '        if (now > 1519862399 && now < 1527807600) {\n', '            amount = msg.value * 12477;\n', '            _amount = amount / 5;\n', '            amount += _amount * 2;\n', '        }\n', '\n', '        // Summer period\n', '        if (now > 1527807599 && now < 1535756400) {\n', '            amount = msg.value * 6238;\n', '            _amount = amount / 10;\n', '            amount += _amount * 3;\n', '        }\n', '\n', '        // Autumn period\n', '        if (now > 1535756399 && now < 1543622400) {\n', '            amount = msg.value * 3119;\n', '            _amount = amount / 5;\n', '            amount += _amount;\n', '        }\n', '\n', '        // Winter period\n', '        if (now > 1543622399 && now < 1551398400) {\n', '            amount = msg.value * 1559;\n', '            _amount = amount / 10;\n', '            amount += _amount;\n', '        }\n', '        \n', '        // 1-10 ETH\n', '        if (msg.value >= 1 ether && msg.value < 10 ether) {\n', '            _amount = amount / 10;\n', '            amount += _amount * 3;\n', '        }\n', '\n', '        // 10 ETH\n', '        if (msg.value >= 10 ether) {\n', '            amount += amount / 2;\n', '        }\n', '\n', '        tokenReward.transfer(msg.sender, amount);\n', '        FundTransfer(msg.sender, amount, true);\n', '        owner.transfer(msg.value);\n', '    }\n', '}']