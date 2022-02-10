['pragma solidity ^0.4.18;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract Releasable is Ownable {\n', '\n', '  event Release();\n', '\n', '  bool public released = false;\n', '\n', '  modifier afterReleased() {\n', '    require(released);\n', '    _;\n', '  }\n', '\n', '  function release() onlyOwner public {\n', '    require(!released);\n', '    released = true;\n', '    Release();\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract Managed is Releasable {\n', '\n', '  mapping (address => bool) public manager;\n', '  event SetManager(address _addr);\n', '  event UnsetManager(address _addr);\n', '\n', '  function Managed() public {\n', '    manager[msg.sender] = true;\n', '  }\n', '\n', '  modifier onlyManager() {\n', '    require(manager[msg.sender]);\n', '    _;\n', '  }\n', '\n', '  function setManager(address _addr) public onlyOwner {\n', '    require(_addr != address(0) && manager[_addr] == false);\n', '    manager[_addr] = true;\n', '\n', '    SetManager(_addr);\n', '  }\n', '\n', '  function unsetManager(address _addr) public onlyOwner {\n', '    require(_addr != address(0) && manager[_addr] == true);\n', '    manager[_addr] = false;\n', '\n', '    UnsetManager(_addr);\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract ReleasableToken is StandardToken, Managed {\n', '\n', '  function transfer(address _to, uint256 _value) public afterReleased returns (bool) {\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  function saleTransfer(address _to, uint256 _value) public onlyManager returns (bool) {\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public afterReleased returns (bool) {\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public afterReleased returns (bool) {\n', '    return super.approve(_spender, _value);\n', '  }\n', '\n', '  function increaseApproval(address _spender, uint _addedValue) public afterReleased returns (bool success) {\n', '    return super.increaseApproval(_spender, _addedValue);\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public afterReleased returns (bool success) {\n', '    return super.decreaseApproval(_spender, _subtractedValue);\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract BurnableToken is ReleasableToken {\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param _value The amount of token to be burned.\n', '     */\n', '    function burn(uint256 _value) onlyManager public {\n', '        require(_value > 0);\n', '        require(_value <= balances[msg.sender]);\n', '        // no need to require value <= tota0lSupply, since that would imply the\n', "        // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        Burn(burner, _value);\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', '  *  GanaToken\n', '  */\n', 'contract GanaToken is BurnableToken {\n', '\n', '  string public constant name = "GANA";\n', '  string public constant symbol = "GANA";\n', '  uint8 public constant decimals = 18;\n', '\n', '  event ClaimedTokens(address manager, address _token, uint256 claimedBalance);\n', '\n', '  function GanaToken() public {\n', '    totalSupply = 2400000000 * 1 ether;\n', '    balances[msg.sender] = totalSupply;\n', '  }\n', '\n', '  function claimTokens(address _token, uint256 _claimedBalance) public onlyManager afterReleased {\n', '    ERC20Basic token = ERC20Basic(_token);\n', '    uint256 tokenBalance = token.balanceOf(this);\n', '    require(tokenBalance >= _claimedBalance);\n', '\n', '    address manager = msg.sender;\n', '    token.transfer(manager, _claimedBalance);\n', '    ClaimedTokens(manager, _token, _claimedBalance);\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', '  *  Whitelist contract\n', '  */\n', 'contract Whitelist is Ownable {\n', '\n', '   mapping (address => bool) public whitelist;\n', '   event Registered(address indexed _addr);\n', '   event Unregistered(address indexed _addr);\n', '\n', '   modifier onlyWhitelisted(address _addr) {\n', '     require(whitelist[_addr]);\n', '     _;\n', '   }\n', '\n', '   function isWhitelist(address _addr) public view returns (bool listed) {\n', '     return whitelist[_addr];\n', '   }\n', '\n', '   function registerAddress(address _addr) public onlyOwner {\n', '     require(_addr != address(0) && whitelist[_addr] == false);\n', '     whitelist[_addr] = true;\n', '     Registered(_addr);\n', '   }\n', '\n', '   function registerAddresses(address[] _addrs) public onlyOwner {\n', '     for(uint256 i = 0; i < _addrs.length; i++) {\n', '       require(_addrs[i] != address(0) && whitelist[_addrs[i]] == false);\n', '       whitelist[_addrs[i]] = true;\n', '       Registered(_addrs[i]);\n', '     }\n', '   }\n', '\n', '   function unregisterAddress(address _addr) public onlyOwner onlyWhitelisted(_addr) {\n', '       whitelist[_addr] = false;\n', '       Unregistered(_addr);\n', '   }\n', '\n', '   function unregisterAddresses(address[] _addrs) public onlyOwner {\n', '     for(uint256 i = 0; i < _addrs.length; i++) {\n', '       require(whitelist[_addrs[i]]);\n', '       whitelist[_addrs[i]] = false;\n', '       Unregistered(_addrs[i]);\n', '     }\n', '   }\n', '\n', '}\n', '\n', '\n', '/**\n', '  *  GanaToken PUBLIC-SALE\n', '  */\n', 'contract GanaTokenPublicSale is Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  GanaToken public gana;\n', '  Whitelist public whitelist;\n', '  address public wallet;\n', '  uint256 public hardCap   = 50000 ether; //publicsale cap\n', '  uint256 public weiRaised = 0;\n', '  uint256 public defaultRate = 20000;\n', '  uint256 public startTime;\n', '  uint256 public endTime;\n', '\n', '  event TokenPurchase(address indexed sender, address indexed buyer, uint256 weiAmount, uint256 ganaAmount);\n', '  event Refund(address indexed buyer, uint256 weiAmount);\n', '  event TransferToSafe();\n', '  event BurnAndReturnAfterEnded(uint256 burnAmount, uint256 returnAmount);\n', '\n', '  function GanaTokenPublicSale(address _gana, address _wallet, address _whitelist, uint256 _startTime, uint256 _endTime) public {\n', '    require(_wallet != address(0));\n', '    gana = GanaToken(_gana);\n', '    whitelist = Whitelist(_whitelist);\n', '    wallet = _wallet;\n', '    startTime = _startTime;\n', '    endTime = _endTime;\n', '  }\n', '\n', '  modifier onlyWhitelisted() {\n', '    require(whitelist.isWhitelist(msg.sender));\n', '    _;\n', '  }\n', '\n', '  // fallback function can be used to buy tokens\n', '  function () external payable {\n', '    buyGana(msg.sender);\n', '  }\n', '\n', '  function buyGana(address buyer) public onlyWhitelisted payable {\n', '    require(!hasEnded());\n', '    require(afterStart());\n', '    require(buyer != address(0));\n', '    require(msg.value > 0);\n', '    require(buyer == msg.sender);\n', '\n', '    uint256 weiAmount = msg.value;\n', '    //pre-calculate wei raise after buying\n', '    uint256 preCalWeiRaised = weiRaised.add(weiAmount);\n', '    uint256 ganaAmount;\n', '    uint256 rate = getRate();\n', '\n', '    if(preCalWeiRaised <= hardCap){\n', '      //the pre-calculate wei raise is less than the hard cap\n', '      ganaAmount = weiAmount.mul(rate);\n', '      gana.saleTransfer(buyer, ganaAmount);\n', '      weiRaised = preCalWeiRaised;\n', '      TokenPurchase(msg.sender, buyer, weiAmount, ganaAmount);\n', '    }else{\n', '      //the pre-calculate weiRaised is more than the hard cap\n', '      uint256 refundWeiAmount = preCalWeiRaised.sub(hardCap);\n', '      uint256 fundWeiAmount =  weiAmount.sub(refundWeiAmount);\n', '      ganaAmount = fundWeiAmount.mul(rate);\n', '      gana.saleTransfer(buyer, ganaAmount);\n', '      weiRaised = weiRaised.add(fundWeiAmount);\n', '      TokenPurchase(msg.sender, buyer, fundWeiAmount, ganaAmount);\n', '      buyer.transfer(refundWeiAmount);\n', '      Refund(buyer,refundWeiAmount);\n', '    }\n', '  }\n', '\n', '  function getRate() public view returns (uint256) {\n', '    if(weiRaised < 15000 ether){\n', '      return 22000;\n', '    }else if(weiRaised < 30000 ether){\n', '      return 21000;\n', '    }else if(weiRaised < 45000 ether){\n', '      return 20500;\n', '    }else{\n', '      return 20000;\n', '    }\n', '  }\n', '\n', '  //Was it sold out or sale overdue\n', '  function hasEnded() public view returns (bool) {\n', '    bool hardCapReached = weiRaised >= hardCap; // valid cap\n', '    return hardCapReached || afterEnded();\n', '  }\n', '\n', '  function afterEnded() internal constant returns (bool) {\n', '    return now > endTime;\n', '  }\n', '\n', '  function afterStart() internal constant returns (bool) {\n', '    return now >= startTime;\n', '  }\n', '\n', '  function transferToSafe() onlyOwner public {\n', '    require(hasEnded());\n', '    wallet.transfer(this.balance);\n', '    TransferToSafe();\n', '  }\n', '\n', '  /**\n', '  * @dev burn unsold token and return bonus token\n', '  * @param reserveWallet reserve pool address\n', '  */\n', '  function burnAndReturnAfterEnded(address reserveWallet) onlyOwner public {\n', '    require(reserveWallet != address(0));\n', '    require(hasEnded());\n', '    uint256 unsoldWei = hardCap.sub(weiRaised);\n', '    uint256 ganaBalance = gana.balanceOf(this);\n', '    require(ganaBalance > 0);\n', '\n', '    if(unsoldWei > 0){\n', '      //Burn unsold and return bonus\n', '      uint256 unsoldGanaAmount = ganaBalance;\n', '      uint256 burnGanaAmount = unsoldWei.mul(defaultRate);\n', '      uint256 bonusGanaAmount = unsoldGanaAmount.sub(burnGanaAmount);\n', '      gana.burn(burnGanaAmount);\n', '      gana.saleTransfer(reserveWallet, bonusGanaAmount);\n', '      BurnAndReturnAfterEnded(burnGanaAmount, bonusGanaAmount);\n', '    }else{\n', '      //All tokens were sold. return bonus\n', '      gana.saleTransfer(reserveWallet, ganaBalance);\n', '      BurnAndReturnAfterEnded(0, ganaBalance);\n', '    }\n', '  }\n', '\n', '  /**\n', '  * @dev emergency function before sale\n', '  * @param returnAddress return token address\n', '  */\n', '  function returnGanaBeforeSale(address returnAddress) onlyOwner public {\n', '    require(returnAddress != address(0));\n', '    require(weiRaised == 0);\n', '    uint256 returnGana = gana.balanceOf(this);\n', '    gana.saleTransfer(returnAddress, returnGana);\n', '  }\n', '\n', '}']