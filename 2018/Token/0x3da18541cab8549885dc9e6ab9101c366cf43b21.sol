['pragma solidity ^0.4.24;\n', '\n', '//設定管理者//\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() {\n', '        owner = msg.sender;\n', '    }\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '}    \n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', 'contract Leimen is owned{\n', '    \n', '//設定初始值//\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event FrozenFunds(address target, bool frozen);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 2;\n', '    uint256 public totalSupply;\n', '    \n', '//初始化//\n', '\n', '    function Leimen() public {\n', '\t    totalSupply = 1000000000 * 100 ;\n', '    \tbalanceOf[msg.sender] = totalSupply ;\n', '        name = "Leimen test";\n', '        symbol = "Lts";         \n', '    }\n', '    \n', '//管理權限//\n', '\n', '    mapping (address => bool) public frozenAccount;\n', '    uint256 public eth_amount ;\n', '    bool public stoptransfer ;\n', '    bool public stopsell;\n', '    \n', '\n', '    function freezeAccount(address target, bool freeze) onlyOwner {\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '\n', '    function set_prices(uint256 _eth_amount) onlyOwner {\n', '        eth_amount  = _eth_amount  ;\n', '    }\n', '\n', '    function withdraw_Leim(uint256 amount)  onlyOwner {\n', '        require(balanceOf[this] >= amount) ;\n', '        balanceOf[this] -= amount ;\n', '        balanceOf[msg.sender] += amount ;\n', '    }\n', '    \n', '    function withdraw_Eth(uint amount_wei) onlyOwner {\n', '        msg.sender.transfer(amount_wei) ;\n', '    }\n', '    \n', '    function set_Name(string _name) onlyOwner {\n', '        name = _name;\n', '    }\n', '    \n', '    function set_symbol(string _symbol) onlyOwner {\n', '        symbol = _symbol;\n', '    }\n', '    \n', '    function set_stopsell(bool _stopsell) onlyOwner {\n', '        stopsell = _stopsell;\n', '    }\n', '    \n', '    function set_stoptransfer(bool _stoptransfer) onlyOwner {\n', '        stoptransfer = _stoptransfer;\n', '    }\n', '    \n', '    function burn(uint256 _value) onlyOwner {\n', '        require(_value > 0);\n', '        require(balanceOf[msg.sender] >= _value);   \n', '        balanceOf[msg.sender] -= _value;            \n', '        totalSupply -= _value;                      \n', '        Burn(msg.sender, _value);\n', '    }    \n', '\n', '//交易//\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '\t    require(!frozenAccount[_from]);\n', '\t    require(!stoptransfer);\n', '        require(_to != 0x0);\n', '        \n', '        require(_value >= 0);\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        \n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '\t    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]); \n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '//販售\n', '\n', '    function () payable {\n', '        buy();\n', '    }\n', '\n', '    function buy() payable returns (uint amount){\n', '\t    require(!stopsell);\n', '        amount = msg.value * eth_amount / (10 ** 18) ;\n', '        require(balanceOf[this] >= amount);           \n', '        balanceOf[msg.sender] += amount;           \n', '        balanceOf[this] -= amount; \n', '        Transfer(this, msg.sender, amount);         \n', '        return amount;    \n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '//設定管理者//\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() {\n', '        owner = msg.sender;\n', '    }\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '}    \n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', 'contract Leimen is owned{\n', '    \n', '//設定初始值//\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event FrozenFunds(address target, bool frozen);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 2;\n', '    uint256 public totalSupply;\n', '    \n', '//初始化//\n', '\n', '    function Leimen() public {\n', '\t    totalSupply = 1000000000 * 100 ;\n', '    \tbalanceOf[msg.sender] = totalSupply ;\n', '        name = "Leimen test";\n', '        symbol = "Lts";         \n', '    }\n', '    \n', '//管理權限//\n', '\n', '    mapping (address => bool) public frozenAccount;\n', '    uint256 public eth_amount ;\n', '    bool public stoptransfer ;\n', '    bool public stopsell;\n', '    \n', '\n', '    function freezeAccount(address target, bool freeze) onlyOwner {\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '\n', '    function set_prices(uint256 _eth_amount) onlyOwner {\n', '        eth_amount  = _eth_amount  ;\n', '    }\n', '\n', '    function withdraw_Leim(uint256 amount)  onlyOwner {\n', '        require(balanceOf[this] >= amount) ;\n', '        balanceOf[this] -= amount ;\n', '        balanceOf[msg.sender] += amount ;\n', '    }\n', '    \n', '    function withdraw_Eth(uint amount_wei) onlyOwner {\n', '        msg.sender.transfer(amount_wei) ;\n', '    }\n', '    \n', '    function set_Name(string _name) onlyOwner {\n', '        name = _name;\n', '    }\n', '    \n', '    function set_symbol(string _symbol) onlyOwner {\n', '        symbol = _symbol;\n', '    }\n', '    \n', '    function set_stopsell(bool _stopsell) onlyOwner {\n', '        stopsell = _stopsell;\n', '    }\n', '    \n', '    function set_stoptransfer(bool _stoptransfer) onlyOwner {\n', '        stoptransfer = _stoptransfer;\n', '    }\n', '    \n', '    function burn(uint256 _value) onlyOwner {\n', '        require(_value > 0);\n', '        require(balanceOf[msg.sender] >= _value);   \n', '        balanceOf[msg.sender] -= _value;            \n', '        totalSupply -= _value;                      \n', '        Burn(msg.sender, _value);\n', '    }    \n', '\n', '//交易//\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '\t    require(!frozenAccount[_from]);\n', '\t    require(!stoptransfer);\n', '        require(_to != 0x0);\n', '        \n', '        require(_value >= 0);\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        \n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '\t    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]); \n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '//販售\n', '\n', '    function () payable {\n', '        buy();\n', '    }\n', '\n', '    function buy() payable returns (uint amount){\n', '\t    require(!stopsell);\n', '        amount = msg.value * eth_amount / (10 ** 18) ;\n', '        require(balanceOf[this] >= amount);           \n', '        balanceOf[msg.sender] += amount;           \n', '        balanceOf[this] -= amount; \n', '        Transfer(this, msg.sender, amount);         \n', '        return amount;    \n', '    }\n', '}']