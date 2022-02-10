['pragma solidity ^0.4.25;\n', '\n', 'library SafeMath {\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', ' \n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', ' \n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '}\n', '\n', 'contract Ownable {\n', '\n', '    address public zbtceo;\n', '    address public zbtcfo;\n', '    address public zbtadmin;\n', '       \n', '    event CEOshipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    event CFOshipTransferred(address indexed previousCFO, address indexed newCFO);\n', '    event ZBTAdminshipTransferred(address indexed previousZBTAdmin, address indexed newZBTAdmin);\n', '\n', '    constructor () public {\n', '        zbtceo = msg.sender;\n', '        zbtcfo = msg.sender;\n', '        zbtadmin = msg.sender;\n', '    }\n', '\n', '    modifier onlyCEO() {\n', '        require(msg.sender == zbtceo);\n', '        _;\n', '    }\n', '  \n', '    modifier onlyCFO() {\n', '        require(msg.sender == zbtcfo);\n', '        _;\n', '    }\n', '\n', '    modifier onlyZBTAdmin() {\n', '        require(msg.sender == zbtadmin);\n', '        _;\n', '    }\n', '\n', '    modifier onlyCLevel() {\n', '        require(\n', '            msg.sender == zbtceo ||\n', '            msg.sender == zbtcfo ||\n', '            msg.sender == zbtadmin\n', '        );\n', '        _;\n', '    }    \n', '\n', '    function transferCEOship(address _newCEO) public onlyCEO {\n', '      \n', '        require(_newCEO != address(0));        \n', '        emit CEOshipTransferred(zbtceo, _newCEO);       \n', '        zbtceo = _newCEO;               \n', '    }\n', '\n', '    function transferCFOship(address _newcfo) public onlyCEO {\n', '        require(_newcfo != address(0));\n', '        \n', '        emit CFOshipTransferred(zbtcfo, _newcfo);        \n', '        zbtcfo = _newcfo;             \n', '    }\n', '   \n', '    function transferZBTAdminship(address _newzbtadmin) public onlyCEO {\n', '        require(_newzbtadmin != address(0));        \n', '        emit ZBTAdminshipTransferred(zbtadmin, _newzbtadmin);        \n', '        zbtadmin = _newzbtadmin;              \n', '    }     \n', '}\n', '\n', ' \n', 'contract Pausable is Ownable {\n', '\n', '    event EventPause();\n', '    event EventUnpause();\n', '\n', '    bool public paused = false;\n', '\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    function setPause() onlyCEO whenNotPaused public {\n', '        paused = true;\n', '        emit EventPause();\n', '    }\n', '\n', '    function setUnpause() onlyCEO whenPaused public {\n', '        paused = false;\n', '        emit EventUnpause();\n', '    }\n', '}\n', '\n', '\n', 'contract ERC20Basic {\n', '\n', '    uint256 public totalSupply;\n', '    \n', '  \n', '    function balanceOf(address who) public view returns (uint256);\n', '    \n', '\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    \n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    \n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    \n', '\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    \n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) public balances;\n', '\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', '//datacontrolcontract\n', 'contract StandardToken is ERC20, BasicToken,Ownable {\n', '    \n', '\n', '    mapping (address => bool) public frozenAccount;\n', '    mapping (address => mapping (address =>uint256)) internal allowed;\n', '\n', '\n', '    /* This notifies clients about the amount burnt */\n', '    event BurnTokens(address indexed from, uint256 value);\n', '\t\n', '   /* This generates a public event on the blockchain that will notify clients */\n', '    event FrozenFunds(address target, bool frozen);\n', '    \n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '    \n', '        require(_to != address(0));\n', '        require(!frozenAccount[msg.sender]);           // Check if sender is frozen\n', '        require(!frozenAccount[_to]);              // Check if recipient is frozen\n', '        require(_value <= balances[msg.sender]);\n', '\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        \n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    \t  }\n', '\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != address(0));\n', '        \n', '        require(!frozenAccount[_from]);           // Check if sender is frozen\n', '        require(!frozenAccount[_to]);              // Check if recipient is frozen\n', '        require(_value <= balances[_from]);\n', '                      \n', '     if( allowed[msg.sender][_from]>0) { \n', '     require(allowed[msg.sender][_from] >= _value);\n', '     \n', '        allowed[msg.sender][_from] = allowed[msg.sender][_from].sub(_value);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        emit Transfer(_from, _to, _value);\n', '        \n', '        return true;\n', '     }\n', '     else {            \n', '         allowed[msg.sender][_from] = 0;\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        emit Transfer(_from, _to, _value);\n', '        \n', '        return true;\n', '     }\n', '\n', '    }\n', '\n', '\n', '\tfunction batchTransfer(address[] _receivers, uint256 _value) public  returns (bool) {\n', '\t\t\n', '\t\t    uint256 cnt = _receivers.length;\n', '\t\t    \n', '\t\t    uint256 amount = _value.mul(cnt); \n', '\t\t    \n', '\t\t    require(cnt > 0 && cnt <= 20);\n', '\t\t    \n', '\t\t    require(_value > 0 && balances[msg.sender] >= amount);\n', '\n', '\t\t    balances[msg.sender] = balances[msg.sender].sub(amount);\n', '\t\t    \n', '\t\t    for (uint256 i = 0; i < cnt; i++) {\n', '\t\t        balances[_receivers[i]] = balances[_receivers[i]].add(_value);\n', '\t\t        emit Transfer(msg.sender, _receivers[i], _value);\n', '\t\t    }\n', '\t\t    \n', '\t\t    return true;\n', '\t\t  }\n', ' \n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '    \n', '        allowed[msg.sender][_spender] = _value;\n', '        \n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function getAccountFreezedInfo(address _owner) public view returns (bool) {\n', '        return frozenAccount[_owner];\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        \n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {\n', '        uint256 oldValue = allowed[msg.sender][_spender];\n', '        \n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        \n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '  function burnTokens(uint256 _burnValue)  public onlyCEO returns (bool success) {\n', '       // Check if the sender has enough\n', '\t    require(balances[msg.sender] >= _burnValue);\n', '        // Subtract from the sender\n', '        balances[msg.sender] = balances[msg.sender].sub(_burnValue);              \n', '        // Updates totalSupply\n', '        totalSupply = totalSupply.sub(_burnValue);                              \n', '        \n', '        emit BurnTokens(msg.sender, _burnValue);\n', '        return true;\n', '    }\n', '\n', '    function burnTokensFrom(address _from, uint256 _value) public onlyCLevel returns (bool success) {\n', '        \n', '        require(balances[_from] >= _value);                // Check if the targeted balance is enough\n', '       \n', '        require(_from != msg.sender);   \n', '                \n', '        balances[_from] = balances[_from].sub(_value);     // Subtract from the targeted balance\n', '       \n', '        totalSupply =totalSupply.sub(_value) ;             // Update totalSupply\n', '        \n', '        emit BurnTokens(_from, _value);\n', '        return true;\n', '        }\n', '  \n', '    function freezeAccount(address _target, bool _freeze) public onlyCLevel returns (bool success) {\n', '        \n', '        require(_target != msg.sender);\n', '        \n', '        frozenAccount[_target] = _freeze;\n', '        emit FrozenFunds(_target, _freeze);\n', '        return _freeze;\n', '        }\n', '}\n', '\n', 'contract PausableToken is StandardToken, Pausable {\n', '\n', '    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function  batchTransfer(address[] _receivers, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.batchTransfer(_receivers, _value);\n', '    }\n', '\n', '\n', '    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.approve(_spender, _value);\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint256 _addedValue) public whenNotPaused returns (bool success) {\n', '        return super.increaseApproval(_spender, _addedValue);\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint256 _subtractedValue) public whenNotPaused returns (bool success) {\n', '        return super.decreaseApproval(_spender, _subtractedValue);\n', '    }\n', '    \n', '    \n', '  function burnTokens( uint256 _burnValue) public whenNotPaused returns (bool success) {\n', '        return super.burnTokens(_burnValue);\n', '    }\n', '    \n', '  function burnTokensFrom(address _from, uint256 _burnValue) public whenNotPaused returns (bool success) {\n', '        return super.burnTokensFrom( _from,_burnValue);\n', '    }    \n', '    \n', '  function freezeAccount(address _target, bool _freeze)  public whenNotPaused returns (bool success) {\n', '        return super.freezeAccount(_target,_freeze);\n', '    }\n', '    \n', '       \n', '}\n', '\n', 'contract CustomToken is PausableToken {\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals ;\n', '    uint256 public totalSupply;\n', '    \n', '    // Constants\n', '    string  public constant tokenName = "ZBT.COM Token";\n', '    string  public constant tokenSymbol = "ZBT";\n', '    uint8   public constant tokenDecimals = 6;\n', '    \n', '    uint256 public constant initTokenSUPPLY      = 5000000000 * (10 ** uint256(tokenDecimals));\n', '             \n', '                                        \n', '    constructor () public {\n', '\n', '        name = tokenName;\n', '\n', '        symbol = tokenSymbol;\n', '\n', '        decimals = tokenDecimals;\n', '\n', '        totalSupply = initTokenSUPPLY;    \n', '                \n', '        balances[msg.sender] = totalSupply;   \n', '\n', '    }    \n', '\n', '}']