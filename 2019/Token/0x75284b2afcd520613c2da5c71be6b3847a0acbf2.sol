['pragma solidity ^0.4.12;\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() public\n', '    {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner\n', '    {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function changeOwnership(address newOwner) public onlyOwner\n', '    {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract MyToken is owned {\n', '    \n', "    string public standard = 'NCMT 1.0';\n", '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    \n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    \n', '    function MyToken  () public {\n', '        balanceOf[msg.sender] = 7998000000000000000000000000;\n', '        totalSupply =7998000000000000000000000000;\n', "        name = 'NCM Govuro Forest Token';\n", "        symbol = 'NCMT';\n", '        decimals = 18;\n', '    }\n', '\n', '\n', '    \n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    \n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    \n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    \n', '    function transfer(address _to, uint256 _value) public\n', '    returns (bool success)\n', '    {\n', '        require(_to != 0x0);\n', '        require(balanceOf[msg.sender] >= _value);\n', '        require(!frozenAccount[msg.sender]);\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    \n', '   function mintToken(address target, uint256 mintedAmount)  public onlyOwner\n', '   {\n', '        balanceOf[target] += mintedAmount;\n', '        totalSupply += mintedAmount;\n', '        Transfer(0, this, mintedAmount);\n', '        Transfer(this, target, mintedAmount);\n', '   }\n', '\n', '    \n', '    function freezeAccount(address target, bool freeze)  public onlyOwner\n', '    {\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '\n', '    \n', '    function burn(uint256 _value)  public onlyOwner\n', '    returns (bool success)\n', '    {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        balanceOf[msg.sender] -= _value;\n', '        totalSupply -= _value;\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    \n', '    function burnFrom(address _from, uint256 _value)  public onlyOwner\n', '    returns (bool success)\n', '    {\n', '        require(balanceOf[_from] >= _value);\n', '        require(_value <= allowance[_from][msg.sender]);\n', '        balanceOf[_from] -= _value;\n', '        totalSupply -= _value;\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '}']