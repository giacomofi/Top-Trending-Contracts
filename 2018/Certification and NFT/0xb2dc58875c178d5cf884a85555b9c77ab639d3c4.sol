['pragma solidity ^0.4.23;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic, Ownable {\n', '  using SafeMath for uint256;\n', '  mapping(address => uint256) balances;\n', '  // 1 denied / 0 allow\n', '  mapping(address => uint8) permissionsList;\n', '  \n', '  function SetPermissionsList(address _address, uint8 _sign) public onlyOwner{\n', '    permissionsList[_address] = _sign; \n', '  }\n', '  function GetPermissionsList(address _address) public constant onlyOwner returns(uint8){\n', '    return permissionsList[_address]; \n', '  }  \n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(permissionsList[msg.sender] == 0);\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(permissionsList[msg.sender] == 0);\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Pausable token\n', ' * @dev StandardToken modified with pausable transfers.\n', ' **/\n', 'contract PausableToken is StandardToken, Pausable {\n', '\n', '  function transfer(\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool)\n', '  {\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool)\n', '  {\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  function approve(\n', '    address _spender,\n', '    uint256 _value\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool)\n', '  {\n', '    return super.approve(_spender, _value);\n', '  }\n', '\n', '  function increaseApproval(\n', '    address _spender,\n', '    uint _addedValue\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool success)\n', '  {\n', '    return super.increaseApproval(_spender, _addedValue);\n', '  }\n', '\n', '  function decreaseApproval(\n', '    address _spender,\n', '    uint _subtractedValue\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool success)\n', '  {\n', '    return super.decreaseApproval(_spender, _subtractedValue);\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', 'contract MintableToken is PausableToken {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint whenNotPaused public returns (bool) {\n', '    totalSupply_ = totalSupply_.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    emit Mint(_to, _amount);\n', '    emit Transfer(address(0), _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner canMint public returns (bool) {\n', '    mintingFinished = true;\n', '    emit MintFinished();\n', '    return true;\n', '  }\n', '}\n', 'contract BurnableByOwner is BasicToken {\n', '\n', '  event Burn(address indexed burner, uint256 value);\n', '  function burn(address _address, uint256 _value) public onlyOwner{\n', '    require(_value <= balances[_address]);\n', '    // no need to require value <= totalSupply, since that would imply the\n', '    // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure\n', '\n', '    address burner = _address;\n', '    balances[burner] = balances[burner].sub(_value);\n', '    totalSupply_ = totalSupply_.sub(_value);\n', '    emit Burn(burner, _value);\n', '    emit Transfer(burner, address(0), _value);\n', '  }\n', '}\n', '\n', 'contract TRND is Ownable, MintableToken, BurnableByOwner {\n', '  using SafeMath for uint256;    \n', '  string public constant name = "Trends";\n', '  string public constant symbol = "TRND";\n', '  uint32 public constant decimals = 18;\n', '  \n', '  address public addressPrivateSale;\n', '  address public addressAirdrop;\n', '  address public addressPremineBounty;\n', '  address public addressPartnerships;\n', '\n', '  uint256 public summPrivateSale;\n', '  uint256 public summAirdrop;\n', '  uint256 public summPremineBounty;\n', '  uint256 public summPartnerships;\n', ' // uint256 public totalSupply;\n', '\n', '  function TRND() public {\n', '    addressPrivateSale   = 0x6701DdeDBeb3155B8c908D0D12985A699B9d2272;\n', '    addressAirdrop       = 0xd176131235B5B8dC314202a8B348CC71798B0874;\n', '    addressPremineBounty = 0xd176131235B5B8dC314202a8B348CC71798B0874;\n', '    addressPartnerships  = 0x441B2B781a6b411f1988084a597e2ED4e0A7C352; \n', '\t\n', '    summPrivateSale   = 5000000 * (10 ** uint256(decimals)); \n', '    summAirdrop       = 4500000 * (10 ** uint256(decimals));  \n', '    summPremineBounty = 1000000 * (10 ** uint256(decimals));  \n', '    summPartnerships  = 2500000 * (10 ** uint256(decimals));  \t\t    \n', '    // Founders and supporters initial Allocations\n', '    mint(addressPrivateSale, summPrivateSale);\n', '    mint(addressAirdrop, summAirdrop);\n', '    mint(addressPremineBounty, summPremineBounty);\n', '    mint(addressPartnerships, summPartnerships);\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale.\n', ' * Crowdsales have a start and end timestamps, where Contributors can make\n', ' * token Contributions and the crowdsale will assign them tokens based\n', ' * on a token per ETH rate. Funds collected are forwarded to a wallet\n', ' * as they arrive. The contract requires a MintableToken that will be\n', ' * minted as contributions arrive, note that the crowdsale contract\n', ' * must be owner of the token in order to be able to mint it.\n', ' */\n', 'contract Crowdsale is Ownable {\n', '  using SafeMath for uint256;\n', '  // soft cap\n', '  uint softcap;\n', '  // hard cap\n', '  uint256 hardcapPreICO; \n', '  uint256 hardcapMainSale;  \n', '  TRND public token;\n', '  // balances for softcap\n', '  mapping(address => uint) public balances;\n', '\n', '  // start and end timestamps where investments are allowed (both inclusive)\n', '  //ico\n', '    //start\n', '  uint256 public startIcoPreICO;  \n', '  uint256 public startIcoMainSale;  \n', '    //end \n', '  uint256 public endIcoPreICO; \n', '  uint256 public endIcoMainSale;   \n', '  //token distribution\n', ' // uint256 public maxIco;\n', '\n', '  uint256 public totalSoldTokens;\n', '  uint256 minPurchasePreICO;     \n', '  uint256 minPurchaseMainSale;   \n', '  \n', '  // how many token units a Contributor gets per wei\n', '  uint256 public rateIcoPreICO;\n', '  uint256 public rateIcoMainSale;\n', '\n', '  //Unconfirmed sum\n', '  uint256 public unconfirmedSum;\n', '  mapping(address => uint) public unconfirmedSumAddr;\n', '  // address where funds are collected\n', '  address public wallet;\n', '  \n', '  \n', '/**\n', '* event for token Procurement logging\n', '* @param contributor who Pledged for the tokens\n', '* @param beneficiary who got the tokens\n', '* @param value weis Contributed for Procurement\n', '* @param amount amount of tokens Procured\n', '*/\n', '  event TokenProcurement(address indexed contributor, address indexed beneficiary, uint256 value, uint256 amount);\n', '  \n', '  function Crowdsale() public {\n', '    token = createTokenContract();\n', '    //soft cap in tokens\n', '    softcap            = 20000000 * 1 ether; \n', '    hardcapPreICO      =  5000000 * 1 ether; \n', '    hardcapMainSale    = 80000000 * 1 ether; \n', '\t\n', '    //min Purchase in wei = 0.1 ETH\n', '    minPurchasePreICO      = 100000000000000000;\n', '    minPurchaseMainSale    = 100000000000000000;\n', '    // start and end timestamps where investments are allowed\n', '    //ico\n', '    //start/end \n', '    startIcoPreICO   = 1527843600; //   06/01/2018 @ 9:00am (UTC)\n', '    endIcoPreICO     = 1530435600; //   07/01/2018 @ 9:00am (UTC)\n', '    startIcoMainSale = 1530435600; //   07/01/2018 @ 9:00am (UTC)\n', '    endIcoMainSale   = 1533891600; //   08/10/2018 @ 9:00am (UTC)\n', '\n', '    //rate; 0.125$ for ETH = 700$\n', '    rateIcoPreICO = 5600;\n', '    //rate; 0.25$ for ETH = 700$\n', '    rateIcoMainSale = 2800;\n', '\n', '    // address where funds are collected\n', '    wallet = 0xca5EdAE100d4D262DC3Ec2dE96FD9943Ea659d04;\n', '  }\n', '  \n', '  function setStartIcoPreICO(uint256 _startIcoPreICO) public onlyOwner  { \n', '    uint256 delta;\n', '    require(now < startIcoPreICO);\n', '\tif (startIcoPreICO > _startIcoPreICO) {\n', '\t  delta = startIcoPreICO.sub(_startIcoPreICO);\n', '\t  startIcoPreICO   = _startIcoPreICO;\n', '\t  endIcoPreICO     = endIcoPreICO.sub(delta);\n', '      startIcoMainSale = startIcoMainSale.sub(delta);\n', '      endIcoMainSale   = endIcoMainSale.sub(delta);\n', '\t}\n', '\tif (startIcoPreICO < _startIcoPreICO) {\n', '\t  delta = _startIcoPreICO.sub(startIcoPreICO);\n', '\t  startIcoPreICO   = _startIcoPreICO;\n', '\t  endIcoPreICO     = endIcoPreICO.add(delta);\n', '      startIcoMainSale = startIcoMainSale.add(delta);\n', '      endIcoMainSale   = endIcoMainSale.add(delta);\n', '\t}\t\n', '  }\n', '  \n', '  function setRateIcoPreICO(uint256 _rateIcoPreICO) public onlyOwner  {\n', '    rateIcoPreICO = _rateIcoPreICO;\n', '  }   \n', '  function setRateIcoMainSale(uint _rateIcoMainSale) public onlyOwner  {\n', '    rateIcoMainSale = _rateIcoMainSale;\n', '  }     \n', '  // fallback function can be used to Procure tokens\n', '  function () external payable {\n', '    procureTokens(msg.sender);\n', '  }\n', '  \n', '  function createTokenContract() internal returns (TRND) {\n', '    return new TRND();\n', '  }\n', '  \n', '  function getRateIcoWithBonus() public view returns (uint256) {\n', '    uint256 bonus;\n', '\tuint256 rateICO;\n', '    //icoPreICO   \n', '    if (now >= startIcoPreICO && now < endIcoPreICO){\n', '      rateICO = rateIcoPreICO;\n', '    }  \n', '\n', '    //icoMainSale   \n', '    if (now >= startIcoMainSale  && now < endIcoMainSale){\n', '      rateICO = rateIcoMainSale;\n', '    }  \n', '\n', '    //bonus\n', '    if (now >= startIcoPreICO && now < startIcoPreICO.add( 2 * 7 * 1 days )){\n', '      bonus = 10;\n', '    }  \n', '    if (now >= startIcoPreICO.add(2 * 7 * 1 days) && now < startIcoPreICO.add(4 * 7 * 1 days)){\n', '      bonus = 8;\n', '    } \n', '    if (now >= startIcoPreICO.add(4 * 7 * 1 days) && now < startIcoPreICO.add(6 * 7 * 1 days)){\n', '      bonus = 6;\n', '    } \n', '    if (now >= startIcoPreICO.add(6 * 7 * 1 days) && now < startIcoPreICO.add(8 * 7 * 1 days)){\n', '      bonus = 4;\n', '    } \n', '    if (now >= startIcoPreICO.add(8 * 7 * 1 days) && now < startIcoPreICO.add(10 * 7 * 1 days)){\n', '      bonus = 2;\n', '    } \n', '\n', '    return rateICO + rateICO.mul(bonus).div(100);\n', '  }    \n', '  // low level token Pledge function\n', '  function procureTokens(address beneficiary) public payable {\n', '    uint256 tokens;\n', '    uint256 weiAmount = msg.value;\n', '    uint256 backAmount;\n', '    uint256 rate;\n', '    uint hardCap;\n', '    require(beneficiary != address(0));\n', '    rate = getRateIcoWithBonus();\n', '    //icoPreICO   \n', '    hardCap = hardcapPreICO;\n', '    if (now >= startIcoPreICO && now < endIcoPreICO && totalSoldTokens < hardCap){\n', '\t  require(weiAmount >= minPurchasePreICO);\n', '      tokens = weiAmount.mul(rate);\n', '      if (hardCap.sub(totalSoldTokens) < tokens){\n', '        tokens = hardCap.sub(totalSoldTokens); \n', '        weiAmount = tokens.div(rate);\n', '        backAmount = msg.value.sub(weiAmount);\n', '      }\n', '    }  \n', '    //icoMainSale  \n', '    hardCap = hardcapMainSale.add(hardcapPreICO);\n', '    if (now >= startIcoMainSale  && now < endIcoMainSale  && totalSoldTokens < hardCap){\n', '\t  require(weiAmount >= minPurchaseMainSale);\n', '      tokens = weiAmount.mul(rate);\n', '      if (hardCap.sub(totalSoldTokens) < tokens){\n', '        tokens = hardCap.sub(totalSoldTokens); \n', '        weiAmount = tokens.div(rate);\n', '        backAmount = msg.value.sub(weiAmount);\n', '      }\n', '    }     \n', '    require(tokens > 0);\n', '    totalSoldTokens = totalSoldTokens.add(tokens);\n', '    balances[msg.sender] = balances[msg.sender].add(weiAmount);\n', '    token.mint(msg.sender, tokens);\n', '\tunconfirmedSum = unconfirmedSum.add(tokens);\n', '\tunconfirmedSumAddr[msg.sender] = unconfirmedSumAddr[msg.sender].add(tokens);\n', '\ttoken.SetPermissionsList(beneficiary, 1);\n', '    if (backAmount > 0){\n', '      msg.sender.transfer(backAmount);    \n', '    }\n', '    emit TokenProcurement(msg.sender, beneficiary, weiAmount, tokens);\n', '  }\n', '\n', '  function refund() public{\n', '    require(totalSoldTokens.sub(unconfirmedSum) < softcap && now > endIcoMainSale);\n', '    require(balances[msg.sender] > 0);\n', '    uint value = balances[msg.sender];\n', '    balances[msg.sender] = 0;\n', '    msg.sender.transfer(value);\n', '  }\n', '  \n', '  function transferEthToMultisig() public onlyOwner {\n', '    address _this = this;\n', '    require(totalSoldTokens.sub(unconfirmedSum) >= softcap && now > endIcoMainSale);  \n', '    wallet.transfer(_this.balance);\n', '  } \n', '  \n', '  function refundUnconfirmed() public{\n', '    require(now > endIcoMainSale);\n', '    require(balances[msg.sender] > 0);\n', '    require(token.GetPermissionsList(msg.sender) == 1);\n', '    uint value = balances[msg.sender];\n', '    balances[msg.sender] = 0;\n', '    msg.sender.transfer(value);\n', '   // token.burn(msg.sender, token.balanceOf(msg.sender));\n', '    uint uvalue = unconfirmedSumAddr[msg.sender];\n', '    unconfirmedSumAddr[msg.sender] = 0;\n', '    token.burn(msg.sender, uvalue );\n', '   // totalICO = totalICO.sub(token.balanceOf(msg.sender));    \n', '  } \n', '  \n', '  function SetPermissionsList(address _address, uint8 _sign) public onlyOwner{\n', '      uint8 sign;\n', '      sign = token.GetPermissionsList(_address);\n', '      token.SetPermissionsList(_address, _sign);\n', '      if (_sign == 0){\n', '          if (sign != _sign){  \n', '\t\t\tunconfirmedSum = unconfirmedSum.sub(unconfirmedSumAddr[_address]);\n', '\t\t\tunconfirmedSumAddr[_address] = 0;\n', '          }\n', '      }\n', '   }\n', '   \n', '   function GetPermissionsList(address _address) public constant onlyOwner returns(uint8){\n', '     return token.GetPermissionsList(_address); \n', '   }   \n', '   \n', '   function pause() onlyOwner public {\n', '     token.pause();\n', '   }\n', '\n', '   function unpause() onlyOwner public {\n', '     token.unpause();\n', '   }\n', '    \n', '}']