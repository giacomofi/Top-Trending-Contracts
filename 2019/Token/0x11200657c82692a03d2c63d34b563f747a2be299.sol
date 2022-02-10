['pragma solidity >=0.4.22 <0.7.0;\n', '\n', 'library BalancesLib {\n', '    function move(mapping(address => uint) storage balances, address _from, address _to, uint _amount) internal {\n', '        require(balances[_from] >= _amount);\n', '        require(balances[_to] + _amount >= balances[_to]);\n', '        balances[_from] -= _amount;\n', '        balances[_to] += _amount;\n', '    }\n', '}\n', '\n', 'contract Token {\n', '    function balanceOf(address _owner) view public returns (uint balance);\n', '    function transfer(address _to, uint _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success);\n', '    function approve(address _spender, uint _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) view public returns (uint remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '    }\n', '\n', 'contract StandardERC20Token is Token {\n', '    uint totalSupplyValue;\n', '    address public owner;\n', '    \n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '    \n', '     modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function totalSupply() public view returns (uint _totalSupply) {\n', '        _totalSupply=totalSupplyValue;\n', '    }\n', '    \n', '    function transfer(address _to, uint _value) public returns (bool success) {\n', '        require(!frozenAccount[msg.sender]);\n', '        require(_to != address(0));\n', '        balances.move(msg.sender, _to, _value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '\t    return true;\n', '    }\n', '    \n', '\n', '    function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {\n', '        require(!frozenAccount[_from]);                         \n', '        require(!frozenAccount[_to]);                           \n', '        require(_to != address(0));\n', '        require(allowed[_from][msg.sender] >= _amount);\n', '        allowed[_from][msg.sender] -= _amount;\n', '        balances.move(_from, _to, _amount);\n', '        emit Transfer(_from, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint _tokens) public returns (bool success) {\n', '        require(allowed[msg.sender][_spender] == 0, "");\n', '        allowed[msg.sender][_spender] = _tokens;\n', '        emit Approval(msg.sender, _spender, _tokens);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) view public returns (uint remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '   \n', '    function freezeAccount(address _target, bool _freeze) public onlyOwner{\n', '        frozenAccount[_target] = _freeze;\n', '        emit FrozenFunds(_target, _freeze);\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Owner can transfer out any accidentally sent ERC20 tokens\n', '    // ------------------------------------------------------------------------\n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '        return Token(tokenAddress).transfer(owner, tokens);\n', '    }\n', '\n', '    mapping (address => bool) public frozenAccount;\n', '    mapping (address => uint) balances;\n', '    mapping (address => mapping (address => uint)) allowed;\n', '    event FrozenFunds(address target, bool frozen);\n', '    using BalancesLib for *;\n', '}\n', '\n', 'contract AppUcoin is StandardERC20Token {\n', '\n', 'function () external payable{\n', '        //if ether is sent to this address, send it back.\n', '        revert();\n', '}\n', '    string public name;                 \n', '    uint8 public decimals;               \n', '    string public symbol;                \n', "    string public version = '1.0'; \n", '    \n', '    constructor () public{\n', '        balances[msg.sender] = 1769520000000000;              \n', '        totalSupplyValue = 1769520000000000;                       \n', '        name = "AppUcoin";                                   \n', '        decimals = 8;                                               \n', '        symbol = "AU";      \n', '   }\n', '}']