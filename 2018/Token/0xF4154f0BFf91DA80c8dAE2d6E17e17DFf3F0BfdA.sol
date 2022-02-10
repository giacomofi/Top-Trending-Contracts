['pragma solidity ^0.4.21;\n', '\n', 'library SafeMath {\n', '\tfunction mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tif (a == 0) {\n', '\t\t\treturn 0;\n', '\t\t}\n', '\t\tuint256 c = a * b;\n', '\t\tassert(c / a == b);\n', '\t\treturn c;\n', '\t}\n', '\n', '\tfunction div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\t// assert(b > 0); // Solidity automatically throws when dividing by 0\n', '\t\tuint256 c = a / b;\n', "\t\t// assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\t\treturn c;\n', '\t}\n', '\n', '\tfunction sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tassert(b <= a);\n', '\t\treturn a - b;\n', '\t}\n', '\n', '\tfunction add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tuint256 c = a + b;\n', '\t\tassert(c >= a);\n', '\t\treturn c;\n', '\t}\n', '}\n', '\n', 'contract ERC20Basic {\n', '\tuint256 public totalSupply;\n', '\tfunction balanceOf(address who) public view returns (uint256);\n', '\tfunction transfer(address to, uint256 value) public returns (bool);\n', '\tevent Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '\tfunction allowance(address owner, address spender) public view returns (uint256);\n', '\tfunction transferFrom(address from, address to, uint256 value) public returns (bool);\n', '\tfunction approve(address spender, uint256 value) public returns (bool);\n', '\tevent Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '\tusing SafeMath for uint256;\n', '\n', '\tmapping(address => uint256) balances;\n', '\n', '\t/**\n', '\t* @dev transfer token for a specified address\n', '\t* @param _to The address to transfer to.\n', '\t* @param _value The amount to be transferred.\n', '\t*/\n', '\tfunction transfer(address _to, uint256 _value) public returns (bool) {\n', '\t\trequire(_to != address(0));\n', '\t\trequire(_value <= balances[msg.sender]);\n', '\n', '\t\t// SafeMath.sub will throw if there is not enough balance.\n', '\t\tbalances[msg.sender] = balances[msg.sender].sub(_value);\n', '\t\tbalances[_to] = balances[_to].add(_value);\n', '\t\temit Transfer(msg.sender, _to, _value);\n', '\t\treturn true;\n', '\t}\n', '\n', '\t/**\n', '\t* @dev Gets the balance of the specified address.\n', '\t* @param _owner The address to query the the balance of.\n', '\t* @return An uint256 representing the amount owned by the passed address.\n', '\t*/\n', '\tfunction balanceOf(address _owner) public view returns (uint256 balance) {\n', '\t\treturn balances[_owner];\n', '\t}\n', '}\n', '\n', 'contract WoodToken is ERC20, BasicToken {\n', '\t// Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 0;\n', '\n', '\tmapping (address => mapping (address => uint256)) internal allowed;\n', '\t\n', '\tevent Burn(address indexed burner, uint256 value);\n', '\t\n', '\t/**\n', '     * Constrctor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    function WoodToken(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) public {\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);          // Update total supply with the decimal amount\n', '\t\tbalances[msg.sender] = balances[msg.sender].add(totalSupply);   // Give the creator all initial tokens           \n', '        name = tokenName;                                               // Set the name for display purposes\n', '        symbol = tokenSymbol;                                           // Set the symbol for display purposes\n', '    }\n', '\t\n', '\t/**\n', '\t* @dev Transfer tokens from one address to another\n', '\t* @param _from address The address which you want to send tokens from\n', '\t* @param _to address The address which you want to transfer to\n', '\t* @param _value uint256 the amount of tokens to be transferred\n', '\t*/\n', '\tfunction transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '\t\trequire(_to != address(0));\n', '\t\trequire(_value <= balances[_from]);\n', '\t\trequire(_value <= allowed[_from][msg.sender]);\n', '\n', '\t\tbalances[_from] = balances[_from].sub(_value);\n', '\t\tbalances[_to] = balances[_to].add(_value);\n', '\t\tallowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '\t\temit Transfer(_from, _to, _value);\n', '\t\treturn true;\n', '\t}\n', '\t\n', '\t/**\n', '\t* @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '\t*\n', '\t* Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '\t* and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "\t* race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '\t* https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '\t* @param _spender The address which will spend the funds.\n', '\t* @param _value The amount of tokens to be spent.\n', '\t*/\n', '\tfunction approve(address _spender, uint256 _value) public returns (bool) {\n', '\t\tallowed[msg.sender][_spender] = _value;\n', '\t\temit Approval(msg.sender, _spender, _value);\n', '\t\treturn true;\n', '\t}\n', '\t\n', '\t/**\n', '\t* @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '\t* @param _owner address The address which owns the funds.\n', '\t* @param _spender address The address which will spend the funds.\n', '\t* @return A uint256 specifying the amount of tokens still available for the spender.\n', '\t*/\n', '\tfunction allowance(address _owner, address _spender) public view returns (uint256) {\n', '\t\treturn allowed[_owner][_spender];\n', '\t}\n', '\t\n', '\t/**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param _value The amount of token to be burned.\n', '     */\n', '    function burn(uint256 _value) public {\n', '        require(_value <= balances[msg.sender]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', "        // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        emit Burn(burner, _value);\n', '    }\n', '}']