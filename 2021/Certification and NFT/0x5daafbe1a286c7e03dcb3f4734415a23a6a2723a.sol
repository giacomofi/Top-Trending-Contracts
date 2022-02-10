['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-09\n', '*/\n', '\n', '// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v1.12.0/contracts/math/SafeMath.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', "    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (_a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = _a * _b;\n', '    assert(c / _a == _b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    // assert(_b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = _a / _b;\n', "    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold\n", '    return _a / _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    assert(_b <= _a);\n', '    return _a - _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    c = _a + _b;\n', '    assert(c >= _a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v1.12.0/contracts/token/ERC20/ERC20Basic.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * See https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address _who) public view returns (uint256);\n', '  function transfer(address _to, uint256 _value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v1.12.0/contracts/token/ERC20/ERC20.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address _owner, address _spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value)\n', '    public returns (bool);\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v1.12.0/contracts/token/ERC20/SafeERC20.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '  function safeTransfer(\n', '    ERC20Basic _token,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    internal\n', '  {\n', '    require(_token.transfer(_to, _value));\n', '  }\n', '\n', '  function safeTransferFrom(\n', '    ERC20 _token,\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    internal\n', '  {\n', '    require(_token.transferFrom(_from, _to, _value));\n', '  }\n', '\n', '  function safeApprove(\n', '    ERC20 _token,\n', '    address _spender,\n', '    uint256 _value\n', '  )\n', '    internal\n', '  {\n', '    require(_token.approve(_spender, _value));\n', '  }\n', '}\n', '\n', '\n', '// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v1.12.0/contracts/ownership/Ownable.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '\n', '// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v1.12.0/contracts/token/ERC20/TokenVesting.sol\n', '\n', '/* solium-disable security/no-block-members */\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title TokenVesting\n', ' * @dev A token holder contract that can release its token balance gradually like a\n', ' * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the\n', ' * owner.\n', ' */\n', 'contract TokenVesting is Ownable {\n', '  using SafeMath for uint256;\n', '  using SafeERC20 for ERC20Basic;\n', '\n', '  event Released(uint256 amount);\n', '  event Revoked();\n', '\n', '  // beneficiary of tokens after they are released\n', '  address public beneficiary;\n', '\n', '  uint256 public cliff;\n', '  uint256 public start;\n', '  uint256 public duration;\n', '\n', '  bool public revocable;\n', '\n', '  mapping (address => uint256) public released;\n', '  mapping (address => bool) public revoked;\n', '\n', '  /**\n', '   * @dev Creates a vesting contract that vests its balance of any ERC20 token to the\n', '   * _beneficiary, gradually in a linear fashion until _start + _duration. By then all\n', '   * of the balance will have vested.\n', '   * @param _beneficiary address of the beneficiary to whom vested tokens are transferred\n', '   * @param _cliff duration in seconds of the cliff in which tokens will begin to vest\n', '   * @param _start the time (as Unix time) at which point vesting starts\n', '   * @param _duration duration in seconds of the period in which the tokens will vest\n', '   * @param _revocable whether the vesting is revocable or not\n', '   */\n', '  constructor(\n', '    address _beneficiary,\n', '    uint256 _start,\n', '    uint256 _cliff,\n', '    uint256 _duration,\n', '    bool _revocable\n', '  )\n', '    public\n', '  {\n', '    require(_beneficiary != address(0));\n', '    require(_cliff <= _duration);\n', '\n', '    beneficiary = _beneficiary;\n', '    revocable = _revocable;\n', '    duration = _duration;\n', '    cliff = _start.add(_cliff);\n', '    start = _start;\n', '  }\n', '\n', '  /**\n', '   * @notice Transfers vested tokens to beneficiary.\n', '   * @param _token ERC20 token which is being vested\n', '   */\n', '  function release(ERC20Basic _token) public {\n', '    uint256 unreleased = releasableAmount(_token);\n', '\n', '    require(unreleased > 0);\n', '\n', '    released[_token] = released[_token].add(unreleased);\n', '\n', '    _token.safeTransfer(beneficiary, unreleased);\n', '\n', '    emit Released(unreleased);\n', '  }\n', '\n', '  /**\n', '   * @notice Allows the owner to revoke the vesting. Tokens already vested\n', '   * remain in the contract, the rest are returned to the owner.\n', '   * @param _token ERC20 token which is being vested\n', '   */\n', '  function revoke(ERC20Basic _token) public onlyOwner {\n', '    require(revocable);\n', '    require(!revoked[_token]);\n', '\n', '    uint256 balance = _token.balanceOf(address(this));\n', '\n', '    uint256 unreleased = releasableAmount(_token);\n', '    uint256 refund = balance.sub(unreleased);\n', '\n', '    revoked[_token] = true;\n', '\n', '    _token.safeTransfer(owner, refund);\n', '\n', '    emit Revoked();\n', '  }\n', '\n', '  /**\n', "   * @dev Calculates the amount that has already vested but hasn't been released yet.\n", '   * @param _token ERC20 token which is being vested\n', '   */\n', '  function releasableAmount(ERC20Basic _token) public view returns (uint256) {\n', '    return vestedAmount(_token).sub(released[_token]);\n', '  }\n', '\n', '  /**\n', '   * @dev Calculates the amount that has already vested.\n', '   * @param _token ERC20 token which is being vested\n', '   */\n', '  function vestedAmount(ERC20Basic _token) public view returns (uint256) {\n', '    uint256 currentBalance = _token.balanceOf(address(this));\n', '    uint256 totalBalance = currentBalance.add(released[_token]);\n', '\n', '    if (block.timestamp < cliff) {\n', '      return 0;\n', '    } else if (block.timestamp >= start.add(duration) || revoked[_token]) {\n', '      return totalBalance;\n', '    } else {\n', '      return totalBalance.mul(block.timestamp.sub(start)).div(duration);\n', '    }\n', '  }\n', '}\n', '\n', '\n', '// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v1.12.0/contracts/ownership/Claimable.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '\n', '/**\n', ' * @title Claimable\n', ' * @dev Extension for the Ownable contract, where the ownership needs to be claimed.\n', ' * This allows the new owner to accept the transfer.\n', ' */\n', 'contract Claimable is Ownable {\n', '  address public pendingOwner;\n', '\n', '  /**\n', '   * @dev Modifier throws if called by any account other than the pendingOwner.\n', '   */\n', '  modifier onlyPendingOwner() {\n', '    require(msg.sender == pendingOwner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to set the pendingOwner address.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    pendingOwner = newOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the pendingOwner address to finalize the transfer.\n', '   */\n', '  function claimOwnership() public onlyPendingOwner {\n', '    emit OwnershipTransferred(owner, pendingOwner);\n', '    owner = pendingOwner;\n', '    pendingOwner = address(0);\n', '  }\n', '}\n', '\n', '\n', '\n', 'pragma solidity 0.4.24;\n', '\n', '\n', '/**\n', ' * @title ZamzamVestingPool\n', ' * @author Wibson Development Team <[email\xa0protected]>\n', ' * @notice This contract models a pool of tokens to be distributed among beneficiaries\n', ' * with different lock-up and vesting conditions. There is no need to know the\n', ' * beneficiaries in advance, since the contract allows to add them as time goes by.\n', ' * @dev There is only one method to add a beneficiary. By doing this, not only\n', ' * both modes (lock-up and vesting) can be achieved, but they can also be combined\n', ' * as suitable. Moreover, total funds and distributed tokens are controlled to\n', ' * avoid refills done by transferring tokens through the ERC20.\n', ' */\n', 'contract ZamzamVestingPool is Claimable {\n', '  using SafeERC20 for ERC20Basic;\n', '  using SafeMath for uint256;\n', '\n', '  // ERC20 token being held\n', '  ERC20Basic public token;\n', '\n', '  // Maximum amount of tokens to be distributed\n', '  uint256 public totalFunds;\n', '\n', '  // Tokens already distributed\n', '  uint256 public distributedTokens;\n', '\n', '  // List of beneficiaries added to the pool\n', '  address[] public beneficiaries;\n', '\n', '  // Mapping of beneficiary to TokenVesting contracts addresses\n', '  mapping(address => address[]) public beneficiaryDistributionContracts;\n', '\n', '  // Tracks the distribution contracts created by this contract.\n', '  mapping(address => bool) private distributionContracts;\n', '\n', '  event BeneficiaryAdded(\n', '    address indexed beneficiary,\n', '    address vesting,\n', '    uint256 amount\n', '  );\n', '\n', '  modifier validAddress(address _addr) {\n', '    require(_addr != address(0));\n', '    require(_addr != address(this));\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @notice Contract constructor.\n', '   * @param _token instance of an ERC20 token.\n', '   * @param _totalFunds Maximum amount of tokens to be distributed among\n', '   *        beneficiaries.\n', '   */\n', '  constructor(\n', '    ERC20Basic _token,\n', '    uint256 _totalFunds\n', '  ) public validAddress(_token) {\n', '    require(_totalFunds > 0);\n', '\n', '    token = _token;\n', '    totalFunds = _totalFunds;\n', '    distributedTokens = 0;\n', '  }\n', '\n', '  /**\n', '   * @notice Assigns a token release point to a beneficiary. A beneficiary can have\n', '   *         many token release points.\n', '   * @param _beneficiary address of the beneficiary to whom vested tokens are transferred\n', '   * @param _start the time (as Unix time) at which point vesting starts\n', '   * @param _cliff duration in seconds of the cliff in which tokens will begin to vest\n', '   * @param _duration duration in seconds of the period in which the tokens will vest\n', '   * @param _amount amount of tokens to be released\n', '   * @return address for the new TokenVesting contract instance.\n', '   */\n', '  function addBeneficiary(\n', '    address _beneficiary,\n', '    uint256 _start,\n', '    uint256 _cliff,\n', '    uint256 _duration,\n', '    uint256 _amount\n', '  ) public onlyOwner validAddress(_beneficiary) returns (address) {\n', '    require(_beneficiary != owner);\n', '    require(_amount > 0);\n', '    require(_duration >= _cliff);\n', '\n', '    // Check there are sufficient funds and actual token balance.\n', '    require(SafeMath.sub(totalFunds, distributedTokens) >= _amount);\n', '    require(token.balanceOf(address(this)) >= _amount);\n', '\n', '    if (!beneficiaryExists(_beneficiary)) {\n', '      beneficiaries.push(_beneficiary);\n', '    }\n', '\n', '    // Bookkepping of distributed tokens\n', '    distributedTokens = distributedTokens.add(_amount);\n', '\n', '    address tokenVesting = new TokenVesting(\n', '      _beneficiary,\n', '      _start,\n', '      _cliff,\n', '      _duration,\n', '      false // TokenVesting cannot be revoked\n', '    );\n', '\n', '    // Bookkeeping of distributions contracts per beneficiary\n', '    beneficiaryDistributionContracts[_beneficiary].push(tokenVesting);\n', '    distributionContracts[tokenVesting] = true;\n', '\n', '    // Assign the tokens to the beneficiary\n', '    token.safeTransfer(tokenVesting, _amount);\n', '\n', '    emit BeneficiaryAdded(_beneficiary, tokenVesting, _amount);\n', '    return tokenVesting;\n', '  }\n', '\n', '  /**\n', '   * @notice Gets an array of all the distribution contracts for a given beneficiary.\n', '   * @param _beneficiary address of the beneficiary to whom tokens will be transferred.\n', '   * @return List of TokenVesting addresses.\n', '   */\n', '  function getDistributionContracts(\n', '    address _beneficiary\n', '  ) public view validAddress(_beneficiary) returns (address[]) {\n', '    return beneficiaryDistributionContracts[_beneficiary];\n', '  }\n', '\n', '  /**\n', '   * @notice Checks if a beneficiary was added to the pool at least once.\n', '   * @param _beneficiary address of the beneficiary to whom tokens will be transferred.\n', '   * @return true if beneficiary exists, false otherwise.\n', '   */\n', '  function beneficiaryExists(\n', '    address _beneficiary\n', '  ) internal view returns (bool) {\n', '    return beneficiaryDistributionContracts[_beneficiary].length > 0;\n', '  }\n', '}']