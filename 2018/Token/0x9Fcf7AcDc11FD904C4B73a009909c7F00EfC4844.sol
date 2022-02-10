['pragma solidity 0.4.21;\n', '\n', '// ----------------------------------------------------------------------------\n', "// 'INO8' 'Innovate Token' token contract\n", '//\n', '// Symbol      : INO8\n', '// Name        : InnovateToken\n', '// Total supply: Generated from contributions\n', '// Decimals    : 18\n', '//\n', '//\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Safe maths\n', '// ----------------------------------------------------------------------------\n', 'contract SafeMath {\n', '    function safeAdd(uint a, uint b) public pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function safeSub(uint a, uint b) public pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function safeMul(uint a, uint b) public pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function safeDiv(uint a, uint b) public pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function totalSupply() public view returns (uint);\n', '    function balanceOf(address tokenOwner) public view returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Contract function to receive approval and execute function in one call\n', '//\n', '// Borrowed from MiniMeToken\n', '// ----------------------------------------------------------------------------\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20 Token, with the addition of symbol, name and decimals\n', '// Receives ETH and generates tokens\n', '// ----------------------------------------------------------------------------\n', 'contract InnovateToken is ERC20Interface, Owned, SafeMath {\n', '    string public symbol;\n', '    string public  name;\n', '    uint8 public decimals;\n', '    uint public _totalSupply;\n', '  \n', '\n', '    uint256 public sellPrice;\n', '    uint256 public buyPrice;\n', '\n', '\n', '    mapping(address => uint) public balances;\n', '    mapping(address => mapping(address => uint)) public allowed;\n', '    mapping (address => bool) public frozenAccount;\n', '\n', '     /* This generates a public event on the blockchain that will notify clients */\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '     // This notifies clients about the amount burnt\n', '    event Burn(address indexed from, uint256 value);\n', '    /**\n', '    * @dev Fix for the ERC20 short address attack.\n', '    */\n', '    modifier onlyPayloadSize(uint size) {\n', '        assert(msg.data.length >= size + 4);\n', '        _;\n', '    } \n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    function InnovateToken() public {\n', '        symbol = "INO8";\n', '        name = "InnovateToken";\n', '        decimals = 18;\n', '        _totalSupply = 250000000 * 10**uint(decimals);\n', '        balances[owner] = _totalSupply;\n', '        emit Transfer(address(0), owner, _totalSupply);\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public view returns (uint) {\n', '        return safeSub(_totalSupply , balances[address(0)]);\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public view returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '   \n', '\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Transfer the balance from token owner's account to `to` account\n", "    // - Owner's account must have sufficient balance to transfer\n", '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) onlyPayloadSize(safeMul(2,32)) public  returns (bool success) {\n', '        _transfer(msg.sender, to, tokens);              // makes the transfers\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account\n", '    //\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces \n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    // \n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens)  onlyPayloadSize(safeMul(3,32)) public returns (bool success) {\n', '\n', '        require (to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\n', '        require (balances[from] >= tokens);               // Check if the sender has enough\n', '        require (safeAdd(balances[to] , tokens) >= balances[to]); // Check for overflows\n', '        require(!frozenAccount[from]);                     // Check if sender is frozen\n', '        require(!frozenAccount[to]);                       // Check if recipient is frozen\n', '\n', '        balances[from] = safeSub(balances[from], tokens);\n', '        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', "    // transferred to the spender's account\n", '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account. The `spender` contract function\n", '    // `receiveApproval(...)` is then executed\n', '    // ------------------------------------------------------------------------\n', '    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '        return true;\n', '    }\n', '\n', '\n', '\n', '     /// @notice Create `mintedAmount` tokens and send it to `target`\n', '    /// @param target Address to receive the tokens\n', '    /// @param mintedAmount the amount of tokens it will receive\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '        balances[target] = safeAdd(balances[target], mintedAmount);    \n', '        _totalSupply = safeAdd(_totalSupply, mintedAmount);\n', '        emit Transfer(0, this, mintedAmount);\n', '        emit Transfer(this, target, mintedAmount);\n', '    }\n', '\n', '     /// @notice `freeze? Prevent | Allow` `from` from sending & receiving tokens\n', '    /// @param from Address to be frozen\n', '    /// @param freeze either to freeze it or not\n', '    function freezeAccount(address from, bool freeze) onlyOwner public {\n', '        frozenAccount[from] = freeze;\n', '        emit FrozenFunds(from, freeze);\n', '    }\n', '    \n', '\n', '    /* Internal transfer, only can be called by this contract */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\n', '        require (balances[_from] >= _value);               // Check if the sender has enough\n', '        require (safeAdd(balances[_to] , _value) >= balances[_to]); // Check for overflows\n', '        require(!frozenAccount[_from]);                     // Check if sender is frozen\n', '        require(!frozenAccount[_to]);                       // Check if recipient is frozen\n', '        \n', '        balances[_from] = safeSub(balances[_from], _value);\n', '        balances[_to] = safeAdd(balances[_to], _value);              \n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '\n', '    /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth\n', '    /// @param newSellPrice Price the users can sell to the contract\n', '    /// @param newBuyPrice Price users can buy from the contract\n', '    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {\n', '        sellPrice = newSellPrice;\n', '        buyPrice = newBuyPrice;\n', '    }\n', '\n', '    /// @notice Buy tokens from contract by sending ether\n', '    function buy() payable public {\n', '        uint amount = safeDiv(msg.value , buyPrice);               // calculates the amount\n', '        _transfer(this, msg.sender, amount);              // makes the transfers\n', '    }\n', '\n', '    /// @notice Sell `amount` tokens to contract\n', '    /// @param amount amount of tokens to be sold\n', '    function sell(uint256 amount) public {\n', '        require(address(this).balance >= safeMul(amount ,sellPrice));      // checks if the contract has enough ether to buy\n', '        _transfer(msg.sender, this, amount);              // makes the transfers\n', "        msg.sender.transfer(safeMul(amount ,sellPrice));          // sends ether to the seller. It's important to do this last to avoid recursion attacks\n", '    }\n', '\n', '    /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balances[msg.sender] >= _value);   // Check if the sender has enough\n', '        balances[msg.sender] = safeSub(balances[msg.sender], _value); // Subtract from the sender\n', '        _totalSupply = safeSub(_totalSupply, _value); // Updates totalSupply\n', '                     \n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balances[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowed[_from][msg.sender]);    // Check allowance\n', '        balances[_from] = safeSub(balances[_from], _value); // Subtract from the targeted balance\n', "        allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value); // Subtract from the sender's allowance\n", '        _totalSupply = safeSub(_totalSupply, _value);  // Update totalSupply\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Owner can transfer out any accidentally sent ERC20 tokens\n', '    // ------------------------------------------------------------------------\n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '        return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '    }\n', '}']