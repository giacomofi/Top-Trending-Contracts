['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '  \n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    Unpause();\n', '  }\n', '}\n', '/**\n', ' * @title Destructible\n', ' * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.\n', ' */\n', 'contract Destructible is Ownable {\n', '\n', '  function Destructible() public payable { }\n', '\n', '  /**\n', '   * @dev Transfers the current balance to the owner and terminates the contract.\n', '   */\n', '  function destroy() onlyOwner public {\n', '    selfdestruct(owner);\n', '  }\n', '\n', '  function destroyAndSend(address _recipient) onlyOwner public {\n', '    selfdestruct(_recipient);\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' */\n', 'contract ERC20Basic  {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic, Pausable {\n', '  using SafeMath for uint256;\n', '  uint256 public etherRaised;\n', '  mapping(address => uint256) balances;\n', '  address companyReserve;\n', '  uint256 deployTime;\n', '  modifier isUserAbleToTransferCheck(uint256 _value) {\n', '  if(msg.sender == companyReserve){\n', '          uint256 balanceRemaining = balanceOf(companyReserve);\n', '          uint256 timeDiff = now - deployTime;\n', '          uint256 totalMonths = timeDiff / 30 days;\n', '          if(totalMonths == 0){\n', '              totalMonths  = 1;\n', '          }\n', '          uint256 percentToWitdraw = totalMonths * 5;\n', '          uint256 tokensToWithdraw = ((25000000 * (10**18)) * percentToWitdraw)/100;\n', '          uint256 spentTokens = (25000000 * (10**18)) - balanceRemaining;\n', '          if(spentTokens + _value <= tokensToWithdraw){\n', '              _;\n', '          }\n', '          else{\n', '              revert();\n', '          }\n', '        }else{\n', '           _;\n', '        }\n', '    }\n', '    \n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public  isUserAbleToTransferCheck(_value) returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '    \n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', 'contract BurnableToken is BasicToken {\n', '    using SafeMath for uint256;\n', '  event Burn(address indexed burner, uint256 value);\n', '\n', '  /**\n', '   * @dev Burns a specific amount of tokens.\n', '   * @param _value The amount of token to be burned.\n', '   */\n', '  function burn(uint256 _value) public {\n', '    require(_value <= balances[msg.sender]);\n', '    // no need to require value <= totalSupply, since that would imply the\n', "    // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '\n', '    address burner = msg.sender;\n', '    balances[burner] = balances[burner].sub(_value);\n', '    totalSupply= totalSupply.sub(_value);\n', '    Burn(burner, _value);\n', '  }\n', '}\n', 'contract StandardToken is ERC20, BurnableToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  \n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public isUserAbleToTransferCheck(_value) returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   */\n', '  function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract POTENTIAM is StandardToken, Destructible {\n', '    string public constant name = "POTENTIAM";\n', '    using SafeMath for uint256;\n', '    uint public constant decimals = 18;\n', '    string public constant symbol = "PTM";\n', '    uint public priceOfToken=250000000000000;//1 eth = 4000 PTM\n', '    address[] allParticipants;\n', '   \n', '    uint tokenSales=0;\n', '    uint256 public firstWeekPreICOBonusEstimate;\n', '    uint256  public secondWeekPreICOBonusEstimate;\n', '    uint256  public firstWeekMainICOBonusEstimate;\n', '    uint256 public secondWeekMainICOBonusEstimate;\n', '    uint256 public thirdWeekMainICOBonusEstimate;\n', '    uint256 public forthWeekMainICOBonusEstimate;\n', '    uint256 public firstWeekPreICOBonusRate;\n', '    uint256 secondWeekPreICOBonusRate;\n', '    uint256 firstWeekMainICOBonusRate;\n', '    uint256 secondWeekMainICOBonusRate;\n', '    uint256 thirdWeekMainICOBonusRate;\n', '    uint256 forthWeekMainICOBonusRate;\n', '    uint256 totalWeiRaised = 0;\n', '    function POTENTIAM()  public {\n', '       totalSupply = 100000000 * (10**decimals);  // \n', '       owner = msg.sender;\n', '       companyReserve =   0xd311cB7D961B46428d766df0eaE7FE83Fc8B7B5c;\n', '       balances[msg.sender] += 75000000 * (10 **decimals);\n', '       balances[companyReserve]  += 25000000 * (10**decimals);\n', '       firstWeekPreICOBonusEstimate = now + 7 days;\n', '       deployTime = now;\n', '       secondWeekPreICOBonusEstimate = firstWeekPreICOBonusEstimate + 7 days;\n', '       firstWeekMainICOBonusEstimate = firstWeekPreICOBonusEstimate + 14 days;\n', '       secondWeekMainICOBonusEstimate = firstWeekPreICOBonusEstimate + 21 days;\n', '       thirdWeekMainICOBonusEstimate = firstWeekPreICOBonusEstimate + 28 days;\n', '       forthWeekMainICOBonusEstimate = firstWeekPreICOBonusEstimate + 35 days;\n', '       firstWeekPreICOBonusRate = 20;\n', '       secondWeekPreICOBonusRate = 18;\n', '       firstWeekMainICOBonusRate = 12;\n', '       secondWeekMainICOBonusRate = 8;\n', '       thirdWeekMainICOBonusRate = 4;\n', '       forthWeekMainICOBonusRate = 0;\n', '    }\n', '\n', '    function()  public whenNotPaused payable {\n', '        require(msg.value>0);\n', '        require(now<=forthWeekMainICOBonusEstimate);\n', '        require(tokenSales < (60000000 * (10 **decimals)));\n', '        uint256 bonus = 0;\n', '        if(now<=firstWeekPreICOBonusEstimate && totalWeiRaised < 3000 ether){\n', '            bonus = firstWeekPreICOBonusRate;\n', '        }else if(now <=secondWeekPreICOBonusEstimate && totalWeiRaised < 5000 ether){\n', '            bonus = secondWeekPreICOBonusRate;\n', '        }else if(now<=firstWeekMainICOBonusEstimate && totalWeiRaised < 9000 ether){\n', '            bonus = firstWeekMainICOBonusRate;\n', '        }else if(now<=secondWeekMainICOBonusEstimate && totalWeiRaised < 12000 ether){\n', '            bonus = secondWeekMainICOBonusRate;\n', '        }\n', '        else if(now<=thirdWeekMainICOBonusEstimate && totalWeiRaised <14000 ether){\n', '            bonus = thirdWeekMainICOBonusRate;\n', '        }\n', '        uint256 tokens = (msg.value * (10 ** decimals)) / priceOfToken;\n', '        uint256 bonusTokens = ((tokens * bonus) /100); \n', '        tokens +=bonusTokens;\n', '          if(balances[owner] <tokens) //check etiher owner can have token otherwise reject transaction and ether\n', '        {\n', '           revert();\n', '        }\n', '        allowed[owner][msg.sender] += tokens;\n', '        bool transferRes=transferFrom(owner, msg.sender, tokens);\n', '        if (!transferRes) {\n', '            revert();\n', '        }\n', '        else{\n', '            tokenSales += tokens;\n', '            etherRaised += msg.value;\n', '            totalWeiRaised +=msg.value;\n', '        }\n', '    }//end of fallback\n', '    /**\n', '    * Transfer entire balance to any account (by owner and admin only)\n', '    **/\n', '    function transferFundToAccount(address _accountByOwner) public onlyOwner {\n', '        require(etherRaised > 0);\n', '        _accountByOwner.transfer(etherRaised);\n', '        etherRaised = 0;\n', '    }\n', '\n', '    function resetTokenOfAddress(address _userAddr, uint256 _tokens) public onlyOwner returns (uint256){\n', '       require(_userAddr !=0); \n', '       require(balanceOf(_userAddr)>=_tokens);\n', '        balances[_userAddr] = balances[_userAddr].sub(_tokens);\n', '        balances[owner] = balances[owner].add(_tokens);\n', '        return balances[_userAddr];\n', '    }\n', '   \n', '    /**\n', '    * Transfer part of balance to any account (by owner and admin only)\n', '    **/\n', '    function transferLimitedFundToAccount(address _accountByOwner, uint256 balanceToTransfer) public onlyOwner   {\n', '        require(etherRaised > balanceToTransfer);\n', '        _accountByOwner.transfer(balanceToTransfer);\n', '        etherRaised -= balanceToTransfer;\n', '    }\n', '  \n', '}']