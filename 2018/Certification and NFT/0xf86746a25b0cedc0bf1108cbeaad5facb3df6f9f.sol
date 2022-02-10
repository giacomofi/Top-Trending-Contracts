['pragma solidity ^0.4.25;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    // Gas optimization: this is cheaper than asserting &#39;a&#39; not being zero, but the\n', '    // benefit is lost if &#39;b&#39; is also tested.\n', '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/// @title Role based access control mixin for Rasmart Platform\n', '/// @author Abha Mai <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="abc6cac2cac9c3ca9399ebccc6cac2c785c8c4c6">[email&#160;protected]</a>>\n', '/// @dev Ignore DRY approach to achieve readability\n', 'contract RBACMixin {\n', '  /// @notice Constant string message to throw on lack of access\n', '  string constant FORBIDDEN = "Haven&#39;t enough right to access";\n', '  /// @notice Public map of owners\n', '  mapping (address => bool) public owners;\n', '  /// @notice Public map of minters\n', '  mapping (address => bool) public minters;\n', '\n', '  /// @notice The event indicates the addition of a new owner\n', '  /// @param who is address of added owner\n', '  event AddOwner(address indexed who);\n', '  /// @notice The event indicates the deletion of an owner\n', '  /// @param who is address of deleted owner\n', '  event DeleteOwner(address indexed who);\n', '\n', '  /// @notice The event indicates the addition of a new minter\n', '  /// @param who is address of added minter\n', '  event AddMinter(address indexed who);\n', '  /// @notice The event indicates the deletion of a minter\n', '  /// @param who is address of deleted minter\n', '  event DeleteMinter(address indexed who);\n', '\n', '  constructor () public {\n', '    _setOwner(msg.sender, true);\n', '  }\n', '\n', '  /// @notice The functional modifier rejects the interaction of senders who are not owners\n', '  modifier onlyOwner() {\n', '    require(isOwner(msg.sender), FORBIDDEN);\n', '    _;\n', '  }\n', '\n', '  /// @notice Functional modifier for rejecting the interaction of senders that are not minters\n', '  modifier onlyMinter() {\n', '    require(isMinter(msg.sender), FORBIDDEN);\n', '    _;\n', '  }\n', '\n', '  /// @notice Look up for the owner role on providen address\n', '  /// @param _who is address to look up\n', '  /// @return A boolean of owner role\n', '  function isOwner(address _who) public view returns (bool) {\n', '    return owners[_who];\n', '  }\n', '\n', '  /// @notice Look up for the minter role on providen address\n', '  /// @param _who is address to look up\n', '  /// @return A boolean of minter role\n', '  function isMinter(address _who) public view returns (bool) {\n', '    return minters[_who];\n', '  }\n', '\n', '  /// @notice Adds the owner role to provided address\n', '  /// @dev Requires owner role to interact\n', '  /// @param _who is address to add role\n', '  /// @return A boolean that indicates if the operation was successful.\n', '  function addOwner(address _who) public onlyOwner returns (bool) {\n', '    _setOwner(_who, true);\n', '  }\n', '\n', '  /// @notice Deletes the owner role to provided address\n', '  /// @dev Requires owner role to interact\n', '  /// @param _who is address to delete role\n', '  /// @return A boolean that indicates if the operation was successful.\n', '  function deleteOwner(address _who) public onlyOwner returns (bool) {\n', '    _setOwner(_who, false);\n', '  }\n', '\n', '  /// @notice Adds the minter role to provided address\n', '  /// @dev Requires owner role to interact\n', '  /// @param _who is address to add role\n', '  /// @return A boolean that indicates if the operation was successful.\n', '  function addMinter(address _who) public onlyOwner returns (bool) {\n', '    _setMinter(_who, true);\n', '  }\n', '\n', '  /// @notice Deletes the minter role to provided address\n', '  /// @dev Requires owner role to interact\n', '  /// @param _who is address to delete role\n', '  /// @return A boolean that indicates if the operation was successful.\n', '  function deleteMinter(address _who) public onlyOwner returns (bool) {\n', '    _setMinter(_who, false);\n', '  }\n', '\n', '  /// @notice Changes the owner role to provided address\n', '  /// @param _who is address to change role\n', '  /// @param _flag is next role status after success\n', '  /// @return A boolean that indicates if the operation was successful.\n', '  function _setOwner(address _who, bool _flag) private returns (bool) {\n', '    require(owners[_who] != _flag);\n', '    owners[_who] = _flag;\n', '    if (_flag) {\n', '      emit AddOwner(_who);\n', '    } else {\n', '      emit DeleteOwner(_who);\n', '    }\n', '    return true;\n', '  }\n', '\n', '  /// @notice Changes the minter role to provided address\n', '  /// @param _who is address to change role\n', '  /// @param _flag is next role status after success\n', '  /// @return A boolean that indicates if the operation was successful.\n', '  function _setMinter(address _who, bool _flag) private returns (bool) {\n', '    require(minters[_who] != _flag);\n', '    minters[_who] = _flag;\n', '    if (_flag) {\n', '      emit AddMinter(_who);\n', '    } else {\n', '      emit DeleteMinter(_who);\n', '    }\n', '    return true;\n', '  }\n', '}\n', '\n', 'interface IMintableToken {\n', '  function mint(address _to, uint256 _amount) external returns (bool);\n', '}\n', '\n', '\n', '/// @title Very simplified implementation of Token Bucket Algorithm to secure token minting\n', '/// @author Abha Mai <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="a6cbc7cfc7c4cec79e94e6c1cbc7cfca88c5c9cb">[email&#160;protected]</a>>\n', '/// @notice Works with tokens implemented Mintable interface\n', '/// @dev Transfer ownership/minting role to contract and execute mint over ICOBucket proxy to secure\n', 'contract ICOBucket is RBACMixin {\n', '  using SafeMath for uint;\n', '\n', '  /// @notice Limit maximum amount of available for minting tokens when bucket is full\n', '  /// @dev Should be enough to mint tokens with proper speed but less enough to prevent overminting in case of losing pkey\n', '  uint256 public size;\n', '  /// @notice Bucket refill rate\n', '  /// @dev Tokens per second (based on block.timestamp). Amount without decimals (in smallest part of token)\n', '  uint256 public rate;\n', '  /// @notice Stored time of latest minting\n', '  /// @dev Each successful call of minting function will update field with call timestamp\n', '  uint256 public lastMintTime;\n', '  /// @notice Left tokens in bucket on time of latest minting\n', '  uint256 public leftOnLastMint;\n', '\n', '  /// @notice Reference of Mintable token\n', '  /// @dev Setup in contructor phase and never change in future\n', '  IMintableToken public token;\n', '\n', '  /// @notice Token Bucket leak event fires on each minting\n', '  /// @param to is address of target tokens holder\n', '  /// @param left is amount of tokens available in bucket after leak\n', '  event Leak(address indexed to, uint256 left);\n', '\n', '  /// ICO SECTION\n', '  /// @notice A token price\n', '  uint256 public tokenCost;\n', '\n', '  /// @notice Allow only whitelisted wallets to purchase\n', '  mapping(address => bool) public whiteList;\n', '\n', '  /// @notice Main wallet all funds are transferred to\n', '  address public wallet;\n', '\n', '  /// @notice Main wallet all funds are transferred to\n', '  uint256 public bonus;\n', '\n', '  /// @notice Minimum amount of tokens can be purchased\n', '  uint256 public minimumTokensForPurchase;\n', '\n', '  /// @notice A helper\n', '  modifier onlyWhiteList {\n', '      require(whiteList[msg.sender]);\n', '      _;\n', '  }\n', '  /// END ICO SECTION\n', '\n', '  /// @param _token is address of Mintable token\n', '  /// @param _size initial size of token bucket\n', '  /// @param _rate initial refill rate (tokens/sec)\n', '  constructor (address _token, uint256 _size, uint256 _rate, uint256 _cost, address _wallet, uint256 _bonus, uint256 _minimum) public {\n', '    token = IMintableToken(_token);\n', '    size = _size;\n', '    rate = _rate;\n', '    leftOnLastMint = _size;\n', '    tokenCost = _cost;\n', '    wallet = _wallet;\n', '    bonus = _bonus;\n', '    minimumTokensForPurchase = _minimum;\n', '  }\n', '\n', '  /// @notice Change size of bucket\n', '  /// @dev Require owner role to call\n', '  /// @param _size is new size of bucket\n', '  /// @return A boolean that indicates if the operation was successful.\n', '  function setSize(uint256 _size) public onlyOwner returns (bool) {\n', '    size = _size;\n', '    return true;\n', '  }\n', '\n', '  /// @notice Change refill rate of bucket\n', '  /// @dev Require owner role to call\n', '  /// @param _rate is new refill rate of bucket\n', '  /// @return A boolean that indicates if the operation was successful.\n', '  function setRate(uint256 _rate) public onlyOwner returns (bool) {\n', '    rate = _rate;\n', '    return true;\n', '  }\n', '\n', '  /// @notice Change size and refill rate of bucket\n', '  /// @dev Require owner role to call\n', '  /// @param _size is new size of bucket\n', '  /// @param _rate is new refill rate of bucket\n', '  /// @return A boolean that indicates if the operation was successful.\n', '  function setSizeAndRate(uint256 _size, uint256 _rate) public onlyOwner returns (bool) {\n', '    return setSize(_size) && setRate(_rate);\n', '  }\n', '\n', '  /// @notice Function to calculate and get available in bucket tokens\n', '  /// @return An amount of available tokens in bucket\n', '  function availableTokens() public view returns (uint) {\n', '     // solium-disable-next-line security/no-block-members\n', '    uint256 timeAfterMint = now.sub(lastMintTime);\n', '    uint256 refillAmount = rate.mul(timeAfterMint).add(leftOnLastMint);\n', '    return size < refillAmount ? size : refillAmount;\n', '  }\n', '\n', '  /// ICO METHODS\n', '  function addToWhiteList(address _address) public onlyMinter {\n', '    whiteList[_address] = true;\n', '  }\n', '\n', '  function removeFromWhiteList(address _address) public onlyMinter {\n', '    whiteList[_address] = false;\n', '  }\n', '\n', '  function setWallet(address _wallet) public onlyOwner {\n', '    wallet = _wallet;\n', '  }\n', '\n', '  function setBonus(uint256 _bonus) public onlyOwner {\n', '    bonus = _bonus;\n', '  }\n', '\n', '  function setMinimumTokensForPurchase(uint256 _minimum) public onlyOwner {\n', '    minimumTokensForPurchase = _minimum;\n', '  }\n', '\n', '  /// @notice Purchase function mints tokens\n', '  /// @return A boolean that indicates if the operation was successful.\n', '  function () public payable onlyWhiteList {\n', '    uint256 tokensAmount = tokensAmountForPurchase();\n', '    uint256 available = availableTokens();\n', '    uint256 minimum = minimumTokensForPurchase;\n', '    require(tokensAmount <= available);\n', '    require(tokensAmount >= minimum);\n', '    // transfer all funcds to external multisig wallet\n', '    wallet.transfer(msg.value);\n', '    leftOnLastMint = available.sub(tokensAmount);\n', '    lastMintTime = now; // solium-disable-line security/no-block-members\n', '    require(token.mint(msg.sender, tokensAmount));\n', '  }\n', '\n', '  function tokensAmountForPurchase() private constant returns(uint256) {\n', '    return msg.value.mul(10 ** 18)\n', '                    .div(tokenCost)\n', '                    .mul(100 + bonus)\n', '                    .div(100);\n', '  }\n', '}']
['pragma solidity ^0.4.25;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', "    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/// @title Role based access control mixin for Rasmart Platform\n', '/// @author Abha Mai <maiabha82@gmail.com>\n', '/// @dev Ignore DRY approach to achieve readability\n', 'contract RBACMixin {\n', '  /// @notice Constant string message to throw on lack of access\n', '  string constant FORBIDDEN = "Haven\'t enough right to access";\n', '  /// @notice Public map of owners\n', '  mapping (address => bool) public owners;\n', '  /// @notice Public map of minters\n', '  mapping (address => bool) public minters;\n', '\n', '  /// @notice The event indicates the addition of a new owner\n', '  /// @param who is address of added owner\n', '  event AddOwner(address indexed who);\n', '  /// @notice The event indicates the deletion of an owner\n', '  /// @param who is address of deleted owner\n', '  event DeleteOwner(address indexed who);\n', '\n', '  /// @notice The event indicates the addition of a new minter\n', '  /// @param who is address of added minter\n', '  event AddMinter(address indexed who);\n', '  /// @notice The event indicates the deletion of a minter\n', '  /// @param who is address of deleted minter\n', '  event DeleteMinter(address indexed who);\n', '\n', '  constructor () public {\n', '    _setOwner(msg.sender, true);\n', '  }\n', '\n', '  /// @notice The functional modifier rejects the interaction of senders who are not owners\n', '  modifier onlyOwner() {\n', '    require(isOwner(msg.sender), FORBIDDEN);\n', '    _;\n', '  }\n', '\n', '  /// @notice Functional modifier for rejecting the interaction of senders that are not minters\n', '  modifier onlyMinter() {\n', '    require(isMinter(msg.sender), FORBIDDEN);\n', '    _;\n', '  }\n', '\n', '  /// @notice Look up for the owner role on providen address\n', '  /// @param _who is address to look up\n', '  /// @return A boolean of owner role\n', '  function isOwner(address _who) public view returns (bool) {\n', '    return owners[_who];\n', '  }\n', '\n', '  /// @notice Look up for the minter role on providen address\n', '  /// @param _who is address to look up\n', '  /// @return A boolean of minter role\n', '  function isMinter(address _who) public view returns (bool) {\n', '    return minters[_who];\n', '  }\n', '\n', '  /// @notice Adds the owner role to provided address\n', '  /// @dev Requires owner role to interact\n', '  /// @param _who is address to add role\n', '  /// @return A boolean that indicates if the operation was successful.\n', '  function addOwner(address _who) public onlyOwner returns (bool) {\n', '    _setOwner(_who, true);\n', '  }\n', '\n', '  /// @notice Deletes the owner role to provided address\n', '  /// @dev Requires owner role to interact\n', '  /// @param _who is address to delete role\n', '  /// @return A boolean that indicates if the operation was successful.\n', '  function deleteOwner(address _who) public onlyOwner returns (bool) {\n', '    _setOwner(_who, false);\n', '  }\n', '\n', '  /// @notice Adds the minter role to provided address\n', '  /// @dev Requires owner role to interact\n', '  /// @param _who is address to add role\n', '  /// @return A boolean that indicates if the operation was successful.\n', '  function addMinter(address _who) public onlyOwner returns (bool) {\n', '    _setMinter(_who, true);\n', '  }\n', '\n', '  /// @notice Deletes the minter role to provided address\n', '  /// @dev Requires owner role to interact\n', '  /// @param _who is address to delete role\n', '  /// @return A boolean that indicates if the operation was successful.\n', '  function deleteMinter(address _who) public onlyOwner returns (bool) {\n', '    _setMinter(_who, false);\n', '  }\n', '\n', '  /// @notice Changes the owner role to provided address\n', '  /// @param _who is address to change role\n', '  /// @param _flag is next role status after success\n', '  /// @return A boolean that indicates if the operation was successful.\n', '  function _setOwner(address _who, bool _flag) private returns (bool) {\n', '    require(owners[_who] != _flag);\n', '    owners[_who] = _flag;\n', '    if (_flag) {\n', '      emit AddOwner(_who);\n', '    } else {\n', '      emit DeleteOwner(_who);\n', '    }\n', '    return true;\n', '  }\n', '\n', '  /// @notice Changes the minter role to provided address\n', '  /// @param _who is address to change role\n', '  /// @param _flag is next role status after success\n', '  /// @return A boolean that indicates if the operation was successful.\n', '  function _setMinter(address _who, bool _flag) private returns (bool) {\n', '    require(minters[_who] != _flag);\n', '    minters[_who] = _flag;\n', '    if (_flag) {\n', '      emit AddMinter(_who);\n', '    } else {\n', '      emit DeleteMinter(_who);\n', '    }\n', '    return true;\n', '  }\n', '}\n', '\n', 'interface IMintableToken {\n', '  function mint(address _to, uint256 _amount) external returns (bool);\n', '}\n', '\n', '\n', '/// @title Very simplified implementation of Token Bucket Algorithm to secure token minting\n', '/// @author Abha Mai <maiabha82@gmail.com>\n', '/// @notice Works with tokens implemented Mintable interface\n', '/// @dev Transfer ownership/minting role to contract and execute mint over ICOBucket proxy to secure\n', 'contract ICOBucket is RBACMixin {\n', '  using SafeMath for uint;\n', '\n', '  /// @notice Limit maximum amount of available for minting tokens when bucket is full\n', '  /// @dev Should be enough to mint tokens with proper speed but less enough to prevent overminting in case of losing pkey\n', '  uint256 public size;\n', '  /// @notice Bucket refill rate\n', '  /// @dev Tokens per second (based on block.timestamp). Amount without decimals (in smallest part of token)\n', '  uint256 public rate;\n', '  /// @notice Stored time of latest minting\n', '  /// @dev Each successful call of minting function will update field with call timestamp\n', '  uint256 public lastMintTime;\n', '  /// @notice Left tokens in bucket on time of latest minting\n', '  uint256 public leftOnLastMint;\n', '\n', '  /// @notice Reference of Mintable token\n', '  /// @dev Setup in contructor phase and never change in future\n', '  IMintableToken public token;\n', '\n', '  /// @notice Token Bucket leak event fires on each minting\n', '  /// @param to is address of target tokens holder\n', '  /// @param left is amount of tokens available in bucket after leak\n', '  event Leak(address indexed to, uint256 left);\n', '\n', '  /// ICO SECTION\n', '  /// @notice A token price\n', '  uint256 public tokenCost;\n', '\n', '  /// @notice Allow only whitelisted wallets to purchase\n', '  mapping(address => bool) public whiteList;\n', '\n', '  /// @notice Main wallet all funds are transferred to\n', '  address public wallet;\n', '\n', '  /// @notice Main wallet all funds are transferred to\n', '  uint256 public bonus;\n', '\n', '  /// @notice Minimum amount of tokens can be purchased\n', '  uint256 public minimumTokensForPurchase;\n', '\n', '  /// @notice A helper\n', '  modifier onlyWhiteList {\n', '      require(whiteList[msg.sender]);\n', '      _;\n', '  }\n', '  /// END ICO SECTION\n', '\n', '  /// @param _token is address of Mintable token\n', '  /// @param _size initial size of token bucket\n', '  /// @param _rate initial refill rate (tokens/sec)\n', '  constructor (address _token, uint256 _size, uint256 _rate, uint256 _cost, address _wallet, uint256 _bonus, uint256 _minimum) public {\n', '    token = IMintableToken(_token);\n', '    size = _size;\n', '    rate = _rate;\n', '    leftOnLastMint = _size;\n', '    tokenCost = _cost;\n', '    wallet = _wallet;\n', '    bonus = _bonus;\n', '    minimumTokensForPurchase = _minimum;\n', '  }\n', '\n', '  /// @notice Change size of bucket\n', '  /// @dev Require owner role to call\n', '  /// @param _size is new size of bucket\n', '  /// @return A boolean that indicates if the operation was successful.\n', '  function setSize(uint256 _size) public onlyOwner returns (bool) {\n', '    size = _size;\n', '    return true;\n', '  }\n', '\n', '  /// @notice Change refill rate of bucket\n', '  /// @dev Require owner role to call\n', '  /// @param _rate is new refill rate of bucket\n', '  /// @return A boolean that indicates if the operation was successful.\n', '  function setRate(uint256 _rate) public onlyOwner returns (bool) {\n', '    rate = _rate;\n', '    return true;\n', '  }\n', '\n', '  /// @notice Change size and refill rate of bucket\n', '  /// @dev Require owner role to call\n', '  /// @param _size is new size of bucket\n', '  /// @param _rate is new refill rate of bucket\n', '  /// @return A boolean that indicates if the operation was successful.\n', '  function setSizeAndRate(uint256 _size, uint256 _rate) public onlyOwner returns (bool) {\n', '    return setSize(_size) && setRate(_rate);\n', '  }\n', '\n', '  /// @notice Function to calculate and get available in bucket tokens\n', '  /// @return An amount of available tokens in bucket\n', '  function availableTokens() public view returns (uint) {\n', '     // solium-disable-next-line security/no-block-members\n', '    uint256 timeAfterMint = now.sub(lastMintTime);\n', '    uint256 refillAmount = rate.mul(timeAfterMint).add(leftOnLastMint);\n', '    return size < refillAmount ? size : refillAmount;\n', '  }\n', '\n', '  /// ICO METHODS\n', '  function addToWhiteList(address _address) public onlyMinter {\n', '    whiteList[_address] = true;\n', '  }\n', '\n', '  function removeFromWhiteList(address _address) public onlyMinter {\n', '    whiteList[_address] = false;\n', '  }\n', '\n', '  function setWallet(address _wallet) public onlyOwner {\n', '    wallet = _wallet;\n', '  }\n', '\n', '  function setBonus(uint256 _bonus) public onlyOwner {\n', '    bonus = _bonus;\n', '  }\n', '\n', '  function setMinimumTokensForPurchase(uint256 _minimum) public onlyOwner {\n', '    minimumTokensForPurchase = _minimum;\n', '  }\n', '\n', '  /// @notice Purchase function mints tokens\n', '  /// @return A boolean that indicates if the operation was successful.\n', '  function () public payable onlyWhiteList {\n', '    uint256 tokensAmount = tokensAmountForPurchase();\n', '    uint256 available = availableTokens();\n', '    uint256 minimum = minimumTokensForPurchase;\n', '    require(tokensAmount <= available);\n', '    require(tokensAmount >= minimum);\n', '    // transfer all funcds to external multisig wallet\n', '    wallet.transfer(msg.value);\n', '    leftOnLastMint = available.sub(tokensAmount);\n', '    lastMintTime = now; // solium-disable-line security/no-block-members\n', '    require(token.mint(msg.sender, tokensAmount));\n', '  }\n', '\n', '  function tokensAmountForPurchase() private constant returns(uint256) {\n', '    return msg.value.mul(10 ** 18)\n', '                    .div(tokenCost)\n', '                    .mul(100 + bonus)\n', '                    .div(100);\n', '  }\n', '}']
