['pragma solidity ^0.4.18;\n', '\n', '\n', 'contract Token {\n', '    function balanceOf(address _account) public constant returns (uint256 balance);\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '}\n', '\n', '\n', 'contract RocketCoin {\n', '    string public constant symbol = "XRC";\n', '\n', '    string public constant name = "Rocket Coin";\n', '\n', '    uint public constant decimals = 18;\n', '\n', '    uint public constant totalSupply = 10000000 * 10 ** decimals;\n', '\n', '    address owner;\n', '\n', '    bool airDropStatus = true;\n', '\n', '    uint airDropAmount = 300 * 10 ** decimals;\n', '\n', '    uint airDropGasPrice = 20 * 10 ** 9;\n', '\n', '    mapping (address => bool) participants;\n', '\n', '    mapping (address => uint256) balances;\n', '\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    function RocketCoin() public {\n', '        owner = msg.sender;\n', '        balances[owner] = totalSupply;\n', '        Transfer(address(0), owner, totalSupply);\n', '    }\n', '\n', '    function() public payable {\n', '        require(airDropStatus && balances[owner] >= airDropAmount && !participants[msg.sender] && tx.gasprice >= airDropGasPrice);\n', '        balances[owner] -= airDropAmount;\n', '        balances[msg.sender] += airDropAmount;\n', '        Transfer(owner, msg.sender, airDropAmount);\n', '        participants[msg.sender] = true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function transfer(address _to, uint256 _amount) public returns (bool success) {\n', '        require(balances[msg.sender] >= _amount && _amount > 0);\n', '        balances[msg.sender] -= _amount;\n', '        balances[_to] += _amount;\n', '        Transfer(msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    function multiTransfer(address[] _addresses, uint[] _amounts) public returns (bool success) {\n', '        require(_addresses.length <= 100 && _addresses.length == _amounts.length);\n', '        uint totalAmount;\n', '        for (uint a = 0; a < _amounts.length; a++) {\n', '            totalAmount += _amounts[a];\n', '        }\n', '        require(totalAmount > 0 && balances[msg.sender] >= totalAmount);\n', '        balances[msg.sender] -= totalAmount;\n', '        for (uint b = 0; b < _addresses.length; b++) {\n', '            if (_amounts[b] > 0) {\n', '                balances[_addresses[b]] += _amounts[b];\n', '                Transfer(msg.sender, _addresses[b], _amounts[b]);\n', '            }\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {\n', '        require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0);\n', '        balances[_from] -= _amount;\n', '        allowed[_from][msg.sender] -= _amount;\n', '        balances[_to] += _amount;\n', '        Transfer(_from, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _amount) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _amount;\n', '        Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '\n', '    function setupAirDrop(bool _status, uint _amount, uint _Gwei) public returns (bool success) {\n', '        require(msg.sender == owner);\n', '        airDropStatus = _status;\n', '        airDropAmount = _amount * 10 ** decimals;\n', '        airDropGasPrice = _Gwei * 10 ** 9;\n', '        return true;\n', '    }\n', '\n', '    function withdrawFunds(address _token) public returns (bool success) {\n', '        require(msg.sender == owner);\n', '        if (_token == address(0)) {\n', '            owner.transfer(this.balance);\n', '        }\n', '        else {\n', '            Token ERC20 = Token(_token);\n', '            ERC20.transfer(owner, ERC20.balanceOf(this));\n', '        }\n', '        return true;\n', '    }\n', '}']