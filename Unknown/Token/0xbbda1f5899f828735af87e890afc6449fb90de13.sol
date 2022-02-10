['pragma solidity ^0.4.16;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances. \n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of. \n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool);\n', '  function approve(address spender, uint256 value) returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) returns (bool) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifing the amount of tokens still avaible for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', 'contract DEST  is StandardToken {\n', '\n', '  // Constants\n', '  // =========\n', '\n', '  string public constant name = "Decentralized Escrow Token";\n', '  string public constant symbol = "DEST";\n', '  uint   public constant decimals = 18;\n', '\n', '  uint public constant ETH_MIN_LIMIT = 500 ether;\n', '  uint public constant ETH_MAX_LIMIT = 1500 ether;\n', '\n', '  uint public constant START_TIMESTAMP = 1503824400; // 2017-08-27 09:00:00 UTC\n', '  uint public constant END_TIMESTAMP   = 1506816000; // 2017-10-01 00:00:00 UTC\n', '\n', '  address public constant wallet = 0x51559EfC1AcC15bcAfc7E0C2fB440848C136A46B;\n', '\n', '\n', '  // State variables\n', '  // ===============\n', '\n', '  uint public ethCollected;\n', '  mapping (address=>uint) ethInvested;\n', '\n', '\n', '  // Constant functions\n', '  // =========================\n', '\n', '  function hasStarted() public constant returns (bool) {\n', '    return now >= START_TIMESTAMP;\n', '  }\n', '\n', '\n', '  // Payments are not accepted after ICO is finished.\n', '  function hasFinished() public constant returns (bool) {\n', '    return now >= END_TIMESTAMP || ethCollected >= ETH_MAX_LIMIT;\n', '  }\n', '\n', '\n', '  // Investors can move their tokens only after ico has successfully finished\n', '  function tokensAreLiquid() public constant returns (bool) {\n', '    return (ethCollected >= ETH_MIN_LIMIT && now >= END_TIMESTAMP)\n', '      || (ethCollected >= ETH_MAX_LIMIT);\n', '  }\n', '\n', '\n', '  function price(uint _v) public constant returns (uint) {\n', '    return // poor man&#39;s binary search\n', '      _v < 7 ether\n', '        ? _v < 3 ether\n', '          ? _v < 1 ether\n', '            ? 1000\n', '            : _v < 2 ether ? 1005 : 1010\n', '          : _v < 4 ether\n', '            ? 1015\n', '            : _v < 5 ether ? 1020 : 1030\n', '        : _v < 14 ether\n', '          ? _v < 10 ether\n', '            ? _v < 9 ether ? 1040 : 1050\n', '            : 1080\n', '          : _v < 100 ether\n', '            ? _v < 20 ether ? 1110 : 1150\n', '            : 1200;\n', '  }\n', '\n', '\n', '  // Public functions\n', '  // =========================\n', '\n', '  function() public payable {\n', '    require(hasStarted() && !hasFinished());\n', '    require(ethCollected + msg.value <= ETH_MAX_LIMIT);\n', '\n', '    ethCollected += msg.value;\n', '    ethInvested[msg.sender] += msg.value;\n', '\n', '    uint _tokenValue = msg.value * price(msg.value);\n', '    balances[msg.sender] += _tokenValue;\n', '    totalSupply += _tokenValue;\n', '    Transfer(0x0, msg.sender, _tokenValue);\n', '  }\n', '\n', '\n', '  // Investors can get refund if ETH_MIN_LIMIT is not reached.\n', '  function refund() public {\n', '    require(ethCollected < ETH_MIN_LIMIT && now >= END_TIMESTAMP);\n', '    require(balances[msg.sender] > 0);\n', '\n', '    totalSupply -= balances[msg.sender];\n', '    balances[msg.sender] = 0;\n', '    uint _ethRefund = ethInvested[msg.sender];\n', '    ethInvested[msg.sender] = 0;\n', '    msg.sender.transfer(_ethRefund);\n', '  }\n', '\n', '\n', '  // Owner can withdraw all the money after min_limit is reached.\n', '  function withdraw() public {\n', '    require(ethCollected >= ETH_MIN_LIMIT);\n', '    wallet.transfer(this.balance);\n', '  }\n', '\n', '\n', '  // ERC20 functions\n', '  // =========================\n', '\n', '  function transfer(address _to, uint _value) public returns (bool)\n', '  {\n', '    require(tokensAreLiquid());\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '\n', '  function transferFrom(address _from, address _to, uint _value)\n', '    public returns (bool)\n', '  {\n', '    require(tokensAreLiquid());\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '\n', '  function approve(address _spender, uint _value)\n', '    public returns (bool)\n', '  {\n', '    require(tokensAreLiquid());\n', '    return super.approve(_spender, _value);\n', '  }\n', '}']
['pragma solidity ^0.4.16;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances. \n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of. \n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool);\n', '  function approve(address spender, uint256 value) returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) returns (bool) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifing the amount of tokens still avaible for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', 'contract DEST  is StandardToken {\n', '\n', '  // Constants\n', '  // =========\n', '\n', '  string public constant name = "Decentralized Escrow Token";\n', '  string public constant symbol = "DEST";\n', '  uint   public constant decimals = 18;\n', '\n', '  uint public constant ETH_MIN_LIMIT = 500 ether;\n', '  uint public constant ETH_MAX_LIMIT = 1500 ether;\n', '\n', '  uint public constant START_TIMESTAMP = 1503824400; // 2017-08-27 09:00:00 UTC\n', '  uint public constant END_TIMESTAMP   = 1506816000; // 2017-10-01 00:00:00 UTC\n', '\n', '  address public constant wallet = 0x51559EfC1AcC15bcAfc7E0C2fB440848C136A46B;\n', '\n', '\n', '  // State variables\n', '  // ===============\n', '\n', '  uint public ethCollected;\n', '  mapping (address=>uint) ethInvested;\n', '\n', '\n', '  // Constant functions\n', '  // =========================\n', '\n', '  function hasStarted() public constant returns (bool) {\n', '    return now >= START_TIMESTAMP;\n', '  }\n', '\n', '\n', '  // Payments are not accepted after ICO is finished.\n', '  function hasFinished() public constant returns (bool) {\n', '    return now >= END_TIMESTAMP || ethCollected >= ETH_MAX_LIMIT;\n', '  }\n', '\n', '\n', '  // Investors can move their tokens only after ico has successfully finished\n', '  function tokensAreLiquid() public constant returns (bool) {\n', '    return (ethCollected >= ETH_MIN_LIMIT && now >= END_TIMESTAMP)\n', '      || (ethCollected >= ETH_MAX_LIMIT);\n', '  }\n', '\n', '\n', '  function price(uint _v) public constant returns (uint) {\n', "    return // poor man's binary search\n", '      _v < 7 ether\n', '        ? _v < 3 ether\n', '          ? _v < 1 ether\n', '            ? 1000\n', '            : _v < 2 ether ? 1005 : 1010\n', '          : _v < 4 ether\n', '            ? 1015\n', '            : _v < 5 ether ? 1020 : 1030\n', '        : _v < 14 ether\n', '          ? _v < 10 ether\n', '            ? _v < 9 ether ? 1040 : 1050\n', '            : 1080\n', '          : _v < 100 ether\n', '            ? _v < 20 ether ? 1110 : 1150\n', '            : 1200;\n', '  }\n', '\n', '\n', '  // Public functions\n', '  // =========================\n', '\n', '  function() public payable {\n', '    require(hasStarted() && !hasFinished());\n', '    require(ethCollected + msg.value <= ETH_MAX_LIMIT);\n', '\n', '    ethCollected += msg.value;\n', '    ethInvested[msg.sender] += msg.value;\n', '\n', '    uint _tokenValue = msg.value * price(msg.value);\n', '    balances[msg.sender] += _tokenValue;\n', '    totalSupply += _tokenValue;\n', '    Transfer(0x0, msg.sender, _tokenValue);\n', '  }\n', '\n', '\n', '  // Investors can get refund if ETH_MIN_LIMIT is not reached.\n', '  function refund() public {\n', '    require(ethCollected < ETH_MIN_LIMIT && now >= END_TIMESTAMP);\n', '    require(balances[msg.sender] > 0);\n', '\n', '    totalSupply -= balances[msg.sender];\n', '    balances[msg.sender] = 0;\n', '    uint _ethRefund = ethInvested[msg.sender];\n', '    ethInvested[msg.sender] = 0;\n', '    msg.sender.transfer(_ethRefund);\n', '  }\n', '\n', '\n', '  // Owner can withdraw all the money after min_limit is reached.\n', '  function withdraw() public {\n', '    require(ethCollected >= ETH_MIN_LIMIT);\n', '    wallet.transfer(this.balance);\n', '  }\n', '\n', '\n', '  // ERC20 functions\n', '  // =========================\n', '\n', '  function transfer(address _to, uint _value) public returns (bool)\n', '  {\n', '    require(tokensAreLiquid());\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '\n', '  function transferFrom(address _from, address _to, uint _value)\n', '    public returns (bool)\n', '  {\n', '    require(tokensAreLiquid());\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '\n', '  function approve(address _spender, uint _value)\n', '    public returns (bool)\n', '  {\n', '    require(tokensAreLiquid());\n', '    return super.approve(_spender, _value);\n', '  }\n', '}']
