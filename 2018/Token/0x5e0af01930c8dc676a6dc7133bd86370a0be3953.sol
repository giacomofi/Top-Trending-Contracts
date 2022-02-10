['/**\n', ' * @title Moderated\n', ' * @dev restricts execution of &#39;onlyModerator&#39; modified functions to the contract moderator\n', ' * @dev restricts execution of &#39;ifUnrestricted&#39; modified functions to when unrestricted\n', ' *      boolean state is true\n', ' * @dev allows for the extraction of ether or other ERC20 tokens mistakenly sent to this address\n', ' */\n', 'contract Moderated {\n', '\n', '    address public moderator;\n', '\n', '    bool public unrestricted;\n', '\n', '    modifier onlyModerator {\n', '        require(msg.sender == moderator);\n', '        _;\n', '    }\n', '\n', '    modifier ifUnrestricted {\n', '        require(unrestricted);\n', '        _;\n', '    }\n', '\n', '    modifier onlyPayloadSize(uint numWords) {\n', '        assert(msg.data.length >= numWords * 32 + 4);\n', '        _;\n', '    }\n', '\n', '    function Moderated() public {\n', '        moderator = msg.sender;\n', '        unrestricted = true;\n', '    }\n', '\n', '    function reassignModerator(address newModerator) public onlyModerator {\n', '        moderator = newModerator;\n', '    }\n', '\n', '    function restrict() public onlyModerator {\n', '        unrestricted = false;\n', '    }\n', '\n', '    function unrestrict() public onlyModerator {\n', '        unrestricted = true;\n', '    }\n', '\n', '    /// This method can be used to extract tokens mistakenly sent to this contract.\n', '    /// @param _token The address of the token contract that you want to recover\n', '    function extract(address _token) public returns (bool) {\n', '        require(_token != address(0x0));\n', '        Token token = Token(_token);\n', '        uint256 balance = token.balanceOf(this);\n', '        return token.transfer(moderator, balance);\n', '    }\n', '\n', '    function isContract(address _addr) internal view returns (bool) {\n', '        uint256 size;\n', '        assembly { size := extcodesize(_addr) }\n', '        return (size > 0);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract Token {\n', '\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations that are safe for uint256 against overflow and negative values\n', ' * @dev https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol\n', ' */\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// @dev Assign moderation of contract to CrowdSale\n', '\n', 'contract Touch is Moderated {\n', '\tusing SafeMath for uint256;\n', '\n', '\t\tstring public name = "Touch. Token";\n', '\t\tstring public symbol = "TST";\n', '\t\tuint8 public decimals = 18;\n', '\n', '        uint256 public maximumTokenIssue = 1000000000 * 10**18;\n', '\n', '\t\tmapping(address => uint256) internal balances;\n', '\t\tmapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\t\tuint256 internal totalSupply_;\n', '\n', '\t\tevent Approval(address indexed owner, address indexed spender, uint256 value);\n', '\t\tevent Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '\t\t/**\n', '\t\t* @dev total number of tokens in existence\n', '\t\t*/\n', '\t\tfunction totalSupply() public view returns (uint256) {\n', '\t\t\treturn totalSupply_;\n', '\t\t}\n', '\n', '\t\t/**\n', '\t\t* @dev transfer token for a specified address\n', '\t\t* @param _to The address to transfer to.\n', '\t\t* @param _value The amount to be transferred.\n', '\t\t*/\n', '\t\tfunction transfer(address _to, uint256 _value) public ifUnrestricted onlyPayloadSize(2) returns (bool) {\n', '\t\t    return _transfer(msg.sender, _to, _value);\n', '\t\t}\n', '\n', '\t\t/**\n', '\t\t* @dev Transfer tokens from one address to another\n', '\t\t* @param _from address The address which you want to send tokens from\n', '\t\t* @param _to address The address which you want to transfer to\n', '\t\t* @param _value uint256 the amount of tokens to be transferred\n', '\t\t*/\n', '\t\tfunction transferFrom(address _from, address _to, uint256 _value) public ifUnrestricted onlyPayloadSize(3) returns (bool) {\n', '\t\t    require(_value <= allowed[_from][msg.sender]);\n', '\t\t    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '\t\t    return _transfer(_from, _to, _value);\n', '\t\t}\n', '\n', '\t\tfunction _transfer(address _from, address _to, uint256 _value) internal returns (bool) {\n', '\t\t\t// Do not allow transfers to 0x0 or to this contract\n', '\t\t\trequire(_to != address(0x0) && _to != address(this));\n', '\t\t\t// Do not allow transfer of value greater than sender&#39;s current balance\n', '\t\t\trequire(_value <= balances[_from]);\n', '\t\t\t// Update balance of sending address\n', '\t\t\tbalances[_from] = balances[_from].sub(_value);\n', '\t\t\t// Update balance of receiving address\n', '\t\t\tbalances[_to] = balances[_to].add(_value);\n', '\t\t\t// An event to make the transfer easy to find on the blockchain\n', '\t\t\tTransfer(_from, _to, _value);\n', '\t\t\treturn true;\n', '\t\t}\n', '\n', '\t\t/**\n', '\t\t* @dev Gets the balance of the specified address.\n', '\t\t* @param _owner The address to query the the balance of.\n', '\t\t* @return An uint256 representing the amount owned by the passed address.\n', '\t\t*/\n', '\t\tfunction balanceOf(address _owner) public view returns (uint256) {\n', '\t\t\treturn balances[_owner];\n', '\t\t}\n', '\n', '\t\t/**\n', '\t\t* @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '\t\t*\n', '\t\t* Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '\t\t* and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '\t\t* race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '\t\t* https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '\t\t* @param _spender The address which will spend the funds.\n', '\t\t* @param _value The amount of tokens to be spent.\n', '\t\t*/\n', '\t\tfunction approve(address _spender, uint256 _value) public ifUnrestricted onlyPayloadSize(2) returns (bool sucess) {\n', '\t\t\t// Can only approve when value has not already been set or is zero\n', '\t\t\trequire(allowed[msg.sender][_spender] == 0 || _value == 0);\n', '\t\t\tallowed[msg.sender][_spender] = _value;\n', '\t\t\tApproval(msg.sender, _spender, _value);\n', '\t\t\treturn true;\n', '\t\t}\n', '\n', '\t\t/**\n', '\t\t* @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '\t\t* @param _owner address The address which owns the funds.\n', '\t\t* @param _spender address The address which will spend the funds.\n', '\t\t* @return A uint256 specifying the amount of tokens still available for the spender.\n', '\t\t*/\n', '\t\tfunction allowance(address _owner, address _spender) public view returns (uint256) {\n', '\t\t\treturn allowed[_owner][_spender];\n', '\t\t}\n', '\n', '\t\t/**\n', '\t\t* @dev Increase the amount of tokens that an owner allowed to a spender.\n', '\t\t*\n', '\t\t* approve should be called when allowed[_spender] == 0. To increment\n', '\t\t* allowed value is better to use this function to avoid 2 calls (and wait until\n', '\t\t* the first transaction is mined)\n', '\t\t* From MonolithDAO Token.sol\n', '\t\t* @param _spender The address which will spend the funds.\n', '\t\t* @param _addedValue The amount of tokens to increase the allowance by.\n', '\t\t*/\n', '\t\tfunction increaseApproval(address _spender, uint256 _addedValue) public ifUnrestricted onlyPayloadSize(2) returns (bool) {\n', '\t\t\trequire(_addedValue > 0);\n', '\t\t\tallowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '\t\t\tApproval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\t\t\treturn true;\n', '\t\t}\n', '\n', '\t\t/**\n', '\t\t* @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '\t\t*\n', '\t\t* approve should be called when allowed[_spender] == 0. To decrement\n', '\t\t* allowed value is better to use this function to avoid 2 calls (and wait until\n', '\t\t* the first transaction is mined)\n', '\t\t* From MonolithDAO Token.sol\n', '\t\t* @param _spender The address which will spend the funds.\n', '\t\t* @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '\t\t*/\n', '\t\tfunction decreaseApproval(address _spender, uint256 _subtractedValue) public ifUnrestricted onlyPayloadSize(2) returns (bool) {\n', '\t\t\tuint256 oldValue = allowed[msg.sender][_spender];\n', '\t\t\trequire(_subtractedValue > 0);\n', '\t\t\tif (_subtractedValue > oldValue) {\n', '\t\t\t\tallowed[msg.sender][_spender] = 0;\n', '\t\t\t} else {\n', '\t\t\t\tallowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '\t\t\t}\n', '\t\t\tApproval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\t\t\treturn true;\n', '\t\t}\n', '\n', '\t\t/**\n', '\t\t* @dev Function to mint tokens\n', '\t\t* @param _to The address that will receive the minted tokens.\n', '\t\t* @param _amount The amount of tokens to mint.\n', '\t\t* @return A boolean that indicates if the operation was successful.\n', '\t\t*/\n', '\t\tfunction generateTokens(address _to, uint _amount) internal returns (bool) {\n', '\t\t\ttotalSupply_ = totalSupply_.add(_amount);\n', '\t\t\tbalances[_to] = balances[_to].add(_amount);\n', '\t\t\tTransfer(address(0x0), _to, _amount);\n', '\t\t\treturn true;\n', '\t\t}\n', '\t\t/**\n', '\t\t* @dev fallback function - reverts transaction\n', '\t\t*/\n', '    \tfunction () external payable {\n', '    \t    revert();\n', '    \t}\n', '\n', '    \tfunction Touch () public {\n', '    \t\tgenerateTokens(msg.sender, maximumTokenIssue);\n', '    \t}\n', '\n', '}']
['/**\n', ' * @title Moderated\n', " * @dev restricts execution of 'onlyModerator' modified functions to the contract moderator\n", " * @dev restricts execution of 'ifUnrestricted' modified functions to when unrestricted\n", ' *      boolean state is true\n', ' * @dev allows for the extraction of ether or other ERC20 tokens mistakenly sent to this address\n', ' */\n', 'contract Moderated {\n', '\n', '    address public moderator;\n', '\n', '    bool public unrestricted;\n', '\n', '    modifier onlyModerator {\n', '        require(msg.sender == moderator);\n', '        _;\n', '    }\n', '\n', '    modifier ifUnrestricted {\n', '        require(unrestricted);\n', '        _;\n', '    }\n', '\n', '    modifier onlyPayloadSize(uint numWords) {\n', '        assert(msg.data.length >= numWords * 32 + 4);\n', '        _;\n', '    }\n', '\n', '    function Moderated() public {\n', '        moderator = msg.sender;\n', '        unrestricted = true;\n', '    }\n', '\n', '    function reassignModerator(address newModerator) public onlyModerator {\n', '        moderator = newModerator;\n', '    }\n', '\n', '    function restrict() public onlyModerator {\n', '        unrestricted = false;\n', '    }\n', '\n', '    function unrestrict() public onlyModerator {\n', '        unrestricted = true;\n', '    }\n', '\n', '    /// This method can be used to extract tokens mistakenly sent to this contract.\n', '    /// @param _token The address of the token contract that you want to recover\n', '    function extract(address _token) public returns (bool) {\n', '        require(_token != address(0x0));\n', '        Token token = Token(_token);\n', '        uint256 balance = token.balanceOf(this);\n', '        return token.transfer(moderator, balance);\n', '    }\n', '\n', '    function isContract(address _addr) internal view returns (bool) {\n', '        uint256 size;\n', '        assembly { size := extcodesize(_addr) }\n', '        return (size > 0);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract Token {\n', '\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations that are safe for uint256 against overflow and negative values\n', ' * @dev https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol\n', ' */\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// @dev Assign moderation of contract to CrowdSale\n', '\n', 'contract Touch is Moderated {\n', '\tusing SafeMath for uint256;\n', '\n', '\t\tstring public name = "Touch. Token";\n', '\t\tstring public symbol = "TST";\n', '\t\tuint8 public decimals = 18;\n', '\n', '        uint256 public maximumTokenIssue = 1000000000 * 10**18;\n', '\n', '\t\tmapping(address => uint256) internal balances;\n', '\t\tmapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\t\tuint256 internal totalSupply_;\n', '\n', '\t\tevent Approval(address indexed owner, address indexed spender, uint256 value);\n', '\t\tevent Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '\t\t/**\n', '\t\t* @dev total number of tokens in existence\n', '\t\t*/\n', '\t\tfunction totalSupply() public view returns (uint256) {\n', '\t\t\treturn totalSupply_;\n', '\t\t}\n', '\n', '\t\t/**\n', '\t\t* @dev transfer token for a specified address\n', '\t\t* @param _to The address to transfer to.\n', '\t\t* @param _value The amount to be transferred.\n', '\t\t*/\n', '\t\tfunction transfer(address _to, uint256 _value) public ifUnrestricted onlyPayloadSize(2) returns (bool) {\n', '\t\t    return _transfer(msg.sender, _to, _value);\n', '\t\t}\n', '\n', '\t\t/**\n', '\t\t* @dev Transfer tokens from one address to another\n', '\t\t* @param _from address The address which you want to send tokens from\n', '\t\t* @param _to address The address which you want to transfer to\n', '\t\t* @param _value uint256 the amount of tokens to be transferred\n', '\t\t*/\n', '\t\tfunction transferFrom(address _from, address _to, uint256 _value) public ifUnrestricted onlyPayloadSize(3) returns (bool) {\n', '\t\t    require(_value <= allowed[_from][msg.sender]);\n', '\t\t    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '\t\t    return _transfer(_from, _to, _value);\n', '\t\t}\n', '\n', '\t\tfunction _transfer(address _from, address _to, uint256 _value) internal returns (bool) {\n', '\t\t\t// Do not allow transfers to 0x0 or to this contract\n', '\t\t\trequire(_to != address(0x0) && _to != address(this));\n', "\t\t\t// Do not allow transfer of value greater than sender's current balance\n", '\t\t\trequire(_value <= balances[_from]);\n', '\t\t\t// Update balance of sending address\n', '\t\t\tbalances[_from] = balances[_from].sub(_value);\n', '\t\t\t// Update balance of receiving address\n', '\t\t\tbalances[_to] = balances[_to].add(_value);\n', '\t\t\t// An event to make the transfer easy to find on the blockchain\n', '\t\t\tTransfer(_from, _to, _value);\n', '\t\t\treturn true;\n', '\t\t}\n', '\n', '\t\t/**\n', '\t\t* @dev Gets the balance of the specified address.\n', '\t\t* @param _owner The address to query the the balance of.\n', '\t\t* @return An uint256 representing the amount owned by the passed address.\n', '\t\t*/\n', '\t\tfunction balanceOf(address _owner) public view returns (uint256) {\n', '\t\t\treturn balances[_owner];\n', '\t\t}\n', '\n', '\t\t/**\n', '\t\t* @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '\t\t*\n', '\t\t* Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '\t\t* and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "\t\t* race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '\t\t* https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '\t\t* @param _spender The address which will spend the funds.\n', '\t\t* @param _value The amount of tokens to be spent.\n', '\t\t*/\n', '\t\tfunction approve(address _spender, uint256 _value) public ifUnrestricted onlyPayloadSize(2) returns (bool sucess) {\n', '\t\t\t// Can only approve when value has not already been set or is zero\n', '\t\t\trequire(allowed[msg.sender][_spender] == 0 || _value == 0);\n', '\t\t\tallowed[msg.sender][_spender] = _value;\n', '\t\t\tApproval(msg.sender, _spender, _value);\n', '\t\t\treturn true;\n', '\t\t}\n', '\n', '\t\t/**\n', '\t\t* @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '\t\t* @param _owner address The address which owns the funds.\n', '\t\t* @param _spender address The address which will spend the funds.\n', '\t\t* @return A uint256 specifying the amount of tokens still available for the spender.\n', '\t\t*/\n', '\t\tfunction allowance(address _owner, address _spender) public view returns (uint256) {\n', '\t\t\treturn allowed[_owner][_spender];\n', '\t\t}\n', '\n', '\t\t/**\n', '\t\t* @dev Increase the amount of tokens that an owner allowed to a spender.\n', '\t\t*\n', '\t\t* approve should be called when allowed[_spender] == 0. To increment\n', '\t\t* allowed value is better to use this function to avoid 2 calls (and wait until\n', '\t\t* the first transaction is mined)\n', '\t\t* From MonolithDAO Token.sol\n', '\t\t* @param _spender The address which will spend the funds.\n', '\t\t* @param _addedValue The amount of tokens to increase the allowance by.\n', '\t\t*/\n', '\t\tfunction increaseApproval(address _spender, uint256 _addedValue) public ifUnrestricted onlyPayloadSize(2) returns (bool) {\n', '\t\t\trequire(_addedValue > 0);\n', '\t\t\tallowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '\t\t\tApproval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\t\t\treturn true;\n', '\t\t}\n', '\n', '\t\t/**\n', '\t\t* @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '\t\t*\n', '\t\t* approve should be called when allowed[_spender] == 0. To decrement\n', '\t\t* allowed value is better to use this function to avoid 2 calls (and wait until\n', '\t\t* the first transaction is mined)\n', '\t\t* From MonolithDAO Token.sol\n', '\t\t* @param _spender The address which will spend the funds.\n', '\t\t* @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '\t\t*/\n', '\t\tfunction decreaseApproval(address _spender, uint256 _subtractedValue) public ifUnrestricted onlyPayloadSize(2) returns (bool) {\n', '\t\t\tuint256 oldValue = allowed[msg.sender][_spender];\n', '\t\t\trequire(_subtractedValue > 0);\n', '\t\t\tif (_subtractedValue > oldValue) {\n', '\t\t\t\tallowed[msg.sender][_spender] = 0;\n', '\t\t\t} else {\n', '\t\t\t\tallowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '\t\t\t}\n', '\t\t\tApproval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\t\t\treturn true;\n', '\t\t}\n', '\n', '\t\t/**\n', '\t\t* @dev Function to mint tokens\n', '\t\t* @param _to The address that will receive the minted tokens.\n', '\t\t* @param _amount The amount of tokens to mint.\n', '\t\t* @return A boolean that indicates if the operation was successful.\n', '\t\t*/\n', '\t\tfunction generateTokens(address _to, uint _amount) internal returns (bool) {\n', '\t\t\ttotalSupply_ = totalSupply_.add(_amount);\n', '\t\t\tbalances[_to] = balances[_to].add(_amount);\n', '\t\t\tTransfer(address(0x0), _to, _amount);\n', '\t\t\treturn true;\n', '\t\t}\n', '\t\t/**\n', '\t\t* @dev fallback function - reverts transaction\n', '\t\t*/\n', '    \tfunction () external payable {\n', '    \t    revert();\n', '    \t}\n', '\n', '    \tfunction Touch () public {\n', '    \t\tgenerateTokens(msg.sender, maximumTokenIssue);\n', '    \t}\n', '\n', '}']
