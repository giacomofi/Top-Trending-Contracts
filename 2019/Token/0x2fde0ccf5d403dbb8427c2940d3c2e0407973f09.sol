['pragma solidity >=0.4.22 <0.6.0;\n', 'contract Token{\n', '    uint256 public totalSupply;\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from,address _to,uint256 _value)public returns(bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public view returns  (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256  _value);\n', '    event Burn(address indexed from, uint256 value);\n', '}\n', '\n', 'contract YMFToken is Token{\n', '    string public chinaName;\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    address public owner;\n', '    mapping(address=>uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    \n', '    constructor(uint256 _initialAmount, string memory _tokenName,string memory _chinaName,uint8 _decimalUnits, string memory _tokenSymbol) public{\n', '        totalSupply = _initialAmount * 10 ** uint256(_decimalUnits);\n', '        balances[msg.sender] = totalSupply;\n', '        name=_tokenName;\n', '        decimals=_decimalUnits;\n', '        symbol=_tokenSymbol;\n', '        chinaName=_chinaName;\n', '        owner=msg.sender;\n', '    }\n', '    \n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require(_to != address(0x0));\n', '        require(balances[_from] >= _value);\n', '        require(balances[_to] + _value >= balances[_to]);\n', '        uint previousBalances = balances[_from] + balances[_to];\n', '        balances[_from] -= _value;\n', '        balances[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '        assert(balances[_from] + balances[_to] == previousBalances);\n', '    }    \n', '    \n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowed[_from][msg.sender]);     \n', '        allowed[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _value) public returns (bool success)   \n', '    { \n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }  \n', '    \n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(msg.sender==owner);\n', '        require(balances[msg.sender] >= _value);  \n', '        balances[msg.sender] -= _value;            \n', '        totalSupply -= _value;                      \n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }    \n', '    \n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(msg.sender==owner);\n', '        require(balances[_from] >= _value);                \n', '        require(_value <= allowed[_from][msg.sender]);    \n', '        balances[_from] -= _value;                        \n', '        allowed[_from][msg.sender] -= _value;             \n', '        totalSupply -= _value;                              \n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '    \n', '}']