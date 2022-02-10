['pragma solidity ^0.5.0;\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '//   // Telegram : https://t.me/Unicryptfarm\n', '    // Twitter : https://twitter.com/Unicryptfarm\n', '    // Medium : https://medium.com/@Unicryptfarm\n', '    // Website : https://Unicrypt.farm\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function totalSupply() public view returns (uint);\n', '    function balanceOf(address tokenOwner) public view returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Safe Math Library \n', '//\n', ' //* @title Ownable UnicryptFarm\n', ' //* @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' // functions, this simplifies the implementation of "user permissions".\n', ' //\n', '// ----------------------------------------------------------------------------\n', 'contract SafeMath {\n', '    function safeAdd(uint a, uint b) public pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function safeSub(uint a, uint b) public pure returns (uint c) {\n', '        require(b <= a); c = a - b; } function safeMul(uint a, uint b) public pure returns (uint c) { c = a * b; require(a == 0 || c / a == b); } function safeDiv(uint a, uint b) public pure returns (uint c) { require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '\n', 'contract UnicryptFarm is ERC20Interface, SafeMath {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals; // 18 decimals is the strongly suggested default, avoid changing it\n', '    \n', '    uint256 public _totalSupply;\n', '    \n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '    \n', '     /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '    \n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    constructor() public {\n', '        name = "UnicryptFarm";\n', '        symbol = "UCx";\n', '        decimals = 18;\n', '        _totalSupply = 10000000000000000000000;\n', '        \n', '        balances[msg.sender] = _totalSupply;\n', '        emit Transfer(address(0), msg.sender, _totalSupply);\n', '    }\n', '     //\n', '   //* @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   //*\n', '   // Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   //* and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   //* race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   //* https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   //* @param _spender The address which will spend the funds.\n', '   //* @param _value The amount of tokens to be spent.\n', '   //\n', '    \n', '    function totalSupply() public view returns (uint) {\n', '        return _totalSupply  - balances[address(0)];\n', '    }\n', '    \n', '    function balanceOf(address tokenOwner) public view returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '    \n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '    \n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '    \n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        balances[msg.sender] = safeSub(balances[msg.sender], tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        balances[from] = safeSub(balances[from], tokens);\n', '        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '}']