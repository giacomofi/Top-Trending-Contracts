['pragma solidity ^0.4.15;\n', '\n', '/**\n', ' * @title Ownable contract - base contract with an owner\n', ' */\n', 'contract Ownable {\n', '  \n', '  address public owner;\n', '  address public newOwner;\n', '\n', '  event OwnershipTransferred(address indexed _from, address indexed _to);\n', '  \n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    assert(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    assert(_newOwner != address(0));      \n', '    newOwner = _newOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Accept transferOwnership.\n', '   */\n', '  function acceptOwnership() public {\n', '    if (msg.sender == newOwner) {\n', '      OwnershipTransferred(owner, newOwner);\n', '      owner = newOwner;\n', '    }\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'contract SafeMath {\n', '\n', '  function sub(uint256 x, uint256 y) internal constant returns (uint256) {\n', '    uint256 z = x - y;\n', '    assert(z <= x);\n', '\t  return z;\n', '  }\n', '\n', '  function add(uint256 x, uint256 y) internal constant returns (uint256) {\n', '    uint256 z = x + y;\n', '\t  assert(z >= x);\n', '\t  return z;\n', '  }\n', '\t\n', '  function div(uint256 x, uint256 y) internal constant returns (uint256) {\n', '    uint256 z = x / y;\n', '\t  return z;\n', '  }\n', '\t\n', '  function mul(uint256 x, uint256 y) internal constant returns (uint256) {\n', '    uint256 z = x * y;\n', '    assert(x == 0 || z / x == y);\n', '    return z;\n', '  }\n', '\n', '  function min(uint256 x, uint256 y) internal constant returns (uint256) {\n', '    uint256 z = x <= y ? x : y;\n', '\t  return z;\n', '  }\n', '\n', '  function max(uint256 x, uint256 y) internal constant returns (uint256) {\n', '    uint256 z = x >= y ? x : y;\n', '\t  return z;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '\tfunction totalSupply() public constant returns (uint);\n', '\tfunction balanceOf(address owner) public constant returns (uint);\n', '\tfunction allowance(address owner, address spender) public constant returns (uint);\n', '\tfunction transfer(address to, uint value) public returns (bool success);\n', '\tfunction transferFrom(address from, address to, uint value) public returns (bool success);\n', '\tfunction approve(address spender, uint value) public returns (bool success);\n', '\tfunction mint(address to, uint value) public returns (bool success);\n', '\tevent Transfer(address indexed from, address indexed to, uint value);\n', '\tevent Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, SafeMath, Ownable{\n', '\t\n', '  uint256 _totalSupply;\n', '  mapping (address => uint256) balances;\n', '  mapping (address => mapping (address => uint256)) approvals;\n', '  address public crowdsaleAgent;\n', '  bool public released = false;  \n', '  \n', '  /**\n', '   * @dev Fix for the ERC20 short address attack http://vessenes.com/the-erc20-short-address-attack-explained/\n', '   * @param numwords payload size  \n', '   */\n', '  modifier onlyPayloadSize(uint numwords) {\n', '    assert(msg.data.length == numwords * 32 + 4);\n', '    _;\n', '  }\n', '  \n', '  /**\n', '   * @dev The function can be called only by crowdsale agent.\n', '   */\n', '  modifier onlyCrowdsaleAgent() {\n', '    assert(msg.sender == crowdsaleAgent);\n', '    _;\n', '  }\n', '\n', '  /** Limit token mint after finishing crowdsale\n', '   * @dev Make sure we are not done yet.\n', '   */\n', '  modifier canMint() {\n', '    assert(!released);\n', '    _;\n', '  }\n', '  \n', '  /**\n', '   * @dev Limit token transfer until the crowdsale is over.\n', '   */\n', '  modifier canTransfer() {\n', '    assert(released);\n', '    _;\n', '  } \n', '  \n', '  /** \n', '   * @dev Total Supply\n', '   * @return _totalSupply \n', '   */  \n', '  function totalSupply() public constant returns (uint256) {\n', '    return _totalSupply;\n', '  }\n', '  \n', '  /** \n', '   * @dev Tokens balance\n', '   * @param _owner holder address\n', '   * @return balance amount \n', '   */\n', '  function balanceOf(address _owner) public constant returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '  \n', '  /** \n', '   * @dev Token allowance\n', '   * @param _owner holder address\n', '   * @param _spender spender address\n', '   * @return remain amount\n', '   */   \n', '  function allowance(address _owner, address _spender) public constant returns (uint256) {\n', '    return approvals[_owner][_spender];\n', '  }\n', '\n', '  /** \n', '   * @dev Tranfer tokens to address\n', '   * @param _to dest address\n', '   * @param _value tokens amount\n', '   * @return transfer result\n', '   */   \n', '  function transfer(address _to, uint _value) public canTransfer onlyPayloadSize(2) returns (bool success) {\n', '    assert(balances[msg.sender] >= _value);\n', '    balances[msg.sender] = sub(balances[msg.sender], _value);\n', '    balances[_to] = add(balances[_to], _value);\n', '    \n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '  \n', '  /**    \n', '   * @dev Tranfer tokens from one address to other\n', '   * @param _from source address\n', '   * @param _to dest address\n', '   * @param _value tokens amount\n', '   * @return transfer result\n', '   */    \n', '  function transferFrom(address _from, address _to, uint _value) public canTransfer onlyPayloadSize(3) returns (bool success) {\n', '    assert(balances[_from] >= _value);\n', '    assert(approvals[_from][msg.sender] >= _value);\n', '    approvals[_from][msg.sender] = sub(approvals[_from][msg.sender], _value);\n', '    balances[_from] = sub(balances[_from], _value);\n', '    balances[_to] = add(balances[_to], _value);\n', '    \n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '  \n', '  /** \n', '   * @dev Approve transfer\n', '   * @param _spender holder address\n', '   * @param _value tokens amount\n', '   * @return result  \n', '   */\n', '  function approve(address _spender, uint _value) public onlyPayloadSize(2) returns (bool success) {\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  approvals to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    assert((_value == 0) || (approvals[msg.sender][_spender] == 0));\n', '    approvals[msg.sender][_spender] = _value;\n', '    \n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '  \n', '  /** \n', '   * @dev Create new tokens and allocate them to an address. Only callably by a crowdsale contract\n', '   * @param _to dest address\n', '   * @param _value tokens amount\n', '   * @return mint result\n', '   */ \n', '  function mint(address _to, uint _value) public onlyCrowdsaleAgent canMint onlyPayloadSize(2) returns (bool success) {\n', '    _totalSupply = add(_totalSupply, _value);\n', '    balances[_to] = add(balances[_to], _value);\n', '    \n', '    Transfer(0, _to, _value);\n', '    return true;\n', '  }\n', '  \n', '  /**\n', '   * @dev Set the contract that can call release and make the token transferable.\n', '   * @param _crowdsaleAgent crowdsale contract address\n', '   */\n', '  function setCrowdsaleAgent(address _crowdsaleAgent) public onlyOwner {\n', '    assert(!released);\n', '    crowdsaleAgent = _crowdsaleAgent;\n', '  }\n', '  \n', '  /**\n', '   * @dev One way function to release the tokens to the wild. Can be called only from the release agent that is the final ICO contract. \n', '   */\n', '  function releaseTokenTransfer() public onlyCrowdsaleAgent {\n', '    released = true;\n', '  }\n', '}\n', '\n', '\n', '/** \n', ' * @title DAOPlayMarket2.0 contract - standard ERC20 token with Short Hand Attack and approve() race condition mitigation.\n', ' */\n', 'contract DAOPlayMarketToken is StandardToken {\n', '  \n', '  string public name;\n', '  string public symbol;\n', '  uint public decimals;\n', '  \n', '  /** Name and symbol were updated. */\n', '  event UpdatedTokenInformation(string newName, string newSymbol);\n', '\n', '  /**\n', '   * Construct the token.\n', '   *\n', '   * This token must be created through a team multisig wallet, so that it is owned by that wallet.\n', '   *\n', '   * @param _name Token name\n', '   * @param _symbol Token symbol - should be all caps\n', '   * @param _initialSupply How many tokens we start with\n', '   * @param _decimals Number of decimal places\n', "   * @param _addr Address for team's tokens\n", '   */\n', '   \n', '  function DAOPlayMarketToken(string _name, string _symbol, uint _initialSupply, uint _decimals, address _addr) public {\n', '    require(_addr != 0x0);\n', '    name = _name;\n', '    symbol = _symbol;\n', '    decimals = _decimals;\n', '\t\n', '    _totalSupply = _initialSupply*10**_decimals;\n', '\n', '    // Creating initial tokens\n', '    balances[_addr] = _totalSupply;\n', '  }   \n', '  \n', '   /**\n', '   * Owner can update token information here.\n', '   *\n', '   * It is often useful to conceal the actual token association, until\n', '   * the token operations, like central issuance or reissuance have been completed.\n', '   *\n', '   * This function allows the token owner to rename the token after the operations\n', '   * have been completed and then point the audience to use the token contract.\n', '   */\n', '  function setTokenInformation(string _name, string _symbol) public onlyOwner {\n', '    name = _name;\n', '    symbol = _symbol;\n', '\n', '    UpdatedTokenInformation(name, symbol);\n', '  }\n', '\n', '}']