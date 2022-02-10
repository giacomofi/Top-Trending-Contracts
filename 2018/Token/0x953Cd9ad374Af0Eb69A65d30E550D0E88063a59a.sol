['pragma solidity ^0.4.20;\n', '\n', 'contract MyOwned {\n', '\n', '    address public owner;\n', '    function MyOwned() public { owner = msg.sender; }\n', '    modifier onlyOwner { require(msg.sender == owner ); _; }\n', '    function transferOwnership (address newOwner) onlyOwner public { owner = newOwner; }\n', '}\n', '\n', 'contract MyToken is MyOwned {   \n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '    \n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => bool) public frozenAccount;\n', '    event Burn (address indexed from,uint256 value);    \n', '    event FrozenFunds (address target,bool frozen);\n', '    event Transfer (address indexed from,address indexed to,uint256 value);\n', '    \n', '    function MyToken(\n', '\n', '        string tokenName,\n', '        string tokenSymbol,\n', '        uint8 decimalUnits,\n', '        uint256 initialSupply) public {\n', '\n', '        name = tokenName;\n', '        symbol = tokenSymbol;\n', '        decimals = decimalUnits;\n', '        totalSupply = initialSupply;\n', '        balanceOf[msg.sender] = initialSupply;\n', '    }\n', '\n', '    function transfer (address _to, uint256 _value) public {\n', '\n', '        require(!frozenAccount[msg.sender]);\n', '        require (balanceOf[msg.sender] >= _value);\n', '        require (balanceOf[_to] + _value >= balanceOf[_to]);\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '    }\n', '    \n', '    function freezeAccount (address target,bool freeze) public onlyOwner {\n', '\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '\n', '    function mintToken (address target, uint256 mintedAmount) public onlyOwner {\n', '\n', '        balanceOf[target] += mintedAmount;\n', '        Transfer(0, this, mintedAmount);\n', '        Transfer(this, target, mintedAmount);\n', '    }\n', '    \n', '    function burnFrom (address _from,uint256 _value) public onlyOwner {\n', '\n', '        require(balanceOf[_from] >= _value); \n', '        balanceOf[_from] -= _value; \n', '        Burn(_from, _value);\n', '    }        \n', '}']