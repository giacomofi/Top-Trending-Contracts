['pragma solidity ^0.4.18;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal pure returns (uint) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal pure returns (uint) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal pure returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC20 {\n', '\n', '    function totalSupply() public constant returns (uint supply);\n', '    \n', '    function balanceOf(address _owner) public constant returns (uint balance);\n', '    \n', '    function transfer(address _to, uint _value) public returns (bool success);\n', '    \n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success);\n', '    \n', '    function approve(address _spender, uint _value) public returns (bool success);\n', '    \n', '    function allowance(address _owner, address _spender) public constant returns (uint remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '    \n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '\n', '\n', 'contract StandardToken is ERC20 {\n', '\n', '    using SafeMath for uint;\n', '\n', '    uint public totalSupply;\n', '\n', '    mapping (address => uint) balances;\n', '    \n', '    mapping (address => mapping (address => uint)) allowed;\n', '\n', '    function totalSupply() public constant returns (uint) {\n', '        return totalSupply;\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transfer(address _to, uint _value) public returns (bool success) {\n', '        require(balances[msg.sender] >= _value && _value > 0);\n', '        \n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        \n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {\n', '        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);\n', '        \n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        \n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint _value) public returns (bool success) {\n', '        // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) {\n', '            revert();\n', '        }\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '}\n', '\n', 'contract Controlled {\n', '\n', '    address public controller;\n', '\n', '    function Controlled() public {\n', '        controller = msg.sender;\n', '    }\n', '\n', '    function changeController(address _newController) public only_controller {\n', '        controller = _newController;\n', '    }\n', '    \n', '    function getController() constant public returns (address) {\n', '        return controller;\n', '    }\n', '\n', '    modifier only_controller { \n', '        require(msg.sender == controller);\n', '        _; \n', '    }\n', '\n', '}\n', '\n', '\n', 'contract ThetaToken is StandardToken, Controlled {\n', '    \n', '    using SafeMath for uint;\n', '\n', '    string public constant name = "Theta Token";\n', '\n', '    string public constant symbol = "THETA";\n', '\n', '    uint8 public constant decimals = 18;\n', '\n', '    // tokens can be transferred amoung holders only after unlockTime\n', '    uint unlockTime;\n', '    \n', '    // for token circulation on platforms that integrate Theta before unlockTime\n', '    mapping (address => bool) internal precirculated;\n', '\n', '    function ThetaToken(uint _unlockTime) public {\n', '        unlockTime = _unlockTime;\n', '    }\n', '\n', '    function transfer(address _to, uint _amount) can_transfer(msg.sender, _to) public returns (bool success) {\n', '        return super.transfer(_to, _amount);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _amount) can_transfer(_from, _to) public returns (bool success) {\n', '        return super.transferFrom(_from, _to, _amount);\n', '    }\n', '\n', '    function mint(address _owner, uint _amount) external only_controller returns (bool) {\n', '        totalSupply = totalSupply.add(_amount);\n', '        balances[_owner] = balances[_owner].add(_amount);\n', '\n', '        Transfer(0, _owner, _amount);\n', '        return true;\n', '    }\n', '\n', '    function allowPrecirculation(address _addr) only_controller public {\n', '        precirculated[_addr] = true;\n', '    }\n', '\n', '    function disallowPrecirculation(address _addr) only_controller public {\n', '        precirculated[_addr] = false;\n', '    }\n', '\n', '    function isPrecirculationAllowed(address _addr) constant public returns(bool) {\n', '        return precirculated[_addr];\n', '    }\n', '    \n', '    function changeUnlockTime(uint _unlockTime) only_controller public {\n', '        unlockTime = _unlockTime;\n', '    }\n', '\n', '    function getUnlockTime() constant public returns (uint) {\n', '        return unlockTime;\n', '    }\n', '\n', '    modifier can_transfer(address _from, address _to) {\n', '        require((block.number >= unlockTime) || (isPrecirculationAllowed(_from) && isPrecirculationAllowed(_to)));\n', '        _;\n', '    }\n', '\n', '}']