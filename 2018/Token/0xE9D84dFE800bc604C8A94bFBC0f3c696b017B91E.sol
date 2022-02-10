['pragma solidity ^0.4.0;\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */ \n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '  \n', '    modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '  \n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract MintableToken is BasicToken, Ownable {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '  \n', '  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '    totalSupply_ = totalSupply_.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    emit Mint(_to, _amount);\n', '    emit Transfer(address(0), _to, _amount);\n', '    return true;\n', '  }\n', '  \n', '  function finishMinting() onlyOwner canMint public returns (bool) {\n', '    mintingFinished = true;\n', '    emit MintFinished();\n', '    return true;\n', '  }\n', '}  \n', '\n', '\n', 'contract VoidToken is Ownable, MintableToken {\n', '  string public constant name = "VOID TOKEN";\n', '  string public constant symbol = "VOID";\n', '  uint256 public constant decimals = 8;\n', '  uint256 public constant fixed_value = 100 * (10 ** uint256(decimals));\n', '  uint256 public totalAirDropped = 0;\n', '  address owner_address;\n', '  mapping (address => bool) air_dropped;\n', '\n', '  uint256 public INITIAL_TOTAL_SUPPLY = 10 ** 8 * (10 ** uint256(decimals));\n', '\n', '  constructor() public {\n', '    totalSupply_ = INITIAL_TOTAL_SUPPLY;\n', '    owner_address = msg.sender;\n', '    balances[owner_address] = totalSupply_;\n', '    emit Transfer(address(0), owner_address, totalSupply_);\n', '  }\n', '\n', '  function batch_send(address[] addresses, uint256 value) onlyOwner public{\n', '    require(addresses.length < 255);\n', '    for(uint i = 0; i < addresses.length; i++)\n', '    {\n', '      require(value <= totalSupply_);\n', '      transfer(addresses[i], value);\n', '    }\n', '  }\n', '\n', '  function airdrop(address[] addresses, uint256 value) onlyOwner public{\n', '    require(addresses.length < 255);\n', '    for(uint i = 0; i < addresses.length; i++)\n', '    {\n', '      require(value <= totalSupply_);\n', '      require(air_dropped[addresses[i]] == false);\n', '      air_dropped[addresses[i]] = true;\n', '      transfer(addresses[i], value);\n', '      totalAirDropped = totalAirDropped.add(value);\n', '    }\n', '  }\n', '\n', '  function () external payable{\n', '      airdrop_auto(msg.sender);\n', '  }\n', '\n', '  function airdrop_auto(address investor_address) public payable returns (bool success){\n', '    require(investor_address != address(0));\n', '    require(air_dropped[investor_address] == false);\n', '    require(fixed_value <= totalSupply_);\n', '    totalAirDropped = totalAirDropped.add(fixed_value);\n', '    balances[owner_address] = balances[owner_address].sub(fixed_value);\n', '    balances[investor_address] = balances[investor_address].add(fixed_value);\n', '    emit Transfer(owner_address, investor_address, fixed_value);\n', '    forward_funds(msg.value);\n', '    return true;\n', '  }\n', ' \n', '  function forward_funds(uint256 funds) internal {\n', '    if(funds > 0){\n', '      owner_address.transfer(funds);\n', '    }\n', '  }\n', '}']