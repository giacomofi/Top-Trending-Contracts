['pragma solidity 0.4.21;\n', '\n', 'contract ERC20Basic {\n', '\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\t\n', '}\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\t\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '\t\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) public balances;\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\t\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', 'contract CerttifyToken is StandardToken {\n', '\n', '    event Burn(address indexed burner, uint256 value, string message);\n', '    event IssueCert(bytes32 indexed id, address certIssuer, uint256 value, bytes cert);\n', '\n', '    string public name = "Certtify Token";\n', '    string public symbol = "CTF";\n', '    uint8 public decimals = 18;\n', '\n', '    address public deployer;\n', '    bool public lockup = true;\n', '\n', '    function CerttifyToken(uint256 maxSupply) public {\n', '        totalSupply = maxSupply.mul(10 ** uint256(decimals));\n', '        balances[msg.sender] = totalSupply;\n', '        deployer = msg.sender;\n', '    }\n', '\n', '    modifier afterLockup() {\n', '        require(!lockup || msg.sender == deployer);\n', '        _;\n', '    }\n', '\n', '    function unlock() public {\n', '        require(msg.sender == deployer);\n', '        lockup = false;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public afterLockup() returns (bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public afterLockup() returns (bool) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function burn(uint256 _value, string _message) public afterLockup() {\n', '        require(_value > 0);\n', '        require(_value <= balances[msg.sender]);\n', '        address burner = msg.sender;\n', '        totalSupply = totalSupply.sub(_value);\n', '        balances[burner] = balances[burner].sub(_value);\n', '        emit Burn(burner, _value, _message);\n', '    }\n', '\n', '    function issueCert(uint256 _value, bytes _cert) external afterLockup() {\n', '        if (_value > 0) { \n', '            burn(_value, "");\n', '        }\n', '        emit IssueCert(keccak256(block.number, msg.sender, _value, _cert), msg.sender, _value, _cert);\n', '    }\n', '\n', '}']