['pragma solidity 0.4.24;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor () public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '    /// Total amount of tokens\n', '  uint256 public totalSupply;\n', '  \n', '  function balanceOf(address _owner) public view returns (uint256 balance);\n', '  \n', '  function transfer(address _to, uint256 _amount) public returns (bool success);\n', '  \n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '  \n', '  function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);\n', '  \n', '  function approve(address _spender, uint256 _amount) public returns (bool success);\n', '  \n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  //balance in each address account\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _amount The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _amount) public returns (bool success) {\n', '    require(_to != address(0));\n', '    require(balances[msg.sender] >= _amount && _amount > 0\n', '        && balances[_to].add(_amount) > balances[_to]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    emit Transfer(msg.sender, _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '  \n', '  \n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _amount uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {\n', '    require(_to != address(0));\n', '    require(balances[_from] >= _amount);\n', '    require(allowed[_from][msg.sender] >= _amount);\n', '    require(_amount > 0 && balances[_to].add(_amount) > balances[_to]);\n', '\n', '    balances[_from] = balances[_from].sub(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);\n', '    emit Transfer(_from, _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _amount The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _amount) public returns (bool success) {\n', '    allowed[msg.sender][_spender] = _amount;\n', '    emit Approval(msg.sender, _spender, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract BurnableToken is StandardToken, Ownable {\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '  /**\n', '   * @dev Burns a specific amount of tokens.\n', '   * @param _value The amount of token to be burned.\n', '   */\n', '\n', '  function burn(uint256 _value) public {\n', '\n', '    _burn(msg.sender, _value);\n', '\n', '  }\n', '\n', '  function _burn(address _who, uint256 _value) internal {\n', '\n', '    require(_value <= balances[_who]);\n', '    // no need to require value <= totalSupply, since that would imply the\n', '    // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure\n', '    balances[_who] = balances[_who].sub(_value);\n', '    totalSupply = totalSupply.sub(_value);\n', '    emit Burn(_who, _value);\n', '    emit Transfer(_who, address(0), _value);\n', '  }\n', '} \n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev ERC20 token, with mintable token creation\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '    using SafeMath for uint256;\n', '\n', '  mapping(address => uint256)public shares;\n', '  \n', '  address[] public beneficiaries;\n', ' \n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '  event BeneficiariesAdded();\n', '  \n', '  uint256 public lastMintingTime;\n', '  uint256 public mintingStartTime = 1543622400;\n', '  uint256 public mintingThreshold = 31536000;\n', '  uint256 public lastMintedTokens = 91000000000000000;\n', '\n', '  bool public mintingFinished = false;\n', '  \n', '  \n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    require(totalSupply < 910000000000000000);// Total minting has not yet been finished\n', '    require(beneficiaries.length == 7);//Check beneficiaries has been added\n', '    _;\n', '  }\n', '\n', '  modifier hasMintPermission() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '\n', '  function mint() hasMintPermission  canMint public  returns (bool){\n', '    \n', '    uint256 _amount = tokensToMint();\n', '    \n', '    totalSupply = totalSupply.add(_amount);\n', '    \n', '    \n', '    for(uint8 i = 0; i<beneficiaries.length; i++){\n', '        \n', '        balances[beneficiaries[i]] = balances[beneficiaries[i]].add(_amount.mul(shares[beneficiaries[i]]).div(100));\n', '        emit Mint(beneficiaries[i], _amount.mul(shares[beneficiaries[i]]).div(100));\n', '        emit Transfer(address(0), beneficiaries[i], _amount.mul(shares[beneficiaries[i]]).div(100));\n', '    }\n', '    \n', '    lastMintingTime = now;\n', '    \n', '   \n', '     return true;\n', '  }\n', '  \n', '  //Return how much tokens will be minted as per algorithm. Each year 10% tokens will be reduced\n', '  function tokensToMint()private returns(uint256 _tokensToMint){\n', '      \n', '      uint8 tiersToBeMinted = currentTier() - getTierForLastMiniting();\n', '      \n', '      require(tiersToBeMinted>0);\n', '      \n', '      for(uint8 i = 0;i<tiersToBeMinted;i++){\n', '          _tokensToMint = _tokensToMint.add(lastMintedTokens.sub(lastMintedTokens.mul(10).div(100)));\n', '          lastMintedTokens = lastMintedTokens.sub(lastMintedTokens.mul(10).div(100));\n', '      }\n', '      \n', '      return _tokensToMint;\n', '      \n', '  }\n', ' \n', '  function currentTier()private view returns(uint8 _tier) {\n', '      \n', '      uint256 currentTime = now;\n', '      \n', '      uint256 nextTierStartTime = mintingStartTime;\n', '      \n', '      while(nextTierStartTime < currentTime) {\n', '          nextTierStartTime = nextTierStartTime.add(mintingThreshold);\n', '          _tier++;\n', '      }\n', '      \n', '      return _tier;\n', '      \n', '  }\n', '  \n', '  function getTierForLastMiniting()private view returns(uint8 _tier) {\n', '      \n', '       uint256 nextTierStartTime = mintingStartTime;\n', '      \n', '      while(nextTierStartTime < lastMintingTime) {\n', '          nextTierStartTime = nextTierStartTime.add(mintingThreshold);\n', '          _tier++;\n', '      }\n', '      \n', '      return _tier;\n', '      \n', '  }\n', '  \n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '\n', '  function finishMinting() onlyOwner canMint public returns (bool) {\n', '    mintingFinished = true;\n', '    emit MintFinished();\n', '    return true;\n', '  }\n', '\n', '\n', 'function beneficiariesPercentage(address[] _beneficiaries, uint256[] percentages) onlyOwner external returns(bool){\n', '   \n', '    require(_beneficiaries.length == 7);\n', '    require(percentages.length == 7);\n', '    \n', '    uint256 sumOfPercentages;\n', '    \n', '    if(beneficiaries.length>0) {\n', '        \n', '        for(uint8 j = 0;j<beneficiaries.length;j++) {\n', '            \n', '            shares[beneficiaries[j]] = 0;\n', '            delete beneficiaries[j];\n', '            \n', '            \n', '        }\n', '        beneficiaries.length = 0;\n', '        \n', '    }\n', '\n', '    for(uint8 i = 0; i < _beneficiaries.length; i++){\n', '\n', '      require(_beneficiaries[i] != 0x0);\n', '      require(percentages[i] > 0);\n', '      beneficiaries.push(_beneficiaries[i]);\n', '      \n', '      shares[_beneficiaries[i]] = percentages[i];\n', '      sumOfPercentages = sumOfPercentages.add(percentages[i]); \n', '     \n', '    }\n', '\n', '    require(sumOfPercentages == 100);\n', '    emit BeneficiariesAdded();\n', '    return true;\n', '  } \n', '}\n', '\n', '/**\n', ' * @title ERA Swap Token \n', ' * @dev Token representing EST.\n', ' */\n', ' contract EraSwapToken is BurnableToken, MintableToken{\n', '     string public name ;\n', '     string public symbol ;\n', '     uint8 public decimals = 8 ;\n', '     \n', '     /**\n', '     *@dev users sending ether to this contract will be reverted. Any ether sent to the contract will be sent back to the caller\n', '     */\n', '     function ()public payable {\n', '         revert();\n', '     }\n', '     \n', '     /**\n', '     * @dev Constructor function to initialize the initial supply of token to the creator of the contract\n', '     * @param initialSupply The initial supply of tokens which will be fixed through out\n', '     * @param tokenName The name of the token\n', '     * @param tokenSymbol The symboll of the token\n', '     */\n', '     constructor (\n', '            uint256 initialSupply,\n', '            string tokenName,\n', '            string tokenSymbol\n', '         ) public {\n', '         totalSupply = initialSupply.mul( 10 ** uint256(decimals)); //Update total supply with the decimal amount\n', '         name = tokenName;\n', '         symbol = tokenSymbol;\n', '         balances[msg.sender] = totalSupply;\n', '         \n', '         //Emitting transfer event since assigning all tokens to the creator also corresponds to the transfer of tokens to the creator\n', '         emit Transfer(address(0), msg.sender, totalSupply);\n', '     }\n', '     \n', '     /**\n', '     *@dev helper method to get token details, name, symbol and totalSupply in one go\n', '     */\n', '    function getTokenDetail() public view returns (string, string, uint256) {\n', '\t    return (name, symbol, totalSupply);\n', '    }\n', ' }']
['pragma solidity 0.4.24;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor () public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '    /// Total amount of tokens\n', '  uint256 public totalSupply;\n', '  \n', '  function balanceOf(address _owner) public view returns (uint256 balance);\n', '  \n', '  function transfer(address _to, uint256 _amount) public returns (bool success);\n', '  \n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '  \n', '  function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);\n', '  \n', '  function approve(address _spender, uint256 _amount) public returns (bool success);\n', '  \n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  //balance in each address account\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _amount The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _amount) public returns (bool success) {\n', '    require(_to != address(0));\n', '    require(balances[msg.sender] >= _amount && _amount > 0\n', '        && balances[_to].add(_amount) > balances[_to]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    emit Transfer(msg.sender, _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '  \n', '  \n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _amount uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {\n', '    require(_to != address(0));\n', '    require(balances[_from] >= _amount);\n', '    require(allowed[_from][msg.sender] >= _amount);\n', '    require(_amount > 0 && balances[_to].add(_amount) > balances[_to]);\n', '\n', '    balances[_from] = balances[_from].sub(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);\n', '    emit Transfer(_from, _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _amount The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _amount) public returns (bool success) {\n', '    allowed[msg.sender][_spender] = _amount;\n', '    emit Approval(msg.sender, _spender, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract BurnableToken is StandardToken, Ownable {\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '  /**\n', '   * @dev Burns a specific amount of tokens.\n', '   * @param _value The amount of token to be burned.\n', '   */\n', '\n', '  function burn(uint256 _value) public {\n', '\n', '    _burn(msg.sender, _value);\n', '\n', '  }\n', '\n', '  function _burn(address _who, uint256 _value) internal {\n', '\n', '    require(_value <= balances[_who]);\n', '    // no need to require value <= totalSupply, since that would imply the\n', "    // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '    balances[_who] = balances[_who].sub(_value);\n', '    totalSupply = totalSupply.sub(_value);\n', '    emit Burn(_who, _value);\n', '    emit Transfer(_who, address(0), _value);\n', '  }\n', '} \n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev ERC20 token, with mintable token creation\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '    using SafeMath for uint256;\n', '\n', '  mapping(address => uint256)public shares;\n', '  \n', '  address[] public beneficiaries;\n', ' \n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '  event BeneficiariesAdded();\n', '  \n', '  uint256 public lastMintingTime;\n', '  uint256 public mintingStartTime = 1543622400;\n', '  uint256 public mintingThreshold = 31536000;\n', '  uint256 public lastMintedTokens = 91000000000000000;\n', '\n', '  bool public mintingFinished = false;\n', '  \n', '  \n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    require(totalSupply < 910000000000000000);// Total minting has not yet been finished\n', '    require(beneficiaries.length == 7);//Check beneficiaries has been added\n', '    _;\n', '  }\n', '\n', '  modifier hasMintPermission() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '\n', '  function mint() hasMintPermission  canMint public  returns (bool){\n', '    \n', '    uint256 _amount = tokensToMint();\n', '    \n', '    totalSupply = totalSupply.add(_amount);\n', '    \n', '    \n', '    for(uint8 i = 0; i<beneficiaries.length; i++){\n', '        \n', '        balances[beneficiaries[i]] = balances[beneficiaries[i]].add(_amount.mul(shares[beneficiaries[i]]).div(100));\n', '        emit Mint(beneficiaries[i], _amount.mul(shares[beneficiaries[i]]).div(100));\n', '        emit Transfer(address(0), beneficiaries[i], _amount.mul(shares[beneficiaries[i]]).div(100));\n', '    }\n', '    \n', '    lastMintingTime = now;\n', '    \n', '   \n', '     return true;\n', '  }\n', '  \n', '  //Return how much tokens will be minted as per algorithm. Each year 10% tokens will be reduced\n', '  function tokensToMint()private returns(uint256 _tokensToMint){\n', '      \n', '      uint8 tiersToBeMinted = currentTier() - getTierForLastMiniting();\n', '      \n', '      require(tiersToBeMinted>0);\n', '      \n', '      for(uint8 i = 0;i<tiersToBeMinted;i++){\n', '          _tokensToMint = _tokensToMint.add(lastMintedTokens.sub(lastMintedTokens.mul(10).div(100)));\n', '          lastMintedTokens = lastMintedTokens.sub(lastMintedTokens.mul(10).div(100));\n', '      }\n', '      \n', '      return _tokensToMint;\n', '      \n', '  }\n', ' \n', '  function currentTier()private view returns(uint8 _tier) {\n', '      \n', '      uint256 currentTime = now;\n', '      \n', '      uint256 nextTierStartTime = mintingStartTime;\n', '      \n', '      while(nextTierStartTime < currentTime) {\n', '          nextTierStartTime = nextTierStartTime.add(mintingThreshold);\n', '          _tier++;\n', '      }\n', '      \n', '      return _tier;\n', '      \n', '  }\n', '  \n', '  function getTierForLastMiniting()private view returns(uint8 _tier) {\n', '      \n', '       uint256 nextTierStartTime = mintingStartTime;\n', '      \n', '      while(nextTierStartTime < lastMintingTime) {\n', '          nextTierStartTime = nextTierStartTime.add(mintingThreshold);\n', '          _tier++;\n', '      }\n', '      \n', '      return _tier;\n', '      \n', '  }\n', '  \n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '\n', '  function finishMinting() onlyOwner canMint public returns (bool) {\n', '    mintingFinished = true;\n', '    emit MintFinished();\n', '    return true;\n', '  }\n', '\n', '\n', 'function beneficiariesPercentage(address[] _beneficiaries, uint256[] percentages) onlyOwner external returns(bool){\n', '   \n', '    require(_beneficiaries.length == 7);\n', '    require(percentages.length == 7);\n', '    \n', '    uint256 sumOfPercentages;\n', '    \n', '    if(beneficiaries.length>0) {\n', '        \n', '        for(uint8 j = 0;j<beneficiaries.length;j++) {\n', '            \n', '            shares[beneficiaries[j]] = 0;\n', '            delete beneficiaries[j];\n', '            \n', '            \n', '        }\n', '        beneficiaries.length = 0;\n', '        \n', '    }\n', '\n', '    for(uint8 i = 0; i < _beneficiaries.length; i++){\n', '\n', '      require(_beneficiaries[i] != 0x0);\n', '      require(percentages[i] > 0);\n', '      beneficiaries.push(_beneficiaries[i]);\n', '      \n', '      shares[_beneficiaries[i]] = percentages[i];\n', '      sumOfPercentages = sumOfPercentages.add(percentages[i]); \n', '     \n', '    }\n', '\n', '    require(sumOfPercentages == 100);\n', '    emit BeneficiariesAdded();\n', '    return true;\n', '  } \n', '}\n', '\n', '/**\n', ' * @title ERA Swap Token \n', ' * @dev Token representing EST.\n', ' */\n', ' contract EraSwapToken is BurnableToken, MintableToken{\n', '     string public name ;\n', '     string public symbol ;\n', '     uint8 public decimals = 8 ;\n', '     \n', '     /**\n', '     *@dev users sending ether to this contract will be reverted. Any ether sent to the contract will be sent back to the caller\n', '     */\n', '     function ()public payable {\n', '         revert();\n', '     }\n', '     \n', '     /**\n', '     * @dev Constructor function to initialize the initial supply of token to the creator of the contract\n', '     * @param initialSupply The initial supply of tokens which will be fixed through out\n', '     * @param tokenName The name of the token\n', '     * @param tokenSymbol The symboll of the token\n', '     */\n', '     constructor (\n', '            uint256 initialSupply,\n', '            string tokenName,\n', '            string tokenSymbol\n', '         ) public {\n', '         totalSupply = initialSupply.mul( 10 ** uint256(decimals)); //Update total supply with the decimal amount\n', '         name = tokenName;\n', '         symbol = tokenSymbol;\n', '         balances[msg.sender] = totalSupply;\n', '         \n', '         //Emitting transfer event since assigning all tokens to the creator also corresponds to the transfer of tokens to the creator\n', '         emit Transfer(address(0), msg.sender, totalSupply);\n', '     }\n', '     \n', '     /**\n', '     *@dev helper method to get token details, name, symbol and totalSupply in one go\n', '     */\n', '    function getTokenDetail() public view returns (string, string, uint256) {\n', '\t    return (name, symbol, totalSupply);\n', '    }\n', ' }']
