['pragma solidity ^0.4.24;\n', '\n', 'interface token {\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '}\n', '\n', 'contract Sale {\n', '    address private maintoken = 0x2054a15c6822a722378d13c4e4ea85365e46e50b;\n', '    address private owner = msg.sender;\n', '    address private owner8 = 0x98b3540c7d95950f44ed9774f6caf04bf76c368f;\n', '    address private owner6 = 0x4e76f947fA07B655F5e3e2cDD645E590C5D0875e;\n', '    uint256 private sendtoken;\n', '    uint256 public cost1token = 0.00042 ether;\n', '    uint256 private ether86;\n', '    uint256 private ether8;\n', '    uint256 private ether6;\n', '    token public tokenReward;\n', '    \n', '    function Sale() public {\n', '        tokenReward = token(maintoken);\n', '    }\n', '    \n', '    function() external payable {\n', '        sendtoken = (msg.value)/cost1token;\n', '        if (msg.value >= 5 ether) {\n', '            sendtoken = (msg.value)/cost1token;\n', '            sendtoken = sendtoken*3/2;\n', '        }\n', '        if (msg.value >= 15 ether) {\n', '            sendtoken = (msg.value)/cost1token;\n', '            sendtoken = sendtoken*2;\n', '        }\n', '        if (msg.value >= 25 ether) {\n', '            sendtoken = (msg.value)/cost1token;\n', '            sendtoken = sendtoken*3;\n', '        }\n', '        tokenReward.transferFrom(owner, msg.sender, sendtoken);\n', '        \n', '        ether8 = (msg.value)*8/100;\n', '        ether6 = (msg.value)*6/100;\n', '        ether86 = (msg.value)-ether8-ether6;\n', '        owner8.transfer(ether8);\n', '        owner6.transfer(ether6);\n', '        owner.transfer(ether86);\n', '    }\n', '}']