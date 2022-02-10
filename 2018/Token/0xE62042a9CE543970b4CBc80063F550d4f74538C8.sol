['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '    \n', '  mapping (address => uint256) balances;\n', '  uint256 totalSupply_;\n', '  \n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '  \n', '    /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  \n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of. \n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '}\n', '\n', 'contract BurnableToken is BasicToken {\n', '\n', '  event Burn(address indexed burner, uint256 value);\n', '\n', '  /**\n', '   * @dev Burns a specific amount of tokens.\n', '   * @param _value The amount of token to be burned.\n', '   */\n', '  function burn(uint256 _value) public {\n', '    require(_value <= balances[msg.sender]);\n', '    // no need to require value <= totalSupply, since that would imply the\n', '    // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure\n', '\n', '    address burner = msg.sender;\n', '    balances[burner] = balances[burner].sub(_value);\n', '    totalSupply_ = totalSupply_.sub(_value);\n', '    emit Burn(burner, _value);\n', '    emit Transfer(burner, address(0), _value);\n', '  }\n', '}\n', '\n', 'contract StandardToken is ERC20, BurnableToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    \n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifing the amount of tokens still avaible for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '  \n', '}\n', '\n', 'contract BittechToken is StandardToken {\n', '\n', '  string constant public name = "Bittech Token";\n', '  string constant public symbol = "BTECH";\n', '  uint256 constant public decimals = 18;\n', '\n', '  address constant public bountyWallet = 0x8E8d4cdADbc027b192DfF91c77382521B419E5A2;\n', '  uint256 public bountyPart = uint256(5000000).mul(10 ** decimals); \n', '  address constant public adviserWallet = 0x1B9D19Af310E8cB35D0d3B8977b65bD79C5bB299;\n', '  uint256 public adviserPart = uint256(1000000).mul(10 ** decimals);\n', '  address constant public reserveWallet = 0xa323DA182fDfC10861609C2c98894D9745ABAB91;\n', '  uint256 public reservePart = uint256(20000000).mul(10 ** decimals);\n', '  address constant public ICOWallet = 0x1ba99f4F5Aa56684423a122D72990A7851AaFD9e;\n', '  uint256 public ICOPart = uint256(60000000).mul(10 ** decimals);\n', '  uint256 public PreICOPart = uint256(5000000).mul(10 ** decimals);\n', '  address constant public teamWallet = 0x69548B7740EAf1200312d803f8bDd04F77523e09;\n', '  uint256 public teamPart = uint256(9000000).mul(10 ** decimals);\n', '\n', '  uint256 constant public yearSeconds = 31536000; // 60*60*24*365 = 31536000\n', '  uint256 constant public secsPerBlock = 14; // 1 block per 14 seconds\n', '  uint256 public INITIAL_SUPPLY = uint256(100000000).mul(10 ** decimals); // 100 000 000 tokens\n', '\n', '  uint256 public withdrawTokens = 0;\n', '  uint256 public startTime;\n', '\n', '  function BittechToken() public {\n', '    totalSupply_ = INITIAL_SUPPLY;\n', '\n', '    balances[bountyWallet] = bountyPart;\n', '    emit Transfer(this, bountyWallet, bountyPart);\n', '\n', '    balances[adviserWallet] = adviserPart;\n', '    emit Transfer(this, adviserWallet, adviserPart);\n', '\n', '    balances[reserveWallet] = reservePart;\n', '    emit Transfer(this, reserveWallet, reservePart);\n', '\n', '    balances[ICOWallet] = ICOPart;\n', '    emit Transfer(this, ICOWallet, ICOPart);\n', '\n', '    balances[msg.sender] = PreICOPart;\n', '    emit Transfer(this, msg.sender, PreICOPart);\n', '\n', '    balances[this] = teamPart;\n', '    emit Transfer(this, this, teamPart); \n', '\n', '    startTime = block.number;\n', '  }\n', '\n', '  modifier onlyTeam() {\n', '    require(msg.sender == teamWallet);\n', '    _;\n', '  }\n', '\n', '  function viewTeamTokens() public view returns (uint256) {\n', '\n', '    if (block.number >= startTime.add(yearSeconds.div(secsPerBlock))) {\n', '      return 3000000;\n', '    }\n', '\n', '    if (block.number >= startTime.add(yearSeconds.div(secsPerBlock).mul(2))) {\n', '      return 6000000;\n', '    }\n', '\n', '    if (block.number >= startTime.add(yearSeconds.div(secsPerBlock).mul(3))) {\n', '      return 9000000;\n', '    }\n', '\n', '  }\n', '\n', '  function getTeamTokens(uint256 _tokens) public onlyTeam {\n', '    uint256 tokens = _tokens.mul(10 ** decimals);\n', '    require(withdrawTokens.add(tokens) <= viewTeamTokens().mul(10 ** decimals));\n', '    transfer(teamWallet, tokens);\n', '    emit Transfer(this, teamWallet, tokens);\n', '    withdrawTokens = withdrawTokens.add(tokens);\n', '  }\n', '  \n', '}']