['pragma solidity ^0.4.21;\n', '\n', '/**\n', ' * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        // Gas optimization: this is cheaper than asserting &#39;a&#39; not being zero, but the\n', '        // benefit is lost if &#39;b&#39; is also tested.\n', '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b > 0);\n', '        // uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * ERC Token Standard #20 Interface\n', ' * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', ' */\n', 'contract ERC20Interface {\n', '    uint256 public totalSupply;\n', '\n', '    function balanceOf(address tokenOwner) public constant returns (uint256 balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining);\n', '    function transfer(address to, uint256 tokens) public returns (bool success);\n', '    function approve(address spender, uint256 tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint256 tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', 'contract FixedSupplyToken is ERC20Interface, Owned {\n', '    using SafeMath for uint256;\n', '\n', '    string public symbol;\n', '    string public name;\n', '    uint8 public decimals;\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '\n', '    modifier onlyPayloadSize(uint size) {\n', '        assert(msg.data.length == size + 4);\n', '        _;\n', '    }\n', '\n', '    constructor() public {\n', '        symbol = "CARPWO";\n', '        name = "CarblockPWOToken";\n', '        decimals = 18;\n', '        totalSupply = 1800000000 * 10**uint(decimals);\n', '        balances[owner] = totalSupply;\n', '        emit Transfer(address(0), owner, totalSupply);\n', '    }\n', '\n', '    function balanceOf(address tokenOwner) public constant returns (uint256 balanceOfOwner) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '\n', '    /**\n', '     * Transfer the balance from token owner&#39;s account to `to` account\n', '     * - Owner&#39;s account must have sufficient balance to transfer\n', '     * - 0 value transfers are allowed\n', '     */\n', '    function transfer(address to, uint256 tokens) onlyPayloadSize(2 * 32) public returns (bool success) {\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    /**\n', '     * Token owner can approve for `spender` to transferFrom(...) `tokens`\n', '     * from the token owner&#39;s account\n', '     *\n', '     * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '     * recommends that there are no checks for the approval double-spend attack\n', '     * as this should be implemented in user interfaces \n', '     */\n', '    function approve(address spender, uint256 tokens) onlyPayloadSize(3 * 32) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    /**\n', '     * Transfer `tokens` from the `from` account to the `to` account\n', '     *\n', '     * The calling account must already have sufficient tokens approve(...)-d\n', '     * for spending from the `from` account and\n', '     * - From account must have sufficient balance to transfer\n', '     * - Spender must have sufficient allowance to transfer\n', '     * - 0 value transfers are allowed\n', '     */\n', '    function transferFrom(address from, address to, uint256 tokens) public returns (bool success) {\n', '        balances[from] = balances[from].sub(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    /**\n', '     * Returns the amount of tokens approved by the owner that can be\n', '     * transferred to the spender&#39;s account\n', '     */\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '\n', '    /**\n', '     * Don&#39;t accept ETH\n', '     */\n', '    function () public payable {\n', '        revert();\n', '    }\n', '\n', '\n', '    /**\n', '     * Owner can transfer out any accidentally sent ERC20 tokens\n', '     */\n', '    function transferAnyERC20Token(address tokenAddress, uint256 tokens) public onlyOwner returns (bool success) {\n', '        return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '    }\n', '}']
['pragma solidity ^0.4.21;\n', '\n', '/**\n', ' * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', "        // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b > 0);\n', '        // uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * ERC Token Standard #20 Interface\n', ' * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', ' */\n', 'contract ERC20Interface {\n', '    uint256 public totalSupply;\n', '\n', '    function balanceOf(address tokenOwner) public constant returns (uint256 balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining);\n', '    function transfer(address to, uint256 tokens) public returns (bool success);\n', '    function approve(address spender, uint256 tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint256 tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', 'contract FixedSupplyToken is ERC20Interface, Owned {\n', '    using SafeMath for uint256;\n', '\n', '    string public symbol;\n', '    string public name;\n', '    uint8 public decimals;\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '\n', '    modifier onlyPayloadSize(uint size) {\n', '        assert(msg.data.length == size + 4);\n', '        _;\n', '    }\n', '\n', '    constructor() public {\n', '        symbol = "CARPWO";\n', '        name = "CarblockPWOToken";\n', '        decimals = 18;\n', '        totalSupply = 1800000000 * 10**uint(decimals);\n', '        balances[owner] = totalSupply;\n', '        emit Transfer(address(0), owner, totalSupply);\n', '    }\n', '\n', '    function balanceOf(address tokenOwner) public constant returns (uint256 balanceOfOwner) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '\n', '    /**\n', "     * Transfer the balance from token owner's account to `to` account\n", "     * - Owner's account must have sufficient balance to transfer\n", '     * - 0 value transfers are allowed\n', '     */\n', '    function transfer(address to, uint256 tokens) onlyPayloadSize(2 * 32) public returns (bool success) {\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    /**\n', '     * Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "     * from the token owner's account\n", '     *\n', '     * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '     * recommends that there are no checks for the approval double-spend attack\n', '     * as this should be implemented in user interfaces \n', '     */\n', '    function approve(address spender, uint256 tokens) onlyPayloadSize(3 * 32) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    /**\n', '     * Transfer `tokens` from the `from` account to the `to` account\n', '     *\n', '     * The calling account must already have sufficient tokens approve(...)-d\n', '     * for spending from the `from` account and\n', '     * - From account must have sufficient balance to transfer\n', '     * - Spender must have sufficient allowance to transfer\n', '     * - 0 value transfers are allowed\n', '     */\n', '    function transferFrom(address from, address to, uint256 tokens) public returns (bool success) {\n', '        balances[from] = balances[from].sub(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    /**\n', '     * Returns the amount of tokens approved by the owner that can be\n', "     * transferred to the spender's account\n", '     */\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '\n', '    /**\n', "     * Don't accept ETH\n", '     */\n', '    function () public payable {\n', '        revert();\n', '    }\n', '\n', '\n', '    /**\n', '     * Owner can transfer out any accidentally sent ERC20 tokens\n', '     */\n', '    function transferAnyERC20Token(address tokenAddress, uint256 tokens) public onlyOwner returns (bool success) {\n', '        return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '    }\n', '}']
