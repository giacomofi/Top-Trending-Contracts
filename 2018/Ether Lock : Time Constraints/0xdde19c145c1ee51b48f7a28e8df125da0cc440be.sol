['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'contract EmbiggenToken is ERC20 {\n', '  using SafeMath for uint256;\n', '\n', '  uint constant MAX_UINT = 2**256 - 1;\n', '  string public name;\n', '  string public symbol;\n', '  uint8 public decimals;\n', '\n', '  uint initialSupply;\n', '  uint initializedTime;\n', '  uint hourRate;\n', '\n', '  struct UserBalance {\n', '    uint latestBalance;\n', '    uint lastCalculated;\n', '  }\n', '\n', '  mapping(address => UserBalance) balances;\n', '  mapping(address => mapping(address => uint)) allowed;\n', '\n', '  // annualRate: percent * 10^18\n', '  function EmbiggenToken(uint _initialSupply, uint annualRate, string _name, string _symbol, uint8 _decimals) {\n', '    initialSupply = _initialSupply;\n', '    initializedTime = (block.timestamp / 3600) * 3600;\n', '    hourRate = annualRate / (365 * 24);\n', '    require(hourRate <= 223872113856833); // This ensures that (earnedInterset * baseInterest) won&#39;t overflow a uint for any plausible time period\n', '    balances[msg.sender] = UserBalance({\n', '      latestBalance: _initialSupply,\n', '      lastCalculated: (block.timestamp / 3600) * 3600\n', '    });\n', '    name = _name;\n', '    symbol = _symbol;\n', '    decimals = _decimals;\n', '  }\n', '\n', '  function getInterest(uint value, uint lastCalculated) public view returns (uint) {\n', '    if(value == 0) {\n', '      // We were going to multiply by 0 at the end, so no point wasting gas on\n', '      // the other calculations.\n', '      return 0;\n', '    }\n', '    uint exp = (block.timestamp - lastCalculated) / 3600;\n', '    uint x = 1000000000000000000;\n', '    uint base = 1000000000000000000 + hourRate;\n', '    while(exp != 0) {\n', '      if(exp & 1 != 0){\n', '        x = (x * base) / 1000000000000000000;\n', '      }\n', '      exp = exp / 2;\n', '      base = (base * base) / 1000000000000000000;\n', '    }\n', '    return value.mul(x - 1000000000000000000) / 1000000000000000000;\n', '  }\n', '\n', '  function totalSupply() public view returns (uint) {\n', '    return initialSupply.add(getInterest(initialSupply, initializedTime));\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner].latestBalance.add(getInterest(balances[_owner].latestBalance, balances[_owner].lastCalculated));\n', '  }\n', '\n', '  function incBalance(address _owner, uint amount) private {\n', '    balances[_owner] = UserBalance({\n', '      latestBalance: balanceOf(_owner).add(amount),\n', '      lastCalculated: (block.timestamp / 3600) * 3600 // Round down to the last hour\n', '    });\n', '  }\n', '\n', '  function decBalance(address _owner, uint amount) private {\n', '    uint priorBalance = balanceOf(_owner);\n', '    require(priorBalance >= amount);\n', '    balances[_owner] = UserBalance({\n', '      latestBalance: priorBalance.sub(amount),\n', '      lastCalculated: (block.timestamp / 3600) * 3600 // Round down to the last hour\n', '    });\n', '  }\n', '\n', '  function transfer(address _to, uint _value) public returns (bool)  {\n', '    require(_to != address(0));\n', '    decBalance(msg.sender, _value);\n', '    incBalance(_to, _value);\n', '    Transfer(msg.sender, _to, _value);\n', '\n', '    return true;\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    decBalance(_from, _value);\n', '    incBalance(_to, _value);\n', '\n', '    if(allowed[_from][msg.sender] < MAX_UINT) {\n', '      allowed[_from][msg.sender] -= _value;\n', '    }\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'contract EmbiggenToken is ERC20 {\n', '  using SafeMath for uint256;\n', '\n', '  uint constant MAX_UINT = 2**256 - 1;\n', '  string public name;\n', '  string public symbol;\n', '  uint8 public decimals;\n', '\n', '  uint initialSupply;\n', '  uint initializedTime;\n', '  uint hourRate;\n', '\n', '  struct UserBalance {\n', '    uint latestBalance;\n', '    uint lastCalculated;\n', '  }\n', '\n', '  mapping(address => UserBalance) balances;\n', '  mapping(address => mapping(address => uint)) allowed;\n', '\n', '  // annualRate: percent * 10^18\n', '  function EmbiggenToken(uint _initialSupply, uint annualRate, string _name, string _symbol, uint8 _decimals) {\n', '    initialSupply = _initialSupply;\n', '    initializedTime = (block.timestamp / 3600) * 3600;\n', '    hourRate = annualRate / (365 * 24);\n', "    require(hourRate <= 223872113856833); // This ensures that (earnedInterset * baseInterest) won't overflow a uint for any plausible time period\n", '    balances[msg.sender] = UserBalance({\n', '      latestBalance: _initialSupply,\n', '      lastCalculated: (block.timestamp / 3600) * 3600\n', '    });\n', '    name = _name;\n', '    symbol = _symbol;\n', '    decimals = _decimals;\n', '  }\n', '\n', '  function getInterest(uint value, uint lastCalculated) public view returns (uint) {\n', '    if(value == 0) {\n', '      // We were going to multiply by 0 at the end, so no point wasting gas on\n', '      // the other calculations.\n', '      return 0;\n', '    }\n', '    uint exp = (block.timestamp - lastCalculated) / 3600;\n', '    uint x = 1000000000000000000;\n', '    uint base = 1000000000000000000 + hourRate;\n', '    while(exp != 0) {\n', '      if(exp & 1 != 0){\n', '        x = (x * base) / 1000000000000000000;\n', '      }\n', '      exp = exp / 2;\n', '      base = (base * base) / 1000000000000000000;\n', '    }\n', '    return value.mul(x - 1000000000000000000) / 1000000000000000000;\n', '  }\n', '\n', '  function totalSupply() public view returns (uint) {\n', '    return initialSupply.add(getInterest(initialSupply, initializedTime));\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner].latestBalance.add(getInterest(balances[_owner].latestBalance, balances[_owner].lastCalculated));\n', '  }\n', '\n', '  function incBalance(address _owner, uint amount) private {\n', '    balances[_owner] = UserBalance({\n', '      latestBalance: balanceOf(_owner).add(amount),\n', '      lastCalculated: (block.timestamp / 3600) * 3600 // Round down to the last hour\n', '    });\n', '  }\n', '\n', '  function decBalance(address _owner, uint amount) private {\n', '    uint priorBalance = balanceOf(_owner);\n', '    require(priorBalance >= amount);\n', '    balances[_owner] = UserBalance({\n', '      latestBalance: priorBalance.sub(amount),\n', '      lastCalculated: (block.timestamp / 3600) * 3600 // Round down to the last hour\n', '    });\n', '  }\n', '\n', '  function transfer(address _to, uint _value) public returns (bool)  {\n', '    require(_to != address(0));\n', '    decBalance(msg.sender, _value);\n', '    incBalance(_to, _value);\n', '    Transfer(msg.sender, _to, _value);\n', '\n', '    return true;\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    decBalance(_from, _value);\n', '    incBalance(_to, _value);\n', '\n', '    if(allowed[_from][msg.sender] < MAX_UINT) {\n', '      allowed[_from][msg.sender] -= _value;\n', '    }\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '}']
