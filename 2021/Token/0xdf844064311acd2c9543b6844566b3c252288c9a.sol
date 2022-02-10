['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-05\n', '*/\n', '\n', '/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-03\n', '*/\n', '\n', 'pragma solidity 0.4.21;\n', '\n', '\n', '// ---------------------------------------------------------------------\n', '// ERC-20 Token Standard Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md\n', '// ---------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '  /**\n', '  Returns the name of the token - e.g. "MyToken"\n', '   */\n', '  string public name;\n', '  /**\n', '  Returns the symbol of the token. E.g. "HIX".\n', '   */\n', '  string public symbol;\n', '  /**\n', '  Returns the number of decimals the token uses - e. g. 8\n', '   */\n', '  uint8 public decimals;\n', '  /**\n', '  Returns the total token supply.\n', '   */\n', '  uint256 public totalSupply;\n', '  /**\n', '  Returns the account balance of another account with address _owner.\n', '   */\n', '  function balanceOf(address _owner) public view returns (uint256 balance);\n', '  /**\n', '  Transfers _value amount of tokens to address _to, and MUST fire the Transfer event. \n', '  The function SHOULD throw if the _from account balance does not have enough tokens to spend.\n', '   */\n', '  function transfer(address _to, uint256 _value) public returns (bool success);\n', '  /**\n', '  Transfers _value amount of tokens from address _from to address _to, and MUST fire the Transfer event.\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '  /**\n', '  Allows _spender to withdraw from your account multiple times, up to the _value amount. \n', '  If this function is called again it overwrites the current allowance with _value.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool success);\n', '  /**\n', '  Returns the amount which _spender is still allowed to withdraw from _owner.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '  /**\n', '  MUST trigger when tokens are transferred, including zero value transfers.\n', '   */\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  /**\n', '  MUST trigger on any successful call to approve(address _spender, uint256 _value).\n', '    */\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '/**\n', 'Owned contract\n', ' */\n', 'contract Owned {\n', '  address public owner;\n', '  address public newOwner;\n', '\n', '  event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '  function Owned() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    newOwner = _newOwner;\n', '  }\n', '\n', '  function acceptOwnership() public {\n', '    require(msg.sender == newOwner);\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '    newOwner = address(0);\n', '  }\n', '}\n', '\n', '/**\n', 'Function to receive approval and execute function in one call.\n', ' */\n', 'contract TokenRecipient { \n', '  function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; \n', '}\n', '\n', '/**\n', 'Token implement\n', ' */\n', 'contract Token is ERC20Interface, Owned {\n', '\n', '  mapping (address => uint256) public balances;\n', '  mapping (address => mapping (address => uint256)) public allowed;\n', '  \n', '  // This notifies clients about the amount burnt\n', '  event Burn(address indexed from, uint256 value);\n', '  \n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool success) {\n', '    _transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '    require(_value <= allowed[_from][msg.sender]); \n', '    allowed[_from][msg.sender] -= _value;\n', '    _transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool success) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  \n', '  /**\n', '  Approves and then calls the receiving contract\n', '   */\n', '  function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '    TokenRecipient spender = TokenRecipient(_spender);\n', '    approve(_spender, _value);\n', '    spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  Destroy tokens.\n', '  Remove `_value` tokens from the system irreversibly\n', '    */\n', '  function burn(uint256 _value) public returns (bool success) {\n', '    require(balances[msg.sender] >= _value);\n', '    balances[msg.sender] -= _value;\n', '    totalSupply -= _value;\n', '    emit Burn(msg.sender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  Destroy tokens from other account.\n', '  Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '    */\n', '  function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '    require(balances[_from] >= _value);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '    balances[_from] -= _value;\n', '    allowed[_from][msg.sender] -= _value;\n', '    totalSupply -= _value;\n', '    emit Burn(_from, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  Internal transfer, only can be called by this contract\n', '    */\n', '  function _transfer(address _from, address _to, uint _value) internal {\n', '    // Prevent transfer to 0x0 address. Use burn() instead\n', '    require(_to != 0x0);\n', '    // Check if the sender has enough\n', '    require(balances[_from] >= _value);\n', '    // Check for overflows\n', '    require(balances[_to] + _value > balances[_to]);\n', '    // Save this for an assertion in the future\n', '    uint previousBalances = balances[_from] + balances[_to];\n', '    // Subtract from the sender\n', '    balances[_from] -= _value;\n', '    // Add the same to the recipient\n', '    balances[_to] += _value;\n', '    emit Transfer(_from, _to, _value);\n', '    // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '    assert(balances[_from] + balances[_to] == previousBalances);\n', '  }\n', '\n', '}\n', '\n', 'contract STELO is Token {\n', '\n', '  function STELO() public {\n', '    name = "Stelo Coin";\n', '    symbol = "STELO";\n', '    decimals = 0;\n', '    totalSupply = 200000000000;\n', '    balances[msg.sender] = totalSupply;\n', '  }\n', '}']