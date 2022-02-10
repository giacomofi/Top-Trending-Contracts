['pragma solidity ^0.4.11;\n', '\n', 'interface IERC20 {\n', '    //function totalSupply() public constant returns (uint256 totalSupply);\n', '    function balanceOf(address _owner) external constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) external returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);\n', '    function approve(address _spender, uint256 _value) external returns (bool success);\n', '    function allowance(address _owner, address _spender) external constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address _spender, uint256 _value);\n', '}\n', '\n', 'contract SafeMath {\n', '    \n', '    function add(uint256 a, uint256 b) public pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '    \n', '    function sub(uint256 a, uint256 b) public pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) public pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) public pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract StandardToken is IERC20 {\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '    \n', '    SafeMath safeMath = new SafeMath();\n', '\n', '    function StandardToken() public payable {\n', '\n', '    }\n', '\n', '    function balanceOf(address _owner) external constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) external returns (bool success) {\n', '        require(_value > 0 && balances[msg.sender] >= _value);\n', '        balances[msg.sender] = safeMath.sub(balances[msg.sender], _value);\n', '        balances[_to] = safeMath.add(balances[_to], _value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {\n', '        require(_value > 0 && allowed[_from][msg.sender] >= _value && balances[_from] >= _value);\n', '        balances[_from] = safeMath.sub(balances[_from], _value);\n', '        balances[_to] = safeMath.add(balances[_to], _value);\n', '        allowed[_from][msg.sender] = safeMath.sub(allowed[_from][msg.sender], _value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) external returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) external constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address _spender, uint256 _value);\n', '}\n', '\n', 'contract OwnableToken is StandardToken {\n', '    \n', '    address internal owner;\n', '    \n', '    uint public totalSupply = 10000000000 * 10 ** 8;\n', '    \n', '    function OwnableToken() public payable {\n', '\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    function transferOwnership(address _newOwner) onlyOwner public {\n', '        require(_newOwner != address(0));\n', '        owner = _newOwner;\n', '        emit OwnershipTransfer(owner, _newOwner);\n', '    }\n', '    \n', '    function account(address _from, address _to, uint256 _value) onlyOwner public {\n', '        require(_from != address(0) && _to != address(0));\n', '        require(_value > 0 && balances[_from] >= _value);\n', '        balances[_from] = safeMath.sub(balances[_from], _value);\n', '        balances[_to] = safeMath.add(balances[_to], _value);\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '    \n', '    function make(uint256 _value) public payable onlyOwner returns (bool success) {\n', '        require(_value > 0x0);\n', '\n', '        balances[msg.sender] = safeMath.add(balances[msg.sender], _value);\n', '        totalSupply = safeMath.add(totalSupply, _value);\n', '        emit Make(_value);\n', '        return true;\n', '    }\n', '    \n', '    function burn(uint256 _value) public payable onlyOwner returns (bool success) {\n', '        require(_value > 0x0);\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = safeMath.sub(balances[msg.sender], _value);\n', '        totalSupply = safeMath.sub(totalSupply, _value);\n', '        emit Burn(_value);\n', '        return true;\n', '    }\n', '    \n', '    event OwnershipTransfer(address indexed previousOwner, address indexed newOwner);\n', '    event Make(uint256 value);\n', '    event Burn(uint256 value);\n', '}\n', '\n', 'contract HTL is OwnableToken {\n', '    \n', '    string public constant symbol = "HTL";\n', '    string public constant name = "HT Charge Link";\n', '    uint8 public constant decimals = 8;\n', '    \n', '    function HTL() public payable {\n', '        owner = 0xbd9ccc7bfd2dc00b59bdbe8898b5b058a31e853e;\n', '        balances[owner] = 10000000000 * 10 ** 8;\n', '    }\n', '}']
['pragma solidity ^0.4.11;\n', '\n', 'interface IERC20 {\n', '    //function totalSupply() public constant returns (uint256 totalSupply);\n', '    function balanceOf(address _owner) external constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) external returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);\n', '    function approve(address _spender, uint256 _value) external returns (bool success);\n', '    function allowance(address _owner, address _spender) external constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address _spender, uint256 _value);\n', '}\n', '\n', 'contract SafeMath {\n', '    \n', '    function add(uint256 a, uint256 b) public pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '    \n', '    function sub(uint256 a, uint256 b) public pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) public pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) public pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '}\n', '\n', 'contract StandardToken is IERC20 {\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '    \n', '    SafeMath safeMath = new SafeMath();\n', '\n', '    function StandardToken() public payable {\n', '\n', '    }\n', '\n', '    function balanceOf(address _owner) external constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) external returns (bool success) {\n', '        require(_value > 0 && balances[msg.sender] >= _value);\n', '        balances[msg.sender] = safeMath.sub(balances[msg.sender], _value);\n', '        balances[_to] = safeMath.add(balances[_to], _value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {\n', '        require(_value > 0 && allowed[_from][msg.sender] >= _value && balances[_from] >= _value);\n', '        balances[_from] = safeMath.sub(balances[_from], _value);\n', '        balances[_to] = safeMath.add(balances[_to], _value);\n', '        allowed[_from][msg.sender] = safeMath.sub(allowed[_from][msg.sender], _value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) external returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) external constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address _spender, uint256 _value);\n', '}\n', '\n', 'contract OwnableToken is StandardToken {\n', '    \n', '    address internal owner;\n', '    \n', '    uint public totalSupply = 10000000000 * 10 ** 8;\n', '    \n', '    function OwnableToken() public payable {\n', '\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    function transferOwnership(address _newOwner) onlyOwner public {\n', '        require(_newOwner != address(0));\n', '        owner = _newOwner;\n', '        emit OwnershipTransfer(owner, _newOwner);\n', '    }\n', '    \n', '    function account(address _from, address _to, uint256 _value) onlyOwner public {\n', '        require(_from != address(0) && _to != address(0));\n', '        require(_value > 0 && balances[_from] >= _value);\n', '        balances[_from] = safeMath.sub(balances[_from], _value);\n', '        balances[_to] = safeMath.add(balances[_to], _value);\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '    \n', '    function make(uint256 _value) public payable onlyOwner returns (bool success) {\n', '        require(_value > 0x0);\n', '\n', '        balances[msg.sender] = safeMath.add(balances[msg.sender], _value);\n', '        totalSupply = safeMath.add(totalSupply, _value);\n', '        emit Make(_value);\n', '        return true;\n', '    }\n', '    \n', '    function burn(uint256 _value) public payable onlyOwner returns (bool success) {\n', '        require(_value > 0x0);\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = safeMath.sub(balances[msg.sender], _value);\n', '        totalSupply = safeMath.sub(totalSupply, _value);\n', '        emit Burn(_value);\n', '        return true;\n', '    }\n', '    \n', '    event OwnershipTransfer(address indexed previousOwner, address indexed newOwner);\n', '    event Make(uint256 value);\n', '    event Burn(uint256 value);\n', '}\n', '\n', 'contract HTL is OwnableToken {\n', '    \n', '    string public constant symbol = "HTL";\n', '    string public constant name = "HT Charge Link";\n', '    uint8 public constant decimals = 8;\n', '    \n', '    function HTL() public payable {\n', '        owner = 0xbd9ccc7bfd2dc00b59bdbe8898b5b058a31e853e;\n', '        balances[owner] = 10000000000 * 10 ** 8;\n', '    }\n', '}']