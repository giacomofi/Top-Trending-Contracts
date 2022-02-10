['library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract IToken {\n', '  function totalSupply() constant returns (uint256 totalSupply);\n', '  function mintTokens(address _to, uint256 _amount) {}\n', '}\n', 'contract IMintableToken {\n', '  function mintTokens(address _to, uint256 _amount){}\n', '}\n', 'contract IERC20Token {\n', '  function totalSupply() constant returns (uint256 totalSupply);\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {}\n', '  function transfer(address _to, uint256 _value) returns (bool success) {}\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}\n', '  function approve(address _spender, uint256 _value) returns (bool success) {}\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}\n', '\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract ItokenRecipient {\n', '  function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    function Owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        assert(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        require(_newOwner != owner);\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        OwnerUpdate(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = 0x0;\n', '    }\n', '\n', '    event OwnerUpdate(address _prevOwner, address _newOwner);\n', '}\n', 'contract ReentrnacyHandlingContract{\n', '\n', '    bool locked;\n', '\n', '    modifier noReentrancy() {\n', '        require(!locked);\n', '        locked = true;\n', '        _;\n', '        locked = false;\n', '    }\n', '}\n', '\n', 'contract Lockable is Owned{\n', '\n', '  uint256 public lockedUntilBlock;\n', '\n', '  event ContractLocked(uint256 _untilBlock, string _reason);\n', '\n', '  modifier lockAffected {\n', '      require(block.number > lockedUntilBlock);\n', '      _;\n', '  }\n', '\n', '  function lockFromSelf(uint256 _untilBlock, string _reason) internal {\n', '    lockedUntilBlock = _untilBlock;\n', '    ContractLocked(_untilBlock, _reason);\n', '  }\n', '\n', '\n', '  function lockUntil(uint256 _untilBlock, string _reason) onlyOwner {\n', '    lockedUntilBlock = _untilBlock;\n', '    ContractLocked(_untilBlock, _reason);\n', '  }\n', '}\n', '\n', '\n', 'contract Token is IERC20Token, Owned, Lockable{\n', '\n', '  using SafeMath for uint256;\n', '\n', '  /* Public variables of the token */\n', '  string public standard;\n', '  string public name;\n', '  string public symbol;\n', '  uint8 public decimals;\n', '\n', '  address public crowdsaleContractAddress;\n', '\n', '  /* Private variables of the token */\n', '  uint256 supply = 0;\n', '  mapping (address => uint256) balances;\n', '  mapping (address => mapping (address => uint256)) allowances;\n', '\n', '  /* Events */\n', '  event Mint(address indexed _to, uint256 _value);\n', '\n', '  /* Returns total supply of issued tokens */\n', '  function totalSupply() constant returns (uint256) {\n', '    return supply;\n', '  }\n', '\n', '  /* Returns balance of address */\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  /* Transfers tokens from your address to other */\n', '  function transfer(address _to, uint256 _value) lockAffected returns (bool success) {\n', '    require(_to != 0x0 && _to != address(this));\n', '    balances[msg.sender] = balances[msg.sender].sub(_value); // Deduct senders balance\n', '    balances[_to] = balances[_to].add(_value);               // Add recivers blaance\n', '    Transfer(msg.sender, _to, _value);                       // Raise Transfer event\n', '    return true;\n', '  }\n', '\n', '  /* Approve other address to spend tokens on your account */\n', '  function approve(address _spender, uint256 _value) lockAffected returns (bool success) {\n', '    allowances[msg.sender][_spender] = _value;        // Set allowance\n', '    Approval(msg.sender, _spender, _value);           // Raise Approval event\n', '    return true;\n', '  }\n', '\n', '  /* Approve and then communicate the approved contract in a single tx */\n', '  function approveAndCall(address _spender, uint256 _value, bytes _extraData) lockAffected returns (bool success) {\n', '    ItokenRecipient spender = ItokenRecipient(_spender);            // Cast spender to tokenRecipient contract\n', '    approve(_spender, _value);                                      // Set approval to contract for _value\n', '    spender.receiveApproval(msg.sender, _value, this, _extraData);  // Raise method on _spender contract\n', '    return true;\n', '  }\n', '\n', '  /* A contract attempts to get the coins */\n', '  function transferFrom(address _from, address _to, uint256 _value) lockAffected returns (bool success) {\n', '    require(_to != 0x0 && _to != address(this));\n', '    balances[_from] = balances[_from].sub(_value);                              // Deduct senders balance\n', '    balances[_to] = balances[_to].add(_value);                                  // Add recipient blaance\n', '    allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);  // Deduct allowance for this address\n', '    Transfer(_from, _to, _value);                                               // Raise Transfer event\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowances[_owner][_spender];\n', '  }\n', '\n', '  function mintTokens(address _to, uint256 _amount) {\n', '    require(msg.sender == crowdsaleContractAddress);\n', '\n', '    supply = supply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    Transfer(0x0, _to, _amount);\n', '  }\n', '\n', '  function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) onlyOwner{\n', '    IERC20Token(_tokenAddress).transfer(_to, _amount);\n', '  }\n', '}\n', '\n', '\n', '\n', 'contract MaecenasToken is Token {\n', '\n', '  /* Initializes contract */\n', '  function MaecenasToken() {\n', '    standard = "Maecenas token v1.0";\n', '    name = "Maecenas ART Token";\n', '    symbol = "ART";\n', '    decimals = 18;\n', '    crowdsaleContractAddress = 0x9B60874D7bc4e4fBDd142e0F5a12002e4F7715a6; \n', '    lockFromSelf(4366494, "Lock before crowdsale starts");\n', '  }\n', '}']
['library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract IToken {\n', '  function totalSupply() constant returns (uint256 totalSupply);\n', '  function mintTokens(address _to, uint256 _amount) {}\n', '}\n', 'contract IMintableToken {\n', '  function mintTokens(address _to, uint256 _amount){}\n', '}\n', 'contract IERC20Token {\n', '  function totalSupply() constant returns (uint256 totalSupply);\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {}\n', '  function transfer(address _to, uint256 _value) returns (bool success) {}\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}\n', '  function approve(address _spender, uint256 _value) returns (bool success) {}\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}\n', '\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract ItokenRecipient {\n', '  function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    function Owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        assert(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        require(_newOwner != owner);\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        OwnerUpdate(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = 0x0;\n', '    }\n', '\n', '    event OwnerUpdate(address _prevOwner, address _newOwner);\n', '}\n', 'contract ReentrnacyHandlingContract{\n', '\n', '    bool locked;\n', '\n', '    modifier noReentrancy() {\n', '        require(!locked);\n', '        locked = true;\n', '        _;\n', '        locked = false;\n', '    }\n', '}\n', '\n', 'contract Lockable is Owned{\n', '\n', '  uint256 public lockedUntilBlock;\n', '\n', '  event ContractLocked(uint256 _untilBlock, string _reason);\n', '\n', '  modifier lockAffected {\n', '      require(block.number > lockedUntilBlock);\n', '      _;\n', '  }\n', '\n', '  function lockFromSelf(uint256 _untilBlock, string _reason) internal {\n', '    lockedUntilBlock = _untilBlock;\n', '    ContractLocked(_untilBlock, _reason);\n', '  }\n', '\n', '\n', '  function lockUntil(uint256 _untilBlock, string _reason) onlyOwner {\n', '    lockedUntilBlock = _untilBlock;\n', '    ContractLocked(_untilBlock, _reason);\n', '  }\n', '}\n', '\n', '\n', 'contract Token is IERC20Token, Owned, Lockable{\n', '\n', '  using SafeMath for uint256;\n', '\n', '  /* Public variables of the token */\n', '  string public standard;\n', '  string public name;\n', '  string public symbol;\n', '  uint8 public decimals;\n', '\n', '  address public crowdsaleContractAddress;\n', '\n', '  /* Private variables of the token */\n', '  uint256 supply = 0;\n', '  mapping (address => uint256) balances;\n', '  mapping (address => mapping (address => uint256)) allowances;\n', '\n', '  /* Events */\n', '  event Mint(address indexed _to, uint256 _value);\n', '\n', '  /* Returns total supply of issued tokens */\n', '  function totalSupply() constant returns (uint256) {\n', '    return supply;\n', '  }\n', '\n', '  /* Returns balance of address */\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  /* Transfers tokens from your address to other */\n', '  function transfer(address _to, uint256 _value) lockAffected returns (bool success) {\n', '    require(_to != 0x0 && _to != address(this));\n', '    balances[msg.sender] = balances[msg.sender].sub(_value); // Deduct senders balance\n', '    balances[_to] = balances[_to].add(_value);               // Add recivers blaance\n', '    Transfer(msg.sender, _to, _value);                       // Raise Transfer event\n', '    return true;\n', '  }\n', '\n', '  /* Approve other address to spend tokens on your account */\n', '  function approve(address _spender, uint256 _value) lockAffected returns (bool success) {\n', '    allowances[msg.sender][_spender] = _value;        // Set allowance\n', '    Approval(msg.sender, _spender, _value);           // Raise Approval event\n', '    return true;\n', '  }\n', '\n', '  /* Approve and then communicate the approved contract in a single tx */\n', '  function approveAndCall(address _spender, uint256 _value, bytes _extraData) lockAffected returns (bool success) {\n', '    ItokenRecipient spender = ItokenRecipient(_spender);            // Cast spender to tokenRecipient contract\n', '    approve(_spender, _value);                                      // Set approval to contract for _value\n', '    spender.receiveApproval(msg.sender, _value, this, _extraData);  // Raise method on _spender contract\n', '    return true;\n', '  }\n', '\n', '  /* A contract attempts to get the coins */\n', '  function transferFrom(address _from, address _to, uint256 _value) lockAffected returns (bool success) {\n', '    require(_to != 0x0 && _to != address(this));\n', '    balances[_from] = balances[_from].sub(_value);                              // Deduct senders balance\n', '    balances[_to] = balances[_to].add(_value);                                  // Add recipient blaance\n', '    allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);  // Deduct allowance for this address\n', '    Transfer(_from, _to, _value);                                               // Raise Transfer event\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowances[_owner][_spender];\n', '  }\n', '\n', '  function mintTokens(address _to, uint256 _amount) {\n', '    require(msg.sender == crowdsaleContractAddress);\n', '\n', '    supply = supply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    Transfer(0x0, _to, _amount);\n', '  }\n', '\n', '  function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) onlyOwner{\n', '    IERC20Token(_tokenAddress).transfer(_to, _amount);\n', '  }\n', '}\n', '\n', '\n', '\n', 'contract MaecenasToken is Token {\n', '\n', '  /* Initializes contract */\n', '  function MaecenasToken() {\n', '    standard = "Maecenas token v1.0";\n', '    name = "Maecenas ART Token";\n', '    symbol = "ART";\n', '    decimals = 18;\n', '    crowdsaleContractAddress = 0x9B60874D7bc4e4fBDd142e0F5a12002e4F7715a6; \n', '    lockFromSelf(4366494, "Lock before crowdsale starts");\n', '  }\n', '}']
