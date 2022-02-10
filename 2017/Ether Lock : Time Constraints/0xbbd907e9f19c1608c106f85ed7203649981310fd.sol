['pragma solidity ^0.4.16;\n', '\n', 'interface Token {\n', '    function transfer(address receiver, uint amount) public;\n', '}\n', '\n', 'contract WRTCrowdsale {\n', '    \n', '    Token public tokenReward;\n', '    address creator;\n', '    address owner = 0x7f9c7CB1e4A8870849BF481D35EF088d6a456dbD;\n', '\n', '    uint256 public startDate;\n', '    uint256 public endDate;\n', '    uint256 public price;\n', '\n', '    event FundTransfer(address backer, uint amount, bool isContribution);\n', '\n', '    function WRTCrowdsale() public {\n', '        creator = msg.sender;\n', '        startDate = 1514329200;     // 27/12/2017\n', '        endDate = 1521586800;       // 20/03/2018\n', '        price = 500;\n', '        tokenReward = Token(0x973dc0c65B3eF4267394Cf9A1Fa1582827D9053f);\n', '    }\n', '\n', '    function setOwner(address _owner) public {\n', '        require(msg.sender == creator);\n', '        owner = _owner;      \n', '    }\n', '\n', '    function setCreator(address _creator) public {\n', '        require(msg.sender == creator);\n', '        creator = _creator;      \n', '    }    \n', '\n', '    function setStartDate(uint256 _startDate) public {\n', '        require(msg.sender == creator);\n', '        startDate = _startDate;      \n', '    }\n', '\n', '    function setEndDate(uint256 _endDate) public {\n', '        require(msg.sender == creator);\n', '        endDate = _endDate;      \n', '    }\n', '\n', '    function setPrice(uint256 _price) public {\n', '        require(msg.sender == creator);\n', '        price = _price;      \n', '    }\n', '\n', '    function sendToken(address receiver, uint amount) public {\n', '        require(msg.sender == creator);\n', '        tokenReward.transfer(receiver, amount);\n', '        FundTransfer(receiver, amount, true);    \n', '    }\n', '\n', '    function () payable public {\n', '        require(msg.value > 0);\n', '        require(now > startDate);\n', '        require(now < endDate);\n', '        uint amount = msg.value * price;\n', '\n', '        // Pre-sale 12/27   01/27\n', '        if(now > startDate && now < 1517094000) {\n', '            amount += amount / 2;\n', '        }\n', '\n', '        // Pre-ICO  02/01   02/28\n', '        if(now > 1517439600 && now < 1519772400) {\n', '            amount += amount / 3;\n', '        }\n', '\n', '        // ICO      03/10   03/20\n', '        if(now > 1520636400 && now < 1521500400) {\n', '            amount += amount / 4;\n', '        }\n', '        \n', '        tokenReward.transfer(msg.sender, amount);\n', '        FundTransfer(msg.sender, amount, true);\n', '        owner.transfer(msg.value);\n', '    }\n', '}']