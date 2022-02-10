['pragma solidity ^0.4.16;\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() public {  owner = msg.sender;  }\n', '    modifier onlyOwner {  require (msg.sender == owner);    _;   }\n', '    function transferOwnership(address newOwner) onlyOwner public{  owner = newOwner;  }\n', '}\n', '\n', 'contract CNKTToken is owned {\n', '    string public name; \n', '    string public symbol; \n', '    uint8 public decimals = 18;\n', '    uint256 public totalSupply; \n', '\n', '    mapping (address => uint256) public balanceOf;\n', '\t\n', '    event Transfer(address indexed from, address indexed to, uint256 value); \n', '    \n', '    function CNKTToken(uint256 initialSupply, string tokenName, string tokenSymbol) public {\n', '\t\towner = msg.sender;\n', '        totalSupply = initialSupply * 10 ** uint256(decimals); \n', '        balanceOf[owner] = totalSupply; \n', '        name = tokenName;\n', '        symbol = tokenSymbol;\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint256 _value) internal {\n', '        require (_to != 0x0); \n', '        require (balanceOf[_from] >= _value); \n', '        require (balanceOf[_to] + _value > balanceOf[_to]);\n', '\n', '\t\tuint256 previousBalances = balanceOf[_from] +balanceOf[_to]; \n', '        \n', '        balanceOf[_from] -= _value; \n', '        balanceOf[_to] +=  _value; \n', '\t\tassert(balanceOf[_from] + balanceOf[_to] == previousBalances); \n', '\t\temit Transfer(_from, _to, _value); \n', '    }\n', '\t\n', '    function transfer(address _to, uint256 _value) public {   _transfer(msg.sender, _to, _value);   }\n', '}']