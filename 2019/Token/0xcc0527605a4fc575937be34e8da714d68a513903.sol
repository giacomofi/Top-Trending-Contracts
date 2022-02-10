['pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', '*\n', '*/\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'library SafeMath {\n', 'function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      throw;\n', '    }\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '   * @dev Fix for the ERC20 short address attack.\n', '   */\n', '  modifier onlyPayloadSize(uint size) {\n', '     if(msg.data.length < size + 4) {\n', '       throw;\n', '     }\n', '     _;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value);\n', '  function approve(address spender, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implemantation of the basic standart token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is BasicToken, ERC20 {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // if (_value > _allowance) throw;\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens than an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint specifing the amount of tokens still avaible for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    if (msg.sender != owner) {\n', '      throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '  event Mint(address indexed to, uint256 value);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '  uint256 public totalSupply = 0;\n', '\n', '\n', '  modifier canMint() {\n', '    if(mintingFinished) throw;\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will recieve the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner returns (bool) {\n', '    mintingFinished = true;\n', '    MintFinished();\n', '    return true;\n', '  }\n', '}\n', '\n', 'contract TimeLockToken is Ownable, MintableToken{\n', '  using SafeMath for uint256;\n', '  struct LockedBalance {  \n', '    uint256 releaseTime; \n', '    uint256 amount;\n', '  }\n', '\n', '  event MintLock(address indexed to, uint256 releaseTime, uint256 value);\n', '  mapping(address => LockedBalance) lockedBalances;\n', '  /**\n', '   * @dev mint timelocked tokens\n', '   */\n', '  function mintTimelocked(address _to, uint256 _releaseTime, uint256 _amount)\n', '    onlyOwner canMint returns (bool){\n', '    require(_releaseTime > now);\n', '    require(_amount > 0);\n', '    LockedBalance exist = lockedBalances[_to];\n', '    require(exist.amount == 0);\n', '    LockedBalance memory balance = LockedBalance(_releaseTime,_amount);\n', '    totalSupply = totalSupply.add(_amount);\n', '    lockedBalances[_to] = balance;\n', '    MintLock(_to, _releaseTime, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev beneficiary claims tokens held by time lock\n', '   */\n', '  function claim() {\n', '    LockedBalance balance = lockedBalances[msg.sender];\n', '    require(balance.amount > 0);\n', '    require(now >= balance.releaseTime);\n', '    uint256 amount = balance.amount;\n', '    delete lockedBalances[msg.sender];\n', '    balances[msg.sender] = balances[msg.sender].add(amount);\n', '    Transfer(0, msg.sender, amount);\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the locked balance of the specified address.\n', '  * @param _owner The address to query the the locked balance of.\n', '  * @return An uint representing the amount owned by the passed address.\n', '  */\n', '  function lockedBalanceOf(address _owner) constant returns (uint256 lockedAmount) {\n', '    return lockedBalances[_owner].amount;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the releaseTime of the specified address.\n', '  * @param _owner The address to query the the releaseTime of.\n', '  * @return An uint representing the amount owned by the passed address.\n', '  */\n', '  function releaseTimeOf(address _owner) constant returns (uint256 releaseTime) {\n', '    return lockedBalances[_owner].releaseTime;\n', '  }\n', '  \n', '}\n', '\n', '\n', 'contract LiuTJToken is TimeLockToken {\n', '  using SafeMath for uint256;\n', '  event Freeze(address indexed to, uint256 value);\n', '  event Unfreeze(address indexed to, uint256 value);\n', '  event Burn(address indexed to, uint256 value);\n', '  mapping (address => uint256) public freezeOf;\n', '  string public name = "Liu TJ Token";\n', '  string public symbol = "LT";\n', '  uint public decimals = 18;\n', '\n', '\n', '  function burn(address _to,uint256 _value) onlyOwner returns (bool success) {\n', '    require(_value >= 0);\n', '    require(balances[_to] >= _value);\n', '    \n', '    balances[_to] = balances[_to].sub(_value);                      // Subtract from the sender\n', '    totalSupply = totalSupply.sub(_value);                                // Updates totalSupply\n', '    Burn(_to, _value);\n', '    return true;\n', '  }\n', '  \n', '  function freeze(address _to,uint256 _value) onlyOwner returns (bool success) {\n', '    require(_value >= 0);\n', '    require(balances[_to] >= _value);\n', '    balances[_to] = balances[_to].sub(_value);                      // Subtract from the sender\n', '    freezeOf[_to] = freezeOf[_to].add(_value);                                // Updates totalSupply\n', '    Freeze(_to, _value);\n', '    return true;\n', '  }\n', '  \n', '  function unfreeze(address _to,uint256 _value) onlyOwner returns (bool success) {\n', '    require(_value >= 0);\n', '    require(freezeOf[_to] >= _value);\n', '    freezeOf[_to] = freezeOf[_to].sub(_value);                      // Subtract from the sender\n', '    balances[_to] = balances[_to].add(_value);\n', '    Unfreeze(_to, _value);\n', '    return true;\n', '  }\n', '\n', '}']