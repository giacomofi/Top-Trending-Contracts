['pragma solidity ^0.4.21;\n', '\n', 'contract VernamWhiteListDeposit {\n', '\t\n', '\taddress[] public participants;\n', '\t\n', '\taddress public benecifiary;\n', '\tmapping (address => bool) public isWhiteList;\n', '\tuint256 public constant depositAmount = 10000000000000000 wei;   // 0.01 ETH\n', '\t\n', '\tuint256 public constant maxWiteList = 10000;\t\t\t\t\t// maximum 10 000 whitelist participant\n', '\t\n', '\tuint256 public deadLine;\n', '\tuint256 public constant whiteListPeriod = 47 days; \t\t\t// 47 days active\n', '\t\n', '\tfunction VernamWhiteListDeposit() public {\n', '\t\tbenecifiary = 0x769ef9759B840690a98244D3D1B0384499A69E4F;\n', '\t\tdeadLine = block.timestamp + whiteListPeriod;\n', '\t\tparticipants.length = 0;\n', '\t}\n', '\t\n', '\tevent WhiteListSuccess(address indexed _whiteListParticipant, uint256 _amount);\n', '\tfunction() public payable {\n', '\t\trequire(participants.length <= maxWiteList);               //check does have more than 10 000 whitelist\n', '\t\trequire(block.timestamp <= deadLine);\t\t\t\t\t   // check does whitelist period over\n', '\t\trequire(msg.value == depositAmount);\t\t\t\t\t\t// exactly 0.01 ethers no more no less\n', '\t\trequire(!isWhiteList[msg.sender]);\t\t\t\t\t\t\t// can&#39;t whitelist twice\n', '\t\tbenecifiary.transfer(msg.value);\t\t\t\t\t\t\t// transfer the money\n', '\t\tisWhiteList[msg.sender] = true;\t\t\t\t\t\t\t\t// put participant in witheList\n', '\t\tparticipants.push(msg.sender);\t\t\t\t\t\t\t\t// put in to arrayy\n', '\t\temit WhiteListSuccess(msg.sender, msg.value);\t\t\t\t// say to the network\n', '\t}\n', '\t\n', '\tfunction getParticipant() public view returns (address[]) {\n', '\t\treturn participants;\n', '\t}\n', '\t\n', '\tfunction getCounter() public view returns(uint256 _counter) {\n', '\t\treturn participants.length;\n', '\t}\n', '}']
['pragma solidity ^0.4.21;\n', '\n', 'contract VernamWhiteListDeposit {\n', '\t\n', '\taddress[] public participants;\n', '\t\n', '\taddress public benecifiary;\n', '\tmapping (address => bool) public isWhiteList;\n', '\tuint256 public constant depositAmount = 10000000000000000 wei;   // 0.01 ETH\n', '\t\n', '\tuint256 public constant maxWiteList = 10000;\t\t\t\t\t// maximum 10 000 whitelist participant\n', '\t\n', '\tuint256 public deadLine;\n', '\tuint256 public constant whiteListPeriod = 47 days; \t\t\t// 47 days active\n', '\t\n', '\tfunction VernamWhiteListDeposit() public {\n', '\t\tbenecifiary = 0x769ef9759B840690a98244D3D1B0384499A69E4F;\n', '\t\tdeadLine = block.timestamp + whiteListPeriod;\n', '\t\tparticipants.length = 0;\n', '\t}\n', '\t\n', '\tevent WhiteListSuccess(address indexed _whiteListParticipant, uint256 _amount);\n', '\tfunction() public payable {\n', '\t\trequire(participants.length <= maxWiteList);               //check does have more than 10 000 whitelist\n', '\t\trequire(block.timestamp <= deadLine);\t\t\t\t\t   // check does whitelist period over\n', '\t\trequire(msg.value == depositAmount);\t\t\t\t\t\t// exactly 0.01 ethers no more no less\n', "\t\trequire(!isWhiteList[msg.sender]);\t\t\t\t\t\t\t// can't whitelist twice\n", '\t\tbenecifiary.transfer(msg.value);\t\t\t\t\t\t\t// transfer the money\n', '\t\tisWhiteList[msg.sender] = true;\t\t\t\t\t\t\t\t// put participant in witheList\n', '\t\tparticipants.push(msg.sender);\t\t\t\t\t\t\t\t// put in to arrayy\n', '\t\temit WhiteListSuccess(msg.sender, msg.value);\t\t\t\t// say to the network\n', '\t}\n', '\t\n', '\tfunction getParticipant() public view returns (address[]) {\n', '\t\treturn participants;\n', '\t}\n', '\t\n', '\tfunction getCounter() public view returns(uint256 _counter) {\n', '\t\treturn participants.length;\n', '\t}\n', '}']
