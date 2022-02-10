['pragma solidity ^0.4.11;\n', '\n', 'contract Grid {\n', '  // The account address with admin privilege to this contract\n', '  // This is also the default owner of all unowned pixels\n', '  address admin;\n', '\n', '  // The size in number of pixels of the square grid on each side\n', '  uint16 public size;\n', '\n', '  // The default price of unowned pixels\n', '  uint public defaultPrice;\n', '\n', '  // The price-fee ratio used in the following formula:\n', '  //   salePrice / feeRatio = fee\n', '  //   payout = salePrice - fee\n', '  // Higher feeRatio equates to lower fee percentage\n', '  uint public feeRatio;\n', '\n', '  // The price increment rate used in the following formula:\n', '  //   price = prevPrice + (prevPrice * incrementRate / 100);\n', '  uint public incrementRate;\n', '\n', '  // A record of a user who may at any time be an owner of pixels or simply has\n', '  // unclaimed withdrawal from a failed purchase or a successful sale\n', '  struct User {\n', '    // Number of Wei that can be withdrawn by the user\n', '    uint pendingWithdrawal;\n', '\n', '    // Number of Wei in total ever credited to the user as a result of a\n', '    // successful sale\n', '    uint totalSales;\n', '  }\n', '\n', '  struct Pixel {\n', '    // User with permission to modify the pixel. A successful sale of the\n', '    // pixel will result in payouts being credited to the pendingWithdrawal of\n', '    // the User\n', '    address owner;\n', '\n', '    // Current listed price of the pixel\n', '    uint price;\n', '\n', '    // Current color of the pixel. A valid of 0 is considered transparent and\n', '    // not black. Use 1 for black.\n', '    uint24 color;\n', '  }\n', '\n', '  // The state of the pixel grid\n', '  mapping(uint32 => Pixel) pixels;\n', '\n', '  // The state of all users who have transacted with this contract\n', '  mapping(address => User) users;\n', '\n', '  // An optional message that is shown in some parts of the UI and in the\n', '  // details pane of every owned pixel\n', '  mapping(address => string) messages;\n', '\n', '  //============================================================================\n', '  // Events\n', '  //============================================================================\n', '\n', '  event PixelTransfer(uint16 row, uint16 col, uint price, address prevOwner, address newOwner);\n', '  event PixelColor(uint16 row, uint16 col, address owner, uint24 color);\n', '  event PixelPrice(uint16 row, uint16 col, address owner, uint price);\n', '  event UserMessage(address user, string message);\n', '\n', '  //============================================================================\n', '  // Basic API and helper functions\n', '  //============================================================================\n', '\n', '  function Grid(\n', '    uint16 _size,\n', '    uint _defaultPrice,\n', '    uint _feeRatio,\n', '    uint _incrementRate) {\n', '    admin = msg.sender;\n', '    defaultPrice = _defaultPrice;\n', '    feeRatio = _feeRatio;\n', '    size = _size;\n', '    incrementRate = _incrementRate;\n', '  }\n', '\n', '  modifier onlyAdmin {\n', '    require(msg.sender == admin);\n', '    _;\n', '  }\n', '\n', '  modifier onlyOwner(uint16 row, uint16 col) {\n', '    require(msg.sender == getPixelOwner(row, col));\n', '    _;\n', '  }\n', '\n', '  function getKey(uint16 row, uint16 col) constant returns (uint32) {\n', '    require(row < size && col < size);\n', '    return uint32(SafeMath.add(SafeMath.mul(row, size), col));\n', '  }\n', '\n', '  function() payable {}\n', '\n', '  //============================================================================\n', '  // Admin API\n', '  //============================================================================\n', '\n', '  function setAdmin(address _admin) onlyAdmin {\n', '    admin = _admin;\n', '  }\n', '\n', '  function setFeeRatio(uint _feeRatio) onlyAdmin {\n', '    feeRatio = _feeRatio;\n', '  }\n', '\n', '  function setDefaultPrice(uint _defaultPrice) onlyAdmin {\n', '    defaultPrice = _defaultPrice;\n', '  }\n', '\n', '  //============================================================================\n', '  // Public Querying API\n', '  //============================================================================\n', '\n', '  function getPixelColor(uint16 row, uint16 col) constant returns (uint24) {\n', '    uint32 key = getKey(row, col);\n', '    return pixels[key].color;\n', '  }\n', '\n', '  function getPixelOwner(uint16 row, uint16 col) constant returns (address) {\n', '    uint32 key = getKey(row, col);\n', '    if (pixels[key].owner == 0) {\n', '      return admin;\n', '    }\n', '    return pixels[key].owner;\n', '  }\n', '\n', '  function getPixelPrice(uint16 row, uint16 col) constant returns (uint) {\n', '    uint32 key = getKey(row, col);\n', '    if (pixels[key].owner == 0) {\n', '      return defaultPrice;\n', '    }\n', '    return pixels[key].price;\n', '  }\n', '\n', '  function getUserMessage(address user) constant returns (string) {\n', '    return messages[user];\n', '  }\n', '\n', '  function getUserTotalSales(address user) constant returns (uint) {\n', '    return users[user].totalSales;\n', '  }\n', '\n', '  //============================================================================\n', '  // Public Transaction API\n', '  //============================================================================\n', '\n', '  function checkPendingWithdrawal() constant returns (uint) {\n', '    return users[msg.sender].pendingWithdrawal;\n', '  }\n', '\n', '  function withdraw() {\n', '    if (users[msg.sender].pendingWithdrawal > 0) {\n', '      uint amount = users[msg.sender].pendingWithdrawal;\n', '      users[msg.sender].pendingWithdrawal = 0;\n', '      msg.sender.transfer(amount);\n', '    }\n', '  }\n', '\n', '  function buyPixel(uint16 row, uint16 col, uint24 newColor) payable {\n', '    uint balance = users[msg.sender].pendingWithdrawal;\n', '    // Return instead of letting getKey throw here to correctly refund the\n', '    // transaction by updating the user balance in user.pendingWithdrawal\n', '    if (row >= size || col >= size) {\n', '      users[msg.sender].pendingWithdrawal = SafeMath.add(balance, msg.value);\n', '      return;\n', '    }\n', '\n', '    uint32 key = getKey(row, col);\n', '    uint price = getPixelPrice(row, col);\n', '    address owner = getPixelOwner(row, col);\n', '\n', '    // Return instead of throw here to correctly refund the transaction by\n', '    // updating the user balance in user.pendingWithdrawal\n', '    if (msg.value < price) {\n', '      users[msg.sender].pendingWithdrawal = SafeMath.add(balance, msg.value);\n', '      return;\n', '    }\n', '\n', '    uint fee = SafeMath.div(msg.value, feeRatio);\n', '    uint payout = SafeMath.sub(msg.value, fee);\n', '\n', '    uint adminBalance = users[admin].pendingWithdrawal;\n', '    users[admin].pendingWithdrawal = SafeMath.add(adminBalance, fee);\n', '\n', '    uint ownerBalance = users[owner].pendingWithdrawal;\n', '    users[owner].pendingWithdrawal = SafeMath.add(ownerBalance, payout);\n', '    users[owner].totalSales = SafeMath.add(users[owner].totalSales, payout);\n', '\n', '    // Increase the price automatically based on the global incrementRate\n', '    uint increase = SafeMath.div(SafeMath.mul(price, incrementRate), 100);\n', '    pixels[key].price = SafeMath.add(price, increase);\n', '    pixels[key].owner = msg.sender;\n', '\n', '    PixelTransfer(row, col, price, owner, msg.sender);\n', '    setPixelColor(row, col, newColor);\n', '  }\n', '\n', '  //============================================================================\n', '  // Owner Management API\n', '  //============================================================================\n', '\n', '  function transferPixel(uint16 row, uint16 col, address newOwner) onlyOwner(row, col) {\n', '    uint32 key = getKey(row, col);\n', '    address owner = pixels[key].owner;\n', '    if (owner != newOwner) {\n', '      pixels[key].owner = newOwner;\n', '      PixelTransfer(row, col, 0, owner, newOwner);\n', '    }\n', '  }\n', '\n', '  function setPixelColor(uint16 row, uint16 col, uint24 color) onlyOwner(row, col) {\n', '    uint32 key = getKey(row, col);\n', '    if (pixels[key].color != color) {\n', '      pixels[key].color = color;\n', '      PixelColor(row, col, pixels[key].owner, color);\n', '    }\n', '  }\n', '\n', '  function setPixelPrice(uint16 row, uint16 col, uint newPrice) onlyOwner(row, col) {\n', '    uint32 key = getKey(row, col);\n', '    // The owner can only lower the price. Price increases are determined by\n', '    // the global incrementRate\n', '    require(pixels[key].price > newPrice);\n', '\n', '    pixels[key].price = newPrice;\n', '    PixelPrice(row, col, pixels[key].owner, newPrice);\n', '  }\n', '\n', '  //============================================================================\n', '  // User Management API\n', '  //============================================================================\n', '\n', '  function setUserMessage(string message) {\n', '    messages[msg.sender] = message;\n', '    UserMessage(msg.sender, message);\n', '  }\n', '}\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']