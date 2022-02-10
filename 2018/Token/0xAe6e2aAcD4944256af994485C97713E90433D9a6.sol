['pragma solidity 0.4.21;\n', '\n', '/*--------------------------------------------------------------/*\n', '        _      _                 _                _         \n', '  _ __ ( ) ___| | ___  _   _  __| |  _____      _(_)___ ___ \n', ' | &#39;_ \\|/ / __| |/ _ \\| | | |/ _` | / __\\ \\ /\\ / / / __/ __|\n', ' | | | | | (__| | (_) | |_| | (_| |_\\__ \\\\ V  V /| \\__ \\__ \\\n', ' |_| |_|  \\___|_|\\___/ \\__,_|\\__,_(_)___/ \\_/\\_/ |_|___/___/\n', '                                                            \n', '                              NCU Token   \n', '                              \n', '                 Token Code created:   23.03.2018\n', '                                 - \n', '                 Token Code published: 04.04.2018\n', '                 \n', '                        by n&#39;cloud.swiss AG                                           \n', '/*--------------------------------------------------------------*/\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '  function add(uint a, uint b) internal pure returns (uint c) {\n', '       c = a + b;\n', '        require(c >= a);\n', '   }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '       c = a - b;\n', '   }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '       c = a * b;\n', '       require(a == 0 || c / a == b);\n', '  }\n', '  function div(uint a, uint b) internal pure returns (uint c) {\n', '    require(b > 0);\n', '      c = a / b;\n', '   }\n', '}\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', 'contract TokenERC20 {\n', '    \n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    function TokenERC20(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '\n', '    ) public {\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);\n', '        balanceOf[msg.sender] = totalSupply;\n', '        name = tokenName;\n', '        symbol = tokenSymbol;\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require(_to != 0x0);\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '}\n', '\n', 'contract NCU is owned, TokenERC20 {\n', '\n', '    uint256 public sellPrice;\n', '    uint256 public buyPrice;\n', '    uint256 public constant decimals = 2;\n', '\n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    function NCU(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '        \n', '    ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}\n', '\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (_to != 0x0);\n', '        require (balanceOf[_from] >= _value);\n', '        require (balanceOf[_to] + _value > balanceOf[_to]);\n', '        require(!frozenAccount[_from]);\n', '        require(!frozenAccount[_to]);\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '        balanceOf[target] += mintedAmount;\n', '        totalSupply += mintedAmount;\n', '        Transfer(0, this, mintedAmount);\n', '        Transfer(this, target, mintedAmount);\n', '    }\n', '\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '\n', '    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {\n', '        sellPrice = newSellPrice;\n', '        buyPrice = newBuyPrice;\n', '    }\n', '\n', '    function buy() payable public {\n', '        uint amount = msg.value / buyPrice;\n', '        _transfer(this, msg.sender, amount);\n', '    }\n', '\n', '    function sell(uint256 amount) public {\n', '        require(this.balance >= amount * sellPrice);\n', '        _transfer(msg.sender, this, amount);\n', '        msg.sender.transfer(amount * sellPrice);\n', '    }\n', '   }']