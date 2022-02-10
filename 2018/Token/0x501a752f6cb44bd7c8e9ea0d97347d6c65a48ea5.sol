['pragma solidity ^0.4.18;\n', '\n', 'contract ERC20 {\n', '\n', '    // Events\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval( address indexed owner, address indexed spender, uint256 value);\n', '\n', '    // Stateless functions\n', '    function totalSupply() constant public returns (uint256 supply);\n', '    function balanceOf( address who ) constant public returns (uint256 value);\n', '    function allowance(address owner, address spender) constant public returns (uint value);\n', '\n', '    // Stateful functions\n', '    function transfer( address to, uint256 value) public returns (bool success);\n', '    function transferFrom( address from, address to, uint256 value) public returns (bool success);\n', '    function approve(address spender, uint256 value) public returns (bool success);\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    Unpause();\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' */\n', 'library SafeMath {\n', '\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '  \n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Whitelist\n', ' * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.\n', ' * @dev This simplifies the implementation of "user permissions".\n', ' */\n', 'contract Whitelist is Ownable {\n', '  mapping(address => bool) public whitelist;\n', '  \n', '  event WhitelistedAddressAdded(address addr);\n', '  event WhitelistedAddressRemoved(address addr);\n', '\n', '  /**\n', '   * @dev Throws if called by any account that&#39;s not whitelisted.\n', '   */\n', '  modifier onlyWhitelisted() {\n', '    require(whitelist[msg.sender]);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev add an address to the whitelist\n', '   * @param addr address\n', '   * @return true if the address was added to the whitelist, false if the address was already in the whitelist \n', '   */\n', '  function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {\n', '    if (!whitelist[addr]) {\n', '      whitelist[addr] = true;\n', '      WhitelistedAddressAdded(addr);\n', '      success = true; \n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev add addresses to the whitelist\n', '   * @param addrs addresses\n', '   * @return true if at least one address was added to the whitelist, \n', '   * false if all addresses were already in the whitelist  \n', '   */\n', '  function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {\n', '    for (uint256 i = 0; i < addrs.length; i++) {\n', '      if (addAddressToWhitelist(addrs[i])) {\n', '        success = true;\n', '      }\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev remove an address from the whitelist\n', '   * @param addr address\n', '   * @return true if the address was removed from the whitelist, \n', '   * false if the address wasn&#39;t in the whitelist in the first place \n', '   */\n', '  function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {\n', '    if (whitelist[addr]) {\n', '      whitelist[addr] = false;\n', '      WhitelistedAddressRemoved(addr);\n', '      success = true;\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev remove addresses from the whitelist\n', '   * @param addrs addresses\n', '   * @return true if at least one address was removed from the whitelist, \n', '   * false if all addresses weren&#39;t in the whitelist in the first place\n', '   */\n', '  function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {\n', '    for (uint256 i = 0; i < addrs.length; i++) {\n', '      if (removeAddressFromWhitelist(addrs[i])) {\n', '        success = true;\n', '      }\n', '    }\n', '  }\n', '\n', '}\n', '\n', 'contract TalentCoin is ERC20, Ownable, Whitelist, Pausable{\n', '  \n', '  using SafeMath for uint256;\n', '\n', '  mapping (address => bool) admins;  // Mapping of who is an admin\n', '  mapping( address => uint256 ) balances;\n', '  mapping( address => mapping( address => uint256 ) ) approvals;\n', '  mapping( address => uint256 ) ratemapping;\n', '  //How much ETH each address has invested\n', '  mapping (address => uint) public investedAmountOf;\n', '  address public owner;\n', '  address public walletAddress;\n', '  uint256 public supply;\n', '  string public name;\n', '  uint256 public decimals;\n', '  string public symbol;\n', '  uint256 public rate;\n', '  uint public weiRaised;\n', '  uint public soldTokens;\n', '  uint public investorCount;\n', '  \n', '\n', '  function TalentCoin(address _walletAddress, uint256 _supply, string _name, uint256 _decimals, string _symbol, uint256 _rate ) public {\n', '    require(_walletAddress != 0x0);\n', '    balances[msg.sender] = _supply;\n', '    ratemapping[msg.sender] = _rate;\n', '    supply = _supply;\n', '    name = _name;\n', '    decimals = _decimals;\n', '    symbol = _symbol;\n', '    rate = _rate;\n', '    owner = msg.sender;\n', '    admins[msg.sender] = true;\n', '    walletAddress = _walletAddress;\n', '  }\n', '  \n', '    function () external payable {\n', '        createTokens();\n', '    }\n', '    \n', '    function createTokens() public payable onlyWhitelisted() whenNotPaused(){\n', '    require(msg.value >0);\n', '    if (investedAmountOf[msg.sender] == 0) {\n', '            investorCount++;\n', '        }\n', '    uint256 tokens = msg.value.mul(rate);  \n', '    require(supply >= tokens && balances[owner] >= tokens);\n', '    balances[msg.sender] = balances[msg.sender].add(tokens);\n', '    balances[owner] = balances[owner].sub(tokens); \n', '    walletAddress.transfer(msg.value); \n', '    Transfer(owner, msg.sender, tokens);\n', '    investedAmountOf[msg.sender] = investedAmountOf[msg.sender].add(msg.value);\n', '    weiRaised = weiRaised.add(msg.value);\n', '    soldTokens = soldTokens.add(tokens);\n', '    }\n', '    \n', '  function totalSupply() constant public returns (uint) {\n', '    return supply;\n', '  }\n', '\n', '  function balanceOf( address _who ) constant public returns (uint) {\n', '    return balances[_who];\n', '  }\n', '\n', '  function transfer( address _to, uint256 _value) onlyWhitelisted() public returns (bool success) {\n', '    if (investedAmountOf[_to] == 0) {\n', '        investorCount++;\n', '    }\n', '    require(_to != 0x0);\n', '    require(balances[msg.sender] >= _value && _value > 0 && supply >= _value);\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer( msg.sender, _to, _value );\n', '    soldTokens = soldTokens.add(_value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom( address _from, address _to, uint256 _value) onlyWhitelisted() public returns (bool success) {\n', '    require(_from != 0x0 && _to != 0x0);\n', '    require(approvals[_from][msg.sender] >= _value && balances[_from] >= _value && _value > 0);\n', '    approvals[_from][msg.sender] = approvals[_from][msg.sender].sub(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer( _from, _to, _value );\n', '    soldTokens = soldTokens.add(_value);\n', '    return true;\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool ok) {\n', '    require(_spender != 0x0);\n', '    approvals[msg.sender][_spender] = _value;\n', '    Approval( msg.sender, _spender, _value );\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant public returns (uint) {\n', '    return approvals[_owner][_spender];\n', '  }\n', '\n', '  function increaseSupply(uint256 _value, address _to) onlyOwner() public returns(bool success) {\n', '    require(_to != 0x0);\n', '    supply = supply.add(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(0, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function decreaseSupply(uint256 _value, address _from) onlyOwner() public returns(bool success) {\n', '    require(_from != 0x0);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    supply = supply.sub(_value);\n', '    Transfer(_from, 0, _value);\n', '    return true;\n', '  }\n', '\n', '  function increaseRate(uint256 _value, address _to) onlyOwner() public returns(bool success) {\n', '    require(_to != 0x0);\n', '    rate = rate.add(_value);\n', '    ratemapping[_to] = ratemapping[_to].add(_value);\n', '    Transfer(0, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function decreaseRate(uint256 _value, address _from) onlyOwner() public returns(bool success) {\n', '    require(_from != 0x0);\n', '    ratemapping[_from] = ratemapping[_from].sub(_value);\n', '    rate = rate.sub(_value);\n', '    Transfer(_from, 0, _value);\n', '    return true;\n', '  }\n', '  \n', '  function increaseApproval (address _spender, uint _addedValue) onlyOwner() public returns (bool success) {\n', '    approvals[msg.sender][_spender] = approvals[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, approvals[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval (address _spender, uint _subtractedValue) onlyOwner() public returns (bool success) {\n', '    uint oldValue = approvals[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      approvals[msg.sender][_spender] = 0;\n', '    } else {\n', '      approvals[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, approvals[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'contract ERC20 {\n', '\n', '    // Events\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval( address indexed owner, address indexed spender, uint256 value);\n', '\n', '    // Stateless functions\n', '    function totalSupply() constant public returns (uint256 supply);\n', '    function balanceOf( address who ) constant public returns (uint256 value);\n', '    function allowance(address owner, address spender) constant public returns (uint value);\n', '\n', '    // Stateful functions\n', '    function transfer( address to, uint256 value) public returns (bool success);\n', '    function transferFrom( address from, address to, uint256 value) public returns (bool success);\n', '    function approve(address spender, uint256 value) public returns (bool success);\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    Unpause();\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' */\n', 'library SafeMath {\n', '\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '  \n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Whitelist\n', ' * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.\n', ' * @dev This simplifies the implementation of "user permissions".\n', ' */\n', 'contract Whitelist is Ownable {\n', '  mapping(address => bool) public whitelist;\n', '  \n', '  event WhitelistedAddressAdded(address addr);\n', '  event WhitelistedAddressRemoved(address addr);\n', '\n', '  /**\n', "   * @dev Throws if called by any account that's not whitelisted.\n", '   */\n', '  modifier onlyWhitelisted() {\n', '    require(whitelist[msg.sender]);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev add an address to the whitelist\n', '   * @param addr address\n', '   * @return true if the address was added to the whitelist, false if the address was already in the whitelist \n', '   */\n', '  function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {\n', '    if (!whitelist[addr]) {\n', '      whitelist[addr] = true;\n', '      WhitelistedAddressAdded(addr);\n', '      success = true; \n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev add addresses to the whitelist\n', '   * @param addrs addresses\n', '   * @return true if at least one address was added to the whitelist, \n', '   * false if all addresses were already in the whitelist  \n', '   */\n', '  function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {\n', '    for (uint256 i = 0; i < addrs.length; i++) {\n', '      if (addAddressToWhitelist(addrs[i])) {\n', '        success = true;\n', '      }\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev remove an address from the whitelist\n', '   * @param addr address\n', '   * @return true if the address was removed from the whitelist, \n', "   * false if the address wasn't in the whitelist in the first place \n", '   */\n', '  function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {\n', '    if (whitelist[addr]) {\n', '      whitelist[addr] = false;\n', '      WhitelistedAddressRemoved(addr);\n', '      success = true;\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev remove addresses from the whitelist\n', '   * @param addrs addresses\n', '   * @return true if at least one address was removed from the whitelist, \n', "   * false if all addresses weren't in the whitelist in the first place\n", '   */\n', '  function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {\n', '    for (uint256 i = 0; i < addrs.length; i++) {\n', '      if (removeAddressFromWhitelist(addrs[i])) {\n', '        success = true;\n', '      }\n', '    }\n', '  }\n', '\n', '}\n', '\n', 'contract TalentCoin is ERC20, Ownable, Whitelist, Pausable{\n', '  \n', '  using SafeMath for uint256;\n', '\n', '  mapping (address => bool) admins;  // Mapping of who is an admin\n', '  mapping( address => uint256 ) balances;\n', '  mapping( address => mapping( address => uint256 ) ) approvals;\n', '  mapping( address => uint256 ) ratemapping;\n', '  //How much ETH each address has invested\n', '  mapping (address => uint) public investedAmountOf;\n', '  address public owner;\n', '  address public walletAddress;\n', '  uint256 public supply;\n', '  string public name;\n', '  uint256 public decimals;\n', '  string public symbol;\n', '  uint256 public rate;\n', '  uint public weiRaised;\n', '  uint public soldTokens;\n', '  uint public investorCount;\n', '  \n', '\n', '  function TalentCoin(address _walletAddress, uint256 _supply, string _name, uint256 _decimals, string _symbol, uint256 _rate ) public {\n', '    require(_walletAddress != 0x0);\n', '    balances[msg.sender] = _supply;\n', '    ratemapping[msg.sender] = _rate;\n', '    supply = _supply;\n', '    name = _name;\n', '    decimals = _decimals;\n', '    symbol = _symbol;\n', '    rate = _rate;\n', '    owner = msg.sender;\n', '    admins[msg.sender] = true;\n', '    walletAddress = _walletAddress;\n', '  }\n', '  \n', '    function () external payable {\n', '        createTokens();\n', '    }\n', '    \n', '    function createTokens() public payable onlyWhitelisted() whenNotPaused(){\n', '    require(msg.value >0);\n', '    if (investedAmountOf[msg.sender] == 0) {\n', '            investorCount++;\n', '        }\n', '    uint256 tokens = msg.value.mul(rate);  \n', '    require(supply >= tokens && balances[owner] >= tokens);\n', '    balances[msg.sender] = balances[msg.sender].add(tokens);\n', '    balances[owner] = balances[owner].sub(tokens); \n', '    walletAddress.transfer(msg.value); \n', '    Transfer(owner, msg.sender, tokens);\n', '    investedAmountOf[msg.sender] = investedAmountOf[msg.sender].add(msg.value);\n', '    weiRaised = weiRaised.add(msg.value);\n', '    soldTokens = soldTokens.add(tokens);\n', '    }\n', '    \n', '  function totalSupply() constant public returns (uint) {\n', '    return supply;\n', '  }\n', '\n', '  function balanceOf( address _who ) constant public returns (uint) {\n', '    return balances[_who];\n', '  }\n', '\n', '  function transfer( address _to, uint256 _value) onlyWhitelisted() public returns (bool success) {\n', '    if (investedAmountOf[_to] == 0) {\n', '        investorCount++;\n', '    }\n', '    require(_to != 0x0);\n', '    require(balances[msg.sender] >= _value && _value > 0 && supply >= _value);\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer( msg.sender, _to, _value );\n', '    soldTokens = soldTokens.add(_value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom( address _from, address _to, uint256 _value) onlyWhitelisted() public returns (bool success) {\n', '    require(_from != 0x0 && _to != 0x0);\n', '    require(approvals[_from][msg.sender] >= _value && balances[_from] >= _value && _value > 0);\n', '    approvals[_from][msg.sender] = approvals[_from][msg.sender].sub(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer( _from, _to, _value );\n', '    soldTokens = soldTokens.add(_value);\n', '    return true;\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool ok) {\n', '    require(_spender != 0x0);\n', '    approvals[msg.sender][_spender] = _value;\n', '    Approval( msg.sender, _spender, _value );\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant public returns (uint) {\n', '    return approvals[_owner][_spender];\n', '  }\n', '\n', '  function increaseSupply(uint256 _value, address _to) onlyOwner() public returns(bool success) {\n', '    require(_to != 0x0);\n', '    supply = supply.add(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(0, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function decreaseSupply(uint256 _value, address _from) onlyOwner() public returns(bool success) {\n', '    require(_from != 0x0);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    supply = supply.sub(_value);\n', '    Transfer(_from, 0, _value);\n', '    return true;\n', '  }\n', '\n', '  function increaseRate(uint256 _value, address _to) onlyOwner() public returns(bool success) {\n', '    require(_to != 0x0);\n', '    rate = rate.add(_value);\n', '    ratemapping[_to] = ratemapping[_to].add(_value);\n', '    Transfer(0, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function decreaseRate(uint256 _value, address _from) onlyOwner() public returns(bool success) {\n', '    require(_from != 0x0);\n', '    ratemapping[_from] = ratemapping[_from].sub(_value);\n', '    rate = rate.sub(_value);\n', '    Transfer(_from, 0, _value);\n', '    return true;\n', '  }\n', '  \n', '  function increaseApproval (address _spender, uint _addedValue) onlyOwner() public returns (bool success) {\n', '    approvals[msg.sender][_spender] = approvals[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, approvals[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval (address _spender, uint _subtractedValue) onlyOwner() public returns (bool success) {\n', '    uint oldValue = approvals[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      approvals[msg.sender][_spender] = 0;\n', '    } else {\n', '      approvals[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, approvals[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}']
