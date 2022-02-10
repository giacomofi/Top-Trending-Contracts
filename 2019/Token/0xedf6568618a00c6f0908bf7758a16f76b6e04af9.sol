['// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol\n', '\n', 'pragma solidity ^0.5.2;\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://eips.ethereum.org/EIPS/eip-20\n', ' */\n', 'interface IERC20 {\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address who) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol\n', '\n', 'pragma solidity ^0.5.2;\n', '\n', '\n', '/**\n', ' * @title ERC20Detailed token\n', ' * @dev The decimals are only for visualization purposes.\n', ' * All the operations are done using the smallest and indivisible token unit,\n', ' * just as on Ethereum all the operations are done in wei.\n', ' */\n', 'contract ERC20Detailed is IERC20 {\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '\n', '    constructor (string memory name, string memory symbol, uint8 decimals) public {\n', '        _name = name;\n', '        _symbol = symbol;\n', '        _decimals = decimals;\n', '    }\n', '\n', '    /**\n', '     * @return the name of the token.\n', '     */\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    /**\n', '     * @return the symbol of the token.\n', '     */\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    /**\n', '     * @return the number of decimals of the token.\n', '     */\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', 'pragma solidity ^0.5.2;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Unsigned math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Multiplies two unsigned integers, reverts on overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Adds two unsigned integers, reverts on overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '     * reverts when dividing by zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol\n', '\n', 'pragma solidity ^0.5.2;\n', '\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * https://eips.ethereum.org/EIPS/eip-20\n', ' * Originally based on code by FirstBlood:\n', ' * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' *\n', ' * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for\n', " * all accounts just by listening to said events. Note that this isn't required by the specification, and other\n", ' * compliant implementations may not do it.\n', ' */\n', 'contract ERC20 is IERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) private _balances;\n', '\n', '    mapping (address => mapping (address => uint256)) private _allowed;\n', '\n', '    uint256 private _totalSupply;\n', '\n', '    /**\n', '     * @dev Total number of tokens in existence\n', '     */\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the balance of the specified address.\n', '     * @param owner The address to query the balance of.\n', '     * @return A uint256 representing the amount owned by the passed address.\n', '     */\n', '    function balanceOf(address owner) public view returns (uint256) {\n', '        return _balances[owner];\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param owner address The address which owns the funds.\n', '     * @param spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address owner, address spender) public view returns (uint256) {\n', '        return _allowed[owner][spender];\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer token to a specified address\n', '     * @param to The address to transfer to.\n', '     * @param value The amount to be transferred.\n', '     */\n', '    function transfer(address to, uint256 value) public returns (bool) {\n', '        _transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param spender The address which will spend the funds.\n', '     * @param value The amount of tokens to be spent.\n', '     */\n', '    function approve(address spender, uint256 value) public returns (bool) {\n', '        _approve(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another.\n', '     * Note that while this function emits an Approval event, this is not required as per the specification,\n', '     * and other compliant implementations may not emit the event.\n', '     * @param from address The address which you want to send tokens from\n', '     * @param to address The address which you want to transfer to\n', '     * @param value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '        _transfer(from, to, value);\n', '        _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when _allowed[msg.sender][spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * Emits an Approval event.\n', '     * @param spender The address which will spend the funds.\n', '     * @param addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '        _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when _allowed[msg.sender][spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * Emits an Approval event.\n', '     * @param spender The address which will spend the funds.\n', '     * @param subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '        _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer token for a specified addresses\n', '     * @param from The address to transfer from.\n', '     * @param to The address to transfer to.\n', '     * @param value The amount to be transferred.\n', '     */\n', '    function _transfer(address from, address to, uint256 value) internal {\n', '        require(to != address(0));\n', '\n', '        _balances[from] = _balances[from].sub(value);\n', '        _balances[to] = _balances[to].add(value);\n', '        emit Transfer(from, to, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function that mints an amount of the token and assigns it to\n', '     * an account. This encapsulates the modification of balances such that the\n', '     * proper events are emitted.\n', '     * @param account The account that will receive the created tokens.\n', '     * @param value The amount that will be created.\n', '     */\n', '    function _mint(address account, uint256 value) internal {\n', '        require(account != address(0));\n', '\n', '        _totalSupply = _totalSupply.add(value);\n', '        _balances[account] = _balances[account].add(value);\n', '        emit Transfer(address(0), account, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function that burns an amount of the token of a given\n', '     * account.\n', '     * @param account The account whose tokens will be burnt.\n', '     * @param value The amount that will be burnt.\n', '     */\n', '    function _burn(address account, uint256 value) internal {\n', '        require(account != address(0));\n', '\n', '        _totalSupply = _totalSupply.sub(value);\n', '        _balances[account] = _balances[account].sub(value);\n', '        emit Transfer(account, address(0), value);\n', '    }\n', '\n', '    /**\n', "     * @dev Approve an address to spend another addresses' tokens.\n", '     * @param owner The address that owns the tokens.\n', '     * @param spender The address that will spend the tokens.\n', '     * @param value The number of tokens that can be spent.\n', '     */\n', '    function _approve(address owner, address spender, uint256 value) internal {\n', '        require(spender != address(0));\n', '        require(owner != address(0));\n', '\n', '        _allowed[owner][spender] = value;\n', '        emit Approval(owner, spender, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function that burns an amount of the token of a given\n', "     * account, deducting from the sender's allowance for said account. Uses the\n", '     * internal burn function.\n', '     * Emits an Approval event (reflecting the reduced allowance).\n', '     * @param account The account whose tokens will be burnt.\n', '     * @param value The amount that will be burnt.\n', '     */\n', '    function _burnFrom(address account, uint256 value) internal {\n', '        _burn(account, value);\n', '        _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol\n', '\n', 'pragma solidity ^0.5.2;\n', '\n', '\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract ERC20Burnable is ERC20 {\n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param value The amount of token to be burned.\n', '     */\n', '    function burn(uint256 value) public {\n', '        _burn(msg.sender, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Burns a specific amount of tokens from the target address and decrements allowance\n', '     * @param from address The account whose tokens will be burned.\n', '     * @param value uint256 The amount of token to be burned.\n', '     */\n', '    function burnFrom(address from, uint256 value) public {\n', '        _burnFrom(from, value);\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/access/Roles.sol\n', '\n', 'pragma solidity ^0.5.2;\n', '\n', '/**\n', ' * @title Roles\n', ' * @dev Library for managing addresses assigned to a Role.\n', ' */\n', 'library Roles {\n', '    struct Role {\n', '        mapping (address => bool) bearer;\n', '    }\n', '\n', '    /**\n', '     * @dev give an account access to this role\n', '     */\n', '    function add(Role storage role, address account) internal {\n', '        require(account != address(0));\n', '        require(!has(role, account));\n', '\n', '        role.bearer[account] = true;\n', '    }\n', '\n', '    /**\n', "     * @dev remove an account's access to this role\n", '     */\n', '    function remove(Role storage role, address account) internal {\n', '        require(account != address(0));\n', '        require(has(role, account));\n', '\n', '        role.bearer[account] = false;\n', '    }\n', '\n', '    /**\n', '     * @dev check if an account has this role\n', '     * @return bool\n', '     */\n', '    function has(Role storage role, address account) internal view returns (bool) {\n', '        require(account != address(0));\n', '        return role.bearer[account];\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol\n', '\n', 'pragma solidity ^0.5.2;\n', '\n', '\n', 'contract PauserRole {\n', '    using Roles for Roles.Role;\n', '\n', '    event PauserAdded(address indexed account);\n', '    event PauserRemoved(address indexed account);\n', '\n', '    Roles.Role private _pausers;\n', '\n', '    constructor () internal {\n', '        _addPauser(msg.sender);\n', '    }\n', '\n', '    modifier onlyPauser() {\n', '        require(isPauser(msg.sender));\n', '        _;\n', '    }\n', '\n', '    function isPauser(address account) public view returns (bool) {\n', '        return _pausers.has(account);\n', '    }\n', '\n', '    function addPauser(address account) public onlyPauser {\n', '        _addPauser(account);\n', '    }\n', '\n', '    function renouncePauser() public {\n', '        _removePauser(msg.sender);\n', '    }\n', '\n', '    function _addPauser(address account) internal {\n', '        _pausers.add(account);\n', '        emit PauserAdded(account);\n', '    }\n', '\n', '    function _removePauser(address account) internal {\n', '        _pausers.remove(account);\n', '        emit PauserRemoved(account);\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol\n', '\n', 'pragma solidity ^0.5.2;\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is PauserRole {\n', '    event Paused(address account);\n', '    event Unpaused(address account);\n', '\n', '    bool private _paused;\n', '\n', '    constructor () internal {\n', '        _paused = false;\n', '    }\n', '\n', '    /**\n', '     * @return true if the contract is paused, false otherwise.\n', '     */\n', '    function paused() public view returns (bool) {\n', '        return _paused;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!_paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(_paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to pause, triggers stopped state\n', '     */\n', '    function pause() public onlyPauser whenNotPaused {\n', '        _paused = true;\n', '        emit Paused(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to unpause, returns to normal state\n', '     */\n', '    function unpause() public onlyPauser whenPaused {\n', '        _paused = false;\n', '        emit Unpaused(msg.sender);\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol\n', '\n', 'pragma solidity ^0.5.2;\n', '\n', '\n', '\n', '/**\n', ' * @title Pausable token\n', ' * @dev ERC20 modified with pausable transfers.\n', ' */\n', 'contract ERC20Pausable is ERC20, Pausable {\n', '    function transfer(address to, uint256 value) public whenNotPaused returns (bool) {\n', '        return super.transfer(to, value);\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {\n', '        return super.transferFrom(from, to, value);\n', '    }\n', '\n', '    function approve(address spender, uint256 value) public whenNotPaused returns (bool) {\n', '        return super.approve(spender, value);\n', '    }\n', '\n', '    function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {\n', '        return super.increaseAllowance(spender, addedValue);\n', '    }\n', '\n', '    function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {\n', '        return super.decreaseAllowance(spender, subtractedValue);\n', '    }\n', '}\n', '\n', '// File: contracts/Aria20.sol\n', '\n', 'pragma solidity ^0.5.2;\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Aria20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * https://eips.ethereum.org/EIPS/eip-20\n', ' *\n', ' * Using already audited OpenZeppelin functionality of: ERC20, ERC20Detailed, ERC20Pausable and ERC20Burnable tokens\n', ' */\n', 'contract Aria20 is ERC20Detailed, ERC20Pausable, ERC20Burnable {\n', '\n', '    // Note: Being a Burnable token the current supply should always be fetch by "totalSupply()" function\n', '    uint public constant INITIAL_SUPPLY = 200000000 * (10 ** uint (18));\n', '\n', '    /**\n', '     * Constructor to init token detail parameters and mint the initial and final supply\n', '     * @param name The display name of the token (Expected: "ARIANEE").\n', '     * @param symbol The symbol of the token (Expected: "ARIA20").\n', '     * @param decimals The amount token decimals (Expected: 18).\n', '     */\n', '    constructor(\n', '        string memory name,\n', '        string memory symbol,\n', '        uint8 decimals\n', '    )\n', '        ERC20Burnable()\n', '        ERC20Pausable()\n', '        ERC20Detailed(name, symbol, decimals)\n', '        public\n', '    {\n', '        // Mint initial supply to the token creator\n', '        _mint(msg.sender, INITIAL_SUPPLY);\n', '    }\n', '\n', '    /**\n', '     * Mass distribution function to multi-transfer tokens between received addresses and amounts\n', '     * @param _recipients The list of addresses to receive tokens\n', '     * @param _amounts The list amounts of tokens to transfer to each address received\n', '     * @return A boolean that indicates if the all transfers were successful.\n', '     */\n', '    function distributeTokens(address[] memory _recipients, uint256[] memory _amounts) public whenNotPaused returns (bool) {\n', '        // Optimization: Verify than both lists have the save amount of items\n', '        require(_recipients.length == _amounts.length);\n', '\n', '        // Optimization: Verify than sender has some tokens to distribute\n', '        require(balanceOf(msg.sender) > 0);\n', '\n', '        // Iterate over recipients addresses and transfer received amount\n', '        for (uint i = 0; i < _recipients.length; i++) {\n', '            require(transfer(_recipients[i], _amounts[i]));\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '}']