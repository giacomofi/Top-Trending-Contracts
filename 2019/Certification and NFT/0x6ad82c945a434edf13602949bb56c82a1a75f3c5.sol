['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'interface IERC20 {\n', '  function totalSupply() external view returns (uint256);\n', '\n', '  function balanceOf(address who) external view returns (uint256);\n', '\n', '  function allowance(address owner, address spender)\n', '  external view returns (uint256);\n', '\n', '  function transfer(address to, uint256 value) external returns (bool);\n', '\n', '  function approve(address spender, uint256 value)\n', '  external returns (bool);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '  external returns (bool);\n', '\n', '\n', '  event Transfer(\n', '    address indexed from,\n', '    address indexed to,\n', '    uint256 value\n', '  );\n', '\n', '  event TransferWithData(address indexed from, address indexed to, uint value, bytes data);\n', '\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md\n', ' * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract ERC20 is IERC20 {\n', '  using SafeMath for uint256;\n', '\n', '  mapping (address => uint256) private _balances;\n', '\n', '  mapping (address => mapping (address => uint256)) private _allowed;\n', '\n', '  uint256 private _totalSupply;\n', '\n', '  /**\n', '  * @dev Total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return _totalSupply;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param owner The address to query the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address owner) public view returns (uint256) {\n', '    return _balances[owner];\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param owner address The address which owns the funds.\n', '   * @param spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(\n', '    address owner,\n', '    address spender\n', '  )\n', '  public\n', '  view\n', '  returns (uint256)\n', '  {\n', '    return _allowed[owner][spender];\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Transfer the specified amount of tokens to the specified address.\n', '   *      Invokes the `tokenFallback` function if the recipient is a contract.\n', '   *      The token transfer fails if the recipient is a contract\n', '   *      but does not implement the `tokenFallback` function\n', '   *      or the fallback function to receive funds.\n', '   *\n', '   * @param _to    Receiver address.\n', '   * @param _value Amount of tokens that will be transferred.\n', '   * @param _data  Transaction metadata.\n', '   */\n', '\n', '  function transfer(address _to, uint _value, bytes _data) external returns (bool) {\n', '    // Standard function transfer similar to ERC20 transfer with no _data .\n', '    // Added due to backwards compatibility reasons .\n', '    uint codeLength;\n', '\n', '    require(_value / 1000000000000000000 >= 1);\n', '\n', '    assembly {\n', '    // Retrieve the size of the code on target address, this needs assembly .\n', '      codeLength := extcodesize(_to)\n', '    }\n', '\n', '    _balances[msg.sender] = _balances[msg.sender].sub(_value);\n', '    _balances[_to] = _balances[_to].add(_value);\n', '    if (codeLength > 0) {\n', '      ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '\n', '      receiver.tokenFallback(msg.sender, _value, _to);\n', '    }\n', '    emit TransferWithData(msg.sender, _to, _value, _data);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer the specified amount of tokens to the specified address.\n', '   *      This function works the same with the previous one\n', "   *      but doesn't contain `_data` param.\n", '   *      Added due to backwards compatibility reasons.\n', '   *\n', '   * @param _to    Receiver address.\n', '   * @param _value Amount of tokens that will be transferred.\n', '   */\n', '  function transfer(address _to, uint _value) external returns (bool) {\n', '    uint codeLength;\n', '    bytes memory empty;\n', '\n', '    require(_value / 1000000000000000000 >= 1);\n', '\n', '    assembly {\n', '    // Retrieve the size of the code on target address, this needs assembly .\n', '      codeLength := extcodesize(_to)\n', '    }\n', '\n', '    _balances[msg.sender] = _balances[msg.sender].sub(_value);\n', '    _balances[_to] = _balances[_to].add(_value);\n', '    if (codeLength > 0) {\n', '      ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '      receiver.tokenFallback(msg.sender, _value, address(this));\n', '    }\n', '\n', '    emit Transfer(msg.sender, _to, _value);\n', '    emit TransferWithData(msg.sender, _to, _value, empty);\n', '    return true;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Transfer the specified amount of tokens to the specified address.\n', '   *      This function works the same with the previous one\n', "   *      but doesn't contain `_data` param.\n", '   *      Added due to backwards compatibility reasons.\n', '   *\n', '   * @param _to    Receiver address.\n', '   * @param _value Amount of tokens that will be transferred.\n', '   */\n', '  function transferByCrowdSale(address _to, uint _value) external returns (bool) {\n', '    bytes memory empty;\n', '\n', '    require(_value / 1000000000000000000 >= 1);\n', '\n', '    _balances[msg.sender] = _balances[msg.sender].sub(_value);\n', '    _balances[_to] = _balances[_to].add(_value);\n', '\n', '    emit Transfer(msg.sender, _to, _value);\n', '    emit TransferWithData(msg.sender, _to, _value, empty);\n', '    return true;\n', '  }\n', '\n', '  function _transferGasByOwner(address _from, address _to, uint256 _value) internal {\n', '    _balances[_from] = _balances[_from].sub(_value);\n', '    _balances[_to] = _balances[_to].add(_value);\n', '    emit Transfer(_from, _to, _value);\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param spender The address which will spend the funds.\n', '   * @param value The amount of tokens to be spent.\n', '   */\n', '  function approve(address spender, uint256 value) public returns (bool) {\n', '    require(spender != address(0));\n', '\n', '    _allowed[msg.sender][spender] = value;\n', '    emit Approval(msg.sender, spender, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param from address The address which you want to send tokens from\n', '   * @param to address The address which you want to transfer to\n', '   * @param value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(\n', '    address from,\n', '    address to,\n', '    uint256 value\n', '  )\n', '  public\n', '  returns (bool)\n', '  {\n', '    require(value <= _allowed[from][msg.sender]);\n', '\n', '    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '    _transfer(from, to, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed_[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param spender The address which will spend the funds.\n', '   * @param addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseAllowance(\n', '    address spender,\n', '    uint256 addedValue\n', '  )\n', '  public\n', '  returns (bool)\n', '  {\n', '    require(spender != address(0));\n', '\n', '    _allowed[msg.sender][spender] = (\n', '    _allowed[msg.sender][spender].add(addedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed_[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param spender The address which will spend the funds.\n', '   * @param subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseAllowance(\n', '    address spender,\n', '    uint256 subtractedValue\n', '  )\n', '  public\n', '  returns (bool)\n', '  {\n', '    require(spender != address(0));\n', '\n', '    _allowed[msg.sender][spender] = (\n', '    _allowed[msg.sender][spender].sub(subtractedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified addresses\n', '  * @param from The address to transfer from.\n', '  * @param to The address to transfer to.\n', '  * @param value The amount to be transferred.\n', '  */\n', '  function _transfer(address from, address to, uint256 value) internal {\n', '    require(value <= _balances[from]);\n', '    require(to != address(0));\n', '\n', '    _balances[from] = _balances[from].sub(value);\n', '    _balances[to] = _balances[to].add(value);\n', "    emit TransferWithData(from, to, value, '');\n", '    emit Transfer(from, to, value);\n', '  }\n', '\n', '  /**\n', '   * @dev Internal function that mints an amount of the token and assigns it to\n', '   * an account. This encapsulates the modification of balances such that the\n', '   * proper events are emitted.\n', '   * @param account The account that will receive the created tokens.\n', '   * @param value The amount that will be created.\n', '   */\n', '  function _mint(address account, uint256 value) internal {\n', '    require(account != 0);\n', '    _totalSupply = _totalSupply.add(value);\n', '    _balances[account] = _balances[account].add(value);\n', "    emit TransferWithData(address(0), account, value, '');\n", '    emit Transfer(address(0), account, value);\n', '  }\n', '\n', '  /**\n', '   * @dev Internal function that burns an amount of the token of a given\n', '   * account.\n', '   * @param account The account whose tokens will be burnt.\n', '   * @param value The amount that will be burnt.\n', '   */\n', '  function _burn(address account, uint256 value) internal {\n', '    require(account != 0);\n', '    require(value <= _balances[account]);\n', '\n', '    _totalSupply = _totalSupply.sub(value);\n', '    _balances[account] = _balances[account].sub(value);\n', "    emit TransferWithData(account, address(0), value, '');\n", '    emit Transfer(account, address(0), value);\n', '  }\n', '\n', '  /**\n', '   * @dev Internal function that burns an amount of the token of a given\n', "   * account, deducting from the sender's allowance for said account. Uses the\n", '   * internal burn function.\n', '   * @param account The account whose tokens will be burnt.\n', '   * @param value The amount that will be burnt.\n', '   */\n', '  function _burnFrom(address account, uint256 value) internal {\n', '    require(value <= _allowed[account][msg.sender]);\n', '\n', '    // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,\n', '    // this function needs to emit an event with the updated approval.\n', '    _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(\n', '      value);\n', '    _burn(account, value);\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Roles\n', ' * @dev Library for managing addresses assigned to a Role.\n', ' */\n', 'library Roles {\n', '  struct Role {\n', '    mapping (address => bool) bearer;\n', '  }\n', '\n', '  /**\n', '   * @dev give an account access to this role\n', '   */\n', '  function add(Role storage role, address account) internal {\n', '    require(account != address(0));\n', '    role.bearer[account] = true;\n', '  }\n', '\n', '  /**\n', "   * @dev remove an account's access to this role\n", '   */\n', '  function remove(Role storage role, address account) internal {\n', '    require(account != address(0));\n', '    role.bearer[account] = false;\n', '  }\n', '\n', '  /**\n', '   * @dev check if an account has this role\n', '   * @return bool\n', '   */\n', '  function has(Role storage role, address account)\n', '  internal\n', '  view\n', '  returns (bool)\n', '  {\n', '    require(account != address(0));\n', '    return role.bearer[account];\n', '  }\n', '}\n', '\n', '\n', 'contract MinterRole {\n', '  using Roles for Roles.Role;\n', '\n', '  event MinterAdded(address indexed account);\n', '  event MinterRemoved(address indexed account);\n', '\n', '  Roles.Role private minters;\n', '\n', '  constructor() public {\n', '    _addMinter(msg.sender);\n', '  }\n', '\n', '  modifier onlyMinter() {\n', '    require(isMinter(msg.sender));\n', '    _;\n', '  }\n', '\n', '  function isMinter(address account) public view returns (bool) {\n', '    return minters.has(account);\n', '  }\n', '\n', '  function addMinter(address account) public onlyMinter {\n', '    _addMinter(account);\n', '  }\n', '\n', '  function renounceMinter() public {\n', '    _removeMinter(msg.sender);\n', '  }\n', '\n', '  function _addMinter(address account) internal {\n', '    minters.add(account);\n', '    emit MinterAdded(account);\n', '  }\n', '\n', '  function _removeMinter(address account) internal {\n', '    minters.remove(account);\n', '    emit MinterRemoved(account);\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20Mintable\n', ' * @dev ERC20 minting logic\n', ' */\n', 'contract ERC20Mintable is ERC20, MinterRole {\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param to The address that will receive the minted tokens.\n', '   * @param value The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(\n', '    address to,\n', '    uint256 value\n', '  )\n', '  public\n', '  onlyMinter\n', '  returns (bool)\n', '  {\n', '    _mint(to, value);\n', '    return true;\n', '  }\n', '\n', '  function transferGasByOwner(address _from, address _to, uint256 _value) public onlyMinter returns (bool) {\n', '    super._transferGasByOwner(_from, _to, _value);\n', '    return true;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title SimpleToken\n', ' * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.\n', ' * Note they can later distribute these tokens as they wish using `transfer` and other\n', ' * `ERC20` functions.\n', ' */\n', 'contract CryptoMusEstate is ERC20Mintable {\n', '\n', '  string public constant name = "Mus#1";\n', '  string public constant symbol = "MUS#1";\n', '  uint8 public constant decimals = 18;\n', '\n', '  uint256 public constant INITIAL_SUPPLY = 1000 * (10 ** uint256(decimals));\n', '\n', '  /**\n', '   * @dev Constructor that gives msg.sender all of existing tokens.\n', '   */\n', '  constructor() public {\n', '    mint(msg.sender, INITIAL_SUPPLY);\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title SimpleToken\n', ' * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.\n', ' * Note they can later distribute these tokens as they wish using `transfer` and other\n', ' * `ERC20` functions.\n', ' */\n', 'contract CryptoMusKRW is ERC20Mintable {\n', '\n', '  string public constant name = "CryptoMus KRW Stable Token";\n', '  string public constant symbol = "KRWMus";\n', '  uint8 public constant decimals = 18;\n', '\n', '  uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));\n', '\n', '  /**\n', '   * @dev Constructor that gives msg.sender all of existing tokens.\n', '   */\n', '  constructor() public {\n', '    mint(msg.sender, INITIAL_SUPPLY);\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address private _owner;\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    _owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @return the address of the owner.\n', '   */\n', '  function owner() public view returns (address) {\n', '    return _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(isOwner());\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @return true if `msg.sender` is the owner of the contract.\n', '   */\n', '  function isOwner() public view returns (bool) {\n', '    return msg.sender == _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(_owner);\n', '    _owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    _transferOwnership(newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address newOwner) internal {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(_owner, newOwner);\n', '    _owner = newOwner;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale,\n', ' * allowing investors to purchase tokens with ether. This contract implements\n', ' * such functionality in its most fundamental form and can be extended to provide additional\n', ' * functionality and/or custom behavior.\n', ' * The external interface represents the basic interface for purchasing tokens, and conform\n', ' * the base architecture for crowdsales. They are *not* intended to be modified / overridden.\n', ' * The internal interface conforms the extensible and modifiable surface of crowdsales. Override\n', " * the methods to add functionality. Consider using 'super' where appropriate to concatenate\n", ' * behavior.\n', ' */\n', 'contract ERC223ReceivingContract is Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  // The token being sold\n', '  CryptoMusEstate private _token;\n', '  // The token being sold\n', '  CryptoMusKRW private _krwToken;\n', '\n', '  // Address where funds are collected\n', '  address private _wallet;\n', '  address private _krwTokenAddress;\n', '\n', '  // How many token units a buyer gets per wei.\n', '  // The rate is the conversion between wei and the smallest and indivisible token unit.\n', '  // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK\n', '  // 1 wei will give you 1 unit, or 0.001 TOK.\n', '  uint256 private _rate;\n', '\n', '  // Amount of wei raised\n', '  uint256 private _weiRaised;\n', '\n', '  /**\n', '   * Event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokensPurchased(\n', '    address indexed purchaser,\n', '    address indexed beneficiary,\n', '    uint256 value,\n', '    uint256 amount\n', '  );\n', '\n', '  /**\n', '   * @param rate Number of token units a buyer gets per wei\n', '   * @dev The rate is the conversion between wei and the smallest and indivisible\n', '   * token unit. So, if you are using a rate of 1 with a ERC20Detailed token\n', '   * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.\n', '   * @param token Address of the token being sold\n', '   */\n', '  constructor(uint256 rate, CryptoMusEstate token, CryptoMusKRW krwToken) public {\n', '    require(rate > 0);\n', '\n', '    require(token != address(0));\n', '\n', '    _rate = rate;\n', '    _wallet = msg.sender;\n', '    _token = token;\n', '    _krwToken = krwToken;\n', '    _krwTokenAddress = krwToken;\n', '  }\n', '\n', '  // -----------------------------------------\n', '  // Crowdsale external interface\n', '  // -----------------------------------------\n', '\n', '\n', '  function tokenFallback(address _from, uint _value, address _to) public {\n', '\n', '    if(_krwTokenAddress != _to) {\n', '    } else {\n', '      buyTokens(_from, _value);\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @return the token being sold.\n', '   */\n', '  function token() public view returns (CryptoMusEstate) {\n', '    return _token;\n', '  }\n', '\n', '  /**\n', '   * @return the address where funds are collected.\n', '   */\n', '  function wallet() public view returns (address) {\n', '    return _wallet;\n', '  }\n', '\n', '  /**\n', '   * @return the number of token units a buyer gets per wei.\n', '   */\n', '  function rate() public view returns (uint256) {\n', '    return _rate;\n', '  }\n', '\n', '  function setRate(uint256 setRate) public onlyOwner returns (uint256)\n', '  {\n', '    _rate = setRate;\n', '    return _rate;\n', '  }\n', '\n', '  /**\n', '   * @return the mount of wei raised.\n', '   */\n', '  function weiRaised() public view returns (uint256) {\n', '    return _weiRaised;\n', '  }\n', '\n', '  /**\n', '   * @dev low level token purchase ***DO NOT OVERRIDE***\n', '   * @param beneficiary Address performing the token purchase\n', '   */\n', '  function buyTokens(address beneficiary, uint _value) public {\n', '\n', '    uint256 weiAmount = _value;\n', '    _preValidatePurchase(beneficiary, weiAmount);\n', '\n', '    // calculate token amount to be created\n', '    uint256 tokens = _getTokenAmount(weiAmount);\n', '\n', '    // update state\n', '    _weiRaised = _weiRaised.add(weiAmount);\n', '\n', '    _processPurchase(beneficiary, tokens);\n', '    emit TokensPurchased(\n', '      msg.sender,\n', '      beneficiary,\n', '      weiAmount,\n', '      tokens\n', '    );\n', '\n', '    _updatePurchasingState(beneficiary, weiAmount);\n', '\n', '    _forwardFunds(_value);\n', '    _postValidatePurchase(beneficiary, weiAmount);\n', '  }\n', '\n', '  // -----------------------------------------\n', '  // Internal interface (extensible)\n', '  // -----------------------------------------\n', '\n', '  /**\n', '   * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.\n', "   * Example from CappedCrowdsale.sol's _preValidatePurchase method:\n", '   *   super._preValidatePurchase(beneficiary, weiAmount);\n', '   *   require(weiRaised().add(weiAmount) <= cap);\n', '   * @param beneficiary Address performing the token purchase\n', '   * @param weiAmount Value in wei involved in the purchase\n', '   */\n', '  function _preValidatePurchase(\n', '    address beneficiary,\n', '    uint256 weiAmount\n', '  )\n', '  internal\n', '  {\n', '    require(beneficiary != address(0));\n', '    require(weiAmount != 0);\n', '  }\n', '\n', '  /**\n', '   * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.\n', '   * @param beneficiary Address performing the token purchase\n', '   * @param weiAmount Value in wei involved in the purchase\n', '   */\n', '  function _postValidatePurchase(\n', '    address beneficiary,\n', '    uint256 weiAmount\n', '  )\n', '  internal\n', '  {\n', '    // optional override\n', '  }\n', '\n', '  /**\n', '   * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.\n', '   * @param beneficiary Address performing the token purchase\n', '   * @param tokenAmount Number of tokens to be emitted\n', '   */\n', '  function _deliverTokens(\n', '    address beneficiary,\n', '    uint256 tokenAmount\n', '  )\n', '  internal\n', '  {\n', '    _token.transferByCrowdSale(beneficiary, tokenAmount);\n', '  }\n', '\n', '  /**\n', '   * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.\n', '   * @param beneficiary Address receiving the tokens\n', '   * @param tokenAmount Number of tokens to be purchased\n', '   */\n', '  function _processPurchase(\n', '    address beneficiary,\n', '    uint256 tokenAmount\n', '  )\n', '  internal\n', '  {\n', '    _deliverTokens(beneficiary, tokenAmount);\n', '  }\n', '\n', '  /**\n', '   * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)\n', '   * @param beneficiary Address receiving the tokens\n', '   * @param weiAmount Value in wei involved in the purchase\n', '   */\n', '  function _updatePurchasingState(\n', '    address beneficiary,\n', '    uint256 weiAmount\n', '  )\n', '  internal\n', '  {\n', '    // optional override\n', '  }\n', '\n', '  /**\n', '   * @dev Override to extend the way in which ether is converted to tokens.\n', '   * @param weiAmount Value in wei to be converted into tokens\n', '   * @return Number of tokens that can be purchased with the specified _weiAmount\n', '   */\n', '  function _getTokenAmount(uint256 weiAmount)\n', '  internal view returns (uint256)\n', '  {\n', '    return weiAmount.mul(_rate);\n', '  }\n', '\n', '  /**\n', '   * @dev Determines how ETH is stored/forwarded on purchases.\n', '   */\n', '  function _forwardFunds(uint _value) internal {\n', '\n', '    _krwToken.transferByCrowdSale(_wallet, _value);\n', '  }\n', '}']