['pragma solidity ^0.4.16;\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() public {  owner = msg.sender;  }\n', '    modifier onlyOwner {  require (msg.sender == owner);    _;   }\n', '    function transferOwnership(address newOwner) onlyOwner public{  owner = newOwner;  }\n', '}\n', '\n', 'contract HSCToken is owned {\n', '    string public name; \n', '    string public symbol; \n', '    uint8 public decimals = 18;\n', '    uint256 public totalSupply; \n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => uint256) public lockOf;\n', '\tmapping (address => bool) public frozenAccount; \n', '\t\n', '    event Transfer(address indexed from, address indexed to, uint256 value); \n', '    event Burn(address indexed from, uint256 value); \n', '    \n', '    function HSCToken(uint256 initialSupply, string tokenName, string tokenSymbol, address centralMinter) public {\n', '        if(centralMinter != 0 ) \n', '\t\t\towner = centralMinter; \n', '\t\telse\n', '\t\t\towner = msg.sender;\n', '\t\t\n', '        totalSupply = initialSupply * 10 ** uint256(decimals); \n', '        balanceOf[owner] = totalSupply; \n', '\n', '        name = tokenName;\n', '        symbol = tokenSymbol;\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint256 _value) internal {\n', '        require (_to != 0x0); \n', '        require (balanceOf[_from] > _value); \n', '        require (balanceOf[_to] + _value > balanceOf[_to]);\n', '\t\trequire( balanceOf[_from] - _value >= lockOf[_from] );\n', '        require(!frozenAccount[_from]); \n', '        require(!frozenAccount[_to]);\n', '\n', '\t\tuint256 previousBalances = balanceOf[_from] +balanceOf[_to]; \n', '        \n', '        balanceOf[_from] -= _value; \n', '        balanceOf[_to] +=  _value; \n', '\t\tassert(balanceOf[_from] + balanceOf[_to] == previousBalances); \n', '\t\temit Transfer(_from, _to, _value); \n', '    }\n', '\t\n', '    function transfer(address _to, uint256 _value) public {   _transfer(msg.sender, _to, _value);   }\n', '\n', '    function mintToken(address target, uint256 mintedAmount) public onlyOwner  {\n', '\t\tbalanceOf[target] += mintedAmount; \n', '        totalSupply += mintedAmount;\n', '        emit Transfer(0, owner, mintedAmount);\n', '        emit Transfer(owner, target, mintedAmount);\n', '    }\n', '\n', '    function lockAccount(address _spender, uint256 _value) public onlyOwner returns (bool success) {\n', '        lockOf[_spender] = _value*10 ** uint256(decimals);\n', '        return true;\n', '    }\n', '\n', '    function freezeAccount(address target, bool freeze) public onlyOwner {\n', '        frozenAccount[target] = freeze;\n', '    }\n', '\n', '    function burn(uint256 _value) public onlyOwner returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   \n', '\n', '\t\tbalanceOf[msg.sender] -= _value; \n', '        totalSupply -= _value; \n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\t\n', '}']