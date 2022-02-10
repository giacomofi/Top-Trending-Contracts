['pragma solidity ^0.4.19;\n', '\n', 'contract BaseToken {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require(_to != 0x0);\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract BurnToken is BaseToken {\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        balanceOf[msg.sender] -= _value;\n', '        totalSupply -= _value;\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);\n', '        require(_value <= allowance[_from][msg.sender]);\n', '        balanceOf[_from] -= _value;\n', '        allowance[_from][msg.sender] -= _value;\n', '        totalSupply -= _value;\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract ICOToken is BaseToken {\n', '    // 1 ether = icoRatio token\n', '    uint256 public icoRatio;\n', '    uint256 public icoEndtime;\n', '    address public icoSender;\n', '    address public icoHolder;\n', '\n', '    event ICO(address indexed from, uint256 indexed value, uint256 tokenValue);\n', '    event Withdraw(address indexed from, address indexed holder, uint256 value);\n', '\n', '    modifier onlyBefore() {\n', '        if (now > icoEndtime) {\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '\n', '    function() public payable onlyBefore {\n', '        uint256 tokenValue = (msg.value * icoRatio * 10 ** uint256(decimals)) / (1 ether / 1 wei);\n', '        if (tokenValue == 0 || balanceOf[icoSender] < tokenValue) {\n', '            revert();\n', '        }\n', '        _transfer(icoSender, msg.sender, tokenValue);\n', '        ICO(msg.sender, msg.value, tokenValue);\n', '    }\n', '\n', '    function withdraw() {\n', '        uint256 balance = this.balance;\n', '        icoHolder.transfer(balance);\n', '        Withdraw(msg.sender, icoHolder, balance);\n', '    }\n', '}\n', '\n', 'contract CustomToken is BaseToken, BurnToken, ICOToken {\n', '    function CustomToken() public {\n', '        totalSupply = 500000000000000000000000000;\n', '        balanceOf[0xe1f77b81a2383162cbbdd0dd93630f31a6672477] = totalSupply;\n', "        name = 'HouseChain';\n", "        symbol = 'HSE';\n", '        decimals = 18;\n', '        icoRatio = 100000;\n', '        icoEndtime = 1893430800;\n', '        icoSender = 0xfd3198b99946935d8bbb664f7ce6bac595af103b;\n', '        icoHolder = 0xfd3198b99946935d8bbb664f7ce6bac595af103b;\n', '    }\n', '}']