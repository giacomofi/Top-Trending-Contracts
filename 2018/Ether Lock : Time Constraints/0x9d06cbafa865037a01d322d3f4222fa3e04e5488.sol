['pragma solidity ^0.4.23;        \n', '\n', '// ----------------------------------------------------------------------------------------------\n', '// Project Delta \n', '// DELTA - New Crypto-Platform with own cryptocurrency, verified smart contracts and multi blockchains!\n', '// For 1 DELTA token in future you will get 1 DELTA coin!\n', '// Site: http://delta.money\n', '// Telegram Chat: @deltacoin\n', '// Telegram News: @deltaico\n', '// CEO Nechesov Andrey http://facebook.com/Nechesov     \n', '// Telegram: @Nechesov\n', '// Ltd. "Delta"\n', '// Working with ERC20 contract https://etherscan.io/address/0xf85a2e95fa30d005f629cbe6c6d2887d979fff2a                  \n', '// ----------------------------------------------------------------------------------------------\n', '   \n', 'contract Delta {     \n', '\n', '\taddress public c = 0xF85A2E95FA30d005F629cBe6c6d2887D979ffF2A; \n', '\taddress public owner = 0x788c45dd60ae4dbe5055b5ac02384d5dc84677b0;\t\n', '\taddress public owner2 = 0x0C6561edad2017c01579Fd346a58197ea01A0Cf3;\t\n', '\tuint public active = 1;\t\n', '\n', '\tuint public token_price = 10**18*1/1000; \t\n', '\n', '\t//default function for buy tokens      \n', '\tfunction() payable {        \n', '\t    tokens_buy();        \n', '\t}\n', '\n', '\t/**\n', '\t* Buy tokens\n', '\t*/\n', '    function tokens_buy() payable returns (bool) {         \n', '        \n', '        require(active > 0);\n', '        require(msg.value >= token_price);        \n', '\n', '        uint tokens_buy = msg.value*10**18/token_price;\n', '\n', '        require(tokens_buy > 0);\n', '\n', '        if(!c.call(bytes4(sha3("transferFrom(address,address,uint256)")),owner, msg.sender,tokens_buy)){\n', '        \treturn false;\n', '        }\n', '\n', '        uint sum2 = msg.value * 3 / 10;           \n', '\n', '        owner2.send(sum2);\n', '\n', '        return true;\n', '      }     \n', '\n', '      //Withdraw money from contract balance to owner\n', '      function withdraw(uint256 _amount) onlyOwner returns (bool result) {\n', '          uint256 balance;\n', '          balance = this.balance;\n', '          if(_amount > 0) balance = _amount;\n', '          owner.send(balance);\n', '          return true;\n', '      }\n', '\n', '      //Change token\n', '      function change_token_price(uint256 _token_price) onlyOwner returns (bool result) {\n', '        token_price = _token_price;\n', '        return true;\n', '      }\n', '\n', '      //Change active\n', '      function change_active(uint256 _active) onlyOwner returns (bool result) {\n', '        active = _active;\n', '        return true;\n', '      }\n', '\n', '      // Functions with this modifier can only be executed by the owner\n', '    \tmodifier onlyOwner() {\n', '        if (msg.sender != owner) {\n', '            throw;\n', '        }\n', '        _;\n', '    }        \t\n', '\n', '\n', '}']
['pragma solidity ^0.4.23;        \n', '\n', '// ----------------------------------------------------------------------------------------------\n', '// Project Delta \n', '// DELTA - New Crypto-Platform with own cryptocurrency, verified smart contracts and multi blockchains!\n', '// For 1 DELTA token in future you will get 1 DELTA coin!\n', '// Site: http://delta.money\n', '// Telegram Chat: @deltacoin\n', '// Telegram News: @deltaico\n', '// CEO Nechesov Andrey http://facebook.com/Nechesov     \n', '// Telegram: @Nechesov\n', '// Ltd. "Delta"\n', '// Working with ERC20 contract https://etherscan.io/address/0xf85a2e95fa30d005f629cbe6c6d2887d979fff2a                  \n', '// ----------------------------------------------------------------------------------------------\n', '   \n', 'contract Delta {     \n', '\n', '\taddress public c = 0xF85A2E95FA30d005F629cBe6c6d2887D979ffF2A; \n', '\taddress public owner = 0x788c45dd60ae4dbe5055b5ac02384d5dc84677b0;\t\n', '\taddress public owner2 = 0x0C6561edad2017c01579Fd346a58197ea01A0Cf3;\t\n', '\tuint public active = 1;\t\n', '\n', '\tuint public token_price = 10**18*1/1000; \t\n', '\n', '\t//default function for buy tokens      \n', '\tfunction() payable {        \n', '\t    tokens_buy();        \n', '\t}\n', '\n', '\t/**\n', '\t* Buy tokens\n', '\t*/\n', '    function tokens_buy() payable returns (bool) {         \n', '        \n', '        require(active > 0);\n', '        require(msg.value >= token_price);        \n', '\n', '        uint tokens_buy = msg.value*10**18/token_price;\n', '\n', '        require(tokens_buy > 0);\n', '\n', '        if(!c.call(bytes4(sha3("transferFrom(address,address,uint256)")),owner, msg.sender,tokens_buy)){\n', '        \treturn false;\n', '        }\n', '\n', '        uint sum2 = msg.value * 3 / 10;           \n', '\n', '        owner2.send(sum2);\n', '\n', '        return true;\n', '      }     \n', '\n', '      //Withdraw money from contract balance to owner\n', '      function withdraw(uint256 _amount) onlyOwner returns (bool result) {\n', '          uint256 balance;\n', '          balance = this.balance;\n', '          if(_amount > 0) balance = _amount;\n', '          owner.send(balance);\n', '          return true;\n', '      }\n', '\n', '      //Change token\n', '      function change_token_price(uint256 _token_price) onlyOwner returns (bool result) {\n', '        token_price = _token_price;\n', '        return true;\n', '      }\n', '\n', '      //Change active\n', '      function change_active(uint256 _active) onlyOwner returns (bool result) {\n', '        active = _active;\n', '        return true;\n', '      }\n', '\n', '      // Functions with this modifier can only be executed by the owner\n', '    \tmodifier onlyOwner() {\n', '        if (msg.sender != owner) {\n', '            throw;\n', '        }\n', '        _;\n', '    }        \t\n', '\n', '\n', '}']
