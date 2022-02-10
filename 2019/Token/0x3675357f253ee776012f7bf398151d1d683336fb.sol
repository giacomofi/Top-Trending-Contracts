['pragma solidity ^0.4.25;\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    // Gas optimization: this is cheaper than asserting &#39;a&#39; not being zero, but the\n', '    // benefit is lost if &#39;b&#39; is also tested.\n', '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (_a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = _a * _b;\n', '    assert(c / _a == _b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    // assert(_b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = _a / _b;\n', '    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn&#39;t hold\n', '    return _a / _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    assert(_b <= _a);\n', '    return _a - _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    c = _a + _b;\n', '    assert(c >= _a);\n', '    return c;\n', '  }\n', '}\n', '/**\n', ' * ERC 20 token\n', ' *\n', ' * https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract GFOT  {\n', '    using SafeMath for uint256;\n', '\n', '    string public constant name = "WTO Fruit Organization Chain";\n', '    string public constant symbol = "GFOT";\n', '\n', '    uint public constant decimals = 18;\n', '\n', '    // Total supply is 21 billion\n', '    uint256 _totalSupply = 21000000000 * 10**decimals;\n', '\n', '    mapping(address => uint256) balances; //list of balance of each address\n', '    mapping(address => mapping (address => uint256)) allowed;\n', '\n', '    address public owner;\n', '\n', '    modifier ownerOnly {\n', '      require(\n', '            msg.sender == owner,\n', '            "Sender not authorized."\n', '        );\n', '        _;\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256 supply) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    //constructor\n', '    constructor(address _owner) public{\n', '        owner = _owner;\n', '        balances[owner] = _totalSupply;\n', '        emit Transfer(address(0x0), _owner, _totalSupply);\n', '    }\n', '\n', '    /**\n', '     * ERC 20 Standard Token interface transfer function\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        //Default assumes totalSupply can&#39;t be over max (2^256 - 1).\n', '        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn&#39;t wrap.\n', '        //Replace the if with this one instead.\n', '        if (balances[msg.sender] >= _value && balances[_to].add(_value) > balances[_to]) {\n', '            balances[msg.sender] = balances[msg.sender].sub(_value);\n', '            balances[_to] = balances[_to].add(_value);\n', '            emit Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * ERC 20 Standard Token interface transfer function\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        //same as above. Replace this line with the following if you want to protect against wrapping uints.\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to].add(_value) > balances[_to]) {\n', '            balances[_to] = _value.add(balances[_to]);\n', '            balances[_from] = balances[_from].sub(_value);\n', '            allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '            emit Transfer(_from, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Change owner address (where ICO ETH is being forwarded).\n', '     */\n', '    function changeOwner(address _newowner) public ownerOnly returns (bool success) {\n', '        owner = _newowner;\n', '        return true;\n', '    }\n', '\n', '    // only owner can kill\n', '    function kill() public ownerOnly {\n', '        selfdestruct(owner);\n', '    }\n', '}']
['pragma solidity ^0.4.25;\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', "    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (_a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = _a * _b;\n', '    assert(c / _a == _b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    // assert(_b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = _a / _b;\n', "    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold\n", '    return _a / _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    assert(_b <= _a);\n', '    return _a - _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    c = _a + _b;\n', '    assert(c >= _a);\n', '    return c;\n', '  }\n', '}\n', '/**\n', ' * ERC 20 token\n', ' *\n', ' * https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract GFOT  {\n', '    using SafeMath for uint256;\n', '\n', '    string public constant name = "WTO Fruit Organization Chain";\n', '    string public constant symbol = "GFOT";\n', '\n', '    uint public constant decimals = 18;\n', '\n', '    // Total supply is 21 billion\n', '    uint256 _totalSupply = 21000000000 * 10**decimals;\n', '\n', '    mapping(address => uint256) balances; //list of balance of each address\n', '    mapping(address => mapping (address => uint256)) allowed;\n', '\n', '    address public owner;\n', '\n', '    modifier ownerOnly {\n', '      require(\n', '            msg.sender == owner,\n', '            "Sender not authorized."\n', '        );\n', '        _;\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256 supply) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    //constructor\n', '    constructor(address _owner) public{\n', '        owner = _owner;\n', '        balances[owner] = _totalSupply;\n', '        emit Transfer(address(0x0), _owner, _totalSupply);\n', '    }\n', '\n', '    /**\n', '     * ERC 20 Standard Token interface transfer function\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', "        //Default assumes totalSupply can't be over max (2^256 - 1).\n", "        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.\n", '        //Replace the if with this one instead.\n', '        if (balances[msg.sender] >= _value && balances[_to].add(_value) > balances[_to]) {\n', '            balances[msg.sender] = balances[msg.sender].sub(_value);\n', '            balances[_to] = balances[_to].add(_value);\n', '            emit Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * ERC 20 Standard Token interface transfer function\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        //same as above. Replace this line with the following if you want to protect against wrapping uints.\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to].add(_value) > balances[_to]) {\n', '            balances[_to] = _value.add(balances[_to]);\n', '            balances[_from] = balances[_from].sub(_value);\n', '            allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '            emit Transfer(_from, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Change owner address (where ICO ETH is being forwarded).\n', '     */\n', '    function changeOwner(address _newowner) public ownerOnly returns (bool success) {\n', '        owner = _newowner;\n', '        return true;\n', '    }\n', '\n', '    // only owner can kill\n', '    function kill() public ownerOnly {\n', '        selfdestruct(owner);\n', '    }\n', '}']
