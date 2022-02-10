['pragma solidity ^0.4.23;\n', '\n', 'contract TokenReceiver {\n', '    function tokenFallback(address _from, uint _value, bytes _data) public;\n', '}\n', '\n', 'contract EgeregToken {\n', '    address public owner;\n', '    string public name = "EgeregToken";\n', '    string public symbol = "MNG";\n', '    uint8 public decimals = 2;\n', '    uint public totalSupply = 0;\n', '    mapping(address => uint) balances;\n', '    mapping (address => mapping (address => uint)) internal allowed;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function subtr(uint a, uint b) internal pure returns (uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function addit(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function balanceOf(address _owner) external view returns (uint) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transfer(address _to, uint _value) external returns (bool) {\n', '        bytes memory empty;\n', '        transfer(_to, _value, empty);\n', '        return true;\n', '    }\n', '\n', '    function transfer(address _to, uint _value, bytes _data) public returns (bool) {\n', '        require(_value <= balances[msg.sender]);\n', '        balances[msg.sender] = subtr(balances[msg.sender], _value);\n', '        balances[_to] = addit(balances[_to], _value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        if (isContract(_to)) {\n', '            TokenReceiver receiver = TokenReceiver(_to);\n', '            receiver.tokenFallback(msg.sender, _value, _data);\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value) external returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        balances[_from] = subtr(balances[_from], _value);\n', '        balances[_to] = addit(balances[_to], _value);\n', '        allowed[_from][msg.sender] = subtr(allowed[_from][msg.sender], _value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint _value, bytes _data) external returns (bool) {\n', '        approve(_spender, _value);\n', '        require(_spender.call(_data));\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) external view returns (uint) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = addit(allowed[msg.sender][_spender], _addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue, bytes _data) external returns (bool) {\n', '        increaseApproval(_spender, _addedValue);\n', '        require(_spender.call(_data));\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) external returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = subtr(oldValue, _subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) external onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '    function mint(address _to, uint _amount) onlyOwner external returns (bool) {\n', '        totalSupply = addit(totalSupply, _amount);\n', '        balances[_to] = addit(balances[_to], _amount);\n', '        emit Mint(_to, _amount);\n', '        emit Transfer(address(0), _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    function burn(uint _value) external {\n', '        require(_value <= balances[msg.sender]);\n', '        address burner = msg.sender;\n', '        balances[burner] = subtr(balances[burner], _value);\n', '        totalSupply = subtr(totalSupply, _value);\n', '        emit Burn(burner, _value);\n', '        emit Transfer(burner, address(0), _value);\n', '    }\n', '\n', '    function isContract(address _addr) private view returns (bool) {\n', '        uint length;\n', '        assembly {\n', '            length := extcodesize(_addr)\n', '        }\n', '        return (length>0);\n', '    }\n', '\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Mint(address indexed to, uint amount);\n', '    event Burn(address indexed burner, uint value);\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '}']
['pragma solidity ^0.4.23;\n', '\n', 'contract TokenReceiver {\n', '    function tokenFallback(address _from, uint _value, bytes _data) public;\n', '}\n', '\n', 'contract EgeregToken {\n', '    address public owner;\n', '    string public name = "EgeregToken";\n', '    string public symbol = "MNG";\n', '    uint8 public decimals = 2;\n', '    uint public totalSupply = 0;\n', '    mapping(address => uint) balances;\n', '    mapping (address => mapping (address => uint)) internal allowed;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function subtr(uint a, uint b) internal pure returns (uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function addit(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function balanceOf(address _owner) external view returns (uint) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transfer(address _to, uint _value) external returns (bool) {\n', '        bytes memory empty;\n', '        transfer(_to, _value, empty);\n', '        return true;\n', '    }\n', '\n', '    function transfer(address _to, uint _value, bytes _data) public returns (bool) {\n', '        require(_value <= balances[msg.sender]);\n', '        balances[msg.sender] = subtr(balances[msg.sender], _value);\n', '        balances[_to] = addit(balances[_to], _value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        if (isContract(_to)) {\n', '            TokenReceiver receiver = TokenReceiver(_to);\n', '            receiver.tokenFallback(msg.sender, _value, _data);\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value) external returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        balances[_from] = subtr(balances[_from], _value);\n', '        balances[_to] = addit(balances[_to], _value);\n', '        allowed[_from][msg.sender] = subtr(allowed[_from][msg.sender], _value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint _value, bytes _data) external returns (bool) {\n', '        approve(_spender, _value);\n', '        require(_spender.call(_data));\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) external view returns (uint) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = addit(allowed[msg.sender][_spender], _addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue, bytes _data) external returns (bool) {\n', '        increaseApproval(_spender, _addedValue);\n', '        require(_spender.call(_data));\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) external returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = subtr(oldValue, _subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) external onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '    function mint(address _to, uint _amount) onlyOwner external returns (bool) {\n', '        totalSupply = addit(totalSupply, _amount);\n', '        balances[_to] = addit(balances[_to], _amount);\n', '        emit Mint(_to, _amount);\n', '        emit Transfer(address(0), _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    function burn(uint _value) external {\n', '        require(_value <= balances[msg.sender]);\n', '        address burner = msg.sender;\n', '        balances[burner] = subtr(balances[burner], _value);\n', '        totalSupply = subtr(totalSupply, _value);\n', '        emit Burn(burner, _value);\n', '        emit Transfer(burner, address(0), _value);\n', '    }\n', '\n', '    function isContract(address _addr) private view returns (bool) {\n', '        uint length;\n', '        assembly {\n', '            length := extcodesize(_addr)\n', '        }\n', '        return (length>0);\n', '    }\n', '\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Mint(address indexed to, uint amount);\n', '    event Burn(address indexed burner, uint value);\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '}']
