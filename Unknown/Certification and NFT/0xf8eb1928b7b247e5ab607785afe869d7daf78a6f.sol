['pragma solidity ^0.4.8;\n', '\n', 'contract token {function transfer(address receiver, uint amount){ }}\n', '\n', 'contract Crowdsale {\n', '    mapping(address => uint256) public balanceOf;\n', '\n', '    uint public amountRaised; uint public tokensCounter; uint tokensForSending;\n', '\n', '    token public tokenReward = token(0x9bB7Eb467eB11193966e726f3397d27136E79eb2);\n', '    address public beneficiary = 0xA4047af02a2Fd8e6BB43Cfe8Ab25292aC52c73f4;\n', '    bool public crowdsaleClosed = true;\n', '    bool public admin = false;\n', '    uint public price = 0.0000000333 ether;\n', '\n', '    event FundTransfer(address backer, uint amount, bool isContribution);\n', '\n', '\n', '    function () payable {\n', '        uint amount = msg.value;\n', '        if (crowdsaleClosed || amount < 0.1 ether) throw;\n', '        balanceOf[msg.sender] += amount;\n', '        amountRaised += amount;\n', '        tokensForSending = amount / price;\n', '        tokenReward.transfer(msg.sender, tokensForSending);\n', '        tokensCounter += tokensForSending;\n', '        FundTransfer(msg.sender, amount, true);\n', '        if (beneficiary.send(amount)) {\n', '            FundTransfer(beneficiary, amount, false);\n', '        }\n', '    }\n', '\n', '    function closeCrowdsale(bool closeType){\n', '        if (beneficiary == msg.sender) {\n', '            crowdsaleClosed = closeType;\n', '        }\n', '        else {\n', '            throw;\n', '        }\n', '    }\n', '\n', '    function getUnsoldTokensVal(uint val_) {\n', '        if (beneficiary == msg.sender) {\n', '            tokenReward.transfer(beneficiary, val_);\n', '        }\n', '        else {\n', '            throw;\n', '        }\n', '    }\n', '    \n', '    function checkAdmin() {\n', '        if (beneficiary == msg.sender) {\n', '            admin =  true;\n', '        }\n', '        else {\n', '            throw;\n', '        }\n', '    }\n', '}']
['pragma solidity ^0.4.8;\n', '\n', 'contract token {function transfer(address receiver, uint amount){ }}\n', '\n', 'contract Crowdsale {\n', '    mapping(address => uint256) public balanceOf;\n', '\n', '    uint public amountRaised; uint public tokensCounter; uint tokensForSending;\n', '\n', '    token public tokenReward = token(0x9bB7Eb467eB11193966e726f3397d27136E79eb2);\n', '    address public beneficiary = 0xA4047af02a2Fd8e6BB43Cfe8Ab25292aC52c73f4;\n', '    bool public crowdsaleClosed = true;\n', '    bool public admin = false;\n', '    uint public price = 0.0000000333 ether;\n', '\n', '    event FundTransfer(address backer, uint amount, bool isContribution);\n', '\n', '\n', '    function () payable {\n', '        uint amount = msg.value;\n', '        if (crowdsaleClosed || amount < 0.1 ether) throw;\n', '        balanceOf[msg.sender] += amount;\n', '        amountRaised += amount;\n', '        tokensForSending = amount / price;\n', '        tokenReward.transfer(msg.sender, tokensForSending);\n', '        tokensCounter += tokensForSending;\n', '        FundTransfer(msg.sender, amount, true);\n', '        if (beneficiary.send(amount)) {\n', '            FundTransfer(beneficiary, amount, false);\n', '        }\n', '    }\n', '\n', '    function closeCrowdsale(bool closeType){\n', '        if (beneficiary == msg.sender) {\n', '            crowdsaleClosed = closeType;\n', '        }\n', '        else {\n', '            throw;\n', '        }\n', '    }\n', '\n', '    function getUnsoldTokensVal(uint val_) {\n', '        if (beneficiary == msg.sender) {\n', '            tokenReward.transfer(beneficiary, val_);\n', '        }\n', '        else {\n', '            throw;\n', '        }\n', '    }\n', '    \n', '    function checkAdmin() {\n', '        if (beneficiary == msg.sender) {\n', '            admin =  true;\n', '        }\n', '        else {\n', '            throw;\n', '        }\n', '    }\n', '}']
