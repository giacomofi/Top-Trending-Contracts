['pragma solidity ^0.4.24;\n', '\n', '\n', '\n', 'contract DSGC {\n', '\n', '    string public name ;\n', '    string public symbol ;\n', '    uint8 public decimals = 18;  \n', '    uint256 public totalSupply  ;  \n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    \n', '   \n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    \n', '\n', '    function DSGC(uint256 initialSupply, string tokenName, string tokenSymbol) public {\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);\n', '\n', '        balanceOf[msg.sender] = totalSupply;    \n', '\n', '        name = tokenName;\n', '        symbol = tokenSymbol;\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '\n', '        require(_to != 0x0);\n', '\n', '        require(balanceOf[_from] >= _value);\n', '\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '\n', '        emit Transfer(_from, _to, _value);\n', '\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\t\n', '\t\n', '}']