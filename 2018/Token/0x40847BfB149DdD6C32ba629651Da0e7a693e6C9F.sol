['pragma solidity ^0.4.24;\n', '/**\n', ' * @title Roles\n', ' * @dev Library for managing addresses assigned to a Role.\n', ' */\n', 'library Roles {\n', '  struct Role {\n', '    mapping (address => bool) bearer;\n', '  }\n', '\n', '  /**\n', '   * @dev give an account access to this role\n', '   */\n', '  function add(Role storage role, address account) internal {\n', '    require(account != address(0));\n', '    require(!has(role, account));\n', '\n', '    role.bearer[account] = true;\n', '  }\n', '\n', '  /**\n', '   * @dev remove an account&#39;s access to this role\n', '   */\n', '  function remove(Role storage role, address account) internal {\n', '    require(account != address(0));\n', '    require(has(role, account));\n', '\n', '    role.bearer[account] = false;\n', '  }\n', '\n', '  /**\n', '   * @dev check if an account has this role\n', '   * @return bool\n', '   */\n', '  function has(Role storage role, address account)\n', '    internal\n', '    view\n', '    returns (bool)\n', '  {\n', '    require(account != address(0));\n', '    return role.bearer[account];\n', '  }\n', '}\n', '\n', '\n', 'contract MasterRole {\n', '  using Roles for Roles.Role;\n', '\n', '  event MasterAdded(address indexed account);\n', '  event MasterRemoved(address indexed account);\n', '\n', '  Roles.Role private masters;\n', '\n', '  constructor() internal {\n', '    _addMaster(msg.sender);\n', '  }\n', '\n', '  modifier onlyMaster() {\n', '    require(isMaster(msg.sender));\n', '    _;\n', '  }\n', '\n', '  function isMaster(address account) public view returns (bool) {\n', '    return masters.has(account);\n', '  }\n', '\n', '  function addMaster(address account) public onlyMaster {\n', '    _addMaster(account);\n', '  }\n', '\n', '  function renounceMaster() public {\n', '    _removeMaster(msg.sender);\n', '  }\n', '\n', '  function _addMaster(address account) internal {\n', '    masters.add(account);\n', '    emit MasterAdded(account);\n', '  }\n', '\n', '  function _removeMaster(address account) internal {\n', '    masters.remove(account);\n', '    emit MasterRemoved(account);\n', '  }\n', '}\n', '\n', 'contract MinterRole {\n', '  using Roles for Roles.Role;\n', '\n', '  event MinterAdded(address indexed account);\n', '  event MinterRemoved(address indexed account);\n', '\n', '  Roles.Role private minters;\n', '\n', '  constructor() internal {\n', '    _addMinter(msg.sender);\n', '  }\n', '\n', '  modifier onlyMinter() {\n', '    require(isMinter(msg.sender));\n', '    _;\n', '  }\n', '\n', '  function isMinter(address account) public view returns (bool) {\n', '    return minters.has(account);\n', '  }\n', '\n', '  function addMinter(address account) public onlyMinter {\n', '    _addMinter(account);\n', '  }\n', '\n', '  function renounceMinter() public {\n', '    _removeMinter(msg.sender);\n', '  }\n', '\n', '  function _addMinter(address account) internal {\n', '    minters.add(account);\n', '    emit MinterAdded(account);\n', '  }\n', '\n', '  function _removeMinter(address account) internal {\n', '    minters.remove(account);\n', '    emit MinterRemoved(account);\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'interface IERC20 {\n', '  function totalSupply() external view returns (uint256);\n', '\n', '  function balanceOf(address who) external view returns (uint256);\n', '\n', '  function allowance(address owner, address spender)\n', '    external view returns (uint256);\n', '\n', '  function transfer(address to, uint256 value) external returns (bool);\n', '\n', '  function approve(address spender, uint256 value)\n', '    external returns (bool);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    external returns (bool);\n', '\n', '  event Transfer(\n', '    address indexed from,\n', '    address indexed to,\n', '    uint256 value\n', '  );\n', '\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '\n', '  event TransferWithData(\n', '    address indexed from,\n', '    address indexed to,\n', '    bytes32 indexed data,\n', '    uint256 value\n', '  );\n', '}\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // Gas optimization: this is cheaper than requiring &#39;a&#39; not being zero, but the\n', '    // benefit is lost if &#39;b&#39; is also tested.\n', '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', 'contract AddressMapper is MasterRole {\n', '    \n', '    event DoMap(address indexed src, bytes32 indexed target, string rawTarget);\n', '    event DoMapAuto(address indexed src, bytes32 indexed target, string rawTarget);\n', '    event UnMap(address indexed src);\n', '\n', '    mapping (address => string) public mapper;\n', '\n', '    modifier onlyNotSet(address src) {\n', '        bytes memory tmpTargetBytes = bytes(mapper[src]);\n', '        require(tmpTargetBytes.length == 0);\n', '        _;\n', '    }\n', '\n', '    function()\n', '        public\n', '        payable\n', '        onlyNotSet(msg.sender)\n', '    {\n', '        require(msg.value > 0);\n', '        _doMapAuto(msg.sender, string(msg.data));\n', '        msg.sender.transfer(msg.value);\n', '    }\n', '\n', '    function isAddressSet(address thisAddr)\n', '        public\n', '        view\n', '        returns(bool)\n', '    {\n', '        bytes memory tmpTargetBytes = bytes(mapper[thisAddr]);\n', '        if(tmpTargetBytes.length == 0) {\n', '            return false;\n', '        } else {\n', '            return true;\n', '        }\n', '    }\n', '\n', '    function _doMapAuto(address src, string target)\n', '        internal\n', '    {\n', '        mapper[src] = target;\n', '        bytes32 translated = _stringToBytes32(target);\n', '        emit DoMapAuto(src, translated, target);\n', '    }\n', '\n', '    function doMap(address src, string target) \n', '        public\n', '        onlyMaster\n', '        onlyNotSet(src)\n', '    {\n', '        mapper[src] = target;\n', '        bytes32 translated = _stringToBytes32(target);\n', '        emit DoMap(src, translated, target);\n', '    }\n', '\n', '    function unMap(address src) \n', '        public\n', '        onlyMaster\n', '    {\n', '        mapper[src] = "";\n', '        emit UnMap(src);\n', '    }\n', '\n', '    function _stringToBytes32(string memory source) internal returns (bytes32 result) {\n', '        bytes memory tempEmptyStringTest = bytes(source);\n', '        if (tempEmptyStringTest.length == 0) {\n', '            return 0x0;\n', '        }\n', '\n', '        assembly {\n', '            result := mload(add(source, 32))\n', '        }\n', '    }\n', '\n', '    function submitTransaction(address destination, uint value, bytes data)\n', '        public\n', '        onlyMaster\n', '    {\n', '        external_call(destination, value, data.length, data);\n', '    }\n', '\n', '    function external_call(address destination, uint value, uint dataLength, bytes data) private returns (bool) {\n', '        bool result;\n', '        assembly {\n', '            let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)\n', '            let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that\n', '            result := call(\n', '                sub(gas, 34710),   // 34710 is the value that solidity is currently emitting\n', '                                   // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +\n', '                                   // callNewAccountGas (25000, in case the destination address does not exist and needs creating)\n', '                destination,\n', '                value,\n', '                d,\n', '                dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem\n', '                x,\n', '                0                  // Output is ignored, therefore the output size is zero\n', '            )\n', '        }\n', '        return result;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md\n', ' * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract ERC20 is IERC20 {\n', '  using SafeMath for uint256;\n', '\n', '  mapping (address => uint256) internal _balances;\n', '\n', '  mapping (address => mapping (address => uint256)) internal _allowed;\n', '\n', '  uint256 private _totalSupply;\n', '\n', '  AddressMapper public addressMapper;\n', '\n', '  constructor(address addressMapperAddr) public {\n', '    addressMapper = AddressMapper(addressMapperAddr);\n', '  }\n', '\n', '  /**\n', '  * @dev Total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return _totalSupply;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param owner The address to query the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address owner) public view returns (uint256) {\n', '    return _balances[owner];\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param owner address The address which owns the funds.\n', '   * @param spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(\n', '    address owner,\n', '    address spender\n', '   )\n', '    public\n', '    view\n', '    returns (uint256)\n', '  {\n', '    return _allowed[owner][spender];\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified address\n', '  * @param to The address to transfer to.\n', '  * @param value The amount to be transferred.\n', '  */\n', '  function transfer(address to, uint256 value) public returns (bool) {\n', '    _transfer(msg.sender, to, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified address\n', '  * @param to The address to transfer to.\n', '  * @param value The amount to be transferred.\n', '  * @param data addtional data.\n', '  */\n', '  function transferWithData(address to, uint256 value, bytes32 data) public returns (bool) {\n', '    _transfer(msg.sender, to, value);\n', '    emit TransferWithData(msg.sender, to, data, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param spender The address which will spend the funds.\n', '   * @param value The amount of tokens to be spent.\n', '   */\n', '  function approve(address spender, uint256 value) public returns (bool) {\n', '    require(spender != address(0));\n', '\n', '    _allowed[msg.sender][spender] = value;\n', '    emit Approval(msg.sender, spender, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param from address The address which you want to send tokens from\n', '   * @param to address The address which you want to transfer to\n', '   * @param value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(\n', '    address from,\n', '    address to,\n', '    uint256 value\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(value <= _allowed[from][msg.sender]);\n', '\n', '    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '    _transfer(from, to, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param from address The address which you want to send tokens from\n', '   * @param to address The address which you want to transfer to\n', '   * @param value uint256 the amount of tokens to be transferred\n', '   * @param data addtional data.\n', '   */\n', '  function transferFromWithData(\n', '    address from,\n', '    address to,\n', '    uint256 value,\n', '    bytes32 data\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(value <= _allowed[from][msg.sender]);\n', '\n', '    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '    _transfer(from, to, value);\n', '    emit TransferWithData(from, to, data, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed_[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param spender The address which will spend the funds.\n', '   * @param addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseAllowance(\n', '    address spender,\n', '    uint256 addedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(spender != address(0));\n', '\n', '    _allowed[msg.sender][spender] = (\n', '      _allowed[msg.sender][spender].add(addedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed_[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param spender The address which will spend the funds.\n', '   * @param subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseAllowance(\n', '    address spender,\n', '    uint256 subtractedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(spender != address(0));\n', '\n', '    _allowed[msg.sender][spender] = (\n', '      _allowed[msg.sender][spender].sub(subtractedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified addresses\n', '  * @param from The address to transfer from.\n', '  * @param to The address to transfer to.\n', '  * @param value The amount to be transferred.\n', '  */\n', '  function _transfer(address from, address to, uint256 value) internal {\n', '    require(value <= _balances[from]);\n', '    require(to != address(0));\n', '\n', '    _balances[from] = _balances[from].sub(value);\n', '    _balances[to] = _balances[to].add(value);\n', '    emit Transfer(from, to, value);\n', '  }\n', '\n', '  /**\n', '   * @dev Internal function that mints an amount of the token and assigns it to\n', '   * an account. This encapsulates the modification of balances such that the\n', '   * proper events are emitted.\n', '   * @param account The account that will receive the created tokens.\n', '   * @param value The amount that will be created.\n', '   */\n', '  function _mint(address account, uint256 value) internal {\n', '    require(account != 0);\n', '    _totalSupply = _totalSupply.add(value);\n', '    _balances[account] = _balances[account].add(value);\n', '    emit Transfer(address(0), account, value);\n', '  }\n', '\n', '  /**\n', '   * @dev Internal function that burns an amount of the token of a given\n', '   * account.\n', '   * @param account The account whose tokens will be burnt.\n', '   * @param value The amount that will be burnt.\n', '   */\n', '  function _burn(address account, uint256 value) internal {\n', '    require(account != 0);\n', '    require(value <= _balances[account]);\n', '\n', '    _totalSupply = _totalSupply.sub(value);\n', '    _balances[account] = _balances[account].sub(value);\n', '    emit Transfer(account, address(0), value);\n', '  }\n', '\n', '  /**\n', '   * @dev Internal function that burns an amount of the token of a given\n', '   * account, deducting from the sender&#39;s allowance for said account. Uses the\n', '   * internal burn function.\n', '   * @param account The account whose tokens will be burnt.\n', '   * @param value The amount that will be burnt.\n', '   */\n', '  function _burnFrom(address account, uint256 value) internal {\n', '    require(value <= _allowed[account][msg.sender]);\n', '\n', '    // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,\n', '    // this function needs to emit an event with the updated approval.\n', '    _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(\n', '      value);\n', '    _burn(account, value);\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Mintable\n', ' * @dev ERC20 minting logic\n', ' */\n', 'contract ERC20Mintable is ERC20, MinterRole {\n', '\n', '  constructor(address addressMapperAddr)\n', '    ERC20(addressMapperAddr)\n', '    public\n', '  {}\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param to The address that will receive the minted tokens.\n', '   * @param value The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(\n', '    address to,\n', '    uint256 value\n', '  )\n', '    public\n', '    onlyMinter\n', '    returns (bool)\n', '  {\n', '    _mint(to, value);\n', '    return true;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Capped token\n', ' * @dev Mintable token with a token cap.\n', ' */\n', 'contract ERC20Capped is ERC20Mintable {\n', '\n', '  event SetIsPreventedAddr(address indexed preventedAddr, bool hbool);\n', '\n', '  uint256 private _cap;\n', '  string private _name;\n', '  string private _symbol;\n', '  uint8 private _decimals;\n', '\n', '  mapping ( address => bool ) public isPreventedAddr;\n', '\n', '  function transfer(address to, uint256 value) public returns (bool) {\n', '    _checkedTransfer(msg.sender, to, value);\n', '    return true;\n', '  }\n', '\n', '  function transferWithData(address to, uint256 value, bytes32 data) public returns (bool) {\n', '    _checkedTransfer(msg.sender, to, value);\n', '    emit TransferWithData(msg.sender, to, data, value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(\n', '    address from,\n', '    address to,\n', '    uint256 value\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(value <= _allowed[from][msg.sender]);\n', '\n', '    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '    _checkedTransfer(from, to, value);\n', '    return true;\n', '  }\n', '\n', '  function transferFromWithData(\n', '    address from,\n', '    address to,\n', '    uint256 value,\n', '    bytes32 data\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(value <= _allowed[from][msg.sender]);\n', '\n', '    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '    _checkedTransfer(from, to, value);\n', '    emit TransferWithData(from, to, data, value);\n', '    return true;\n', '  }\n', '\n', '  function _checkedTransfer(address from, address to, uint256 value) internal {\n', '    require(value <= _balances[from]);\n', '    require(to != address(0));\n', '\n', '    \n', '    if(isPreventedAddr[to]) {\n', '      require(addressMapper.isAddressSet(from));\n', '    }\n', '\n', '    _balances[from] = _balances[from].sub(value);\n', '    _balances[to] = _balances[to].add(value);\n', '    emit Transfer(from, to, value);\n', '  }\n', '\n', '  function setIsPreventedAddr(address thisAddr, bool hbool)\n', '    public\n', '    onlyMinter\n', '  {\n', '    isPreventedAddr[thisAddr] = hbool;\n', '    emit SetIsPreventedAddr(thisAddr, hbool);\n', '  }\n', '\n', '  constructor(address addressMapperAddr, uint256 cap, string name, string symbol, uint8 decimals)\n', '    ERC20Mintable(addressMapperAddr)\n', '    public\n', '  {\n', '    require(cap > 0);\n', '    _cap = cap;\n', '    _name = name;\n', '    _symbol = symbol;\n', '    _decimals = decimals;\n', '\n', '  }\n', '\n', '  /**\n', '   * @return the cap for the token minting.\n', '   */\n', '  function cap() public view returns(uint256) {\n', '    return _cap;\n', '  }\n', '\n', '  function _mint(address account, uint256 value) internal {\n', '    require(totalSupply().add(value) <= _cap);\n', '    super._mint(account, value);\n', '  }\n', '\n', '  /**\n', '   * @return the name of the token.\n', '   */\n', '  function name() public view returns(string) {\n', '    return _name;\n', '  }\n', '\n', '  /**\n', '   * @return the symbol of the token.\n', '   */\n', '  function symbol() public view returns(string) {\n', '    return _symbol;\n', '  }\n', '\n', '  /**\n', '   * @return the number of decimals of the token.\n', '   */\n', '  function decimals() public view returns(uint8) {\n', '    return _decimals;\n', '  }\n', '  \n', '}']