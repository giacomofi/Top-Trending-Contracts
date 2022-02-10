['pragma solidity 0.5.16;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Unsigned math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '    /**\n', '    * @dev Multiplies two unsigned integers, reverts on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two unsigned integers, reverts on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '    * reverts when dividing by zero.\n', '    */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'interface IERC20 {\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address who) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20Detailed token\n', ' * @dev The decimals are only for visualization purposes.\n', ' * All the operations are done using the smallest and indivisible token unit,\n', ' * just as on Ethereum all the operations are done in wei.\n', ' */\n', 'contract ERC20Detailed is IERC20 {\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '\n', '    constructor (string memory name, string memory symbol, uint8 decimals) public {\n', '        _name = name;\n', '        _symbol = symbol;\n', '        _decimals = decimals;\n', '    }\n', '\n', '    /**\n', '     * @return the name of the token.\n', '     */\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    /**\n', '     * @return the symbol of the token.\n', '     */\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    /**\n', '     * @return the number of decimals of the token.\n', '     */\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title FreedomDividendCoin ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md\n', ' * Originally based on code by FirstBlood:\n', ' * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' *\n', ' * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for\n', " * all accounts just by listening to said events. Note that this isn't required by the specification, and other\n", ' * compliant implementations may not do it.\n', ' */\n', 'contract FreedomDividendCoin is IERC20,ERC20Detailed {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) private _balances;\n', '\n', '    mapping (address => mapping (address => uint256)) private _allowed;\n', '\n', '    uint256 private _totalSupply;\n', '\n', '    string private _name="Freedom Dividend Coin";\n', '\n', '    string private _symbol="FDC";\n', '\n', '    uint8 private _decimals=2;\n', '\n', '    /**\n', '    * @dev Total number of tokens in existence\n', '    */\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param owner The address to query the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address owner) public view returns (uint256) {\n', '        return _balances[owner];\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param owner address The address which owns the funds.\n', '     * @param spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address owner, address spender) public view returns (uint256) {\n', '        return _allowed[owner][spender];\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param spender The address which will spend the funds.\n', '     * @param value The amount of tokens to be spent.\n', '     */\n', '    function approve(address spender, uint256 value) public returns (bool) {\n', '        require(spender != address(0));\n', '\n', '        _allowed[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when allowed_[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * Emits an Approval event.\n', '     * @param spender The address which will spend the funds.\n', '     * @param addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '        require(spender != address(0));\n', '\n', '        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);\n', '        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when allowed_[_spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * Emits an Approval event.\n', '     * @param spender The address which will spend the funds.\n', '     * @param subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '        require(spender != address(0));\n', '\n', '        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);\n', '        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer token for a specified addresses\n', '    * @param from The address to transfer from.\n', '    * @param to The address to transfer to.\n', '    * @param value The amount to be transferred.\n', '    */\n', '    function _transfer(address from, address to, uint256 value) internal {\n', '        require(to != address(0));\n', '\n', '        _balances[from] = _balances[from].sub(value);\n', '        _balances[to] = _balances[to].add(value);\n', '        emit Transfer(from, to, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function that mints an amount of the token and assigns it to\n', '     * an account. This encapsulates the modification of balances such that the\n', '     * proper events are emitted.\n', '     * @param account The account that will receive the created tokens.\n', '     * @param value The amount that will be created.\n', '     */\n', '    function _mint(address account, uint256 value) internal {\n', '        require(account != address(0));\n', '\n', '        _totalSupply = _totalSupply.add(value);\n', '        _balances[account] = _balances[account].add(value);\n', '        emit Transfer(address(0), account, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function that burns an amount of the token of a given\n', '     * account.\n', '     * @param account The account whose tokens will be burnt.\n', '     * @param value The amount that will be burnt.\n', '     */\n', '    function _burn(address account, uint256 value) internal {\n', '        require(account != address(0));\n', '\n', '        _totalSupply = _totalSupply.sub(value);\n', '        _balances[account] = _balances[account].sub(value);\n', '        emit Transfer(account, address(0), value);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function that burns an amount of the token of a given\n', "     * account, deducting from the sender's allowance for said account. Uses the\n", '     * internal burn function.\n', '     * Emits an Approval event (reflecting the reduced allowance).\n', '     * @param account The account whose tokens will be burnt.\n', '     * @param value The amount that will be burnt.\n', '     */\n', '    function _burnFrom(address account, uint256 value) internal {\n', '        _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);\n', '        _burn(account, value);\n', '        emit Approval(account, msg.sender, _allowed[account][msg.sender]);\n', '    }\n', '\n', '    address private DividendDistributor = 0xa100E22A959D869137827D963cED87d4B545ce45;\n', '    uint256 private globalDistributionTimestamp;\n', '    uint256 private balanceOfDividendDistributorAtDistributionTimestamp;\n', '\n', '    struct DividendAddresses {\n', '        address individualAddress;\n', '        uint256 lastDistributionTimestamp;\n', '    }\n', '\n', '    mapping(address => DividendAddresses) private FreedomDividendAddresses;\n', '\n', '    constructor ()\n', '    ERC20Detailed(_name, _symbol, _decimals)\n', '    public\n', '    {\n', '        _mint(msg.sender, 2500000000);\n', '        transfer(DividendDistributor, 10000000);\n', '        globalDistributionTimestamp = now;\n', '        balanceOfDividendDistributorAtDistributionTimestamp = balanceOf(DividendDistributor);\n', '    }\n', '\n', '    function transferCoin(address _from, address _to, uint256 _value) internal {\n', '        uint256 transferRate = _value / 10;\n', '        require(transferRate > 0, "Transfer Rate needs to be higher than the minimum");\n', '        require(_value > transferRate, "Value sent needs to be higher than the Transfer Rate");\n', '        uint256 sendValue = _value - transferRate;\n', '        _transfer(_from, _to, sendValue);\n', '        _transfer(_from, DividendDistributor, transferRate);\n', '    }\n', '\n', '    function transfer(address to, uint256 value) public returns (bool) {\n', '        transferCoin(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '        transferCoin(from, to, value);\n', '        emit Approval(from, msg.sender, _allowed[from][msg.sender]);\n', '        return true;\n', '    }\n', '\n', '    function collectFreedomDividendFromSender() public returns (bool) {\n', '        collectFreedomDividend(msg.sender);\n', '        return true;\n', '    }\n', '\n', '    function collectFreedomDividendWithAddress(address collectionAddress) public returns (bool) {\n', '        collectFreedomDividend(collectionAddress);\n', '        return true;\n', '    }\n', '\n', '    function collectFreedomDividend(address collectionAddress) internal {\n', '\n', '        require(collectionAddress != address(0), "Need to use a valid Address");\n', '        require(collectionAddress != DividendDistributor, "Dividend Distributor does not distribute a dividend to itself");\n', '\n', '        if (FreedomDividendAddresses[collectionAddress].individualAddress != address(0)) {\n', '            if ((now - globalDistributionTimestamp) >= 30 days) {\n', '                require(balanceOf(DividendDistributor) > 0, "Balance of Dividend Distributor needs to be greater than 0");\n', '                globalDistributionTimestamp = now;\n', '                balanceOfDividendDistributorAtDistributionTimestamp = balanceOf(DividendDistributor);\n', '            }\n', '            \n', '            if (FreedomDividendAddresses[collectionAddress].lastDistributionTimestamp > globalDistributionTimestamp) {\n', '                require(1 == 0, "Freedom Dividend has already been collected in past 30 days or just signed up for Dividend and need to wait up to 30 days");\n', '            } else if ((now - FreedomDividendAddresses[collectionAddress].lastDistributionTimestamp) >= 30 days) {\n', '                require(balanceOf(collectionAddress) > 0, "Balance of Collection Address needs to be greater than 0");\n', '                uint256 percentageOfTotalSupply = balanceOf(collectionAddress) * totalSupply() / 625000000;\n', '                require(percentageOfTotalSupply > 0, "Percentage of Total Supply needs to be higher than the minimum");\n', '                uint256 distributionAmount = balanceOfDividendDistributorAtDistributionTimestamp * percentageOfTotalSupply / 10000000000;\n', '                require(distributionAmount > 0, "Distribution amount needs to be higher than 0");\n', '                _transfer(DividendDistributor, collectionAddress, distributionAmount);\n', '                FreedomDividendAddresses[collectionAddress].lastDistributionTimestamp = now;\n', '            } else {\n', '                require(1 == 0, "It has not been 30 days since last collection of the Freedom Dividend");\n', '            }\n', '        } else {\n', '            DividendAddresses memory newDividendAddresses;\n', '            newDividendAddresses.individualAddress = collectionAddress;\n', '            newDividendAddresses.lastDistributionTimestamp = now;\n', '            FreedomDividendAddresses[collectionAddress] = newDividendAddresses;\n', '        }\n', '\n', '    }\n', '\n', '    function getDividendAddress() public view returns(address) {\n', '        return FreedomDividendAddresses[msg.sender].individualAddress;\n', '    }\n', '\n', '    function getDividendAddressWithAddress(address Address) public view returns(address) {\n', '        return FreedomDividendAddresses[Address].individualAddress;\n', '    }\n', '\n', '    function getLastDistributionTimestamp() public view returns(uint256) {\n', '        return FreedomDividendAddresses[msg.sender].lastDistributionTimestamp;\n', '    }\n', '\n', '    function getLastDistributionTimestampWithAddress(address Address) public view returns(uint256) {\n', '        return FreedomDividendAddresses[Address].lastDistributionTimestamp;\n', '    }\n', '\n', '    function getGlobalDistributionTimestamp() public view returns(uint256) {\n', '        return globalDistributionTimestamp;\n', '    }\n', '\n', '    function getbalanceOfDividendDistributorAtDistributionTimestamp() public view returns(uint256) {\n', '        return balanceOfDividendDistributorAtDistributionTimestamp;\n', '    }\n', '\n', '}']