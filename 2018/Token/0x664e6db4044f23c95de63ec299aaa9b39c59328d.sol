['pragma solidity 0.4.21;\n', '\n', '// ----------------------------------------------------------------------------\n', '// &#39;Digitize Coin - DTZ&#39; token contract: https://digitizecoin.com \n', '//\n', '// Symbol      : DTZ\n', '// Name        : Digitize Coin\n', '// Total supply: 200,000,000\n', '// Decimals    : 18\n', '//\n', '//\n', '// (c) Radek Ostrowski / http://startonchain.com - The MIT Licence.\n', '// ----------------------------------------------------------------------------\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0);\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    require(_newOwner != address(0));\n', '    owner = _newOwner;\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '  }\n', '}\n', '\n', '/**\n', ' * @title CutdownToken\n', ' * @dev Some ERC20 interface methods used in this contract\n', ' */\n', 'contract CutdownToken {\n', '  \tfunction balanceOf(address _who) public view returns (uint256);\n', '  \tfunction transfer(address _to, uint256 _value) public returns (bool);\n', '  \tfunction allowance(address _owner, address _spender) public view returns (uint256);\n', '}\n', '\n', '/**\n', ' * @title ApproveAndCallFallback\n', ' * @dev Interface function called from `approveAndCall` notifying that the approval happened\n', ' */\n', 'contract ApproveAndCallFallback {\n', '    function receiveApproval(address _from, uint256 _amount, address _tokenContract, bytes _data) public returns (bool);\n', '}\n', '\n', '/**\n', ' * @title Digitize Coin\n', ' * @dev Burnable ERC20 token with initial transfers blocked\n', ' */\n', 'contract DigitizeCoin is Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '  \n', '  event Burn(address indexed _burner, uint256 _value);\n', '  event TransfersEnabled();\n', '  event TransferRightGiven(address indexed _to);\n', '  event TransferRightCancelled(address indexed _from);\n', '  event WithdrawnERC20Tokens(address indexed _tokenContract, address indexed _owner, uint256 _balance);\n', '  event WithdrawnEther(address indexed _owner, uint256 _balance);\n', '  event ApproveAndCall(address indexed _from, address indexed _to, uint256 _value, bytes _data);\n', '\n', '  string public constant name = "Digitize Coin";\n', '  string public constant symbol = "DTZ";\n', '  uint256 public constant decimals = 18;\n', '  uint256 public constant initialSupply = 200000000 * (10 ** decimals);\n', '  uint256 public totalSupply;\n', '\n', '  mapping(address => uint256) public balances;\n', '  mapping(address => mapping (address => uint256)) internal allowed;\n', '\n', '  //This mapping is used for the token owner and crowdsale contract to \n', '  //transfer tokens before they are transferable\n', '  mapping(address => bool) public transferGrants;\n', '  //This flag controls the global token transfer\n', '  bool public transferable;\n', '\n', '  /**\n', '   * @dev Modifier to check if tokens can be transfered.\n', '   */\n', '  modifier canTransfer() {\n', '    require(transferable || transferGrants[msg.sender]);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev The constructor sets the original `owner` of the contract \n', '   * to the sender account and assigns them all tokens.\n', '   */\n', '  function DigitizeCoin() public {\n', '    owner = msg.sender;\n', '    totalSupply = initialSupply;\n', '    balances[owner] = totalSupply;\n', '    transferGrants[owner] = true;\n', '  }\n', '\n', '  /**\n', '   * @dev This contract does not accept any ether. \n', '   * Any forced ether can be withdrawn with `withdrawEther()` by the owner.\n', '   */\n', '  function () payable public {\n', '    revert();\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) canTransfer public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) canTransfer public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) canTransfer public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) canTransfer public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to approve the transfer of the tokens and to call another contract in one step\n', '   * @param _recipient The target contract for tokens and function call\n', '   * @param _value The amount of tokens to send\n', '   * @param _data Extra data to be sent to the recipient contract function\n', '   */\n', '  function approveAndCall(address _recipient, uint _value, bytes _data) canTransfer public returns (bool) {\n', '    allowed[msg.sender][_recipient] = _value;\n', '    emit ApproveAndCall(msg.sender, _recipient, _value, _data);\n', '    ApproveAndCallFallback(_recipient).receiveApproval(msg.sender, _value, address(this), _data);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Burns a specific amount of tokens.\n', '   * @param _value The amount of token to be burned.\n', '   */\n', '  function burn(uint256 _value) public {\n', '    require(_value <= balances[msg.sender]);\n', '    address burner = msg.sender;\n', '    balances[burner] = balances[burner].sub(_value);\n', '    totalSupply = totalSupply.sub(_value);\n', '    emit Burn(burner, _value);\n', '  }\n', '\n', '  /**\n', '   * @dev Enables the transfer of tokens for everyone\n', '   */\n', '  function enableTransfers() onlyOwner public {\n', '    require(!transferable);\n', '    transferable = true;\n', '    emit TransfersEnabled();\n', '  }\n', '\n', '  /**\n', '   * @dev Assigns the special transfer right, before transfers are enabled\n', '   * @param _to The address receiving the transfer grant\n', '   */\n', '  function grantTransferRight(address _to) onlyOwner public {\n', '    require(!transferable);\n', '    require(!transferGrants[_to]);\n', '    require(_to != address(0));\n', '    transferGrants[_to] = true;\n', '    emit TransferRightGiven(_to);\n', '  }\n', '\n', '  /**\n', '   * @dev Removes the special transfer right, before transfers are enabled\n', '   * @param _from The address that the transfer grant is removed from\n', '   */\n', '  function cancelTransferRight(address _from) onlyOwner public {\n', '    require(!transferable);\n', '    require(transferGrants[_from]);\n', '    transferGrants[_from] = false;\n', '    emit TransferRightCancelled(_from);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows to transfer out the balance of arbitrary ERC20 tokens from the contract.\n', '   * @param _token The contract address of the ERC20 token.\n', '   */\n', '  function withdrawERC20Tokens(CutdownToken _token) onlyOwner public {\n', '    uint256 totalBalance = _token.balanceOf(address(this));\n', '    require(totalBalance > 0);\n', '    _token.transfer(owner, totalBalance);\n', '    emit WithdrawnERC20Tokens(address(_token), owner, totalBalance);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows to transfer out the ether balance that was forced into this contract, e.g with `selfdestruct`\n', '   */\n', '  function withdrawEther() onlyOwner public {\n', '    uint256 totalBalance = address(this).balance;\n', '    require(totalBalance > 0);\n', '    owner.transfer(totalBalance);\n', '    emit WithdrawnEther(owner, totalBalance);\n', '  }\n', '}']
['pragma solidity 0.4.21;\n', '\n', '// ----------------------------------------------------------------------------\n', "// 'Digitize Coin - DTZ' token contract: https://digitizecoin.com \n", '//\n', '// Symbol      : DTZ\n', '// Name        : Digitize Coin\n', '// Total supply: 200,000,000\n', '// Decimals    : 18\n', '//\n', '//\n', '// (c) Radek Ostrowski / http://startonchain.com - The MIT Licence.\n', '// ----------------------------------------------------------------------------\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0);\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    require(_newOwner != address(0));\n', '    owner = _newOwner;\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '  }\n', '}\n', '\n', '/**\n', ' * @title CutdownToken\n', ' * @dev Some ERC20 interface methods used in this contract\n', ' */\n', 'contract CutdownToken {\n', '  \tfunction balanceOf(address _who) public view returns (uint256);\n', '  \tfunction transfer(address _to, uint256 _value) public returns (bool);\n', '  \tfunction allowance(address _owner, address _spender) public view returns (uint256);\n', '}\n', '\n', '/**\n', ' * @title ApproveAndCallFallback\n', ' * @dev Interface function called from `approveAndCall` notifying that the approval happened\n', ' */\n', 'contract ApproveAndCallFallback {\n', '    function receiveApproval(address _from, uint256 _amount, address _tokenContract, bytes _data) public returns (bool);\n', '}\n', '\n', '/**\n', ' * @title Digitize Coin\n', ' * @dev Burnable ERC20 token with initial transfers blocked\n', ' */\n', 'contract DigitizeCoin is Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '  \n', '  event Burn(address indexed _burner, uint256 _value);\n', '  event TransfersEnabled();\n', '  event TransferRightGiven(address indexed _to);\n', '  event TransferRightCancelled(address indexed _from);\n', '  event WithdrawnERC20Tokens(address indexed _tokenContract, address indexed _owner, uint256 _balance);\n', '  event WithdrawnEther(address indexed _owner, uint256 _balance);\n', '  event ApproveAndCall(address indexed _from, address indexed _to, uint256 _value, bytes _data);\n', '\n', '  string public constant name = "Digitize Coin";\n', '  string public constant symbol = "DTZ";\n', '  uint256 public constant decimals = 18;\n', '  uint256 public constant initialSupply = 200000000 * (10 ** decimals);\n', '  uint256 public totalSupply;\n', '\n', '  mapping(address => uint256) public balances;\n', '  mapping(address => mapping (address => uint256)) internal allowed;\n', '\n', '  //This mapping is used for the token owner and crowdsale contract to \n', '  //transfer tokens before they are transferable\n', '  mapping(address => bool) public transferGrants;\n', '  //This flag controls the global token transfer\n', '  bool public transferable;\n', '\n', '  /**\n', '   * @dev Modifier to check if tokens can be transfered.\n', '   */\n', '  modifier canTransfer() {\n', '    require(transferable || transferGrants[msg.sender]);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev The constructor sets the original `owner` of the contract \n', '   * to the sender account and assigns them all tokens.\n', '   */\n', '  function DigitizeCoin() public {\n', '    owner = msg.sender;\n', '    totalSupply = initialSupply;\n', '    balances[owner] = totalSupply;\n', '    transferGrants[owner] = true;\n', '  }\n', '\n', '  /**\n', '   * @dev This contract does not accept any ether. \n', '   * Any forced ether can be withdrawn with `withdrawEther()` by the owner.\n', '   */\n', '  function () payable public {\n', '    revert();\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) canTransfer public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) canTransfer public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) canTransfer public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) canTransfer public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to approve the transfer of the tokens and to call another contract in one step\n', '   * @param _recipient The target contract for tokens and function call\n', '   * @param _value The amount of tokens to send\n', '   * @param _data Extra data to be sent to the recipient contract function\n', '   */\n', '  function approveAndCall(address _recipient, uint _value, bytes _data) canTransfer public returns (bool) {\n', '    allowed[msg.sender][_recipient] = _value;\n', '    emit ApproveAndCall(msg.sender, _recipient, _value, _data);\n', '    ApproveAndCallFallback(_recipient).receiveApproval(msg.sender, _value, address(this), _data);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Burns a specific amount of tokens.\n', '   * @param _value The amount of token to be burned.\n', '   */\n', '  function burn(uint256 _value) public {\n', '    require(_value <= balances[msg.sender]);\n', '    address burner = msg.sender;\n', '    balances[burner] = balances[burner].sub(_value);\n', '    totalSupply = totalSupply.sub(_value);\n', '    emit Burn(burner, _value);\n', '  }\n', '\n', '  /**\n', '   * @dev Enables the transfer of tokens for everyone\n', '   */\n', '  function enableTransfers() onlyOwner public {\n', '    require(!transferable);\n', '    transferable = true;\n', '    emit TransfersEnabled();\n', '  }\n', '\n', '  /**\n', '   * @dev Assigns the special transfer right, before transfers are enabled\n', '   * @param _to The address receiving the transfer grant\n', '   */\n', '  function grantTransferRight(address _to) onlyOwner public {\n', '    require(!transferable);\n', '    require(!transferGrants[_to]);\n', '    require(_to != address(0));\n', '    transferGrants[_to] = true;\n', '    emit TransferRightGiven(_to);\n', '  }\n', '\n', '  /**\n', '   * @dev Removes the special transfer right, before transfers are enabled\n', '   * @param _from The address that the transfer grant is removed from\n', '   */\n', '  function cancelTransferRight(address _from) onlyOwner public {\n', '    require(!transferable);\n', '    require(transferGrants[_from]);\n', '    transferGrants[_from] = false;\n', '    emit TransferRightCancelled(_from);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows to transfer out the balance of arbitrary ERC20 tokens from the contract.\n', '   * @param _token The contract address of the ERC20 token.\n', '   */\n', '  function withdrawERC20Tokens(CutdownToken _token) onlyOwner public {\n', '    uint256 totalBalance = _token.balanceOf(address(this));\n', '    require(totalBalance > 0);\n', '    _token.transfer(owner, totalBalance);\n', '    emit WithdrawnERC20Tokens(address(_token), owner, totalBalance);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows to transfer out the ether balance that was forced into this contract, e.g with `selfdestruct`\n', '   */\n', '  function withdrawEther() onlyOwner public {\n', '    uint256 totalBalance = address(this).balance;\n', '    require(totalBalance > 0);\n', '    owner.transfer(totalBalance);\n', '    emit WithdrawnEther(owner, totalBalance);\n', '  }\n', '}']
