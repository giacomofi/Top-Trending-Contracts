['pragma solidity ^0.4.18;\n', '\n', '/*\n', '\n', '  Copyright 2018 Kotlind Foundation.\n', '  https://www.ktd.io/\n', '\n', '*/\n', '\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'contract BurnableToken is BasicToken {\n', '\n', '  event Burn(address indexed burner, uint256 value);\n', '\n', '  function burn(uint256 _value) public {\n', '    require(_value <= balances[msg.sender]);\n', '    address burner = msg.sender;\n', '    balances[burner] = balances[burner].sub(_value);\n', '    totalSupply_ = totalSupply_.sub(_value);\n', '    Burn(burner, _value);\n', '    Transfer(burner, address(0), _value);\n', '  }\n', '}\n', '\n', 'contract Kotlind is StandardToken, BurnableToken, Ownable {\n', '    // Constants\n', '    string  public constant name = "Kotlind";\n', '    string  public constant symbol = "KTD";\n', '    uint8   public constant decimals = 9;\n', '    uint256 public constant INITIAL_SUPPLY      = 100000000 * (10 ** uint256(decimals));\n', '\n', '    uint public amountRaised;\n', '    uint256 public buyPrice = 575;\n', '    bool public crowdsaleClosed;\n', '\n', '    function Kotlind() public {\n', '    \ttotalSupply_ = INITIAL_SUPPLY;\n', '      balances[msg.sender] = INITIAL_SUPPLY;\n', '      Transfer(0x0, msg.sender, INITIAL_SUPPLY);\n', '  \t}\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {     \n', '        require (balances[_from] >= _value);\n', '        require (balances[_to] + _value > balances[_to]);\n', '   \n', '        balances[_from] -= _value;\n', '        balances[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    function setPrices(bool closebuy, uint256 newBuyPrice) onlyOwner public {\n', '        crowdsaleClosed=closebuy;\n', '        buyPrice = newBuyPrice;\n', '    }\n', '\n', '    function () payable public{\n', '        require(!crowdsaleClosed);\n', '        uint amount = msg.value ;\n', '        amountRaised+=amount;\n', '        _transfer(owner, msg.sender, amount * buyPrice);\n', '    }\n', '\n', '    function safeWithdrawal() onlyOwner public {\n', '       owner.transfer(amountRaised);\n', '    }\n', '\n', '    function batchTransfer(address[] _recipients, uint[] _values) onlyOwner public returns (bool) {\n', '        require( _recipients.length > 0 && _recipients.length == _values.length);\n', '\n', '        uint total = 0;\n', '        for(uint i = 0; i < _values.length; i++){\n', '            total = total.add(_values[i]);\n', '        }\n', '        require(total <= balances[msg.sender]);\n', '\n', '        for(uint j = 0; j < _recipients.length; j++){\n', '            balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);\n', '            Transfer(msg.sender, _recipients[j], _values[j]);\n', '        }\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(total);\n', '        return true;\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '/*\n', '\n', '  Copyright 2018 Kotlind Foundation.\n', '  https://www.ktd.io/\n', '\n', '*/\n', '\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'contract BurnableToken is BasicToken {\n', '\n', '  event Burn(address indexed burner, uint256 value);\n', '\n', '  function burn(uint256 _value) public {\n', '    require(_value <= balances[msg.sender]);\n', '    address burner = msg.sender;\n', '    balances[burner] = balances[burner].sub(_value);\n', '    totalSupply_ = totalSupply_.sub(_value);\n', '    Burn(burner, _value);\n', '    Transfer(burner, address(0), _value);\n', '  }\n', '}\n', '\n', 'contract Kotlind is StandardToken, BurnableToken, Ownable {\n', '    // Constants\n', '    string  public constant name = "Kotlind";\n', '    string  public constant symbol = "KTD";\n', '    uint8   public constant decimals = 9;\n', '    uint256 public constant INITIAL_SUPPLY      = 100000000 * (10 ** uint256(decimals));\n', '\n', '    uint public amountRaised;\n', '    uint256 public buyPrice = 575;\n', '    bool public crowdsaleClosed;\n', '\n', '    function Kotlind() public {\n', '    \ttotalSupply_ = INITIAL_SUPPLY;\n', '      balances[msg.sender] = INITIAL_SUPPLY;\n', '      Transfer(0x0, msg.sender, INITIAL_SUPPLY);\n', '  \t}\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {     \n', '        require (balances[_from] >= _value);\n', '        require (balances[_to] + _value > balances[_to]);\n', '   \n', '        balances[_from] -= _value;\n', '        balances[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    function setPrices(bool closebuy, uint256 newBuyPrice) onlyOwner public {\n', '        crowdsaleClosed=closebuy;\n', '        buyPrice = newBuyPrice;\n', '    }\n', '\n', '    function () payable public{\n', '        require(!crowdsaleClosed);\n', '        uint amount = msg.value ;\n', '        amountRaised+=amount;\n', '        _transfer(owner, msg.sender, amount * buyPrice);\n', '    }\n', '\n', '    function safeWithdrawal() onlyOwner public {\n', '       owner.transfer(amountRaised);\n', '    }\n', '\n', '    function batchTransfer(address[] _recipients, uint[] _values) onlyOwner public returns (bool) {\n', '        require( _recipients.length > 0 && _recipients.length == _values.length);\n', '\n', '        uint total = 0;\n', '        for(uint i = 0; i < _values.length; i++){\n', '            total = total.add(_values[i]);\n', '        }\n', '        require(total <= balances[msg.sender]);\n', '\n', '        for(uint j = 0; j < _recipients.length; j++){\n', '            balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);\n', '            Transfer(msg.sender, _recipients[j], _values[j]);\n', '        }\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(total);\n', '        return true;\n', '    }\n', '}']
