['pragma solidity ^0.4.16;\n', '\n', 'interface Token {\n', '    function transfer(address _to, uint256 _value) external;\n', '}\n', '\n', 'contract CMDCrowdsale {\n', '    \n', '    Token public tokenReward;\n', '    address public creator;\n', '    address public owner = 0x16F4b9b85Ed28F11D0b7b52B7ad48eFe217E0D48;\n', '\n', '    uint256 private tokenSold;\n', '    uint256 public price;\n', '\n', '    modifier isCreator() {\n', '        require(msg.sender == creator);\n', '        _;\n', '    }\n', '\n', '    event FundTransfer(address backer, uint amount, bool isContribution);\n', '\n', '    function CMDCrowdsale() public {\n', '        creator = msg.sender;\n', '        tokenReward = Token(0xf04eAba18e56ECA6be0f29f09082f62D3865782a);\n', '        price = 2000;\n', '    }\n', '\n', '    function setOwner(address _owner) isCreator public {\n', '        owner = _owner;      \n', '    }\n', '\n', '    function setCreator(address _creator) isCreator public {\n', '        creator = _creator;      \n', '    }\n', '\n', '    function setPrice(uint256 _price) isCreator public {\n', '        price = _price;      \n', '    }\n', '\n', '    function setToken(address _token) isCreator public {\n', '        tokenReward = Token(_token);      \n', '    }\n', '\n', '    function sendToken(address _to, uint256 _value) isCreator public {\n', '        tokenReward.transfer(_to, _value);      \n', '    }\n', '\n', '    function kill() isCreator public {\n', '        selfdestruct(owner);\n', '    }\n', '\n', '    function () payable public {\n', '        require(msg.value > 0);\n', '        uint256 amount;\n', '        uint256 bonus;\n', '        \n', '        // Private Sale\n', '        if (now > 1522018800 && now < 1523228400 && tokenSold < 42000001) {\n', '            amount = msg.value * price;\n', '            amount += amount / 3;\n', '        }\n', '\n', '        // Pre-Sale\n', '        if (now > 1523228399 && now < 1525388400 && tokenSold > 42000000 && tokenSold < 84000001) {\n', '            amount = msg.value * price;\n', '            amount += amount / 5;\n', '        }\n', '\n', '        // Public ICO\n', '        if (now > 1525388399 && now < 1530399600 && tokenSold > 84000001 && tokenSold < 140000001) {\n', '            amount = msg.value * price;\n', '            bonus = amount / 100;\n', '\n', '            if (now < 1525388399 + 1 days) {\n', '                amount += bonus * 15;\n', '            }\n', '\n', '            if (now > 1525388399 + 1 days && now < 1525388399 + 2 days) {\n', '                amount += bonus * 14;\n', '            }\n', '\n', '            if (now > 1525388399 + 2 days && now < 1525388399 + 3 days) {\n', '                amount += bonus * 13;\n', '            }\n', '\n', '            if (now > 1525388399 + 3 days && now < 1525388399 + 4 days) {\n', '                amount += bonus * 12;\n', '            }\n', '\n', '            if (now > 1525388399 + 4 days && now < 1525388399 + 5 days) {\n', '                amount += bonus * 11;\n', '            }\n', '\n', '            if (now > 1525388399 + 5 days && now < 1525388399 + 6 days) {\n', '                amount += bonus * 10;\n', '            }\n', '\n', '            if (now > 1525388399 + 6 days && now < 1525388399 + 7 days) {\n', '                amount += bonus * 9;\n', '            }\n', '\n', '            if (now > 1525388399 + 7 days && now < 1525388399 + 8 days) {\n', '                amount += bonus * 8;\n', '            }\n', '\n', '            if (now > 1525388399 + 8 days && now < 1525388399 + 9 days) {\n', '                amount += bonus * 7;\n', '            }\n', '\n', '            if (now > 1525388399 + 9 days && now < 1525388399 + 10 days) {\n', '                amount += bonus * 6;\n', '            }\n', '\n', '            if (now > 1525388399 + 10 days && now < 1525388399 + 11 days) {\n', '                amount += bonus * 5;\n', '            }\n', '\n', '            if (now > 1525388399 + 11 days && now < 1525388399 + 12 days) {\n', '                amount += bonus * 4;\n', '            }\n', '\n', '            if (now > 1525388399 + 12 days && now < 1525388399 + 13 days) {\n', '                amount += bonus * 3;\n', '            }\n', '\n', '            if (now > 1525388399 + 14 days && now < 1525388399 + 15 days) {\n', '                amount += bonus * 2;\n', '            }\n', '\n', '            if (now > 1525388399 + 15 days && now < 1525388399 + 16 days) {\n', '                amount += bonus;\n', '            }\n', '        }\n', '\n', '        tokenSold += amount / 1 ether;\n', '        tokenReward.transfer(msg.sender, amount);\n', '        FundTransfer(msg.sender, amount, true);\n', '        owner.transfer(msg.value);\n', '    }\n', '}']
['pragma solidity ^0.4.16;\n', '\n', 'interface Token {\n', '    function transfer(address _to, uint256 _value) external;\n', '}\n', '\n', 'contract CMDCrowdsale {\n', '    \n', '    Token public tokenReward;\n', '    address public creator;\n', '    address public owner = 0x16F4b9b85Ed28F11D0b7b52B7ad48eFe217E0D48;\n', '\n', '    uint256 private tokenSold;\n', '    uint256 public price;\n', '\n', '    modifier isCreator() {\n', '        require(msg.sender == creator);\n', '        _;\n', '    }\n', '\n', '    event FundTransfer(address backer, uint amount, bool isContribution);\n', '\n', '    function CMDCrowdsale() public {\n', '        creator = msg.sender;\n', '        tokenReward = Token(0xf04eAba18e56ECA6be0f29f09082f62D3865782a);\n', '        price = 2000;\n', '    }\n', '\n', '    function setOwner(address _owner) isCreator public {\n', '        owner = _owner;      \n', '    }\n', '\n', '    function setCreator(address _creator) isCreator public {\n', '        creator = _creator;      \n', '    }\n', '\n', '    function setPrice(uint256 _price) isCreator public {\n', '        price = _price;      \n', '    }\n', '\n', '    function setToken(address _token) isCreator public {\n', '        tokenReward = Token(_token);      \n', '    }\n', '\n', '    function sendToken(address _to, uint256 _value) isCreator public {\n', '        tokenReward.transfer(_to, _value);      \n', '    }\n', '\n', '    function kill() isCreator public {\n', '        selfdestruct(owner);\n', '    }\n', '\n', '    function () payable public {\n', '        require(msg.value > 0);\n', '        uint256 amount;\n', '        uint256 bonus;\n', '        \n', '        // Private Sale\n', '        if (now > 1522018800 && now < 1523228400 && tokenSold < 42000001) {\n', '            amount = msg.value * price;\n', '            amount += amount / 3;\n', '        }\n', '\n', '        // Pre-Sale\n', '        if (now > 1523228399 && now < 1525388400 && tokenSold > 42000000 && tokenSold < 84000001) {\n', '            amount = msg.value * price;\n', '            amount += amount / 5;\n', '        }\n', '\n', '        // Public ICO\n', '        if (now > 1525388399 && now < 1530399600 && tokenSold > 84000001 && tokenSold < 140000001) {\n', '            amount = msg.value * price;\n', '            bonus = amount / 100;\n', '\n', '            if (now < 1525388399 + 1 days) {\n', '                amount += bonus * 15;\n', '            }\n', '\n', '            if (now > 1525388399 + 1 days && now < 1525388399 + 2 days) {\n', '                amount += bonus * 14;\n', '            }\n', '\n', '            if (now > 1525388399 + 2 days && now < 1525388399 + 3 days) {\n', '                amount += bonus * 13;\n', '            }\n', '\n', '            if (now > 1525388399 + 3 days && now < 1525388399 + 4 days) {\n', '                amount += bonus * 12;\n', '            }\n', '\n', '            if (now > 1525388399 + 4 days && now < 1525388399 + 5 days) {\n', '                amount += bonus * 11;\n', '            }\n', '\n', '            if (now > 1525388399 + 5 days && now < 1525388399 + 6 days) {\n', '                amount += bonus * 10;\n', '            }\n', '\n', '            if (now > 1525388399 + 6 days && now < 1525388399 + 7 days) {\n', '                amount += bonus * 9;\n', '            }\n', '\n', '            if (now > 1525388399 + 7 days && now < 1525388399 + 8 days) {\n', '                amount += bonus * 8;\n', '            }\n', '\n', '            if (now > 1525388399 + 8 days && now < 1525388399 + 9 days) {\n', '                amount += bonus * 7;\n', '            }\n', '\n', '            if (now > 1525388399 + 9 days && now < 1525388399 + 10 days) {\n', '                amount += bonus * 6;\n', '            }\n', '\n', '            if (now > 1525388399 + 10 days && now < 1525388399 + 11 days) {\n', '                amount += bonus * 5;\n', '            }\n', '\n', '            if (now > 1525388399 + 11 days && now < 1525388399 + 12 days) {\n', '                amount += bonus * 4;\n', '            }\n', '\n', '            if (now > 1525388399 + 12 days && now < 1525388399 + 13 days) {\n', '                amount += bonus * 3;\n', '            }\n', '\n', '            if (now > 1525388399 + 14 days && now < 1525388399 + 15 days) {\n', '                amount += bonus * 2;\n', '            }\n', '\n', '            if (now > 1525388399 + 15 days && now < 1525388399 + 16 days) {\n', '                amount += bonus;\n', '            }\n', '        }\n', '\n', '        tokenSold += amount / 1 ether;\n', '        tokenReward.transfer(msg.sender, amount);\n', '        FundTransfer(msg.sender, amount, true);\n', '        owner.transfer(msg.value);\n', '    }\n', '}']