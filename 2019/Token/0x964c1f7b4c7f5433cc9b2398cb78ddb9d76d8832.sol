['pragma solidity 0.5.7;\n', '\n', '/**\n', ' * @title SafeMath \n', ' * @dev Unsigned math operations with safety checks that revert on error.\n', ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Multiplies two unsigned integers, reverts on overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Subtracts two unsigned integers, reverts on underflow (i.e. if subtrahend is greater than minuend).\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Adds two unsigned integers, reverts on overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '}\n', '/**\n', ' * @title Token\n', ' * @dev Implementation of the basic standard token.\n', ' * https://eips.ethereum.org/EIPS/eip-20\n', ' */\n', 'contract Token {\n', '    using SafeMath for uint256;\n', '    \n', '    string public constant name = "5G Cloud Chain";\n', '    string public constant symbol = "5GCC";\n', '    uint8 public constant decimals = 4;\n', '\n', '    uint256 private constant INITIAL_SUPPLY = 1e9;\n', '    uint256 public constant totalSupply = INITIAL_SUPPLY * 10 ** uint256(decimals);\n', '\n', '    address public constant wallet = 0x25c5141A20f2D901C2fbA19131C8f6dccdE90399;\n', '\n', '    mapping (address => uint256) internal _balances;\n', '    mapping (address => mapping (address => uint256)) internal _allowed;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    constructor() public {\n', '        _balances[wallet] = totalSupply;\n', '        emit Transfer(address(0), wallet, totalSupply);\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the balance of the specified address.\n', '     * @param owner The address to query the balance of.\n', '     * @return A uint256 representing the amount owned by the passed address.\n', '     */\n', '    function balanceOf(address owner) public view returns (uint256) {\n', '        return _balances[owner];\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param owner address The address which owns the funds.\n', '     * @param spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address owner, address spender) public view returns (uint256) {\n', '        return _allowed[owner][spender];\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer token to a specified address.\n', '     * @param to The address to transfer to.\n', '     * @param value The amount to be transferred.\n', '     */\n', '    function transfer(address to, uint256 value) public returns (bool) {\n', '        _transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param spender The address which will spend the funds.\n', '     * @param value The amount of tokens to be spent.\n', '     */\n', '    function approve(address spender, uint256 value) public returns (bool) {\n', '        _approve(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another.\n', '     * Note that while this function emits an Approval event, this is not required as per the specification,\n', '     * and other compliant implementations may not emit the event.\n', '     * @param from address The address which you want to send tokens from\n', '     * @param to address The address which you want to transfer to\n', '     * @param value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '        _transfer(from, to, value);\n', '        _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when _allowed[msg.sender][spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * Emits an Approval event.\n', '     * @param spender The address which will spend the funds.\n', '     * @param addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '        _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when _allowed[msg.sender][spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * Emits an Approval event.\n', '     * @param spender The address which will spend the funds.\n', '     * @param subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '        _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer token for a specified address.\n', '     * @param from The address to transfer from.\n', '     * @param to The address to transfer to.\n', '     * @param value The amount to be transferred.\n', '     */\n', '    function _transfer(address from, address to, uint256 value) internal {\n', '        require(to != address(0), "Cannot transfer to zero address");\n', '\n', '        _balances[from] = _balances[from].sub(value);\n', '        _balances[to] = _balances[to].add(value);\n', '        emit Transfer(from, to, value);\n', '    }\n', '\n', '    /**\n', "     * @dev Approve an address to spend another addresses' tokens.\n", '     * @param owner The address that owns the tokens.\n', '     * @param spender The address that will spend the tokens.\n', '     * @param value The number of tokens that can be spent.\n', '     */\n', '    function _approve(address owner, address spender, uint256 value) internal {\n', '        require(spender != address(0), "Cannot approve to the zero address");\n', '        require(owner != address(0), "Setter cannot be a zero address");\n', '\n', '        _allowed[owner][spender] = value;\n', '        emit Approval(owner, spender, value);\n', '    }\n', '}']