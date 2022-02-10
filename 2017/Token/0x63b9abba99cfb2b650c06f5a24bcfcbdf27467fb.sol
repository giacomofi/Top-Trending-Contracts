['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract SafeERC20 {\n', '    \n', '    using SafeMath for uint256;\n', '    \n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    // 18 decimals is the strongly suggested default, avoid changing it\n', '    uint256 public totalSupply;\n', '\n', '    // This creates an array with all balances    \n', '    mapping (address => uint256) public balanceOf;\n', '    // Owner of account approves the transfer of an amount to another account\n', '    mapping (address => mapping(address => uint256)) allowed;\n', '    \n', '\n', '    function totalSupply() public constant returns (uint256) {\n', '        return totalSupply;\n', '    }\n', '    \n', '    \n', '        // @notice send `value` token to `to` from `msg.sender`\n', '    // @param to The address of the recipient\n', '    // @param value The amount of token to be transferred\n', '    // @return the transaction address and send the event as Transfer\n', '    function transfer(address to, uint256 value) public {\n', '        require (\n', '            balanceOf[msg.sender] >= value && value > 0\n', '        );\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(value);\n', '        balanceOf[to] = balanceOf[to].add(value);\n', '        Transfer(msg.sender, to, value);\n', '    }\n', '\n', '    // @notice send `value` token to `to` from `from`\n', '    // @param from The address of the sender\n', '    // @param to The address of the recipient\n', '    // @param value The amount of token to be transferred\n', '    // @return the transaction address and send the event as Transfer\n', '    function transferFrom(address from, address to, uint256 value) public {\n', '        require (\n', '            allowed[from][msg.sender] >= value && balanceOf[from] >= value && value > 0\n', '        );\n', '        balanceOf[from] = balanceOf[from].sub(value);\n', '        balanceOf[to] = balanceOf[to].add(value);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);\n', '        Transfer(from, to, value);\n', '    }\n', '\n', '    // Allow spender to withdraw from your account, multiple times, up to the value amount.\n', '    // If this function is called again it overwrites the current allowance with value.\n', '    // @param spender The address of the sender\n', '    // @param value The amount to be approved\n', '    // @return the transaction address and send the event as Approval\n', '    function approve(address spender, uint256 value) public {\n', '        require (\n', '            balanceOf[msg.sender] >= value && value > 0\n', '        );\n', '        allowed[msg.sender][spender] = value;\n', '        Approval(msg.sender, spender, value);\n', '    }\n', '\n', '    // Check the allowed value for the spender to withdraw from owner\n', '    // @param owner The address of the owner\n', '    // @param spender The address of the spender\n', '    // @return the amount which spender is still allowed to withdraw from owner\n', '    function allowance(address _owner, address spender) public constant returns (uint256) {\n', '        return allowed[_owner][spender];\n', '    }\n', '\n', '    // What is the balance of a particular account?\n', '    // @param who The address of the particular account\n', '    // @return the balanace the particular account\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '}\n', '\n', 'contract BITTOToken is SafeERC20, owned {\n', '\n', '    using SafeMath for uint256;\n', '\n', '\n', '\n', '    // Token properties\n', '    string public name = "BITTO";\n', '    string public symbol = "BITTO";\n', '    uint256 public decimals = 18;\n', '\n', '    uint256 public _totalSupply = 33000000e18;\n', '\n', '\n', '    \n', '\n', '    // how many token units a buyer gets per wei\n', '    uint public price = 800;\n', '\n', '\n', '    uint256 public fundRaised;\n', '\n', '    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '\n', '    // Constructor\n', '    // @notice RQXToken Contract\n', '    // @return the transaction address\n', '    function BITTOToken() public {\n', ' \n', '        balanceOf[owner] = _totalSupply;\n', '\n', '    }\n', '\n', '    function transfertoken (uint256 _amount, address recipient) public onlyOwner {\n', '         require(recipient != 0x0);\n', '         require(balanceOf[owner] >= _amount);\n', '         balanceOf[owner] = balanceOf[owner].sub(_amount);\n', '         balanceOf[recipient] = balanceOf[recipient].add(_amount);\n', '\n', '    }\n', '    \n', '    function burn(uint256 _amount) public onlyOwner{\n', '        require(balanceOf[owner] >= _amount);\n', '        balanceOf[owner] -= _amount;\n', '        _totalSupply -= _amount;\n', '    }\n', '    // Payable method\n', '    // @notice Anyone can buy the tokens on tokensale by paying ether\n', '    function () public payable {\n', '        tokensale(msg.sender);\n', '        \n', '    }\n', '    // update price \n', '    \n', '    function updatePrice (uint _newpice) public onlyOwner {\n', '        price = _newpice;\n', '    }\n', '    // @notice tokensale\n', '    // @param recipient The address of the recipient\n', '    // @return the transaction address and send the event as Transfer\n', '    function tokensale(address recipient) public payable {\n', '        require(recipient != 0x0);\n', '\n', '\n', '        uint256 weiAmount = msg.value;\n', '        uint256 tokens = weiAmount.mul(price);\n', '\n', '        // update state\n', '        fundRaised = fundRaised.add(weiAmount);\n', '\n', '        balanceOf[owner] = balanceOf[owner].sub(tokens);\n', '        balanceOf[recipient] = balanceOf[recipient].add(tokens);\n', '\n', '\n', '\n', '        TokenPurchase(msg.sender, recipient, weiAmount, tokens);\n', '        forwardFunds();\n', '    }\n', '\n', '    // send ether to the fund collection wallet\n', '    // override to create custom fund forwarding mechanisms\n', '    function forwardFunds() internal {\n', '        owner.transfer(msg.value);\n', '    }\n', '\n', '}']