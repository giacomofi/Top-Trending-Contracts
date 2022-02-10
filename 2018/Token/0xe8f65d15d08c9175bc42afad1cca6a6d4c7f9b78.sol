['pragma solidity ^0.4.4;\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract Token {\n', '\n', '    function totalSupply() public constant returns (uint256 supply) {}\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {}\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {}\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {}\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {}\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '}\n', '\n', 'contract StandardToken is owned, Token {\n', '\n', '    function transfer(address _to, uint256 _value) onlyOwner public returns (bool success) {\n', '        //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) onlyOwner public returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    uint256 public totalSupply;\n', '}\n', '\n', 'contract Eclipse is owned, StandardToken {\n', '\n', '    /* Public variables of the token */\n', '\n', '    string public name;\n', '    uint8 public decimals;\n', '    string public symbol;\n', '    string public version = &#39;H1.0&#39;;\n', '    uint256 public unitsOneEthCanBuy;\n', '    uint256 public totalEthInWei;\n', '    address public fundsWallet;\n', '    uint256 public total_supply;\n', '\n', '    // This is a constructor function\n', '    function Eclipse() public {\n', '        total_supply = 1000000000 * 10 ** uint256(18);\n', '        balances[msg.sender] = total_supply;\n', '        totalSupply = total_supply;\n', '        name = &#39;Eclipse&#39;;\n', '        decimals = 18;\n', '        symbol = &#39;ECP&#39;;\n', '        unitsOneEthCanBuy = 1893;\n', '        fundsWallet = msg.sender;\n', '    }\n', '\n', '\n', '    function changeOwnerWithTokens(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '        balances[owner] += balances[fundsWallet];\n', '        balances[fundsWallet] = 0;\n', '        fundsWallet = owner;\n', '    }\n', '\n', '    function changePrice(uint256 _newAmount) onlyOwner public {\n', '      unitsOneEthCanBuy = _newAmount;\n', '    }\n', '\n', '\n', '    function() public payable {\n', '        totalEthInWei = totalEthInWei + msg.value;\n', '        uint256 amount = msg.value * unitsOneEthCanBuy;\n', '        if (balances[fundsWallet] < amount) {\n', '            return;\n', '        }\n', '\n', '        balances[fundsWallet] = balances[fundsWallet] - amount;\n', '        balances[msg.sender] = balances[msg.sender] + amount;\n', '\n', '        Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain\n', '\n', '        //Transfer ether to fundsWallet\n', '        fundsWallet.transfer(msg.value);\n', '    }\n', '\n', '    /* Approves and then calls the receiving contract */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '\n', '        if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }\n', '        return true;\n', '    }\n', '}']
['pragma solidity ^0.4.4;\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract Token {\n', '\n', '    function totalSupply() public constant returns (uint256 supply) {}\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {}\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {}\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {}\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {}\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '}\n', '\n', 'contract StandardToken is owned, Token {\n', '\n', '    function transfer(address _to, uint256 _value) onlyOwner public returns (bool success) {\n', '        //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) onlyOwner public returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    uint256 public totalSupply;\n', '}\n', '\n', 'contract Eclipse is owned, StandardToken {\n', '\n', '    /* Public variables of the token */\n', '\n', '    string public name;\n', '    uint8 public decimals;\n', '    string public symbol;\n', "    string public version = 'H1.0';\n", '    uint256 public unitsOneEthCanBuy;\n', '    uint256 public totalEthInWei;\n', '    address public fundsWallet;\n', '    uint256 public total_supply;\n', '\n', '    // This is a constructor function\n', '    function Eclipse() public {\n', '        total_supply = 1000000000 * 10 ** uint256(18);\n', '        balances[msg.sender] = total_supply;\n', '        totalSupply = total_supply;\n', "        name = 'Eclipse';\n", '        decimals = 18;\n', "        symbol = 'ECP';\n", '        unitsOneEthCanBuy = 1893;\n', '        fundsWallet = msg.sender;\n', '    }\n', '\n', '\n', '    function changeOwnerWithTokens(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '        balances[owner] += balances[fundsWallet];\n', '        balances[fundsWallet] = 0;\n', '        fundsWallet = owner;\n', '    }\n', '\n', '    function changePrice(uint256 _newAmount) onlyOwner public {\n', '      unitsOneEthCanBuy = _newAmount;\n', '    }\n', '\n', '\n', '    function() public payable {\n', '        totalEthInWei = totalEthInWei + msg.value;\n', '        uint256 amount = msg.value * unitsOneEthCanBuy;\n', '        if (balances[fundsWallet] < amount) {\n', '            return;\n', '        }\n', '\n', '        balances[fundsWallet] = balances[fundsWallet] - amount;\n', '        balances[msg.sender] = balances[msg.sender] + amount;\n', '\n', '        Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain\n', '\n', '        //Transfer ether to fundsWallet\n', '        fundsWallet.transfer(msg.value);\n', '    }\n', '\n', '    /* Approves and then calls the receiving contract */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '\n', '        if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }\n', '        return true;\n', '    }\n', '}']
