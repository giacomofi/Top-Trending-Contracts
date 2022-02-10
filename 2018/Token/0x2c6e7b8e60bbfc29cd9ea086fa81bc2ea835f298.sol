['pragma solidity ^0.4.22;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  /**\n', '   * @dev Multiplies two numbers, throws on overflow\n', '   */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0 || b == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '   * @dev Integer division of two numbers, truncating the quotient\n', '   */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  /**\n', '   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '   */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '   * @dev Adds two numbers, throws on overflow.\n', '   */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of ERC20 token interface\n', ' */\n', 'contract ERC20Token {\n', '  using SafeMath for uint256;\n', '\n', '  uint256 public totalSupply;\n', '\n', '  mapping (address => uint256) public balanceOf;\n', '  mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '  /**\n', '   * @dev Send tokens to a specified address\n', '   * @param _to     address  The address to send to\n', '   * @param _value  uint256  The amount to send\n', '   */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    // Prevent sending to zero address\n', '    require(_to != address(0));\n', '    // Check sender has enough balance\n', '    require(_value <= balanceOf[msg.sender]);\n', '\n', '    // Do transfer\n', '    balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '    balanceOf[_to] = balanceOf[_to].add(_value);\n', '\n', '    emit Transfer(msg.sender, _to, _value);\n', '\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Send tokens in behalf of one address to another\n', '   * @param _from   address   The sender address\n', '   * @param _to     address   The recipient address\n', '   * @param _value  uint256   The amount to send\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    // Prevent sending to zero address\n', '    require(_to != address(0));\n', '    // Check sender has enough balance\n', '    require(_value <= balanceOf[_from]);\n', '    // Check caller has enough allowed balance\n', '    require(_value <= allowance[_from][msg.sender]);\n', '\n', '    // Make sure sending amount is subtracted from `allowance` before actual transfer\n', '    allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);\n', '\n', '    // Do transfer\n', '    balanceOf[_from] = balanceOf[_from].sub(_value);\n', '    balanceOf[_to] = balanceOf[_to].add(_value);\n', '\n', '    emit Transfer(_from, _to, _value);\n', '\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @param _spender  address   The address which will spend the funds.\n', '   * @param _value    uint256   The amount of tokens can be spend.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowance[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ApproveAndCallFallBack\n', ' * @dev Interface to notify contracts about approved tokens\n', ' */\n', 'contract ApproveAndCallFallBack {\n', '  function receiveApproval(address _from, uint256 _amount, address _token, bytes _data) public;\n', '}\n', '\n', 'contract BCBToken is ERC20Token, Ownable {\n', '  uint256 constant public BCB_UNIT = 10 ** 18;\n', '\n', '  string public constant name = "BCBToken";\n', '  string public constant symbol = "BCB";\n', '  uint32 public constant decimals = 18;\n', '\n', '  uint256 public totalSupply = 120000000 * BCB_UNIT;\n', '  uint256 public lockedAllocation = 53500000 * BCB_UNIT;\n', '  uint256 public totalAllocated = 0;\n', '  address public allocationAddress;\n', '\n', '  uint256 public lockEndTime;\n', '\n', '  constructor(address _allocationAddress) public {\n', '    // Transfer the rest of the tokens to the owner\n', '    balanceOf[owner] = totalSupply - lockedAllocation;\n', '    allocationAddress = _allocationAddress;\n', '\n', '    // Lock for 12 months\n', '    lockEndTime = now + 12 * 30 days;\n', '  }\n', '\n', '  /**\n', '   * @dev Release all locked tokens\n', '   * throws if called not by the owner or called before timelock (12 months)\n', '   * or if tokens were already allocated\n', '   */\n', '  function releaseLockedTokens() public onlyOwner {\n', '    require(now > lockEndTime);\n', '    require(totalAllocated < lockedAllocation);\n', '\n', '    totalAllocated = lockedAllocation;\n', '    balanceOf[allocationAddress] = balanceOf[allocationAddress].add(lockedAllocation);\n', '\n', '    emit Transfer(0x0, allocationAddress, lockedAllocation);\n', '  }\n', '\n', '  /**\n', '   * @dev Allow other contract to spend tokens and notify the contract about it a in single transaction\n', '   * @param _spender    address   The contract address authorized to spend\n', '   * @param _value      uint256   The amount of tokens can be spend\n', '   * @param _extraData  bytes     Some extra information to send to the approved contract\n', '   */\n', '  function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool) {\n', '    if (approve(_spender, _value)) {\n', '      ApproveAndCallFallBack(_spender).receiveApproval(msg.sender, _value, address(this), _extraData);\n', '      return true;\n', '    }\n', '  }\n', '}']