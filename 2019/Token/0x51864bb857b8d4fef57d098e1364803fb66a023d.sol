['pragma solidity ^0.4.24;\n', '\n', '\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal pure  returns (uint) {\n', '    uint c = a * b;\n', '    require(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '  function div(uint a, uint b) internal pure returns (uint) {\n', '    require(b > 0);\n', '    uint c = a / b;\n', '    require(a == b * c + a % b);\n', '    return c;\n', '  }\n', '  function sub(uint a, uint b) internal pure returns (uint) {\n', '    require(b <= a);\n', '    return a - b;\n', '  }\n', '  function add(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a + b;\n', '    require(c >= a);\n', '    return c;\n', '  }\n', '  function max64(uint64 a, uint64 b) internal  pure returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '  function min64(uint64 a, uint64 b) internal  pure returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '  function max256(uint256 a, uint256 b) internal  pure returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '  function min256(uint256 a, uint256 b) internal  pure returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    function Ownable() public{\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    function transferOwnership(address newOwner) onlyOwner public{\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'contract AUCC is  Ownable {\n', '    \n', '  using SafeMath for uint;\n', '  mapping(address => uint) balances;\n', '  \n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '  \n', '  string public constant name = "Arc Unified Chain";\n', '  string public constant symbol = "AUCC";\n', '  uint public constant decimals = 18;\n', '  uint public totalSupply = 6700000000000000000000000;\n', '  \n', '  address public deadContractAddress;\n', '\n', '  function AUCC() public {\n', '      balances[msg.sender] = totalSupply; // Send all tokens to owner\n', '  }\n', '  \n', '\n', '  function transfer(address _to, uint _value) public{\n', '      \n', '    uint256 fee = _value.mul(1).div(100);\n', '    uint256 remainingValue = _value.mul(99).div(100);\n', '    \n', '    if (_to == deadContractAddress){\n', '        burn(_value);//Burn 100% transfer value\n', '    }else{\n', '        burn(fee); //Burn 1% transfer value\n', '        balances[msg.sender] = balances[msg.sender].sub(remainingValue);\n', '    }\n', '    \n', '    balances[_to] = balances[_to].add(remainingValue);\n', '    emit Transfer(msg.sender, _to, _value);\n', '  }\n', '  \n', '\n', '  function balanceOf(address _owner) public constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '  \n', '  \n', '  function transferFrom(address _from, address _to, uint _value) public {\n', '      \n', '    uint256 fee = _value.mul(1).div(100);//\n', '    uint256 remainingValue = _value.mul(99).div(100);\n', '    \n', '    if (_to == deadContractAddress){\n', '         burnFrom(_from, _value);//Burn 100% transfer value\n', '    }else{\n', '        burnFrom(_from, fee);//Burn 1% transfer value\n', '        balances[_from] = balances[_from].sub(remainingValue);\n', '    }\n', '   \n', '    balances[_to] = balances[_to].add(remainingValue);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '  }\n', '\n', '  function approve(address _spender, uint _value) public{\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0)) ;\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '  \n', ' function burnFrom(address _from, uint _value) internal  returns (bool)  {\n', '    balances[_from] = balances[_from].sub(_value);\n', '    totalSupply = totalSupply.sub(_value);\n', '    emit Transfer(_from, 0x0, _value);\n', '    return true;\n', '  }\n', '\n', '  function burn(uint _value)  public returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    totalSupply = totalSupply.sub(_value);\n', '    emit Transfer(msg.sender, 0x0, _value);\n', '    return true;\n', '  }\n', '  \n', '  function setDeadContractAddress(address _deadContractAddress) onlyOwner public {\n', '   deadContractAddress = _deadContractAddress;\n', '  }\n', '\n', '}']