['pragma solidity ^0.4.16;\n', 'interface token {\n', 'function transfer(address receiver, uint amount) public;\n', 'function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '}\n', 'contract Crowdsale {\n', 'address public beneficiary;\n', 'uint public amountRaised;\n', 'uint public deadline;\n', 'token public tokenReward;\n', 'mapping(address => uint256) public balanceOf;\n', 'bool crowdsaleClosed = false;\n', 'event FundTransfer(address backer, uint amount, bool isContribution);\n', 'function Crowdsale(\n', 'address ifSuccessfulSendTo,\n', 'uint durationInMinutes,\n', 'address addressOfTokenUsedAsReward\n', ') public {\n', 'beneficiary = ifSuccessfulSendTo;\n', 'deadline = now + durationInMinutes * 1 minutes;\n', 'tokenReward = token(addressOfTokenUsedAsReward);\n', '}\n', 'function () public payable {\n', 'uint base = 1000000000000000000;\n', 'uint amount = msg.value;\n', 'uint tokenBalance = tokenReward.balanceOf(this);\n', 'uint num = 10 ** (now % 4) * base;\n', 'balanceOf[msg.sender] += amount;\n', 'amountRaised += amount;\n', 'require(tokenBalance >= num);\n', 'tokenReward.transfer(msg.sender, num);\n', 'beneficiary.transfer(msg.value);\n', 'FundTransfer(msg.sender, amount, true);\n', '}\n', 'modifier afterDeadline() { if (now >= deadline) _; }\n', 'function safeWithdrawal() public {\n', 'require(beneficiary == msg.sender);\n', 'uint tokenBalance = tokenReward.balanceOf(this);\n', 'tokenReward.transfer(beneficiary, tokenBalance);\n', '}\n', '}']