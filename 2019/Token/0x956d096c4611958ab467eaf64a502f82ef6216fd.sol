['/**\n', '*所發行數字牡丹（即BitPeony），其最終解釋權為Bitcaps.club所有，並保留所有修改權利。\n', '*本專項衍生之營運政策、交易模式等資訊，其最新修訂版本，詳見官網（http://www.bitcaps.club/）正式公告。官網擁有上述公告之最終解釋權，並保留所有修改權利。\n', '*/\n', '\n', '/**\n', '*Abstract contract for the full ERC 20 Token standard\n', '*https://github.com/ethereum/EIPs/issues/20\n', '*/\n', 'pragma solidity ^0.4.13;\n', '\n', '/**\n', '* @title ERC20Basic\n', '* @dev Simpler version of ERC20 interface\n', '* @dev see https://github.com/ethereum/EIPs/issues/20\n', '*/\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', '* @dev simple own functions\n', '* @dev see https://github.com/ethereum/EIPs/issues/20\n', '*/\n', 'contract Ownable {\n', '  address public owner;\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '  * This contract only defines a modifier but does not use it\n', '  * it will be used in derived contracts.\n', '  * The function body is inserted where the special symbol\n', '  * "_;" in the definition of a modifier appears.\n', '  * This means that if the owner calls this function, the\n', '  * function is executed and otherwise, an exception is  thrown.\n', '  */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '  * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '  * @param newOwner The address to transfer ownership to.\n', '  */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', '/**\n', '* @title Basic token\n', '* @dev Basic version of ERC20 Standard\n', '* @dev see https://github.com/ethereum/EIPs/issues/20\n', '*/\n', 'contract PeonyToken is Ownable, ERC20 {\n', '  using SafeMath for uint256;\n', '  string public version;\n', '  string public name;\n', '  string public symbol;\n', '  uint256 public decimals;\n', '  address public peony;\n', '  mapping(address => mapping (address => uint256)) allowed;\n', '  mapping(address => uint256) balances;\n', '  uint256 public totalSupply;\n', '  uint256 public totalSupplyLimit;\n', '\n', '\n', '  /**\n', '  * @dev Basic version of ERC20 Standard\n', '  * @dev see https://github.com/ethereum/EIPs/issues/20\n', '  * This function is executed once in the initial stage.\n', '  */\n', '  function PeonyToken(\n', '    string _version,\n', '    uint256 initialSupply,\n', '    uint256 totalSupplyLimit_,\n', '    string tokenName,\n', '    uint8 decimalUnits,\n', '    string tokenSymbol\n', '    ) {\n', '    require(totalSupplyLimit_ == 0 || totalSupplyLimit_ >= initialSupply);\n', '    version = _version;\n', '    balances[msg.sender] = initialSupply;\n', '    totalSupply = initialSupply;\n', '    totalSupplyLimit = totalSupplyLimit_;\n', '    name = tokenName;\n', '    symbol = tokenSymbol;\n', '    decimals = decimalUnits;\n', '  }\n', '\n', '  /**\n', '  * This contract only defines a modifier but does not use it\n', '  * it will be used in derived contracts.\n', '  * The function body is inserted where the special symbol\n', '  * "_;" in the definition of a modifier appears.\n', '  * This means that if the owner calls this function, the\n', '  * function is executed and otherwise, an exception is  thrown.\n', '  */\n', '  modifier isPeonyContract() {\n', '    require(peony != 0x0);\n', '    require(msg.sender == peony);\n', '    _;\n', '  }\n', '\n', '  /**\n', '  * This contract only defines a modifier but does not use it\n', '  * it will be used in derived contracts.\n', '  * The function body is inserted where the special symbol\n', '  * "_;" in the definition of a modifier appears.\n', '  * This means that if the owner calls this function, the\n', '  * function is executed and otherwise, an exception is  thrown.\n', '  */\n', '  modifier isOwnerOrPeonyContract() {\n', '    require(msg.sender != address(0) && (msg.sender == peony || msg.sender == owner));\n', '    _;\n', '  }\n', '\n', '  /**\n', '  * @notice produce `amount` of tokens to `_owner`\n', '  * @param amount The amount of tokens to produce\n', '  * @return Whether or not producing was successful\n', '  */\n', '  function produce(uint256 amount) isPeonyContract returns (bool) {\n', '    require(totalSupplyLimit == 0 || totalSupply.add(amount) <= totalSupplyLimit);\n', '\n', '    balances[owner] = balances[owner].add(amount);\n', '    totalSupply = totalSupply.add(amount);\n', '\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @notice consume digital artwork tokens for changing physical artwork\n', '  * @param amount consume token amount\n', '  */\n', '  function consume(uint256 amount) isPeonyContract returns (bool) {\n', '    require(balances[owner].sub(amount) >= 0);\n', '    require(totalSupply.sub(amount) >= 0);\n', '    balances[owner] = balances[owner].sub(amount);\n', '    totalSupply = totalSupply.sub(amount);\n', '\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @notice Set address of Peony contract.\n', '  * @param _address the address of Peony contract\n', '  */\n', '  function setPeonyAddress(address _address) onlyOwner returns (bool) {\n', '    require(_address != 0x0);\n', '\n', '    peony = _address;\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * Implements ERC 20 Token standard:https://github.com/ethereum/EIPs/issues/20\n', '  * @notice send `_value` token to `_to`\n', '  * @param _to The address of the recipient\n', '  * @param _value The amount of token to be transferred\n', '  * @return Whether the transfer was successful or not\n', '  */\n', '  function transfer(address _to, uint256 _value) returns (bool) {\n', '    require(_to != address(0));\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '\n', '    Transfer(msg.sender, _to, _value);\n', '\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer tokens from one address to another\n', '  * @param _from address The address which you want to send tokens from\n', '  * @param _to address The address which you want to transfer to\n', '  * @param _value uint256 the amount of tokens to be transferred\n', '  */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '  * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '  * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "  * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '  * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '  * @param _spender The address which will spend the funds.\n', '  * @param _value The amount of tokens to be spent.\n', '  */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '  * @param _owner address The address which owns the funds.\n', '  * @param _spender address The address which will spend the funds.\n', '  * @return A uint256 specifying the amount of tokens still available for the spender.\n', '  */\n', '  function allowance(address _owner, address _spender) public constant returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '  * @notice return total amount of tokens uint256 public totalSupply;\n', '  * @param _owner The address from which the balance will be retrieved\n', '  * @return The balance\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '}\n', '\n', '/**\n', '*Math operations with safety checks\n', '*/\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']