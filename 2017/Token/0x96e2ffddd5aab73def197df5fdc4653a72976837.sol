['pragma solidity ^0.4.18;\n', '\n', '// ----------------------------------------------------------------------------\n', "// 'LEIA' 'Save Princess Leia Peach Rainbow Vomit Cat ICO Token' token contract\n", '//\n', '// Princess Leia Peach Rainbow Vomit Cat #52\n', '//   http://cryptocats.thetwentysix.io/#cbp=cats/52.html\n', '// has been catnapped by\n', '//   https://etherscan.io/address/0x4532874375f2417abadbde9003a7a468d4b926bd\n', '// \n', '// A 10 ETH ransom demand has been made by @Ajent007 aka  @AJoobandi .\n', '//\n', '// * Help save Princess Leia Peach Rainbow Vomit Cat #52\n', '// * Send your ETH to this crowdsale contract at\n', '//   0x96E2fFDdd5aaB73dEf197df5fDC4653a72976837\n', '// * A friendly reminder not to send your ETH anywhere else\n', '// * 75% of raised funds will be used to:\n', '//   * Blacklist 0x4532874375f2417abadbde9003a7a468d4b926bd in `geth`, Parity\n', '//     and crypto-exchanges worldwide like the 13 million Tether hack\n', '//     https://github.com/tetherto/omnicore/blob/0e43bc4734cae29fa99d287c51619ffc9ae0019a/src/omnicore/omnicore.cpp#L831-L834\n', '//   * Add 0x4532874375f2417abadbde9003a7a468d4b926bd to https://etherscamdb.info/\n', '//     for feline extortion\n', "// * 25% of raised ETH to fund the founder's lifestyle\n", '// * Crowdsale period 4 weeks\n', '// * 20% bonus in the first week\n', '// * 1,000 tokens per 1 ETH.\n', '// * Nice work Team CryptoCats @CryptoCats26 http://cryptocats.thetwentysix.io/\n', '// * Nice work @bitfwdxyz bitfwd.xyz for the MCIC blockathon 2017\n', '//   https://twitter.com/bitfwdxyz/status/933105474228011008\n', '// * Best of luck for the hackathon teams!!!\n', '//\n', '// ICO & token  : 0x96E2fFDdd5aaB73dEf197df5fDC4653a72976837\n', '// SafeMath lib : 0x7c9801326a2A8394e45dBAcC115c975381A693aE\n', '// Symbol       : LEIA\n', '// Name         : Save Princess Leia Peach Rainbow Vomit Cat ICO Token\n', '// Total supply : many\n', '// Decimals     : 18\n', '//\n', '// https://github.com/bokkypoobah/Tokens/blob/master/contracts/SavePrincessLeiaPeachRainbowVomitCatICOToken.sol\n', '//\n', '// Enjoy.\n', '//\n', '// (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Safe maths\n', '// ----------------------------------------------------------------------------\n', 'library SafeMath {\n', '    function add(uint a, uint b) public pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) public pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) public pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) public pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Contract function to receive approval and execute function in one call\n', '//\n', '// Borrowed from MiniMeToken\n', '// ----------------------------------------------------------------------------\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20 Token, with the addition of symbol, name and decimals and assisted\n', '// token transfers\n', '// ----------------------------------------------------------------------------\n', 'contract SavePrincessLeiaPeachRainbowVomitCatICOToken is ERC20Interface, Owned {\n', '    using SafeMath for uint;\n', '\n', '    string public symbol;\n', '    string public  name;\n', '    uint8 public decimals;\n', '    uint public _totalSupply;\n', '    uint public startDate;\n', '    uint public bonusEnds;\n', '    uint public endDate;\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    function SavePrincessLeiaPeachRainbowVomitCatICOToken() public {\n', '        symbol = "LEIA";\n', '        name = "Save Princess Leia Peach Rainbow Vomit Cat ICO Token";\n', '        decimals = 18;\n', '        startDate = now;\n', '        bonusEnds = now + 1 weeks;\n', '        endDate = now + 4 weeks;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public constant returns (uint) {\n', '        return _totalSupply  - balances[address(0)];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Transfer the balance from token owner's account to `to` account\n", "    // - Owner's account must have sufficient balance to transfer\n", '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account\n", '    //\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces \n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    // \n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        balances[from] = balances[from].sub(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', "    // transferred to the spender's account\n", '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account. The `spender` contract function\n", '    // `receiveApproval(...)` is then executed\n', '    // ------------------------------------------------------------------------\n', '    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        Approval(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // 1,000 LEIA per 1 ETH\n', '    // ------------------------------------------------------------------------\n', '    function () public payable {\n', '        require(now >= startDate && now <= endDate);\n', '        uint tokens;\n', '        if (now <= bonusEnds) {\n', '            tokens = msg.value * 1200;\n', '        } else {\n', '            tokens = msg.value * 1000;\n', '        }\n', '        balances[msg.sender] = balances[msg.sender].add(tokens);\n', '        _totalSupply = _totalSupply.add(tokens);\n', '        Transfer(address(0), msg.sender, tokens);\n', '        msg.sender.transfer(msg.value);\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Owner can transfer out any accidentally sent ERC20 tokens\n', '    // ------------------------------------------------------------------------\n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '        return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '    }\n', '}']