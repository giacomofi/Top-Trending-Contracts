['pragma solidity 0.4.24;\n', '\n', 'contract Token {\n', '    function transfer(address receiver, uint amount) public;\n', '    function balanceOf(address _address) public returns(uint);\n', '}\n', '\n', 'contract Crowdsale {\n', '\n', '    address public beneficiary;\n', '    uint public amountRaised;\n', '    uint public startTime;\n', '    uint public endTime;\n', '    uint public price;\n', '    Token public tokenReward;\n', '    address public owner;\n', '\n', '    event FundTransfer(address backer, uint amount, bool isContribution);\n', '\n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Setup the owner\n', '     */\n', '    function Crowdsale() public {\n', '        beneficiary = address(0x22dA2fC310DC5F24a107823796684A518A672aCd);\n', '        startTime = 1530650947;\n', '        endTime = 1533110399;\n', '        price = 2000;\n', '        tokenReward = Token(0x791ff572c19f711d96ce454f574958b5717ffd15);\n', '    }\n', '\n', '\n', '\n', '    function isActive() constant returns (bool) {\n', '\n', '        return (\n', '            now >= startTime && // Must be after the START date\n', '            now <= endTime // Must be before the end date\n', '            \n', '            );\n', '    }\n', '\n', '\n', '    /**\n', '     * Fallback function\n', '     *\n', '     * The function without name is the default function that is called whenever anyone sends funds to a contract\n', '     */\n', '    function () public payable {\n', '        require(isActive());\n', '        uint amount = msg.value;\n', '        amountRaised += amount;\n', '        uint TokenAmount = uint((msg.value/(10 ** 10)) * price);\n', '        tokenReward.transfer(msg.sender, TokenAmount);\n', '        beneficiary.transfer(msg.value);\n', '        FundTransfer(msg.sender, amount, true);\n', '    }\n', '\n', '    function finish() public {\n', '        require(now > endTime);\n', '        uint balance = tokenReward.balanceOf(address(this));\n', '        if(balance > 0){\n', '            tokenReward.transfer(address(0x320A83f85E5503Fc2D1aB369a2E358F94BDc4B3A), balance);\n', '        }\n', '    }\n', '\n', '}']
['pragma solidity 0.4.24;\n', '\n', 'contract Token {\n', '    function transfer(address receiver, uint amount) public;\n', '    function balanceOf(address _address) public returns(uint);\n', '}\n', '\n', 'contract Crowdsale {\n', '\n', '    address public beneficiary;\n', '    uint public amountRaised;\n', '    uint public startTime;\n', '    uint public endTime;\n', '    uint public price;\n', '    Token public tokenReward;\n', '    address public owner;\n', '\n', '    event FundTransfer(address backer, uint amount, bool isContribution);\n', '\n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Setup the owner\n', '     */\n', '    function Crowdsale() public {\n', '        beneficiary = address(0x22dA2fC310DC5F24a107823796684A518A672aCd);\n', '        startTime = 1530650947;\n', '        endTime = 1533110399;\n', '        price = 2000;\n', '        tokenReward = Token(0x791ff572c19f711d96ce454f574958b5717ffd15);\n', '    }\n', '\n', '\n', '\n', '    function isActive() constant returns (bool) {\n', '\n', '        return (\n', '            now >= startTime && // Must be after the START date\n', '            now <= endTime // Must be before the end date\n', '            \n', '            );\n', '    }\n', '\n', '\n', '    /**\n', '     * Fallback function\n', '     *\n', '     * The function without name is the default function that is called whenever anyone sends funds to a contract\n', '     */\n', '    function () public payable {\n', '        require(isActive());\n', '        uint amount = msg.value;\n', '        amountRaised += amount;\n', '        uint TokenAmount = uint((msg.value/(10 ** 10)) * price);\n', '        tokenReward.transfer(msg.sender, TokenAmount);\n', '        beneficiary.transfer(msg.value);\n', '        FundTransfer(msg.sender, amount, true);\n', '    }\n', '\n', '    function finish() public {\n', '        require(now > endTime);\n', '        uint balance = tokenReward.balanceOf(address(this));\n', '        if(balance > 0){\n', '            tokenReward.transfer(address(0x320A83f85E5503Fc2D1aB369a2E358F94BDc4B3A), balance);\n', '        }\n', '    }\n', '\n', '}']
