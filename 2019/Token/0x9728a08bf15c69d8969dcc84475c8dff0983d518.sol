['pragma solidity ^0.5.4;\n', '\n', '// ----------------------------------------------------------------------------\n', "// 'RNBW' token contract\n", '//\n', '// Deployed to : \n', '// Symbol      : RNBW\n', '// Name        : RNBW Token\n', '// Description : Virtual Geospatial Networking Asset\n', '// Total supply: Dynamic ITO\n', '// Decimals    : 18\n', '// ----------------------------------------------------------------------------\n', '\n', '// ----------------------------------------------------------------------------\n', '// Safe maths\n', '// ----------------------------------------------------------------------------\n', 'contract SafeMath {\n', '    function safeAdd(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '        \n', '    }\n', '    function safeSub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function safeMul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function safeDiv(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function totalSupply() public view returns (uint);\n', '    function balanceOf(address tokenOwner) public view returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Contract function to receive approval and execute function in one call\n', '// ----------------------------------------------------------------------------\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address payable token, bytes memory data) public;\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address payable public _owner;\n', '    address payable private _newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor() public {\n', '        _owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == _owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address payable newOwner) public onlyOwner {\n', '        _newOwner = newOwner;\n', '    }\n', '\n', '    function acceptOwnership() public {\n', '        require(msg.sender == _newOwner);\n', '        emit OwnershipTransferred(_owner, _newOwner);\n', '        _owner = _newOwner;\n', '        _newOwner = address(0);\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20 Token, with the addition of symbol, name and decimals and assisted\n', '// token transfers\n', '// ----------------------------------------------------------------------------\n', 'contract RNBW is ERC20Interface, Owned, SafeMath {\n', '    string public symbol;\n', '    string public name;\n', '    string public description;\n', '    uint8 public decimals;    \n', '    uint private _startDate;\n', '    uint private _bonusEnds;\n', '    uint private _endDate;\n', '    \n', '    uint256 private _internalCap;\n', '    uint256 private _softCap;\n', '    uint256 private _totalSupply;\n', '\n', '    mapping(address => uint256) _balances;\n', '    mapping(address => mapping(address => uint256)) _allowed;\n', '    mapping(address => bool) _freezeState;\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    constructor(\n', '        address payable minter) public {\n', '        \n', '        name   = "RNBW Token";\n', '        description = "Virtual Geospatial Networking Asset";\n', '        symbol = "RNBW";\n', '        decimals = 18;\n', '        _internalCap = 25000000 * 1000000000000000000;\n', '        _softCap     = _internalCap * 2;\n', '        \n', '        _bonusEnds = now + 3 days;\n', '        _endDate = now + 1 weeks;\n', '            \n', '        _owner = minter;\n', '        _balances[_owner] = _internalCap;  \n', '        _totalSupply = _internalCap;\n', '        emit Transfer(address(0), _owner, _internalCap);\n', '    }\n', '\n', '    modifier IcoSuccessful {\n', '        require(now >= _endDate);\n', '        require(_totalSupply >= _softCap);\n', '        _;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public view returns (uint) {\n', '        return _totalSupply - _balances[address(0)];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public view returns (uint balance) {\n', '        return _balances[tokenOwner];\n', '    }\n', '    \n', '    function isFreezed(address tokenOwner) public view returns (bool freezed) {\n', '        return _freezeState[tokenOwner];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Transfer the balance from token owner's account to `to` account\n", "    // - Owner's account must have sufficient balance to transfer\n", '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint256 tokens) public IcoSuccessful returns (bool success) {\n', '        require(_freezeState[msg.sender] == false);\n', '        \n', '        _balances[msg.sender] = safeSub(_balances[msg.sender], tokens);\n', '        _balances[to] = safeAdd(_balances[to], tokens);\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '    \n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account\n", '    //\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces\n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public IcoSuccessful returns (bool success) {\n', '        require( _freezeState[spender] == false);\n', '        _allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    //\n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public IcoSuccessful returns (bool success) {\n', '        require( _freezeState[from] == false && _freezeState[to] == false);\n', '        \n', '        _balances[from] = safeSub(_balances[from], tokens);\n', '        _allowed[from][msg.sender] = safeSub(_allowed[from][msg.sender], tokens);\n', '        _balances[to] = safeAdd(_balances[to], tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', "    // transferred to the spender's account\n", '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '        require(_freezeState[spender] == false);\n', '        return _allowed[tokenOwner][spender];\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account. The `spender` contract function\n", '    // `receiveApproval(...)` is then executed\n', '    // ------------------------------------------------------------------------\n', '    function approveAndCall(address spender, uint tokens, bytes memory data) public IcoSuccessful returns (bool success) {\n', '        require(_freezeState[spender] == false);\n', '        _allowed[msg.sender][spender] = tokens;\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, _owner, data);\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // 1 RNBW Tokens per 1 Wei\n', '    // ------------------------------------------------------------------------\n', '    function buy() public payable {\n', '    \n', '        require(msg.value >= 1 finney);\n', '        require(now >= _startDate && now <= _endDate);\n', '\n', '        uint256 weiValue = msg.value;\n', '        uint256 tokens = 0;\n', '        \n', '        if (now <= _bonusEnds) {\n', '            tokens = safeMul(weiValue, 2);\n', '        } else {\n', '            tokens = safeMul(weiValue, 1);\n', '        }\n', '        \n', '        _freezeState[msg.sender] = true;\n', '        _balances[msg.sender] = safeAdd(_balances[msg.sender], tokens);\n', '        _totalSupply = safeAdd(_totalSupply, tokens);\n', '        emit Transfer(address(0), msg.sender, tokens);\n', '        _owner.transfer(address(this).balance);\n', '    }\n', '    \n', '    function () payable external {\n', '        buy();\n', '    }\n', '\n', '    function burn(uint256 tokens) public onlyOwner returns (bool success) {\n', '        require(_balances[msg.sender] >= tokens);   // Check if the sender has enough\n', '        address burner = msg.sender;\n', '        _balances[burner] = safeSub(_balances[burner], tokens);\n', '        _totalSupply = safeSub(_totalSupply, tokens);\n', '        emit Transfer(burner, address(0), tokens);\n', '        return true;\n', '    }\n', '    \n', '    function burnFrom(address account, uint256 tokens) public onlyOwner returns (bool success) {\n', '        require(_balances[account] >= tokens);   // Check if the sender has enough\n', '        address burner = account;\n', '        _balances[burner] = safeSub(_balances[burner], tokens);\n', '        _totalSupply = safeSub(_totalSupply, tokens);\n', '        emit Transfer(burner, address(0), tokens);\n', '        return true;\n', '    }\n', '    \n', '    function freeze(address account) public onlyOwner returns (bool success) {\n', '        require(account != _owner && account != address(0));\n', '        _freezeState[account] = true;\n', '        return true;\n', '    }\n', '    \n', '    function unfreeze(address account) public onlyOwner returns (bool success) {\n', '        require(account != _owner && account != address(0));\n', '        _freezeState[account] = false;\n', '        return true;\n', '    }\n', '    \n', '    function mint(uint256 tokens) public onlyOwner returns (bool success)\n', '    {\n', '        require(now >= _startDate && now <= _endDate);\n', '        _balances[msg.sender] = safeAdd(_balances[msg.sender], tokens);\n', '        _totalSupply = safeAdd(_totalSupply, tokens);\n', '        emit Transfer(address(0), msg.sender, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Owner can transfer out any accidentally sent ERC20 tokens\n', '    // ------------------------------------------------------------------------\n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '        return ERC20Interface(tokenAddress).transfer(_owner, tokens);\n', '    }\n', '}']