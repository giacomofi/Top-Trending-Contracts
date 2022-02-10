['pragma solidity ^0.4.18;\n', '\n', '\n', 'contract Owner {\n', '    address public owner;\n', '\n', '    function Owner() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier  onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function  transferOwnership(address newOwner) onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', 'contract TokenRecipient { \n', '    function receiveApproval(\n', '        address _from, \n', '        uint256 _value, \n', '        address _token, \n', '        bytes _extraData); \n', '}\n', '\n', '\n', 'contract Token {\n', '    string public standard;\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    function Token (\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        uint8 decimalUnits,\n', '        string tokenSymbol,\n', '        string standardStr\n', '    ) {\n', '        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens\n', '        totalSupply = initialSupply;                        // Update total supply\n', '        name = tokenName;                                   // Set the name for display purposes\n', '        symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '        decimals = decimalUnits;                            // Amount of decimals for display purposes\n', '        standard = standardStr;\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if (balanceOf[msg.sender] < _value) {\n', '            revert();           // Check if the sender has enough\n', '        }\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) {\n', '            revert(); // Check for overflows\n', '        }\n', '\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '\n', '        allowance[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '    returns (bool success) \n', '    {    \n', '        TokenRecipient spender = TokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(\n', '                msg.sender,\n', '                _value,\n', '                this,\n', '                _extraData\n', '            );\n', '            return true;\n', '        }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (balanceOf[_from] < _value) {\n', '            revert();                                        // Check if the sender has enough\n', '        }                 \n', '        if (balanceOf[_to] + _value < balanceOf[_to]) {\n', '            revert();  // Check for overflows\n', '        }\n', '        if (_value > allowance[_from][msg.sender]) {\n', '            revert();   // Check allowance\n', '        }\n', '\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        allowance[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', '\n', '//build EXToken\n', 'contract EXToken is Token, Owner {\n', '    uint256 public constant INITIAL_SUPPLY = 100 * 10000 * 10000 * 100000000; // 1e10 * 1e8\n', '    string public constant NAME = "coinex8"; //名称\n', '    string public constant SYMBOL = "ex8"; // 简称\n', '    string public constant STANDARD = "coinex8 1.0";\n', '    uint8 public constant DECIMALS = 8;\n', '    uint256 public constant BUY = 0; // 用于自动买卖\n', '    uint256 constant RATE = 1 szabo;\n', '    bool private couldTrade = false;\n', '\n', '    uint256 public sellPrice;\n', '    uint256 public buyPrice;\n', '    uint minBalanceForAccounts;\n', '\n', '    mapping (address => bool) frozenAccount;\n', '\n', '    event FrozenFunds(address indexed _target, bool _frozen);\n', '\n', '    function EXToken() Token(INITIAL_SUPPLY, NAME, DECIMALS, SYMBOL, STANDARD) {\n', '        balanceOf[msg.sender] = totalSupply;\n', '        buyPrice = 100000000;\n', '        sellPrice = 100000000;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if (balanceOf[msg.sender] < _value) {\n', '            revert();           // Check if the sender has enough\n', '        }\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) {\n', '            revert(); // Check for overflows\n', '        }\n', '        if (frozenAccount[msg.sender]) {\n', '            revert();                // Check if frozen\n', '        }\n', '\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (frozenAccount[_from]) {\n', '            revert();                        // Check if frozen       \n', '        }     \n', '        if (balanceOf[_from] < _value) {\n', '            revert();                 // Check if the sender has enough\n', '        }\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) {\n', '            revert();  // Check for overflows\n', '        }\n', '        if (_value > allowance[_from][msg.sender]) {\n', '            revert();   // Check allowance\n', '        }\n', '\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        allowance[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function freezeAccount(address _target, bool freeze) onlyOwner {\n', '        frozenAccount[_target] = freeze;\n', '        FrozenFunds(_target, freeze);\n', '    }\n', '\n', '    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {\n', '        sellPrice = newSellPrice;\n', '        buyPrice = newBuyPrice;\n', '    }\n', '\n', '    function buy() payable returns (uint amount) {\n', '        require(couldTrade);\n', '        amount = msg.value * RATE / buyPrice;\n', '        require(balanceOf[this] >= amount);\n', '        require(balanceOf[msg.sender] + amount >= amount);\n', '        balanceOf[this] -= amount;\n', '        balanceOf[msg.sender] += amount;\n', '        Transfer(this, msg.sender, amount);\n', '        return amount;\n', '    }\n', '\n', '    function sell(uint256 amountInWeiDecimalIs18) returns (uint256 revenue) {\n', '        require(couldTrade);\n', '        uint256 amount = amountInWeiDecimalIs18;\n', '        require(balanceOf[msg.sender] >= amount);\n', '        require(!frozenAccount[msg.sender]);\n', '\n', '        revenue = amount * sellPrice / RATE;\n', '        balanceOf[this] += amount;\n', '        balanceOf[msg.sender] -= amount;\n', '        require(msg.sender.send(revenue));\n', '        Transfer(msg.sender, this, amount);\n', '        return revenue;\n', '    }\n', '\n', '    function withdraw(uint256 amount) onlyOwner returns (bool success) {\n', '        require(msg.sender.send(amount));\n', '        return true;\n', '    }\n', '\n', '    function setCouldTrade(uint256 amountInWeiDecimalIs18) onlyOwner returns (bool success) {\n', '        couldTrade = true;\n', '        require(balanceOf[msg.sender] >= amountInWeiDecimalIs18);\n', '        require(balanceOf[this] + amountInWeiDecimalIs18 >= amountInWeiDecimalIs18);\n', '        balanceOf[msg.sender] -= amountInWeiDecimalIs18;\n', '        balanceOf[this] += amountInWeiDecimalIs18;\n', '        Transfer(msg.sender, this, amountInWeiDecimalIs18);\n', '        return true;\n', '    }\n', '\n', '    function stopTrade() onlyOwner returns (bool success) {\n', '        couldTrade = false;\n', '        uint256 _remain = balanceOf[this];\n', '        require(balanceOf[msg.sender] + _remain >= _remain);\n', '        balanceOf[msg.sender] += _remain;\n', '        balanceOf[this] -= _remain;\n', '        Transfer(this, msg.sender, _remain);\n', '        return true;\n', '    }\n', '\n', '    function () {\n', '        revert();\n', '    }\n', '}']