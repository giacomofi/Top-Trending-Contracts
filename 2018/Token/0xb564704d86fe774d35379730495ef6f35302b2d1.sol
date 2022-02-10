['pragma solidity ^0.4.18;\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    uint256 totalSupply_;\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract BurnableToken is BasicToken {\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '\n', '    function burn(uint256 _value) public {\n', '        require(_value <= balances[msg.sender]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', '        // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure\n', '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply_ = totalSupply_.sub(_value);\n', '        Burn(burner, _value);\n', '        Transfer(burner, address(0), _value);\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', '   @title ERC827 interface, an extension of ERC20 token standard\n', '   Interface of a ERC827 token, following the ERC20 standard with extra\n', '   methods to transfer value and data and execute calls in transfers and\n', '   approvals.\n', ' */\n', 'contract ERC827 is ERC20 {\n', '\n', '    function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);\n', '    function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);\n', '    function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', '   @title ERC827, an extension of ERC20 token standard\n', '   Implementation the ERC827, following the ERC20 standard with extra\n', '   methods to transfer value and data and execute calls in transfers and\n', '   approvals.\n', ' */\n', 'contract ERC827Token is ERC827, StandardToken {\n', '\n', '    function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {\n', '        require(_spender != address(this));\n', '\n', '        super.approve(_spender, _value);\n', '\n', '        require(_spender.call(_data));\n', '\n', '        return true;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {\n', '        require(_to != address(this));\n', '\n', '        super.transfer(_to, _value);\n', '\n', '        require(_to.call(_data));\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {\n', '        require(_to != address(this));\n', '\n', '        super.transferFrom(_from, _to, _value);\n', '\n', '        require(_to.call(_data));\n', '        return true;\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {\n', '        require(_spender != address(this));\n', '\n', '        super.increaseApproval(_spender, _addedValue);\n', '\n', '        require(_spender.call(_data));\n', '\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {\n', '        require(_spender != address(this));\n', '\n', '        super.decreaseApproval(_spender, _subtractedValue);\n', '\n', '        require(_spender.call(_data));\n', '\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to pause, triggers stopped state\n', '     */\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        Pause();\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to unpause, returns to normal state\n', '     */\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        Unpause();\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Pausable token\n', ' * @dev StandardToken modified with pausable transfers.\n', ' **/\n', 'contract PausableToken is StandardToken, Pausable {\n', '\n', '    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.approve(_spender, _value);\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {\n', '        return super.increaseApproval(_spender, _addedValue);\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {\n', '        return super.decreaseApproval(_spender, _subtractedValue);\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Pausable ERC827 token\n', ' * @dev ERC827 token modified with pausable functions.\n', ' **/\n', 'contract PausableERC827Token is ERC827Token, PausableToken {\n', '\n', '    function transfer(address _to, uint256 _value, bytes _data) public whenNotPaused returns (bool) {\n', '        return super.transfer(_to, _value, _data);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value, bytes _data) public whenNotPaused returns (bool) {\n', '        return super.transferFrom(_from, _to, _value, _data);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value, bytes _data) public whenNotPaused returns (bool) {\n', '        return super.approve(_spender, _value, _data);\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue, bytes _data) public whenNotPaused returns (bool) {\n', '        return super.increaseApproval(_spender, _addedValue, _data);\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public whenNotPaused returns (bool) {\n', '        return super.decreaseApproval(_spender, _subtractedValue, _data);\n', '    }\n', '}\n', '\n', '\n', 'contract COOPToken is PausableERC827Token, BurnableToken {\n', '\n', '    string public constant name = "Cooperative Exchange Token";\n', '    string public constant symbol = "COOP";\n', '    uint32 public constant decimals = 14;\n', '\n', '    function COOPToken() public {\n', '        totalSupply_ = 12000000E14;\n', '        balances[owner] = totalSupply_; // Add all tokens to issuer balance (crowdsale in this case)\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    uint256 totalSupply_;\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract BurnableToken is BasicToken {\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '\n', '    function burn(uint256 _value) public {\n', '        require(_value <= balances[msg.sender]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', "        // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply_ = totalSupply_.sub(_value);\n', '        Burn(burner, _value);\n', '        Transfer(burner, address(0), _value);\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', '   @title ERC827 interface, an extension of ERC20 token standard\n', '   Interface of a ERC827 token, following the ERC20 standard with extra\n', '   methods to transfer value and data and execute calls in transfers and\n', '   approvals.\n', ' */\n', 'contract ERC827 is ERC20 {\n', '\n', '    function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);\n', '    function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);\n', '    function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', '   @title ERC827, an extension of ERC20 token standard\n', '   Implementation the ERC827, following the ERC20 standard with extra\n', '   methods to transfer value and data and execute calls in transfers and\n', '   approvals.\n', ' */\n', 'contract ERC827Token is ERC827, StandardToken {\n', '\n', '    function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {\n', '        require(_spender != address(this));\n', '\n', '        super.approve(_spender, _value);\n', '\n', '        require(_spender.call(_data));\n', '\n', '        return true;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {\n', '        require(_to != address(this));\n', '\n', '        super.transfer(_to, _value);\n', '\n', '        require(_to.call(_data));\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {\n', '        require(_to != address(this));\n', '\n', '        super.transferFrom(_from, _to, _value);\n', '\n', '        require(_to.call(_data));\n', '        return true;\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {\n', '        require(_spender != address(this));\n', '\n', '        super.increaseApproval(_spender, _addedValue);\n', '\n', '        require(_spender.call(_data));\n', '\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {\n', '        require(_spender != address(this));\n', '\n', '        super.decreaseApproval(_spender, _subtractedValue);\n', '\n', '        require(_spender.call(_data));\n', '\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to pause, triggers stopped state\n', '     */\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        Pause();\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to unpause, returns to normal state\n', '     */\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        Unpause();\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Pausable token\n', ' * @dev StandardToken modified with pausable transfers.\n', ' **/\n', 'contract PausableToken is StandardToken, Pausable {\n', '\n', '    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.approve(_spender, _value);\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {\n', '        return super.increaseApproval(_spender, _addedValue);\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {\n', '        return super.decreaseApproval(_spender, _subtractedValue);\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Pausable ERC827 token\n', ' * @dev ERC827 token modified with pausable functions.\n', ' **/\n', 'contract PausableERC827Token is ERC827Token, PausableToken {\n', '\n', '    function transfer(address _to, uint256 _value, bytes _data) public whenNotPaused returns (bool) {\n', '        return super.transfer(_to, _value, _data);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value, bytes _data) public whenNotPaused returns (bool) {\n', '        return super.transferFrom(_from, _to, _value, _data);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value, bytes _data) public whenNotPaused returns (bool) {\n', '        return super.approve(_spender, _value, _data);\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue, bytes _data) public whenNotPaused returns (bool) {\n', '        return super.increaseApproval(_spender, _addedValue, _data);\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public whenNotPaused returns (bool) {\n', '        return super.decreaseApproval(_spender, _subtractedValue, _data);\n', '    }\n', '}\n', '\n', '\n', 'contract COOPToken is PausableERC827Token, BurnableToken {\n', '\n', '    string public constant name = "Cooperative Exchange Token";\n', '    string public constant symbol = "COOP";\n', '    uint32 public constant decimals = 14;\n', '\n', '    function COOPToken() public {\n', '        totalSupply_ = 12000000E14;\n', '        balances[owner] = totalSupply_; // Add all tokens to issuer balance (crowdsale in this case)\n', '    }\n', '\n', '}']
