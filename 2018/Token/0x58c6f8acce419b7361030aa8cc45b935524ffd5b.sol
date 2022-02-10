['pragma solidity ^0.4.24;\n', '\n', '\n', '\n', '/* ********** Zeppelin Solidity - v1.3.0 ********** */\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '\n', '    uint256 _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   */\n', '  function increaseApproval (address _spender, uint _addedValue)\n', '    returns (bool success) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval (address _spender, uint _subtractedValue)\n', '    returns (bool success) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/* ********** RxEAL Token Contract ********** */\n', '\n', '\n', '\n', '/**\n', ' * @title RxEALTokenContract\n', ' * @author RxEAL.com\n', ' *\n', ' * ERC20 Compatible token\n', ' * Zeppelin Solidity - v1.3.0\n', ' */\n', '\n', 'contract RxEALTokenContract is StandardToken {\n', '\n', '  /* ********** Token Predefined Information ********** */\n', '\n', '  // Predefine token info\n', '  string public constant name = "RxEAL";\n', '  string public constant symbol = "RXL";\n', '  uint256 public constant decimals = 18;\n', '\n', '  /* ********** Defined Variables ********** */\n', '\n', '  // Total tokens supply 96 000 000\n', '  // For ethereum wallets we added decimals constant\n', '  uint256 public constant INITIAL_SUPPLY = 96000000 * (10 ** decimals);\n', '  // Vault where tokens are stored\n', '  address public vault = this;\n', '  // Sale agent who has permissions to sell tokens\n', '  address public salesAgent;\n', '  // Array of token owners\n', '  mapping (address => bool) public owners;\n', '\n', '  /* ********** Events ********** */\n', '\n', '  // Contract events\n', '  event OwnershipGranted(address indexed _owner, address indexed revoked_owner);\n', '  event OwnershipRevoked(address indexed _owner, address indexed granted_owner);\n', '  event SalesAgentPermissionsTransferred(address indexed previousSalesAgent, address indexed newSalesAgent);\n', '  event SalesAgentRemoved(address indexed currentSalesAgent);\n', '  event Burn(uint256 value);\n', '\n', '  /* ********** Modifiers ********** */\n', '\n', '  // Throws if called by any account other than the owner\n', '  modifier onlyOwner() {\n', '    require(owners[msg.sender] == true);\n', '    _;\n', '  }\n', '\n', '  /* ********** Functions ********** */\n', '\n', '  // Constructor\n', '  function RxEALTokenContract() {\n', '    owners[msg.sender] = true;\n', '    totalSupply = INITIAL_SUPPLY;\n', '    balances[vault] = totalSupply;\n', '  }\n', '\n', '  // Allows the current owner to grant control of the contract to another account\n', '  function grantOwnership(address _owner) onlyOwner public {\n', '    require(_owner != address(0));\n', '    owners[_owner] = true;\n', '    OwnershipGranted(msg.sender, _owner);\n', '  }\n', '\n', '  // Allow the current owner to revoke control of the contract from another owner\n', '  function revokeOwnership(address _owner) onlyOwner public {\n', '    require(_owner != msg.sender);\n', '    owners[_owner] = false;\n', '    OwnershipRevoked(msg.sender, _owner);\n', '  }\n', '\n', '  // Transfer sales agent permissions to another account\n', '  function transferSalesAgentPermissions(address _salesAgent) onlyOwner public {\n', '    SalesAgentPermissionsTransferred(salesAgent, _salesAgent);\n', '    salesAgent = _salesAgent;\n', '  }\n', '\n', '  // Remove sales agent from token\n', '  function removeSalesAgent() onlyOwner public {\n', '    SalesAgentRemoved(salesAgent);\n', '    salesAgent = address(0);\n', '  }\n', '\n', '  // Transfer tokens from vault to account if sales agent is correct\n', '  function transferTokensFromVault(address _from, address _to, uint256 _amount) public {\n', '    require(salesAgent == msg.sender);\n', '    balances[vault] = balances[vault].sub(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Transfer(_from, _to, _amount);\n', '  }\n', '\n', '  // Allow the current owner to burn a specific amount of tokens from the vault\n', '  function burn(uint256 _value) onlyOwner public {\n', '    require(_value > 0);\n', '    balances[vault] = balances[vault].sub(_value);\n', '    totalSupply = totalSupply.sub(_value);\n', '    Burn(_value);\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/* ********** RxEAL Distribution Contract ********** */\n', '\n', '\n', '\n', 'contract RxEALDistributionTokens {\n', '\n', '  address public owner;\n', '  RxEALTokenContract internal token;\n', '\n', '  address[] internal addresses = [\n', '    0x2a3B2C39AE3958B875033349fd573eD14886C2Ee,\n', '    0x2d039F29929f2560e66A4A41656CBdE3D877951D,\n', '    0x44b12554bDB95c40fd7A58d5745c8B33ab20e7B3\n', '  ];\n', '\n', '  uint256[] internal values = [\n', '    600,\n', '    600,\n', '    1800\n', '  ];\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '    token = RxEALTokenContract(0xD6682Db9106e0cfB530B697cA0EcDC8F5597CD15);\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    owner = _newOwner;\n', '  }\n', '\n', '  function _distribution(address[] _to, uint256[] _value) internal {\n', '    assert(_to.length == _value.length);\n', '    assert(_to.length <= 1000);\n', '\n', '    for (uint8 i = 0; i < _to.length; i++) {\n', '      uint256 _real_value = _value[i] * (10 ** token.decimals());\n', '      token.transferTokensFromVault(msg.sender, _to[i], _real_value);\n', '    }\n', '  }\n', '\n', '  function distributeTokens() public onlyOwner {\n', '    _distribution(addresses, values);\n', '  }\n', '\n', '  function distributeTokens2(address[] _to, uint256[] _value) public onlyOwner {\n', '    _distribution(_to, _value);\n', '  }\n', '\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '\n', '\n', '/* ********** Zeppelin Solidity - v1.3.0 ********** */\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '\n', '    uint256 _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   */\n', '  function increaseApproval (address _spender, uint _addedValue)\n', '    returns (bool success) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval (address _spender, uint _subtractedValue)\n', '    returns (bool success) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/* ********** RxEAL Token Contract ********** */\n', '\n', '\n', '\n', '/**\n', ' * @title RxEALTokenContract\n', ' * @author RxEAL.com\n', ' *\n', ' * ERC20 Compatible token\n', ' * Zeppelin Solidity - v1.3.0\n', ' */\n', '\n', 'contract RxEALTokenContract is StandardToken {\n', '\n', '  /* ********** Token Predefined Information ********** */\n', '\n', '  // Predefine token info\n', '  string public constant name = "RxEAL";\n', '  string public constant symbol = "RXL";\n', '  uint256 public constant decimals = 18;\n', '\n', '  /* ********** Defined Variables ********** */\n', '\n', '  // Total tokens supply 96 000 000\n', '  // For ethereum wallets we added decimals constant\n', '  uint256 public constant INITIAL_SUPPLY = 96000000 * (10 ** decimals);\n', '  // Vault where tokens are stored\n', '  address public vault = this;\n', '  // Sale agent who has permissions to sell tokens\n', '  address public salesAgent;\n', '  // Array of token owners\n', '  mapping (address => bool) public owners;\n', '\n', '  /* ********** Events ********** */\n', '\n', '  // Contract events\n', '  event OwnershipGranted(address indexed _owner, address indexed revoked_owner);\n', '  event OwnershipRevoked(address indexed _owner, address indexed granted_owner);\n', '  event SalesAgentPermissionsTransferred(address indexed previousSalesAgent, address indexed newSalesAgent);\n', '  event SalesAgentRemoved(address indexed currentSalesAgent);\n', '  event Burn(uint256 value);\n', '\n', '  /* ********** Modifiers ********** */\n', '\n', '  // Throws if called by any account other than the owner\n', '  modifier onlyOwner() {\n', '    require(owners[msg.sender] == true);\n', '    _;\n', '  }\n', '\n', '  /* ********** Functions ********** */\n', '\n', '  // Constructor\n', '  function RxEALTokenContract() {\n', '    owners[msg.sender] = true;\n', '    totalSupply = INITIAL_SUPPLY;\n', '    balances[vault] = totalSupply;\n', '  }\n', '\n', '  // Allows the current owner to grant control of the contract to another account\n', '  function grantOwnership(address _owner) onlyOwner public {\n', '    require(_owner != address(0));\n', '    owners[_owner] = true;\n', '    OwnershipGranted(msg.sender, _owner);\n', '  }\n', '\n', '  // Allow the current owner to revoke control of the contract from another owner\n', '  function revokeOwnership(address _owner) onlyOwner public {\n', '    require(_owner != msg.sender);\n', '    owners[_owner] = false;\n', '    OwnershipRevoked(msg.sender, _owner);\n', '  }\n', '\n', '  // Transfer sales agent permissions to another account\n', '  function transferSalesAgentPermissions(address _salesAgent) onlyOwner public {\n', '    SalesAgentPermissionsTransferred(salesAgent, _salesAgent);\n', '    salesAgent = _salesAgent;\n', '  }\n', '\n', '  // Remove sales agent from token\n', '  function removeSalesAgent() onlyOwner public {\n', '    SalesAgentRemoved(salesAgent);\n', '    salesAgent = address(0);\n', '  }\n', '\n', '  // Transfer tokens from vault to account if sales agent is correct\n', '  function transferTokensFromVault(address _from, address _to, uint256 _amount) public {\n', '    require(salesAgent == msg.sender);\n', '    balances[vault] = balances[vault].sub(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Transfer(_from, _to, _amount);\n', '  }\n', '\n', '  // Allow the current owner to burn a specific amount of tokens from the vault\n', '  function burn(uint256 _value) onlyOwner public {\n', '    require(_value > 0);\n', '    balances[vault] = balances[vault].sub(_value);\n', '    totalSupply = totalSupply.sub(_value);\n', '    Burn(_value);\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/* ********** RxEAL Distribution Contract ********** */\n', '\n', '\n', '\n', 'contract RxEALDistributionTokens {\n', '\n', '  address public owner;\n', '  RxEALTokenContract internal token;\n', '\n', '  address[] internal addresses = [\n', '    0x2a3B2C39AE3958B875033349fd573eD14886C2Ee,\n', '    0x2d039F29929f2560e66A4A41656CBdE3D877951D,\n', '    0x44b12554bDB95c40fd7A58d5745c8B33ab20e7B3\n', '  ];\n', '\n', '  uint256[] internal values = [\n', '    600,\n', '    600,\n', '    1800\n', '  ];\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '    token = RxEALTokenContract(0xD6682Db9106e0cfB530B697cA0EcDC8F5597CD15);\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    owner = _newOwner;\n', '  }\n', '\n', '  function _distribution(address[] _to, uint256[] _value) internal {\n', '    assert(_to.length == _value.length);\n', '    assert(_to.length <= 1000);\n', '\n', '    for (uint8 i = 0; i < _to.length; i++) {\n', '      uint256 _real_value = _value[i] * (10 ** token.decimals());\n', '      token.transferTokensFromVault(msg.sender, _to[i], _real_value);\n', '    }\n', '  }\n', '\n', '  function distributeTokens() public onlyOwner {\n', '    _distribution(addresses, values);\n', '  }\n', '\n', '  function distributeTokens2(address[] _to, uint256[] _value) public onlyOwner {\n', '    _distribution(_to, _value);\n', '  }\n', '\n', '}']
