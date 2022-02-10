['pragma solidity ^0.4.19;\n', '\n', '/* taking ideas from OpenZeppelin, thanks*/\n', 'contract SafeMath {\n', '    function safeAdd(uint256 x, uint256 y) internal pure returns (uint256) {\n', '        uint256 z = x + y;\n', '        assert((z >= x) && (z >= y));\n', '        return z;\n', '    }\n', '\n', '    function safeSub(uint256 x, uint256 y) internal pure returns (uint256) {\n', '        assert(x >= y);\n', '        return x - y;\n', '    }\n', '}\n', '\n', 'contract Token {\n', '    uint256 public totalSupply;\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '/* ERC 20 token */\n', 'contract StandardToken is Token, SafeMath {\n', '    mapping(address => uint256) public balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '\n', '    // prvent from the ERC20 short address attack\n', '    modifier onlyPayloadSize(uint size) {\n', '        require(msg.data.length >= size + 4);\n', '        _;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool success) {\n', '        require(_to != 0x0);\n', '        balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3 * 32) returns (bool success) {\n', '        balances[_from] = safeSub(balances[_from], _value);\n', '        allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', 'contract XCTToken is StandardToken {\n', '    //meta data\n', '    string public constant name = "XChain Token";\n', '    string public constant symbol = "NXCT";\n', '    uint8 public constant decimals = 18;\n', '\n', '    function XCTToken() public {\n', '        // 3.2b Coins in total, destroyed 130m, left 3.07b\n', '        totalSupply = 307 * 10**25;\n', '        balances[msg.sender] = totalSupply;\n', '    }\n', '}']
['pragma solidity ^0.4.19;\n', '\n', '/* taking ideas from OpenZeppelin, thanks*/\n', 'contract SafeMath {\n', '    function safeAdd(uint256 x, uint256 y) internal pure returns (uint256) {\n', '        uint256 z = x + y;\n', '        assert((z >= x) && (z >= y));\n', '        return z;\n', '    }\n', '\n', '    function safeSub(uint256 x, uint256 y) internal pure returns (uint256) {\n', '        assert(x >= y);\n', '        return x - y;\n', '    }\n', '}\n', '\n', 'contract Token {\n', '    uint256 public totalSupply;\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '/* ERC 20 token */\n', 'contract StandardToken is Token, SafeMath {\n', '    mapping(address => uint256) public balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '\n', '    // prvent from the ERC20 short address attack\n', '    modifier onlyPayloadSize(uint size) {\n', '        require(msg.data.length >= size + 4);\n', '        _;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool success) {\n', '        require(_to != 0x0);\n', '        balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3 * 32) returns (bool success) {\n', '        balances[_from] = safeSub(balances[_from], _value);\n', '        allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', 'contract XCTToken is StandardToken {\n', '    //meta data\n', '    string public constant name = "XChain Token";\n', '    string public constant symbol = "NXCT";\n', '    uint8 public constant decimals = 18;\n', '\n', '    function XCTToken() public {\n', '        // 3.2b Coins in total, destroyed 130m, left 3.07b\n', '        totalSupply = 307 * 10**25;\n', '        balances[msg.sender] = totalSupply;\n', '    }\n', '}']
