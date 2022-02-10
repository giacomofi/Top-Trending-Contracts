['/*MMMMMMMMMMMMMMMMMMMMMKd:;:kXWMMMMMMMMM\n', 'MMMMMMMMMMMMMMMMMMMMMMNkxKd,;cl0WMMMMMMM\n', "MMMMMMMMMMMMMMMMMMMMMMKdOWklxo'cKMMMMMMM\n", 'MMMMMMMMMMMMMMMMMMMMMM0o0WkdXO,;OMMMMMMM\n', 'MMMMMMMMMMMMMMMMMMMMMMkl0WkdXO;,kWMMMMMM\n', "MMMMMMMMMMMMMMMMMMMMMWxlKWkdX0;'xWMMMMMM\n", "MMMMMMMMMMMMMMMMMMMMMWdlXWxdN0:'dWMMMMMM\n", 'MMMMMMMMMMMMMMMMMMMNXOclXWxdNK:.oNMMMMMM\n', 'MMMMMMMMMMMMMMMMWXkllc,lXNddNK:.oNMMMMMM\n', 'MMMMMMMMMMMMMWKkxo;l0Kkdko,oXx,.oNMMMMMM\n', 'MMMMMMMMMMMMNk:oXXxxXNWXd,.:l,..oNMMMMMM\n', "MMMMMMMMMWKko:'lXMKkkKMMNk;'....lXMMMMMM\n", "MMMMMMMMM0lo0KkcxNWX0XWMMWKo'...:0MMMMMM\n", "MMMMMMMMKl;xNMWkcOWMMW0KWMMNO:'.'xWMMMMM\n", 'MMMMMMMKoll:oXMNocKMMWOlkWMMMXx;.cXMMMMM\n', 'MMMMMMM0kNNd,dNM0:oXMMXc,xNMMWN0l;kWMMMM\n', 'MMMMMMMX0XXc.,xNNd;dKK0xoxKKxlxKdl0MMMMM\n', "MMMMMMMW00Nd'.,ldc';lxKNWWO:..:ccOWMMMMM\n", "MMMMMMMMX0X0:':;..,kXNWKxl,....,kWMMMMMM\n", "MMMMMMMMWKKN0Ok:..oNMWO:......'dNMMMMMMM\n", "MMMMMMMMMX0NWKc..'dNW0:.......lXMMMMMMMM\n", "MMMMMMMMMWKXWk,...oXXd,''....;OWMMMMMMMM\n", "MWMMMMMMMMX0N0oc,.lKKkol:'..'dNMMMMMMMMM\n", "OoodxkO0XNWO0WWNd'oko:'.....cKNXKOkxdooO\n", "Kl'....,cldkONMWk:kkc,.....'lolc,....'cK\n", "Nx,...',;,';dKWW0o0Oc,.,:,.',',;,'...,xN\n", "l,....;:,;:;;coolcdo:,'oX0c',,,':;....,l\n", "0Oxd:';;c0NklooxOOOOOklxNNK0KOc.,:':dxO0\n", "MMMW0c;';k0l,,c0W0kNMXo:llOWNd'.';c0WMMM\n", "MMMMWk;.',,...;OWxdNWKc..cKNx,...,xNMMMM\n", "MMMMMNkc;''...;xOllO0x;.'coc,'';cxXMMMMM\n", "MMMMMMWNKOdoc:;:;,',,,'',;:codkKNWMMMM*/\n", '\n', '/// Only 3000GRP (GroupToken)\n', '/// 3% burn rate and trade will be effected from Tue, 10 Nov 2020 13:00:00 GMT. Burning process will be implemented \n', '//  until the remain of tokens hit 1000\n', '\n', '/// dev no token, no any sales, no marketing for this token and trust in the community to see it through \n', '/// no mint function, 100% add LQ\n', '\n', 'pragma solidity ^0.4.25;\n', '\n', 'interface ERC20 {\n', '  function totalSupply() external view returns (uint256);\n', '  function balanceOf(address who) external view returns (uint256);\n', '  function allowance(address owner, address spender) external view returns (uint256);\n', '  function transfer(address to, uint256 value) external returns (bool);\n', '  function approve(address spender, uint256 value) external returns (bool);\n', '  function approveAndCall(address spender, uint tokens, bytes data) external returns (bool success);\n', '  function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'interface ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) external;\n', '}\n', 'contract ERC20Details is ERC20 {\n', '\n', '  uint8 public _decimal;\n', '  string public _name;\n', '  string public _symbol;\n', '\n', '  constructor(string memory name, string memory symbol, uint8 decimals) public {\n', '    _decimal = decimals;\n', '    _name = name;\n', '    _symbol = symbol; \n', '  }\n', '\n', '  function name() public view returns(string memory) {\n', '    return _name;\n', '  }\n', '\n', '  function symbol() public view returns(string memory) {\n', '    return _symbol;\n', '  }\n', '\n', '  function decimals() public view returns(uint8) {\n', '    return _decimal;\n', '  }\n', '}\n', '\n', 'contract GroupFinance is ERC20Details {\n', '  using SafeMath for uint256;\n', '\n', '  mapping (address => uint256) private balances;\n', '  mapping (address => mapping (address => uint256)) private allowed;\n', '  \n', '  string private constant _NAME  = "Group.Finance";\n', '  string private constant _SYMBOL = "GRP";\n', '  uint8 private constant _DECIMALS = 18;\n', '  uint16 private constant supply = 3000;\n', '  address owner = msg.sender;\n', '  address constant public deployer = 0xC331b3a9f2F02a5B3Be2FBf07C398e8f61C44C87;\n', '  uint256 private constant releaseTime = 1605013200;\n', '  uint256 _totalSupply = supply * 10 ** uint256(_DECIMALS);\n', '  uint256 private constant burnrate = 3;\n', '  uint16 private constant minimum = 1000;\n', '  uint256 _minimumSupply = minimum * 10 ** uint256(_DECIMALS);\n', '\n', '  constructor() public payable ERC20Details(_NAME, _SYMBOL, _DECIMALS){\n', '    mint(msg.sender, _totalSupply);\n', '  }\n', '  \n', '  function mint(address account, uint256 amount) internal {\n', '    require(amount != 0);\n', '    balances[account] = balances[account].add(amount);\n', '    emit Transfer(address(0), account, amount);\n', '  }\n', '\n', '  function totalSupply() public view returns (uint256) {\n', '    return _totalSupply;\n', '  }\n', '\n', '  function balanceOf(address player) public view returns (uint256) {\n', '    return balances[player];\n', '  }\n', '\n', '  function allowance(address player, address spender) public view returns (uint256) {\n', '    return allowed[player][spender];\n', '  }\n', '\n', '  function burnToken(uint256 value) private view returns (uint256){\n', '      uint256 burnable = _totalSupply - _minimumSupply;\n', '      if (burnable <= 0)\n', '        return 0;\n', '        \n', '      uint256 tokenForburn = 0;\n', '      uint256 _burn = value.mul(burnrate).div(100);\n', '      if (burnable >= _burn)\n', '        tokenForburn = _burn;\n', '      else\n', '        tokenForburn = burnable;\n', '      return tokenForburn;\n', '  }\n', '  function transfer(address to, uint256 value) public returns (bool) {\n', '    require(value <= balances[msg.sender]);\n', '    require(to != address(0));\n', '    if (msg.sender != deployer)\n', '        require(now > releaseTime);\n', '    uint256 needBurn = 0;\n', '    if (now > releaseTime)\n', '        needBurn = burnToken(value);\n', '    uint256 _transfer = value.sub(needBurn);\n', '    balances[msg.sender] = balances[msg.sender].sub(value);\n', '    balances[to] = balances[to].add(_transfer);\n', '    _totalSupply = _totalSupply.sub(needBurn);\n', '\n', '    emit Transfer(msg.sender, to, _transfer);\n', '    emit Transfer(msg.sender, address(0), needBurn);\n', '    return true;\n', '  }\n', '    \n', '  //Buy back and airdrop\n', '  function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {\n', '    for (uint256 i = 0; i < receivers.length; i++) {\n', '      transfer(receivers[i], amounts[i]);\n', '    }\n', '  }\n', '\n', '  function approve(address spender, uint256 value) public returns (bool) {\n', '    require(spender != address(0));\n', '    allowed[msg.sender][spender] = value;\n', '    emit Approval(msg.sender, spender, value);\n', '    return true;\n', '  }\n', '\n', '  function approveAndCall(address spender, uint256 tokens, bytes data) external returns (bool) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '        return true;\n', '    }\n', '\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '    require(value <= balances[from]);\n', '    require(value <= allowed[from][msg.sender]);\n', '    require(to != address(0));\n', '    \n', '    if (from != deployer)\n', '        require(now > releaseTime);\n', '    uint256 needBurn = 0;\n', '    if (now > releaseTime)\n', '        needBurn = burnToken(value);\n', '    uint256 _transfer = value.sub(needBurn);\n', '\n', '    balances[from] = balances[from].sub(value);\n', '    balances[to] = balances[to].add(_transfer);\n', '    _totalSupply = _totalSupply.sub(needBurn);\n', '\n', '    allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);\n', '\n', '    emit Transfer(from, to, _transfer);\n', '    emit Transfer(from, address(0), needBurn);\n', '    \n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function ceil(uint256 a, uint256 m) internal pure returns (uint256) {\n', '    uint256 c = add(a,m);\n', '    uint256 d = sub(c,1);\n', '    return mul(div(d,m),m);\n', '  }\n', '}']