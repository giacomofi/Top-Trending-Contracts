['pragma solidity ^0.4.20;\n', '\n', 'contract ERC20Interface {\n', '    function totalSupply() constant returns (uint256 supply) {}\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {}\n', '    function transfer(address _to, uint256 _value) returns (bool success) {}\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}\n', '    function approve(address _spender, uint256 _value) returns (bool success) {}\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract StandardToken is ERC20Interface {\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    uint256 public totalSupply;\n', '}\n', '\n', 'contract SafeMath {\n', '    function mul(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint a, uint b) internal pure returns (uint) {\n', '        assert(b > 0);\n', '        uint c = a / b;\n', '        assert(a == b * c + a % b);\n', '        return c;\n', '    }\n', '\n', '    function sub(uint a, uint b) internal pure returns (uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function pow(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a ** b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '  address public ownerWallet;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  function Ownable() public {\n', '    ownerWallet = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == ownerWallet);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(ownerWallet, newOwner);\n', '    ownerWallet = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract Token is StandardToken, SafeMath, Ownable {\n', '\n', '    function withDecimals(uint number, uint decimals)\n', '        internal\n', '        pure\n', '        returns (uint)\n', '    {\n', '        return mul(number, pow(10, decimals));\n', '    }\n', '\n', '}\n', '\n', 'contract Apen is Token {\n', '\n', '    string public name;                   \n', '    uint8 public decimals;                \n', '    string public symbol;                 \n', '    string public version = &#39;A1.1&#39;; \n', '    uint256 public unitsPerEth;     \n', '    uint256 public maxApenSell;         \n', '    uint256 public totalEthPos;  \n', '    address public ownerWallet;           \n', '\n', '    function Apen() public {\n', '        decimals = 18;   \n', '        totalSupply = withDecimals(21000000, decimals); \n', '        balances[msg.sender] = totalSupply;  \n', '        maxApenSell = div(totalSupply, 2);         \n', '        name = "Apen";                                             \n', '        symbol = "APEN";                                 \n', '        unitsPerEth = 1000;                           \n', '    }\n', '\n', '    function() public payable{\n', '        \n', '        uint256 amount = mul(msg.value, unitsPerEth);\n', '        require(balances[ownerWallet] >= amount);\n', '        require(balances[ownerWallet] >= maxApenSell);\n', '\n', '        balances[ownerWallet] = sub(balances[ownerWallet], amount);\n', '        maxApenSell = sub(maxApenSell, amount);\n', '        balances[msg.sender] = add(balances[msg.sender], amount);\n', '\n', '        Transfer(ownerWallet, msg.sender, amount);\n', '\n', '        totalEthPos = add(totalEthPos, msg.value);\n', '\n', '        ownerWallet.transfer(msg.value);                               \n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }\n', '        return true;\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.20;\n', '\n', 'contract ERC20Interface {\n', '    function totalSupply() constant returns (uint256 supply) {}\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {}\n', '    function transfer(address _to, uint256 _value) returns (bool success) {}\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}\n', '    function approve(address _spender, uint256 _value) returns (bool success) {}\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract StandardToken is ERC20Interface {\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    uint256 public totalSupply;\n', '}\n', '\n', 'contract SafeMath {\n', '    function mul(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint a, uint b) internal pure returns (uint) {\n', '        assert(b > 0);\n', '        uint c = a / b;\n', '        assert(a == b * c + a % b);\n', '        return c;\n', '    }\n', '\n', '    function sub(uint a, uint b) internal pure returns (uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function pow(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a ** b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '  address public ownerWallet;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  function Ownable() public {\n', '    ownerWallet = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == ownerWallet);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(ownerWallet, newOwner);\n', '    ownerWallet = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract Token is StandardToken, SafeMath, Ownable {\n', '\n', '    function withDecimals(uint number, uint decimals)\n', '        internal\n', '        pure\n', '        returns (uint)\n', '    {\n', '        return mul(number, pow(10, decimals));\n', '    }\n', '\n', '}\n', '\n', 'contract Apen is Token {\n', '\n', '    string public name;                   \n', '    uint8 public decimals;                \n', '    string public symbol;                 \n', "    string public version = 'A1.1'; \n", '    uint256 public unitsPerEth;     \n', '    uint256 public maxApenSell;         \n', '    uint256 public totalEthPos;  \n', '    address public ownerWallet;           \n', '\n', '    function Apen() public {\n', '        decimals = 18;   \n', '        totalSupply = withDecimals(21000000, decimals); \n', '        balances[msg.sender] = totalSupply;  \n', '        maxApenSell = div(totalSupply, 2);         \n', '        name = "Apen";                                             \n', '        symbol = "APEN";                                 \n', '        unitsPerEth = 1000;                           \n', '    }\n', '\n', '    function() public payable{\n', '        \n', '        uint256 amount = mul(msg.value, unitsPerEth);\n', '        require(balances[ownerWallet] >= amount);\n', '        require(balances[ownerWallet] >= maxApenSell);\n', '\n', '        balances[ownerWallet] = sub(balances[ownerWallet], amount);\n', '        maxApenSell = sub(maxApenSell, amount);\n', '        balances[msg.sender] = add(balances[msg.sender], amount);\n', '\n', '        Transfer(ownerWallet, msg.sender, amount);\n', '\n', '        totalEthPos = add(totalEthPos, msg.value);\n', '\n', '        ownerWallet.transfer(msg.value);                               \n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }\n', '        return true;\n', '    }\n', '\n', '}']