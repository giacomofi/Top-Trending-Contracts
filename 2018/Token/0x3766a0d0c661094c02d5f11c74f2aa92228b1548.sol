['pragma solidity ^0.4.15;\n', '\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) onlyOwner public {\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() onlyOwner public {\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '}\n', '\n', 'contract ERC20 {\n', '    uint256 public totalSupply;\n', '  \n', '    function balanceOf(address who) public constant returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '  \n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract StandartToken is ERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    \n', '    bool public isStarted = false;\n', '    \n', '    modifier isStartedOnly() {\n', '        require(isStarted);\n', '        _;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) isStartedOnly public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '  \n', '    function transferFrom(address _from, address _to, uint256 _value) isStartedOnly public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) isStartedOnly public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function increaseApproval (address _spender, uint _addedValue) isStartedOnly public returns (bool success) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval (address _spender, uint _subtractedValue) isStartedOnly public returns (bool success) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '\n', 'contract ENDOToken is Owned, StandartToken {\n', '    string public name = "ENDO Token";\n', '    string public symbol = "EDT";\n', '    uint public decimals = 18;\n', '\n', '    address public distributionMinter;\n', '\n', '    event Mint(address indexed to, uint256 amount);\n', '\n', '    modifier canMint() {\n', '        require(!isStarted);\n', '        _;\n', '    }\n', '\n', '    modifier onlyDistributionMinter(){\n', '        require(msg.sender == distributionMinter);\n', '        _;\n', '    }\n', '\n', '    function () public {\n', '        revert();\n', '    }\n', '\n', '    function setDistributionMinter(address _distributionMinter)\n', '        public\n', '        onlyOwner\n', '        canMint\n', '    {\n', '        distributionMinter = _distributionMinter;\n', '    }\n', '\n', '    function mint(address _to, uint256 _amount)\n', '        onlyDistributionMinter\n', '        canMint\n', '        public\n', '        returns (bool)\n', '    {\n', '        totalSupply = totalSupply.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        Mint(_to, _amount);\n', '        return true;\n', '    }\n', '\n', '    function start()\n', '        onlyDistributionMinter\n', '        canMint\n', '        public\n', '        returns (bool)\n', '    {\n', '        isStarted = true;\n', '        return true;\n', '    }\n', '}']
['pragma solidity ^0.4.15;\n', '\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) onlyOwner public {\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() onlyOwner public {\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '}\n', '\n', 'contract ERC20 {\n', '    uint256 public totalSupply;\n', '  \n', '    function balanceOf(address who) public constant returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '  \n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract StandartToken is ERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    \n', '    bool public isStarted = false;\n', '    \n', '    modifier isStartedOnly() {\n', '        require(isStarted);\n', '        _;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) isStartedOnly public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '  \n', '    function transferFrom(address _from, address _to, uint256 _value) isStartedOnly public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) isStartedOnly public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function increaseApproval (address _spender, uint _addedValue) isStartedOnly public returns (bool success) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval (address _spender, uint _subtractedValue) isStartedOnly public returns (bool success) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '\n', 'contract ENDOToken is Owned, StandartToken {\n', '    string public name = "ENDO Token";\n', '    string public symbol = "EDT";\n', '    uint public decimals = 18;\n', '\n', '    address public distributionMinter;\n', '\n', '    event Mint(address indexed to, uint256 amount);\n', '\n', '    modifier canMint() {\n', '        require(!isStarted);\n', '        _;\n', '    }\n', '\n', '    modifier onlyDistributionMinter(){\n', '        require(msg.sender == distributionMinter);\n', '        _;\n', '    }\n', '\n', '    function () public {\n', '        revert();\n', '    }\n', '\n', '    function setDistributionMinter(address _distributionMinter)\n', '        public\n', '        onlyOwner\n', '        canMint\n', '    {\n', '        distributionMinter = _distributionMinter;\n', '    }\n', '\n', '    function mint(address _to, uint256 _amount)\n', '        onlyDistributionMinter\n', '        canMint\n', '        public\n', '        returns (bool)\n', '    {\n', '        totalSupply = totalSupply.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        Mint(_to, _amount);\n', '        return true;\n', '    }\n', '\n', '    function start()\n', '        onlyDistributionMinter\n', '        canMint\n', '        public\n', '        returns (bool)\n', '    {\n', '        isStarted = true;\n', '        return true;\n', '    }\n', '}']