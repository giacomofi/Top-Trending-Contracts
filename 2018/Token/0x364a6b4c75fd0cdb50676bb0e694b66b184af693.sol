['pragma solidity ^0.4.18;\n', '    library SafeMath {\n', '        function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '            uint256 c = a * b;\n', '            assert(a == 0 || c / a == b);\n', '            return c;\n', '        }\n', '    \n', '        function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '            // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '            uint256 c = a / b;\n', '            // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '            return c;\n', '        }\n', '    \n', '        function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '            assert(b <= a);\n', '            return a - b;\n', '        }\n', '    \n', '        function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '            uint256 c = a + b;\n', '            assert(c >= a);\n', '            return c;\n', '        }\n', '    }\n', '    library ERC20Interface {\n', '        function totalSupply() public constant returns (uint);\n', '        function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '        function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '        function transfer(address to, uint tokens) public returns (bool success);\n', '        function approve(address spender, uint tokens) public returns (bool success);\n', '        function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '        event Transfer(address indexed from, address indexed to, uint tokens);\n', '        event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '    }\n', '    library ApproveAndCallFallBack {\n', '        function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '    }\n', '    contract owned {\n', '    \n', '    \n', '    \t    address public owner;\n', '    \n', '    \n', '    \t    function owned() payable public {\n', '    \t        owner = msg.sender;\n', '    \t    }\n', '    \t    \n', '    \t    modifier onlyOwner {\n', '    \t        require(owner == msg.sender);\n', '    \t        _;\n', '    \t    }\n', '    \n', '    \n', '    \t    function changeOwner(address _owner) onlyOwner public {\n', '    \t        owner = _owner;\n', '    \t    }\n', '    \t}\n', '    contract Crowdsale is owned {\n', '    \t    \n', '    \t    uint256 public totalSupply;\n', '    \t\n', '    \t    mapping (address => uint256) public balanceOf;\n', '    \n', '    \n', '    \t    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    \t    \n', '    \t    function Crowdsale() payable owned() public {\n', '                totalSupply = 10000000000 * 1000000000000000000; \n', '                // ico\n', '    \t        balanceOf[this] = 9000000000 * 1000000000000000000;   \n', '    \t        balanceOf[owner] = totalSupply - balanceOf[this];\n', '    \t        Transfer(this, owner, balanceOf[owner]);\n', '    \t    }\n', '    \n', '    \t    function () payable public {\n', '    \t        require(balanceOf[this] > 0);\n', '    \t        \n', '    \t        uint256 tokensPerOneEther = 100000 * 1000000000000000000;\n', '    \t        uint256 tokens = tokensPerOneEther * msg.value / 1000000000000000000;\n', '    \t        if (tokens > balanceOf[this]) {\n', '    \t            tokens = balanceOf[this];\n', '    \t            uint valueWei = tokens * 1000000000000000000 / tokensPerOneEther;\n', '    \t            msg.sender.transfer(msg.value - valueWei);\n', '    \t        }\n', '    \t        require(tokens > 0);\n', '    \t        balanceOf[msg.sender] += tokens;\n', '    \t        balanceOf[this] -= tokens;\n', '    \t        Transfer(this, msg.sender, tokens);\n', '    \t    }\n', '    \t}\n', '    contract KOCMOC is Crowdsale {\n', '        \n', '            using SafeMath for uint256;\n', '            string  public name        = &#39;KOCMOC&#39;;\n', '    \t    string  public symbol      = &#39;KOCMOC&#39;;\n', '    \t    string  public standard    = &#39;KOCMOC&#39;;\n', '            \n', '    \t    uint8   public decimals    = 18;\n', '    \t    mapping (address => mapping (address => uint256)) internal allowed;\n', '    \t    \n', '    \t    function KOCMOC() payable Crowdsale() public {}\n', '    \t    \n', '    \t    function transfer(address _to, uint256 _value) public {\n', '    \t        require(balanceOf[msg.sender] >= _value);\n', '    \t        balanceOf[msg.sender] -= _value;\n', '    \t        balanceOf[_to] += _value;\n', '    \t        Transfer(msg.sender, _to, _value);\n', '    \t    }\n', '    \t}\n', '    contract KOCMOCToken is KOCMOC {\n', '    \t    function KOCMOCToken() payable KOCMOC()  {}\n', '    \t    function withdraw() onlyOwner {    \n', '    \t        owner.transfer(this.balance);  \n', '    \t    }\n', '    \t    function killMe()  onlyOwner {\n', '    \t        selfdestruct(owner);\n', '    \t    }\n', '    \t}']
['pragma solidity ^0.4.18;\n', '    library SafeMath {\n', '        function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '            uint256 c = a * b;\n', '            assert(a == 0 || c / a == b);\n', '            return c;\n', '        }\n', '    \n', '        function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '            // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '            uint256 c = a / b;\n', "            // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '            return c;\n', '        }\n', '    \n', '        function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '            assert(b <= a);\n', '            return a - b;\n', '        }\n', '    \n', '        function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '            uint256 c = a + b;\n', '            assert(c >= a);\n', '            return c;\n', '        }\n', '    }\n', '    library ERC20Interface {\n', '        function totalSupply() public constant returns (uint);\n', '        function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '        function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '        function transfer(address to, uint tokens) public returns (bool success);\n', '        function approve(address spender, uint tokens) public returns (bool success);\n', '        function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '        event Transfer(address indexed from, address indexed to, uint tokens);\n', '        event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '    }\n', '    library ApproveAndCallFallBack {\n', '        function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '    }\n', '    contract owned {\n', '    \n', '    \n', '    \t    address public owner;\n', '    \n', '    \n', '    \t    function owned() payable public {\n', '    \t        owner = msg.sender;\n', '    \t    }\n', '    \t    \n', '    \t    modifier onlyOwner {\n', '    \t        require(owner == msg.sender);\n', '    \t        _;\n', '    \t    }\n', '    \n', '    \n', '    \t    function changeOwner(address _owner) onlyOwner public {\n', '    \t        owner = _owner;\n', '    \t    }\n', '    \t}\n', '    contract Crowdsale is owned {\n', '    \t    \n', '    \t    uint256 public totalSupply;\n', '    \t\n', '    \t    mapping (address => uint256) public balanceOf;\n', '    \n', '    \n', '    \t    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    \t    \n', '    \t    function Crowdsale() payable owned() public {\n', '                totalSupply = 10000000000 * 1000000000000000000; \n', '                // ico\n', '    \t        balanceOf[this] = 9000000000 * 1000000000000000000;   \n', '    \t        balanceOf[owner] = totalSupply - balanceOf[this];\n', '    \t        Transfer(this, owner, balanceOf[owner]);\n', '    \t    }\n', '    \n', '    \t    function () payable public {\n', '    \t        require(balanceOf[this] > 0);\n', '    \t        \n', '    \t        uint256 tokensPerOneEther = 100000 * 1000000000000000000;\n', '    \t        uint256 tokens = tokensPerOneEther * msg.value / 1000000000000000000;\n', '    \t        if (tokens > balanceOf[this]) {\n', '    \t            tokens = balanceOf[this];\n', '    \t            uint valueWei = tokens * 1000000000000000000 / tokensPerOneEther;\n', '    \t            msg.sender.transfer(msg.value - valueWei);\n', '    \t        }\n', '    \t        require(tokens > 0);\n', '    \t        balanceOf[msg.sender] += tokens;\n', '    \t        balanceOf[this] -= tokens;\n', '    \t        Transfer(this, msg.sender, tokens);\n', '    \t    }\n', '    \t}\n', '    contract KOCMOC is Crowdsale {\n', '        \n', '            using SafeMath for uint256;\n', "            string  public name        = 'KOCMOC';\n", "    \t    string  public symbol      = 'KOCMOC';\n", "    \t    string  public standard    = 'KOCMOC';\n", '            \n', '    \t    uint8   public decimals    = 18;\n', '    \t    mapping (address => mapping (address => uint256)) internal allowed;\n', '    \t    \n', '    \t    function KOCMOC() payable Crowdsale() public {}\n', '    \t    \n', '    \t    function transfer(address _to, uint256 _value) public {\n', '    \t        require(balanceOf[msg.sender] >= _value);\n', '    \t        balanceOf[msg.sender] -= _value;\n', '    \t        balanceOf[_to] += _value;\n', '    \t        Transfer(msg.sender, _to, _value);\n', '    \t    }\n', '    \t}\n', '    contract KOCMOCToken is KOCMOC {\n', '    \t    function KOCMOCToken() payable KOCMOC()  {}\n', '    \t    function withdraw() onlyOwner {    \n', '    \t        owner.transfer(this.balance);  \n', '    \t    }\n', '    \t    function killMe()  onlyOwner {\n', '    \t        selfdestruct(owner);\n', '    \t    }\n', '    \t}']
