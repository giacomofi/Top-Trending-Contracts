['pragma solidity >=0.4.22 <0.6.0;\n', '\n', 'contract ERC20 {\n', '    function totalSupply() public view returns (uint supply);\n', '    function balanceOf(address who) public view returns (uint value);\n', '    function allowance(address owner, address spender) public view returns (uint remaining);\n', '    function transferFrom(address from, address to, uint value) public returns (bool ok);\n', '    function approve(address spender, uint value) public returns (bool ok);\n', '    function transfer(address to, uint value) public returns (bool ok);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'contract qnml is ERC20{\n', '    uint8 public constant decimals = 18;\n', '    uint256 initialSupply = 7500000*10**uint256(decimals);\n', '    string public constant name = "qnml.finance";\n', '    string public constant symbol = "qnml";\n', '\n', '    address payable teamAddress;\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return initialSupply;\n', '    }\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    \n', '    function balanceOf(address owner) public view returns (uint256 balance) {\n', '        return balances[owner];\n', '    }\n', '\n', '    function allowance(address owner, address spender) public view returns (uint remaining) {\n', '        return allowed[owner][spender];\n', '    }\n', '\n', '    function transfer(address to, uint256 value) public returns (bool success) {\n', '        if (balances[msg.sender] >= value && value > 0) {\n', '            balances[msg.sender] -= value;\n', '            balances[to] += value;\n', '            emit Transfer(msg.sender, to, value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool success) {\n', '        if (balances[from] >= value && allowed[from][msg.sender] >= value && value > 0) {\n', '            balances[to] += value;\n', '            balances[from] -= value;\n', '            allowed[from][msg.sender] -= value;\n', '            emit Transfer(from, to, value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function approve(address spender, uint256 value) public returns (bool success) {\n', '        allowed[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '    \n', '     function () external payable {\n', '        teamAddress.transfer(msg.value);\n', '    }\n', '\n', '    constructor () public payable {\n', '        teamAddress = msg.sender;\n', '        balances[teamAddress] = initialSupply;\n', '    }\n', '\n', '   \n', '}']