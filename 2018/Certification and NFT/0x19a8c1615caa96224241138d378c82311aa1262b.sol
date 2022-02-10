['pragma solidity ^0.4.16;\n', '\n', 'interface token {\n', '    function transfer(address receiver, uint amount);\n', '}\n', '\n', 'contract NyronChain_Crowdsale {\n', '    address public beneficiary;\n', '    uint public amountRaised;\n', '    uint public rate;\n', '    uint public softcap;\n', '    token public tokenReward;\n', '    mapping(address => uint256) public balanceOf;\n', '    bool public crowdsaleClosed = false;\n', '\n', '    event GoalReached(address recipient, uint totalAmountRaised);\n', '    event FundTransfer(address backer, uint amount, bool isContribution);\n', '\n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Setup the owner\n', '     */\n', '    function NyronChain_Crowdsale() {\n', '        beneficiary = 0x618a6e3DA0A159937917DC600D49cAd9d0054A70;\n', '        rate = 1800;\n', '        softcap = 5560 * 1 ether;\n', '        tokenReward = token(0xE65a20195d53DD00f915d2bE49e55ffDB46380D7);\n', '    }\n', '    \n', '    /**\n', '     * Fallback function\n', '     *\n', '     * The function without name is the default function that is called whenever anyone sends funds to a contract\n', '     */\n', '    function () payable {\n', '        require(msg.value > 0);\n', '            uint amount = msg.value;\n', '            balanceOf[msg.sender] += amount;\n', '            amountRaised += amount;\n', '            if(!crowdsaleClosed){ \n', '            if(amountRaised >= softcap){\n', '                tokenReward.transfer(msg.sender, amount * rate);\n', '            }else {\n', '                tokenReward.transfer(msg.sender, amount * rate + amount * rate * 20 / 100);\n', '            }}\n', '            FundTransfer(msg.sender, amount, true);\n', '    }\n', '     \n', '     /**\n', '     * Open the crowdsale\n', '     * \n', '     */\n', '    function openCrowdsale() {\n', '        if(beneficiary == msg.sender){\n', '            crowdsaleClosed = false;\n', '        }\n', '    }\n', '    \n', '    \n', '    /**\n', '     * Close the crowdsale\n', '     * \n', '     */\n', '    function endCrowdsale() {\n', '        if(beneficiary == msg.sender){\n', '            crowdsaleClosed = true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Withdraw the funds\n', '     *\n', '     * Sends the entire amount to the beneficiary. \n', '     */\n', '    function safeWithdrawal() {\n', '        if(beneficiary == msg.sender){\n', '            if (beneficiary.send(amountRaised)) {\n', '                FundTransfer(beneficiary, amountRaised, false);\n', '            }\n', '        }\n', '    }\n', '}']
['pragma solidity ^0.4.16;\n', '\n', 'interface token {\n', '    function transfer(address receiver, uint amount);\n', '}\n', '\n', 'contract NyronChain_Crowdsale {\n', '    address public beneficiary;\n', '    uint public amountRaised;\n', '    uint public rate;\n', '    uint public softcap;\n', '    token public tokenReward;\n', '    mapping(address => uint256) public balanceOf;\n', '    bool public crowdsaleClosed = false;\n', '\n', '    event GoalReached(address recipient, uint totalAmountRaised);\n', '    event FundTransfer(address backer, uint amount, bool isContribution);\n', '\n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Setup the owner\n', '     */\n', '    function NyronChain_Crowdsale() {\n', '        beneficiary = 0x618a6e3DA0A159937917DC600D49cAd9d0054A70;\n', '        rate = 1800;\n', '        softcap = 5560 * 1 ether;\n', '        tokenReward = token(0xE65a20195d53DD00f915d2bE49e55ffDB46380D7);\n', '    }\n', '    \n', '    /**\n', '     * Fallback function\n', '     *\n', '     * The function without name is the default function that is called whenever anyone sends funds to a contract\n', '     */\n', '    function () payable {\n', '        require(msg.value > 0);\n', '            uint amount = msg.value;\n', '            balanceOf[msg.sender] += amount;\n', '            amountRaised += amount;\n', '            if(!crowdsaleClosed){ \n', '            if(amountRaised >= softcap){\n', '                tokenReward.transfer(msg.sender, amount * rate);\n', '            }else {\n', '                tokenReward.transfer(msg.sender, amount * rate + amount * rate * 20 / 100);\n', '            }}\n', '            FundTransfer(msg.sender, amount, true);\n', '    }\n', '     \n', '     /**\n', '     * Open the crowdsale\n', '     * \n', '     */\n', '    function openCrowdsale() {\n', '        if(beneficiary == msg.sender){\n', '            crowdsaleClosed = false;\n', '        }\n', '    }\n', '    \n', '    \n', '    /**\n', '     * Close the crowdsale\n', '     * \n', '     */\n', '    function endCrowdsale() {\n', '        if(beneficiary == msg.sender){\n', '            crowdsaleClosed = true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Withdraw the funds\n', '     *\n', '     * Sends the entire amount to the beneficiary. \n', '     */\n', '    function safeWithdrawal() {\n', '        if(beneficiary == msg.sender){\n', '            if (beneficiary.send(amountRaised)) {\n', '                FundTransfer(beneficiary, amountRaised, false);\n', '            }\n', '        }\n', '    }\n', '}']