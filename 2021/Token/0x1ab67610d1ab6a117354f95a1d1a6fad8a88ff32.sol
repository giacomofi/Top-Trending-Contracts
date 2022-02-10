['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-26\n', '*/\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '//         `-::::.`                                                     \n', '//      :sdNNmmmmNmds:                               `-:///:-`          \n', '//    /dNmmmmmmmmmmmmmm+`                         -sdmNmmmmmmmds:`      \n', '//  `hNmmmmmmmmmmmmmmmmmd.                      -hmmmmmmmmmmmmmmmmo.    \n', '// `dmmmmmmmmmmmmmmmmmmmmm.                    /mmmmmmmmmmmmmmmmmmmm+   \n', '// yNmmmmmmmmmmmmmmmmmmmmms                   .mmmmmmmmmmmmmmmmmmmmmNy` \n', '//-mmmmmmmmmmmmmmmmmmmmmmmd                   /NmmmmmmmmmmmmmmmmmmmmmNs \n', '///Nmmmmmmmmmmmmmmmmmmmmmmh                   /Nmmmmmmmmmmmmmmmmmmmmmmm.\n', '//-NmmmmmmmmmmmmmmmmmmmmmN+    `.-:////:-.`   .mmmmmmmmmmmmmmmmmmmmmmmN/\n', '// hmmmmmmmmmmmmmmmmmmmmNh-//::--:odNmmho+++++:oNmmmmmmmmmmmmmmmmmmmmmN:\n', '// .dmmmmmmmmmmmmmmmmmmmNh/`        +y.       .ommmmmmmmmmmmmmmmmmmmmmd \n', '//  `ymmmmmmmmmmmmmmmmmd:                       .yNmmmmmmmmmmmmmmmmmmm- \n', '//    -smmmmmmmmmmmmmmh`        .-      ..        yNmmmmmmmmmmmmmmmmh.  \n', '//      `:oyhdddhymmmd`       ./ .+   `o.`+`      `dmmmmmmmmmmmmmmy:    \n', '//              `yNmm:       `o   :-  o.  .+       +mmmmosyhhys+:`      \n', '//              yNmmm`       ::   `+ `o    o       -Nmmmy`              \n', '//             +Nmmmm`       /-    + :-   `+       :NmmmNo              \n', '//            `mmmmmm:       -: omo+ ++d+ :-       ymmmmmm-             \n', '//            /Nmmmmmd`       o`NmN- +mmy`/       /mmmmmmms             \n', '//            smmmmmmNh`      .+ddh//ohdo+       +mNmmmmmmd             \n', '//            ymNho/---.     .--/+ossso/-.-`    ```./sdmmmd             \n', '//            +d-            `smmmmmmmmmNh.            +mms             \n', '//            y.    -/:`     +NmmmmmmmmmmN+     `-:+:   :m.             \n', '//           `m    +:+`      .ymmmmmmmmmmo       `:-./  `h              \n', '//            o+  `   /:       ./+ooo+/-       `::      :+              \n', '//             s+      .//.                  :+/`      -s               \n', '//              /s`      .dho/-`       `.:oymo        /+                \n', '//               `oo`     `hmmNNmmddddmmNmmm/       :o-                 \n', '//                 `+o/`   `sNmdsoohmmmdmmd-     .+o-                   \n', '//                    .++/::./y`   -:`  :+`-..://:`                     \n', '//                        `.:+::/:...://./+/:-`                         \n', '//                            -+/:::--/++`                              \n', '//                               .:::-`                                 \n', '\n', '\n', '//MickeyMouse is a meme based token to kickstart a series of Disney Meme Tokens\n', '\n', "//Let's bring the childhood good memories to our adulthood\n", '\n', '// ----------------------------------------------------------------------------\n', '// Lib: Safe Math\n', '// ----------------------------------------------------------------------------\n', 'contract SafeMath {\n', '\n', '    function safeAdd(uint a, uint b) public pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '\n', '    function safeSub(uint a, uint b) public pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '\n', '    function safeMul(uint a, uint b) public pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '\n', '    function safeDiv(uint a, uint b) public pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '\n', '/**\n', 'ERC Token Standard #20 Interface\n', 'https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '*/\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '\n', '/**\n', 'Contract function to receive approval and execute function in one call\n', 'Borrowed from MiniMeToken\n', '*/\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '}\n', '\n', '/**\n', 'ERC20 Token, with the addition of symbol, name and decimals and assisted token transfers\n', '*/\n', 'contract MickeyMouse is ERC20Interface, SafeMath {\n', '    string public symbol;\n', '    string public  name;\n', '    uint8 public decimals;\n', '    uint public _totalSupply;\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    constructor() public {\n', '        symbol = "MICKEY";\n', '        name = "Mickey Mouse";\n', '        decimals = 18;\n', '        _totalSupply = 1000000000000000 * 10**18;\n', '        balances[0x023356A07e80EB93fF57Dfc0B0d68814DD75988d] = _totalSupply;\n', '        emit Transfer(address(0), 0x023356A07e80EB93fF57Dfc0B0d68814DD75988d, _totalSupply);\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public constant returns (uint) {\n', '        return _totalSupply  - balances[address(0)];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account tokenOwner\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Transfer the balance from token owner's account to to account\n", "    // - Owner's account must have sufficient balance to transfer\n", '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        balances[msg.sender] = safeSub(balances[msg.sender], tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for spender to transferFrom(...) tokens\n', "    // from the token owner's account\n", '    //\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces \n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer tokens from the from account to the to account\n', '    // \n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the from account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        balances[from] = safeSub(balances[from], tokens);\n', '        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', "    // transferred to the spender's account\n", '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for spender to transferFrom(...) tokens\n', "    // from the token owner's account. The spender contract function\n", '    // receiveApproval(...) is then executed\n', '    // ------------------------------------------------------------------------\n', '    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Don't accept ETH\n", '    // ------------------------------------------------------------------------\n', '    function () public payable {\n', '        revert();\n', '    }\n', '}']