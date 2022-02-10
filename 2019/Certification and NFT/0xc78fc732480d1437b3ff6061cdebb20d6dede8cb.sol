['// File: contracts/SafeMath.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: contracts/Ownable.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.\n', '   */\n', '  constructor () public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/Pausable.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '  constructor() public {}\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS paused\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS NOT paused\n', '   */\n', '  modifier whenPaused {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() public onlyOwner whenNotPaused returns (bool) {\n', '    paused = true;\n', '    emit Pause();\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() public onlyOwner whenPaused returns (bool) {\n', '    paused = false;\n', '    emit Unpause();\n', '    return true;\n', '  }\n', '}\n', '\n', '// File: contracts/Controllable.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '/**\n', ' * @title Controllable\n', ' * @dev The Controllable contract has an controller address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Controllable {\n', '  address public controller;\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.\n', '   */\n', '  constructor() public {\n', '    controller = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyController() {\n', '    require(msg.sender == controller);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newController The address to transfer ownership to.\n', '   */\n', '  function transferControl(address newController) public onlyController {\n', '    if (newController != address(0)) {\n', '      controller = newController;\n', '    }\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/TokenInterface.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '/**\n', ' * @title Token (WIRA)\n', ' * Standard Mintable ERC20 Token\n', ' * https://github.com/ethereum/EIPs/issues/20\n', ' * Based on code by FirstBlood:\n', ' * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract TokenInterface is Controllable {\n', '\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '  event ClaimedTokens(address indexed _token, address indexed _owner, uint _amount);\n', '  event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _amount);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '  function totalSupply() public view returns (uint);\n', '  function totalSupplyAt(uint _blockNumber) public view returns(uint);\n', '  function balanceOf(address _owner) public view returns (uint256 balance);\n', '  function balanceOfAt(address _owner, uint _blockNumber) public view returns (uint);\n', '  function transfer(address _to, uint256 _amount) public returns (bool success);\n', '  function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);\n', '  function approve(address _spender, uint256 _amount) public returns (bool success);\n', '  function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '  function mint(address _owner, uint _amount) public returns (bool);\n', '  function enableTransfers() public returns (bool);\n', '  function finishMinting() public returns (bool);\n', '}\n', '\n', '// File: contracts/WiraTokenSale.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '\n', '/**\n', ' * @title WiraTokenSale\n', ' * Tokensale allows investors to make token purchases and assigns them tokens based\n', '\n', ' * on a token per ETH rate. Funds collected are forwarded to a wallet as they arrive.\n', ' */\n', ' contract WiraTokenSale is Pausable {\n', '   using SafeMath for uint256;\n', '\n', '   TokenInterface public token;\n', '   uint256 public totalWeiRaised;\n', '   uint256 public tokensMinted;\n', '   uint256 public contributors;\n', '\n', '   bool public teamTokensMinted = false;\n', '   bool public finalized = false;\n', '\n', '   address payable tokenSaleWalletAddress;\n', '   address public tokenWalletAddress;\n', '   uint256 public constant FIRST_ROUND_CAP = 20000000 * 10 ** 18;\n', '   uint256 public constant SECOND_ROUND_CAP = 70000000 * 10 ** 18;\n', '   uint256 public constant TOKENSALE_CAP = 122500000 * 10 ** 18;\n', '   uint256 public constant TOTAL_CAP = 408333334 * 10 ** 18;\n', '   uint256 public constant TEAM_TOKENS = 285833334 * 10 ** 18; //TOTAL_CAP - TOKENSALE_CAP\n', '\n', '   uint256 public conversionRateInCents = 15000; // 1ETH = 15000 cents by default - can be updated\n', '   uint256 public firstRoundStartDate;\n', '   uint256 public firstRoundEndDate;\n', '   uint256 public secondRoundStartDate;\n', '   uint256 public secondRoundEndDate;\n', '   uint256 public thirdRoundStartDate;\n', '   uint256 public thirdRoundEndDate;\n', '\n', '   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '   event Finalized();\n', '\n', '   constructor(\n', '     address _tokenAddress,\n', '     uint256 _startDate,\n', '     address _tokenSaleWalletAddress,\n', '     address _tokenWalletAddress\n', '   ) public {\n', '     require(_tokenAddress != address(0));\n', '\n', '      token = TokenInterface(_tokenAddress);\n', '\n', '      //Hardcoded to conform to the current tokensale plan with firstRoundStartDate = _startDate = 1556668800\n', '      //firstRoundStartDate = 1556668800;  //1st May 2019 @ 00:00 GMT\n', '      //firstRoundEndDate = 1557187200; // 7th May 2019 @ 00:00 GMT\n', '      //secondRoundStartDate = 1557273600; // 8th May 2019 @ 00:00 GMT\n', '      //secondRoundEndDate = 1557792000; // 14th May 2019 @ 00:00 GMT\n', '      //thirdRoundStartDate = 1557878400; // 15th May 2019 @ 00:00 GMT\n', '      //thirdRoundEndDate = 1561939200; // 1st July 2019 @ 00:00 GMT\n', '      firstRoundStartDate = _startDate;\n', '      firstRoundEndDate = _startDate + 518400;\n', '      secondRoundStartDate = _startDate + 604800;\n', '      secondRoundEndDate = _startDate + 1123200;\n', '      thirdRoundStartDate = _startDate + 1209600;\n', '      thirdRoundEndDate = _startDate + 5270400;\n', '\n', '      tokenSaleWalletAddress = address(uint160(_tokenSaleWalletAddress));\n', '      tokenWalletAddress = _tokenWalletAddress;\n', '   }\n', '\n', '   /**\n', '    * High level token purchase function\n', '    */\n', '   function() external payable {\n', '     buyTokens(msg.sender);\n', '   }\n', '\n', '\n', '   /**\n', '    * Mint team tokens\n', '    */\n', '   function mintTeamTokens() public onlyOwner {\n', '     require(!teamTokensMinted);\n', '     token.mint(tokenWalletAddress, TEAM_TOKENS);\n', '     teamTokensMinted = true;\n', '   }\n', '\n', '   /**\n', '    * Low level token purchase function\n', '    * @param _beneficiary will receive the tokens.\n', '    */\n', '   function buyTokens(address _beneficiary) public payable whenNotPaused whenNotFinalized {\n', '     require(_beneficiary != address(0));\n', '     validatePurchase();\n', '\n', '     uint256 current = now;\n', '     uint256 tokens;\n', '\n', '     totalWeiRaised = totalWeiRaised.add(msg.value);\n', '\n', '     if (now >= firstRoundStartDate && now <= firstRoundEndDate) {\n', '      tokens = (msg.value * conversionRateInCents) / 10;\n', '     } else if (now >= secondRoundStartDate && now <= secondRoundEndDate) {\n', '       tokens = (msg.value * conversionRateInCents) / 15;\n', '     } else if (now >= thirdRoundStartDate && now <= thirdRoundEndDate) {\n', '       tokens = (msg.value * conversionRateInCents) / 20;\n', '     }\n', '\n', '    contributors = contributors.add(1);\n', '    tokensMinted = tokensMinted.add(tokens);\n', '\n', '    /*\n', '    *@info: msg.value can stay in Wei as long as decimals for the tokens are the same as Ethereum (18 decimals)\n', '    */\n', '    bool earlyBirdSale = (current >= firstRoundStartDate && current <= firstRoundEndDate);\n', '    bool prelaunchSale = (current >= secondRoundStartDate && current <= secondRoundEndDate);\n', '    bool mainSale = (current >= thirdRoundStartDate && current <= thirdRoundEndDate);\n', '\n', '    if (earlyBirdSale) require(tokensMinted < FIRST_ROUND_CAP);\n', '    if (prelaunchSale) require(tokensMinted < SECOND_ROUND_CAP);\n', '    if (mainSale) require(tokensMinted < TOKENSALE_CAP);\n', '\n', '    token.mint(_beneficiary, tokens);\n', '    emit TokenPurchase(msg.sender, _beneficiary, msg.value, tokens);\n', '    forwardFunds();\n', '   }\n', '\n', '   function updateConversionRate(uint256 _conversionRateInCents) onlyOwner public {\n', '     conversionRateInCents = _conversionRateInCents;\n', '   }\n', '\n', '   /**\n', '   * Forwards funds to the tokensale wallet\n', '   */\n', '   function forwardFunds() internal {\n', '     address(tokenSaleWalletAddress).transfer(msg.value);\n', '   }\n', '\n', '   function currentDate() public view returns (uint256) {\n', '     return now;\n', '   }\n', '\n', '   /**\n', '   * Validates the purchase (period, minimum amount, within cap)\n', '   * @return {bool} valid\n', '   */\n', '   function validatePurchase() internal returns (bool) {\n', '     uint256 current = now;\n', '     bool duringFirstRound = (current >= firstRoundStartDate && current <= firstRoundEndDate);\n', '     bool duringSecondRound = (current >= secondRoundStartDate && current <= secondRoundEndDate);\n', '     bool duringThirdRound = (current >= thirdRoundStartDate && current <= thirdRoundEndDate);\n', '     bool nonZeroPurchase = msg.value != 0;\n', '\n', '     require(duringFirstRound || duringSecondRound || duringThirdRound);\n', '     require(nonZeroPurchase);\n', '   }\n', '\n', '   /**\n', '   * Returns the total WIRA token supply\n', '   * @return totalSupply {uint256} WIRA Token Total Supply\n', '   */\n', '   function totalSupply() public view returns (uint256) {\n', '     return token.totalSupply();\n', '   }\n', '\n', '   /**\n', '   * Returns token holder WIRA Token balance\n', '   * @param _owner {address} Token holder address\n', '   * @return balance {uint256} Corresponding token holder balance\n', '   */\n', '   function balanceOf(address _owner) public view returns (uint256) {\n', '     return token.balanceOf(_owner);\n', '   }\n', '\n', '   /**\n', '   * Change the WIRA Token controller\n', '   * @param _newController {address} New WIRA Token controller\n', '   */\n', '   function changeController(address _newController) public onlyOwner {\n', '     require(isContract(_newController));\n', '     token.transferControl(_newController);\n', '   }\n', '\n', '   function finalize() public onlyOwner {\n', '     require(paused);\n', '     emit Finalized();\n', '\n', '    uint256 remainingTokens = TOKENSALE_CAP - tokensMinted;\n', '    token.mint(tokenWalletAddress, remainingTokens);\n', '\n', '     finalized = true;\n', '   }\n', '\n', '   function enableTransfers() public onlyOwner {\n', '     token.enableTransfers();\n', '   }\n', '\n', '\n', '   function isContract(address _addr) view internal returns(bool) {\n', '     uint size;\n', '     if (_addr == address(0))\n', '       return false;\n', '     assembly {\n', '         size := extcodesize(_addr)\n', '     }\n', '     return size>0;\n', '   }\n', '\n', '   modifier whenNotFinalized() {\n', '     require(!finalized);\n', '     _;\n', '   }\n', '\n', ' }']