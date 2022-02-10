['pragma solidity ^0.4.16;\n', '\n', 'contract CrowdsaleRC {\n', '    uint public createdTimestamp; uint public start; uint public deadline;\n', '    address public owner;\n', '    address public beneficiary;\n', '    uint public amountRaised;\n', '    uint public maxAmount;\n', '    mapping(address => uint256) public balanceOf;\n', '    mapping (address => bool) public whitelist;\n', '    event FundTransfer(address backer, uint amount, bool isContribution);\n', '\n', '    function CrowdsaleRC () public {\n', '        createdTimestamp = block.timestamp;\n', '        start = 1529316000;\n', '        deadline = 1532080800;\n', '        amountRaised = 0;\n', '        beneficiary = 0xD27eAD21C9564f122c8f84cD98a505efDf547665;\n', '        owner = msg.sender;\n', '        maxAmount = 2000 ether;\n', '    }\n', '\n', '    function () payable public {\n', '        require( (msg.value >= 0.1 ether) &&  block.timestamp >= start && block.timestamp <= deadline && amountRaised < maxAmount\n', '        && ( (msg.value <= 100 ether) || (msg.value > 100 ether && whitelist[msg.sender]==true) )\n', '        );\n', '\n', '        uint amount = msg.value;\n', '        balanceOf[msg.sender] += amount;\n', '        amountRaised += amount;\n', '        FundTransfer(msg.sender, amount, true);\n', '        if (beneficiary.send(amount)) {\n', '            FundTransfer(beneficiary, amount, false);\n', '        }\n', '    }\n', '\n', '    function whitelistAddress (address uaddress) public {\n', '        require (owner == msg.sender || beneficiary == msg.sender);\n', '        whitelist[uaddress] = true;\n', '    }\n', '\n', '    function removeAddressFromWhitelist (address uaddress) public {\n', '        require (owner == msg.sender || beneficiary == msg.sender);\n', '        whitelist[uaddress] = false;\n', '    }\n', '}']
['pragma solidity ^0.4.16;\n', '\n', 'contract CrowdsaleRC {\n', '    uint public createdTimestamp; uint public start; uint public deadline;\n', '    address public owner;\n', '    address public beneficiary;\n', '    uint public amountRaised;\n', '    uint public maxAmount;\n', '    mapping(address => uint256) public balanceOf;\n', '    mapping (address => bool) public whitelist;\n', '    event FundTransfer(address backer, uint amount, bool isContribution);\n', '\n', '    function CrowdsaleRC () public {\n', '        createdTimestamp = block.timestamp;\n', '        start = 1529316000;\n', '        deadline = 1532080800;\n', '        amountRaised = 0;\n', '        beneficiary = 0xD27eAD21C9564f122c8f84cD98a505efDf547665;\n', '        owner = msg.sender;\n', '        maxAmount = 2000 ether;\n', '    }\n', '\n', '    function () payable public {\n', '        require( (msg.value >= 0.1 ether) &&  block.timestamp >= start && block.timestamp <= deadline && amountRaised < maxAmount\n', '        && ( (msg.value <= 100 ether) || (msg.value > 100 ether && whitelist[msg.sender]==true) )\n', '        );\n', '\n', '        uint amount = msg.value;\n', '        balanceOf[msg.sender] += amount;\n', '        amountRaised += amount;\n', '        FundTransfer(msg.sender, amount, true);\n', '        if (beneficiary.send(amount)) {\n', '            FundTransfer(beneficiary, amount, false);\n', '        }\n', '    }\n', '\n', '    function whitelistAddress (address uaddress) public {\n', '        require (owner == msg.sender || beneficiary == msg.sender);\n', '        whitelist[uaddress] = true;\n', '    }\n', '\n', '    function removeAddressFromWhitelist (address uaddress) public {\n', '        require (owner == msg.sender || beneficiary == msg.sender);\n', '        whitelist[uaddress] = false;\n', '    }\n', '}']
