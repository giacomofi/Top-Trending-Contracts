['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-13\n', '*/\n', '\n', 'pragma solidity ^0.5.7;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '\n', '    int256 constant private INT256_MIN = - 2 ** 255;\n', '\n', '    /**\n', '    * @dev Multiplies two unsigned integers, reverts on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Multiplies two signed integers, reverts on overflow.\n', '    */\n', '    function mul(int256 a, int256 b) internal pure returns (int256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        require(!(a == - 1 && b == INT256_MIN));\n', '        // This is the only case of overflow not detected by the check below\n', '\n', '        int256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.\n', '    */\n', '    function div(int256 a, int256 b) internal pure returns (int256) {\n', '        require(b != 0);\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(!(b == - 1 && a == INT256_MIN));\n', '        // This is the only case of overflow\n', '\n', '        int256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two signed integers, reverts on overflow.\n', '    */\n', '    function sub(int256 a, int256 b) internal pure returns (int256) {\n', '        int256 c = a - b;\n', '        require((b >= 0 && c <= a) || (b < 0 && c > a));\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two unsigned integers, reverts on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two signed integers, reverts on overflow.\n', '    */\n', '    function add(int256 a, int256 b) internal pure returns (int256) {\n', '        int256 c = a + b;\n', '        require((b >= 0 && c >= a) || (b < 0 && c < a));\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '    * reverts when dividing by zero.\n', '    */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address who) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    function locked(address owner) external view returns (uint256);\n', '\n', '    function lockedTill(address owner) external view returns (uint256);\n', '\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    event Lock(address indexed from, uint256 value, uint time);\n', '}\n', '\n', 'contract ERC20Pistachio is IERC20 {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) private _balances;\n', '\n', '    mapping(address => mapping(address => uint256)) private _allowed;\n', '\n', '    mapping(address => uint256) private _locked;\n', '    mapping(address => uint256) private _lockedTill;\n', '\n', '    uint256 private _totalSupply;\n', '\n', '    address private _admin;\n', '\n', '    modifier onlyAdmin() {\n', '        require(msg.sender == _admin);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Public parameters to define the token\n', '    */\n', '\n', '    // Token symbol (short)\n', '    string public symbol;\n', '\n', '    // Token name (Long)\n', '    string public  name;\n', '\n', '    // Decimals (18 maximum)\n', '    uint8 public decimals;\n', '\n', '    /**\n', '    * @dev Public functions to make the contract accesible\n', '    */\n', '    constructor (address initialAccount, string memory _tokenSymbol, string memory _tokenName, uint256 initialBalance) public {\n', '\n', '        // Initialize Contract Parameters\n', '        symbol = _tokenSymbol;\n', '        name = _tokenName;\n', '        decimals = 18;\n', '        // default decimals is going to be 18 always\n', '\n', '        _mint(initialAccount, initialBalance);\n', '\n', '        _admin = initialAccount;\n', '\n', '    }\n', '\n', '    /**\n', '    * @dev Total number of tokens in existence\n', '    */\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param owner The address to query the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address owner) public view returns (uint256) {\n', '        return _balances[owner];\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param owner address The address which owns the funds.\n', '     * @param spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address owner, address spender) public view returns (uint256) {\n', '        return _allowed[owner][spender];\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner has locked.\n', '     * @param owner address The address which owns the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function locked(address owner) public view returns (uint256) {\n', '        return _locked[owner];\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the time until tokens of the owner has beem locked.\n', '     * @param owner address The address which owns the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function lockedTill(address owner) public view returns (uint256) {\n', '        return _lockedTill[owner];\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer token for a specified address\n', '    * @param to The address to transfer to.\n', '    * @param value The amount to be transferred.\n', '    */\n', '    function transfer(address to, uint256 value) public returns (bool) {\n', '        _transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param spender The address which will spend the funds.\n', '     * @param value The amount of tokens to be spent.\n', '     */\n', '    function approve(address spender, uint256 value) public returns (bool) {\n', '        require(spender != address(0));\n', '\n', '        _allowed[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another.\n', '     * Note that while this function emits an Approval event, this is not required as per the specification,\n', '     * and other compliant implementations may not emit the event.\n', '     * @param from address The address which you want to send tokens from\n', '     * @param to address The address which you want to transfer to\n', '     * @param value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '        _transfer(from, to, value);\n', '        emit Approval(from, msg.sender, _allowed[from][msg.sender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when allowed_[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * Emits an Approval event.\n', '     * @param spender The address which will spend the funds.\n', '     * @param addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '        require(spender != address(0));\n', '\n', '        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);\n', '        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when allowed_[_spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * Emits an Approval event.\n', '     * @param spender The address which will spend the funds.\n', '     * @param subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '        require(spender != address(0));\n', '\n', '        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);\n', '        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer token for a specified addresses\n', '    * @param from The address to transfer from.\n', '    * @param to The address to transfer to.\n', '    * @param value The amount to be transferred.\n', '    */\n', '    function _transfer(address from, address to, uint256 value) internal {\n', '        require(to != address(0));\n', '        require(_lockedTill[from] < now || _balances[from] - _locked[from] > value);\n', '\n', '        _balances[from] = _balances[from].sub(value);\n', '        _balances[to] = _balances[to].add(value);\n', '        emit Transfer(from, to, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function that mints an amount of the token and assigns it to\n', '     * an account. This encapsulates the modification of balances such that the\n', '     * proper events are emitted.\n', '     * @param account The account that will receive the created tokens.\n', '     * @param value The amount that will be created.\n', '     */\n', '    function _mint(address account, uint256 value) internal {\n', '        require(account != address(0));\n', '\n', '        _totalSupply = _totalSupply.add(value);\n', '        _balances[account] = _balances[account].add(value);\n', '        emit Transfer(address(0), account, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function that burns an amount of the token of a given\n', '     * account.\n', '     * @param account The account whose tokens will be burnt.\n', '     * @param value The amount that will be burnt.\n', '     */\n', '    function _burn(address account, uint256 value) internal {\n', '        require(account != address(0));\n', '\n', '        _totalSupply = _totalSupply.sub(value);\n', '        _balances[account] = _balances[account].sub(value);\n', '        emit Transfer(account, address(0), value);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function that locks an amount of the token of a given\n', '     * account.\n', '     * @param account The account whose tokens will be locked.\n', '     * @param value The amount that will be locked.\n', '     */\n', '    function _lock(address account, uint256 value, uint256 time) internal {\n', '        require(account != address(0));\n', '        require(time > 0);\n', '        require(value > 0);\n', '\n', '        _locked[account] = _locked[account].add(value);\n', '        _lockedTill[account] = now.add(time);\n', '        emit Lock(account, value, time);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract ERC20Burnable is ERC20Pistachio {\n', '\n', '    bool private _burnableActive;\n', '\n', '    /**\n', '     * @dev Burns a specific amount of tokens from the target address and decrements allowance\n', '     * @param from address The address which you want to send tokens from\n', '     * @param value uint256 The amount of token to be burned\n', '     */\n', '    function burn(address from, uint256 value) public onlyAdmin whenBurnableActive {\n', '        _burn(from, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Options to activate or deactivate Burn ability\n', '     */\n', '\n', '    function _setBurnableActive(bool _active) internal {\n', '        _burnableActive = _active;\n', '    }\n', '\n', '    modifier whenBurnableActive() {\n', '        require(_burnableActive);\n', '        _;\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title ERC20Mintable\n', ' * @dev ERC20 minting logic\n', ' */\n', 'contract ERC20Mintable is ERC20Pistachio {\n', '\n', '    bool private _mintableActive;\n', '    /**\n', '     * @dev Function to mint tokens\n', '     * @param to The address that will receive the minted tokens.\n', '     * @param value The amount of tokens to mint.\n', '     * @return A boolean that indicates if the operation was successful.\n', '     */\n', '    function mint(address to, uint256 value) public onlyAdmin whenMintableActive returns (bool) {\n', '        _mint(to, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Options to activate or deactivate Burn ability\n', '     */\n', '\n', '    function _setMintableActive(bool _active) internal {\n', '        _mintableActive = _active;\n', '    }\n', '\n', '    modifier whenMintableActive() {\n', '        require(_mintableActive);\n', '        _;\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract ERC20Pausable is ERC20Pistachio {\n', '    event Paused(address account);\n', '    event Unpaused(address account);\n', '\n', '    bool private _pausableActive;\n', '    bool private _paused;\n', '\n', '    constructor () internal {\n', '        _paused = false;\n', '    }\n', '\n', '    /**\n', '     * @return true if the contract is paused, false otherwise.\n', '     */\n', '    function paused() public view returns (bool) {\n', '        return _paused;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!_paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(_paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to pause, triggers stopped state\n', '     */\n', '    function pause() public onlyAdmin whenNotPaused whenPausableActive {\n', '        _paused = true;\n', '        emit Paused(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to unpause, returns to normal state\n', '     */\n', '    function unpause() public onlyAdmin whenPaused whenPausableActive {\n', '        _paused = false;\n', '        emit Unpaused(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @dev Options to activate or deactivate Pausable ability\n', '     */\n', '\n', '    function _setPausableActive(bool _active) internal {\n', '        _pausableActive = _active;\n', '    }\n', '\n', '    modifier whenPausableActive() {\n', '        require(_pausableActive);\n', '        _;\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title ERC20Lockable\n', ' * @dev ERC20 locking logic\n', ' */\n', 'contract ERC20Lockable is ERC20Pistachio {\n', '\n', '    bool private _lockableActive;\n', '    /**\n', '     * @dev Function to lock tokens\n', '     * @param from The address that will receive the locked tokens.\n', '     * @param value The amount of tokens to lock.\n', '     * @return A boolean that indicates if the operation was successful.\n', '     */\n', '    function lock(address from, uint256 value, uint256 time) public onlyAdmin whenLockableActive returns (bool) {\n', '        _lock(from, value, time);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Options to activate or deactivate Burn ability\n', '     */\n', '\n', '    function _setLockableActive(bool _active) internal {\n', '        _lockableActive = _active;\n', '    }\n', '\n', '    modifier whenLockableActive() {\n', '        require(_lockableActive);\n', '        _;\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title Advanced ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token plus mint and burn public functions.\n', ' *\n', ' * Version 2. This version delegates the minter and pauser renounce to parent-factory contract\n', ' * that allows ICOs to be minter for token selling\n', ' *\n', ' */\n', 'contract ETM is ERC20Pistachio, ERC20Burnable, ERC20Lockable, ERC20Mintable, ERC20Pausable {\n', '    constructor (\n', '        address initialAccount\n', '    ) public\n', '    ERC20Pistachio(initialAccount, "ETM", "EtherM Token", 5000000000000000000000000000) {\n', '        _setBurnableActive(true);\n', '        _setLockableActive(true);\n', '        _setMintableActive(true);\n', '        _setPausableActive(true);\n', '\n', '    }\n', '\n', '    /**\n', '     * Pausable options\n', '     */\n', '    function transfer(address to, uint256 value) public whenNotPaused returns (bool) {\n', '        return super.transfer(to, value);\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {\n', '        return super.transferFrom(from, to, value);\n', '    }\n', '\n', '    function approve(address spender, uint256 value) public whenNotPaused returns (bool) {\n', '        return super.approve(spender, value);\n', '    }\n', '\n', '    function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {\n', '        return super.increaseAllowance(spender, addedValue);\n', '    }\n', '\n', '    function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {\n', '        return super.decreaseAllowance(spender, subtractedValue);\n', '    }\n', '}']