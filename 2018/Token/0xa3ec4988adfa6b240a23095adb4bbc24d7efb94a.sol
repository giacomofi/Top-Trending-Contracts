['/*! depo.sol | (c) 2018 Develop by BelovITLab LLC (smartcontract.ru), author @stupidlovejoy | License: MIT */\n', '\n', 'pragma solidity 0.4.24;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns(uint256 c) {\n', '        if(a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        return a / b;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns(uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipRenounced(address indexed previousOwner);\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    modifier onlyOwner() { require(msg.sender == owner); _;  }\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function _transferOwnership(address _newOwner) internal {\n', '        require(_newOwner != address(0));\n', '        emit OwnershipTransferred(owner, _newOwner);\n', '        owner = _newOwner;\n', '    }\n', '\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipRenounced(owner);\n', '        owner = address(0);\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        _transferOwnership(_newOwner);\n', '    }\n', '}\n', '\n', 'contract ERC20 {\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    function totalSupply() public view returns(uint256);\n', '    function balanceOf(address who) public view returns(uint256);\n', '    function transfer(address to, uint256 value) public returns(bool);\n', '    function transferFrom(address from, address to, uint256 value) public returns(bool);\n', '    function allowance(address owner, address spender) public view returns(uint256);\n', '    function approve(address spender, uint256 value) public returns(bool);\n', '}\n', '\n', 'contract StandardToken is ERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    uint256 totalSupply_;\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) internal allowed;\n', '\n', '    constructor(string _name, string _symbol, uint8 _decimals) public {\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '    }\n', '\n', '    function totalSupply() public view returns(uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns(uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns(bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        \n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {\n', '        require(_to.length == _value.length);\n', '\n', '        for(uint i = 0; i < _to.length; i++) {\n', '            transfer(_to[i], _value[i]);\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns(uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns(bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public returns(bool) {\n', '        allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));\n', '\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '\n', '        if(_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        }\n', '        else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '    bool public mintingFinished = false;\n', '\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '\n', '    modifier canMint() { require(!mintingFinished); _; }\n', '    modifier hasMintPermission() { require(msg.sender == owner); _; }\n', '\n', '    function mint(address _to, uint256 _amount) hasMintPermission canMint public returns(bool) {\n', '        totalSupply_ = totalSupply_.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '\n', '        emit Mint(_to, _amount);\n', '        emit Transfer(address(0), _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    function finishMinting() onlyOwner canMint public returns(bool) {\n', '        mintingFinished = true;\n', '\n', '        emit MintFinished();\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract CappedToken is MintableToken {\n', '    uint256 public cap;\n', '\n', '    constructor(uint256 _cap) public {\n', '        require(_cap > 0);\n', '        cap = _cap;\n', '    }\n', '\n', '    function mint(address _to, uint256 _amount) public returns(bool) {\n', '        require(totalSupply_.add(_amount) <= cap);\n', '\n', '        return super.mint(_to, _amount);\n', '    }\n', '}\n', '\n', 'contract BurnableToken is StandardToken {\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    function _burn(address _who, uint256 _value) internal {\n', '        require(_value <= balances[_who]);\n', '\n', '        balances[_who] = balances[_who].sub(_value);\n', '        totalSupply_ = totalSupply_.sub(_value);\n', '\n', '        emit Burn(_who, _value);\n', '        emit Transfer(_who, address(0), _value);\n', '    }\n', '\n', '    function burn(uint256 _value) public {\n', '        _burn(msg.sender, _value);\n', '    }\n', '\n', '    function burnFrom(address _from, uint256 _value) public {\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        \n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        _burn(_from, _value);\n', '    }\n', '}\n', '\n', 'contract Withdrawable is Ownable {\n', '    function withdrawEther(address _to, uint _value) onlyOwner public {\n', '        require(_to != address(0));\n', '        require(address(this).balance >= _value);\n', '\n', '        _to.transfer(_value);\n', '    }\n', '\n', '    function withdrawTokensTransfer(ERC20 _token, address _to, uint256 _value) onlyOwner public {\n', '        require(_token.transfer(_to, _value));\n', '    }\n', '\n', '    function withdrawTokensTransferFrom(ERC20 _token, address _from, address _to, uint256 _value) onlyOwner public {\n', '        require(_token.transferFrom(_from, _to, _value));\n', '    }\n', '\n', '    function withdrawTokensApprove(ERC20 _token, address _spender, uint256 _value) onlyOwner public {\n', '        require(_token.approve(_spender, _value));\n', '    }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '    bool public paused = false;\n', '\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    modifier whenNotPaused() { require(!paused); _; }\n', '    modifier whenPaused() { require(paused); _; }\n', '\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '}\n', '\n', 'contract Manageable is Ownable {\n', '    address[] public managers;\n', '\n', '    event ManagerAdded(address indexed manager);\n', '    event ManagerRemoved(address indexed manager);\n', '\n', '    modifier onlyManager() { require(isManager(msg.sender)); _; }\n', '\n', '    function countManagers() view public returns(uint) {\n', '        return managers.length;\n', '    }\n', '\n', '    function getManagers() view public returns(address[]) {\n', '        return managers;\n', '    }\n', '\n', '    function isManager(address _manager) view public returns(bool) {\n', '        for(uint i = 0; i < managers.length; i++) {\n', '            if(managers[i] == _manager) {\n', '                return true;\n', '            }\n', '        }\n', '        return false;\n', '    }\n', '\n', '    function addManager(address _manager) onlyOwner public {\n', '        require(_manager != address(0));\n', '        require(!isManager(_manager));\n', '\n', '        managers.push(_manager);\n', '\n', '        emit ManagerAdded(_manager);\n', '    }\n', '\n', '    function removeManager(address _manager) onlyOwner public {\n', '        require(isManager(_manager));\n', '\n', '        uint index = 0;\n', '        for(uint i = 0; i < managers.length; i++) {\n', '            if(managers[i] == _manager) {\n', '                index = i;\n', '            }\n', '        }\n', '\n', '        for(; index < managers.length - 1; index++) {\n', '            managers[index] = managers[index + 1];\n', '        }\n', '        \n', '        managers.length--;\n', '        emit ManagerRemoved(_manager);\n', '    }\n', '}\n', '\n', '\n', 'contract Token is CappedToken, BurnableToken, Withdrawable {\n', '    constructor() CappedToken(1000000 * 1e8) StandardToken("DEPO", "DEPO", 8) public {\n', '    }\n', '}\n', '\n', 'contract Crowdsale is Manageable, Withdrawable, Pausable {\n', '    using SafeMath for uint;\n', '\n', '    Token public token;\n', '    bool public crowdsaleClosed = false;\n', '\n', '    event ExternalPurchase(address indexed holder, string tx, string currency, uint256 currencyAmount, uint256 rateToEther, uint256 tokenAmount);\n', '    event CrowdsaleClose();\n', '   \n', '    constructor() public {\n', '        token = new Token();\n', '    }\n', '\n', '    function externalPurchase(address _to, string _tx, string _currency, uint _value, uint256 _rate, uint256 _tokens) whenNotPaused onlyManager public {\n', '        token.mint(_to, _tokens);\n', '        emit ExternalPurchase(_to, _tx, _currency, _value, _rate, _tokens);\n', '    }\n', '\n', '    function closeCrowdsale(address _to) onlyOwner public {\n', '        require(!crowdsaleClosed);\n', '\n', '        token.transferOwnership(_to);\n', '        crowdsaleClosed = true;\n', '\n', '        emit CrowdsaleClose();\n', '    }\n', '}']