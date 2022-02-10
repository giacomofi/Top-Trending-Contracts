['pragma solidity ^0.4.13;\n', '\n', 'library Math {\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '}\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeERC20 {\n', '  function safeTransfer(ERC20Basic token, address to, uint256 value) internal {\n', '    assert(token.transfer(to, value));\n', '  }\n', '\n', '  function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {\n', '    assert(token.transferFrom(from, to, value));\n', '  }\n', '\n', '  function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '    assert(token.approve(spender, value));\n', '  }\n', '}\n', '\n', 'contract ReturnVestingRegistry is Ownable {\n', '\n', '  mapping (address => address) public returnAddress;\n', '\n', '  function record(address from, address to) onlyOwner public {\n', '    require(from != 0);\n', '\n', '    returnAddress[from] = to;\n', '  }\n', '}\n', '\n', 'contract TerraformReserve is Ownable {\n', '\n', '  /* Storing a balance for each user */\n', '  mapping (address => uint256) public lockedBalance;\n', '\n', '  /* Store the total sum locked */\n', '  uint public totalLocked;\n', '\n', '  /* Reference to the token */\n', '  ERC20 public manaToken;\n', '\n', '  /* Contract that will assign the LAND and burn/return tokens */\n', '  address public landClaim;\n', '\n', '  /* Prevent the token from accepting deposits */\n', '  bool public acceptingDeposits;\n', '\n', '  event LockedBalance(address user, uint mana);\n', '  event LandClaimContractSet(address target);\n', '  event LandClaimExecuted(address user, uint value, bytes data);\n', '  event AcceptingDepositsChanged(bool _acceptingDeposits);\n', '\n', '  function TerraformReserve(address _token) {\n', '    require(_token != 0);\n', '    manaToken = ERC20(_token);\n', '    acceptingDeposits = true;\n', '  }\n', '\n', '  /**\n', '   * Lock MANA into the contract.\n', '   * This contract does not have another way to take the tokens out other than\n', '   * through the target contract.\n', '   */\n', '  function lockMana(address _from, uint256 mana) public {\n', '    require(acceptingDeposits);\n', '    require(mana >= 1000 * 1e18);\n', '    require(manaToken.transferFrom(_from, this, mana));\n', '\n', '    lockedBalance[_from] += mana;\n', '    totalLocked += mana;\n', '    LockedBalance(_from, mana);\n', '  }\n', '\n', '  /**\n', '   * Allows the owner of the contract to pause acceptingDeposits\n', '   */\n', '  function changeContractState(bool _acceptingDeposits) public onlyOwner {\n', '    acceptingDeposits = _acceptingDeposits;\n', '    AcceptingDepositsChanged(acceptingDeposits);\n', '  }\n', '\n', '  /**\n', '   * Set the contract that can move the staked MANA.\n', '   * Calls the `approve` function of the ERC20 token with the total amount.\n', '   */\n', '  function setTargetContract(address target) public onlyOwner {\n', '    landClaim = target;\n', '    manaToken.approve(landClaim, totalLocked);\n', '    LandClaimContractSet(target);\n', '  }\n', '\n', '  /**\n', '   * Prevent payments to the contract\n', '   */\n', '  function () public payable {\n', '    revert();\n', '  }\n', '}\n', '\n', 'contract TokenVesting is Ownable {\n', '  using SafeMath for uint256;\n', '  using SafeERC20 for ERC20;\n', '\n', '  event Released(uint256 amount);\n', '  event Revoked();\n', '\n', '  // beneficiary of tokens after they are released\n', '  address public beneficiary;\n', '\n', '  uint256 public cliff;\n', '  uint256 public start;\n', '  uint256 public duration;\n', '\n', '  bool public revocable;\n', '  bool public revoked;\n', '\n', '  uint256 public released;\n', '\n', '  ERC20 public token;\n', '\n', '  /**\n', '   * @dev Creates a vesting contract that vests its balance of any ERC20 token to the\n', '   * _beneficiary, gradually in a linear fashion until _start + _duration. By then all\n', '   * of the balance will have vested.\n', '   * @param _beneficiary address of the beneficiary to whom vested tokens are transferred\n', '   * @param _cliff duration in seconds of the cliff in which tokens will begin to vest\n', '   * @param _duration duration in seconds of the period in which the tokens will vest\n', '   * @param _revocable whether the vesting is revocable or not\n', '   * @param _token address of the ERC20 token contract\n', '   */\n', '  function TokenVesting(\n', '    address _beneficiary,\n', '    uint256 _start,\n', '    uint256 _cliff,\n', '    uint256 _duration,\n', '    bool    _revocable,\n', '    address _token\n', '  ) {\n', '    require(_beneficiary != 0x0);\n', '    require(_cliff <= _duration);\n', '\n', '    beneficiary = _beneficiary;\n', '    start       = _start;\n', '    cliff       = _start.add(_cliff);\n', '    duration    = _duration;\n', '    revocable   = _revocable;\n', '    token       = ERC20(_token);\n', '  }\n', '\n', '  /**\n', '   * @notice Only allow calls from the beneficiary of the vesting contract\n', '   */\n', '  modifier onlyBeneficiary() {\n', '    require(msg.sender == beneficiary);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @notice Allow the beneficiary to change its address\n', '   * @param target the address to transfer the right to\n', '   */\n', '  function changeBeneficiary(address target) onlyBeneficiary public {\n', '    require(target != 0);\n', '    beneficiary = target;\n', '  }\n', '\n', '  /**\n', '   * @notice Transfers vested tokens to beneficiary.\n', '   */\n', '  function release() onlyBeneficiary public {\n', '    require(now >= cliff);\n', '    _releaseTo(beneficiary);\n', '  }\n', '\n', '  /**\n', '   * @notice Transfers vested tokens to a target address.\n', '   * @param target the address to send the tokens to\n', '   */\n', '  function releaseTo(address target) onlyBeneficiary public {\n', '    require(now >= cliff);\n', '    _releaseTo(target);\n', '  }\n', '\n', '  /**\n', '   * @notice Transfers vested tokens to beneficiary.\n', '   */\n', '  function _releaseTo(address target) internal {\n', '    uint256 unreleased = releasableAmount();\n', '\n', '    released = released.add(unreleased);\n', '\n', '    token.safeTransfer(target, unreleased);\n', '\n', '    Released(released);\n', '  }\n', '\n', '  /**\n', '   * @notice Allows the owner to revoke the vesting. Tokens already vested are sent to the beneficiary.\n', '   */\n', '  function revoke() onlyOwner public {\n', '    require(revocable);\n', '    require(!revoked);\n', '\n', '    // Release all vested tokens\n', '    _releaseTo(beneficiary);\n', '\n', '    // Send the remainder to the owner\n', '    token.safeTransfer(owner, token.balanceOf(this));\n', '\n', '    revoked = true;\n', '\n', '    Revoked();\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Calculates the amount that has already vested but hasn&#39;t been released yet.\n', '   */\n', '  function releasableAmount() public constant returns (uint256) {\n', '    return vestedAmount().sub(released);\n', '  }\n', '\n', '  /**\n', '   * @dev Calculates the amount that has already vested.\n', '   */\n', '  function vestedAmount() public constant returns (uint256) {\n', '    uint256 currentBalance = token.balanceOf(this);\n', '    uint256 totalBalance = currentBalance.add(released);\n', '\n', '    if (now < cliff) {\n', '      return 0;\n', '    } else if (now >= start.add(duration) || revoked) {\n', '      return totalBalance;\n', '    } else {\n', '      return totalBalance.mul(now.sub(start)).div(duration);\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @notice Allow withdrawing any token other than the relevant one\n', '   */\n', '  function releaseForeignToken(ERC20 _token, uint256 amount) onlyOwner {\n', '    require(_token != token);\n', '    _token.transfer(owner, amount);\n', '  }\n', '}']