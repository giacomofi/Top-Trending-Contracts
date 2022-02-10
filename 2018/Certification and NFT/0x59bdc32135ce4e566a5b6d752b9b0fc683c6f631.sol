['pragma solidity ^0.4.22;\n', '\n', 'contract Lottery {\n', '\n', '  address owner;\n', '  address public beneficiary;\n', '  mapping(address => bool) public playersMap;\n', '  address[] public players;\n', '  uint public playerEther = 0.01 ether;\n', '  uint playerCountGoal;\n', '  bool public isLotteryClosed = false;\n', '  uint public rewards;\n', '\n', '  event GoalReached(address recipient, uint totalAmountRaised);\n', '  event FundTransfer(address backer, uint amount, bool isContribution);\n', '\n', '  constructor() public {\n', '    // playerCountGoal will be in [10000, 10100]\n', '    playerCountGoal = 10000 + randomGen(block.number - 1, 101);\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '    * Fallback function\n', '    *\n', '    * The function without name is the default function that is called whenever anyone sends funds to a contract\n', '    */\n', '  function () public payable {\n', '    require(!isLotteryClosed && msg.value == playerEther, "Lottery should not be closed and player should send exact ethers");\n', '    require(!playersMap[msg.sender], "player should not attend twice");\n', '    players.push(msg.sender);\n', '    playersMap[msg.sender] = true;\n', '    \n', '    emit FundTransfer(msg.sender, msg.value, true);\n', '\n', '    checkGoalReached();\n', '  }\n', '\n', '  modifier afterGoalReached() { \n', '    if (players.length >= playerCountGoal) _; \n', '  }\n', '\n', '  function checkGoalReached() internal afterGoalReached {\n', '    require(!isLotteryClosed, "lottery must be opened");\n', '    isLotteryClosed = true;\n', '    uint playerCount = players.length;\n', '\n', '    // calculate the rewards\n', '    uint winnerIndex = randomGen(block.number - 2, playerCount);\n', '    beneficiary = players[winnerIndex];\n', '    rewards = playerEther * playerCount * 4 / 5;\n', '\n', '    emit GoalReached(beneficiary, rewards);\n', '  }\n', '\n', '  /* Generates a random number from 0 to 100 based on the last block hash */\n', '  function randomGen(uint seed, uint count) private view returns (uint randomNumber) {\n', '    return uint(keccak256(abi.encodePacked(block.number-3, seed))) % count;\n', '  }\n', '\n', '  function safeWithdrawal() public afterGoalReached {\n', '    require(isLotteryClosed, "lottery must be closed");\n', '    \n', '    if (beneficiary == msg.sender) {\n', '      beneficiary.transfer(rewards);\n', '      emit FundTransfer(beneficiary, rewards, false);\n', '    }\n', '\n', '    if (owner == msg.sender) {\n', '      uint fee = playerEther * players.length / 5;\n', '      owner.transfer(fee);\n', '      emit FundTransfer(owner, fee, false);\n', '    }\n', '  }\n', '\n', '}']