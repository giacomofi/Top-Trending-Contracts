['pragma solidity ^0.4.16;\n', '\n', 'interface Token {\n', '    function transferFrom(address _from, address _to, uint256 _value) external;\n', '}\n', '\n', 'contract SGEICO {\n', '\n', '    Token public tokenReward;\n', '    address public creator;\n', '    address public owner = 0x8dfFcCE1d47C6325340712AB1B8fD7328075730C;\n', '\n', '    uint256 public price;\n', '    uint256 public startDate;\n', '    uint256 public endDate;\n', '\n', '    modifier isCreator() {\n', '        require(msg.sender == creator);\n', '        _;\n', '    }\n', '\n', '    event FundTransfer(address backer, uint amount, bool isContribution);\n', '\n', '    constructor () public {\n', '        creator = msg.sender;\n', '        startDate = 1544565011;\n', '        endDate = 1554076799;\n', '        price = 460;\n', '        tokenReward = Token(0x40489719E489782959486A04B765E1E93E5B221a);\n', '    }\n', '\n', '    function setOwner(address _owner) isCreator public {\n', '        owner = _owner;\n', '    }\n', '\n', '    function setCreator(address _creator) isCreator public {\n', '        creator = _creator;\n', '    }\n', '\n', '    function setStartDate(uint256 _startDate) isCreator public {\n', '        startDate = _startDate;\n', '    }\n', '\n', '    function setEndtDate(uint256 _endDate) isCreator public {\n', '        endDate = _endDate;\n', '    }\n', '\n', '    function setPrice(uint256 _price) isCreator public {\n', '        price = _price;\n', '    }\n', '\n', '    function setToken(address _token) isCreator public {\n', '        tokenReward = Token(_token);\n', '    }\n', '\n', '    function kill() isCreator public {\n', '        selfdestruct(owner);\n', '    }\n', '\n', '    function () payable public {\n', '        require(msg.value >= 1 ether);\n', '        require(now > startDate);\n', '        require(now < endDate);\n', '\t    uint amount = msg.value * price;\n', '        uint _amount = amount / 4;\n', '        amount += _amount;\n', '        tokenReward.transferFrom(owner, msg.sender, amount);\n', '        emit FundTransfer(msg.sender, amount, true);\n', '        owner.transfer(msg.value);\n', '    }\n', '}']