['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-28\n', '*/\n', '\n', 'pragma solidity 0.4.25;\n', '\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address  to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address  to, uint256 value) public returns (bool);\n', '    function approve(address  spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract DetailedERC20 is ERC20 {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    \n', '    constructor(string _name, string _symbol, uint8 _decimals) public {\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '    }\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    mapping(address => uint256)  balances;\n', '    uint256  _totalSupply;\n', '    \n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0) && _value != 0 &&_value <= balances[msg.sender],"Please check the amount of transmission error and the amount you send.");\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        \n', '        return true;\n', '    }\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '}\n', '\n', 'contract ERC20Token is BasicToken, ERC20 {\n', '    using SafeMath for uint256;\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    mapping (address => mapping (address => uint256))  allowed;\n', '    mapping (address => uint256) public freezeOf;\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        \n', '        require(_value == 0 || allowed[msg.sender][_spender] == 0,"Please check the amount you want to approve.");\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '    function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '    \n', '    function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) {\n', '        uint256 oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue >= oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    mapping (address => bool) public admin;\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    \n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner,"I am not the owner of the wallet.");\n', '        _;\n', '    }\n', '    modifier onlyOwnerOrAdmin() {\n', '        require(msg.sender == owner || admin[msg.sender] == true,"It is not the owner or manager wallet address.");\n', '        _;\n', '    }\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        require(newOwner != address(0) && newOwner != owner && admin[newOwner] == true,"It must be the existing manager wallet, not the existing owner\'s wallet.");\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '    function setAdmin(address newAdmin) onlyOwner public {\n', '        require(admin[newAdmin] != true && owner != newAdmin,"It is not an existing administrator wallet, and it must not be the owner wallet of the token.");\n', '        admin[newAdmin] = true;\n', '    }\n', '    function unsetAdmin(address Admin) onlyOwner public {\n', '        require(admin[Admin] != false && owner != Admin,"This is an existing admin wallet, it must not be a token holder wallet.");\n', '        admin[Admin] = false;\n', '    }\n', '\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '    event Pause();\n', '    event Unpause();\n', '    bool public paused = false;\n', '    \n', '    modifier whenNotPaused() {\n', '        require(!paused,"There is a pause.");\n', '        _;\n', '    }\n', '    modifier whenPaused() {\n', '        require(paused,"It is not paused.");\n', '        _;\n', '    }\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '\n', '}\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {return 0; }\t\n', '        uint256 c = a * b;\n', '        require(c / a == b,"An error occurred in the calculation process");\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b !=0,"The number you want to divide must be non-zero.");\n', '        uint256 c = a / b;\n', '        require(c * b == a,"An error occurred in the calculation process");\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a,"There are more to deduct.");\n', '        return a - b;\n', '    }\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a,"The number did not increase.");\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract BurnableToken is BasicToken, Ownable {\n', '    \n', '    event Burn(address indexed burner, uint256 amount);\n', '\n', '    function burn(uint256 _value) onlyOwner public {\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        _totalSupply = _totalSupply.sub(_value);\n', '        emit Burn(msg.sender, _value);\n', '        emit Transfer(msg.sender, address(0), _value);\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', 'contract FreezeToken is BasicToken, Ownable {\n', '    \n', '    event Freezen(address indexed freezer, uint256 amount);\n', '    event UnFreezen(address indexed freezer, uint256 amount);\n', '    mapping (address => uint256) freezeOf;\n', '    \n', '    function freeze(uint256 _value) onlyOwner public {\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        freezeOf[msg.sender] = freezeOf[msg.sender].add(_value);\n', '        _totalSupply = _totalSupply.sub(_value);\n', '        emit Freezen(msg.sender, _value);\n', '    }\n', '    function unfreeze(uint256 _value) onlyOwner public {\n', '        require(freezeOf[msg.sender] >= _value,"The number to be processed is more than the total amount and the number currently frozen.");\n', '        balances[msg.sender] = balances[msg.sender].add(_value);\n', '        freezeOf[msg.sender] = freezeOf[msg.sender].sub(_value);\n', '        _totalSupply = _totalSupply.add(_value);\n', '        emit Freezen(msg.sender, _value);\n', '    }\n', '}\n', '\n', '\n', 'contract KoreaBlackHole is BurnableToken,FreezeToken, DetailedERC20, ERC20Token,Pausable{\n', '    using SafeMath for uint256;\n', '    \n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event LockerChanged(address indexed owner, uint256 amount);\n', '    mapping(address => uint) locker;\n', '    \n', '    string  private _symbol = "KBH";\n', '    string  private _name = "Korea Blackhole";\n', '    uint8  private _decimals = 18;\n', '    uint256 private TOTAL_SUPPLY = 40*(10**8)*(10**uint256(_decimals));\n', '    \n', '    constructor() DetailedERC20(_name, _symbol, _decimals) public {\n', '        _totalSupply = TOTAL_SUPPLY;\n', '        balances[owner] = _totalSupply;\n', '        emit Transfer(address(0x0), msg.sender, _totalSupply);\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _value)  public whenNotPaused returns (bool){\n', '        require(balances[msg.sender].sub(_value) >= locker[msg.sender],"Attempting to send more than the locked number");\n', '        return super.transfer(_to, _value);\n', '    }\n', '    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool){\n', '    \n', '        require(_to > address(0) && _from > address(0),"Please check the address" );\n', '        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value,"Please check the amount of transmission error and the amount you send.");\n', '        require(balances[_from].sub(_value) >= locker[_from],"Attempting to send more than the locked number" );\n', '        \n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        \n', '        emit Transfer(_from, _to, _value);\n', '        \n', '        return true;\n', '    }\n', '    function lockOf(address _address) public view returns (uint256 _locker) {\n', '        return locker[_address];\n', '    }\n', '    function setLock(address _address, uint256 _value) public onlyOwnerOrAdmin {\n', '        require(_value <= _totalSupply &&_address != address(0),"It is the first wallet or attempted to lock an amount greater than the total holding.");\n', '        locker[_address] = _value;\n', '        emit LockerChanged(_address, _value);\n', '    }\n', '    function setLockList(address[] _recipients, uint256[] _balances) public onlyOwnerOrAdmin{\n', '        require(_recipients.length == _balances.length,"The number of wallet arrangements and the number of amounts are different.");\n', '        \n', '        for (uint i=0; i < _recipients.length; i++) {\n', "            require(_recipients[i] != address(0),'Please check the address');\n", '            \n', '            locker[_recipients[i]] = _balances[i];\n', '            emit LockerChanged(_recipients[i], _balances[i]);\n', '        }\n', '    }\n', '    function transferList(address[] _recipients, uint256[] _balances) public onlyOwnerOrAdmin{\n', '        require(_recipients.length == _balances.length,"The number of wallet arrangements and the number of amounts are different.");\n', '        \n', '        for (uint i=0; i < _recipients.length; i++) {\n', '            balances[msg.sender] = balances[msg.sender].sub(_balances[i]);\n', '            balances[_recipients[i]] = balances[_recipients[i]].add(_balances[i]);\n', '            emit Transfer(msg.sender,_recipients[i],_balances[i]);\n', '        }\n', '    }\n', '    function() public payable {\n', '        revert();\n', '    }\n', '}']