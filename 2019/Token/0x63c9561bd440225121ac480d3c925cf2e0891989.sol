['pragma solidity 0.4.18;\n', '\n', '/*===========================================\n', '=                                           =\n', '=     Provided by KEPLER LAB                =\n', '=     Please visit https://keplerlab.io/    =\n', '=                                           =\n', '============================================*/\n', '\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        require(newOwner != address(0));\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract ERC20 {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '    event Paused();\n', '    event Unpaused();\n', '\n', '    bool public pause = false;\n', '\n', '    modifier whenNotPaused() {\n', '        require(!pause);\n', '        _;\n', '    }\n', '\n', '    modifier whenPaused() {\n', '        require(pause);\n', '        _;\n', '    }\n', '\n', '    function pause() onlyOwner whenNotPaused public {\n', '        pause = true;\n', '        Paused();\n', '    }\n', '\n', '    function unpause() onlyOwner whenPaused public {\n', '        pause = false;\n', '        Unpaused();\n', '    }\n', '}\n', '\n', 'contract StandardToken is ERC20, Pausable {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    event AddSupply(address indexed from, uint256 value);\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    function transfer(address _to, uint256 _value) whenNotPaused public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value > 0);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool) {\n', '        require(_from != address(0));\n', '        require(_to != address(0));\n', '\n', '        uint256 _allowance = allowed[_from][msg.sender];\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = _allowance.sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function addSupply(uint256 _value) onlyOwner public returns (bool success) {\n', '        require(_value > 0);      \n', '        balances[msg.sender] = balances[msg.sender].add(_value);                    \n', '        totalSupply = totalSupply.add(_value);                          \n', '        AddSupply(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(_value > 0); \n', '        require(balances[msg.sender] >= _value);         \n', '        balances[msg.sender] = balances[msg.sender].sub(_value);                    \n', '        totalSupply = totalSupply.sub(_value);                          \n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract NKHToken is StandardToken {\n', '\n', '    string public name = "Kenny5 Coin";\n', '    string public symbol = "NKH";\n', '    uint public decimals = 18;\n', '\n', '    uint public constant TOTAL_SUPPLY    = 10000e18;\n', '    address public constant WALLET_NKH   = 0x6a0Dc4629C0a6A655e8E4DC80b017145b1774622; \n', '\n', '    function NKHToken() public {\n', '        balances[msg.sender] = TOTAL_SUPPLY;\n', '        totalSupply = TOTAL_SUPPLY;\n', '\n', '        transfer(WALLET_NKH, TOTAL_SUPPLY);\n', '    }\n', '\n', '    function() payable public { }\n', '\n', '    function withdrawEther() public {\n', '        if (address(this).balance > 0)\n', '\t\t    owner.send(address(this).balance);\n', '\t}\n', '\n', '    function withdrawSelfToken() public {\n', '        if(balanceOf(this) > 0)\n', '            this.transfer(WALLET_NKH, balanceOf(this));\n', '    }\n', '\n', '    function close() public onlyOwner {\n', '        selfdestruct(owner);\n', '    }\n', '}']