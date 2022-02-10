['pragma solidity ^0.4.23;\n', '\n', 'library SafeMath {\n', '\n', ' \n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    // Gas optimization: this is cheaper than asserting &#39;a&#39; not being zero, but the\n', '    // benefit is lost if &#39;b&#39; is also tested.\n', '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  \n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  \n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  \n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '\n', 'contract Bitcrore is Ownable{\n', 'using SafeMath for uint256;\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 8;\n', '    uint256 public totalSupply;\n', '    uint256 public releaseTime;\n', '    \n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    mapping (address => bool) public frozenAccount;\n', '    \n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Burn(address indexed from, uint256 value);\n', '    event FrozenFunds(address target, bool frozen);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    \n', '    constructor (uint256 initialSupply,string tokenName,string tokenSymbol,uint256 _releaseTime) public\n', '    {\n', '        releaseTime = _releaseTime;\n', '        totalSupply = initialSupply;  // Update total supply with the decimal amount\n', '        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens\n', '        name = tokenName;                                   // Set the name for display purposes\n', '        symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '    }\n', '    \n', '    function _transfer(address _from, address _to, uint256 _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to].add(_value) > balanceOf[_to]);\n', '        // Save this for an assertion in the future\n', '        uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);\n', '        // Subtract from the sender\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '        // Add the same to the recipient\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        require(now >= releaseTime);\n', '        require(!frozenAccount[_to]);\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance( address _owner, address _spender  ) public view returns (uint256)\n', '    {\n', '        return allowance[_owner][_spender];\n', '    }\n', '  \n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(now >= releaseTime);\n', '        require(!frozenAccount[_from]);\n', '        require(!frozenAccount[_to]);\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function distributeToken(address[] addresses, uint256[] _value) public onlyOwner returns (bool success){\n', '        //require(msg.sender == owner);\n', '        assert (addresses.length == _value.length);\n', '        for (uint i = 0; i < addresses.length; i++) {\n', '            _transfer(msg.sender, addresses[i], _value[i]);\n', '        }\n', '        return true;\n', '    }\n', '    \n', '    function burn(uint256 _value) public onlyOwner returns (bool success) {\n', '        //require(msg.sender == owner);\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender\n', '        totalSupply =totalSupply.sub(_value);                      // Updates totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        emit Transfer(msg.sender, 0x0 , _value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(address _from, uint256 _value) public onlyOwner returns (bool success) {\n', '        //require(msg.sender == owner);\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(!frozenAccount[_from]);\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance\n', '        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender&#39;s allowance\n', '        totalSupply = totalSupply.sub(_value);                              // Update totalSupply\n', '        emit Burn(_from, _value);\n', '        emit Transfer(msg.sender, 0x0 , _value);\n', '        return true;\n', '    }\n', '    \n', '    function freezeAccount(address target, bool freeze) public onlyOwner {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        require(!frozenAccount[_spender]);\n', '        require(!frozenAccount[msg.sender]);\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function increaseApproval( address _spender, uint256 _addedValue) public returns (bool)  {\n', '        require(!frozenAccount[_spender]);\n', '        require(!frozenAccount[msg.sender]);\n', '        allowance[msg.sender][_spender] = (\n', '        allowance[msg.sender][_spender].add(_addedValue));\n', '        emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '  \n', '    function decreaseApproval( address _spender, uint256 _subtractedValue ) public returns (bool)  {\n', '        require(!frozenAccount[_spender]);\n', '        require(!frozenAccount[msg.sender]);\n', '        uint256 oldValue = allowance[msg.sender][_spender];\n', '        if (_subtractedValue >= oldValue) {\n', '          allowance[msg.sender][_spender] = 0;\n', '        } else {\n', '          allowance[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.23;\n', '\n', 'library SafeMath {\n', '\n', ' \n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', "    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  \n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  \n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  \n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '\n', 'contract Bitcrore is Ownable{\n', 'using SafeMath for uint256;\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 8;\n', '    uint256 public totalSupply;\n', '    uint256 public releaseTime;\n', '    \n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    mapping (address => bool) public frozenAccount;\n', '    \n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Burn(address indexed from, uint256 value);\n', '    event FrozenFunds(address target, bool frozen);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    \n', '    constructor (uint256 initialSupply,string tokenName,string tokenSymbol,uint256 _releaseTime) public\n', '    {\n', '        releaseTime = _releaseTime;\n', '        totalSupply = initialSupply;  // Update total supply with the decimal amount\n', '        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens\n', '        name = tokenName;                                   // Set the name for display purposes\n', '        symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '    }\n', '    \n', '    function _transfer(address _from, address _to, uint256 _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to].add(_value) > balanceOf[_to]);\n', '        // Save this for an assertion in the future\n', '        uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);\n', '        // Subtract from the sender\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '        // Add the same to the recipient\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        require(now >= releaseTime);\n', '        require(!frozenAccount[_to]);\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance( address _owner, address _spender  ) public view returns (uint256)\n', '    {\n', '        return allowance[_owner][_spender];\n', '    }\n', '  \n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(now >= releaseTime);\n', '        require(!frozenAccount[_from]);\n', '        require(!frozenAccount[_to]);\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function distributeToken(address[] addresses, uint256[] _value) public onlyOwner returns (bool success){\n', '        //require(msg.sender == owner);\n', '        assert (addresses.length == _value.length);\n', '        for (uint i = 0; i < addresses.length; i++) {\n', '            _transfer(msg.sender, addresses[i], _value[i]);\n', '        }\n', '        return true;\n', '    }\n', '    \n', '    function burn(uint256 _value) public onlyOwner returns (bool success) {\n', '        //require(msg.sender == owner);\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender\n', '        totalSupply =totalSupply.sub(_value);                      // Updates totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        emit Transfer(msg.sender, 0x0 , _value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(address _from, uint256 _value) public onlyOwner returns (bool success) {\n', '        //require(msg.sender == owner);\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(!frozenAccount[_from]);\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance\n', "        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance\n", '        totalSupply = totalSupply.sub(_value);                              // Update totalSupply\n', '        emit Burn(_from, _value);\n', '        emit Transfer(msg.sender, 0x0 , _value);\n', '        return true;\n', '    }\n', '    \n', '    function freezeAccount(address target, bool freeze) public onlyOwner {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        require(!frozenAccount[_spender]);\n', '        require(!frozenAccount[msg.sender]);\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function increaseApproval( address _spender, uint256 _addedValue) public returns (bool)  {\n', '        require(!frozenAccount[_spender]);\n', '        require(!frozenAccount[msg.sender]);\n', '        allowance[msg.sender][_spender] = (\n', '        allowance[msg.sender][_spender].add(_addedValue));\n', '        emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '  \n', '    function decreaseApproval( address _spender, uint256 _subtractedValue ) public returns (bool)  {\n', '        require(!frozenAccount[_spender]);\n', '        require(!frozenAccount[msg.sender]);\n', '        uint256 oldValue = allowance[msg.sender][_spender];\n', '        if (_subtractedValue >= oldValue) {\n', '          allowance[msg.sender][_spender] = 0;\n', '        } else {\n', '          allowance[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}']