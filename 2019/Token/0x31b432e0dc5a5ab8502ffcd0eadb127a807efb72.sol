['pragma solidity 0.4.25;\n', '\n', '// ----------------------------------------------------------------------------\n', '// Safe maths\n', '// ----------------------------------------------------------------------------\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address public owner;\n', '    \n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function totalSupply() public view returns (uint);\n', '    function balanceOf(address tokenOwner) public view returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 \n', '// \n', '// ----------------------------------------------------------------------------\n', '\n', 'contract WTXH is ERC20Interface, Owned {\n', '    using SafeMath for uint;\n', '\n', '    string public constant name = "WTX Hub";\n', '    string public constant symbol = "WTXH";\n', '    uint8 public constant decimals = 18;\n', '    \n', '    mapping(address => uint) frozenAccountPeriod;\n', '    mapping(address => bool) frozenAccount;\n', '\n', '    uint constant public _decimals18 = uint(10) ** decimals;\n', '    uint constant public _totalSupply    = 400000000 * _decimals18;\n', '    \n', '    event FrozenFunds(address target, uint period);\n', '\n', '    constructor() public { \n', '        balances[owner] = _totalSupply;\n', '        emit Transfer(address(0), owner, _totalSupply);\n', '    }\n', '\n', '// ----------------------------------------------------------------------------\n', '// mappings for implementing ERC20 \n', '// ERC20 standard functions\n', '// ----------------------------------------------------------------------------\n', '    \n', '    // Balances for each account\n', '    mapping(address => uint) balances;\n', '    \n', '    // Owner of account approves the transfer of an amount to another account\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '    function totalSupply() public view returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '    \n', '    // Get the token balance for account `tokenOwner`\n', '    function balanceOf(address tokenOwner) public view returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '    \n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '    function _transfer(address _from, address _toAddress, uint _tokens) private {\n', '        balances[_from] = balances[_from].sub(_tokens);\n', '        addToBalance(_toAddress, _tokens);\n', '        emit Transfer(_from, _toAddress, _tokens);\n', '    }\n', '    \n', "    // Transfer the balance from owner's account to another account\n", '    function transfer(address _add, uint _tokens) public returns (bool success) {\n', '        require(_add != address(0));\n', '        require(_tokens <= balances[msg.sender]);\n', '        \n', '        if(!frozenAccount[msg.sender] && now > frozenAccountPeriod[msg.sender]){\n', '            _transfer(msg.sender, _add, _tokens);\n', '        }\n', '        \n', '        return true;\n', '    }\n', '\n', '    /*\n', '        Allow `spender` to withdraw from your account, multiple times, \n', '        up to the `tokens` amount.If this function is called again it \n', '        overwrites the current allowance with _value.\n', '    */\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '    \n', '    /*\n', '        Send `tokens` amount of tokens from address `from` to address `to`\n', '        The transferFrom method is used for a withdraw workflow, \n', '        allowing contracts to send tokens on your behalf, \n', '        for example to "deposit" to a contract address and/or to charge\n', '        fees in sub-currencies; the command should fail unless the _from \n', '        account has deliberately authorized the sender of the message via\n', '        some mechanism; we propose these standardized APIs for approval:\n', '    */\n', '    function transferFrom(address from, address _toAddr, uint tokens) public returns (bool success) {\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        _transfer(from, _toAddr, tokens);\n', '        return true;\n', '    }\n', '    \n', '\n', '    // address not null\n', '    modifier addressNotNull(address _addr){\n', '        require(_addr != address(0));\n', '        _;\n', '    }\n', '\n', '    // Add to balance\n', '    function addToBalance(address _address, uint _amount) internal {\n', '    \tbalances[_address] = balances[_address].add(_amount);\n', '    }\n', '\t\n', '\t /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '    \n', '    function freezeAccount(address target, uint period) public onlyOwner {\n', '        require(target != address(0) && owner != target);\n', '        frozenAccount[target] = true;\n', '        frozenAccountPeriod[target] = period;\n', '        emit FrozenFunds(target, period);\n', '    }\n', '    \n', '    function unFreezeAccount(address target) public onlyOwner {\n', '        require(target != address(0));\n', '        delete(frozenAccount[target]);\n', '        delete(frozenAccountPeriod[target]);\n', '    }\n', '    \n', '    function getFreezeAccountInfo(address _ad) public view onlyOwner returns(bool, uint) {\n', '        return (frozenAccount[_ad], frozenAccountPeriod[_ad]);\n', '    }\n', '\n', '    function () payable external {\n', '        owner.transfer(msg.value);\n', '    }\n', '\n', '}']