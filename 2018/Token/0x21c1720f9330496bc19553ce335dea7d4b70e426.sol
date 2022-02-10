['pragma solidity ^0.4.20;\n', '\n', 'contract SafeMath {\n', '  function safeMul(uint256 a, uint256 b) public pure  returns (uint256)  {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint256 a, uint256 b)public pure returns (uint256) {\n', '    assert(b > 0);\n', '    uint256 c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint256 a, uint256 b)public pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint256 a, uint256 b)public pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  function _assert(bool assertion)public pure {\n', '    assert(!assertion);\n', '  }\n', '}\n', '\n', '\n', 'contract ERC20Interface {\n', '  string public name;\n', '  string public symbol;\n', '  uint8 public  decimals;\n', '  uint public totalSupply;\n', '  function transfer(address _to, uint256 _value) returns (bool success);\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '  \n', '  function approve(address _spender, uint256 _value) returns (bool success);\n', '  function allowance(address _owner, address _spender) view returns (uint256 remaining);\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', ' }\n', ' \n', 'contract ERC20 is ERC20Interface,SafeMath {\n', '\n', '    // ?????????????balanceOf????\n', '    mapping(address => uint256) public balanceOf;\n', '\n', '    // allowed?????????????????address?? ????????????(?????address)?????uint256??\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '\n', '    constructor(string _name) public {\n', '       name = _name;  // "UpChain";\n', '       symbol = "ETPP";\n', '       decimals = 4;\n', '       totalSupply = 1038628770000;\n', '       balanceOf[msg.sender] = totalSupply;\n', '    }\n', '\n', '  // ???\n', '  function transfer(address _to, uint256 _value) returns (bool success) {\n', '      require(_to != address(0));\n', '      require(balanceOf[msg.sender] >= _value);\n', '      require(balanceOf[ _to] + _value >= balanceOf[ _to]);   // ??????\n', '\n', '      balanceOf[msg.sender] =SafeMath.safeSub(balanceOf[msg.sender],_value) ;\n', '      balanceOf[_to] =SafeMath.safeAdd(balanceOf[_to] ,_value);\n', '\n', '      // ???????\n', '      emit Transfer(msg.sender, _to, _value);\n', '\n', '      return true;\n', '  }\n', '\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '      require(_to != address(0));\n', '      require(allowed[_from][msg.sender] >= _value);\n', '      require(balanceOf[_from] >= _value);\n', '      require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '\n', '      balanceOf[_from] =SafeMath.safeSub(balanceOf[_from],_value) ;\n', '      balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to],_value);\n', '\n', '      allowed[_from][msg.sender] =SafeMath.safeSub(allowed[_from][msg.sender], _value);\n', '\n', '      emit Transfer(msg.sender, _to, _value);\n', '      return true;\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) returns (bool success) {\n', '      allowed[msg.sender][_spender] = _value;\n', '\n', '      emit Approval(msg.sender, _spender, _value);\n', '      return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) view returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    constructor () public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnerShip(address newOwer) public onlyOwner {\n', '        owner = newOwer;\n', '    }\n', '\n', '}\n', '\n', 'contract SelfDesctructionContract is owned {\n', '   \n', '   string  public someValue;\n', '   modifier ownerRestricted {\n', '      require(owner == msg.sender);\n', '      _;\n', '   } \n', '   // constructor\n', '   function SelfDesctructionContract() {\n', '      owner = msg.sender;\n', '   }\n', '   // a simple setter function\n', '   function setSomeValue(string value){\n', '      someValue = value;\n', '   } \n', '   // you can call it anything you want\n', '   function destroyContract() ownerRestricted {\n', '     selfdestruct(owner);\n', '   }\n', '}\n', '\n', '\n', '\n', 'contract AdvanceToken is ERC20, owned,SelfDesctructionContract{\n', '\n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    event AddSupply(uint amount);\n', '    event FrozenFunds(address target, bool frozen);\n', '    event Burn(address target, uint amount);\n', '\n', '    constructor (string _name) ERC20(_name) public {\n', '\n', '    }\n', '\n', '    function mine(address target, uint amount) public onlyOwner {\n', '        totalSupply =SafeMath.safeAdd(totalSupply,amount) ;\n', '        balanceOf[target] = SafeMath.safeAdd(balanceOf[target],amount);\n', '\n', '        emit AddSupply(amount);\n', '        emit Transfer(0, target, amount);\n', '    }\n', '\n', '    function freezeAccount(address target, bool freeze) public onlyOwner {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        success = _transfer(msg.sender, _to, _value);\n', '  }\n', '\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(allowed[_from][msg.sender] >= _value);\n', '        success =  _transfer(_from, _to, _value);\n', '        allowed[_from][msg.sender] =SafeMath.safeSub(allowed[_from][msg.sender],_value) ;\n', '  }\n', '\n', '  function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {\n', '      require(_to != address(0));\n', '      require(!frozenAccount[_from]);\n', '\n', '      require(balanceOf[_from] >= _value);\n', '      require(balanceOf[ _to] + _value >= balanceOf[ _to]);\n', '\n', '      balanceOf[_from] =SafeMath.safeSub(balanceOf[_from],_value) ;\n', '      balanceOf[_to] =SafeMath.safeAdd(balanceOf[_to],_value) ;\n', '\n', '      emit Transfer(_from, _to, _value);\n', '      return true;\n', '  }\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '\n', '        totalSupply =SafeMath.safeSub(totalSupply,_value) ;\n', '        balanceOf[msg.sender] =SafeMath.safeSub(balanceOf[msg.sender],_value) ;\n', '\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(address _from, uint256 _value)  public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);\n', '        require(allowed[_from][msg.sender] >= _value);\n', '\n', '        totalSupply =SafeMath.safeSub(totalSupply,_value) ;\n', '        balanceOf[msg.sender] =SafeMath.safeSub(balanceOf[msg.sender], _value);\n', '        allowed[_from][msg.sender] =SafeMath.safeSub(allowed[_from][msg.sender],_value);\n', '\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '}']
['pragma solidity ^0.4.20;\n', '\n', 'contract SafeMath {\n', '  function safeMul(uint256 a, uint256 b) public pure  returns (uint256)  {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint256 a, uint256 b)public pure returns (uint256) {\n', '    assert(b > 0);\n', '    uint256 c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint256 a, uint256 b)public pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint256 a, uint256 b)public pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  function _assert(bool assertion)public pure {\n', '    assert(!assertion);\n', '  }\n', '}\n', '\n', '\n', 'contract ERC20Interface {\n', '  string public name;\n', '  string public symbol;\n', '  uint8 public  decimals;\n', '  uint public totalSupply;\n', '  function transfer(address _to, uint256 _value) returns (bool success);\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '  \n', '  function approve(address _spender, uint256 _value) returns (bool success);\n', '  function allowance(address _owner, address _spender) view returns (uint256 remaining);\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', ' }\n', ' \n', 'contract ERC20 is ERC20Interface,SafeMath {\n', '\n', '    // ?????????????balanceOf????\n', '    mapping(address => uint256) public balanceOf;\n', '\n', '    // allowed?????????????????address?? ????????????(?????address)?????uint256??\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '\n', '    constructor(string _name) public {\n', '       name = _name;  // "UpChain";\n', '       symbol = "ETPP";\n', '       decimals = 4;\n', '       totalSupply = 1038628770000;\n', '       balanceOf[msg.sender] = totalSupply;\n', '    }\n', '\n', '  // ???\n', '  function transfer(address _to, uint256 _value) returns (bool success) {\n', '      require(_to != address(0));\n', '      require(balanceOf[msg.sender] >= _value);\n', '      require(balanceOf[ _to] + _value >= balanceOf[ _to]);   // ??????\n', '\n', '      balanceOf[msg.sender] =SafeMath.safeSub(balanceOf[msg.sender],_value) ;\n', '      balanceOf[_to] =SafeMath.safeAdd(balanceOf[_to] ,_value);\n', '\n', '      // ???????\n', '      emit Transfer(msg.sender, _to, _value);\n', '\n', '      return true;\n', '  }\n', '\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '      require(_to != address(0));\n', '      require(allowed[_from][msg.sender] >= _value);\n', '      require(balanceOf[_from] >= _value);\n', '      require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '\n', '      balanceOf[_from] =SafeMath.safeSub(balanceOf[_from],_value) ;\n', '      balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to],_value);\n', '\n', '      allowed[_from][msg.sender] =SafeMath.safeSub(allowed[_from][msg.sender], _value);\n', '\n', '      emit Transfer(msg.sender, _to, _value);\n', '      return true;\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) returns (bool success) {\n', '      allowed[msg.sender][_spender] = _value;\n', '\n', '      emit Approval(msg.sender, _spender, _value);\n', '      return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) view returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    constructor () public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnerShip(address newOwer) public onlyOwner {\n', '        owner = newOwer;\n', '    }\n', '\n', '}\n', '\n', 'contract SelfDesctructionContract is owned {\n', '   \n', '   string  public someValue;\n', '   modifier ownerRestricted {\n', '      require(owner == msg.sender);\n', '      _;\n', '   } \n', '   // constructor\n', '   function SelfDesctructionContract() {\n', '      owner = msg.sender;\n', '   }\n', '   // a simple setter function\n', '   function setSomeValue(string value){\n', '      someValue = value;\n', '   } \n', '   // you can call it anything you want\n', '   function destroyContract() ownerRestricted {\n', '     selfdestruct(owner);\n', '   }\n', '}\n', '\n', '\n', '\n', 'contract AdvanceToken is ERC20, owned,SelfDesctructionContract{\n', '\n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    event AddSupply(uint amount);\n', '    event FrozenFunds(address target, bool frozen);\n', '    event Burn(address target, uint amount);\n', '\n', '    constructor (string _name) ERC20(_name) public {\n', '\n', '    }\n', '\n', '    function mine(address target, uint amount) public onlyOwner {\n', '        totalSupply =SafeMath.safeAdd(totalSupply,amount) ;\n', '        balanceOf[target] = SafeMath.safeAdd(balanceOf[target],amount);\n', '\n', '        emit AddSupply(amount);\n', '        emit Transfer(0, target, amount);\n', '    }\n', '\n', '    function freezeAccount(address target, bool freeze) public onlyOwner {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        success = _transfer(msg.sender, _to, _value);\n', '  }\n', '\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(allowed[_from][msg.sender] >= _value);\n', '        success =  _transfer(_from, _to, _value);\n', '        allowed[_from][msg.sender] =SafeMath.safeSub(allowed[_from][msg.sender],_value) ;\n', '  }\n', '\n', '  function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {\n', '      require(_to != address(0));\n', '      require(!frozenAccount[_from]);\n', '\n', '      require(balanceOf[_from] >= _value);\n', '      require(balanceOf[ _to] + _value >= balanceOf[ _to]);\n', '\n', '      balanceOf[_from] =SafeMath.safeSub(balanceOf[_from],_value) ;\n', '      balanceOf[_to] =SafeMath.safeAdd(balanceOf[_to],_value) ;\n', '\n', '      emit Transfer(_from, _to, _value);\n', '      return true;\n', '  }\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '\n', '        totalSupply =SafeMath.safeSub(totalSupply,_value) ;\n', '        balanceOf[msg.sender] =SafeMath.safeSub(balanceOf[msg.sender],_value) ;\n', '\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(address _from, uint256 _value)  public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);\n', '        require(allowed[_from][msg.sender] >= _value);\n', '\n', '        totalSupply =SafeMath.safeSub(totalSupply,_value) ;\n', '        balanceOf[msg.sender] =SafeMath.safeSub(balanceOf[msg.sender], _value);\n', '        allowed[_from][msg.sender] =SafeMath.safeSub(allowed[_from][msg.sender],_value);\n', '\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '}']
