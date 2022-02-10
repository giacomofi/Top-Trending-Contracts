['pragma solidity ^0.4.16;\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    modifier onlyOwner() {\n', '        if (msg.sender == owner)\n', '            _;\n', '        else {\n', '            revert();\n', '        }\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   *  modifier to allow actions only when the contract IS paused\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   *  modifier to allow actions only when the contract IS NOT paused\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   *  called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() public onlyOwner whenNotPaused {\n', '    paused = true;\n', '    Pause();\n', '  }\n', '\n', '  /**\n', '   *  called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() public  onlyOwner whenPaused {\n', '    paused = false;\n', '    Unpause();\n', '  }\n', '}\n', 'contract Mortal is Ownable {\n', '\n', '    function kill()  public {\n', '        if (msg.sender == owner) {\n', '            selfdestruct(owner);\n', '        }\n', '    }\n', '}\n', 'contract UserTokensControl is Ownable{\n', '    uint256 isUserAbleToTransferTime = 1579174400000;//control for transfer Thu Jan 16 2020 \n', '    modifier isUserAbleToTransferCheck(uint balance,uint _value) {\n', '      if(msg.sender == 0x3b06AC092339D382050C892aD035b5F140B7C628){\n', '         if(now<isUserAbleToTransferTime){\n', '             revert();\n', '         }\n', '         _;\n', '      }else {\n', '          _;\n', '      }\n', '    }\n', '   \n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic, Pausable , UserTokensControl{\n', '  using SafeMath for uint256;\n', ' \n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public whenNotPaused isUserAbleToTransferCheck(balances[msg.sender],_value) returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '   // Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  \n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused isUserAbleToTransferCheck(balances[msg.sender],_value) returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '  //  Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   */\n', '  function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract Potentium is StandardToken, Mortal {\n', '    string public constant name = "POTENTIAM";\n', '    uint public constant decimals = 18;\n', '    string public constant symbol = "PTM";\n', '    address companyReserve;\n', '    uint saleEndDate;\n', '    uint public amountRaisedInWei;\n', '    uint public priceOfToken=1041600000000000;//0.0010416 ETH\n', '    address[] allParticipants;\n', '    uint tokenSales=0;\n', '     mapping(address => uint256)public  balancesHold;\n', '    event TokenHold( address indexed to, uint256 value);\n', '    mapping (address => bool) isParticipated;\n', '    uint public icoStartDate;\n', '    uint public icoWeek1Bonus = 10;\n', '    uint public icoWeek2Bonus = 7;\n', '    uint public icoWeek3Bonus = 5;\n', '    uint public icoWeek4Bonus = 3;\n', '    function Potentium()  public {\n', '      totalSupply=100000000 *(10**decimals);  // \n', '       owner = msg.sender;\n', '       companyReserve=0x3b06AC092339D382050C892aD035b5F140B7C628;\n', '       balances[msg.sender] = 75000000 * (10**decimals);\n', '       balances[companyReserve] = 25000000 * (10**decimals); //given by potentieum\n', '      saleEndDate =  1520554400000;  //8 March 2018\n', '    }\n', '\n', '    \n', '    function() payable whenNotPaused public {\n', '        require(msg.sender !=0x0);\n', '        require(now<=saleEndDate);\n', '        require(msg.value >=40000000000000000); //minimum 0.04 eth\n', '        require(tokenSales<=(60000000 * (10 ** decimals)));\n', '        uint256 tokens = (msg.value * (10 ** decimals)) / priceOfToken;\n', '        uint256 bonusTokens = 0;\n', '        if(now <1513555100000){\n', '            bonusTokens = (tokens * 40) /100; //17 dec 2017 % bonus presale\n', '        }else if(now <1514760800000) {\n', '            bonusTokens = (tokens * 35) /100; //31 dec 2017 % bonus\n', '        }else if(now <1515369600000){\n', '            bonusTokens = (tokens * 30) /100; //jan 7 2018 bonus\n', '        }else if(now <1515974400000){\n', '            bonusTokens = (tokens * 25) /100; //jan 14 2018 bonus\n', '        }\n', '        else if(now <1516578400000){\n', '            bonusTokens = (tokens * 20) /100; //jan 21 2018 bonus\n', '        }else if(now <1517011400000){\n', '              bonusTokens = (tokens * 15) /100; //jan 26 2018 bonus\n', '        }\n', '        else if(now>=icoStartDate){\n', '            if(now <= (icoStartDate + 1 * 7 days) ){\n', '                bonusTokens = (tokens * icoWeek1Bonus) /100; \n', '            }\n', '            else if(now <= (icoStartDate + 2 * 7 days) ){\n', '                bonusTokens = (tokens * icoWeek2Bonus) /100; \n', '            }\n', '           else if(now <= (icoStartDate + 3 * 7 days) ){\n', '                bonusTokens = (tokens * icoWeek3Bonus) /100; \n', '            }\n', '           else if(now <= (icoStartDate + 4 * 7 days) ){\n', '                bonusTokens = (tokens * icoWeek4Bonus) /100; \n', '            }\n', '            \n', '        }\n', '        tokens +=bonusTokens;\n', '        tokenSales+=tokens;\n', '        balancesHold[msg.sender]+=tokens;\n', '        amountRaisedInWei = amountRaisedInWei + msg.value;\n', '        if(!isParticipated[msg.sender]){\n', '            allParticipants.push(msg.sender);\n', '        }\n', '        TokenHold(msg.sender,tokens);//event to dispactc as token hold successfully\n', '    }\n', '    function distributeTokensAfterIcoByOwner()public onlyOwner{\n', '        for (uint i = 0; i < allParticipants.length; i++) {\n', '                    address userAdder=allParticipants[i];\n', '                    var tokens = balancesHold[userAdder];\n', '                    if(tokens>0){\n', '                    allowed[owner][userAdder] += tokens;\n', '                    transferFrom(owner, userAdder, tokens);\n', '                    balancesHold[userAdder] = 0;\n', '                     }\n', '                 }\n', '    }\n', '    /**\n', '   * @dev called by the owner to extend deadline relative to last deadLine Time,\n', '   * to accept ether and transfer tokens\n', '   */\n', '   function extendSaleEndDate(uint saleEndTimeInMIllis)public onlyOwner{\n', '       saleEndDate = saleEndTimeInMIllis;\n', '   }\n', '   function setIcoStartDate(uint icoStartDateInMilli)public onlyOwner{\n', '       icoStartDate = icoStartDateInMilli;\n', '   }\n', '    function setICOWeek1Bonus(uint bonus)public onlyOwner{\n', '       icoWeek1Bonus= bonus;\n', '   }\n', '     function setICOWeek2Bonus(uint bonus)public onlyOwner{\n', '       icoWeek2Bonus= bonus;\n', '   }\n', '     function setICOWeek3Bonus(uint bonus)public onlyOwner{\n', '       icoWeek3Bonus= bonus;\n', '   }\n', '     function setICOWeek4Bonus(uint bonus)public onlyOwner{\n', '       icoWeek4Bonus= bonus;\n', '   }\n', '   function rateForOnePTM(uint rateInWei) public onlyOwner{\n', '       priceOfToken = rateInWei;\n', '   }\n', '\n', '   //function ext\n', '   /**\n', '     * to get total particpants count\n', '     */\n', '    function getCountPartipants() public constant returns (uint count){\n', '       return allParticipants.length;\n', '    }\n', '    function getParticipantIndexAddress(uint index)public constant returns (address){\n', '        return allParticipants[index];\n', '    }\n', '    /**\n', '    * Transfer entire balance to any account (by owner and admin only)\n', '    **/\n', '    function transferFundToAccount(address _accountByOwner) public onlyOwner {\n', '        require(amountRaisedInWei > 0);\n', '        _accountByOwner.transfer(amountRaisedInWei);\n', '        amountRaisedInWei = 0;\n', '    }\n', '\n', '    function resetTokenOfAddress(address _userAdd)public onlyOwner {\n', '      uint256 userBal=  balances[_userAdd] ;\n', '      balances[_userAdd] = 0;\n', '      balances[owner] +=userBal;\n', '    }\n', '    /**\n', '    * Transfer part of balance to any account (by owner and admin only)\n', '    **/\n', '    function transferLimitedFundToAccount(address _accountByOwner, uint256 balanceToTransfer) public onlyOwner   {\n', '        require(amountRaisedInWei > balanceToTransfer);\n', '        _accountByOwner.transfer(balanceToTransfer);\n', '        amountRaisedInWei -= balanceToTransfer;\n', '    }\n', '}']