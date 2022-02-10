['pragma solidity ^0.4.13;\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeERC20 {\n', '  function safeTransfer(ERC20Basic token, address to, uint256 value) internal {\n', '    assert(token.transfer(to, value));\n', '  }\n', '\n', '  function safeTransferFrom(\n', '    ERC20 token,\n', '    address from,\n', '    address to,\n', '    uint256 value\n', '  )\n', '    internal\n', '  {\n', '    assert(token.transferFrom(from, to, value));\n', '  }\n', '\n', '  function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '    assert(token.approve(spender, value));\n', '  }\n', '}\n', '\n', 'contract TokenVesting is Ownable {\n', '  using SafeMath for uint256;\n', '  using SafeERC20 for ERC20Basic;\n', '\n', '  event Released(uint256 amount);\n', '  event Revoked();\n', '\n', '  // beneficiary of tokens after they are released\n', '  address public beneficiary;\n', '\n', '  uint256 public cliff;\n', '  uint256 public start;\n', '  uint256 public duration;\n', '\n', '  bool public revocable;\n', '\n', '  mapping (address => uint256) public released;\n', '  mapping (address => bool) public revoked;\n', '\n', '  /**\n', '   * @dev Creates a vesting contract that vests its balance of any ERC20 token to the\n', '   * _beneficiary, gradually in a linear fashion until _start + _duration. By then all\n', '   * of the balance will have vested.\n', '   * @param _beneficiary address of the beneficiary to whom vested tokens are transferred\n', '   * @param _cliff duration in seconds of the cliff in which tokens will begin to vest\n', '   * @param _duration duration in seconds of the period in which the tokens will vest\n', '   * @param _revocable whether the vesting is revocable or not\n', '   */\n', '  function TokenVesting(\n', '    address _beneficiary,\n', '    uint256 _start,\n', '    uint256 _cliff,\n', '    uint256 _duration,\n', '    bool _revocable\n', '  )\n', '    public\n', '  {\n', '    require(_beneficiary != address(0));\n', '    require(_cliff <= _duration);\n', '\n', '    beneficiary = _beneficiary;\n', '    revocable = _revocable;\n', '    duration = _duration;\n', '    cliff = _start.add(_cliff);\n', '    start = _start;\n', '  }\n', '\n', '  /**\n', '   * @notice Transfers vested tokens to beneficiary.\n', '   * @param token ERC20 token which is being vested\n', '   */\n', '  function release(ERC20Basic token) public {\n', '    uint256 unreleased = releasableAmount(token);\n', '\n', '    require(unreleased > 0);\n', '\n', '    released[token] = released[token].add(unreleased);\n', '\n', '    token.safeTransfer(beneficiary, unreleased);\n', '\n', '    emit Released(unreleased);\n', '  }\n', '\n', '  /**\n', '   * @notice Allows the owner to revoke the vesting. Tokens already vested\n', '   * remain in the contract, the rest are returned to the owner.\n', '   * @param token ERC20 token which is being vested\n', '   */\n', '  function revoke(ERC20Basic token) public onlyOwner {\n', '    require(revocable);\n', '    require(!revoked[token]);\n', '\n', '    uint256 balance = token.balanceOf(this);\n', '\n', '    uint256 unreleased = releasableAmount(token);\n', '    uint256 refund = balance.sub(unreleased);\n', '\n', '    revoked[token] = true;\n', '\n', '    token.safeTransfer(owner, refund);\n', '\n', '    emit Revoked();\n', '  }\n', '\n', '  /**\n', '   * @dev Calculates the amount that has already vested but hasn&#39;t been released yet.\n', '   * @param token ERC20 token which is being vested\n', '   */\n', '  function releasableAmount(ERC20Basic token) public view returns (uint256) {\n', '    return vestedAmount(token).sub(released[token]);\n', '  }\n', '\n', '  /**\n', '   * @dev Calculates the amount that has already vested.\n', '   * @param token ERC20 token which is being vested\n', '   */\n', '  function vestedAmount(ERC20Basic token) public view returns (uint256) {\n', '    uint256 currentBalance = token.balanceOf(this);\n', '    uint256 totalBalance = currentBalance.add(released[token]);\n', '\n', '    if (block.timestamp < cliff) {\n', '      return 0;\n', '    } else if (block.timestamp >= start.add(duration) || revoked[token]) {\n', '      return totalBalance;\n', '    } else {\n', '      return totalBalance.mul(block.timestamp.sub(start)).div(duration);\n', '    }\n', '  }\n', '}\n', '\n', 'contract VariableRateTokenVesting is TokenVesting {\n', '\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for ERC20Basic;\n', '\n', '    // Every element between 0 and 100, and should increase monotonically.\n', '    // [10, 20, 30, ..., 100] means releasing 10% for each period.\n', '    uint256[] public cumulativeRates;\n', '\n', '    // Seconds between each period.\n', '    uint256 public interval;\n', '\n', '    constructor(\n', '        address _beneficiary,\n', '        uint256 _start,\n', '        uint256[] _cumulativeRates,\n', '        uint256 _interval\n', '    ) public\n', '        // We don&#39;t need `duration`, also always allow revoking.\n', '        TokenVesting(_beneficiary, _start, /*cliff*/0, /*duration: uint max*/~uint256(0), true)\n', '    {\n', '        // Validate rates.\n', '        for (uint256 i = 0; i < _cumulativeRates.length; ++i) {\n', '            require(_cumulativeRates[i] <= 100);\n', '            if (i > 0) {\n', '                require(_cumulativeRates[i] >= _cumulativeRates[i - 1]);\n', '            }\n', '        }\n', '\n', '        cumulativeRates = _cumulativeRates;\n', '        interval = _interval;\n', '        // Hardcode owner.\n', '        owner = 0x0298CF0d5B60a0aD885518adCB4c3fc49b36D347;\n', '    }\n', '\n', '    /// @dev Override to use cumulative rates to calculated amount for vesting.\n', '    function vestedAmount(ERC20Basic token) public view returns (uint256) {\n', '        if (now < start) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 currentBalance = token.balanceOf(this);\n', '        uint256 totalBalance = currentBalance.add(released[token]);\n', '\n', '        uint256 timeSinceStart = now.sub(start);\n', '        uint256 currentPeriod = timeSinceStart.div(interval);\n', '        if (currentPeriod >= cumulativeRates.length) {\n', '            return totalBalance;\n', '        }\n', '        return totalBalance.mul(cumulativeRates[currentPeriod]).div(100);\n', '    }\n', '}\n', '\n', 'contract BatchReleaser {\n', '    \n', '    function batchRelease(address[] vestingContracts, ERC20Basic token) external {\n', '        for (uint256 i = 0; i < vestingContracts.length; i++) {\n', '            VariableRateTokenVesting vesting = VariableRateTokenVesting(vestingContracts[i]);\n', '            vesting.release(token);\n', '        }\n', '    }\n', '    \n', '}']
['pragma solidity ^0.4.13;\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeERC20 {\n', '  function safeTransfer(ERC20Basic token, address to, uint256 value) internal {\n', '    assert(token.transfer(to, value));\n', '  }\n', '\n', '  function safeTransferFrom(\n', '    ERC20 token,\n', '    address from,\n', '    address to,\n', '    uint256 value\n', '  )\n', '    internal\n', '  {\n', '    assert(token.transferFrom(from, to, value));\n', '  }\n', '\n', '  function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '    assert(token.approve(spender, value));\n', '  }\n', '}\n', '\n', 'contract TokenVesting is Ownable {\n', '  using SafeMath for uint256;\n', '  using SafeERC20 for ERC20Basic;\n', '\n', '  event Released(uint256 amount);\n', '  event Revoked();\n', '\n', '  // beneficiary of tokens after they are released\n', '  address public beneficiary;\n', '\n', '  uint256 public cliff;\n', '  uint256 public start;\n', '  uint256 public duration;\n', '\n', '  bool public revocable;\n', '\n', '  mapping (address => uint256) public released;\n', '  mapping (address => bool) public revoked;\n', '\n', '  /**\n', '   * @dev Creates a vesting contract that vests its balance of any ERC20 token to the\n', '   * _beneficiary, gradually in a linear fashion until _start + _duration. By then all\n', '   * of the balance will have vested.\n', '   * @param _beneficiary address of the beneficiary to whom vested tokens are transferred\n', '   * @param _cliff duration in seconds of the cliff in which tokens will begin to vest\n', '   * @param _duration duration in seconds of the period in which the tokens will vest\n', '   * @param _revocable whether the vesting is revocable or not\n', '   */\n', '  function TokenVesting(\n', '    address _beneficiary,\n', '    uint256 _start,\n', '    uint256 _cliff,\n', '    uint256 _duration,\n', '    bool _revocable\n', '  )\n', '    public\n', '  {\n', '    require(_beneficiary != address(0));\n', '    require(_cliff <= _duration);\n', '\n', '    beneficiary = _beneficiary;\n', '    revocable = _revocable;\n', '    duration = _duration;\n', '    cliff = _start.add(_cliff);\n', '    start = _start;\n', '  }\n', '\n', '  /**\n', '   * @notice Transfers vested tokens to beneficiary.\n', '   * @param token ERC20 token which is being vested\n', '   */\n', '  function release(ERC20Basic token) public {\n', '    uint256 unreleased = releasableAmount(token);\n', '\n', '    require(unreleased > 0);\n', '\n', '    released[token] = released[token].add(unreleased);\n', '\n', '    token.safeTransfer(beneficiary, unreleased);\n', '\n', '    emit Released(unreleased);\n', '  }\n', '\n', '  /**\n', '   * @notice Allows the owner to revoke the vesting. Tokens already vested\n', '   * remain in the contract, the rest are returned to the owner.\n', '   * @param token ERC20 token which is being vested\n', '   */\n', '  function revoke(ERC20Basic token) public onlyOwner {\n', '    require(revocable);\n', '    require(!revoked[token]);\n', '\n', '    uint256 balance = token.balanceOf(this);\n', '\n', '    uint256 unreleased = releasableAmount(token);\n', '    uint256 refund = balance.sub(unreleased);\n', '\n', '    revoked[token] = true;\n', '\n', '    token.safeTransfer(owner, refund);\n', '\n', '    emit Revoked();\n', '  }\n', '\n', '  /**\n', "   * @dev Calculates the amount that has already vested but hasn't been released yet.\n", '   * @param token ERC20 token which is being vested\n', '   */\n', '  function releasableAmount(ERC20Basic token) public view returns (uint256) {\n', '    return vestedAmount(token).sub(released[token]);\n', '  }\n', '\n', '  /**\n', '   * @dev Calculates the amount that has already vested.\n', '   * @param token ERC20 token which is being vested\n', '   */\n', '  function vestedAmount(ERC20Basic token) public view returns (uint256) {\n', '    uint256 currentBalance = token.balanceOf(this);\n', '    uint256 totalBalance = currentBalance.add(released[token]);\n', '\n', '    if (block.timestamp < cliff) {\n', '      return 0;\n', '    } else if (block.timestamp >= start.add(duration) || revoked[token]) {\n', '      return totalBalance;\n', '    } else {\n', '      return totalBalance.mul(block.timestamp.sub(start)).div(duration);\n', '    }\n', '  }\n', '}\n', '\n', 'contract VariableRateTokenVesting is TokenVesting {\n', '\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for ERC20Basic;\n', '\n', '    // Every element between 0 and 100, and should increase monotonically.\n', '    // [10, 20, 30, ..., 100] means releasing 10% for each period.\n', '    uint256[] public cumulativeRates;\n', '\n', '    // Seconds between each period.\n', '    uint256 public interval;\n', '\n', '    constructor(\n', '        address _beneficiary,\n', '        uint256 _start,\n', '        uint256[] _cumulativeRates,\n', '        uint256 _interval\n', '    ) public\n', "        // We don't need `duration`, also always allow revoking.\n", '        TokenVesting(_beneficiary, _start, /*cliff*/0, /*duration: uint max*/~uint256(0), true)\n', '    {\n', '        // Validate rates.\n', '        for (uint256 i = 0; i < _cumulativeRates.length; ++i) {\n', '            require(_cumulativeRates[i] <= 100);\n', '            if (i > 0) {\n', '                require(_cumulativeRates[i] >= _cumulativeRates[i - 1]);\n', '            }\n', '        }\n', '\n', '        cumulativeRates = _cumulativeRates;\n', '        interval = _interval;\n', '        // Hardcode owner.\n', '        owner = 0x0298CF0d5B60a0aD885518adCB4c3fc49b36D347;\n', '    }\n', '\n', '    /// @dev Override to use cumulative rates to calculated amount for vesting.\n', '    function vestedAmount(ERC20Basic token) public view returns (uint256) {\n', '        if (now < start) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 currentBalance = token.balanceOf(this);\n', '        uint256 totalBalance = currentBalance.add(released[token]);\n', '\n', '        uint256 timeSinceStart = now.sub(start);\n', '        uint256 currentPeriod = timeSinceStart.div(interval);\n', '        if (currentPeriod >= cumulativeRates.length) {\n', '            return totalBalance;\n', '        }\n', '        return totalBalance.mul(cumulativeRates[currentPeriod]).div(100);\n', '    }\n', '}\n', '\n', 'contract BatchReleaser {\n', '    \n', '    function batchRelease(address[] vestingContracts, ERC20Basic token) external {\n', '        for (uint256 i = 0; i < vestingContracts.length; i++) {\n', '            VariableRateTokenVesting vesting = VariableRateTokenVesting(vestingContracts[i]);\n', '            vesting.release(token);\n', '        }\n', '    }\n', '    \n', '}']
