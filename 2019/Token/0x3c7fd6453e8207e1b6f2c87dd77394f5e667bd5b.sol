['pragma solidity ^0.4.23;\n', '\n', '\n', '/**\n', ' * @title IERC20Token - ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract IERC20Token {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value)  public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value)  public returns (bool success);\n', '    function approve(address _spender, uint256 _value)  public returns (bool success);\n', '    function allowance(address _owner, address _spender)  public constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'contract SafeMath {\n', '    /**\n', '    * @dev constructor\n', '    */\n', '    constructor() public {\n', '    }\n', '\n', '    function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(a >= b);\n', '        return a - b;\n', '    }\n', '\n', '    function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20Token - ERC20 base implementation\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20Token is IERC20Token, SafeMath {\n', '    mapping (address => uint256) public balances;\n', '    mapping (address => mapping (address => uint256)) public allowed;\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(balances[msg.sender] >= _value);\n', '\n', '        balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);\n', '\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        balances[_from] = safeSub(balances[_from], _value);\n', '        allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', 'contract BlessToken is ERC20Token {\n', '\n', '    uint256 public mintTotal;\n', '    address public owner;\n', '\n', '    event Mint(address _toAddress, uint256 _amount);\n', '\n', '    constructor(address _owner) public {\n', '        require(address(0) != _owner);\n', '\n', '        name = "BlessToken";\n', '        symbol = "BSS";\n', '        decimals = 18;\n', '        totalSupply = 1* 1000 * 1000 *1000 * 10**uint256(decimals);\n', '\n', '        mintTotal = 0;\n', '        owner = _owner;\n', '    }\n', '\n', '    function mint (address _toAddress, uint256 _amount) public returns (bool) {\n', '        require(msg.sender == owner);\n', '        require(address(0) != _toAddress);\n', '        require(_amount >= 0);\n', '        require( safeAdd(_amount,mintTotal) <= totalSupply);\n', '\n', '        mintTotal = safeAdd(_amount, mintTotal);\n', '        balances[_toAddress] = safeAdd(balances[_toAddress], _amount);\n', '\n', '        emit Mint(_toAddress, _amount);\n', '        return (true);\n', '    }\n', '\n', '    function() public payable {\n', '        revert();\n', '    }\n', '}']