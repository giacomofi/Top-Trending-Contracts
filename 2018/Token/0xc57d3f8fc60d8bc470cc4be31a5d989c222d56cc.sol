['/**\n', '     *-------------------------------------\n', '     * -- Scam coin - modified by Sanko as a mark of Cain for scams.\n', '     * -- This token will be sent to proven scammers to mark them\n', '     * -- FUCK YOU SCAMMERS\n', '     *-------------------------------------\n', '     * --ERC20 STANDARD TOKEN\n', '     * --ETHEREUM BLOCKCHAIN\n', '     * --Name: SCAM\n', '     * --Symbol: BEWARE:THIS IS A SCAM CONTRACT\n', '     * --Total Supply: 1000000000,00..SCAM\n', '     * --Decimal: 18\n', '     * ------------------------------------\n', '     * --Created by Luigi Di Benedetto Brescia(IT) copied by Sanko.\n', '     */\n', '\n', 'pragma solidity ^0.4.16;\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '\n', 'contract SCAMERC20 {\n', '    string public name = "SCAM";\n', '    string public symbol = "BEWARE:THIS IS A SCAM CONTRACT";\n', '    uint8 public decimals = 18;\n', '    uint256 public totalSupply = 1000000000;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    /**\n', '     * Costruttore\n', '     *\n', '     * Inizializzo nel costruttore i dati del token.\n', '     */\n', '    function SCAMERC20 () public {\n', '\n', '    }\n', '\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require(_to != 0x0);\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value); //emit per evitare di confondersi con un motodo(indica che &#232; un evento)\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);  \n', '        balanceOf[msg.sender] -= _value; \n', '        totalSupply -= _value;\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                \n', '        require(_value <= allowance[_from][msg.sender]);    \n', '        balanceOf[_from] -= _value;                         \n', '        allowance[_from][msg.sender] -= _value;             \n', '        totalSupply -= _value;                              // Aggiorno\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', '/******************************************/\n', '/*       FUNZIONI AGGIUNTIVE              */\n', '/******************************************/\n', '\n', 'contract SCAM is owned, SCAMERC20 {\n', '\n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    event FrozenFunds(address target, bool frozen); //notifico il "congelamento"\n', '\n', '    function SCAM(\n', '    ) SCAMERC20() public {}\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (_to != 0x0);                               \n', '        require (balanceOf[_from] >= _value);               \n', '        require (balanceOf[_to] + _value > balanceOf[_to]); \n', '        require(!frozenAccount[_from]);                     \n', '        require(!frozenAccount[_to]);                       \n', '        balanceOf[_from] -= _value;                         \n', '        balanceOf[_to] += _value;                           \n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '        balanceOf[target] += mintedAmount;\n', '        totalSupply += mintedAmount;\n', '        emit Transfer(0, this, mintedAmount);\n', '        emit Transfer(this, target, mintedAmount);\n', '    }\n', '\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '\n', '}']
['/**\n', '     *-------------------------------------\n', '     * -- Scam coin - modified by Sanko as a mark of Cain for scams.\n', '     * -- This token will be sent to proven scammers to mark them\n', '     * -- FUCK YOU SCAMMERS\n', '     *-------------------------------------\n', '     * --ERC20 STANDARD TOKEN\n', '     * --ETHEREUM BLOCKCHAIN\n', '     * --Name: SCAM\n', '     * --Symbol: BEWARE:THIS IS A SCAM CONTRACT\n', '     * --Total Supply: 1000000000,00..SCAM\n', '     * --Decimal: 18\n', '     * ------------------------------------\n', '     * --Created by Luigi Di Benedetto Brescia(IT) copied by Sanko.\n', '     */\n', '\n', 'pragma solidity ^0.4.16;\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '\n', 'contract SCAMERC20 {\n', '    string public name = "SCAM";\n', '    string public symbol = "BEWARE:THIS IS A SCAM CONTRACT";\n', '    uint8 public decimals = 18;\n', '    uint256 public totalSupply = 1000000000;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    /**\n', '     * Costruttore\n', '     *\n', '     * Inizializzo nel costruttore i dati del token.\n', '     */\n', '    function SCAMERC20 () public {\n', '\n', '    }\n', '\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require(_to != 0x0);\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value); //emit per evitare di confondersi con un motodo(indica che è un evento)\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);  \n', '        balanceOf[msg.sender] -= _value; \n', '        totalSupply -= _value;\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                \n', '        require(_value <= allowance[_from][msg.sender]);    \n', '        balanceOf[_from] -= _value;                         \n', '        allowance[_from][msg.sender] -= _value;             \n', '        totalSupply -= _value;                              // Aggiorno\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', '/******************************************/\n', '/*       FUNZIONI AGGIUNTIVE              */\n', '/******************************************/\n', '\n', 'contract SCAM is owned, SCAMERC20 {\n', '\n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    event FrozenFunds(address target, bool frozen); //notifico il "congelamento"\n', '\n', '    function SCAM(\n', '    ) SCAMERC20() public {}\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (_to != 0x0);                               \n', '        require (balanceOf[_from] >= _value);               \n', '        require (balanceOf[_to] + _value > balanceOf[_to]); \n', '        require(!frozenAccount[_from]);                     \n', '        require(!frozenAccount[_to]);                       \n', '        balanceOf[_from] -= _value;                         \n', '        balanceOf[_to] += _value;                           \n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '        balanceOf[target] += mintedAmount;\n', '        totalSupply += mintedAmount;\n', '        emit Transfer(0, this, mintedAmount);\n', '        emit Transfer(this, target, mintedAmount);\n', '    }\n', '\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '\n', '}']
