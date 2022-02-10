['pragma solidity ^0.5.17;\n', '\n', 'library SafeMath {\n', '    /**\n', '    * @dev Multiplies two unsigned integers, reverts on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, "SafeMath: division by zero");\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two unsigned integers, reverts on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '    * reverts when dividing by zero.\n', '    */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'library Roles {\n', '    struct Role {\n', '        mapping (address => bool) bearer;\n', '    }\n', '\n', '    /**\n', '     * @dev give an account access to this role\n', '     */\n', '    function add(Role storage role, address account) internal {\n', '        require(account != address(0), "Roles: account is the zero address");\n', '        require(!has(role, account), "Roles: account already has role");\n', '\n', '        role.bearer[account] = true;\n', '    }\n', '\n', '    /**\n', "     * @dev remove an account's access to this role\n", '     */\n', '    function remove(Role storage role, address account) internal {\n', '        require(account != address(0), "Roles: account is the zero address");\n', '        require(has(role, account), "Roles: account does not have role");\n', '\n', '        role.bearer[account] = false;\n', '    }\n', '\n', '    /**\n', '     * @dev check if an account has this role\n', '     * @return bool\n', '     */\n', '    function has(Role storage role, address account) internal view returns (bool) {\n', '        require(account != address(0), "Roles: account is the zero address");\n', '        return role.bearer[account];\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '        newOwner = address(0);\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner, "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '    modifier onlyNewOwner() {\n', '        require(msg.sender != address(0), "Ownable: account is the zero address");\n', '        require(msg.sender == newOwner, "Ownable: caller is not the new owner");\n', '        _;\n', '    }\n', '   \n', '    function isOwner(address account) public view returns (bool) {       \n', '            return account == owner;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        require(_newOwner != address(0), "Ownable: new owner is the zero address");\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() public onlyNewOwner returns(bool) {\n', '        emit OwnershipTransferred(owner, newOwner);        \n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract PauserRole is Ownable{\n', '    using Roles for Roles.Role;\n', '\n', '    event PauserAdded(address indexed account);\n', '    event PauserRemoved(address indexed account);\n', '\n', '    Roles.Role private _pausers;\n', '    uint256 internal _pausersCount;\n', '\n', '    constructor () internal {\n', '        _addPauser(msg.sender);\n', '    }\n', '\n', '    modifier onlyPauser() {\n', '        require(isPauser(msg.sender)|| isOwner(msg.sender));\n', '        _;\n', '    }\n', '\n', '    function isPauser(address account) public view returns (bool) {\n', '        return _pausers.has(account);\n', '    }\n', '\n', '    function addPauser(address account) public onlyPauser {\n', '        _addPauser(account);\n', '    }\n', '   \n', '    function removePauser(address account) public onlyOwner {\n', '        _removePauser(account);\n', '    }\n', '\n', '    function renouncePauser() public onlyOwner {\n', '        _removePauser(msg.sender);\n', '    }\n', '\n', '    function _addPauser(address account) internal {\n', '        _pausers.add(account);\n', '        emit PauserAdded(account);\n', '    }\n', '\n', '    function _removePauser(address account) internal {        \n', '        _pausers.remove(account);\n', '        emit PauserRemoved(account);\n', '    }\n', '}\n', '\n', 'contract Pausable is PauserRole {\n', '    event Paused(address account);\n', '    event Unpaused(address account);\n', '\n', '    bool private _paused;\n', '\n', '    constructor () internal {\n', '        _paused = false;\n', '    }\n', '\n', '    /**\n', '     * @return true if the contract is paused, false otherwise.\n', '     */\n', '    function paused() public view returns (bool) {\n', '        return _paused;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!_paused, "Pausable: paused");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(_paused, "Pausable: not paused");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to pause, triggers stopped state\n', '     */\n', '    function pause() public onlyPauser whenNotPaused {\n', '        _paused = true;\n', '        emit Paused(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to unpause, returns to normal state\n', '     */\n', '    function unpause() public onlyPauser whenPaused {\n', '        _paused = false;\n', '        emit Unpaused(msg.sender);\n', '    }\n', '}\n', '\n', 'interface IERC20 {\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address who) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract ERC20 is IERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) internal _balances;\n', '\n', '    mapping (address => mapping (address => uint256)) internal _allowed;\n', '\n', '    uint256 private _totalSupply;\n', '\n', '    /**\n', '    * @dev Total number of tokens in existence\n', '    */\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param owner The address to query the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address owner) public view returns (uint256) {\n', '        return _balances[owner];\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param owner address The address which owns the funds.\n', '     * @param spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address owner, address spender) public view returns (uint256) {\n', '        return _allowed[owner][spender];\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer token for a specified address\n', '    * @param to The address to transfer to.\n', '    * @param value The amount to be transferred.\n', '    */\n', '    function transfer(address to, uint256 value) public returns (bool) {\n', '        _transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param spender The address which will spend the funds.\n', '     * @param value The amount of tokens to be spent.\n', '     */\n', '    function approve(address spender, uint256 value) public returns (bool) {\n', '        require(spender != address(0), "ERC20: approve from the zero address");\n', '\n', '        _allowed[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another.\n', '     * Note that while this function emits an Approval event, this is not required as per the specification,\n', '     * and other compliant implementations may not emit the event.\n', '     * @param from address The address which you want to send tokens from\n', '     * @param to address The address which you want to transfer to\n', '     * @param value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '        _transfer(from, to, value);\n', '        emit Approval(from, msg.sender, _allowed[from][msg.sender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when allowed_[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * Emits an Approval event.\n', '     * @param spender The address which will spend the funds.\n', '     * @param addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '        require(spender != address(0), "ERC20: increaseAllowance from the zero address");\n', '\n', '        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);\n', '        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when allowed_[_spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * Emits an Approval event.\n', '     * @param spender The address which will spend the funds.\n', '     * @param subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '        require(spender != address(0), "ERC20: decreaseAllowance from the zero address");\n', '\n', '        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);\n', '        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer token for a specified addresses\n', '    * @param from The address to transfer from.\n', '    * @param to The address to transfer to.\n', '    * @param value The amount to be transferred.\n', '    */\n', '    function _transfer(address from, address to, uint256 value) internal {\n', '        require(to != address(0), "ERC20: account to the zero address");\n', '\n', '        _balances[from] = _balances[from].sub(value);\n', '        _balances[to] = _balances[to].add(value);\n', '        emit Transfer(from, to, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function that mints an amount of the token and assigns it to\n', '     * an account. This encapsulates the modification of balances such that the\n', '     * proper events are emitted.\n', '     * @param account The account that will receive the created tokens.\n', '     * @param value The amount that will be created.\n', '     */\n', '    function _mint(address account, uint256 value) internal {\n', '        require(account != address(0), "ERC20: account from the zero address");\n', '\n', '        _totalSupply = _totalSupply.add(value);\n', '        _balances[account] = _balances[account].add(value);\n', '        emit Transfer(address(0), account, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function that burns an amount of the token of a given\n', '     * account.\n', '     * @param account The account whose tokens will be burnt.\n', '     * @param value The amount that will be burnt.\n', '     */\n', '    function _burn(address account, uint256 value) internal {\n', '        require(account != address(0), "ERC20: account from the zero address");\n', '\n', '        _totalSupply = _totalSupply.sub(value);\n', '        _balances[account] = _balances[account].sub(value);\n', '        emit Transfer(account, address(0), value);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function that burns an amount of the token of a given\n', "     * account, deducting from the sender's allowance for said account. Uses the\n", '     * internal burn function.\n', '     * Emits an Approval event (reflecting the reduced allowance).\n', '     * @param account The account whose tokens will be burnt.\n', '     * @param value The amount that will be burnt.\n', '     */\n', '    function _burnFrom(address account, uint256 value) internal {\n', '        _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);\n', '        _burn(account, value);\n', '        emit Approval(account, msg.sender, _allowed[account][msg.sender]);\n', '    }\n', '}\n', '\n', 'contract ERC20Burnable is ERC20 {\n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param value The amount of token to be burned.\n', '     */\n', '    function burn(uint256 value) public {\n', '        _burn(msg.sender, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Burns a specific amount of tokens from the target address and decrements allowance\n', '     * @param from address The address which you want to send tokens from\n', '     * @param value uint256 The amount of token to be burned\n', '     */\n', '    function burnFrom(address from, uint256 value) public {\n', '        _burnFrom(from, value);\n', '    }\n', '}\n', '\n', 'contract ERC20Pausable is ERC20, Pausable {\n', '    function transfer(address to, uint256 value) public whenNotPaused returns (bool) {\n', '        return super.transfer(to, value);\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {\n', '        return super.transferFrom(from, to, value);\n', '    }\n', '\n', '    function approve(address spender, uint256 value) public whenNotPaused returns (bool) {\n', '        return super.approve(spender, value);\n', '    }\n', '\n', '    function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {\n', '        return super.increaseAllowance(spender, addedValue);\n', '    }\n', '\n', '    function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {\n', '        return super.decreaseAllowance(spender, subtractedValue);\n', '    }\n', '}\n', '\n', 'contract ERC20Detailed is IERC20 {\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '\n', '    constructor (string memory name, string memory symbol, uint8 decimals) public {\n', '        _name = name;\n', '        _symbol = symbol;\n', '        _decimals = decimals;\n', '    }\n', '\n', '    /**\n', '     * @return the name of the token.\n', '     */\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    /**\n', '     * @return the symbol of the token.\n', '     */\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    /**\n', '     * @return the number of decimals of the token.\n', '     */\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '}\n', '\n', '\n', 'contract AQT is ERC20Detailed, ERC20Pausable, ERC20Burnable {\n', '   \n', '    struct LockInfo {\n', '        uint256 _releaseTime;\n', '        uint256 _amount;\n', '    }\n', '   \n', '    address public implementation;\n', '\n', '    mapping (address => LockInfo[]) public timelockList;\n', '    mapping (address => bool) public frozenAccount;\n', '   \n', '    event Freeze(address indexed holder,bool status);    \n', '    event Lock(address indexed holder, uint256 value, uint256 releaseTime);\n', '    event Unlock(address indexed holder, uint256 value);\n', '\n', '    modifier notFrozen(address _holder) {\n', '        require(!frozenAccount[_holder], "ERC20: frozenAccount");\n', '        _;\n', '    }\n', '   \n', '    constructor() ERC20Detailed("Alpha Quark Token", "AQT", 18) public  {\n', '        _mint(msg.sender, 30000000 * (10 ** 18));\n', '    }\n', '   \n', '    function balanceOf(address owner) public view returns (uint256) {\n', '       \n', '        uint256 totalBalance = super.balanceOf(owner);\n', '        if( timelockList[owner].length >0 ){\n', '            for(uint i=0; i<timelockList[owner].length;i++){\n', '                totalBalance = totalBalance.add(timelockList[owner][i]._amount);\n', '            }\n', '        }\n', '       \n', '        return totalBalance;\n', '    }\n', '   \n', '    function transfer(address to, uint256 value) public notFrozen(msg.sender) notFrozen(to) returns (bool) {\n', '        if (timelockList[msg.sender].length > 0 ) {\n', '            _autoUnlock(msg.sender);            \n', '        }\n', '        return super.transfer(to, value);\n', '    }\n', '   \n', '\n', '    function freezeAccount(address holder, bool value) public onlyPauser returns (bool) {        \n', '        frozenAccount[holder] = value;\n', '        emit Freeze(holder,value);\n', '        return true;\n', '    }\n', '\n', '    function lock(address holder, uint256 value, uint256 releaseTime) public onlyPauser returns (bool) {\n', '        require(_balances[holder] >= value,"There is not enough balances of holder.");\n', '        _lock(holder,value,releaseTime);\n', '       \n', '        return true;\n', '    }\n', '   \n', '    function transferWithLock(address holder, uint256 value, uint256 releaseTime) public onlyPauser returns (bool) {\n', '        _transfer(msg.sender, holder, value);\n', '        _lock(holder,value,releaseTime);\n', '        return true;\n', '    }\n', '   \n', '    function unlock(address holder, uint256 idx) public onlyPauser returns (bool) {\n', '        require( timelockList[holder].length > idx, "There is not lock info.");\n', '        _unlock(holder,idx);\n', '        return true;\n', '    }\n', '   \n', '    /**\n', '     * @dev Upgrades the implementation address\n', '     * @param _newImplementation address of the new implementation\n', '     */\n', '    function upgradeTo(address _newImplementation) public onlyOwner {\n', '        require(implementation != _newImplementation);\n', '        _setImplementation(_newImplementation);\n', '    }\n', '   \n', '    function _lock(address holder, uint256 value, uint256 releaseTime) internal returns(bool) {\n', '        _balances[holder] = _balances[holder].sub(value);\n', '        timelockList[holder].push( LockInfo(releaseTime, value) );\n', '       \n', '        emit Lock(holder, value, releaseTime);\n', '        return true;\n', '    }\n', '   \n', '    function _unlock(address holder, uint256 idx) internal returns(bool) {\n', '        LockInfo storage lockinfo = timelockList[holder][idx];\n', '        uint256 releaseAmount = lockinfo._amount;\n', '        timelockList[holder][idx] = timelockList[holder][timelockList[holder].length.sub(1)];\n', '        timelockList[holder].pop();\n', '       \n', '        emit Unlock(holder, releaseAmount);\n', '        _balances[holder] = _balances[holder].add(releaseAmount);\n', '       \n', '        return true;\n', '    }\n', '   \n', '    function _autoUnlock(address holder) internal returns(bool) {\n', '        for(uint256 idx =0; idx < timelockList[holder].length ; idx++ ) {\n', '            if (timelockList[holder][idx]._releaseTime <= now) {\n', '                // If lockupinfo was deleted, loop restart at same position.\n', '                if( _unlock(holder, idx) ) {\n', '                    idx -=1;\n', '                }\n', '            }\n', '        }\n', '        return true;\n', '    }\n', '   \n', '    /**\n', '     * @dev Sets the address of the current implementation\n', '     * @param _newImp address of the new implementation\n', '     */\n', '    function _setImplementation(address _newImp) internal {\n', '        implementation = _newImp;\n', '    }\n', '   \n', '    /**\n', '     * @dev Fallback function allowing to perform a delegatecall\n', '     * to the given implementation. This function will return\n', '     * whatever the implementation call returns\n', '     */\n', '    function () payable external {\n', '        address impl = implementation;\n', '        require(impl != address(0), "ERC20: account is the zero address");\n', '        assembly {\n', '            let ptr := mload(0x40)\n', '            calldatacopy(ptr, 0, calldatasize)\n', '            let result := delegatecall(gas, impl, ptr, calldatasize, 0, 0)\n', '            let size := returndatasize\n', '            returndatacopy(ptr, 0, size)\n', '           \n', '            switch result\n', '            case 0 { revert(ptr, size) }\n', '            default { return(ptr, size) }\n', '        }\n', '    }\n', '}']