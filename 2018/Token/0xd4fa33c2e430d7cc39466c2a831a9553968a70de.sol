['//@ create by ETU LAB, INC.\n', 'pragma solidity ^0.4.19;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '          return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '    \n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '    \n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '    \n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '    modifier onlyOwner { require(msg.sender == owner); _; }\n', '    event OwnerUpdate(address _prevOwner, address _newOwner);\n', '\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        require(_newOwner != owner);\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        OwnerUpdate(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = 0x0;\n', '    }\n', '}\n', '\n', '// ERC20 Interface\n', 'contract ERC20 {\n', '    function totalSupply() public view returns (uint _totalSupply);\n', '    function balanceOf(address _owner) public view returns (uint balance);\n', '    function transfer(address _to, uint _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success);\n', '    function approve(address _spender, uint _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public view returns (uint remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '\n', '// ERC20Token\n', 'contract ERC20Token is ERC20 {\n', '    using SafeMath for uint256;\n', '    mapping(address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    uint256 public totalToken; \n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] = balances[msg.sender].sub(_value);\n', '            balances[_to] = balances[_to].add(_value);\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_from] = balances[_from].sub(_value);\n', '            balances[_to] = balances[_to].add(_value);\n', '            allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalToken;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '}\n', '\n', 'contract ETU is ERC20Token, Owned {\n', '\n', '    string  public constant name = "ETU Token";\n', '    string  public constant symbol = "ETU";\n', '    uint256 public constant decimals = 18;\n', '    uint256 public tokenDestroyed;\n', '\tevent Burn(address indexed _from, uint256 _tokenDestroyed, uint256 _timestamp);\n', '\n', '    function ETU() public {\n', '\t\ttotalToken = 1000000000000000000000000000;\n', '\t\tbalances[msg.sender] = totalToken;\n', '    }\n', '\n', '    function transferAnyERC20Token(address _tokenAddress, address _recipient, uint256 _amount) public onlyOwner returns (bool success) {\n', '        return ERC20(_tokenAddress).transfer(_recipient, _amount);\n', '    }\n', '\n', '    function burn (uint256 _burntAmount) public returns (bool success) {\n', '    \trequire(balances[msg.sender] >= _burntAmount && _burntAmount > 0);\n', '    \tbalances[msg.sender] = balances[msg.sender].sub(_burntAmount);\n', '    \ttotalToken = totalToken.sub(_burntAmount);\n', '    \ttokenDestroyed = tokenDestroyed.add(_burntAmount);\n', '    \trequire (tokenDestroyed <= 500000000000000000000000000);\n', '    \tTransfer(address(this), 0x0, _burntAmount);\n', '    \tBurn(msg.sender, _burntAmount, block.timestamp);\n', '    \treturn true;\n', '\t}\n', '\n', '}']
['//@ create by ETU LAB, INC.\n', 'pragma solidity ^0.4.19;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '          return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '    \n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '    \n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '    \n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '    modifier onlyOwner { require(msg.sender == owner); _; }\n', '    event OwnerUpdate(address _prevOwner, address _newOwner);\n', '\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        require(_newOwner != owner);\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        OwnerUpdate(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = 0x0;\n', '    }\n', '}\n', '\n', '// ERC20 Interface\n', 'contract ERC20 {\n', '    function totalSupply() public view returns (uint _totalSupply);\n', '    function balanceOf(address _owner) public view returns (uint balance);\n', '    function transfer(address _to, uint _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success);\n', '    function approve(address _spender, uint _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public view returns (uint remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '\n', '// ERC20Token\n', 'contract ERC20Token is ERC20 {\n', '    using SafeMath for uint256;\n', '    mapping(address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    uint256 public totalToken; \n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] = balances[msg.sender].sub(_value);\n', '            balances[_to] = balances[_to].add(_value);\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_from] = balances[_from].sub(_value);\n', '            balances[_to] = balances[_to].add(_value);\n', '            allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalToken;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '}\n', '\n', 'contract ETU is ERC20Token, Owned {\n', '\n', '    string  public constant name = "ETU Token";\n', '    string  public constant symbol = "ETU";\n', '    uint256 public constant decimals = 18;\n', '    uint256 public tokenDestroyed;\n', '\tevent Burn(address indexed _from, uint256 _tokenDestroyed, uint256 _timestamp);\n', '\n', '    function ETU() public {\n', '\t\ttotalToken = 1000000000000000000000000000;\n', '\t\tbalances[msg.sender] = totalToken;\n', '    }\n', '\n', '    function transferAnyERC20Token(address _tokenAddress, address _recipient, uint256 _amount) public onlyOwner returns (bool success) {\n', '        return ERC20(_tokenAddress).transfer(_recipient, _amount);\n', '    }\n', '\n', '    function burn (uint256 _burntAmount) public returns (bool success) {\n', '    \trequire(balances[msg.sender] >= _burntAmount && _burntAmount > 0);\n', '    \tbalances[msg.sender] = balances[msg.sender].sub(_burntAmount);\n', '    \ttotalToken = totalToken.sub(_burntAmount);\n', '    \ttokenDestroyed = tokenDestroyed.add(_burntAmount);\n', '    \trequire (tokenDestroyed <= 500000000000000000000000000);\n', '    \tTransfer(address(this), 0x0, _burntAmount);\n', '    \tBurn(msg.sender, _burntAmount, block.timestamp);\n', '    \treturn true;\n', '\t}\n', '\n', '}']