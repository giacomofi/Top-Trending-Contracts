['/*\n', '  8888888 .d8888b.   .d88888b.   .d8888b.  888                     888                 888      \n', '    888  d88P  Y88b d88P" "Y88b d88P  Y88b 888                     888                 888      \n', '    888  888    888 888     888 Y88b.      888                     888                 888      \n', '    888  888        888     888  "Y888b.   888888  8888b.  888d888 888888      .d8888b 88888b.  \n', '    888  888        888     888     "Y88b. 888        "88b 888P"   888        d88P"    888 "88b \n', '    888  888    888 888     888       "888 888    .d888888 888     888        888      888  888 \n', '    888  Y88b  d88P Y88b. .d88P Y88b  d88P Y88b.  888  888 888     Y88b.  d8b Y88b.    888  888 \n', '  8888888 "Y8888P"   "Y88888P"   "Y8888P"   "Y888 "Y888888 888      "Y888 Y8P  "Y8888P 888  888 \n', '\n', '  Rocket startup for your ICO\n', '\n', '  The innovative platform to create your initial coin offering (ICO) simply, safely and professionally.\n', '  All the services your project needs: KYC, AI Audit, Smart contract wizard, Legal template,\n', '  Master Nodes management, on a single SaaS platform!\n', '*/\n', 'pragma solidity ^0.4.21;\n', '\n', '// File: contracts\\zeppelin-solidity\\contracts\\ownership\\Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts\\zeppelin-solidity\\contracts\\lifecycle\\Pausable.sol\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', '// File: contracts\\zeppelin-solidity\\contracts\\math\\SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: contracts\\zeppelin-solidity\\contracts\\token\\ERC20\\ERC20Basic.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: contracts\\zeppelin-solidity\\contracts\\token\\ERC20\\ERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: contracts\\ICOStartReservation.sol\n', '\n', 'contract ICOStartSaleInterface {\n', '  ERC20 public token;\n', '}\n', '\n', 'contract ICOStartReservation is Pausable {\n', '  using SafeMath for uint256;\n', '\n', '  ICOStartSaleInterface public sale;\n', '  uint256 public cap;\n', '  uint8 public feePerc;\n', '  address public manager;\n', '  mapping(address => uint256) public deposits;\n', '  uint256 public weiCollected;\n', '  uint256 public tokensReceived;\n', '  bool public canceled;\n', '  bool public paid;\n', '\n', '  event Deposited(address indexed depositor, uint256 amount);\n', '  event Withdrawn(address indexed beneficiary, uint256 amount);\n', '  event Paid(uint256 netAmount, uint256 fee);\n', '  event Canceled();\n', '\n', '  function ICOStartReservation(ICOStartSaleInterface _sale, uint256 _cap, uint8 _feePerc, address _manager) public {\n', '    require(_sale != (address(0)));\n', '    require(_cap != 0);\n', '    require(_feePerc >= 0);\n', '    if (_feePerc != 0) {\n', '      require(_manager != 0x0);\n', '    }\n', '\n', '    sale = _sale;\n', '    cap = _cap;\n', '    feePerc = _feePerc;\n', '    manager = _manager;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is accepting\n', '   * deposits.\n', '   */\n', '  modifier whenOpen() {\n', '    require(isOpen());\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only if the reservation was not canceled.\n', '   */\n', '  modifier whenNotCanceled() {\n', '    require(!canceled);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only if the reservation was canceled.\n', '   */\n', '  modifier whenCanceled() {\n', '    require(canceled);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only if the reservation was not yet paid.\n', '   */\n', '  modifier whenNotPaid() {\n', '    require(!paid);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only if the reservation was paid.\n', '   */\n', '  modifier whenPaid() {\n', '    require(paid);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Checks whether the cap has been reached. \n', '   * @return Whether the cap was reached\n', '   */\n', '  function capReached() public view returns (bool) {\n', '    return weiCollected >= cap;\n', '  }\n', '\n', '  /**\n', '   * @dev A reference to the sale&#39;s token contract. \n', '   * @return The token contract.\n', '   */\n', '  function getToken() public view returns (ERC20) {\n', '    return sale.token();\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is accepting\n', '   * deposits.\n', '   */\n', '  function isOpen() public view returns (bool) {\n', '    return !paused && !capReached() && !canceled && !paid;\n', '  }\n', '\n', '  /**\n', '   * @dev Shortcut for deposit() and claimTokens() functions.\n', '   * Send 0 to claim, any other value to deposit.\n', '   */\n', '  function () external payable {\n', '    if (msg.value == 0) {\n', '      claimTokens(msg.sender);\n', '    } else {\n', '      deposit(msg.sender);\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Deposit ethers in the contract keeping track of the sender.\n', '   * @param _depositor Address performing the purchase\n', '   */\n', '  function deposit(address _depositor) public whenOpen payable {\n', '    require(_depositor != address(0));\n', '    require(weiCollected.add(msg.value) <= cap);\n', '    deposits[_depositor] = deposits[_depositor].add(msg.value);\n', '    weiCollected = weiCollected.add(msg.value);\n', '    emit Deposited(_depositor, msg.value);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the owner to cancel the reservation thus enabling withdraws.\n', '   * Contract must first be paused so we are sure we are not accepting deposits.\n', '   */\n', '  function cancel() public onlyOwner whenPaused whenNotPaid {\n', '    canceled = true;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the owner to cancel the reservation thus enabling withdraws.\n', '   * Contract must first be paused so we are sure we are not accepting deposits.\n', '   */\n', '  function pay() public onlyOwner whenNotCanceled {\n', '    require(weiCollected > 0);\n', '  \n', '    uint256 fee;\n', '    uint256 netAmount;\n', '    (fee, netAmount) = _getFeeAndNetAmount(weiCollected);\n', '\n', '    require(address(sale).call.value(netAmount)(this));\n', '    tokensReceived = getToken().balanceOf(this);\n', '\n', '    if (fee != 0) {\n', '      manager.transfer(fee);\n', '    }\n', '\n', '    paid = true;\n', '    emit Paid(netAmount, fee);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows a depositor to withdraw his contribution if the reservation was canceled.\n', '   */\n', '  function withdraw() public whenCanceled {\n', '    uint256 depositAmount = deposits[msg.sender];\n', '    require(depositAmount != 0);\n', '    deposits[msg.sender] = 0;\n', '    weiCollected = weiCollected.sub(depositAmount);\n', '    msg.sender.transfer(depositAmount);\n', '    emit Withdrawn(msg.sender, depositAmount);\n', '  }\n', '\n', '  /**\n', '   * @dev After the reservation is paid, transfers tokens from the contract to the\n', '   * specified address (which must have deposited ethers earlier).\n', '   * @param _beneficiary Address that will receive the tokens.\n', '   */\n', '  function claimTokens(address _beneficiary) public whenPaid {\n', '    require(_beneficiary != address(0));\n', '    \n', '    uint256 depositAmount = deposits[_beneficiary];\n', '    if (depositAmount != 0) {\n', '      uint256 tokens = tokensReceived.mul(depositAmount).div(weiCollected);\n', '      assert(tokens != 0);\n', '      deposits[_beneficiary] = 0;\n', '      getToken().transfer(_beneficiary, tokens);\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Emergency brake. Send all ethers and tokens to the owner.\n', '   */\n', '  function destroy() onlyOwner public {\n', '    uint256 myTokens = getToken().balanceOf(this);\n', '    if (myTokens != 0) {\n', '      getToken().transfer(owner, myTokens);\n', '    }\n', '    selfdestruct(owner);\n', '  }\n', '\n', '  /*\n', '   * Internal functions\n', '   */\n', '\n', '  /**\n', '   * @dev Returns the current period, or null.\n', '   */\n', '   function _getFeeAndNetAmount(uint256 _grossAmount) internal view returns (uint256 _fee, uint256 _netAmount) {\n', '      _fee = _grossAmount.div(100).mul(feePerc);\n', '      _netAmount = _grossAmount.sub(_fee);\n', '   }\n', '}']
['/*\n', '  8888888 .d8888b.   .d88888b.   .d8888b.  888                     888                 888      \n', '    888  d88P  Y88b d88P" "Y88b d88P  Y88b 888                     888                 888      \n', '    888  888    888 888     888 Y88b.      888                     888                 888      \n', '    888  888        888     888  "Y888b.   888888  8888b.  888d888 888888      .d8888b 88888b.  \n', '    888  888        888     888     "Y88b. 888        "88b 888P"   888        d88P"    888 "88b \n', '    888  888    888 888     888       "888 888    .d888888 888     888        888      888  888 \n', '    888  Y88b  d88P Y88b. .d88P Y88b  d88P Y88b.  888  888 888     Y88b.  d8b Y88b.    888  888 \n', '  8888888 "Y8888P"   "Y88888P"   "Y8888P"   "Y888 "Y888888 888      "Y888 Y8P  "Y8888P 888  888 \n', '\n', '  Rocket startup for your ICO\n', '\n', '  The innovative platform to create your initial coin offering (ICO) simply, safely and professionally.\n', '  All the services your project needs: KYC, AI Audit, Smart contract wizard, Legal template,\n', '  Master Nodes management, on a single SaaS platform!\n', '*/\n', 'pragma solidity ^0.4.21;\n', '\n', '// File: contracts\\zeppelin-solidity\\contracts\\ownership\\Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts\\zeppelin-solidity\\contracts\\lifecycle\\Pausable.sol\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', '// File: contracts\\zeppelin-solidity\\contracts\\math\\SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: contracts\\zeppelin-solidity\\contracts\\token\\ERC20\\ERC20Basic.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: contracts\\zeppelin-solidity\\contracts\\token\\ERC20\\ERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: contracts\\ICOStartReservation.sol\n', '\n', 'contract ICOStartSaleInterface {\n', '  ERC20 public token;\n', '}\n', '\n', 'contract ICOStartReservation is Pausable {\n', '  using SafeMath for uint256;\n', '\n', '  ICOStartSaleInterface public sale;\n', '  uint256 public cap;\n', '  uint8 public feePerc;\n', '  address public manager;\n', '  mapping(address => uint256) public deposits;\n', '  uint256 public weiCollected;\n', '  uint256 public tokensReceived;\n', '  bool public canceled;\n', '  bool public paid;\n', '\n', '  event Deposited(address indexed depositor, uint256 amount);\n', '  event Withdrawn(address indexed beneficiary, uint256 amount);\n', '  event Paid(uint256 netAmount, uint256 fee);\n', '  event Canceled();\n', '\n', '  function ICOStartReservation(ICOStartSaleInterface _sale, uint256 _cap, uint8 _feePerc, address _manager) public {\n', '    require(_sale != (address(0)));\n', '    require(_cap != 0);\n', '    require(_feePerc >= 0);\n', '    if (_feePerc != 0) {\n', '      require(_manager != 0x0);\n', '    }\n', '\n', '    sale = _sale;\n', '    cap = _cap;\n', '    feePerc = _feePerc;\n', '    manager = _manager;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is accepting\n', '   * deposits.\n', '   */\n', '  modifier whenOpen() {\n', '    require(isOpen());\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only if the reservation was not canceled.\n', '   */\n', '  modifier whenNotCanceled() {\n', '    require(!canceled);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only if the reservation was canceled.\n', '   */\n', '  modifier whenCanceled() {\n', '    require(canceled);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only if the reservation was not yet paid.\n', '   */\n', '  modifier whenNotPaid() {\n', '    require(!paid);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only if the reservation was paid.\n', '   */\n', '  modifier whenPaid() {\n', '    require(paid);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Checks whether the cap has been reached. \n', '   * @return Whether the cap was reached\n', '   */\n', '  function capReached() public view returns (bool) {\n', '    return weiCollected >= cap;\n', '  }\n', '\n', '  /**\n', "   * @dev A reference to the sale's token contract. \n", '   * @return The token contract.\n', '   */\n', '  function getToken() public view returns (ERC20) {\n', '    return sale.token();\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is accepting\n', '   * deposits.\n', '   */\n', '  function isOpen() public view returns (bool) {\n', '    return !paused && !capReached() && !canceled && !paid;\n', '  }\n', '\n', '  /**\n', '   * @dev Shortcut for deposit() and claimTokens() functions.\n', '   * Send 0 to claim, any other value to deposit.\n', '   */\n', '  function () external payable {\n', '    if (msg.value == 0) {\n', '      claimTokens(msg.sender);\n', '    } else {\n', '      deposit(msg.sender);\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Deposit ethers in the contract keeping track of the sender.\n', '   * @param _depositor Address performing the purchase\n', '   */\n', '  function deposit(address _depositor) public whenOpen payable {\n', '    require(_depositor != address(0));\n', '    require(weiCollected.add(msg.value) <= cap);\n', '    deposits[_depositor] = deposits[_depositor].add(msg.value);\n', '    weiCollected = weiCollected.add(msg.value);\n', '    emit Deposited(_depositor, msg.value);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the owner to cancel the reservation thus enabling withdraws.\n', '   * Contract must first be paused so we are sure we are not accepting deposits.\n', '   */\n', '  function cancel() public onlyOwner whenPaused whenNotPaid {\n', '    canceled = true;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the owner to cancel the reservation thus enabling withdraws.\n', '   * Contract must first be paused so we are sure we are not accepting deposits.\n', '   */\n', '  function pay() public onlyOwner whenNotCanceled {\n', '    require(weiCollected > 0);\n', '  \n', '    uint256 fee;\n', '    uint256 netAmount;\n', '    (fee, netAmount) = _getFeeAndNetAmount(weiCollected);\n', '\n', '    require(address(sale).call.value(netAmount)(this));\n', '    tokensReceived = getToken().balanceOf(this);\n', '\n', '    if (fee != 0) {\n', '      manager.transfer(fee);\n', '    }\n', '\n', '    paid = true;\n', '    emit Paid(netAmount, fee);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows a depositor to withdraw his contribution if the reservation was canceled.\n', '   */\n', '  function withdraw() public whenCanceled {\n', '    uint256 depositAmount = deposits[msg.sender];\n', '    require(depositAmount != 0);\n', '    deposits[msg.sender] = 0;\n', '    weiCollected = weiCollected.sub(depositAmount);\n', '    msg.sender.transfer(depositAmount);\n', '    emit Withdrawn(msg.sender, depositAmount);\n', '  }\n', '\n', '  /**\n', '   * @dev After the reservation is paid, transfers tokens from the contract to the\n', '   * specified address (which must have deposited ethers earlier).\n', '   * @param _beneficiary Address that will receive the tokens.\n', '   */\n', '  function claimTokens(address _beneficiary) public whenPaid {\n', '    require(_beneficiary != address(0));\n', '    \n', '    uint256 depositAmount = deposits[_beneficiary];\n', '    if (depositAmount != 0) {\n', '      uint256 tokens = tokensReceived.mul(depositAmount).div(weiCollected);\n', '      assert(tokens != 0);\n', '      deposits[_beneficiary] = 0;\n', '      getToken().transfer(_beneficiary, tokens);\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Emergency brake. Send all ethers and tokens to the owner.\n', '   */\n', '  function destroy() onlyOwner public {\n', '    uint256 myTokens = getToken().balanceOf(this);\n', '    if (myTokens != 0) {\n', '      getToken().transfer(owner, myTokens);\n', '    }\n', '    selfdestruct(owner);\n', '  }\n', '\n', '  /*\n', '   * Internal functions\n', '   */\n', '\n', '  /**\n', '   * @dev Returns the current period, or null.\n', '   */\n', '   function _getFeeAndNetAmount(uint256 _grossAmount) internal view returns (uint256 _fee, uint256 _netAmount) {\n', '      _fee = _grossAmount.div(100).mul(feePerc);\n', '      _netAmount = _grossAmount.sub(_fee);\n', '   }\n', '}']