['pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://eips.ethereum.org/EIPS/eip-20\n', ' */\n', 'interface IERC20 {\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address who) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '    /**\n', '     * @dev Multiplies two unsigned integers, reverts on overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Adds two unsigned integers, reverts on overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '     * reverts when dividing by zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20Detailed token\n', ' * @dev The decimals are only for visualization purposes.\n', ' * All the operations are done using the smallest and indivisible token unit,\n', ' * just as on Ethereum all the operations are done in wei.\n', ' */\n', 'contract ERC20Detailed is IERC20 {\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '\n', '    constructor (string memory name, string memory symbol, uint8 decimals) public {\n', '        _name = name;\n', '        _symbol = symbol;\n', '        _decimals = decimals;\n', '    }\n', '\n', '    /**\n', '     * @return the name of the token.\n', '     */\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    /**\n', '     * @return the symbol of the token.\n', '     */\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    /**\n', '     * @return the number of decimals of the token.\n', '     */\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '}\n', '\n', 'contract ERC20 is IERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) private _balances;\n', '\n', '    mapping (address => mapping (address => uint256)) private _allowed;\n', '\n', '    uint256 private _totalSupply;\n', '\n', '    /**\n', '     * @dev Total number of tokens in existence.\n', '     */\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the balance of the specified address.\n', '     * @param owner The address to query the balance of.\n', '     * @return A uint256 representing the amount owned by the passed address.\n', '     */\n', '    function balanceOf(address owner) public view returns (uint256) {\n', '        return _balances[owner];\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param owner address The address which owns the funds.\n', '     * @param spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address owner, address spender) public view returns (uint256) {\n', '        return _allowed[owner][spender];\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer token to a specified address.\n', '     * @param to The address to transfer to.\n', '     * @param value The amount to be transferred.\n', '     */\n', '    function transfer(address to, uint256 value) public returns (bool) {\n', '        _transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param spender The address which will spend the funds.\n', '     * @param value The amount of tokens to be spent.\n', '     */\n', '    function approve(address spender, uint256 value) public returns (bool) {\n', '        _approve(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another.\n', '     * Note that while this function emits an Approval event, this is not required as per the specification,\n', '     * and other compliant implementations may not emit the event.\n', '     * @param from address The address which you want to send tokens from\n', '     * @param to address The address which you want to transfer to\n', '     * @param value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '        _transfer(from, to, value);\n', '        _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when _allowed[msg.sender][spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * Emits an Approval event.\n', '     * @param spender The address which will spend the funds.\n', '     * @param addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '        _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when _allowed[msg.sender][spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * Emits an Approval event.\n', '     * @param spender The address which will spend the funds.\n', '     * @param subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '        _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer token for a specified addresses.\n', '     * @param from The address to transfer from.\n', '     * @param to The address to transfer to.\n', '     * @param value The amount to be transferred.\n', '     */\n', '    function _transfer(address from, address to, uint256 value) internal {\n', '        require(to != address(0));\n', '\n', '        _balances[from] = _balances[from].sub(value);\n', '        _balances[to] = _balances[to].add(value);\n', '        emit Transfer(from, to, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function that mints an amount of the token and assigns it to\n', '     * an account. This encapsulates the modification of balances such that the\n', '     * proper events are emitted.\n', '     * @param account The account that will receive the created tokens.\n', '     * @param value The amount that will be created.\n', '     */\n', '    function _mint(address account, uint256 value) internal {\n', '        require(account != address(0));\n', '\n', '        _totalSupply = _totalSupply.add(value);\n', '        _balances[account] = _balances[account].add(value);\n', '        emit Transfer(address(0), account, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function that burns an amount of the token of a given\n', '     * account.\n', '     * @param account The account whose tokens will be burnt.\n', '     * @param value The amount that will be burnt.\n', '     */\n', '    function _burn(address account, uint256 value) internal {\n', '        require(account != address(0));\n', '\n', '        _totalSupply = _totalSupply.sub(value);\n', '        _balances[account] = _balances[account].sub(value);\n', '        emit Transfer(account, address(0), value);\n', '    }\n', '\n', '    /**\n', "     * @dev Approve an address to spend another addresses' tokens.\n", '     * @param owner The address that owns the tokens.\n', '     * @param spender The address that will spend the tokens.\n', '     * @param value The number of tokens that can be spent.\n', '     */\n', '    function _approve(address owner, address spender, uint256 value) internal {\n', '        require(spender != address(0));\n', '        require(owner != address(0));\n', '\n', '        _allowed[owner][spender] = value;\n', '        emit Approval(owner, spender, value);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor () internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @return the address of the owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner());\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @return true if `msg.sender` is the owner of the contract.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to relinquish control of the contract.\n', '     * It will not be possible to call the functions with the `onlyOwner`\n', '     * modifier anymore.\n', '     * @notice Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Roles\n', ' * @dev Library for managing addresses assigned to a Role.\n', ' */\n', 'library Roles {\n', '    struct Role {\n', '        mapping (address => bool) bearer;\n', '    }\n', '\n', '    /**\n', '     * @dev Give an account access to this role.\n', '     */\n', '    function add(Role storage role, address account) internal {\n', '        require(account != address(0));\n', '        require(!has(role, account));\n', '\n', '        role.bearer[account] = true;\n', '    }\n', '\n', '    /**\n', "     * @dev Remove an account's access to this role.\n", '     */\n', '    function remove(Role storage role, address account) internal {\n', '        require(account != address(0));\n', '        require(has(role, account));\n', '\n', '        role.bearer[account] = false;\n', '    }\n', '\n', '    /**\n', '     * @dev Check if an account has this role.\n', '     * @return bool\n', '     */\n', '    function has(Role storage role, address account) internal view returns (bool) {\n', '        require(account != address(0));\n', '        return role.bearer[account];\n', '    }\n', '}\n', 'contract PauserRole {\n', '    using Roles for Roles.Role;\n', '\n', '    event PauserAdded(address indexed account);\n', '    event PauserRemoved(address indexed account);\n', '\n', '    Roles.Role private _pausers;\n', '\n', '    constructor () internal {\n', '        _addPauser(msg.sender);\n', '    }\n', '\n', '    modifier onlyPauser() {\n', '        require(isPauser(msg.sender));\n', '        _;\n', '    }\n', '\n', '    function isPauser(address account) public view returns (bool) {\n', '        return _pausers.has(account);\n', '    }\n', '\n', '    function addPauser(address account) public onlyPauser {\n', '        _addPauser(account);\n', '    }\n', '\n', '    function renouncePauser() public {\n', '        _removePauser(msg.sender);\n', '    }\n', '\n', '    function _addPauser(address account) internal {\n', '        _pausers.add(account);\n', '        emit PauserAdded(account);\n', '    }\n', '\n', '    function _removePauser(address account) internal {\n', '        _pausers.remove(account);\n', '        emit PauserRemoved(account);\n', '    }\n', '}\n', '\n', 'contract BurnRole{\n', '    using Roles for Roles.Role;\n', '\n', '    event BurnerAdded(address indexed account);\n', '    event BurnerRemoved(address indexed account);\n', '\n', '    Roles.Role private _burners;\n', '\n', '    constructor () internal {\n', '        _addBurner(msg.sender);\n', '    }\n', '\n', '    modifier onlyBurner() {\n', '        require(isBurner(msg.sender));\n', '        _;\n', '    }\n', '\n', '    function isBurner(address account) public view returns (bool) {\n', '        return _burners.has(account);\n', '    }\n', '\n', '    function addBurner(address account) public onlyBurner {\n', '        _addBurner(account);\n', '    }\n', '\n', '    function renounceBurner() public {\n', '        _removeBurner(msg.sender);\n', '    }\n', '\n', '    function _addBurner(address account) internal {\n', '        _burners.add(account);\n', '        emit BurnerAdded(account);\n', '    }\n', '\n', '    function _removeBurner(address account) internal {\n', '        _burners.remove(account);\n', '        emit BurnerRemoved(account);\n', '    }\n', '}\n', '\n', 'contract MinterRole {\n', '    using Roles for Roles.Role;\n', '\n', '    event MinterAdded(address indexed account);\n', '    event MinterRemoved(address indexed account);\n', '\n', '    Roles.Role private _minters;\n', '\n', '    constructor () internal {\n', '        _addMinter(msg.sender);\n', '    }\n', '\n', '    modifier onlyMinter() {\n', '        require(isMinter(msg.sender));\n', '        _;\n', '    }\n', '\n', '    function isMinter(address account) public view returns (bool) {\n', '        return _minters.has(account);\n', '    }\n', '\n', '    function addMinter(address account) public onlyMinter {\n', '        _addMinter(account);\n', '    }\n', '\n', '    function renounceMinter() public {\n', '        _removeMinter(msg.sender);\n', '    }\n', '\n', '    function _addMinter(address account) internal {\n', '        _minters.add(account);\n', '        emit MinterAdded(account);\n', '    }\n', '\n', '    function _removeMinter(address account) internal {\n', '        _minters.remove(account);\n', '        emit MinterRemoved(account);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is PauserRole {\n', '    event Paused(address account);\n', '    event Unpaused(address account);\n', '\n', '    bool private _paused;\n', '\n', '    constructor () internal {\n', '        _paused = false;\n', '    }\n', '\n', '    /**\n', '     * @return True if the contract is paused, false otherwise.\n', '     */\n', '    function paused() public view returns (bool) {\n', '        return _paused;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!_paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(_paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Called by a pauser to pause, triggers stopped state.\n', '     */\n', '    function pause() public onlyPauser whenNotPaused {\n', '        _paused = true;\n', '        emit Paused(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @dev Called by a pauser to unpause, returns to normal state.\n', '     */\n', '    function unpause() public onlyPauser whenPaused {\n', '        _paused = false;\n', '        emit Unpaused(msg.sender);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Pausable token\n', ' * @dev ERC20 modified with pausable transfers.\n', ' */\n', 'contract ERC20Pausable is ERC20, Pausable {\n', '    function transfer(address to, uint256 value) public whenNotPaused returns (bool) {\n', '        return super.transfer(to, value);\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {\n', '        return super.transferFrom(from, to, value);\n', '    }\n', '\n', '    function approve(address spender, uint256 value) public whenNotPaused returns (bool) {\n', '        return super.approve(spender, value);\n', '    }\n', '\n', '    function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {\n', '        return super.increaseAllowance(spender, addedValue);\n', '    }\n', '\n', '    function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {\n', '        return super.decreaseAllowance(spender, subtractedValue);\n', '    }\n', '}\n', '\n', 'contract ERC20Mintable is ERC20, MinterRole, Pausable {\n', '    /**\n', '     * @dev Function to mint tokens\n', '     * @param to The address that will receive the minted tokens.\n', '     * @param value The amount of tokens to mint.\n', '     * @return A boolean that indicates if the operation was successful.\n', '     */\n', '    function mint(address to, uint256 value) public onlyMinter whenNotPaused returns (bool) {\n', '        _mint(to, value);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract ERC20Capped is ERC20Mintable {\n', '    uint256 private _cap;\n', '\n', '    constructor (uint256 cap) public {\n', '        require(cap > 0);\n', '        _cap = cap;\n', '    }\n', '\n', '    /**\n', '     * @return the cap for the token minting.\n', '     */\n', '    function cap() public view returns (uint256) {\n', '        return _cap;\n', '    }\n', '\n', '    function _mint(address account, uint256 value) internal {\n', '        require(totalSupply().add(value) <= _cap);\n', '        super._mint(account, value);\n', '    }\n', '}\n', '\n', 'contract ERC20Burnable is ERC20, BurnRole, Pausable {\n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param value The amount of token to be burned.\n', '     */\n', '    function burn(uint256 value) public onlyBurner whenNotPaused returns (bool){\n', '        _burn(msg.sender, value);\n', '        return true;\n', '    }\n', '}\n', '\n', '/**\n', ' * Utility library of inline functions on addresses\n', ' */\n', 'library Address {\n', '    /**\n', '     * Returns whether the target address is a contract\n', '     * @dev This function will return false if invoked during the constructor of a contract,\n', '     * as the code is not actually created until after the constructor finishes.\n', '     * @param account address of the account to check\n', '     * @return whether the target address is a contract\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        uint256 size;\n', '        // XXX Currently there is no better way to check if there is a contract in an address\n', '        // than to check the size of the code at that address.\n', '        // See https://ethereum.stackexchange.com/a/14016/36603\n', '        // for more details about how this works.\n', '        // TODO Check this again before the Serenity release, because all addresses will be\n', '        // contracts then.\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '}\n', '\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        require((value == 0) || (token.allowance(address(this), spender) == 0));\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value);\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves.\n", '\n', '        // A Solidity high level call has three parts:\n', '        //  1. The target address is checked to verify it contains contract code\n', '        //  2. The call itself is made, and success asserted\n', '        //  3. The return value is decoded, which in turn checks the size of the returned data.\n', '\n', '        require(address(token).isContract());\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success);\n', '\n', '        if (returndata.length > 0) { // Return data is optional\n', '            require(abi.decode(returndata, (bool)));\n', '        }\n', '    }\n', '}\n', '\n', '/**\n', ' * @title TokenVesting\n', ' * @dev A token holder contract that can release its token balance gradually like a\n', ' * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the\n', ' * owner.\n', ' */\n', 'contract TokenVesting is Ownable {\n', '    // The vesting schedule is time-based (i.e. using block timestamps as opposed to e.g. block numbers), and is\n', '    // therefore sensitive to timestamp manipulation (which is something miners can do, to a certain degree). Therefore,\n', '    // it is recommended to avoid using short time durations (less than a minute). Typical vesting schemes, with a\n', '    // cliff period of a year and a duration of four years, are safe to use.\n', '    // solhint-disable not-rely-on-time\n', '\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for IERC20;\n', '\n', '    event TokensReleased(address token, uint256 amount);\n', '    event TokenVestingRevoked(address token);\n', '\n', '    // beneficiary of tokens after they are released\n', '    address private _beneficiary;\n', '\n', '    // Durations and timestamps are expressed in UNIX time, the same units as block.timestamp.\n', '    uint256 private _phase;\n', '    uint256 private _start;\n', '    uint256 private _duration;\n', '\n', '    bool private _revocable;\n', '\n', '    mapping (address => uint256) private _released;\n', '    mapping (address => bool) private _revoked;\n', '\n', '    /**\n', '     * @dev Creates a vesting contract that vests its balance of any ERC20 token to the\n', '     * beneficiary, gradually in a linear fashion until start + duration. By then all\n', '     * of the balance will have vested.\n', '     * @param beneficiary address of the beneficiary to whom vested tokens are transferred\n', '     * @param phase duration in seconds of the cliff in which tokens will begin to vest\n', '     * @param start the time (as Unix time) at which point vesting starts\n', '     * @param duration duration in seconds of the period in which the tokens will vest\n', '     * @param revocable whether the vesting is revocable or not\n', '     */\n', '    constructor (address beneficiary, uint256 start, uint256 phase, uint256 duration, bool revocable) public {\n', '        require(beneficiary != address(0));\n', '        require(phase >= 1);\n', '        require(duration > 0);\n', '        require(start.add(duration) > block.timestamp);\n', '\n', '        _beneficiary = beneficiary;\n', '        _revocable = revocable;\n', '        _duration = duration;\n', '        _phase = phase;\n', '        _start = start;\n', '    }\n', '\n', '    /**\n', '     * @return the beneficiary of the tokens.\n', '     */\n', '    function beneficiary() public view returns (address) {\n', '        return _beneficiary;\n', '    }\n', '\n', '    /**\n', '     * @return the cliff time of the token vesting.\n', '     */\n', '    function phase() public view returns (uint256) {\n', '        return _phase;\n', '    }\n', '\n', '    /**\n', '     * @return the start time of the token vesting.\n', '     */\n', '    function start() public view returns (uint256) {\n', '        return _start;\n', '    }\n', '\n', '    /**\n', '     * @return the duration of the token vesting.\n', '     */\n', '    function duration() public view returns (uint256) {\n', '        return _duration;\n', '    }\n', '\n', '    /**\n', '     * @return true if the vesting is revocable.\n', '     */\n', '    function revocable() public view returns (bool) {\n', '        return _revocable;\n', '    }\n', '\n', '    /**\n', '     * @return the amount of the token released.\n', '     */\n', '    function released(address token) public view returns (uint256) {\n', '        return _released[token];\n', '    }\n', '\n', '    /**\n', '     * @return true if the token is revoked.\n', '     */\n', '    function revoked(address token) public view returns (bool) {\n', '        return _revoked[token];\n', '    }\n', '\n', '    /**\n', '     * @notice Transfers vested tokens to beneficiary.\n', '     * @param token ERC20 token which is being vested\n', '     */\n', '    function release(IERC20 token) public {\n', '        uint256 unreleased = _releasableAmount(token);\n', '\n', '        require(unreleased > 0);\n', '\n', '        _released[address(token)] = _released[address(token)].add(unreleased);\n', '\n', '        token.safeTransfer(_beneficiary, unreleased);\n', '\n', '        emit TokensReleased(address(token), unreleased);\n', '    }\n', '\n', '    /**\n', '     * @notice Allows the owner to revoke the vesting. Tokens already vested\n', '     * remain in the contract, the rest are returned to the owner.\n', '     * @param token ERC20 token which is being vested\n', '     */\n', '    function revoke(IERC20 token) public onlyOwner {\n', '        require(_revocable);\n', '        require(!_revoked[address(token)]);\n', '\n', '        uint256 balance = token.balanceOf(address(this));\n', '\n', '        uint256 unreleased = _releasableAmount(token);\n', '        uint256 refund = balance.sub(unreleased);\n', '\n', '        _revoked[address(token)] = true;\n', '\n', '        token.safeTransfer(owner(), refund);\n', '\n', '        emit TokenVestingRevoked(address(token));\n', '    }\n', '\n', '    /**\n', "     * @dev Calculates the amount that has already vested but hasn't been released yet.\n", '     * @param token ERC20 token which is being vested\n', '     */\n', '    function _releasableAmount(IERC20 token) private view returns (uint256) {\n', '        return _vestedAmount(token).sub(_released[address(token)]);\n', '    }\n', '\n', '    /**\n', '     * @dev Calculates the amount that has already vested.\n', '     * @param token ERC20 token which is being vested\n', '     */\n', '    function _vestedAmount(IERC20 token) private view returns (uint256) {\n', '        uint256 currentBalance = token.balanceOf(address(this));\n', '        uint256 totalBalance = currentBalance.add(_released[address(token)]);\n', '\n', '        if (block.timestamp < _start) {\n', '            return 0;\n', '        } else if (block.timestamp >= _start.add(_duration) || _revoked[address(token)]) {\n', '            return totalBalance;\n', '        } else {\n', '            uint256 everyPhaseDuration = _duration.div(_phase);\n', '            uint256 currentPhase = (block.timestamp - _start).div(everyPhaseDuration);\n', '            return totalBalance.div(_phase).mul(currentPhase);\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'contract MixMarvelToken is ERC20, ERC20Detailed, ERC20Pausable, ERC20Capped, ERC20Burnable {\n', '    using Address for address;\n', '\n', '    event TransferExtend(address indexed from, address indexed to, uint256 value, string name);\n', '    \n', '    constructor(string memory name, string memory symbol, uint8 decimals, uint256 cap) ERC20Pausable() ERC20Burnable() ERC20Capped(cap) ERC20Detailed(name, symbol, decimals) ERC20() public {}\n', '\n', '    function mintVesting(address _to, uint256 _amount, uint256 start, uint256 phase, uint256 duration, bool revocable) public onlyMinter whenNotPaused returns (TokenVesting) {\n', '        TokenVesting vesting = new TokenVesting(_to, start, phase, duration, revocable);\n', '        mint(address(vesting), _amount);\n', '        return vesting;\n', '    }\n', '\n', '    function revokeVesting(TokenVesting vesting) public onlyMinter whenNotPaused returns(bool) {\n', '        require(address(vesting).isContract());\n', '        vesting.revoke(this);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer token of this contract to a specified address.\n', '     * @param to The address to transfer to.\n', '     * @param value The amount to be transferred.\n', '     */\n', '    function transferTo(address to, uint256 value) public onlyMinter whenNotPaused returns (bool) {\n', '      _transfer(address(this), to, value);\n', '      return true;\n', '    }\n', '  \n', '    /**\n', '     * @dev Transfer token to a specified address.\n', '     * @param to The address to transfer to.\n', '     * @param value The amount to be transferred.\n', '     * @param name Custom string\n', '     */\n', '    function transfer(address to, uint256 value, string memory name) public whenNotPaused returns (bool) {\n', '        _transfer(msg.sender, to, value);\n', '        emit TransferExtend(msg.sender, to, value, name);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Batch transfer token.\n', '     * @param tos The address list to transfer to.\n', '     * @param value The amount to be transferred.\n', '     */\n', '    function transfer(address[] memory tos, uint256 value) public whenNotPaused returns (bool) {\n', '        require(tos.length > 0);\n', '        require(tos.length <= 50);\n', '\n', '        for(uint i = 0; i < tos.length; i ++){\n', '            _transfer(msg.sender, tos[i], value);\n', '        }\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Batch transfer token.\n', '     * @param tos The address list to transfer to.\n', '     * @param values The amount list to be transferred.\n', '     */\n', '    function transfer(address[] memory tos, uint256[] memory values) public whenNotPaused returns (bool) {\n', '        require(tos.length > 0);\n', '        require(tos.length <= 50);\n', '        require(values.length == tos.length);\n', '\n', '        for(uint i = 0; i < tos.length; i ++){\n', '            _transfer(msg.sender, tos[i], values[i]);\n', '        }\n', '        return true;\n', '    }\n', '}']