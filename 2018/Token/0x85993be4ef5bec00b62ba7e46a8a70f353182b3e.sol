['pragma solidity ^0.4.18;\n', '\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  function Ownable() public {\n', '    owner = msg.sender ;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract YYBToken is Ownable{\n', '    \n', '    using SafeMath for uint256;\n', '    \n', '    string public constant name       = "YiYouBao";\n', '    string public constant symbol     = "YYB";\n', '    uint32 public constant decimals   = 18;\n', '    uint256 public totalSupply        = 199999880000 ether;\n', '    uint256 public currentTotalSupply = 0;\n', '    uint256 startBalance              = 99888.88 ether;\n', '    \n', '    mapping(address => bool) touched;\n', '    mapping(address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '    \n', '        function  YYBToken()  public {\n', '        balances[msg.sender] = startBalance * 999999;\n', '        currentTotalSupply = balances[msg.sender];\n', '    }\n', '    \n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    \n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '\n', '        if( !touched[msg.sender] && currentTotalSupply < totalSupply ){\n', '            balances[msg.sender] = balances[msg.sender].add( startBalance );\n', '            touched[msg.sender] = true;\n', '            currentTotalSupply = currentTotalSupply.add( startBalance );\n', '        }\n', '        \n', '        require(_value <= balances[msg.sender]);\n', '        \n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '    \n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '  \n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        \n', '        require(_value <= allowed[_from][msg.sender]);\n', '        \n', '        if( !touched[_from] && currentTotalSupply < totalSupply ){\n', '            touched[_from] = true;\n', '            balances[_from] = balances[_from].add( startBalance );\n', '            currentTotalSupply = currentTotalSupply.add( startBalance );\n', '        }\n', '        \n', '        require(_value <= balances[_from]);\n', '        \n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '     }\n', '\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '          allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '          allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '     }\n', '    \n', '\n', '    function getBalance(address _a) internal constant returns(uint256)\n', '    {\n', '        if( currentTotalSupply < totalSupply ){\n', '            if( touched[_a] )\n', '                return balances[_a];\n', '            else\n', '                return balances[_a].add( startBalance );\n', '        } else {\n', '            return balances[_a];\n', '        }\n', '    }\n', '    \n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return getBalance( _owner );\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  function Ownable() public {\n', '    owner = msg.sender ;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract YYBToken is Ownable{\n', '    \n', '    using SafeMath for uint256;\n', '    \n', '    string public constant name       = "YiYouBao";\n', '    string public constant symbol     = "YYB";\n', '    uint32 public constant decimals   = 18;\n', '    uint256 public totalSupply        = 199999880000 ether;\n', '    uint256 public currentTotalSupply = 0;\n', '    uint256 startBalance              = 99888.88 ether;\n', '    \n', '    mapping(address => bool) touched;\n', '    mapping(address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '    \n', '        function  YYBToken()  public {\n', '        balances[msg.sender] = startBalance * 999999;\n', '        currentTotalSupply = balances[msg.sender];\n', '    }\n', '    \n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    \n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '\n', '        if( !touched[msg.sender] && currentTotalSupply < totalSupply ){\n', '            balances[msg.sender] = balances[msg.sender].add( startBalance );\n', '            touched[msg.sender] = true;\n', '            currentTotalSupply = currentTotalSupply.add( startBalance );\n', '        }\n', '        \n', '        require(_value <= balances[msg.sender]);\n', '        \n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '    \n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '  \n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        \n', '        require(_value <= allowed[_from][msg.sender]);\n', '        \n', '        if( !touched[_from] && currentTotalSupply < totalSupply ){\n', '            touched[_from] = true;\n', '            balances[_from] = balances[_from].add( startBalance );\n', '            currentTotalSupply = currentTotalSupply.add( startBalance );\n', '        }\n', '        \n', '        require(_value <= balances[_from]);\n', '        \n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '     }\n', '\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '          allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '          allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '     }\n', '    \n', '\n', '    function getBalance(address _a) internal constant returns(uint256)\n', '    {\n', '        if( currentTotalSupply < totalSupply ){\n', '            if( touched[_a] )\n', '                return balances[_a];\n', '            else\n', '                return balances[_a].add( startBalance );\n', '        } else {\n', '            return balances[_a];\n', '        }\n', '    }\n', '    \n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return getBalance( _owner );\n', '    }\n', '\n', '}']
