['pragma solidity ^0.4.21;\n', '\n', 'interface token {\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '}\n', '\n', 'contract Sale {\n', '    address private maintoken = 0x2f7823aaf1ad1df0d5716e8f18e1764579f4abe6;\n', '    address private owner90 = 0xf2b9DA535e8B8eF8aab29956823df7237f1863A3;\n', '    address private owner10 = 0x966c0FD16a4f4292E6E0372e04fbB5c7013AD02e;\n', '    uint256 private sendtoken;\n', '    uint256 public cost1token = 0.00379 ether;\n', '    uint256 private ether90;\n', '    uint256 private ether10;\n', '    token public tokenReward;\n', '    \n', '    function Sale() public {\n', '        tokenReward = token(maintoken);\n', '    }\n', '    \n', '    function() external payable {\n', '        sendtoken = (msg.value)/cost1token;\n', '        tokenReward.transferFrom(owner90, msg.sender, sendtoken);\n', '        \n', '        ether10 = (msg.value)/10;\n', '        ether90 = (msg.value)-ether10;\n', '        owner90.transfer(ether90);\n', '        owner10.transfer(ether10);\n', '    }\n', '}']
['pragma solidity ^0.4.21;\n', '\n', 'interface token {\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '}\n', '\n', 'contract Sale {\n', '    address private maintoken = 0x2f7823aaf1ad1df0d5716e8f18e1764579f4abe6;\n', '    address private owner90 = 0xf2b9DA535e8B8eF8aab29956823df7237f1863A3;\n', '    address private owner10 = 0x966c0FD16a4f4292E6E0372e04fbB5c7013AD02e;\n', '    uint256 private sendtoken;\n', '    uint256 public cost1token = 0.00379 ether;\n', '    uint256 private ether90;\n', '    uint256 private ether10;\n', '    token public tokenReward;\n', '    \n', '    function Sale() public {\n', '        tokenReward = token(maintoken);\n', '    }\n', '    \n', '    function() external payable {\n', '        sendtoken = (msg.value)/cost1token;\n', '        tokenReward.transferFrom(owner90, msg.sender, sendtoken);\n', '        \n', '        ether10 = (msg.value)/10;\n', '        ether90 = (msg.value)-ether10;\n', '        owner90.transfer(ether90);\n', '        owner10.transfer(ether10);\n', '    }\n', '}']