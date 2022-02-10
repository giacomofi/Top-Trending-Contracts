['pragma solidity 0.4.24;\n', '\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    event OwnershipRenounced(address indexed previousOwner);\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(\n', '        address newOwner\n', '    )\n', '        public\n', '        onlyOwner\n', '    {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '    function renounceOwnership()\n', '        public\n', '        onlyOwner\n', '    {\n', '        emit OwnershipRenounced(owner);\n', '        owner = address(0);\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    function mul(\n', '        uint256 a, \n', '        uint256 b\n', '    )\n', '        internal\n', '        pure\n', '        returns (uint256 c)\n', '    {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        require(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(\n', '        uint256 a, \n', '        uint256 b\n', '    )\n', '        internal\n', '        pure\n', '        returns (uint256)\n', '    {\n', '        return a / b;\n', '    }\n', '\n', '    function sub(\n', '        uint256 a, \n', '        uint256 b\n', '    )\n', '        internal\n', '        pure\n', '        returns (uint256)\n', '    {\n', '        require(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(\n', '        uint256 a,\n', '        uint256 b\n', '    )\n', '        internal\n', '        pure\n', '        returns (uint256 c)\n', '    {\n', '        c = a + b;\n', '        require(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    function burn(uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Burn(address indexed from, uint256 value);\n', '}\n', '\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function burnFrom(address from, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '    mapping(address => uint256) internal balances;\n', '    uint256 internal totalSupply_;\n', '\n', '    function totalSupply()\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return totalSupply_;\n', '    }\n', '\n', '    function transfer(\n', '        address _to, \n', '        uint256 _value\n', '    )\n', '        public\n', '        returns (bool)\n', '    {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function burn(\n', '        uint256 _value\n', '    )\n', '        public\n', '        returns (bool)\n', '    {\n', '        require(balances[msg.sender] >= _value);\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        totalSupply_ = totalSupply_.sub(_value);\n', '        emit Burn(msg.sender, _value);\n', '        emit Transfer(msg.sender, address(0), _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(\n', '        address _owner\n', '    )\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return balances[_owner];\n', '    }\n', '}\n', '\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    function transferFrom(\n', '        address _from, \n', '        address _to, \n', '        uint256 _value\n', '    )\n', '        public\n', '        returns (bool)\n', '    {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(\n', '        address _from, \n', '        uint256 _value\n', '    )\n', '        public\n', '        returns (bool)\n', '    {\n', '        require(balances[_from] >= _value);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        totalSupply_ = totalSupply_.sub(_value);\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(\n', '        address _spender, \n', '        uint256 _value\n', '    )\n', '        public\n', '        returns (bool)\n', '    {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(\n', '        address _owner, \n', '        address _spender\n', '    )\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function increaseApproval(\n', '        address _spender, \n', '        uint _addedValue\n', '    )\n', '        public\n', '        returns (bool)\n', '    {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(\n', '        address _spender, \n', '        uint _subtractedValue\n', '    )\n', '        public\n', '        returns (bool)\n', '    {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract CoAlphaToken is StandardToken, Ownable {\n', '    string public name = "CoAlphaToken";\n', '    string public symbol = "CAL";\n', '    uint8 public decimals = 2;\n', '    uint public initialSupply = 2000000000*(10**uint256(decimals));\n', '\n', '    constructor() public {\n', '        totalSupply_ = initialSupply;\n', '        balances[msg.sender] = initialSupply;\n', '    }\n', '}']
['pragma solidity 0.4.24;\n', '\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    event OwnershipRenounced(address indexed previousOwner);\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(\n', '        address newOwner\n', '    )\n', '        public\n', '        onlyOwner\n', '    {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '    function renounceOwnership()\n', '        public\n', '        onlyOwner\n', '    {\n', '        emit OwnershipRenounced(owner);\n', '        owner = address(0);\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    function mul(\n', '        uint256 a, \n', '        uint256 b\n', '    )\n', '        internal\n', '        pure\n', '        returns (uint256 c)\n', '    {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        require(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(\n', '        uint256 a, \n', '        uint256 b\n', '    )\n', '        internal\n', '        pure\n', '        returns (uint256)\n', '    {\n', '        return a / b;\n', '    }\n', '\n', '    function sub(\n', '        uint256 a, \n', '        uint256 b\n', '    )\n', '        internal\n', '        pure\n', '        returns (uint256)\n', '    {\n', '        require(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(\n', '        uint256 a,\n', '        uint256 b\n', '    )\n', '        internal\n', '        pure\n', '        returns (uint256 c)\n', '    {\n', '        c = a + b;\n', '        require(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    function burn(uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Burn(address indexed from, uint256 value);\n', '}\n', '\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function burnFrom(address from, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '    mapping(address => uint256) internal balances;\n', '    uint256 internal totalSupply_;\n', '\n', '    function totalSupply()\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return totalSupply_;\n', '    }\n', '\n', '    function transfer(\n', '        address _to, \n', '        uint256 _value\n', '    )\n', '        public\n', '        returns (bool)\n', '    {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function burn(\n', '        uint256 _value\n', '    )\n', '        public\n', '        returns (bool)\n', '    {\n', '        require(balances[msg.sender] >= _value);\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        totalSupply_ = totalSupply_.sub(_value);\n', '        emit Burn(msg.sender, _value);\n', '        emit Transfer(msg.sender, address(0), _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(\n', '        address _owner\n', '    )\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return balances[_owner];\n', '    }\n', '}\n', '\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    function transferFrom(\n', '        address _from, \n', '        address _to, \n', '        uint256 _value\n', '    )\n', '        public\n', '        returns (bool)\n', '    {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(\n', '        address _from, \n', '        uint256 _value\n', '    )\n', '        public\n', '        returns (bool)\n', '    {\n', '        require(balances[_from] >= _value);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        totalSupply_ = totalSupply_.sub(_value);\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(\n', '        address _spender, \n', '        uint256 _value\n', '    )\n', '        public\n', '        returns (bool)\n', '    {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(\n', '        address _owner, \n', '        address _spender\n', '    )\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function increaseApproval(\n', '        address _spender, \n', '        uint _addedValue\n', '    )\n', '        public\n', '        returns (bool)\n', '    {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(\n', '        address _spender, \n', '        uint _subtractedValue\n', '    )\n', '        public\n', '        returns (bool)\n', '    {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract CoAlphaToken is StandardToken, Ownable {\n', '    string public name = "CoAlphaToken";\n', '    string public symbol = "CAL";\n', '    uint8 public decimals = 2;\n', '    uint public initialSupply = 2000000000*(10**uint256(decimals));\n', '\n', '    constructor() public {\n', '        totalSupply_ = initialSupply;\n', '        balances[msg.sender] = initialSupply;\n', '    }\n', '}']