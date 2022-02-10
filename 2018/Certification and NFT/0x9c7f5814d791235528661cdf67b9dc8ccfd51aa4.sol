['// Copyright New Alchemy Limited, 2017. All rights reserved.\n', '\n', 'pragma solidity >=0.4.10;\n', '\n', '// Just the bits of ERC20 that we need.\n', 'contract Token {\n', '\tfunction balanceOf(address addr) returns(uint);\n', '\tfunction transfer(address to, uint amount) returns(bool);\n', '}\n', '\n', 'contract Sale {\n', '\taddress public owner;    // contract owner\n', '\taddress public newOwner; // new contract owner for two-way ownership handshake\n', '\tstring public notice;    // arbitrary public notice text\n', '\tuint public start;       // start time of sale\n', '\tuint public end;         // end time of sale\n', '\tuint public cap;         // Ether hard cap\n', '\tbool public live;        // sale is live right now\n', '\n', '\tevent StartSale();\n', '\tevent EndSale();\n', '\tevent EtherIn(address from, uint amount);\n', '\n', '\tfunction Sale() {\n', '\t\towner = msg.sender;\n', '\t}\n', '\n', '\tmodifier onlyOwner() {\n', '\t\trequire(msg.sender == owner);\n', '\t\t_;\n', '\t}\n', '\n', '\tfunction () payable {\n', '\t\trequire(block.timestamp >= start);\n', '\n', '\t\tif (block.timestamp > end || this.balance > cap) {\n', '\t\t\trequire(live);\n', '\t\t\tlive = false;\n', '\t\t\tEndSale();\n', '\t\t} else if (!live) {\n', '\t\t\tlive = true;\n', '\t\t\tStartSale();\n', '\t\t}\n', '\t\tEtherIn(msg.sender, msg.value);\n', '\t}\n', '\n', '\tfunction init(uint _start, uint _end, uint _cap) onlyOwner {\n', '\t\tstart = _start;\n', '\t\tend = _end;\n', '\t\tcap = _cap;\n', '\t}\n', '\n', '\tfunction softCap(uint _newend) onlyOwner {\n', '\t\trequire(_newend >= block.timestamp && _newend >= start && _newend <= end);\n', '\t\tend = _newend;\n', '\t}\n', '\n', '\t// 1st half of ownership change\n', '\tfunction changeOwner(address next) onlyOwner {\n', '\t\tnewOwner = next;\n', '\t}\n', '\n', '\t// 2nd half of ownership change\n', '\tfunction acceptOwnership() {\n', '\t\trequire(msg.sender == newOwner);\n', '\t\towner = msg.sender;\n', '\t\tnewOwner = 0;\n', '\t}\n', '\n', '\t// put some text in the contract\n', '\tfunction setNotice(string note) onlyOwner {\n', '\t\tnotice = note;\n', '\t}\n', '\n', '\t// withdraw all of the Ether\n', '\tfunction withdraw() onlyOwner {\n', '\t\tmsg.sender.transfer(this.balance);\n', '\t}\n', '\n', '\t// withdraw some of the Ether\n', '\tfunction withdrawSome(uint value) onlyOwner {\n', '\t\trequire(value <= this.balance);\n', '\t\tmsg.sender.transfer(value);\n', '\t}\n', '\n', '\t// withdraw tokens to owner\n', '\tfunction withdrawToken(address token) onlyOwner {\n', '\t\tToken t = Token(token);\n', '\t\trequire(t.transfer(msg.sender, t.balanceOf(this)));\n', '\t}\n', '\n', '\t// refund early/late tokens\n', '\tfunction refundToken(address token, address sender, uint amount) onlyOwner {\n', '\t\tToken t = Token(token);\n', '\t\trequire(t.transfer(sender, amount));\n', '\t}\n', '}']
['// Copyright New Alchemy Limited, 2017. All rights reserved.\n', '\n', 'pragma solidity >=0.4.10;\n', '\n', '// Just the bits of ERC20 that we need.\n', 'contract Token {\n', '\tfunction balanceOf(address addr) returns(uint);\n', '\tfunction transfer(address to, uint amount) returns(bool);\n', '}\n', '\n', 'contract Sale {\n', '\taddress public owner;    // contract owner\n', '\taddress public newOwner; // new contract owner for two-way ownership handshake\n', '\tstring public notice;    // arbitrary public notice text\n', '\tuint public start;       // start time of sale\n', '\tuint public end;         // end time of sale\n', '\tuint public cap;         // Ether hard cap\n', '\tbool public live;        // sale is live right now\n', '\n', '\tevent StartSale();\n', '\tevent EndSale();\n', '\tevent EtherIn(address from, uint amount);\n', '\n', '\tfunction Sale() {\n', '\t\towner = msg.sender;\n', '\t}\n', '\n', '\tmodifier onlyOwner() {\n', '\t\trequire(msg.sender == owner);\n', '\t\t_;\n', '\t}\n', '\n', '\tfunction () payable {\n', '\t\trequire(block.timestamp >= start);\n', '\n', '\t\tif (block.timestamp > end || this.balance > cap) {\n', '\t\t\trequire(live);\n', '\t\t\tlive = false;\n', '\t\t\tEndSale();\n', '\t\t} else if (!live) {\n', '\t\t\tlive = true;\n', '\t\t\tStartSale();\n', '\t\t}\n', '\t\tEtherIn(msg.sender, msg.value);\n', '\t}\n', '\n', '\tfunction init(uint _start, uint _end, uint _cap) onlyOwner {\n', '\t\tstart = _start;\n', '\t\tend = _end;\n', '\t\tcap = _cap;\n', '\t}\n', '\n', '\tfunction softCap(uint _newend) onlyOwner {\n', '\t\trequire(_newend >= block.timestamp && _newend >= start && _newend <= end);\n', '\t\tend = _newend;\n', '\t}\n', '\n', '\t// 1st half of ownership change\n', '\tfunction changeOwner(address next) onlyOwner {\n', '\t\tnewOwner = next;\n', '\t}\n', '\n', '\t// 2nd half of ownership change\n', '\tfunction acceptOwnership() {\n', '\t\trequire(msg.sender == newOwner);\n', '\t\towner = msg.sender;\n', '\t\tnewOwner = 0;\n', '\t}\n', '\n', '\t// put some text in the contract\n', '\tfunction setNotice(string note) onlyOwner {\n', '\t\tnotice = note;\n', '\t}\n', '\n', '\t// withdraw all of the Ether\n', '\tfunction withdraw() onlyOwner {\n', '\t\tmsg.sender.transfer(this.balance);\n', '\t}\n', '\n', '\t// withdraw some of the Ether\n', '\tfunction withdrawSome(uint value) onlyOwner {\n', '\t\trequire(value <= this.balance);\n', '\t\tmsg.sender.transfer(value);\n', '\t}\n', '\n', '\t// withdraw tokens to owner\n', '\tfunction withdrawToken(address token) onlyOwner {\n', '\t\tToken t = Token(token);\n', '\t\trequire(t.transfer(msg.sender, t.balanceOf(this)));\n', '\t}\n', '\n', '\t// refund early/late tokens\n', '\tfunction refundToken(address token, address sender, uint amount) onlyOwner {\n', '\t\tToken t = Token(token);\n', '\t\trequire(t.transfer(sender, amount));\n', '\t}\n', '}']