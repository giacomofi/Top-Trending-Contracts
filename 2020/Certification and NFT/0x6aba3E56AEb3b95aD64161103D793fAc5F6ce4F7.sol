['// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    public returns (bool);\n', '\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', "    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: contracts/ERC900/ERC900.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * @title ERC900 Simple Staking Interface\n', ' * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-900.md\n', ' */\n', 'contract ERC900 {\n', '  event Staked(address indexed user, uint256 amount, uint256 total, bytes data);\n', '  event Unstaked(address indexed user, uint256 amount, uint256 total, bytes data);\n', '\n', '  function stake(uint256 amount, bytes data) public;\n', '  function stakeFor(address user, uint256 amount, bytes data) public;\n', '  function unstake(uint256 amount, bytes data) public;\n', '  function totalStakedFor(address addr) public view returns (uint256);\n', '  function totalStaked() public view returns (uint256);\n', '  function token() public view returns (address);\n', '  function supportsHistory() public pure returns (bool);\n', '\n', '  // NOTE: Not implementing the optional functions\n', '  // function lastStakedFor(address addr) public view returns (uint256);\n', '  // function totalStakedForAt(address addr, uint256 blockNumber) public view returns (uint256);\n', '  // function totalStakedAt(uint256 blockNumber) public view returns (uint256);\n', '}\n', '\n', '// File: contracts/ERC900/ERC900BasicStakeContract.sol\n', '\n', '/* solium-disable security/no-block-members */\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title ERC900 Simple Staking Interface basic implementation\n', ' * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-900.md\n', ' */\n', 'contract ERC900BasicStakeContract is ERC900 {\n', "  // @TODO: deploy this separately so we don't have to deploy it multiple times for each contract\n", '  using SafeMath for uint256;\n', '\n', '  // Token used for staking\n', '  ERC20 stakingToken;\n', '\n', '  // The default duration of stake lock-in (in seconds)\n', '  uint256 public defaultLockInDuration;\n', '\n', '  // To save on gas, rather than create a separate mapping for totalStakedFor & personalStakes,\n', '  //  both data structures are stored in a single mapping for a given addresses.\n', '  //\n', "  // It's possible to have a non-existing personalStakes, but have tokens in totalStakedFor\n", '  //  if other users are staking on behalf of a given address.\n', '  mapping (address => StakeContract) public stakeHolders;\n', '\n', '  // Struct for personal stakes (i.e., stakes made by this address)\n', '  // unlockedTimestamp - when the stake unlocks (in seconds since Unix epoch)\n', '  // actualAmount - the amount of tokens in the stake\n', '  // stakedFor - the address the stake was staked for\n', '  struct Stake {\n', '    uint256 unlockedTimestamp;\n', '    uint256 actualAmount;\n', '    address stakedFor;\n', '  }\n', '\n', '  // Struct for all stake metadata at a particular address\n', '  // totalStakedFor - the number of tokens staked for this address\n', '  // personalStakeIndex - the index in the personalStakes array.\n', '  // personalStakes - append only array of stakes made by this address\n', '  // exists - whether or not there are stakes that involve this address\n', '  struct StakeContract {\n', '    uint256 totalStakedFor;\n', '\n', '    uint256 personalStakeIndex;\n', '\n', '    Stake[] personalStakes;\n', '\n', '    bool exists;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier that checks that this contract can transfer tokens from the\n', '   *  balance in the stakingToken contract for the given address.\n', '   * @dev This modifier also transfers the tokens.\n', '   * @param _address address to transfer tokens from\n', '   * @param _amount uint256 the number of tokens\n', '   */\n', '  modifier canStake(address _address, uint256 _amount) {\n', '    require(\n', '      stakingToken.transferFrom(_address, this, _amount),\n', '      "Stake required");\n', '\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Constructor function\n', '   * @param _stakingToken ERC20 The address of the token contract used for staking\n', '   */\n', '  constructor(ERC20 _stakingToken) public {\n', '    stakingToken = _stakingToken;\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the timestamps for when active personal stakes for an address will unlock\n', '   * @dev These accessors functions are needed until https://github.com/ethereum/web3.js/issues/1241 is solved\n', '   * @param _address address that created the stakes\n', '   * @return uint256[] array of timestamps\n', '   */\n', '  function getPersonalStakeUnlockedTimestamps(address _address) external view returns (uint256[]) {\n', '    uint256[] memory timestamps;\n', '    (timestamps,,) = getPersonalStakes(_address);\n', '\n', '    return timestamps;\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the stake actualAmount for active personal stakes for an address\n', '   * @dev These accessors functions are needed until https://github.com/ethereum/web3.js/issues/1241 is solved\n', '   * @param _address address that created the stakes\n', '   * @return uint256[] array of actualAmounts\n', '   */\n', '  function getPersonalStakeActualAmounts(address _address) external view returns (uint256[]) {\n', '    uint256[] memory actualAmounts;\n', '    (,actualAmounts,) = getPersonalStakes(_address);\n', '\n', '    return actualAmounts;\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the addresses that each personal stake was created for by an address\n', '   * @dev These accessors functions are needed until https://github.com/ethereum/web3.js/issues/1241 is solved\n', '   * @param _address address that created the stakes\n', '   * @return address[] array of amounts\n', '   */\n', '  function getPersonalStakeForAddresses(address _address) external view returns (address[]) {\n', '    address[] memory stakedFor;\n', '    (,,stakedFor) = getPersonalStakes(_address);\n', '\n', '    return stakedFor;\n', '  }\n', '\n', '  /**\n', '   * @notice Stakes a certain amount of tokens, this MUST transfer the given amount from the user\n', '   * @notice MUST trigger Staked event\n', '   * @param _amount uint256 the amount of tokens to stake\n', '   * @param _data bytes optional data to include in the Stake event\n', '   */\n', '  function stake(uint256 _amount, bytes _data) public {\n', '    createStake(\n', '      msg.sender,\n', '      _amount,\n', '      defaultLockInDuration,\n', '      _data);\n', '  }\n', '\n', '  /**\n', '   * @notice Stakes a certain amount of tokens, this MUST transfer the given amount from the caller\n', '   * @notice MUST trigger Staked event\n', '   * @param _user address the address the tokens are staked for\n', '   * @param _amount uint256 the amount of tokens to stake\n', '   * @param _data bytes optional data to include in the Stake event\n', '   */\n', '  function stakeFor(address _user, uint256 _amount, bytes _data) public {\n', '    createStake(\n', '      _user,\n', '      _amount,\n', '      defaultLockInDuration,\n', '      _data);\n', '  }\n', '\n', '  /**\n', '   * @notice Unstakes a certain amount of tokens, this SHOULD return the given amount of tokens to the user, if unstaking is currently not possible the function MUST revert\n', '   * @notice MUST trigger Unstaked event\n', '   * @dev Unstaking tokens is an atomic operation—either all of the tokens in a stake, or none of the tokens.\n', '   * @dev Users can only unstake a single stake at a time, it is must be their oldest active stake. Upon releasing that stake, the tokens will be\n', '   *  transferred back to their account, and their personalStakeIndex will increment to the next active stake.\n', '   * @param _amount uint256 the amount of tokens to unstake\n', '   * @param _data bytes optional data to include in the Unstake event\n', '   */\n', '  function unstake(uint256 _amount, bytes _data) public {\n', '    withdrawStake(\n', '      _amount,\n', '      _data);\n', '  }\n', '\n', '  /**\n', '   * @notice Returns the current total of tokens staked for an address\n', '   * @param _address address The address to query\n', '   * @return uint256 The number of tokens staked for the given address\n', '   */\n', '  function totalStakedFor(address _address) public view returns (uint256) {\n', '    return stakeHolders[_address].totalStakedFor;\n', '  }\n', '\n', '  /**\n', '   * @notice Returns the current total of tokens staked\n', '   * @return uint256 The number of tokens staked in the contract\n', '   */\n', '  function totalStaked() public view returns (uint256) {\n', '    return stakingToken.balanceOf(this);\n', '  }\n', '\n', '  /**\n', '   * @notice Address of the token being used by the staking interface\n', '   * @return address The address of the ERC20 token used for staking\n', '   */\n', '  function token() public view returns (address) {\n', '    return stakingToken;\n', '  }\n', '\n', '  /**\n', '   * @notice MUST return true if the optional history functions are implemented, otherwise false\n', "   * @dev Since we don't implement the optional interface, this always returns false\n", '   * @return bool Whether or not the optional history functions are implemented\n', '   */\n', '  function supportsHistory() public pure returns (bool) {\n', '    return false;\n', '  }\n', '\n', '  /**\n', '   * @dev Helper function to get specific properties of all of the personal stakes created by an address\n', '   * @param _address address The address to query\n', '   * @return (uint256[], uint256[], address[])\n', '   *  timestamps array, actualAmounts array, stakedFor array\n', '   */\n', '  function getPersonalStakes(\n', '    address _address\n', '  )\n', '    public\n', '    view\n', '    returns(uint256[], uint256[], address[])\n', '  {\n', '    StakeContract storage stakeContract = stakeHolders[_address];\n', '\n', '    uint256 arraySize = stakeContract.personalStakes.length - stakeContract.personalStakeIndex;\n', '    uint256[] memory unlockedTimestamps = new uint256[](arraySize);\n', '    uint256[] memory actualAmounts = new uint256[](arraySize);\n', '    address[] memory stakedFor = new address[](arraySize);\n', '\n', '    for (uint256 i = stakeContract.personalStakeIndex; i < stakeContract.personalStakes.length; i++) {\n', '      uint256 index = i - stakeContract.personalStakeIndex;\n', '      unlockedTimestamps[index] = stakeContract.personalStakes[i].unlockedTimestamp;\n', '      actualAmounts[index] = stakeContract.personalStakes[i].actualAmount;\n', '      stakedFor[index] = stakeContract.personalStakes[i].stakedFor;\n', '    }\n', '\n', '    return (\n', '      unlockedTimestamps,\n', '      actualAmounts,\n', '      stakedFor\n', '    );\n', '  }\n', '\n', '  /**\n', '   * @dev Helper function to create stakes for a given address\n', '   * @param _address address The address the stake is being created for\n', '   * @param _amount uint256 The number of tokens being staked\n', '   * @param _lockInDuration uint256 The duration to lock the tokens for\n', '   * @param _data bytes optional data to include in the Stake event\n', '   */\n', '  function createStake(\n', '    address _address,\n', '    uint256 _amount,\n', '    uint256 _lockInDuration,\n', '    bytes _data\n', '  )\n', '    internal\n', '    canStake(msg.sender, _amount)\n', '  {\n', '    require(\n', '      _amount > 0,\n', '      "Stake amount has to be greater than 0!");\n', '    if (!stakeHolders[msg.sender].exists) {\n', '      stakeHolders[msg.sender].exists = true;\n', '    }\n', '\n', '    stakeHolders[_address].totalStakedFor = stakeHolders[_address].totalStakedFor.add(_amount);\n', '    stakeHolders[msg.sender].personalStakes.push(\n', '      Stake(\n', '        block.timestamp.add(_lockInDuration),\n', '        _amount,\n', '        _address)\n', '      );\n', '\n', '    emit Staked(\n', '      _address,\n', '      _amount,\n', '      totalStakedFor(_address),\n', '      _data);\n', '  }\n', '\n', '  /**\n', '   * @dev Helper function to withdraw stakes for the msg.sender\n', '   * @param _amount uint256 The amount to withdraw. MUST match the stake amount for the\n', '   *  stake at personalStakeIndex.\n', '   * @param _data bytes optional data to include in the Unstake event\n', '   */\n', '  function withdrawStake(\n', '    uint256 _amount,\n', '    bytes _data\n', '  )\n', '    internal\n', '  {\n', '    Stake storage personalStake = stakeHolders[msg.sender].personalStakes[stakeHolders[msg.sender].personalStakeIndex];\n', '\n', '    // Check that the current stake has unlocked & matches the unstake amount\n', '    require(\n', '      personalStake.unlockedTimestamp <= block.timestamp,\n', '      "The current stake hasn\'t unlocked yet");\n', '\n', '    require(\n', '      personalStake.actualAmount == _amount,\n', '      "The unstake amount does not match the current stake");\n', '\n', '    // Transfer the staked tokens from this contract back to the sender\n', '    // Notice that we are using transfer instead of transferFrom here, so\n', '    //  no approval is needed beforehand.\n', '    require(\n', '      stakingToken.transfer(msg.sender, _amount),\n', '      "Unable to withdraw stake");\n', '\n', '    stakeHolders[personalStake.stakedFor].totalStakedFor = stakeHolders[personalStake.stakedFor]\n', '      .totalStakedFor.sub(personalStake.actualAmount);\n', '\n', '    personalStake.actualAmount = 0;\n', '    stakeHolders[msg.sender].personalStakeIndex++;\n', '\n', '    emit Unstaked(\n', '      personalStake.stakedFor,\n', '      _amount,\n', '      totalStakedFor(personalStake.stakedFor),\n', '      _data);\n', '  }\n', '}\n', '\n', '// File: contracts/ERC900/BasicStakingContract.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '\n', '/**\n', ' * @title BasicStakingContract\n', ' */\n', 'contract BasicStakingContract is ERC900BasicStakeContract {\n', '  /**\n', '   * @dev Constructor function\n', '   * @param _stakingToken ERC20 The address of the token used for staking\n', '   * @param _lockInDuration uint256 The duration (in seconds) that stakes are required to be locked for\n', '   */\n', '  constructor(\n', '    ERC20 _stakingToken,\n', '    uint256 _lockInDuration\n', '  )\n', '    public\n', '    ERC900BasicStakeContract(_stakingToken)\n', '  {\n', '    defaultLockInDuration = _lockInDuration;\n', '  }\n', '}']