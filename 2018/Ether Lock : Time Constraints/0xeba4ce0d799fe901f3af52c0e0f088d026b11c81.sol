['pragma solidity ^0.4.16;\n', '\n', 'interface Token {\n', '    function transfer(address _to, uint256 _value) external;\n', '}\n', '\n', 'contract CFNDCrowdsale {\n', '    \n', '    Token public tokenReward;\n', '    address public creator;\n', '    address public owner = 0x56D215183E48881f10D1FaEb9325cf02171B16B7;\n', '\n', '    uint256 private price;\n', '\n', '    modifier isCreator() {\n', '        require(msg.sender == creator);\n', '        _;\n', '    }\n', '\n', '    event FundTransfer(address backer, uint amount, bool isContribution);\n', '\n', '    function CFNDCrowdsale() public {\n', '        creator = msg.sender;\n', '        price = 400;\n', '        tokenReward = Token(0x2a7d19F2bfd99F46322B03C2d3FdC7B7756cAe1a);\n', '    }\n', '\n', '    function setOwner(address _owner) isCreator public {\n', '        owner = _owner;      \n', '    }\n', '\n', '    function setCreator(address _creator) isCreator public {\n', '        creator = _creator;      \n', '    }\n', '\n', '    function setPrice(uint256 _price) isCreator public {\n', '        price = _price;      \n', '    }\n', '\n', '    function setToken(address _token) isCreator public {\n', '        tokenReward = Token(_token);      \n', '    }\n', '\n', '    function sendToken(address _to, uint256 _value) isCreator public {\n', '        tokenReward.transfer(_to, _value);      \n', '    }\n', '\n', '    function kill() isCreator public {\n', '        selfdestruct(owner);\n', '    }\n', '\n', '    function () payable public {\n', '        require(msg.value > 0);\n', '        require(now > 1527238800);\n', '        uint256 amount = msg.value * price;\n', '        uint256 _amount = amount / 100;\n', '\n', '        \n', '        // stage 1\n', '        if (now > 1527238800 && now < 1527670800) {\n', '            amount += _amount * 15;\n', '        }\n', '\n', '        // stage 2\n', '        if (now > 1527843600 && now < 1528189200) {\n', '            amount += _amount * 10;\n', '        }\n', '\n', '        // stage 3\n', '        if (now > 1528275600 && now < 1528621200) {\n', '            amount += _amount * 5;\n', '        }\n', '\n', '        // stage 4\n', '        if (now > 1528707600 && now < 1529053200) {\n', '            amount += _amount * 2;\n', '        }\n', '\n', '        // stage 5\n', '        require(now < 1531123200);\n', '\n', '        tokenReward.transfer(msg.sender, amount);\n', '        FundTransfer(msg.sender, amount, true);\n', '        owner.transfer(msg.value);\n', '    }\n', '}']
['pragma solidity ^0.4.16;\n', '\n', 'interface Token {\n', '    function transfer(address _to, uint256 _value) external;\n', '}\n', '\n', 'contract CFNDCrowdsale {\n', '    \n', '    Token public tokenReward;\n', '    address public creator;\n', '    address public owner = 0x56D215183E48881f10D1FaEb9325cf02171B16B7;\n', '\n', '    uint256 private price;\n', '\n', '    modifier isCreator() {\n', '        require(msg.sender == creator);\n', '        _;\n', '    }\n', '\n', '    event FundTransfer(address backer, uint amount, bool isContribution);\n', '\n', '    function CFNDCrowdsale() public {\n', '        creator = msg.sender;\n', '        price = 400;\n', '        tokenReward = Token(0x2a7d19F2bfd99F46322B03C2d3FdC7B7756cAe1a);\n', '    }\n', '\n', '    function setOwner(address _owner) isCreator public {\n', '        owner = _owner;      \n', '    }\n', '\n', '    function setCreator(address _creator) isCreator public {\n', '        creator = _creator;      \n', '    }\n', '\n', '    function setPrice(uint256 _price) isCreator public {\n', '        price = _price;      \n', '    }\n', '\n', '    function setToken(address _token) isCreator public {\n', '        tokenReward = Token(_token);      \n', '    }\n', '\n', '    function sendToken(address _to, uint256 _value) isCreator public {\n', '        tokenReward.transfer(_to, _value);      \n', '    }\n', '\n', '    function kill() isCreator public {\n', '        selfdestruct(owner);\n', '    }\n', '\n', '    function () payable public {\n', '        require(msg.value > 0);\n', '        require(now > 1527238800);\n', '        uint256 amount = msg.value * price;\n', '        uint256 _amount = amount / 100;\n', '\n', '        \n', '        // stage 1\n', '        if (now > 1527238800 && now < 1527670800) {\n', '            amount += _amount * 15;\n', '        }\n', '\n', '        // stage 2\n', '        if (now > 1527843600 && now < 1528189200) {\n', '            amount += _amount * 10;\n', '        }\n', '\n', '        // stage 3\n', '        if (now > 1528275600 && now < 1528621200) {\n', '            amount += _amount * 5;\n', '        }\n', '\n', '        // stage 4\n', '        if (now > 1528707600 && now < 1529053200) {\n', '            amount += _amount * 2;\n', '        }\n', '\n', '        // stage 5\n', '        require(now < 1531123200);\n', '\n', '        tokenReward.transfer(msg.sender, amount);\n', '        FundTransfer(msg.sender, amount, true);\n', '        owner.transfer(msg.value);\n', '    }\n', '}']