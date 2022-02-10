['pragma solidity ^0.4.8;\n', '\n', '/**\n', ' * Very basic owned/mortal boilerplate.  Used for basically everything, for\n', ' * security/access control purposes.\n', ' */\n', 'contract Owned {\n', '  address owner;\n', '\n', '  modifier onlyOwner {\n', '    if (msg.sender != owner) {\n', '      throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * Basic constructor.  The sender is the owner.\n', '   */\n', '  function Owned() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * Transfers ownership of the contract to a new owner.\n', '   * @param newOwner  Who gets to inherit this thing.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    owner = newOwner;\n', '  }\n', '\n', '  /**\n', '   * Shuts down the contract and removes it from the blockchain state.\n', '   * Only available to the owner.\n', '   */\n', '  function shutdown() onlyOwner {\n', '    selfdestruct(owner);\n', '  }\n', '\n', '  /**\n', '   * Withdraw all the funds from this contract.\n', '   * Only available to the owner.\n', '   */\n', '  function withdraw() onlyOwner {\n', '    if (!owner.send(this.balance)) {\n', '      throw;\n', '    }\n', '  }\n', '}\n', '\n', 'contract LotteryRoundFactoryInterface {\n', '  string public VERSION;\n', '  function transferOwnership(address newOwner);\n', '}\n', '\n', 'contract LotteryRoundFactoryInterfaceV1 is LotteryRoundFactoryInterface {\n', '  function createRound(bytes32 _saltHash, bytes32 _saltNHash) payable returns(address);\n', '}\n', '\n', 'contract LotteryRoundInterface {\n', '  bool public winningNumbersPicked;\n', '  uint256 public closingBlock;\n', '\n', '  function pickTicket(bytes4 picks) payable;\n', '  function randomTicket() payable;\n', '\n', '  function proofOfSalt(bytes32 salt, uint8 N) constant returns(bool);\n', '  function closeGame(bytes32 salt, uint8 N);\n', '  function claimOwnerFee(address payout);\n', '  function withdraw();\n', '  function shutdown();\n', '  function distributeWinnings();\n', '  function claimPrize();\n', '\n', '  function paidOut() constant returns(bool);\n', '  function transferOwnership(address newOwner);\n', '}\n', '\n', '/**\n', ' * The base interface is what the parent contract expects to be able to use.\n', ' * If rules change in the future, and new logic is introduced, it only has to\n', ' * implement these methods, wtih the role of the curator being used\n', ' * to execute the additional functionality (if any).\n', ' */\n', 'contract LotteryGameLogicInterface {\n', '  address public currentRound;\n', '  function finalizeRound() returns(address);\n', '  function isUpgradeAllowed() constant returns(bool);\n', '  function transferOwnership(address newOwner);\n', '}\n', '\n', 'contract LotteryGameLogicInterfaceV1 is LotteryGameLogicInterface {\n', '  function deposit() payable;\n', '  function setCurator(address newCurator);\n', '}\n', '\n', '\n', '/**\n', ' * Core game logic.  Handlings management of rounds, carry-over balances,\n', " * paying winners, etc.  Separate from the main contract because it's more\n", ' * tightly-coupled to the factory/round logic than the game logic.  This\n', ' * allows for new rules in the future (e.g. partial picks, etc).  Carries\n', ' * the caveat that it cannot be upgraded until the current rules produce\n', ' * a winner, and can only be upgraded in the period between a winner under\n', ' * the current rules and the next round being started.\n', ' */\n', 'contract LotteryGameLogic is LotteryGameLogicInterfaceV1, Owned {\n', '\n', '  LotteryRoundFactoryInterfaceV1 public roundFactory;\n', '\n', '  address public curator;\n', '\n', '  LotteryRoundInterface public currentRound;\n', '\n', '  modifier onlyWhenNoRound {\n', '    if (currentRound != LotteryRoundInterface(0)) {\n', '      throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '  modifier onlyBeforeDraw {\n', '    if (\n', '      currentRound == LotteryRoundInterface(0) ||\n', '      block.number <= currentRound.closingBlock() ||\n', '      currentRound.winningNumbersPicked() == true\n', '    ) {\n', '      throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '  modifier onlyAfterDraw {\n', '    if (\n', '      currentRound == LotteryRoundInterface(0) ||\n', '      currentRound.winningNumbersPicked() == false\n', '    ) {\n', '      throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '  modifier onlyCurator {\n', '    if (msg.sender != curator) {\n', '      throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '  modifier onlyFromCurrentRound {\n', '    if (msg.sender != address(currentRound)) {\n', '      throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * Creates the core logic of the lottery.  Requires a round factory\n', '   * and an initial curator.\n', '   * @param _roundFactory  The factory to generate new rounds\n', '   * @param _curator       The initial curator\n', '   */\n', '  function LotteryGameLogic(address _roundFactory, address _curator) {\n', '    roundFactory = LotteryRoundFactoryInterfaceV1(_roundFactory);\n', '    curator = _curator;\n', '  }\n', '\n', '  /**\n', '   * Allows the curator to hand over curation responsibilities to someone else.\n', '   * @param newCurator  The new curator\n', '   */\n', '  function setCurator(address newCurator) onlyCurator onlyWhenNoRound {\n', '    curator = newCurator;\n', '  }\n', '\n', '  /**\n', '   * Specifies whether or not upgrading this contract is allowed.  In general, if there\n', '   * is a round underway, or this contract is holding a balance, upgrading is not allowed.\n', '   */\n', '  function isUpgradeAllowed() constant returns(bool) {\n', '    return currentRound == LotteryRoundInterface(0) && this.balance < 1 finney;\n', '  }\n', '\n', '  /**\n', '   * Starts a new round.  Can only be started by the curator, and only when there is no round\n', '   * currently underway\n', '   * @param saltHash    Secret salt, hashed N times.\n', '   * @param saltNHash   Proof of N, in the form of sha3(salt, N, salt)\n', '   */\n', '  function startRound(bytes32 saltHash, bytes32 saltNHash) onlyCurator onlyWhenNoRound {\n', '    if (this.balance > 0) {\n', '      currentRound = LotteryRoundInterface(\n', '        roundFactory.createRound.value(this.balance)(saltHash, saltNHash)\n', '      );\n', '    } else {\n', '      currentRound = LotteryRoundInterface(roundFactory.createRound(saltHash, saltNHash));\n', '    }\n', '  }\n', '\n', '  /**\n', '   * Reveal the chosen salt and number of hash iterations, then close the current roundn\n', '   * and pick the winning numbers\n', '   * @param salt   The original salt\n', '   * @param N      The original N\n', '   */\n', '  function closeRound(bytes32 salt, uint8 N) onlyCurator onlyBeforeDraw {\n', '    currentRound.closeGame(salt, N);\n', '  }\n', '\n', '  /**\n', '   * Finalize the round before returning it back to the the parent contract for\n', '   * historical purposes.  Attempts to pay winners and the curator if there was a winning\n', '   * draw, otherwise, pulls the balance out of the round before handing over ownership\n', '   * to the curator.\n', '   */\n', '  function finalizeRound() onlyOwner onlyAfterDraw returns(address) {\n', '    address roundAddress = address(currentRound);\n', '    if (!currentRound.paidOut()) {\n', "      // we'll only make one attempt here to pay the winners\n", '      currentRound.distributeWinnings();\n', '      currentRound.claimOwnerFee(curator);\n', '    } else if (currentRound.balance > 0) {\n', '      // otherwise, we have no winners, so just pull out funds in\n', '      // preparation for the next round.\n', '      currentRound.withdraw();\n', '    }\n', '\n', '    // be sure someone can handle disputes, etc, if they arise.\n', "    // not that they'll be able to *do* anything, but they can at least\n", '    // try calling `distributeWinnings()` again...\n', '    currentRound.transferOwnership(curator);\n', '\n', '    // clear this shit out.\n', '    delete currentRound;\n', '\n', '    // if there are or were any problems distributing winnings, the winners can attempt to withdraw\n', "    // funds for themselves.  The contracts won't be destroyed so long as they have funds to pay out.\n", '    // handling them might require special care or something.\n', '\n', '    return roundAddress;\n', '  }\n', '\n', '  /**\n', '   * Mostly just used for testing.  Technically, this contract may be seeded with an initial deposit\n', '   * before\n', '   */\n', '  function deposit() payable onlyOwner onlyWhenNoRound {\n', '    // noop, just used for depositing funds during an upgrade.\n', '  }\n', '\n', '  /**\n', "   * Only accept payments from the current round.  Required due to calling `.withdraw` at round's end.\n", '   */\n', '  function () payable onlyFromCurrentRound {\n', '    // another noop, since we can only receive funds from the current round.\n', '  }\n', '}']