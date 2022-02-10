['pragma solidity ^0.4.18;\n', '\n', '// zeppelin-solidity: 1.8.0\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ChampionSimple is Ownable {\n', '  using SafeMath for uint;\n', '\n', '  event LogDistributeReward(address addr, uint reward);\n', '  event LogParticipant(address addr, uint choice, uint betAmount);\n', '  event LogModifyChoice(address addr, uint oldChoice, uint newChoice);\n', '  event LogRefund(address addr, uint betAmount);\n', '  event LogWithdraw(address addr, uint amount);\n', '  event LogWinChoice(uint choice, uint reward);\n', '\n', '  uint public minimumBet = 5 * 10 ** 16;\n', '  uint public deposit = 0;\n', '  uint public totalBetAmount = 0;\n', '  uint public startTime;\n', '  uint public winChoice;\n', '  uint public winReward;\n', '  uint public numberOfBet;\n', '  bool public betClosed = false;\n', '\n', '  struct Player {\n', '    uint betAmount;\n', '    uint choice;\n', '  }\n', '\n', '  address [] public players;\n', '  mapping(address => Player) public playerInfo;\n', '  mapping(uint => uint) public numberOfChoice;\n', '  mapping(uint => mapping(address => bool)) public addressOfChoice;\n', '  mapping(address => bool) public withdrawRecord;\n', ' \n', '  modifier beforeTimestamp(uint timestamp) {\n', '    require(now < timestamp);\n', '    _;\n', '  }\n', '\n', '  modifier afterTimestamp(uint timestamp) {\n', '    require(now >= timestamp);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev the construct function\n', '   * @param _startTime the deadline of betting\n', '   * @param _minimumBet the minimum bet amount\n', '   */\n', '  function ChampionSimple(uint _startTime, uint _minimumBet) payable public {\n', '    require(_startTime > now);\n', '    deposit = msg.value;\n', '    startTime = _startTime;\n', '    minimumBet = _minimumBet;\n', '  }\n', '\n', '  /**\n', '   * @dev find a player has participanted or not\n', '   * @param player the address of the participant\n', '   */\n', '  function checkPlayerExists(address player) public view returns (bool) {\n', '    if (playerInfo[player].choice == 0) {\n', '      return false;\n', '    }\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev to bet which team will be the champion\n', '   * @param choice the choice of the participant(actually team id)\n', '   */\n', '  function placeBet(uint choice) payable beforeTimestamp(startTime) public {\n', '    require(choice > 0);\n', '    require(!checkPlayerExists(msg.sender));\n', '    require(msg.value >= minimumBet);\n', '\n', '    playerInfo[msg.sender].betAmount = msg.value;\n', '    playerInfo[msg.sender].choice = choice;\n', '    totalBetAmount = totalBetAmount.add(msg.value);\n', '    numberOfBet = numberOfBet.add(1);\n', '    players.push(msg.sender);\n', '    numberOfChoice[choice] = numberOfChoice[choice].add(1);\n', '    addressOfChoice[choice][msg.sender] = true;\n', '    LogParticipant(msg.sender, choice, msg.value);\n', '  }\n', '\n', '  /**\n', '   * @dev allow user to change their choice before a timestamp\n', '   * @param choice the choice of the participant(actually team id)\n', '   */\n', '  function modifyChoice(uint choice) beforeTimestamp(startTime) public {\n', '    require(choice > 0);\n', '    require(checkPlayerExists(msg.sender));\n', '\n', '    uint oldChoice = playerInfo[msg.sender].choice;\n', '    numberOfChoice[oldChoice] = numberOfChoice[oldChoice].sub(1);\n', '    numberOfChoice[choice] = numberOfChoice[choice].add(1);\n', '    playerInfo[msg.sender].choice = choice;\n', '\n', '    addressOfChoice[oldChoice][msg.sender] = false;\n', '    addressOfChoice[choice][msg.sender] = true;\n', '    LogModifyChoice(msg.sender, oldChoice, choice);\n', '  }\n', '\n', '  /**\n', '   * @dev close who is champion bet with the champion id\n', '   */\n', '  function saveResult(uint teamId) onlyOwner public {\n', '    winChoice = teamId;\n', '    betClosed = true;\n', '    winReward = deposit.add(totalBetAmount).div(numberOfChoice[winChoice]);\n', '    LogWinChoice(winChoice, winReward);\n', '  }\n', '\n', '  /**\n', '   * @dev every user can withdraw his reward\n', '   */\n', '  function withdrawReward() public {\n', '    require(betClosed);\n', '    require(!withdrawRecord[msg.sender]);\n', '    require(winChoice > 0);\n', '    require(winReward > 0);\n', '    require(addressOfChoice[winChoice][msg.sender]);\n', '\n', '    msg.sender.transfer(winReward);\n', '    withdrawRecord[msg.sender] = true;\n', '    LogDistributeReward(msg.sender, winReward);\n', '  }\n', '\n', '  /**\n', '   * @dev anyone could recharge deposit\n', '   */\n', '  function rechargeDeposit() payable public {\n', '    deposit = deposit.add(msg.value);\n', '  }\n', '\n', '  /**\n', '   * @dev get player bet information\n', '   * @param addr indicate the bet address\n', '   */\n', '  function getPlayerBetInfo(address addr) view public returns (uint, uint) {\n', '    return (playerInfo[addr].choice, playerInfo[addr].betAmount);\n', '  }\n', '\n', '  /**\n', '   * @dev get the bet numbers of a specific choice\n', '   * @param choice indicate the choice\n', '   */\n', '  function getNumberByChoice(uint choice) view public returns (uint) {\n', '    return numberOfChoice[choice];\n', '  }\n', '\n', '  /**\n', '   * @dev if there are some reasons lead game postpone or cancel\n', '   *      the bet will also cancel and refund every bet\n', '   */\n', '  function refund() onlyOwner public {\n', '    for (uint i = 0; i < players.length; i++) {\n', '      players[i].transfer(playerInfo[players[i]].betAmount);\n', '      LogRefund(players[i], playerInfo[players[i]].betAmount);\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev get the players\n', '   */\n', '  function getPlayers() view public returns (address[]) {\n', '    return players;\n', '  }\n', '\n', '  /**\n', '   * @dev dealer can withdraw the remain ether if distribute exceeds max length\n', '   */\n', '  function withdraw() onlyOwner public {\n', '    uint _balance = address(this).balance;\n', '    owner.transfer(_balance);\n', '    LogWithdraw(owner, _balance);\n', '  }\n', '}']