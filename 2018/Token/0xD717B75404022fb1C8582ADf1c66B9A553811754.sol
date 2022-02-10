['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title Safe Math contract\n', ' * \n', ' * @dev prevents overflow when working with uint256 addition ans substraction\n', ' */\n', 'contract SafeMath {\n', '    function safeAdd(uint256 a, uint256 b) public pure returns (uint256 c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '\n', '    function safeSub(uint256 a, uint256 b) public pure returns (uint256 c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC Token Standard #20 Interface \n', ' *\n', ' * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md\n', ' * @dev https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts/token/ERC20\n', ' */\n', 'contract ERC20Interface {\n', '\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Owned contract\n', ' *\n', ' * @dev Implements ownership \n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public {\n', '        require(msg.sender == owner);\n', '        require(newOwner != address(0));\n', '\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title The MILC Token Contract\n', ' *\n', ' * @dev The MILC Token is an ERC20 Token\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract MilcToken is ERC20Interface, Ownable, SafeMath {\n', '\n', '    /**\n', '    * Max Tokens: 40 Millions MILC with 18 Decimals.\n', '    * The smallest unit is called "Hey". 1\'000\'000\'000\'000\'000\'000 Hey = 1 MILC\n', '    */\n', '    uint256 constant public MAX_TOKENS = 40 * 1000 * 1000 * 10 ** uint256(18);\n', '\n', '    string public symbol = "MILC";\n', '    string public name = "Micro Licensing Coin";\n', '    uint8 public decimals = 18;\n', '    uint256 public totalSupply = 0;\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '\n', '    event Mint(address indexed to, uint256 amount);\n', '    \n', '    function MilcToken() public {\n', '    }\n', '\n', '    /**\n', '     * @dev This contract does not accept ETH\n', '     */\n', '    function() public payable {\n', '        revert();\n', '    }\n', '\n', '    // ---- ERC20 START ----\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply;\n', '    }\n', '\n', '    function balanceOf(address who) public view returns (uint256) {\n', '        return balances[who];\n', '    }\n', '\n', '    function transfer(address to, uint256 value) public returns (bool) {\n', '        balances[msg.sender] = safeSub(balances[msg.sender], value);\n', '        balances[to] = safeAdd(balances[to], value);\n', '        Transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    */\n', '    function approve(address spender, uint256 value) public returns (bool) {\n', '        allowed[msg.sender][spender] = value;\n', '        Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '        balances[from] = safeSub(balances[from], value);\n', '        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], value);\n', '        balances[to] = safeAdd(balances[to], value);\n', '        Transfer(from, to, value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address owner, address spender) public view returns (uint256) {\n', '        return allowed[owner][spender];\n', '    }\n', '    // ---- ERC20 END ----\n', '\n', '    // ---- EXTENDED FUNCTIONALITY START ----\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     */\n', '    function increaseApproval(address spender, uint256 addedValue) public returns (bool success) {\n', '        allowed[msg.sender][spender] = safeAdd(allowed[msg.sender][spender], addedValue);\n', '        Approval(msg.sender, spender, allowed[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     */\n', '    function decreaseApproval(address spender, uint256 subtractedValue) public returns (bool success) {\n', '        uint256 oldValue = allowed[msg.sender][spender];\n', '        if (subtractedValue > oldValue) {\n', '            allowed[msg.sender][spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][spender] = safeSub(oldValue, subtractedValue);\n', '        }\n', '\n', '        Approval(msg.sender, spender, allowed[msg.sender][spender]);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * @dev Same functionality as transfer. Accepts an array of recipients and values. Can be used to save gas.\n', '     * @dev both arrays requires to have the same length\n', '     */\n', '    function transferArray(address[] tos, uint256[] values) public returns (bool) {\n', '        for (uint8 i = 0; i < tos.length; i++) {\n', '            require(transfer(tos[i], values[i]));\n', '        }\n', '\n', '        return true;\n', '    }\n', '    // ---- EXTENDED FUNCTIONALITY END ----\n', '\n', '    // ---- MINT START ----\n', '    /**\n', '     * @dev Bulk mint function to save gas. \n', '     * @dev both arrays requires to have the same length\n', '     */\n', '    function mint(address[] recipients, uint256[] tokens) public returns (bool) {\n', '        require(msg.sender == owner);\n', '\n', '        for (uint8 i = 0; i < recipients.length; i++) {\n', '\n', '            address recipient = recipients[i];\n', '            uint256 token = tokens[i];\n', '\n', '            totalSupply = safeAdd(totalSupply, token);\n', '            require(totalSupply <= MAX_TOKENS);\n', '\n', '            balances[recipient] = safeAdd(balances[recipient], token);\n', '\n', '            Mint(recipient, token);\n', '            Transfer(address(0), recipient, token);\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    function isMintDone() public view returns (bool) {\n', '        return totalSupply == MAX_TOKENS;\n', '    }\n', '    // ---- MINT END ---- \n', '}']