['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-05\n', '*/\n', '\n', '/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-05\n', '*/\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'contract StandardToken is ERC20 {\n', '  using SafeMath for uint256;\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\tmapping(address => bool) tokenBlacklist;\n', '\tevent Blacklist(address indexed blackListed, bool value);\n', '\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(tokenBlacklist[msg.sender] == false);\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(tokenBlacklist[msg.sender] == false);\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '  \n', '\n', '\n', '  function _blackList(address _address, bool _isBlackListed) internal returns (bool) {\n', '\trequire(tokenBlacklist[_address] != _isBlackListed);\n', '\ttokenBlacklist[_address] = _isBlackListed;\n', '\temit Blacklist(_address, _isBlackListed);\n', '\treturn true;\n', '  }\n', '\n', '\n', '\n', '}\n', '\n', 'contract PausableToken is StandardToken, Pausable {\n', '\n', '  function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.approve(_spender, _value);\n', '  }\n', '\n', '  function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {\n', '    return super.increaseApproval(_spender, _addedValue);\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {\n', '    return super.decreaseApproval(_spender, _subtractedValue);\n', '  }\n', '  \n', '  function blackListAddress(address listAddress,  bool isBlackListed) public whenNotPaused onlyOwner  returns (bool success) {\n', '\treturn super._blackList(listAddress, isBlackListed);\n', '  }\n', '  \n', '}\n', '\n', 'contract CoinToken is PausableToken {\n', '    string public name;\n', '    string public symbol;\n', '    uint public decimals;\n', '    event Mint(address indexed from, address indexed to, uint256 value);\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '\t\n', '    constructor(string memory _name, string memory _symbol, uint256 _decimals, uint256 _supply, address tokenOwner) public {\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '        totalSupply = _supply * 10**_decimals;\n', '        balances[tokenOwner] = totalSupply;\n', '        owner = tokenOwner;\n', '        emit Transfer(address(0), tokenOwner, totalSupply);\n', '    }\n', '\t\n', '\tfunction burn(uint256 _value) public {\n', '\t\t_burn(msg.sender, _value);\n', '\t}\n', '\n', '\tfunction _burn(address _who, uint256 _value) internal {\n', '\t\trequire(_value <= balances[_who]);\n', '\t\tbalances[_who] = balances[_who].sub(_value);\n', '\t\ttotalSupply = totalSupply.sub(_value);\n', '\t\temit Burn(_who, _value);\n', '\t\temit Transfer(_who, address(0), _value);\n', '\t}\n', '\n', '    function mint(address account, uint256 amount) onlyOwner public {\n', '\n', '        totalSupply = totalSupply.add(amount);\n', '        balances[account] = balances[account].add(amount);\n', '        emit Mint(address(0), account, amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '\n', '    \n', '}']