['pragma solidity 0.4.25;\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address private _owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    _owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @return the address of the owner.\n', '   */\n', '  function owner() public view returns(address) {\n', '    return _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(isOwner());\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @return true if `msg.sender` is the owner of the contract.\n', '   */\n', '  function isOwner() public view returns(bool) {\n', '    return msg.sender == _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(_owner);\n', '    _owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    _transferOwnership(newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address newOwner) internal {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(_owner, newOwner);\n', '    _owner = newOwner;\n', '  }\n', '}\n', '\n', '// File: contracts/Administratable.sol\n', '\n', '// Lee, July 29, 2018\n', 'pragma solidity 0.4.25;\n', '\n', '\n', 'contract Administratable is Ownable {\n', '\tmapping (address => bool) public superAdmins;\n', '\n', '\tevent AddSuperAdmin(address indexed admin);\n', '\tevent RemoveSuperAdmin(address indexed admin);\n', '\n', '    modifier validateAddress( address _addr )\n', '    {\n', '        require(_addr != address(0x0));\n', '        require(_addr != address(this));\n', '        _;\n', '    }\n', '\n', '\tmodifier onlySuperAdmins {\n', '\t\trequire(msg.sender == owner() || superAdmins[msg.sender]);\n', '\t\t_;\n', '\t}\n', '\n', '\tfunction addSuperAdmin(address _admin) public onlyOwner validateAddress(_admin){\n', '\t\trequire(!superAdmins[_admin]);\n', '\t\tsuperAdmins[_admin] = true;\n', '\t\temit AddSuperAdmin(_admin);\n', '\t}\n', '\n', '\tfunction removeSuperAdmin(address _admin) public onlyOwner validateAddress(_admin){\n', '\t\trequire(superAdmins[_admin]);\n', '\t\tsuperAdmins[_admin] = false;\n', '\t\temit RemoveSuperAdmin(_admin);\n', '\t}\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'interface IERC20 {\n', '  function totalSupply() external view returns (uint256);\n', '\n', '  function balanceOf(address who) external view returns (uint256);\n', '\n', '  function allowance(address owner, address spender)\n', '    external view returns (uint256);\n', '\n', '  function transfer(address to, uint256 value) external returns (bool);\n', '\n', '  function approve(address spender, uint256 value)\n', '    external returns (bool);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    external returns (bool);\n', '\n', '  event Transfer(\n', '    address indexed from,\n', '    address indexed to,\n', '    uint256 value\n', '  );\n', '\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md\n', ' * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract ERC20 is IERC20 {\n', '  using SafeMath for uint256;\n', '\n', '  mapping (address => uint256) private _balances;\n', '\n', '  mapping (address => mapping (address => uint256)) private _allowed;\n', '\n', '  uint256 private _totalSupply;\n', '\n', '  /**\n', '  * @dev Total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return _totalSupply;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address owner) public view returns (uint256) {\n', '    return _balances[owner];\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param owner address The address which owns the funds.\n', '   * @param spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(\n', '    address owner,\n', '    address spender\n', '   )\n', '    public\n', '    view\n', '    returns (uint256)\n', '  {\n', '    return _allowed[owner][spender];\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified address\n', '  * @param to The address to transfer to.\n', '  * @param value The amount to be transferred.\n', '  */\n', '  function transfer(address to, uint256 value) public returns (bool) {\n', '    require(value <= _balances[msg.sender]);\n', '    require(to != address(0));\n', '\n', '    _balances[msg.sender] = _balances[msg.sender].sub(value);\n', '    _balances[to] = _balances[to].add(value);\n', '    emit Transfer(msg.sender, to, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param spender The address which will spend the funds.\n', '   * @param value The amount of tokens to be spent.\n', '   */\n', '  function approve(address spender, uint256 value) public returns (bool) {\n', '    require(spender != address(0));\n', '\n', '    _allowed[msg.sender][spender] = value;\n', '    emit Approval(msg.sender, spender, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param from address The address which you want to send tokens from\n', '   * @param to address The address which you want to transfer to\n', '   * @param value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(\n', '    address from,\n', '    address to,\n', '    uint256 value\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(value <= _balances[from]);\n', '    require(value <= _allowed[from][msg.sender]);\n', '    require(to != address(0));\n', '\n', '    _balances[from] = _balances[from].sub(value);\n', '    _balances[to] = _balances[to].add(value);\n', '    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '    emit Transfer(from, to, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed_[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param spender The address which will spend the funds.\n', '   * @param addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseAllowance(\n', '    address spender,\n', '    uint256 addedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(spender != address(0));\n', '\n', '    _allowed[msg.sender][spender] = (\n', '      _allowed[msg.sender][spender].add(addedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed_[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param spender The address which will spend the funds.\n', '   * @param subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseAllowance(\n', '    address spender,\n', '    uint256 subtractedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(spender != address(0));\n', '\n', '    _allowed[msg.sender][spender] = (\n', '      _allowed[msg.sender][spender].sub(subtractedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Internal function that mints an amount of the token and assigns it to\n', '   * an account. This encapsulates the modification of balances such that the\n', '   * proper events are emitted.\n', '   * @param account The account that will receive the created tokens.\n', '   * @param amount The amount that will be created.\n', '   */\n', '  function _mint(address account, uint256 amount) internal {\n', '    require(account != 0);\n', '    _totalSupply = _totalSupply.add(amount);\n', '    _balances[account] = _balances[account].add(amount);\n', '    emit Transfer(address(0), account, amount);\n', '  }\n', '\n', '  /**\n', '   * @dev Internal function that burns an amount of the token of a given\n', '   * account.\n', '   * @param account The account whose tokens will be burnt.\n', '   * @param amount The amount that will be burnt.\n', '   */\n', '  function _burn(address account, uint256 amount) internal {\n', '    require(account != 0);\n', '    require(amount <= _balances[account]);\n', '\n', '    _totalSupply = _totalSupply.sub(amount);\n', '    _balances[account] = _balances[account].sub(amount);\n', '    emit Transfer(account, address(0), amount);\n', '  }\n', '\n', '  /**\n', '   * @dev Internal function that burns an amount of the token of a given\n', "   * account, deducting from the sender's allowance for said account. Uses the\n", '   * internal burn function.\n', '   * @param account The account whose tokens will be burnt.\n', '   * @param amount The amount that will be burnt.\n', '   */\n', '  function _burnFrom(address account, uint256 amount) internal {\n', '    require(amount <= _allowed[account][msg.sender]);\n', '\n', '    // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,\n', '    // this function needs to emit an event with the updated approval.\n', '    _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(\n', '      amount);\n', '    _burn(account, amount);\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol\n', '\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract ERC20Burnable is ERC20 {\n', '\n', '  /**\n', '   * @dev Burns a specific amount of tokens.\n', '   * @param value The amount of token to be burned.\n', '   */\n', '  function burn(uint256 value) public {\n', '    _burn(msg.sender, value);\n', '  }\n', '\n', '  /**\n', '   * @dev Burns a specific amount of tokens from the target address and decrements allowance\n', '   * @param from address The address which you want to send tokens from\n', '   * @param value uint256 The amount of token to be burned\n', '   */\n', '  function burnFrom(address from, uint256 value) public {\n', '    _burnFrom(from, value);\n', '  }\n', '\n', '  /**\n', '   * @dev Overrides ERC20._burn in order for burn and burnFrom to emit\n', '   * an additional Burn event.\n', '   */\n', '  function _burn(address who, uint256 value) internal {\n', '    super._burn(who, value);\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/access/Roles.sol\n', '\n', '/**\n', ' * @title Roles\n', ' * @dev Library for managing addresses assigned to a Role.\n', ' */\n', 'library Roles {\n', '  struct Role {\n', '    mapping (address => bool) bearer;\n', '  }\n', '\n', '  /**\n', '   * @dev give an account access to this role\n', '   */\n', '  function add(Role storage role, address account) internal {\n', '    require(account != address(0));\n', '    role.bearer[account] = true;\n', '  }\n', '\n', '  /**\n', "   * @dev remove an account's access to this role\n", '   */\n', '  function remove(Role storage role, address account) internal {\n', '    require(account != address(0));\n', '    role.bearer[account] = false;\n', '  }\n', '\n', '  /**\n', '   * @dev check if an account has this role\n', '   * @return bool\n', '   */\n', '  function has(Role storage role, address account)\n', '    internal\n', '    view\n', '    returns (bool)\n', '  {\n', '    require(account != address(0));\n', '    return role.bearer[account];\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol\n', '\n', 'contract MinterRole {\n', '  using Roles for Roles.Role;\n', '\n', '  event MinterAdded(address indexed account);\n', '  event MinterRemoved(address indexed account);\n', '\n', '  Roles.Role private minters;\n', '\n', '  constructor() public {\n', '    minters.add(msg.sender);\n', '  }\n', '\n', '  modifier onlyMinter() {\n', '    require(isMinter(msg.sender));\n', '    _;\n', '  }\n', '\n', '  function isMinter(address account) public view returns (bool) {\n', '    return minters.has(account);\n', '  }\n', '\n', '  function addMinter(address account) public onlyMinter {\n', '    minters.add(account);\n', '    emit MinterAdded(account);\n', '  }\n', '\n', '  function renounceMinter() public {\n', '    minters.remove(msg.sender);\n', '  }\n', '\n', '  function _removeMinter(address account) internal {\n', '    minters.remove(account);\n', '    emit MinterRemoved(account);\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol\n', '\n', '/**\n', ' * @title ERC20Mintable\n', ' * @dev ERC20 minting logic\n', ' */\n', 'contract ERC20Mintable is ERC20, MinterRole {\n', '  event MintingFinished();\n', '\n', '  bool private _mintingFinished = false;\n', '\n', '  modifier onlyBeforeMintingFinished() {\n', '    require(!_mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @return true if the minting is finished.\n', '   */\n', '  function mintingFinished() public view returns(bool) {\n', '    return _mintingFinished;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param to The address that will receive the minted tokens.\n', '   * @param amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(\n', '    address to,\n', '    uint256 amount\n', '  )\n', '    public\n', '    onlyMinter\n', '    onlyBeforeMintingFinished\n', '    returns (bool)\n', '  {\n', '    _mint(to, amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting()\n', '    public\n', '    onlyMinter\n', '    onlyBeforeMintingFinished\n', '    returns (bool)\n', '  {\n', '    _mintingFinished = true;\n', '    emit MintingFinished();\n', '    return true;\n', '  }\n', '}\n', '\n', '// File: contracts/Freezable.sol\n', '\n', '// Lee, July 29, 2018\n', 'pragma solidity 0.4.25;\n', '\n', '\n', 'contract Freezable is Administratable {\n', '\n', '    bool public frozenToken;\n', '    mapping (address => bool) public frozenAccounts;\n', '\n', '    event FrozenFunds(address indexed _target, bool _frozen);\n', '    event FrozenToken(bool _frozen);\n', '\n', '    modifier isNotFrozen( address _to ) {\n', '        require(!frozenToken);\n', '        require(!frozenAccounts[msg.sender] && !frozenAccounts[_to]);\n', '        _;\n', '    }\n', '\n', '    modifier isNotFrozenFrom( address _from, address _to ) {\n', '        require(!frozenToken);\n', '        require(!frozenAccounts[msg.sender] && !frozenAccounts[_from] && !frozenAccounts[_to]);\n', '        _;\n', '    }\n', '\n', '    function freezeAccount(address _target, bool _freeze) public onlySuperAdmins validateAddress(_target) {\n', '        require(frozenAccounts[_target] != _freeze);\n', '        frozenAccounts[_target] = _freeze;\n', '        emit FrozenFunds(_target, _freeze);\n', '    }\n', '\n', '    function freezeToken(bool _freeze) public onlySuperAdmins {\n', '        require(frozenToken != _freeze);\n', '        frozenToken = _freeze;\n', '        emit FrozenToken(frozenToken);\n', '    }\n', '}\n', '\n', '// File: contracts/Cryptonium.sol\n', '\n', '// Lee, July 29, 2018\n', 'pragma solidity 0.4.25;\n', '\n', '\n', '\n', '\n', 'contract Cryptonium is ERC20Burnable, ERC20Mintable, Freezable\n', '{\n', '    string  public  constant name       = "Cryptonium";\n', '    string  public  constant symbol     = "CRN";\n', '    uint8   public  constant decimals   = 18;\n', '    \n', '    event Burn(address indexed _burner, uint _value);\n', '\n', '    constructor( address _registry, uint _totalTokenAmount ) public\n', '    {\n', '        _mint(_registry, _totalTokenAmount);\n', '        addSuperAdmin(_registry);\n', '    }\n', '\n', '\n', '\n', '\n', '    /**\n', '    * @dev Transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */    \n', '    function transfer(address _to, uint _value) public validateAddress(_to) isNotFrozen(_to) returns (bool) \n', '    {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer tokens from one address to another\n', '    * @param _from address The address which you want to send tokens from\n', '    * @param _to address The address which you want to transfer to\n', '    * @param _value uint256 the amount of tokens to be transferred\n', '    */\n', '    function transferFrom(address _from, address _to, uint _value) public validateAddress(_to)  isNotFrozenFrom(_from, _to) returns (bool) \n', '    {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public validateAddress(_spender) isNotFrozen(_spender)  returns (bool) \n', '    {\n', '        return super.approve(_spender, _value);\n', '    }\n', '\n', '    function increaseAllowance( address _spender, uint256 _addedValue ) public validateAddress(_spender) isNotFrozen(_spender)  returns (bool)\n', '    {\n', '        return super.increaseAllowance(_spender, _addedValue);\n', '    }\n', '\n', '    function decreaseAllowance(address _spender, uint256 _subtractedValue) public validateAddress(_spender) isNotFrozen(_spender)  returns (bool)\n', '    {\n', '        return super.decreaseAllowance(_spender, _subtractedValue);\n', '    }\n', '}\n', '\n', '// File: contracts/Migrations.sol\n', '\n', 'contract Migrations {\n', '    address public owner;\n', '    uint public last_completed_migration;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier restricted() {\n', '        if (msg.sender == owner) _;\n', '    }\n', '\n', '    function setCompleted(uint completed) public restricted {\n', '        last_completed_migration = completed;\n', '    }\n', '\n', '    function upgrade(address new_address) public restricted {\n', '        Migrations upgraded = Migrations(new_address);\n', '        upgraded.setCompleted(last_completed_migration);\n', '    }\n', '}']