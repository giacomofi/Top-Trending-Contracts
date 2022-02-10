['pragma solidity ^0.5.7;\n', '\n', '\n', '// Vision.Network 100G Token -- is called "Voken" (upgraded)\n', '// \n', '// More info:\n', '//   https://vision.network\n', '//   https://voken.io\n', '//\n', '// Contact us:\n', '//   support@vision.network\n', '//   support@voken.io\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Unsigned math operations with safety checks that revert on error.\n', ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Adds two unsigned integers, reverts on overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Multiplies two unsigned integers, reverts on overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Integer division of two unsigned integers truncating the quotient,\n', '     * reverts on division by zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b > 0);\n', '        uint256 c = a / b;\n', '        assert(a == b * c + a % b);\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '     * reverts when dividing by zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://eips.ethereum.org/EIPS/eip-20\n', ' */\n', 'interface IERC20{\n', '    function name() external view returns (string memory);\n', '    function symbol() external view returns (string memory);\n', '    function decimals() external view returns (uint8);\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address owner) external view returns (uint256);\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' */\n', 'contract Ownable {\n', '    address internal _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract\n', '     * to the sender account.\n', '     */\n', '    constructor () internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @return the address of the owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == _owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) external onlyOwner {\n', '        require(newOwner != address(0));\n', '        _owner = newOwner;\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Rescue compatible ERC20 Token\n', '     *\n', '     * @param tokenAddr ERC20 The address of the ERC20 token contract\n', '     * @param receiver The address of the receiver\n', '     * @param amount uint256\n', '     */\n', '    function rescueTokens(address tokenAddr, address receiver, uint256 amount) external onlyOwner {\n', '        IERC20 _token = IERC20(tokenAddr);\n', '        require(receiver != address(0));\n', '        uint256 balance = _token.balanceOf(address(this));\n', '        \n', '        require(balance >= amount);\n', '        assert(_token.transfer(receiver, amount));\n', '    }\n', '\n', '    /**\n', '     * @dev Withdraw Ether\n', '     */\n', '    function withdrawEther(address payable to, uint256 amount) external onlyOwner {\n', '        require(to != address(0));\n', '        \n', '        uint256 balance = address(this).balance;\n', '        \n', '        require(balance >= amount);\n', '        to.transfer(amount);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '    bool private _paused;\n', '\n', '    event Paused(address account);\n', '    event Unpaused(address account);\n', '\n', '    constructor () internal {\n', '        _paused = false;\n', '    }\n', '\n', '    /**\n', '     * @return Returns true if the contract is paused, false otherwise.\n', '     */\n', '    function paused() public view returns (bool) {\n', '        return _paused;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!_paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(_paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Called by a pauser to pause, triggers stopped state.\n', '     */\n', '    function pause() external onlyOwner whenNotPaused {\n', '        _paused = true;\n', '        emit Paused(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @dev Called by a pauser to unpause, returns to normal state.\n', '     */\n', '    function unpause() external onlyOwner whenPaused {\n', '        _paused = false;\n', '        emit Unpaused(msg.sender);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Voken Main Contract\n', ' */\n', 'contract Voken is Ownable, Pausable, IERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    string private _name = "Vision.Network 100G Token";\n', '    string private _symbol = "Voken";\n', '    uint8 private _decimals = 6;                // 6 decimals\n', '    uint256 private _cap = 35000000000000000;   // 35 billion cap, that is 35000000000.000000\n', '    uint256 private _totalSupply;\n', '    \n', '    mapping (address => bool) private _minter;\n', '    event Mint(address indexed to, uint256 value);\n', '    event MinterChanged(address account, bool state);\n', '\n', '    mapping (address => uint256) private _balances;\n', '    mapping (address => mapping (address => uint256)) private _allowed;\n', '\n', '    bool private _allowWhitelistRegistration;\n', '    mapping(address => address) private _referrer;\n', '    mapping(address => uint256) private _refCount;\n', '\n', '    event VokenSaleWhitelistRegistered(address indexed addr, address indexed refAddr);\n', '    event VokenSaleWhitelistTransferred(address indexed previousAddr, address indexed _newAddr);\n', '    event VokenSaleWhitelistRegistrationEnabled();\n', '    event VokenSaleWhitelistRegistrationDisabled();\n', '\n', '    uint256 private _whitelistRegistrationValue = 1001000000;   // 1001 Voken, 1001.000000\n', '    uint256[15] private _whitelistRefRewards = [                // 100% Reward\n', '        301000000,  // 301 Voken for Level.1\n', '        200000000,  // 200 Voken for Level.2\n', '        100000000,  // 100 Voken for Level.3\n', '        100000000,  // 100 Voken for Level.4\n', '        100000000,  // 100 Voken for Level.5\n', '        50000000,   //  50 Voken for Level.6\n', '        40000000,   //  40 Voken for Level.7\n', '        30000000,   //  30 Voken for Level.8\n', '        20000000,   //  20 Voken for Level.9\n', '        10000000,   //  10 Voken for Level.10\n', '        10000000,   //  10 Voken for Level.11\n', '        10000000,   //  10 Voken for Level.12\n', '        10000000,   //  10 Voken for Level.13\n', '        10000000,   //  10 Voken for Level.14\n', '        10000000    //  10 Voken for Level.15\n', '    ];\n', '\n', '    event Donate(address indexed account, uint256 amount);\n', '\n', '\n', '    /**\n', '     * @dev Constructor\n', '     */\n', '    constructor() public {\n', '        _minter[msg.sender] = true;\n', '        _allowWhitelistRegistration = true;\n', '\n', '        emit VokenSaleWhitelistRegistrationEnabled();\n', '\n', '        _referrer[msg.sender] = msg.sender;\n', '        emit VokenSaleWhitelistRegistered(msg.sender, msg.sender);\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev donate\n', '     */\n', '    function () external payable {\n', '        emit Donate(msg.sender, msg.value);\n', '    }\n', '\n', '\n', '    /**\n', '     * @return the name of the token.\n', '     */\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    /**\n', '     * @return the symbol of the token.\n', '     */\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    /**\n', '     * @return the number of decimals of the token.\n', '     */\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '\n', '    /**\n', '     * @return the cap for the token minting.\n', '     */\n', '    function cap() public view returns (uint256) {\n', '        return _cap;\n', '    }\n', '    \n', '    /**\n', '     * @dev Total number of tokens in existence.\n', '     */\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the balance of the specified address.\n', '     * @param owner The address to query the balance of.\n', '     * @return A uint256 representing the amount owned by the passed address.\n', '     */\n', '    function balanceOf(address owner) public view returns (uint256) {\n', '        return _balances[owner];\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param owner address The address which owns the funds.\n', '     * @param spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address owner, address spender) public view returns (uint256) {\n', '        return _allowed[owner][spender];\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer token to a specified address.\n', '     * @param to The address to transfer to.\n', '     * @param value The amount to be transferred.\n', '     */\n', '    function transfer(address to, uint256 value) public whenNotPaused returns (bool) {\n', '        if (_allowWhitelistRegistration && value == _whitelistRegistrationValue\n', '            && inWhitelist(to) && !inWhitelist(msg.sender) && isNotContract(msg.sender)) {\n', '            // Register whitelist for Voken-Sale\n', '            _regWhitelist(msg.sender, to);\n', '            return true;\n', '        } else {\n', '            // Normal Transfer\n', '            _transfer(msg.sender, to, value);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     * @param spender The address which will spend the funds.\n', '     * @param value The amount of tokens to be spent.\n', '     */\n', '    function approve(address spender, uint256 value) public returns (bool) {\n', '        _approve(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     * @param spender The address which will spend the funds.\n', '     * @param addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '        _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     * @param spender The address which will spend the funds.\n', '     * @param subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '        _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));\n', '        return true;\n', '    }\n', '    /**\n', '     * @dev Transfer tokens from one address to another.\n', '     * @param from address The address which you want to send tokens from\n', '     * @param to address The address which you want to transfer to\n', '     * @param value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {\n', '        require(_allowed[from][msg.sender] >= value);\n', '        _transfer(from, to, value);\n', '        _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer token for a specified addresses.\n', '     * @param from The address to transfer from.\n', '     * @param to The address to transfer to.\n', '     * @param value The amount to be transferred.\n', '     */\n', '    function _transfer(address from, address to, uint256 value) internal {\n', '        require(to != address(0));\n', '\n', '        _balances[from] = _balances[from].sub(value);\n', '        _balances[to] = _balances[to].add(value);\n', '        emit Transfer(from, to, value);\n', '    }\n', '\n', '    /**\n', "     * @dev Approve an address to spend another addresses' tokens.\n", '     * @param owner The address that owns the tokens.\n', '     * @param spender The address that will spend the tokens.\n', '     * @param value The number of tokens that can be spent.\n', '     */\n', '    function _approve(address owner, address spender, uint256 value) internal {\n', '        require(owner != address(0));\n', '        require(spender != address(0));\n', '\n', '        _allowed[owner][spender] = value;\n', '        emit Approval(owner, spender, value);\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Throws if called by account not a minter.\n', '     */\n', '    modifier onlyMinter() {\n', '        require(_minter[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the given account is minter.\n', '     */\n', '    function isMinter(address account) public view returns (bool) {\n', '        return _minter[account];\n', '    }\n', '\n', '    /**\n', '     * @dev Set a minter state\n', '     */\n', '    function setMinterState(address account, bool state) external onlyOwner {\n', '        _minter[account] = state;\n', '        emit MinterChanged(account, state);\n', '    }\n', '\n', '    /**\n', '     * @dev Function to mint tokens\n', '     * @param to The address that will receive the minted tokens.\n', '     * @param value The amount of tokens to mint.\n', '     * @return A boolean that indicates if the operation was successful.\n', '     */\n', '    function mint(address to, uint256 value) public onlyMinter returns (bool) {\n', '        _mint(to, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function that mints an amount of the token and assigns it to an account.\n', '     * @param account The account that will receive the created tokens.\n', '     * @param value The amount that will be created.\n', '     */\n', '    function _mint(address account, uint256 value) internal {\n', '        require(_totalSupply.add(value) <= _cap);\n', '        require(account != address(0));\n', '\n', '        _totalSupply = _totalSupply.add(value);\n', '        _balances[account] = _balances[account].add(value);\n', '        emit Mint(account, value);\n', '        emit Transfer(address(0), account, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by account not in whitelist.\n', '     */\n', '    modifier onlyInWhitelist() {\n', '        require(_referrer[msg.sender] != address(0));\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the whitelist registration is allowed.\n', '     */\n', '    function allowWhitelistRegistration() public view returns (bool) {\n', '        return _allowWhitelistRegistration;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the given account is in whitelist.\n', '     */\n', '    function inWhitelist(address account) public view returns (bool) {\n', '        return _referrer[account] != address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the referrer of a given account address\n', '     */\n', '    function referrer(address account) public view returns (address) {\n', '        return _referrer[account];\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the referrals count of a given account address\n', '     */\n', '    function refCount(address account) public view returns (uint256) {\n', '        return _refCount[account];\n', '    }\n', '\n', '    /**\n', '     * @dev Disable Voken-Sale whitelist registration. Unrecoverable!\n', '     */\n', '    function disableVokenSaleWhitelistRegistration() external onlyOwner {\n', '        _allowWhitelistRegistration = false;\n', '        emit VokenSaleWhitelistRegistrationDisabled();\n', '    }\n', '\n', '    /**\n', '     * @dev Register whitelist for Voken-Sale\n', '     */\n', '    function _regWhitelist(address account, address refAccount) internal {\n', '        _refCount[refAccount] = _refCount[refAccount].add(1);\n', '        _referrer[account] = refAccount;\n', '\n', '        emit VokenSaleWhitelistRegistered(account, refAccount);\n', '\n', '        // Whitelist Registration Referral Reward\n', '        _transfer(msg.sender, address(this), _whitelistRegistrationValue);\n', '        address cursor = account;\n', '        uint256 remain = _whitelistRegistrationValue;\n', '        for(uint i = 0; i < _whitelistRefRewards.length; i++) {\n', '            address receiver = _referrer[cursor];\n', '\n', '            if (cursor != receiver) {\n', '                if (_refCount[receiver] > i) {\n', '                    _transfer(address(this), receiver, _whitelistRefRewards[i]);\n', '                    remain = remain.sub(_whitelistRefRewards[i]);\n', '                }\n', '            } else {\n', '                _transfer(address(this), refAccount, remain);\n', '                break;\n', '            }\n', '\n', '            cursor = _referrer[cursor];\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer the whitelisted address to another.\n', '     */\n', '    function transferWhitelist(address account) external onlyInWhitelist {\n', '        require(isNotContract(account));\n', '\n', '        _refCount[account] = _refCount[msg.sender];\n', '        _refCount[msg.sender] = 0;\n', '        _referrer[account] = _referrer[msg.sender];\n', '        _referrer[msg.sender] = address(0);\n', '        emit VokenSaleWhitelistTransferred(msg.sender, account);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the given address is not a contract\n', '     */\n', '    function isNotContract(address addr) internal view returns (bool) {\n', '        uint size;\n', '        assembly {\n', '            size := extcodesize(addr)\n', '        }\n', '        return size == 0;\n', '    }\n', '\n', '    /**\n', '     * @dev Calculator\n', '     * Returns the reward amount if someone now registers the whitelist directly with the given whitelistedAccount.\n', '     */\n', '    function calculateTheRewardOfDirectWhitelistRegistration(address whitelistedAccount) external view returns (uint256 reward) {\n', '        if (!inWhitelist(whitelistedAccount)) {\n', '            return 0;\n', '        }\n', '\n', '        address cursor = whitelistedAccount;\n', '        uint256 remain = _whitelistRegistrationValue;\n', '        for(uint i = 1; i < _whitelistRefRewards.length; i++) {\n', '            address receiver = _referrer[cursor];\n', '\n', '            if (cursor != receiver) {\n', '                if (_refCount[receiver] > i) {\n', '                    remain = remain.sub(_whitelistRefRewards[i]);\n', '                }\n', '            } else {\n', '                reward = reward.add(remain);\n', '                break;\n', '            }\n', '\n', '            cursor = _referrer[cursor];\n', '        }\n', '\n', '        return reward;\n', '    }\n', '}']