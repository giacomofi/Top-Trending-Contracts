['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-02\n', '*/\n', '\n', '// SPDX-License-Identifier: UNLICENSED\n', 'pragma solidity >=0.7.0 <0.9.0;\n', '\n', 'contract CastleDome {\n', '\n', '    string public constant name = "CastleDome";\n', '    string public constant symbol = "CDOM";\n', '    uint8 public constant decimals = 9;  \n', '    address public owner;\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    mapping(address => mapping (address => uint256)) allowed;\n', '    \n', '    uint256 totalSupply_;\n', '\n', '    using SafeMath for uint256;\n', '\n', '\n', '   constructor(uint256 total) public {  \n', '\ttotalSupply_ = total;\n', '\tbalances[msg.sender] = totalSupply_;\n', '    }  \n', '\n', '    function totalSupply() public view returns (uint256) {\n', '\treturn totalSupply_;\n', '    }\n', '    \n', '    function balanceOf(address tokenOwner) public view returns (uint) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    function transfer(address receiver, uint numTokens) public returns (bool) {\n', '        require(numTokens <= balances[msg.sender]);\n', '        balances[msg.sender] = balances[msg.sender].sub(numTokens);\n', '        balances[receiver] = balances[receiver].add(numTokens);\n', '        emit Transfer(msg.sender, receiver, numTokens);\n', '        return true;\n', '    }\n', '\n', '    function approve(address delegate, uint numTokens) public returns (bool) {\n', '        allowed[msg.sender][delegate] = numTokens;\n', '        emit Approval(msg.sender, delegate, numTokens);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address owner, address delegate) public view returns (uint) {\n', '        return allowed[owner][delegate];\n', '    }\n', '\n', '    function transferFrom(address owner, address buyer, uint numTokens) public returns (bool) {\n', '        require(numTokens <= balances[owner]);    \n', '        require(numTokens <= allowed[owner][msg.sender]);\n', '    \n', '        balances[owner] = balances[owner].sub(numTokens);\n', '        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);\n', '        balances[buyer] = balances[buyer].add(numTokens);\n', '        emit Transfer(owner, buyer, numTokens);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '  \n', '  /**\n', '   * @dev Burns a specific amount of tokens. Allowed for owner only\n', '   * @param _value The amount of token to be burned.\n', '   */\n', '  function burn(uint256 _value) public {\n', '    require(_value <= balances[msg.sender]);\n', '    // no need to require value <= totalSupply, since that would imply the\n', "    // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '\n', '    address burner = msg.sender;\n', '    balances[burner] = balances[burner].sub(_value);\n', '    totalSupply_ = totalSupply_.sub(_value);\n', '    emit Burn(burner, _value);\n', '  }\n', '  \n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '\n', '}\n', '\n', 'library SafeMath { \n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '      assert(b <= a);\n', '      return a - b;\n', '    }\n', '    \n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '      uint256 c = a + b;\n', '      assert(c >= a);\n', '      return c;\n', '    }\n', '}']