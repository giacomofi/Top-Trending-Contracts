['pragma solidity ^0.4.25;\n', '\n', '/******************************************/\n', '/*     Netkiller Standard safe token      */\n', '/******************************************/\n', '/* Author netkiller <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="f69893829d9f9a9a9384b69b8598d895999b">[email&#160;protected]</a>>   */\n', '/* Home http://www.netkiller.cn           */\n', '/* Version 2018-09-30                     */\n', '/******************************************/\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // Gas optimization: this is cheaper than requiring &#39;a&#39; not being zero, but the\n', '    // benefit is lost if &#39;b&#39; is also tested.\n', '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '    \n', '    address public owner;\n', '    \n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    \n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', 'contract NetkillerToken is Ownable{\n', '    \n', '    using SafeMath for uint256;\n', '    \n', '    string public name;\n', '    string public symbol;\n', '    uint public decimals;\n', '    uint256 public totalSupply;\n', '    \n', '    // This creates an array with all balances\n', '    mapping (address => uint256) internal balances;\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    constructor(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol,\n', '        uint decimalUnits\n', '    ) public {\n', '        owner = msg.sender;\n', '        name = tokenName;                                   // Set the name for display purposes\n', '        symbol = tokenSymbol; \n', '        decimals = decimalUnits;\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount\n', '        balances[msg.sender] = totalSupply;                // Give the creator all initial token\n', '    }\n', '\n', '    function balanceOf(address _address) view public returns (uint256 balance) {\n', '        return balances[_address];\n', '    }\n', '    \n', '    /* Internal transfer, only can be called by this contract */\n', '    function _transfer(address _from, address _to, uint256 _value) internal {\n', '        require (_to != address(0));                        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require (balances[_from] >= _value);                // Check if the sender has enough\n', '        require (balances[_to] + _value > balances[_to]);   // Check for overflows\n', '        balances[_from] = balances[_from].sub(_value);      // Subtract from the sender\n', '        balances[_to] = balances[_to].add(_value);          // Add the same to the recipient\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);     // Check allowance\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    function allowance(address _owner, address _spender) view public returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function airdrop(address[] _to, uint256 _value) onlyOwner public returns (bool success) {\n', '        \n', '        require(_value > 0 && balanceOf(msg.sender) >= _value.mul(_to.length));\n', '        \n', '        for (uint i=0; i<_to.length; i++) {\n', '            _transfer(msg.sender, _to[i], _value);\n', '        }\n', '        return true;\n', '    }\n', '    \n', '    function batchTransfer(address[] _to, uint256[] _value) onlyOwner public returns (bool success) {\n', '        require(_to.length == _value.length);\n', '\n', '        uint256 amount = 0;\n', '        for(uint n=0;n<_value.length;n++){\n', '            amount = amount.add(_value[n]);\n', '        }\n', '        \n', '        require(amount > 0 && balanceOf(msg.sender) >= amount);\n', '        \n', '        for (uint i=0; i<_to.length; i++) {\n', '            transfer(_to[i], _value[i]);\n', '        }\n', '        return true;\n', '    }\n', '}']
['pragma solidity ^0.4.25;\n', '\n', '/******************************************/\n', '/*     Netkiller Standard safe token      */\n', '/******************************************/\n', '/* Author netkiller <netkiller@msn.com>   */\n', '/* Home http://www.netkiller.cn           */\n', '/* Version 2018-09-30                     */\n', '/******************************************/\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '    \n', '    address public owner;\n', '    \n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    \n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', 'contract NetkillerToken is Ownable{\n', '    \n', '    using SafeMath for uint256;\n', '    \n', '    string public name;\n', '    string public symbol;\n', '    uint public decimals;\n', '    uint256 public totalSupply;\n', '    \n', '    // This creates an array with all balances\n', '    mapping (address => uint256) internal balances;\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    constructor(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol,\n', '        uint decimalUnits\n', '    ) public {\n', '        owner = msg.sender;\n', '        name = tokenName;                                   // Set the name for display purposes\n', '        symbol = tokenSymbol; \n', '        decimals = decimalUnits;\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount\n', '        balances[msg.sender] = totalSupply;                // Give the creator all initial token\n', '    }\n', '\n', '    function balanceOf(address _address) view public returns (uint256 balance) {\n', '        return balances[_address];\n', '    }\n', '    \n', '    /* Internal transfer, only can be called by this contract */\n', '    function _transfer(address _from, address _to, uint256 _value) internal {\n', '        require (_to != address(0));                        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require (balances[_from] >= _value);                // Check if the sender has enough\n', '        require (balances[_to] + _value > balances[_to]);   // Check for overflows\n', '        balances[_from] = balances[_from].sub(_value);      // Subtract from the sender\n', '        balances[_to] = balances[_to].add(_value);          // Add the same to the recipient\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);     // Check allowance\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    function allowance(address _owner, address _spender) view public returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function airdrop(address[] _to, uint256 _value) onlyOwner public returns (bool success) {\n', '        \n', '        require(_value > 0 && balanceOf(msg.sender) >= _value.mul(_to.length));\n', '        \n', '        for (uint i=0; i<_to.length; i++) {\n', '            _transfer(msg.sender, _to[i], _value);\n', '        }\n', '        return true;\n', '    }\n', '    \n', '    function batchTransfer(address[] _to, uint256[] _value) onlyOwner public returns (bool success) {\n', '        require(_to.length == _value.length);\n', '\n', '        uint256 amount = 0;\n', '        for(uint n=0;n<_value.length;n++){\n', '            amount = amount.add(_value[n]);\n', '        }\n', '        \n', '        require(amount > 0 && balanceOf(msg.sender) >= amount);\n', '        \n', '        for (uint i=0; i<_to.length; i++) {\n', '            transfer(_to[i], _value[i]);\n', '        }\n', '        return true;\n', '    }\n', '}']
