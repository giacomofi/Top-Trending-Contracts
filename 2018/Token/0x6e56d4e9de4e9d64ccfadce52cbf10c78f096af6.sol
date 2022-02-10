['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * @title Snow Coin\n', ' * @author lan yuhang\n', ' */\n', '\n', 'contract SafeMath {\n', '    function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b > 0);\n', '        uint256 c = a / b;\n', '        assert(a == b * c + a % b);\n', '        return c;\n', '    }\n', '\n', '    function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a && c >= b);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '    * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '    * account.\n', '    */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '\n', '    /**\n', '    * @dev Modifier to make a function callable only when the contract is not paused.\n', '    */\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Modifier to make a function callable only when the contract is paused.\n', '    */\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev called by the owner to pause, triggers stopped state\n', '    */\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    /**\n', '    * @dev called by the owner to unpause, returns to normal state\n', '    */\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '}\n', '\n', 'contract SNC is SafeMath, Pausable {\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '\n', '    uint256 public totalSupply;\n', '\n', '    address public owner;\n', '    \n', '    mapping(address => uint256) public balanceOf;\n', '    mapping(address => mapping(address => uint256)) public allowance;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function SNC() public {\n', '        totalSupply = (10**8) * (10**8);\n', '        name = "Snow Coin";                                 // Set the name for display purposes\n', '        symbol = "SNC";                                     // Set the symbol for display purposes\n', '        decimals = 8;                                       // Amount of decimals for display purposes\n', '        owner = msg.sender;\n', '        balanceOf[owner] = totalSupply;                     // Give the creator all tokens\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool success) {\n', '        require(_value > 0);\n', '        require(balanceOf[msg.sender] >= _value);              // Check if the sender has enough\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);    // Check for overflows\n', '        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);   // Subtract from the sender\n', '        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                 // Add the same to the recipient\n', '        emit Transfer(msg.sender, _to, _value);                  // Notify anyone listening that this transfer took place\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;            // Set allowance\n', '        emit Approval(msg.sender, _spender, _value);              // Raise Approval event\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                  // Check if the sender has enough\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);   // Check for overflows\n', '        require(_value <= allowance[_from][msg.sender]);      // Check allowance\n', '        balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);    // Subtract from the sender\n', '        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);        // Add the same to the recipient\n', '        allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function totalSupply() constant public returns (uint256 Supply) {\n', '        return totalSupply;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant public returns (uint256 balance) {\n', '        return balanceOf[_owner];\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {\n', '        return allowance[_owner][_spender];\n', '    }\n', '\n', '    function() public payable {\n', '        revert();\n', '    }\n', '}']
['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * @title Snow Coin\n', ' * @author lan yuhang\n', ' */\n', '\n', 'contract SafeMath {\n', '    function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b > 0);\n', '        uint256 c = a / b;\n', '        assert(a == b * c + a % b);\n', '        return c;\n', '    }\n', '\n', '    function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a && c >= b);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '    * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '    * account.\n', '    */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '\n', '    /**\n', '    * @dev Modifier to make a function callable only when the contract is not paused.\n', '    */\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Modifier to make a function callable only when the contract is paused.\n', '    */\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev called by the owner to pause, triggers stopped state\n', '    */\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    /**\n', '    * @dev called by the owner to unpause, returns to normal state\n', '    */\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '}\n', '\n', 'contract SNC is SafeMath, Pausable {\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '\n', '    uint256 public totalSupply;\n', '\n', '    address public owner;\n', '    \n', '    mapping(address => uint256) public balanceOf;\n', '    mapping(address => mapping(address => uint256)) public allowance;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function SNC() public {\n', '        totalSupply = (10**8) * (10**8);\n', '        name = "Snow Coin";                                 // Set the name for display purposes\n', '        symbol = "SNC";                                     // Set the symbol for display purposes\n', '        decimals = 8;                                       // Amount of decimals for display purposes\n', '        owner = msg.sender;\n', '        balanceOf[owner] = totalSupply;                     // Give the creator all tokens\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool success) {\n', '        require(_value > 0);\n', '        require(balanceOf[msg.sender] >= _value);              // Check if the sender has enough\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);    // Check for overflows\n', '        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);   // Subtract from the sender\n', '        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                 // Add the same to the recipient\n', '        emit Transfer(msg.sender, _to, _value);                  // Notify anyone listening that this transfer took place\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;            // Set allowance\n', '        emit Approval(msg.sender, _spender, _value);              // Raise Approval event\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                  // Check if the sender has enough\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);   // Check for overflows\n', '        require(_value <= allowance[_from][msg.sender]);      // Check allowance\n', '        balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);    // Subtract from the sender\n', '        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);        // Add the same to the recipient\n', '        allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function totalSupply() constant public returns (uint256 Supply) {\n', '        return totalSupply;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant public returns (uint256 balance) {\n', '        return balanceOf[_owner];\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {\n', '        return allowance[_owner][_spender];\n', '    }\n', '\n', '    function() public payable {\n', '        revert();\n', '    }\n', '}']
