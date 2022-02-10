['pragma solidity >=0.5.0 <0.7.0;\n', '\n', '/*\n', '                                              N     .N      \n', '                                            .ONN.   NN      \n', '                                          ..NNDN  :NNNN     \n', '                                         .8NN  NNNN. NN     \n', '                                        NNN. .NNN....NN     \n', '                                    ..NNN ~NNNO     .N:     \n', '                                 .,NNNDNNNN?.       NN      \n', '                    ..?NNNNNNNNNNNNNNND..          NN       \n', '               ..$NNNNN$.    .=NNN=             ..NN        \n', '             .NNNN,         .NNON               NNN         \n', '           NNN+.           NN~.NN           ..NNN           \n', '         NNN..            NN.  ON          .NNN             \n', '      .:NN.              ,N=    NN.    .,NNNN               \n', '      NNI.              .NN     .NNNNNNNN$.,N?              \n', '    ,NN.                .NI     .NNN,.   .  NN.             \n', '    NN .                ?N.       ?NNNNNN... NN             \n', '    NN.                 NN=       ..NN .NNNN NN             \n', '     NN                 NNN.         NN..NN.  NN            \n', '     IN.                NNN.          :NNN=   :N,           \n', '      NN.               N$NN..         .NN.   .NN           \n', '      .NN.              N7 NN .               .NNI          \n', '        NN.             NO  DNN  .          .ZNNNN.         \n', '        .NN             NN .  NNN:..     ..NNN. .NN         \n', '         .NN.           NN .  . INNNNNNNNNNNN:. .ZN         \n', '           NNI.         NN       . NNNN+   .ONNN8 NN        \n', '             NN.        .N.     .NN, $NN?   . .INNN         \n', '              NN?       .NN    NNO     :NNNNNNNN+           \n', '               ~NN      .NN   NN,                           \n', '                .NNN.     NI..NI.                           \n', '                   NNN    NN.NN                             \n', '                    .NND.. NNNI                             \n', '                       NNN.$NN.                             \n', '                         ONNNN?                             \n', '                            NNN                             \n', '\n', '   ,        ,     II   N        NN     OOOOOO       SSSS    \n', '   M        M     II   NN       NN   OOOOOOOOOO    SSSSSSS  \n', '   MM      MM     II   NNN      NN  OOO      OOO  SS     SS   \n', '   MMM    MMM     II   NNNN     NN OO?        OO  SS        \n', '  MM~MM  MMMMM    II   NN NNN   NN OO         OO$  SSSSSS   \n', '  MM MM  MM MM    II   NN  NNN  NN OO         OO=     SSSS  \n', '  MM  MMMM  MM    II   NN   NNN:NN .OOO      OOO        SS  \n', ' MM    MM    MM   II   NN    NNNNN  =OOO    OOO   SS    SS  \n', ' MM    MM    MM   II   NN     NNNN    OOOOOOO      SSSSSS   \n', '*/\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '    uint256 c = a / b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address private _owner;\n', '\n', '  /**\n', '   * Event that notifies clients about the ownership transference\n', '   * @param previousOwner Address registered as the former owner\n', '   * @param newOwner Address that is registered as the new owner\n', '   */\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() internal {\n', '    _owner = msg.sender;\n', '    emit OwnershipTransferred(address(0), _owner);\n', '  }\n', '\n', '  /**\n', '   * @return the address of the owner.\n', '   */\n', '  function owner() public view returns(address) {\n', '    return _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(isOwner(), "Ownable: Caller is not the owner");\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @return true if `msg.sender` is the owner of the contract.\n', '   */\n', '  function isOwner() public view returns(bool) {\n', '    return msg.sender == _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0), "Ownable: New owner is the zero address");\n', '    emit OwnershipTransferred(_owner, newOwner);\n', '    _owner = newOwner;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md\n', ' */\n', 'interface IERC20 {\n', '\n', '  function balanceOf(address account) external view returns (uint256);\n', ' \n', '  function transfer(address to, uint256 value) external returns (bool);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    external returns (bool);\n', '\n', '  function approve(address spender, uint256 value)\n', '    external returns (bool);\n', '\n', '  function allowance(address owner, address spender)\n', '    external view returns (uint256);\n', '\n', '  /**\n', '   * Event that notifies clients about the amount transferred\n', '   * @param from Address owner of the transferred funds\n', '   * @param to Destination address\n', '   * @param value Amount of tokens transferred\n', '   */\n', '  event Transfer(\n', '    address indexed from,\n', '    address indexed to,\n', '    uint256 value\n', '  );\n', '\n', '  /**\n', '   * Event that notifies clients about the amount approved to be spent\n', '   * @param owner Address owner of the approved funds\n', '   * @param spender The address authorized to spend the funds\n', '   * @param value Amount of tokens approved\n', '   */\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '/**\n', ' * @title ERC20\n', ' * @dev Implements the functions declared in the IERC20 interface\n', ' */\n', 'contract ERC20 is IERC20 {\n', '  using SafeMath for uint256;\n', '\n', '  mapping (address => uint256) internal balances;\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  uint256 public totalSupply;\n', '  \n', '  constructor(uint256 initialSupply) internal {\n', '    require(msg.sender != address(0));\n', '    totalSupply = initialSupply;\n', '    balances[msg.sender] = initialSupply;\n', '    emit Transfer(address(0), msg.sender, initialSupply);\n', '  }\n', '\n', '  /**\n', '   * @dev Gets the balance of the specified address.\n', '   * @param account The address to query the balance of.\n', '   * @return An uint256 representing the amount owned by the passed address.\n', '   */\n', '  function balanceOf(address account) external view returns (uint256) {\n', '    return balances[account];\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer token for a specified address\n', '   * @param to The address to transfer to.\n', '   * @param value The amount to be transferred.\n', '   */\n', '  function transfer(address to, uint256 value) public returns (bool) {\n', '    require(value <= balances[msg.sender]);\n', '    require(to != address(0));\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(value);\n', '    balances[to] = balances[to].add(value);\n', '    emit Transfer(msg.sender, to, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param from address The address which you want to send tokens from\n', '   * @param to address The address which you want to transfer to\n', '   * @param value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(\n', '    address from,\n', '    address to,\n', '    uint256 value\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(value <= balances[from]);\n', '    require(value <= allowed[from][msg.sender]);\n', '    require(to != address(0));\n', '\n', '    balances[from] = balances[from].sub(value);\n', '    balances[to] = balances[to].add(value);\n', '    allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);\n', '    emit Transfer(from, to, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param spender The address which will spend the funds.\n', '   * @param value The amount of tokens to be spent.\n', '   */\n', '  function approve(address spender, uint256 value) public returns (bool) {\n', '    require(spender != address(0));\n', '\n', '    allowed[msg.sender][spender] = value;\n', '    emit Approval(msg.sender, spender, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param owner address The address which owns the funds.\n', '   * @param spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(\n', '    address owner,\n', '    address spender\n', '   )\n', '    external\n', '    view\n', '    returns (uint256)\n', '  {\n', '    return allowed[owner][spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param spender The address which will spend the funds.\n', '   * @param addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseAllowance(\n', '    address spender,\n', '    uint256 addedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(spender != address(0));\n', '\n', '    allowed[msg.sender][spender] = (\n', '      allowed[msg.sender][spender].add(addedValue));\n', '    emit Approval(msg.sender, spender, allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param spender The address which will spend the funds.\n', '   * @param subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseAllowance(\n', '    address spender,\n', '    uint256 subtractedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(spender != address(0));\n', '\n', '    allowed[msg.sender][spender] = (\n', '      allowed[msg.sender][spender].sub(subtractedValue));\n', '    emit Approval(msg.sender, spender, allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract Burnable is ERC20 {\n', '\n', '  /**\n', '   * Event that notifies clients about the amount burnt\n', '   * @param from Address owner of the burnt funds\n', '   * @param value Amount of tokens burnt\n', '   */\n', '  event Burn(\n', '    address indexed from,\n', '    uint256 value\n', '  );\n', '  \n', '  /**\n', '   * @dev Burns a specific amount of tokens.\n', '   * @param value The amount of token to be burned.\n', '   */\n', '  function burn(uint256 value) public {\n', '    _burn(msg.sender, value);\n', '  }\n', '\n', '  /**\n', '   * @dev Burns a specific amount of tokens from the target address and decrements allowance\n', '   * @param from address The address which you want to send tokens from\n', '   * @param value uint256 The amount of token to be burned\n', '   */\n', '  function burnFrom(address from, uint256 value) public {\n', '    require(value <= allowed[from][msg.sender], "Burnable: Amount to be burnt exceeds the account balance");\n', '\n', '    // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,\n', '    // this function needs to emit an event with the updated approval.\n', '    allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);\n', '    _burn(from, value);\n', '  }\n', '\n', '  /**\n', '   * @dev Internal function that burns an amount of the token of a given\n', '   * account.\n', '   * @param account The account whose tokens will be burnt.\n', '   * @param amount The amount that will be burnt.\n', '   */\n', '  function _burn(address account, uint256 amount) internal {\n', '    require(account != address(0), "Burnable: Burn from the zero address");\n', '    require(amount > 0, "Burnable: Can not burn negative amount");\n', '    require(amount <= balances[account], "Burnable: Amount to be burnt exceeds the account balance");\n', '\n', '    totalSupply = totalSupply.sub(amount);\n', '    balances[account] = balances[account].sub(amount);\n', '    emit Burn(account, amount);\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Freezable Token\n', ' * @dev Token that can be frozen.\n', ' */\n', 'contract Freezable is ERC20 {\n', '\n', '  mapping (address => uint256) private _freeze;\n', '\n', '  /**\n', '   * Event that notifies clients about the amount frozen\n', '   * @param from Address owner of the frozen funds\n', '   * @param value Amount of tokens frozen\n', '   */\n', '  event Freeze(\n', '    address indexed from,\n', '    uint256 value\n', '  );\n', '\n', '  /**\n', '   * Event that notifies clients about the amount unfrozen\n', '   * @param from Address owner of the unfrozen funds\n', '   * @param value Amount of tokens unfrozen\n', '   */\n', '  event Unfreeze(\n', '    address indexed from,\n', '    uint256 value\n', '  );\n', '\n', '  /**\n', '   * @dev Gets the frozen balance of the specified address.\n', '   * @param account The address to query the frozen balance of.\n', '   * @return An uint256 representing the amount frozen by the passed address.\n', '   */\n', '  function freezeOf(address account) public view returns (uint256) {\n', '    return _freeze[account];\n', '  }\n', '\n', '  /**\n', '   * @dev Freezes a specific amount of tokens\n', '   * @param amount uint256 The amount of token to be frozen\n', '   */\n', '  function freeze(uint256 amount) public {\n', '    require(balances[msg.sender] >= amount, "Freezable: Amount to be frozen exceeds the account balance");\n', '    require(amount > 0, "Freezable: Can not freeze negative amount");\n', '    balances[msg.sender] = balances[msg.sender].sub(amount);\n', '    _freeze[msg.sender] = _freeze[msg.sender].add(amount);\n', '    emit Freeze(msg.sender, amount);\n', '  }\n', '\n', '  /**\n', '   * @dev Unfreezes a specific amount of tokens\n', '   * @param amount uint256 The amount of token to be unfrozen\n', '   */\n', '  function unfreeze(uint256 amount) public {\n', '    require(_freeze[msg.sender] >= amount, "Freezable: Amount to be unfrozen exceeds the account balance");\n', '    require(amount > 0, "Freezable: Can not unfreeze negative amount");\n', '    _freeze[msg.sender] = _freeze[msg.sender].sub(amount);\n', '    balances[msg.sender] = balances[msg.sender].add(amount);\n', '    emit Unfreeze(msg.sender, amount);\n', '  }\n', '}\n', '\n', '/**\n', ' * @title MinosCoin \n', ' * @dev Contract for MinosCoin token\n', ' **/\n', 'contract MinosCoin is ERC20, Burnable, Freezable, Ownable {\n', '\n', '  string public constant name = "MinosCoin";\n', '  string public constant symbol = "MNS";\n', '  uint8 public constant decimals = 18;\n', '\n', '  // Initial supply is the balance assigned to the owner\n', '  uint256 private constant _initialSupply = 300000000 * (10 ** uint256(decimals));\n', '\n', '  /**\n', '   * @dev Constructor\n', '   */\n', '  constructor() \n', '    public \n', '    ERC20(_initialSupply)\n', '  {\n', '    require(msg.sender != address(0), "MinosCoin: Create contract from the zero address");\n', '  }\n', '  \n', '  /**\n', '   * @dev Allows to transfer out the ether balance that was sent into this contract\n', '   */\n', '  function withdrawEther() public onlyOwner {\n', '    uint256 totalBalance = address(this).balance;\n', '    require(totalBalance > 0, "MinosCoin: No ether available to be withdrawn");\n', '    msg.sender.transfer(totalBalance);\n', '  }\n', '}']