['pragma solidity ^0.4.24;\n', '\n', 'contract ERC20Interface {\n', '    function totalSupply() public view returns (uint);\n', '    function balanceOf(address tokenOwner) public view returns (uint balance);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '\n', '    \n', '    //function allowance(address tokenOwner, address spender) public view returns (uint remaining);\n', '    //function approve(address spender, uint tokens) public returns (bool success);\n', '    //function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '    \n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    //event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '\n', 'contract VENJOCOIN is ERC20Interface{\n', '    string public name = "VENJOCOIN";\n', '    string public symbol = "VJC";\n', '    uint public decimals = 18;\n', '    \n', '    uint public supply;\n', '    address public founder;\n', '    \n', '    mapping(address => uint) public balances;\n', '\n', '\n', ' event Transfer(address indexed from, address indexed to, uint tokens);\n', '\n', '\n', '    constructor() public{\n', '        supply = 2000000000000000000000000000;\n', '        founder = msg.sender;\n', '        balances[founder] = supply;\n', '    }\n', '    \n', '    \n', '    function totalSupply() public view returns (uint){\n', '        return supply;\n', '    }\n', '    \n', '    function balanceOf(address tokenOwner) public view returns (uint balance){\n', '         return balances[tokenOwner];\n', '     }\n', '     \n', '     \n', '    //transfer from the owner balance to another address\n', '    function transfer(address to, uint tokens) public returns (bool success){\n', '         require(balances[msg.sender] >= tokens && tokens > 0);\n', '         \n', '         balances[to] += tokens;\n', '         balances[msg.sender] -= tokens;\n', '         emit Transfer(msg.sender, to, tokens);\n', '         return true;\n', '     }\n', '     \n', '     \n', '     function burn(uint256 _value) public returns (bool success) {\n', '        require(balances[founder] >= _value);   // Check if the sender has enough\n', '        balances[founder] -= _value;            // Subtract from the sender\n', '        supply -= _value;                      // Updates totalSupply\n', '        return true;\n', '    }\n', '     \n', '}']