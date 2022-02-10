['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-06\n', '*/\n', '\n', 'pragma solidity ^0.5.10;\n', '\n', 'contract ChainDotPrivateSale {\n', '  address payable owner;\n', '  uint public goal;\n', '  uint public endTime;\n', '  bool open = true;\n', '  address public topDonor;\n', '\n', '  mapping(address=>uint) donations;\n', '  \n', '  event OwnerWithdraw(uint amount, uint withdrawTime);\n', '  event UserWithdraw(address user, uint amount, uint withdrawTime);\n', '  event Donation(uint amount, address contributor);\n', '  \n', '  constructor(uint _goal, uint _timelimit) public {\n', '    owner = msg.sender;\n', '    goal = _goal;\n', '    endTime = block.number + _timelimit;\n', '  }\n', '\n', '  function add() public payable {\n', '    donations[msg.sender] += msg.value;\n', '    if(donations[msg.sender] > donations[topDonor]) {\n', '      topDonor = msg.sender;\n', '    }\n', '    emit Donation(msg.value, msg.sender);\n', '  }\n', '\n', '  function withdrawOwner() public {\n', '    require(msg.sender == owner, "You must be the owner");\n', '    emit OwnerWithdraw(address(this).balance, now);\n', '    owner.transfer(address(this).balance);\n', '  }\n', '\n', '  function withdraw() public {\n', '    require(address(this).balance < goal, "Fundraising campaign was successful");\n', '    require(now > endTime, "Fundraising campaign is still ongoing");\n', '    msg.sender.transfer(donations[msg.sender]);\n', '    emit UserWithdraw(msg.sender, donations[msg.sender], now);\n', '    donations[msg.sender] = 0;\n', '  }\n', '  \n', '  function percentageComplete() public view returns (uint) {\n', '    require(goal != 0, "goal is 0, cannot divide by 0");\n', '    return 100 * (address(this).balance / goal);\n', '  }\n', '}']