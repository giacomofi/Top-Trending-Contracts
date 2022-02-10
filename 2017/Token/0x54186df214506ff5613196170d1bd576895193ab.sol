['pragma solidity ^0.4.11;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract IERC20 {\n', '\n', '    function totalSupply() public constant returns (uint256);\n', '    function balanceOf(address who) public constant returns (uint256);\n', '    function transfer(address to, uint256 value) public;\n', '    function transferFrom(address from, address to, uint256 value) public;\n', '    function approve(address spender, uint256 value) public;\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '}\n', '\n', 'contract BTCPToken is IERC20 {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    // Token properties\n', '    string public name = "BitcoinPeso";\n', '    string public symbol = "BTCP";\n', '    uint public decimals = 18;\n', '\n', '    uint public _totalSupply = 21000000e18;\n', '    uint public _leftSupply = 21000000e18;\n', '\n', '    // Balances for each account\n', '    mapping (address => uint256) balances;\n', '\n', '    // Owner of account approves the transfer of an amount to another account\n', '    mapping (address => mapping(address => uint256)) allowed;\n', '\n', '    uint256 public startTime;\n', '\n', '    // Owner of Token\n', '    address public owner;\n', '\n', '    // how many token units a buyer gets per wei\n', '    uint public PRICE = 1000;\n', '\n', '    // amount of raised money in wei\n', '\n', '    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '    // modifier to allow only owner has full control on the function\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    // Constructor\n', '    // @notice BTCPToken Contract\n', '    // @return the transaction address\n', '    function BTCPToken() public payable {\n', '        startTime = now;\n', '        owner = msg.sender;\n', '\n', '        balances[owner] = _totalSupply; \n', '    }\n', '\n', '    // Payable method\n', '    // @notice Anyone can buy the tokens on tokensale by paying ether\n', '    function () public payable {\n', '        tokensale(msg.sender);\n', '    }\n', '\n', '    // @notice tokensale\n', '    // @param recipient The address of the recipient\n', '    // @return the transaction address and send the event as Transfer\n', '    function tokensale(address recipient) public payable {\n', '        require(recipient != 0x0);\n', '\n', '        uint256 weiAmount = msg.value;\n', '        uint tokens = weiAmount.mul(getPrice());\n', '\n', '        require(_leftSupply >= tokens);\n', '\n', '        balances[owner] = balances[owner].sub(tokens);\n', '        balances[recipient] = balances[recipient].add(tokens);\n', '\n', '        _leftSupply = _leftSupply.sub(tokens);\n', '\n', '        TokenPurchase(msg.sender, recipient, weiAmount, tokens);\n', '    }\n', '\n', '    // @return total tokens supplied\n', '    function totalSupply() public constant returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    // What is the balance of a particular account?\n', '    // @param who The address of the particular account\n', '    // @return the balanace the particular account\n', '    function balanceOf(address who) public constant returns (uint256) {\n', '        return balances[who];\n', '    }\n', '\n', '    // Token distribution to founder, develoment team, partners, charity, and bounty\n', '    function sendBTCPToken(address to, uint256 value) public onlyOwner {\n', '        require (\n', '            to != 0x0 && value > 0 && _leftSupply >= value\n', '        );\n', '\n', '        balances[owner] = balances[owner].sub(value);\n', '        balances[to] = balances[to].add(value);\n', '        _leftSupply = _leftSupply.sub(value);\n', '        Transfer(owner, to, value);\n', '    }\n', '\n', '    function sendBTCPTokenToMultiAddr(address[] listAddresses, uint256[] amount) onlyOwner {\n', '        require(listAddresses.length == amount.length); \n', '         for (uint256 i = 0; i < listAddresses.length; i++) {\n', '                require(listAddresses[i] != 0x0); \n', '                balances[listAddresses[i]] = balances[listAddresses[i]].add(amount[i]);\n', '                balances[owner] = balances[owner].sub(amount[i]);\n', '                Transfer(owner, listAddresses[i], amount[i]);\n', '                _leftSupply = _leftSupply.sub(amount[i]);\n', '         }\n', '    }\n', '\n', '    function destroyBTCPToken(address to, uint256 value) public onlyOwner {\n', '        require (\n', '                to != 0x0 && value > 0 && _totalSupply >= value\n', '            );\n', '        balances[to] = balances[to].sub(value);\n', '    }\n', '\n', '    // @notice send `value` token to `to` from `msg.sender`\n', '    // @param to The address of the recipient\n', '    // @param value The amount of token to be transferred\n', '    // @return the transaction address and send the event as Transfer\n', '    function transfer(address to, uint256 value) public {\n', '        require (\n', '            balances[msg.sender] >= value && value > 0\n', '        );\n', '        balances[msg.sender] = balances[msg.sender].sub(value);\n', '        balances[to] = balances[to].add(value);\n', '        Transfer(msg.sender, to, value);\n', '    }\n', '\n', '    // @notice send `value` token to `to` from `from`\n', '    // @param from The address of the sender\n', '    // @param to The address of the recipient\n', '    // @param value The amount of token to be transferred\n', '    // @return the transaction address and send the event as Transfer\n', '    function transferFrom(address from, address to, uint256 value) public {\n', '        require (\n', '            allowed[from][msg.sender] >= value && balances[from] >= value && value > 0\n', '        );\n', '        balances[from] = balances[from].sub(value);\n', '        balances[to] = balances[to].add(value);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);\n', '        Transfer(from, to, value);\n', '    }\n', '\n', '    // Allow spender to withdraw from your account, multiple times, up to the value amount.\n', '    // If this function is called again it overwrites the current allowance with value.\n', '    // @param spender The address of the sender\n', '    // @param value The amount to be approved\n', '    // @return the transaction address and send the event as Approval\n', '    function approve(address spender, uint256 value) public {\n', '        require (\n', '            balances[msg.sender] >= value && value > 0\n', '        );\n', '        allowed[msg.sender][spender] = value;\n', '        Approval(msg.sender, spender, value);\n', '    }\n', '\n', '    // Check the allowed value for the spender to withdraw from owner\n', '    // @param owner The address of the owner\n', '    // @param spender The address of the spender\n', '    // @return the amount which spender is still allowed to withdraw from owner\n', '    function allowance(address _owner, address spender) public constant returns (uint256) {\n', '        return allowed[_owner][spender];\n', '    }\n', '\n', '    // Get current price of a Token\n', '    // @return the price or token value for a ether\n', '    function getPrice() public constant returns (uint result) {\n', '        return PRICE;\n', '    }\n', '\n', '    function getTokenDetail() public constant returns (string, string, uint256) {\n', '\treturn (name, symbol, _totalSupply);\n', '    }\n', '}']