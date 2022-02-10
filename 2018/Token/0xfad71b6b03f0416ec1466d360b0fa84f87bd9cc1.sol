['pragma solidity ^0.4.25;\n', '\n', '\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal pure  returns (uint) {\n', '    uint c = a * b;\n', '    require(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '  function div(uint a, uint b) internal pure returns (uint) {\n', '    require(b > 0);\n', '    uint c = a / b;\n', '    require(a == b * c + a % b);\n', '    return c;\n', '  }\n', '  function sub(uint a, uint b) internal pure returns (uint) {\n', '    require(b <= a);\n', '    return a - b;\n', '  }\n', '  function add(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a + b;\n', '    require(c >= a);\n', '    return c;\n', '  }\n', '  function max64(uint64 a, uint64 b) internal  pure returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '  function min64(uint64 a, uint64 b) internal  pure returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '  function max256(uint256 a, uint256 b) internal  pure returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '  function min256(uint256 a, uint256 b) internal  pure returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint);\n', '  function transfer(address to, uint value) public;\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public constant returns (uint);\n', '  function transferFrom(address from, address to, uint value) public;\n', '  function approve(address spender, uint value) public;\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', 'contract BasicToken is ERC20Basic {\n', '\n', '  using SafeMath for uint;\n', '\n', '  mapping(address => uint) balances;\n', '\n', '  function transfer(address _to, uint _value) public{\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '  }\n', '\n', '  function balanceOf(address _owner) public constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '}\n', '\n', 'contract StandardToken is BasicToken, ERC20 {\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '  function transferFrom(address _from, address _to, uint _value) public {\n', '    require(_to != 0x0 && _value > 0);\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '  }\n', '\n', '  function approve(address _spender, uint _value) public{\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0)) ;\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '  }\n', '  \n', '  /* Approves and then calls the receiving contract */\n', '  function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '    approve(_spender,_value);\n', '    //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn&#39;t have to include a contract in here just for this.\n', '    //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)\n', '    //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.\n', '    //require(_spender.call(bytes4(keccak256("receiveApproval(address,uint256,address,bytes)")), abi.encode(msg.sender, _value, this, _extraData)));\n', '    require(_spender.call(abi.encodeWithSelector(bytes4(keccak256("receiveApproval(address,uint256,address,bytes)")),msg.sender, _value, this, _extraData)));\n', '    return true;\n', '}\n', '\n', '  function allowance(address _owner, address _spender) public constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '}\n', '\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    function Ownable() public{\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    function transferOwnership(address newOwner) onlyOwner public{\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'contract BCT is StandardToken, Ownable{\n', '    string public constant name = "BlockCircle Token";\n', '    string public constant symbol = "BCT";\n', '    uint public constant decimals = 18;\n', '\n', '    using SafeMath for uint;\n', '    \n', '    function BCT() public {\n', '        totalSupply = 1000000000000000000000000000;\n', '        balances[msg.sender] = totalSupply; // Send tokens to owner\n', '    }\n', '    \n', '    function burn() onlyOwner public returns (bool) {\n', '        uint256 _burnValue = totalSupply.mul(5).div(100);//5 percent tokens should be burned every year\n', '        require(balances[msg.sender] >= _burnValue);\n', '        require(totalSupply >= _burnValue);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_burnValue);\n', '        totalSupply = totalSupply.sub(_burnValue);\n', '        Transfer(msg.sender, 0x0, _burnValue);\n', '        return true;\n', '    }\n', '    \n', '}']
['pragma solidity ^0.4.25;\n', '\n', '\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal pure  returns (uint) {\n', '    uint c = a * b;\n', '    require(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '  function div(uint a, uint b) internal pure returns (uint) {\n', '    require(b > 0);\n', '    uint c = a / b;\n', '    require(a == b * c + a % b);\n', '    return c;\n', '  }\n', '  function sub(uint a, uint b) internal pure returns (uint) {\n', '    require(b <= a);\n', '    return a - b;\n', '  }\n', '  function add(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a + b;\n', '    require(c >= a);\n', '    return c;\n', '  }\n', '  function max64(uint64 a, uint64 b) internal  pure returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '  function min64(uint64 a, uint64 b) internal  pure returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '  function max256(uint256 a, uint256 b) internal  pure returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '  function min256(uint256 a, uint256 b) internal  pure returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint);\n', '  function transfer(address to, uint value) public;\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public constant returns (uint);\n', '  function transferFrom(address from, address to, uint value) public;\n', '  function approve(address spender, uint value) public;\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', 'contract BasicToken is ERC20Basic {\n', '\n', '  using SafeMath for uint;\n', '\n', '  mapping(address => uint) balances;\n', '\n', '  function transfer(address _to, uint _value) public{\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '  }\n', '\n', '  function balanceOf(address _owner) public constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '}\n', '\n', 'contract StandardToken is BasicToken, ERC20 {\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '  function transferFrom(address _from, address _to, uint _value) public {\n', '    require(_to != 0x0 && _value > 0);\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '  }\n', '\n', '  function approve(address _spender, uint _value) public{\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0)) ;\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '  }\n', '  \n', '  /* Approves and then calls the receiving contract */\n', '  function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '    approve(_spender,_value);\n', "    //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.\n", '    //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)\n', '    //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.\n', '    //require(_spender.call(bytes4(keccak256("receiveApproval(address,uint256,address,bytes)")), abi.encode(msg.sender, _value, this, _extraData)));\n', '    require(_spender.call(abi.encodeWithSelector(bytes4(keccak256("receiveApproval(address,uint256,address,bytes)")),msg.sender, _value, this, _extraData)));\n', '    return true;\n', '}\n', '\n', '  function allowance(address _owner, address _spender) public constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '}\n', '\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    function Ownable() public{\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    function transferOwnership(address newOwner) onlyOwner public{\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'contract BCT is StandardToken, Ownable{\n', '    string public constant name = "BlockCircle Token";\n', '    string public constant symbol = "BCT";\n', '    uint public constant decimals = 18;\n', '\n', '    using SafeMath for uint;\n', '    \n', '    function BCT() public {\n', '        totalSupply = 1000000000000000000000000000;\n', '        balances[msg.sender] = totalSupply; // Send tokens to owner\n', '    }\n', '    \n', '    function burn() onlyOwner public returns (bool) {\n', '        uint256 _burnValue = totalSupply.mul(5).div(100);//5 percent tokens should be burned every year\n', '        require(balances[msg.sender] >= _burnValue);\n', '        require(totalSupply >= _burnValue);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_burnValue);\n', '        totalSupply = totalSupply.sub(_burnValue);\n', '        Transfer(msg.sender, 0x0, _burnValue);\n', '        return true;\n', '    }\n', '    \n', '}']
