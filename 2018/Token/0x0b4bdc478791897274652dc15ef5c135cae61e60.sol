['pragma solidity ^0.4.17;\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20Basic {\n', '  uint public totalSupply;\n', '  function balanceOf(address _owner) public constant returns (uint balance);\n', '  function transfer(address _to, uint _value) public returns (bool success);\n', '  function allowance(address _owner, address _spender) public constant returns (uint remaining);\n', '  function approve(address _spender, uint _value) public returns (bool success);\n', '\n', '  event Transfer(address indexed _from, address indexed _to, uint _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' */\n', 'contract StandardToken is ERC20Basic {\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '   /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '\t    require((_value > 0) && (balances[msg.sender] >= _value));\n', '\t    balances[msg.sender] -= _value;\n', '    \tbalances[_to] += _value;\n', '    \tTransfer(msg.sender, _to, _value);\n', '    \treturn true;\n', '    }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '    \tallowed[msg.sender][_spender] = _value;\n', '    \tApproval(msg.sender, _spender, _value);\n', '    \treturn true;\n', '    }\n', '\n', '   /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifing the amount of tokens still avaible for the spender.\n', '   */\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title DAXToken\n', ' */\n', 'contract DAEXToken is StandardToken {\n', '    string public constant name = "DAEX Token";\n', '    string public constant symbol = "DAX";\n', '    uint public constant decimals = 18;\n', '\n', '    address public target;\n', '\n', '    function DAEXToken(address _target) public {\n', '        target = _target;\n', '        totalSupply = 2*10**27;\n', '        balances[target] = totalSupply;\n', '    }\n', '}']
['pragma solidity ^0.4.17;\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20Basic {\n', '  uint public totalSupply;\n', '  function balanceOf(address _owner) public constant returns (uint balance);\n', '  function transfer(address _to, uint _value) public returns (bool success);\n', '  function allowance(address _owner, address _spender) public constant returns (uint remaining);\n', '  function approve(address _spender, uint _value) public returns (bool success);\n', '\n', '  event Transfer(address indexed _from, address indexed _to, uint _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' */\n', 'contract StandardToken is ERC20Basic {\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '   /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '\t    require((_value > 0) && (balances[msg.sender] >= _value));\n', '\t    balances[msg.sender] -= _value;\n', '    \tbalances[_to] += _value;\n', '    \tTransfer(msg.sender, _to, _value);\n', '    \treturn true;\n', '    }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '    \tallowed[msg.sender][_spender] = _value;\n', '    \tApproval(msg.sender, _spender, _value);\n', '    \treturn true;\n', '    }\n', '\n', '   /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifing the amount of tokens still avaible for the spender.\n', '   */\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title DAXToken\n', ' */\n', 'contract DAEXToken is StandardToken {\n', '    string public constant name = "DAEX Token";\n', '    string public constant symbol = "DAX";\n', '    uint public constant decimals = 18;\n', '\n', '    address public target;\n', '\n', '    function DAEXToken(address _target) public {\n', '        target = _target;\n', '        totalSupply = 2*10**27;\n', '        balances[target] = totalSupply;\n', '    }\n', '}']
