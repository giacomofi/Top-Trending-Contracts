['pragma solidity 0.4.24;\n', '\n', '// File: contracts/commons/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '// File: contracts/flavours/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: contracts/flavours/Lockable.sol\n', '\n', '/**\n', ' * @title Lockable\n', ' * @dev Base contract which allows children to\n', ' *      implement main operations locking mechanism.\n', ' */\n', 'contract Lockable is Ownable {\n', '    event Lock();\n', '    event Unlock();\n', '\n', '    bool public locked = false;\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable\n', '    *       only when the contract is not locked.\n', '     */\n', '    modifier whenNotLocked() {\n', '        require(!locked);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable\n', '     *      only when the contract is locked.\n', '     */\n', '    modifier whenLocked() {\n', '        require(locked);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to locke, triggers locked state\n', '     */\n', '    function lock() public onlyOwner whenNotLocked {\n', '        locked = true;\n', '        emit Lock();\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner\n', '     *      to unlock, returns to unlocked state\n', '     */\n', '    function unlock() public onlyOwner whenLocked {\n', '        locked = false;\n', '        emit Unlock();\n', '    }\n', '}\n', '\n', '// File: contracts/base/BaseFixedERC20Token.sol\n', '\n', 'contract BaseFixedERC20Token is Lockable {\n', '    using SafeMath for uint;\n', '\n', '    /// @dev ERC20 Total supply\n', '    uint public totalSupply;\n', '\n', '    mapping(address => uint) public balances;\n', '\n', '    mapping(address => mapping(address => uint)) private allowed;\n', '\n', '    /// @dev Fired if token is transferred according to ERC20 spec\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    /// @dev Fired if token withdrawal is approved according to ERC20 spec\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '\n', '    /**\n', '     * @dev Gets the balance of the specified address\n', '     * @param owner_ The address to query the the balance of\n', '     * @return An uint representing the amount owned by the passed address\n', '     */\n', '    function balanceOf(address owner_) public view returns (uint balance) {\n', '        return balances[owner_];\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer token for a specified address\n', '     * @param to_ The address to transfer to.\n', '     * @param value_ The amount to be transferred.\n', '     */\n', '    function transfer(address to_, uint value_) public whenNotLocked returns (bool) {\n', '        require(to_ != address(0) && value_ <= balances[msg.sender]);\n', '        // SafeMath.sub will throw an exception if there is not enough balance\n', '        balances[msg.sender] = balances[msg.sender].sub(value_);\n', '        balances[to_] = balances[to_].add(value_);\n', '        emit Transfer(msg.sender, to_, value_);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param from_ address The address which you want to send tokens from\n', '     * @param to_ address The address which you want to transfer to\n', '     * @param value_ uint the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address from_, address to_, uint value_) public whenNotLocked returns (bool) {\n', '        require(to_ != address(0) && value_ <= balances[from_] && value_ <= allowed[from_][msg.sender]);\n', '        balances[from_] = balances[from_].sub(value_);\n', '        balances[to_] = balances[to_].add(value_);\n', '        allowed[from_][msg.sender] = allowed[from_][msg.sender].sub(value_);\n', '        emit Transfer(from_, to_, value_);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender\n', '     *\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering\n', '     *\n', '     * To change the approve amount you first have to reduce the addresses\n', '     * allowance to zero by calling `approve(spender_, 0)` if it is not\n', '     * already 0 to mitigate the race condition described in:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * @param spender_ The address which will spend the funds.\n', '     * @param value_ The amount of tokens to be spent.\n', '     */\n', '    function approve(address spender_, uint value_) public whenNotLocked returns (bool) {\n', '        if (value_ != 0 && allowed[msg.sender][spender_] != 0) {\n', '            revert();\n', '        }\n', '        allowed[msg.sender][spender_] = value_;\n', '        emit Approval(msg.sender, spender_, value_);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender\n', '     * @param owner_ address The address which owns the funds\n', '     * @param spender_ address The address which will spend the funds\n', '     * @return A uint specifying the amount of tokens still available for the spender\n', '     */\n', '    function allowance(address owner_, address spender_) public view returns (uint) {\n', '        return allowed[owner_][spender_];\n', '    }\n', '}\n', '\n', '// File: contracts/IonChain.sol\n', '\n', '/**\n', ' * @title IONC token contract.\n', ' */\n', 'contract IonChain is BaseFixedERC20Token {\n', '    using SafeMath for uint;\n', '\n', '    string public constant name = "IonChain";\n', '\n', '    string public constant symbol = "IONC";\n', '\n', '    uint8 public constant decimals = 6;\n', '\n', '    uint internal constant ONE_TOKEN = 1e6;\n', '\n', '    constructor(uint totalSupplyTokens_) public {\n', '        locked = false;\n', '        totalSupply = totalSupplyTokens_ * ONE_TOKEN;\n', '        address creator = msg.sender;\n', '        balances[creator] = totalSupply;\n', '\n', '        emit Transfer(0, this, totalSupply);\n', '        emit Transfer(this, creator, balances[creator]);\n', '    }\n', '\n', '    // Disable direct payments\n', '    function() external payable {\n', '        revert();\n', '    }\n', '\n', '}']
['pragma solidity 0.4.24;\n', '\n', '// File: contracts/commons/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '// File: contracts/flavours/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: contracts/flavours/Lockable.sol\n', '\n', '/**\n', ' * @title Lockable\n', ' * @dev Base contract which allows children to\n', ' *      implement main operations locking mechanism.\n', ' */\n', 'contract Lockable is Ownable {\n', '    event Lock();\n', '    event Unlock();\n', '\n', '    bool public locked = false;\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable\n', '    *       only when the contract is not locked.\n', '     */\n', '    modifier whenNotLocked() {\n', '        require(!locked);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable\n', '     *      only when the contract is locked.\n', '     */\n', '    modifier whenLocked() {\n', '        require(locked);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to locke, triggers locked state\n', '     */\n', '    function lock() public onlyOwner whenNotLocked {\n', '        locked = true;\n', '        emit Lock();\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner\n', '     *      to unlock, returns to unlocked state\n', '     */\n', '    function unlock() public onlyOwner whenLocked {\n', '        locked = false;\n', '        emit Unlock();\n', '    }\n', '}\n', '\n', '// File: contracts/base/BaseFixedERC20Token.sol\n', '\n', 'contract BaseFixedERC20Token is Lockable {\n', '    using SafeMath for uint;\n', '\n', '    /// @dev ERC20 Total supply\n', '    uint public totalSupply;\n', '\n', '    mapping(address => uint) public balances;\n', '\n', '    mapping(address => mapping(address => uint)) private allowed;\n', '\n', '    /// @dev Fired if token is transferred according to ERC20 spec\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    /// @dev Fired if token withdrawal is approved according to ERC20 spec\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '\n', '    /**\n', '     * @dev Gets the balance of the specified address\n', '     * @param owner_ The address to query the the balance of\n', '     * @return An uint representing the amount owned by the passed address\n', '     */\n', '    function balanceOf(address owner_) public view returns (uint balance) {\n', '        return balances[owner_];\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer token for a specified address\n', '     * @param to_ The address to transfer to.\n', '     * @param value_ The amount to be transferred.\n', '     */\n', '    function transfer(address to_, uint value_) public whenNotLocked returns (bool) {\n', '        require(to_ != address(0) && value_ <= balances[msg.sender]);\n', '        // SafeMath.sub will throw an exception if there is not enough balance\n', '        balances[msg.sender] = balances[msg.sender].sub(value_);\n', '        balances[to_] = balances[to_].add(value_);\n', '        emit Transfer(msg.sender, to_, value_);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param from_ address The address which you want to send tokens from\n', '     * @param to_ address The address which you want to transfer to\n', '     * @param value_ uint the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address from_, address to_, uint value_) public whenNotLocked returns (bool) {\n', '        require(to_ != address(0) && value_ <= balances[from_] && value_ <= allowed[from_][msg.sender]);\n', '        balances[from_] = balances[from_].sub(value_);\n', '        balances[to_] = balances[to_].add(value_);\n', '        allowed[from_][msg.sender] = allowed[from_][msg.sender].sub(value_);\n', '        emit Transfer(from_, to_, value_);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender\n', '     *\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering\n', '     *\n', '     * To change the approve amount you first have to reduce the addresses\n', '     * allowance to zero by calling `approve(spender_, 0)` if it is not\n', '     * already 0 to mitigate the race condition described in:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * @param spender_ The address which will spend the funds.\n', '     * @param value_ The amount of tokens to be spent.\n', '     */\n', '    function approve(address spender_, uint value_) public whenNotLocked returns (bool) {\n', '        if (value_ != 0 && allowed[msg.sender][spender_] != 0) {\n', '            revert();\n', '        }\n', '        allowed[msg.sender][spender_] = value_;\n', '        emit Approval(msg.sender, spender_, value_);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender\n', '     * @param owner_ address The address which owns the funds\n', '     * @param spender_ address The address which will spend the funds\n', '     * @return A uint specifying the amount of tokens still available for the spender\n', '     */\n', '    function allowance(address owner_, address spender_) public view returns (uint) {\n', '        return allowed[owner_][spender_];\n', '    }\n', '}\n', '\n', '// File: contracts/IonChain.sol\n', '\n', '/**\n', ' * @title IONC token contract.\n', ' */\n', 'contract IonChain is BaseFixedERC20Token {\n', '    using SafeMath for uint;\n', '\n', '    string public constant name = "IonChain";\n', '\n', '    string public constant symbol = "IONC";\n', '\n', '    uint8 public constant decimals = 6;\n', '\n', '    uint internal constant ONE_TOKEN = 1e6;\n', '\n', '    constructor(uint totalSupplyTokens_) public {\n', '        locked = false;\n', '        totalSupply = totalSupplyTokens_ * ONE_TOKEN;\n', '        address creator = msg.sender;\n', '        balances[creator] = totalSupply;\n', '\n', '        emit Transfer(0, this, totalSupply);\n', '        emit Transfer(this, creator, balances[creator]);\n', '    }\n', '\n', '    // Disable direct payments\n', '    function() external payable {\n', '        revert();\n', '    }\n', '\n', '}']