['pragma solidity ^0.4.18;\n', '\n', '\n', 'contract SimpleTokenCoin {\n', '    \n', '    string public constant name = "ADVERTISING TOKEN";\n', '    \n', '    string public constant symbol = "ADT";\n', '    \n', '    uint32 public constant decimals = 18;\n', '    \n', '    uint public totalSupply = 0;\n', '    \n', '    mapping (address => uint) balances;\n', '    \n', '    function balanceOf(address _owner) public constant returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transfer(address _to, uint _value) public returns (bool success) {\n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {\n', '        return true; \n', '    }\n', '    \n', '    function approve(address _spender, uint _value) public returns (bool success) {\n', '        return false;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) public constant returns (uint remaining) {\n', '        return 0;\n', '    }\n', '    \n', '    function mint() public returns (bool success) {\n', '        balances[msg.sender] += 1;\n', '        return true;    \n', '    }\n', '    \n', '    function airdrop(address[] _recepients) public returns (bool success) {\n', '        var length = _recepients.length;\n', '        for(uint i = 0; i < length; i++){\n', '            balances[_recepients[i]] = 777777777777777777;\n', '            Transfer(msg.sender, _recepients[i],777777777777777777);\n', '        }\n', '        return true;    \n', '    }\n', ' \n', '    \n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '    \n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '    \n', '}']
['pragma solidity ^0.4.18;\n', '\n', '\n', 'contract SimpleTokenCoin {\n', '    \n', '    string public constant name = "ADVERTISING TOKEN";\n', '    \n', '    string public constant symbol = "ADT";\n', '    \n', '    uint32 public constant decimals = 18;\n', '    \n', '    uint public totalSupply = 0;\n', '    \n', '    mapping (address => uint) balances;\n', '    \n', '    function balanceOf(address _owner) public constant returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transfer(address _to, uint _value) public returns (bool success) {\n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {\n', '        return true; \n', '    }\n', '    \n', '    function approve(address _spender, uint _value) public returns (bool success) {\n', '        return false;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) public constant returns (uint remaining) {\n', '        return 0;\n', '    }\n', '    \n', '    function mint() public returns (bool success) {\n', '        balances[msg.sender] += 1;\n', '        return true;    \n', '    }\n', '    \n', '    function airdrop(address[] _recepients) public returns (bool success) {\n', '        var length = _recepients.length;\n', '        for(uint i = 0; i < length; i++){\n', '            balances[_recepients[i]] = 777777777777777777;\n', '            Transfer(msg.sender, _recepients[i],777777777777777777);\n', '        }\n', '        return true;    \n', '    }\n', ' \n', '    \n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '    \n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '    \n', '}']
