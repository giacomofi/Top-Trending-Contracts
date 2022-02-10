['pragma solidity ^0.4.15;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    Unpause();\n', '  }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/*\n', ' This is a simple contract that is used to track incoming payments.\n', ' As soon as a payment is received, an event is triggered to log the transaction.\n', ' All funds are immediately forwarded to the owner.\n', ' The sender must include a payment code as a payload and the contract can conditionally enforce the\n', ' sending address matches the payment code.\n', ' The payment code is the first 8 bytes of the keccak/sha3 hash of the address that the user has specified in the sale.\n', '*/\n', 'contract SaleTracker is Pausable {\n', '  using SafeMath for uint256;\n', '\n', '  // Event to allow monitoring incoming payments\n', '  event PurchaseMade (address indexed _from, bytes8 _paymentCode, uint256 _value);\n', '\n', '  // Tracking of purchase total in wei made per sending address\n', '  mapping(address => uint256) public purchases;\n', '\n', '  // Tracking of purchaser addresses for lookup offline\n', '  address[] public purchaserAddresses;\n', '\n', '  // Flag to enforce payments source address matching the payment code\n', '  bool public enforceAddressMatch;\n', '\n', '  // Constructor to start the contract in a paused state\n', '  function SaleTracker(bool _enforceAddressMatch) {\n', '    enforceAddressMatch = _enforceAddressMatch;\n', '    pause();\n', '  }\n', '\n', '  // Setter for the enforce flag - only updatable by the owner\n', '  function setEnforceAddressMatch(bool _enforceAddressMatch) onlyOwner public {\n', '    enforceAddressMatch = _enforceAddressMatch;\n', '  }\n', '\n', '  // Purchase function allows incoming payments when not paused - requires payment code\n', '  function purchase(bytes8 paymentCode) whenNotPaused public payable {\n', '\n', '    // Verify they have sent ETH in\n', '    require(msg.value != 0);\n', '\n', '    // Verify the payment code was included\n', '    require(paymentCode != 0);\n', '\n', '    // If payment from addresses are being enforced, ensure the code matches the sender address\n', '    if (enforceAddressMatch) {\n', '\n', '      // Get the first 8 bytes of the hash of the address\n', '      bytes8 calculatedPaymentCode = bytes8(sha3(msg.sender));\n', '\n', '      // Fail if the sender code does not match\n', '      require(calculatedPaymentCode == paymentCode);\n', '    }\n', '\n', '    // Save off the existing purchase amount for this user\n', '    uint256 existingPurchaseAmount = purchases[msg.sender];\n', '\n', '    // If they have not purchased before (0 value), then save it off\n', '    if (existingPurchaseAmount == 0) {\n', '      purchaserAddresses.push(msg.sender);\n', '    }\n', '\n', '    // Add the new purchase value to the existing value already being tracked\n', '    purchases[msg.sender] = existingPurchaseAmount.add(msg.value);    \n', '\n', '    // Transfer out to the owner wallet\n', '    owner.transfer(msg.value);\n', '\n', '    // Trigger the event for a new purchase\n', '    PurchaseMade(msg.sender, paymentCode, msg.value);\n', '  }\n', '\n', '  // Allows owner to sweep any ETH somehow trapped in the contract.\n', '  function sweep() onlyOwner public {\n', '    owner.transfer(this.balance);\n', '  }\n', '\n', '  // Get the number of addresses that have contributed to the sale\n', '  function getPurchaserAddressCount() public constant returns (uint) {\n', '    return purchaserAddresses.length;\n', '  }\n', '\n', '}']