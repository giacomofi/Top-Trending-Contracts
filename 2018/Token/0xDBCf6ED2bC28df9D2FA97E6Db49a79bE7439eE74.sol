['pragma solidity 0.4.23;\n', '\n', '/**\n', ' * ERC20 compliant interface\n', ' * See: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '**/\n', 'contract ERC20Interface {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address account) public view returns (uint256);\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) public returns (bool);\n', '    function transferFrom(address from, address to, uint256 amount) public returns (bool);\n', '    function approve(address spender, uint256 amount) public returns (bool);\n', '\n', '    event Transfer(address indexed sender, address indexed recipient, uint256 amount);\n', '    event Approval(address indexed owner, address indexed spender, uint256 amount);\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * Math operations with safety checks that throw on error\n', '**/\n', 'library SafeMath {\n', '\n', '    /**\n', '     * Adds two numbers a and b, throws on overflow.\n', '    **/\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * Subtracts two numbers a and b, throws on overflow (i.e. if b is greater than a).\n', '    **/\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * Multiplies two numbers, throws on overflow.\n', '    **/\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * Divide of two numbers (a by b), truncating the quotient.\n', '    **/\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // require(b > 0); // Solidity automatically throws when dividing by 0\n', '\n', '        return a / b;\n', '    }\n', '}\n', '\n', '/**\n', ' * ERC20 compliant token\n', '**/\n', 'contract ERC20Token is ERC20Interface {\n', '    using SafeMath for uint256;\n', '\n', '    uint256 _totalSupply;\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) internal allowed;\n', '\n', '    /**\n', '     * Return total number of tokens in existence.\n', '    **/\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    /**\n', '     * Get the balance of the specified address.\n', '     * @param account - The address to query the the balance of.\n', '     * @return An uint256 representing the amount owned by the passed address.\n', '    **/\n', '    function balanceOf(address account) public view returns (uint256) {\n', '        return balances[account];\n', '    }\n', '\n', '    /**\n', '     * Check the amount of tokens that an owner allowed to a spender.\n', '     * @param owner - The address which owns the funds.\n', '     * @param spender - The address which will spend the funds.\n', '     * @return An uint256 specifying the amount of tokens still available for the spender.\n', '    **/\n', '    function allowance(address owner, address spender) public view returns (uint256) {\n', '        return allowed[owner][spender];\n', '    }\n', '\n', '    /**\n', "     * Transfer token to a specified address from 'msg.sender'.\n", '     * @param recipient - The address to transfer to.\n', '     * @param amount - The amount to be transferred.\n', '     * @return true if transfer is successfull, error otherwise.\n', '    **/\n', '    function transfer(address recipient, uint256 amount) public returns (bool) {\n', '        require(recipient != address(0) && recipient != address(this));\n', '        require(amount <= balances[msg.sender], "insufficient funds");\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(amount);\n', '        balances[recipient] = balances[recipient].add(amount);\n', '\n', '        emit Transfer(msg.sender, recipient, amount);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from one address to another.\n', '     * @param from - The address which you want to send tokens from.\n', '     * @param to - The address which you want to transfer to.\n', '     * @param amount - The amount of tokens to be transferred.\n', '     * @return true if transfer is successfull, error otherwise.\n', '    **/\n', '    function transferFrom(address from, address to, uint256 amount) public returns (bool) {\n', '        require(to != address(0) && to != address(this));\n', '        require(amount <= balances[from] && amount <= allowed[from][msg.sender], "insufficient funds");\n', '\n', '        balances[from] = balances[from].sub(amount);\n', '        balances[to] = balances[to].add(amount);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(amount);\n', '\n', '        emit Transfer(from, to, amount);\n', '        \n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param spender - The address which will spend the funds.\n', '     * @param amount - The amount of tokens to be spent.\n', '     * @return true if transfer is successfull, error otherwise.\n', '    **/\n', '    function approve(address spender, uint256 amount) public returns (bool) {\n', '        require(spender != address(0) && spender != address(this));\n', '        require(amount == 0 || allowed[msg.sender][spender] == 0); // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '\n', '        allowed[msg.sender][spender] = amount;\n', '        emit Approval(msg.sender, spender, amount);\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', '**/\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    /**\n', '     * The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '    **/\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * Throws if called by any account other than the owner.\n', '    **/\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title BurnableToken\n', ' * Implements a token contract in which the owner can burn tokens only from his account.\n', '**/\n', 'contract BurnableToken is Ownable, ERC20Token {\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    /**\n', '     * Owner can burn a specific amount of tokens from his account.\n', '     * @param amount - The amount of token to be burned.\n', '     * @return true if burning is successfull, error otherwise.\n', '    **/\n', '    function burn(uint256 amount) public onlyOwner returns (bool) {\n', '        require(amount <= balances[owner], "amount should be less than available balance");\n', '\n', '        balances[owner] = balances[owner].sub(amount);\n', '        _totalSupply = _totalSupply.sub(amount);\n', '\n', '        emit Burn(owner, amount);\n', '        emit Transfer(owner, address(0), amount);\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title PausableToken\n', ' * Implements a token contract that can be paused and resumed by owner.\n', '**/\n', 'contract PausableToken is Ownable, ERC20Token {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '    /**\n', '     * Modifier to make a function callable only when the contract is not paused.\n', '    **/\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Modifier to make a function callable only when the contract is paused.\n', '    **/\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Owner can pause the contract (Goes to paused state).\n', '    **/\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    /**\n', '     * Owner can unpause the contract (Goes to unpaused state).\n', '    **/\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '\n', '    /**\n', "     * ERC20 specific 'transfer' is only allowed, if contract is not in paused state.\n", '    **/\n', '    function transfer(address recipient, uint256 amount) public whenNotPaused returns (bool) {\n', '        return super.transfer(recipient, amount);\n', '    }\n', '\n', '    /**\n', "     * ERC20 specific 'transferFrom' is only allowed, if contract is not in paused state.\n", '    **/\n', '    function transferFrom(address from, address to, uint256 amount) public whenNotPaused returns (bool) {\n', '        return super.transferFrom(from, to, amount);\n', '    }\n', '\n', '    /**\n', "     * ERC20 specific 'approve' is only allowed, if contract is not in paused state.\n", '    **/\n', '    function approve(address spender, uint256 amount) public whenNotPaused returns (bool) {\n', '        return super.approve(spender, amount);\n', '    }\n', '}\n', '\n', '/**\n', ' * Bloxia Fixed Supply Token Contract\n', '**/\n', 'contract BloxiaToken is Ownable, ERC20Token, PausableToken, BurnableToken {\n', '\n', '    string public constant name = "Bloxia";\n', '    string public constant symbol = "BLOX";\n', '    uint8 public constant decimals = 18;\n', '\n', '    uint256 constant initial_supply = 500000000 * (10 ** uint256(decimals)); // 500 Million\n', '\n', '    /**\n', "     * Constructor that gives 'msg.sender' all of existing tokens.\n", '    **/\n', '    constructor() public {\n', '        _totalSupply = initial_supply;\n', '        balances[msg.sender] = initial_supply;\n', '        emit Transfer(0x0, msg.sender, initial_supply);\n', '    }\n', '}']