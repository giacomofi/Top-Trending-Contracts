['pragma solidity ^0.4.11;\n', '\n', 'library Math {\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', 'contract ICOBuyer is Ownable {\n', '\n', '  // Contract allows Ether to be paid into it\n', '  // Contract allows tokens / Ether to be extracted only to owner account\n', '  // Contract allows executor address or owner address to trigger ICO purtchase\n', '\n', '  //Notify on economic events\n', '  event EtherReceived(address indexed _contributor, uint256 _amount);\n', '  event EtherWithdrawn(uint256 _amount);\n', '  event TokensWithdrawn(uint256 _balance);\n', '  event ICOPurchased(uint256 _amount);\n', '\n', '  //Notify on contract updates\n', '  event ICOStartBlockChanged(uint256 _icoStartBlock);\n', '  event ICOStartTimeChanged(uint256 _icoStartTime);\n', '  event ExecutorChanged(address _executor);\n', '  event CrowdSaleChanged(address _crowdSale);\n', '  event TokenChanged(address _token);\n', '  event PurchaseCapChanged(uint256 _purchaseCap);\n', '\n', '  // only owner can change these\n', '  // Earliest block number contract is allowed to buy into the crowdsale.\n', '  uint256 public icoStartBlock;\n', '  // Earliest time contract is allowed to buy into the crowdsale.\n', '  uint256 public icoStartTime;\n', '  // The crowdsale address.\n', '  address public crowdSale;\n', '  // The address that can trigger ICO purchase (may be different to owner)\n', '  address public executor;\n', '  // The amount for each ICO purchase\n', '  uint256 public purchaseCap;\n', '\n', '  modifier onlyExecutorOrOwner() {\n', '    require((msg.sender == executor) || (msg.sender == owner));\n', '    _;\n', '  }\n', '\n', '  function ICOBuyer(address _executor, address _crowdSale, uint256 _icoStartBlock, uint256 _icoStartTime, uint256 _purchaseCap) {\n', '    executor = _executor;\n', '    crowdSale = _crowdSale;\n', '    icoStartBlock = _icoStartBlock;\n', '    icoStartTime = _icoStartTime;\n', '    purchaseCap = _purchaseCap;\n', '  }\n', '\n', '  function changeCrowdSale(address _crowdSale) onlyOwner {\n', '    crowdSale = _crowdSale;\n', '    CrowdSaleChanged(crowdSale);\n', '  }\n', '\n', '  function changeICOStartBlock(uint256 _icoStartBlock) onlyExecutorOrOwner {\n', '    icoStartBlock = _icoStartBlock;\n', '    ICOStartBlockChanged(icoStartBlock);\n', '  }\n', '\n', '  function changeICOStartTime(uint256 _icoStartTime) onlyExecutorOrOwner {\n', '    icoStartTime = _icoStartTime;\n', '    ICOStartTimeChanged(icoStartTime);\n', '  }\n', '\n', '  function changePurchaseCap(uint256 _purchaseCap) onlyOwner {\n', '    purchaseCap = _purchaseCap;\n', '    PurchaseCapChanged(purchaseCap);\n', '  }\n', '\n', '  function changeExecutor(address _executor) onlyOwner {\n', '    executor = _executor;\n', '    ExecutorChanged(_executor);\n', '  }\n', '\n', '  // function allows all Ether to be drained from contract by owner\n', '  function withdrawEther() onlyOwner {\n', '    require(this.balance != 0);\n', '    owner.transfer(this.balance);\n', '    EtherWithdrawn(this.balance);\n', '  }\n', '\n', '  // function allows all tokens to be transferred to owner\n', '  function withdrawTokens(address _token) onlyOwner {\n', '    ERC20Basic token = ERC20Basic(_token);\n', '    // Retrieve current token balance of contract.\n', '    uint256 contractTokenBalance = token.balanceOf(address(this));\n', '    // Disallow token withdrawals if there are no tokens to withdraw.\n', '    require(contractTokenBalance != 0);\n', '    // Send the funds.  Throws on failure to prevent loss of funds.\n', '    assert(token.transfer(owner, contractTokenBalance));\n', '    TokensWithdrawn(contractTokenBalance);\n', '  }\n', '\n', '  // Buys tokens in the crowdsale and rewards the caller, callable by anyone.\n', '  function buyICO() onlyExecutorOrOwner {\n', '    // Short circuit to save gas if the earliest block number hasn&#39;t been reached.\n', '    if ((icoStartBlock != 0) && (getBlockNumber() < icoStartBlock)) return;\n', '    // Short circuit to save gas if the earliest buy time hasn&#39;t been reached.\n', '    if ((icoStartTime != 0) && (getNow() < icoStartTime)) return;\n', '    // Return if no balance\n', '    if (this.balance == 0) return;\n', '\n', '    // Purchase tokens from ICO contract (assuming call to ICO fallback function)\n', '    uint256 purchaseAmount = Math.min256(this.balance, purchaseCap);\n', '    assert(crowdSale.call.value(purchaseAmount)());\n', '    ICOPurchased(purchaseAmount);\n', '  }\n', '\n', '  // Fallback function accepts ether and logs this.\n', '  // Can be called by anyone to fund contract.\n', '  function () payable {\n', '    EtherReceived(msg.sender, msg.value);\n', '  }\n', '\n', '  //Function is mocked for tests\n', '  function getBlockNumber() internal constant returns (uint256) {\n', '    return block.number;\n', '  }\n', '\n', '  //Function is mocked for tests\n', '  function getNow() internal constant returns (uint256) {\n', '    return now;\n', '  }\n', '\n', '}']