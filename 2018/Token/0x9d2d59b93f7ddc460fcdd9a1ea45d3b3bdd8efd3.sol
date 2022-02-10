['pragma solidity ^0.4.18;\n', '\n', '// File: zeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '  function safeTransfer(ERC20Basic token, address to, uint256 value) internal {\n', '    assert(token.transfer(to, value));\n', '  }\n', '\n', '  function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {\n', '    assert(token.transferFrom(from, to, value));\n', '  }\n', '\n', '  function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '    assert(token.approve(spender, value));\n', '  }\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20/TokenVesting.sol\n', '\n', '/**\n', ' * @title TokenVesting\n', ' * @dev A token holder contract that can release its token balance gradually like a\n', ' * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the\n', ' * owner.\n', ' */\n', 'contract TokenVesting is Ownable {\n', '  using SafeMath for uint256;\n', '  using SafeERC20 for ERC20Basic;\n', '\n', '  event Released(uint256 amount);\n', '  event Revoked();\n', '\n', '  // beneficiary of tokens after they are released\n', '  address public beneficiary;\n', '\n', '  uint256 public cliff;\n', '  uint256 public start;\n', '  uint256 public duration;\n', '\n', '  bool public revocable;\n', '\n', '  mapping (address => uint256) public released;\n', '  mapping (address => bool) public revoked;\n', '\n', '  /**\n', '   * @dev Creates a vesting contract that vests its balance of any ERC20 token to the\n', '   * _beneficiary, gradually in a linear fashion until _start + _duration. By then all\n', '   * of the balance will have vested.\n', '   * @param _beneficiary address of the beneficiary to whom vested tokens are transferred\n', '   * @param _cliff duration in seconds of the cliff in which tokens will begin to vest\n', '   * @param _duration duration in seconds of the period in which the tokens will vest\n', '   * @param _revocable whether the vesting is revocable or not\n', '   */\n', '  function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {\n', '    require(_beneficiary != address(0));\n', '    require(_cliff <= _duration);\n', '\n', '    beneficiary = _beneficiary;\n', '    revocable = _revocable;\n', '    duration = _duration;\n', '    cliff = _start.add(_cliff);\n', '    start = _start;\n', '  }\n', '\n', '  /**\n', '   * @notice Transfers vested tokens to beneficiary.\n', '   * @param token ERC20 token which is being vested\n', '   */\n', '  function release(ERC20Basic token) public {\n', '    uint256 unreleased = releasableAmount(token);\n', '\n', '    require(unreleased > 0);\n', '\n', '    released[token] = released[token].add(unreleased);\n', '\n', '    token.safeTransfer(beneficiary, unreleased);\n', '\n', '    Released(unreleased);\n', '  }\n', '\n', '  /**\n', '   * @notice Allows the owner to revoke the vesting. Tokens already vested\n', '   * remain in the contract, the rest are returned to the owner.\n', '   * @param token ERC20 token which is being vested\n', '   */\n', '  function revoke(ERC20Basic token) public onlyOwner {\n', '    require(revocable);\n', '    require(!revoked[token]);\n', '\n', '    uint256 balance = token.balanceOf(this);\n', '\n', '    uint256 unreleased = releasableAmount(token);\n', '    uint256 refund = balance.sub(unreleased);\n', '\n', '    revoked[token] = true;\n', '\n', '    token.safeTransfer(owner, refund);\n', '\n', '    Revoked();\n', '  }\n', '\n', '  /**\n', '   * @dev Calculates the amount that has already vested but hasn&#39;t been released yet.\n', '   * @param token ERC20 token which is being vested\n', '   */\n', '  function releasableAmount(ERC20Basic token) public view returns (uint256) {\n', '    return vestedAmount(token).sub(released[token]);\n', '  }\n', '\n', '  /**\n', '   * @dev Calculates the amount that has already vested.\n', '   * @param token ERC20 token which is being vested\n', '   */\n', '  function vestedAmount(ERC20Basic token) public view returns (uint256) {\n', '    uint256 currentBalance = token.balanceOf(this);\n', '    uint256 totalBalance = currentBalance.add(released[token]);\n', '\n', '    if (now < cliff) {\n', '      return 0;\n', '    } else if (now >= start.add(duration) || revoked[token]) {\n', '      return totalBalance;\n', '    } else {\n', '      return totalBalance.mul(now.sub(start)).div(duration);\n', '    }\n', '  }\n', '}\n', '\n', '// File: contracts/LiteXTokenVesting.sol\n', '\n', '/**\n', '* token will released by divider like this:\n', '*\n', '* if divider is one month, _cliff is zero, _duration is one year, total vesting token is 12000\n', '*   Jan 30th will not release any token\n', '*   Jan 31st will release 1000\n', '*   Feb 1 will not release any token\n', '*   Feb 28th will release 1000\n', '*   ………………\n', '*   ………………\n', '*   Dec 31st will release 1000\n', '*/\n', 'contract LiteXTokenVesting is TokenVesting {\n', '\n', '  uint256 public divider;\n', '\n', '  function LiteXTokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, uint256 _divider, bool _revocable) TokenVesting(_beneficiary, _start, _cliff, _duration, _revocable) public   {\n', '    require(_beneficiary != address(0));\n', '    require(_cliff <= _duration);\n', '    require(_divider <= duration);\n', '    divider = _divider;\n', '  }\n', '\n', '  /**\n', '  * @dev Calculates the amount that has already vested.\n', '  * @param token ERC20 token which is being vested\n', '  */\n', '  function vestedAmount(ERC20Basic token) public view returns (uint256) {\n', '    uint256 currentBalance = token.balanceOf(this);\n', '    uint256 totalBalance = currentBalance.add(released[token]);\n', '\n', '    if (now < cliff) {\n', '      return 0;\n', '    }\n', '\n', '    if (now >= start.add(duration) || revoked[token]) {\n', '      return totalBalance;\n', '    }\n', '    return totalBalance.mul(now.sub(start).div(divider).mul(divider)).div(duration);\n', '  }\n', '\n', '}']