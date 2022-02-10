['pragma solidity ^0.5.6;\n', '\n', 'contract TheInternetCoin {\n', '\n', '    string public name = "The Internet Coin" ;                               \n', '    string public symbol = "ITN";           \n', '    uint256 public decimals = 18;            \n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    uint256 public totalSupply = 0;\n', '\n', '    uint256 constant valueFounder = 200*10**24;\n', '    address owner = 0x000000000000000000000000000000000000dEaD;\n', '\n', '    modifier isOwner {\n', '        assert(owner == msg.sender);\n', '        _;\n', '    }\n', '\n', '    modifier validAddress {\n', '        assert(0x000000000000000000000000000000000000dEaD != msg.sender);\n', '        _;\n', '    }\n', '\n', '    constructor (address _addressFounder) public {\n', '        owner = msg.sender;\n', '        totalSupply = valueFounder;\n', '        balanceOf[_addressFounder] = valueFounder;\n', '        emit Transfer(0x000000000000000000000000000000000000dEaD, _addressFounder, valueFounder);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) validAddress public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) validAddress public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        require(allowance[_from][msg.sender] >= _value);\n', '        balanceOf[_to] += _value;\n', '        balanceOf[_from] -= _value;\n', '        allowance[_from][msg.sender] -= _value;\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) validAddress public returns (bool success) {\n', '        require(_value == 0 || allowance[msg.sender][_spender] == 0);\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burn(uint256 _value) isOwner public {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[0x000000000000000000000000000000000000dEaD] += _value;\n', '        emit Transfer(msg.sender, 0x000000000000000000000000000000000000dEaD, _value);\n', '        totalSupply = totalSupply - _value ; \n', '    }\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}']