['/*\n', 'Xsearch Token\n', '*/\n', 'pragma solidity ^0.4.16;\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool);\n', '  function approve(address spender, uint256 value) returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    \n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '  \n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances. \n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '    \n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of. \n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) returns (bool) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifing the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    \n', '  address public owner;\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    require(newOwner != address(0));      \n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract BurnableToken is StandardToken {\n', '\n', '  /**\n', '   * @dev Burns a specific amount of tokens.\n', '   * @param _value The amount of token to be burned.\n', '   */\n', '  function burn(uint _value) public {\n', '    require(_value > 0);\n', '    address burner = msg.sender;\n', '    balances[burner] = balances[burner].sub(_value);\n', '    totalSupply = totalSupply.sub(_value);\n', '    Burn(burner, _value);\n', '  }\n', '\n', '  event Burn(address indexed burner, uint indexed value);\n', '\n', '}\n', '\n', 'contract XsearchToken is BurnableToken {\n', '    \n', '  string public constant name = "XSearch Token";\n', '   \n', '  string public constant symbol = "XSE";\n', '    \n', '  uint32 public constant decimals = 18;\n', '\n', '  uint256 public INITIAL_SUPPLY = 30000000 * 1 ether;\n', '\n', '  function XsearchToken() {\n', '    totalSupply = INITIAL_SUPPLY;\n', '    balances[msg.sender] = INITIAL_SUPPLY;\n', '  }\n', '    \n', '}\n', '\n', 'contract Crowdsale is Ownable {\n', '    \n', '  using SafeMath for uint;\n', '    \n', '  address multisig;\n', '\n', '  uint restrictedPercent;\n', '\n', '  address restricted;\n', '\n', '  XsearchToken public token = new XsearchToken();\n', '\n', '  uint start;\n', '    \n', '  uint period;\n', '\n', '  uint rate;\n', '\n', '  function Crowdsale() {\n', '    multisig = 0xd4DB7d2086C46CDd5F21c46613B520290ABfC9D6; //escrow wallet\n', '    restricted = 0x25fbfaA7bB3FfEb697Fe59Bb464Fc49299ef5563; // wallet for 15%\n', '    restrictedPercent = 15; // 15% procent for Founders, Bounties, Distribution cost, Management costs\n', '    rate = 1000000000000000000000; //rate\n', '    start = 1522195200;  //start date\n', '    period = 63; // ico period\n', '  }\n', '\n', '  modifier saleIsOn() {\n', '    require(now > start && now < start + period * 1 days);\n', '    _;\n', '  }\n', '\n', '    /*\n', '    Bonus: \n', '    private ico 40% (min 20 eth) 28.03-05.04\n', '    pre-ico 30% (min 0.5 eth) 05.04-20.04\n', '    main ico\n', '    R1(20.04-26.04): +15%min deposit 0.1ETH;    \n', '    R2(27.04-06.05): +10% min deposit 0.1ETH;  \n', '    R3(07.05-15.05): +5% bonus; min deposit 0.1ETH;  \n', '    R4(16.05-30.05): 0% bonus;  min deposit 0.1ETH;\n', '    */    \n', '\n', 'function createTokens() saleIsOn payable {\n', '   multisig.transfer(msg.value);\n', '   uint tokens = rate.mul(msg.value).div(1 ether);\n', '   uint bonusTokens = 0;\n', '   uint saleTime = period * 1 days;\n', '   if(now >= start && now < start + 8 * 1 days) {\n', '       bonusTokens = tokens.mul(40).div(100);\n', '   } else if(now >= start + 8 * 1 days && now < start + 24 * 1 days) {\n', '       bonusTokens = tokens.mul(30).div(100);\n', '   } else if(now >= start + 24 * 1 days && now <= start + 30 * 1 days) {\n', '       bonusTokens = tokens.mul(15).div(100);\n', '   } else if(now >= start + 31 * 1 days && now <= start + 40 * 1 days) {\n', '       bonusTokens = tokens.mul(10).div(100);\n', '   } else if(now >= start + 41 * 1 days && now <= start + 49 * 1 days) {\n', '       bonusTokens = tokens.mul(5).div(100);\n', '   } else if(now >= start + 50 * 1 days && now <= start + 64 * 1 days) {\n', '       bonusTokens = 0;\n', '   } else {\n', '       bonusTokens = 0;\n', '   }\n', '   uint tokensWithBonus = tokens.add(bonusTokens);\n', '   token.transfer(msg.sender, tokensWithBonus);\n', '   uint restrictedTokens = tokens.mul(restrictedPercent).div(100 - restrictedPercent);\n', '   token.transfer(restricted, restrictedTokens);\n', ' }\n', '\n', '  function() external payable {\n', '    createTokens();\n', '  }\n', '    \n', '}']
['/*\n', 'Xsearch Token\n', '*/\n', 'pragma solidity ^0.4.16;\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool);\n', '  function approve(address spender, uint256 value) returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    \n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '  \n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances. \n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '    \n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of. \n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) returns (bool) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifing the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    \n', '  address public owner;\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    require(newOwner != address(0));      \n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract BurnableToken is StandardToken {\n', '\n', '  /**\n', '   * @dev Burns a specific amount of tokens.\n', '   * @param _value The amount of token to be burned.\n', '   */\n', '  function burn(uint _value) public {\n', '    require(_value > 0);\n', '    address burner = msg.sender;\n', '    balances[burner] = balances[burner].sub(_value);\n', '    totalSupply = totalSupply.sub(_value);\n', '    Burn(burner, _value);\n', '  }\n', '\n', '  event Burn(address indexed burner, uint indexed value);\n', '\n', '}\n', '\n', 'contract XsearchToken is BurnableToken {\n', '    \n', '  string public constant name = "XSearch Token";\n', '   \n', '  string public constant symbol = "XSE";\n', '    \n', '  uint32 public constant decimals = 18;\n', '\n', '  uint256 public INITIAL_SUPPLY = 30000000 * 1 ether;\n', '\n', '  function XsearchToken() {\n', '    totalSupply = INITIAL_SUPPLY;\n', '    balances[msg.sender] = INITIAL_SUPPLY;\n', '  }\n', '    \n', '}\n', '\n', 'contract Crowdsale is Ownable {\n', '    \n', '  using SafeMath for uint;\n', '    \n', '  address multisig;\n', '\n', '  uint restrictedPercent;\n', '\n', '  address restricted;\n', '\n', '  XsearchToken public token = new XsearchToken();\n', '\n', '  uint start;\n', '    \n', '  uint period;\n', '\n', '  uint rate;\n', '\n', '  function Crowdsale() {\n', '    multisig = 0xd4DB7d2086C46CDd5F21c46613B520290ABfC9D6; //escrow wallet\n', '    restricted = 0x25fbfaA7bB3FfEb697Fe59Bb464Fc49299ef5563; // wallet for 15%\n', '    restrictedPercent = 15; // 15% procent for Founders, Bounties, Distribution cost, Management costs\n', '    rate = 1000000000000000000000; //rate\n', '    start = 1522195200;  //start date\n', '    period = 63; // ico period\n', '  }\n', '\n', '  modifier saleIsOn() {\n', '    require(now > start && now < start + period * 1 days);\n', '    _;\n', '  }\n', '\n', '    /*\n', '    Bonus: \n', '    private ico 40% (min 20 eth) 28.03-05.04\n', '    pre-ico 30% (min 0.5 eth) 05.04-20.04\n', '    main ico\n', '    R1(20.04-26.04): +15%min deposit 0.1ETH;    \n', '    R2(27.04-06.05): +10% min deposit 0.1ETH;  \n', '    R3(07.05-15.05): +5% bonus; min deposit 0.1ETH;  \n', '    R4(16.05-30.05): 0% bonus;  min deposit 0.1ETH;\n', '    */    \n', '\n', 'function createTokens() saleIsOn payable {\n', '   multisig.transfer(msg.value);\n', '   uint tokens = rate.mul(msg.value).div(1 ether);\n', '   uint bonusTokens = 0;\n', '   uint saleTime = period * 1 days;\n', '   if(now >= start && now < start + 8 * 1 days) {\n', '       bonusTokens = tokens.mul(40).div(100);\n', '   } else if(now >= start + 8 * 1 days && now < start + 24 * 1 days) {\n', '       bonusTokens = tokens.mul(30).div(100);\n', '   } else if(now >= start + 24 * 1 days && now <= start + 30 * 1 days) {\n', '       bonusTokens = tokens.mul(15).div(100);\n', '   } else if(now >= start + 31 * 1 days && now <= start + 40 * 1 days) {\n', '       bonusTokens = tokens.mul(10).div(100);\n', '   } else if(now >= start + 41 * 1 days && now <= start + 49 * 1 days) {\n', '       bonusTokens = tokens.mul(5).div(100);\n', '   } else if(now >= start + 50 * 1 days && now <= start + 64 * 1 days) {\n', '       bonusTokens = 0;\n', '   } else {\n', '       bonusTokens = 0;\n', '   }\n', '   uint tokensWithBonus = tokens.add(bonusTokens);\n', '   token.transfer(msg.sender, tokensWithBonus);\n', '   uint restrictedTokens = tokens.mul(restrictedPercent).div(100 - restrictedPercent);\n', '   token.transfer(restricted, restrictedTokens);\n', ' }\n', '\n', '  function() external payable {\n', '    createTokens();\n', '  }\n', '    \n', '}']
