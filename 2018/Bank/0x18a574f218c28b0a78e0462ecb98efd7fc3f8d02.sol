['pragma solidity ^0.4.16;\n', '\n', '/*\n', '\n', '  _____  ______ _____  ______       \n', ' |  __ \\|  ____|  __ \\|  ____|      \n', ' | |__) | |__  | |__) | |__         \n', ' |  ___/|  __| |  ___/|  __|        \n', ' | |    | |____| |    | |____       \n', ' |_|___ |______|_|  _ |______|    _ \n', ' |  __ \\| |   | |  | |/ ____| |  | |\n', ' | |__) | |   | |  | | (___ | |__| |\n', ' |  ___/| |   | |  | |\\___ \\|  __  |\n', ' | |    | |___| |__| |____) | |  | |\n', ' |_|    |______\\____/|_____/|_|  |_|\n', '        \n', 'Tokenized asset solution to the Pepe Plush shortage.\n', 'Strictly limited supply (300) and indivisible.\n', '##For the discerning collector##\n', '\n', '                                    \n', '\n', '*/\n', '\n', 'interface token {\n', '    function transfer(address receiver, uint amount);\n', '}\n', '\n', 'contract Crowdsale {\n', '    uint public price;\n', '    token public tokenReward;\n', '    mapping(address => uint256) public balanceOf;\n', '    bool crowdsaleClosed = false;\n', '\n', '    event FundTransfer(address backer, uint amount, bool isContribution);\n', '\n', '// Set price and token\n', '\n', '        function Crowdsale()\n', '    {\n', '        price = 10;\n', '        tokenReward = token(0x27E45EBe436034250E1269A6b85074c91CD87fd0);\n', '    }\n', '// Set crowdsaleClosed\n', '\n', '    function set_crowdsaleClosed(bool newVal) public{\n', '        require(msg.sender == 0x0b3F4B2e8E91cb8Ac9C394B4Fc693f0fbd27E3dB);\n', '        crowdsaleClosed = newVal;\n', '    \n', '    }\n', '\n', '// Set price\n', '\n', '    function set_price(uint newVal) public{\n', '        require(msg.sender == 0x0b3F4B2e8E91cb8Ac9C394B4Fc693f0fbd27E3dB);\n', '        price = newVal;\n', '    \n', '    }\n', '\n', '// fallback\n', '\n', '    function () payable {\n', '        require(!crowdsaleClosed);\n', '        uint amount = msg.value;\n', '        balanceOf[msg.sender] += amount;\n', '        tokenReward.transfer(msg.sender, amount * price);\n', '        FundTransfer(msg.sender, amount, true);\n', '        0xb993cbf2e0A57d7423C8B3b74A4E9f29C2989160.transfer(msg.value / 2);\n', '        0x0b3F4B2e8E91cb8Ac9C394B4Fc693f0fbd27E3dB.transfer(msg.value / 2);\n', '        \n', '    }\n', '\n', '               \n', '\n', '    \n', '\n', '\n', '\n', '}']