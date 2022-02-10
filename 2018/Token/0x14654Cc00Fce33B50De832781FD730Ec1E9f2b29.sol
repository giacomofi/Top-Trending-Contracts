['pragma solidity ^0.4.18;\n', '\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', '\n', 'contract Admin is Ownable {\n', '  mapping(address => bool) public adminlist;\n', '\n', '  event AdminAddressAdded(address addr);\n', '  event AdminAddressRemoved(address addr);\n', '\n', '  function isAdmin() public view returns(bool) {\n', '    if (owner == msg.sender) {\n', '      return true;\n', '    }\n', '    return adminlist[msg.sender];\n', '  }\n', '\n', '  function isAdminAddress(address addr) view public returns(bool) {\n', '    return adminlist[addr];\n', '  }\n', '\n', '  function addAddressToAdminlist(address addr) onlyOwner public returns(bool success) {\n', '    if (!adminlist[addr]) {\n', '      adminlist[addr] = true;\n', '      AdminAddressAdded(addr);\n', '      success = true;\n', '    }\n', '  }\n', '\n', '  function removeAddressFromAdminlist(address addr) onlyOwner public returns(bool success) {\n', '    if (adminlist[addr]) {\n', '      adminlist[addr] = false;\n', '      AdminAddressRemoved(addr);\n', '      success = true;\n', '    }\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract Pausable is Ownable, Admin {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '  modifier whenNotPaused() {\n', '    require(!paused || isAdmin());\n', '    _;\n', '  }\n', '\n', '  modifier whenPaused() {\n', '    require(paused || isAdmin());\n', '    _;\n', '  }\n', '\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    Pause();\n', '  }\n', '\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    Unpause();\n', '  }\n', '}\n', '\n', '\n', '\n', 'contract ERC20 {\n', '\n', '  function totalSupply() public view returns (uint256);\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '\n', 'contract SafeMath {\n', '\n', '  function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {\n', '    uint256 z = x + y;\n', '    assert((z >= x) && (z >= y));\n', '    return z;\n', '  }\n', '\n', '  function safeSubtract(uint256 x, uint256 y) internal pure returns(uint256) {\n', '    assert(x >= y);\n', '    uint256 z = x - y;\n', '    return z;\n', '  }\n', '\n', '  function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {\n', '    uint256 z = x * y;\n', '    assert((x == 0)||(z/x == y));\n', '    return z;\n', '  }\n', '\n', '  function safeDiv(uint256 x, uint256 y) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 z = x / y;\n', '    return z;\n', '  }\n', '}\n', '\n', '\n', 'contract StandardToken is ERC20, SafeMath {\n', '  /**\n', '  * @dev Fix for the ERC20 short address attack.\n', '   */\n', '  modifier onlyPayloadSize(uint size) {\n', '    require(msg.data.length >= size + 4) ;\n', '    _;\n', '  }\n', '\n', '  mapping(address => uint256) balances;\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) public returns (bool){\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = safeSubtract(balances[msg.sender], _value);\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    uint _allowance = allowed[_from][msg.sender];\n', '\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    balances[_from] = safeSubtract(balances[_from], _value);\n', '    allowed[_from][msg.sender] = safeSubtract(_allowance, _value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public view returns (uint) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', 'contract WeiToken is StandardToken, Pausable {\n', '  string public constant name = "WeiToken";\n', '  string public constant symbol = "YOUNG";\n', '  uint256 public constant decimals = 18;\n', '  string public version = "1.0";\n', '\n', '  uint256 public constant total = 65 * (10**8) * 10**decimals;   // 20 *10^8 HNC total\n', '\n', '  function WeiToken() public {\n', '    balances[msg.sender] = total;\n', '    Transfer(0x0, msg.sender, total);\n', '  }\n', '\n', '  function totalSupply() public view returns (uint256) {\n', '    return total;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) whenNotPaused public returns (bool success) {\n', '    return super.transfer(_to,_value);\n', '  }\n', '\n', '  function approve(address _spender, uint _value) whenNotPaused public returns (bool success) {\n', '    return super.approve(_spender,_value);\n', '  }\n', '\n', '  function airdropToAddresses(address[] addrs, uint256 amount) public {\n', '    for (uint256 i = 0; i < addrs.length; i++) {\n', '      transfer(addrs[i], amount);\n', '    }\n', '  }\n', '}']