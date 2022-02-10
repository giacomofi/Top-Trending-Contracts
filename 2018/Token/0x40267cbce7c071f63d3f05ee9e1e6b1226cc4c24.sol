['pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '  function safeTransfer(ERC20Basic token, address to, uint256 value) internal {\n', '    assert(token.transfer(to, value));\n', '  }\n', '\n', '  function safeTransferFrom(\n', '    ERC20 token,\n', '    address from,\n', '    address to,\n', '    uint256 value\n', '  )\n', '    internal\n', '  {\n', '    assert(token.transferFrom(from, to, value));\n', '  }\n', '\n', '  function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '    assert(token.approve(spender, value));\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Locker\n', ' * @notice Locker holds tokens and releases them at a certain time.\n', ' */\n', 'contract Locker is Ownable {\n', '  using SafeMath for uint;\n', '  using SafeERC20 for ERC20Basic;\n', '\n', '  /**\n', '   * It is init state only when adding release info is possible.\n', '   * beneficiary only can release tokens when Locker is active.\n', '   * After all tokens are released, locker is drawn.\n', '   */\n', '  enum State { Init, Ready, Active, Drawn }\n', '\n', '  struct Beneficiary {\n', '    uint ratio;             // ratio based on Locker&#39;s initial balance.\n', '    uint withdrawAmount;    // accumulated tokens beneficiary released\n', '    bool releaseAllTokens;\n', '  }\n', '\n', '  /**\n', '   * @notice Release has info to release tokens.\n', '   * If lock type is straight, only two release infos is required.\n', '   *\n', '   *     |\n', '   * 100 |                _______________\n', '   *     |              _/\n', '   *  50 |            _/\n', '   *     |         . |\n', '   *     |       .   |\n', '   *     |     .     |\n', '   *     +===+=======+----*----------> time\n', '   *     Locker  First    Last\n', '   *  Activated  Release  Release\n', '   *\n', '   *\n', '   * If lock type is variable, the release graph will be\n', '   *\n', '   *     |\n', '   * 100 |                                 _________\n', '   *     |                                |\n', '   *  70 |                      __________|\n', '   *     |                     |\n', '   *  30 |            _________|\n', '   *     |           |\n', '   *     +===+=======+---------+----------*------> time\n', '   *     Locker   First        Second     Last\n', '   *  Activated   Release      Release    Release\n', '   *\n', '   *\n', '   *\n', '   * For the first straight release graph, parameters would be\n', '   *   coeff: 100\n', '   *   releaseTimes: [\n', '   *     first release time,\n', '   *     second release time\n', '   *   ]\n', '   *   releaseRatios: [\n', '   *     50,\n', '   *     100,\n', '   *   ]\n', '   *\n', '   * For the second variable release graph, parameters would be\n', '   *   coeff: 100\n', '   *   releaseTimes: [\n', '   *     first release time,\n', '   *     second release time,\n', '   *     last release time\n', '   *   ]\n', '   *   releaseRatios: [\n', '   *     30,\n', '   *     70,\n', '   *     100,\n', '   *   ]\n', '   *\n', '   */\n', '  struct Release {\n', '    bool isStraight;        // lock type : straight or variable\n', '    uint[] releaseTimes;    //\n', '    uint[] releaseRatios;   //\n', '  }\n', '\n', '  uint public activeTime;\n', '\n', '  // ERC20 basic token contract being held\n', '  ERC20Basic public token;\n', '\n', '  uint public coeff;\n', '  uint public initialBalance;\n', '  uint public withdrawAmount; // total amount of tokens released\n', '\n', '  mapping (address => Beneficiary) public beneficiaries;\n', '  mapping (address => Release) public releases;  // beneficiary&#39;s lock\n', '  mapping (address => bool) public locked; // whether beneficiary&#39;s lock is instantiated\n', '\n', '  uint public numBeneficiaries;\n', '  uint public numLocks;\n', '\n', '  State public state;\n', '\n', '  modifier onlyState(State v) {\n', '    require(state == v);\n', '    _;\n', '  }\n', '\n', '  modifier onlyBeneficiary(address _addr) {\n', '    require(beneficiaries[_addr].ratio > 0);\n', '    _;\n', '  }\n', '\n', '  event StateChanged(State _state);\n', '  event Locked(address indexed _beneficiary, bool _isStraight);\n', '  event Released(address indexed _beneficiary, uint256 _amount);\n', '\n', '  function Locker(address _token, uint _coeff, address[] _beneficiaries, uint[] _ratios) public {\n', '    require(_token != address(0));\n', '    require(_beneficiaries.length == _ratios.length);\n', '\n', '    token = ERC20Basic(_token);\n', '    coeff = _coeff;\n', '    numBeneficiaries = _beneficiaries.length;\n', '\n', '    uint accRatio;\n', '\n', '    for(uint i = 0; i < numBeneficiaries; i++) {\n', '      require(_ratios[i] > 0);\n', '      beneficiaries[_beneficiaries[i]].ratio = _ratios[i];\n', '\n', '      accRatio = accRatio.add(_ratios[i]);\n', '    }\n', '\n', '    require(coeff == accRatio);\n', '  }\n', '\n', '  /**\n', '   * @notice beneficiary can release their tokens after activated\n', '   */\n', '  function activate() external onlyOwner onlyState(State.Ready) {\n', '    require(numLocks == numBeneficiaries); // double check : assert all releases are recorded\n', '\n', '    initialBalance = token.balanceOf(this);\n', '    require(initialBalance > 0);\n', '\n', '    activeTime = now; // solium-disable-line security/no-block-members\n', '\n', '    // set locker as active state\n', '    state = State.Active;\n', '    emit StateChanged(state);\n', '  }\n', '\n', '  function getReleaseType(address _beneficiary)\n', '    public\n', '    view\n', '    onlyBeneficiary(_beneficiary)\n', '    returns (bool)\n', '  {\n', '    return releases[_beneficiary].isStraight;\n', '  }\n', '\n', '  function getTotalLockedAmounts(address _beneficiary)\n', '    public\n', '    view\n', '    onlyBeneficiary(_beneficiary)\n', '    returns (uint)\n', '  {\n', '    return getPartialAmount(beneficiaries[_beneficiary].ratio, coeff, initialBalance);\n', '  }\n', '\n', '  function getReleaseTimes(address _beneficiary)\n', '    public\n', '    view\n', '    onlyBeneficiary(_beneficiary)\n', '    returns (uint[])\n', '  {\n', '    return releases[_beneficiary].releaseTimes;\n', '  }\n', '\n', '  function getReleaseRatios(address _beneficiary)\n', '    public\n', '    view\n', '    onlyBeneficiary(_beneficiary)\n', '    returns (uint[])\n', '  {\n', '    return releases[_beneficiary].releaseRatios;\n', '  }\n', '\n', '  /**\n', '   * @notice add new release record for beneficiary\n', '   */\n', '  function lock(address _beneficiary, bool _isStraight, uint[] _releaseTimes, uint[] _releaseRatios)\n', '    external\n', '    onlyOwner\n', '    onlyState(State.Init)\n', '    onlyBeneficiary(_beneficiary)\n', '  {\n', '    require(!locked[_beneficiary]);\n', '    require(_releaseRatios.length != 0);\n', '    require(_releaseRatios.length == _releaseTimes.length);\n', '\n', '    uint i;\n', '    uint len = _releaseRatios.length;\n', '\n', '    // finally should release all tokens\n', '    require(_releaseRatios[len - 1] == coeff);\n', '\n', '    // check two array are ascending sorted\n', '    for(i = 0; i < len - 1; i++) {\n', '      require(_releaseTimes[i] < _releaseTimes[i + 1]);\n', '      require(_releaseRatios[i] < _releaseRatios[i + 1]);\n', '    }\n', '\n', '    // 2 release times for straight locking type\n', '    if (_isStraight) {\n', '      require(len == 2);\n', '    }\n', '\n', '    numLocks = numLocks.add(1);\n', '\n', '    // create Release for the beneficiary\n', '    releases[_beneficiary].isStraight = _isStraight;\n', '\n', '    // copy array of uint\n', '    releases[_beneficiary].releaseTimes = _releaseTimes;\n', '    releases[_beneficiary].releaseRatios = _releaseRatios;\n', '\n', '    // lock beneficiary\n', '    locked[_beneficiary] = true;\n', '    emit Locked(_beneficiary, _isStraight);\n', '\n', '    //  if all beneficiaries locked, change Locker state to change\n', '    if (numLocks == numBeneficiaries) {\n', '      state = State.Ready;\n', '      emit StateChanged(state);\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @notice transfer releasable tokens for beneficiary wrt the release graph\n', '   */\n', '  function release() external onlyState(State.Active) onlyBeneficiary(msg.sender) {\n', '    require(!beneficiaries[msg.sender].releaseAllTokens);\n', '\n', '    uint releasableAmount = getReleasableAmount(msg.sender);\n', '    beneficiaries[msg.sender].withdrawAmount = beneficiaries[msg.sender].withdrawAmount.add(releasableAmount);\n', '\n', '    beneficiaries[msg.sender].releaseAllTokens = beneficiaries[msg.sender].withdrawAmount == getPartialAmount(\n', '      beneficiaries[msg.sender].ratio,\n', '      coeff,\n', '      initialBalance);\n', '\n', '    withdrawAmount = withdrawAmount.add(releasableAmount);\n', '\n', '    if (withdrawAmount == initialBalance) {\n', '      state = State.Drawn;\n', '      emit StateChanged(state);\n', '    }\n', '\n', '    token.transfer(msg.sender, releasableAmount);\n', '    emit Released(msg.sender, releasableAmount);\n', '  }\n', '\n', '  function getReleasableAmount(address _beneficiary) internal view returns (uint) {\n', '    if (releases[_beneficiary].isStraight) {\n', '      return getStraightReleasableAmount(_beneficiary);\n', '    } else {\n', '      return getVariableReleasableAmount(_beneficiary);\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @notice return releaseable amount for beneficiary in case of straight type of release\n', '   */\n', '  function getStraightReleasableAmount(address _beneficiary) internal view returns (uint releasableAmount) {\n', '    Beneficiary memory _b = beneficiaries[_beneficiary];\n', '    Release memory _r = releases[_beneficiary];\n', '\n', '    // total amount of tokens beneficiary can release\n', '    uint totalReleasableAmount = getTotalLockedAmounts(_beneficiary);\n', '\n', '    uint firstTime = _r.releaseTimes[0];\n', '    uint lastTime = _r.releaseTimes[1];\n', '\n', '    // solium-disable security/no-block-members\n', '    require(now >= firstTime); // pass if can release\n', '    // solium-enable security/no-block-members\n', '\n', '    if(now >= lastTime) { // inclusive to reduce calculation\n', '      releasableAmount = totalReleasableAmount;\n', '    } else {\n', '      // releasable amount at first time\n', '      uint firstAmount = getPartialAmount(\n', '        _r.releaseRatios[0],\n', '        coeff,\n', '        totalReleasableAmount);\n', '\n', '      // partial amount without first amount\n', '      releasableAmount = getPartialAmount(\n', '        now.sub(firstTime),\n', '        lastTime.sub(firstTime),\n', '        totalReleasableAmount.sub(firstAmount));\n', '      releasableAmount = releasableAmount.add(firstAmount);\n', '    }\n', '\n', '    // subtract already withdrawn amounts\n', '    releasableAmount = releasableAmount.sub(_b.withdrawAmount);\n', '  }\n', '\n', '  /**\n', '   * @notice return releaseable amount for beneficiary in case of variable type of release\n', '   */\n', '  function getVariableReleasableAmount(address _beneficiary) internal view returns (uint releasableAmount) {\n', '    Beneficiary memory _b = beneficiaries[_beneficiary];\n', '    Release memory _r = releases[_beneficiary];\n', '\n', '    // total amount of tokens beneficiary will receive\n', '    uint totalReleasableAmount = getTotalLockedAmounts(_beneficiary);\n', '\n', '    uint releaseRatio;\n', '\n', '    // reverse order for short curcit\n', '    for(uint i = _r.releaseTimes.length - 1; i >= 0; i--) {\n', '      if (now >= _r.releaseTimes[i]) {\n', '        releaseRatio = _r.releaseRatios[i];\n', '        break;\n', '      }\n', '    }\n', '\n', '    require(releaseRatio > 0);\n', '\n', '    releasableAmount = getPartialAmount(\n', '      releaseRatio,\n', '      coeff,\n', '      totalReleasableAmount);\n', '    releasableAmount = releasableAmount.sub(_b.withdrawAmount);\n', '  }\n', '\n', '  /// https://github.com/0xProject/0x.js/blob/05aae368132a81ddb9fd6a04ac5b0ff1cbb24691/packages/contracts/src/current/protocol/Exchange/Exchange.sol#L497\n', '  /// @notice Calculates partial value given a numerator and denominator.\n', '  /// @param numerator Numerator.\n', '  /// @param denominator Denominator.\n', '  /// @param target Value to calculate partial of.\n', '  /// @return Partial value of target.\n', '  function getPartialAmount(uint numerator, uint denominator, uint target) public pure returns (uint) {\n', '    return numerator.mul(target).div(denominator);\n', '  }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '  function safeTransfer(ERC20Basic token, address to, uint256 value) internal {\n', '    assert(token.transfer(to, value));\n', '  }\n', '\n', '  function safeTransferFrom(\n', '    ERC20 token,\n', '    address from,\n', '    address to,\n', '    uint256 value\n', '  )\n', '    internal\n', '  {\n', '    assert(token.transferFrom(from, to, value));\n', '  }\n', '\n', '  function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '    assert(token.approve(spender, value));\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Locker\n', ' * @notice Locker holds tokens and releases them at a certain time.\n', ' */\n', 'contract Locker is Ownable {\n', '  using SafeMath for uint;\n', '  using SafeERC20 for ERC20Basic;\n', '\n', '  /**\n', '   * It is init state only when adding release info is possible.\n', '   * beneficiary only can release tokens when Locker is active.\n', '   * After all tokens are released, locker is drawn.\n', '   */\n', '  enum State { Init, Ready, Active, Drawn }\n', '\n', '  struct Beneficiary {\n', "    uint ratio;             // ratio based on Locker's initial balance.\n", '    uint withdrawAmount;    // accumulated tokens beneficiary released\n', '    bool releaseAllTokens;\n', '  }\n', '\n', '  /**\n', '   * @notice Release has info to release tokens.\n', '   * If lock type is straight, only two release infos is required.\n', '   *\n', '   *     |\n', '   * 100 |                _______________\n', '   *     |              _/\n', '   *  50 |            _/\n', '   *     |         . |\n', '   *     |       .   |\n', '   *     |     .     |\n', '   *     +===+=======+----*----------> time\n', '   *     Locker  First    Last\n', '   *  Activated  Release  Release\n', '   *\n', '   *\n', '   * If lock type is variable, the release graph will be\n', '   *\n', '   *     |\n', '   * 100 |                                 _________\n', '   *     |                                |\n', '   *  70 |                      __________|\n', '   *     |                     |\n', '   *  30 |            _________|\n', '   *     |           |\n', '   *     +===+=======+---------+----------*------> time\n', '   *     Locker   First        Second     Last\n', '   *  Activated   Release      Release    Release\n', '   *\n', '   *\n', '   *\n', '   * For the first straight release graph, parameters would be\n', '   *   coeff: 100\n', '   *   releaseTimes: [\n', '   *     first release time,\n', '   *     second release time\n', '   *   ]\n', '   *   releaseRatios: [\n', '   *     50,\n', '   *     100,\n', '   *   ]\n', '   *\n', '   * For the second variable release graph, parameters would be\n', '   *   coeff: 100\n', '   *   releaseTimes: [\n', '   *     first release time,\n', '   *     second release time,\n', '   *     last release time\n', '   *   ]\n', '   *   releaseRatios: [\n', '   *     30,\n', '   *     70,\n', '   *     100,\n', '   *   ]\n', '   *\n', '   */\n', '  struct Release {\n', '    bool isStraight;        // lock type : straight or variable\n', '    uint[] releaseTimes;    //\n', '    uint[] releaseRatios;   //\n', '  }\n', '\n', '  uint public activeTime;\n', '\n', '  // ERC20 basic token contract being held\n', '  ERC20Basic public token;\n', '\n', '  uint public coeff;\n', '  uint public initialBalance;\n', '  uint public withdrawAmount; // total amount of tokens released\n', '\n', '  mapping (address => Beneficiary) public beneficiaries;\n', "  mapping (address => Release) public releases;  // beneficiary's lock\n", "  mapping (address => bool) public locked; // whether beneficiary's lock is instantiated\n", '\n', '  uint public numBeneficiaries;\n', '  uint public numLocks;\n', '\n', '  State public state;\n', '\n', '  modifier onlyState(State v) {\n', '    require(state == v);\n', '    _;\n', '  }\n', '\n', '  modifier onlyBeneficiary(address _addr) {\n', '    require(beneficiaries[_addr].ratio > 0);\n', '    _;\n', '  }\n', '\n', '  event StateChanged(State _state);\n', '  event Locked(address indexed _beneficiary, bool _isStraight);\n', '  event Released(address indexed _beneficiary, uint256 _amount);\n', '\n', '  function Locker(address _token, uint _coeff, address[] _beneficiaries, uint[] _ratios) public {\n', '    require(_token != address(0));\n', '    require(_beneficiaries.length == _ratios.length);\n', '\n', '    token = ERC20Basic(_token);\n', '    coeff = _coeff;\n', '    numBeneficiaries = _beneficiaries.length;\n', '\n', '    uint accRatio;\n', '\n', '    for(uint i = 0; i < numBeneficiaries; i++) {\n', '      require(_ratios[i] > 0);\n', '      beneficiaries[_beneficiaries[i]].ratio = _ratios[i];\n', '\n', '      accRatio = accRatio.add(_ratios[i]);\n', '    }\n', '\n', '    require(coeff == accRatio);\n', '  }\n', '\n', '  /**\n', '   * @notice beneficiary can release their tokens after activated\n', '   */\n', '  function activate() external onlyOwner onlyState(State.Ready) {\n', '    require(numLocks == numBeneficiaries); // double check : assert all releases are recorded\n', '\n', '    initialBalance = token.balanceOf(this);\n', '    require(initialBalance > 0);\n', '\n', '    activeTime = now; // solium-disable-line security/no-block-members\n', '\n', '    // set locker as active state\n', '    state = State.Active;\n', '    emit StateChanged(state);\n', '  }\n', '\n', '  function getReleaseType(address _beneficiary)\n', '    public\n', '    view\n', '    onlyBeneficiary(_beneficiary)\n', '    returns (bool)\n', '  {\n', '    return releases[_beneficiary].isStraight;\n', '  }\n', '\n', '  function getTotalLockedAmounts(address _beneficiary)\n', '    public\n', '    view\n', '    onlyBeneficiary(_beneficiary)\n', '    returns (uint)\n', '  {\n', '    return getPartialAmount(beneficiaries[_beneficiary].ratio, coeff, initialBalance);\n', '  }\n', '\n', '  function getReleaseTimes(address _beneficiary)\n', '    public\n', '    view\n', '    onlyBeneficiary(_beneficiary)\n', '    returns (uint[])\n', '  {\n', '    return releases[_beneficiary].releaseTimes;\n', '  }\n', '\n', '  function getReleaseRatios(address _beneficiary)\n', '    public\n', '    view\n', '    onlyBeneficiary(_beneficiary)\n', '    returns (uint[])\n', '  {\n', '    return releases[_beneficiary].releaseRatios;\n', '  }\n', '\n', '  /**\n', '   * @notice add new release record for beneficiary\n', '   */\n', '  function lock(address _beneficiary, bool _isStraight, uint[] _releaseTimes, uint[] _releaseRatios)\n', '    external\n', '    onlyOwner\n', '    onlyState(State.Init)\n', '    onlyBeneficiary(_beneficiary)\n', '  {\n', '    require(!locked[_beneficiary]);\n', '    require(_releaseRatios.length != 0);\n', '    require(_releaseRatios.length == _releaseTimes.length);\n', '\n', '    uint i;\n', '    uint len = _releaseRatios.length;\n', '\n', '    // finally should release all tokens\n', '    require(_releaseRatios[len - 1] == coeff);\n', '\n', '    // check two array are ascending sorted\n', '    for(i = 0; i < len - 1; i++) {\n', '      require(_releaseTimes[i] < _releaseTimes[i + 1]);\n', '      require(_releaseRatios[i] < _releaseRatios[i + 1]);\n', '    }\n', '\n', '    // 2 release times for straight locking type\n', '    if (_isStraight) {\n', '      require(len == 2);\n', '    }\n', '\n', '    numLocks = numLocks.add(1);\n', '\n', '    // create Release for the beneficiary\n', '    releases[_beneficiary].isStraight = _isStraight;\n', '\n', '    // copy array of uint\n', '    releases[_beneficiary].releaseTimes = _releaseTimes;\n', '    releases[_beneficiary].releaseRatios = _releaseRatios;\n', '\n', '    // lock beneficiary\n', '    locked[_beneficiary] = true;\n', '    emit Locked(_beneficiary, _isStraight);\n', '\n', '    //  if all beneficiaries locked, change Locker state to change\n', '    if (numLocks == numBeneficiaries) {\n', '      state = State.Ready;\n', '      emit StateChanged(state);\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @notice transfer releasable tokens for beneficiary wrt the release graph\n', '   */\n', '  function release() external onlyState(State.Active) onlyBeneficiary(msg.sender) {\n', '    require(!beneficiaries[msg.sender].releaseAllTokens);\n', '\n', '    uint releasableAmount = getReleasableAmount(msg.sender);\n', '    beneficiaries[msg.sender].withdrawAmount = beneficiaries[msg.sender].withdrawAmount.add(releasableAmount);\n', '\n', '    beneficiaries[msg.sender].releaseAllTokens = beneficiaries[msg.sender].withdrawAmount == getPartialAmount(\n', '      beneficiaries[msg.sender].ratio,\n', '      coeff,\n', '      initialBalance);\n', '\n', '    withdrawAmount = withdrawAmount.add(releasableAmount);\n', '\n', '    if (withdrawAmount == initialBalance) {\n', '      state = State.Drawn;\n', '      emit StateChanged(state);\n', '    }\n', '\n', '    token.transfer(msg.sender, releasableAmount);\n', '    emit Released(msg.sender, releasableAmount);\n', '  }\n', '\n', '  function getReleasableAmount(address _beneficiary) internal view returns (uint) {\n', '    if (releases[_beneficiary].isStraight) {\n', '      return getStraightReleasableAmount(_beneficiary);\n', '    } else {\n', '      return getVariableReleasableAmount(_beneficiary);\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @notice return releaseable amount for beneficiary in case of straight type of release\n', '   */\n', '  function getStraightReleasableAmount(address _beneficiary) internal view returns (uint releasableAmount) {\n', '    Beneficiary memory _b = beneficiaries[_beneficiary];\n', '    Release memory _r = releases[_beneficiary];\n', '\n', '    // total amount of tokens beneficiary can release\n', '    uint totalReleasableAmount = getTotalLockedAmounts(_beneficiary);\n', '\n', '    uint firstTime = _r.releaseTimes[0];\n', '    uint lastTime = _r.releaseTimes[1];\n', '\n', '    // solium-disable security/no-block-members\n', '    require(now >= firstTime); // pass if can release\n', '    // solium-enable security/no-block-members\n', '\n', '    if(now >= lastTime) { // inclusive to reduce calculation\n', '      releasableAmount = totalReleasableAmount;\n', '    } else {\n', '      // releasable amount at first time\n', '      uint firstAmount = getPartialAmount(\n', '        _r.releaseRatios[0],\n', '        coeff,\n', '        totalReleasableAmount);\n', '\n', '      // partial amount without first amount\n', '      releasableAmount = getPartialAmount(\n', '        now.sub(firstTime),\n', '        lastTime.sub(firstTime),\n', '        totalReleasableAmount.sub(firstAmount));\n', '      releasableAmount = releasableAmount.add(firstAmount);\n', '    }\n', '\n', '    // subtract already withdrawn amounts\n', '    releasableAmount = releasableAmount.sub(_b.withdrawAmount);\n', '  }\n', '\n', '  /**\n', '   * @notice return releaseable amount for beneficiary in case of variable type of release\n', '   */\n', '  function getVariableReleasableAmount(address _beneficiary) internal view returns (uint releasableAmount) {\n', '    Beneficiary memory _b = beneficiaries[_beneficiary];\n', '    Release memory _r = releases[_beneficiary];\n', '\n', '    // total amount of tokens beneficiary will receive\n', '    uint totalReleasableAmount = getTotalLockedAmounts(_beneficiary);\n', '\n', '    uint releaseRatio;\n', '\n', '    // reverse order for short curcit\n', '    for(uint i = _r.releaseTimes.length - 1; i >= 0; i--) {\n', '      if (now >= _r.releaseTimes[i]) {\n', '        releaseRatio = _r.releaseRatios[i];\n', '        break;\n', '      }\n', '    }\n', '\n', '    require(releaseRatio > 0);\n', '\n', '    releasableAmount = getPartialAmount(\n', '      releaseRatio,\n', '      coeff,\n', '      totalReleasableAmount);\n', '    releasableAmount = releasableAmount.sub(_b.withdrawAmount);\n', '  }\n', '\n', '  /// https://github.com/0xProject/0x.js/blob/05aae368132a81ddb9fd6a04ac5b0ff1cbb24691/packages/contracts/src/current/protocol/Exchange/Exchange.sol#L497\n', '  /// @notice Calculates partial value given a numerator and denominator.\n', '  /// @param numerator Numerator.\n', '  /// @param denominator Denominator.\n', '  /// @param target Value to calculate partial of.\n', '  /// @return Partial value of target.\n', '  function getPartialAmount(uint numerator, uint denominator, uint target) public pure returns (uint) {\n', '    return numerator.mul(target).div(denominator);\n', '  }\n', '}']
