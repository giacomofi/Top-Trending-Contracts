['pragma solidity 0.4.21;\n', '\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a / b;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @dev The "SCHTSub" contract is the interface declaration of a Sub-Contract that is paired with this current instance of the Master Contract.\n', ' */\n', 'contract SCHTSub {\n', '  function changeStage(uint256 stageCapValue) public;\n', '  function transfer(address _to, uint256 _value, address origin) public returns (bool);\n', '  function transferFromTo(address _from, address _to, uint256 _value, address origin) public returns (bool);\n', '  function transferFrom(address _from, address _to, uint256 _value, address origin) public returns (bool);\n', '  function approve(address _spender, uint256 _value, address origin) public returns (bool);\n', '  function increaseApproval(address _spender, uint256 _addedValue, address origin) public returns (bool);\n', '  function decreaseApproval(address _spender, uint256 _subtractedValue, address origin) public returns (bool);\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public ctOwner;\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == ctOwner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.\n', '   */\n', '  function Ownable() public {\n', '    ctOwner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(ctOwner, newOwner);\n', '    ctOwner = newOwner;\n', '  }\n', '}\n', '\n', 'contract SubRule is Ownable {\n', '  address public subContractAddr;\n', '\n', '  function setSubContractAddr(address _newSubAddr) public onlyOwner {\n', '    subContractAddr = _newSubAddr;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any contract other than the Sub-Contract address that has been set.\n', '   */\n', '  modifier onlySubContract() {\n', '    require(msg.sender == subContractAddr);\n', '    _;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Destructible\n', ' * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.\n', ' */\n', 'contract Destructible is SubRule {\n', '\n', '  function Destructible() public payable { }\n', '\n', '  /**\n', '   * @dev Transfers the current balance to the owner and terminates the contract.\n', '   */\n', '  function destroy() onlyOwner public {\n', '    selfdestruct(ctOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers the current balance to the _recipient address and terminates the contract.\n', '   */\n', '  function destroyAndSend(address _recipient) onlyOwner public {\n', '    selfdestruct(_recipient);\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Capable\n', ' * @dev The Capable contract has a cap value for each stage of the token Sale, Only set/reset by owner.\n', ' */\n', 'contract Capable is Destructible {\n', '  using SafeMath for uint256;\n', '  uint256 saleStage;\n', '  uint256 currentStageSpent;\n', '  uint256 currentStageCap;\n', '\n', '  event StageChanged(uint256 indexed previousStage, uint256 indexed newStage);\n', '\n', '  function getCurrentStage() public view returns (uint256) {\n', '    return saleStage;\n', '  }\n', '\n', '  function getCurrentStageSpent() public view returns (uint256) {\n', '    return currentStageSpent;\n', '  }\n', '\n', '  function getCurrentRemainingCap() public view returns (uint256) {\n', '    return currentStageCap.sub(currentStageSpent);\n', '  }\n', '\n', '  function getCurrentCap() public view returns (uint256) {\n', '    return currentStageCap;\n', '  }\n', '\n', '  function setCurrentStageSpent(uint256 _value) public onlySubContract {\n', '    currentStageSpent = _value;\n', '  }\n', '\n', '  function setCurrentCap(uint256 _value) public onlySubContract {\n', '    currentStageCap = _value;\n', '  }\n', '\n', '  function incrementStage() public onlySubContract {\n', '    saleStage = saleStage+1;\n', '  }\n', '\n', '  function changeStage(uint256 stageCapValue) public onlyOwner returns (bool){\n', '    SCHTSub sc = SCHTSub(subContractAddr);\n', '    sc.changeStage(stageCapValue);\n', '    emit StageChanged(saleStage-1, saleStage);\n', '    return true;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic interface\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  function transferFromTo(address from, address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title BasicToken\n', ' */\n', 'contract BasicToken is ERC20Basic, Capable {\n', '  mapping(address => uint256) balances;\n', '  mapping(address => address) addrIndex;\n', '\n', '  uint256 totalSupply_;\n', '  uint256 totalSpent_;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '   /**\n', '  * @dev total number of tokens spent in sale stages\n', '  */\n', '  function getTotalSpent() public view returns (uint256) {\n', '    return totalSpent_;\n', '  }\n', '\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    SCHTSub sc = SCHTSub(subContractAddr);\n', '    bool result = sc.transfer(_to, _value, msg.sender);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return result;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _from The address to transfer from.\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transferFromTo(address _from, address _to, uint256 _value) public returns (bool) {\n', '    SCHTSub sc = SCHTSub(subContractAddr);\n', '    bool result = sc.transferFromTo(_from, _to, _value, msg.sender);\n', '    emit Transfer(_from, _to, _value);\n', '    return result;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function setBalanceForAddr( address _addr, uint256 _value) public onlySubContract {\n', '    balances[_addr] = _value;\n', '  }\n', '\n', '   function setTotalSpent(uint256 _value) public onlySubContract {\n', '    totalSpent_=_value;\n', '  }\n', '\n', '  function addAddrToIndex(address _addr) public onlySubContract {\n', '    if(!isAddrExists(_addr)){\n', '      addrIndex[_addr] = _addr;\n', '    }\n', '  }\n', '\n', '  function isAddrExists(address _addr) public view returns (bool) {\n', '    return (_addr == addrIndex[_addr]);\n', '  }\n', '}\n', '\n', '/**\n', ' * @title BurnableToken\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract BurnableToken is BasicToken {\n', '\n', '  event Burn(address indexed burner, uint256 value);\n', '\n', '  /**\n', '   * @dev Burns a specific amount of tokens.\n', '   * @param _value The amount of token to be burned.\n', '   */\n', '  function burn(uint256 _value) public onlyOwner {\n', '    require(_value <= balances[msg.sender]);\n', '    address burner = msg.sender;\n', '    balances[burner] = balances[burner].sub(_value);\n', '    totalSupply_ = totalSupply_.sub(_value);\n', '    emit Burn(burner, _value);\n', '    emit Transfer(burner, address(0), _value);\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' * @dev Implementation of the basic standard token.\n', ' */\n', 'contract StandardToken is ERC20, BurnableToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    SCHTSub sc = SCHTSub(subContractAddr);\n', '    bool result = sc.approve(_spender,_value, msg.sender);\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return result;\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    SCHTSub sc = SCHTSub(subContractAddr);\n', '    bool result = sc.transferFrom(_from, _to, _value, msg.sender);\n', '    emit Transfer(_from, _to, _value);\n', '    return result;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  function setAllowance(address _owner, address _spender, uint256 _value) public onlySubContract returns (bool) {\n', '    allowed[_owner][_spender] = _value;\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {\n', '    SCHTSub sc = SCHTSub(subContractAddr);\n', '    bool result = sc.increaseApproval(_spender,_addedValue, msg.sender);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return result;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {\n', '    SCHTSub sc = SCHTSub(subContractAddr);\n', '    bool result = sc.decreaseApproval(_spender,_subtractedValue,msg.sender);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return result;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title SCHToken\n', ' * All tokens are pre-assigned to the creator.\n', ' */\n', '\n', 'contract SCHToken is StandardToken {\n', '\n', '  string public constant name = "SCHToken";\n', '  string public constant symbol = "SCHT";\n', '  uint8 public constant decimals = 18;\n', '\n', '  uint256 public constant INITIAL_SUPPLY = 400000000 * (10 ** uint256(decimals));\n', '\n', '  /**\n', '   * @dev Constructor that gives msg.sender all of existing tokens\n', '   * Defines stages and Stage Caps.\n', '   */\n', '  function SCHToken() public {\n', '    totalSupply_ = INITIAL_SUPPLY;\n', '    totalSpent_ = 0;\n', '    balances[msg.sender] = INITIAL_SUPPLY;\n', '    emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);\n', '\n', '    saleStage = 0;\n', '    currentStageSpent = 0;\n', '    currentStageCap = 0;\n', '  }\n', '}']