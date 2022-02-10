['pragma solidity ^0.4.18;\n', '\n', '// ---------------------------------------------------------------------------------------------------------------------------------------\n', '//                                 ACLYD CENTRAL COMPANY IDENTITY (CCID) LISTING INDEX                                                   |\n', '//      FULL NAME                             (CONTRACT ENTRY)              :         LISTED PUBLIC INFORMATION                          |                                |                             |\n', '// Company Name                            (companyName)                    : The Aclyd Project LTD.                                     |\n', '// Company Reg. Number                     (companyRegistrationgNum)        : No. 202470 B                                               |\n', '// Jurisdiction                            (companyJurisdiction)            : Nassau, Island of New Providence, Common Wealth of Bahamas |\n', '// Type of Organization                    (companyType)                    : International Business Company                             |\n', '// Listed Manager                          (companyManager)                 : The Aclyd Group, Inc., Wyoming, USA                        |\n', '// Reg. Agent Name                         (companyRegisteredAgent)         : KLA CORPORATE SERVICES LTD.                                |\n', '// Reg. Agent Address                      (companyRegisteredAgentAddress)  : 48 Village Road (North) Nassau, New Providence, The Bahamas|\n', '//                                                                          : P.O Box N-3747                                             |\n', '// Company Address                         (companyAddress)                 : 48 Village Road (North) Nassau, New Providence, The Bahamas|\n', '//                                                                          : P.O Box N-3747                                             |\n', '// Company Official Website Domains        (companywebsites)                : https://aclyd.com | https://aclyd.io | https://aclydex.com |\n', '// CID Third Party Verification Wallet     (cidThirdPartyVerificationWallet): 0x2bea96F65407cF8ed5CEEB804001837dBCDF8b23                 |\n', '// CID Token Symbol                        (cidtokensymbol)                 : ACLYDcid                                                   |\n', '// Total Number of CID tokens Issued       (totalCIDTokensIssued)           : 11                                                         |\n', '// Central Company ID (CCID) Listing Wallet(ccidListingWallet)              : 0x81cFa21CD58eB2363C1357c46DD9F553459F9B53                 |\n', '//                                                                                                                                       |\n', '// ---------------------------------------------------------------------------------------------------------------------------------------\n', '// ---------------------------------------------------------------------------\n', '//      ICO TOKEN DETAILS    :        TOKEN INFORMATION                      |\n', '// ICO token Standard        : ERC20                                         |\n', '// ICO token Symbol          : ACLYD                                         |\n', '// ICO Total Token Supply    : 750,000,000                                   |\n', '// ICO token Contract Address: 0x34B4af7C75342f01c072FA780443575BE5E20df1    |\n', '//                                                                           |\n', "// (c) by The ACLYD PROJECT'S CENTRAL COMPANY INDENTIY (CCID) LISTING INDEX  |  \n", '// ---------------------------------------------------------------------------\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Safe maths\n', '// ----------------------------------------------------------------------------\n', 'contract SafeMath {\n', '    function safeAdd(uint a, uint b) public pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function safeSub(uint a, uint b) public pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function safeMul(uint a, uint b) public pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function safeDiv(uint a, uint b) public pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function cidTokenSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Contract function to receive approval and execute function in one call\n', '//\n', '// Borrowed from ACLYDcid TOKEN\n', '// ----------------------------------------------------------------------------\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20 Token, with the addition of symbol, name and decimals and assisted\n', '// token transfers\n', '// ----------------------------------------------------------------------------\n', 'contract ACLYDcidTOKEN is ERC20Interface, Owned, SafeMath {\n', '    /* Public variables of the TheAclydProject */\n', '    string public companyName = "The Aclyd Project LTD.";\n', '    string public companyRegistrationgNum = "No. 202470 B";\n', '    string public companyJurisdiction =  "Nassau, Island of New Providence, Common Wealth of Bahamas";\n', '    string public companyType  = "International Business Company";\n', '    string public companyManager = "The Aclyd Group Inc., Wyoming, USA";\n', '    string public companyRegisteredAgent = "KLA CORPORATE SERVICES LTD.";\n', '    string public companyRegisteredAgentAddress = "48 Village Road (North) Nassau, New Providence, The Bahamas, P.O Box N-3747";\n', '    string public companyAddress = "48 Village Road (North) Nassau, New Providence, The Bahamas, P.O Box N-3747";\n', '    string public companywebsites = "https://aclyd.com | https://aclyd.io | https://aclydex.com";\n', '    string public cidThirdPartyVerificationWallet = "0x2bea96F65407cF8ed5CEEB804001837dBCDF8b23";\n', '    string public cidTokenSymbol = "ACLYDcid";\n', '    string public totalCIDTokensIssued = "11";\n', '    string public ccidListingWallet = "0x81cFa21CD58eB2363C1357c46DD9F553459F9B53";\n', '    uint8 public  decimals;\n', '    uint public   _cidTokenSupply; \n', '    string public icoTokenStandard = "ERC20";\n', '    string public icoTokenSymbol = "ACLYD";\n', '    string public icoTotalTokenSupply ="750,000,000";\n', '    string public icoTokenContractAddress = "0xAFeB1579290E60f72D7A642A87BeE5BFF633735A";\n', '    \n', '    \n', '    \n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '\n', '   // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    function ACLYDcidTOKEN() public {\n', '        cidTokenSymbol = "ACLYDcid";\n', '        companyName = "The Aclyd Project LTD.";\n', '        decimals = 0;\n', '        _cidTokenSupply = 11;\n', '        balances[0x2bea96F65407cF8ed5CEEB804001837dBCDF8b23] = _cidTokenSupply;\n', '        Transfer(address(0), 0x2bea96F65407cF8ed5CEEB804001837dBCDF8b23, _cidTokenSupply);\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function cidTokenSupply() public constant returns (uint) {\n', '        return _cidTokenSupply  - balances[address(0)];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account tokenOwner\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Transfer the balance from token owner's account to  account\n", "    // - Owner's account must have sufficient balance to transfer\n", '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        balances[msg.sender] = safeSub(balances[msg.sender], tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);\n', '        Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for spender to transferFrom(...) tokens\n', "    // from the token owner's account\n", '    //\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces \n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer tokens from the from account to the to account\n', '    // \n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the from account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        balances[from] = safeSub(balances[from], tokens);\n', '        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);\n', '        Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', "    // transferred to the spender's account\n", '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for spender to transferFrom(...) tokens\n', "    // from the token owner's account. The spender contract function\n", '    // receiveApproval(...) is then executed\n', '    // ------------------------------------------------------------------------\n', '    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        Approval(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Don't accept ETH\n", '    // ------------------------------------------------------------------------\n', '    function () public payable {\n', '        revert();\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Owner can transfer out any accidentally sent ERC20 tokens\n', '    // ------------------------------------------------------------------------\n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '        return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '    }\n', '}']