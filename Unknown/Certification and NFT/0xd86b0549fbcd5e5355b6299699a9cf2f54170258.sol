['pragma solidity ^0.4.8;\n', '\n', '/**\n', ' * Very basic owned/mortal boilerplate.  Used for basically everything, for\n', ' * security/access control purposes.\n', ' */\n', 'contract Owned {\n', '  address owner;\n', '\n', '  modifier onlyOwner {\n', '    if (msg.sender != owner) {\n', '      throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * Basic constructor.  The sender is the owner.\n', '   */\n', '  function Owned() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * Transfers ownership of the contract to a new owner.\n', '   * @param newOwner  Who gets to inherit this thing.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    owner = newOwner;\n', '  }\n', '\n', '  /**\n', '   * Shuts down the contract and removes it from the blockchain state.\n', '   * Only available to the owner.\n', '   */\n', '  function shutdown() onlyOwner {\n', '    selfdestruct(owner);\n', '  }\n', '\n', '  /**\n', '   * Withdraw all the funds from this contract.\n', '   * Only available to the owner.\n', '   */\n', '  function withdraw() onlyOwner {\n', '    if (!owner.send(this.balance)) {\n', '      throw;\n', '    }\n', '  }\n', '}\n', '\n', 'contract LotteryRoundInterface {\n', '  bool public winningNumbersPicked;\n', '  uint256 public closingBlock;\n', '\n', '  function pickTicket(bytes4 picks) payable;\n', '  function randomTicket() payable;\n', '\n', '  function proofOfSalt(bytes32 salt, uint8 N) constant returns(bool);\n', '  function closeGame(bytes32 salt, uint8 N);\n', '  function claimOwnerFee(address payout);\n', '  function withdraw();\n', '  function shutdown();\n', '  function distributeWinnings();\n', '  function claimPrize();\n', '\n', '  function paidOut() constant returns(bool);\n', '  function transferOwnership(address newOwner);\n', '}\n', '\n', '/**\n', ' * The meat of the game.  Holds all the rules around picking numbers,\n', ' * attempting to establish good sources of entropy, holding the pre-selected\n', ' * entropy sources (salt) in a way that is not publicly-revealed, etc.\n', ' * The gist is that this is a bit of a PRNG, that advances its entropy each\n', ' * time a ticket is picked.\n', ' *\n', ' * Provides the means to both pick specific numbers or have the PRNG select\n', ' * them for the ticketholder.\n', ' *\n', ' * Also controls payout of winners for a particular round.\n', ' */\n', 'contract LotteryRound is LotteryRoundInterface, Owned {\n', '\n', '  /*\n', '    Constants\n', '   */\n', '  // public version string\n', "  string constant VERSION = '0.1.2';\n", '\n', '  // round length\n', '  uint256 constant ROUND_LENGTH = 43200;  // approximately a week\n', '\n', '  // payout fraction (in thousandths):\n', '  uint256 constant PAYOUT_FRACTION = 950;\n', '\n', '  // Cost per ticket\n', '  uint constant TICKET_PRICE = 1 finney;\n', '\n', '  // valid pick mask\n', '  bytes1 constant PICK_MASK = 0x3f; // 0-63\n', '\n', '  /*\n', '    Public variables\n', '   */\n', '  // Pre-selected salt, hashed N times\n', '  // serves as proof-of-salt\n', '  bytes32 public saltHash;\n', '\n', '  // single hash of salt.N.salt\n', '  // serves as proof-of-N\n', '  // 0 < N < 256\n', '  bytes32 public saltNHash;\n', '\n', '  // closing time.\n', '  uint256 public closingBlock;\n', '\n', '  // winning numbers\n', '  bytes4 public winningNumbers;\n', '\n', '  // This becomes true when the numbers have been picked\n', '  bool public winningNumbersPicked = false;\n', '\n', '  // This becomes populated if anyone wins\n', '  address[] public winners;\n', '\n', '  // Stores a flag to signal if the winner has winnings to be claimed\n', '  mapping(address => bool) public winningsClaimable;\n', '\n', '  /**\n', '   * Current picks are from 0 to 63, or 2^6 - 1.\n', '   * Current number of picks is 4\n', '   * Rough odds of winning will be 1 in (2^6)^4, assuming even distributions, etc\n', '   */\n', '  mapping(bytes4 => address[]) public tickets;\n', '  uint256 public nTickets = 0;\n', '\n', "  // Set when winners are drawn, and represents the amount of the contract's current balance that can be paid out.\n", '  uint256 public prizePool;\n', '\n', '  // Set when winners are drawn, and signifies the amount each winner will receive.  In the event of multiple\n', '  // winners, this will be prizePool / winners.length\n', '  uint256 public prizeValue;\n', '\n', "  // The fee at the time winners were picked (if there were winners).  This is the portion of the contract's balance\n", '  // that goes to the contract owner.\n', '  uint256 public ownerFee;\n', '\n', '  // This will be the sha3 hash of the previous entropy + some additional inputs (e.g. randomly-generated hashes, etc)\n', '  bytes32 private accumulatedEntropy;\n', '\n', '  modifier beforeClose {\n', '    if (block.number > closingBlock) {\n', '      throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '  modifier beforeDraw {\n', '    if (block.number <= closingBlock || winningNumbersPicked) {\n', '      throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '  modifier afterDraw {\n', '    if (winningNumbersPicked == false) {\n', '      throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '  // Emitted when the round starts, broadcasting the hidden entropy params, closing block\n', '  // and game version.\n', '  event LotteryRoundStarted(\n', '    bytes32 saltHash,\n', '    bytes32 saltNHash,\n', '    uint256 closingBlock,\n', '    string version\n', '  );\n', '\n', '  // Broadcasted any time a user purchases a ticket.\n', '  event LotteryRoundDraw(\n', '    address indexed ticketHolder,\n', '    bytes4 indexed picks\n', '  );\n', '\n', '  // Broadcast when the round is completed, revealing the hidden entropy sources\n', '  // and the winning picks.\n', '  event LotteryRoundCompleted(\n', '    bytes32 salt,\n', '    uint8 N,\n', '    bytes4 indexed winningPicks,\n', '    uint256 closingBalance\n', '  );\n', '\n', '  // Broadcast for each winner.\n', '  event LotteryRoundWinner(\n', '    address indexed ticketHolder,\n', '    bytes4 indexed picks\n', '  );\n', '\n', '  /**\n', "   * Creates a new Lottery round, and sets the round's parameters.\n", '   *\n', '   * Note that this will implicitly set the factory to be the owner,\n', '   * meaning the factory will need to be able to transfer ownership,\n', '   * to its owner, the C&C contract.\n', '   *\n', '   * @param _saltHash       Hashed salt.  Will be hashed with sha3 N times\n', '   * @param _saltNHash      Hashed proof of N, in the format sha3(salt+N+salt)\n', '   */\n', '  function LotteryRound(\n', '    bytes32 _saltHash,\n', '    bytes32 _saltNHash\n', '  ) payable {\n', '    saltHash = _saltHash;\n', '    saltNHash = _saltNHash;\n', '    closingBlock = block.number + ROUND_LENGTH;\n', '    LotteryRoundStarted(\n', '      saltHash,\n', '      saltNHash,\n', '      closingBlock,\n', '      VERSION\n', '    );\n', '    // start this off with some really poor entropy.\n', '    accumulatedEntropy = block.blockhash(block.number - 1);\n', '  }\n', '\n', '  /**\n', '   * Attempt to generate a new pseudo-random number, while advancing the internal entropy\n', '   * of the contract.  Uses a two-phase approach: first, generates a simple offset [0-255]\n', '   * from simple entropy sources (accumulated, sender, block number).  Uses this offset\n', '   * to index into the history of blockhashes, to attempt to generate some stronger entropy\n', '   * by including previous block hashes.\n', '   *\n', '   * Then advances the interal entropy by rehashing it with the chosen number.\n', '   */\n', '  function generatePseudoRand(bytes32 seed) internal returns(bytes32) {\n', '    uint8 pseudoRandomOffset = uint8(uint256(sha256(\n', '      seed,\n', '      block.difficulty,\n', '      block.coinbase,\n', '      block.timestamp,\n', '      accumulatedEntropy\n', '    )) & 0xff);\n', '    // WARNING: This assumes block.number > 256... If block.number < 256, the below block.blockhash could return 0\n', "    // This is probably only an issue in testing, but shouldn't be a problem there.\n", '    uint256 pseudoRandomBlock = block.number - pseudoRandomOffset - 1;\n', '    bytes32 pseudoRand = sha3(\n', '      block.number,\n', '      block.blockhash(pseudoRandomBlock),\n', '      block.difficulty,\n', '      block.timestamp,\n', '      accumulatedEntropy\n', '    );\n', '    accumulatedEntropy = sha3(accumulatedEntropy, pseudoRand);\n', '    return pseudoRand;\n', '  }\n', '\n', '  /**\n', '   * Buy a ticket with pre-selected picks\n', "   * @param picks User's picks.\n", '   */\n', '  function pickTicket(bytes4 picks) payable beforeClose {\n', '    if (msg.value != TICKET_PRICE) {\n', '      throw;\n', '    }\n', "    // don't allow invalid picks.\n", '    for (uint8 i = 0; i < 4; i++) {\n', '      if (picks[i] & PICK_MASK != picks[i]) {\n', '        throw;\n', '      }\n', '    }\n', '    tickets[picks].push(msg.sender);\n', '    nTickets++;\n', '    generatePseudoRand(bytes32(picks)); // advance the accumulated entropy\n', '    LotteryRoundDraw(msg.sender, picks);\n', '  }\n', '\n', '  /**\n', '   * Interal function to generate valid picks.  Used by both the random\n', '   * ticket functionality, as well as when generating winning picks.\n', '   * Even though the picks are a fixed-width byte array, each pick is\n', '   * chosen separately (e.g. a bytes4 will result in 4 separate sha3 hashes\n', '   * used as sources).\n', '   *\n', '   * Masks the first byte of the seed to use as an offset into the next PRNG,\n', '   * then replaces the seed with the new PRNG.  Pulls a single byte from the\n', '   * resultant offset, masks it to be valid, then adds it to the accumulator.\n', '   *\n', '   * @param seed  The PRNG seed used to pick the numbers.\n', '   */\n', '  function pickValues(bytes32 seed) internal returns (bytes4) {\n', '    bytes4 picks;\n', '    uint8 offset;\n', '    for (uint8 i = 0; i < 4; i++) {\n', '      offset = uint8(seed[0]) & 0x1f;\n', '      seed = sha3(seed, msg.sender);\n', '      picks = (picks >> 8) | bytes1(seed[offset] & PICK_MASK);\n', '    }\n', '    return picks;\n', '  }\n', '\n', '  /**\n', '   * Picks a random ticket, using the internal PRNG and accumulated entropy\n', '   */\n', '  function randomTicket() payable beforeClose {\n', '    if (msg.value != TICKET_PRICE) {\n', '      throw;\n', '    }\n', '    bytes32 pseudoRand = generatePseudoRand(bytes32(msg.sender));\n', '    bytes4 picks = pickValues(pseudoRand);\n', '    tickets[picks].push(msg.sender);\n', '    nTickets++;\n', '    LotteryRoundDraw(msg.sender, picks);\n', '  }\n', '\n', '  /**\n', '   * Public means to prove the salt after numbers are picked.  Not technically necessary\n', '   * for this to be external, because it will be called during the round close process.\n', "   * If the hidden entropy parameters don't match, the contract will refuse to pick\n", '   * numbers or close.\n', '   *\n', '   * @param salt          Hidden entropy source\n', '   * @param N             Secret value proving how to obtain the hashed entropy from the source.\n', '   */\n', '  function proofOfSalt(bytes32 salt, uint8 N) constant returns(bool) {\n', '    // Proof-of-N:\n', '    bytes32 _saltNHash = sha3(salt, N, salt);\n', '    if (_saltNHash != saltNHash) {\n', '      return false;\n', '    }\n', '\n', '    // Proof-of-salt:\n', '    bytes32 _saltHash = sha3(salt);\n', '    for (var i = 1; i < N; i++) {\n', '      _saltHash = sha3(_saltHash);\n', '    }\n', '    if (_saltHash != saltHash) {\n', '      return false;\n', '    }\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * Internal function to handle tabulating the winners, including edge cases around\n', '   * duplicate winners.  Split out into its own method partially to enable proper\n', '   * testing.\n', '   *\n', '   * @param salt          Hidden entropy source.  Emitted here\n', '   * @param N             Key to the hidden entropy source.\n', '   * @param winningPicks  The winning picks.\n', '   */\n', '  function finalizeRound(bytes32 salt, uint8 N, bytes4 winningPicks) internal {\n', '    winningNumbers = winningPicks;\n', '    winningNumbersPicked = true;\n', '    LotteryRoundCompleted(salt, N, winningNumbers, this.balance);\n', '\n', '    var _winners = tickets[winningNumbers];\n', '    // if we have winners:\n', '    if (_winners.length > 0) {\n', "      // let's dedupe and broadcast the winners before figuring out the prize pool situation.\n", '      for (uint i = 0; i < _winners.length; i++) {\n', '        var winner = _winners[i];\n', '        if (!winningsClaimable[winner]) {\n', '          winners.push(winner);\n', '          winningsClaimable[winner] = true;\n', '          LotteryRoundWinner(winner, winningNumbers);\n', '        }\n', '      }\n', "      // now let's wrap this up by finalizing the prize pool value:\n", '      // There may be some rounding errors in here, but it should only amount to a couple wei.\n', '      prizePool = this.balance * PAYOUT_FRACTION / 1000;\n', '      prizeValue = prizePool / winners.length;\n', '\n', "      // Note that the owner doesn't get to claim a fee until the game is won.\n", '      ownerFee = this.balance - prizePool;\n', '    }\n', '    // we done.\n', '  }\n', '\n', '  /**\n', '   * Reveal the secret sources of entropy, then use them to pick winning numbers.\n', '   *\n', '   * Note that by using no dynamic (e.g. blockhash-based) sources of entropy,\n', '   * censoring this transaction will not change the final outcome of the picks.\n', '   *\n', '   * @param salt          Hidden entropy.\n', '   * @param N             Number of times to hash the hidden entropy to produce the value provided at creation.\n', '   */\n', '  function closeGame(bytes32 salt, uint8 N) onlyOwner beforeDraw {\n', "    // Don't allow picking numbers multiple times.\n", '    if (winningNumbersPicked == true) {\n', '      throw;\n', '    }\n', '\n', '    // prove the pre-selected salt is actually legit.\n', '    if (proofOfSalt(salt, N) != true) {\n', '      throw;\n', '    }\n', '\n', '    bytes32 pseudoRand = sha3(\n', '      salt,\n', '      nTickets,\n', '      accumulatedEntropy\n', '    );\n', '    finalizeRound(salt, N, pickValues(pseudoRand));\n', '  }\n', '\n', '  /**\n', "   * Sends the owner's fee to the specified address.  Note that the\n", '   * owner can only be paid if there actually was a winner. In the\n', '   * event no one wins, the entire balance is carried over into the\n', '   * next round.  No double-dipping here.\n', '   * @param payout        Address to send the owner fee to.\n', '   */\n', '  function claimOwnerFee(address payout) onlyOwner afterDraw {\n', '    if (ownerFee > 0) {\n', '      uint256 value = ownerFee;\n', '      ownerFee = 0;\n', '      if (!payout.send(value)) {\n', '        throw;\n', '      }\n', '    }\n', '  }\n', '\n', '  /**\n', '   * Used to withdraw the balance when the round is completed.  This\n', '   * only works if there are either no winners, or all winners + the\n', '   * owner have been paid.\n', '   */\n', '  function withdraw() onlyOwner afterDraw {\n', '    if (paidOut() && ownerFee == 0) {\n', '      if (!owner.send(this.balance)) {\n', '        throw;\n', '      }\n', '    }\n', '  }\n', '\n', '  /**\n', "   * Same as above.  This is mostly here because it's overriding the method\n", '   * inherited from `Owned`\n', '   */\n', '  function shutdown() onlyOwner afterDraw {\n', '    if (paidOut() && ownerFee == 0) {\n', '      selfdestruct(owner);\n', '    }\n', '  }\n', '\n', '  /**\n', '   * Attempt to pay the winners, if any.  If any `send`s fail, the winner\n', '   * will have to collect their winnings on their own.\n', '   */\n', '  function distributeWinnings() onlyOwner afterDraw {\n', '    if (winners.length > 0) {\n', '      for (uint i = 0; i < winners.length; i++) {\n', '        address winner = winners[i];\n', '        bool unclaimed = winningsClaimable[winner];\n', '        if (unclaimed) {\n', '          winningsClaimable[winner] = false;\n', '          if (!winner.send(prizeValue)) {\n', "            // If I can't send you money, dumbshit, you get to claim it on your own.\n", "            // maybe next time don't use a contract or try to exploit the game.\n", "            // Regardless, you're on your own.  Happy birthday to the ground.\n", '            winningsClaimable[winner] = true;\n', '          }\n', '        }\n', '      }\n', '    }\n', '  }\n', '\n', '  /**\n', "   * Returns true if it's after the draw, and either there are no winners, or all the winners have been paid.\n", '   * @return {bool}\n', '   */\n', '  function paidOut() constant returns(bool) {\n', '    // no need to use the modifier on this function, just do the same check\n', '    // and return false instead.\n', '    if (winningNumbersPicked == false) {\n', '      return false;\n', '    }\n', '    if (winners.length > 0) {\n', '      bool claimed = true;\n', "      // if anyone hasn't been sent or claimed their earnings,\n", '      // we still have money to pay out.\n', '      for (uint i = 0; claimed && i < winners.length; i++) {\n', '        claimed = claimed && !winningsClaimable[winners[i]];\n', '      }\n', '      return claimed;\n', '    } else {\n', '      // no winners, nothing to pay.\n', '      return true;\n', '    }\n', '  }\n', '\n', '  /**\n', '   * Winners can claim their own prizes using this.  If they do\n', '   * something stupid like use a contract, this gives them a\n', '   * a second chance at withdrawing their funds.  Note that\n', '   * this shares an interlock with `distributeWinnings`.\n', '   */\n', '  function claimPrize() afterDraw {\n', '    if (winningsClaimable[msg.sender] == false) {\n', '      // get. out!\n', '      throw;\n', '    }\n', '    winningsClaimable[msg.sender] = false;\n', '    if (!msg.sender.send(prizeValue)) {\n', "      // you really are a dumbshit, aren't you.\n", '      throw;\n', '    }\n', '  }\n', '\n', '  // Man! What do I look like? A charity case?\n', '  // Please.\n', "  // You can't buy me, hot dog man!\n", '  function () {\n', '    throw;\n', '  }\n', '}']