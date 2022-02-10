['pragma solidity ^0.4.21;\n', '\n', '\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a / b;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract TokenERC20 is Ownable {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    string public constant name       = "Biological Chain";\n', '    string public constant symbol     = "BICC";\n', '    uint32 public constant decimals   = 18;\n', '    uint256 public totalSupply;\n', '    uint256 public currentTotalSupply = 0;\n', '    uint256 public airdrop;\n', '    uint256 public startBalance;\n', '    uint256 public buyPrice ;\n', '\n', '    mapping(address => bool) touched;\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping (address => uint256)) internal allowed;\n', '    mapping(address => bool) public frozenAccount;\n', '\n', '    event FrozenFunds(address target, bool frozen);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    constructor(\n', '        uint256 initialSupply\n', '    ) public {\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount\n', '        balances[msg.sender] = totalSupply;                // Give the creator all initial tokens\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '\n', '        if( !touched[msg.sender] && currentTotalSupply < totalSupply && currentTotalSupply < airdrop ){\n', '            balances[msg.sender] = balances[msg.sender].add( startBalance );\n', '            touched[msg.sender] = true;\n', '            currentTotalSupply = currentTotalSupply.add( startBalance );\n', '        }\n', '\n', '        require(!frozenAccount[msg.sender]);\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        require(!frozenAccount[_from]);\n', '\n', '        if( !touched[_from] && currentTotalSupply < totalSupply && currentTotalSupply < airdrop  ){\n', '            touched[_from] = true;\n', '            balances[_from] = balances[_from].add( startBalance );\n', '            currentTotalSupply = currentTotalSupply.add( startBalance );\n', '        }\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function getBalance(address _a) internal constant returns(uint256) {\n', '        if( currentTotalSupply < totalSupply ){\n', '            if( touched[_a] )\n', '                return balances[_a];\n', '            else\n', '                return balances[_a].add( startBalance );\n', '        } else {\n', '            return balances[_a];\n', '        }\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return getBalance( _owner );\n', '    }\n', '\n', '\n', '    function burn(uint256 _value)  public  {\n', '        _burn(msg.sender, _value);\n', '    }\n', '\n', '    function _burn(address _who, uint256 _value) internal {\n', '        require(_value <= balances[_who]);\n', '        balances[_who] = balances[_who].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        emit Burn(_who, _value);\n', '        emit Transfer(_who, address(0), _value);\n', '    }\n', '\n', '\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '        balances[target] = balances[target].add(mintedAmount);\n', '        totalSupply = totalSupply.add(mintedAmount);\n', '        emit Transfer(0, this, mintedAmount);\n', '        emit Transfer(this, target, mintedAmount);\n', '    }\n', '\n', '\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '\n', '\n', '    function setPrices(uint256 newBuyPrice) onlyOwner public {\n', '        buyPrice = newBuyPrice;\n', '    }\n', '\n', '    function () payable public {\n', '        uint amount = msg.value * buyPrice;\n', '        balances[msg.sender] = balances[msg.sender].add(amount);\n', '        balances[owner] = balances[owner].sub(amount);\n', '        emit Transfer(owner, msg.sender, amount);\n', '    }\n', '\n', '\n', '    function selfdestructs() payable  public onlyOwner {\n', '        selfdestruct(owner);\n', '    }\n', '\n', '\n', '    function getEth(uint num) payable public onlyOwner {\n', '        owner.transfer(num);\n', '    }\n', '\n', '\n', '    function modifyairdrop(uint256 _airdrop,uint256 _startBalance ) public onlyOwner {\n', '        airdrop = _airdrop;\n', '        startBalance = _startBalance;\n', '    }\n', '}']
['pragma solidity ^0.4.21;\n', '\n', '\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a / b;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract TokenERC20 is Ownable {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    string public constant name       = "Biological Chain";\n', '    string public constant symbol     = "BICC";\n', '    uint32 public constant decimals   = 18;\n', '    uint256 public totalSupply;\n', '    uint256 public currentTotalSupply = 0;\n', '    uint256 public airdrop;\n', '    uint256 public startBalance;\n', '    uint256 public buyPrice ;\n', '\n', '    mapping(address => bool) touched;\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping (address => uint256)) internal allowed;\n', '    mapping(address => bool) public frozenAccount;\n', '\n', '    event FrozenFunds(address target, bool frozen);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    constructor(\n', '        uint256 initialSupply\n', '    ) public {\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount\n', '        balances[msg.sender] = totalSupply;                // Give the creator all initial tokens\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '\n', '        if( !touched[msg.sender] && currentTotalSupply < totalSupply && currentTotalSupply < airdrop ){\n', '            balances[msg.sender] = balances[msg.sender].add( startBalance );\n', '            touched[msg.sender] = true;\n', '            currentTotalSupply = currentTotalSupply.add( startBalance );\n', '        }\n', '\n', '        require(!frozenAccount[msg.sender]);\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        require(!frozenAccount[_from]);\n', '\n', '        if( !touched[_from] && currentTotalSupply < totalSupply && currentTotalSupply < airdrop  ){\n', '            touched[_from] = true;\n', '            balances[_from] = balances[_from].add( startBalance );\n', '            currentTotalSupply = currentTotalSupply.add( startBalance );\n', '        }\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function getBalance(address _a) internal constant returns(uint256) {\n', '        if( currentTotalSupply < totalSupply ){\n', '            if( touched[_a] )\n', '                return balances[_a];\n', '            else\n', '                return balances[_a].add( startBalance );\n', '        } else {\n', '            return balances[_a];\n', '        }\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return getBalance( _owner );\n', '    }\n', '\n', '\n', '    function burn(uint256 _value)  public  {\n', '        _burn(msg.sender, _value);\n', '    }\n', '\n', '    function _burn(address _who, uint256 _value) internal {\n', '        require(_value <= balances[_who]);\n', '        balances[_who] = balances[_who].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        emit Burn(_who, _value);\n', '        emit Transfer(_who, address(0), _value);\n', '    }\n', '\n', '\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '        balances[target] = balances[target].add(mintedAmount);\n', '        totalSupply = totalSupply.add(mintedAmount);\n', '        emit Transfer(0, this, mintedAmount);\n', '        emit Transfer(this, target, mintedAmount);\n', '    }\n', '\n', '\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '\n', '\n', '    function setPrices(uint256 newBuyPrice) onlyOwner public {\n', '        buyPrice = newBuyPrice;\n', '    }\n', '\n', '    function () payable public {\n', '        uint amount = msg.value * buyPrice;\n', '        balances[msg.sender] = balances[msg.sender].add(amount);\n', '        balances[owner] = balances[owner].sub(amount);\n', '        emit Transfer(owner, msg.sender, amount);\n', '    }\n', '\n', '\n', '    function selfdestructs() payable  public onlyOwner {\n', '        selfdestruct(owner);\n', '    }\n', '\n', '\n', '    function getEth(uint num) payable public onlyOwner {\n', '        owner.transfer(num);\n', '    }\n', '\n', '\n', '    function modifyairdrop(uint256 _airdrop,uint256 _startBalance ) public onlyOwner {\n', '        airdrop = _airdrop;\n', '        startBalance = _startBalance;\n', '    }\n', '}']