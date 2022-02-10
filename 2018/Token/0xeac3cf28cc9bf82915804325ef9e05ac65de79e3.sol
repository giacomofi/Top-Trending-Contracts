['pragma solidity ^0.4.19;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    Unpause();\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', '   @title ERC827 interface, an extension of ERC20 token standard\n', '\n', '   Interface of a ERC827 token, following the ERC20 standard with extra\n', '   methods to transfer value and data and execute calls in transfers and\n', '   approvals.\n', ' */\n', 'contract ERC827 is ERC20 {\n', '\n', '  function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);\n', '  function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);\n', '  function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);\n', '\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '/**\n', '   @title ERC827, an extension of ERC20 token standard\n', '\n', '   Implementation the ERC827, following the ERC20 standard with extra\n', '   methods to transfer value and data and execute calls in transfers and\n', '   approvals.\n', '   Uses OpenZeppelin StandardToken.\n', ' */\n', 'contract ERC827Token is ERC827, StandardToken {\n', '\n', '  /**\n', '     @dev Addition to ERC20 token methods. It allows to\n', '     approve the transfer of value and execute a call with the sent data.\n', '\n', '     Beware that changing an allowance with this method brings the risk that\n', '     someone may use both the old and the new allowance by unfortunate\n', '     transaction ordering. One possible solution to mitigate this race condition\n', '     is to first reduce the spender&#39;s allowance to 0 and set the desired value\n', '     afterwards:\n', '     https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '\n', '     @param _spender The address that will spend the funds.\n', '     @param _value The amount of tokens to be spent.\n', '     @param _data ABI-encoded contract call to call `_to` address.\n', '\n', '     @return true if the call function was executed successfully\n', '   */\n', '  function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {\n', '    require(_spender != address(this));\n', '\n', '    super.approve(_spender, _value);\n', '\n', '    require(_spender.call(_data));\n', '\n', '    return true;\n', '  }\n', '\n', '  /**\n', '     @dev Addition to ERC20 token methods. Transfer tokens to a specified\n', '     address and execute a call with the sent data on the same transaction\n', '\n', '     @param _to address The address which you want to transfer to\n', '     @param _value uint256 the amout of tokens to be transfered\n', '     @param _data ABI-encoded contract call to call `_to` address.\n', '\n', '     @return true if the call function was executed successfully\n', '   */\n', '  function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {\n', '    require(_to != address(this));\n', '\n', '    super.transfer(_to, _value);\n', '\n', '    require(_to.call(_data));\n', '    return true;\n', '  }\n', '\n', '  /**\n', '     @dev Addition to ERC20 token methods. Transfer tokens from one address to\n', '     another and make a contract call on the same transaction\n', '\n', '     @param _from The address which you want to send tokens from\n', '     @param _to The address which you want to transfer to\n', '     @param _value The amout of tokens to be transferred\n', '     @param _data ABI-encoded contract call to call `_to` address.\n', '\n', '     @return true if the call function was executed successfully\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {\n', '    require(_to != address(this));\n', '\n', '    super.transferFrom(_from, _to, _value);\n', '\n', '    require(_to.call(_data));\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Addition to StandardToken methods. Increase the amount of tokens that\n', '   * an owner allowed to a spender and execute a call with the sent data.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   * @param _data ABI-encoded contract call to call `_spender` address.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {\n', '    require(_spender != address(this));\n', '\n', '    super.increaseApproval(_spender, _addedValue);\n', '\n', '    require(_spender.call(_data));\n', '\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Addition to StandardToken methods. Decrease the amount of tokens that\n', '   * an owner allowed to a spender and execute a call with the sent data.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   * @param _data ABI-encoded contract call to call `_spender` address.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {\n', '    require(_spender != address(this));\n', '\n', '    super.decreaseApproval(_spender, _subtractedValue);\n', '\n', '    require(_spender.call(_data));\n', '\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title JOYToken\n', ' * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.\n', ' * Note they can later distribute these tokens as they wish using `transfer` and other\n', ' * `StandardToken` functions.\n', ' */\n', 'contract JOYToken is Pausable, ERC827Token {\n', '\n', '    string public constant name = "BLOCK JOY";\n', '    string public constant symbol = "JOY";\n', '    uint256 public constant decimals = 18;\n', '\n', '    uint256 public constant exchangeRatio = 10000;\n', '    uint256 public constant sellCut = 1000;\n', '\n', '    uint256 public incomeFees;\n', '    address public cfoAddress;\n', '\n', '    event Buy(address indexed buyer, uint256 ethAmount, uint256 tokenAmount);\n', '    event Sell(address indexed seller, uint256 tokenAmount, uint256 ethAmount);\n', '\n', '    function JOYToken() public {\n', '        cfoAddress = msg.sender;\n', '    }\n', '\n', '    // @dev sell token\n', '    function sell(uint256 _tokenCount) external {\n', '        require(_tokenCount > 0);\n', '        require(_tokenCount <= balances[msg.sender]);\n', '        balances[msg.sender] = balances[msg.sender].sub(_tokenCount);\n', '        totalSupply_ = totalSupply_.sub(_tokenCount);\n', '        Transfer(msg.sender, 0x0, _tokenCount);\n', '        uint256 value = _tokenCount.div(exchangeRatio);\n', '        uint256 cut = value.div(sellCut);\n', '        value = value.sub(cut);\n', '        Sell(msg.sender, _tokenCount, value);\n', '        if (cut > 0) {\n', '            incomeFees = incomeFees.add(cut);\n', '        }\n', '        if (value > 0) {\n', '            msg.sender.transfer(value);\n', '        }\n', '    }\n', '\n', '    function setCFO(address _newCFO) external onlyOwner {\n', '        require(_newCFO != address(0));\n', '\n', '        cfoAddress = _newCFO;\n', '    }\n', '\n', '    modifier onlyCFO() {\n', '        require(msg.sender == cfoAddress);\n', '        _;\n', '    }\n', '\n', '    /// @dev Remove all fees from the contract\n', '    function withdrawFees(uint256 _value) external onlyCFO {\n', '\n', '        // We are using this boolean method to make sure that even if one fails it will still work\n', '        require(_value <= incomeFees);\n', '        incomeFees = incomeFees.sub(_value);\n', '        cfoAddress.transfer(_value);\n', '    }\n', '\n', '    // @dev buy token\n', '    function() external payable whenNotPaused {\n', '        require(msg.value > 0);\n', '        uint256 _count = msg.value;\n', '        uint256 tokenCount = _count.mul(exchangeRatio);\n', '        \n', '        totalSupply_ = totalSupply_.add(tokenCount);\n', '        balances[msg.sender] = balances[msg.sender].add(tokenCount);\n', '        Buy(msg.sender, _count, tokenCount);\n', '        Transfer(0x0, msg.sender, tokenCount);\n', '    }\n', '}']
['pragma solidity ^0.4.19;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    Unpause();\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', '   @title ERC827 interface, an extension of ERC20 token standard\n', '\n', '   Interface of a ERC827 token, following the ERC20 standard with extra\n', '   methods to transfer value and data and execute calls in transfers and\n', '   approvals.\n', ' */\n', 'contract ERC827 is ERC20 {\n', '\n', '  function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);\n', '  function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);\n', '  function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);\n', '\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '/**\n', '   @title ERC827, an extension of ERC20 token standard\n', '\n', '   Implementation the ERC827, following the ERC20 standard with extra\n', '   methods to transfer value and data and execute calls in transfers and\n', '   approvals.\n', '   Uses OpenZeppelin StandardToken.\n', ' */\n', 'contract ERC827Token is ERC827, StandardToken {\n', '\n', '  /**\n', '     @dev Addition to ERC20 token methods. It allows to\n', '     approve the transfer of value and execute a call with the sent data.\n', '\n', '     Beware that changing an allowance with this method brings the risk that\n', '     someone may use both the old and the new allowance by unfortunate\n', '     transaction ordering. One possible solution to mitigate this race condition\n', "     is to first reduce the spender's allowance to 0 and set the desired value\n", '     afterwards:\n', '     https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '\n', '     @param _spender The address that will spend the funds.\n', '     @param _value The amount of tokens to be spent.\n', '     @param _data ABI-encoded contract call to call `_to` address.\n', '\n', '     @return true if the call function was executed successfully\n', '   */\n', '  function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {\n', '    require(_spender != address(this));\n', '\n', '    super.approve(_spender, _value);\n', '\n', '    require(_spender.call(_data));\n', '\n', '    return true;\n', '  }\n', '\n', '  /**\n', '     @dev Addition to ERC20 token methods. Transfer tokens to a specified\n', '     address and execute a call with the sent data on the same transaction\n', '\n', '     @param _to address The address which you want to transfer to\n', '     @param _value uint256 the amout of tokens to be transfered\n', '     @param _data ABI-encoded contract call to call `_to` address.\n', '\n', '     @return true if the call function was executed successfully\n', '   */\n', '  function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {\n', '    require(_to != address(this));\n', '\n', '    super.transfer(_to, _value);\n', '\n', '    require(_to.call(_data));\n', '    return true;\n', '  }\n', '\n', '  /**\n', '     @dev Addition to ERC20 token methods. Transfer tokens from one address to\n', '     another and make a contract call on the same transaction\n', '\n', '     @param _from The address which you want to send tokens from\n', '     @param _to The address which you want to transfer to\n', '     @param _value The amout of tokens to be transferred\n', '     @param _data ABI-encoded contract call to call `_to` address.\n', '\n', '     @return true if the call function was executed successfully\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {\n', '    require(_to != address(this));\n', '\n', '    super.transferFrom(_from, _to, _value);\n', '\n', '    require(_to.call(_data));\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Addition to StandardToken methods. Increase the amount of tokens that\n', '   * an owner allowed to a spender and execute a call with the sent data.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   * @param _data ABI-encoded contract call to call `_spender` address.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {\n', '    require(_spender != address(this));\n', '\n', '    super.increaseApproval(_spender, _addedValue);\n', '\n', '    require(_spender.call(_data));\n', '\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Addition to StandardToken methods. Decrease the amount of tokens that\n', '   * an owner allowed to a spender and execute a call with the sent data.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   * @param _data ABI-encoded contract call to call `_spender` address.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {\n', '    require(_spender != address(this));\n', '\n', '    super.decreaseApproval(_spender, _subtractedValue);\n', '\n', '    require(_spender.call(_data));\n', '\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title JOYToken\n', ' * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.\n', ' * Note they can later distribute these tokens as they wish using `transfer` and other\n', ' * `StandardToken` functions.\n', ' */\n', 'contract JOYToken is Pausable, ERC827Token {\n', '\n', '    string public constant name = "BLOCK JOY";\n', '    string public constant symbol = "JOY";\n', '    uint256 public constant decimals = 18;\n', '\n', '    uint256 public constant exchangeRatio = 10000;\n', '    uint256 public constant sellCut = 1000;\n', '\n', '    uint256 public incomeFees;\n', '    address public cfoAddress;\n', '\n', '    event Buy(address indexed buyer, uint256 ethAmount, uint256 tokenAmount);\n', '    event Sell(address indexed seller, uint256 tokenAmount, uint256 ethAmount);\n', '\n', '    function JOYToken() public {\n', '        cfoAddress = msg.sender;\n', '    }\n', '\n', '    // @dev sell token\n', '    function sell(uint256 _tokenCount) external {\n', '        require(_tokenCount > 0);\n', '        require(_tokenCount <= balances[msg.sender]);\n', '        balances[msg.sender] = balances[msg.sender].sub(_tokenCount);\n', '        totalSupply_ = totalSupply_.sub(_tokenCount);\n', '        Transfer(msg.sender, 0x0, _tokenCount);\n', '        uint256 value = _tokenCount.div(exchangeRatio);\n', '        uint256 cut = value.div(sellCut);\n', '        value = value.sub(cut);\n', '        Sell(msg.sender, _tokenCount, value);\n', '        if (cut > 0) {\n', '            incomeFees = incomeFees.add(cut);\n', '        }\n', '        if (value > 0) {\n', '            msg.sender.transfer(value);\n', '        }\n', '    }\n', '\n', '    function setCFO(address _newCFO) external onlyOwner {\n', '        require(_newCFO != address(0));\n', '\n', '        cfoAddress = _newCFO;\n', '    }\n', '\n', '    modifier onlyCFO() {\n', '        require(msg.sender == cfoAddress);\n', '        _;\n', '    }\n', '\n', '    /// @dev Remove all fees from the contract\n', '    function withdrawFees(uint256 _value) external onlyCFO {\n', '\n', '        // We are using this boolean method to make sure that even if one fails it will still work\n', '        require(_value <= incomeFees);\n', '        incomeFees = incomeFees.sub(_value);\n', '        cfoAddress.transfer(_value);\n', '    }\n', '\n', '    // @dev buy token\n', '    function() external payable whenNotPaused {\n', '        require(msg.value > 0);\n', '        uint256 _count = msg.value;\n', '        uint256 tokenCount = _count.mul(exchangeRatio);\n', '        \n', '        totalSupply_ = totalSupply_.add(tokenCount);\n', '        balances[msg.sender] = balances[msg.sender].add(tokenCount);\n', '        Buy(msg.sender, _count, tokenCount);\n', '        Transfer(0x0, msg.sender, tokenCount);\n', '    }\n', '}']
