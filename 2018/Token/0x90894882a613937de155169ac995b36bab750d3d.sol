['pragma solidity ^0.4.24;\n', ' \n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    // Gas optimization: this is cheaper than asserting &#39;a&#39; not being zero, but the\n', '    // benefit is lost if &#39;b&#39; is also tested.\n', '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev Total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner,address indexed spender,uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(\n', '    address _owner,\n', '    address _spender\n', '   )\n', '    public\n', '    view\n', '    returns (uint256)\n', '  {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(\n', '    address _spender,\n', '    uint _addedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    allowed[msg.sender][_spender] = (\n', '      allowed[msg.sender][_spender].add(_addedValue));\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(\n', '    address _spender,\n', '    uint _subtractedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'contract Ownable {\n', '    \n', '  address public owner;\n', '  \n', '   //这里是个事件，供前端监听\n', '  event OwnerEvent(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.这是一个构造函数，在合约启动时只运行一次，将合约的地址赋给地址owner\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner。这里就是modifier onlyOwner的修饰符，用来判定是否是合约的发布者\n', '   * \n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   * 让合约拥有者修改指定新的合约拥有者，并调用事件来监听\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnerEvent(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '  /**\n', '   * @title TongBi Coin\n', '   * @dev http://www.tongbi.io\n', '   * @dev WeChat:sixinwo\n', '   */\n', 'contract TBCPublishToken is StandardToken,Ownable,Pausable{\n', '    \n', '    string public name ;\n', '    string public symbol ;\n', '    uint8 public decimals ;\n', '    address public owner;\n', ' \n', '    constructor(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 tokenDecimals)  public {\n', '        owner = msg.sender;\n', '        totalSupply_ = initialSupply * 10 ** uint256(tokenDecimals);\n', '        balances[owner] = totalSupply_;\n', '        name = tokenName;\n', '        symbol = tokenSymbol;\n', '        decimals=tokenDecimals;\n', '    }\n', '    \n', '    event Mint(address indexed to, uint256 value);\n', '    event TransferETH(address indexed from, address indexed to, uint256 value);\n', '    \n', '    mapping(address => bool) touched;\n', '    mapping(address => bool) airDropPayabled;\n', '    \n', '    bool public airDropShadowTag = true;\n', '    bool public airDropPayableTag = true;\n', '    uint256 public airDropShadowMoney = 888;\n', '    uint256 public airDropPayableMoney = 88;\n', '    uint256 public airDropTotalSupply = 0;\n', '    uint256 public buyPrice = 40000;\n', '\n', '    function setName(string name_) onlyOwner public{\n', '        name = name_;\n', '    }\n', '    function setSymbol(string symbol_) onlyOwner public{\n', '        symbol = symbol_;\n', '    }\n', '    function setDecimals(uint8 decimals_) onlyOwner public{\n', '        decimals = decimals_;\n', '    }\n', '\n', '    // public functions\n', '    function mint(address _to, uint256 _value) onlyOwner public returns (bool) {\n', '        require(_value > 0 );\n', '        balances[_to]  = balances[_to].add(_value);\n', '        totalSupply_ = totalSupply_.add(_value);\n', '        emit Mint(_to, _value);\n', '        emit Transfer(address(0), _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function setAirDropShadowTag(bool airDropShadowTag_,uint airDropShadowMoney_) onlyOwner public{\n', '        airDropShadowTag = airDropShadowTag_;\n', '        airDropShadowMoney = airDropShadowMoney_;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256) {\n', '        require(msg.sender != address(0));\n', ' \n', '        if(airDropShadowTag  && balances[_owner] == 0)\n', '            balances[_owner] += airDropShadowMoney * 10 ** uint256(decimals);\n', '        return balances[_owner];\n', '    }\n', '    function setPrices(uint256 newBuyPrice) onlyOwner public{\n', '        require(newBuyPrice > 0) ;\n', '        require(buyPrice != newBuyPrice);\n', '        buyPrice = newBuyPrice;\n', '    }\n', '    function setAirDropPayableTag(bool airDropPayableTag_,uint airDropPayableMoney_) onlyOwner public{\n', '        airDropPayableTag = airDropPayableTag_;\n', '        airDropPayableMoney = airDropPayableMoney_;\n', '    }\n', '    function () public payable {\n', '        require(msg.value >= 0 );\n', '        require(msg.sender != owner);\n', '        uint256 amount = airDropPayableMoney * 10 ** uint256(decimals);\n', '        if(msg.value == 0 && airDropShadowTag && !airDropPayabled[msg.sender] && airDropTotalSupply < totalSupply_){\n', '            balances[msg.sender] = balances[msg.sender].add(amount);\n', '            airDropPayabled[msg.sender] = true;\n', '            airDropTotalSupply = airDropTotalSupply.add(amount);\n', '            balances[owner] = balances[owner].sub(amount);\n', '            emit Transfer(owner,msg.sender,amount);\n', '        }else{\n', '            amount = msg.value.mul(buyPrice);\n', '            require(balances[owner]  >= amount);\n', '            balances[msg.sender] = balances[msg.sender].add(amount);\n', '            balances[owner] = balances[owner].sub(amount);\n', '            owner.transfer(msg.value);\n', '            emit TransferETH(msg.sender,owner,msg.value);\n', '            emit Transfer(owner,msg.sender,amount);\n', '        }\n', '    }  \n', '    // events\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    \n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '        require(_value > 0 );\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @dev Burns a specific amount of tokens.\n', '    * @param _value The amount of token to be burned.\n', '    */\n', '    function burn(uint256 _value) public {\n', '        require(_value > 0 );\n', '        _burn(msg.sender, _value);\n', '    }\n', '\n', '    function _burn(address _who, uint256 _value) internal {\n', '        require(_value <= balances[_who]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', '        // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure\n', '    \n', '        balances[_who] = balances[_who].sub(_value);\n', '        totalSupply_ = totalSupply_.sub(_value);\n', '        emit Burn(_who, _value);\n', '        emit Transfer(_who, address(0), _value);\n', '    }\n', '    /**\n', '     * @dev Burns a specific amount of tokens from the target address and decrements allowance\n', '    * @param _from address The address which you want to send tokens from\n', '    * @param _value uint256 The amount of token to be burned\n', '    */\n', '    function burnFrom(address _from, uint256 _value) public {\n', '        require(_value > 0 );\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,\n', '        // this function needs to emit an event with the updated approval.\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        _burn(_from, _value);\n', '    }\n', '    \n', '    function transfer(address _to,uint256 _value) public whenNotPaused returns (bool){\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from,address _to, uint256 _value) public whenNotPaused returns (bool){\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function approve(address _spender,uint256 _value) public whenNotPaused returns (bool){\n', '        return super.approve(_spender, _value);\n', '    }\n', '\n', '    function increaseApproval(address _spender,uint _addedValue) public  whenNotPaused returns (bool success){\n', '     return super.increaseApproval(_spender, _addedValue);\n', '    }\n', '\n', '    function decreaseApproval( address _spender,uint _subtractedValue)  public whenNotPaused returns (bool success){\n', '        return super.decreaseApproval(_spender, _subtractedValue);\n', '    }\n', '    function batchTransfer(address[] _receivers, uint256 _value) public whenNotPaused returns (bool) {\n', '        uint length_ = _receivers.length;\n', '        uint256 amount =  _value.mul(length_);\n', '        require(length_ > 0 );\n', '        require(_value > 0 && balances[msg.sender] >= amount);\n', '    \n', '        balances[msg.sender] = balances[msg.sender].sub(amount);\n', '        for (uint i = 0; i < length_; i++) {\n', '            require (balances[_receivers[i]].add(_value) < balances[_receivers[i]]) ; // Check for overflows\n', '            balances[_receivers[i]] = balances[_receivers[i]].add(_value);\n', '            emit Transfer(msg.sender, _receivers[i], _value);\n', '        }\n', '        return true;\n', '    }\n', '    /**    www.tongbi.io     */\n', '}']
['pragma solidity ^0.4.24;\n', ' \n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', "    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev Total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner,address indexed spender,uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(\n', '    address _owner,\n', '    address _spender\n', '   )\n', '    public\n', '    view\n', '    returns (uint256)\n', '  {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(\n', '    address _spender,\n', '    uint _addedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    allowed[msg.sender][_spender] = (\n', '      allowed[msg.sender][_spender].add(_addedValue));\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(\n', '    address _spender,\n', '    uint _subtractedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'contract Ownable {\n', '    \n', '  address public owner;\n', '  \n', '   //这里是个事件，供前端监听\n', '  event OwnerEvent(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.这是一个构造函数，在合约启动时只运行一次，将合约的地址赋给地址owner\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner。这里就是modifier onlyOwner的修饰符，用来判定是否是合约的发布者\n', '   * \n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   * 让合约拥有者修改指定新的合约拥有者，并调用事件来监听\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnerEvent(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '  /**\n', '   * @title TongBi Coin\n', '   * @dev http://www.tongbi.io\n', '   * @dev WeChat:sixinwo\n', '   */\n', 'contract TBCPublishToken is StandardToken,Ownable,Pausable{\n', '    \n', '    string public name ;\n', '    string public symbol ;\n', '    uint8 public decimals ;\n', '    address public owner;\n', ' \n', '    constructor(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 tokenDecimals)  public {\n', '        owner = msg.sender;\n', '        totalSupply_ = initialSupply * 10 ** uint256(tokenDecimals);\n', '        balances[owner] = totalSupply_;\n', '        name = tokenName;\n', '        symbol = tokenSymbol;\n', '        decimals=tokenDecimals;\n', '    }\n', '    \n', '    event Mint(address indexed to, uint256 value);\n', '    event TransferETH(address indexed from, address indexed to, uint256 value);\n', '    \n', '    mapping(address => bool) touched;\n', '    mapping(address => bool) airDropPayabled;\n', '    \n', '    bool public airDropShadowTag = true;\n', '    bool public airDropPayableTag = true;\n', '    uint256 public airDropShadowMoney = 888;\n', '    uint256 public airDropPayableMoney = 88;\n', '    uint256 public airDropTotalSupply = 0;\n', '    uint256 public buyPrice = 40000;\n', '\n', '    function setName(string name_) onlyOwner public{\n', '        name = name_;\n', '    }\n', '    function setSymbol(string symbol_) onlyOwner public{\n', '        symbol = symbol_;\n', '    }\n', '    function setDecimals(uint8 decimals_) onlyOwner public{\n', '        decimals = decimals_;\n', '    }\n', '\n', '    // public functions\n', '    function mint(address _to, uint256 _value) onlyOwner public returns (bool) {\n', '        require(_value > 0 );\n', '        balances[_to]  = balances[_to].add(_value);\n', '        totalSupply_ = totalSupply_.add(_value);\n', '        emit Mint(_to, _value);\n', '        emit Transfer(address(0), _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function setAirDropShadowTag(bool airDropShadowTag_,uint airDropShadowMoney_) onlyOwner public{\n', '        airDropShadowTag = airDropShadowTag_;\n', '        airDropShadowMoney = airDropShadowMoney_;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256) {\n', '        require(msg.sender != address(0));\n', ' \n', '        if(airDropShadowTag  && balances[_owner] == 0)\n', '            balances[_owner] += airDropShadowMoney * 10 ** uint256(decimals);\n', '        return balances[_owner];\n', '    }\n', '    function setPrices(uint256 newBuyPrice) onlyOwner public{\n', '        require(newBuyPrice > 0) ;\n', '        require(buyPrice != newBuyPrice);\n', '        buyPrice = newBuyPrice;\n', '    }\n', '    function setAirDropPayableTag(bool airDropPayableTag_,uint airDropPayableMoney_) onlyOwner public{\n', '        airDropPayableTag = airDropPayableTag_;\n', '        airDropPayableMoney = airDropPayableMoney_;\n', '    }\n', '    function () public payable {\n', '        require(msg.value >= 0 );\n', '        require(msg.sender != owner);\n', '        uint256 amount = airDropPayableMoney * 10 ** uint256(decimals);\n', '        if(msg.value == 0 && airDropShadowTag && !airDropPayabled[msg.sender] && airDropTotalSupply < totalSupply_){\n', '            balances[msg.sender] = balances[msg.sender].add(amount);\n', '            airDropPayabled[msg.sender] = true;\n', '            airDropTotalSupply = airDropTotalSupply.add(amount);\n', '            balances[owner] = balances[owner].sub(amount);\n', '            emit Transfer(owner,msg.sender,amount);\n', '        }else{\n', '            amount = msg.value.mul(buyPrice);\n', '            require(balances[owner]  >= amount);\n', '            balances[msg.sender] = balances[msg.sender].add(amount);\n', '            balances[owner] = balances[owner].sub(amount);\n', '            owner.transfer(msg.value);\n', '            emit TransferETH(msg.sender,owner,msg.value);\n', '            emit Transfer(owner,msg.sender,amount);\n', '        }\n', '    }  \n', '    // events\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    \n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '        require(_value > 0 );\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @dev Burns a specific amount of tokens.\n', '    * @param _value The amount of token to be burned.\n', '    */\n', '    function burn(uint256 _value) public {\n', '        require(_value > 0 );\n', '        _burn(msg.sender, _value);\n', '    }\n', '\n', '    function _burn(address _who, uint256 _value) internal {\n', '        require(_value <= balances[_who]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', "        // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '    \n', '        balances[_who] = balances[_who].sub(_value);\n', '        totalSupply_ = totalSupply_.sub(_value);\n', '        emit Burn(_who, _value);\n', '        emit Transfer(_who, address(0), _value);\n', '    }\n', '    /**\n', '     * @dev Burns a specific amount of tokens from the target address and decrements allowance\n', '    * @param _from address The address which you want to send tokens from\n', '    * @param _value uint256 The amount of token to be burned\n', '    */\n', '    function burnFrom(address _from, uint256 _value) public {\n', '        require(_value > 0 );\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,\n', '        // this function needs to emit an event with the updated approval.\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        _burn(_from, _value);\n', '    }\n', '    \n', '    function transfer(address _to,uint256 _value) public whenNotPaused returns (bool){\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from,address _to, uint256 _value) public whenNotPaused returns (bool){\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function approve(address _spender,uint256 _value) public whenNotPaused returns (bool){\n', '        return super.approve(_spender, _value);\n', '    }\n', '\n', '    function increaseApproval(address _spender,uint _addedValue) public  whenNotPaused returns (bool success){\n', '     return super.increaseApproval(_spender, _addedValue);\n', '    }\n', '\n', '    function decreaseApproval( address _spender,uint _subtractedValue)  public whenNotPaused returns (bool success){\n', '        return super.decreaseApproval(_spender, _subtractedValue);\n', '    }\n', '    function batchTransfer(address[] _receivers, uint256 _value) public whenNotPaused returns (bool) {\n', '        uint length_ = _receivers.length;\n', '        uint256 amount =  _value.mul(length_);\n', '        require(length_ > 0 );\n', '        require(_value > 0 && balances[msg.sender] >= amount);\n', '    \n', '        balances[msg.sender] = balances[msg.sender].sub(amount);\n', '        for (uint i = 0; i < length_; i++) {\n', '            require (balances[_receivers[i]].add(_value) < balances[_receivers[i]]) ; // Check for overflows\n', '            balances[_receivers[i]] = balances[_receivers[i]].add(_value);\n', '            emit Transfer(msg.sender, _receivers[i], _value);\n', '        }\n', '        return true;\n', '    }\n', '    /**    www.tongbi.io     */\n', '}']
