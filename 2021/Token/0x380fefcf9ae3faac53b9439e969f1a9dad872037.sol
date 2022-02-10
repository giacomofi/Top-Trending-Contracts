['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-28\n', '*/\n', '\n', 'pragma solidity 0.6.6;\n', '\n', '// ----------------------------------------------------------------------------\n', "// 'MJCoin' token contract\n", '// (c) by Mario Brandinu, Santa Cruz España.\n', '// ----------------------------------------------------------------------------\n', '// ----------------------------------------------------------------------------\n', '// Safe maths\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// ----------------------------------------------------------------------------\n', 'abstract contract MJCInterface {\n', '    function totalSupply() virtual public view returns (uint);\n', '    function balanceOf(address tokenOwner) virtual public view returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) virtual public view returns (uint remaining);\n', '    function transfer(address to, uint tokens) virtual public returns (bool success);\n', '    function approve(address spender, uint tokens) virtual public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) virtual public returns (bool success);\n', '    function buyToken(address payable sellerAddress, uint tokens) virtual payable public  returns (bool success);\n', '    \n', '   /* function getTokenName() virtual view public returns(string memory);\n', '    function getTokenSymbol() virtual view public  returns (string memory);\n', '    function getTokenDecimals() virtual view public  returns (uint8);*/\n', '    \n', '    // function CrowdsToSaleGet() virtual view public returns (address[] memory);\n', '    // function CrowdsToSaleAdd(address artContract) virtual public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '    \n', '    event Bought(uint256 amount);\n', '    event Sold(uint256 amount);\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Contract function to receive approval and execute function in one call\n', '//\n', '// Borrowed from MiniMeToken\n', '// ----------------------------------------------------------------------------\n', 'abstract contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes memory data) virtual public;\n', '}\n', '\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20 Token, with the addition of symbol, name and decimals and assisted\n', '// token transfers\n', '// ----------------------------------------------------------------------------\n', 'contract MJCoin is MJCInterface {//, Owned, SafeMath \n', '    string public symbol;\n', '    string public  name;\n', '    uint8 public decimals;\n', '    uint public _totalSupply;\n', '    \n', '    address payable public  owner;\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '    event FundTransfer(address seller, uint amount, bool isContribution);\n', '    \n', '    //address[] public CrowdsToSale;\n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    constructor() public {\n', '        symbol = "MJC";\n', '        name = "MaryJaneCoin";\n', '        decimals = 0;\n', '        _totalSupply = 1000000;\n', '        owner = msg.sender;\n', '        balances[owner] = _totalSupply;\n', '        emit Transfer(address(0), owner, _totalSupply);\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public override view returns (uint) {\n', '        return _totalSupply - balances[address(0)];\n', '    }\n', '    \n', '    function addSupply(uint newTokens) public  returns (bool esito) {\n', '        require(msg.sender == owner,"Solo il propritario puo aggiungere tokens");\n', '        _totalSupply = _totalSupply + newTokens;\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account tokenOwner\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public override view returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Transfer the balance from token owner's account to to account\n", "    // - Owner's account must have sufficient balance to transfer\n", '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public override returns (bool success) {\n', '        balances[msg.sender] = balances[msg.sender] - tokens;\n', '        balances[to] = balances[to] + tokens;\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for spender to transferFrom(...) tokens\n', "    // from the token owner's account\n", '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces \n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public override returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer tokens from the from account to the to account\n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the from account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public override returns (bool success) {\n', '        //balances[from] = safeSub(balances[from], tokens);\n', '        balances[from] = balances[from] - tokens;\n', "        //questa funzione permetta il ritiro dei token se l'asta non va in successo\n", "        //rettifica momentanea ma poi attivare l'approvazione nel processo\n", '       /* if(allowed[from][msg.sender]>0){\n', '        allowed[from][msg.sender] = //safeSub(allowed[from][msg.sender], tokens);}*/\n', '        allowed[from][msg.sender] = allowed[from][msg.sender] - tokens;\n', '       // balances[to] = safeAdd(balances[to], tokens);\n', '        balances[to] = balances[to] + tokens;\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', "    // transferred to the spender's account\n", '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public override view returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for spender to transferFrom(...) tokens\n', "    // from the token owner's account. The spender contract function\n", '    // receiveApproval(...) is then executed\n', '    // ------------------------------------------------------------------------\n', '    function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Don't accept ETH\n", '    // ------------------------------------------------------------------------\n', '    // function () external payable {\n', '    //     revert();\n', '    // }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Owner can transfer out any accidentally sent ERC20 tokens\n', '    // ------------------------------------------------------------------------\n', ' /*   function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '        return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '    }*/\n', '    \n', '    function buyToken(address payable sellerAddress, uint tokens) payable public override returns (bool success) {//\n', '        uint256 sellerBalance = balanceOf(sellerAddress);\n', '        require(tokens <= sellerBalance, "Not enough tokens in the Seller reserve");\n', '        balances[sellerAddress] = balances[sellerAddress] - tokens;\n', '        balances[msg.sender] = balances[msg.sender] + tokens;\n', '        emit Transfer(sellerAddress, msg.sender, tokens);\n', '        sellerAddress.transfer(msg.value);\n', '        \n', '        emit Bought(msg.value);\n', '        \n', '        return true;\n', '    }\n', '    \n', '\n', '}']