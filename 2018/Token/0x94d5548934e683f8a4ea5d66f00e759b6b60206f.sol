['pragma solidity ^0.4.18;\n', '\n', '// Latino Token - Latinos Unidos Impulsando la CriptoEconom&#237;a - latinotoken.com\n', '\n', '\n', '/**\n', ' * @title ERC20Basic interface\n', ' * @dev Basic version of ERC20 interface\n', ' */\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev Standard version of ERC20 interface\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool);\n', '  function approve(address spender, uint256 value) returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function mod(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a % b;\n', '    //uint256 z = a / b;\n', '    assert(a == (a / b) * b + c); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The modified Ownable contract has two owner addresses to provide authorization control\n', ' * functions.\n', ' */\n', 'contract Ownable {\n', '\n', '  address public owner;\n', '  address public ownerManualMinter; \n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    /**\n', '    * ownerManualMinter contains the eth address of the party allowed to manually mint outside the crowdsale contract\n', '    * this is setup at construction time \n', '    */ \n', '\n', '    ownerManualMinter = 0xd97c302e9b5ee38ab900d3a07164c2ad43ffc044 ; // To be changed right after contract is deployed\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner || msg.sender == ownerManualMinter);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * This shall be invoked with the ICO crowd sale smart contract address once it&#180;s ready\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '/**\n', '   * @dev After the manual minting process ends, this shall be invoked passing the ICO crowd sale contract address so that\n', '   * nobody else will be ever able to mint more tokens\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnershipManualMinter(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    ownerManualMinter = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract Restrictable is Ownable {\n', '    \n', '    address public restrictedAddress;\n', '    \n', '    event RestrictedAddressChanged(address indexed restrictedAddress);\n', '    \n', '    function Restrictable() {\n', '        restrictedAddress = address(0);\n', '    }\n', '    \n', '    //that function could be called only ONCE!!! After that nothing could be reverted!!! \n', '    function setRestrictedAddress(address _restrictedAddress) onlyOwner public {\n', '      restrictedAddress = _restrictedAddress;\n', '      RestrictedAddressChanged(_restrictedAddress);\n', '      transferOwnership(_restrictedAddress);\n', '    }\n', '    \n', '    modifier notRestricted(address tryTo) {\n', '        if(tryTo == restrictedAddress) {\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic Token\n', ' * @dev Implementation of the basic token.\n', ' */\n', '\n', 'contract BasicToken is ERC20Basic, Restrictable {\n', '\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '  uint256 public constant icoEndDatetime = 1521035143 ; \n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '\n', '  function transfer(address _to, uint256 _value) notRestricted(_to) public returns (bool) {\n', '    require(_to != address(0));\n', '    \n', '    // We won&#180;t allow to transfer tokens until the ICO finishes\n', '    require(now > icoEndDatetime ); \n', '\n', '    require(_value <= balances[msg.sender]);\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 Token\n', ' * @dev Implementation of the standard token.\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) notRestricted(_to) public returns (bool) {\n', '    require(_to != address(0));\n', '    \n', '    // We won&#180;t allow to transfer tokens until the ICO finishes\n', '    require(now > icoEndDatetime) ; \n', '\n', '\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '  \n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifing the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', ' /**\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   */\n', '  function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev ERC20 Token, with mintable token creation\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', 'contract MintableToken is StandardToken {\n', '\n', '  uint32 public constant decimals = 4;\n', '  uint256 public constant MAX_SUPPLY = 700000000 * (10 ** uint256(decimals)); // 700MM tokens hard cap\n', '\n', '  event Mint(address indexed to, uint256 amount);\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will recieve the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '\n', '  function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {\n', '    uint256 newTotalSupply = totalSupply.add(_amount);\n', '    require(newTotalSupply <= MAX_SUPPLY); // never ever allows to create more than the hard cap limit\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    Transfer(0x0, _to, _amount);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'contract LATIME is MintableToken \n', '{\n', '  string public constant name = "LATIME";\n', '  string public constant symbol = "LATIME";\n', '\n', ' function LATIME() { totalSupply = 0 ; } // initializes to 0 the total token supply \n', '}']
['pragma solidity ^0.4.18;\n', '\n', '// Latino Token - Latinos Unidos Impulsando la CriptoEconomía - latinotoken.com\n', '\n', '\n', '/**\n', ' * @title ERC20Basic interface\n', ' * @dev Basic version of ERC20 interface\n', ' */\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev Standard version of ERC20 interface\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool);\n', '  function approve(address spender, uint256 value) returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function mod(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a % b;\n', '    //uint256 z = a / b;\n', "    assert(a == (a / b) * b + c); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The modified Ownable contract has two owner addresses to provide authorization control\n', ' * functions.\n', ' */\n', 'contract Ownable {\n', '\n', '  address public owner;\n', '  address public ownerManualMinter; \n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    /**\n', '    * ownerManualMinter contains the eth address of the party allowed to manually mint outside the crowdsale contract\n', '    * this is setup at construction time \n', '    */ \n', '\n', '    ownerManualMinter = 0xd97c302e9b5ee38ab900d3a07164c2ad43ffc044 ; // To be changed right after contract is deployed\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner || msg.sender == ownerManualMinter);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * This shall be invoked with the ICO crowd sale smart contract address once it´s ready\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '/**\n', '   * @dev After the manual minting process ends, this shall be invoked passing the ICO crowd sale contract address so that\n', '   * nobody else will be ever able to mint more tokens\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnershipManualMinter(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    ownerManualMinter = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract Restrictable is Ownable {\n', '    \n', '    address public restrictedAddress;\n', '    \n', '    event RestrictedAddressChanged(address indexed restrictedAddress);\n', '    \n', '    function Restrictable() {\n', '        restrictedAddress = address(0);\n', '    }\n', '    \n', '    //that function could be called only ONCE!!! After that nothing could be reverted!!! \n', '    function setRestrictedAddress(address _restrictedAddress) onlyOwner public {\n', '      restrictedAddress = _restrictedAddress;\n', '      RestrictedAddressChanged(_restrictedAddress);\n', '      transferOwnership(_restrictedAddress);\n', '    }\n', '    \n', '    modifier notRestricted(address tryTo) {\n', '        if(tryTo == restrictedAddress) {\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic Token\n', ' * @dev Implementation of the basic token.\n', ' */\n', '\n', 'contract BasicToken is ERC20Basic, Restrictable {\n', '\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '  uint256 public constant icoEndDatetime = 1521035143 ; \n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '\n', '  function transfer(address _to, uint256 _value) notRestricted(_to) public returns (bool) {\n', '    require(_to != address(0));\n', '    \n', '    // We won´t allow to transfer tokens until the ICO finishes\n', '    require(now > icoEndDatetime ); \n', '\n', '    require(_value <= balances[msg.sender]);\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 Token\n', ' * @dev Implementation of the standard token.\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) notRestricted(_to) public returns (bool) {\n', '    require(_to != address(0));\n', '    \n', '    // We won´t allow to transfer tokens until the ICO finishes\n', '    require(now > icoEndDatetime) ; \n', '\n', '\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '  \n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifing the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', ' /**\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   */\n', '  function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev ERC20 Token, with mintable token creation\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', 'contract MintableToken is StandardToken {\n', '\n', '  uint32 public constant decimals = 4;\n', '  uint256 public constant MAX_SUPPLY = 700000000 * (10 ** uint256(decimals)); // 700MM tokens hard cap\n', '\n', '  event Mint(address indexed to, uint256 amount);\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will recieve the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '\n', '  function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {\n', '    uint256 newTotalSupply = totalSupply.add(_amount);\n', '    require(newTotalSupply <= MAX_SUPPLY); // never ever allows to create more than the hard cap limit\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    Transfer(0x0, _to, _amount);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'contract LATIME is MintableToken \n', '{\n', '  string public constant name = "LATIME";\n', '  string public constant symbol = "LATIME";\n', '\n', ' function LATIME() { totalSupply = 0 ; } // initializes to 0 the total token supply \n', '}']