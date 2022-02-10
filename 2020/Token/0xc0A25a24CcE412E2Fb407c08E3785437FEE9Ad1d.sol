['pragma solidity ^0.4.24;\n', '\n', '// ----------------------------------------------------------------------------\n', "// 'Orient' Token Smart Contract\n", '//\n', '// OwnerAddress : 0x9E7641216640041ca7838c9DED05538A1F001E7E\n', '// Symbol       : OFT\n', '// Name         : Orient\n', '// Total Supply : 25,000 OFT\n', '// Decimals     : 18\n', '//\n', '//\n', '// The MIT Licence.\n', '//\n', '// Prepared and Compiled By: https://bit.ly/3ixlO2e\n', '// ----------------------------------------------------------------------------\n', '\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Ownership contract\n', '// _newOwner is address of new owner\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    \n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor() public {\n', '        owner = 0x9E7641216640041ca7838c9DED05538A1F001E7E;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    // transfer Ownership to other address\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        require(_newOwner != address(0x0));\n', '        emit OwnershipTransferred(owner,_newOwner);\n', '        owner = _newOwner;\n', '    }\n', '    \n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20 Token, with the addition of symbol, name and decimals and an\n', '// initial fixed supply\n', '// ----------------------------------------------------------------------------\n', 'contract OrientToken is ERC20Interface, Owned {\n', '    \n', '    using SafeMath for uint;\n', '\n', '    string public symbol;\n', '    string public  name;\n', '    uint8 public decimals;\n', '    uint public _totalSupply;\n', '    uint public RATE;\n', '    uint public DENOMINATOR;\n', '    bool public isStopped = false;\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '    \n', '    event Mint(address indexed to, uint256 amount);\n', '    event ChangeRate(uint256 amount);\n', '    \n', '    modifier onlyWhenRunning {\n', '        require(!isStopped);\n', '        _;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    constructor() public {\n', '        symbol = "OFT";\n', '        name = "Orient";\n', '        decimals = 18;\n', '        _totalSupply = 25000 * 10**uint(decimals);\n', '        balances[owner] = _totalSupply;\n', '        RATE = 300000; // 1 ETH = 30 OFT \n', '        DENOMINATOR = 10000;\n', '        emit Transfer(address(0), owner, _totalSupply);\n', '    }\n', '    \n', '    \n', '    // ----------------------------------------------------------------------------\n', '    // requires enough gas for execution\n', '    // ----------------------------------------------------------------------------\n', '    function() public payable {\n', '        buyTokens();\n', '    }\n', '    \n', '    \n', '    // ----------------------------------------------------------------------------\n', '    // Function to handle eth and token transfers\n', '    // tokens are transferred to user\n', '    // ETH are transferred to current owner\n', '    // ----------------------------------------------------------------------------\n', '    function buyTokens() onlyWhenRunning public payable {\n', '        require(msg.value > 0);\n', '        \n', '        uint tokens = msg.value.mul(RATE).div(DENOMINATOR);\n', '        require(balances[owner] >= tokens);\n', '        \n', '        balances[msg.sender] = balances[msg.sender].add(tokens);\n', '        balances[owner] = balances[owner].sub(tokens);\n', '        \n', '        emit Transfer(owner, msg.sender, tokens);\n', '        \n', '        owner.transfer(msg.value);\n', '    }\n', '    \n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public view returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public view returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Transfer the balance from token owner's account to `to` account\n", "    // - Owner's account must have sufficient balance to transfer\n", '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        require(to != address(0));\n', '        require(tokens > 0);\n', '        require(balances[msg.sender] >= tokens);\n', '        \n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account\n", '    //\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces \n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        require(spender != address(0));\n', '        require(tokens > 0);\n', '        \n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    // \n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        require(from != address(0));\n', '        require(to != address(0));\n', '        require(tokens > 0);\n', '        require(balances[from] >= tokens);\n', '        require(allowed[from][msg.sender] >= tokens);\n', '        \n', '        balances[from] = balances[from].sub(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', "    // transferred to the spender's account\n", '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '    \n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Increase the amount of tokens that an owner allowed to a spender.\n', '    //\n', '    // approve should be called when allowed[_spender] == 0. To increment\n', '    // allowed value is better to use this function to avoid 2 calls (and wait until\n', '    // the first transaction is mined)\n', '    // _spender The address which will spend the funds.\n', '    // _addedValue The amount of tokens to increase the allowance by.\n', '    // ------------------------------------------------------------------------\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        require(_spender != address(0));\n', '        \n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '    \n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Decrease the amount of tokens that an owner allowed to a spender.\n', '    //\n', '    // approve should be called when allowed[_spender] == 0. To decrement\n', '    // allowed value is better to use this function to avoid 2 calls (and wait until\n', '    // the first transaction is mined)\n', '    // _spender The address which will spend the funds.\n', '    // _subtractedValue The amount of tokens to decrease the allowance by.\n', '    // ------------------------------------------------------------------------\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        require(_spender != address(0));\n', '        \n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '    \n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Change the ETH to IO rate\n', '    // ------------------------------------------------------------------------\n', '    function changeRate(uint256 _rate) public onlyOwner {\n', '        require(_rate > 0);\n', '        \n', '        RATE =_rate;\n', '        emit ChangeRate(_rate);\n', '    }\n', '    \n', '    \n', '    // ------------------------------------------------------------------------\n', '    // _to The address that will receive the minted tokens.\n', '    // _amount The amount of tokens to mint.\n', '    // A boolean that indicates if the operation was successful.\n', '    // ------------------------------------------------------------------------\n', '    function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_amount > 0);\n', '        \n', '        uint newamount = _amount * 10**uint(decimals);\n', '        _totalSupply = _totalSupply.add(newamount);\n', '        balances[_to] = balances[_to].add(newamount);\n', '        \n', '        emit Mint(_to, newamount);\n', '        emit Transfer(address(0), _to, newamount);\n', '        return true;\n', '    }\n', '    \n', '    \n', '    // ------------------------------------------------------------------------\n', '    // function to stop the ICO\n', '    // ------------------------------------------------------------------------\n', '    function stopICO() onlyOwner public {\n', '        isStopped = true;\n', '    }\n', '    \n', '    \n', '    // ------------------------------------------------------------------------\n', '    // function to resume ICO\n', '    // ------------------------------------------------------------------------\n', '    function resumeICO() onlyOwner public {\n', '        isStopped = false;\n', '    }\n', '\n', '}']