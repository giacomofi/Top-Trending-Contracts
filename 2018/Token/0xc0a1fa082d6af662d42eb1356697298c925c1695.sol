['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  \t/**\n', '  \t * @dev Multiplies two numbers, throws on overflow.\n', '  \t*/\n', '  \tfunction mul(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    \t// Gas optimization: this is cheaper than asserting &#39;a&#39; not being zero, but the\n', '    \t// benefit is lost if &#39;b&#39; is also tested.\n', '    \t// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    \tif (_a == 0) {\n', '      \t\treturn 0;\n', '    \t}\n', '\n', '    \tuint256 c = _a * _b;\n', '    \tassert(c / _a == _b);\n', '\n', '    \treturn c;\n', '  \t}\n', '\n', '  \t/**\n', '  \t * @dev Integer division of two numbers, truncating the quotient.\n', '  \t */\n', '  \tfunction div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    \t// assert(_b > 0); // Solidity automatically throws when dividing by 0\n', '    \tuint256 c = _a / _b;\n', '    \t// assert(_a == _b * c + _a % _b); // There is no case in which this doesn&#39;t hold\n', '\n', '    \treturn c;\n', '  \t}\n', '\n', '  \t/**\n', '  \t * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  \t */\n', '  \tfunction sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    \tassert(_b <= _a);\n', '    \tuint256 c = _a - _b;\n', '\n', '    \treturn c;\n', '  \t}\n', '\n', '  \t/**\n', '  \t * @dev Adds two numbers, throws on overflow.\n', '  \t */\n', '  \tfunction add(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    \tuint256 c = _a + _b;\n', '    \tassert(c >= _a);\n', '\n', '    \treturn c;\n', '  \t}\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of ""user permissions"".\n', ' */\n', 'contract Ownable {\n', '\n', '    address public owner;\n', '\n', '    address internal newOwner;\n', '\n', '    event OwnerUpdate(address _prevOwner, address _newOwner);\n', '\n', '  \t/**\n', '   \t * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   \t * account.\n', '   \t */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '        newOwner = address(0);\n', '    }\n', '\n', '  \t/**\n', '   \t * @dev Throws if called by any account other than the owner.\n', '   \t */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /*\n', '     * @dev Change the owner.\n', '     * @param _newOwner The new owner.\n', '     */\n', '    function changeOwner(address _newOwner) public onlyOwner {\n', '        require(_newOwner != owner);\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    /*\n', '     * @dev Accept the ownership.\n', '     */\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        \n', '        emit OwnerUpdate(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  \tevent Pause();\n', '  \tevent Unpause();\n', '\n', '  \tbool public paused = false;\n', '\n', '\n', '  \t/**\n', '   \t * @dev Modifier to make a function callable only when the contract is not paused.\n', '   \t */\n', '  \tmodifier whenNotPaused() {\n', '    \trequire(!paused);\n', '    \t_;\n', '  \t}\n', '\n', '  \t/**\n', '   \t * @dev Modifier to make a function callable only when the contract is paused.\n', '   \t */\n', '  \tmodifier whenPaused() {\n', '    \trequire(paused);\n', '    \t_;\n', '  \t}\n', '\n', '  \t/**\n', '   \t * @dev called by the owner to pause, triggers stopped state\n', '   \t */\n', '  \tfunction pause() public onlyOwner whenNotPaused {\n', '    \tpaused = true;\n', '    \temit Pause();\n', '  \t}\n', '\n', '  \t/**\n', '   \t * @dev called by the owner to unpause, returns to normal state\n', '   \t */\n', '  \tfunction unpause() public onlyOwner whenPaused {\n', '    \tpaused = false;\n', '    \temit Unpause();\n', '  \t}\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '  \tfunction totalSupply() public view returns (uint256);\n', '\n', '  \tfunction balanceOf(address _who) public view returns (uint256);\n', '\n', '  \tfunction allowance(address _owner, address _spender) public view returns (uint256);\n', '\n', '  \tfunction transfer(address _to, uint256 _value) public returns (bool);\n', '\n', '  \tfunction approve(address _spender, uint256 _value) public returns (bool);\n', '\n', '  \tfunction transferFrom(address _from, address _to, uint256 _value) public returns (bool);\n', '\n', '  \tevent Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '  \tevent Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract StandardToken is ERC20, Pausable {\n', '\t\n', '    using SafeMath for uint256;\n', '    \n', '    mapping(address => uint256) balances;\n', '    \n', '    mapping(address => mapping(address => uint256)) internal allowed;\n', '    \n', '    uint256 totalSupply_;\n', '    \n', '  \t/**\n', '     * @dev Total number of tokens in existence\n', '     */\n', '  \tfunction totalSupply() public view returns (uint256) {\n', '    \treturn totalSupply_;\n', '  \t}    \n', '    \n', '  \t/**\n', '  \t * @dev Gets the balance of the specified address.\n', '  \t * @param _owner The address to query the the balance of.\n', '  \t * @return An uint256 representing the amount owned by the passed address.\n', '  \t */    \n', '    function balanceOf(address _owner) public view returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '    \n', '  \t/**\n', '   \t * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   \t * @param _owner address The address which owns the funds.\n', '   \t * @param _spender address The address which will spend the funds.\n', '   \t * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   \t */    \n', '    function allowance(address _owner, address _spender) public view whenNotPaused returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '  \t/**\n', '  \t * @dev Transfer token for a specified address\n', '  \t * @param _to The address to transfer to.\n', '  \t * @param _value The amount to be transferred.\n', '  \t */    \n', '    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '    \trequire(_value <= balances[msg.sender]);\n', '    \trequire(_to != address(0));\n', '    \n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '  \t/**\n', '   \t * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   \t * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   \t * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   \t * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   \t * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   \t * @param _spender The address which will spend the funds.\n', '   \t * @param _value The amount of tokens to be spent.\n', '   \t */\n', '    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '  \t/**\n', '   \t * @dev Transfer tokens from one address to another\n', '   \t * @param _from address The address which you want to send tokens from\n', '   \t * @param _to address The address which you want to transfer to\n', '   \t * @param _value uint256 the amount of tokens to be transferred\n', '   \t */\n', '    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '\t    require(_value <= balances[_from]);\n', '\t    require(_value <= allowed[_from][msg.sender]);\n', '\t    require(_to != address(0));    \t\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '\t/**\n', '   \t * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   \t * approve should be called when allowed[_spender] == 0. To increment\n', '   \t * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   \t * the first transaction is mined)\n', '   \t * From MonolithDAO Token.sol\n', '   \t * @param _spender The address which will spend the funds.\n', '   \t * @param _addedValue The amount of tokens to increase the allowance by.\n', '   \t */\n', '    function increaseApproval(address _spender, uint256 _addedValue) public whenNotPaused returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '  \t/**\n', '   \t * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   \t * approve should be called when allowed[_spender] == 0. To decrement\n', '   \t * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   \t * the first transaction is mined)\n', '   \t * From MonolithDAO Token.sol\n', '   \t * @param _spender The address which will spend the funds.\n', '   \t * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   \t */\n', '    function decreaseApproval(address _spender, uint256 _subtractedValue) public whenNotPaused returns (bool) {\n', '    \tuint256 oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue >= oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '  \t/**\n', '   \t * @dev Decrease the amount of tokens that an owner allowed to a spender by spender self.\n', '   \t * approve should be called when allowed[msg.sender] == 0. To decrement\n', '   \t * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   \t * the first transaction is mined)\n', '   \t * From MonolithDAO Token.sol\n', '   \t * @param _from The address which will transfer the funds from.\n', '   \t * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   \t */\n', '    function spenderDecreaseApproval(address _from, uint256 _subtractedValue) public whenNotPaused returns (bool) {\n', '    \tuint256 oldValue = allowed[_from][msg.sender];\n', '        if (_subtractedValue >= oldValue) {\n', '            allowed[_from][msg.sender] = 0;\n', '        } else {\n', '            allowed[_from][msg.sender] = oldValue.sub(_subtractedValue);\n', '        }\n', '\n', '        emit Approval(_from, msg.sender, allowed[_from][msg.sender]);\n', '        return true;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title BCL token.\n', ' * @dev Issued by blockchainlock.io\n', ' */\n', 'contract BCLToken is StandardToken {\n', '    string public name = "Blockchainlock Token";\n', '    string public symbol = "BCL";\n', '    uint8 public decimals = 18;\n', '\n', '  \t/**\n', '   \t * @dev The BCLToken constructor\n', '   \t */\n', '    constructor() public {\n', '        totalSupply_ = 360 * (10**26);\t\t\t// 36 billions\n', '        balances[msg.sender] = totalSupply_; \t// Give the creator all initial tokens\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  \t/**\n', '  \t * @dev Multiplies two numbers, throws on overflow.\n', '  \t*/\n', '  \tfunction mul(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', "    \t// Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "    \t// benefit is lost if 'b' is also tested.\n", '    \t// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    \tif (_a == 0) {\n', '      \t\treturn 0;\n', '    \t}\n', '\n', '    \tuint256 c = _a * _b;\n', '    \tassert(c / _a == _b);\n', '\n', '    \treturn c;\n', '  \t}\n', '\n', '  \t/**\n', '  \t * @dev Integer division of two numbers, truncating the quotient.\n', '  \t */\n', '  \tfunction div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    \t// assert(_b > 0); // Solidity automatically throws when dividing by 0\n', '    \tuint256 c = _a / _b;\n', "    \t// assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold\n", '\n', '    \treturn c;\n', '  \t}\n', '\n', '  \t/**\n', '  \t * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  \t */\n', '  \tfunction sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    \tassert(_b <= _a);\n', '    \tuint256 c = _a - _b;\n', '\n', '    \treturn c;\n', '  \t}\n', '\n', '  \t/**\n', '  \t * @dev Adds two numbers, throws on overflow.\n', '  \t */\n', '  \tfunction add(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    \tuint256 c = _a + _b;\n', '    \tassert(c >= _a);\n', '\n', '    \treturn c;\n', '  \t}\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of ""user permissions"".\n', ' */\n', 'contract Ownable {\n', '\n', '    address public owner;\n', '\n', '    address internal newOwner;\n', '\n', '    event OwnerUpdate(address _prevOwner, address _newOwner);\n', '\n', '  \t/**\n', '   \t * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   \t * account.\n', '   \t */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '        newOwner = address(0);\n', '    }\n', '\n', '  \t/**\n', '   \t * @dev Throws if called by any account other than the owner.\n', '   \t */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /*\n', '     * @dev Change the owner.\n', '     * @param _newOwner The new owner.\n', '     */\n', '    function changeOwner(address _newOwner) public onlyOwner {\n', '        require(_newOwner != owner);\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    /*\n', '     * @dev Accept the ownership.\n', '     */\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        \n', '        emit OwnerUpdate(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  \tevent Pause();\n', '  \tevent Unpause();\n', '\n', '  \tbool public paused = false;\n', '\n', '\n', '  \t/**\n', '   \t * @dev Modifier to make a function callable only when the contract is not paused.\n', '   \t */\n', '  \tmodifier whenNotPaused() {\n', '    \trequire(!paused);\n', '    \t_;\n', '  \t}\n', '\n', '  \t/**\n', '   \t * @dev Modifier to make a function callable only when the contract is paused.\n', '   \t */\n', '  \tmodifier whenPaused() {\n', '    \trequire(paused);\n', '    \t_;\n', '  \t}\n', '\n', '  \t/**\n', '   \t * @dev called by the owner to pause, triggers stopped state\n', '   \t */\n', '  \tfunction pause() public onlyOwner whenNotPaused {\n', '    \tpaused = true;\n', '    \temit Pause();\n', '  \t}\n', '\n', '  \t/**\n', '   \t * @dev called by the owner to unpause, returns to normal state\n', '   \t */\n', '  \tfunction unpause() public onlyOwner whenPaused {\n', '    \tpaused = false;\n', '    \temit Unpause();\n', '  \t}\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '  \tfunction totalSupply() public view returns (uint256);\n', '\n', '  \tfunction balanceOf(address _who) public view returns (uint256);\n', '\n', '  \tfunction allowance(address _owner, address _spender) public view returns (uint256);\n', '\n', '  \tfunction transfer(address _to, uint256 _value) public returns (bool);\n', '\n', '  \tfunction approve(address _spender, uint256 _value) public returns (bool);\n', '\n', '  \tfunction transferFrom(address _from, address _to, uint256 _value) public returns (bool);\n', '\n', '  \tevent Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '  \tevent Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract StandardToken is ERC20, Pausable {\n', '\t\n', '    using SafeMath for uint256;\n', '    \n', '    mapping(address => uint256) balances;\n', '    \n', '    mapping(address => mapping(address => uint256)) internal allowed;\n', '    \n', '    uint256 totalSupply_;\n', '    \n', '  \t/**\n', '     * @dev Total number of tokens in existence\n', '     */\n', '  \tfunction totalSupply() public view returns (uint256) {\n', '    \treturn totalSupply_;\n', '  \t}    \n', '    \n', '  \t/**\n', '  \t * @dev Gets the balance of the specified address.\n', '  \t * @param _owner The address to query the the balance of.\n', '  \t * @return An uint256 representing the amount owned by the passed address.\n', '  \t */    \n', '    function balanceOf(address _owner) public view returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '    \n', '  \t/**\n', '   \t * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   \t * @param _owner address The address which owns the funds.\n', '   \t * @param _spender address The address which will spend the funds.\n', '   \t * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   \t */    \n', '    function allowance(address _owner, address _spender) public view whenNotPaused returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '  \t/**\n', '  \t * @dev Transfer token for a specified address\n', '  \t * @param _to The address to transfer to.\n', '  \t * @param _value The amount to be transferred.\n', '  \t */    \n', '    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '    \trequire(_value <= balances[msg.sender]);\n', '    \trequire(_to != address(0));\n', '    \n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '  \t/**\n', '   \t * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   \t * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   \t * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   \t * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   \t * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   \t * @param _spender The address which will spend the funds.\n', '   \t * @param _value The amount of tokens to be spent.\n', '   \t */\n', '    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '  \t/**\n', '   \t * @dev Transfer tokens from one address to another\n', '   \t * @param _from address The address which you want to send tokens from\n', '   \t * @param _to address The address which you want to transfer to\n', '   \t * @param _value uint256 the amount of tokens to be transferred\n', '   \t */\n', '    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '\t    require(_value <= balances[_from]);\n', '\t    require(_value <= allowed[_from][msg.sender]);\n', '\t    require(_to != address(0));    \t\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '\t/**\n', '   \t * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   \t * approve should be called when allowed[_spender] == 0. To increment\n', '   \t * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   \t * the first transaction is mined)\n', '   \t * From MonolithDAO Token.sol\n', '   \t * @param _spender The address which will spend the funds.\n', '   \t * @param _addedValue The amount of tokens to increase the allowance by.\n', '   \t */\n', '    function increaseApproval(address _spender, uint256 _addedValue) public whenNotPaused returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '  \t/**\n', '   \t * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   \t * approve should be called when allowed[_spender] == 0. To decrement\n', '   \t * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   \t * the first transaction is mined)\n', '   \t * From MonolithDAO Token.sol\n', '   \t * @param _spender The address which will spend the funds.\n', '   \t * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   \t */\n', '    function decreaseApproval(address _spender, uint256 _subtractedValue) public whenNotPaused returns (bool) {\n', '    \tuint256 oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue >= oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '  \t/**\n', '   \t * @dev Decrease the amount of tokens that an owner allowed to a spender by spender self.\n', '   \t * approve should be called when allowed[msg.sender] == 0. To decrement\n', '   \t * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   \t * the first transaction is mined)\n', '   \t * From MonolithDAO Token.sol\n', '   \t * @param _from The address which will transfer the funds from.\n', '   \t * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   \t */\n', '    function spenderDecreaseApproval(address _from, uint256 _subtractedValue) public whenNotPaused returns (bool) {\n', '    \tuint256 oldValue = allowed[_from][msg.sender];\n', '        if (_subtractedValue >= oldValue) {\n', '            allowed[_from][msg.sender] = 0;\n', '        } else {\n', '            allowed[_from][msg.sender] = oldValue.sub(_subtractedValue);\n', '        }\n', '\n', '        emit Approval(_from, msg.sender, allowed[_from][msg.sender]);\n', '        return true;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title BCL token.\n', ' * @dev Issued by blockchainlock.io\n', ' */\n', 'contract BCLToken is StandardToken {\n', '    string public name = "Blockchainlock Token";\n', '    string public symbol = "BCL";\n', '    uint8 public decimals = 18;\n', '\n', '  \t/**\n', '   \t * @dev The BCLToken constructor\n', '   \t */\n', '    constructor() public {\n', '        totalSupply_ = 360 * (10**26);\t\t\t// 36 billions\n', '        balances[msg.sender] = totalSupply_; \t// Give the creator all initial tokens\n', '    }\n', '}']
