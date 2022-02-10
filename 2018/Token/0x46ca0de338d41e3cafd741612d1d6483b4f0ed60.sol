['pragma solidity ^0.4.20;\n', '\n', '/**\n', ' * @title ContractReceiver\n', ' * @dev Receiver for ERC223 tokens\n', ' */\n', 'contract ContractReceiver {\n', '\n', '  struct TKN {\n', '    address sender;\n', '    uint value;\n', '    bytes data;\n', '    bytes4 sig;\n', '  }\n', '\n', '  function tokenFallback(address _from, uint _value, bytes _data) public pure {\n', '    TKN memory tkn;\n', '    tkn.sender = _from;\n', '    tkn.value = _value;\n', '    tkn.data = _data;\n', '    uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);\n', '    tkn.sig = bytes4(u);\n', '\n', '    /* tkn variable is analogue of msg variable of Ether transaction\n', '    *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)\n', '    *  tkn.value the number of tokens that were sent   (analogue of msg.value)\n', '    *  tkn.data is data of token transaction   (analogue of msg.data)\n', '    *  tkn.sig is 4 bytes signature of function\n', '    *  if data of token transaction is a function execution\n', '    */\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC223 {\n', '  uint public totalSupply;\n', '\n', '  function name() public view returns (string _name);\n', '  function symbol() public view returns (string _symbol);\n', '  function decimals() public view returns (uint8 _decimals);\n', '  function totalSupply() public view returns (uint256 _supply);\n', '  function balanceOf(address who) public view returns (uint);\n', '\n', '  function transfer(address to, uint value) public returns (bool ok);\n', '  function transfer(address to, uint value, bytes data) public returns (bool ok);\n', '  function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);\n', '  event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '}\n', '\n', '// CLIP TOKEN\n', '/**\n', '\n', '                                      .--:///++++++++++///:--.                                     \n', '                                .-:/+++++++++++++++++++++++++++++/:.                                \n', '                            -:++++++++++++++++++++++++++++++++++++++++/-.                           \n', '                        .:/+++++++++++++++++++++++++++++++++++++++++++++++:.                        \n', '                     .:++++++++++++++++++++++++++++++++++++++++++++++++++++++:.                     \n', '                   -/++++++++++++++++++++++++++++++++++++++++++++++++++++++++++/-                  \n', '                 -+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++/-                   \n', '               -+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++/-`                    \n', '             -/++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++/-`                      \n', '            /++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++/.          .--           \n', '          -++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++/.          .-::::.          \n', '         :+++++++++++++++++++++++++++++++//::-........--://++++++++++/.          .-:::::::-         \n', '        /++++++++++++++++++++++++++++/:.``                ``.:/++++/.         `.-::::::::::-       \n', '       /++++++++++++++++++++++++++/-.                          `-:.         `.:::::::::::::::      \n', '      /+++++++++++++++++++++++++/.                                        `.::::::::::::::::::     \n', '     :++++++++++++++++++++++++/.                                        `.::::::::::::::::::::-     \n', '    -++++++++++++++++++++++++-                                         .:::::::::::::::::::::::-    \n', '    +++++++++++++++++++++++/`                                           -:::::::::::::::::::::::   \n', '   :++++++++++++++++++++++/`                                             .::::::::::::::::::::::-   \n', '   ++++++++++++++++++++++/`                                               -::::::::::::::::::::::  \n', '  -++++++++++++++++++++++.                       ..........................::::::::::::::::::::::-  \n', '  /+++++++++++++++++++++:                       `:::::::::::::::::::::::::::::::::::::::::::::::::  \n', '  ++++++++++++++++++++++.                       `::::::::::::::::::::::::::::::::::::::::::::::::: \n', '  ++++++++++++++++++++++`                       `::::::::::::::::::::::::::::::::::::::::::::::::: \n', '  ++++++++++++++++++++++                        `::::::::::::::::::::::::::::::::::::::::::::::::: \n', '  ++++++++++++++++++++++`                       `::::::::::::::::::::::::::::::::::::::::::::::::: \n', '  ++++++++++++++++++++++`                       `::::::::::::::::::::::::::::::::::::::::::::::::: \n', '  /+++++++++++++++++++++:                       `:::::::::::::::::::::::::::::::::::::::::::::::::  \n', '  -++++++++++++++++++++++`                      `--------------------------:::::::::::::::::::::::  \n', '   ++++++++++++++++++++++/                                                .:::::::::::::::::::::::  \n', '   :++++++++++++++++++++++:                                              .:::::::::::::::::::::::   \n', '    +++++++++++++++++++++++:                                            .:::::::::::::::::::::::.   \n', '    :++++++++++++++++++++++.                                           .:::::::::::::::::::::::-    \n', '     /++++++++++++++++++++-                                             .::::::::::::::::::::::.    \n', '      +++++++++++++++++++-                                                .-::::::::::::::::::.     \n', '       +++++++++++++++++:                                       ..          .-:::::::::::::::.      \n', '        /++++++++++++++:        .-//+:-                      .:/++/.          .-::::::::::::.       \n', '         /++++++++++++:     .-/+++++++++//:-..        ..-://++++++++/.          .-:::::::::        \n', '          :++++++++++/` .:/+++++++++++++++++++++++++++++++++++++++++++/.          .-:::::-         \n', '           ./++++++++//+++++++++++++++++++++++++++++++++++++++++++++++++/-          .-::.           \n', '            `:++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++/-`         .`            \n', '              ./++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++/-`                     \n', '                ./++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++/-`                   \n', '                  `:++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++:                   \n', '                    `-/++++++++++++++++++++++++++++++++++++++++++++++++++++++/-`                    \n', '                       `-/++++++++++++++++++++++++++++++++++++++++++++++++/-.                       \n', '                          `.:/+++++++++++++++++++++++++++++++++++++++++:-`                          \n', '                              `.-:++++++++++++++++++++++++++++++++/:.`                              \n', '                                   ``.-://++++++++++++++++//:--.`                                   \n', '                                             ``````````                                                \n', '     \n', '             ::::::  ::    `::  :::::    ,,,,,,,  ,,,,,,    ,,   ,,, ,,,,,,  ,,.    ,,                   \n', '            :::,.,:  ::    `::  ::,:::   ,,,,,,, ,,,,,,,,`  ,,  ,,,  ,,,,,,  ,,,    ,,                   \n', '           ,::       ::    `::  ::  ::     ,,   .,,    ,,,  ,, .,,   ,,      ,,,,   ,,                   \n', '           ::`       ::    `::  ::  ::     ,,   ,,,     ,,` ,, ,,    ,,      ,,,,,  ,,                   \n', '           ::        ::    `::  ::::::     ,,   ,,      ,,, ,,,,,    ,,,,,,  ,, ,,, ,,                   \n', '           ::        ::    `::  :::::      ,,   ,,      ,,, ,,`,,    ,,,,,,  ,, `,, ,,                   \n', '           ::.       ::    `::  ::         ,,   ,,,     ,,  ,, ,,,   ,,      ,,  ,,,,,                   \n', '           .::       ::    `::  ::         ,,    ,,.   ,,,  ,,  ,,,  ,,      ,,   ,,,,                   \n', '            ,::::::  :::::,`::  ::         ,,    .,,,,,,,   ,,  `,,  ,,,,,,  ,,    ,,,                   \n', '             .:::::  :::::,`::  ::         ,,      ,,,,,    ,,   ,,, ,,,,,,  ,,     ,,                   \n', '                                                                                                               \n', '                                                                                             \n', '\n', ' */\n', '\n', '\n', 'contract ClipToken is ERC223, Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  string public name = "ClipToken";\n', '  string public symbol = "CLIP";\n', '  uint8 public decimals = 8;\n', '  uint256 public initialSupply = 280e8 * 1e8;\n', '  uint256 public totalSupply;\n', '  uint256 public distributeAmount = 0;\n', '  bool public mintingFinished = false;\n', '\n', '  mapping (address => uint) balances;\n', '  mapping (address => bool) public frozenAccount;\n', '  mapping (address => uint256) public unlockUnixTime;\n', '\n', '  event FrozenFunds(address indexed target, bool frozen);\n', '  event LockedFunds(address indexed target, uint256 locked);\n', '  event Burn(address indexed burner, uint256 value);\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  function Excalibur() public {\n', '    totalSupply = initialSupply;\n', '    balances[msg.sender] = totalSupply;\n', '  }\n', '\n', '  function name() public view returns (string _name) {\n', '      return name;\n', '  }\n', '\n', '  function symbol() public view returns (string _symbol) {\n', '      return symbol;\n', '  }\n', '\n', '  function decimals() public view returns (uint8 _decimals) {\n', '      return decimals;\n', '  }\n', '\n', '  function totalSupply() public view returns (uint256 _totalSupply) {\n', '      return totalSupply;\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  modifier onlyPayloadSize(uint256 size){\n', '    assert(msg.data.length >= size + 4);\n', '    _;\n', '  }\n', '\n', '  // Function that is called when a user or another contract wants to transfer funds .\n', '  function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {\n', '    require(_value > 0\n', '            && frozenAccount[msg.sender] == false\n', '            && frozenAccount[_to] == false\n', '            && now > unlockUnixTime[msg.sender]\n', '            && now > unlockUnixTime[_to]);\n', '\n', '    if(isContract(_to)) {\n', '        if (balanceOf(msg.sender) < _value) revert();\n', '        balances[msg.sender] = SafeMath.sub(balanceOf(msg.sender), _value);\n', '        balances[_to] = SafeMath.add(balanceOf(_to), _value);\n', '        assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));\n', '        Transfer(msg.sender, _to, _value, _data);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    else {\n', '        return transferToAddress(_to, _value, _data);\n', '    }\n', '  }\n', '\n', '\n', '  // Function that is called when a user or another contract wants to transfer funds .\n', '  function transfer(address _to, uint _value, bytes _data) public returns (bool success) {\n', '    require(_value > 0\n', '            && frozenAccount[msg.sender] == false\n', '            && frozenAccount[_to] == false\n', '            && now > unlockUnixTime[msg.sender]\n', '            && now > unlockUnixTime[_to]);\n', '\n', '    if(isContract(_to)) {\n', '        return transferToContract(_to, _value, _data);\n', '    }\n', '    else {\n', '        return transferToAddress(_to, _value, _data);\n', '    }\n', '  }\n', '\n', '  // Standard function transfer similar to ERC20 transfer with no _data .\n', '  // Added due to backwards compatibility reasons .\n', '  function transfer(address _to, uint _value) public returns (bool success) {\n', '    require(_value > 0\n', '            && frozenAccount[msg.sender] == false\n', '            && frozenAccount[_to] == false\n', '            && now > unlockUnixTime[msg.sender]\n', '            && now > unlockUnixTime[_to]);\n', '\n', '    //standard function transfer similar to ERC20 transfer with no _data\n', '    //added due to backwards compatibility reasons\n', '    bytes memory empty;\n', '    if(isContract(_to)) {\n', '        return transferToContract(_to, _value, empty);\n', '    }\n', '    else {\n', '        return transferToAddress(_to, _value, empty);\n', '    }\n', '  }\n', '\n', '  // assemble the given address bytecode. If bytecode exists then the _addr is a contract.\n', '  function isContract(address _addr) private view returns (bool is_contract) {\n', '    uint length;\n', '    assembly {\n', '      // retrieve the size of the code on target address, this needs assembly\n', '      length := extcodesize(_addr)\n', '    }\n', '    return (length>0);\n', '  }\n', '\n', '  // function that is called when transaction target is an address\n', '  function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {\n', '    if (balanceOf(msg.sender) < _value) revert();\n', '    balances[msg.sender] = SafeMath.sub(balanceOf(msg.sender), _value);\n', '    balances[_to] = SafeMath.add(balanceOf(_to), _value);\n', '    Transfer(msg.sender, _to, _value, _data);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  //function that is called when transaction target is a contract\n', '  function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {\n', '    if (balanceOf(msg.sender) < _value) revert();\n', '    balances[msg.sender] = SafeMath.sub(balanceOf(msg.sender), _value);\n', '    balances[_to] = SafeMath.add(balanceOf(_to), _value);\n', '    ContractReceiver receiver = ContractReceiver(_to);\n', '    receiver.tokenFallback(msg.sender, _value, _data);\n', '    Transfer(msg.sender, _to, _value, _data);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Prevent targets from sending or receiving tokens\n', '   * @param targets Addresses to be frozen\n', '   * @param isFrozen either to freeze it or not\n', '   */\n', '  function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {\n', '    require(targets.length > 0);\n', '\n', '    for (uint i = 0; i < targets.length; i++) {\n', '      require(targets[i] != 0x0);\n', '      frozenAccount[targets[i]] = isFrozen;\n', '      FrozenFunds(targets[i], isFrozen);\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Prevent targets from sending or receiving tokens by setting Unix times\n', '   * @param targets Addresses to be locked funds\n', '   * @param unixTimes Unix times when locking up will be finished\n', '   */\n', '  function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {\n', '    require(targets.length > 0\n', '            && targets.length == unixTimes.length);\n', '\n', '    for(uint i = 0; i < targets.length; i++){\n', '      require(unlockUnixTime[targets[i]] < unixTimes[i]);\n', '      unlockUnixTime[targets[i]] = unixTimes[i];\n', '      LockedFunds(targets[i], unixTimes[i]);\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Burns a specific amount of tokens.\n', '   * @param _from The address that will burn the tokens.\n', '   * @param _unitAmount The amount of token to be burned.\n', '   */\n', '  function burn(address _from, uint256 _unitAmount) onlyOwner public {\n', '    require(_unitAmount > 0\n', '            && balanceOf(_from) >= _unitAmount);\n', '\n', '    balances[_from] = SafeMath.sub(balances[_from], _unitAmount);\n', '    totalSupply = SafeMath.sub(totalSupply, _unitAmount);\n', '    Burn(_from, _unitAmount);\n', '  }\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _unitAmount The amount of tokens to mint.\n', '   */\n', '  function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {\n', '    require(_unitAmount > 0);\n', '\n', '    totalSupply = SafeMath.add(totalSupply, _unitAmount);\n', '    balances[_to] = SafeMath.add(balances[_to], _unitAmount);\n', '    Mint(_to, _unitAmount);\n', '    Transfer(address(0), _to, _unitAmount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   */\n', '  function finishMinting() onlyOwner canMint public returns (bool) {\n', '    mintingFinished = true;\n', '    MintFinished();\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to distribute tokens to the list of addresses by the provided amount\n', '   */\n', '  function distributeTokens(address[] addresses, uint256 amount) public returns (bool) {\n', '    require(amount > 0\n', '            && addresses.length > 0\n', '            && frozenAccount[msg.sender] == false\n', '            && now > unlockUnixTime[msg.sender]);\n', '\n', '    amount = SafeMath.mul(amount, 1e8);\n', '    uint256 totalAmount = SafeMath.mul(amount, addresses.length);\n', '    require(balances[msg.sender] >= totalAmount);\n', '\n', '    for (uint i = 0; i < addresses.length; i++) {\n', '      require(addresses[i] != 0x0\n', '              && frozenAccount[addresses[i]] == false\n', '              && now > unlockUnixTime[addresses[i]]);\n', '\n', '      balances[addresses[i]] = SafeMath.add(balances[addresses[i]], amount);\n', '      Transfer(msg.sender, addresses[i], amount);\n', '    }\n', '    balances[msg.sender] = SafeMath.sub(balances[msg.sender], totalAmount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to collect tokens from the list of addresses\n', '   */\n', '  function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {\n', '    require(addresses.length > 0\n', '            && addresses.length == amounts.length);\n', '\n', '    uint256 totalAmount = 0;\n', '\n', '    for (uint i = 0; i < addresses.length; i++) {\n', '      require(amounts[i] > 0\n', '              && addresses[i] != 0x0\n', '              && frozenAccount[addresses[i]] == false\n', '              && now > unlockUnixTime[addresses[i]]);\n', '\n', '      amounts[i] = SafeMath.mul(amounts[i], 1e8);\n', '      require(balances[addresses[i]] >= amounts[i]);\n', '      balances[addresses[i]] = SafeMath.sub(balances[addresses[i]], amounts[i]);\n', '      totalAmount = SafeMath.add(totalAmount, amounts[i]);\n', '      Transfer(addresses[i], msg.sender, amounts[i]);\n', '    }\n', '    balances[msg.sender] = SafeMath.add(balances[msg.sender], totalAmount);\n', '    return true;\n', '  }\n', '\n', '  function setDistributeAmount(uint256 _unitAmount) onlyOwner public {\n', '    distributeAmount = _unitAmount;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to distribute tokens to the msg.sender automatically\n', '   *      If distributeAmount is 0, this function doesn&#39;t work\n', '   */\n', '  function autoDistribute() payable public {\n', '    require(distributeAmount > 0\n', '            && balanceOf(owner) >= distributeAmount\n', '            && frozenAccount[msg.sender] == false\n', '            && now > unlockUnixTime[msg.sender]);\n', '    if (msg.value > 0) owner.transfer(msg.value);\n', '\n', '    balances[owner] = SafeMath.sub(balances[owner], distributeAmount);\n', '    balances[msg.sender] = SafeMath.add(balances[msg.sender], distributeAmount);\n', '    Transfer(owner, msg.sender, distributeAmount);\n', '  }\n', '\n', '  /**\n', '   * @dev token fallback function\n', '   */\n', '  function() payable public {\n', '    autoDistribute();\n', '  }\n', '}']