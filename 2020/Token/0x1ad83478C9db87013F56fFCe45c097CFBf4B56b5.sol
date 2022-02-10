['pragma solidity ^0.4.24;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0); \n', '    uint256 c = a / b;\n', '\n', '    return c;\n', '  }\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '  \n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '\n', 'contract TokenERC20 is owned{\n', '    using SafeMath for uint256;\n', '\n', '    string public name = "Smapi Digital Stock";\n', '    string public symbol = "SDS";\n', '    uint8 public decimals = 18;\n', '    uint256 public totalSupply = 20000000000000000000000000000;\n', '    bool public released = true;\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    \n', '    constructor(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) public {\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);\n', '        balanceOf[msg.sender] = 0;\n', '        name = "Smapi Digital Stock";\n', '        symbol = "SDS";\n', '    }\n', '\n', '    function release() public onlyOwner{\n', '      require (owner == msg.sender);\n', '      released = !released;\n', '    }\n', '\n', '    modifier onlyReleased() {\n', '      require(released);\n', '      _;\n', '    }\n', '    \n', '    function _transfer(address _from, address _to, uint _value) internal onlyReleased {\n', '        require(_to != 0x0);\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        uint previousBalances = balanceOf[_from].add(balanceOf[_to]);\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public onlyReleased returns (bool success) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    \n', '    function approve(address _spender, uint256 _value) public onlyReleased\n', '        returns (bool success) {\n', '        require(_spender != address(0));\n', '\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public onlyReleased\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value) public onlyReleased returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '\n', '        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function burn(uint256 _value) public onlyReleased returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender\n', '        totalSupply = totalSupply.sub(_value);                      // Updates totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(address _from, uint256 _value) public onlyReleased returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance\n', "        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance\n", '        totalSupply = totalSupply.sub(_value);                              // Update totalSupply\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract SDS is owned, TokenERC20 {\n', '\n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    event FrozenFunds(address target, bool frozen);\n', '    constructor(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {\n', '    }\n', '\n', '      function _transfer(address _from, address _to, uint _value) internal onlyReleased {\n', '        require (_to != 0x0);\n', '        require (balanceOf[_from] >= _value);\n', '        require (balanceOf[_to] + _value >= balanceOf[_to]); \n', '        require(!frozenAccount[_from]);\n', '        require(!frozenAccount[_to]);\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '        require (mintedAmount > 0);\n', '        totalSupply = totalSupply.add(mintedAmount);\n', '        balanceOf[target] = balanceOf[target].add(mintedAmount);\n', '        emit Transfer(0, this, mintedAmount);\n', '        emit Transfer(this, target, mintedAmount);\n', '    }\n', '    \n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '\n', '}']