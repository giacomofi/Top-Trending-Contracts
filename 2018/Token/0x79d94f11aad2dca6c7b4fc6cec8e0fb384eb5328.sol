['pragma solidity ^0.4.11;\n', '\n', '// File: contracts/SafeMath.sol\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal pure returns (uint) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal pure returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '}\n', '\n', '// File: contracts/ERC20.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', ' /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', ' /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/ERC223.sol\n', '\n', '/**\n', ' * ERC20-compatible version of ERC223\n', ' * https://github.com/Dexaran/ERC223-token-standard/tree/ERC20_compatible\n', ' */\n', 'contract ERC223Basic is StandardToken {\n', '    function transfer(address to, uint value, bytes data) public;\n', '    event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);\n', '}\n', '\n', '/**\n', ' * Contract that is working with ERC223 tokens\n', ' */\n', 'contract ERC223ReceivingContract {\n', '    function tokenFallback(address _from, uint _value, bytes _data) public;\n', '}\n', '\n', '/**\n', ' * ERC20-compatible version of ERC223\n', ' * https://github.com/Dexaran/ERC223-token-standard/tree/ERC20_compatible\n', ' */\n', 'contract ERC223BasicToken is ERC223Basic {\n', '    using SafeMath for uint;\n', '\n', '    /**\n', '     * @dev Fix for the ERC20 short address attack.\n', '     */\n', '    modifier onlyPayloadSize(uint size) {\n', '        require(msg.data.length >= size + 4);\n', '        _;\n', '    }\n', '\n', '    // Function that is called when a user or another contract wants to transfer funds .\n', '    function transfer(address to, uint value, bytes data) onlyPayloadSize(2 * 32) public {\n', '        // Standard function transfer similar to ERC20 transfer with no _data .\n', '        // Added due to backwards compatibility reasons .\n', '        uint codeLength;\n', '\n', '        assembly {\n', '            // Retrieve the size of the code on target address, this needs assembly .\n', '            codeLength := extcodesize(to)\n', '        }\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(value);\n', '        balances[to] = balances[to].add(value);\n', '        if(codeLength > 0) {\n', '            ERC223ReceivingContract receiver = ERC223ReceivingContract(to);\n', '            receiver.tokenFallback(msg.sender, value, data);\n', '        }\n', '        Transfer(msg.sender, to, value);  // ERC20 transfer event\n', '        Transfer(msg.sender, to, value, data);  // ERC223 transfer event\n', '    }\n', '\n', '    // Standard function transfer similar to ERC20 transfer with no _data .\n', '    // Added due to backwards compatibility reasons .\n', '    function transfer(address to, uint256 value) onlyPayloadSize(2 * 32)  public returns (bool) {\n', '        uint codeLength;\n', '\n', '        assembly {\n', '            // Retrieve the size of the code on target address, this needs assembly .\n', '            codeLength := extcodesize(to)\n', '        }\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(value);\n', '        balances[to] = balances[to].add(value);\n', '        if(codeLength > 0) {\n', '            ERC223ReceivingContract receiver = ERC223ReceivingContract(to);\n', '            bytes memory empty;\n', '            receiver.tokenFallback(msg.sender, value, empty);\n', '        }\n', '        Transfer(msg.sender, to, value);  // ERC20 transfer event\n', '        return true;\n', '    }\n', '}\n', '\n', '// File: contracts/DogRacingToken.sol\n', '\n', '/**\n', ' * DogRacing Token\n', ' */\n', 'contract DogRacingToken is ERC223BasicToken {\n', '  using SafeMath for uint256;\n', '\n', '  string constant public name = "Dog Racing";\n', '  string constant public symbol = "DGR";\n', '  uint8 constant public decimals = 3;\n', '  uint256 constant public totalSupply \t= 326250000 * 1000;\t// Supply is in the smallest units\n', '\n', '  address public owner;   // owner address\n', '\n', '  modifier onlyOwner {\n', '    require(owner == msg.sender);\n', '    _;\n', '  }\n', '\n', '  function DogRacingToken() public {\n', '    owner = msg.sender;\n', '    balances[owner] = totalSupply;   // All tokens are assigned to the owner\n', '  }\n', '\n', '  // Owner may burn own tokens\n', '  function burnTokens(uint256 amount) onlyOwner external {\n', '    balances[owner] = balances[owner].sub(amount);\n', '  }\n', '}']
['pragma solidity ^0.4.11;\n', '\n', '// File: contracts/SafeMath.sol\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal pure returns (uint) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal pure returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '}\n', '\n', '// File: contracts/ERC20.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', ' /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', ' /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/ERC223.sol\n', '\n', '/**\n', ' * ERC20-compatible version of ERC223\n', ' * https://github.com/Dexaran/ERC223-token-standard/tree/ERC20_compatible\n', ' */\n', 'contract ERC223Basic is StandardToken {\n', '    function transfer(address to, uint value, bytes data) public;\n', '    event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);\n', '}\n', '\n', '/**\n', ' * Contract that is working with ERC223 tokens\n', ' */\n', 'contract ERC223ReceivingContract {\n', '    function tokenFallback(address _from, uint _value, bytes _data) public;\n', '}\n', '\n', '/**\n', ' * ERC20-compatible version of ERC223\n', ' * https://github.com/Dexaran/ERC223-token-standard/tree/ERC20_compatible\n', ' */\n', 'contract ERC223BasicToken is ERC223Basic {\n', '    using SafeMath for uint;\n', '\n', '    /**\n', '     * @dev Fix for the ERC20 short address attack.\n', '     */\n', '    modifier onlyPayloadSize(uint size) {\n', '        require(msg.data.length >= size + 4);\n', '        _;\n', '    }\n', '\n', '    // Function that is called when a user or another contract wants to transfer funds .\n', '    function transfer(address to, uint value, bytes data) onlyPayloadSize(2 * 32) public {\n', '        // Standard function transfer similar to ERC20 transfer with no _data .\n', '        // Added due to backwards compatibility reasons .\n', '        uint codeLength;\n', '\n', '        assembly {\n', '            // Retrieve the size of the code on target address, this needs assembly .\n', '            codeLength := extcodesize(to)\n', '        }\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(value);\n', '        balances[to] = balances[to].add(value);\n', '        if(codeLength > 0) {\n', '            ERC223ReceivingContract receiver = ERC223ReceivingContract(to);\n', '            receiver.tokenFallback(msg.sender, value, data);\n', '        }\n', '        Transfer(msg.sender, to, value);  // ERC20 transfer event\n', '        Transfer(msg.sender, to, value, data);  // ERC223 transfer event\n', '    }\n', '\n', '    // Standard function transfer similar to ERC20 transfer with no _data .\n', '    // Added due to backwards compatibility reasons .\n', '    function transfer(address to, uint256 value) onlyPayloadSize(2 * 32)  public returns (bool) {\n', '        uint codeLength;\n', '\n', '        assembly {\n', '            // Retrieve the size of the code on target address, this needs assembly .\n', '            codeLength := extcodesize(to)\n', '        }\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(value);\n', '        balances[to] = balances[to].add(value);\n', '        if(codeLength > 0) {\n', '            ERC223ReceivingContract receiver = ERC223ReceivingContract(to);\n', '            bytes memory empty;\n', '            receiver.tokenFallback(msg.sender, value, empty);\n', '        }\n', '        Transfer(msg.sender, to, value);  // ERC20 transfer event\n', '        return true;\n', '    }\n', '}\n', '\n', '// File: contracts/DogRacingToken.sol\n', '\n', '/**\n', ' * DogRacing Token\n', ' */\n', 'contract DogRacingToken is ERC223BasicToken {\n', '  using SafeMath for uint256;\n', '\n', '  string constant public name = "Dog Racing";\n', '  string constant public symbol = "DGR";\n', '  uint8 constant public decimals = 3;\n', '  uint256 constant public totalSupply \t= 326250000 * 1000;\t// Supply is in the smallest units\n', '\n', '  address public owner;   // owner address\n', '\n', '  modifier onlyOwner {\n', '    require(owner == msg.sender);\n', '    _;\n', '  }\n', '\n', '  function DogRacingToken() public {\n', '    owner = msg.sender;\n', '    balances[owner] = totalSupply;   // All tokens are assigned to the owner\n', '  }\n', '\n', '  // Owner may burn own tokens\n', '  function burnTokens(uint256 amount) onlyOwner external {\n', '    balances[owner] = balances[owner].sub(amount);\n', '  }\n', '}']
