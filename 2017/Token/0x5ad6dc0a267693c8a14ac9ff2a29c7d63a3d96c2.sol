['pragma solidity ^0.4.8;\n', '\n', '\n', 'contract MP3Coin {\n', '    string public constant symbol = "MP3";\n', '\n', '    string public constant name = "MP3 Coin";\n', '\n', '    string public constant slogan = "Make Music Great Again";\n', '\n', '    uint public constant decimals = 8;\n', '\n', '    uint public totalSupply = 1000000 * 10 ** decimals;\n', '\n', '    address owner;\n', '\n', '    mapping (address => uint) balances;\n', '\n', '    mapping (address => mapping (address => uint)) allowed;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '\n', '    function MP3Coin() public {\n', '        owner = msg.sender;\n', '        balances[owner] = totalSupply;\n', '        Transfer(this, owner, totalSupply);\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function transfer(address _to, uint _amount) public returns (bool success) {\n', '        require(_amount > 0 && balances[msg.sender] >= _amount);\n', '        balances[msg.sender] -= _amount;\n', '        balances[_to] += _amount;\n', '        Transfer(msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {\n', '        require(_amount > 0 && balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount);\n', '        balances[_from] -= _amount;\n', '        allowed[_from][msg.sender] -= _amount;\n', '        balances[_to] += _amount;\n', '        Transfer(_from, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint _amount) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _amount;\n', '        Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '\n', '    function distribute(address[] _addresses, uint[] _amounts) public returns (bool success) {\n', '        // Checkout input data\n', '        require(_addresses.length < 256 && _addresses.length == _amounts.length);\n', '        // Calculate total amount\n', '        uint totalAmount;\n', '        for (uint a = 0; a < _amounts.length; a++) {\n', '            totalAmount += _amounts[a];\n', '        }\n', '        // Checkout account balance\n', '        require(totalAmount > 0 && balances[msg.sender] >= totalAmount);\n', '        // Deduct amount from sender\n', '        balances[msg.sender] -= totalAmount;\n', '        // Transfer amounts to receivers\n', '        for (uint b = 0; b < _addresses.length; b++) {\n', '            if (_amounts[b] > 0) {\n', '                balances[_addresses[b]] += _amounts[b];\n', '                Transfer(msg.sender, _addresses[b], _amounts[b]);\n', '            }\n', '        }\n', '        return true;\n', '    }\n', '}']