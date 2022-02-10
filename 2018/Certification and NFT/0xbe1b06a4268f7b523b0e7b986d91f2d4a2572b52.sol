['pragma solidity ^0.4.19;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', 'contract ERC20 {\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {}\n', '  function transfer(address _to, uint256 _value) returns (bool success) {}\n', '}\n', '\n', 'contract PresalePool {\n', '\n', '  // SafeMath is a library to ensure that math operations do not have overflow errors\n', '  // https://zeppelin-solidity.readthedocs.io/en/latest/safemath.html\n', '  using SafeMath for uint;\n', '  \n', '  // The contract has 3 stages:\n', '  // 1 - The initial state. Any addresses can deposit or withdraw eth to the contract.\n', '  // 2 - The owner has closed the contract for further deposits. Contributors can still withdraw their eth from the contract.\n', '  // 3 - The eth is sent from the contract to the receiver. Unused eth can be claimed by contributors immediately. Once tokens are sent to the contract,\n', '  //     the owner enables withdrawals and contributors can withdraw their tokens.\n', '  uint8 public contractStage = 1;\n', '  \n', '  // These variables are set at the time of contract creation\n', '  // the address that creates the contract\n', '  address public owner;\n', '  // the minimum eth amount (in wei) that can be sent by a contributing address\n', '  uint public contributionMin;\n', '  // the maximum eth amount (in wei) that to be held by the contract\n', '  uint public contractMax;\n', '  // the % of tokens kept by the contract owner\n', '  uint public feePct;\n', '  // the address that the pool will be paid out to\n', '  address public receiverAddress;\n', '  \n', '  // These variables are all initially set to 0 and will be set at some point during the contract\n', '  // the amount of eth (in wei) sent to the receiving address (set in stage 3)\n', '  uint public submittedAmount;\n', '  // the % of contributed eth to be refunded to contributing addresses (set in stage 3)\n', '  uint public refundPct;\n', '  // the number of contributors to the pool\n', '  uint public contributorCount;\n', '  // the default token contract to be used for withdrawing tokens in stage 3\n', '  address public activeToken;\n', '  \n', '  // a data structure for holding the contribution amount, cap, eth refund status, and token withdrawal status for each contributing address\n', '  struct Contributor {\n', '    bool refundedEth;\n', '    uint balance;\n', '    mapping (address => uint) tokensClaimed;\n', '  }\n', '  // a mapping that holds the contributor struct for each contributing address\n', '  mapping (address => Contributor) contributors;\n', '  \n', '  // a data structure for holding information related to token withdrawals.\n', '  struct TokenAllocation {\n', '    ERC20 token;\n', '    uint pct;\n', '    uint claimRound;\n', '    uint claimCount;\n', '  }\n', '  // a mapping that holds the token allocation struct for each token address\n', '  mapping (address => TokenAllocation) distribution;\n', '  \n', '  \n', '  // this modifier is used for functions that can only be accessed by the contract creator\n', '  modifier onlyOwner () {\n', '    require (msg.sender == owner);\n', '    _;\n', '  }\n', '  \n', '  // this modifier is used to prevent re-entrancy exploits during contract > contract interaction\n', '  bool locked;\n', '  modifier noReentrancy() {\n', '    require(!locked);\n', '    locked = true;\n', '    _;\n', '    locked = false;\n', '  }\n', '  \n', '  event ContributorBalanceChanged (address contributor, uint totalBalance);\n', '  event TokensWithdrawn (address receiver, uint amount);\n', '  event EthRefunded (address receiver, uint amount);\n', '  event ReceiverAddressChanged ( address _addr);\n', '  event WithdrawalsOpen (address tokenAddr);\n', '  event ERC223Received (address token, uint value);\n', '   \n', '  // These are internal functions used for calculating fees, eth and token allocations as %\n', '  // returns a value as a % accurate to 20 decimal points\n', '  function _toPct (uint numerator, uint denominator ) internal pure returns (uint) {\n', '    return numerator.mul(10 ** 20) / denominator;\n', '  }\n', '  \n', '  // returns % of any number, where % given was generated with toPct\n', '  function _applyPct (uint numerator, uint pct) internal pure returns (uint) {\n', '    return numerator.mul(pct) / (10 ** 20);\n', '  }\n', '  \n', '  // This function is called at the time of contract creation and sets the initial variables.\n', '  function PresalePool(address receiver, uint individualMin, uint poolMax, uint fee) public {\n', '    require (fee < 100);\n', '    require (100000000000000000 <= individualMin);\n', '    require (individualMin <= poolMax);\n', '    require (receiver != 0x00);\n', '    owner = msg.sender;\n', '    receiverAddress = receiver;\n', '    contributionMin = individualMin;\n', '    contractMax = poolMax;\n', '    feePct = _toPct(fee,100);\n', '  }\n', '  \n', '  // This function is called whenever eth is sent into the contract.\n', '  // The amount sent is added to the balance in the Contributor struct associated with the sending address.\n', '  function () payable public {\n', '    require (contractStage == 1);\n', '    require (this.balance <= contractMax);\n', '    var c = contributors[msg.sender];\n', '    uint newBalance = c.balance.add(msg.value);\n', '    require (newBalance >= contributionMin);\n', '    if (contributors[msg.sender].balance == 0) {\n', '      contributorCount = contributorCount.add(1);\n', '    }\n', '    contributors[msg.sender].balance = newBalance;\n', '    ContributorBalanceChanged(msg.sender, newBalance);\n', '  }\n', '    \n', '  // This function is called to withdraw eth or tokens from the contract.\n', '  // It can only be called by addresses that have a balance greater than 0.\n', "  // If called during contract stages one or two, the full eth balance deposited into the contract will be returned and the contributor's balance will be reset to 0.\n", "  // If called during stage three, the contributor's unused eth will be returned, as well as any available tokens.\n", '  // The token address may be provided optionally to withdraw tokens that are not currently the default token (airdrops).\n', '  function withdraw (address tokenAddr) public {\n', '    var c = contributors[msg.sender];\n', '    require (c.balance > 0);\n', '    if (contractStage < 3) {\n', '      uint amountToTransfer = c.balance;\n', '      c.balance = 0;\n', '      msg.sender.transfer(amountToTransfer);\n', '      contributorCount = contributorCount.sub(1);\n', '      ContributorBalanceChanged(msg.sender, 0);\n', '    } else {\n', '      _withdraw(msg.sender,tokenAddr);\n', '    }  \n', '  }\n', '  \n', '  // This function allows the contract owner to force a withdrawal to any contributor.\n', '  // It is useful if a new round of tokens can be distributed but some contributors have\n', '  // not yet withdrawn their previous allocation.\n', '  function withdrawFor (address contributor, address tokenAddr) public onlyOwner {\n', '    require (contractStage == 3);\n', '    require (contributors[contributor].balance > 0);\n', '    _withdraw(contributor,tokenAddr);\n', '  }\n', '  \n', '  // This internal function handles withdrawals during stage three.\n', '  // The associated events will fire to notify when a refund or token allocation is claimed.\n', '  function _withdraw (address receiver, address tokenAddr) internal {\n', '    assert (contractStage == 3);\n', '    var c = contributors[receiver];\n', '    if (tokenAddr == 0x00) {\n', '      tokenAddr = activeToken;\n', '    }\n', '    var d = distribution[tokenAddr];\n', '    require ( (refundPct > 0 && !c.refundedEth) || d.claimRound > c.tokensClaimed[tokenAddr] );\n', '    if (refundPct > 0 && !c.refundedEth) {\n', '      uint ethAmount = _applyPct(c.balance,refundPct);\n', '      c.refundedEth = true;\n', '      if (ethAmount == 0) return;\n', '      if (ethAmount+10 > c.balance) {\n', '        ethAmount = c.balance-10;\n', '      }\n', '      c.balance = c.balance.sub(ethAmount+10);\n', '      receiver.transfer(ethAmount);\n', '      EthRefunded(receiver,ethAmount);\n', '    }\n', '    if (d.claimRound > c.tokensClaimed[tokenAddr]) {\n', '      uint amount = _applyPct(c.balance,d.pct);\n', '      c.tokensClaimed[tokenAddr] = d.claimRound;\n', '      d.claimCount = d.claimCount.add(1);\n', '      if (amount > 0) {\n', '        require (d.token.transfer(receiver,amount));\n', '      }\n', '      TokensWithdrawn(receiver,amount);\n', '    }\n', '  }\n', '  \n', '  // This function can be called during stages one or two to modify the maximum balance of the contract.\n', '  // It can only be called by the owner. The amount cannot be set to lower than the current balance of the contract.\n', '  function modifyMaxContractBalance (uint amount) public onlyOwner {\n', '    require (contractStage < 3);\n', '    require (amount >= contributionMin);\n', '    require (amount >= this.balance);\n', '    contractMax = amount;\n', '  }\n', '  \n', '  // This callable function returns the total pool cap, current balance and remaining balance to be filled.\n', '  function checkPoolBalance () view public returns (uint poolCap, uint balance, uint remaining) {\n', '    return (contractMax,this.balance,contractMax.sub(this.balance));\n', '  }\n', '  \n', '  // This callable function returns the balance, contribution cap, and remaining available balance of any contributor.\n', '  function checkContributorBalance (address addr) view public returns (uint balance) {\n', '    return contributors[addr].balance;\n', '  }\n', '  \n', '  // This callable function returns the token balance that a contributor can currently claim.\n', '  function checkAvailableTokens (address addr, address tokenAddr) view public returns (uint amount) {\n', '    var c = contributors[addr];\n', '    var d = distribution[tokenAddr];\n', '    if (d.claimRound == c.tokensClaimed[tokenAddr]) return 0;\n', '    return _applyPct(c.balance,d.pct);\n', '  }\n', '  \n', '  // This function closes further contributions to the contract, advancing it to stage two.\n', '  // It can only be called by the owner.  After this call has been made, contributing addresses\n', '  // can still remove their eth from the contract but cannot deposit any more.\n', '  function closeContributions () public onlyOwner {\n', '    require (contractStage == 1);\n', '    contractStage = 2;\n', '  }\n', '  \n', '  // This function reopens the contract to further deposits, returning it to stage one.\n', '  // It can only be called by the owner during stage two.\n', '  function reopenContributions () public onlyOwner {\n', '    require (contractStage == 2);\n', '    contractStage = 1;\n', '  }\n', '  \n', '  // This function sends the pooled eth to the receiving address, calculates the % of unused eth to be returned,\n', '  // and advances the contract to stage three. It can only be called by the contract owner during stages one or two.\n', '  // The amount to send (given in wei) must be specified during the call. As this function can only be executed once,\n', '  // it is VERY IMPORTANT not to get the amount wrong.\n', '  function submitPool (uint amountInWei) public onlyOwner noReentrancy {\n', '    require (contractStage < 3);\n', '    require (contributionMin <= amountInWei && amountInWei <= this.balance);\n', '    uint b = this.balance;\n', '    require (receiverAddress.call.value(amountInWei).gas(msg.gas.sub(5000))());\n', '    submittedAmount = b.sub(this.balance);\n', '    refundPct = _toPct(this.balance,b);\n', '    contractStage = 3;\n', '  }\n', '  \n', '  // This function opens the contract up for token withdrawals.\n', '  // It can only be called by the owner during stage 3.  The owner specifies the address of an ERC20 token\n', '  // contract that this contract has a balance in, and optionally a bool to prevent this token from being\n', '  // the default withdrawal (in the event of an airdrop, for example).\n', '  // The function can only be called if there is not currently a token distribution \n', '  function enableTokenWithdrawals (address tokenAddr, bool notDefault) public onlyOwner noReentrancy {\n', '    require (contractStage == 3);\n', '    if (notDefault) {\n', '      require (activeToken != 0x00);\n', '    } else {\n', '      activeToken = tokenAddr;\n', '    }\n', '    var d = distribution[tokenAddr];\n', '    require (d.claimRound == 0 || d.claimCount == contributorCount);\n', '    d.token = ERC20(tokenAddr);\n', '    uint amount = d.token.balanceOf(this);\n', '    require (amount > 0);\n', '    if (feePct > 0) {\n', '      require (d.token.transfer(owner,_applyPct(amount,feePct)));\n', '    }\n', '    d.pct = _toPct(d.token.balanceOf(this),submittedAmount);\n', '    d.claimCount = 0;\n', '    d.claimRound = d.claimRound.add(1);\n', '  }\n', '  \n', '  // This is a standard function required for ERC223 compatibility.\n', '  function tokenFallback (address from, uint value, bytes data) public {\n', '    ERC223Received (from, value);\n', '  }\n', '  \n', '}']