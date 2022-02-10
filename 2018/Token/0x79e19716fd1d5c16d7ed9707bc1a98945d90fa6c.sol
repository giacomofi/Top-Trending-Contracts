['pragma solidity ^0.4.24;\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', '/// @dev The token controller contract must implement these functions\n', 'contract TokenController {\n', '    /// @notice Notifies the controller about a token transfer allowing the\n', '    ///  controller to react if desired\n', '    /// @param _from The origin of the transfer\n', '    /// @param _to The destination of the transfer\n', '    /// @param _amount The amount of the transfer\n', '    /// @return False if the controller does not authorize the transfer\n', '    function onTransfer(address _from, address _to, uint _amount) public returns(bool);\n', '\n', '    /// @notice Notifies the controller about an approval allowing the\n', '    ///  controller to react if desired\n', '    /// @param _owner The address that calls `approve()`\n', '    /// @param _spender The spender in the `approve()` call\n', '    /// @param _amount_old The current allowed amount in the `approve()` call\n', '    /// @param _amount_new The amount in the `approve()` call\n', '    /// @return False if the controller does not authorize the approval\n', '    function onApprove(address _owner, address _spender, uint _amount_old, uint _amount_new) public returns(bool);\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Dividends implementation interface\n', '// ----------------------------------------------------------------------------\n', 'contract DividendsDistributor {\n', '    function totalDividends() public constant returns (uint);\n', '    function totalUndistributedDividends() public constant returns (uint);\n', '    function totalDistributedDividends() public constant returns (uint);\n', '    function totalPaidDividends() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function distributeDividendsOnTransferFrom(address from, address to, uint tokens) public returns (bool success);\n', '    function withdrawDividends() public returns(bool success);\n', '\n', '    event DividendsDistributed(address indexed tokenOwner, uint dividends);\n', '    event DividendsPaid(address indexed tokenOwner, uint dividends);\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Contract function to receive approval and execute function in one call\n', '//\n', '// Borrowed from MiniMeToken\n', '// ----------------------------------------------------------------------------\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20 Token, with the addition of symbol, name and decimals and an\n', '// initial fixed supply\n', '// ----------------------------------------------------------------------------\n', 'contract AHF_Token is ERC20Interface, Owned {\n', '    string public constant symbol = "AHF";\n', '    string public constant name = "Ahedgefund Sagl Token";\n', '    uint8 public constant decimals = 18;\n', '    uint private constant _totalSupply = 130000000 * 10**uint(decimals);\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '    address public dividendsDistributor;\n', '    address public controller;\n', '    \n', '    // Flag that determines if the token is transferable or not.\n', '    bool public transfersEnabled;\n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    constructor() public {\n', '        balances[owner] = _totalSupply;\n', '        transfersEnabled = true;\n', '        emit Transfer(address(0), owner, _totalSupply);\n', '    }\n', '\n', '\n', '    function setDividendsDistributor(address _newDividendsDistributor) public onlyOwner {\n', '        dividendsDistributor = _newDividendsDistributor;\n', '    }\n', '\n', '    /// @notice Changes the controller of the contract\n', '    /// @param _newController The new controller of the contract\n', '    function setController(address _newController) public onlyOwner {\n', '        controller = _newController;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public constant returns (uint) {\n', '        return _totalSupply  - balances[address(0)];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', '    // from the token owner&#39;s account\n', '    //\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces \n', '    // ------------------------------------------------------------------------\n', '    function approve(address _spender, uint _amount) public returns (bool success) {\n', '        require(transfersEnabled);\n', '\n', '        // Alerts the token controller of the approve function call\n', '        if (isContract(controller)) {\n', '            require(TokenController(controller).onApprove(msg.sender, _spender, allowed[msg.sender][_spender], _amount));\n', '        }\n', '\n', '        allowed[msg.sender][_spender] = _amount;\n', '        emit Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', '    // transferred to the spender&#39;s account\n', '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer the balance from token owner&#39;s account to `to` account\n', '    // - Owner&#39;s account must have sufficient balance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address _to, uint _amount) public returns (bool success) {\n', '        require(transfersEnabled);\n', '        doTransfer(msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    // \n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {\n', '        require(transfersEnabled);\n', '\n', '        // The standard ERC 20 transferFrom functionality\n', '        require(allowed[_from][msg.sender] >= _amount);\n', '        allowed[_from][msg.sender] -= _amount;\n', '        doTransfer(_from, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '\n', '    /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on\n', '    ///  its behalf, and then a function is triggered in the contract that is\n', '    ///  being approved, `_spender`. This allows users to use their tokens to\n', '    ///  interact with contracts in one function call instead of two\n', '    /// @param _spender The address of the contract able to transfer the tokens\n', '    /// @param _amount The amount of tokens to be approved for transfer\n', '    /// @return True if the function call was successful\n', '    function approveAndCall(address _spender, uint256 _amount, bytes _extraData\n', '    ) public returns (bool success) {\n', '        require(approve(_spender, _amount));\n', '\n', '        ApproveAndCallFallBack(_spender).receiveApproval(\n', '            msg.sender,\n', '            _amount,\n', '            this,\n', '            _extraData\n', '        );\n', '\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Don&#39;t accept ETH\n', '    // ------------------------------------------------------------------------\n', '    function () public payable {\n', '        revert();\n', '    }\n', '\n', '\n', '    /// @dev This is the actual transfer function in the token contract, it can\n', '    ///  only be called by other functions in this contract.\n', '    /// @param _from The address holding the tokens being transferred\n', '    /// @param _to The address of the recipient\n', '    /// @param _amount The amount of tokens to be transferred\n', '    /// @return True if the transfer was successful\n', '    function doTransfer(address _from, address _to, uint _amount) internal {\n', '           if (_amount == 0) {\n', '               emit Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0\n', '               return;\n', '           }\n', '\n', '           // Do not allow transfer to 0x0 or the token contract itself\n', '           require((_to != 0) && (_to != address(this)));\n', '\n', '           // If the amount being transfered is more than the balance of the\n', '           //  account the transfer throws\n', '           uint previousBalanceFrom = balanceOf(_from);\n', '\n', '           require(previousBalanceFrom >= _amount);\n', '\n', '           // Alerts the token controller of the transfer\n', '           if (isContract(controller)) {\n', '               require(TokenController(controller).onTransfer(_from, _to, _amount));\n', '           }\n', '\n', '           // First update the balance array with the new value for the address\n', '           //  sending the tokens\n', '           balances[_from] = previousBalanceFrom - _amount;\n', '\n', '           // Then update the balance array with the new value for the address\n', '           //  receiving the tokens\n', '           uint previousBalanceTo = balanceOf(_to);\n', '           require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow\n', '           balances[_to] = previousBalanceTo + _amount;\n', '\n', '           // An event to make the transfer easy to find on the blockchain\n', '           emit Transfer(_from, _to, _amount);\n', '           \n', '           if (isContract(dividendsDistributor)) {\n', '                require(DividendsDistributor(dividendsDistributor).distributeDividendsOnTransferFrom(_from, _to, _amount));\n', '            }\n', '    }\n', '\n', '    /// @notice Enables token holders to transfer their tokens freely if true\n', '    /// @param _transfersEnabled True if transfers are allowed in the clone\n', '    function enableTransfers(bool _transfersEnabled) public onlyOwner {\n', '        transfersEnabled = _transfersEnabled;\n', '    }\n', '\n', '    /// @dev Internal function to determine if an address is a contract\n', '    /// @param _addr The address being queried\n', '    /// @return True if `_addr` is a contract\n', '    function isContract(address _addr) constant internal returns(bool) {\n', '        uint size;\n', '        if (_addr == 0) return false;\n', '        assembly {\n', '            size := extcodesize(_addr)\n', '        }\n', '        return size>0;\n', '    }\n', '\n', '    /// @notice This method can be used by the owner to extract mistakenly\n', '    ///  sent tokens to this contract.\n', '    /// @param _token The address of the token contract that you want to recover\n', '    ///  set to 0 in case you want to extract ether.\n', '    function claimTokens(address _token) public onlyOwner {\n', '        if (_token == 0x0) {\n', '            owner.transfer(address(this).balance);\n', '            return;\n', '        }\n', '\n', '        ERC20Interface token = ERC20Interface(_token);\n', '        uint balance = token.balanceOf(this);\n', '        token.transfer(owner, balance);\n', '        emit ClaimedTokens(_token, owner, balance);\n', '    }\n', '    \n', '    event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', '/// @dev The token controller contract must implement these functions\n', 'contract TokenController {\n', '    /// @notice Notifies the controller about a token transfer allowing the\n', '    ///  controller to react if desired\n', '    /// @param _from The origin of the transfer\n', '    /// @param _to The destination of the transfer\n', '    /// @param _amount The amount of the transfer\n', '    /// @return False if the controller does not authorize the transfer\n', '    function onTransfer(address _from, address _to, uint _amount) public returns(bool);\n', '\n', '    /// @notice Notifies the controller about an approval allowing the\n', '    ///  controller to react if desired\n', '    /// @param _owner The address that calls `approve()`\n', '    /// @param _spender The spender in the `approve()` call\n', '    /// @param _amount_old The current allowed amount in the `approve()` call\n', '    /// @param _amount_new The amount in the `approve()` call\n', '    /// @return False if the controller does not authorize the approval\n', '    function onApprove(address _owner, address _spender, uint _amount_old, uint _amount_new) public returns(bool);\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Dividends implementation interface\n', '// ----------------------------------------------------------------------------\n', 'contract DividendsDistributor {\n', '    function totalDividends() public constant returns (uint);\n', '    function totalUndistributedDividends() public constant returns (uint);\n', '    function totalDistributedDividends() public constant returns (uint);\n', '    function totalPaidDividends() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function distributeDividendsOnTransferFrom(address from, address to, uint tokens) public returns (bool success);\n', '    function withdrawDividends() public returns(bool success);\n', '\n', '    event DividendsDistributed(address indexed tokenOwner, uint dividends);\n', '    event DividendsPaid(address indexed tokenOwner, uint dividends);\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Contract function to receive approval and execute function in one call\n', '//\n', '// Borrowed from MiniMeToken\n', '// ----------------------------------------------------------------------------\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20 Token, with the addition of symbol, name and decimals and an\n', '// initial fixed supply\n', '// ----------------------------------------------------------------------------\n', 'contract AHF_Token is ERC20Interface, Owned {\n', '    string public constant symbol = "AHF";\n', '    string public constant name = "Ahedgefund Sagl Token";\n', '    uint8 public constant decimals = 18;\n', '    uint private constant _totalSupply = 130000000 * 10**uint(decimals);\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '    address public dividendsDistributor;\n', '    address public controller;\n', '    \n', '    // Flag that determines if the token is transferable or not.\n', '    bool public transfersEnabled;\n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    constructor() public {\n', '        balances[owner] = _totalSupply;\n', '        transfersEnabled = true;\n', '        emit Transfer(address(0), owner, _totalSupply);\n', '    }\n', '\n', '\n', '    function setDividendsDistributor(address _newDividendsDistributor) public onlyOwner {\n', '        dividendsDistributor = _newDividendsDistributor;\n', '    }\n', '\n', '    /// @notice Changes the controller of the contract\n', '    /// @param _newController The new controller of the contract\n', '    function setController(address _newController) public onlyOwner {\n', '        controller = _newController;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public constant returns (uint) {\n', '        return _totalSupply  - balances[address(0)];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account\n", '    //\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces \n', '    // ------------------------------------------------------------------------\n', '    function approve(address _spender, uint _amount) public returns (bool success) {\n', '        require(transfersEnabled);\n', '\n', '        // Alerts the token controller of the approve function call\n', '        if (isContract(controller)) {\n', '            require(TokenController(controller).onApprove(msg.sender, _spender, allowed[msg.sender][_spender], _amount));\n', '        }\n', '\n', '        allowed[msg.sender][_spender] = _amount;\n', '        emit Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', "    // transferred to the spender's account\n", '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Transfer the balance from token owner's account to `to` account\n", "    // - Owner's account must have sufficient balance to transfer\n", '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address _to, uint _amount) public returns (bool success) {\n', '        require(transfersEnabled);\n', '        doTransfer(msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    // \n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {\n', '        require(transfersEnabled);\n', '\n', '        // The standard ERC 20 transferFrom functionality\n', '        require(allowed[_from][msg.sender] >= _amount);\n', '        allowed[_from][msg.sender] -= _amount;\n', '        doTransfer(_from, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '\n', '    /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on\n', '    ///  its behalf, and then a function is triggered in the contract that is\n', '    ///  being approved, `_spender`. This allows users to use their tokens to\n', '    ///  interact with contracts in one function call instead of two\n', '    /// @param _spender The address of the contract able to transfer the tokens\n', '    /// @param _amount The amount of tokens to be approved for transfer\n', '    /// @return True if the function call was successful\n', '    function approveAndCall(address _spender, uint256 _amount, bytes _extraData\n', '    ) public returns (bool success) {\n', '        require(approve(_spender, _amount));\n', '\n', '        ApproveAndCallFallBack(_spender).receiveApproval(\n', '            msg.sender,\n', '            _amount,\n', '            this,\n', '            _extraData\n', '        );\n', '\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Don't accept ETH\n", '    // ------------------------------------------------------------------------\n', '    function () public payable {\n', '        revert();\n', '    }\n', '\n', '\n', '    /// @dev This is the actual transfer function in the token contract, it can\n', '    ///  only be called by other functions in this contract.\n', '    /// @param _from The address holding the tokens being transferred\n', '    /// @param _to The address of the recipient\n', '    /// @param _amount The amount of tokens to be transferred\n', '    /// @return True if the transfer was successful\n', '    function doTransfer(address _from, address _to, uint _amount) internal {\n', '           if (_amount == 0) {\n', '               emit Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0\n', '               return;\n', '           }\n', '\n', '           // Do not allow transfer to 0x0 or the token contract itself\n', '           require((_to != 0) && (_to != address(this)));\n', '\n', '           // If the amount being transfered is more than the balance of the\n', '           //  account the transfer throws\n', '           uint previousBalanceFrom = balanceOf(_from);\n', '\n', '           require(previousBalanceFrom >= _amount);\n', '\n', '           // Alerts the token controller of the transfer\n', '           if (isContract(controller)) {\n', '               require(TokenController(controller).onTransfer(_from, _to, _amount));\n', '           }\n', '\n', '           // First update the balance array with the new value for the address\n', '           //  sending the tokens\n', '           balances[_from] = previousBalanceFrom - _amount;\n', '\n', '           // Then update the balance array with the new value for the address\n', '           //  receiving the tokens\n', '           uint previousBalanceTo = balanceOf(_to);\n', '           require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow\n', '           balances[_to] = previousBalanceTo + _amount;\n', '\n', '           // An event to make the transfer easy to find on the blockchain\n', '           emit Transfer(_from, _to, _amount);\n', '           \n', '           if (isContract(dividendsDistributor)) {\n', '                require(DividendsDistributor(dividendsDistributor).distributeDividendsOnTransferFrom(_from, _to, _amount));\n', '            }\n', '    }\n', '\n', '    /// @notice Enables token holders to transfer their tokens freely if true\n', '    /// @param _transfersEnabled True if transfers are allowed in the clone\n', '    function enableTransfers(bool _transfersEnabled) public onlyOwner {\n', '        transfersEnabled = _transfersEnabled;\n', '    }\n', '\n', '    /// @dev Internal function to determine if an address is a contract\n', '    /// @param _addr The address being queried\n', '    /// @return True if `_addr` is a contract\n', '    function isContract(address _addr) constant internal returns(bool) {\n', '        uint size;\n', '        if (_addr == 0) return false;\n', '        assembly {\n', '            size := extcodesize(_addr)\n', '        }\n', '        return size>0;\n', '    }\n', '\n', '    /// @notice This method can be used by the owner to extract mistakenly\n', '    ///  sent tokens to this contract.\n', '    /// @param _token The address of the token contract that you want to recover\n', '    ///  set to 0 in case you want to extract ether.\n', '    function claimTokens(address _token) public onlyOwner {\n', '        if (_token == 0x0) {\n', '            owner.transfer(address(this).balance);\n', '            return;\n', '        }\n', '\n', '        ERC20Interface token = ERC20Interface(_token);\n', '        uint balance = token.balanceOf(this);\n', '        token.transfer(owner, balance);\n', '        emit ClaimedTokens(_token, owner, balance);\n', '    }\n', '    \n', '    event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);\n', '}']
