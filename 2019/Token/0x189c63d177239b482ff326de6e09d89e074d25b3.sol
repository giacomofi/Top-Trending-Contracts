['/*\n', 'The United Crypto System is an unique Blockchain-based system that combines three key elements:\n', 'UCS Gambling (Cryptocurrency Casino)\n', 'UCS Dapps (Game Applications)\n', 'UCS Bet (Sports Betting)\n', 'The platform will provide access to the three most popular destinations in the niche, using a single cryptocurrency and wallet.\n', 'The United Crypto System is an unique system, the first and only in the world, which will bring dividends to each investor (100% of net profit is subject to distribution throughout the project’s lifetime) and an additional percentage (from 3% to 150%) for each month ownership investment token. \n', '\n', 'The sooner you join our United Crypto System Token Sale, the more you will earn. \n', 'For example, if you invest in pre-ICO or ICO, then in September after IEO you will be able to get more than 10000% of profit.\n', '\n', 'IEO (Initial Exchange Offering) of the United Crypto System tokens is scheduled for August-September 2019. \n', '\n', 'Our website https://casinosinvest.com \n', 'Our telegram channel https://t.me//Unitedsystem \n', 'Our telegram chat https://t.me//Casinosystem\n', '\n', '*/\n', '\n', 'pragma solidity ^0.5.0;\n', 'interface IERC20 {\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address who) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'contract ERC20 is IERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) private _balances;\n', '\n', '    mapping (address => mapping (address => uint256)) private _allowed;\n', '\n', '    uint256 private _totalSupply;\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address owner) public view returns (uint256) {\n', '        return _balances[owner];\n', '    }\n', '\n', '    function allowance(address owner, address spender) public view returns (uint256) {\n', '        return _allowed[owner][spender];\n', '    }\n', '\n', '    function transfer(address to, uint256 value) public returns (bool) {\n', '        require(block.timestamp > 1564617600, "Tokens transfers are prohibited until August 1, 2019");\n', '\n', '        _transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address spender, uint256 value) public returns (bool) {\n', '        require(spender != address(0));\n', '\n', '        _allowed[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '        _transfer(from, to, value);\n', '        emit Approval(from, msg.sender, _allowed[from][msg.sender]);\n', '        return true;\n', '    }\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '        require(spender != address(0));\n', '\n', '        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);\n', '        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '        require(spender != address(0));\n', '\n', '        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);\n', '        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '    function _transfer(address from, address to, uint256 value) internal {\n', '        require(to != address(0));\n', '\n', '        _balances[from] = _balances[from].sub(value);\n', '        _balances[to] = _balances[to].add(value);\n', '        emit Transfer(from, to, value);\n', '    }\n', '\n', '    function _mint(address account, uint256 value) internal {\n', '        require(account != address(0));\n', '\n', '        _totalSupply = _totalSupply.add(value);\n', '        _balances[account] = _balances[account].add(value);\n', '        emit Transfer(address(0), account, value);\n', '    }\n', '\n', '    function _burn(address account, uint256 value) internal {\n', '        require(account != address(0));\n', '\n', '        _totalSupply = _totalSupply.sub(value);\n', '        _balances[account] = _balances[account].sub(value);\n', '        emit Transfer(account, address(0), value);\n', '    }\n', '\n', '    function _burnFrom(address account, uint256 value) internal {\n', '        _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);\n', '        _burn(account, value);\n', '        emit Approval(account, msg.sender, _allowed[account][msg.sender]);\n', '    }\n', '}\n', '\n', 'library Roles {\n', '    struct Role {\n', '        mapping (address => bool) bearer;\n', '    }\n', '\n', '    function add(Role storage role, address account) internal {\n', '        require(account != address(0));\n', '        require(!has(role, account));\n', '\n', '        role.bearer[account] = true;\n', '    }\n', '\n', '    function remove(Role storage role, address account) internal {\n', '        require(account != address(0));\n', '        require(has(role, account));\n', '\n', '        role.bearer[account] = false;\n', '    }\n', '\n', '    function has(Role storage role, address account) internal view returns (bool) {\n', '        require(account != address(0));\n', '        return role.bearer[account];\n', '    }\n', '}\n', '\n', 'contract MinterRole {\n', '    using Roles for Roles.Role;\n', '\n', '    event MinterAdded(address indexed account);\n', '    event MinterRemoved(address indexed account);\n', '\n', '    Roles.Role private _minters;\n', '\n', '    constructor () internal {\n', '        _addMinter(msg.sender);\n', '    }\n', '\n', '    modifier onlyMinter() {\n', '        require(isMinter(msg.sender));\n', '        _;\n', '    }\n', '\n', '    function isMinter(address account) public view returns (bool) {\n', '        return _minters.has(account);\n', '    }\n', '\n', '    function addMinter(address account) public onlyMinter {\n', '        _addMinter(account);\n', '    }\n', '\n', '    function renounceMinter() public {\n', '        _removeMinter(msg.sender);\n', '    }\n', '\n', '    function _addMinter(address account) internal {\n', '        _minters.add(account);\n', '        emit MinterAdded(account);\n', '    }\n', '\n', '    function _removeMinter(address account) internal {\n', '        _minters.remove(account);\n', '        emit MinterRemoved(account);\n', '    }\n', '}\n', '\n', 'contract ERC20Mintable is ERC20, MinterRole {\n', '    function mint(address to, uint256 value) public onlyMinter returns (bool) {\n', '        _mint(to, value);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract UCS is ERC20Mintable {\n', '  string public constant name = "United Crypto System";\n', '  string public constant symbol = "UCS";\n', '  uint8 public constant decimals = 18;\n', '}']