['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-03\n', '*/\n', '\n', '// File: @openzeppelin/upgrades/contracts/Initializable.sol\n', '\n', 'pragma solidity >=0.4.24 <0.7.0;\n', '\n', '\n', '/**\n', ' * @title Initializable\n', ' *\n', ' * @dev Helper contract to support initializer functions. To use it, replace\n', ' * the constructor with a function that has the `initializer` modifier.\n', ' * WARNING: Unlike constructors, initializer functions must be manually\n', ' * invoked. This applies both to deploying an Initializable contract, as well\n', ' * as extending an Initializable contract via inheritance.\n', ' * WARNING: When used with inheritance, manual care must be taken to not invoke\n', ' * a parent initializer twice, or ensure that all initializers are idempotent,\n', ' * because this is not dealt with automatically as with constructors.\n', ' */\n', 'contract Initializable {\n', '\n', '  /**\n', '   * @dev Indicates that the contract has been initialized.\n', '   */\n', '  bool private initialized;\n', '\n', '  /**\n', '   * @dev Indicates that the contract is in the process of being initialized.\n', '   */\n', '  bool private initializing;\n', '\n', '  /**\n', '   * @dev Modifier to use in the initializer function of a contract.\n', '   */\n', '  modifier initializer() {\n', '    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");\n', '\n', '    bool isTopLevelCall = !initializing;\n', '    if (isTopLevelCall) {\n', '      initializing = true;\n', '      initialized = true;\n', '    }\n', '\n', '    _;\n', '\n', '    if (isTopLevelCall) {\n', '      initializing = false;\n', '    }\n', '  }\n', '\n', '  /// @dev Returns true if and only if the function is running in the constructor\n', '  function isConstructor() private view returns (bool) {\n', '    // extcodesize checks the size of the code stored in an address, and\n', '    // address returns the current address. Since the code is still not\n', '    // deployed when running a constructor, any checks on its code size will\n', '    // yield zero, making it an effective way to detect if a contract is\n', '    // under construction or not.\n', '    address self = address(this);\n', '    uint256 cs;\n', '    assembly { cs := extcodesize(self) }\n', '    return cs == 0;\n', '  }\n', '\n', '  // Reserved storage space to allow for layout changes in the future.\n', '  uint256[50] private ______gap;\n', '}\n', '\n', '// File: contracts/ERC/ERC20Interface.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/** ----------------------------------------------------------------------------\n', '* @title ERC Token Standard #20 Interface\n', '* https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md\n', '* ----------------------------------------------------------------------------\n', '*/\n', 'contract ERC20Interface {\n', '    function totalSupply() public view returns (uint);\n', '    function balanceOf(address tokenOwner) public view returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint value);\n', '}\n', '\n', '// File: contracts/libs/SafeMath.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, reverts on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, reverts on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '    * reverts when dividing by zero.\n', '    */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts-ethereum-package/contracts/access/Roles.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @title Roles\n', ' * @dev Library for managing addresses assigned to a Role.\n', ' */\n', 'library Roles {\n', '    struct Role {\n', '        mapping (address => bool) bearer;\n', '    }\n', '\n', '    /**\n', '     * @dev Give an account access to this role.\n', '     */\n', '    function add(Role storage role, address account) internal {\n', '        require(!has(role, account), "Roles: account already has role");\n', '        role.bearer[account] = true;\n', '    }\n', '\n', '    /**\n', "     * @dev Remove an account's access to this role.\n", '     */\n', '    function remove(Role storage role, address account) internal {\n', '        require(has(role, account), "Roles: account does not have role");\n', '        role.bearer[account] = false;\n', '    }\n', '\n', '    /**\n', '     * @dev Check if an account has this role.\n', '     * @return bool\n', '     */\n', '    function has(Role storage role, address account) internal view returns (bool) {\n', '        require(account != address(0), "Roles: account is the zero address");\n', '        return role.bearer[account];\n', '    }\n', '}\n', '\n', '// File: contracts/libs/Ownable.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', '* @title Ownable\n', '* @dev The Ownable contract has an owner address, and provides basic      authorization control\n', '* functions, this simplifies the implementation of "user permissions".\n', '*/\n', 'contract Ownable {\n', '\n', '    address public owner;\n', '\n', '    event OwnershipRenounced(address indexed previousOwner);\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner, "Ownable: sender is not owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to relinquish control of the contract.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        owner = address(0);\n', '        emit OwnershipRenounced(owner);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param _newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        _transferOwnership(_newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers control of the contract to a newOwner.\n', '     * @param _newOwner The address to transfer ownership to.\n', '     */\n', '    function _transferOwnership(address _newOwner) internal {\n', '        require(_newOwner != address(0), "Ownable: transfer to zero address");\n', '        owner = _newOwner;\n', '        emit OwnershipTransferred(owner, _newOwner);\n', '    }\n', '}\n', '\n', '// File: contracts/libs/AccessControl.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '\n', 'contract AccessControl is Ownable {\n', '\n', '    using Roles for Roles.Role;\n', '\n', '    //Contract admins\n', '    Roles.Role internal _admins;\n', '\n', '    // Events\n', '    event AddedAdmin(address _address);\n', '    event DeletedAdmin(address _addess);\n', '\n', '    function addAdmin(address newAdmin) public onlyOwner {\n', '        require(newAdmin != address(0), "AccessControl: Invalid new admin address");\n', '        _admins.add(newAdmin);\n', '        emit AddedAdmin(newAdmin);\n', '    }\n', '\n', '    function deletedAdmin(address deleteAdmin) public onlyOwner {\n', '        require(deleteAdmin != address(0), "AccessControl: Invalid new admin address");\n', '        _admins.remove(deleteAdmin);\n', '        emit DeletedAdmin(deleteAdmin);\n', '    }\n', '}\n', '\n', '// File: contracts/ERC/ERC20.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md\n', ' */\n', 'contract ERC20 is ERC20Interface, AccessControl {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) internal _balances;\n', '\n', '    mapping(address => mapping(address => uint256)) internal _allowed;\n', '\n', '    uint256 internal _totalSupply;\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    // Modifiers\n', '\n', '    modifier onlyOwnerOrAdmin() {\n', '        require(msg.sender == owner || _admins.has(msg.sender), "ERC20: sender is not owner or admin");\n', '        _;\n', '    }\n', '\n', '    // Functions\n', '\n', '\n', '    /**\n', '    * @dev Total number of tokens in existence\n', '    */\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param owner The address to query the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address owner) public view returns (uint256) {\n', '        return _balances[owner];\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param owner address The address which owns the funds.\n', '     * @param spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address owner, address spender) public view returns (uint256) {\n', '        return _allowed[owner][spender];\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer token for a specified address\n', '    * @param to The address to transfer to.\n', '    * @param value The amount to be transferred.\n', '    */\n', '    function transfer(address to, uint256 value) public returns (bool) {\n', '        _transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param spender The address which will spend the funds.\n', '     * @param value The amount of tokens to be spent.\n', '     */\n', '    function approve(address spender, uint256 value) public returns (bool) {\n', '        _approve(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param from address The address which you want to send tokens from\n', '     * @param to address The address which you want to transfer to\n', '     * @param value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '        require(value <= _allowed[from][msg.sender], "ERC20: account balance is lower than amount");\n', '        _transfer(from, to, value);\n', '        _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when allowed_[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * @param spender The address which will spend the funds.\n', '     * @param addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '        require(addedValue > 0, "ERC20: value must be bigger than zero");\n', '        _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when allowed_[_spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * @param spender The address which will spend the funds.\n', '     * @param subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '        require(subtractedValue > 0, "ERC20: value must be bigger than zero");\n', '        _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function that burns an amount of the token of a given\n', '     * account.\n', '     * @param account The account whose tokens will be burnt.\n', '     * @param amount The amount that will be burnt.\n', '     */\n', '    function _burn(address account, uint256 amount) internal {\n', '        require(account != address(0), "ERC20: transfer to the zero address");\n', '        require(amount > 0, "ERC20: value must be bigger than zero");\n', '        require(amount <= _balances[account], "ERC20: account balance is lower than amount");\n', '\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        _balances[account] = _balances[account].sub(amount);\n', '        emit Transfer(account, address(0), amount);\n', '        emit Burn(account, amount);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function that burns an amount of the token of a given\n', "     * account, deducting from the sender's allowance for said account. Uses the\n", '     * internal burn function.\n', '     * @param account The account whose tokens will be burnt.\n', '     * @param amount The amount that will be burnt.\n', '     */\n', '    function _burnFrom(address account, uint256 amount) internal {\n', '        require(account != address(0), "ERC20: transfer to the zero address");\n', '        require(amount > 0, "ERC20: value must be bigger than zero");\n', '        require(amount <= _allowed[account][msg.sender] || _admins.has(msg.sender), "ERC20: account allowed balance is lower than amount");\n', '        _burn(account, amount);\n', '        _approve(account, msg.sender, _allowed[account][msg.sender].sub(amount));\n', '    }\n', '\n', '    /**\n', '    * @dev Internal transfer, only can be called by this contract\n', '    */\n', '    function _transfer(address _from, address _to, uint256 value) internal {\n', '        require(_from != address(0), "ERC20: transfer to the zero address");\n', '        require(_to != address(0), "ERC20: transfer to the zero address");\n', '        require(value > 0, "ERC20: value must be bigger than zero");\n', '        require(value <= _balances[_from], "ERC20: balances from must be bigger than transfer amount");\n', '        require(_balances[_to] < _balances[_to] + value, "ERC20: value must be bigger than zero");\n', '\n', '        _balances[_from] = _balances[_from].sub(value);\n', '        _balances[_to] = _balances[_to].add(value);\n', '        emit Transfer(_from, _to, value);\n', '    }\n', '\n', '    /**\n', '    * @dev Internal function, minting new tokens\n', '    */\n', '    function _mint(address account, uint256 amount) internal {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '        require(amount > 0, "ERC20: value must be bigger than zero");\n', '\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '        _allowed[account][account] = _balances[account];\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.\n', '     *\n', '     * This is internal function is equivalent to `approve`, and can be used to\n', '     * e.g. set automatic allowances for certain subsystems, etc.\n', '     *\n', '     * Emits an {Approval} event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `owner` cannot be the zero address.\n', '     * - `spender` cannot be the zero address.\n', '     */\n', '    function _approve(address owner, address spender, uint256 amount) internal {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowed[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '\n', '}\n', '\n', '// File: contracts/libs/MintableToken.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120\n', ' */\n', 'contract MintableToken is ERC20 {\n', '\n', '    event Mint(address indexed to, uint256 amount);\n', '\n', '    event MintFinished();\n', '\n', '    event MintStarted();\n', '\n', '    bool public mintingFinished = false;\n', '\n', '    modifier canMint() {\n', '        require(!mintingFinished, "MintableToken: minting is finished");\n', '        _;\n', '    }\n', '\n', '    modifier hasMintPermission() {\n', '        require(msg.sender == owner || _admins.has(msg.sender), "MintableToken: sender has not permissions");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to mint tokens\n', '     * @param _to The address that will receive the minted tokens.\n', '     * @param _amount The amount of tokens to mint.\n', '     * @return A boolean this indicates if the operation was successful.\n', '     */\n', '    function mint(address _to, uint256 _amount) public hasMintPermission canMint returns (bool) {\n', '        _mint(_to, _amount);\n', '        emit Mint(_to, _amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to stop minting new tokens.\n', '     * @return True if the operation was successful.\n', '     */\n', '    function finishMinting() public onlyOwnerOrAdmin canMint returns (bool) {\n', '        mintingFinished = true;\n', '        emit MintFinished();\n', '        return true;\n', '    }\n', '\n', '    function startMinting() public onlyOwnerOrAdmin returns (bool) {\n', '        mintingFinished = false;\n', '        emit MintStarted();\n', '        return true;\n', '    }\n', '}\n', '\n', '// File: contracts/libs/FreezableToken.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '/**\n', ' * @title Freezable token\n', ' * @dev Add ability froze accounts\n', ' */\n', 'contract FreezableToken is MintableToken {\n', '\n', '    mapping(address => bool) public frozenAccounts;\n', '\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    /**\n', '     * @dev Freze account\n', '     */\n', '    function freezeAccount(address target, bool freeze) public onlyOwnerOrAdmin {\n', '        frozenAccounts[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '\n', '    /**\n', '     * @dev Ovveride base method _transfer from base ERC20 contract\n', '     */\n', '    function _transfer(address _from, address _to, uint256 value) internal {\n', '        require(_to != address(0x0), "FreezableToken: transfer to the zero address");\n', '        require(_balances[_from] >= value, "FreezableToken: balance _from must br bigger than value");\n', '        require(_balances[_to] + value >= _balances[_to], "FreezableToken: balance to must br bigger than current balance");\n', '        require(!frozenAccounts[_from], "FreezableToken: account _from is frozen");\n', '        require(!frozenAccounts[_to], "FreezableToken: account _to is frozen");\n', '        _balances[_from] = _balances[_from].sub(value);\n', '        _balances[_to] = _balances[_to].add(value);\n', '        emit Transfer(_from, _to, value);\n', '    }\n', '}\n', '\n', '// File: contracts/libs/Pausable.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '\n', '    event Pause();\n', '\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!paused, "Pausable: contract paused");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(paused, "Pausable: contract not paused");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to pause, triggers stopped state\n', '     */\n', '    function pause() public onlyOwner whenNotPaused {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to unpause, returns to normal state\n', '     */\n', '    function unpause() public onlyOwner whenPaused {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '}\n', '\n', '// File: contracts/MainContract.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '\n', '/**\n', ' * @title Contract constants\n', ' * @dev  Contract whose consisit base constants for contract\n', ' */\n', 'contract ContractConstants {\n', '\n', '    uint256 internal TOKEN_BUY_PRICE;\n', '\n', '    uint256 internal TOKEN_BUY_PRICE_DECIMAL;\n', '\n', '    uint256 internal TOKENS_BUY_LIMIT;\n', '}\n', '\n', '/**\n', ' * @title MainContract\n', ' * @dev Base contract which using for initializing new contract\n', ' */\n', 'contract MainContract is ContractConstants, FreezableToken, Pausable {\n', '\n', '    string private _name;\n', '\n', '    string private _symbol;\n', '\n', '    uint private _decimals;\n', '\n', '    uint private _decimalsMultiplier;\n', '\n', '    uint256 internal buyPrice;\n', '\n', '    uint256 internal buyPriceDecimals;\n', '\n', '    uint256 internal buyTokensLimit;\n', '\n', '    uint256 internal boughtTokensByCurrentPrice;\n', '\n', '    uint256 internal membersCount;\n', '\n', '    event Buy(address target, uint256 eth, uint256 tokens);\n', '\n', '    event NewLimit(uint256 prevLimit, uint256 newLimit);\n', '\n', '    event SetNewPrice(uint256 prevPrice, uint256 newPrice);\n', '\n', '    /**\n', '     * @return get token name\n', '     */\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    /**\n', '     * @return get token symbol\n', '     */\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    /**\n', '     * @return get token decimals\n', '     */\n', '    function decimals() public view returns (uint) {\n', '        return _decimals;\n', '    }\n', '\n', '    /**\n', '     * @return return buy price\n', '     */\n', '    function getBuyPrice() public view returns (uint256) {\n', '        return buyPrice;\n', '    }\n', '\n', '    /**\n', '     * @return return buy price decimals\n', '     */\n', '    function getBuyPriceDecimals() public view returns (uint256) {\n', '        return buyPriceDecimals;\n', '    }\n', '\n', '    /**\n', '    * @return return count mebers\n', '    */\n', '    function getMembersCount() public view returns (uint256) {\n', '        return membersCount;\n', '    }\n', '\n', '    /**\n', '     * @return return payable function buy limit\n', '     */\n', '    function getBuyTokensLimit() public view returns (uint256) {\n', '        return buyTokensLimit;\n', '    }\n', '\n', '    /**\n', '     * @return return count of bought tokens for current price\n', '     */\n', '    function getBoughtTokensByCurrentPrice() public view returns (uint256) {\n', '        return boughtTokensByCurrentPrice;\n', '    }\n', '\n', '    /**\n', '     * @dev set prices for sell tokens and buy tokens\n', '     */\n', '    function setPrices(uint256 newBuyPrice) public onlyOwnerOrAdmin {\n', '\n', '        emit SetNewPrice(buyPrice, newBuyPrice);\n', '\n', '        buyPrice = newBuyPrice;\n', '\n', '        boughtTokensByCurrentPrice = 0;\n', '    }\n', '\n', '    /**\n', '     * @dev set max buy tokens\n', '     */\n', '    function setLimit(uint256 newLimit) public onlyOwnerOrAdmin {\n', '\n', '        emit NewLimit(buyTokensLimit, newLimit);\n', '\n', '        buyTokensLimit = newLimit;\n', '    }\n', '\n', '    /**\n', '    * @dev set limit and reset price\n', '    */\n', '    function setLimitAndPrice(uint256 newLimit, uint256 newBuyPrice) public onlyOwnerOrAdmin {\n', '        setLimit(newLimit);\n', '        setPrices(newBuyPrice);\n', '    }\n', '\n', '    /**\n', '     * @dev set prices for sell tokens and buy tokens\n', '     */\n', '    function setPricesDecimals(uint256 newBuyDecimal) public onlyOwnerOrAdmin {\n', '        buyPriceDecimals = newBuyDecimal;\n', '    }\n', '\n', '    /**\n', '     * @dev override base method transferFrom\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 value) public whenNotPaused returns (bool _success) {\n', '        return super.transferFrom(_from, _to, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Override base method transfer\n', '     */\n', '    function transfer(address _to, uint256 value) public whenNotPaused returns (bool _success) {\n', '        return super.transfer(_to, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Override base method increaseAllowance\n', '     */\n', '    function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {\n', '        return super.increaseAllowance(spender, addedValue);\n', '    }\n', '\n', '    /**\n', '    * @dev Override base method decreaseAllowance\n', '    */\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {\n', '        return super.decreaseAllowance(spender, subtractedValue);\n', '    }\n', '\n', '    /**\n', '    * @dev Override base method approve\n', '    */\n', '    function approve(address spender, uint256 value) public whenNotPaused returns (bool) {\n', '        return super.approve(spender, value);\n', '    }\n', '\n', '    /**\n', '    * @dev Burn user tokens\n', '    */\n', '    function burn(uint256 _value) public whenNotPaused {\n', '        _burn(msg.sender, _value);\n', '    }\n', '\n', '    /**\n', '    * @dev Burn users tokens with allowance\n', '    */\n', '    function burnFrom(address account, uint256 _value) public whenNotPaused {\n', '        _burnFrom(account, _value);\n', '    }\n', '\n', '    /**\n', '    *  @dev Mint tokens by owner\n', '    */\n', '    function addTokens(uint256 _amount) public hasMintPermission canMint {\n', '        _mint(msg.sender, _amount);\n', '        emit Mint(msg.sender, _amount);\n', '    }\n', '\n', '    /**\n', '    * @dev Function whose calling on initialize contract\n', '    */\n', '    function init(string memory __name, string memory __symbol, uint __decimals, uint __totalSupply, address __owner, address __admin) public {\n', '        _name = __name;\n', '        _symbol = __symbol;\n', '        _decimals = __decimals;\n', '        _decimalsMultiplier = 10 ** _decimals;\n', '        if (paused) {\n', '            pause();\n', '        }\n', '        setPrices(TOKEN_BUY_PRICE);\n', '        setPricesDecimals(TOKEN_BUY_PRICE_DECIMAL);\n', '        uint256 generateTokens = __totalSupply * _decimalsMultiplier;\n', '        setLimit(TOKENS_BUY_LIMIT);\n', '        if (generateTokens > 0) {\n', '            mint(__owner, generateTokens);\n', '            approve(__owner, balanceOf(__owner));\n', '        }\n', '        addAdmin(__admin);\n', '        transferOwnership(__owner);\n', '    }\n', '\n', '    function() external payable {\n', '        buy(msg.sender, msg.value);\n', '    }\n', '\n', '    function calculateBuyTokens(uint256 _value) public view returns (uint256) {\n', '        uint256 buyDecimal = 10 ** buyPriceDecimals;\n', '        return (_value * _decimalsMultiplier) / (buyPrice * buyDecimal);\n', '    }\n', '\n', '    /**\n', '     * @dev buy tokens \n', '     */\n', '    function buy(address _sender, uint256 _value) internal {\n', "        require(_value > 0, 'MainContract: Value must be bigger than zero');\n", "        require(buyPrice > 0, 'MainContract: Cannot buy tokens');\n", "        require(boughtTokensByCurrentPrice < buyTokensLimit, 'MainContract: Cannot buy tokens more than current limit');\n", '        uint256 amount = this.calculateBuyTokens(_value);\n', '        if (boughtTokensByCurrentPrice + amount > buyTokensLimit) {\n', '            amount = buyTokensLimit - boughtTokensByCurrentPrice;\n', '        }\n', '        membersCount = membersCount.add(1);\n', '        _transfer(owner, _sender, amount);\n', '        boughtTokensByCurrentPrice = boughtTokensByCurrentPrice.add(amount);\n', '        address(uint160(owner)).transfer(_value);\n', '        emit Buy(_sender, _value, amount);\n', '    }\n', '}\n', '\n', '// File: contracts/Esillium.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '\n', 'contract Esillium is MainContract, Initializable {\n', '\n', '     constructor () public {initialize();}\n', '\n', '     function initialize() public initializer {\n', '          owner = msg.sender;\n', '          // First stage config, ETH/USD price : 1605.73\n', '          TOKEN_BUY_PRICE = 31172;\n', '          TOKEN_BUY_PRICE_DECIMAL = 10;\n', '          TOKENS_BUY_LIMIT = 359200000000;\n', "          init('Esillium', '8YB', 5, 7000000000, 0x158ad714bc7BEeaD490960eCB382717FA36Ef926, 0x51b8Aa6616B868a4F36b0b3C6Db46B015c5467D6);\n", '     }\n', '}']