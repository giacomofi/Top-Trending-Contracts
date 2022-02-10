['pragma solidity ^0.5.2;\n', ' \n', '/**\n', ' * @title SafeMath\n', ' * @dev Unsigned math operations with safety checks that revert on error.\n', ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Multiplies two unsigned integers, reverts on overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', ' \n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', ' \n', '        return c;\n', '    }\n', ' \n', '    /**\n', '     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", ' \n', '        return c;\n', '    }\n', ' \n', '    /**\n', '     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', ' \n', '        return c;\n', '    }\n', ' \n', '    /**\n', '     * @dev Adds two unsigned integers, reverts on overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', ' \n', '        return c;\n', '    }\n', ' \n', '    /**\n', '     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '     * reverts when dividing by zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', ' \n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address private _owner;\n', ' \n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', ' \n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor () internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', ' \n', '    /**\n', '     * @return the address of the owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', ' \n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner());\n', '        _;\n', '    }\n', ' \n', '    /**\n', '     * @return true if `msg.sender` is the owner of the contract.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', ' \n', '    /**\n', '     * @dev Allows the current owner to relinquish control of the contract.\n', '     * @notice Renouncing to ownership will leave the contract without an owner.\n', '     * It will not be possible to call the functions with the `onlyOwner`\n', '     * modifier anymore.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', ' \n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', ' \n', '    /**\n', '     * @dev Transfers control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', ' \n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', ' \n', '    function balanceOf(address who) external view returns (uint256);\n', ' \n', '    function allowance(address owner, address spender) external view returns (uint256);\n', ' \n', '    function transfer(address to, uint256 value) external returns (bool);\n', ' \n', '    function approve(address spender, uint256 value) external returns (bool);\n', ' \n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', ' \n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', ' \n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', ' \n', '/**\n', ' * @title Helps contracts guard against reentrancy attacks.\n', ' * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>\n', ' * @dev If you mark a function `nonReentrant`, you should also\n', ' * mark it `external`.\n', ' */\n', 'contract ReentrancyGuard {\n', '    /// @dev counter to allow mutex lock with only one SSTORE operation\n', '    uint256 private _guardCounter;\n', ' \n', '    constructor () internal {\n', '        // The counter starts at one to prevent changing it from zero to a non-zero\n', '        // value, which is a more expensive operation.\n', '        _guardCounter = 1;\n', '    }\n', ' \n', '    /**\n', '     * @dev Prevents a contract from calling itself, directly or indirectly.\n', '     * Calling a `nonReentrant` function from another `nonReentrant`\n', '     * function is not supported. It is possible to prevent this from happening\n', '     * by making the `nonReentrant` function external, and make it call a\n', '     * `private` function that does the actual work.\n', '     */\n', '    modifier nonReentrant() {\n', '        _guardCounter += 1;\n', '        uint256 localCounter = _guardCounter;\n', '        _;\n', '        require(localCounter == _guardCounter);\n', '    }\n', '}\n', ' \n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '    event Paused(address account);\n', '    event Unpaused(address account);\n', ' \n', '    bool private _paused;\n', ' \n', '    constructor () internal {\n', '        _paused = false;\n', '    }\n', ' \n', '    /**\n', '     * @return True if the contract is paused, false otherwise.\n', '     */\n', '    function paused() public view returns (bool) {\n', '        return _paused;\n', '    }\n', ' \n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!_paused);\n', '        _;\n', '    }\n', ' \n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(_paused);\n', '        _;\n', '    }\n', ' \n', '    /**\n', '     * @dev Called by a pauser to pause, triggers stopped state.\n', '     */\n', '    function pause() public onlyOwner whenNotPaused {\n', '        _paused = true;\n', '        emit Paused(msg.sender);\n', '    }\n', ' \n', '    /**\n', '     * @dev Called by a pauser to unpause, returns to normal state.\n', '     */\n', '    function unpause() public onlyOwner whenPaused {\n', '        _paused = false;\n', '        emit Unpaused(msg.sender);\n', '    }\n', '}\n', ' \n', '/**\n', ' * @title ERACoin\n', ' * @dev ERC20 Token \n', ' */\n', 'contract ERACoin is IERC20, Ownable, ReentrancyGuard, Pausable  {\n', '   using SafeMath for uint256;\n', '   \n', '    mapping (address => uint256) private _balances;\n', ' \n', '    mapping (address => mapping (address => uint256)) private _allowed;\n', ' \n', '    uint256 private _totalSupply;\n', '    \n', '    /**\n', '    * @dev Total number of tokens in existence\n', '    */\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', ' \n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param owner The address to query the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address owner) public view returns (uint256) {\n', '        return _balances[owner];\n', '    }\n', '    \n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param owner address The address which owns the funds.\n', '     * @param spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address owner, address spender) public view returns (uint256) {\n', '        return _allowed[owner][spender];\n', '    }\n', ' \n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param spender The address which will spend the funds.\n', '     * @param value The amount of tokens to be spent.\n', '     */\n', '    function approve(address spender, uint256 value) public whenNotPaused returns (bool) {\n', '        require(spender != address(0));\n', '        _allowed[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', ' \n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when allowed_[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * Emits an Approval event.\n', '     * @param spender The address which will spend the funds.\n', '     * @param addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {\n', '        require(spender != address(0));\n', '        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);\n', '        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '        return true;\n', '    }\n', ' \n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when allowed_[_spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * Emits an Approval event.\n', '     * @param spender The address which will spend the funds.\n', '     * @param subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {\n', '        require(spender != address(0));\n', '        \n', '        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);\n', '        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '        return true;\n', '    }\n', ' \n', '    /**\n', '    * @dev Transfer token for a specified addresses\n', '    * @param from The address to transfer from.\n', '    * @param to The address to transfer to.\n', '    * @param value The amount to be transferred.\n', '    */\n', '    function _transfer(address from, address to, uint256 value) internal {\n', '        require(to != address(0));\n', ' \n', '        _balances[from] = _balances[from].sub(value);\n', '        _balances[to] = _balances[to].add(value);\n', '        emit Transfer(from, to, value);\n', '    }\n', ' \n', '    /**\n', '     * @dev Internal function that mints an amount of the token and assigns it to\n', '     * an account. This encapsulates the modification of balances such that the\n', '     * proper events are emitted.\n', '     * @param account The account that will receive the created tokens.\n', '     * @param value The amount that will be created.\n', '     */\n', '    function _mint(address account, uint256 value) internal {\n', '        require(account != address(0));\n', ' \n', '        _totalSupply = _totalSupply.add(value);\n', '        _balances[account] = _balances[account].add(value);\n', '        emit Transfer(address(0), account, value);\n', '    }\n', ' \n', '    /**\n', '     * @dev Internal function that burns an amount of the token of a given\n', '     * account.\n', '     * @param account The account whose tokens will be burnt.\n', '     * @param value The amount that will be burnt.\n', '     */\n', '    function _burn(address account, uint256 value) internal {\n', '        require(account != address(0));\n', '        _totalSupply = _totalSupply.sub(value);\n', '        _balances[account] = _balances[account].sub(value);\n', '        emit Transfer(account, address(0), value);\n', '    }\n', ' \n', '    /**\n', '     * @dev Internal function that burns an amount of the token of a given\n', "     * account, deducting from the sender's allowance for said account. Uses the\n", '     * internal burn function.\n', '     * Emits an Approval event (reflecting the reduced allowance).\n', '     * @param account The account whose tokens will be burnt.\n', '     * @param value The amount that will be burnt.\n', '     */\n', '    function _burnFrom(address account, uint256 value) internal {\n', '        _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);\n', '        _burn(account, value);\n', '        emit Approval(account, msg.sender, _allowed[account][msg.sender]);\n', '    }\n', ' \n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '    uint256 private _initSupply;\n', '    \n', '    constructor (string memory name, string memory symbol, uint8 decimals, uint256 initSupply) public {\n', '        _name = name;\n', '        _symbol = symbol;\n', '        _decimals = decimals;\n', '        _initSupply = initSupply.mul(10 **uint256(decimals));\n', '        _mint(msg.sender, _initSupply);\n', '    }\n', ' \n', '    /**\n', '     * @return the name of the token.\n', '     */\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', ' \n', '    /**\n', '     * @return the symbol of the token.\n', '     */\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', ' \n', '    /**\n', '     * @return the number of decimals of the token.\n', '     */\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '    \n', '    /**\n', '     * @return the initial Supply of the token.\n', '     */\n', '    function initSupply() public view returns (uint256) {\n', '        return _initSupply;\n', '    }\n', '   \n', '   mapping (address => bool) status; \n', '   \n', '   \n', '   // Address bounty Admin\n', '    address private _walletAdmin; \n', '   // Address where funds can be collected\n', '    address payable _walletBase90;\n', '    // Address where funds can be collected too\n', '    address payable _walletF5;\n', '    // Address where funds can be collected too\n', '    address payable _walletS5;\n', '    // How many token units a buyer gets per wei.\n', '    // The rate is the conversion between wei and the smallest and indivisible token unit.\n', '    // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK\n', '    // 1 wei will give you 1 unit, or 0.001 TOK.\n', '    uint256 private _rate;\n', '    // _rate share index\n', '    uint256 private _y;\n', '    // Amount of wei raised\n', '    uint256 private _weiRaised;\n', '    // Min token*s qty required to buy  \n', '    uint256 private _MinTokenQty;\n', '    // Max token*s qty is available for transfer by bounty Admin \n', '    uint256 private _MaxTokenAdminQty;\n', '    \n', '   /**\n', '     * @dev Function to mint tokens\n', '     * @param to The address that will receive the minted tokens.\n', '     * @param value The amount of tokens to mint.\n', '     * @return A boolean that indicates if the operation was successful.\n', '     */\n', '    function mint(address to, uint256 value) public onlyOwner returns (bool) {\n', '        _mint(to, value);\n', '        return true;\n', '    }\n', '    \n', '   /**\n', '     * @dev Function to burn tokens\n', '     * @param to The address to burn tokens.\n', '     * @param value The amount of tokens to burn.\n', '     * @return A boolean that indicates if the operation was successful.\n', '     */\n', '    function burn(address to, uint256 value) public onlyOwner returns (bool) {\n', '        _burn(to, value);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '    * @dev Transfer token for a specified address.onlyOwner\n', '    * @param to The address to transfer to.\n', '    * @param value The amount to be transferred.\n', '    */\n', '    function transferOwner(address to, uint256 value) public onlyOwner returns (bool) {\n', '      \n', '        _transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '    * @dev Transfer token for a specified address\n', '    * @param to The address to transfer to.\n', '    * @param value The amount to be transferred.\n', '    */\n', '    function transfer(address to, uint256 value) public whenNotPaused returns (bool) {\n', '      \n', '        _transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * @dev Transfer tokens from one address to another.\n', '     * Note that while this function emits an Approval event, this is not required as per the specification,\n', '     * and other compliant implementations may not emit the event.\n', '     * @param from address The address which you want to send tokens from\n', '     * @param to address The address which you want to transfer to\n', '     * @param value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {\n', '      \n', '        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '        _transfer(from, to, value);\n', '        emit Approval(from, msg.sender, _allowed[from][msg.sender]);\n', '        return true;\n', '    }\n', '     \n', '   /**\n', "     * @dev check an account's status\n", '     * @return bool\n', '     */\n', '    function CheckStatus(address account) public view returns (bool) {\n', '        require(account != address(0));\n', '        bool currentStatus = status[account];\n', '        return currentStatus;\n', '    }\n', '    \n', '    /**\n', "     * @dev change an account's status. OnlyOwner\n", '     * @return bool\n', '     */\n', '    function ChangeStatus(address account) public  onlyOwner {\n', '        require(account != address(0));\n', '        bool currentStatus1 = status[account];\n', '       status[account] = (currentStatus1 == true) ? false : true;\n', '    }\n', ' \n', '   /**\n', '     * @dev fallback function ***DO NOT OVERRIDE***\n', '     * Note that other contracts will transfer fund with a base gas stipend\n', '     * of 2300, which is not enough to call buyTokens. Consider calling\n', '     * buyTokens directly when purchasing tokens from a contract.\n', '     */\n', '    function () external payable {\n', '        buyTokens(msg.sender, msg.value);\n', '        }\n', '        \n', '    function buyTokens(address beneficiary, uint256 weiAmount) public nonReentrant payable {\n', '        require(beneficiary != address(0) && beneficiary !=_walletBase90 && beneficiary !=_walletF5 && beneficiary !=_walletS5);\n', '        require(weiAmount > 0);\n', '        address _walletTokenSale = owner();\n', '        require(_walletTokenSale != address(0));\n', '        require(_walletBase90 != address(0));\n', '        require(_walletF5 != address(0));\n', '        require(_walletS5 != address(0));\n', '        require(CheckStatus(beneficiary) != true);\n', '        // calculate token amount to be created\n', '        uint256 tokens = weiAmount.div(_y).mul(_rate);\n', '        // update min token amount to be buy by beneficiary\n', '        uint256 currentMinQty = MinTokenQty();\n', '        // check token amount to be transfered from _wallet\n', '        require(balanceOf(_walletTokenSale) > tokens);\n', '        // check token amount to be buy by beneficiary\n', '        require(tokens >= currentMinQty);\n', '        // update state\n', '        _weiRaised = _weiRaised.add(weiAmount);\n', '        // transfer tokens to beneficiary from CurrentFundWallet\n', '       _transfer(_walletTokenSale, beneficiary, tokens);\n', '       // transfer 90% weiAmount to _walletBase90\n', '       _walletBase90.transfer(weiAmount.div(100).mul(90));\n', '       // transfer 5% weiAmount to _walletF5\n', '       _walletF5.transfer(weiAmount.div(100).mul(5));\n', '       // transfer 5% weiAmount to _walletS5\n', '       _walletS5.transfer(weiAmount.div(100).mul(5));\n', '    }\n', '  \n', '    /**\n', '     * Set Rate. onlyOwner\n', '     */\n', '    function setRate(uint256 rate) public onlyOwner  {\n', '        require(rate >= 1);\n', '        _rate = rate;\n', '    }\n', '   \n', '    /**\n', '     * Set Y. onlyOwner\n', '     */\n', '    function setY(uint256 y) public onlyOwner  {\n', '        require(y >= 1);\n', '        _y = y;\n', '    }\n', '    \n', '    /**\n', '     * Set together the _walletBase90,_walletF5,_walletS5. onlyOwner\n', '     */\n', '    function setFundWallets(address payable B90Wallet,address payable F5Wallet,address payable S5Wallet) public onlyOwner  {\n', '        _walletBase90 = B90Wallet;\n', '         _walletF5 = F5Wallet;\n', '         _walletS5 = S5Wallet;\n', '    } \n', '    \n', '    /**\n', '     * Set the _walletBase90. onlyOwner\n', '     */\n', '    function setWalletB90(address payable B90Wallet) public onlyOwner  {\n', '        _walletBase90 = B90Wallet;\n', '    } \n', '    \n', '    /**\n', '     * @return the _walletBase90.\n', '     */\n', '    function WalletBase90() public view returns (address) {\n', '        return _walletBase90;\n', '    }\n', '    \n', '    /**\n', '     * Set the _walletF5. onlyOwner\n', '     */\n', '    function setWalletF5(address payable F5Wallet) public onlyOwner  {\n', '        _walletF5 = F5Wallet;\n', '    } \n', '    \n', '    /**\n', '     * @return the _walletF5.\n', '     */\n', '    function WalletF5() public view returns (address) {\n', '        return _walletF5;\n', '    }\n', '    \n', '     /**\n', '     * Set the _walletS5. onlyOwner\n', '     */\n', '    function setWalletS5(address payable S5Wallet) public onlyOwner  {\n', '        _walletS5 = S5Wallet;\n', '    } \n', '    \n', '    /**\n', '     * @return the _walletS5.\n', '     */\n', '    function WalletS5() public view returns (address) {\n', '        return _walletS5;\n', '    }\n', '    \n', '    /**\n', '     * Set the _walletTokenSale. onlyOwner\n', '     */\n', '    function setWalletAdmin(address WalletAdmin) public onlyOwner  {\n', '        _walletAdmin = WalletAdmin;\n', '    } \n', '    \n', '     /**\n', '     * @return the _walletTokenSale.\n', '     */\n', '    function WalletAdmin() public view returns (address) {\n', '        return _walletAdmin;\n', '    }\n', '    \n', '    /**\n', '     * @dev Throws if called by any account other than the admin.\n', '     */\n', '    modifier onlyAdmin() {\n', '        require(isAdmin());\n', '        _;\n', '    }\n', ' \n', '    /**\n', '     * @return true if `msg.sender` is the admin of the contract.\n', '     */\n', '    function isAdmin() public view returns (bool) {\n', '        return msg.sender == _walletAdmin;\n', '    }\n', ' \n', '    /**\n', '    * @dev Transfer token for a specified address.onlyOwner\n', '    * @param to The address to transfer to.\n', '    * @param value The amount to be transferred.\n', '    */\n', '    function transferAdmin(address to, uint256 value) public onlyAdmin returns (bool) {\n', '        require(value <= MaxTokenAdminQty());\n', '        _transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * Set the _MinTokenQty. onlyOwner\n', '     */\n', '    function setMinTokenQty(uint256 MinTokenQty) public onlyOwner  {\n', '        _MinTokenQty = MinTokenQty;\n', '    } \n', '    \n', '    /**\n', '     * Set the _MinTokenQty. onlyOwner\n', '     */\n', '    function setMaxTokenAdminQty(uint256 MaxTokenAdminQty) public onlyOwner  {\n', '        _MaxTokenAdminQty = MaxTokenAdminQty;\n', '    } \n', '    \n', '    /**\n', '     * @return Rate.\n', '     */\n', '    function Rate() public view returns (uint256) {\n', '        return _rate;\n', '    }\n', '   \n', '    /**\n', '     * @return _Y.\n', '     */\n', '    function Y() public view returns (uint256) {\n', '        return _y;\n', '    }\n', '    \n', '    /**\n', '     * @return the number of wei income Total.\n', '     */\n', '    function WeiRaised() public view returns (uint256) {\n', '        return _weiRaised;\n', '    }\n', '    \n', '    /**\n', '     * @return _MinTokenQty.\n', '     */\n', '    function MinTokenQty() public view returns (uint256) {\n', '        return _MinTokenQty;\n', '    }\n', '    \n', '     /**\n', '     * @return _MinTokenQty.\n', '     */\n', '    function MaxTokenAdminQty() public view returns (uint256) {\n', '        return _MaxTokenAdminQty;\n', '    }\n', '    \n', '}']