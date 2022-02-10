['pragma solidity ^0.4.18;\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract BurnableToken is BasicToken {\n', '\n', '  event Burn(address indexed burner, uint256 value);\n', '\n', '  /**\n', '   * @dev Burns a specific amount of tokens.\n', '   * @param _value The amount of token to be burned.\n', '   */\n', '  function burn(uint256 _value) public {\n', '    require(_value <= balances[msg.sender]);\n', '    // no need to require value <= totalSupply, since that would imply the\n', "    // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '\n', '    address burner = msg.sender;\n', '    balances[burner] = balances[burner].sub(_value);\n', '    totalSupply_ = totalSupply_.sub(_value);\n', '    Burn(burner, _value);\n', '  }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', '/**\n', '* @title Allowable\n', '* @dev The Allowable contract provides basic functionality to authorize\n', '* only allowed addresses to action.\n', '*/\n', 'contract Allowable is Ownable {\n', '\n', '    // Contains details regarding allowed addresses\n', '    mapping (address => bool) public permissions;\n', '\n', '    /**\n', '    * @dev Reverts if an address is not allowed. Can be used when extending this contract.\n', '    */\n', '    modifier isAllowed(address _operator) {\n', '        require(permissions[_operator] || _operator == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds single address to the permissions list. Allowed only for contract owner.\n', '    * @param _operator Address to be added to the permissions list\n', '    */\n', '    function allow(address _operator) external onlyOwner {\n', '        permissions[_operator] = true;\n', '    }\n', '\n', '    /**\n', '    * @dev Removes single address from an permissions list. Allowed only for contract owner.  \n', '    * @param _operator Address to be removed from the permissions list\n', '    */\n', '    function deny(address _operator) external onlyOwner {\n', '        permissions[_operator] = false;\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Operable\n', ' * @dev The Operable contract has an operator address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Operable is Ownable {\n', '    address public operator;\n', '\n', '    event OperatorRoleTransferred(address indexed previousOperator, address indexed newOperator);\n', '\n', '\n', '    /**\n', '    * @dev The Operable constructor sets the original `operator` of the contract to the sender\n', '    * account.\n', '    */\n', '    function Operable() public {\n', '        operator = msg.sender;\n', '    }\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOperator() {\n', '        require(msg.sender == operator || msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer operator role to a newOperator.\n', '    * @param newOperator The address to transfer Operator role to.\n', '    */\n', '    function transferOperatorRole(address newOperator) public onlyOwner {\n', '        require(newOperator != address(0));\n', '        OperatorRoleTransferred(operator, newOperator);\n', '        operator = newOperator;\n', '    }\n', '}\n', '\n', '\n', '/**\n', '* @title DaricoEcosystemToken\n', '* @dev The DaricoEcosystemToken (DEC) is a ERC20 token.\n', '* DEC volume is pre-minted and distributed to a set of pre-configurred wallets according the following rules:\n', '*   120000000 - total tokens\n', '*   72000000 - tokens for sale\n', '*   18000000 - reserved tokens\n', '*   18000000 - tokens for the team\n', '*   12000000 - tokens for marketing needs\n', '* DEC supports burn functionality to destroy tokens left after sale. \n', '* Burn functionality is limited to Operator role that belongs to sale contract\n', '* DEC is disactivated by default, which means initially token transfers are allowed to a limited set of addresses. \n', '* Activation functionality is limited to Owner role. After activation token transfers are not limited\n', '*/\n', 'contract DaricoEcosystemToken is BurnableToken, StandardToken, Allowable, Operable {\n', '    using SafeMath for uint256;\n', '\n', '    // token name\n', '    string public constant name= "Darico Ecosystem Coin";\n', '    // token symbol\n', '    string public constant symbol= "DEC";\n', '    // supported decimals\n', '    uint256 public constant decimals = 18;\n', '\n', '    //initially tokens locked for any transfers\n', '    bool public isActive = false;\n', '\n', '    /**\n', '    * @param _saleWallet Wallet to hold tokens for sale \n', '    * @param _reserveWallet Wallet to hold tokens for reserve \n', '    * @param _teamWallet Wallet to hold tokens for team \n', '    * @param _otherWallet Wallet to hold tokens for other needs  \n', '    */\n', '    function DaricoEcosystemToken(address _saleWallet, \n', '                                  address _reserveWallet, \n', '                                  address _teamWallet, \n', '                                  address _otherWallet) public {\n', '        totalSupply_ = uint256(120000000).mul(10 ** decimals);\n', '\n', '        configureWallet(_saleWallet, uint256(72000000).mul(10 ** decimals));\n', '        configureWallet(_reserveWallet, uint256(18000000).mul(10 ** decimals));\n', '        configureWallet(_teamWallet, uint256(18000000).mul(10 ** decimals));\n', '        configureWallet(_otherWallet, uint256(12000000).mul(10 ** decimals));\n', '    }\n', '\n', '    /**\n', '    * @dev checks if address is able to perform token operations\n', '    * @param _from The address that owns tokens, to check over permissions list\n', '    */ \n', '    modifier whenActive(address _from){\n', '        if (!permissions[_from]) {            \n', '            require(isActive);            \n', '        }\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Activate tokens. Can be executed by contract Owner only.\n', '    */\n', '    function activate() onlyOwner public {\n', '        isActive = true;\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token for a specified address, validates if there are enough unlocked tokens\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public whenActive(msg.sender) returns (bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer tokens from one address to another, validates if there are enough unlocked tokens\n', '    * @param _from address The address which you want to send tokens from\n', '    * @param _to address The address which you want to transfer to\n', '    * @param _value uint256 the amount of tokens to be transferred\n', '    */\n', '    function transferFrom(address _from, address _to, uint256 _value) public whenActive(_from) returns (bool) {        \n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    /**\n', '    * @dev Burns a specific amount of tokens. Can be executed by contract Operator only.\n', '    * @param _value The amount of token to be burned.\n', '    */\n', '    function burn(uint256 _value) public onlyOperator {\n', '        super.burn(_value);\n', '    }\n', '\n', '    /**\n', '    * @dev Sends tokens to a specified wallet\n', '    */\n', '    function configureWallet(address _wallet, uint256 _amount) private {\n', '        require(_wallet != address(0));\n', '        permissions[_wallet] = true;\n', '        balances[_wallet] = _amount;\n', '        Transfer(address(0), _wallet, _amount);\n', '    }\n', '}']