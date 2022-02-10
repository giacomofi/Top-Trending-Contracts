['pragma  solidity ^ 0.4.24 ;\n', '\n', '// ----------------------------------------------------------------------------\n', '// 安全的加减乘除\n', '// ----------------------------------------------------------------------------\n', 'library SafeMath {\n', '\tfunction add(uint a, uint b) internal pure returns(uint c) {\n', '\t\tc = a + b;\n', '\t\trequire(c >= a);\n', '\t}\n', '\n', '\tfunction sub(uint a, uint b) internal pure returns(uint c) {\n', '\t\trequire(b <= a);\n', '\t\tc = a - b;\n', '\t}\n', '\n', '\tfunction mul(uint a, uint b) internal pure returns(uint c) {\n', '\t\tc = a * b;\n', '\t\trequire(a == 0 || c / a == b);\n', '\t}\n', '\n', '\tfunction div(uint a, uint b) internal pure returns(uint c) {\n', '\t\trequire(b > 0);\n', '\t\tc = a / b;\n', '\t}\n', '}\n', '\n', '\n', 'contract COM  {\n', '\tusing SafeMath for uint;\n', '\taddress public owner; \n', '    \n', '    address public backaddress1;\n', '    address public backaddress2;\n', '    uint public per1 = 150 ;\n', '    uint public per2 = 850 ;\n', '    \n', '\t\n', '\tmodifier onlyOwner {\n', '\t\trequire(msg.sender == owner);\n', '\t\t_;\n', '\t}\n', '\t\n', '\tmodifier onlyConf(address _back1,uint _limit1,address _back2,uint _limit2) {\n', '\t    require(_back1 !=address(0x0) && _back1 != address(this));\n', '\t    require(_back2 !=address(0x0) && _back2 != address(this));\n', '\t    require(_back2 != _back1);\n', '\t    require(_limit1 >0 && _limit2 >0 && _limit1.add(_limit2)==1000);\n', '\t    _;\n', '\t}\n', '\t\n', '\tevent Transfer(address from,address to,uint value);\n', '\tevent Setowner(address newowner,address oldower);\n', '\t\n', '\tconstructor(address back1,address back2)  public{\n', '\t    require(back1 !=address(0x0) && back1 != address(this));\n', '\t    require(back2 !=address(0x0) && back2 != address(this));\n', '\t    require(back2 != back1);\n', '\t    owner = msg.sender;\n', '\t    backaddress1 = back1;\n', '\t    backaddress2 = back2;\n', '\t}\n', '\t\n', '\tfunction setconf(address _back1,uint _limit1,address _back2,uint _limit2) onlyOwner onlyConf( _back1, _limit1, _back2, _limit2) public {\n', '\t    backaddress1 = _back1;\n', '\t    backaddress2 = _back2;\n', '\t    per1 = _limit1;\n', '\t    per2 = _limit2;\n', '\t}\n', '\tfunction setowner(address _newowner) onlyOwner public {\n', '\t    require(_newowner !=owner && _newowner !=address(this) && _newowner !=address(0x0));\n', '\t    address  oldower = owner;\n', '\t    owner = _newowner;\n', '\t    emit Setowner(_newowner,oldower);\n', '\t}\n', '\t\n', '\tfunction transfer() public payable  {\n', '\t  emit Transfer(msg.sender,address(this),msg.value);\n', '\t  backaddress1.transfer(msg.value * per1 / 1000);\n', '\t  emit Transfer(address(this),backaddress1,msg.value * per1 / 1000);\n', '\t  backaddress2.transfer(msg.value * per2 / 1000);\n', '\t  emit Transfer(address(this),backaddress2,msg.value * per2 / 1000);\n', '\t}\n', '\t\n', '\tfunction () public payable  {\n', '\t  transfer();\n', '\t}\n', '\n', '}']