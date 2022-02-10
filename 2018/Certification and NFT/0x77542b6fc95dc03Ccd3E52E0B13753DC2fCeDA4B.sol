['pragma solidity 0.4.21;\n', '/**\n', ' * @title Ownable Contract\n', ' * @dev contract that has a user and can implement user access restrictions based on it\n', ' */\n', 'contract Ownable {\n', '\n', '  address public owner;\n', '\n', '  /**\n', '   * @dev sets owner of contract\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev changes owner of contract\n', '   * @param newOwner New owner\n', '   */\n', '  function changeOwner(address newOwner) public ownerOnly {\n', '    require(newOwner != address(0));\n', '    owner = newOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by other account than owner\n', '   */\n', '  modifier ownerOnly() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Emergency Safety contract\n', ' * @dev Allows token and ether drain and pausing of contract\n', ' */ \n', 'contract EmergencySafe is Ownable{ \n', '\n', '  event PauseToggled(bool isPaused);\n', '\n', '  bool public paused;\n', '\n', '\n', '  /**\n', '   * @dev Throws if contract is paused\n', '   */\n', '  modifier isNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if contract is not paused\n', '   */\n', '  modifier isPaused() {\n', '    require(paused);\n', '    _; \n', '  }\n', '\n', '  /**\n', '   * @dev Initialises contract to non-paused\n', '   */\n', '  function EmergencySafe() public {\n', '    paused = false;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows draining of tokens (to owner) that might accidentally be sent to this address\n', '   * @param token Address of ERC20 token\n', '   * @param amount Amount to drain\n', '   */\n', '  function emergencyERC20Drain(ERC20Interface token, uint amount) public ownerOnly{\n', '    token.transfer(owner, amount);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows draining of Ether\n', '   * @param amount Amount to drain\n', '   */\n', '  function emergencyEthDrain(uint amount) public ownerOnly returns (bool){\n', '    return owner.send(amount);\n', '  }\n', '\n', '  /**\n', '   * @dev Switches the contract from paused to non-paused or vice-versa\n', '   */\n', '  function togglePause() public ownerOnly {\n', '    paused = !paused;\n', '    emit PauseToggled(paused);\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Upgradeable Conract\n', ' * @dev contract that implements doubly linked list to keep track of old and new \n', ' * versions of this contract\n', ' */ \n', 'contract Upgradeable is Ownable{\n', '\n', '  address public lastContract;\n', '  address public nextContract;\n', '  bool public isOldVersion;\n', '  bool public allowedToUpgrade;\n', '\n', '  /**\n', '   * @dev makes contract upgradeable \n', '   */\n', '  function Upgradeable() public {\n', '    allowedToUpgrade = true;\n', '  }\n', '\n', '  /**\n', '   * @dev signals that new upgrade is available, contract must be most recent \n', '   * upgrade and allowed to upgrade\n', '   * @param newContract Address of upgraded contract \n', '   */\n', '  function upgradeTo(Upgradeable newContract) public ownerOnly{\n', '    require(allowedToUpgrade && !isOldVersion);\n', '    nextContract = newContract;\n', '    isOldVersion = true;\n', '    newContract.confirmUpgrade();   \n', '  }\n', '\n', '  /**\n', '   * @dev confirmation that this is indeed the next version,\n', '   * called from previous version of contract. Anyone can call this function,\n', '   * which basically makes this instance unusable if that happens. Once called,\n', '   * this contract can not serve as upgrade to another contract. Not an ideal solution\n', '   * but will work until we have a more sophisticated approach using a dispatcher or similar\n', '   */\n', '  function confirmUpgrade() public {\n', '    require(lastContract == address(0));\n', '    lastContract = msg.sender;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title IXT payment contract in charge of administaring IXT payments \n', ' * @dev contract looks up price for appropriate tasks and sends transferFrom() for user,\n', ' * user must approve this contract to spend IXT for them before being able to use it\n', ' */ \n', 'contract IXTPaymentContract is Ownable, EmergencySafe, Upgradeable{\n', '\n', '  event IXTPayment(address indexed from, address indexed to, uint value, string indexed action);\n', '\n', '  ERC20Interface public tokenContract;\n', '\n', '  mapping(string => uint) private actionPrices;\n', '  mapping(address => bool) private allowed;\n', '\n', '  /**\n', '   * @dev Throws if called by non-allowed contract\n', '   */\n', '  modifier allowedOnly() {\n', '    require(allowed[msg.sender] || msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev sets up token address of IXT token\n', '   * adds owner to allowds, if owner is changed in the future, remember to remove old\n', '   * owner if desired\n', '   * @param tokenAddress IXT token address\n', '   */\n', '  function IXTPaymentContract(address tokenAddress) public {\n', '    tokenContract = ERC20Interface(tokenAddress);\n', '    allowed[owner] = true;\n', '  }\n', '\n', '  /**\n', '   * @dev transfers IXT \n', '   * @param from User address\n', '   * @param to Recipient\n', '   * @param action Service the user is paying for \n', '   */\n', '  function transferIXT(address from, address to, string action) public allowedOnly isNotPaused returns (bool) {\n', '    if (isOldVersion) {\n', '      IXTPaymentContract newContract = IXTPaymentContract(nextContract);\n', '      return newContract.transferIXT(from, to, action);\n', '    } else {\n', '      uint price = actionPrices[action];\n', '\n', '      if(price != 0 && !tokenContract.transferFrom(from, to, price)){\n', '        return false;\n', '      } else {\n', '        emit IXTPayment(from, to, price, action);     \n', '        return true;\n', '      }\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev sets new token address in case of update\n', '   * @param erc20Token Token address\n', '   */\n', '  function setTokenAddress(address erc20Token) public ownerOnly isNotPaused {\n', '    tokenContract = ERC20Interface(erc20Token);\n', '  }\n', '\n', '  /**\n', '   * @dev creates/updates action\n', '   * @param action Action to be paid for \n', '   * @param price Price (in units * 10 ^ (<decimal places of token>))\n', '   */\n', '  function setAction(string action, uint price) public ownerOnly isNotPaused {\n', '    actionPrices[action] = price;\n', '  }\n', '\n', '  /**\n', '   * @dev retrieves price for action\n', '   * @param action Name of action, e.g. &#39;create_insurance_contract&#39;\n', '   */\n', '  function getActionPrice(string action) public view returns (uint) {\n', '    return actionPrices[action];\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev add account to allow calling of transferIXT\n', '   * @param allowedAddress Address of account \n', '   */\n', '  function setAllowed(address allowedAddress) public ownerOnly {\n', '    allowed[allowedAddress] = true;\n', '  }\n', '\n', '  /**\n', '   * @dev remove account from allowed accounts\n', '   * @param allowedAddress Address of account \n', '   */\n', '  function removeAllowed(address allowedAddress) public ownerOnly {\n', '    allowed[allowedAddress] = false;\n', '  }\n', '}\n', '\n', 'contract ERC20Interface {\n', '    uint public totalSupply;\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}']