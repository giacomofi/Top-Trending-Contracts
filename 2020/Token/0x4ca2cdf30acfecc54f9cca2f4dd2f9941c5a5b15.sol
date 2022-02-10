['/**\n', ' * https://seen.haus/\n', ' * \n', ' * Listing but only advising those who read contracts. Fuck the rest, Kirby angry.\n', ' * \n', ' * \n', '*/\n', '\n', 'pragma solidity ^0.5.17;\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '  function totalSupply() public view returns (uint);\n', '  function balanceOf(address tokenOwner) public view returns (uint balance);\n', '  function allowance(address tokenOwner, address spender) public view returns (uint remaining);\n', '  function transfer(address to, uint tokens) public returns (bool success);\n', '  function approve(address spender, uint tokens) public returns (bool success);\n', '  function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '  event Transfer(address indexed from, address indexed to, uint tokens);\n', '  event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Safe maths\n', '// ----------------------------------------------------------------------------\n', 'library SafeMath {\n', '  function add(uint a, uint b) internal pure returns (uint c) {\n', '    c = a + b;\n', '    require(c >= a);\n', '  }\n', '  function sub(uint a, uint b) internal pure returns (uint c) {\n', '    require(b <= a);\n', '    c = a - b;\n', '  }\n', '  function mul(uint a, uint b) internal pure returns (uint c) {\n', '    c = a * b;\n', '    require(a == 0 || c / a == b); // the same as: if (a !=0 && c / a != b) {throw;}\n', '  }\n', '  function div(uint a, uint b) internal pure returns (uint c) {\n', '    require(b > 0);\n', '    c = a / b;\n', '  }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20 Token, with the addition of symbol, name and decimals and an\n', '// initial fixed supply\n', '// ----------------------------------------------------------------------------\n', 'contract SeenHaus is ERC20Interface {\n', '  using SafeMath for uint;\n', '\n', '  string public symbol;\n', '  string public  name;\n', '  uint8 public decimals;\n', '  uint _totalSupply;\n', '\n', '  mapping(address => uint) balances;\n', '  mapping(address => mapping(address => uint)) allowed;\n', '\n', '\n', '  // ------------------------------------------------------------------------\n', '  // Constructor\n', '  // ------------------------------------------------------------------------\n', '  constructor() public {\n', '    symbol = "SEEN";\n', '    name = "Seen Haus";\n', '    decimals = 18;\n', '    _totalSupply = 2000 * 10**uint(decimals);\n', '    balances[msg.sender] = _totalSupply;\n', '    emit Transfer(address(0), msg.sender, _totalSupply);\n', '  }\n', '\n', '  // ------------------------------------------------------------------------\n', '  // Total supply\n', '  // ------------------------------------------------------------------------\n', '  function totalSupply() public view returns (uint) {\n', '    return _totalSupply;\n', '  }\n', '\n', '  // ------------------------------------------------------------------------\n', '  // Get the token balance for account `tokenOwner`\n', '  // ------------------------------------------------------------------------\n', '  function balanceOf(address tokenOwner) public view returns (uint balance) {\n', '    return balances[tokenOwner];\n', '  }\n', '\n', '  // ------------------------------------------------------------------------\n', "  // Transfer the balance from token owner's account to `to` account\n", "  // - Owner's account must have sufficient balance to transfer\n", '  // - 0 value transfers are allowed\n', '  // ------------------------------------------------------------------------\n', '  function transfer(address to, uint tokens) public returns (bool success) {\n', '    require(to != address(0), "to address is a zero address"); \n', '    balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '    balances[to] = balances[to].add(tokens);\n', '    emit Transfer(msg.sender, to, tokens);\n', '    return true;\n', '  }\n', '\n', '  // ------------------------------------------------------------------------\n', '  // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "  // from the token owner's account\n", '  //\n', '  // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '  // recommends that there are no checks for the approval double-spend attack\n', '  // as this should be implemented in user interfaces\n', '  // ------------------------------------------------------------------------\n', '  function approve(address spender, uint tokens) public returns (bool success) {\n', '    require(spender != address(0), "spender address is a zero address");   \n', '    allowed[msg.sender][spender] = tokens;\n', '    emit Approval(msg.sender, spender, tokens);\n', '    return true;\n', '  }\n', '\n', '  // ------------------------------------------------------------------------\n', '  // Transfer `tokens` from the `from` account to the `to` account\n', '  //\n', '  // The calling account must already have sufficient tokens approve(...)-d\n', '  // for spending from the `from` account and\n', '  // - From account must have sufficient balance to transfer\n', '  // - Spender must have sufficient allowance to transfer\n', '  // - 0 value transfers are allowed\n', '  // ------------------------------------------------------------------------\n', '  function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '    require(to != address(0), "to address is a zero address"); \n', '    balances[from] != balances[from].sub(tokens);\n', '    allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '    balances[to] = balances[to].add(tokens);\n', '    emit Transfer(from, to, tokens);\n', '    return true;\n', '  }\n', '\n', '  // ------------------------------------------------------------------------\n', '  // Returns the amount of tokens approved by the owner that can be\n', "  // transferred to the spender's account\n", '  // ------------------------------------------------------------------------\n', '  function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '    return allowed[tokenOwner][spender];\n', '  }\n', '  \n', '  \n', '  \n', '}']