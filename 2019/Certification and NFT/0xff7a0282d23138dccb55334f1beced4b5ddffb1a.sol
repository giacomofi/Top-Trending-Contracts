['// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol\n', '\n', 'pragma solidity ^0.5.2;\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://eips.ethereum.org/EIPS/eip-20\n', ' */\n', 'interface IERC20 {\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address who) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol\n', '\n', 'pragma solidity ^0.5.2;\n', '\n', '\n', '/**\n', ' * @title ERC20Detailed token\n', ' * @dev The decimals are only for visualization purposes.\n', ' * All the operations are done using the smallest and indivisible token unit,\n', ' * just as on Ethereum all the operations are done in wei.\n', ' */\n', 'contract ERC20Detailed is IERC20 {\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '\n', '    constructor (string memory name, string memory symbol, uint8 decimals) public {\n', '        _name = name;\n', '        _symbol = symbol;\n', '        _decimals = decimals;\n', '    }\n', '\n', '    /**\n', '     * @return the name of the token.\n', '     */\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    /**\n', '     * @return the symbol of the token.\n', '     */\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    /**\n', '     * @return the number of decimals of the token.\n', '     */\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', 'pragma solidity ^0.5.2;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Unsigned math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Multiplies two unsigned integers, reverts on overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Adds two unsigned integers, reverts on overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '     * reverts when dividing by zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol\n', '\n', 'pragma solidity ^0.5.2;\n', '\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * https://eips.ethereum.org/EIPS/eip-20\n', ' * Originally based on code by FirstBlood:\n', ' * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' *\n', ' * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for\n', " * all accounts just by listening to said events. Note that this isn't required by the specification, and other\n", ' * compliant implementations may not do it.\n', ' */\n', 'contract ERC20 is IERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) private _balances;\n', '\n', '    mapping (address => mapping (address => uint256)) private _allowed;\n', '\n', '    uint256 private _totalSupply;\n', '\n', '    /**\n', '     * @dev Total number of tokens in existence\n', '     */\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the balance of the specified address.\n', '     * @param owner The address to query the balance of.\n', '     * @return A uint256 representing the amount owned by the passed address.\n', '     */\n', '    function balanceOf(address owner) public view returns (uint256) {\n', '        return _balances[owner];\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param owner address The address which owns the funds.\n', '     * @param spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address owner, address spender) public view returns (uint256) {\n', '        return _allowed[owner][spender];\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer token to a specified address\n', '     * @param to The address to transfer to.\n', '     * @param value The amount to be transferred.\n', '     */\n', '    function transfer(address to, uint256 value) public returns (bool) {\n', '        _transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param spender The address which will spend the funds.\n', '     * @param value The amount of tokens to be spent.\n', '     */\n', '    function approve(address spender, uint256 value) public returns (bool) {\n', '        _approve(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another.\n', '     * Note that while this function emits an Approval event, this is not required as per the specification,\n', '     * and other compliant implementations may not emit the event.\n', '     * @param from address The address which you want to send tokens from\n', '     * @param to address The address which you want to transfer to\n', '     * @param value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '        _transfer(from, to, value);\n', '        _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when _allowed[msg.sender][spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * Emits an Approval event.\n', '     * @param spender The address which will spend the funds.\n', '     * @param addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '        _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when _allowed[msg.sender][spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * Emits an Approval event.\n', '     * @param spender The address which will spend the funds.\n', '     * @param subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '        _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer token for a specified addresses\n', '     * @param from The address to transfer from.\n', '     * @param to The address to transfer to.\n', '     * @param value The amount to be transferred.\n', '     */\n', '    function _transfer(address from, address to, uint256 value) internal {\n', '        require(to != address(0));\n', '\n', '        _balances[from] = _balances[from].sub(value);\n', '        _balances[to] = _balances[to].add(value);\n', '        emit Transfer(from, to, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function that mints an amount of the token and assigns it to\n', '     * an account. This encapsulates the modification of balances such that the\n', '     * proper events are emitted.\n', '     * @param account The account that will receive the created tokens.\n', '     * @param value The amount that will be created.\n', '     */\n', '    function _mint(address account, uint256 value) internal {\n', '        require(account != address(0));\n', '\n', '        _totalSupply = _totalSupply.add(value);\n', '        _balances[account] = _balances[account].add(value);\n', '        emit Transfer(address(0), account, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function that burns an amount of the token of a given\n', '     * account.\n', '     * @param account The account whose tokens will be burnt.\n', '     * @param value The amount that will be burnt.\n', '     */\n', '    function _burn(address account, uint256 value) internal {\n', '        require(account != address(0));\n', '\n', '        _totalSupply = _totalSupply.sub(value);\n', '        _balances[account] = _balances[account].sub(value);\n', '        emit Transfer(account, address(0), value);\n', '    }\n', '\n', '    /**\n', "     * @dev Approve an address to spend another addresses' tokens.\n", '     * @param owner The address that owns the tokens.\n', '     * @param spender The address that will spend the tokens.\n', '     * @param value The number of tokens that can be spent.\n', '     */\n', '    function _approve(address owner, address spender, uint256 value) internal {\n', '        require(spender != address(0));\n', '        require(owner != address(0));\n', '\n', '        _allowed[owner][spender] = value;\n', '        emit Approval(owner, spender, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function that burns an amount of the token of a given\n', "     * account, deducting from the sender's allowance for said account. Uses the\n", '     * internal burn function.\n', '     * Emits an Approval event (reflecting the reduced allowance).\n', '     * @param account The account whose tokens will be burnt.\n', '     * @param value The amount that will be burnt.\n', '     */\n', '    function _burnFrom(address account, uint256 value) internal {\n', '        _burn(account, value);\n', '        _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/access/Roles.sol\n', '\n', 'pragma solidity ^0.5.2;\n', '\n', '/**\n', ' * @title Roles\n', ' * @dev Library for managing addresses assigned to a Role.\n', ' */\n', 'library Roles {\n', '    struct Role {\n', '        mapping (address => bool) bearer;\n', '    }\n', '\n', '    /**\n', '     * @dev give an account access to this role\n', '     */\n', '    function add(Role storage role, address account) internal {\n', '        require(account != address(0));\n', '        require(!has(role, account));\n', '\n', '        role.bearer[account] = true;\n', '    }\n', '\n', '    /**\n', "     * @dev remove an account's access to this role\n", '     */\n', '    function remove(Role storage role, address account) internal {\n', '        require(account != address(0));\n', '        require(has(role, account));\n', '\n', '        role.bearer[account] = false;\n', '    }\n', '\n', '    /**\n', '     * @dev check if an account has this role\n', '     * @return bool\n', '     */\n', '    function has(Role storage role, address account) internal view returns (bool) {\n', '        require(account != address(0));\n', '        return role.bearer[account];\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol\n', '\n', 'pragma solidity ^0.5.2;\n', '\n', '\n', 'contract MinterRole {\n', '    using Roles for Roles.Role;\n', '\n', '    event MinterAdded(address indexed account);\n', '    event MinterRemoved(address indexed account);\n', '\n', '    Roles.Role private _minters;\n', '\n', '    constructor () internal {\n', '        _addMinter(msg.sender);\n', '    }\n', '\n', '    modifier onlyMinter() {\n', '        require(isMinter(msg.sender));\n', '        _;\n', '    }\n', '\n', '    function isMinter(address account) public view returns (bool) {\n', '        return _minters.has(account);\n', '    }\n', '\n', '    function addMinter(address account) public onlyMinter {\n', '        _addMinter(account);\n', '    }\n', '\n', '    function renounceMinter() public {\n', '        _removeMinter(msg.sender);\n', '    }\n', '\n', '    function _addMinter(address account) internal {\n', '        _minters.add(account);\n', '        emit MinterAdded(account);\n', '    }\n', '\n', '    function _removeMinter(address account) internal {\n', '        _minters.remove(account);\n', '        emit MinterRemoved(account);\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol\n', '\n', 'pragma solidity ^0.5.2;\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20Mintable\n', ' * @dev ERC20 minting logic\n', ' */\n', 'contract ERC20Mintable is ERC20, MinterRole {\n', '    /**\n', '     * @dev Function to mint tokens\n', '     * @param to The address that will receive the minted tokens.\n', '     * @param value The amount of tokens to mint.\n', '     * @return A boolean that indicates if the operation was successful.\n', '     */\n', '    function mint(address to, uint256 value) public onlyMinter returns (bool) {\n', '        _mint(to, value);\n', '        return true;\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', 'pragma solidity ^0.5.2;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor () internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @return the address of the owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner());\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @return true if `msg.sender` is the owner of the contract.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to relinquish control of the contract.\n', '     * It will not be possible to call the functions with the `onlyOwner`\n', '     * modifier anymore.\n', '     * @notice Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: contracts/ComplianceService.sol\n', '\n', 'pragma solidity ^0.5.2;\n', '\n', '/// @notice Standard interface for `ComplianceService`s\n', 'contract ComplianceService {\n', '\n', '    /*\n', '    * @notice This method *MUST* be called by `BlueshareToken`s during `transfer()` and `transferFrom()`.\n', '    *         The implementation *SHOULD* check whether or not a transfer can be approved.\n', '    *\n', '    * @dev    This method *MAY* call back to the token contract specified by `_token` for\n', '    *         more information needed to enforce trade approval.\n', '    *\n', '    * @param  _token The address of the token to be transfered\n', '    * @param  _spender The address of the spender of the token\n', '    * @param  _from The address of the sender account\n', '    * @param  _to The address of the receiver account\n', '    * @param  _amount The quantity of the token to trade\n', '    *\n', '    * @return uint8 The reason code: 0 means success.  Non-zero values are left to the implementation\n', '    *               to assign meaning.\n', '    */\n', '    function check(address _token, address _spender, address _from, address _to, uint256 _amount) public returns (uint8);\n', '\n', '    /*\n', '    * @notice This method *MUST* be called by `BlueshareToken`s during `forceTransferFrom()`. \n', '    *         Accessible only by admins, used for forced tokens transfer\n', '    *         The implementation *SHOULD* check whether or not a transfer can be approved.\n', '    *\n', '    * @dev    This method *MAY* call back to the token contract specified by `_token` for\n', '    *         more information needed to enforce trade approval.\n', '    *\n', '    * @param  _token The address of the token to be transfered\n', '    * @param  _spender The address of the spender of the token *Admin or Owner*\n', '    * @param  _from The address of the sender account\n', '    * @param  _to The address of the receiver account\n', '    * @param  _amount The quantity of the token to trade\n', '    *\n', '    * @return uint8 The reason code: 0 means success.  Non-zero values are left to the implementation\n', '    *               to assign meaning.\n', '    */\n', '    function forceCheck(address _token, address _spender, address _from, address _to, uint256 _amount) public returns (uint8);\n', '\n', '    /**\n', '    * @notice This method *MUST* be called by `BlueshareToken`s during  during `transfer()` and `transferFrom()`.\n', '    *         The implementation *SHOULD* check whether or not a transfer can be approved.\n', '    *\n', '    * @dev    This method  *MAY* call back to the token contract specified by `_token` for\n', '    *         information needed to enforce trade approval if needed\n', '    *\n', '    * @param  _token The address of the token to be transfered\n', '    * @param  _spender The address of the spender of the token (unused in this implementation)\n', '    * @param  _holder The address of the sender account, our holder\n', '    * @param  _balance The balance of our holder\n', '    * @param  _amount The amount he or she whants to send\n', '    *\n', '    * @return `true` if the trade should be approved and `false` if the trade should not be approved\n', '    */\n', '    function checkVested(address _token, address _spender, address _holder, uint256 _balance, uint256 _amount) public returns (bool);\n', '}\n', '\n', '// File: contracts/DividendService.sol\n', '\n', 'pragma solidity ^0.5.2;\n', '\n', '/// @notice Standard interface for `DividendService`s\n', 'contract DividendService {\n', '\n', '    /**\n', '    * @param _token The address of the token assigned with this `DividendService`\n', '    * @param _spender The address of the spender for this transaction\n', '    * @param _holder The address of the holder of the token\n', '    * @param _interval The time interval / year for which the dividends are paid or not\n', '    * @return uint8 The reason code: 0 means not paid.  Non-zero values are left to the implementation\n', '    *               to assign meaning.\n', '    */\n', '    function check(address _token, address _spender, address _holder, uint _interval) public returns (uint8);\n', '}\n', '\n', '// File: contracts/ServiceRegistry.sol\n', '\n', 'pragma solidity ^0.5.2;\n', '\n', '\n', '\n', '\n', '/// @notice regulator - A service that points to a `ComplianceService` contract\n', '/// @notice dividend - A service that points to a `DividendService` contract\n', 'contract ServiceRegistry is Ownable {\n', '    address public regulator;\n', '    address public dividend;\n', '\n', '    /**\n', '    * @notice Triggered when regulator or dividend service address is replaced\n', '    */\n', '    event ReplaceService(address oldService, address newService);\n', '\n', '    /**\n', '    * @dev Validate contract address\n', '    * Credit: https://github.com/Dexaran/ERC223-token-standard/blob/Recommended/ERC223_Token.sol#L107-L114\n', '    *\n', '    * @param _addr The address of a smart contract\n', '    */\n', '    modifier withContract(address _addr) {\n', '        uint length;\n', '        assembly { length := extcodesize(_addr) }\n', '        require(length > 0);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @notice Constructor\n', '    *\n', '    * @param _regulator The address of the `ComplianceService` contract\n', '    * @param _dividend The address of the `DividendService` contract\n', '    *\n', '    */\n', '    constructor(address _regulator, address _dividend) public {\n', '        regulator = _regulator;\n', '        dividend = _dividend;\n', '    }\n', '\n', '    /**\n', '    * @notice Replaces the address pointer to the `ComplianceService` contract\n', '    *\n', "    * @dev This method is only callable by the contract's owner\n", '    *\n', '    * @param _regulator The address of the new `ComplianceService` contract\n', '    */\n', '    function replaceRegulator(address _regulator) public onlyOwner withContract(_regulator) {\n', '        require(regulator != _regulator, "The address cannot be the same");\n', '\n', '        address oldRegulator = regulator;\n', '        regulator = _regulator;\n', '        emit ReplaceService(oldRegulator, regulator);\n', '    }\n', '\n', '    /**\n', '    * @notice Replaces the address pointer to the `DividendService` contract\n', '    *\n', "    * @dev This method is only callable by the contract's owner\n", '    *\n', '    * @param _dividend The address of the new `DividendService` contract\n', '    */\n', '    function replaceDividend(address _dividend) public onlyOwner withContract(_dividend) {\n', '        require(dividend != _dividend, "The address cannot be the same");\n', '\n', '        address oldDividend = dividend;\n', '        dividend = _dividend;\n', '        emit ReplaceService(oldDividend, dividend);\n', '    }\n', '}\n', '\n', '// File: contracts/BlueshareToken.sol\n', '\n', 'pragma solidity ^0.5.2;\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/// @notice An ERC-20 token that has the ability to check for trade validity\n', 'contract BlueshareToken is ERC20Detailed, ERC20Mintable, Ownable {\n', '\n', '    /**\n', '    * @notice Token decimals setting (used when constructing ERC20Detailed)\n', '    */\n', '    uint8 constant public BLUESHARETOKEN_DECIMALS = 0;\n', '\n', '    /**\n', '    * International Securities Identification Number (ISIN)\n', '    */\n', '    string constant public ISIN = "CH0465030796";\n', '\n', '    /**\n', '    * @notice Triggered when regulator checks pass or fail\n', '    */\n', '    event CheckComplianceStatus(uint8 reason, address indexed spender, address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '    * @notice Triggered when regulator checks pass or fail\n', '    */\n', '    event CheckVestingStatus(bool reason, address indexed spender, address indexed from, uint256 balance, uint256 value);\n', '\n', '    /**\n', '    * @notice Triggered when dividend checks pass or fail\n', '    */\n', '    event CheckDividendStatus(uint8 reason, address indexed spender, address indexed holder, uint interval);\n', '\n', '    /**\n', '    * @notice Address of the `ServiceRegistry` that has the location of the\n', '    *         `ComplianceService` contract responsible for checking trade permissions and \n', '    *         `DividendService` contract responsible for checking dividend state.\n', '    */\n', '    ServiceRegistry public registry;\n', '\n', '    /**\n', '    * @notice Constructor\n', '    *\n', '    * @param _registry Address of `ServiceRegistry` contract\n', '    * @param _name Name of the token: See ERC20Detailed\n', '    * @param _symbol Symbol of the token: See ERC20Detailed\n', '    */\n', '    constructor(ServiceRegistry _registry, string memory _name, string memory _symbol) public\n', '      ERC20Detailed(_name, _symbol, BLUESHARETOKEN_DECIMALS)\n', '    {\n', '        require(address(_registry) != address(0), "Uninitialized or undefined address");\n', '\n', '        registry = _registry;\n', '    }\n', '\n', '    /**\n', '    * @notice ERC-20 overridden function that include logic to check for trade validity.\n', '    *\n', '    * @param _to The address of the receiver\n', '    * @param _value The number of tokens to transfer\n', '    *\n', '    * @return `true` if successful and `false` if unsuccessful\n', '    */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_checkVested(msg.sender, balanceOf(msg.sender), _value), "Cannot send vested amount!");\n', '        require(_check(msg.sender, _to, _value), "Cannot transfer!");\n', '\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    /**\n', '    * @notice ERC-20 overridden function that include logic to check for trade validity.\n', '    *\n', '    * @param _from The address of the sender\n', '    * @param _to The address of the receiver\n', '    * @param _value The number of tokens to transfer\n', '    *\n', '    * @return `true` if successful and `false` if unsuccessful\n', '    */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_checkVested(_from, balanceOf(_from), _value), "Cannot send vested amount!");\n', '        require(_check(_from, _to, _value), "Cannot transfer!");\n', '        \n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    /**\n', '    * @notice ERC-20 extended function that include logic to check for trade validity with admin rights.\n', '    *\n', '    * @param _from The address of the old wallet\n', '    * @param _to The address of the new wallet\n', '    * @param _value The number of tokens to transfer\n', '    *\n', '    */\n', '    function forceTransferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_forceCheck(_from, _to, _value), "Not allowed!");\n', '\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @notice The public function for checking divident payout status\n', '    *\n', "    * @param _holder The address of the token's holder\n", "    * @param _interval The interval for divident's status\n", '    */\n', '    function dividendStatus(address _holder, uint _interval) public returns (uint8) {\n', '        return _checkDividend(_holder, _interval);\n', '    }\n', '\n', '    /**\n', '    * @notice Performs the regulator check\n', '    *\n', '    * @dev This method raises a CheckComplianceStatus event indicating success or failure of the check\n', '    *\n', '    * @param _from The address of the sender\n', '    * @param _to The address of the receiver\n', '    * @param _value The number of tokens to transfer\n', '    *\n', '    * @return `true` if the check was successful and `false` if unsuccessful\n', '    */\n', '    function _check(address _from, address _to, uint256 _value) private returns (bool) {\n', '        uint8 reason = _regulator().check(address(this), msg.sender, _from, _to, _value);\n', '\n', '        emit CheckComplianceStatus(reason, msg.sender, _from, _to, _value);\n', '\n', '        return reason == 0;\n', '    }\n', '\n', '    /**\n', '    * @notice Performs the regulator forceCheck, accessable only by admins\n', '    *\n', '    * @dev This method raises a CheckComplianceStatus event indicating success or failure of the check\n', '    *\n', '    * @param _from The address of the sender\n', '    * @param _to The address of the receiver\n', '    * @param _value The number of tokens to transfer\n', '    *\n', '    * @return `true` if the check was successful and `false` if unsuccessful\n', '    */\n', '    function _forceCheck(address _from, address _to, uint256 _value) private returns (bool) {\n', '        uint8 allowance = _regulator().forceCheck(address(this), msg.sender, _from, _to, _value);\n', '\n', '        emit CheckComplianceStatus(allowance, msg.sender, _from, _to, _value);\n', '\n', '        return allowance == 0;\n', '    }\n', '\n', '    /**\n', '    * @notice Performs the regulator check\n', '    *\n', '    * @dev This method raises a CheckVestingStatus event indicating success or failure of the check\n', '    *\n', '    * @param _participant The address of the participant\n', '    * @param _balance The balance of the sender\n', '    * @param _value The number of tokens to transfer\n', '    *\n', '    * @return `true` if the check was successful and `false` if unsuccessful\n', '    */\n', '    function _checkVested(address _participant, uint256 _balance, uint256 _value) private returns (bool) {\n', '        bool allowed = _regulator().checkVested(address(this), msg.sender, _participant, _balance, _value);\n', '\n', '        emit CheckVestingStatus(allowed, msg.sender, _participant, _balance, _value);\n', '\n', '        return allowed;\n', '    }\n', '\n', '    /**\n', '    * @notice Performs the dividend check\n', '    *\n', '    * @dev This method raises a CheckDividendStatus event indicating success or failure of the check\n', '    *\n', '    * @param _address The address of the holder\n', '    * @param _interval The time interval / year for which the dividends are paid or not\n', '    *\n', '    * @return `true` if the check was successful and `false` if unsuccessful\n', '    */\n', '    function _checkDividend(address _address, uint _interval) private returns (uint8) {\n', '        uint8 status = _dividend().check(address(this), msg.sender, _address, _interval);\n', '\n', '        emit CheckDividendStatus(status, msg.sender, _address, _interval);\n', '\n', '        return status;\n', '    }\n', '\n', '    /**\n', '    * @notice Retreives the address of the `ComplianceService` that manages this token.\n', '    *\n', '    * @dev This function *MUST NOT* memoize the `ComplianceService` address.  This would\n', '    *      break the ability to upgrade the `ComplianceService`.\n', '    *\n', '    * @return The `ComplianceService` that manages this token.\n', '    */\n', '    function _regulator() public view returns (ComplianceService) {\n', '        return ComplianceService(registry.regulator());\n', '    }\n', '\n', '    /**\n', '    * @notice Retreives the address of the `DividendService` that manages this token.\n', '    *\n', '    * @dev This function *MUST NOT* memoize the `DividendService` address.  This would\n', '    *      break the ability to upgrade the `DividendService`.\n', '    *\n', '    * @return The `DividendService` that manages this token.\n', '    */\n', '    function _dividend() public view returns (DividendService) {\n', '        return DividendService(registry.dividend());\n', '    }\n', '}']