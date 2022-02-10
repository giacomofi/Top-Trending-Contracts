['/**\n', ' *Submitted for verification at Etherscan.io on 2020-09-01\n', '*/\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', 'contract HidethepainToken {\n', '    string public name = "HideThePain Harold"; //Optional\n', '    string public symbol = "HTPH"; //Optional\n', '    string public standard = "HideThePain Harold v1.0"; //Not in documentation, extra!\n', '    uint256 public totalSupply;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    event Approval(\n', '        address indexed _owner,\n', '        address indexed _spender,\n', '        uint256 _value\n', '    );\n', '\n', '    mapping(address => uint256) public balanceOf;\n', '    mapping(address => mapping(address => uint256)) public allowance;\n', '\n', '    constructor(uint256 _initialSupply) public {\n', '        balanceOf[msg.sender] = _initialSupply;\n', '        totalSupply = _initialSupply;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value)\n', '        public\n', '        returns (bool success)\n', '    {\n', '        require(balanceOf[msg.sender] >= _value, "Not enough balance");\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value)\n', '        public\n', '        returns (bool success)\n', '    {\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _value\n', '    ) public returns (bool success) {\n', '        require(\n', '            balanceOf[_from] >= _value,\n', '            "_from does not have enough tokens"\n', '        );\n', '        require(\n', '            allowance[_from][msg.sender] >= _value,\n', '            "Spender limit exceeded"\n', '        );\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        allowance[_from][msg.sender] -= _value;\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '}']