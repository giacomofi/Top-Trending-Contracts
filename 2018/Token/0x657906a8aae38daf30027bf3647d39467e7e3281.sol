['pragma solidity ^0.4.18;\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function max64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function max256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '}\n', 'contract Ownable {\n', '    address public owner;\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        if (msg.sender != owner) {\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '\n', '    function destruct() public onlyOwner {\n', '        selfdestruct(owner);\n', '    }\n', '}\n', 'contract ERC20Basic {\n', '    function balanceOf(address who) public constant returns (uint256);\n', '    function transfer(address to, uint256 value) public;\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public;\n', '    function approve(address spender, uint256 value) public;\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '    uint256 public totalSupply;\n', '\n', '    modifier onlyPayloadSize(uint256 size) {\n', '        if(msg.data.length < size + 4) {\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) {\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', 'contract StandardToken is BasicToken, ERC20 {\n', '\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3 * 32) {\n', '        var _allowance = allowed[_from][msg.sender];\n', '        balances[_to] = balances[_to].add(_value);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        allowed[_from][msg.sender] = _allowance.sub(_value);\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public {\n', '        if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '}\n', 'contract GXCH is StandardToken, Ownable {\n', '\n', '    string public constant name = "星河链";\n', '    string public constant symbol = "GXCH";\n', '    uint256 public constant decimals = 8;\n', '\n', '    function GXCH() public {\n', '        owner = msg.sender;\n', '        totalSupply=13000000000000000;\n', '        balances[owner]=totalSupply;\n', '    }\n', '\n', '    function () public {\n', '        revert();\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function max64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function max256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '}\n', 'contract Ownable {\n', '    address public owner;\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        if (msg.sender != owner) {\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '\n', '    function destruct() public onlyOwner {\n', '        selfdestruct(owner);\n', '    }\n', '}\n', 'contract ERC20Basic {\n', '    function balanceOf(address who) public constant returns (uint256);\n', '    function transfer(address to, uint256 value) public;\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public;\n', '    function approve(address spender, uint256 value) public;\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '    uint256 public totalSupply;\n', '\n', '    modifier onlyPayloadSize(uint256 size) {\n', '        if(msg.data.length < size + 4) {\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) {\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', 'contract StandardToken is BasicToken, ERC20 {\n', '\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3 * 32) {\n', '        var _allowance = allowed[_from][msg.sender];\n', '        balances[_to] = balances[_to].add(_value);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        allowed[_from][msg.sender] = _allowance.sub(_value);\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public {\n', '        if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '}\n', 'contract GXCH is StandardToken, Ownable {\n', '\n', '    string public constant name = "星河链";\n', '    string public constant symbol = "GXCH";\n', '    uint256 public constant decimals = 8;\n', '\n', '    function GXCH() public {\n', '        owner = msg.sender;\n', '        totalSupply=13000000000000000;\n', '        balances[owner]=totalSupply;\n', '    }\n', '\n', '    function () public {\n', '        revert();\n', '    }\n', '}']
