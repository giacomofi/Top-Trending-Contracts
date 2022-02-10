['pragma solidity ^0.4.18;\n', '\n', 'interface token {\n', '    function transfer(address receiver, uint amount) external;\n', '}\n', '\n', 'contract Crowdsale {\n', '    address public beneficiary;\n', '    uint public start;\n', '    token public tokenReward;\n', '    \n', '    uint public amountRaised;\n', '    mapping(address => uint256) public contributionOf;\n', '\n', '    event FundTransfer(address backer, uint amount, bool isContribution);\n', '\n', '    /**\n', '     * Constructor function\n', '     *\n', '     * Setup the owner and ERC20 token\n', '     */\n', '    function Crowdsale(\n', '        address sendTo,\n', '        address addressOfTokenUsedAsReward\n', '    ) public {\n', '        beneficiary = sendTo;\n', '        tokenReward = token(addressOfTokenUsedAsReward);\n', '        start = now;\n', '    }\n', '\n', '    /**\n', '     * Fallback function\n', '     *\n', '     * The function without name is the default function that is called whenever anyone sends funds to the contract\n', '     */\n', '    function () payable public {\n', '        require(now < start + 120 days);\n', '        uint amount = msg.value;\n', '\t\t\n', '\t\tuint price = 200000000000 wei;\n', '\t\t\n', '\t\tif (now < start + 90 days) {\n', '\t\t\tprice = 190000000000 wei;\n', '\t\t}\t\t\n', '\t\tif (now < start + 60 days) {\n', '\t\t\tprice = 180000000000 wei;\n', '\t\t}\t\t\n', '\t\tif (now < start + 30 days) {\n', '\t\t\tprice = 170000000000 wei;\n', '\t\t}\n', '\t\t\n', '        contributionOf[msg.sender] += amount;\n', '        amountRaised += amount;\n', '        tokenReward.transfer(msg.sender, amount * 10 ** uint256(18) / price);\n', '        emit FundTransfer(msg.sender, amount, true);\n', '    }\n', '\n', '    /**\n', '     * Withdraw function\n', '     *\n', '     * Sends the specified amount to the beneficiary. \n', '     */\n', '    function withdrawal(uint amount) public {\n', '        if (beneficiary == msg.sender) {\n', '            if (beneficiary.send(amount)) {\n', '               emit FundTransfer(beneficiary, amountRaised, false);\n', '            } \n', '        }\n', '    }\n', '}']