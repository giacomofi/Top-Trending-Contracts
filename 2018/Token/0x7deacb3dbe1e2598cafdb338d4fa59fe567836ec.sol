['pragma solidity 0.4.18;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        if(a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    modifier onlyOwner() { require(msg.sender == owner); _; }\n', '\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        owner = newOwner;\n', '        OwnershipTransferred(owner, newOwner);\n', '    }\n', '}\n', '\n', 'contract Manageable is Ownable {\n', '    address[] public managers;\n', '\n', '    event ManagerAdded(address indexed manager);\n', '    event ManagerRemoved(address indexed manager);\n', '\n', '    modifier onlyManager() { require(isManager(msg.sender)); _; }\n', '\n', '    function countManagers() view public returns(uint) {\n', '        return managers.length;\n', '    }\n', '\n', '    function getManagers() view public returns(address[]) {\n', '        return managers;\n', '    }\n', '\n', '    function isManager(address _manager) view public returns(bool) {\n', '        for(uint i = 0; i < managers.length; i++) {\n', '            if(managers[i] == _manager) {\n', '                return true;\n', '            }\n', '        }\n', '        return false;\n', '    }\n', '\n', '    function addManager(address _manager) onlyOwner public {\n', '        require(_manager != address(0));\n', '        require(!isManager(_manager));\n', '\n', '        managers.push(_manager);\n', '\n', '        ManagerAdded(_manager);\n', '    }\n', '\n', '    function removeManager(address _manager) onlyOwner public {\n', '        require(isManager(_manager));\n', '\n', '        uint index = 0;\n', '        for(uint i = 0; i < managers.length; i++) {\n', '            if(managers[i] == _manager) {\n', '                index = i;\n', '            }\n', '        }\n', '\n', '        for(; index < managers.length - 1; index++) {\n', '            managers[index] = managers[index + 1];\n', '        }\n', '        \n', '        managers.length--;\n', '        ManagerRemoved(_manager);\n', '    }\n', '}\n', '\n', '\n', 'contract Withdrawable is Ownable {\n', '    function withdrawEther(address _to, uint _value) onlyOwner public returns(bool) {\n', '        require(_to != address(0));\n', '        require(this.balance >= _value);\n', '\n', '        _to.transfer(_value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function withdrawTokens(ERC20 _token, address _to, uint _value) onlyOwner public returns(bool) {\n', '        require(_to != address(0));\n', '\n', '        return _token.transfer(_to, _value);\n', '    }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '    bool public paused = false;\n', '\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    modifier whenNotPaused() { require(!paused); _; }\n', '    modifier whenPaused() { require(paused); _; }\n', '\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        Pause();\n', '    }\n', '\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        Unpause();\n', '    }\n', '}\n', '\n', 'contract ERC20 {\n', '    uint256 public totalSupply;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    function balanceOf(address who) public view returns(uint256);\n', '    function transfer(address to, uint256 value) public returns(bool);\n', '    function transferFrom(address from, address to, uint256 value) public returns(bool);\n', '    function allowance(address owner, address spender) public view returns(uint256);\n', '    function approve(address spender, uint256 value) public returns(bool);\n', '}\n', '\n', 'contract StandardToken is ERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    function StandardToken(string _name, string _symbol, uint8 _decimals) public {\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns(uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns(bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        Transfer(msg.sender, _to, _value);\n', '\n', '        return true;\n', '    }\n', '    \n', '    function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {\n', '        require(_to.length == _value.length);\n', '\n', '        for(uint i = 0; i < _to.length; i++) {\n', '            transfer(_to[i], _value[i]);\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '\n', '        Transfer(_from, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns(uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns(bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        Approval(msg.sender, _spender, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public returns(bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '\n', '        if(_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '\n', '    bool public mintingFinished = false;\n', '\n', '    modifier canMint() { require(!mintingFinished); _; }\n', '\n', '    function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {\n', '        totalSupply = totalSupply.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '\n', '        Mint(_to, _amount);\n', '        Transfer(address(0), _to, _amount);\n', '\n', '        return true;\n', '    }\n', '\n', '    function finishMinting() onlyOwner canMint public returns(bool) {\n', '        mintingFinished = true;\n', '\n', '        MintFinished();\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract BurnableToken is StandardToken {\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    function burn(uint256 _value) public {\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        address burner = msg.sender;\n', '\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '\n', '        Burn(burner, _value);\n', '    }\n', '}\n', '\n', '\n', 'contract Token is MintableToken, BurnableToken, Withdrawable {\n', '    function Token() StandardToken("ADGEX Limited", "AGE", 8) public {\n', '        \n', '    }\n', '}\n', '\n', 'contract Crowdsale is Manageable, Withdrawable, Pausable {\n', '    using SafeMath for uint;\n', '\n', '    Token public token;\n', '    bool public crowdsaleClosed = false;\n', '\n', '    event ExternalPurchase(address indexed holder, string tx, string currency, uint256 currencyAmount, uint256 rateToEther, uint256 tokenAmount);\n', '    event CrowdsaleClose();\n', '   \n', '    function Crowdsale() public {\n', '        token = Token(0xcd0f39E201bfAf9Fc30F62f77C7E9AfdcE9D4D42);\n', '\n', '        addManager(0xB25297425110dAeeF6f67A76b5Afa393E0e1ffB3);\n', '    }\n', '\n', '    function externalPurchase(address _to, string _tx, string _currency, uint _value, uint256 _rate, uint256 _tokens) whenNotPaused onlyManager public {\n', '        token.mint(_to, _tokens);\n', '        ExternalPurchase(_to, _tx, _currency, _value, _rate, _tokens);\n', '    }\n', '\n', '    function closeCrowdsale(address _to) onlyOwner public {\n', '        require(!crowdsaleClosed);\n', '\n', '        token.transferOwnership(_to);\n', '\n', '        crowdsaleClosed = true;\n', '\n', '        CrowdsaleClose();\n', '    }\n', '}']
['pragma solidity 0.4.18;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        if(a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    modifier onlyOwner() { require(msg.sender == owner); _; }\n', '\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        owner = newOwner;\n', '        OwnershipTransferred(owner, newOwner);\n', '    }\n', '}\n', '\n', 'contract Manageable is Ownable {\n', '    address[] public managers;\n', '\n', '    event ManagerAdded(address indexed manager);\n', '    event ManagerRemoved(address indexed manager);\n', '\n', '    modifier onlyManager() { require(isManager(msg.sender)); _; }\n', '\n', '    function countManagers() view public returns(uint) {\n', '        return managers.length;\n', '    }\n', '\n', '    function getManagers() view public returns(address[]) {\n', '        return managers;\n', '    }\n', '\n', '    function isManager(address _manager) view public returns(bool) {\n', '        for(uint i = 0; i < managers.length; i++) {\n', '            if(managers[i] == _manager) {\n', '                return true;\n', '            }\n', '        }\n', '        return false;\n', '    }\n', '\n', '    function addManager(address _manager) onlyOwner public {\n', '        require(_manager != address(0));\n', '        require(!isManager(_manager));\n', '\n', '        managers.push(_manager);\n', '\n', '        ManagerAdded(_manager);\n', '    }\n', '\n', '    function removeManager(address _manager) onlyOwner public {\n', '        require(isManager(_manager));\n', '\n', '        uint index = 0;\n', '        for(uint i = 0; i < managers.length; i++) {\n', '            if(managers[i] == _manager) {\n', '                index = i;\n', '            }\n', '        }\n', '\n', '        for(; index < managers.length - 1; index++) {\n', '            managers[index] = managers[index + 1];\n', '        }\n', '        \n', '        managers.length--;\n', '        ManagerRemoved(_manager);\n', '    }\n', '}\n', '\n', '\n', 'contract Withdrawable is Ownable {\n', '    function withdrawEther(address _to, uint _value) onlyOwner public returns(bool) {\n', '        require(_to != address(0));\n', '        require(this.balance >= _value);\n', '\n', '        _to.transfer(_value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function withdrawTokens(ERC20 _token, address _to, uint _value) onlyOwner public returns(bool) {\n', '        require(_to != address(0));\n', '\n', '        return _token.transfer(_to, _value);\n', '    }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '    bool public paused = false;\n', '\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    modifier whenNotPaused() { require(!paused); _; }\n', '    modifier whenPaused() { require(paused); _; }\n', '\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        Pause();\n', '    }\n', '\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        Unpause();\n', '    }\n', '}\n', '\n', 'contract ERC20 {\n', '    uint256 public totalSupply;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    function balanceOf(address who) public view returns(uint256);\n', '    function transfer(address to, uint256 value) public returns(bool);\n', '    function transferFrom(address from, address to, uint256 value) public returns(bool);\n', '    function allowance(address owner, address spender) public view returns(uint256);\n', '    function approve(address spender, uint256 value) public returns(bool);\n', '}\n', '\n', 'contract StandardToken is ERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    function StandardToken(string _name, string _symbol, uint8 _decimals) public {\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns(uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns(bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        Transfer(msg.sender, _to, _value);\n', '\n', '        return true;\n', '    }\n', '    \n', '    function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {\n', '        require(_to.length == _value.length);\n', '\n', '        for(uint i = 0; i < _to.length; i++) {\n', '            transfer(_to[i], _value[i]);\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '\n', '        Transfer(_from, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns(uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns(bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        Approval(msg.sender, _spender, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public returns(bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '\n', '        if(_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '\n', '    bool public mintingFinished = false;\n', '\n', '    modifier canMint() { require(!mintingFinished); _; }\n', '\n', '    function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {\n', '        totalSupply = totalSupply.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '\n', '        Mint(_to, _amount);\n', '        Transfer(address(0), _to, _amount);\n', '\n', '        return true;\n', '    }\n', '\n', '    function finishMinting() onlyOwner canMint public returns(bool) {\n', '        mintingFinished = true;\n', '\n', '        MintFinished();\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract BurnableToken is StandardToken {\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    function burn(uint256 _value) public {\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        address burner = msg.sender;\n', '\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '\n', '        Burn(burner, _value);\n', '    }\n', '}\n', '\n', '\n', 'contract Token is MintableToken, BurnableToken, Withdrawable {\n', '    function Token() StandardToken("ADGEX Limited", "AGE", 8) public {\n', '        \n', '    }\n', '}\n', '\n', 'contract Crowdsale is Manageable, Withdrawable, Pausable {\n', '    using SafeMath for uint;\n', '\n', '    Token public token;\n', '    bool public crowdsaleClosed = false;\n', '\n', '    event ExternalPurchase(address indexed holder, string tx, string currency, uint256 currencyAmount, uint256 rateToEther, uint256 tokenAmount);\n', '    event CrowdsaleClose();\n', '   \n', '    function Crowdsale() public {\n', '        token = Token(0xcd0f39E201bfAf9Fc30F62f77C7E9AfdcE9D4D42);\n', '\n', '        addManager(0xB25297425110dAeeF6f67A76b5Afa393E0e1ffB3);\n', '    }\n', '\n', '    function externalPurchase(address _to, string _tx, string _currency, uint _value, uint256 _rate, uint256 _tokens) whenNotPaused onlyManager public {\n', '        token.mint(_to, _tokens);\n', '        ExternalPurchase(_to, _tx, _currency, _value, _rate, _tokens);\n', '    }\n', '\n', '    function closeCrowdsale(address _to) onlyOwner public {\n', '        require(!crowdsaleClosed);\n', '\n', '        token.transferOwnership(_to);\n', '\n', '        crowdsaleClosed = true;\n', '\n', '        CrowdsaleClose();\n', '    }\n', '}']
