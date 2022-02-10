['pragma solidity 0.4.24;\n', 'library SafeMath {\n', ' function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '        return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '    }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', ' function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '  bool public paused = false;\n', '\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '  mapping(address => uint256) balances;\n', '  uint256 totalSupply_;\n', '\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        require(msg.data.length >= (2 * 32) + 4);\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) view public returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        require(msg.data.length >= (2 * 32) + 4);\n', '        require(_value == 0 || allowed[msg.sender][_spender] == 0);\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) view public returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '        allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '        allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '   }\n', '\n', '\n', '    mapping (address => uint256) public balances;\n', '    mapping (address => mapping (address => uint256)) public allowed;\n', '}\n', '\n', 'contract PausableToken is StandardToken, Pausable {\n', '  function transfer(address _to,uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.transfer(_to, _value);\n', '  }\n', '  function transferFrom(address _from,address _to,uint256 _value)public whenNotPaused returns (bool)  {\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '  function approve(address _spender,uint256 _value) public whenNotPaused returns (bool){\n', '    return super.approve(_spender, _value);\n', '  }\n', '  function increaseApproval(address _spender,uint _addedValue) public whenNotPaused returns (bool success){\n', '    return super.increaseApproval(_spender, _addedValue);\n', '  }\n', '  function decreaseApproval(address _spender,uint _subtractedValue) public whenNotPaused returns (bool success) {\n', '    return super.decreaseApproval(_spender, _subtractedValue);\n', '  }\n', '}\n', '\n', 'contract HumanStandardToken is PausableToken {\n', '\n', '    function () public {\n', '        revert();\n', '    }\n', '    string public name;\n', '    uint8 public decimals;\n', '    string public symbol; \n', '    string public version = &#39;1.0&#39;;\n', '\n', '    constructor (uint256 _initialAmount, string _tokenName,uint8 _decimalUnits, string _tokenSymbol) internal {\n', '        totalSupply_ = _initialAmount;\n', '        balances[msg.sender] = totalSupply_;\n', '        name = _tokenName;\n', '        decimals = _decimalUnits;\n', '        symbol = _tokenSymbol;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract DVPToken is HumanStandardToken(5000000000*(10**18),"Decentralized Vulnerability Platform",18,"DVP") {}']
['pragma solidity 0.4.24;\n', 'library SafeMath {\n', ' function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '        return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '    }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', ' function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '  bool public paused = false;\n', '\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '  mapping(address => uint256) balances;\n', '  uint256 totalSupply_;\n', '\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        require(msg.data.length >= (2 * 32) + 4);\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) view public returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        require(msg.data.length >= (2 * 32) + 4);\n', '        require(_value == 0 || allowed[msg.sender][_spender] == 0);\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) view public returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '        allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '        allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '   }\n', '\n', '\n', '    mapping (address => uint256) public balances;\n', '    mapping (address => mapping (address => uint256)) public allowed;\n', '}\n', '\n', 'contract PausableToken is StandardToken, Pausable {\n', '  function transfer(address _to,uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.transfer(_to, _value);\n', '  }\n', '  function transferFrom(address _from,address _to,uint256 _value)public whenNotPaused returns (bool)  {\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '  function approve(address _spender,uint256 _value) public whenNotPaused returns (bool){\n', '    return super.approve(_spender, _value);\n', '  }\n', '  function increaseApproval(address _spender,uint _addedValue) public whenNotPaused returns (bool success){\n', '    return super.increaseApproval(_spender, _addedValue);\n', '  }\n', '  function decreaseApproval(address _spender,uint _subtractedValue) public whenNotPaused returns (bool success) {\n', '    return super.decreaseApproval(_spender, _subtractedValue);\n', '  }\n', '}\n', '\n', 'contract HumanStandardToken is PausableToken {\n', '\n', '    function () public {\n', '        revert();\n', '    }\n', '    string public name;\n', '    uint8 public decimals;\n', '    string public symbol; \n', "    string public version = '1.0';\n", '\n', '    constructor (uint256 _initialAmount, string _tokenName,uint8 _decimalUnits, string _tokenSymbol) internal {\n', '        totalSupply_ = _initialAmount;\n', '        balances[msg.sender] = totalSupply_;\n', '        name = _tokenName;\n', '        decimals = _decimalUnits;\n', '        symbol = _tokenSymbol;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract DVPToken is HumanStandardToken(5000000000*(10**18),"Decentralized Vulnerability Platform",18,"DVP") {}']