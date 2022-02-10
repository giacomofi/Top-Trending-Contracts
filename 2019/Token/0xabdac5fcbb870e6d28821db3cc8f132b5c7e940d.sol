['pragma solidity ^0.5.4;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    uint256 totalSupply_;\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', 'contract BurnableToken is BasicToken {\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    function burn(uint256 _value) public {\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply_ = totalSupply_.sub(_value);\n', '        emit Burn(burner, _value);\n', '    }\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '       \n', '        \n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    address public distributionContract;\n', '\n', '    bool distributionContractAdded;\n', '    bool public paused = false;\n', '\n', '    function addDistributionContract(address _contract) external {\n', '        require(_contract != address(0));\n', '        require(distributionContractAdded == false);\n', '\n', '        distributionContract = _contract;\n', '        distributionContractAdded = true;\n', '    }\n', '\n', '    modifier whenNotPaused() {\n', '        if(msg.sender != distributionContract) {\n', '            require(!paused);\n', '        }\n', '        _;\n', '    }\n', '\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '}\n', '\n', 'contract PausableToken is StandardToken, Pausable {\n', '\n', '    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.approve(_spender, _value);\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {\n', '        return super.increaseApproval(_spender, _addedValue);\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {\n', '        return super.decreaseApproval(_spender, _subtractedValue);\n', '    }\n', '}\n', '\n', 'contract FreezableToken is StandardToken, Ownable {\n', '    mapping (address => bool) public frozenAccounts;\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    function freezeAccount(address target) public onlyOwner {\n', '        frozenAccounts[target] = true;\n', '        emit FrozenFunds(target, true);\n', '    }\n', '\n', '    function unFreezeAccount(address target) public onlyOwner {\n', '        frozenAccounts[target] = false;\n', '        emit FrozenFunds(target, false);\n', '    }\n', '\n', '    function frozen(address _target) view public returns (bool){\n', '        return frozenAccounts[_target];\n', '    }\n', '\n', '    modifier canTransfer(address _sender) {\n', '        require(!frozenAccounts[_sender]);\n', '        _;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public canTransfer(msg.sender) returns (bool success) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public canTransfer(_from) returns (bool success) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '}\n', '\n', 'contract TimeLockToken is StandardToken, Ownable {\n', '    mapping (address => uint) public timelockAccounts;\n', '    event TimeLockFunds(address target, uint releasetime);\n', '\n', '    function timelockAccount(address target, uint releasetime) public onlyOwner {\n', '        uint r_time;\n', '        r_time = now + (releasetime * 1 days);\n', '        timelockAccounts[target] = r_time;\n', '        emit TimeLockFunds(target, r_time);\n', '    }\n', '\n', '    function timeunlockAccount(address target) public onlyOwner {\n', '        timelockAccounts[target] = now;\n', '        emit TimeLockFunds(target, now);\n', '    }\n', '\n', '    function releasetime(address _target) view public returns (uint){\n', '        return timelockAccounts[_target];\n', '    }\n', '\n', '    modifier ReleaseTimeTransfer(address _sender) {\n', '        require(now >= timelockAccounts[_sender]);\n', '        _;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public ReleaseTimeTransfer(msg.sender) returns (bool success) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public ReleaseTimeTransfer(_from) returns (bool success) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '}\n', '\n', 'contract TTON is TimeLockToken, FreezableToken, PausableToken, BurnableToken {\n', '    string public constant name = "TTON";\n', '    string public constant symbol = "TTON";\n', '    uint public constant decimals = 18;\n', '\n', '    uint public constant INITIAL_SUPPLY = 1000000000 * (10 ** decimals);\n', '\n', '    constructor() public {\n', '        totalSupply_ = INITIAL_SUPPLY;\n', '        balances[msg.sender] = totalSupply_;\n', '        emit Transfer(address(0), msg.sender, totalSupply_);\n', '    }\n', '}']