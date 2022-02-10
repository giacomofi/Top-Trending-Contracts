['pragma solidity ^0.4.18;\n', '\n', '\n', 'contract Owned {\n', '    address public owner;\n', '\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', 'contract YSS is Owned {\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint8  public decimals;\n', '    uint256 public totalSupply;\n', '    uint256 public sellPrice;\n', '    uint256 public buyPrice;\n', '    uint minBalanceForAccounts;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    function YSS(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits, address centralMinter) public {\n', '        balanceOf[msg.sender] = initialSupply;\n', '        totalSupply = initialSupply;\n', '        name = tokenName;\n', '        symbol = tokenSymbol;\n', '        decimals = decimalUnits;\n', '        if (centralMinter != 0) {owner = centralMinter;}\n', '    }\n', '\n', '    function setMinBalance(uint minimumBalanceInFinney) onlyOwner public {\n', '        minBalanceForAccounts = minimumBalanceInFinney * 1 finney;\n', '    }\n', '\n', '    /* Internal transfer, can only be called by this contract */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\n', '        require (balanceOf[_from] >= _value);                // Check if the sender has enough\n', '        require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows\n', '        require(!frozenAccount[_from]);                     // Check if sender is frozen\n', '        require(!frozenAccount[_to]);                       // Check if recipient is frozen\n', '        balanceOf[_from] -= _value;                         // Subtract from the sender\n', '        balanceOf[_to] += _value;                           // Add the same to the recipient\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '    function transfer(address _to, uint256 _value) public {\n', '        require(!frozenAccount[msg.sender]);\n', '        if (msg.sender.balance<minBalanceForAccounts) {\n', '            sell((minBalanceForAccounts-msg.sender.balance)/sellPrice);\n', '        }\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '        balanceOf[target] += mintedAmount;\n', '        totalSupply += mintedAmount;\n', '        emit Transfer(0, owner, mintedAmount);\n', '        emit Transfer(owner, target, mintedAmount);\n', '    }\n', '\n', '\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '\n', '    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {\n', '        sellPrice = newSellPrice;\n', '        buyPrice = newBuyPrice;\n', '    }\n', '\n', '\n', '    function buy() payable public returns (uint amount) {\n', '        amount = msg.value / buyPrice;\n', '        require(balanceOf[this] >= amount);\n', '        balanceOf[msg.sender] += amount;\n', '        balanceOf[this] -= amount;\n', '        emit Transfer(this, msg.sender, amount);\n', '        return amount;\n', '    }\n', '\n', '    function sell(uint amount) public returns (uint revenue) {\n', '        require(balanceOf[msg.sender] >= amount);\n', '        balanceOf[this] += amount;\n', '        balanceOf[msg.sender] -= amount;\n', '        revenue = amount * sellPrice;\n', '        msg.sender.transfer(revenue);\n', '        emit Transfer(msg.sender, this, amount);\n', '        return revenue;\n', '    }\n', '}']