['pragma solidity >=0.4.22 <0.6.0;\n', 'library hitung {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '         c = a + b;\n', '         require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require( a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '         require(b > 0);\n', '         c = a / b;\n', '    }\n', '}\n', ' contract Owned {\n', '     address public owner;\n', '     address public newOwner;\n', '     event OwnershipTransferred(address indexed _from, address indexed _to);\n', '     constructor() public {\n', '         owner = msg.sender;\n', '     }\n', '     modifier onlyOwner {\n', '         require(msg.sender == owner);\n', '         _;\n', '     }\n', '     function transferOwnership(address _newOwner) public onlyOwner {\n', '         newOwner = _newOwner;\n', '     }\n', '     function acceptOwnership() public {\n', '     require(msg.sender == newOwner);\n', '     emit OwnershipTransferred(owner, newOwner);\n', '     newOwner = address(0);\n', '     }\n', ' }\n', ' contract YFBET {\n', '     function totalSupply() public view returns (uint);\n', '     function balanceOf(address tokenOwner) public view returns (uint balance);\n', '     function allowance(address tokenOwner, address spender) public view returns (uint remaining);\n', '     function transfer(address to, uint tokens) public returns (bool success);\n', '     function approve(address spender, uint tokens) public returns (bool success);\n', '     function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '     event Transfer(address indexed from, address indexed to, uint tokens);\n', '     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', ' }\n', ' contract DetailToken is YFBET, Owned {\n', '     using hitung for uint;\n', '     string public symbol;\n', '     string public name;\n', '     uint8 public decimals;\n', '     uint _totalSupply;\n', '     mapping(address => uint) balances;\n', '     mapping(address => mapping(address => uint)) allowed;\n', '\n', '     \n', '         constructor() public {\n', '         symbol = "YFBET";\n', '         name = "YFBET.Finance";\n', '         decimals = 18;\n', '         _totalSupply = 5000 * 10**uint(decimals);\n', '         balances[0x37DA9a87B4F6C0cd82d48ac3582E9610A2Ab2c34] = _totalSupply;\n', '         emit Transfer(address(0), 0x37DA9a87B4F6C0cd82d48ac3582E9610A2Ab2c34, _totalSupply);\n', '}\n', '        function totalSupply() public view returns (uint) {\n', '            return _totalSupply.sub(balances[address(0)]);\n', '        }\n', '        function balanceOf(address tokenOwner) public view returns (uint balance) {\n', '         return balances[tokenOwner];\n', '     }\n', '        function transfer( address to, uint tokens) public returns (bool success) {\n', '            balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '            balances[to] = balances[to].add(tokens);\n', '            emit Transfer(msg.sender, to, tokens);\n', '            return true;\n', '        }\n', '        function approve(address spender, uint tokens) public returns (bool success) {\n', '            allowed[msg.sender][spender] = tokens;\n', '            emit Approval(msg.sender, spender, tokens);\n', '            return true;\n', '        }\n', '        function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        balances[from] = balances[from].sub(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '        }\n', '        function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '            return allowed[tokenOwner][spender];\n', '        }\n', '        \n', ' }']