['/*______________________________________\n', '_____***________________________***_____\n', '____*******__________________*******____\n', '_____********______________********_____\n', '______**** ****___________******________\n', '________********________*****___________\n', '__________********_____***_____________\n', '___________**** ****____________________\n', '_____________**** ****__________________\n', '_______________*********________________\n', '_________________*********______________\n', '__________________**********____________\n', '_____________________********___________\n', '____________****_______********_________\n', '__________******________**** ****_______\n', '_______*******____________**** ***______\n', '____********________________********____\n', '____******____________________******____\n', '________________________________________\n', '______________________________________*/\n', '\n', '// 1. our product provides file lending service to customers who need storage which uses to store\n', '//    data files, host directories or others that need to consume data in internet\n', '// 2. this token meaning DXF token will be used for paying service fee, set different level which use for\n', "//    indicating privileges's holders.\n", '// 3. total supply will be fixed at 10,000 token\n', '// 4. Buring mechanism will be active after deploying and burning rate will be decreased day by day \n', '//    (target burn 60% total token)\n', '//    By following burning rate:\n', '//       - day 1: 8%\n', '//       - day 2: 4%\n', '//       - day 3: 2%\n', '//       - from day 4: 0%\n', '// 5. top 5 holders in day 1 will be set a entry to black diamond level when our service launch\n', '//    top next 5 holders in day 1 will be  set a entry to gold level when our service launch.\n', '//    To be clear that our platform will seperate 6 levels including: golden diamond, black diamond,\n', '//    titanium, gold, silver and non-level\n', '// 6. revenue share base on token holders\n', '// 7. there has been no any sales. At this time, our side will not run any marketing, \n', '//    100% generated token will be provided to liquidity and we trust in the community to see it through \n', '// 8. if you have questions find someone who can read\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '//@from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    \n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function ceil(uint256 m, uint256 n) internal pure returns (uint256) {\n', '    uint256 a = add(m, n);\n', '    uint256 b = sub(a, 1);\n', '    return mul(div(b, n), n);\n', '  }\n', '}\n', '\n', '//@from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol\n', 'interface IERC20 {\n', '  function totalSupply() external view returns (uint256);\n', '  function balanceOf(address who) external view returns (uint256);\n', '  function allowance(address owner, address target) external view returns (uint256);\n', '  function transfer(address to, uint256 value) external returns (bool);\n', '  function approve(address target, uint256 value) external returns (bool);\n', '  function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed target, uint256 value);\n', '}\n', '\n', 'contract ERC20 is IERC20 {\n', '\n', '  uint8 public decimal;\n', '  string public name;\n', '  string public symbol;\n', '\n', '  constructor(string memory _name, string memory _symbol, uint8 _decimals) public {\n', '    decimal = _decimals;\n', '    name = _name;\n', '    symbol = _symbol; \n', '  }\n', '\n', '  function name() public view returns(string memory) {\n', '    return name;\n', '  }\n', '\n', '  function symbol() public view returns(string memory) {\n', '    return symbol;\n', '  }\n', '\n', '  function decimals() public view returns(uint8) {\n', '    return decimal;\n', '  }\n', '}\n', '\n', 'contract DragonXfile is ERC20("DragonXfile" , "DFX", 18){\n', '  using SafeMath for uint256;\n', '  \n', '  mapping (address => uint256) public _dxfbalance;\n', '  mapping (address => mapping (address => uint256)) public _allowed;\n', '  \n', '  uint256 _totalSupply = 10000 * 10 ** 18; //10k token\n', '  uint8 constant private burnrated0 = 8;\n', '  uint8 constant private burnrated1 = 4;\n', '  uint8 constant private burnrated2 = 2;\n', '  uint8 constant private burnrated3 = 0;\n', '  \n', '  uint256 constant private milestoned1 = 1605186000; //Wed, 12 Nov 2020 13:00:00 GMT d1\n', '  uint256 constant private milestoned2 = 1605272400; //Wed, 13 Nov 2020 13:00:00 GMT d2\n', '  uint256 constant private milestoned3 = 1605358800; //Wed, 14 Nov 2020 13:00:00 GMT d3\n', '\n', '  constructor() public {\n', '    _mint(msg.sender, _totalSupply);\n', '  }\n', '\n', '  function totalSupply() public view returns (uint256) {\n', '    return _totalSupply;\n', '  }\n', '\n', '  function balanceOf(address owner) public view returns (uint256) {\n', '    return _dxfbalance[owner];\n', '  }\n', '  function caculateBurnRate() public view returns (uint8){\n', '    if (now >= milestoned3) return burnrated3;\n', '    if (now >= milestoned2) return burnrated2;\n', '    if (now >= milestoned1) return burnrated1;\n', '    return burnrated0;\n', '  }\n', '  function transfer(address to, uint256 value) public returns (bool) {\n', '    require(value <= _dxfbalance[msg.sender]);\n', '    require(to != address(0));\n', '    uint8 burnrate = caculateBurnRate();\n', '    uint256 brn = value.mul(burnrate).div(100);\n', '    \n', '    uint256 rvalue = value.sub(brn);\n', '    _dxfbalance[msg.sender] = _dxfbalance[msg.sender].sub(value);\n', '    _dxfbalance[to] = _dxfbalance[to].add(rvalue);\n', '    _totalSupply = _totalSupply.sub(brn);\n', '\n', '    emit Transfer(msg.sender, to, rvalue);\n', '    emit Transfer(msg.sender, address(0), brn);\n', '\n', '    return true;\n', '  }\n', ' \n', '  function allowance(address owner, address target) public view returns (uint256) {\n', '    return _allowed[owner][target];\n', '  }\n', '\n', '  function approve(address target, uint256 value) public returns (bool) {\n', '    require(target != address(0));\n', '    _allowed[msg.sender][target] = value;\n', '    emit Approval(msg.sender, target, value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '    require(value <= _dxfbalance[from]);\n', '    require(value <= _allowed[from][msg.sender]);\n', '    require(to != address(0));\n', '\n', '    _dxfbalance[from] = _dxfbalance[from].sub(value);\n', '    uint8 burnrate = caculateBurnRate();\n', '    uint256 brn = value.mul(burnrate).div(100);\n', '    \n', '    uint256 rvalue = value.sub(brn);\n', '\n', '    _dxfbalance[to] = _dxfbalance[to].add(rvalue);\n', '    _totalSupply = _totalSupply.sub(brn);\n', '    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '\n', '    emit Transfer(from, to, rvalue);\n', '    emit Transfer(from, address(0), brn);\n', '\n', '    return true;\n', '  }\n', '  \n', '  function increaseAllowance(address target, uint256 addedValue) public returns (bool) {\n', '    require(target != address(0));\n', '    _allowed[msg.sender][target] = (_allowed[msg.sender][target].add(addedValue));\n', '    emit Approval(msg.sender, target, _allowed[msg.sender][target]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseAllowance(address target, uint256 val) public returns (bool) {\n', '    require(target != address(0));\n', '    _allowed[msg.sender][target] = (_allowed[msg.sender][target].sub(val));\n', '    emit Approval(msg.sender, target, _allowed[msg.sender][target]);\n', '    return true;\n', '  }\n', '\n', '  function _mint(address account, uint256 amount) internal {\n', '    require(amount != 0);\n', '    _dxfbalance[account] = _dxfbalance[account].add(amount);\n', '    emit Transfer(address(0), account, amount);\n', '  }\n', '\n', '  function burn(uint256 amount) external {\n', '    setBurn(msg.sender, amount);\n', '  }\n', '\n', '  function setBurn(address account, uint256 amount) internal {\n', '    require(amount != 0);\n', '    require(amount <= _dxfbalance[account]);\n', '    _totalSupply = _totalSupply.sub(amount);\n', '    _dxfbalance[account] = _dxfbalance[account].sub(amount);\n', '    emit Transfer(account, address(0), amount);\n', '  }\n', '}']