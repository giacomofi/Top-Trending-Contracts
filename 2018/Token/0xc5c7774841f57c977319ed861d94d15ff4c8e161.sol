['pragma solidity ^0.4.22;\n', '\n', 'contract ERC20Basic {\n', '  // events\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '  // public functions\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address addr) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  // public variables\n', '  string public name;\n', '  string public symbol;\n', '  uint8 public decimals = 18;\n', '\n', '  // internal variables\n', '  uint256 _totalSupply;\n', '  mapping(address => uint256) _balances;\n', '\n', '  // events\n', '\n', '  // public functions\n', '  function totalSupply() public view returns (uint256) {\n', '    return _totalSupply;\n', '  }\n', '\n', '  function balanceOf(address addr) public view returns (uint256 balance) {\n', '    return _balances[addr];\n', '  }\n', '\n', '  function transfer(address to, uint256 value) public returns (bool) {\n', '    require(to != address(0));\n', '    require(value <= _balances[msg.sender]);\n', '\n', '    _balances[msg.sender] = _balances[msg.sender].sub(value);\n', '    _balances[to] = _balances[to].add(value);\n', '    emit Transfer(msg.sender, to, value);\n', '    return true;\n', '  }\n', '\n', '  // internal functions\n', '\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  // events\n', '  event Approval(address indexed owner, address indexed agent, uint256 value);\n', '\n', '  // public functions\n', '  function allowance(address owner, address agent) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address agent, uint256 value) public returns (bool);\n', '\n', '}\n', '\n', 'contract Ownable {\n', '\n', '    // public variables\n', '    address public owner;\n', '\n', '    // internal variables\n', '\n', '    // events\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    // public functions\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '    // internal functions\n', '}\n', '\n', 'contract Freezeable is Ownable{\n', '    // public variables\n', '\n', '    // internal variables\n', '    mapping(address => bool) _freezeList;\n', '\n', '    // events\n', '    event Freezed(address indexed freezedAddr);\n', '    event UnFreezed(address indexed unfreezedAddr);\n', '\n', '    // public functions\n', '    function freeze(address addr) onlyOwner whenNotFreezed public returns (bool) {\n', '      require(true != _freezeList[addr]);\n', '\n', '      _freezeList[addr] = true;\n', '\n', '      emit Freezed(addr);\n', '      return true;\n', '    }\n', '\n', '    function unfreeze(address addr) onlyOwner whenFreezed public returns (bool) {\n', '      require(true == _freezeList[addr]);\n', '\n', '      _freezeList[addr] = false;\n', '\n', '      emit UnFreezed(addr);\n', '      return true;\n', '    }\n', '\n', '    modifier whenNotFreezed() {\n', '        require(true != _freezeList[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    modifier whenFreezed() {\n', '        require(true == _freezeList[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    function isFreezing(address addr) public view returns (bool) {\n', '        if (true == _freezeList[addr]) {\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    // internal functions\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '  // public variables\n', '\n', '  // internal variables\n', '  mapping (address => mapping (address => uint256)) _allowances;\n', '\n', '  // events\n', '\n', '  // public functions\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '    require(to != address(0));\n', '    require(value <= _balances[from]);\n', '    require(value <= _allowances[from][msg.sender]);\n', '\n', '    _balances[from] = _balances[from].sub(value);\n', '    _balances[to] = _balances[to].add(value);\n', '    _allowances[from][msg.sender] = _allowances[from][msg.sender].sub(value);\n', '    emit Transfer(from, to, value);\n', '    return true;\n', '  }\n', '\n', '  function approve(address agent, uint256 value) public returns (bool) {\n', '    _allowances[msg.sender][agent] = value;\n', '    emit Approval(msg.sender, agent, value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address owner, address agent) public view returns (uint256) {\n', '    return _allowances[owner][agent];\n', '  }\n', '\n', '  function increaseApproval(address agent, uint value) public returns (bool) {\n', '    _allowances[msg.sender][agent] = _allowances[msg.sender][agent].add(value);\n', '    emit Approval(msg.sender, agent, _allowances[msg.sender][agent]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval(address agent, uint value) public returns (bool) {\n', '    uint allowanceValue = _allowances[msg.sender][agent];\n', '    if (value > allowanceValue) {\n', '      _allowances[msg.sender][agent] = 0;\n', '    } else {\n', '      _allowances[msg.sender][agent] = allowanceValue.sub(value);\n', '    }\n', '    emit Approval(msg.sender, agent, _allowances[msg.sender][agent]);\n', '    return true;\n', '  }\n', '\n', '  // internal functions\n', '}\n', '\n', 'contract FreezeableToken is StandardToken, Freezeable {\n', '    // public variables\n', '\n', '    // internal variables\n', '\n', '    // events\n', '\n', '    // public functions\n', '    function transfer(address to, uint256 value) public whenNotFreezed returns (bool) {\n', '      return super.transfer(to, value);\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint256 value) public whenNotFreezed returns (bool) {\n', '      return super.transferFrom(from, to, value);\n', '    }\n', '\n', '    function approve(address agent, uint256 value) public whenNotFreezed returns (bool) {\n', '      return super.approve(agent, value);\n', '    }\n', '\n', '    function increaseApproval(address agent, uint value) public whenNotFreezed returns (bool success) {\n', '      return super.increaseApproval(agent, value);\n', '    }\n', '\n', '    function decreaseApproval(address agent, uint value) public whenNotFreezed returns (bool success) {\n', '      return super.decreaseApproval(agent, value);\n', '    }\n', '\n', '    // internal functions\n', '}\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '    // public variables\n', '\n', '    // internal variables\n', '\n', '    // events\n', '    event Mint(address indexed to, uint256 value);\n', '\n', '    // public functions\n', '    function mint(address addr, uint256 value) onlyOwner public returns (bool) {\n', '      _totalSupply = _totalSupply.add(value);\n', '      _balances[addr] = _balances[addr].add(value);\n', '\n', '      emit Mint(addr, value);\n', '      emit Transfer(address(0), addr, value);\n', '\n', '      return true;\n', '    }\n', '\n', '    // internal functions\n', '}\n', '\n', 'contract YibToken is FreezeableToken, MintableToken {\n', '    // public variables\n', '    string public name = "Yi Chain";\n', '    string public symbol = "YIB";\n', '    uint8 public decimals = 8;\n', '\n', '    constructor() public {\n', '      _totalSupply = 10000000000 * (10 ** uint256(decimals));\n', '\n', '      _balances[msg.sender] = _totalSupply;\n', '      emit Transfer(0x0, msg.sender, _totalSupply);\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '      if (a == 0) {\n', '        return 0;\n', '      }\n', '      uint256 c = a * b;\n', '      assert(c / a == b);\n', '      return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '      // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '      uint256 c = a / b;\n', "      // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '      return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '      assert(b <= a);\n', '      return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '      uint256 c = a + b;\n', '      assert(c >= a);\n', '      return c;\n', '    }\n', '}']