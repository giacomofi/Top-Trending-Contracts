['pragma solidity ^0.4.11;\n', '\n', 'contract SwiftDex {\n', '\n', '    string public name = "SwiftDex";      //  token name\n', '    string public symbol = "SWIFD";           //  token symbol\n', '    uint256 public decimals = 18;            //  token digit\n', '    uint256 public price = 360000000000000;\n', '    string public version="test-5.0";\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    uint256 public totalSupply = 0;\n', '    //000000000000000000\n', '    bool public stopped = false;\n', '    uint256 constant decimalFactor = 1000000000000000000;\n', '\n', '    address owner = 0x0;\n', '    address address_ico = 0x82844C2365667561Ccbd0ceBE0043C494fE54D16;\n', '    address address_team = 0xdB96e4AA6c08C0c8730E1497308608195Fa77B31;\n', '    address address_extra = 0x14Eb4D0125769aC89F60A8aA52e114fAe70217Be;\n', '    modifier isOwner {\n', '        assert(owner == msg.sender);\n', '        _;\n', '    }\n', '\n', '    modifier isRunning {\n', '        assert (!stopped);\n', '        _;\n', '    }\n', '\n', '    modifier validAddress {\n', '        assert(0x0 != msg.sender);\n', '        _;\n', '    }\n', '\n', '    function SwiftDex () public {\n', '        owner = msg.sender;\n', '        totalSupply = 200000000000000000000000000;\n', '\n', '        balanceOf[address_ico] = totalSupply * 70 / 100;\n', '        emit Transfer(0x0, address_ico, totalSupply * 70 / 100);\n', '\n', '        balanceOf[address_team] = totalSupply * 15 / 100;\n', '        emit Transfer(0x0, address_team, totalSupply * 15 / 100);\n', '\n', '        balanceOf[address_extra] = totalSupply * 15 / 100;\n', '        emit Transfer(0x0, address_extra, totalSupply * 15 / 100);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public isRunning validAddress returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public isRunning validAddress returns (bool success) {\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        require(allowance[_from][msg.sender] >= _value);\n', '        balanceOf[_to] += _value;\n', '        balanceOf[_from] -= _value;\n', '        allowance[_from][msg.sender] -= _value;\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public isRunning validAddress returns (bool success) {\n', '        require(_value == 0 || allowance[msg.sender][_spender] == 0);\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function buy() public isRunning payable returns (uint amount){\n', '        amount = msg.value * decimalFactor / price;                    // calculates the amount\n', '        require(balanceOf[address_ico] >= amount);               // checks if it has enough to sell\n', '        balanceOf[msg.sender] += amount;                  // adds the amount to buyer&#39;s balance\n', '        balanceOf[address_ico] -= amount;                        // subtracts amount from seller&#39;s balance\n', '        address_ico.transfer(msg.value);\n', '        emit Transfer(address_ico, msg.sender, amount);               // execute an event reflecting the change\n', '        return amount;                                    // ends function and returns\n', '    }\n', '\n', '    function deployTokens(address[] _recipient, uint256[] _values) public isOwner {\n', '        for(uint i = 0; i< _recipient.length; i++)\n', '        {\n', '              balanceOf[_recipient[i]] += _values[i] * decimalFactor;\n', '              balanceOf[address_ico] -= _values[i] * decimalFactor;\n', '              emit Transfer(address_ico, _recipient[i], _values[i] * decimalFactor);\n', '        }\n', '    }\n', '\n', '    function stop() public isOwner {\n', '        stopped = true;\n', '    }\n', '\n', '    function start() public isOwner {\n', '        stopped = false;\n', '    }\n', '\n', '    function setPrice(uint256 _price) public isOwner {\n', '        price = _price;\n', '    }\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}']
['pragma solidity ^0.4.11;\n', '\n', 'contract SwiftDex {\n', '\n', '    string public name = "SwiftDex";      //  token name\n', '    string public symbol = "SWIFD";           //  token symbol\n', '    uint256 public decimals = 18;            //  token digit\n', '    uint256 public price = 360000000000000;\n', '    string public version="test-5.0";\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    uint256 public totalSupply = 0;\n', '    //000000000000000000\n', '    bool public stopped = false;\n', '    uint256 constant decimalFactor = 1000000000000000000;\n', '\n', '    address owner = 0x0;\n', '    address address_ico = 0x82844C2365667561Ccbd0ceBE0043C494fE54D16;\n', '    address address_team = 0xdB96e4AA6c08C0c8730E1497308608195Fa77B31;\n', '    address address_extra = 0x14Eb4D0125769aC89F60A8aA52e114fAe70217Be;\n', '    modifier isOwner {\n', '        assert(owner == msg.sender);\n', '        _;\n', '    }\n', '\n', '    modifier isRunning {\n', '        assert (!stopped);\n', '        _;\n', '    }\n', '\n', '    modifier validAddress {\n', '        assert(0x0 != msg.sender);\n', '        _;\n', '    }\n', '\n', '    function SwiftDex () public {\n', '        owner = msg.sender;\n', '        totalSupply = 200000000000000000000000000;\n', '\n', '        balanceOf[address_ico] = totalSupply * 70 / 100;\n', '        emit Transfer(0x0, address_ico, totalSupply * 70 / 100);\n', '\n', '        balanceOf[address_team] = totalSupply * 15 / 100;\n', '        emit Transfer(0x0, address_team, totalSupply * 15 / 100);\n', '\n', '        balanceOf[address_extra] = totalSupply * 15 / 100;\n', '        emit Transfer(0x0, address_extra, totalSupply * 15 / 100);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public isRunning validAddress returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public isRunning validAddress returns (bool success) {\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        require(allowance[_from][msg.sender] >= _value);\n', '        balanceOf[_to] += _value;\n', '        balanceOf[_from] -= _value;\n', '        allowance[_from][msg.sender] -= _value;\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public isRunning validAddress returns (bool success) {\n', '        require(_value == 0 || allowance[msg.sender][_spender] == 0);\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function buy() public isRunning payable returns (uint amount){\n', '        amount = msg.value * decimalFactor / price;                    // calculates the amount\n', '        require(balanceOf[address_ico] >= amount);               // checks if it has enough to sell\n', "        balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance\n", "        balanceOf[address_ico] -= amount;                        // subtracts amount from seller's balance\n", '        address_ico.transfer(msg.value);\n', '        emit Transfer(address_ico, msg.sender, amount);               // execute an event reflecting the change\n', '        return amount;                                    // ends function and returns\n', '    }\n', '\n', '    function deployTokens(address[] _recipient, uint256[] _values) public isOwner {\n', '        for(uint i = 0; i< _recipient.length; i++)\n', '        {\n', '              balanceOf[_recipient[i]] += _values[i] * decimalFactor;\n', '              balanceOf[address_ico] -= _values[i] * decimalFactor;\n', '              emit Transfer(address_ico, _recipient[i], _values[i] * decimalFactor);\n', '        }\n', '    }\n', '\n', '    function stop() public isOwner {\n', '        stopped = true;\n', '    }\n', '\n', '    function start() public isOwner {\n', '        stopped = false;\n', '    }\n', '\n', '    function setPrice(uint256 _price) public isOwner {\n', '        price = _price;\n', '    }\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}']
