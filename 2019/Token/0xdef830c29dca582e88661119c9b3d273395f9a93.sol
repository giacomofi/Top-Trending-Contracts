['pragma solidity ^0.4.25;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /** \n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor () public{\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner. \n', '   */\n', '  modifier onlyOwner() {\n', '    require(owner==msg.sender);\n', '    _;\n', ' }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to. \n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '      owner = newOwner;\n', '  }\n', ' \n', '}\n', '  \n', 'contract ERC20 {\n', '\n', '    function totalSupply() public constant returns (uint256);\n', '    function balanceOf(address who) public constant returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool success);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool success);\n', '    function approve(address spender, uint256 value) public returns (bool success);\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '}\n', '\n', 'contract BTNYToken is Ownable, ERC20 {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    // Token properties\n', '    string public name = "Bitney";                //Token name\n', '    string public symbol = "BTNY";                  //Token symbol\n', '    uint256 public decimals = 18;\n', '\n', '    uint256 public _totalSupply = 1000000000e18;       //100% Total Supply\n', '\n', '    // Balances for each account\n', '    mapping (address => uint256) balances;\n', '\n', '    // Owner of account approves the transfer of an amount to another account\n', '    mapping (address => mapping(address => uint256)) allowed;\n', '\n', '    // how many token units a buyer gets per wei\n', '    uint256 public price;\n', '\n', '    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '    // Constructor\n', '    // @notice CBITToken Contract\n', '    // @return the transaction address\n', '    constructor () public{\n', '        // Initial Owner Wallet Address\n', '        owner = msg.sender;\n', '\n', '        balances[owner] = _totalSupply;\n', '    }\n', '\n', '    // Payable method\n', '    // @notice Anyone can buy the tokens on tokensale by paying ether\n', '    function () external payable {\n', '        tokensale(msg.sender);\n', '    }\n', '\n', '    // @notice tokensale\n', '    // @param recipient The address of the recipient\n', '    // @return the transaction address and send the event as Transfer\n', '    function tokensale(address recipient) public payable {\n', '        price = getPrice();\n', '        require(price != 0 && recipient != 0x0);\n', '        uint256 weiAmount = msg.value;\n', '        uint256 tokenToSend = weiAmount.mul(price);\n', '        \n', '        balances[owner] = balances[owner].sub(tokenToSend);\n', '        balances[recipient] = balances[recipient].add(tokenToSend);\n', '\n', '        owner.transfer(msg.value);\n', '        emit TokenPurchase(msg.sender, recipient, weiAmount, tokenToSend);\n', '    }\n', '\n', '    // @return total tokens supplied\n', '    function totalSupply() public constant returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '    \n', '    // What is the balance of a particular account?\n', '    // @param who The address of the particular account\n', '    // @return the balanace the particular account\n', '    function balanceOf(address who) public constant returns (uint256) {\n', '        return balances[who];\n', '    }\n', '\n', '    // @notice send `value` token to `to` from `msg.sender`\n', '    // @param to The address of the recipient\n', '    // @param value The amount of token to be transferred\n', '    // @return the transaction address and send the event as Transfer\n', '    function transfer(address to, uint256 value) public returns (bool success)  {\n', '        require (\n', '            balances[msg.sender] >= value && value > 0\n', '        );\n', '        balances[msg.sender] = balances[msg.sender].sub(value);\n', '        balances[to] = balances[to].add(value);\n', '        emit Transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    // @notice send `value` token to `to` from `from`\n', '    // @param from The address of the sender\n', '    // @param to The address of the recipient\n', '    // @param value The amount of token to be transferred\n', '    // @return the transaction address and send the event as Transfer\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool success)  {\n', '        require (\n', '            allowed[from][msg.sender] >= value && balances[from] >= value && value > 0\n', '        );\n', '        balances[from] = balances[from].sub(value);\n', '        balances[to] = balances[to].add(value);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);\n', '        emit Transfer(from, to, value);\n', '        return true;\n', '    }\n', '\n', '    // Allow spender to withdraw from your account, multiple times, up to the value amount.\n', '    // If this function is called again it overwrites the current allowance with value.\n', '    // @param spender The address of the sender\n', '    // @param value The amount to be approved\n', '    // @return the transaction address and send the event as Approval\n', '    function approve(address spender, uint256 value) public returns (bool success)  {\n', '        require (balances[msg.sender] >= value && value > 0);\n', '        allowed[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    // Check the allowed value for the spender to withdraw from owner\n', '    // @param owner The address of the owner\n', '    // @param spender The address of the spender\n', '    // @return the amount which spender is still allowed to withdraw from owner\n', '    function allowance(address _owner, address spender) public constant returns (uint256) {\n', '        return allowed[_owner][spender];\n', '    }\n', '    \n', '    // Get current price of a Token\n', '    // @return the price or token value for a ether\n', '    function getPrice() public pure returns (uint256 result) {\n', '        return 0;\n', '    }\n', '}']
['pragma solidity ^0.4.25;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /** \n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor () public{\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner. \n', '   */\n', '  modifier onlyOwner() {\n', '    require(owner==msg.sender);\n', '    _;\n', ' }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to. \n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '      owner = newOwner;\n', '  }\n', ' \n', '}\n', '  \n', 'contract ERC20 {\n', '\n', '    function totalSupply() public constant returns (uint256);\n', '    function balanceOf(address who) public constant returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool success);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool success);\n', '    function approve(address spender, uint256 value) public returns (bool success);\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '}\n', '\n', 'contract BTNYToken is Ownable, ERC20 {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    // Token properties\n', '    string public name = "Bitney";                //Token name\n', '    string public symbol = "BTNY";                  //Token symbol\n', '    uint256 public decimals = 18;\n', '\n', '    uint256 public _totalSupply = 1000000000e18;       //100% Total Supply\n', '\n', '    // Balances for each account\n', '    mapping (address => uint256) balances;\n', '\n', '    // Owner of account approves the transfer of an amount to another account\n', '    mapping (address => mapping(address => uint256)) allowed;\n', '\n', '    // how many token units a buyer gets per wei\n', '    uint256 public price;\n', '\n', '    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '    // Constructor\n', '    // @notice CBITToken Contract\n', '    // @return the transaction address\n', '    constructor () public{\n', '        // Initial Owner Wallet Address\n', '        owner = msg.sender;\n', '\n', '        balances[owner] = _totalSupply;\n', '    }\n', '\n', '    // Payable method\n', '    // @notice Anyone can buy the tokens on tokensale by paying ether\n', '    function () external payable {\n', '        tokensale(msg.sender);\n', '    }\n', '\n', '    // @notice tokensale\n', '    // @param recipient The address of the recipient\n', '    // @return the transaction address and send the event as Transfer\n', '    function tokensale(address recipient) public payable {\n', '        price = getPrice();\n', '        require(price != 0 && recipient != 0x0);\n', '        uint256 weiAmount = msg.value;\n', '        uint256 tokenToSend = weiAmount.mul(price);\n', '        \n', '        balances[owner] = balances[owner].sub(tokenToSend);\n', '        balances[recipient] = balances[recipient].add(tokenToSend);\n', '\n', '        owner.transfer(msg.value);\n', '        emit TokenPurchase(msg.sender, recipient, weiAmount, tokenToSend);\n', '    }\n', '\n', '    // @return total tokens supplied\n', '    function totalSupply() public constant returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '    \n', '    // What is the balance of a particular account?\n', '    // @param who The address of the particular account\n', '    // @return the balanace the particular account\n', '    function balanceOf(address who) public constant returns (uint256) {\n', '        return balances[who];\n', '    }\n', '\n', '    // @notice send `value` token to `to` from `msg.sender`\n', '    // @param to The address of the recipient\n', '    // @param value The amount of token to be transferred\n', '    // @return the transaction address and send the event as Transfer\n', '    function transfer(address to, uint256 value) public returns (bool success)  {\n', '        require (\n', '            balances[msg.sender] >= value && value > 0\n', '        );\n', '        balances[msg.sender] = balances[msg.sender].sub(value);\n', '        balances[to] = balances[to].add(value);\n', '        emit Transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    // @notice send `value` token to `to` from `from`\n', '    // @param from The address of the sender\n', '    // @param to The address of the recipient\n', '    // @param value The amount of token to be transferred\n', '    // @return the transaction address and send the event as Transfer\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool success)  {\n', '        require (\n', '            allowed[from][msg.sender] >= value && balances[from] >= value && value > 0\n', '        );\n', '        balances[from] = balances[from].sub(value);\n', '        balances[to] = balances[to].add(value);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);\n', '        emit Transfer(from, to, value);\n', '        return true;\n', '    }\n', '\n', '    // Allow spender to withdraw from your account, multiple times, up to the value amount.\n', '    // If this function is called again it overwrites the current allowance with value.\n', '    // @param spender The address of the sender\n', '    // @param value The amount to be approved\n', '    // @return the transaction address and send the event as Approval\n', '    function approve(address spender, uint256 value) public returns (bool success)  {\n', '        require (balances[msg.sender] >= value && value > 0);\n', '        allowed[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    // Check the allowed value for the spender to withdraw from owner\n', '    // @param owner The address of the owner\n', '    // @param spender The address of the spender\n', '    // @return the amount which spender is still allowed to withdraw from owner\n', '    function allowance(address _owner, address spender) public constant returns (uint256) {\n', '        return allowed[_owner][spender];\n', '    }\n', '    \n', '    // Get current price of a Token\n', '    // @return the price or token value for a ether\n', '    function getPrice() public pure returns (uint256 result) {\n', '        return 0;\n', '    }\n', '}']
