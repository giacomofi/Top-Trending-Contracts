['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath\n', '{\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', "    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (_a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = _a * _b;\n', '    assert(c / _a == _b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    // assert(_b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = _a / _b;\n', "    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold\n", '    return _a / _b;\n', '  }\n', '\n', '  /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '   * @dev Adds two numbers, throws on overflow.\n', '   */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable\n', '{\n', '  address public owner;\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic\n', '{\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public;\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic\n', '{\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '  function safeTransfer(\n', '    ERC20 _token,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    internal\n', '  {\n', '    _token.transfer(_to, _value);\n', '  }\n', '\n', '  function safeTransferFrom(\n', '    ERC20 _token,\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    internal\n', '  {\n', '    require(_token.transferFrom(_from, _to, _value));\n', '  }\n', '\n', '  function safeApprove(\n', '    ERC20 _token,\n', '    address _spender,\n', '    uint256 _value\n', '  )\n', '    internal\n', '  {\n', '    require(_token.approve(_spender, _value));\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title TokenVesting\n', ' * @dev A token holder contract that can release its token balance gradually like a\n', ' * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the\n', ' * owner.\n', ' */\n', 'contract TokenVesting is Ownable {\n', '  using SafeMath for uint256;\n', '  using SafeERC20 for ERC20;\n', '\n', '  event Released(uint256 amount);\n', '  event Revoked();\n', '\n', '  // beneficiary of tokens after they are released\n', '  address public beneficiary;\n', '\n', '  uint256 public cliff;\n', '  uint256 public start;\n', '  uint256 public duration;\n', '\n', '  bool public revocable;\n', '\n', '  mapping (address => uint256) public released;\n', '  mapping (address => bool) public revoked;\n', '\n', '  /**\n', '   * @dev Creates a vesting contract that vests its balance of any ERC20 token to the\n', '   * _beneficiary, gradually in a linear fashion until _start + _duration. By then all\n', '   * of the balance will have vested.\n', '   * @param _beneficiary address of the beneficiary to whom vested tokens are transferred\n', '   * @param _cliff duration in seconds of the cliff in which tokens will begin to vest\n', '   * @param _start the time (as Unix time) at which point vesting starts\n', '   * @param _duration duration in seconds of the period in which the tokens will vest\n', '   * @param _revocable whether the vesting is revocable or not\n', '   */\n', '  constructor(\n', '    address _beneficiary,\n', '    uint256 _start,\n', '    uint256 _cliff,\n', '    uint256 _duration,\n', '    bool _revocable\n', '  )\n', '    public\n', '  {\n', '    require(_beneficiary != address(0));\n', '    require(_cliff <= _duration);\n', '\n', '    beneficiary = _beneficiary;\n', '    revocable = _revocable;\n', '    duration = _duration;\n', '    cliff = _start.add(_cliff);\n', '    start = _start;\n', '  }\n', '\n', '  /**\n', '   * @notice Transfers vested tokens to beneficiary.\n', '   * @param _token ERC20 token which is being vested\n', '   */\n', '  function release(ERC20 _token) public {\n', '    uint256 unreleased = releasableAmount(_token);\n', '\n', '    require(unreleased > 0);\n', '\n', '    released[_token] = unreleased.add(released[_token]);\n', '\n', '    _token.safeTransfer(beneficiary, unreleased);\n', '\n', '    emit Released(unreleased);\n', '  }\n', '\n', '  /**\n', '   * @notice Allows the owner to revoke the vesting. Tokens already vested\n', '   * remain in the contract, the rest are returned to the owner.\n', '   * @param _token ERC20 token which is being vested\n', '   */\n', '  function revoke(ERC20 _token) public onlyOwner {\n', '    require(revocable);\n', '    require(!revoked[_token]);\n', '\n', '    uint256 balance = _token.balanceOf(address(this));\n', '\n', '    uint256 unreleased = releasableAmount(_token);\n', '    uint256 refund = balance.sub(unreleased);\n', '\n', '    revoked[_token] = true;\n', '\n', '    _token.safeTransfer(owner, refund);\n', '\n', '    emit Revoked();\n', '  }\n', '\n', '  /**\n', "   * @dev Calculates the amount that has already vested but hasn't been released yet.\n", '   * @param _token ERC20 token which is being vested\n', '   */\n', '  function releasableAmount(ERC20 _token) public view returns (uint256) {\n', '    return vestedAmount(_token).sub(released[_token]);\n', '  }\n', '\n', '  /**\n', '   * @dev Calculates the amount that has already vested.\n', '   * @param _token ERC20 token which is being vested\n', '   */\n', '  function vestedAmount(ERC20 _token) public view returns (uint256) {\n', '    uint256 currentBalance = _token.balanceOf(this);\n', '    uint256 totalBalance = currentBalance.add(released[_token]);\n', '\n', '    if (block.timestamp < cliff) {\n', '      return 0;\n', '    } else if (block.timestamp >= start.add(duration) || revoked[_token]) {\n', '      return totalBalance;\n', '    } else {\n', '      return totalBalance.mul(block.timestamp.sub(start)).div(duration);\n', '    }\n', '  }\n', '}']