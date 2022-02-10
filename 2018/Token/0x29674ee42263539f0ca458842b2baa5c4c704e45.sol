['pragma solidity ^0.4.18;\n', '    \n', '    // ----------------------------------------------------------------------------\n', '    // &#39;ACT275297&#39; token contract\n', '    //\n', '    // Deployed to : 0x3f70c0B02879c36162C2C902ECfe9Ac0a8a8a187\n', '    // Symbol      : ACT275297\n', '    // Name        : ADZbuzz Scientificamerican.com Community Token\n', '    // Total supply: 2000000\n', '    // Decimals    : 8\n', '    //\n', '    // Enjoy.\n', '    //\n', '    // (c) by Moritz Neto with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.\n', '    // (c) by Darwin Jayme with ADZbuzz Ltd. UK (adzbuzz.com) 2018. \n', '    // ----------------------------------------------------------------------------\n', '    \n', '    \n', '    // ----------------------------------------------------------------------------\n', '    // Safe maths\n', '    // ----------------------------------------------------------------------------\n', '    contract SafeMath {\n', '        function safeAdd(uint a, uint b) public pure returns (uint c) {\n', '            c = a + b;\n', '            require(c >= a);\n', '        }\n', '        function safeSub(uint a, uint b) public pure returns (uint c) {\n', '            require(b <= a);\n', '            c = a - b;\n', '        }\n', '        function safeMul(uint a, uint b) public pure returns (uint c) {\n', '            c = a * b;\n', '            require(a == 0 || c / a == b);\n', '        }\n', '        function safeDiv(uint a, uint b) public pure returns (uint c) {\n', '            require(b > 0);\n', '            c = a / b;\n', '        }\n', '    }\n', '    \n', '    \n', '    // ----------------------------------------------------------------------------\n', '    // ERC Token Standard #20 Interface\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '    // ----------------------------------------------------------------------------\n', '    contract ERC20Interface {\n', '        function totalSupply() public constant returns (uint);\n', '        function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '        function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '        function transfer(address to, uint tokens) public returns (bool success);\n', '        function approve(address spender, uint tokens) public returns (bool success);\n', '        function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '    \n', '        event Transfer(address indexed from, address indexed to, uint tokens);\n', '        event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '    }\n', '    \n', '    \n', '    // ----------------------------------------------------------------------------\n', '    // Contract function to receive approval and execute function in one call\n', '    //\n', '    // Borrowed from MiniMeToken\n', '    // ----------------------------------------------------------------------------\n', '    contract ApproveAndCallFallBack {\n', '        function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '    }\n', '    \n', '    \n', '    // ----------------------------------------------------------------------------\n', '    // Owned contract\n', '    // ----------------------------------------------------------------------------\n', '    contract Owned {\n', '        address public owner;\n', '        address public newOwner;\n', '    \n', '        event OwnershipTransferred(address indexed _from, address indexed _to);\n', '    \n', '        function Owned() public {\n', '            owner = 0x3f70c0B02879c36162C2C902ECfe9Ac0a8a8a187;\n', '        }\n', '    \n', '        modifier onlyOwner {\n', '            require(msg.sender == owner);\n', '            _;\n', '        }\n', '    \n', '        function transferOwnership(address _newOwner) public onlyOwner {\n', '            newOwner = _newOwner;\n', '        }\n', '        function acceptOwnership() public {\n', '            require(msg.sender == newOwner);\n', '            emit OwnershipTransferred(owner, newOwner);\n', '            owner = newOwner;\n', '            newOwner = address(0);\n', '        }\n', '    }\n', '    \n', '    \n', '    // ----------------------------------------------------------------------------\n', '    // ERC20 Token, with the addition of symbol, name and decimals and assisted\n', '    // token transfers\n', '    // ----------------------------------------------------------------------------\n', '    contract ADZbuzzCommunityToken is ERC20Interface, Owned, SafeMath {\n', '        string public symbol;\n', '        string public  name;\n', '        uint8 public decimals;\n', '        uint public _totalSupply;\n', '    \n', '        mapping(address => uint) balances;\n', '        mapping(address => mapping(address => uint)) allowed;\n', '    \n', '    \n', '        // ------------------------------------------------------------------------\n', '        // Constructor\n', '        // ------------------------------------------------------------------------\n', '        function ADZbuzzCommunityToken() public {\n', '            symbol = "ACT275297";\n', '            name = "ADZbuzz Scientificamerican.com Community Token";\n', '            decimals = 8;\n', '            _totalSupply = 200000000000000;\n', '            balances[0x3f70c0B02879c36162C2C902ECfe9Ac0a8a8a187] = _totalSupply;\n', '            emit Transfer(address(0), 0x3f70c0B02879c36162C2C902ECfe9Ac0a8a8a187, _totalSupply);\n', '        }\n', '    \n', '    \n', '        // ------------------------------------------------------------------------\n', '        // Total supply\n', '        // ------------------------------------------------------------------------\n', '        function totalSupply() public constant returns (uint) {\n', '            return _totalSupply  - balances[address(0)];\n', '        }\n', '    \n', '    \n', '        // ------------------------------------------------------------------------\n', '        // Get the token balance for account tokenOwner\n', '        // ------------------------------------------------------------------------\n', '        function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '            return balances[tokenOwner];\n', '        }\n', '    \n', '    \n', '        // ------------------------------------------------------------------------\n', '        // Transfer the balance from token owner&#39;s account to to account\n', '        // - Owner&#39;s account must have sufficient balance to transfer\n', '        // - 0 value transfers are allowed\n', '        // ------------------------------------------------------------------------\n', '        function transfer(address to, uint tokens) public returns (bool success) {\n', '            balances[msg.sender] = safeSub(balances[msg.sender], tokens);\n', '            balances[to] = safeAdd(balances[to], tokens);\n', '            emit Transfer(msg.sender, to, tokens);\n', '            return true;\n', '        }\n', '    \n', '    \n', '        // ------------------------------------------------------------------------\n', '        // Token owner can approve for spender to transferFrom(...) tokens\n', '        // from the token owner&#39;s account\n', '        //\n', '        // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '        // recommends that there are no checks for the approval double-spend attack\n', '        // as this should be implemented in user interfaces \n', '        // ------------------------------------------------------------------------\n', '        function approve(address spender, uint tokens) public returns (bool success) {\n', '            allowed[msg.sender][spender] = tokens;\n', '            emit Approval(msg.sender, spender, tokens);\n', '            return true;\n', '        }\n', '    \n', '    \n', '        // ------------------------------------------------------------------------\n', '        // Transfer tokens from the from account to the to account\n', '        // \n', '        // The calling account must already have sufficient tokens approve(...)-d\n', '        // for spending from the from account and\n', '        // - From account must have sufficient balance to transfer\n', '        // - Spender must have sufficient allowance to transfer\n', '        // - 0 value transfers are allowed\n', '        // ------------------------------------------------------------------------\n', '        function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '            balances[from] = safeSub(balances[from], tokens);\n', '            allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);\n', '            balances[to] = safeAdd(balances[to], tokens);\n', '            emit Transfer(from, to, tokens);\n', '            return true;\n', '        }\n', '    \n', '    \n', '        // ------------------------------------------------------------------------\n', '        // Returns the amount of tokens approved by the owner that can be\n', '        // transferred to the spender&#39;s account\n', '        // ------------------------------------------------------------------------\n', '        function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '            return allowed[tokenOwner][spender];\n', '        }\n', '    \n', '    \n', '        // ------------------------------------------------------------------------\n', '        // Token owner can approve for spender to transferFrom(...) tokens\n', '        // from the token owner&#39;s account. The spender contract function\n', '        // receiveApproval(...) is then executed\n', '        // ------------------------------------------------------------------------\n', '        function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {\n', '            allowed[msg.sender][spender] = tokens;\n', '            emit Approval(msg.sender, spender, tokens);\n', '            ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '            return true;\n', '        }\n', '    \n', '    \n', '        // ------------------------------------------------------------------------\n', '        // Don&#39;t accept ETH\n', '        // ------------------------------------------------------------------------\n', '        function () public payable {\n', '            revert();\n', '        }\n', '    \n', '    \n', '        // ------------------------------------------------------------------------\n', '        // Owner can transfer out any accidentally sent ERC20 tokens\n', '        // ------------------------------------------------------------------------\n', '        function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '            return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '        }\n', '    }']