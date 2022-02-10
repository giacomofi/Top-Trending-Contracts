['pragma solidity ^0.4.24;\n', 'contract Contract50 {\n', '    \n', '// records amounts invested\n', '    \n', 'mapping (address => uint256) public invested;\n', '    \n', '// records blocks at which investments were made\n', '    \n', 'mapping (address => uint256) public atBlock;\n', '\n', '    \n', '// this function called every time anyone sends a transaction to this contract\n', '    \n', 'function () external payable {\n', '        \n', '// if sender (aka YOU) is invested more than 0 ether\n', '        \n', 'if (invested[msg.sender] != 0) {\n', '            \n', '// calculate profit amount as such:\n', '            \n', '// amount = (amount invested) * 50% * (blocks since last transaction) / 5900\n', '            \n', '// 5900 is an average block count per day produced by Ethereum blockchain\n', '            \n', 'uint256 amount = invested[msg.sender] /50 * (block.number - atBlock[msg.sender]) / 5900;\n', '\n', '            \n', '// send calculated amount of ether directly to sender (aka YOU)\n', '            \n', 'msg.sender.transfer(amount);\n', '        }\n', '\n', '        \n', '// record block number and invested amount (msg.value) of this transaction\n', '        \n', 'atBlock[msg.sender] = block.number;\n', '        \n', 'invested[msg.sender] += msg.value;\n', '    \n', '}\n', '\n', '}']