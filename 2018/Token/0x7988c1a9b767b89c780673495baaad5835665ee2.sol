['pragma solidity ^0.4.23;\n', '\n', '// File: zeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol\n', '\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract BurnableToken is BasicToken {\n', '\n', '  event Burn(address indexed burner, uint256 value);\n', '\n', '  /**\n', '   * @dev Burns a specific amount of tokens.\n', '   * @param _value The amount of token to be burned.\n', '   */\n', '  function burn(uint256 _value) public {\n', '    require(_value <= balances[msg.sender]);\n', '    // no need to require value <= totalSupply, since that would imply the\n', "    // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '\n', '    address burner = msg.sender;\n', '    balances[burner] = balances[burner].sub(_value);\n', '    totalSupply_ = totalSupply_.sub(_value);\n', '    Burn(burner, _value);\n', '  }\n', '}\n', '\n', '// File: contracts/PolarisToken.sol\n', '\n', '/*\n', ' * PolarisToken is a standard ERC20 token with some additional functionalities:\n', ' * - Transfers are only enabled after contract owner enables it (after the ICO)\n', ' * - Contract sets 40% of the total supply as allowance for ICO contract\n', ' *\n', ' * Note: Token Offering == Initial Coin Offering(ICO)\n', ' */\n', '\n', 'contract PolarisToken is StandardToken, BurnableToken, Ownable {\n', '\tstring public constant symbol = "POLARIS";\n', '\tstring public constant name = "POLARIS COIN";\n', '\tuint8 public constant decimals = 18;\n', '\tuint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));\n', '\tuint256 public constant TOKEN_OFFERING_ALLOWANCE = 4000000000 * (10 ** uint256(decimals));\n', '\tuint256 public constant ADMIN_ALLOWANCE = INITIAL_SUPPLY - TOKEN_OFFERING_ALLOWANCE;\n', '\n', '\t// Address of token admin\n', '\taddress public adminAddr;\n', '\t// Address of token offering\n', '\taddress public tokenOfferingAddr;\n', '\t// Enable transfers after conclusion of token offering\n', '\tbool public transferEnabled = true;\n', '\n', '\t/**\n', '\t * Check if transfer is allowed\n', '\t *\n', '\t * Permissions:\n', '\t *\t\t\t\t\t\t\t\t\t\t\t\t\t\tOwner\tAdmin\tOfferingContract\tOthers\n', '\t * transfer (before transferEnabled is true)\t\t\tx\t\tx\t\t\tx\t\t\t\tx\n', '\t * transferFrom (before transferEnabled is true)\t\tx\t\to\t\t\to\t\t\t\tx\n', '\t * transfer/transferFrom(after transferEnabled is true)\to\t\tx\t\t\tx\t\t\t\to\n', '\t */\n', '\tmodifier onlyWhenTransferAllowed() {\n', '\t\trequire(transferEnabled || msg.sender == adminAddr || msg.sender == tokenOfferingAddr);\n', '\t\t_;\n', '\t}\n', '\n', '\t/**\n', '\t * Check if token offering address is set or not\n', '\t */\n', '\tmodifier onlyTokenOfferingAddrNotSet() {\n', '\t\trequire(tokenOfferingAddr == address(0x0));\n', '\t\t_;\n', '\t}\n', '\n', '\t/**\n', '\t* Check if address is a valid destination to transfer tokens to\n', '\t* - must not be zero address\n', '\t* - must not be the token address\n', "\t* - must not be the owner's address\n", "\t* - must not be the admin's address\n", '\t* - must not be the token offering contract address\n', '\t*/\n', '\tmodifier validDestination(address to) {\n', '\t\trequire(to != address(0x0));\n', '\t\trequire(to != address(this));\n', '\t\trequire(to != owner);\n', '\t\trequire(to != address(adminAddr));\n', '\t\trequire(to != address(tokenOfferingAddr));\n', '\t\t_;\n', '\t}\t\n', '\n', '\t/**\n', '\t* Token contract constructor\n', '\t*\n', '\t* @param admin Address of admin account\n', '\t*/\n', '\tfunction PolarisToken(address admin) public {\n', '\t\ttotalSupply_ = INITIAL_SUPPLY;\n', '\n', '\t\t// Mint tokens\n', '\t\tbalances[msg.sender] = totalSupply_;\n', '\t\tTransfer(address(0x0), msg.sender, totalSupply_);\n', '\n', '\t\t// Approve allowance for admin account\n', '\t\tadminAddr = admin;\n', '\t\tapprove(adminAddr, ADMIN_ALLOWANCE);\n', '\t}\n', '\n', '\t/**\n', '\t* Set token offering to approve allowance for offering contract to distribute tokens\n', '\t*\n', '\t* @param offeringAddr Address of token offering contract\n', '\t* @param amountForSale Amount of tokens for sale, set 0 to max out\n', '\t*/\n', '\tfunction setTokenOffering(address offeringAddr, uint256 amountForSale) external onlyOwner onlyTokenOfferingAddrNotSet {\n', '\t\trequire(!transferEnabled);\n', '\n', '\t\tuint256 amount = (amountForSale == 0) ? TOKEN_OFFERING_ALLOWANCE : amountForSale;\n', '\t\trequire(amount <= TOKEN_OFFERING_ALLOWANCE);\n', '\n', '\t\tapprove(offeringAddr, amount);\n', '\t\ttokenOfferingAddr = offeringAddr;\n', '\t}\n', '\n', '\t/**\n', '\t* Enable transfers\n', '\t*/\n', '\tfunction enableTransfer() external onlyOwner {\n', '\t\ttransferEnabled = true;\n', '\n', '\t\t// End the offering\n', '\t\tapprove(tokenOfferingAddr, 0);\n', '\t}\n', '\n', '\t/**\n', '\t* Transfer from sender to another account\n', '\t*\n', '\t* @param to Destination address\n', '\t* @param value Amount of polaristokens to send\n', '\t*/\n', '\tfunction transfer(address to, uint256 value) public onlyWhenTransferAllowed validDestination(to) returns (bool) {\n', '\t\treturn super.transfer(to, value);\n', '\t}\n', '\n', '\t/**\n', '\t* Transfer from `from` account to `to` account using allowance in `from` account to the sender\n', '\t*\n', '\t* @param from Origin address\n', '\t* @param to Destination address\n', '\t* @param value Amount of polaristokens to send\n', '\t*/\n', '\tfunction transferFrom(address from, address to, uint256 value) public onlyWhenTransferAllowed validDestination(to) returns (bool) {\n', '\t\treturn super.transferFrom(from, to, value);\n', '\t}\n', '\n', '\t/**\n', '\t* Burn token, only owner is allowed to do this\n', '\t*\n', '\t* @param value Amount of tokens to burn\n', '\t*/\n', '\tfunction burn(uint256 value) public {\n', '\t\trequire(transferEnabled || msg.sender == owner);\n', '\t\tsuper.burn(value);\n', '\t}\n', '}']