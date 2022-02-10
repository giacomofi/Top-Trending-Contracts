['pragma solidity ^0.4.17;\n', '\n', 'contract ERC223ReceivingContract {\n', '\n', '    function tokenFallback(address _from, uint256 _value, bytes _data) public;\n', '}\n', '\n', 'contract Token {\n', '\n', '    uint256 public totalSupply;\n', '\n', '\n', '    //ERC 20\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '\n', '    // ERC 223\n', '    function transfer(address _to, uint256 _value, bytes _data) public returns (bool success);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '}\n', '\n', '\n', 'contract StandardToken is Token {\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != 0x0);\n', '        require(_to != address(this));\n', '        require(balances[msg.sender] >= _value);\n', '        require(balances[_to] + _value >= balances[_to]);\n', '\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '\n', '        Transfer(msg.sender, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function transfer(\n', '        address _to,\n', '        uint256 _value,\n', '        bytes _data)\n', '        public\n', '        returns (bool)\n', '    {\n', '        require(transfer(_to, _value));\n', '\n', '        uint codeLength;\n', '\n', '        assembly {\n', '            // Retrieve the size of the code on target address, this needs assembly.\n', '            codeLength := extcodesize(_to)\n', '        }\n', '\n', '        if (codeLength > 0) {\n', '            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '            receiver.tokenFallback(msg.sender, _value, _data);\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value)\n', '        public\n', '        returns (bool)\n', '    {\n', '        require(_from != 0x0);\n', '        require(_to != 0x0);\n', '        require(_to != address(this));\n', '        require(balances[_from] >= _value);\n', '        require(allowed[_from][msg.sender] >= _value);\n', '        require(balances[_to] + _value >= balances[_to]);\n', '\n', '        balances[_to] += _value;\n', '        balances[_from] -= _value;\n', '        allowed[_from][msg.sender] -= _value;\n', '\n', '        Transfer(_from, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        require(_spender != 0x0);\n', '\n', '        require(_value == 0 || allowed[msg.sender][_spender] == 0);\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender)\n', '        constant\n', '        public\n', '        returns (uint256)\n', '    {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function balanceOf(address _owner) constant public returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '}\n', '\n', '\n', 'contract CalorieCoin is StandardToken {\n', '\n', '    string constant public name = "CalorieCoin";\n', '    string constant public symbol = "CAL";\n', '    uint8 constant public decimals = 18;\n', '    uint constant multiplier = 1000000000000000000;\n', '\n', '    event Deployed(uint indexed _total_supply);\n', '    event Burnt(\n', '        address indexed _receiver,\n', '        uint indexed _num,\n', '        uint indexed _total_supply\n', '    );\n', '\n', '    function CalorieCoin(\n', '        address wallet_address,\n', '        uint initial_supply)\n', '        public\n', '    {\n', '        require(wallet_address != 0x0);\n', '\n', '        totalSupply = initial_supply;\n', '\n', '        balances[wallet_address] = initial_supply;\n', '\n', '        Transfer(0x0, wallet_address, balances[wallet_address]);\n', '\n', '        Deployed(totalSupply);\n', '\n', '        assert(totalSupply == balances[wallet_address]);\n', '    }\n', '\n', '    function burn(uint num) public {\n', '        require(num > 0);\n', '        require(balances[msg.sender] >= num);\n', '        require(totalSupply >= num);\n', '\n', '        uint pre_balance = balances[msg.sender];\n', '\n', '        balances[msg.sender] -= num;\n', '        totalSupply -= num;\n', '        Burnt(msg.sender, num, totalSupply);\n', '        Transfer(msg.sender, 0x0, num);\n', '\n', '        assert(balances[msg.sender] == pre_balance - num);\n', '    }\n', '\n', '}']