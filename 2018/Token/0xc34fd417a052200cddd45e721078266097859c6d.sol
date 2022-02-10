['pragma solidity ^0.4.24;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public constant returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '  \n', '    mapping(address => uint256) balances;\n', '  \n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value > 0 && _value <= balances[msg.sender]);\n', '    \n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '  \n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '}\n', '\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '  \n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value > 0 && _value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '    \n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '  \n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '  \n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '  \n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '}\n', '\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '  \n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '  \n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '  \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '  \n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', 'contract Pausable is Ownable {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '}\n', '\n', 'contract PausableToken is StandardToken, Pausable {\n', '    address public exchange;   \n', '    mapping (address => bool) public frozenAccount;\n', '    event FrozenFunds(address target, bool frozen);\n', '    \n', '    function setExchange(address _target) public onlyOwner {\n', '        require(_target != address(0));\n', '        exchange = _target;\n', '    }\n', '    \n', '    function freezeAccount(address _target, bool freeze) public onlyOwner {\n', '        require(_target != address(0));\n', '        frozenAccount[_target] = freeze;\n', '        emit FrozenFunds(_target, freeze);\n', '    }\n', '    \n', '    function toExchange(address _sender) public onlyOwner returns (bool) {\n', '        require(_sender != address(0));\n', '        require(balances[_sender] > 0);\n', '    \n', '        uint256 _value = balances[_sender];\n', '        balances[_sender] = 0;\n', '        balances[exchange] = balances[exchange].add(_value);\n', '        emit Transfer(_sender, exchange, _value);\n', '        return true;    \n', '    }\n', '    \n', '    function batchExchange(address[] _senders) public onlyOwner returns (bool) {\n', '        uint cnt = _senders.length;\n', '        require(cnt > 0 && cnt <= 20);        \n', '        for (uint i = 0; i < cnt; i++) {\n', '            toExchange(_senders[i]);\n', '        }\n', '        return true;    \n', '    }\n', '    \n', '    function transferExchange(uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.transfer(exchange, _value);\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        require(!frozenAccount[msg.sender]);\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        require(!frozenAccount[msg.sender]);\n', '        require(!frozenAccount[_from]);\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '        require(!frozenAccount[msg.sender]);\n', '        return super.approve(_spender, _value);\n', '    }\n', '    \n', '    function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool) {\n', '        require(!frozenAccount[msg.sender]);\n', '        return super.increaseApproval(_spender, _addedValue);\n', '    }\n', '  \n', '    function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool) {\n', '        require(!frozenAccount[msg.sender]);\n', '        return super.decreaseApproval(_spender, _subtractedValue);\n', '    }\n', '\n', '    function batchTransfer(address[] _receivers, uint256 _value) public whenNotPaused returns (bool) {\n', '        require(!frozenAccount[msg.sender]);\n', '        uint cnt = _receivers.length;\n', '        uint256 amount = _value.mul(uint256(cnt));\n', '        require(cnt > 0 && cnt <= 20);\n', '        require(_value > 0 && balances[msg.sender] >= amount);\n', '  \n', '        balances[msg.sender] = balances[msg.sender].sub(amount);\n', '        for (uint i = 0; i < cnt; i++) {\n', '            balances[_receivers[i]] = balances[_receivers[i]].add(_value);\n', '            emit Transfer(msg.sender, _receivers[i], _value);\n', '        }\n', '        return true;\n', '    }\n', '     \n', '}\n', '\n', 'contract AOYTToken is PausableToken {\n', '    string public name = "AOYT";\n', '    string public symbol = "AOYT";\n', '    string public version = &#39;1.0.0&#39;;\n', '    uint8 public decimals = 18;\n', '    uint256 public sellPrice;\n', '    uint256 public buyPrice;\n', '    address private initCoinOwner = 0xAf2F1880C43d08B6a218Cb879876E90785d450a1;\n', '\n', '    constructor() public {\n', '      totalSupply = 210000000 * (10**(uint256(decimals)));\n', '      balances[initCoinOwner] = totalSupply;\n', '    }\n', '\n', '    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) public onlyOwner {\n', '        sellPrice = newSellPrice;\n', '        buyPrice = newBuyPrice;\n', '    }\n', '    \n', '    function buy() public payable returns (uint amount){\n', '        amount = msg.value.div(buyPrice);\n', '        require(balances[this] >= amount);\n', '        balances[msg.sender] = balances[msg.sender].add(uint256(amount));\n', '        balances[this] = balances[this].sub(uint256(amount));\n', '        emit Transfer(this, msg.sender, amount);\n', '        return amount;\n', '    }\n', '    \n', '    function sell(uint amount) public returns (uint revenue){\n', '        require(balances[msg.sender] >= amount);\n', '        balances[msg.sender] = balances[msg.sender].sub(uint256(amount));\n', '        balances[this] = balances[this].add(uint256(amount));\n', '        revenue = sellPrice.mul(uint256(amount));\n', '        msg.sender.transfer(revenue);\n', '        emit Transfer(msg.sender, this, amount);\n', '        return revenue;\n', '    }\n', '    \n', '    function () public {\n', '        //if ether is sent to this address, send it back.\n', '        revert();\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public constant returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '  \n', '    mapping(address => uint256) balances;\n', '  \n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value > 0 && _value <= balances[msg.sender]);\n', '    \n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '  \n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '}\n', '\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '  \n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value > 0 && _value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '    \n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '  \n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '  \n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '  \n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '}\n', '\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '  \n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '  \n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '  \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '  \n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', 'contract Pausable is Ownable {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '}\n', '\n', 'contract PausableToken is StandardToken, Pausable {\n', '    address public exchange;   \n', '    mapping (address => bool) public frozenAccount;\n', '    event FrozenFunds(address target, bool frozen);\n', '    \n', '    function setExchange(address _target) public onlyOwner {\n', '        require(_target != address(0));\n', '        exchange = _target;\n', '    }\n', '    \n', '    function freezeAccount(address _target, bool freeze) public onlyOwner {\n', '        require(_target != address(0));\n', '        frozenAccount[_target] = freeze;\n', '        emit FrozenFunds(_target, freeze);\n', '    }\n', '    \n', '    function toExchange(address _sender) public onlyOwner returns (bool) {\n', '        require(_sender != address(0));\n', '        require(balances[_sender] > 0);\n', '    \n', '        uint256 _value = balances[_sender];\n', '        balances[_sender] = 0;\n', '        balances[exchange] = balances[exchange].add(_value);\n', '        emit Transfer(_sender, exchange, _value);\n', '        return true;    \n', '    }\n', '    \n', '    function batchExchange(address[] _senders) public onlyOwner returns (bool) {\n', '        uint cnt = _senders.length;\n', '        require(cnt > 0 && cnt <= 20);        \n', '        for (uint i = 0; i < cnt; i++) {\n', '            toExchange(_senders[i]);\n', '        }\n', '        return true;    \n', '    }\n', '    \n', '    function transferExchange(uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.transfer(exchange, _value);\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        require(!frozenAccount[msg.sender]);\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        require(!frozenAccount[msg.sender]);\n', '        require(!frozenAccount[_from]);\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '        require(!frozenAccount[msg.sender]);\n', '        return super.approve(_spender, _value);\n', '    }\n', '    \n', '    function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool) {\n', '        require(!frozenAccount[msg.sender]);\n', '        return super.increaseApproval(_spender, _addedValue);\n', '    }\n', '  \n', '    function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool) {\n', '        require(!frozenAccount[msg.sender]);\n', '        return super.decreaseApproval(_spender, _subtractedValue);\n', '    }\n', '\n', '    function batchTransfer(address[] _receivers, uint256 _value) public whenNotPaused returns (bool) {\n', '        require(!frozenAccount[msg.sender]);\n', '        uint cnt = _receivers.length;\n', '        uint256 amount = _value.mul(uint256(cnt));\n', '        require(cnt > 0 && cnt <= 20);\n', '        require(_value > 0 && balances[msg.sender] >= amount);\n', '  \n', '        balances[msg.sender] = balances[msg.sender].sub(amount);\n', '        for (uint i = 0; i < cnt; i++) {\n', '            balances[_receivers[i]] = balances[_receivers[i]].add(_value);\n', '            emit Transfer(msg.sender, _receivers[i], _value);\n', '        }\n', '        return true;\n', '    }\n', '     \n', '}\n', '\n', 'contract AOYTToken is PausableToken {\n', '    string public name = "AOYT";\n', '    string public symbol = "AOYT";\n', "    string public version = '1.0.0';\n", '    uint8 public decimals = 18;\n', '    uint256 public sellPrice;\n', '    uint256 public buyPrice;\n', '    address private initCoinOwner = 0xAf2F1880C43d08B6a218Cb879876E90785d450a1;\n', '\n', '    constructor() public {\n', '      totalSupply = 210000000 * (10**(uint256(decimals)));\n', '      balances[initCoinOwner] = totalSupply;\n', '    }\n', '\n', '    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) public onlyOwner {\n', '        sellPrice = newSellPrice;\n', '        buyPrice = newBuyPrice;\n', '    }\n', '    \n', '    function buy() public payable returns (uint amount){\n', '        amount = msg.value.div(buyPrice);\n', '        require(balances[this] >= amount);\n', '        balances[msg.sender] = balances[msg.sender].add(uint256(amount));\n', '        balances[this] = balances[this].sub(uint256(amount));\n', '        emit Transfer(this, msg.sender, amount);\n', '        return amount;\n', '    }\n', '    \n', '    function sell(uint amount) public returns (uint revenue){\n', '        require(balances[msg.sender] >= amount);\n', '        balances[msg.sender] = balances[msg.sender].sub(uint256(amount));\n', '        balances[this] = balances[this].add(uint256(amount));\n', '        revenue = sellPrice.mul(uint256(amount));\n', '        msg.sender.transfer(revenue);\n', '        emit Transfer(msg.sender, this, amount);\n', '        return revenue;\n', '    }\n', '    \n', '    function () public {\n', '        //if ether is sent to this address, send it back.\n', '        revert();\n', '    }\n', '}']
