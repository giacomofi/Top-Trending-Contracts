['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '\n', '  function transfer(address _to, uint256 _value) returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool);\n', '  function approve(address spender, uint256 value) returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '  \n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', ' \n', '  function approve(address _spender, uint256 _value) returns (bool) {\n', '\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '   \n', '    \n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '//////////////////////////////////\n', '\n', 'contract token{ \n', '    function transfer(address receiver, uint amount){  } \n', '    \n', '}\n', '\n', 'contract SendTokensContract is Ownable,BasicToken {\n', '  using SafeMath for uint;\n', '  mapping (address => uint) public bals;\n', '  mapping (address => uint) public releaseTimes;\n', '  mapping (address => bytes32[]) public referenceCodes;\n', '  mapping (bytes32 => address[]) public referenceAddresses;\n', '  address public addressOfTokenUsedAsReward;\n', '  token tokenReward;\n', '\n', '  event TokensSent\n', '    (address to, uint256 value, uint256 timeStamp, bytes32 referenceCode);\n', '\n', '  function setTokenReward(address _tokenContractAddress) public onlyOwner {\n', '    tokenReward = token(_tokenContractAddress);\n', '    addressOfTokenUsedAsReward = _tokenContractAddress;\n', '  }\n', '\n', '  function sendTokens(address _to, \n', '    uint _value, \n', '    uint _timeStamp, \n', '    bytes32 _referenceCode) public onlyOwner {\n', '    bals[_to] = bals[_to].add(_value);\n', '    releaseTimes[_to] = _timeStamp;\n', '    referenceCodes[_to].push(_referenceCode);\n', '    referenceAddresses[_referenceCode].push(_to);\n', '    emit TokensSent(_to, _value, _timeStamp, _referenceCode);\n', '  }\n', '\n', '  function getReferenceCodesOfAddress(address _addr) public constant \n', '  returns (bytes32[] _referenceCodes) {\n', '    return referenceCodes[_addr];\n', '  }\n', '\n', '  function getReferenceAddressesOfCode(bytes32 _code) public constant\n', '  returns (address[] _addresses) {\n', '    return referenceAddresses[_code];\n', '  }\n', '\n', '  function withdrawTokens() public {\n', '    require(bals[msg.sender] > 0);\n', '    require(now >= releaseTimes[msg.sender]);\n', '    tokenReward.transfer(msg.sender,bals[msg.sender]);\n', '    //BasicToken.transfer(msg.sender,bals[msg.sender]);\n', '    bals[msg.sender] = 0;\n', '  }\n', '}\n', '\n', '//////////////////////////////////\n', '\n', '\n', 'contract RWSC is StandardToken,SendTokensContract {\n', '\n', '  string public constant name = "Real-World Smart Contract";\n', '  string public constant symbol = "RWSC";\n', '  uint256 public constant decimals = 18;\n', '  \n', '  uint256 public constant INITIAL_SUPPLY = 888888888 * 10 ** uint256(decimals);\n', '\n', '  \n', '  function RWSC() {\n', '    totalSupply = INITIAL_SUPPLY;\n', '    balances[msg.sender] = INITIAL_SUPPLY;\n', '    owner=msg.sender;\n', '  }\n', '  \n', '\n', '  function Airdrop(ERC20 token, address[] _addresses, uint256 amount) public {\n', '        for (uint256 i = 0; i < _addresses.length; i++) {\n', '            token.transfer(_addresses[i], amount);\n', '        }\n', '    }\n', ' \n', '\n', ' \n', '}']
['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '\n', '  function transfer(address _to, uint256 _value) returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool);\n', '  function approve(address spender, uint256 value) returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '  \n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', ' \n', '  function approve(address _spender, uint256 _value) returns (bool) {\n', '\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '   \n', '    \n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '//////////////////////////////////\n', '\n', 'contract token{ \n', '    function transfer(address receiver, uint amount){  } \n', '    \n', '}\n', '\n', 'contract SendTokensContract is Ownable,BasicToken {\n', '  using SafeMath for uint;\n', '  mapping (address => uint) public bals;\n', '  mapping (address => uint) public releaseTimes;\n', '  mapping (address => bytes32[]) public referenceCodes;\n', '  mapping (bytes32 => address[]) public referenceAddresses;\n', '  address public addressOfTokenUsedAsReward;\n', '  token tokenReward;\n', '\n', '  event TokensSent\n', '    (address to, uint256 value, uint256 timeStamp, bytes32 referenceCode);\n', '\n', '  function setTokenReward(address _tokenContractAddress) public onlyOwner {\n', '    tokenReward = token(_tokenContractAddress);\n', '    addressOfTokenUsedAsReward = _tokenContractAddress;\n', '  }\n', '\n', '  function sendTokens(address _to, \n', '    uint _value, \n', '    uint _timeStamp, \n', '    bytes32 _referenceCode) public onlyOwner {\n', '    bals[_to] = bals[_to].add(_value);\n', '    releaseTimes[_to] = _timeStamp;\n', '    referenceCodes[_to].push(_referenceCode);\n', '    referenceAddresses[_referenceCode].push(_to);\n', '    emit TokensSent(_to, _value, _timeStamp, _referenceCode);\n', '  }\n', '\n', '  function getReferenceCodesOfAddress(address _addr) public constant \n', '  returns (bytes32[] _referenceCodes) {\n', '    return referenceCodes[_addr];\n', '  }\n', '\n', '  function getReferenceAddressesOfCode(bytes32 _code) public constant\n', '  returns (address[] _addresses) {\n', '    return referenceAddresses[_code];\n', '  }\n', '\n', '  function withdrawTokens() public {\n', '    require(bals[msg.sender] > 0);\n', '    require(now >= releaseTimes[msg.sender]);\n', '    tokenReward.transfer(msg.sender,bals[msg.sender]);\n', '    //BasicToken.transfer(msg.sender,bals[msg.sender]);\n', '    bals[msg.sender] = 0;\n', '  }\n', '}\n', '\n', '//////////////////////////////////\n', '\n', '\n', 'contract RWSC is StandardToken,SendTokensContract {\n', '\n', '  string public constant name = "Real-World Smart Contract";\n', '  string public constant symbol = "RWSC";\n', '  uint256 public constant decimals = 18;\n', '  \n', '  uint256 public constant INITIAL_SUPPLY = 888888888 * 10 ** uint256(decimals);\n', '\n', '  \n', '  function RWSC() {\n', '    totalSupply = INITIAL_SUPPLY;\n', '    balances[msg.sender] = INITIAL_SUPPLY;\n', '    owner=msg.sender;\n', '  }\n', '  \n', '\n', '  function Airdrop(ERC20 token, address[] _addresses, uint256 amount) public {\n', '        for (uint256 i = 0; i < _addresses.length; i++) {\n', '            token.transfer(_addresses[i], amount);\n', '        }\n', '    }\n', ' \n', '\n', ' \n', '}']