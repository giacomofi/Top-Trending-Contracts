['pragma solidity ^0.4.18;\n', '\n', '// File: zeppelin/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: zeppelin/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/IFOFirstRound.sol\n', '\n', 'contract NILTokenInterface is Ownable {\n', '  uint8 public decimals;\n', '  bool public paused;\n', '  bool public mintingFinished;\n', '  uint256 public totalSupply;\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  function balanceOf(address who) public constant returns (uint256);\n', '\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool);\n', '\n', '  function pause() onlyOwner whenNotPaused public;\n', '}\n', '\n', '// @dev Handles the pre-IFO\n', '\n', 'contract IFOFirstRound is Ownable {\n', '  using SafeMath for uint;\n', '\n', '  NILTokenInterface public token;\n', '\n', '  uint public maxPerWallet = 30000;\n', '\n', '  address public project;\n', '\n', '  address public founders;\n', '\n', '  uint public baseAmount = 1000;\n', '\n', '  // pre dist\n', '\n', '  uint public preDuration;\n', '\n', '  uint public preStartBlock;\n', '\n', '  uint public preEndBlock;\n', '\n', '  // numbers\n', '\n', '  uint public totalParticipants;\n', '\n', '  uint public tokenSupply;\n', '\n', '  bool public projectFoundersReserved;\n', '\n', '  uint public projectReserve = 35;\n', '\n', '  uint public foundersReserve = 15;\n', '\n', '  // states\n', '\n', '  modifier onlyState(bytes32 expectedState) {\n', '    require(expectedState == currentState());\n', '    _;\n', '  }\n', '\n', '  function currentState() public constant returns (bytes32) {\n', '    uint bn = block.number;\n', '\n', '    if (preStartBlock == 0) {\n', '      return "Inactive";\n', '    }\n', '    else if (bn < preStartBlock) {\n', '      return "PreDistInitiated";\n', '    }\n', '    else if (bn <= preEndBlock) {\n', '      return "PreDist";\n', '    }\n', '    else {\n', '      return "InBetween";\n', '    }\n', '  }\n', '\n', '  // distribution\n', '\n', '  function _toNanoNIL(uint amount) internal constant returns (uint) {\n', '    return amount.mul(10 ** uint(token.decimals()));\n', '  }\n', '\n', '  function _fromNanoNIL(uint amount) internal constant returns (uint) {\n', '    return amount.div(10 ** uint(token.decimals()));\n', '  }\n', '\n', '  // requiring NIL\n', '\n', '  function() external payable {\n', '    _getTokens();\n', '  }\n', '\n', '  // 0x7a0c396d\n', '  function giveMeNILs() public payable {\n', '    _getTokens();\n', '  }\n', '\n', '  function _getTokens() internal {\n', '    require(currentState() == "PreDist" || currentState() == "Dist");\n', '    require(msg.sender != address(0));\n', '\n', '    uint balance = token.balanceOf(msg.sender);\n', '    if (balance == 0) {\n', '      totalParticipants++;\n', '    }\n', '\n', '    uint limit = _toNanoNIL(maxPerWallet);\n', '\n', '    require(balance < limit);\n', '\n', '    uint tokensToBeMinted = _toNanoNIL(getTokensAmount());\n', '\n', '    if (balance > 0 && balance + tokensToBeMinted > limit) {\n', '      tokensToBeMinted = limit.sub(balance);\n', '    }\n', '\n', '    token.mint(msg.sender, tokensToBeMinted);\n', '\n', '  }\n', '\n', '  function getTokensAmount() public constant returns (uint) {\n', '    if (currentState() == "PreDist") {\n', '      return baseAmount.mul(5);\n', '    } else {\n', '      return 0;\n', '    }\n', '  }\n', '\n', '  function startPreDistribution(uint _startBlock, uint _duration, address _project, address _founders, address _token) public onlyOwner onlyState("Inactive") {\n', '    require(_startBlock > block.number);\n', '    require(_duration > 0 && _duration < 30000);\n', '    require(msg.sender != address(0));\n', '    require(_project != address(0));\n', '    require(_founders != address(0));\n', '\n', '    token = NILTokenInterface(_token);\n', '    token.pause();\n', '    require(token.paused());\n', '\n', '    project = _project;\n', '    founders = _founders;\n', '    preDuration = _duration;\n', '    preStartBlock = _startBlock;\n', '    preEndBlock = _startBlock + _duration;\n', '  }\n', '\n', '  function reserveTokensProjectAndFounders() public onlyOwner onlyState("InBetween") {\n', '    require(!projectFoundersReserved);\n', '\n', '    tokenSupply = 2 * token.totalSupply();\n', '\n', '    uint amount = tokenSupply.mul(projectReserve).div(100);\n', '    token.mint(project, amount);\n', '    amount = tokenSupply.mul(foundersReserve).div(100);\n', '    token.mint(founders, amount);\n', '    projectFoundersReserved = true;\n', '\n', '    if (this.balance > 0) {\n', '      project.transfer(this.balance);\n', '    }\n', '  }\n', '\n', '  function totalSupply() public constant returns (uint){\n', '    require(currentState() != "Inactive");\n', '    return _fromNanoNIL(token.totalSupply());\n', '  }\n', '\n', '  function transferTokenOwnership(address _newOwner) public onlyOwner {\n', '    require(projectFoundersReserved);\n', '    token.transferOwnership(_newOwner);\n', '  }\n', '\n', '}']