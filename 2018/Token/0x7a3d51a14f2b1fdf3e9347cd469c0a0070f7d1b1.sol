['pragma solidity ^0.4.21;\n', '\n', 'contract ScareERC20Token {\n', '    // Track how many tokens are owned by each address.\n', '    mapping (address => uint256) public balanceOf;\n', '\n', '    string public name = "Shipment Care";\n', '    string public symbol = "SCARE";\n', '    uint8 public decimals = 18;\n', '\n', '    uint256 public totalSupply = 100000000 * (uint256(10) ** decimals);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    function ScareERC20Token() public {\n', '        // Initially assign all tokens to the contract&#39;s creator.\n', '        balanceOf[msg.sender] = totalSupply;\n', '        emit Transfer(address(0), msg.sender, totalSupply);\n', '    }\n', '\n', '    function transfer(address to, uint256 value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= value);\n', '\n', '        balanceOf[msg.sender] -= value;  // deduct from sender&#39;s balance\n', '        balanceOf[to] += value;          // add to recipient&#39;s balance\n', '        emit Transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    mapping(address => mapping(address => uint256)) public allowance;\n', '\n', '    function approve(address spender, uint256 value)\n', '        public\n', '        returns (bool success)\n', '    {\n', '        allowance[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint256 value)\n', '        public\n', '        returns (bool success)\n', '    {\n', '        require(value <= balanceOf[from]);\n', '        require(value <= allowance[from][msg.sender]);\n', '\n', '        balanceOf[from] -= value;\n', '        balanceOf[to] += value;\n', '        allowance[from][msg.sender] -= value;\n', '        emit Transfer(from, to, value);\n', '        return true;\n', '    }\n', '}']