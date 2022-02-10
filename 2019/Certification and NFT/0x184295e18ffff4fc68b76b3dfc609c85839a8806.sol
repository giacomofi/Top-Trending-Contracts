['pragma solidity ^0.4.24;\n', '\n', 'library SafeMath {\n', '    int256 constant private INT256_MIN = -2**255;\n', '\n', '    /**\n', '    * @dev Multiplies two unsigned integers, reverts on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Gas optimization: this is cheaper than requiring &#39;a&#39; not being zero, but the\n', '        // benefit is lost if &#39;b&#39; is also tested.\n', '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Multiplies two signed integers, reverts on overflow.\n', '    */\n', '    function mul(int256 a, int256 b) internal pure returns (int256) {\n', '        // Gas optimization: this is cheaper than requiring &#39;a&#39; not being zero, but the\n', '        // benefit is lost if &#39;b&#39; is also tested.\n', '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below\n', '\n', '        int256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.\n', '    */\n', '    function div(int256 a, int256 b) internal pure returns (int256) {\n', '        require(b != 0); // Solidity only automatically asserts when dividing by 0\n', '        require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow\n', '\n', '        int256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two signed integers, reverts on overflow.\n', '    */\n', '    function sub(int256 a, int256 b) internal pure returns (int256) {\n', '        int256 c = a - b;\n', '        require((b >= 0 && c <= a) || (b < 0 && c > a));\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two unsigned integers, reverts on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two signed integers, reverts on overflow.\n', '    */\n', '    function add(int256 a, int256 b) internal pure returns (int256) {\n', '        int256 c = a + b;\n', '        require((b >= 0 && c >= a) || (b < 0 && c < a));\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '    * reverts when dividing by zero.\n', '    */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', 'contract owned {\n', '    address public owner;\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '}\n', 'contract SavitarToken is owned {\n', '    using SafeMath for uint256;\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping(address => mapping(address => uint256)) public allowance;\n', '    \n', '    // Token parameters\n', '    string public name                  = "Savitar Token";\n', '    string public symbol                = "SVT";\n', '    uint8 public decimals               = 8;\n', '    uint256 public totalSupply          = 50000000 * (uint256(10) ** decimals);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    constructor() public {\n', '      // Initially assign all tokens to the contract&#39;s creator.\n', '        balanceOf[msg.sender] = totalSupply;\n', '        emit Transfer(address(0), msg.sender, totalSupply);\n', '    }\n', '    function transfer(address to, uint256 value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= value);\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(value);\n', '        balanceOf[to] = balanceOf[to].add(value);\n', '        emit Transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '    function approve(address spender, uint256 value) public returns (bool success) {\n', '        allowance[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool success) {\n', '        require(value <= balanceOf[from]);\n', '        require(value <= allowance[from][msg.sender]);\n', '        balanceOf[from] = balanceOf[from].sub(value);\n', '        balanceOf[to] = balanceOf[to].add(value);\n', '        allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);\n', '        emit Transfer(from, to, value);\n', '        return true;\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', 'library SafeMath {\n', '    int256 constant private INT256_MIN = -2**255;\n', '\n', '    /**\n', '    * @dev Multiplies two unsigned integers, reverts on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Multiplies two signed integers, reverts on overflow.\n', '    */\n', '    function mul(int256 a, int256 b) internal pure returns (int256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below\n', '\n', '        int256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.\n', '    */\n', '    function div(int256 a, int256 b) internal pure returns (int256) {\n', '        require(b != 0); // Solidity only automatically asserts when dividing by 0\n', '        require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow\n', '\n', '        int256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two signed integers, reverts on overflow.\n', '    */\n', '    function sub(int256 a, int256 b) internal pure returns (int256) {\n', '        int256 c = a - b;\n', '        require((b >= 0 && c <= a) || (b < 0 && c > a));\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two unsigned integers, reverts on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two signed integers, reverts on overflow.\n', '    */\n', '    function add(int256 a, int256 b) internal pure returns (int256) {\n', '        int256 c = a + b;\n', '        require((b >= 0 && c >= a) || (b < 0 && c < a));\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '    * reverts when dividing by zero.\n', '    */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', 'contract owned {\n', '    address public owner;\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '}\n', 'contract SavitarToken is owned {\n', '    using SafeMath for uint256;\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping(address => mapping(address => uint256)) public allowance;\n', '    \n', '    // Token parameters\n', '    string public name                  = "Savitar Token";\n', '    string public symbol                = "SVT";\n', '    uint8 public decimals               = 8;\n', '    uint256 public totalSupply          = 50000000 * (uint256(10) ** decimals);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    constructor() public {\n', "      // Initially assign all tokens to the contract's creator.\n", '        balanceOf[msg.sender] = totalSupply;\n', '        emit Transfer(address(0), msg.sender, totalSupply);\n', '    }\n', '    function transfer(address to, uint256 value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= value);\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(value);\n', '        balanceOf[to] = balanceOf[to].add(value);\n', '        emit Transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '    function approve(address spender, uint256 value) public returns (bool success) {\n', '        allowance[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool success) {\n', '        require(value <= balanceOf[from]);\n', '        require(value <= allowance[from][msg.sender]);\n', '        balanceOf[from] = balanceOf[from].sub(value);\n', '        balanceOf[to] = balanceOf[to].add(value);\n', '        allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);\n', '        emit Transfer(from, to, value);\n', '        return true;\n', '    }\n', '}']