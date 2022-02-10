['pragma solidity ^0.4.18;\n', '\n', '    contract owned {\n', '        address public owner;\n', '\n', '        function owned() public {\n', '            owner = msg.sender;\n', '        }\n', '\n', '        modifier onlyOwner {\n', '            require(msg.sender == owner);\n', '            _;\n', '        }\n', '\n', '        function transferOwnership(address newOwner) onlyOwner public {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '    \n', '    interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '    \n', 'contract TokenERC20 is owned{\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;\n', '    uint256 public totalSupply;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '\n', '\n', '    function TokenERC20(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) public {\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);  \n', '        balanceOf[msg.sender] = totalSupply;                \n', '        name = tokenName;                                   \n', '        symbol = tokenSymbol;                               \n', '    }\n', '\n', '\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public{\n', '        mintedAmount = mintedAmount * 10 ** uint256(decimals);\n', '        balanceOf[target] += mintedAmount;\n', '        totalSupply += mintedAmount;\n', '        emit Transfer(0, owner, mintedAmount);\n', '        emit Transfer(owner, target, mintedAmount);\n', '    }\n', '    \n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require(_to != 0x0);\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     \n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        _value = _value * 10 ** uint256(decimals);\n', '        require(balanceOf[msg.sender] >= _value);   \n', '        balanceOf[msg.sender] -= _value;            \n', '        totalSupply -= _value;                      \n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '}']