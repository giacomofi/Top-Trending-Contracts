['pragma solidity ^0.4.24;\n', '\n', 'interface Token {\n', '    function transfer(address _to, uint256 _value) external;\n', '}\n', '\n', 'contract ABECrowdsale {\n', '    \n', '    Token public tokenReward;\n', '    address public creator;\n', '    address public owner = 0xdc8a235Ca0D64b172a8fF89760a15A3021371c63;\n', '\n', '    uint256 public startDate;\n', '    uint256 public endDate;\n', '\n', '    event FundTransfer(address backer, uint amount);\n', '\n', '    constructor() public {\n', '        creator = msg.sender;\n', '        startDate = 1537830000;\n', '        endDate = 1543017600;\n', '        tokenReward = Token(0xa8978f8299C3017F79c8e67312A34b9C3E51C859);\n', '    }\n', '\n', '    function setOwner(address _owner) public {\n', '        require(msg.sender == creator);\n', '        owner = _owner;      \n', '    }\n', '\n', '    function setCreator(address _creator) public {\n', '        require(msg.sender == creator);\n', '        creator = _creator;      \n', '    }\n', '\n', '    function setStartDate(uint256 _startDate) public {\n', '        require(msg.sender == creator);\n', '        startDate = _startDate;      \n', '    }\n', '\n', '    function setEndtDate(uint256 _endDate) public {\n', '        require(msg.sender == creator);\n', '        endDate = _endDate;      \n', '    }\n', '\n', '    function setToken(address _token) public {\n', '        require(msg.sender == creator);\n', '        tokenReward = Token(_token);      \n', '    }\n', '    \n', '    function sendToken(address _to, uint256 _value) public {\n', '        require(msg.sender == creator);\n', '        tokenReward.transfer(_to, _value);      \n', '    }\n', '    \n', '    function kill() public {\n', '        require(msg.sender == creator);\n', '        selfdestruct(owner);\n', '    }\n', '\n', '    function () payable public {\n', '        require(msg.value > 0);\n', '        require(now > startDate);\n', '        require(now < endDate);\n', '        uint256 amount = msg.value / 10000000000;\n', '        \n', '        // Pre-Sale\n', '        if(now > 1537830000 && now < 1539126000) {\n', '            amount = amount * 10000;\n', '        }\n', '        \n', '        // Round 1\n', '        if(now > 1539126000 && now < 1540422000) {\n', '            amount = msg.value * 8333;\n', '        }\n', '        \n', '        // Round 2\n', '        if(now > 1540422000 && now < 1541721600) {\n', '            amount = msg.value * 7142;\n', '        }\n', '        \n', '        // Round 3\n', '        if(now > 1541721600 && now < 1543017600) {\n', '            amount = msg.value * 6249;\n', '        }\n', '        \n', '        tokenReward.transfer(msg.sender, amount);\n', '        emit FundTransfer(msg.sender, amount);\n', '        owner.transfer(msg.value);\n', '    }\n', '}']