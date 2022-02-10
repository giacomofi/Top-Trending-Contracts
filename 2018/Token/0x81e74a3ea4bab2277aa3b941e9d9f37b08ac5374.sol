['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract ifoodToken is ERC20 {\n', '  using SafeMath for uint256;\n', '  \n', '  // the controller of minting\n', '  address public ifoodDev = 0x4E471f031D03E5856125993dc3D59520229141Ce;\n', '  // the controller of approving of minting and withdraw tokens\n', '  address public ifoodCommunity = 0x0d72e931932356FcCf8CFF3f83390e24BE72771d;\n', '\n', '  struct TokensWithLock {\n', '    uint256 value;\n', '    uint256 blockNumber;\n', '  }\n', '  // Balances for each account\n', '  mapping(address => uint256) balances;\n', '  // Tokens with time lock\n', '  // Only when the tokens&#39; blockNumber is less than current block number,\n', '  // can the tokens be minted to the owner\n', '  mapping(address => TokensWithLock) lockTokens;\n', '  // Owner of account approves the transfer of an amount to another account\n', '  mapping(address => mapping (address => uint256)) allowed;\n', ' \n', '  // Token Info\n', '  string public name = "Ifoods Token";\n', '  string public symbol = "IFOOD";\n', '  uint8 public decimals = 18;\n', '  \n', '  // Token Cap\n', '  uint256 public totalSupplyCap = 10**10 * 10**uint256(decimals);\n', '  // True if mintingFinished\n', '  bool public mintingFinished = false;\n', '  // The block number when deploy\n', '  uint256 public deployBlockNumber = getCurrentBlockNumber();\n', '  // The min threshold of lock time\n', '  uint256 public constant TIMETHRESHOLD = 7200;\n', '  // The lock time of minted tokens\n', '  uint256 public durationOfLock = 7200;\n', '  // True if transfers are allowed\n', '  bool public transferable = false;\n', '  // True if the transferable can be change\n', '  bool public canSetTransferable = true;\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  modifier only(address _address) {\n', '    require(msg.sender == _address);\n', '    _;\n', '  }\n', '\n', '  modifier nonZeroAddress(address _address) {\n', '    require(_address != address(0));\n', '    _;\n', '  }\n', '\n', '  modifier canTransfer() {\n', '    require(transferable == true);\n', '    _;\n', '  }\n', '\n', '  event SetDurationOfLock(address indexed _caller);\n', '  event ApproveMintTokens(address indexed _owner, uint256 _amount);\n', '  event WithdrawMintTokens(address indexed _owner, uint256 _amount);\n', '  event MintTokens(address indexed _owner, uint256 _amount);\n', '  event BurnTokens(address indexed _owner, uint256 _amount);\n', '  event MintFinished(address indexed _caller);\n', '  event SetTransferable(address indexed _address, bool _transferable);\n', '  event SetifoodDevAddress(address indexed _old, address indexed _new);\n', '  event SetifoodCommunityAddress(address indexed _old, address indexed _new);\n', '  event DisableSetTransferable(address indexed _address, bool _canSetTransferable);\n', '\n', '  /**\n', '   * @dev transfer token for a specified address\n', '   * @param _to The address to transfer to.\n', '   * @param _value The amount to be transferred.\n', '   */\n', '  function transfer(address _to, uint256 _value) canTransfer public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Gets the balance of the specified address.\n', '   * @param _owner The address to query the the balance of.\n', '   * @return An uint256 representing the amount owned by the passed address.\n', '   */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  // Allow `_spender` to withdraw from your account, multiple times.\n', '  function approve(address _spender, uint _value) public returns (bool success) {\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) {\n', '        revert();\n', '    }\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '  \n', '  /**\n', '   * @dev Enables token holders to transfer their tokens freely if true\n', '   * @param _transferable True if transfers are allowed\n', '   */\n', '  function setTransferable(bool _transferable) only(ifoodDev) public {\n', '    require(canSetTransferable == true);\n', '    transferable = _transferable;\n', '    SetTransferable(msg.sender, _transferable);\n', '  }\n', '\n', '  /**\n', '   * @dev disable the canSetTransferable\n', '   */\n', '  function disableSetTransferable() only(ifoodDev) public {\n', '    transferable = true;\n', '    canSetTransferable = false;\n', '    DisableSetTransferable(msg.sender, false);\n', '  }\n', '\n', '  /**\n', '   * @dev Set the ifoodDev\n', '   * @param _ifoodDev The new ifood dev address\n', '   */\n', '  function setifoodDevAddress(address _ifoodDev) only(ifoodDev) nonZeroAddress(ifoodDev) public {\n', '    ifoodDev = _ifoodDev;\n', '    SetifoodDevAddress(msg.sender, _ifoodDev);\n', '  }\n', '\n', '  /**\n', '   * @dev Set the ifoodCommunity\n', '   * @param _ifoodCommunity The new ifood community address\n', '   */\n', '  function setifoodCommunityAddress(address _ifoodCommunity) only(ifoodCommunity) nonZeroAddress(_ifoodCommunity) public {\n', '    ifoodCommunity = _ifoodCommunity;\n', '    SetifoodCommunityAddress(msg.sender, _ifoodCommunity);\n', '  }\n', '  \n', '  /**\n', '   * @dev Set the duration of lock of tokens approved of minting\n', '   * @param _durationOfLock the new duration of lock\n', '   */\n', '  function setDurationOfLock(uint256 _durationOfLock) canMint only(ifoodCommunity) public {\n', '    require(_durationOfLock >= TIMETHRESHOLD);\n', '    durationOfLock = _durationOfLock;\n', '    SetDurationOfLock(msg.sender);\n', '  }\n', '  \n', '  /**\n', '   * @dev Get the quantity of locked tokens\n', '   * @param _owner The address of locked tokens\n', '   * @return the quantity and the lock time of locked tokens\n', '   */\n', '   function getLockTokens(address _owner) nonZeroAddress(_owner) view public returns (uint256 value, uint256 blockNumber) {\n', '     return (lockTokens[_owner].value, lockTokens[_owner].blockNumber);\n', '   }\n', '\n', '  /**\n', '   * @dev Approve of minting `_amount` tokens that are assigned to `_owner`\n', '   * @param _owner The address that will be assigned the new tokens\n', '   * @param _amount The quantity of tokens approved of mintting\n', '   * @return True if the tokens are approved of mintting correctly\n', '   */\n', '  function approveMintTokens(address _owner, uint256 _amount) nonZeroAddress(_owner) canMint only(ifoodCommunity) public returns (bool) {\n', '    require(_amount > 0);\n', '    uint256 previousLockTokens = lockTokens[_owner].value;\n', '    require(previousLockTokens + _amount >= previousLockTokens);\n', '    uint256 curTotalSupply = totalSupply;\n', '    require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow\n', '    require(curTotalSupply + _amount <= totalSupplyCap);  // Check for overflow of total supply cap\n', '    uint256 previousBalanceTo = balanceOf(_owner);\n', '    require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow\n', '    lockTokens[_owner].value = previousLockTokens.add(_amount);\n', '    uint256 curBlockNumber = getCurrentBlockNumber();\n', '    lockTokens[_owner].blockNumber = curBlockNumber.add(durationOfLock);\n', '    ApproveMintTokens(_owner, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Withdraw approval of minting `_amount` tokens that are assigned to `_owner`\n', '   * @param _owner The address that will be withdrawn the tokens\n', '   * @param _amount The quantity of tokens withdrawn approval of mintting\n', '   * @return True if the tokens are withdrawn correctly\n', '   */\n', '  function withdrawMintTokens(address _owner, uint256 _amount) nonZeroAddress(_owner) canMint only(ifoodCommunity) public returns (bool) {\n', '    require(_amount > 0);\n', '    uint256 previousLockTokens = lockTokens[_owner].value;\n', '    require(previousLockTokens - _amount >= 0);\n', '    lockTokens[_owner].value = previousLockTokens.sub(_amount);\n', '    if (previousLockTokens - _amount == 0) {\n', '      lockTokens[_owner].blockNumber = 0;\n', '    }\n', '    WithdrawMintTokens(_owner, _amount);\n', '    return true;\n', '  }\n', '  \n', '  /**\n', '   * @dev Mints `_amount` tokens that are assigned to `_owner`\n', '   * @param _owner The address that will be assigned the new tokens\n', '   * @return True if the tokens are minted correctly\n', '   */\n', '  function mintTokens(address _owner) canMint only(ifoodDev) nonZeroAddress(_owner) public returns (bool) {\n', '    require(lockTokens[_owner].blockNumber <= getCurrentBlockNumber());\n', '    uint256 _amount = lockTokens[_owner].value;\n', '    uint256 curTotalSupply = totalSupply;\n', '    require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow\n', '    require(curTotalSupply + _amount <= totalSupplyCap);  // Check for overflow of total supply cap\n', '    uint256 previousBalanceTo = balanceOf(_owner);\n', '    require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow\n', '    \n', '    totalSupply = curTotalSupply.add(_amount);\n', '    balances[_owner] = previousBalanceTo.add(_amount);\n', '    lockTokens[_owner].value = 0;\n', '    lockTokens[_owner].blockNumber = 0;\n', '    MintTokens(_owner, _amount);\n', '    Transfer(0, _owner, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens to multiple addresses\n', '   * @param _addresses The addresses that will receieve tokens\n', '   * @param _amounts The quantity of tokens that will be transferred\n', '   * @return True if the tokens are transferred correctly\n', '   */\n', '  function transferForMultiAddresses(address[] _addresses, uint256[] _amounts) canTransfer public returns (bool) {\n', '    for (uint256 i = 0; i < _addresses.length; i++) {\n', '      require(_addresses[i] != address(0));\n', '      require(_amounts[i] <= balances[msg.sender]);\n', '      require(_amounts[i] > 0);\n', '\n', '      // SafeMath.sub will throw if there is not enough balance.\n', '      balances[msg.sender] = balances[msg.sender].sub(_amounts[i]);\n', '      balances[_addresses[i]] = balances[_addresses[i]].add(_amounts[i]);\n', '      Transfer(msg.sender, _addresses[i], _amounts[i]);\n', '    }\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() only(ifoodDev) canMint public returns (bool) {\n', '    mintingFinished = true;\n', '    MintFinished(msg.sender);\n', '    return true;\n', '  }\n', '\n', '  function getCurrentBlockNumber() private view returns (uint256) {\n', '    return block.number;\n', '  }\n', '\n', '  function () public payable {\n', '    revert();\n', '  }\n', '\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract ifoodToken is ERC20 {\n', '  using SafeMath for uint256;\n', '  \n', '  // the controller of minting\n', '  address public ifoodDev = 0x4E471f031D03E5856125993dc3D59520229141Ce;\n', '  // the controller of approving of minting and withdraw tokens\n', '  address public ifoodCommunity = 0x0d72e931932356FcCf8CFF3f83390e24BE72771d;\n', '\n', '  struct TokensWithLock {\n', '    uint256 value;\n', '    uint256 blockNumber;\n', '  }\n', '  // Balances for each account\n', '  mapping(address => uint256) balances;\n', '  // Tokens with time lock\n', "  // Only when the tokens' blockNumber is less than current block number,\n", '  // can the tokens be minted to the owner\n', '  mapping(address => TokensWithLock) lockTokens;\n', '  // Owner of account approves the transfer of an amount to another account\n', '  mapping(address => mapping (address => uint256)) allowed;\n', ' \n', '  // Token Info\n', '  string public name = "Ifoods Token";\n', '  string public symbol = "IFOOD";\n', '  uint8 public decimals = 18;\n', '  \n', '  // Token Cap\n', '  uint256 public totalSupplyCap = 10**10 * 10**uint256(decimals);\n', '  // True if mintingFinished\n', '  bool public mintingFinished = false;\n', '  // The block number when deploy\n', '  uint256 public deployBlockNumber = getCurrentBlockNumber();\n', '  // The min threshold of lock time\n', '  uint256 public constant TIMETHRESHOLD = 7200;\n', '  // The lock time of minted tokens\n', '  uint256 public durationOfLock = 7200;\n', '  // True if transfers are allowed\n', '  bool public transferable = false;\n', '  // True if the transferable can be change\n', '  bool public canSetTransferable = true;\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  modifier only(address _address) {\n', '    require(msg.sender == _address);\n', '    _;\n', '  }\n', '\n', '  modifier nonZeroAddress(address _address) {\n', '    require(_address != address(0));\n', '    _;\n', '  }\n', '\n', '  modifier canTransfer() {\n', '    require(transferable == true);\n', '    _;\n', '  }\n', '\n', '  event SetDurationOfLock(address indexed _caller);\n', '  event ApproveMintTokens(address indexed _owner, uint256 _amount);\n', '  event WithdrawMintTokens(address indexed _owner, uint256 _amount);\n', '  event MintTokens(address indexed _owner, uint256 _amount);\n', '  event BurnTokens(address indexed _owner, uint256 _amount);\n', '  event MintFinished(address indexed _caller);\n', '  event SetTransferable(address indexed _address, bool _transferable);\n', '  event SetifoodDevAddress(address indexed _old, address indexed _new);\n', '  event SetifoodCommunityAddress(address indexed _old, address indexed _new);\n', '  event DisableSetTransferable(address indexed _address, bool _canSetTransferable);\n', '\n', '  /**\n', '   * @dev transfer token for a specified address\n', '   * @param _to The address to transfer to.\n', '   * @param _value The amount to be transferred.\n', '   */\n', '  function transfer(address _to, uint256 _value) canTransfer public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Gets the balance of the specified address.\n', '   * @param _owner The address to query the the balance of.\n', '   * @return An uint256 representing the amount owned by the passed address.\n', '   */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  // Allow `_spender` to withdraw from your account, multiple times.\n', '  function approve(address _spender, uint _value) public returns (bool success) {\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) {\n', '        revert();\n', '    }\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '  \n', '  /**\n', '   * @dev Enables token holders to transfer their tokens freely if true\n', '   * @param _transferable True if transfers are allowed\n', '   */\n', '  function setTransferable(bool _transferable) only(ifoodDev) public {\n', '    require(canSetTransferable == true);\n', '    transferable = _transferable;\n', '    SetTransferable(msg.sender, _transferable);\n', '  }\n', '\n', '  /**\n', '   * @dev disable the canSetTransferable\n', '   */\n', '  function disableSetTransferable() only(ifoodDev) public {\n', '    transferable = true;\n', '    canSetTransferable = false;\n', '    DisableSetTransferable(msg.sender, false);\n', '  }\n', '\n', '  /**\n', '   * @dev Set the ifoodDev\n', '   * @param _ifoodDev The new ifood dev address\n', '   */\n', '  function setifoodDevAddress(address _ifoodDev) only(ifoodDev) nonZeroAddress(ifoodDev) public {\n', '    ifoodDev = _ifoodDev;\n', '    SetifoodDevAddress(msg.sender, _ifoodDev);\n', '  }\n', '\n', '  /**\n', '   * @dev Set the ifoodCommunity\n', '   * @param _ifoodCommunity The new ifood community address\n', '   */\n', '  function setifoodCommunityAddress(address _ifoodCommunity) only(ifoodCommunity) nonZeroAddress(_ifoodCommunity) public {\n', '    ifoodCommunity = _ifoodCommunity;\n', '    SetifoodCommunityAddress(msg.sender, _ifoodCommunity);\n', '  }\n', '  \n', '  /**\n', '   * @dev Set the duration of lock of tokens approved of minting\n', '   * @param _durationOfLock the new duration of lock\n', '   */\n', '  function setDurationOfLock(uint256 _durationOfLock) canMint only(ifoodCommunity) public {\n', '    require(_durationOfLock >= TIMETHRESHOLD);\n', '    durationOfLock = _durationOfLock;\n', '    SetDurationOfLock(msg.sender);\n', '  }\n', '  \n', '  /**\n', '   * @dev Get the quantity of locked tokens\n', '   * @param _owner The address of locked tokens\n', '   * @return the quantity and the lock time of locked tokens\n', '   */\n', '   function getLockTokens(address _owner) nonZeroAddress(_owner) view public returns (uint256 value, uint256 blockNumber) {\n', '     return (lockTokens[_owner].value, lockTokens[_owner].blockNumber);\n', '   }\n', '\n', '  /**\n', '   * @dev Approve of minting `_amount` tokens that are assigned to `_owner`\n', '   * @param _owner The address that will be assigned the new tokens\n', '   * @param _amount The quantity of tokens approved of mintting\n', '   * @return True if the tokens are approved of mintting correctly\n', '   */\n', '  function approveMintTokens(address _owner, uint256 _amount) nonZeroAddress(_owner) canMint only(ifoodCommunity) public returns (bool) {\n', '    require(_amount > 0);\n', '    uint256 previousLockTokens = lockTokens[_owner].value;\n', '    require(previousLockTokens + _amount >= previousLockTokens);\n', '    uint256 curTotalSupply = totalSupply;\n', '    require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow\n', '    require(curTotalSupply + _amount <= totalSupplyCap);  // Check for overflow of total supply cap\n', '    uint256 previousBalanceTo = balanceOf(_owner);\n', '    require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow\n', '    lockTokens[_owner].value = previousLockTokens.add(_amount);\n', '    uint256 curBlockNumber = getCurrentBlockNumber();\n', '    lockTokens[_owner].blockNumber = curBlockNumber.add(durationOfLock);\n', '    ApproveMintTokens(_owner, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Withdraw approval of minting `_amount` tokens that are assigned to `_owner`\n', '   * @param _owner The address that will be withdrawn the tokens\n', '   * @param _amount The quantity of tokens withdrawn approval of mintting\n', '   * @return True if the tokens are withdrawn correctly\n', '   */\n', '  function withdrawMintTokens(address _owner, uint256 _amount) nonZeroAddress(_owner) canMint only(ifoodCommunity) public returns (bool) {\n', '    require(_amount > 0);\n', '    uint256 previousLockTokens = lockTokens[_owner].value;\n', '    require(previousLockTokens - _amount >= 0);\n', '    lockTokens[_owner].value = previousLockTokens.sub(_amount);\n', '    if (previousLockTokens - _amount == 0) {\n', '      lockTokens[_owner].blockNumber = 0;\n', '    }\n', '    WithdrawMintTokens(_owner, _amount);\n', '    return true;\n', '  }\n', '  \n', '  /**\n', '   * @dev Mints `_amount` tokens that are assigned to `_owner`\n', '   * @param _owner The address that will be assigned the new tokens\n', '   * @return True if the tokens are minted correctly\n', '   */\n', '  function mintTokens(address _owner) canMint only(ifoodDev) nonZeroAddress(_owner) public returns (bool) {\n', '    require(lockTokens[_owner].blockNumber <= getCurrentBlockNumber());\n', '    uint256 _amount = lockTokens[_owner].value;\n', '    uint256 curTotalSupply = totalSupply;\n', '    require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow\n', '    require(curTotalSupply + _amount <= totalSupplyCap);  // Check for overflow of total supply cap\n', '    uint256 previousBalanceTo = balanceOf(_owner);\n', '    require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow\n', '    \n', '    totalSupply = curTotalSupply.add(_amount);\n', '    balances[_owner] = previousBalanceTo.add(_amount);\n', '    lockTokens[_owner].value = 0;\n', '    lockTokens[_owner].blockNumber = 0;\n', '    MintTokens(_owner, _amount);\n', '    Transfer(0, _owner, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens to multiple addresses\n', '   * @param _addresses The addresses that will receieve tokens\n', '   * @param _amounts The quantity of tokens that will be transferred\n', '   * @return True if the tokens are transferred correctly\n', '   */\n', '  function transferForMultiAddresses(address[] _addresses, uint256[] _amounts) canTransfer public returns (bool) {\n', '    for (uint256 i = 0; i < _addresses.length; i++) {\n', '      require(_addresses[i] != address(0));\n', '      require(_amounts[i] <= balances[msg.sender]);\n', '      require(_amounts[i] > 0);\n', '\n', '      // SafeMath.sub will throw if there is not enough balance.\n', '      balances[msg.sender] = balances[msg.sender].sub(_amounts[i]);\n', '      balances[_addresses[i]] = balances[_addresses[i]].add(_amounts[i]);\n', '      Transfer(msg.sender, _addresses[i], _amounts[i]);\n', '    }\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() only(ifoodDev) canMint public returns (bool) {\n', '    mintingFinished = true;\n', '    MintFinished(msg.sender);\n', '    return true;\n', '  }\n', '\n', '  function getCurrentBlockNumber() private view returns (uint256) {\n', '    return block.number;\n', '  }\n', '\n', '  function () public payable {\n', '    revert();\n', '  }\n', '\n', '}']
